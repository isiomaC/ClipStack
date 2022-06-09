//
//  File.swift
//  ClipStack
//
//  Created by Chuck on 30/05/2022.
//

import Foundation
import UIKit

struct SettingsOptionDTO{
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
    
    static func getOptions() -> ([SettingsOptionDTO], [SettingsOptionDTO]) {
        
        let iconCOnfiguration = UIImage.SymbolConfiguration(scale: .medium )
        
        let settingsOptionsOne: [SettingsOptionDTO] = [
            SettingsOptionDTO(name: "All", image: UIImage(systemName: "app.fill", withConfiguration: iconCOnfiguration)! ),
            SettingsOptionDTO(name: "Recents",  image: UIImage(systemName: "clock.arrow.circlepath", withConfiguration: iconCOnfiguration)! ),
        ]
        
        let settingsOptionsTwo: [SettingsOptionDTO] = [
            SettingsOptionDTO(name: CopyItemType.text.rawValue.capitalizingFirstLetter(), image: UIImage(systemName: "captions.bubble.fill", withConfiguration: iconCOnfiguration)!),
            SettingsOptionDTO(name: CopyItemType.image.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "camera.fill.badge.ellipsis", withConfiguration: iconCOnfiguration)! ),
//            SettingsOptionDTO(name: CopyItemType.url.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "network", withConfiguration: iconCOnfiguration)! ),
//            SettingsOptionDTO(name: CopyItemType.color.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "capsule.fill", withConfiguration: iconCOnfiguration)! ),
        ]
        
        return (settingsOptionsOne, settingsOptionsTwo)
    }
}
