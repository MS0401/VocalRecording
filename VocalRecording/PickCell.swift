//
//  Pick.swift
//  VocalRecording
//
//  Created by dev on 2/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class PickCell: UICollectionViewCell {
    
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var ByName: UILabel!
    @IBOutlet var favorite: UIButton!
    @IBOutlet var Add: UIButton!
    
    override func awakeFromNib() {
        self.setNeedsLayout()
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func Favorite(sender: AnyObject){
        
    }
    @IBAction func Add(sender: AnyObject){
        
    }

    
}
