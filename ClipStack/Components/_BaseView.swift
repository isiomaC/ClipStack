//
//  BaseView.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit

protocol BaseViewProtocol {
    func hide()
    func initialize()
    func addConstraints()
}

class BaseView: UIView, BaseViewProtocol {
    
    // Define View Objects
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        addConstraints()
    }
    
    func initialize(){
        
    }
    
    func addConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Add View Constraints
    }
    
    func hide() {
        self.removeFromSuperview()
    }
    
    func hideAlpha(){
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
