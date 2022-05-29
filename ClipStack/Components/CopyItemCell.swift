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
    
    let labelOpts = LabelOptions(text: "", color: .label, fontStyle: AppFonts.labelText)
    lazy var label = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
    
    let dateOptions = LabelOptions(text: "", color: .label, fontStyle: AppFonts.labelText)
    lazy var date = ViewGenerator.getLabel(dateOptions, LabelInsets(0, 0, 0, 0))
    
    let imageOptions = ImageViewOptions(image: nil, size: (width: 100, height: 100))
    lazy var imageArea = ViewGenerator.getImageView(imageOptions)
    
    let btnOptions = ButtonOptions(title: "", color: .clear, image: UIImage(systemName: "ellipsis"), smiley: nil)
    lazy var threeDotsButton = ViewGenerator.getButton(btnOptions, circular: true)
    
    
    lazy var containerLinkView : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        return stack
    }()
    
    var linkView = LPLinkView(metadata: LPLinkMetadata())
    lazy var textContentView = ViewGenerator.getLabel(labelOpts, LabelInsets(0, 0, 0, 0))
    
    let bgImageOpts = ImageViewOptions(
        image: UIImage(named: "fb"),
        size: (width: 100, height: 100)
    )
    
    lazy var bgImage = ViewGenerator.getRoundedImageView(bgImageOpts)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func hideElement(view: UIView, isHidden: Bool = false ){
        view.isHidden = isHidden
    }
    
    func show(view: UIView){
        if view is UIImageView{
            imageArea.isHidden = false
            containerLinkView.isHidden = true
            label.isHidden = true
        }else if view is UIStackView{
            containerLinkView.isHidden = false
            imageArea.isHidden = true
            label.isHidden = true
        }else if view is UILabel{
            label.isHidden = false
            imageArea.isHidden = true
            containerLinkView.isHidden = true
        }else {
            
        }
    }
    
    func initialize() {
        
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(label)
        contentView.addSubview(date)
        contentView.addSubview(imageArea)
        contentView.addSubview(threeDotsButton)
        containerLinkView.addArrangedSubview(linkView)
        linkView.sizeToFit()
        contentView.addSubview(containerLinkView)
//        contentView.addSubview(linkView)
        
//        contentView.addSubview(linkView)
//        contentView.addSubview(textContentView)
//        contentView.addSubview(imageView)
        
        label.lineBreakMode = .byTruncatingMiddle
        label.numberOfLines = 3
        
        triggerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 20
//        layer.masksToBounds = true
    }
    
    func triggerConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerLinkView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .systemGray6

        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

//        linkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
//        linkView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30).isActive = true
        
//        label.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 20).isActive = true
       
        
        date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        threeDotsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        threeDotsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        label.widthAnchor.constraint(equalToConstant: contentView.frame.width - 30).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
//        linkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        linkView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        linkView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        linkView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
//        containerLinkView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        containerLinkView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 30).isActive = true
        containerLinkView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.5).isActive = true
//        containerLinkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        containerLinkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        containerLinkView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//
        
        imageArea.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageArea.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageArea.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.5).isActive = true
        imageArea.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.5).isActive = true
    }
}
