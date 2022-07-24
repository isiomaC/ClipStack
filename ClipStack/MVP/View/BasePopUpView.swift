//
//  BasePopUpView.swift
//  ClipStack
//
//  Created by Chuck on 16/06/2022.
//


import Foundation
import UIKit

class BasePopUpView : UIView{
    
    struct Constants{
        static let backgroundAlphaTo: CGFloat = 0.6
        static let disabledAlpha: CGFloat = 0.2
        static let enabledAplha: CGFloat = 1
        static let invisibleAlpha: CGFloat = 0
    }
    
    lazy var alertView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray3
        return view
    }()
    
    lazy var cancel = ViewGenerator.circularButton(image: UIImage(systemName: "xmark.circle.fill"), smiley: nil)
    
    lazy var avatar = ViewGenerator.styledImageView(withProps: ImageViewOptions(image: nil, size: (100, 100)))
    
    private var viewControllerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = .white
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize(){
        avatar.isUserInteractionEnabled = true
        
        cancel.tintColor = .systemGray
        addSubview(alertView)
        addViews()
        triggerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatar.makeRounded()
        roundCorners(corners: [.allCorners], radius: 20)
    }
    
    func addViews(){
        alertView.addSubview(avatar)
        alertView.addSubview(cancel)
    }
    
    func triggerAvatarConstraints(){
        avatar.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        avatar.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: Dimensions.screenSize.height * 0.15).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: Dimensions.screenSize.height * 0.15).isActive = true
    }
    
    func triggerConstraints(){
       
        triggerAvatarConstraints()
        
        cancel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        cancel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10).isActive = true
        
    }
    
    func setUpData(){
        
    }
    
    func setEnabled(button: UIButton){
        button.alpha = Constants.enabledAplha
        button.isEnabled = true
    }
    
    func setDisabled(button: UIButton){
        button.alpha = Constants.disabledAlpha
        button.isEnabled = false
    }
    
    func showAlert(_ viewController: UIViewController){
        
        guard let targetView = viewController.view else{
            return
        }
        
        viewControllerView = targetView
        
        frame = CGRect(x: 0, y: 0, width: targetView.bounds.width, height: targetView.bounds.height)//targetView.bounds
        targetView.addSubview(self)
        targetView.addSubview(alertView)
        
        setAlertViewFrame(nil, targetView)
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = Constants.backgroundAlphaTo
        } completion: { (done) in
            if done{
                UIView.animate(withDuration: 0.25) {
                    self.alertView.center =  CGPoint(x: targetView.center.x, y: targetView.center.y - viewController.topBarHeight)
                }
            }
        }
    }
    
    func setAlertViewFrame(_ frame: CGRect?, _ parentView: UIView){
        alertView.frame = frame != nil
            ? frame!
            : CGRect(x: 30,
                     y: -parentView.frame.height * 0.7,
                     width: parentView.frame.size.width - 60,
                     height: parentView.frame.height * 0.7)
    }
    
    @objc func dismissAlert(){
        guard let targetView = viewControllerView else{
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            
            //Change animated to fade in fade out
            self.alertView.frame = CGRect(x: 30, y: targetView.frame.size.height, width: targetView.frame.size.width - 60, height: targetView.frame.height * 0.7)
            
        } completion: { (done) in
            if done{
                UIView.animate(withDuration: 0.25) {
                    self.alpha = Constants.invisibleAlpha
                } completion: { (done) in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.removeFromSuperview()
                    }
                }
            }
        }
    }
}
