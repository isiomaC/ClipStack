//
//  Utility.swift
//  ClipStack
//
//  Created by Chuck on 17/06/2022.
//

import Foundation
import AVFoundation
import UIKit
import SafariServices
import StoreKit

struct Utility {
    
    static var DefaultEmptyBackground: UIImage {
        get{
            return UIImage(named: "empty_bg.png")!
        }
    }
    
    static var DefaultProfileURL : String{
        get{
            let value = Utility.readFromPList("Config", key: "DEFAULT_PROFILE_AVATAR")
            return value
        }
    }
    
    static var getDefaultBg : UIImage{
        get{
            return UIImage(named: "AuthBgImage")!
        }
    }
    
    
    // MARK: Useful web Routes
    
    static var IAPProductId: String {
        get{
            let value = Utility.readFromPList("Config", key: "IAPProductId")
            return value
        }
    }
    
    static var apiRoute : String {
        get{
            let value = Utility.readFromPList("Config", key: "apiRoute")
            return value
        }
    }
    
    
    static var webRoute : String {
        get{
            let value = Utility.readFromPList("Config", key: "webRoute")
            return value
        }
    }
    
    static var appStoreUrl : String {
        get{
            let value = Utility.readFromPList("Config", key: "appStoreUrl")
            return value
        }
    }
    
    
    static var privacyPolicyUrl : String {
        get{
            let value = Utility.readFromPList("Config", key: "privacyPolicy")
            return value
        }
    }

    static var termsAppleEula : String {
        get{
            let value = Utility.readFromPList("Config", key: "termsEULA")
            return value
        }
    }
    

    static func rateApp() {
        let appId = "1635426351"
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + appId) {
//            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
        }
    }
    
    static func shareExternal(controller: BaseViewController, itemToShare: AnyObject){
       
        let sheet = UIActivityViewController(activityItems: [itemToShare as Any], applicationActivities: nil)
        
        controller.present(sheet, animated: true, completion: nil)
        
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
    }
    
    
    
    static func showSafariLink(_ viewController: UIViewController, pageRoute: String){
//        let urlString = pageRoute == "terms" ? appleEula : "\(web_url)\(pageRoute).html"
      
//        let urlString : String = ""
        
        guard let url = URL(string: pageRoute ) else { return }
        let vc = SFSafariViewController(url: url)
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func showImagePickerOption(_ viewController: UIViewController, imagePicker: UIImagePickerController){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            checkCameraPermissions { success in
                guard let permissionGranted = success else { return }
                if permissionGranted {
                    DispatchQueue.main.async {
                        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                            imagePicker.sourceType = .savedPhotosAlbum
                            imagePicker.allowsEditing = false

                            viewController.present(imagePicker, animated: true, completion: nil)
                        }
                    }
                }else{
                    showSettingsAlert(viewController, for: "Camera")
                }
            }
        }
        
        let camera = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            
            checkCameraPermissions { success in
                guard let permissionGranted = success else { return }
                if permissionGranted {
                    DispatchQueue.main.async {
                        if UIImagePickerController.isSourceTypeAvailable(.camera){

                            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                            imagePicker.sourceType = .camera
                            imagePicker.allowsEditing = false

                            viewController.present(imagePicker, animated: true, completion: nil)
                        }
                    }
                }else{
                    showSettingsAlert(viewController, for: "Camera")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func checkCameraPermissions(completion: @escaping(Bool?) -> Void){
        var permissionGranted : Bool? = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                permissionGranted = false
                completion(permissionGranted)
            case .restricted:
                permissionGranted = false
                completion(permissionGranted)
            case .authorized:
                permissionGranted = true
                completion(permissionGranted)
            case .notDetermined:
               AVCaptureDevice.requestAccess(for: .video) { success in
                    if success{
                        completion(success)
                    }else{
                        completion(success)
                    }
               }
            @unknown default:
                permissionGranted = nil
                completion(permissionGranted)
        }
    }
    
    static func getHex(_ str: String) -> UInt64?{
        let data = Data(str.utf8)
        let hexString = data.map{ String(format:"%02x", $0) }.joined()

        // Int(_, radix: ) can't deal with the '0x' prefix. NSScanner can handle hex
        // with or without the '0x' prefix
        let scanner = Scanner(string: hexString)
        var value: UInt64 = 0

        if scanner.scanHexInt64(&value) {
           return value
//            print("Hex: 0x\(String(value, radix: 16))")
        }
        return nil
    }
    
    static func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
    static func readFromPList(_ filename: String, key: String) -> String{
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "plist") else {
          fatalError("Couldn't find file '\(filename).plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in '\(filename).plist'.")
        }
        return value
    }
    
    static func writeToPList(_ filename: String, key: String, value: String){
        
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "plist") else {
            return //throw
        }
        let plist = NSDictionary(contentsOfFile: filePath)
//        var oldValue = plist?.object(forKey: key)
//        oldValue = value
        plist?.setValue(value, forKey: key)
        plist?.write(toFile: filePath, atomically: true)
        
    }
    
    static func checkAudioPermissions(_ completion: @escaping(Bool?) -> Void){
        var permissionGranted : Bool? = false
        switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                permissionGranted = true
                completion(permissionGranted)
            case .denied:
                permissionGranted = false
                completion(permissionGranted)
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    if granted{
                        completion(granted)
                    }else{
                        completion(granted)
                    }
                })
            @unknown default:
                permissionGranted = nil
                completion(permissionGranted)
        }
    }
    
    static func showAlertController(_ viewController: UIViewController, preferredStyle: UIAlertController.Style, confirmTitle: String = "Confirm", confirmAction: @escaping () -> Void){
        
        let alertController = UIAlertController (title: nil, message: nil, preferredStyle: preferredStyle)

        let confirm = UIAlertAction(title: confirmTitle, style: .default) { (_) -> Void in
            confirmAction()
        }
        alertController.addAction(confirm)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancel)
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showSettingsAlert(_ viewController: UIViewController, for type: String = ""){
        
        let title: String = "Camera"
        let body: String = "ClipStack does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        //%@ does not have access to your camera. To enable access, tap settings and turn on Camera.
        //To join a room, %@ needs access to your iPhone???s microphone. Tap on Settings and turn on Microphone.
        //${PRODUCT_NAME} - Allow access access to camera and photos to set profile avatar
        
        let alertController = UIAlertController (title: title, message: body, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)

        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showToast(_ viewController: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = .systemPurple
        alert.view.alpha = 1
        alert.view.layer.cornerRadius = 15

        viewController.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}

