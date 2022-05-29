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
    
    var context: NSManagedObjectContext?
    
    var copyItem: CopyItem?
    
    override init(delegate: PresenterDelegate) {
        super.init(delegate: delegate)
    }

//    public func resolveCopyItemType(copyItem: CopyItem) -> AnyObject?{
//        let mType = CopyItemType.init(rawValue: copyItem.type!)
//
//        var returnType: AnyObject?
//
//        switch mType {
//            case .text:
//                if let text = String(data: copyItem.content!, encoding: .utf8){
//                    returnType = text as AnyObject
//                }
//                break;
//            case .url:
//                if let strng = String(data: copyItem.content!, encoding: .utf8){
//                    returnType = URL(string: strng) as AnyObject
//                }
//                break;
//            case .image:
//                if let img = UIImage(data: copyItem.content!){
//                    returnType = img as AnyObject
//                }
//                break;
//            case .color:
//                if let color = UIColor.color(data: copyItem.content!){
//                    returnType = color as AnyObject
//                }
//                break;
//            default : break;
//        }
//
//        return returnType
//    }
//

    
}
