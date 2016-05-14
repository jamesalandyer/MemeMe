//
//  MemeCollectionCell.swift
//  MemeMe
//
//  Created by James Dyer on 5/13/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class MemeCollectionCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topImageLabel: UILabel!
    @IBOutlet weak var bottomImageLabel: UILabel!
    
    /**
     Configures the cell for the collectionview.
     
     - Parameter meme: The meme used for that cell.
     */
    func configureCell(meme: Meme) {
        let top = meme.topText
        let bottom = meme.bottomText
        
        createStyledText(top, label: topImageLabel)
        createStyledText(bottom, label: bottomImageLabel)
        
        memeImage.image = meme.originalImage
    }
    
}
