//
//  NewHomeVC.swift
//  ClipStack
//
//  Created by Chuck on 04/04/2022.
//

import Foundation
import UIKit

class NewHomeVC: UITableViewController {
    
    var abc : String?
    
    let defaultOptions: [String] = ["All", "Recents", "Collections"]
    
    let copyItemOptions: [String] = [CopyItemType.text.rawValue, CopyItemType.image.rawValue, CopyItemType.url.rawValue, CopyItemType.color.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}
