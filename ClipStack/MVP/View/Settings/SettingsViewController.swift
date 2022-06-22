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
    
    let cellIdentifier = "settingsCell"

    var mText: String = UserDefaults.standard.string(forKey: Constants.layout) ?? Constants.Layout.row
    
    var clearDuration: Int = UserDefaults.standard.integer(forKey: Constants.clearAfter)
    
    let pickerOptions = [1, 5, 12, 24, 48]
    
    lazy var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        initTableView()
        initPresenter()
        
        picker.delegate = self
        picker.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: .pickerValueSelected, object: nil)
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .pickerValueSelected, object: nil)
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
        tableView?.register(SettingsTableCell.self, forCellReuseIdentifier: cellIdentifier)
        
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
    
    private func toggleLayout(indexPath: IndexPath){
        mText = mText == Constants.Layout.row ? Constants.Layout.grid : Constants.Layout.row
        updateTableCell(indexPath: indexPath)
    }
    

    private func updateTableCell(indexPath: IndexPath) {
        tableView?.beginUpdates()
        
        //insert new rows to tableView
        tableView?.deleteRows(at: [indexPath], with: .automatic)
        tableView?.insertRows(at: [indexPath], with: .automatic)
        tableView?.endUpdates()
    }
    
    private func handleClearAfterDuration(_ indexPath: IndexPath){
        if let cell = tableView?.cellForRow(at: indexPath) as? SettingsTableCell {
            if !cell.isFirstResponder {
                _ = cell.becomeFirstResponder()
              
                // Set for Notification.Name.pickerValueSelected, to know what indexPath to updated after setting picker value
                // Will be deleted in the reloadTable function for clean up
                UserDefaults.standard.set(indexPath.section, forKey: Constants.indexPathSection)
                UserDefaults.standard.set(indexPath.row, forKey: Constants.indexPathRow)
            }
        }
    }
    
    @objc func reloadTable(_ notification: Notification){
        let row = UserDefaults.standard.integer(forKey: Constants.indexPathRow)
        let section = UserDefaults.standard.integer(forKey: Constants.indexPathSection)
        
        let currentIndexPath = IndexPath(row: row, section: section)
        updateTableCell(indexPath: currentIndexPath)
    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsOptionDTO.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var returnVal: String?
        
        if section == 0 {
            returnVal = SettingsOptionDTO.sections[section]
        }else if section == 1{
            returnVal = SettingsOptionDTO.sections[section]
        }
        
        return returnVal
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnVal: Int?
        
        if section == 0 {
            returnVal = settingsOptionOne.count
        }else if section == 1{
            returnVal = settingsOptionsTwo.count
        }
        
        return returnVal!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let option = settingsOptionOne[indexPath.row]
            
            switch option.name {
                case Constants.autoCopy:
                    print("auto copy")
                    break;
                case Constants.layout:
                    toggleLayout(indexPath: indexPath)
                    UserDefaults.standard.set(mText, forKey: Constants.layout)
                    NotificationCenter.default.post(name: .layoutChanged, object: nil, userInfo: nil)
                    break;
                case Constants.clearAfter:
                    handleClearAfterDuration(indexPath)
                    break;
                default : break;
            }
            
        }else if indexPath.section == 1 {
            
            let option = settingsOptionsTwo[indexPath.row]
            
            switch option.name {
                case Constants.shareWithFriend:
                    print("share with friends")
                    break;
                case Constants.rateUs:
                    print("rate us")
                    break;
                case Constants.contactUs:
                    print("Contact Us")
                    break;
                case Constants.privacyPolicy:
                    print("Privacy")
                    break;
                case Constants.termsUse:
                    print("terms")
                    break;
                case Constants.version:
                    print("Version")
                    break;
                default : break;
            }
            
        }
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var item: SettingsOptionDTO?
        
        if indexPath.section == 0 {
            
            item = settingsOptionOne[indexPath.row]
            
            guard let mItem = item else {
                return UITableViewCell()
            }
            
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = mItem.name
                content.image = mItem.image
                cell.contentConfiguration = content
                
            } else {
                cell.textLabel?.text = mItem.name
                cell.imageView?.image = mItem.image
            }
            
            if indexPath.row == 0{
                
                lazy var mSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
                mSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
                cell.accessoryView = mSwitch
            }else if indexPath.row == 1 {
                
                lazy var mLayoutTextView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 100))
                lazy var mLayoutText = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 100))
                
                mLayoutTextView.addSubview(mLayoutText)
                mLayoutText.text = mText
                cell.accessoryView = mLayoutTextView
            }else if indexPath.row == 2{
               
                lazy var mLayoutTextView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 100))
                lazy var mLayoutText = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 100))
                
                mLayoutTextView.addSubview(mLayoutText)
                mLayoutText.text = String(UserDefaults.standard.integer(forKey: Constants.clearAfter))
                
                cell.accessoryView = mLayoutTextView
            }

            cell.selectionStyle = .none

        }else if indexPath.section == 1{
            item = settingsOptionsTwo[indexPath.row]
            
            guard let mItem = item else {
                return UITableViewCell()
            }

            cell.textLabel?.text = mItem.name
            
            cell.imageView?.image = mItem.image

            cell.accessoryType = mItem.accessoryType
            
            cell.selectionStyle = .none
        }

        return cell
            
    }

    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        UserDefaults.standard.set(value, forKey: Constants.autoCopy)
    }
    
}


extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerOptions[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set( pickerOptions[row] ,forKey: Constants.clearAfter)
    }
}

//    func didFinishLoadNewUsers(newUsers: [User]) {
//        tableView.beginUpdates()
//
//        //array of index paths for new rows at the bottom
//        var indexPaths = [NSIndexPath]()
//        for row in (currentUsers.count..<(currentUsers.count + newUsers.count)) {
//          indexPaths.append(NSIndexPath(forRow: row, inSection: 0))
//        }
//
//        //update old data
//        currentUsers.appendContentsOf(newUsers)
//
//        //insert new rows to tableView
//        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//        tableView.endUpdates()
//    }
