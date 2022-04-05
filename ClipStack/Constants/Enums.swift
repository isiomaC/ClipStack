//
//  Enums.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation

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


enum CopyItemType: String, CodingKey{
    case image
    case text
    case url
    case color
    
    private func getValue(_ forKey: CopyItemType) -> String {
        return forKey.rawValue
    }
}


