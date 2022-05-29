//
//  HomeViewController.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit
//import CoreData
import LinkPresentation


class CopyItemsViewController: GenericCollectionView<CopyItem, CopyItemCell>{
        
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
//    let pasteboard = UIPasteboard.general
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var copyItemsPresenter: CopyItemsPresenter?
    let homeView = CopyItemsView()
    
    var searching = false
    
    var searchBar: UISearchBar?
    
    var queryFilter: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hasRefresh = false
        
        saveCopyNotification = true
        
        MainCoordinator.shared.toggleNavBarDisplay(hidden: false)
        
        initializePresenter()
        initializeViews()
        
        self.title = "ClipStack";
//        self.navigationItem.title = "ClipStack"
//        self.navigationController?.navigationBar.topItem!.title = "ClipStack";
//        self.navigationController?.navigationBar.tintColor = .red
//        title = "ClipStack"
        addCreateButton()
        
        print(dataFilePath)
        
    
    }
    
    //MARK:- Initialize Views and Presenter
    func initializePresenter(){
        copyItemsPresenter = CopyItemsPresenter(delegate: self)
        
        copyItemsPresenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        copyItemsPresenter?.getCopyItems(type: nil)
    }
    
    func initializeViews(){
        
//        let labelOpts = LabelOptions(text: "History", color: .black, fontStyle: AppFonts.textField)
//        let sectionTopHeader = ViewGenerator.getLabel(labelOpts, LabelInsets(5,5,5,5))
//        homeView.addSectionHeader(label: sectionTopHeader, position: "top")
//
//        let labelOpts2 = LabelOptions(text: "Type", color: .black, fontStyle: AppFonts.textField)
//        let sectionBottomHeader = ViewGenerator.getLabel(labelOpts2, LabelInsets(5,5,5,5))
//        homeView.addSectionHeader(label: sectionBottomHeader, position: "bottom")
        
//        homeView.topArea.addSubview(collecionView)
//        homeView.topArea.backgroundColor = .systemPink
        view = homeView
        
        //add another collectionView
        view.addSubview(collecionView)
    }
    
    override func updatePasteBoardData(){
        //determine type of data to save
        var newCopyItem : CopyItemDTO
//        var type: CopyItemType?
//        var content : Data?
        
        let pasteboardManager = PasteBoardManager.shared
        
        let mPasteBoard = pasteboardManager.mPasteBoard
                
        if mPasteBoard.changeCount > pasteboardManager.currentChangeCount {
            pasteboardManager.updateChangeCount()
        
            guard let presenter = copyItemsPresenter else{
                return
            }
            
            let (type, content) = presenter.prepareDataToSave(pasteboard: mPasteBoard)
            
            let mDate = Date()
            
            //save data
            newCopyItem = CopyItemDTO(
                color: "systemBlue",
                content: content,
                dateCreated: mDate,
                dateUpdated: mDate,
                folderId: UUID(),
                id: UUID(),
                keyId: UUID(),
                title: "test_title",
                type: type)
            
            //save
            presenter.save(newCopyItem, completion: { [weak self]success in
                guard let saveSuccess = success, let strongSelf = self else {
                    return
                }
                if saveSuccess == true {
                    if let newData = strongSelf.copyItemsPresenter?.getDataItems(nil) {
                        strongSelf.refreshingg = true
                        strongSelf.updateCollectionView(newData, "new")
                    }
                }
            })
        }
    }
    
    private func setUpSearchBar() {
        guard let statusBarView = UIApplication.shared.statusBarView else {
            return
        }
        searchBar = UISearchBar(frame: CGRect(x: 0, y: statusBarView.frame.height,
                                              width: Dimensions.screenSize.width, height: 60))
        searchBar?.delegate = self
        searchBar?.clearBackgroundColor()
        searchBar?.placeholder = "Enter search term"
        
//        searchBar?.setLeftImage(UIImage(color: .red), tintColor: .white)
//        searchBar?.showsCancelButton = true
    }
    
    //MARK: Core Data Code
    
    
    // MARK: Helper functions
    private func addCreateButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createCopyItem))
    }
    
    @objc func createCopyItem(){
        print("Create Manually")
    }
    
    override func initializeDefaults() {
        setUpSearchBar()
        hasTabBar = true
        let frame = CGRect(x: 0, y: UIApplication.shared.statusBarView!.frame.height + searchBar!.frame.height,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        mFlowLayout = getFlowLayOut()
        collecionView = UICollectionView(frame: frame, collectionViewLayout: mFlowLayout)
        collecionView.backgroundColor = .systemBackground
//        mFlowLayout.headerReferenceSize = CGSize(width: Dimensions.CollectionViewFlowLayoutWidth, height: Dimensions.halfScreenHeight * 0.7)
        
        progressBar = UIActivityIndicatorView(style: .medium)
        emptyView = ViewGenerator.getLabel(LabelOptions(text: "", color: .black, fontStyle: AppFonts.labelText))
    }
    
    override func createOneTimeVariables() {
        hasRefresh = true
    }
    
    override func getData(array: [Any]) -> [CopyItem] {
        if let mArray = array as? [CopyItem] {
            return mArray
        }
        return [CopyItem]()
    }
    
    override func setupHeaderViews(header: UIView) {
        if let mView = header as? CopyItemHeaderCell {
//            mView.bgImage = UIImageView(image: .remove)
        }
    }

   
    
    override func displayItem(_ cell: CopyItemCell, _ data: CopyItem, _ position: Int) {
        
        guard let mTypeString = data.type else {
            return
        }
        
        let mType = CopyItemType.init(rawValue: mTypeString)
        
        cell.tag = position
        
        if let itemDate = data.dateCreated {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//            cell.date.text = dateFormatterPrint.string(from: itemDate)
            cell.date.text = itemDate.timeAgoSinceDate()
            cell.date.font = AppFonts.smallLabelText
        }
        
        switch mType{
            case .image:
                print("image")
                
                cell.show(view: cell.imageArea)
               
                cell.imageArea.image = UIImage(data: data.content!)
                break
            case .text, .url:
                
                if mType == .url {
                    cell.show(view: cell.containerLinkView)
                   
//                     handle URL with Link View
                    let urlString = String(data: data.content!, encoding: .utf8)!
//                    let mUrl = URL(string: urlString)
            
                    copyItemsPresenter?.fetchMetaData(url: urlString, completion: { metaData in
                        guard let meta = metaData else {
                            return
                        }
                        cell.linkView.metadata = meta
                        cell.linkView.sizeToFit()
                    })
                    
                }
                
                if mType == .text {
                    if let contentString = String(data: data.content!, encoding: .utf8){
                        if contentString.starts(with: "http"){
                            cell.show(view: cell.containerLinkView)
//                            cell.containerLinkView.backgroundColor = .red
                            
                            let urlString = String(data: data.content!, encoding: .utf8)!
//                            let murl = URL(string: String(data: data.content!, encoding: .utf8)!)
                           
                            copyItemsPresenter?.fetchMetaData(url: urlString, completion: { metaData in
                                guard let meta = metaData else {
                                    return
                                }
                                cell.linkView.metadata = meta
                                cell.linkView.sizeToFit()
                            })
                            
        //                     handle URL with Link View
//                            let linkMetaData = LPLinkMetadata()
//                            linkMetaData.originalURL =
//                            linkMetaData.url = linkMetaData.originalURL
//                            linkMetaData.title = ""

//                            cell.linkView.metadata = linkMetaData
                        }else{
                            cell.show(view: cell.label)
                            cell.label.text = contentString
                        }
                    }
                }
                
                break
            case .color:
                print("color")
                
//                cell.show(view: cell.color)
                break
                
            default: break
            
        }
    }
    
    override func selectItem(_ dataSet: CopyItem, _ position: Int) {
        print(position)
        
        let nextVC = DetailsViewController(copyItem: dataSet, sendingInfo: (self, position))
        MainCoordinator.shared.presentVC(self, nextVC)
        
        //TODO:-
        //push detailt View controller over this.
        //prepare detailt View Controller Over Here.
    }
    
    override func fetchedDataFromCoreDataDB(data: [CopyItem]) {
        print(data)
        updateCollectionView(data, "testKey")
    }
    
    override func buildContextMenuForCell(for copy: CopyItem, indexPath: IndexPath) -> UIMenu {
        guard let presenter = copyItemsPresenter else {
            return UIMenu()
        }
        return presenter.getMenuConfiguration(copy: copy, indexPath: indexPath)
    }
    
    
    
}


//extension CopyItemsViewController: UIContextMenuInteractionDelegate {
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self]actions in
//            return self?.buildContextMenu()
//        }
//    }
//
//    func buildContextMenu(for: IndexPath) -> UIMenu {
//        let copy = UIAction(title: Copy, image: UIImage(systemName: "")) { action in
//            <#code#>
//        }
//
//        return UIMenu(title: "Options", children: [copy])
//    }
//
//}



extension CopyItemsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isReallyEmpty {
            let cleanText = searchText.trim()
            let filtered = dataSet.filter({$0.title!.lowercased().contains(cleanText.lowercased())})
            replaceAll(itemList: filtered )
            searching = true
            notifyChange()
        } else {
            replaceAll(itemList: []) //getDefault to replace all with defaullt
            print(searchText.isReallyEmpty)
            DispatchQueue.main.async {
//                IQKeyboardManager.shared.resignFirstResponder()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        replaceAll(itemList: []) //getDefault to replace all with defaullt
//        IQKeyboardManager.shared.resignFirstResponder()
    }
    
}
