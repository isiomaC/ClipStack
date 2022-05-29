//
//  DetailView.swift
//  ClipStack
//
//  Created by Chuck on 14/04/2022.
//

import Foundation
import UIKit

class DetailView : UIView {
    
    lazy var mTextView : UITextView = {
        let textview = UITextView(frame: CGRect(x: 0, y: 0, width: Dimensions.screenSize.width, height: Dimensions.screenSize.height))
        textview.automaticallyAdjustsScrollIndicatorInsets = false
        textview.textAlignment = .justified
        textview.backgroundColor = .systemBackground
        textview.textColor = .systemRed
        textview.font = AppFonts.textField
        textview.center = self.center
        return textview
    }()
    
    let imageOptions = ImageViewOptions(image: nil, size: (width: 100, height: 100))
    lazy var mImageView = ViewGenerator.getImageView(imageOptions)
    
    lazy var closeBtn = ViewGenerator.getButton(ButtonOptions(title: "", color: .systemRed, image: UIImage(systemName: "xmark"), smiley: nil), circular: true)
    
    lazy var copyButton = ViewGenerator.getButton(ButtonOptions(title: "", color: .systemRed, image: UIImage(systemName: "doc.on.doc.fill"), smiley: nil), circular: true)
    lazy var shareButton = ViewGenerator.getButton(ButtonOptions(title: "", color: .systemRed, image: UIImage(systemName: "square.and.arrow.up"), smiley: nil), circular: true)
    lazy var deleteButton = ViewGenerator.getButton(ButtonOptions(title: "", color: .systemRed, image: UIImage(systemName: "delete.backward"), smiley: nil), circular: true)
    
    lazy var bottomArea : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(view: UIView){
        if view is UIImageView{
            mImageView.isHidden = false
            mTextView.isHidden = true
        }else if view is UITextView{
            mTextView.isHidden = false
            mImageView.isHidden = true
        }
    }
    
    private func initialize() {
        addSubview(mTextView)
        addSubview(closeBtn)
        addSubview(mImageView)
        addSubview(bottomArea)
        
        
        bottomArea.addArrangedSubview(shareButton)
        bottomArea.addArrangedSubview(copyButton)
        bottomArea.addArrangedSubview(deleteButton)
        
        bottomArea.backgroundColor = .systemBackground
        
        
        mImageView.contentMode = .scaleAspectFit
        mImageView.backgroundColor = .systemBackground
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        closeBtn.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        
        mTextView.translatesAutoresizingMaskIntoConstraints = false
        mTextView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 10).isActive = true
        
        mTextView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        mTextView.bottomAnchor.constraint(equalTo: bottomArea.topAnchor, constant: -10).isActive = true
        
        
        mImageView.translatesAutoresizingMaskIntoConstraints = false
        mImageView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 10).isActive = true
        
        mImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        mImageView.bottomAnchor.constraint(equalTo: bottomArea.topAnchor, constant: -10).isActive = true
        
        
        
        bottomArea.translatesAutoresizingMaskIntoConstraints = false
        
        bottomArea.widthAnchor.constraint(equalTo: widthAnchor, constant: -15).isActive = true
        bottomArea.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomArea.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bottomArea.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
