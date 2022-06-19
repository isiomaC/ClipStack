//
//  AddedClipsPresenter.swift
//  ClipStack
//
//  Created by Chuck on 12/06/2022.
//

import Foundation

class AddedClipsPresenter: CopyItemsPresenter {
    
    
    override init(delegate: PresenterDelegate) {
        super.init(delegate: delegate)
        
    }
    
    func saveByUser(copyItem: CopyItemDTO, completion: @escaping(Bool, Error) -> Void){
        
        
    }
    
    override func getCopyItems(type: CopyItemType?) {
        let query = NSPredicate(format: "isAutoCopy == %@", NSNumber(booleanLiteral: false))
        
        let data = getDataItems(type, predicate: query)
        
        delegate?.fetchedDataFromCoreDataDB(data: data)
    }
    
}
