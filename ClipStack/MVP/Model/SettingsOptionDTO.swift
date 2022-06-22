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
    
    static var sections: [String] {
        return ["SETTINGS", "INFO"]
    }
    
    static func getOptions() -> ([SettingsOptionDTO], [SettingsOptionDTO]) {
        
        let iconCOnfiguration = UIImage.SymbolConfiguration(scale: .medium )
        
        let settingsOptionsOne: [SettingsOptionDTO] = [
            SettingsOptionDTO(name: Constants.autoCopy, image: UIImage(systemName: "app.fill", withConfiguration: iconCOnfiguration)! ),
            SettingsOptionDTO(name: Constants.layout,  image: UIImage(systemName: "clock.arrow.circlepath", withConfiguration: iconCOnfiguration)! ),
            SettingsOptionDTO(name: Constants.clearAfter,  image: UIImage(systemName: "clock.arrow.circlepath", withConfiguration: iconCOnfiguration)! ),
            
        ]
        
        let settingsOptionsTwo: [SettingsOptionDTO] = [
            SettingsOptionDTO(name: Constants.shareWithFriend,  image: UIImage(systemName: "camera.fill.badge.ellipsis", withConfiguration: iconCOnfiguration)! ), // sharesheet with app id copied over
            SettingsOptionDTO(name: Constants.rateUs, image: UIImage(systemName: "captions.bubble.fill", withConfiguration: iconCOnfiguration)!),  //open review on app store
            SettingsOptionDTO(name: Constants.contactUs,  image: UIImage(systemName: "camera.fill.badge.ellipsis", withConfiguration: iconCOnfiguration)! ),
            SettingsOptionDTO(name: Constants.privacyPolicy,  image: UIImage(systemName: "camera.fill.badge.ellipsis", withConfiguration: iconCOnfiguration)! ),
            SettingsOptionDTO(name: Constants.termsUse,  image: UIImage(systemName: "camera.fill.badge.ellipsis", withConfiguration: iconCOnfiguration)! ),
            SettingsOptionDTO(name: Constants.version,  image: UIImage(systemName: "camera.fill.badge.ellipsis", withConfiguration: iconCOnfiguration)! ),
//            SettingsOptionDTO(name: CopyItemType.url.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "network", withConfiguration: iconCOnfiguration)! ),
//            SettingsOptionDTO(name: CopyItemType.color.rawValue.capitalizingFirstLetter(),  image: UIImage(systemName: "capsule.fill", withConfiguration: iconCOnfiguration)! ),
        ]
        
        return (settingsOptionsOne, settingsOptionsTwo)
    }
}
