//
//  TabBare.swift
//  ClipStack
//
//  Created by Chuck on 05/04/2022.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    static let shared: TabBarController = {
        let instance = TabBarController()
        return instance
    }()
    
    var tabBarHeight: CGFloat? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setUpNavigationController()
        tabBarHeight = tabBar.frame.height
       
        self.tabBar.isTranslucent = false
        tabBar.tintColor = MyColors.primary
//        tabBar.unselectedItemTintColor = .systemGray3
//        tabBar.tintColor = .systemGray
        
        // Home View Controller Start Up
//        let copyItemVC = CopyItemsViewController()
        let copyItemVC = CopyItemsViewController()
        MainCoordinator.setInstance(root: copyItemVC)
        
        let homeTabIcon = UITabBarItem(title: "ClipStack", image: UIImage(systemName: "house"), tag: 0)
        
        guard let mainNavController = MainCoordinator.shared.navigationController else{
            return
        }
        mainNavController.tabBarItem = homeTabIcon
        
        
        // Add Copy Item Controller Start up
        let addedCopyVC = AddedCopyItemsViewController()
        AddedCoordinator.setInstance(root: addedCopyVC)
        
        let addedIcon = UITabBarItem(title: "My Clips", image: UIImage(systemName: "square.stack.fill"), tag: 1)
        
        guard let addedNavController = AddedCoordinator.shared.navigationController else{
            return
        }
        addedNavController.tabBarItem = addedIcon
        
        
        // Settings View Controller Start Up
        let settingsVC = SettingsViewController()
        SettingsCoordinator.setInstance(root: settingsVC)
        
        let menuTabIcon = UITabBarItem(title: "Settings", image: UIImage(systemName:"gear"), tag: 2)
        
        guard let settingNavController = SettingsCoordinator.shared.navigationController else{
            return
        }
        
        settingNavController.tabBarItem = menuTabIcon
        
        // Adding all Tab View Controllers
        self.viewControllers = [mainNavController, addedNavController, settingNavController].map({ (viewController) in
            viewController
        })
        
    }
    
    @objc func openMenu(){
        print("Menu from TabBar")
    }
    
    func setUpNavigationController(){
         let rightBarButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(openMenu))

         navigationItem.rightBarButtonItem = rightBarButton
//         navigationController?.navigationBar.tintColor = .black
//         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.children.first?.navigationItem.title as Any)
        
        return true
    }
}
