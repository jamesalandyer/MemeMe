//
//  DetailVC.swift
//  MemeMe
//
//  Created by James Dyer on 5/13/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var selectedMeme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        print(selectedMeme)
    }

}
