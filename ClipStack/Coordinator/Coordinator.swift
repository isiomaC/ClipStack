//
//  Coordinator.swift
//  Common
//
//  Created by Chuck on 23/07/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    var children: [Coordinating]? { get set }
    
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
