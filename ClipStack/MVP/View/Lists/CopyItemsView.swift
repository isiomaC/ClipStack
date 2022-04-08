//
//  CopyItemView.swift
//  ClipStack
//
//  Created by Chuck on 04/04/2022.
//

import Foundation
import UIKit

class CopyItemsView : UIView {
    
    let buttonOptions = ButtonOptions(title: "someButton", color: .white, borderWidth: 5, radius: 5, font: AppFonts.buttonFont, image: nil, smiley: nil, titleColor: .black)
    lazy var someButton = ViewGenerator.getButton(buttonOptions)
    
    lazy var topArea = UIView()
    lazy var bottomArea = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
        backgroundColor = .systemBackground
    }
    
    func initialize() {
        
//        addSubview(topArea)
//        addSubview(bottomArea)
//        addConstraints()
    }
    
    func addSectionHeader(label: UILabel, position: String = "top"){
        
//        let labelOpts = LabelOptions(text: "Today's popular", color: .black, fontStyle: AppFonts.textField)
        label.font = AppFonts.labelText
        
        if position.lowercased() == "top".lowercased() {
            topArea.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: topArea.trailingAnchor, constant: -15),
                label.leadingAnchor.constraint(equalTo: topArea.leadingAnchor, constant: 15 )
            ])
        }else{
            bottomArea.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bottomArea.topAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: bottomArea.trailingAnchor, constant: -15),
                label.leadingAnchor.constraint(equalTo: bottomArea.leadingAnchor, constant: 15 )
            ])
        }
    }
    
    func addConstraints() {
//        someButton.translatesAutoresizingMaskIntoConstraints = false
//
//        someButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
//        someButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//
//        someButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        someButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        topArea.translatesAutoresizingMaskIntoConstraints = false
        bottomArea.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topArea.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topArea.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            topArea.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor ),
            topArea.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomArea.topAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            bottomArea.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomArea.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor ),
            bottomArea.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
