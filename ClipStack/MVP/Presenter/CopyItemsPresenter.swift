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
    
//    private func save(){
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//    }
    
    func prepareDataToSave(pasteboard: UIPasteboard) -> (CopyItemType?, Data?){
        
        var type: CopyItemType?
        var content: Data?
        
        if pasteboard.hasStrings || pasteboard.hasURLs{

            //decode string
            //String(decoding: data, as: UTF8.self)

            //URL and string are stored in pasteboard.string
            guard let saveString = pasteboard.string else{
              return (nil, nil)
            }

            if saveString.starts(with: "http"){
              type = CopyItemType.url
            }else{
              type = CopyItemType.text
            }
            content = Data(saveString.utf8)

        }else if pasteboard.hasImages{

            //save Image
            type = CopyItemType.image
            guard let saveImage = pasteboard.image, let mData = saveImage.pngData() else{
              return (nil, nil)
            }
            content = mData

        }else if pasteboard.hasColors{

            type = CopyItemType.color
            guard let saveColor = pasteboard.color, let colorData = saveColor.encode() else{
              return (nil, nil)
            }
            content = colorData
        }
        
        return (type, content)
    }
    
    func save(_ copyItemDTO: CopyItemDTO?, completion: @escaping (Bool?) -> Void ){
        
        guard let mContext = context else {
            return
        }
        
        if let copyItem = copyItemDTO {
            let newCopyItem = CopyItem(context: mContext)
            newCopyItem.color = copyItem.color
            newCopyItem.title = copyItem.title
            newCopyItem.content = copyItem.content
            newCopyItem.dateCreated = copyItem.dateCreated
            newCopyItem.dateUpdated = copyItem.dateUpdated
            newCopyItem.type = copyItem.type?.rawValue
            newCopyItem.keyId = copyItem.keyId
            newCopyItem.folderId = copyItem.folderId
            newCopyItem.id = copyItem.id
       
        
            (UIApplication.shared.delegate as! AppDelegate).saveContext { [weak self] result in
                switch result{
                    case .success(let saveComplete):
                        self?.writeContentsForExtension(mCopyItems: [newCopyItem])
                        completion(saveComplete)
                        break;
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(false)
                        break;
                }
            }
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
            let query : NSSortDescriptor = NSSortDescriptor(key: "dateUpdated", ascending: false)
                   
            request.sortDescriptors = [query]
            
            do{
                copyItems = try mContext.fetch(request)
            }catch{
               print("Error fetching request: \(error)")
            }
        }
       
        return copyItems
    }
    
    override func getCopyItems(type: CopyItemType?) {
        
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
        
    
    func getMenuConfiguration(copy: CopyItem, indexPath: IndexPath) -> UIMenu {
        let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "")) { [weak self] action in
            
            self?.copyItemToClipboard(copy: copy)
        }
        
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "")) { [weak self] action in
           
            guard let controller = self?.delegate as? CopyItemsViewController else {
                return
            }
            
            self?.shareCopyItem(controller: controller, copyItem: copy)
        }
        
        let deleteAction =  UIAction(title: "Delete", image: UIImage(systemName: ""), attributes: .destructive) { [weak self] action in
            
            self?.context?.delete(copy)
            
            let copyItemsViewController = self?.delegate as? CopyItemsViewController
            
            copyItemsViewController?.remove(position: indexPath.row)
            
            let hapticFeedback = UINotificationFeedbackGenerator()
            hapticFeedback.notificationOccurred(.success)
            
            self?.save()
            
        }
        
        return UIMenu(title: "", children: [copyAction, shareAction, deleteAction])
    }
    
    
}


//Widget Extension helper
extension CopyItemsPresenter{
    func writeContentsForExtension(mCopyItems: [CopyItem]) {
        let widgetContents = mCopyItems.map {
            WidgetContent(date: $0.dateCreated!, content: $0.content!,
                          name: $0.title!, type: $0.type!,
                          dateCreated: $0.dateCreated!, id: $0.id)
        }
//        var date: Date = Date()
//        let content: Data
//        let name: String
//        let type: CopyItemType
//        let dateCreated: Date
//        let id: UUID?
        
        let archiveURL = FileManager.sharedContainerURL().appendingPathComponent("contents1.json")
        
        print(">>> \(archiveURL)")
        let encoder = JSONEncoder()
        if let dataToSave = try? encoder.encode(widgetContents) {
          do {
            try dataToSave.write(to: archiveURL)
          } catch {
            print("Error: Can't write contents")
            return
          }
        }
      }
}
