//
//  NewHomeVC.swift
//  ClipStack
//
//  Created by Chuck on 04/04/2022.
//

import Foundation
import UIKit


struct HomeOptionsDTO {
    let name: String
    let nameTint: UIColor
    let image: UIImage
    let imageTint: UIColor
    let accessoryType : UITableViewCell.AccessoryType
    
    init(name: String, nameTint: UIColor = .darkText, image: UIImage, imageTint: UIColor = .darkText, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.name = name
        self.nameTint = nameTint
        self.image = image
        self.imageTint = imageTint
        self.accessoryType = accessoryType
    }
    
    static func getOptions() -> ([HomeOptionsDTO], [HomeOptionsDTO]) {
        
        let defaultOptions: [HomeOptionsDTO] = [
            HomeOptionsDTO(name: "All", image: UIImage(systemName: "book")! ),
            HomeOptionsDTO(name: "Recents",  image: UIImage(systemName: "book")! ),
            HomeOptionsDTO(name: "Collections",  image: UIImage(systemName: "book")! ),
        ]
        
        let copyItemOptions: [HomeOptionsDTO] = [
            HomeOptionsDTO(name: CopyItemType.text.rawValue.capitalizingFirstLetter(), image: UIImage(systemName: "book")! ),
            HomeOptionsDTO(name: CopyItemType.image.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "book")! ),
            HomeOptionsDTO(name: CopyItemType.url.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "book")! ),
            HomeOptionsDTO(name: CopyItemType.color.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "book")! ),
        ]
        
        return (defaultOptions, copyItemOptions)
    }
}


class HomeViewController: UITableViewController {
    
    var abc : String?
    
    let (defaultOptions, copyItemOptions) = HomeOptionsDTO.getOptions()
    
    let cellIdentifier = "menuCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
        tableView.register(HomeViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        self.title = "ClipStack"
        
        
        
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
        let frame = CGRect(x: 0, y: UIApplication.shared.statusBarView!.frame.height,
                           width: Dimensions.screenSize.width, height: Dimensions.screenSize.height)
        
        tableView = UITableView(frame: frame, style: .insetGrouped)
    }
    
}


//Table View Overrides
extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "History" : "Type"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? defaultOptions.count : copyItemOptions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                case "Collections":
                    nextVC = CollectionsViewController()
                    MainCoordinator.shared.pushVC(nextVC)
                    break;
                default : break;
            }
            
            
        }else if indexPath.section == 1 {
            let option = copyItemOptions[indexPath.row]
            
            
        }
        print(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let item = indexPath.section == 0 ? defaultOptions[indexPath.row] : copyItemOptions[indexPath.row]
    
        cell.textLabel?.text = item.name
        
        cell.imageView?.image = item.image

        cell.accessoryType = item.accessoryType

        return cell
            
    }
    
}
