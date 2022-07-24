//
//  ErrorHandler.swift
//  ClipStack
//
//  Created by Chuck on 22/07/2022.
//

import Foundation
import UIKit

struct ErrorHandler {
    static func showError(_ viewController: UIViewController?, title: String = "", error: String = ""){
        if error == ""{
            //MARK:-- Add Localized Generic error
            let genericError = (title: "Error", message: "Something went wrong!")
            DispatchQueue.main.async {
                viewController?.showErrorAlert(genericError)
            }
        }else{
            let errorTuple = (title: title, message: error)
            DispatchQueue.main.async {
                viewController?.showErrorAlert(errorTuple)
            }
        }
    }
}
