//
//  Friends.swift
//  VocalRecording
//
//  Created by dev on 2/24/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class Friends: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FriendList: UITableView!
    
    @IBOutlet weak var myConfirm: UIButton!
    
    @IBOutlet weak var myDelete: UIButton!
    
    @IBOutlet weak var myConfirmed: UIButton!
    
    @IBOutlet weak var myDeleted: UIButton!
    
    
    
    var myfriendImages = [0: "tinney.png", 1: "terry.png", 2: "faney.png", 3: "paul.png", 4: "koren.png"]
    
    var myfriendNames = [0: "Tinnei Pang", 1: "Terry Tsai", 2: "Fay Gu", 3: "Paul Wise Beats", 4: "Koren"]
    
    var personImage = UIImage()
    var personName = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myConfirm.isHidden = false
        myDelete.isHidden = false
        myConfirmed.isHidden = true
        myDeleted.isHidden = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Confirm(_ sender: Any) {
        
        myConfirm.isHidden = true
        myDelete.isHidden = true
        myDeleted.isHidden = true
        myConfirmed.isHidden = false
    }
    @IBAction func Delete(_ sender: Any) {
        
        
        myConfirm.isHidden = true
        myDelete.isHidden = true
        myConfirmed.isHidden = true
        myDeleted.isHidden = false
    }
    
    @IBAction func Confirmed(_ sender: Any) {
        
        myDeleted.isHidden = true
        myConfirmed.isHidden = true
        myConfirm.isHidden = false
        myDelete.isHidden = false
    }
    @IBAction func Deleted(_ sender: Any) {
        
        myDeleted.isHidden = true
        myConfirmed.isHidden = true
        myConfirm.isHidden = false
        myDelete.isHidden = false
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myfriendImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myfriendlistcell", for: indexPath) as! MyFriendListCell
        
        cell.Myfriendlistcell.image = UIImage(named: myfriendImages[indexPath.row]!)
        cell.MyfriendName.text = myfriendNames[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        personImage = UIImage(named: myfriendImages[indexPath.row]!)!
        let myfriend = self.storyboard?.instantiateViewController(withIdentifier: "friendprofile") as! FriendProfile
        
        myfriend.stringPassed = myfriendNames[indexPath.row]!
        myfriend.theImagePassed = UIImage(named: myfriendImages[indexPath.row]!)!
        self.present(myfriend, animated: true, completion: nil)
    }
    

    
}

class MyFriendListCell: UITableViewCell{
    
    
    @IBOutlet weak var Myfriendlistcell: UIImageView!
    @IBOutlet weak var MyfriendName: UILabel!
    
    
}
