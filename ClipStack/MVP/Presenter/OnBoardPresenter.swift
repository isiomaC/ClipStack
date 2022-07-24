//
//  onBoardPresenter.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit

class OnBoardPresenter : BasePresenter{
    
    func getDataForOnFirstVC() -> [WhatsNewDTO]{
        
       return [
            WhatsNewDTO(image:  UIImage(systemName: "doc.on.doc"), title: "Automatic Copy", desc: "Items copied are automatically saved to your clipstack"),
            
            WhatsNewDTO(image:  UIImage(systemName: "doc.text.image"), title: "Supported Clips", desc: "Text, links, photos...", comingSoon: false),

            WhatsNewDTO(image:  UIImage(systemName: "square.and.arrow.up"), title: "Share", desc: "Easily share items with other applications"),

        ]
    }
    
    func getDataForOnSecondVC() -> [WhatsNewDTO]{
        
       return [
            WhatsNewDTO(image:  UIImage(systemName: "message.circle.fill"), title: "Messages Extension", desc: "Create shortcuts for your clips", comingSoon: true),
            
            
            WhatsNewDTO(image:  UIImage(systemName: "icloud.circle"), title: "Sync Across Devices", desc: "Copied items are synced across your apple devices", comingSoon: true),

            WhatsNewDTO(image:  UIImage(systemName: "appclip"), title: "Widgets", desc: "Create iOS widgets to view clipstack on home screen", comingSoon: true),

        ]
    }
}
