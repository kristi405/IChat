//
//  ListViewController.swift
//  IChat
//
//  Created by kris on 18/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
        
    var waitingChatListener: ListenerRegistration?
    var activeChatListener: ListenerRegistration?
    
    var activeChats = [Mchat]()
    var waitingChats = [Mchat]()
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        
        func selectHeder() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chat"
            case .activeChats:
                return "Active chat"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSourse: UICollectionViewDiffableDataSource<Section, Mchat>!
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatListener?.remove()
        activeChatListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionVC()
        setupSerchController()
        createDataSourse()
        reloudData()
        
        waitingChatListener = ListenerService.shered.waitingChatsObserv(chats: waitingChats, complition: { (result) in
            switch result {
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatReqestVC = ChatReqestViewController(chat: chats.last!)
                    chatReqestVC.delegate = self
                    self.present(chatReqestVC, animated: true, completion: nil)
                }
                self.waitingChats = chats
                self.reloudData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        })
        
        activeChatListener = ListenerService.shered.activeChatsObserv(chats: activeChats, complition: { (result) in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloudData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        })
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
    
    private func setupCollectionVC() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setupCompositionLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .whiteColor()
        view.addSubview(collectionView)
        collectionView.register(SectionHeder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeder.reuseID)
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseID )
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseID)
        
        collectionView.delegate = self
    }
    
    private func reloudData() {
        
        var snapchot = NSDiffableDataSourceSnapshot<Section, Mchat>()
        snapchot.appendSections([.waitingChats, .activeChats])
        snapchot.appendItems(waitingChats, toSection: .waitingChats)
        snapchot.appendItems(activeChats, toSection: .activeChats)
        dataSourse?.apply(snapchot, animatingDifferences: true)
    }
}


// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chats = self.dataSourse.itemIdentifier(for: indexPath) else {return}
        guard let section = Section(rawValue: indexPath.section) else {return}
        
        switch section {
        case .waitingChats:
            let chatReqestVC = ChatReqestViewController(chat: chats)
            chatReqestVC.delegate = self
            self.present(chatReqestVC, animated: true, completion: nil)
        case .activeChats:
            self.present(MessageViewController(user: currentUser, chat: chats), animated: true, completion: nil)
        }
    }
}


extension ListViewController: NavigationChatProtocol {

    func removeWaitingChat(chat: Mchat) {
        UserService.shered.deleteWaitingChats(chat: chat) { (result) in
            switch result {
            case .success:
                self.showAlert(title: "Успешно", massage: "Чат с \(chat.friendUsername) был удален")
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        }
    }

    func changeToActive(chat: Mchat) {
        UserService.shered.changeToActive(chat: chat) { (result) in
            switch result {    
            case .success:
                self.showAlert(title: "Успешно", massage: "Чат с \(chat.friendUsername) был перемещен в активные чаты")
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: - DataSourse
extension ListViewController {
    
    private func createDataSourse() {
        
        dataSourse = UICollectionViewDiffableDataSource<Section, Mchat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {fatalError("Unnown section")}
            
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSourse?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let sectionHeder = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                withReuseIdentifier: SectionHeder.reuseID,
                                                                                for: indexPath) as? SectionHeder
            else {fatalError("Can not find section heder")}
            
            guard let section = Section(rawValue: indexPath.section) else {fatalError()}
            sectionHeder.configure(texet: section.selectHeder(),
                                   font: .laoSangamMN20(),
                                   textColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            return sectionHeder
        }
    }
}

// MARK: - Layout
extension ListViewController {
    
    private func setupCompositionLayout() -> UICollectionViewLayout {
        
        let compositionLayout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {fatalError("Unnown section")}
            
            switch section {
                
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWeitingChats()
            }
        }
        return compositionLayout
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 15
        
        let sectionHeder = createSectionHeder()
        section.boundarySupplementaryItems = [sectionHeder]
        
        return section
    }
    
    private func createWeitingChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
                                               heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
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
