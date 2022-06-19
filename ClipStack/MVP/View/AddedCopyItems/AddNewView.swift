//
//  AddNewView.swift
//  ClipStack
//
//  Created by Chuck on 14/06/2022.
//

import Foundation
import UIKit

struct SwitchKeys{
    static let text = "Text"
    static let image = "Image"
}

class AddNewView: UIView {
    
    lazy var title = ViewGenerator.getTextField(TextFieldOptions(placeholder: "Enter Title", fontStyle: AppFonts.textField))
    
    lazy var icon = ViewGenerator.circularButton(image: nil, smiley: "📷")
    
    lazy var switchControl : CustomSwitch = {
        let segmentedSwitch = CustomSwitch(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        segmentedSwitch.backgroundColor = .systemGray6
        segmentedSwitch.selectedTitleColor = .systemBackground
        segmentedSwitch.titleColor = .systemTeal
        segmentedSwitch.font = AppFonts.labelText
        segmentedSwitch.thumbColor = .systemGray
        segmentedSwitch.items = [SwitchKeys.text, SwitchKeys.image]
        
        return segmentedSwitch
    }()
    
    lazy var textArea = ViewGenerator.getTextView(TextViewOptions(backgroundColor: .clear, placeholder: "Enter text", textColor: .systemGray6, fontStyle: AppFonts.labelText))
    
    lazy var uploadBtn = ViewGenerator.getButton(ButtonOptions(title: " Upload", color: .lightGray, image: "📷".image(), smiley: nil), circular: false)
    
    lazy var imageArea = ViewGenerator.getImageView(ImageViewOptions(image: nil, size: (100, 100)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func toggle(){
        if switchControl.selectedIndex == 0 {
            textArea.isHidden = false
            icon.setTitle("📑", for: .normal)
            imageArea.isHidden = true
        }else{
            textArea.isHidden = true
            icon.setTitle("📷", for: .normal)
            imageArea.isHidden = false
        }
    }

    func addViews(){
        title.tag = 2
        textArea.tag = 100
        
//        imageArea.image = UIImage(systemName: "house")
        addSubview(title)
        addSubview(icon)
        addSubview(uploadBtn)
        addSubview(textArea)
        addSubview(imageArea)
        addSubview(switchControl)
    }
    
    func addConstraints(){
        
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            switchControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            switchControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            switchControl.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: switchControl.bottomAnchor, constant: 20),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15),
            
            title.topAnchor.constraint(equalTo: switchControl.bottomAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5),
//            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            title.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
        ])

        NSLayoutConstraint.activate([
            textArea.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 25),
            textArea.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textArea.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            textArea.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            
            imageArea.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 25),
            imageArea.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageArea.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            imageArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            
            uploadBtn.topAnchor.constraint(equalTo: imageArea.bottomAnchor, constant: 10),
            uploadBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        
        
        
        
    }
    
}
