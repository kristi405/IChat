//
//  PeopleViewController.swift
//  IChat
//
//  Created by kris on 18/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    
    var users = [MUser]()
    private var usersListener: ListenerRegistration?
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(sectionCount: Int) -> String {
            switch self {
            case .users:
                return "\(sectionCount) people nearby"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, MUser>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSerchController()
        setupCollectionVC()
        createDataSourse()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutItem))
        
        usersListener = ListenerService.shered.usersObserv(users: users, complition: { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.reloudData(with: nil)
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        })
    }
    
    let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        usersListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func signOutItem() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (_) in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = ViewController()
            } catch {
                print(error.localizedDescription)
            }
        }
        ac.addAction(cancelAction)
        ac.addAction(signOutAction)
        present(ac, animated: true, completion: nil)
    }
    
    private func setupCollectionVC() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setupCompositionLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .whiteColor()
        view.addSubview(collectionView)
        collectionView.register(SectionHeder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeder.reuseID)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseID)
        
        collectionView.delegate = self
    }
    
    private func setupSerchController() {
        
        navigationController?.navigationBar.barTintColor = .whiteColor()
        navigationController?.navigationBar.shadowImage = UIImage()
        let serchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = serchController
        navigationItem.hidesSearchBarWhenScrolling = false
        serchController.hidesNavigationBarDuringPresentation = false
        serchController.obscuresBackgroundDuringPresentation = false
        
        serchController.searchBar.delegate = self
    }
    
    private func reloudData(with serchText: String?) {
        
        let filtred = users.filter { (user) -> Bool in
            user.containts(filter: serchText)
        }
        
        var snapchot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapchot.appendSections([.users])
        snapchot.appendItems(filtred, toSection: .users)
        dataSourse?.apply(snapchot, animatingDifferences: true)
    }
}


// MARK: - UICollectionViewDelegate
extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let user = self.dataSourse.itemIdentifier(for: indexPath) else {return}
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloudData(with: searchText)
    }
}

// MARK: - DataSourse
extension PeopleViewController {
    
    private func createDataSourse() {
        
        dataSourse = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {fatalError("Unnown section")}
            
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
        })
        
        dataSourse?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let sectionHeder = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: SectionHeder.reuseID,
                                                                                for: indexPath) as? SectionHeder
            else {fatalError("Can not find section heder")}
            
            guard let section = Section(rawValue: indexPath.section) else {fatalError()}
            let item = self.dataSourse.snapshot().itemIdentifiers(inSection: .users)
            sectionHeder.configure(texet: section.description(sectionCount: item.count),
                                   font: .systemFont(ofSize: 30, weight: .light),
                                   textColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))
            return sectionHeder
        }
    }
}

// MARK: - Layout
extension PeopleViewController {
    
    private func setupCompositionLayout() -> UICollectionViewLayout {
        
        let compositionLayout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {fatalError("Unnown section")}
            
            switch section {
            case .users:
                return self.createSection()
            }
        }
        return compositionLayout
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 7, trailing: 15)
        
        let sectionHeder = createSectionHeder()
        section.boundarySupplementaryItems = [sectionHeder]
        
        return section
    }
    
    private func createSectionHeder() -> NSCollectionLayoutBoundarySupplementaryItem {
           
           let sectionHederSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                         heightDimension: .estimated(1))
           let sectionHeder = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHederSize,
                                                                          elementKind: UICollectionView.elementKindSectionHeader,
                                                                          alignment: .top)
           return sectionHeder
       }
}
