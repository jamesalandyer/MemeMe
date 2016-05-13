//
//  DataService.swift
//  MemeMe
//
//  Created by James Dyer on 5/12/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation

class DataService {
    
    static let ds = DataService()
    
    private var _memes = [Meme]()
    
    var memes: [Meme] {
        get {
            return _memes
        }
    }
    
    /**
     Saves the meme to the current meme array.
     
     - Parameter meme: The meme you want to save.
    */
    func saveMemes(meme: Meme) {
        _memes.append(meme)
    }
    
    /**
     Deletes the meme in the current meme array.
     
     - Parameter memeIndex: The index of the meme you want to delete.
     */
    func removeMeme(memeIndex: Int) {
        _memes.removeAtIndex(memeIndex)
    }
    
}