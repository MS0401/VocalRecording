//
//  Publish.swift
//  VocalRecording
//
//  Created by dev on 2/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class PublishCell: UICollectionViewCell {
    
    
    @IBOutlet var imgView1: UIImageView!
    @IBOutlet var imgView2: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var ByName1: UILabel!
    @IBOutlet var ByName2: UILabel!
    @IBOutlet var Play: UIButton!
    
    
    override func awakeFromNib() {
        self.setNeedsLayout()
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
            
}
