//
//  Enums.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit

enum FSCollection: String {
    case user
    case profile
    case resource
    case category
}

enum TextFieldType {
    case secured
    case normal
}

enum AlertType {
    case info
    case error
}

enum CoreDataModelType: String{
    case folder
    case copyItem
}


enum CopyItemType: String, Codable, CodingKey{
    case image
    case text
    case url
    case color
    
    private func getValue(_ forKey: CopyItemType) -> String {
        return forKey.rawValue
    }
}


struct CopyItemTypeColor{
    
    static let mapping : [String : UIColor] = [
        "systemTeal": UIColor.systemTeal,
        "systemGray": UIColor.systemGray,
        "systemGroupedBackground": UIColor.systemGroupedBackground,
        "systemGray6": UIColor.systemGray6
    ]
    
    static func getColor(type: CopyItemType?) -> String{
        guard let mType = type else{
            return "systemGray6"
        }
        
        var returnVal : String
        
        switch mType{
            case .image:
                returnVal = "systemTeal"
            case .text:
                returnVal = "systemGray"
            case .url:
                returnVal = "systemGroupedBackground"
            default:
                returnVal = "systemGray6"
        }
        return returnVal
    }
}



