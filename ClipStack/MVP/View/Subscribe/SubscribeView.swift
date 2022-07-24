//
//  SubscribeView.swift
//  ClipStack
//
//  Created by Chuck on 22/07/2022.
//

import Foundation
import UIKit

class SubscribeView : UIView {
    
    //Design View
    
    lazy var cancelButton = ViewGenerator.getSimpleImageButton(image: UIImage(systemName: "xmark.fill")!)
    
    lazy var restoreButton = ViewGenerator.getButton(ButtonOptions(title: "Restore", color: .clear, image: nil, smiley: nil))
    
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "title", color: .label, fontStyle: AppFonts.loginTitle), LabelInsets(5))
    
    lazy var subTitle = ViewGenerator.getLabel(LabelOptions(text: "sub title", color: .label, fontStyle: AppFonts.loginTitle), LabelInsets(5))
    
    lazy var subscribeButton = ViewGenerator.getButton(ButtonOptions(title: "Subscribe", color: MyColors.primary, image: nil, smiley: nil))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    private func initialize(){
        
        
    }
}
