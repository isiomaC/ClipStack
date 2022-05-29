//
//  PasteBoardManager.swift
//  ClipStack
//
//  Created by Chuck on 06/05/2022.
//

import Foundation
import UIKit

class PasteBoardManager{
    
    private let pasteboard = UIPasteboard.general
    
    public var mPasteBoard: UIPasteboard {
        get{
            return pasteboard
        }
    }

    // Used to regularly poll the pasteboard for changes.
    private var timer: Timer?
    
    // Keep track of the changes in the pasteboard.
    var currentChangeCount: Int = 0
    
    private var numberOfItem : Int
    
    private var types: [String]
    
    private var pasteBoardItems: [[String:Any]]
    
    //MARK: - Singletion
    private static var instance: PasteBoardManager?
    static let shared: PasteBoardManager = {
        if PasteBoardManager.instance == nil {
            PasteBoardManager.instance = PasteBoardManager()
        }
        return PasteBoardManager.instance!
    }()
    //MARK: - End Singleton

    
    func updateChangeCount(){
        if currentChangeCount == 0 || currentChangeCount <= pasteboard.changeCount {
            currentChangeCount = pasteboard.changeCount
        }
    }
    
    init() {
        // On launch, we mirror the pasteboard context.
        currentChangeCount = pasteboard.changeCount
        numberOfItem = pasteboard.numberOfItems
        
        types = pasteboard.types
        
        pasteBoardItems = pasteboard.items
    }

    
    
}
