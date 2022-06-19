//
//  HomePresenter.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import CoreData


class HomePresenter : BasePresenter {
    
    var copyItems: [CopyItem]?
    
//    var context: NSManagedObjectContext?
    
    func save(_ copyItemDTO: CopyItemDTO){
        guard let mContext = context, let isAuto = copyItemDTO.isAutoCopy else {
            return
        }
        do{
            let newCopyItem = CopyItem(context: mContext)
            newCopyItem.color = copyItemDTO.color
            newCopyItem.title = copyItemDTO.title
            newCopyItem.content = copyItemDTO.content
            newCopyItem.dateCreated = copyItemDTO.dateCreated
            newCopyItem.dateUpdated = copyItemDTO.dateUpdated
            newCopyItem.type = copyItemDTO.type?.rawValue
            newCopyItem.keyId = copyItemDTO.keyId
            newCopyItem.isAutoCopy = isAuto
            newCopyItem.id = copyItemDTO.id
            
            try context?.save()
        }catch {
            print("An error occured while saving the data: \(error)")
        }
    }
    
    func getDataItems(_ type: CopyItemType?) -> [CopyItem]{
        
        var copyItems = [CopyItem]()

        //optional type parameter to filter queries
        if let mType = type {
            print(mType)
            
        } else{
            guard let mContext = context else {
                return [CopyItem]()
            }
                    
            let request : NSFetchRequest<CopyItem> =  CopyItem.fetchRequest()
                   
            do{
                copyItems = try mContext.fetch(request)
            }catch{
               print("Error fetching request: \(error)")
            }
        }
       
        return copyItems
    }
    
    override func getCopyItems(type: CopyItemType?) {
        //Perform operation here then pass to delegate function
        
        let data = getDataItems(type)
        
        delegate?.fetchedDataFromCoreDataDB(data: data)
//        super.getData(type: type)
    }
    
    override func getError(_ level: AlertType = .error, error: Error) {
        
        //Perform operation here then pass to delegate function
        
        super.getError(level, error: error)
    }
}


