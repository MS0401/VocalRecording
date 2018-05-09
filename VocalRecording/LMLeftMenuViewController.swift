//
//  LMLeftMenuViewController.swift
//  VocalRecording
//
//  Created by dev on 2/23/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

class LMLeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //The Titles of Side bar.
    var menuTitles = [0: "Profile", 1: "Friends", 2: "Messages", 3: "Notifications", 4: "Settings",5: "Help"]
    //The images of Side bar.
    var cellimage = [0: "profile1.png", 1: "friends1.png", 2: "message1.png", 3: "notification1.png", 4: "setting1.png", 5:"help1.png"]
    
    //initialize.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var toolBar_left: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Circle images
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.layer.borderWidth = 0.5
        self.avatarImageView.layer.borderColor = UIColor.clear.cgColor
        self.avatarImageView.clipsToBounds = true
        self.tableView.register(UINib(nibName: "LelfMenuViewCell", bundle: nil), forCellReuseIdentifier: "LM")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RemoveMenu(_ sender: Any) {
        self.sideBarController.hideMenuViewController(true)
    }
    // Table View DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LM", for: indexPath) as! LelfMenuViewCell
        cell.titleLabel.text = self.menuTitles[indexPath.row]
        cell.titleLabel.textColor = UIColor(white: 1, alpha: 1)
        cell.backgroundColor = UIColor.clear
        cell.cellImage.image = UIImage(named: cellimage[indexPath.row]!)
        return cell
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect( x:0, y:0, width:width, height:height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    // TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            
            let profile = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! Profile
            self.present(profile, animated: true, completion: nil)
        }
        else if indexPath.row == 1 {
            
            let friends = self.storyboard?.instantiateViewController(withIdentifier: "friends") as! Friends
            self.present(friends, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            
            let messages = self.storyboard?.instantiateViewController(withIdentifier: "messages") as! Messages
            self.present(messages, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            
            let notifications = self.storyboard?.instantiateViewController(withIdentifier: "notifications") as! Notifications
            self.present(notifications, animated: true, completion: nil)
        }
        else if indexPath.row == 4 {
        
        let settings = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! Settings
        self.present(settings, animated: true, completion: nil)
        }
        else if indexPath.row == 5 {
            
            let help = self.storyboard?.instantiateViewController(withIdentifier: "help") as! Help
            self.present(help, animated: true, completion: nil)
        }
    }
    
}
