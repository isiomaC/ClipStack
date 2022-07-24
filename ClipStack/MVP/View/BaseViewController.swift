//
//  BaseViewController.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//


import Foundation
import UIKit

class BaseViewController: PresenterDelegate, Coordinating {
    
    var coordinator: Coordinator?
    
    var saveCopyNotification: Bool = UserDefaults.standard.bool(forKey: Constants.autoCopy)
    
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
        view.isHidden = false
        
        if saveCopyNotification == true{
            addNotification()
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.isHidden = true
        if saveCopyNotification == true{
            removeNotification()
        }
    }
    
    //MARK:- Copy Update Notifications
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(updatePasteBoard), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func updatePasteBoard(notification: Notification){
        updatePasteBoardData()
    }
    
    func updatePasteBoardData(){
        
        //override from children
        print("??Called from Base")
    }
    
    
    func fetchedDataFromCoreDataDB(data: [CopyItem]) {
        print("getFromCoreData   => From Base")
    }
    
    func errorFetchingData(level: AlertType, message: String) {
        print("errorOccured    => From Base")
    }
}

