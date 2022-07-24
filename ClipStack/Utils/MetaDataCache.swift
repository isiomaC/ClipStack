//
//  MetaDataCache.swift
//  ClipStack
//
//  Created by Chuck on 13/04/2022.
//

import Foundation
import LinkPresentation
import CoreData

class MetaDataCache {
    
//    var links: CopyItem?
    static func cache(metadata: LPLinkMetadata)  {
        
//        links = CopyItem()
        do {
            guard retrieve(urlString: metadata.url!.absoluteString) == nil else {
              return
            }

            // Transform the metadata to a Data object and
            // set requiringSecureCoding to true
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)

            // Save to user defaults
            UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
            } catch let error {
                print("Error when caching: \(error.localizedDescription)")
        }
    }
    
    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
           // Check if data exists for a particular url string
           guard let data = UserDefaults.standard.object(forKey: urlString) as? Data,
             // Ensure that it can be transformed to an LPLinkMetadata object
             let metadata = try NSKeyedUnarchiver.unarchivedObject( ofClass: LPLinkMetadata.self, from: data)
             else {
            return nil
           }
           return metadata
         }
         catch let error {
           print("Error when retrieving cached data: \(error.localizedDescription)")
           return nil
         }
    }
}

























////
////  MetaDataCache.swift
////  ClipStack
////
////  Created by Chuck on 13/04/2022.
////
//
//import Foundation
//import LinkPresentation
//import CoreData
//
//class MetaDataCache {
//
//    static func cache(metadata: LPLinkMetadata)  {
//
//        DispatchQueue.main.async {
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//            retrieve(urlString: metadata.url!.absoluteString) { existingMetaData in
//                do {
//
//                    guard existingMetaData == nil else {
//                        return
//                    }
//
//                    // Transform the metadata to a Data object and
//                    // set requiringSecureCoding to true
//                    let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
//
//
//                    let newUrlMetaData = UrlMetaData(context: context)
//
//                    newUrlMetaData.url = metadata.url!.absoluteString
//                    newUrlMetaData.metadat = data
//
//                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
//
//                    } catch let error {
//                        print("Error when caching: \(error.localizedDescription)")
//                }
//            }
//        }
//
//    }
//
//    static func retrieve(urlString: String, completion: @escaping(LPLinkMetadata?) -> Void) {
//
//        DispatchQueue.main.async {
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//            do {
//
//                // Check if data exists for a particular url string
//                let request : NSFetchRequest<UrlMetaData> =  UrlMetaData.fetchRequest()
//
//                request.predicate = NSPredicate(format: "url == %@", urlString)
//
//                let urlMetaData : [UrlMetaData] = try context.fetch(request)
//
//                if urlMetaData.count > 0 {
//
//                    guard let data = urlMetaData.first?.metadat else {
//                        completion(nil)
//                        return
//                    }
//
//                    let metadata = try NSKeyedUnarchiver.unarchivedObject( ofClass: LPLinkMetadata.self, from: data)
//
//                    completion(metadata)
//                }else{
//                    completion(nil)
//                }
//
//    //           guard let data = UserDefaults.standard.object(forKey: urlString) as? Data,
//
//             }
//             catch let error {
//               print("Error when retrieving cached data: \(error.localizedDescription)")
//                 completion(nil)
//             }
//        }
//
//    }
//}
