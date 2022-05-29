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
//        tabBar.barTintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.tintColor = .systemGray
        
        // Home View Controller Start Up
        let homeVC = HomeViewController()
        MainCoordinator.setInstance(root: homeVC)
        
        let homeTabIcon = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        guard let navFromCoordinator = MainCoordinator.shared.navigationController else{
            return
        }
        navFromCoordinator.tabBarItem = homeTabIcon
        
        // Settings View Controller Start Up
        let settingsVC = SettingsViewController()
        let menuTabIcon = UITabBarItem(title: "Settings", image: UIImage(systemName:"text.justifyright"), tag: 1)
        settingsVC.tabBarItem = menuTabIcon
        
        
        // Adding all Tab View Controllers
        self.viewControllers = [navFromCoordinator, settingsVC].map({ (viewController) in
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
