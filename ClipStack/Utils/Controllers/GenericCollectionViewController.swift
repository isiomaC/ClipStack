//
//  GenericCollectionViewController.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//


import Foundation
import UIKit

class GenericCollectionView<DataItem, DataCell: UICollectionViewCell>: BaseViewController, UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    lazy var swipeRefresh: UIRefreshControl = UIRefreshControl()
    
    var dataSet = [DataItem](), dataSetCopy = [DataItem]()
    
    let edgeMargins: CGFloat = 15
    let cellIdentifier = "cell", headerIdentifier = "header", footerIdentifier = "footer"
    
    var verticalSpacing: CGFloat = 15
    var tabBarOffSet: CGFloat = 120
    
    var hasEdgeMargins = true, hasRefresh = true, appeared = false, hasHeader = false, hasTabBar = false
    
    var collecionView: UICollectionView!
    var mFlowLayout: UICollectionViewFlowLayout!
    
    var emptyView: UILabel!
    
    var progressBar: UIActivityIndicatorView!
    var loading = false
    var refreshingg = true
    var more = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initializeDefaults()
        createOneTimeVariables()
        
//        collecionView.backgroundColor = .systemBlue
        
        collecionView.register(DataCell.self, forCellWithReuseIdentifier: cellIdentifier)
//        collecionView.register(CopyItemHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                               withReuseIdentifier: headerIdentifier)
        
        collecionView.delegate = self
        collecionView.dataSource = self
        
        progressBar.tintColor = .systemBlue
        
        if hasRefresh {
            swipeRefresh.addTarget(self, action: #selector(onSwipeRefresh), for: .valueChanged)
            swipeRefresh.tintColor = .systemGray
            collecionView.addSubview(swipeRefresh)
        }
        
        emptyView.backgroundColor = .systemBackground
        emptyView.textColor = .systemGray
        emptyView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !appeared && !loading {
            appeared = true
            loading = true
            // fetchData()
        }
    }
    
    @objc func onSwipeRefresh() {
        setSwipeRefreshing(true)
        // fetchData()
    }
    
    func getFlowLayOut() -> UICollectionViewFlowLayout {
       
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical
      
       layout.estimatedItemSize = CGSize(width: Dimensions.CollectionViewFlowLayoutWidth, height: Dimensions.screenSize.height * 0.2)
//        // CGSize(width: Dimensions.screenSize.width/2, height: Dimensions.screenSize.height * 0.2)
//       layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -200, right: 10)

        
       layout.minimumInteritemSpacing = 10
        
       return layout
       
    }
    
    func updateCollectionView(_ responseData: [Any], _ key: String) {
        
        didNotifyDataSetChanged(getData(array: responseData))
        
        refreshingg = false
        loading = false
        progressBar.isHidden = true
        setSwipeRefreshing(false)
        
        emptyView.text = "" // Handle Empty View
        emptyView.isHidden = getItemCopyCount() > 0
        
    }
    
    final func setSwipeRefreshing(_ refreshing: Bool) {
        if refreshing {
            more = true
            loading = false
            progressBar.isHidden = false
            emptyView.isHidden = true
        } else if hasRefresh {
            swipeRefresh.endRefreshing()
        }
        refreshingg = refreshing
    }
    
    func didNotifyDataSetChanged(_ dataSet: [DataItem]) {
        if refreshingg {
            replaceAll(itemList: dataSet)
        } else {
            addAll(itemList: dataSet)
        }
    }

    // scrolling
    final func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            // reach bottom
            if !loading {
                loading = true
//                fetchData()
            }
        }
        
        if scrollView.contentOffset.y < 0 {
            // reach top
        }
        
        if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) {
            // not top and not bottom
        }
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
//
//        setupHeaderViews(header: header)
//        return header
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 0)
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DataCell = (collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? DataCell)!
        displayItem(cell, getItem(indexPath.row), indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(getItem(indexPath.row), indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let condif =  UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] elements in
            return self?.buildContextMenu(for: (self?.dataSet[indexPath.row])!)
        }
        
        return condif
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        //tabBarOffSet
        if hasTabBar {
            return UIEdgeInsets(top: 0, left: 0, bottom: (tabBarHeight + tabBarOffSet), right: 0)
        }
        
        return hasEdgeMargins
            ? UIEdgeInsets(top: verticalSpacing, left: 0, bottom: verticalSpacing, right: 0)
            : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    // Functions to Override
    func initializeDefaults() {
        
    }
    
    func buildContextMenu(for: DataItem) -> UIMenu {
        let copy = UIAction(title: "Copy", image: UIImage(systemName: "")) { action in
            //perform action here
        }
        
        return UIMenu(title: "Default", image: nil, children: [copy])
    }
    
    func createOneTimeVariables() {
        
    }
    
    func setupHeaderViews(header: UIView) {
        
    }
    
    func displayItem(_ cell: DataCell, _ data: DataItem, _ position: Int) {
        
    }
    
    func selectItem(_ dataSet: DataItem, _ position: Int) {
        
    }
    
    func getData(array: [Any]) -> [DataItem] {
//        if let mArray = array as? [DataItem] {
//            return mArray
//        }
        return [DataItem]()
    }
}

// Data adapter functions
extension GenericCollectionView {
    
    func notifyChange() {
        dataSetCopy = dataSet
        collecionView.reloadData()
    }
    
    final func add(item: DataItem) {
        dataSet.append(item)
        notifyChange()
    }
    
    final func add(item: DataItem, position: Int) {
        dataSet.insert(item, at: position)
        notifyChange()
    }
    
    final func replace(item: DataItem, position: Int) {
        dataSet[position] = item
        notifyChange()
    }
    
    final func remove(position: Int) {
        dataSet.remove(at: position)
        notifyChange()
    }
    
    final func addAll(itemList: [DataItem]) {
        dataSet.append(contentsOf: itemList)
        notifyChange()
    }
    
    final func replaceAll(itemList: [DataItem]) {
        dataSet = itemList
        notifyChange()
    }
    
    final func getItem(_ position: Int) -> DataItem {
        return dataSet[position]
    }
    
    final func getItemCopy(_ position: Int) -> DataItem {
        return dataSetCopy[position]
    }
    
    final func getItemCount() -> Int {
        return dataSet.count
    }
    
    final func getItemCopyCount() -> Int {
        return dataSetCopy.count
    }
}

extension GenericCollectionView {
    
}
