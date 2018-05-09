//
//  CreateProjectViewController.swift
//  VocalRecording
//
//  Created by dev on 2/23/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

let reuseIdentifier = "recordingCell"

class CreateProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CreateButtonDelegate {
    
    //let manager = SwiftPlayerManager()
    
    var engine = AVAudioEngine()
    var player1: AVAudioPlayerNode!
    var f: AVAudioFile!

    
    @IBOutlet var tableView: UITableView!
    var tableCell: RecordingTableViewCell!
    
    var recordings = [URL]()
    var audioPlayer: AKAudioPlayer?
    var audioFile: AKAudioFile?
    var sampler: AKSampler?
    var mixer: AKMixer?
    var moogLader: AKMoogLadder?
    var bool = Bool()
    var succeed: String!
    var deletingBool = Bool()
    var playBool = Bool()
    var oneClick = Bool()
    var drumloop = try? AKAudioFile()
    var player_create: AKAudioPlayer?
    var mp3Booster: AKBooster?

    var marrRecordingData : NSMutableArray!
    var date: String!
    
    @IBOutlet var sideButton: UIBarButtonItem!
    let discover = DiscoverTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
       succeed = "view succeed"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear viewAnimation is \(succeed)")
        // set the recordings array
        listRecordings()
        playBool = true
        bool = false
        self.getProjectNameData()
    }
    //In SQLiteDatabase, the number of entire items of "playlist" table.
    func getProjectNameData()
    {
        marrRecordingData = NSMutableArray()
        marrRecordingData = ModelManager.getInstance().getAllProjectNameData()
        tableView.reloadData()
    }
    //In top bar, when user click "+" button, this method is called.
    @IBAction func SegueNewProject(_ sender: UIButton) {
        
        if playBool == false {
            self.Stop()
            //self.engine.disconnectNodeOutput(player1, bus: 0)
            
        }
        self.engine.stop()
        print("viewAnimation is \(succeed)")
        //DataBase Section.
        self.getProjectNameData()
        //In "Playlist" table, every Item is displayed with the current time.
        
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
    }
    
    @IBAction func ExploreBarItemTouched(_ sender: UIBarButtonItem) {
        if playBool == false {
            Stop()
        }
        self.engine.stop()
        
        let ExplorerProject = self.storyboard?.instantiateViewController(withIdentifier: "lmProject") as! LMRootViewController
        self.present(ExplorerProject, animated: true, completion: nil)
    }
    
    @IBAction func LibraryBarItemTouched(_ sender: UIBarButtonItem) {
        if playBool == false {
            Stop()
        }
        self.engine.stop()
        let libraryProject = self.storyboard?.instantiateViewController(withIdentifier: "libraryController") as! LibraryViewController
        self.present(libraryProject, animated: true, completion: nil)
    }
    
    
    @IBAction func leftMenuButtonTouched(_ sender: UIBarButtonItem){
        
//        discover.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    //In tableviewCell, when user click playbutton, this method is called.
    @IBAction func PlayRecordingProject(_ sender: UIButton) {
        //when Beat music is started.
        
        
        if playBool == true {
            self.play()
            sender.setImage(UIImage(named: "stop"), for: .normal)
            playBool = false
        }else {
            self.Stop()
            sender.setImage(UIImage(named: "create(play)"), for: .normal)
            playBool = true
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.marrRecordingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RecordingTableViewCell
        print("projectName is \(String(describing: cell.projectName.text))")
        
        let projectName:ProjectList = marrRecordingData.object(at: indexPath.row) as! ProjectList
        
        cell.projectName.text = projectName.ProjectName
        cell.projectName.tag = indexPath.row
        cell.projectName.isEnabled = false
        
        cell.projectName.delegate = self
        cell.playButton.tag = indexPath.row
        if cell.buttonDelegate == nil {
            cell.buttonDelegate = self
        }
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(_ tableView: UITableView, shouldSelectRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if playBool == false {
            self.Stop()
//            self.engine.disconnectNodeOutput(player1, bus: 0)
        }
        self.engine.stop()
        let newRecording = self.storyboard?.instantiateViewController(withIdentifier: "newProject") as! NewProjectViewController
        let projectName: ProjectList = marrRecordingData.object(at: indexPath.row) as! ProjectList
        newRecording.project = projectName
        newRecording.isEditRecording = true
        self.present(newRecording, animated: true, completion: nil)
    }
    
    // CreateButtonDelegate.
    func pencil_btnTouched(cell: RecordingTableViewCell) {
        cell.projectName.isEnabled = true
        cell.projectName.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {            
            let projectName:ProjectList = marrRecordingData.object(at: indexPath.row) as! ProjectList
            let isItemDeleted = ModelManager.getInstance().deleteProjectNameData(projectList:  projectName)
            if isItemDeleted {
                print("Successfully Deleted")
            }
            print("The Table name for deleting is \(projectName.ProjectName)")
            let isTableDeleted = ModelManager.getInstance().deleteItemTable(tableName: projectName.ProjectName)
            if isTableDeleted {
                print("Successfully Table deleted")
            }
            else {
                print("Table Deleting is false")
            }
            self.getProjectNameData()
            self.tableView.reloadData()
        }
    }
    //obtaining every audio file of URL that saved in document directory.
    func listRecordings() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            
            let urls = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.recordings = urls.filter({ (name: URL) -> Bool in
                return name.lastPathComponent.hasSuffix("m4a")})
        } catch let error as NSError {
            print(error.localizedDescription)
        }catch {
            print("something went wrong listing recordings")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //when user click pencil button, this method is called.
    func textFieldDidEndEditing(_ textField: UITextField) {
        let count = textField.tag
        print("count is \(count)")
        
        marrRecordingData = NSMutableArray()
        marrRecordingData = ModelManager.getInstance().getAllProjectNameData()
        let recordData: ProjectList = marrRecordingData.object(at: count) as! ProjectList
        let NameInfo: ProjectList = ProjectList()
        NameInfo.ProjectIndex = recordData.ProjectIndex
        print("NameInfo.ProjectIndex is \(NameInfo.ProjectIndex)")
        NameInfo.ProjectName = textField.text!
        print("NameInfo.ProjectName is \(NameInfo.ProjectName)")
        NameInfo.ProjectNumber = recordData.ProjectNumber
        print("NameInfo.ProjectNumber is \(NameInfo.ProjectNumber)")
        let isUpdated = ModelManager.getInstance().updateProjectNameData(projectList: NameInfo)
        if isUpdated {
            print("Successfully is updated")
        }else {
            print("Updating is false")
        }
    }
}
//this method is needed for above the listRecordings method.
extension CreateProjectViewController: FileManagerDelegate {
    
    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool {
        print("should move \(srcURL) to \(dstURL)")
        return true
    }
}

extension CreateProjectViewController: UIGestureRecognizerDelegate {
    
}



