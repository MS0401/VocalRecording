//
//  MoreAboutViewController.swift
//  VocalRecording
//
//  Created by dev on 3/8/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class MoreAboutViewController: UIViewController {
    
    var datasource: JMCFlexibleCollectionViewDataSource?
    @IBOutlet var BeatPick: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // **Register collection view cell */
        BeatPick.register(FlexibleCollectionCell.self, forCellWithReuseIdentifier: "cell")
        
        /** Create an instance of the flexible datasource make sure to pass here the collection view and cell identifier */
        datasource = JMCFlexibleCollectionViewDataSource(collectionView: BeatPick, cellIdentifier: "cell")
        
        // prepare items to display in the collection view
        var dataSourceItems = [JMCDataSourceItem]()
        
        for i in 0...3{
            let item = JMCDataSourceItem()
            item.image = UIImage(named: "yosemite\(i).png")
            dataSourceItems.append(item)
        }
        
        // assign the items to the datasource
        
        datasource?.dataItems = dataSourceItems
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        datasource?.setup()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

