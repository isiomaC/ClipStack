//
//  DetailPresenter.swift
//  ClipStack
//
//  Created by Chuck on 25/05/2022.
//

import Foundation
import CoreData
import UIKit


class DetailPresenter : BasePresenter{
    
//    var context: NSManagedObjectContext?
    
    var copyItem: CopyItem?
    
    override init(delegate: PresenterDelegate) {
        super.init(delegate: delegate)
    }
    
}
