//
//  MemeTableCell.swift
//  MemeMe
//
//  Created by James Dyer on 5/13/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var topImageLabel: UILabel!
    @IBOutlet weak var bottomImageLabel: UILabel!
    
    /**
    Configures the cell for the tableview.
     
     - Parameter meme: The meme used for that cell.
    */
    func configureCell(meme: Meme) {
        let top = meme.topText
        let bottom = meme.bottomText
        
        createStyledText(top, label: topImageLabel)
        createStyledText(bottom, label: bottomImageLabel)
        
        memeImage.image = meme.originalImage
        topTextLabel.text = top
        bottomTextLabel.text = bottom
    }

}
