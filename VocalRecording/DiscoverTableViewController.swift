//
//  DiscoverTableViewController.swift
//  VocalRecording
//
//  Created by dev on 2/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

class DiscoverTableViewController: UITableViewController, UITextFieldDelegate {
    
    //let manager = SwiftPlayerManager()
    
    var audioPlayer : AVAudioPlayer!
    var engine = AVAudioEngine()
    var player1: AVAudioPlayerNode!
    var f: AVAudioFile!

    
    @IBOutlet weak var leftSlide: UIButton!
    @IBOutlet var MainBarItem: UIBarButtonItem!

    var storedOffsets = [Int: CGFloat]()
    
    var progressView: UIProgressView!
    var progressTimer: Timer?
    var endTimer: Timer?
    var PlayerName: UILabel!
    var favorite_btn: UIButton!
    var subView: UIView!
    var subView1: UIView!
    var favoriting: Bool = false
    var add_btn: UIButton!
    var addAction: UIButton!
    var PandS = false
    var pause = Bool()
    
    //Audio player initialize.
    var loadFile = AKSampler()
    var mp3Booster: AKBooster?
    var drumloop = try? AKAudioFile()
    var player_discover: AKAudioPlayer?
    var timer: Double!
    var date: String!
    
    var marrRecordingData : NSMutableArray!
    
    var collectionView: UICollectionView!
    var index: IndexPath!
    
    // pick Cell data.
    var pickImageArray = [0: "Dane Brennan - Razors.jpg", 1: "Austin Fig - Duvet.png", 2: "Keri - Rawmaniac.jpg", 3: "BJOBEATS - Spaceman"]
    var pickName = [0: "Razors", 1: "Duvet", 2: "Rawmaniac", 3: "All"]
    var pickByName = [0: "by Dane Brennan", 1: "byAustin Fig", 2: "by keri", 3: "by anton"]
    
    // popular Cell data.
    var popularImageArray = [0: "EvoBeatz - Skylab.png", 1: "Jurd Beats - Hard Knock Life.jpg", 2: "Malek - Hot N Cold.jpg", 3: "Picture clipping.pictClipping"]
    var popularName = [0: "Skylab", 1: "Hard Knock Life", 2: "Hot N Cold", 3: "S  "]
    var popularByName = [0: "by EvoBeatz", 1: "by jurd Beats", 2: "by Malek", 3: "by anton"]
    
    //publish Cell data.
    var publishImageArray = [0: "Dizzee On The Beat - Only Right.jpg", 1: "Malek - The Golden Age.jpg", 2: "Dizzee On The Beat - Only Right.jpg"]
    var profileIamgeArray = [0: "p2.jpg", 1: "p1.jpeg", 2: "p3.jpg", 3: "Dsavagebeats - All I Ever Wanted.jpg"]
    var publishName = [0: "The Hunt - Joseph", 1: "Treasure - Mark", 2: " Anton popos"]
    var publishByName1 = [0: "first", 1: "second", 2: "thrid"]
    var publishByName2 = [0: "first name", 1: "second name", 2: "third name"]
    
