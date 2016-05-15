//
//  DetailVC.swift
//  MemeMe
//
//  Created by James Dyer on 5/13/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selectedMeme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()

        establishNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        selectedImageView.image = selectedMeme.memedImage
    }
    
    override func viewDidDisappear(animated: Bool) {
        if let navController = self.navigationController {
            navController.popToRootViewControllerAnimated(false)
        }
    }
    
    /**
     Sets the items in the navigation bar.
     */
    func establishNavBar() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editMeme))
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    /**
     Shows you the meme to edit.
     */
    func editMeme() {
        performSegueWithIdentifier("editMeme", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editMeme" {
            if let memeVC = segue.destinationViewController as? MemeVC {
                memeVC.editTop = selectedMeme.topText
                memeVC.editBottom = selectedMeme.bottomText
                memeVC.currentImage = selectedMeme.originalImage
            }
        }
    }

}
