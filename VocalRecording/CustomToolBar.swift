//
//  CustomToolBar.swift
//  VocalRecording
//
//  Created by dev on 4/7/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
//This viewcontroller customize toolBar in everything viewcontroller.
class CustomToolBar: UIToolbar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var newSize: CGSize = super.sizeThatFits(size)
        newSize.height = 60  // there to set your toolbar height
        
        return newSize
    }
}
