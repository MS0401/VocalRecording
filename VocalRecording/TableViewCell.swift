//
//  TableViewCell.swift
//  VocalRecording
//
//  Created by dev on 2/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var choosename1: UILabel!
    @IBOutlet weak var choosename2: UILabel!
    @IBOutlet weak var choosename3: UILabel!
    @IBOutlet weak var choosename4: UILabel!
    @IBOutlet private weak var pickCollection: UICollectionView!
    @IBOutlet private weak var popularCollection: UICollectionView!
    @IBOutlet private weak var publishCollection: UICollectionView!
    @IBOutlet private weak var favoriteCollection: UICollectionView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if self.tag == 0 {
            
            // pickCollection initialization.
            choosename1.text = "I picked for you!"
            pickCollection.frame = self.bounds
            pickCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        else if self.tag == 1 {
            
            // popularCollection initialization.
            choosename2.text = "I Popular Right Now"
            popularCollection.frame = self.bounds
            popularCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        else if self.tag == 2 {
            
            // publishCollection initialization.
            choosename3.text = "I Published by your friends"
            publishCollection.frame = self.bounds
            publishCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        else if self.tag == 3 {
            
            // favoriteCollection initialization.
            choosename4.text = "I From your favorite producers"
            favoriteCollection.frame = self.bounds
            favoriteCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        
        if self.tag == 0 {
            
            // pickCollection
            pickCollection.delegate = dataSourceDelegate
            pickCollection.dataSource = dataSourceDelegate
            pickCollection.tag = row
            pickCollection.reloadData()
        }
        else if self.tag == 1 {
            
            // popularCollection
            popularCollection.delegate = dataSourceDelegate
            popularCollection.dataSource = dataSourceDelegate
            popularCollection.tag = row
            popularCollection.reloadData()
        }
        else if self.tag == 2 {
            
            // publishCollection
            publishCollection.delegate = dataSourceDelegate
            publishCollection.dataSource = dataSourceDelegate
            publishCollection.tag = row
            publishCollection.reloadData()
        }
        else if self.tag == 3 {
            
            // favoriteCollection
            favoriteCollection.delegate = dataSourceDelegate
            favoriteCollection.dataSource = dataSourceDelegate
            favoriteCollection.tag = row
            favoriteCollection.reloadData()
        }        
        
        
    }
    
    var pickCollectionViewOffset: CGFloat {
        
        get {
            return pickCollection.contentOffset.x
        }
        
        set {
            pickCollection.contentOffset.x = newValue
        }
    }
    var popularCollectionViewOffset: CGFloat {
        
        get {
            return popularCollection.contentOffset.x
        }
        set {
            popularCollection.contentOffset.x = newValue
        }
    }
    var publishCollectionViewOffset: CGFloat {
        
        get {
            return publishCollection.contentOffset.x
        }
        set {
            publishCollection.contentOffset.x = newValue
        }
    }
    var favoriteCollectionViewOffset: CGFloat {
        
        get {
            return favoriteCollection.contentOffset.x
        }
        set {
            favoriteCollection.contentOffset.x = newValue
        }
    }

}
