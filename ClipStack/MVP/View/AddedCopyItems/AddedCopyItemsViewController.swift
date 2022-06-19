//
//  AddedClipsViewController.swift
//  ClipStack
//
//  Created by Chuck on 12/06/2022.
//

import Foundation
import UIKit


class AddedCopyItemsViewController : GenericCollectionView<CopyItem, CopyItemCell>, UISearchResultsUpdating{
    
    var presenter: AddedClipsPresenter? = nil
    
    let addedView = AddedCopyItemsView()
    
    var searchBar: UISearchBar?
    
    var searching = false
    
    override func viewDidLoad() {
        
        updateCellIdentifiers(identifiers: (cell: "addnewcell", header: "addnewheader", footer: "addnewfooter"))
        
        super.viewDidLoad()
        
        self.title = "My Clips"
        saveCopyNotification = true
        
        AddedCoordinator.shared.toggleNavBarDisplay(hidden: false)
        
        initializePresenter()
        initializeViews()
        
        addCreateButton()
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        print(searchText)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializePresenter(){
        presenter = AddedClipsPresenter(delegate: self)
        
        presenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        presenter?.getCopyItems(type: nil)
    }
    
    func  initializeViews(){
//        view = addedView
        
        view.addSubview(collecionView)
    }
    
    private func addCreateButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddNewVC))
    }
    
    @objc func showAddNewVC(){
        
        let nextVC = AddNewController()
        AddedCoordinator.shared.presentVC(self, nextVC)
    }
    
    private func setUpSearchController() {
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type text here to search"
        navigationItem.searchController = search
    }
    
    override func initializeDefaults() {
        
        setUpSearchController()
        hasTabBar = true
        let frame = CGRect(x: 0, y: 0,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        mFlowLayout = getFlowLayOut()
        collecionView = UICollectionView(frame: frame, collectionViewLayout: mFlowLayout)
        collecionView.backgroundColor = .systemBackground
        
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
       
    }
    
    override func sizeForItem() -> CGSize {
        let tt = verticalSpacing + 10
        
        let twox2gridEnabled = false //Add Settings for Grid
        
        if (twox2gridEnabled){
            return CGSize(width: Dimensions.halfScreenWidth - tt , height: Dimensions.halfScreenWidth - tt)
        }
        
        return CGSize(width: Dimensions.screenSize.width - tt , height: Dimensions.halfScreenWidth - tt)
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
            
                    presenter?.fetchMetaData(url: urlString, completion: { metaData in
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
                           
                            presenter?.fetchMetaData(url: urlString, completion: { metaData in
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
                
                break
                
            default: break
            
        }
    }
    
    override func selectItem(_ dataSet: CopyItem, _ position: Int) {
        print(position)

//        let nextVC = DetailsViewController(copyItem: dataSet, sendingInfo: (self, position))
//        MainCoordinator.shared.presentVC(self, nextVC)

    }
    
    override func fetchedDataFromCoreDataDB(data: [CopyItem]) {
        print(data)
        updateCollectionView(data, "blah")
    }
    
    override func buildContextMenuForCell(for copy: CopyItem, indexPath: IndexPath) -> UIMenu {
        guard let mPresenter = presenter else {
            return UIMenu()
        }
        return mPresenter.getMenuConfiguration(copy: copy, indexPath: indexPath)
    }
}


extension AddedCopyItemsViewController: UISearchBarDelegate {
    
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