    // favorite Cell data.
    var favoriteImageArray = [0: "Dizzee On The Beat - Trillium.png", 1: "Edgar Krastin - Summertime.jpg", 2: "Malek - The Golden Age.jpg", 3: "Austin Fig - Duvet.png"]
    var favoriteName = [0: "Trillium", 1: "Summertime", 2: "The Golden Age", 3: "Anton popos"]
    var favoriteByName = [0: "by dizzee On The Beat", 1: "by Edgar Krastin", 2: "by Malek", 3: "by anton popos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.AddActionSheet()
        self.subView.isHidden = true
        
        //SQL Database section.
        if SharingMananger.sharedInstance.Creating == false {
            let isCreated = ModelManager.getInstance().createProjectNameTable()
            if isCreated {
                SharingMananger.sharedInstance.Creating = isCreated
                print("ProjectNameTable is successfully created")
            }
            else {
                print("ProjectNameTable is failed")
            }
        }
        else {
            print("ProjectNameTable have already created")
        }
        
        let doubleTap = UITapGestureRecognizer(target:self, action:#selector(DiscoverTableViewController.doubleTap(_:)))
        doubleTap.numberOfTapsRequired = 1
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(doubleTap)
    }
    
    func doubleTap(_ rec:UITapGestureRecognizer) {
        if rec.state != .ended {
            return
        }
        
        let p = rec.location(in: self.collectionView)
        if let indexPath = self.collectionView?.indexPathForItem(at: p) {
            index = indexPath
        }
    }
    // Popular CollectionView
    func AddActionSheet(){        
        
        subView = UIView(frame: CGRect(x: 0, y: 563, width: 375, height: 44))
        subView.backgroundColor = UIColor.black
        self.parent?.view.addSubview(self.subView)
        
        self.add_btn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.add_btn.setImage(UIImage(named: "evo-beatz"), for: .normal)
        self.add_btn.backgroundColor = UIColor.red
        self.add_btn.addTarget(self, action: #selector(DiscoverTableViewController.CreateActionSheet), for: .touchUpInside)
        self.subView.addSubview(self.add_btn)
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressView = UIProgressView(frame: CGRect(x: 52, y: 10, width: 220, height: 2))
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.darkGray
        self.subView.addSubview(self.progressView)
        
        self.PlayerName = UILabel(frame: CGRect(x: 52, y: 20, width: 220, height: 17))
        self.PlayerName.text = "EVOBeatz"
        self.PlayerName.textColor = UIColor.white
        self.subView.addSubview(self.PlayerName)
        
        self.favorite_btn = UIButton(frame: CGRect(x: 307, y: 15, width: 16, height: 15))
        self.favorite_btn.setImage(UIImage(named: "favorite"), for: .normal)
        self.favorite_btn.addTarget(self, action: #selector(DiscoverTableViewController.favoriteSelect), for: .touchUpInside)
        self.subView.addSubview(self.favorite_btn)
        
        self.addAction = UIButton(frame: CGRect(x: 344, y: 12, width: 15, height: 16))
        self.addAction.setImage(UIImage(named: "plus"), for: .normal)
        self.addAction.addTarget(self, action: #selector(DiscoverTableViewController.ActionSheet), for: .touchUpInside)
        self.subView.addSubview(self.addAction)
    }
    //When user click "evo-beatz" image of collectionView, this mothod is called
    func CreateActionSheet(){
        if PandS == false {
            self.play()
            progressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DiscoverTableViewController.UpdateTimer), userInfo: nil, repeats: true)
            
            self.add_btn.setImage(UIImage(named: "EVO_play"), for: .normal)
            endTimer = Timer.scheduledTimer(timeInterval: (f.duration), target: self, selector: #selector(DiscoverTableViewController.EndTimer), userInfo: nil, repeats: true)
            PandS = true
        }else {
            self.Stop()
            self.add_btn.setImage(UIImage(named: "EVO_stop"), for: .normal)
            progressTimer?.invalidate()
            progressTimer = nil
            endTimer?.invalidate()
            endTimer = nil
            PandS = false
        }
    }
    //In bottom bar, when user click favorite button, this method is called.
    func favoriteSelect(){
        if favoriting == true {
            self.favorite_btn.setImage(UIImage(named: "favorite"), for: .normal)
            favoriting = false
        }
        else {
            self.favorite_btn.setImage(UIImage(named: "favorite(selected)"), for: .normal)
            favoriting = true
        }
    }
    //In the bottom bar, when audio is playback, Timer call this method.
    func UpdateTimer() {
//        var time = Double()
//        time = (manager.f.currentTime) / (manager.player1.duration)
//        print("Current Time is \(String(describing: manager.player.currentTime))")
//        //progressView.setProgress(Float(time), animated: false)
//        progressView.progress = Float(time)
    }
    //In the bottom bar, when audio is stop, Timer call this method.
    func EndTimer(){
        Stop()
        self.add_btn.setImage(UIImage(named: "EVO_Stop"), for: .normal)
        popularImageArray[self.index.row] = "EVO_stop"
        self.collectionView.reloadData()
    }
    //In collection view, when user click name, this method is called.
    @IBAction func NameButtonTouched(_ sender: UIButton) {
        
        let showPlaying = self.storyboard?.instantiateViewController(withIdentifier: "showPlaying") as! ShowPlayingViewController
        self.present(showPlaying, animated: true, completion: nil)
    }
    
    @IBAction func ByNameButtonTouched(_ sender: UIButton) {
        let showPlaying = self.storyboard?.instantiateViewController(withIdentifier: "showPlaying") as! ShowPlayingViewController
        self.present(showPlaying, animated: true, completion: nil)
    }
    //In collection View, when user click "+" button, this method is called.
    @IBAction func CreatingAction(_ sender: UIButton) {
        self.ActionSheet()
    }
    //ActionSheet initialize.
    func ActionSheet() {
        
        let actionSheet = AHKActionSheet()
        actionSheet.blurTintColor = UIColor(white: 0.0, alpha: 0.75)
        actionSheet.blurRadius = 8.0
        actionSheet.buttonHeight = 50.0
        actionSheet.animationDuration = 0.5
        actionSheet.separatorColor = UIColor(white: 1.0, alpha: 0.3)
        actionSheet.selectedBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let defaultFont = UIFont(name: "Avenir", size: 17.0)!
        actionSheet.buttonTextAttributes = [NSFontAttributeName: defaultFont, NSForegroundColorAttributeName: UIColor.white]
        //actionSheet.cancelButtonTextAttributes = [NSFontAttributeName: defaultFont, NSForegroundColorAttributeName: UIColor.white]
        
        actionSheet.addButton(withTitle: "Create Project", image: UIImage(named: "createProject1.png"), type: AHKActionSheetButtonType.default, handler: {(AHKActionSheet) -> Void in
            print("Create Project")
            if self.PandS == true {
                self.Stop()
                self.add_btn.setImage(UIImage(named: "EVO_stop"), for: .normal)
                //Timer invalidate.
                self.progressTimer?.invalidate()
                self.progressTimer = nil
                self.endTimer?.invalidate()
                self.endTimer = nil

            }
            self.engine.stop()
//            self.engine.disconnectNodeOutput(self.player1, bus: 0)
            //DataBase Section.
            self.getProjectNameData()
            //Making the Project Name.
            
            //Making project name - year.
            let format_year = DateFormatter()
            format_year.dateFormat = "yyyy"
            let year = format_year.string(from: Date())
            
            //Making project name - month.
            let format_month = DateFormatter()
            format_month.dateFormat = "MM"
            let month = format_month.string(from: Date())
            
            //Making project name - day.
            let format_day = DateFormatter()
            format_day.dateFormat = "dd"
            let day = format_day.string(from: Date())
            
            //Making project name - hour.
            let format_hour = DateFormatter()
            format_hour.dateFormat = "HH"
            let hour = format_hour.string(from: Date())
            
            //Making project name - minutes.
            let format_minute = DateFormatter()
            format_minute.dateFormat = "mm"
            let minute = format_minute.string(from: Date())
            
            //Making project name - second.
            let format_second = DateFormatter()
            format_second.dateFormat = "ss"
            let second = format_second.string(from: Date())
            
            self.date = "Project\(year)\(month)\(day)\(hour)\(minute)\(second)"
            let date1 = year+month+day+hour+minute+second
            // new project list
            let ProjectLists: ProjectList = ProjectList()
            ProjectLists.ProjectName = self.date
            ProjectLists.ProjectNumber = date1
            
            let isInsertedProjectName = ModelManager.getInstance().addProjectNameData(projectList: ProjectLists)
            if isInsertedProjectName {
                print("Successfully inserted")
            }
            let isCreatedRecording = ModelManager.getInstance().createRecordingTable(tableName: ProjectLists.ProjectName)
            if isCreatedRecording {
                print("Successfully created the RecordingTable")
            }
            else {
                print("creating RecordingTable is False")
            }
            
            let recordingInfo: RecordingInFo = RecordingInFo()
            
            recordingInfo.lyrics_txt = ""
            recordingInfo.Record_Url = ""
            recordingInfo.insertLyrics_Boll = "mistake"
            recordingInfo.insertRecord2_Bool = "mistake"
            let add_date = "\(month)/\(day)/\(year)"
            recordingInfo.created_Date = add_date
            recordingInfo.created_time = "00:00:00"
            recordingInfo.recordName = "Recording1"
            let isInserted = ModelManager.getInstance().addRecordingData(recordInfo: recordingInfo, tableName: ProjectLists.ProjectName)
            if isInserted {
                print("Successfully inserted recording Data(Origine)")
            }
            else {
                print("inset False")
            }
            
            let newProject = self.storyboard?.instantiateViewController(withIdentifier: "newProject") as! NewProjectViewController
            newProject.tableName = ProjectLists.ProjectName
            self.present(newProject, animated: true, completion: nil)
        })
        
        // Create New Playlist
        actionSheet.addButton(withTitle: "Create New Playlist", image: UIImage(named: "playlist3.png"), type: AHKActionSheetButtonType.default, handler: {(AHKActionSheet) -> Void in
            
            print("Create New Playlist")
            self.subView1 = UIView(frame: CGRect(x: 75, y: 200, width: 230, height: 150))
            self.subView1.backgroundColor = UIColor.darkGray
            
            let label = UILabel(frame: CGRect(x: 30, y: 30, width: 150, height: 20))
            label.backgroundColor = UIColor.clear
            label.text = "Create New Playlist"
            label.textColor = UIColor.white
            self.subView1.addSubview(label)
            
            let textfiled = UITextField(frame: CGRect(x: 30, y: 60, width: 150, height: 30))
            textfiled.backgroundColor = UIColor.clear
            textfiled.placeholder = "Input"
            textfiled.textColor = UIColor.white
            textfiled.delegate = self
            self.subView1.addSubview(textfiled)
            
            let lineView = UIView(frame: CGRect(x: 30, y: 90, width: 150, height: 1))
            lineView.backgroundColor = UIColor.white
            self.subView1.addSubview(lineView)
            
            self.parent?.view.addSubview(self.subView1)
        })
        
        actionSheet.addButton(withTitle: "Add to Playlist", image: UIImage(named: "play_btn2.png"), type: AHKActionSheetButtonType.default, handler: nil)
        actionSheet.addButton(withTitle: "Spring Beats", image: UIImage(named: "spring1"), type: AHKActionSheetButtonType.default, handler: nil)
        actionSheet.addButton(withTitle: "Fun Beats", image: UIImage(named: "fun1"), type: AHKActionSheetButtonType.default, handler: nil)
        actionSheet.addButton(withTitle: "More...", image: UIImage(named: ""), type: AHKActionSheetButtonType.default, handler: nil)
        
        actionSheet.show()
    }
    
    //SQL Database the first table name list obtaining.
    func getProjectNameData()
    {
        marrRecordingData = NSMutableArray()
        marrRecordingData = ModelManager.getInstance().getAllProjectNameData()
        
        tableView.reloadData()
    }
    //In AnctionSheet, when user click "Add to Playlist" text, this mehtod is called.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let subView1 = UIView(frame: CGRect(x: 75, y: 200, width: 230, height: 150))
        let label1 = UILabel(frame: CGRect(x: 30, y: 30, width: 150, height: 20))
        label1.backgroundColor = UIColor.clear
        label1.text = "Chill Beats"
        label1.textColor = UIColor.white
        subView1.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: 35, y: 40, width: 150, height: 20))
        label2.backgroundColor = UIColor.clear
        label2.text = "Created"
        label2.textColor = UIColor.white
        subView1.addSubview(label2)
        
        let evo = UIImageView(frame: CGRect(x: 30, y: 80, width: 30, height: 30))
        evo.image = UIImage(named: "EVO_play.png")
        subView1.addSubview(evo)
        
        let label3 = UILabel(frame: CGRect(x: 65, y: 55, width: 100, height: 10))
        label3.backgroundColor = UIColor.clear
        label3.textColor = UIColor.white
        label3.text = "added to"
        label3.font = UIFont.init(name: "added to", size: 13)
        subView1.addSubview(label3)
        
        let label4 = UILabel(frame: CGRect(x: 65, y: 65, width: 100, height: 10))
        label4.backgroundColor = UIColor.clear
        label4.textColor = UIColor.white
        label4.font = UIFont.init(name: "Chill Beat", size: 13)
        label4.text = "Chill Beat"
        subView1.addSubview(label4)
        
        self.parent?.view.addSubview(subView1)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //When user click the left butto of top bar, this mehtod is called.
    @IBAction func leftMenuButtonTapped(_ sender: UIBarButtonItem) {
        
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    //In bottom bar, when user click mainButton, this method is called.
    @IBAction func MainBarItemTouched(_ sender: UIBarButtonItem) {
        if PandS == true {
            Stop()
            self.add_btn.setImage(UIImage(named: "EVO_stop"), for: .normal)
            progressTimer?.invalidate()
            progressTimer = nil
            endTimer?.invalidate()
            endTimer = nil
        }
        self.engine.stop()
//        //self.engine.disconnectNodeOutput(self.player1, bus: 0)
        let presentController = self.storyboard?.instantiateViewController(withIdentifier: "createProject") as! CreateProjectViewController
        self.present(presentController, animated: true, completion: nil)

    }
    
    @IBAction func LibraryBarItemTouched(_ sender: UIBarButtonItem) {
        
        if PandS == true {
            Stop()
            progressTimer?.invalidate()
            progressTimer = nil
            endTimer?.invalidate()
            endTimer = nil
        }
        self.engine.stop()
        
        let presentController = self.storyboard?.instantiateViewController(withIdentifier: "libraryController") as! LibraryViewController
        self.present(presentController, animated: true, completion: nil)
    }
    
    
    //Tableview delegate method.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else {
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
        switch indexPath.row {
        case 0:
            tableViewCell.pickCollectionViewOffset = storedOffsets[indexPath.row] ?? 0
            break
        case 1:
            tableViewCell.popularCollectionViewOffset = storedOffsets[indexPath.row] ?? 0
            break
        case 2:
            tableViewCell.publishCollectionViewOffset = storedOffsets[indexPath.row] ?? 0
            break
        case 3:
            tableViewCell.favoriteCollectionViewOffset = storedOffsets[indexPath.row] ?? 0
            break
        default:
            break
            
        }
   }
}
//UICollectionView delegate mehtod.
extension DiscoverTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.restorationIdentifier == "publish_id" {
            return 3
        }
        else{
            return 4
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.restorationIdentifier == "pick_id" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pick", for: indexPath) as! PickCell
            
            collectionView.tag = 0
            cell.imgView.contentMode = .scaleAspectFit
            cell.Name.text = pickName[indexPath.row]
            cell.ByName.text = pickByName[indexPath.row]
            cell.imgView.image = UIImage(named: pickImageArray[indexPath.row]!)
            return cell
        }
        else if collectionView.restorationIdentifier == "popular_id" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as! PopularCell
            
