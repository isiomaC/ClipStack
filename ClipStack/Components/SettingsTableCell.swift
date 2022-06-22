//
//  SettingsTableCell.swift
//  ClipStack
//
//  Created by Chuck on 22/06/2022.
//

import Foundation
import UIKit

class SettingsTableCell: UITableViewCell{
    
    lazy var picker = UIPickerView()
    let pickerOptions = [1, 5, 12, 24, 48]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        picker.delegate = self
        picker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }

    open override var canResignFirstResponder: Bool {
        return true
    }

    open override var inputView: UIView? {
        return picker
    }
}

extension SettingsTableCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerOptions[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set( pickerOptions[row] ,forKey: Constants.clearAfter)
        resignFirstResponder()
        NotificationCenter.default.post(name: .pickerValueSelected, object: nil)
    }
}
