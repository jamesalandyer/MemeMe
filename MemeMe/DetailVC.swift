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
    
    override func viewDidAppear(animated: Bool) {
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
    
    func editMeme() {
        performSegueWithIdentifier("editMeme", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editMeme" {
            if let memeVC = segue.destinationViewController as? MemeVC {
                memeVC.defaultTop = selectedMeme.topText
                memeVC.defaultBottom = selectedMeme.bottomText
                memeVC.currentImage = selectedMeme.originalImage
            }
        }
    }

}
