//
//  CopyItemCell.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit
import LinkPresentation


class CopyItemCell: UICollectionViewCell{
    
    let labelOpts = LabelOptions(text: "Demo Text", color: .label, fontStyle: AppFonts.labelText)
    lazy var label = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
    
    let dateOptions = LabelOptions(text: "Demo Text", color: .label, fontStyle: AppFonts.labelText)
    lazy var date = ViewGenerator.getLabel(dateOptions, LabelInsets(0, 0, 0, 0))
    
    let imageOptions = ImageViewOptions(image: nil, size: (width: 100, height: 100))
    lazy var imageArea = ViewGenerator.getRoundedImageView(imageOptions)
    
//    let imageViewProps = ImageViewOptions(
//        image: UIImage(named: "fb"),
//        size: (width: 200, height: 200)
//    )
    
    lazy var linkView = LPLinkView()
    lazy var textContentView = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
//    lazy var imageView = ViewGenerator.getRoundedImageView(imageViewProps)
    
    let bgImageOpts = ImageViewOptions(
        image: UIImage(named: "fb"),
        size: (width: 100, height: 100)
    )
    
    lazy var bgImage = ViewGenerator.getRoundedImageView(bgImageOpts)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func hideElement(view: UIView, isHidden: Bool = false ){
        view.isHidden = isHidden
    }
    
    func initialize() {
        
        contentView.addSubview(label)
        contentView.addSubview(date)
        contentView.addSubview(imageArea)
//        contentView.addSubview(linkView)
//        contentView.addSubview(textContentView)
//        contentView.addSubview(imageView)
        
        triggerConstraints()
    }
    
    func triggerConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true

//        linkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
//        linkView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30).isActive = true
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        imageArea.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        imageArea.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageArea.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageArea.heightAnchor.constraint(equalToConstant: 100).isActive = true

        date.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        date.widthAnchor.constraint(equalToConstant: 100).isActive = true
        date.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
