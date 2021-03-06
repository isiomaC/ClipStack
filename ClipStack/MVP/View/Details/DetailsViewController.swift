//
//  DetailsViewController.swift
//  ClipStack
//
//  Created by Chuck on 13/04/2022.
//

import Foundation
import UIKit


class DetailsViewController : BaseViewController {
    
    let detailView = DetailView()
    
    var detailPresenter: DetailPresenter?
    
    var sendingViewController: GenericCollectionView<CopyItem, CopyItemCell>?
    var copyItemPosition: Int?
    
    init(copyItem: CopyItem, sendingInfo: (GenericCollectionView<CopyItem, CopyItemCell>, Int) ) {
        
        super.init()
        
        sendingViewController = sendingInfo.0
        copyItemPosition = sendingInfo.1
        
        detailPresenter = DetailPresenter(delegate: self)
        detailPresenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        detailPresenter?.copyItem = copyItem
        
        view = detailView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.isHidden = false
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isHidden = false
        
        guard let copyItem = detailPresenter?.copyItem,
              let value = detailPresenter?.resolveCopyItemType(copyItem: copyItem )else { return }
        
        guard let mType = CopyItemType.init(rawValue: copyItem.type!) else { return }
        
        initButtonActions()
        
        setViewToShow(type: mType, content: value)
    }
    
    private func initButtonActions(){
        detailView.closeBtn.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        detailView.closeBtn.layer.zPosition = 1000
        
        detailView.copyButton.addTarget(self, action: #selector(copyButtonAction), for: .touchUpInside)
        
        detailView.deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        
        detailView.shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
    }
    
    private func setViewToShow(type: CopyItemType, content: AnyObject){
        switch(type){
            case .image:
                detailView.show(view: detailView.mImageView)
                detailView.mImageView.image = content as? UIImage
                break
            case .text:
                detailView.show(view: detailView.mTextView)
                detailView.mTextView.text = content as? String
                break
            case .url:
                detailView.show(view: detailView.mTextView)
                detailView.mTextView.text = (content as? URL)?.absoluteString
                break
            case .color:
                print("Incolor")
                break
        }
    }
    

}

// MARK: OBjc FUnctions

extension DetailsViewController{
    @objc func closeViewController(){
        print("clicked")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func copyButtonAction(){
        guard let copy = detailPresenter?.copyItem else { return }
        
        detailPresenter?.copyItemToClipboard(copy: copy)
        
        Utility.showToast(self, message: "Item Copied", seconds: 1.5)
    }
    
    @objc func deleteButtonAction(){
        
        Utility.showAlertController(self, preferredStyle: .actionSheet, confirmTitle: "Delete Item") { [weak self] in
            
            guard let stronSelf = self else { return }
            
            guard let copy = stronSelf.detailPresenter?.copyItem,
                  let presenter = stronSelf.detailPresenter,
                  let vc = stronSelf.sendingViewController,
                  let postion = stronSelf.copyItemPosition else { return }
            
            presenter.context?.delete(copy)
            
            vc.remove(position: postion)
            
            let hapticFeedback = UINotificationFeedbackGenerator()
            hapticFeedback.notificationOccurred(.success)
            
            presenter.save()
            
            stronSelf.dismiss(animated: true, completion: nil)
        }
      
    }
    
    @objc func shareButtonAction(){
        guard let copy = detailPresenter?.copyItem else { return }
        detailPresenter?.shareCopyItem(controller: self, copyItem: copy)
    }
}
