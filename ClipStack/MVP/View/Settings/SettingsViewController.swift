//
//  SettingsViewController.swift
//  ClipStack
//
//  Created by Chuck on 04/04/2022.
//

import Foundation
import UIKit


class SettingsViewController: BaseViewController {
    
    var settingView = SettingsView()
    
    let (settingsOptionOne, settingsOptionsTwo) = SettingsOptionDTO.getOptions()
    
    var settingsPresenter : SettingsPresenter?
    
    var tableView: UITableView?
    
    let cellIdentifier = "menuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        initTableView()
        initPresenter()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Settings"
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
    
    private func initPresenter() {
        settingsPresenter = SettingsPresenter(delegate: self)
        settingsPresenter?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var returnVal: String?
        
        if section == 0 {
            returnVal = "A"
        }else if section == 1{
            returnVal = "B"
        }else if section == 2 {
            returnVal = "C"
        }
        
        return returnVal
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnVal: Int?
        
        if section == 0 {
            returnVal = settingsOptionOne.count
        }else if section == 1{
            returnVal = settingsOptionsTwo.count
        }else if section == 2{
            returnVal = settingsOptionOne.count
        }
//        else if section == 2 {
//            returnVal = stubData.count
//        }
        
        return returnVal!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let option = settingsOptionOne[indexPath.row]
            
            var nextVC : CoordinatingDelegate
            
            switch option.name {
                case "A":
                
                    nextVC = CopyItemsViewController()
                    (nextVC as? CopyItemsViewController)?.queryFilter = "All"
                    MainCoordinator.shared.pushVC(nextVC)
                    break;
                case "B":
                    
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
            let option = settingsOptionsTwo[indexPath.row]
            
            
        }else if indexPath.section == 2 {
            
            
        }
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var item: SettingsOptionDTO?
        
        if indexPath.section == 0 {
            item = settingsOptionOne[indexPath.row]
        }else if indexPath.section == 1{
            item = settingsOptionsTwo[indexPath.row]
        }
//        else if indexPath.section == 2 {
//            print(indexPath.row)
//            print(indexPath.section)
//            item = stubData[indexPath.row]
//        }
        
        guard let mItem = item else {
            return UITableViewCell()
        }
    
        cell.textLabel?.text = mItem.name
        
        cell.imageView?.image = mItem.image

        cell.accessoryType = mItem.accessoryType

        return cell
            
    }
    
}
