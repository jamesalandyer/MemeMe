//
//  CollectionVC.swift
//  MemeMe
//
//  Created by James Dyer on 5/12/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Properties
    var memeArray: [Meme] {
        return DataService.sharedInstance.memes
    }
    var selectedMeme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        establishFlowLayout()
        establishNavBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    //MARK: - Header and Footer
    
    /**
     Sets the items in the navigation bar.
     */
    func establishNavBar() {
        navigationItem.title = "Created Memes Grid"
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(showGridMemeVC))
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let meme = memeArray[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as? MemeCollectionCell {
            cell.configureCell(meme)
            
            return cell
        } else {
            return MemeCollectionCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = memeArray[indexPath.row]
        performSegueWithIdentifier("collectionDetail", sender: nil)
    }
    
    /**
     Establishes the setting for the flow layout to display the collection view.
    */
    func establishFlowLayout() {
        let space: CGFloat = 1.0
        let width = self.view.frame.width
        let dimensions = (width - (2 * space) - 40) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensions, dimensions)
    }
    
    //MARK: - Segues
    
    /**
     Shows the memeVC from the gird view.
     */
    func showGridMemeVC() {
        performSegueWithIdentifier("showGridMemeVC", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collectionDetail" {
            if let detailVC = segue.destinationViewController as? DetailVC {
                detailVC.selectedMeme = selectedMeme
            }
        }
    }

}
