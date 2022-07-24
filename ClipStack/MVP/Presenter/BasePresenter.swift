//
//  BasePresenter.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit
import CoreData

protocol BasePresenterDelegate: AnyObject {
    func fetchedDataFromCoreDataDB(data: [CopyItem])
    func errorFetchingData(level: AlertType, message: String)
}

typealias PresenterDelegate = BasePresenterDelegate & UIViewController

class BasePresenter {
    weak var delegate: PresenterDelegate?

    var context: NSManagedObjectContext?
    
    init(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    init(){
        
    }
    
    func save(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getCopyItems(type: CopyItemType?){
        delegate?.fetchedDataFromCoreDataDB(data: [CopyItem]())
        
    }

    public func getError(_ level: AlertType = .error, error: Error) {
        delegate?.errorFetchingData(level: level, message: error.localizedDescription)
        
    }
    
    
    public func resolveCopyItemType(copyItem: CopyItem) -> AnyObject?{
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
    
    
    public func copyItemToClipboard(copy: CopyItem){
        
        guard let mType = CopyItemType.init(rawValue: copy.type!) else { return }
        
        let mPasteBoard = PasteBoardManager.shared.mPasteBoard

        switch mType{
            case .text:
                if let text = String(data: copy.content!, encoding: .utf8){
                    mPasteBoard.string = text
                }
                break;
            case .url:
                if let strng = String(data: copy.content!, encoding: .utf8){
                    mPasteBoard.string = strng
                    mPasteBoard.url = URL(string: strng)
                }
                break;
            case .image:
                if let img = UIImage(data: copy.content!){
                    mPasteBoard.image = img
                }
                break;
            case .color:
                if let color = UIColor.color(data: copy.content!){
                    mPasteBoard.color = color
                }
                break;
            default : break;
        }
        
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
    }
    
    
    public func shareCopyItem(controller: BaseViewController, copyItem: CopyItem){
        
        let itemToShare = resolveCopyItemType(copyItem: copyItem)
       
        let sheet = UIActivityViewController(activityItems: [itemToShare as Any], applicationActivities: nil)
        
        controller.present(sheet, animated: true, completion: nil)
        
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
    }
    
}

