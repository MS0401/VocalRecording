//
//  LibraryViewController.swift
//  VocalRecording
//
//  Created by dev on 2/24/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

let SectionHeaderViewIdentifier = "sectionCell"
struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CollapsibleTableViewHeaderDelegate, LibraryDelegate {
    
    var sections = [Section]()
    
    @IBOutlet weak var playListTable: UITableView!
    
    //@IBOutlet weak var FavoritesTable: UITableView!
    var marrProjectNameData: NSMutableArray!
    var marrRecordingData: NSMutableArray!
    var sql_tableName: String!
    var projectNameArray: NSMutableArray!
    var RecordingAllArray: NSMutableArray!
    @IBOutlet var favorite_btn: UIButton!
    @IBOutlet var playlist_btn: UIButton!
    var btn_click: Bool = true
    
    var play_list: Bool = false
    var play_favorite: Bool = false
    
    //Audio initialize.
    var audioFile: AKAudioFile?
    var player: AKAudioPlayer?
    var mainMixer_Play: AKMixer?
    var Beatplayer: AKAudioPlayer?
    var drumloop = try? AKAudioFile()
    var mp3Booster: AKBooster?
    var time = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the customize sectionViewCell initialize.
        playListTable.isHidden = false
        self.playListTable.register(UINib(nibName: "CollapsibleTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "sectionCell")
        
        //Section (struct) initialize.
        self.getProjectNameData()
        var projectNameArray1 = [String]()
        for i in 0..<marrProjectNameData.count {
            let projectlist: ProjectList = marrProjectNameData.object(at: i) as! ProjectList
            let name = projectlist.ProjectName
            self.sql_tableName = name
            self.getRecordingData(tableName: self.sql_tableName)
            //let recordingArray = NSMutableArray()
            for j in 0..<marrRecordingData.count {
                let recordInfo: RecordingInFo = marrRecordingData.object(at: j) as! RecordingInFo
                let serial = recordInfo.insertLyrics_Boll
                projectNameArray1.append(serial)
            }
            let oneSection = Section(name: self.sql_tableName, items: projectNameArray1)
            sections.append(oneSection)
        }
        print("sections.count is \(sections.count)")
        
        self.getProjectNameData()
        
        //Favorite Cell initialize.
        self.ProjectNameNumber_Favorite()
        
        //Beat AudioFile.
        // When playback is implemented, it is implemented with beat.
        drumloop = try? AKAudioFile(readFileName: "Malek-Smile.mp3", baseDir: .resources)
        Beatplayer = try? AKAudioPlayer(file: self.drumloop!)
        mp3Booster = AKBooster(Beatplayer!)
        mp3Booster?.gain = 1
        Beatplayer?.volume = 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoMainViewController(_ sender: UIBarButtonItem) {
        
        let ExplorerProject = self.storyboard?.instantiateViewController(withIdentifier: "lmProject") as! LMRootViewController
        self.present(ExplorerProject, animated: true, completion: nil)
    }
    
    @IBAction func GoDiscover(_ sender: UIBarButtonItem) {
        
        let discoverController = self.storyboard?.instantiateViewController(withIdentifier: "lmProject") as! LMRootViewController
        self.present(discoverController, animated: true, completion: nil)
    }
    
    @IBAction func GoCreateViewController(_ sender: UIBarButtonItem) {
        
        let createProeject = self.storyboard?.instantiateViewController(withIdentifier: "createProject") as! CreateProjectViewController
        self.present(createProeject, animated: true, completion: nil)
    }
    //when user click the playlist button this method is called.
    @IBAction func PlayList(_ sender: Any) {
        if btn_click == false {
            btn_click = true
            self.playlist_btn.backgroundColor = UIColor.init(red: 21/255, green: 15/255, blue: 94/255, alpha: 1)
            self.favorite_btn.backgroundColor = UIColor.init(red: 63/255, green: 52/255, blue: 115/255, alpha: 1)

            self.playListTable.reloadData()
            
        }
    }
    //when user click the Favorite button, this method is called.
    @IBAction func Favorites(_ sender: Any) {
        if btn_click == true {
            btn_click = false
            self.playlist_btn.backgroundColor = UIColor.init(red: 63/255, green: 52/255, blue: 115/255, alpha: 1)
            self.favorite_btn.backgroundColor = UIColor.init(red: 21/255, green: 15/255, blue: 94/255, alpha: 1)

            self.playListTable.reloadData()
        }
    }
    //the number of entire project data.
    func getProjectNameData() {
        marrProjectNameData = NSMutableArray()
        marrProjectNameData = ModelManager.getInstance().getAllProjectNameData()
    }
    //the number of entire Recording data.
    func getRecordingData(tableName: String) {
        marrRecordingData = NSMutableArray()
        marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.sql_tableName)
    }
    //the number of the entire "Favorite" audio file
    func ProjectNameNumber_Favorite() {
        self.getProjectNameData()
        self.projectNameArray = NSMutableArray()
        for i in 0..<marrProjectNameData.count {
            let projectlist: ProjectList = marrProjectNameData.object(at: i) as! ProjectList
            let name = projectlist.ProjectName
            self.sql_tableName = name
            self.getRecordingData(tableName: self.sql_tableName)
            //let recordingArray = NSMutableArray()
            for j in 0..<marrRecordingData.count {
                let recordInfo: RecordingInFo = marrRecordingData.object(at: j) as! RecordingInFo
                let serial = recordInfo.insertLyrics_Boll
                self.projectNameArray.add(serial)
            }
            //self.projectNameArray.add(recordingArray)
        }
        print(self.projectNameArray.count)
    }
    //Regarding every section, the number of each project of audio file
    func projectNameNumber_PlayList(Section: Int) {
        self.getProjectNameData()
        self.RecordingAllArray = NSMutableArray()
        let projectlist: ProjectList = marrProjectNameData.object(at: Section) as! ProjectList
        let name = projectlist.ProjectName
        self.sql_tableName = name
        self.getRecordingData(tableName: self.sql_tableName)
        for i in 0..<marrRecordingData.count {
            let recordInfo: RecordingInFo = marrRecordingData.object(at: i) as! RecordingInFo
            let serial = recordInfo.insertLyrics_Boll
            self.RecordingAllArray.add(serial)
        }
        
    }
    //Tableview datasource.
    func numberOfSections(in tableView: UITableView) -> Int {
        if btn_click == true {
            return sections.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if btn_click == true {
            
            return sections[section].items.count
        } else {
            return self.projectNameArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dequeCell", for: indexPath) as! PlayListCell
        
        if btn_click == true {
            cell.playName_list.text = sections[indexPath.section].items[indexPath.row]
            cell.radioWav_list.image = UIImage(named: "radioWave")
            cell.record_list.imageView?.image = UIImage(named: "create(record)")
            cell.playStop_list.imageView?.image = UIImage(named: "up_btn")
            cell.cellIndexPath = indexPath
            if cell.libraryDelegate == nil {
                cell.libraryDelegate = self
            }
            
            return cell

        }
        else{
            cell.playName_list.text = self.projectNameArray.object(at: indexPath.row) as? String
            cell.playStop_list.imageView?.image = UIImage(named: "up_btn")
            cell.record_list.imageView?.image = UIImage(named: "create(record)")
            cell.radioWav_list.image = UIImage(named: "radioWave")
            cell.cellIndexPath = indexPath
            if cell.libraryDelegate == nil {
                cell.libraryDelegate = self
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if btn_click == true {
            return sections[indexPath.section].collapsed! ? 0 : 50
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.getProjectNameData()
        if btn_click == true {
            let header = self.playListTable.dequeueReusableHeaderFooterView(withIdentifier: "sectionCell") as! CollapsibleTableViewHeader
            
            header.titleLabel.text = sections[section].name
            header.arrowImage.image = UIImage(named: "up_btn")
            header.setCollapsed(collapsed: sections[section].collapsed)
            header.section = section            
            header.delegate = self
            return header
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if btn_click == true {
            return 48
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if btn_click == true {
            if section == (sections.count - 1) {
                return 0
            }else {
                return 0
            }
        }else {
            return 0
        }
        
    }
    //Section animation initializing.
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
    
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        self.playListTable.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            self.playListTable.reloadRows(at: [IndexPath.init(row: i, section: section)], with: .automatic)
        }
        self.playListTable.endUpdates()
    }
    
    //LibraryDelegate method initialize.
    func playingBtn_Touched(cell: PlayListCell) {
//        if btn_click == true {
//            
//            let projectname = sections[cell.cellIndexPath.section].name
//            self.marrRecordingData = NSMutableArray()
//            self.marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: projectname!)
//            let recordInfo: RecordingInFo = self.marrRecordingData.object(at: cell.cellIndexPath.row) as! RecordingInFo
//            
//            if play_list == false {
//                
//                play_list = true
//                
//                if recordInfo.Record_Url == "" {
//                    print("Only have lyrics")
//                }else {
//                    let Url: URL! = NSURL(string: recordInfo.Record_Url)! as URL
//                    print("Url is \(Url!)")
//                    self.audioFile = try! AKAudioFile(forReading: Url!)
//                    player = try? AKAudioPlayer(file: self.audioFile!)
//                    player?.looping = false
//                    player?.volume = 3
//                    let booster = AKBooster(player!)
//                    mainMixer_Play = AKMixer(booster, mp3Booster!)
//                    AudioKit.output = mainMixer_Play
//                    AudioKit.start()
//                    player!.play()
//                    Beatplayer?.play()
//                    time = Timer.scheduledTimer(timeInterval: (player?.endTime)!, target: self, selector: #selector(NewProjectViewController.loadFileStop), userInfo: nil, repeats: false)
//                    
//                    
//                    cell.playStop_list.setImage(UIImage(named: "stop"), for: .normal)
//
//                }
//            }else {
//                if recordInfo.Record_Url == "" {
//                    print("Playing is false")
//                }else {
//                    play_list = false
//                    AudioKit.stop()
//                    player?.stop()
//                    try! self.player?.reloadFile()
//                    Beatplayer?.stop()
//                    cell.playStop_list.setImage(UIImage(named: "create(play)"), for: .normal)
//
//                }
//            }
//        }else {
//            if play_favorite == false {
//                
//            }
//        }
//        
    }
    
    func loadFileStop() {
//        player?.stop()
//        Beatplayer?.stop()
//        AudioKit.stop()
    }
}

protocol LibraryDelegate {
    func playingBtn_Touched(cell: PlayListCell)
}

class PlayListCell: UITableViewCell {
    
    var libraryDelegate: LibraryDelegate?
    var cellIndexPath: IndexPath!
    @IBOutlet var playName_list: UILabel!
    @IBOutlet var radioWav_list: UIImageView!
    @IBOutlet var playStop_list: UIButton!
    @IBOutlet var record_list: UIButton!
    
    @IBAction func PlayList_btnTouched(_ sender: UIButton) {
        if let delegate = libraryDelegate {
            delegate.playingBtn_Touched(cell: self)
        }
    }
    @IBAction func RecordList_btnTouched(_ sender: UIButton) {
    }
    
    
    
    
}

