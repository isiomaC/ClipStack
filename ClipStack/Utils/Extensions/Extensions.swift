//
//  Extensions.swift
//  ClipStack
//
//  Created by Chuck on 13/03/2022.
//

import Foundation
import UIKit

extension Notification.Name{
    static let onPasteBoardChange = Notification.Name("on-pasteboard-change")
}

// MARK: UIApplication EXTENSIONS
extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}


//MARK: Filemanager
extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.com.chuck.clipstack.contents"
    )!
  }
}


// MARK: UIColor EXTENSIONS
extension UIColor {

     class func color(data:Data) -> UIColor? {
          return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
     }

     func encode() -> Data? {
          return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
     }
}


// MARK: String EXTENSIONS
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}

// MARK: UIViewController
extension UIViewController {
    
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? UIApplication.shared.statusBarView!.frame.height) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func showToast(_ controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
}


extension UISearchBar {
    
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }

    func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }

        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }

    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .medium)
                    newActivityIndicator.color = UIColor.gray
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = textField?.backgroundColor ?? UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero

                    newActivityIndicator.center = CGPoint(x: leftViewSize.width - newActivityIndicator.frame.width / 2,
                                                          y: leftViewSize.height / 2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }

    func changePlaceholderColor(_ color: UIColor) {
        guard let UISearchBarTextFieldLabel: AnyClass = NSClassFromString("UISearchBarTextFieldLabel"),
            let field = textField else {
            return
        }
        for subview in field.subviews where subview.isKind(of: UISearchBarTextFieldLabel) {
            (subview as? UILabel)?.textColor = color
        }
    }

    func setRightImage(normalImage: UIImage,
                       highLightedImage: UIImage) {
        showsBookmarkButton = true
        if let btn = textField?.rightView as? UIButton {
            btn.setImage(normalImage,
                         for: .normal)
            btn.setImage(highLightedImage,
                         for: .highlighted)
        }
    }
    
    func setLeftImage(_ image: UIImage, with padding: CGFloat = 0, tintColor: UIColor) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.tintColor = tintColor

        if padding != 0 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            paddingView.widthAnchor.constraint(equalToConstant: padding).isActive = true
            paddingView.heightAnchor.constraint(equalToConstant: padding).isActive = true
            stackView.addArrangedSubview(paddingView)
            stackView.addArrangedSubview(imageView)
            textField?.leftView = stackView

        } else {
            textField?.leftView = imageView
        }
    }
}

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "mins ago"
        }

        return "a moment ago"
    }
    
    func isNew() -> Bool {
        let fromDate = self

        let toDate = Date()
        
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return false
        }

        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return false
        }

        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return false
        }

        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? true : false
        }

        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return true
        }
        return true
    }
}
