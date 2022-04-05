//
//  HomeViewController.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit
//import CoreData


class HomeViewController: GenericCollectionView<CopyItem, CopyItemCell>{
        
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let pasteboard = UIPasteboard.general
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var homePresenter: HomePresenter?
    let homeView = HomeView()
    
    var searching = false
    
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainCoordinator.shared.toggleNavBarDisplay(hidden: false)
        
        initializePresenter()
        initializeViews()
        title = "ClipStack"
        addCreateButton()
        
        print(dataFilePath)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }
    
    //MARK:- Initialize Views and Presenter
    func initializePresenter(){
        homePresenter = HomePresenter(delegate: self)
        homePresenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        homePresenter?.getCopyItems(type: nil)
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
    
    //MARK:- Copy Update Notifications
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(updatePasteBoard), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func updatePasteBoard(notification: Notification){
        //determine type of data to save
        var newCopyItem : CopyItemDTO
        var type: CopyItemType?
        var content : Data?
        
        if pasteboard.hasStrings || pasteboard.hasURLs{
            
            //decode string
            //String(decoding: data, as: UTF8.self)
            
            //URL and string are stored in pasteboard.string
            guard let saveString = pasteboard.string else{
                return
            }
            
            if saveString.starts(with: "http"){
                type = CopyItemType.url
            }else{
                type = CopyItemType.text
            }
            content = Data(saveString.utf8)
             
        }else if pasteboard.hasImages{
            
            //save Image
            type = CopyItemType.image
            guard let saveImage = pasteboard.image, let mData = saveImage.pngData() else{
                return
            }
            content = mData
            
        }else if pasteboard.hasColors{
            
            type = CopyItemType.color
            guard let saveColor = pasteboard.color, let colorData = saveColor.encode() else{
                return
            }
            content = colorData
            
        }
        
        let mDate = Date()
        //save data
        newCopyItem = CopyItemDTO(color: "systemBlue", content: content, dateCreated: mDate, dateUpdated: mDate, folderId: UUID(), id: UUID(), keyId: UUID(), title: "test_title", type: type)
        
        //in another fucntion, get all saved notes and display
        
        //save
        homePresenter?.save(newCopyItem)
        
        
        print(pasteboard.strings)
        print(pasteboard.images)
        print(pasteboard.urls)
        print(pasteboard.colors)
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
        let frame = CGRect(x: 0, y: UIApplication.shared.statusBarView!.frame.height + searchBar!.frame.height,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        mFlowLayout = getFlowLayOut()
        collecionView = UICollectionView(frame: frame, collectionViewLayout: mFlowLayout)
//        mFlowLayout.headerReferenceSize = CGSize(width: Dimensions.CollectionViewFlowLayoutWidth, height: Dimensions.halfScreenHeight * 0.7)
        
        progressBar = UIActivityIndicatorView(style: .medium)
        emptyView = ViewGenerator.getLabel(LabelOptions(text: "", color: .black, fontStyle: AppFonts.labelText))
    }
    
    override func createOneTimeVariables() {
        hasRefresh = true
    }
    
    override func getData(array: [Any]) -> [CopyItem] {
//        guard let presenter = homePresenter else {
//            return []
//        }
//        return presenter.getDataItems(nil)
        
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
//        cell.label.backgroundColor = .label
        cell.backgroundColor = .systemPink
        
        switch mType{
            case .image:
                print("image")
                cell.hideElement(view: cell.imageArea, isHidden: false)
                cell.hideElement(view: cell.label, isHidden: true)
                cell.imageArea.image = UIImage(data: data.content!)
                break
            case .text, .url:
                print("text or Url")
                if mType == .url {
                    // handle URL with Link View
                    // Display or hide as needed.
//                    print(String(data: data.content!, encoding: .utf8))
                    
                    cell.hideElement(view: cell.imageArea, isHidden: true)
                    cell.label.text = String(data: data.content!, encoding: .utf8)
                }
                
                if mType == .text {
//                    print(String(data: data.content!, encoding: .utf8))
                    cell.hideElement(view: cell.imageArea, isHidden: true)
                    cell.label.text = String(data: data.content!, encoding: .utf8)
                }
                
                break
            case .color:
                print("color")
                cell.hideElement(view: cell.label, isHidden: true)
                break
                
            default: break
            
        }
    }
    
    override func selectItem(_ dataSet: CopyItem, _ position: Int) {
        print(position)
    }
    
    override func fetchedDataFromCoreDataDB(data: [CopyItem]) {
        print(data)
        updateCollectionView(data, "testKey")
    }
    
}




extension HomeViewController: UISearchBarDelegate {
    
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