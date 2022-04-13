//
//  CopyItemsPresenter.swift
//  ClipStack
//
//  Created by Chuck on 13/04/2022.
//

import Foundation
import UIKit
import CoreData
import LinkPresentation

class CopyItemsPresenter: BasePresenter {
    
    var copyItems: [CopyItem]?
    
    var context: NSManagedObjectContext?
    
    override init(delegate: PresenterDelegate) {
        super.init(delegate: delegate)
    }
    
    func save(_ copyItemDTO: CopyItemDTO){
        guard let mContext = context else {
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
            newCopyItem.folderId = copyItemDTO.folderId
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
    }
    
    override func getError(_ level: AlertType = .error, error: Error) {
        
        //Perform operation here then pass to delegate function
        
        super.getError(level, error: error)
    }
}


//MARK:- UIKit and Private functions
extension CopyItemsPresenter {
    
    func fetchMetaData(url: String, completion: @escaping (LPLinkMetadata?) -> Void) {
        
        if let metaData = MetaDataCache.retrieve(urlString: url){
            return completion(metaData)
        }else{
            let provider = LPMetadataProvider()
            guard let mUrl = URL(string: url) else {
                completion(nil)
                return
            }
            
            provider.startFetchingMetadata(for: mUrl) { metadata, error in
                guard let meta = metadata, error == nil else {
                    completion(nil)
                    return
                }
                MetaDataCache.cache(metadata: meta)
                DispatchQueue.main.async {
                    completion(meta)
                }
            }
        }
    }
        
    
    func getMenuConfiguration(copy: CopyItem) -> UIMenu {
        let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "")) { [weak self] action in
            
            guard let controller = self?.delegate as? CopyItemsViewController else {
                return
            }
            
            let mType = CopyItemType.init(rawValue: copy.type!)

            switch mType{
                case .text:
                    if let text = String(data: copy.content!, encoding: .utf8){
                        controller.pasteboard.string = text
                    }
                    break;
                case .url:
                    if let strng = String(data: copy.content!, encoding: .utf8){
                        controller.pasteboard.string = strng
                        controller.pasteboard.url = URL(string: strng)
                    }
                    break;
                case .image:
                    if let img = UIImage(data: copy.content!){
                        controller.pasteboard.image = img
                    }
                    break;
                case .color:
                    if let color = UIColor.color(data: copy.content!){
                        controller.pasteboard.color = color
                    }
                    break;
                default : break;
            }
        }
        
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "")) { [weak self] action in
            //trigger shareSheet
           
            guard let controller = self?.delegate as? CopyItemsViewController else {
                return
            }
            
            let itemToShare = self?.resolveCopyItemType(copyItem: copy)
           
            let sheet = UIActivityViewController(activityItems: [itemToShare as Any], applicationActivities: nil)
            
            controller.present(sheet, animated: true, completion: nil)
            
        }
        
        let deleteAction =  UIAction(title: "Delete", image: UIImage(systemName: "")) { [weak self] action in
            
            //delete copyItem, Update CollectionView
           
            
            
        }
        
        return UIMenu(title: "", children: [copyAction, shareAction, deleteAction])
    }
    
    private func resolveCopyItemType(copyItem: CopyItem) -> AnyObject?{
        let mType = CopyItemType.init(rawValue: copyItem.type!)
        
        var returnType: AnyObject?
        
        switch mType {
            case .text:
                if let text = String(data: copyItem.content!, encoding: .utf8){
                    returnType = text as AnyObject
                }
                break;
            case .url:
                if let strng = String(data: copyItem.content!, encoding: .utf8){
                    returnType = URL(string: strng) as AnyObject
                }
                break;
            case .image:
                if let img = UIImage(data: copyItem.content!){
                    returnType = img as AnyObject
                }
                break;
            case .color:
                if let color = UIColor.color(data: copyItem.content!){
                    returnType = color as AnyObject
                }
                break;
            default : break;
        }
        
        return returnType
    }
}
