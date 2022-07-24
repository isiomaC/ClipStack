//
//  FirstBoardViewController.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit


class FirstBoardViewController: UIViewController{
    
    let onBoardView = OnBoardingView()
    
//    static let wDTO = WhatsNewDTO(image:  UIImage(systemName: "app.fill"), title: "Automatic Copy", desc: "Text copied to your clipboard is automatically saved for you")

    var data: [WhatsNewDTO] = [WhatsNewDTO]()
    
    let onBoardPres = OnBoardPresenter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = onBoardPres.getDataForOnFirstVC()

        onBoardView.whatsNewCell1.setData(dto: data[0])
        onBoardView.whatsNewCell2.setData(dto: data[1])
        onBoardView.whatsNewCell3.setData(dto: data[2])
        
        view = onBoardView
        view.backgroundColor  =  .systemBackground
    }
}


