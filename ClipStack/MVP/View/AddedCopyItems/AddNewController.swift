//
//  AddNewController.swift
//  ClipStack
//
//  Created by Chuck on 14/06/2022.
//

import Foundation
import UIKit


class AddNewController: BaseViewController {
    
    let addnew = AddNewView()
    
    lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AddedCoordinator.shared.navigationController?.navigationBar.tintColor = MyColors.primary
        
        navigationController?.navigationBar.tintColor = MyColors.primary
        
        addScrollView()
    
        title = "New Clips"
        
        imagePicker.delegate = self

        initializeView()
        initializeBarButton()
        
        checkImageAccess()
    }
    
    //Fix for IQKeyboardmanager jumping
    private func addScrollView(){
        
        let y = navigationController?.navigationBar.frame.height ?? 0
        
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: y , width: Dimensions.screenSize.width, height: Dimensions.screenSize.height))
        
        scrollView.addSubview(addnew)
        
        scrollView.backgroundColor = .systemBackground
        
        addnew.translatesAutoresizingMaskIntoConstraints = false
        
        addnew.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        addnew.heightAnchor.constraint(equalTo
                                       : scrollView.heightAnchor).isActive = true
        
        view = scrollView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.isHidden = false
       
    }
    
    private func initializeView(){
        addnew.toggle()
        
        addnew.textArea.delegate = self
        addnew.switchControl.addTarget(self, action: #selector(switchCopyItemType), for: .valueChanged)
        
        addnew.uploadBtn.addTarget(self, action: #selector(showImagePickerController), for: .touchUpInside)
    }
    
    func initializeBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCopyItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    private func checkImageAccess(){
        let askedBefore = UserDefaults.standard.bool(forKey: UserDefaultkeys.firstCameraCheck)
        Utility.checkCameraPermissions { [weak self] granted in
            guard let permissions = granted, let strongSelf = self else { return }
            
            if permissions == false && askedBefore == false {
                UserDefaults.standard.setValue(true, forKey: UserDefaultkeys.firstCameraCheck)
                Utility.showSettingsAlert(strongSelf)
            }
        }
    }
    
    @objc func showImagePickerController(){
        Utility.showImagePickerOption(self, imagePicker: imagePicker)
    }
    
    @objc func saveCopyItem(){
        
        let addedPresenter: AddedClipsPresenter = AddedClipsPresenter(delegate: self)
        
        addedPresenter.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var newCopyItem : CopyItemDTO
        
        let (title, content, type, errorMessage) = getCurrentViewValues()
        
        if let err = errorMessage  {
            self.showErrorAlert((title: "Error", message: "Missing Input - \(err)"))
            return
        }
        
        let mDate = Date()
        
        //save data
        newCopyItem = CopyItemDTO(
            color: CopyItemTypeColor.getColor(type: type),
            content: content,
            dateCreated: mDate,
            dateUpdated: mDate,
            id: UUID(),
            keyId: UUID(),  // for short keys - extensions feature
            title: title,   //same as content if text or url, else png for image, els file for pdf
            type: type,
            isAutoCopy: false)
        
        //save
        addedPresenter.save(newCopyItem, completion: { [weak self] success in
            guard let saveSuccess = success, let strongSelf = self else {
                return
            }
            if saveSuccess == true {
                print("Success saving")
                
                strongSelf.dismiss(animated: true) {
                    let userInfo: Dictionary<String, Any> = ["success": true as Any]
                    
                    NotificationCenter.default.post(name: .newClipAdded, object: nil, userInfo: userInfo as [AnyHashable : Any])
                }
            }
        })
    }
    
    @objc func cancel(){
        dismiss(animated: true)
    }
    
    
    @objc func switchCopyItemType ( sender : CustomSwitch) {
        
//        let selected = sender.items[sender.selectedIndex]
        addnew.toggle()
    }
    
    private func getCurrentViewValues() -> ( String?, Data?, CopyItemType?, String? ){
        
        var returnTitle : String?
        
        var returnData : Data?
        
        var returnType : CopyItemType?
        
        if let mTitle = addnew.title.text{
            if mTitle.isReallyEmpty == true {
                return (nil, nil, nil, "Please add a valid title")
            }else{
                returnTitle = mTitle
            }
        }
        
        switch(addnew.switchControl.selectedIndex)  {
            case 0:
                returnType = CopyItemType.text
            case 1:
                returnType = CopyItemType.image
            default:
                returnType = nil
        }
        
        let selectedIndex = addnew.switchControl.selectedIndex
        
        if (selectedIndex == 0){
            
            if (addnew.textArea.text.isReallyEmpty == true){
                return (nil, nil, nil, "Please add valid text")
            }else{
                print(addnew.textArea.text)
                returnData = Data(addnew.textArea.text.utf8)
            }
            
        }else if (selectedIndex == 1){
            if let img = addnew.imageArea.image{
                returnData = img.pngData()
            }else{
                return (nil, nil, nil, "Please add a valid Image")
            }
        }
        
        return (returnTitle, returnData, returnType, nil)
    }
    
}



//MARK:- UITextView Delegates
extension AddNewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 100 {
            textView.text = nil
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text"
            textView.textColor = UIColor.lightGray
        }
    }
}


//MARK:- UITextField Delegates
extension AddNewController: UITextFieldDelegate {
    
    //Stops Users from putting space in user Handle
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 2{
//            if (string == " ") {
//                return false
//            }
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2{
            //set isHidden to true for text field
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            if let title = textField.text{
    
            }
        }
    }
}


extension AddNewController :  UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion:{ [weak self] in
            if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                
                var mImage = image
                
                if mImage.size.width > 1000{
                    mImage = image.resizeImageWith(newSize: CGSize(width: 1000, height: 1000))
                }
                
                if let compressedImageData = mImage.jpeg(UIImage.JPEGQuality.lowest){
                    self?.addnew.imageArea.image = UIImage(data: compressedImageData)
                }
            }
        })
    }
}
