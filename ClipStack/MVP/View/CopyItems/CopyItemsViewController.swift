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


class CopyItemsViewController: GenericCollectionView<CopyItem, CopyItemCell>, UISearchResultsUpdating{
        
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
//    let pasteboard = UIPasteboard.general
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var copyItemsPresenter: CopyItemsPresenter?
    let homeView = CopyItemsView()
    
    var searching = false
    
    var searchBar: UISearchBar?
    
    var queryFilter: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hasRefresh = false
        
        saveCopyNotification = true
        
        MainCoordinator.shared.toggleNavBarDisplay(hidden: false)
        
        initializePresenter()
        initializeViews()
        
        self.title = "Home";
        addCreateButton()
        
        print(dataFilePath)
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        print(searchText)

        print(searchController.isActive)
        
        if !searchController.isActive {
            searching = false
            replaceAll(itemList: dataSetCopy)
        }
        
        if !searchText.isReallyEmpty {
            searching = true
            
            let cleanText = searchText.trim()
            
            let filtered = dataSetCopy.filter { copyItem in
                
                guard let ctype = copyItem.type, let type = CopyItemType.init(stringValue: ctype) else{
                    return false
                }
                
                if (type == CopyItemType.text || type == CopyItemType.url){
                    guard let stringContent = String(data: copyItem.content!, encoding: .utf8) else {
                        return false
                    }
                    
                    if stringContent.lowercased().contains(cleanText.lowercased()){
                        return true
                    }
                }
                
                return false
            }
            
//          replaceAll(itemList: filtered )
            dataSet = filtered
            collecionView.reloadData()
            searching = false
            
        }
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
        view.addSubview(collecionView)
        
    }
    
    override func updatePasteBoardData(){
        var newCopyItem : CopyItemDTO
        
        let pasteboardManager = PasteBoardManager.shared
        
        let mPasteBoard = pasteboardManager.mPasteBoard
                
        if mPasteBoard.changeCount > pasteboardManager.currentChangeCount {
            pasteboardManager.updateChangeCount()
        
            guard let presenter = copyItemsPresenter else{
                return
            }
            
            let (type, content, title) = presenter.prepareDataToSave(pasteboard: mPasteBoard)
            
            let mDate = Date()
            
            //save data
            newCopyItem = CopyItemDTO(
                color: CopyItemTypeColor.getColor(type: type),
                content: content,
                dateCreated: mDate,
                dateUpdated: mDate,
                id: UUID(),
                keyId: UUID(),  // for short keys - extensions feature
                title: title,   //same as content if text or url, else png for image, els file for pdf
                type: type,
                isAutoCopy: true)
            
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
    
    private func setUpSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
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
        
        setUpSearchController()
        hasTabBar = true
        let frame = CGRect(x: 0, y:0,
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
    
    override func sizeForItem() -> CGSize {
        let tt = verticalSpacing + 10
        
        let twox2gridEnabled = false //Add Settings for Grid
        
        if (twox2gridEnabled){
            return CGSize(width: Dimensions.halfScreenWidth - tt , height: Dimensions.halfScreenWidth - tt)
        }
        
        return CGSize(width: Dimensions.screenSize.width - tt , height: Dimensions.halfScreenWidth - tt)
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
            
            mView.addSubview(searchBar!)
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
