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
    
    lazy var emptyView: UIView = {
        let mv = UIView()
        mv.translatesAutoresizingMaskIntoConstraints = false
       return mv
    }()
    
    lazy var emptyImage = ViewGenerator.getImageView(ImageViewOptions(image: Utility.DefaultEmptyBackground, size: (100, 100)))
    
    lazy var emptyLabel = ViewGenerator.getLabel(LabelOptions(text: "Use plus button to add clips manually", color: .systemGray, fontStyle: AppFonts.labelText), LabelInsets(5))
    
    
    override func viewDidLoad() {
//
//        self.navigationController!.hidesBarsOnSwipe = false
        
        updateCellIdentifiers(identifiers: (cell: "addnewcell", header: "addnewheader", footer: "addnewfooter"))
        
        super.viewDidLoad()
        
        initializeViews()
        
        self.title = "My Clips"
//        saveCopyNotification = true
        
        AddedCoordinator.shared.toggleNavBarDisplay(hidden: false)
        
        AddedCoordinator.shared.navigationController?.navigationBar.tintColor = MyColors.primary
        
        initializePresenter()
        
        
        addCreateButton()
      
       
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
                
                guard let ctype = copyItem.type,
                        let type = CopyItemType.init(stringValue: ctype),
                        let copyItemContent = copyItem.content else{
                    return false
                }
                
                if (type == CopyItemType.text || type == CopyItemType.url){
                    guard let stringContent = String(data: copyItemContent, encoding: .utf8) else {
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
    
    func initializeViews(){
//        view = collecionView
        view.addSubview(collecionView)
        
        collecionView.translatesAutoresizingMaskIntoConstraints = false
        collecionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collecionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        initializeViews()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
  
//        collecionView.collectionViewLayout.invalidateLayout()
//        
//        for cell in self.collecionView?.visibleCells as! [CopyItemCell] {
//            cell.setNeedsLayout()
//        }
        
    }
    
    //MARK: Views and Presenter
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSet.count == 0{
            showEmptyState()
        }else{
            hideEmptyState()
        }
        return dataSet.count
    }
    
    private func showEmptyState() {
        
        //new
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
        
//        emptyView.backgroundColor = .systemPink
        
       
        
    }

    private func hideEmptyState() {
        emptyView.removeFromSuperview()
    }
    
    
    func initializePresenter(){
        presenter = AddedClipsPresenter(delegate: self)
        
        presenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        presenter?.getCopyItems(type: nil)
    }
    
    
    
    private func addCreateButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddNewVC))
    }
    
    
    private func setUpSearchController() {
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type text here to search"
        navigationItem.searchController = search
    }
    //
    
    
    //MARK: Objc Functions
    @objc func showAddNewVC(){
        
        let nextVC = AddNewController()
        AddedCoordinator.shared.presentVC(self, nextVC)
    }
    
    @objc func handleNewClipAdded(_ notification: Notification){
        presenter?.getCopyItems(type: nil)
//        if let success = notification.userInfo?["profile"] as? Bool{
//        }
    }
    
    @objc func handleLayoutChange(){
//        collecionView.reloadData()
//        collecionView.collectionViewLayout.invalidateLayout()
//
//        for cell in self.collecionView?.visibleCells as! [CopyItemCell] {
//            cell.setNeedsDisplay()
//        }
        
        collecionView.collectionViewLayout.invalidateLayout()
        collecionView.layoutIfNeeded()
        
        for cell in self.collecionView?.visibleCells as! [CopyItemCell] {
            cell.setNeedsDisplay()
        }
    }
    
    @objc func handleFileCopyButton(sender: UIButton){
        presenter?.copyItemToClipboard(copy: getItem(sender.tag))
        Utility.showToast(self, message: "Copied", seconds: 1.5)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newClipAdded, object: nil)
        NotificationCenter.default.removeObserver(self, name: .layoutChanged, object: nil)
    }
    
    override func initializeDefaults() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewClipAdded(_:)), name: .newClipAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLayoutChange), name: .layoutChanged, object: nil)
        
        setUpSearchController()
        
        hasTabBar = true
        let frame = CGRect(x: 0, y: 0,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        mFlowLayout = getFlowLayOut()
        collecionView = UICollectionView(frame: frame, collectionViewLayout: mFlowLayout)
        collecionView.backgroundColor = .systemBackground
        
//        progressBar = UIActivityIndicatorView(style: .medium)
//        emptyView = ViewGenerator.getLabel(LabelOptions(text: "", color: .black, fontStyle: AppFonts.labelText))
    }
    
    override func createOneTimeVariables() {
//        hasRefresh = true
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
        let padding = verticalSpacing + 10
        
        let twox2gridEnabled = UserDefaults.standard.string(forKey: Constants.layout)
        
        if (twox2gridEnabled == Constants.Layout.grid){
            return CGSize(width: Dimensions.halfScreenWidth - padding , height: Dimensions.halfScreenWidth - padding)
        }
        
        return CGSize(width: Dimensions.screenSize.width - padding , height: Dimensions.halfScreenWidth - padding)
    }
    
    override func displayItem(_ cell: CopyItemCell, _ data: CopyItem, _ position: Int) {
        
        guard let mTypeString = data.type, let dataContent = data.content else {
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
            
            cell.date.text = itemDate.timeAgoSinceDate()
            cell.date.font = AppFonts.smallLabelText
        }
        
        cell.fileCopyButton.tag = position
        cell.fileCopyButton.addTarget(self, action: #selector(handleFileCopyButton), for: .touchUpInside)
        
        switch mType{
            case .image:
                print("image")
                
                cell.show(view: cell.imageArea)
               
                cell.imageArea.image = UIImage(data: dataContent)
                break
            case .text, .url:
                
                if mType == .url {
                    cell.show(view: cell.containerLinkView)
                   
//                     handle URL with Link View
                    let urlString = String(data: dataContent, encoding: .utf8)!
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
                    if let contentString = String(data: dataContent, encoding: .utf8){
                        if contentString.starts(with: "http"){
                            cell.show(view: cell.containerLinkView)
//                            cell.containerLinkView.backgroundColor = .red
                            
                            let urlString = String(data: dataContent, encoding: .utf8)!
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

        let nextVC = DetailsViewController(copyItem: dataSet, sendingInfo: (self, position))
        AddedCoordinator.shared.presentVC(self, nextVC)

    }
    
    override func fetchedDataFromCoreDataDB(data: [CopyItem]) {
        print(data)
        refreshingg = true
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
