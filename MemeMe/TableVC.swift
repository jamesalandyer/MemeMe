//
//  TableVC.swift
//  MemeMe
//
//  Created by James Dyer on 5/12/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    var memeArray: [Meme] {
        return DataService.ds.memes
    }
    var selectedMeme: Meme!

    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        indentTabs()
        establishNavBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        if memeArray.count == 0 {
            showMemeVC()
        }
        tableView.reloadData()
    }
    
    //MARK: - Header and Footer
    
    /**
     Sets the items in the navigation bar.
    */
    func establishNavBar() {
        navigationItem.title = "Created Memes Table"
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(showMemeVC))
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    /**
     Indents the tabs in the tab bar to adjust for no text.
     */
    func indentTabs() {
        if let tabBarItems = tabBarController?.tabBar.items {
            for items in tabBarItems {
                items.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
            }
        }
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meme = memeArray[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as? MemeTableCell {
            cell.configureCell(meme)
            return cell
        } else {
            return MemeTableCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = memeArray[indexPath.row]
        performSegueWithIdentifier("tableDetail", sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            DataService.ds.removeMeme(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    //MARK: - Segues
    
    /**
     Shows the meme view controller.
     */
    func showMemeVC() {
        performSegueWithIdentifier("showMemeVC", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tableDetail" {
            if let detailVC = segue.destinationViewController as? DetailVC {
                detailVC.selectedMeme = selectedMeme
            }
        }
    }

}
