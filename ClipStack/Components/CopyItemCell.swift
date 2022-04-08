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
    
    let btnOptions = ButtonOptions(title: "", color: .clear, image: UIImage(systemName: "square.grid.4x3.fill"), smiley: nil)
    lazy var threeDotsButton = ViewGenerator.getButton(btnOptions, circular: true)
    
    
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
        backgroundColor = .systemGray6
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
        
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(label)
        contentView.addSubview(date)
        contentView.addSubview(imageArea)
        contentView.addSubview(threeDotsButton)
        
//        contentView.addSubview(linkView)
//        contentView.addSubview(textContentView)
//        contentView.addSubview(imageView)
        
        triggerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 20
//        layer.masksToBounds = true
    }
    
    func triggerConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true

//        linkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
//        linkView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30).isActive = true
        
        label.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        threeDotsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        threeDotsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        imageArea.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        imageArea.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageArea.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageArea.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
