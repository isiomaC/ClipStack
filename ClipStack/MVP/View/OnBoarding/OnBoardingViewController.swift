//
//  OnBoardingViewController.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit


class OnBoardingViewController: MyPageViewController{
    
    var pages = [UIViewController]()
    
    let initialPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        let first = FirstBoardViewController()
        let second = SecondBoardViewController()
        
        pages = [first, second]
        
        skipButton.addTarget(self, action: #selector(skipOnBoarding), for: .touchUpInside)
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPageIndex
       
        view.backgroundColor = .white
        
        setViewControllers([pages[initialPageIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func skipOnBoarding(){
        UserDefaults.standard.set(false, forKey: UserDefaultkeys.isFirstLaunch)
        
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        appDelegate.window?.rootViewController = TabBarController()

        appDelegate.window?.makeKeyAndVisible()
        
        UIView.transition(with: appDelegate.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
}


extension OnBoardingViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return pages.last
            } else {
                // go to previous page in array
                return pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
              // go to next page in array
              return pages[viewControllerIndex + 1]
            } else {
              // wrap to first page in array
              return pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}
