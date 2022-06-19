//
//  HomeViewController.swift
//  ClipStack
//
//  Created by Chuck on 04/04/2022.
//

import Foundation
import UIKit
import JavaScriptCore


class HomeViewController: BaseViewController, UISearchResultsUpdating  {

    var abc : String?
    
    let (defaultOptions, copyItemOptions) = HomeOptionsDTO.getOptions()
    
    var homePresenter : HomePresenter?
    
    var tableView: UITableView?
    
    let stubData = [ HomeOptionsDTO(name: "Collections",  image: UIImage(systemName: "folder.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium ))! )]
    
    let cellIdentifier = "menuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initPresenter()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    //MARK: Testing
    func callJavascript(){
        let jsSource = "var read = function() { try{  window.navigator.clipboard.readText().then(clip => consoleLog(clip) ).catch(er => consoleLog(er));   }catch(e){ consoleLog(e) } }"

        //Initialize
        let jsContext = JSContext()
        jsContext?.exceptionHandler = { context, exception in
            if let ex = exception {
                print("JS Exception", ex.toString())
            }
        }
        jsContext?.evaluateScript(jsSource)
        //End Initialize


        //Console Log : Calling swift from jsContext
        let consoleLog: @convention(block) (String) -> Void = { logMessage in
            print("\nJS Console: ", logMessage)
        }
        
        let consoleLogObject = unsafeBitCast(consoleLog, to: AnyObject.self)
        jsContext?.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))

        jsContext?.evaluateScript("consoleLog")
        //end Console Log

        if let copyItemFunc = jsContext?.objectForKeyedSubscript("read") {
            if let result = copyItemFunc.call(withArguments: []) {
                print(result)
            }
        }
    }
    
    private func initPresenter() {
        homePresenter = HomePresenter(delegate: self)
        homePresenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "ClipStack"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        view.isHidden = true
    }
    
    private func initTableView() {
        let frame = CGRect(x: 0, y: 0,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        
        tableView = UITableView(frame: frame, style: .insetGrouped)
        tableView?.register(HomeViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if let table = tableView {
            view.addSubview(table)
        }
    }
    
   
    
}


//Table View Delegate and DataSource Overrides
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var returnVal: String?
        
        if section == 0 {
            returnVal = "History"
        }else if section == 1{
            returnVal = "Type"
        }
        
        return returnVal
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnVal: Int?
        
        if section == 0 {
            returnVal = defaultOptions.count
        }else if section == 1{
            returnVal = copyItemOptions.count
        }
        
        return returnVal!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let option = defaultOptions[indexPath.row]
            
            var nextVC : CoordinatingDelegate
            
            switch option.name {
                case "All":
                
                    nextVC = CopyItemsViewController()
                    (nextVC as? CopyItemsViewController)?.queryFilter = "All"
                    MainCoordinator.shared.pushVC(nextVC)
                    break;
                case "Recents":
                    
                    nextVC = CopyItemsViewController()
                    (nextVC as? CopyItemsViewController)?.queryFilter = "Recents"
                    MainCoordinator.shared.pushVC(nextVC)
                    break;
//                case "Collections":
//                    nextVC = CollectionsViewController()
//                    MainCoordinator.shared.pushVC(nextVC)
//                    break;
                default : break;
            }
            
            
        }else if indexPath.section == 1 {
            let option = copyItemOptions[indexPath.row]
            
            
        }
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var item: HomeOptionsDTO?
        
        if indexPath.section == 0 {
            item = defaultOptions[indexPath.row]
        }else if indexPath.section == 1{
            item = copyItemOptions[indexPath.row]
        }
        
        guard let mItem = item else {
            return UITableViewCell()
        }
    
        cell.textLabel?.text = mItem.name
        
        cell.imageView?.image = mItem.image

        cell.accessoryType = mItem.accessoryType

        return cell
            
    }
    
}
