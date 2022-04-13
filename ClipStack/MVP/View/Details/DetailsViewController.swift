//
//  DetailsViewController.swift
//  ClipStack
//
//  Created by Chuck on 13/04/2022.
//

import Foundation
import UIKit


class DetailsViewController : UIViewController {
    
    var copyItem: CopyItem?
    
    init(copyItem: CopyItem) {
        self.copyItem = copyItem
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
