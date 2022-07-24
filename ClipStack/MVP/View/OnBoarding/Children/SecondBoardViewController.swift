//
//  SecondBoardViewController.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation
import UIKit


class SecondBoardViewController: UIViewController{
 
    let onBoardView = OnBoardingView()

    var data: [WhatsNewDTO] = [WhatsNewDTO]()
    
    let onBoardPres = OnBoardPresenter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = onBoardPres.getDataForOnSecondVC()

        onBoardView.whatsNewLabel.text = "What's Coming"
        onBoardView.whatsNewCell1.setData(dto: data[0])
        onBoardView.whatsNewCell2.setData(dto: data[1])
        onBoardView.whatsNewCell3.setData(dto: data[2])
        
        view = onBoardView
        view.backgroundColor  =  .systemBackground
    }
}
