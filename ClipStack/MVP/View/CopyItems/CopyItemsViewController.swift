//
//  CopyItemsViewController.swift
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
    
    var copyItemsPresenter: CopyItemsPresenter?
    let copyItemsView = CopyItemsView()
    
    var searching = false
    
    var searchBar: UISearchBar?
    
    var queryFilter: String?
    
    lazy var emptyView: UIView = {
        let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
       return mv
    }()
    
    lazy var emptyImage = ViewGenerator.getImageView(ImageViewOptions(image: Utility.DefaultEmptyBackground, size: (100, 100)))
    
    lazy var emptyLabel = ViewGenerator.getLabel(LabelOptions(text: "Copied items will show here", color: .systemGray, fontStyle: AppFonts.labelText), LabelInsets(5))

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
  
//        collecionView.reloadData()
//        collecionView.collectionViewLayout.invalidateLayout()
//
//        for cell in self.collecionView?.visibleCells as! [CopyItemCell] {
//            cell.setNeedsLayout()
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        collecionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
       
//        hasRefresh = false
    
//        saveCopyNotification = true
        
        self.title = "ClipStack"
        
        MainCoordinator.shared.toggleNavBarDisplay(hidden: false)
        
        initializePresenter()
        
        UserDefaults.standard.set(Constants.Layout.grid, forKey: Constants.layout)
        
        print(dataFilePath)
        
        MainCoordinator.shared.navigationController?.navigationBar.tintColor = MyColors.primary
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "xmark.bin.fill"), style: .plain, target: self, action: #selector(clearAll)),
            UIBarButtonItem(image: UIImage(systemName: "bolt.shield.fill"), style: .plain, target: self, action: #selector(updateClipStack)),
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLayoutChange), name: .layoutChanged, object: nil)
    
    }
    
    private func initializeViews(){
        view.addSubview(collecionView)
        
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        collecionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collecionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .layoutChanged, object: nil)
    }
    
    @objc func updateClipStack(){
        //Update the CLipStack Queue
        //Check clipboard manually here
        
        copyItemsPresenter?.inspectPasteboard(currentItems: dataSet, completion: { [weak self]done in
            guard let sucess = done, let strongSelf = self else { return }
            
            Utility.showToast(strongSelf, message: "Updated Copy Items", seconds: 1.5)
            
            if sucess == true {
                strongSelf.copyItemsPresenter?.getCopyItems(type: nil)
            }
        })
        
    }
    
    @objc func clearAll(){
        Utility.showAlertController(self, preferredStyle: .actionSheet, confirmTitle: "Confirm - delete items on ClipStack") { [weak self] in
            //Implement delete all here
            print("Delete All")
            
            guard let strongSelf = self else {
                return
            }
            
            for mData in strongSelf.dataSet {
                strongSelf.copyItemsPresenter?.context?.delete(mData)
            }
            
            strongSelf.copyItemsPresenter?.save()
            
            strongSelf.dataSet = []
            strongSelf.dataSetCopy = []
            
            strongSelf.collecionView.reloadData()
            
        }
    }
    
    @objc func handleLayoutChange(){
//        let offset = collecionView.contentOffset

//        collecionView.layoutIfNeeded()
//        collecionView.setContentOffset(offset, animated: true)
//        collecionView.reloadData()
        for cell in self.collecionView?.visibleCells as! [CopyItemCell] {
            cell.setNeedsDisplay()
        }
        
        collecionView.collectionViewLayout.invalidateLayout()
        collecionView.layoutIfNeeded()
    }
    
    @objc func handleFileCopyButton(sender: UIButton){
        copyItemsPresenter?.copyItemToClipboard(copy: getItem(sender.tag))
        Utility.showToast(self, message: "Item Copied", seconds: 1.5)
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (dataSet.count == 0){
            showEmptyState()
        }else{
            hideEmptyState()
        }
        return dataSet.count
    }
    
    private func showEmptyState() {
    
        // new new
        emptyView.addSubview(emptyImage)
        emptyView.addSubview(emptyLabel)
        collecionView.addSubview(emptyView)
        
        emptyView.centerYAnchor.constraint(equalTo: collecionView.centerYAnchor, constant: -collecionView.frame.height * 0.2).isActive = true
        emptyView.centerXAnchor.constraint(equalTo: collecionView.centerXAnchor).isActive = true
        emptyView.widthAnchor.constraint(equalTo: collecionView.widthAnchor, multiplier: 0.8).isActive = true
        emptyView.heightAnchor.constraint(equalTo: collecionView.heightAnchor, multiplier: 0.5).isActive = true
        
        emptyImage.widthAnchor.constraint(equalTo: emptyView.widthAnchor).isActive = true
        emptyImage.heightAnchor.constraint(equalTo: emptyView.heightAnchor).isActive = true
        emptyImage.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        emptyImage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        
        
    }

    private func hideEmptyState() {
        emptyView.removeFromSuperview()
    }
    
    
    func initializePresenter(){
        copyItemsPresenter = CopyItemsPresenter(delegate: self)
        
        copyItemsPresenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        copyItemsPresenter?.getCopyItems(type: nil)
    }
    
    
    override func updatePasteBoardData(){
        guard let presenter = copyItemsPresenter else{
            return
        }
        
        presenter.inspectPasteboard(currentItems: dataSet) { [weak self] success in
            guard let copied = success, let strongSelf = self else {
                return
            }
            
            if copied == true {
                strongSelf.copyItemsPresenter?.getCopyItems(type: nil)
            }
        }
    }
    
    private func setUpSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type text here to search"
        navigationItem.searchController = search
    }
    
    
    
    //MARK: Core Data Code
    
    
    // MARK: Helper functions
    
    override func initializeDefaults() {
        
        setUpSearchController()
        hasTabBar = true
        
        let frame = CGRect(x: 0, y: 0,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        
        mFlowLayout = getFlowLayOut()
        
        collecionView = UICollectionView(frame: frame, collectionViewLayout: mFlowLayout)
        collecionView.backgroundColor = .systemBackground
//        mFlowLayout.headerReferenceSize = CGSize(width: Dimensions.CollectionViewFlowLayoutWidth, height: Dimensions.halfScreenHeight * 0.7)
        
//        emptyView = ViewGenerator.getLabel(LabelOptions(text: "This View is EMpty", color: .systemRed, fontStyle: AppFonts.labelText))
    }
    
    
    override func createOneTimeVariables() {  }
    
    
    override func sizeForItem() -> CGSize {
        let padding = verticalSpacing + 10
        
        let twox2gridEnabled = UserDefaults.standard.string(forKey: Constants.layout)
        
        if (twox2gridEnabled == Constants.Layout.grid){
            return CGSize(width: Dimensions.halfScreenWidth - padding , height: Dimensions.halfScreenWidth - padding)
        }
        
        return CGSize(width: Dimensions.screenSize.width - padding , height: Dimensions.halfScreenWidth - padding)
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
        
        //Set current cell size
        cell.contentView.frame = cell.bounds;
        cell.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let mType = CopyItemType.init(rawValue: mTypeString)
        
        cell.tag = position
        
        if let itemDate = data.dateUpdated {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//            cell.date.text = dateFormatterPrint.string(from: itemDate)
            cell.date.text = itemDate.timeAgoSinceDate()
            cell.date.font = AppFonts.smallLabelText
        }
        
        cell.fileCopyButton.tag = position
        cell.fileCopyButton.addTarget(self, action: #selector(handleFileCopyButton), for: .touchUpInside)
        
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
                            
                            let urlString = String(data: data.content!, encoding: .utf8)!
                           
                            copyItemsPresenter?.fetchMetaData(url: urlString, completion: { metaData in
                                guard let meta = metaData else {
                                    return
                                }
                                cell.linkView.metadata = meta
                                cell.linkView.sizeToFit()
                            })
                
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
        refreshingg = true
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
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if !searchText.isReallyEmpty {
//            let cleanText = searchText.trim()
//            let filtered = dataSet.filter({$0.title!.lowercased().contains(cleanText.lowercased())})
//            replaceAll(itemList: filtered )
//            searching = true
//            notifyChange()
//        } else {
//            replaceAll(itemList: []) //getDefault to replace all with defaullt
//            print(searchText.isReallyEmpty)
//            DispatchQueue.main.async {
////                IQKeyboardManager.shared.resignFirstResponder()
//            }
//        }
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        searching = false
//        replaceAll(itemList: []) //getDefault to replace all with defaullt
////        IQKeyboardManager.shared.resignFirstResponder()
//    }
    
}
