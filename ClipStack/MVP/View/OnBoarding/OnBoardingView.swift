//
//  OnBoardingView.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit

class OnBoardingView: UIView{

//    lazy var image = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(systemName: "trash"), size: (150, 150)))
    
//    lazy var nextButton = ViewGenerator.getButton(ButtonOptions(title: "", color: .systemGray, image: nil, smiley: nil))
//
//    lazy var prevButton = ViewGenerator.getButton(ButtonOptions(title: "", color: .systemGray, image: nil, smiley: nil))
    
    lazy var innerView = UIView()
    
    lazy var whatsNewLabel = ViewGenerator.getLabel(LabelOptions(text: "What's New", color: .label, fontStyle: AppFonts.loginLandingText))
    
    lazy var whatsNewCell1 = WhatsNewCell()
    lazy var whatsNewCell2 = WhatsNewCell()
    lazy var whatsNewCell3 = WhatsNewCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setUpConstraints()
    }
    
    private func addViews(){
        
        addSubview(innerView)
        
        innerView.addSubview(whatsNewLabel)
        
        innerView.addSubview(whatsNewCell1)
        
        innerView.addSubview(whatsNewCell2)
        
        innerView.addSubview(whatsNewCell3)
        

        
    }
    


    private func setUpConstraints(){
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        innerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        innerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        whatsNewLabel.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 20).isActive = true
        whatsNewLabel.centerXAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        

        whatsNewCell1.translatesAutoresizingMaskIntoConstraints = false
        whatsNewCell1.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whatsNewCell1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        whatsNewCell1.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        whatsNewCell1.topAnchor.constraint(equalTo: whatsNewLabel.bottomAnchor, constant: 30).isActive = true

        
        whatsNewCell2.translatesAutoresizingMaskIntoConstraints = false
        whatsNewCell2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whatsNewCell2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        whatsNewCell2.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        whatsNewCell2.topAnchor.constraint(equalTo: whatsNewCell1.bottomAnchor, constant: 30).isActive = true
        
        
        whatsNewCell3.translatesAutoresizingMaskIntoConstraints = false

        whatsNewCell3.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whatsNewCell3.heightAnchor.constraint(equalToConstant: 100).isActive = true
        whatsNewCell3.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        
        whatsNewCell3.topAnchor.constraint(equalTo: whatsNewCell2.bottomAnchor, constant: 30).isActive = true

       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
