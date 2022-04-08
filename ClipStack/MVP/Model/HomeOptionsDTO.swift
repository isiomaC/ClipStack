//
//  File.swift
//  ClipStack
//
//  Created by Chuck on 06/04/2022.
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
