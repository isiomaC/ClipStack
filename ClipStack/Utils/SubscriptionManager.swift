//
//  SubscriptionManager.swift
//  ClipStack
//
//  Created by Chuck on 10/07/2022.
//

import Foundation

class SubscriptionManager{
    
    enum Plan{
        case pro
        case basic
    }
    
    //store for allowed features
    let planDetails : [Plan: [String]] = [
        .pro: [" ", " "],
        .basic: [" ", " "]
    ]
    
    var isSubscribed: Bool {
        get{
            return UserDefaults.standard.bool(forKey: UserDefaultkeys.isSubscribed)
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultkeys.isSubscribed)
        }
    }
    
    //MARK: - Singletion
    private static var instance: SubscriptionManager?
    static let shared: SubscriptionManager = {
        if SubscriptionManager.instance == nil {
            SubscriptionManager.instance = SubscriptionManager()
        }
        return SubscriptionManager.instance!
    }()
    
    init() {
        
    }

    func getSubPlan() -> Plan {
        
        let subscribed = UserDefaults.standard.bool(forKey: UserDefaultkeys.isSubscribed)
        
        if subscribed {
            return .pro
        }
        
        return .basic
    }
    
    
}
