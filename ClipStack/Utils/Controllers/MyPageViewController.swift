//
//  MyPageViewController.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit

class MyPageViewController : UIPageViewController{
    
    lazy var pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: Dimensions.screenSize.width, height: 20))
    
    lazy var skipButton : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Skip", for: .normal)
        btn.backgroundColor = .systemGray6
        return btn
    }()
//    ViewGenerator.getButton(ButtonOptions(title: "Skip", color: .systemPurple, image: nil, smiley: nil))
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    func setUpViews(){
        
        pageControl.currentPageIndicatorTintColor = MyColors.primary
        pageControl.pageIndicatorTintColor = .systemGray6
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        setPageControlConstraints()
    }
    
    func setPageControlConstraints(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
}
