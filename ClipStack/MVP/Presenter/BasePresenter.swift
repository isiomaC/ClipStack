//
//  BasePresenter.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit

protocol BasePresenterDelegate: AnyObject {
    func fetchedDataFromCoreDataDB(data: [CopyItem])
    func errorFetchingData(level: AlertType, message: String)
}

typealias PresenterDelegate = BasePresenterDelegate & UIViewController

class BasePresenter {
    weak var delegate: PresenterDelegate?
    
    init(delegate: PresenterDelegate) {
        self.delegate = delegate
        
    }
    
    func getCopyItems(type: CopyItemType?){
        delegate?.fetchedDataFromCoreDataDB(data: [CopyItem]())
        
    }

    public func getError(_ level: AlertType = .error, error: Error) {
        delegate?.errorFetchingData(level: level, message: error.localizedDescription)
        
    }
}

