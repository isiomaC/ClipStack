//
//  ImageCopyItemCell.swift
//  ClipStack
//
//  Created by Chuck on 08/04/2022.
//

import Foundation
import UIKit
import LinkPresentation


class ImageCopyItemCell: UICollectionViewCell{
    
    let labelOpts = LabelOptions(text: "Demo Text", color: .label, fontStyle: AppFonts.labelText)
    lazy var label = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
    
    let dateOptions = LabelOptions(text: "Demo Text", color: .label, fontStyle: AppFonts.labelText)
    lazy var date = ViewGenerator.getLabel(dateOptions, LabelInsets(0, 0, 0, 0))
    
    let imageOptions = ImageViewOptions(image: nil, size: (width: 100, height: 100))
    lazy var imageArea = ViewGenerator.getRoundedImageView(imageOptions)
    
    let btnOptions = ButtonOptions(title: "", color: .clear, image: UIImage(systemName: "square.grid.4x3.fill"), smiley: nil)
    lazy var threeDotsButton = ViewGenerator.getButton(btnOptions, circular: true)
    
//    lazy var textContentView = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
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
        contentView.addSubview(threeDotsButton)
        
        triggerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 20
    }
    
    func triggerConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
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
