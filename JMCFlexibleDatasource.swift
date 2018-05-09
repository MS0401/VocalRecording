//
//  JMCFlexibleDatasource.swift
//  JMCFlexibleLayout
//
//  Created by Janusz Chudzynski on 7/9/16.
//  Copyright © 2016 izotx. All rights reserved.
//
import UIKit

/**Protocol that needs to be implemented by the cells implemented by the cells to be displayed in the layout*/
protocol JMCFlexibleCellProtocol{
    func configureWithItem(item:DataSourceItem, indexPath:NSIndexPath)
}

/**Item Selected Protocol*/
protocol JMCFlexibleCellSelection  {
    func cellDidSelected(indexPath:NSIndexPath, item:DataSourceItem)
}

/**Generic Data source item*/
class DataSourceItem: NSObject{
    
    func getSize()->CGSize{
        return CGSize.zero
    }
}

/**Not that Generic Data source item*/
class JMCDataSourceItem:DataSourceItem{
    //Image to display in the collection view cell
    var image:UIImage?
    
    // Make sure to override this method to pass the size of the element to display in the collection view cell
    override func getSize()->CGSize{
        if let image = image {
            return image.size
        }
        return CGSize.zero
    }
}


/***Sample FLexible Collection View Cell*/
class FlexibleCollectionCell : UICollectionViewCell{
    var imageView = UIImageView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
       
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
       
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
//        imageView.layer.borderColor = UIColor.greenColor().CGColor
//        imageView.layer.borderWidth = 1.0
//        contentView.layer.borderColor = UIColor.redColor().CGColor
//        contentView.layer.borderWidth = 1.0
    }
    
        
    func configureWithItem(item:DataSourceItem, indexPath:NSIndexPath){
       
        if let item = item as? JMCDataSourceItem{
            self.imageView.image = item.image
        }
    }

}
    

/*Datasource for the collection view*/
class JMCFlexibleCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    

    /**Layout Methods*/
    //private let layoutHelper = JMCFlexibleLayout()
    /**Collection view*/
    private weak var collectionView:UICollectionView?
    
    private var cellSizes = [CGSize]()
    
    private var cellIdentifier:String
    
    var delegate: JMCFlexibleCellSelection?
    
    /**Margins around the collection view*/
    var margin:CGFloat = 25{
        didSet{
           
            setup()
        }
    }

    /**Spacing between the cells*/
    var spacing:CGFloat = 14{
        didSet{
            if let c = collectionView
            {
                print(c.frame)
                if spacing * 2 >= c.frame.width{
                    spacing = 14
                }
            }
            
            setup()
        }
    }
    /**Determines how tall can the row be*/
    var maximumRowHeight:CGFloat = 300{
        didSet{
            setup()
        }
    }
    
    /**Data source elements to display*/
    var dataItems = [JMCDataSourceItem](){
        didSet{
            //dataItems = dataItems.filter({$0.image != nil})
            setup()
        }
    }
    
    init(collectionView:UICollectionView, cellIdentifier:String) {
        self.collectionView = collectionView
        self.cellIdentifier = cellIdentifier
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setup(){
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        prepareSizes()
        collectionView?.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    //MARK: Collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataItems.count
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as!  FlexibleCollectionCell
        cell.configureWithItem(item: dataItems[indexPath.row], indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    //MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellDidSelected(indexPath: indexPath as NSIndexPath, item: dataItems[indexPath.row])
    }
    
    
    
    
    /**This method generates a dynamic grid based on the image sizes*/
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        if cellSizes.count <= indexPath.row {
            return CGSize.zero
        }
        
        return cellSizes[indexPath.row]
    }
    
    /**If for any reason you decide to deal with static sizes */
    private func staticSize(indexPath:NSIndexPath) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        let width = collectionView.frame.width
        let cellWidth = (width -  2 * margin - 1 * spacing ) * 1.0/2.0
        let cellHeight = cellWidth
        return  CGSize(width: cellWidth, height: cellHeight)
    }
    
    /**Calculates size of */
    private func prepareSizes(){
        _ = dataItems.map({return $0.getSize()})
        _ = self.collectionView!.frame.width - 2 * margin
        //Maximum height of the row
        let _:CGFloat = maximumRowHeight
        //layoutHelper.spacing = spacing
        /**we should be calling this method only once */
        //cellSizes = layoutHelper.generateGrid(sizes: sizes, maxWidth: width, maxHeight: height, viewHeight: collectionView!.frame.height).0
    }
    
    
    deinit{
        
    }
}

