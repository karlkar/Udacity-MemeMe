//
//  ViewController.swift
//  MemeMe
//
//  Created by Ksionek, Karol on 26/07/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    private static let BOTTOM = "BOTTOM"
    private static let TOP = "TOP"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.0
    ]
    
    let topTextFieldDelegate = TextFieldDelegate(initialText: TOP)
    let bottomTextFieldDelegate = TextFieldDelegate(initialText: BOTTOM)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareBtn.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupTextField(topTextField, ViewController.TOP, topTextFieldDelegate)
        setupTextField(bottomTextField, ViewController.BOTTOM, bottomTextFieldDelegate)
        
        subscribeToKeyboardNotifications()
    }
    
    private func setupTextField(_ textField: UITextField, _ title: String, _ delegate: TextFieldDelegate) {
        textField.text = title
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = delegate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImage(_ sender: Any) {
        chooseImageFromCameraOrPhoto(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(.camera)
    }
    
    private func chooseImageFromCameraOrPhoto(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let meme = generateMemedImage()
        let avc = UIActivityViewController(activityItems: [meme], applicationActivities: [])
        avc.completionWithItemsHandler = { activity, completed, items, error in
                    if completed {
                        self.save()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        present(avc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            shareBtn.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isFirstResponder) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() -> Meme {
        return Meme(topText: topTextField.text!,
                    bottomText: bottomTextField.text!,
                    originalImage: imagePickerView.image!,
                    memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        toggleNoiseVisibility(visible: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toggleNoiseVisibility(visible: true)

        return memedImage
    }
    
    private func toggleNoiseVisibility(visible: Bool) {
        toolbar.isHidden = !visible
        navigationBar.isHidden = !visible
    }
}

