//
//  MainCoordinator.swift
//  Common
//
//  Created by Chuck on 23/07/2021.
//

import Foundation
import UIKit

typealias CoordinatingDelegate = UIViewController & Coordinating

class MainCoordinator: Coordinator {
    var children: [Coordinating]?
    
    var navigationController: UINavigationController?
    
    private static var instance: MainCoordinator?
    
    var currentChild: CoordinatingDelegate?
    
    static let shared: MainCoordinator = {
        if MainCoordinator.instance == nil {
            MainCoordinator.instance = MainCoordinator(navigationController: setInstance(HomeViewController()))
        }
        return MainCoordinator.instance!
    }()
    
    static func setInstance(root: UIViewController) {
        MainCoordinator.instance = MainCoordinator(navigationController: setInstance(root))
    }
    
    static func setInstance(_ navigationRoot: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: navigationRoot)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toggleNavBarDisplay(hidden: Bool){
        navigationController?.navigationBar.isHidden = hidden
    }
    
    // MARK: Start Functions
    func start() {
       
    }
    
    private func setWindowRootVC() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let navVc = MainCoordinator.shared.navigationController else {
            return
        }
        appDelegate?.setRootViewController(navVc, animated: true)
    }
    
    // MARK: Presentation Functions
    func presentVC(_ currentVC: CoordinatingDelegate, _ nextVC: CoordinatingDelegate) {
        children?.append(currentVC)
        currentChild = currentVC
        currentVC.present(nextVC, animated: true, completion: nil)
    }
    
    // MARK: Push and Pop View Controllers
    func pushVC(_ viewController: CoordinatingDelegate) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popVC(_ viewController: CoordinatingDelegate) {
        navigationController?.popViewController(animated: true)
    }
    
    func goToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
