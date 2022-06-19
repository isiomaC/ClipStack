//
//  Constants.swift
//  ClipStack
//
//  Created by Chuck on 12/03/2022.
//

import Foundation
import UIKit

struct Dimensions {
    static let screenSize = UIScreen.main.bounds
    static let halfScreenHeight = screenSize.height * 0.5
    static let halfScreenWidth = screenSize.width * 0.5
    static let CollectionViewFlowLayoutWidth = Dimensions.screenSize.width - 30 //Sets Margins for collectionView
}


struct UserDefaultkeys {
    static let firstCameraCheck = "FirstCameraAccessCheck"
    static let isFirstLaunch = "isFirstLaunch"
    static let isSubscribed = "UserSubscribed"
    static let isAuthenticated = "UserAuthenticated"
    static let reviewWorthyCount = "reviewWorthyCount"
    static let lastReviewRequestAppVersion = "lastReviewedVersion"
}

struct BackgroundIds{
    static let appRefresh = "com.chuck.ClipStack.appRefresh"
    static let bgCopy = "com.chuck.ClipStack.backgroundCopy"
}


struct AppFonts {
    static let loginLandingText = Font(type: .systemBold, size: .custom(40)).instance
    static let textField = Font(type: .system, size: .custom(16.0)).instance
    
    static let loginTitle = Font(size: .custom(20)).instance
    static let loginForgotPwd = Font(type: .systemBold, size: .custom(16.0)).instance
    
    
    static let smallLabelText = Font(type: .system, size: .custom(14.0)).instance
    static let labelText = Font(type: .system, size: .custom(16.0)).instance
    
    static let buttonFont = Font(type: .system, size: .custom(16.0)).instance
    
}
