//
//  MetaDataCache.swift
//  ClipStack
//
//  Created by Chuck on 13/04/2022.
//

import Foundation
import LinkPresentation


class MetaDataCache {
    
    static func cache(metadata: LPLinkMetadata)  {
        
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
