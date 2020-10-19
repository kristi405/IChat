//
//  MainTabBarVewController.swift
//  IChat
//
//  Created by kris on 18/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

class MainTabBarVewController: UITabBarController {
    
    private var currentUser: MUser
    
    init(currentUser: MUser = MUser(username: "hdfg", email: "ghfk", description: "ghfkg", avatarStringURL: "hgfk", sex: "hg", id: "ghk")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        
        viewControllers = [
            generatedNavigationViewController(rootViewController: peopleViewController, title: "People", image: peopleImage),
            generatedNavigationViewController(rootViewController: listViewController, title: "Conversetion", image: convImage)
        ]
    }
    
    private func generatedNavigationViewController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}


