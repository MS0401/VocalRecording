//
//  FriendProfile.swift
//  VocalRecording
//
//  Created by dev on 2/25/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class FriendProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendname: UILabel!
    
    @IBOutlet weak var projectTable: UITableView!
    
    @IBOutlet weak var FriendTable: UITableView!
    
    @IBOutlet weak var FollowingTable: UITableView!
    
    
    //project data
    
    var imageName = [0: "evo-beatz.png", 1: "kery.png", 2: "fany.png"]
    var name = [0: "project One", 1: "Explement", 2: "Load your test"]
    var byname = [0: "with Justin", 1: "with Tinnel panng", 2: "with"]
    
    // friends data
    
    var friends = [0: "Austin.png", 1: "BJOBEATs.png", 2: "dane.png"]
    var fri_name = [0: "Tinnel pang", 1: "Terry tstai", 2: "Fay Gu"]
    
    //following data
    
    
    var followImage = [0: "personal1.png", 1: "malek1.png", 2: "malek2.png"]
    var followName = [0: "Christian Morgan", 1: "David K.", 2: "Koren T."]
    
    
    var stringPassed = ""
    
    var theImagePassed = UIImage()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendImage.image = theImagePassed
        self.friendname.text = stringPassed
        

        // Circle images
        self.friendImage.layer.cornerRadius = self.friendImage.frame.size.width / 2
        self.friendImage.layer.borderWidth = 0.5
        self.friendImage.layer.borderColor = UIColor.clear.cgColor
        self.friendImage.clipsToBounds = true
        
        
        projectTable.isHidden = true
        FriendTable.isHidden = true
        FollowingTable.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func projectfriend(_ sender: Any) {
        
        FollowingTable.isHidden = true
        FriendTable.isHidden = true
        projectTable.isHidden = false
    }
    @IBAction func friends(_ sender: Any) {
        
        projectTable.isHidden = true
        FollowingTable.isHidden = true
        FriendTable.isHidden = false
    }
    @IBAction func followings(_ sender: Any) {
        
        projectTable.isHidden = true
        FriendTable.isHidden = true
        FollowingTable.isHidden = false

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == projectTable {
            
            return imageName.count
        }
        else if tableView == FriendTable {
            
            return friends.count
        }
        else{
            
            return followImage.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == projectTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pro_cell", for: indexPath) as! projectCell_Friend
            
            cell.proj_img.image = UIImage(named: imageName[indexPath.row]!)
            cell.proj_name.text = name[indexPath.row]
            cell.user_name.text = byname[indexPath.row]
            cell.proj_date.text = "03/18/2016"
            
            return cell
        }
        else if tableView == FriendTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friend_cell", for: indexPath) as! friendCell_Friend
            
            cell.friendsImage.image = UIImage(named: friends[indexPath.row]!)
            cell.friends_name.text = fri_name[indexPath.row]
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "follow_cell", for: indexPath) as! followingsCell_Friend
            
            cell.following_Image.image = UIImage(named: followImage[indexPath.row]!)
            cell.following_label.text = followName[indexPath.row]
            
            return cell
        }
    }

    

    
}

class  projectCell_Friend: UITableViewCell{
    
    @IBOutlet weak var proj_img: UIImageView!
    @IBOutlet weak var proj_name: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var proj_date: UILabel!
    
    
}

class friendCell_Friend: UITableViewCell{
    
    @IBOutlet weak var friends_name: UILabel!
    @IBOutlet weak var friendsImage: UIImageView!
    
    
}

class followingsCell_Friend: UITableViewCell{
    
    @IBOutlet weak var following_label: UILabel!
    @IBOutlet weak var following_Image: UIImageView!
}
