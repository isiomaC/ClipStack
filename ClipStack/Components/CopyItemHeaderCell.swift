//
//  CopyItemHeaderCell.swift
//  ClipStack
//
//  Created by Chuck on 14/03/2022.
//


import Foundation
import UIKit

class CopyItemHeaderCell: UICollectionViewCell {
    
    let labelOpts = LabelOptions(text: "Today's popular", color: .black, fontStyle: AppFonts.textField)
    lazy var label = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
    
    let labelOpts2 = LabelOptions(text: "Designs", color: .black, fontStyle: AppFonts.textField)
    lazy var label2 = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
    
//    let bgImageOpts = ImageViewOptions(
//        image: UIImage(named: "fb"),
//        size: (width: 100, height: 100)
//    )
//    lazy var bgImage = ViewGenerator.getRoundedImageView(bgImageOpts)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        
        contentView.addSubview(label)
        contentView.addSubview(label2)
//        contentView.addSubview(bgImage)
        contentView.backgroundColor = .lightGray
        triggerConstraints()
    }
    
    func triggerConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        label2.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        
//        bgImage.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15).isActive = true
//        bgImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
}
