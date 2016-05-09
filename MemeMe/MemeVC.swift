//
//  MemeVC.swift
//  MemeMe
//
//  Created by James Dyer on 5/8/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

struct Meme {
    
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}

class MemeVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumsButton: UIBarButtonItem!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var mememeLabel: UILabel!
    
    //Properties
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor() ,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.0
    ]
    let defaultTop: String = "TOP"
    let defaultBottom: String = "BOTTOM"
    
    var currentImage: UIImage!
    var memedImage: UIImage!
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityButton.enabled = false
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //Actions
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        presentImagePicker(.Camera)
    }
   
    @IBAction func albumsButtonPressed(sender: AnyObject) {
        presentImagePicker(.PhotoLibrary)
    }
    
    @IBAction func activityButtonPressed(sender: AnyObject) {
        let image = generateMemedImage()
        let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
        presentViewController(shareVC, animated: true, completion: nil)
        shareVC.completionWithItemsHandler = { activity, success, items, error in
            self.save()
        }
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        clearScreen()
    }
    
    //Methods
    
    //Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //TextField
    func setupTextField(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == defaultTop || textField.text == defaultBottom {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField == topTextField {
                textField.text = defaultTop
            } else if textField == bottomTextField {
                textField.text = defaultBottom
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        return true
    }
    
    //ImagePicker
    func presentImagePicker(chosenSource: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = chosenSource
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        currentImage = image
        memeImageView.image = currentImage
        activityButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clearScreen() {
        topTextField.text = defaultTop
        bottomTextField.text = defaultBottom
        memeImageView.image = UIImage()
        activityButton.enabled = false
    }
    
    //Final Image
    func generateMemedImage() -> UIImage {
        toolbarHide(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbarHide(false)
        
        return memedImage
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: currentImage, memedImage: memedImage)
        memes.append(meme)
    }
    
    func toolbarHide(state: Bool) {
        mememeLabel.hidden = state
        topToolbar.hidden = state
        bottomToolbar.hidden = state
    }
    
    
}

