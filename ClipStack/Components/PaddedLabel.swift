//
//  PaddedLabel.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//


import Foundation
import UIKit

struct LabelInsets{
    let topInset: CGFloat
    let bottomInset: CGFloat
    let leftInset: CGFloat
    let rightInset: CGFloat
    
    init(_ topInset: CGFloat = 0, _ bottomInset: CGFloat = 0, _ leftInset: CGFloat = 0, _ rightInset: CGFloat = 0){
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
    }
}


class PaddedLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init(_ top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}