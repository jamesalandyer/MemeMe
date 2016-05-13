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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
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
    
    let memesArray = DataService.ds.memes
    
    //MARK: - Stack

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityButton.enabled = false
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if memesArray.count == 0 {
            cancelButton.enabled = false
        }
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
    
    //MARK: - IBActions
    
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
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Notifications
    
    /**
     Subcribe to keyboard will show and hide notifications.
    */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     Unsubcribe to keyboard will show and hide notifications.
     */
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     Alter screen for keyboard showing.
     
     - Parameter notification: KeyboardWillShow notification.
     */
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    /**
     Alter screen for keyboard hiding.
     
     - Parameter notification: KeyboardWillHide notification.
     */
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    /**
     Get the keyboard height for the user.
     
     - Parameter notification: Notification.
     */
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: - TextField
    
    /**
     Sets up the textfields to be used.
     
     - Parameter textField: The textfield being setup.
     */
    func setupTextField(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
    //Clear textfield when editing begins.
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == defaultTop || textField.text == defaultBottom {
            textField.text = ""
        }
    }
    
    //If empty set the texfield to the default text.
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField == topTextField {
                textField.text = defaultTop
            } else if textField == bottomTextField {
                textField.text = defaultBottom
            }
        }
    }
    
    //Dismiss keyboard when enter is hit.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - ImagePicker
    
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
    
    //MARK: - Final Image
    
    /**
     Takes a capture of the screen without the toolbars.
     
     - Returns: A new image with the text in it.
     */
    func generateMemedImage() -> UIImage {
        toolbarHide(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbarHide(false)
        
        return memedImage
    }
    
    /**
     Saves the meme as a Meme object and appends it to an array.
     */
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: currentImage, memedImage: memedImage)
        DataService.ds.saveMemes(meme)
    }
    
    /**
     Toggles the toolbar to hide or not hide.
     
     - Parameter state: The state of the buttons to change to.
     */
    func toolbarHide(state: Bool) {
        mememeLabel.hidden = state
        topToolbar.hidden = state
        bottomToolbar.hidden = state
    }
    
    
}

