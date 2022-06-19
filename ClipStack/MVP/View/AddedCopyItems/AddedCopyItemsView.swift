//
//  AddedClipsView.swift
//  ClipStack
//
//  Created by Chuck on 12/06/2022.
//

import Foundation
import UIKit

class AddedCopyItemsView : UIView{
    
    lazy var button = ViewGenerator.getButton(ButtonOptions(title: "Test", color: .red, image: nil, smiley: nil), circular: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView(){
        
        
    }
    
}