            collectionView.tag = 1
            cell.imgView.contentMode = .scaleAspectFit
            cell.NameButton.setTitle(popularName[indexPath.row], for: .normal)
            cell.ByNameButton.setTitle(popularByName[indexPath.row], for: .normal)
            cell.imgView.image = UIImage(named: popularImageArray[indexPath.row]!)
            return cell
        }
        else if collectionView.restorationIdentifier == "publish_id" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publish", for: indexPath) as! PublishCell
            
            collectionView.tag = 2
            cell.imgView1.contentMode = .scaleAspectFit
            cell.imgView2.contentMode = .scaleAspectFit
            
             //imageView circle.
            cell.imgView2.layer.cornerRadius = cell.imgView2.frame.size.width / 2
            cell.imgView2.layer.borderWidth = 1.5
            cell.imgView2.layer.borderColor = UIColor.white.cgColor
            cell.imgView2.clipsToBounds = true
            
            cell.Name.text = publishName[indexPath.row]
            cell.ByName1.text = publishByName1[indexPath.row]
            cell.ByName2.text = publishByName2[indexPath.row]
            cell.imgView1.image = UIImage(named: publishImageArray[indexPath.row]!)
            cell.imgView2.image = UIImage(named: profileIamgeArray[indexPath.row]!)
            return cell
            
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favorite", for: indexPath) as! FavoriteFriendsCell
            
            collectionView.tag = 3
            cell.imgView.contentMode = .scaleAspectFit
            cell.Name.text = favoriteName[indexPath.row]
            cell.ByName.text = favoriteByName[indexPath.row]
            cell.imgView.image = UIImage(named: favoriteImageArray[indexPath.row]!)
            return cell
        }
    }
    
    func play() {
        self.engine.stop()
        self.engine = AVAudioEngine()
        
        // simplest possible "play a file" scenario
        // construct a graph
        // take out a player node
        player1 = AVAudioPlayerNode()
        // open a file to play on the player node
        let url = Bundle.main.url(forResource:"Malek-Smile", withExtension:"mp3")!
        f = try! AVAudioFile(forReading: url)
        // hook the player's output to the self.engine's mixer node
        // alternatively, could use the self.engine's output node (mixer is hooked to output already)
        let mixer = self.engine.mainMixerNode
        self.engine.attach(player1)
        self.engine.connect(player1, to: mixer, format: f.processingFormat)
        // schedule the file on the player
        player1.scheduleFile(f, at:nil)
        // start the self.engine
        self.engine.prepare()
        try! self.engine.start()
        player1.play()

    }
    
    func Stop() {
        player1.stop()
        self.engine.stop()
        //self.engine = AVAudioEngine()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view a row \(collectionView.tag) selected index path \(indexPath)")
        
        //let img = UIImage(named: "small_main2")
        //self.MainBarItem.setBackgroundImage(img, for: .normal, style: .plain, barMetrics: .default)
        self.MainBarItem.image = UIImage(named: "small_main4")
        
        //In collectionView, when user click "evo-beatz" image.
        if collectionView.tag == 1 {
            self.collectionView = collectionView
            self.hideMenu()
            //Beat player is started.
            if indexPath.row == 0 {
                self.AddActionSheet()

                
                
                if PandS == false {
                    self.play()
                    popularImageArray[indexPath.row] = "EVO_play"
                    self.add_btn.setImage(UIImage(named: "EVO_play"), for: .normal)
                    
                    progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DiscoverTableViewController.UpdateTimer), userInfo: nil, repeats: true)
                    
                    endTimer = Timer.scheduledTimer(timeInterval: (self.f.duration), target: self, selector: #selector(DiscoverTableViewController.EndTimer), userInfo: nil, repeats: false)
                    collectionView.reloadData()
                    PandS = true

                }else {
                    self.Stop()
                    popularImageArray[indexPath.row] = "EVO_stop"
                    self.add_btn.setImage(UIImage(named: "EVO_stop"), for: .normal)
                    progressTimer?.invalidate()
                    progressTimer = nil
                    endTimer?.invalidate()
                    endTimer = nil
                    PandS = false
                    collectionView.reloadData()

                }
                
                
                
            
                
            }
        }
    }
    
    private func hideMenu() {
        UIView .animate(withDuration: 0.3, animations: { () -> Void in
            //self.tableViewHeightConstraint.constant = 0
            self.tableView.layoutIfNeeded()
        });
    }
    
    private func showMenu() {
        UIView .animate(withDuration: 0.3, animations: { () -> Void in
            _ = self.tableView.rowHeight * CGFloat(self.tableView.numberOfRows(inSection: 0))
            //self.tableViewHeightConstraint.constant = totalHeight
            self.tableView.layoutIfNeeded()
        });
    }
}
