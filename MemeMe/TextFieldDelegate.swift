//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Ksionek, Karol on 26/07/2021.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var initialText: String
    
    init(initialText: String) {
        self.initialText = initialText
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == initialText) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
