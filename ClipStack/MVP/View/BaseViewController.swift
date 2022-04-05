//
//  BaseViewController.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//


import Foundation
import UIKit

class BaseViewController: PresenterDelegate, Coordinating {
    func fetchedDataFromCoreDataDB(data: [CopyItem]) {
        print("getFromCoreData   => From Base")
    }
    
    func errorFetchingData(level: AlertType, message: String) {
        print("errorOccured    => From Base")
    }
    
    var coordinator: Coordinator?
    
    init(){
        coordinator = (UIApplication.shared.delegate as? AppDelegate)?.coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

}
