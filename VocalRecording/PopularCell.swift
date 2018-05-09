//
//  Popular.swift
//  VocalRecording
//
//  Created by dev on 2/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class PopularCell: UICollectionViewCell {
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var favorite: UIButton!
    @IBOutlet var NameButton: UIButton!
    @IBOutlet var ByNameButton: UIButton!
    
    
    override func awakeFromNib() {
        self.setNeedsLayout()
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func Favorite(sender: AnyObject){
        
    }
    
}
