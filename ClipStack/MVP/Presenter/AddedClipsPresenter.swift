//
//  AddedClipsPresenter.swift
//  ClipStack
//
//  Created by Chuck on 12/06/2022.
//

import Foundation
import UIKit

class AddedClipsPresenter: CopyItemsPresenter {
    
    
    override init(delegate: PresenterDelegate) {
        super.init(delegate: delegate)
        
    }
    
    func saveByUser(copyItem: CopyItemDTO, completion: @escaping(Bool, Error) -> Void){
        
        
    }
    
    override func getCopyItems(type: CopyItemType?) {
        let query = NSPredicate(format: "isAutoCopy == %@", NSNumber(booleanLiteral: false))
        
        let data = getDataItems(type, predicate: query)
        
        delegate?.fetchedDataFromCoreDataDB(data: data)
    }
    
    override func getMenuConfiguration(copy: CopyItem, indexPath: IndexPath) -> UIMenu {
        let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { [weak self] action in
            
            self?.copyItemToClipboard(copy: copy)
            guard let del = self?.delegate else { return }
            Utility.showToast(del, message: "Copied", seconds: 1.5)
        }
        
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
           
            guard let controller = self?.delegate as? AddedCopyItemsViewController else {
                return
            }
            
            self?.shareCopyItem(controller: controller, copyItem: copy)
        }
        
        let deleteAction =  UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { [weak self] action in
            
//            self?.handleDeleteAction(copyItem: copy, vc: BaseViewController(), indexPath: indexPath)
            
            guard let delegat = self?.delegate else { return }
            
            Utility.showAlertController(delegat, preferredStyle: .actionSheet) {
                self?.context?.delete(copy)

                let copyItemsViewController = self?.delegate as? AddedCopyItemsViewController

                copyItemsViewController?.remove(position: indexPath.row)

                let hapticFeedback = UINotificationFeedbackGenerator()
                hapticFeedback.notificationOccurred(.success)

                self?.save()
            }
            
        }
        
        return UIMenu(title: "", children: [copyAction, shareAction, deleteAction])
    }
    
}
