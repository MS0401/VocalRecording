//
//  SharingManager.swift
//  VocalRecording
//
//  Created by dev on 3/16/17.
//  Copyright © 2017 dev. All rights reserved.
//

import Foundation

class SharingMananger {
    static let sharedInstance = SharingMananger()
    
    var isCreated = false
    var indexpath: Int!
    var shareTextView = [Int: String]()
    var Creating = false
    //CreateProject of row number
    var n: Int!
}
