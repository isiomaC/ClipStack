//
//  WhatsNewCell.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit

class WhatsNewCell: UIView {
    
    lazy var image = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(systemName: "app.fill"), size: (100, 100)))
    
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "", color: .label, fontStyle: AppFonts.boldLabelText))
    
    lazy var desc = ViewGenerator.getLabel(LabelOptions(text: "", color: .label, fontStyle: AppFonts.descText))
    
    lazy var comingSoonLabel = ViewGenerator.getLabel(LabelOptions(text: "", color: .label, fontStyle: AppFonts.boldSmallDescText))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        comingSoonLabel.backgroundColor = MyColors.primary
        comingSoonLabel.layer.cornerRadius = 10
        
        image.tintColor = MyColors.primary
        
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = false
        clipsToBounds = true
        layer.cornerRadius = 20
        
        backgroundColor = .systemGray6
        
        desc.textAlignment = .left;
        addView()
        triggerConstraints()
        
    }
    
    func setData(dto: WhatsNewDTO){
        guard let img = dto.image, let tit = dto.title, let des = dto.desc, let coming = dto.comingSoon  else{
            return
        }
        image.image = img
        title.text = tit
        desc.text = des
        
        if coming == true {
            hideComingSoon(value: false)
            comingSoonLabel.text = "Coming soon"
        }else{
            hideComingSoon(value: true)
        }
    }
    
    private func addView(){
        
        addSubview(image)
        
        addSubview(title)
        
        addSubview(desc)
        
        addSubview(comingSoonLabel)
        
    }
    
    func hideComingSoon(value: Bool){
        comingSoonLabel.isHidden = value
    }
    
    private func triggerConstraints(){
        
        
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        image.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        
        image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        

        title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5).isActive = true
        title.bottomAnchor.constraint(equalTo: image.centerYAnchor).isActive = true

        comingSoonLabel.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 5).isActive = true
        
        comingSoonLabel.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true

        desc.topAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        desc.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5).isActive = true
//
        
        desc.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
//        desc.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
