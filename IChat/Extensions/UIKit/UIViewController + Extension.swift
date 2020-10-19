//
//  UIViewController + Extension.swift
//  IChat
//
//  Created by kris on 23/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func configure<T: SelfConfigureCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {fatalError("don`t create \(cellType)")}
        cell.configure(with: value)
        return cell
    }
}

extension UIViewController {
    
    func showAlert(title: String, massage: String, complation: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            complation()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
