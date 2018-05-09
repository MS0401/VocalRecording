//
//  Profile.swift
//  VocalRecording
//
//  Created by dev on 2/24/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class Profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var projectTable: UITableView!
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var followings: UITableView!
   
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Circle images
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.layer.borderWidth = 0.5
        self.profileImage.layer.borderColor = UIColor.clear.cgColor
        self.profileImage.clipsToBounds = true


        projectTable.isHidden = true
        friendsTable.isHidden = true
        followings.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Project_btn(_ sender: Any) {
        
        followings.isHidden = true
        friendsTable.isHidden = true
        projectTable.isHidden = false
        
    }
    
    
    @IBAction func Friends_btn(_ sender: Any) {
        
        projectTable.isHidden = true
        followings.isHidden = true
        friendsTable.isHidden = false
        
        
    }
    
    
    @IBAction func Followings_btn(_ sender: Any) {
        
        projectTable.isHidden = true
        friendsTable.isHidden = true
        followings.isHidden = false
        
    }
    
    
    @IBAction func GoLeftSlide(_ sender: Any) {
        
    
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == projectTable {
            
            return imageName.count
        }
        else if tableView == friendsTable {
            
            return friends.count
        }
        else{
            
            return followImage.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == projectTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectsCell
            
            cell.proj_img.image = UIImage(named: imageName[indexPath.row]!)
            cell.proj_name.text = name[indexPath.row]
            cell.user_name.text = byname[indexPath.row]
            cell.proj_date.text = "03/18/2016"
            
            return cell
        }
        else if tableView == friendsTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsCell
            
            cell.friendsImage.image = UIImage(named: friends[indexPath.row]!)
            cell.friends_name.text = fri_name[indexPath.row]
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "followingsCell", for: indexPath) as! FollowingsCell
            
            cell.following_Image.image = UIImage(named: followImage[indexPath.row]!)
            cell.following_label.text = followName[indexPath.row]
            
            return cell
        }
    }
    

    
}

class ProjectsCell: UITableViewCell {
    
    @IBOutlet weak var proj_img: UIImageView!
    @IBOutlet weak var proj_name: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var proj_date: UILabel!
    
    
    
}

class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var friends_name: UILabel!
    @IBOutlet weak var friendsImage: UIImageView!
    
    
}

class FollowingsCell: UITableViewCell {
    
    @IBOutlet weak var following_label: UILabel!
    @IBOutlet weak var following_Image: UIImageView!
    
}
