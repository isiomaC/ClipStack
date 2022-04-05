//
//  CopyItem.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//


import Foundation

protocol BaseProtocol {
    var isEmpty: Bool { get set }
    func setData(_ snapShot: NSObject?)
}

struct CopyItemDTO{
    var color: String?
    var content: Data?
    var dateCreated: Date?
    var dateUpdated: Date?
    var folderId: UUID?
    var id: UUID?
    var keyId: UUID?
    var title: String?
    var type: CopyItemType?
    
    mutating func setType(type: CopyItemType){
        self.type = type
    }
}

//
//class CopyItem: BaseProtocol {
//    var isEmpty: Bool
//    
//    var isBase: Bool = true
//    
//    var property1: String
//    var property2: String
//    
//    func setData(_ snapShot: NSObject?) { }
//    
//    required init(snapShot: NSObject? = nil) {
//        isEmpty = snapShot == nil
//        self.property1 = ""
//        self.property2 = ""
//        if !isEmpty {
//            if let data = snapShot {
//                setData(data)
//            }
//        }
//    }
//    
//    init(_ abc: String, _ bde: String ){
//        self.property1 = abc
//        self.property2 = bde
//        self.isEmpty = false
//    }
//}
