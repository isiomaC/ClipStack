//
//  SubscribeViewController.swift
//  ClipStack
//
//  Created by Chuck on 22/07/2022.
//


import Foundation
import UIKit
import StoreKit

class SubscribeViewController : BaseViewController{
    
    private var product : SKProduct?
    
    let subscribeView = SubscribeView()
    
    var parentController : BaseViewController?
    
    
    init(_ parent: BaseViewController?, _ index: IndexPath? = nil ) {
        
        parentController = parent
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        getProducts()
    }
    
    func setUpViews (){
        view = subscribeView
        
//        subscribeView.subscibeButton.addTarget(self, action: #selector(subscribeAction), for: .touchUpInside)
//
//        subscribeView.LinkToPrivacy.addTarget(self, action: #selector(openSafariController), for: .touchUpInside)
//
//        subscribeView.LinkToTerms.addTarget(self, action: #selector(openSafariController), for: .touchUpInside)
//
//        subscribeView.subscibeButton.setTitle(UserDefaults.standard.string(forKey: RemoteConfigKeys.sub_cta), for: .normal)
//
//        subscribeView.headerLabel.text = UserDefaults.standard.string(forKey: RemoteConfigKeys.sub_header)
//
//        if let room = mRoom {
//            let people = room.count > 1 ? L10n.People.text : L10n.Person.text
//            subscribeView.subLabel.text = L10n.SucbribeViewSubLabel.text(room.count, people, room.channelName)
//            subscribeView.subLabel.isHidden = false
//
//            if room.count == 0 {
//                subscribeView.subLabel.isHidden = true
//            }
//        }
//
//        //Ads label
//        subscribeView.icon4.isHidden = true
//        subscribeView.infoLabel4.isHidden = true
//
//        subscribeView.disclaimerLabel.text =  UserDefaults.standard.string(forKey: RemoteConfigKeys.sub_disclaimer)
    }
    
    func getProducts(){
        let request = SKProductsRequest(productIdentifiers: [Utility.IAPProductId])
        request.delegate = self
        request.start()
    }
}


extension SubscribeViewController {
    @objc func subscribeAction(){
        guard let mProduct = product else {
            return
        }
        if SKPaymentQueue.canMakePayments(){
            let payment = SKPayment(product: mProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    @objc func openSafariController(sender : UIButton){
        let pageRoute = sender.tag == 1 ? Utility.privacyPolicyUrl : Utility.termsAppleEula
        Utility.showSafariLink(self, pageRoute: pageRoute)
    }
}


extension SubscribeViewController : SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let mProduct = response.products.first{
            product = mProduct
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            //MARK:- LOCALIZED ERROR SHOWN HERE
            ErrorHandler.showError(strongSelf, title: "Error", error: "Something went wrong")
        }
    }
}


extension SubscribeViewController : SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchasing:
                break
                
            case .purchased:
                complete(transaction: transaction)
                break
                
            case .restored:
                restore(transaction: transaction)
                break
                
            case .failed:
                fail(transaction: transaction)
                break
                
            default:
                break
            }
        }
    }
    
    private func showFinishNotification(_ state : SKPaymentTransactionState, _ localizedError: NSError? = nil){
        switch state {
        case .purchased, .restored:
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true) { [weak self] in
                    guard let strongSelf = self else { return }
                    
                    //Hanlde success of payment..
                    
                }
            }
            break
        case .failed:
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self,
                      let localizedDescription = localizedError?.localizedDescription,
                      localizedError?.code != SKError.paymentCancelled.rawValue else { return }
                
                //MARK:- LOCALIZED ERROR SHOWN HERE
                ErrorHandler.showError(strongSelf, title: "Error", error: localizedDescription)
            }
            break
        default:
            break
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        UserDefaults.standard.setValue(true, forKey: UserDefaultkeys.isSubscribed)
        showFinishNotification(transaction.transactionState)
        SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
    }
     
    private func restore(transaction: SKPaymentTransaction) {
//        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

        UserDefaults.standard.setValue(true, forKey: UserDefaultkeys.isSubscribed)
        showFinishNotification(transaction.transactionState)
        SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
    }
     
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            showFinishNotification(transaction.transactionState, transactionError)
        }
        UserDefaults.standard.setValue(false, forKey: UserDefaultkeys.isSubscribed)
        SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
    }
}
