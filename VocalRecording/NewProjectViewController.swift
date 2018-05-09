//
//  NewProjectViewController.swift
//  VocalRecording
//
//  Created by dev on 3/2/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

class NewProjectViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, ButtonOneCellDelegate, ButtonRecordCellDelegate {
    
    
    enum State {
        case readyToRecord
        case recording
        
    }
    enum State1 {
        case readyToRecord1
        case recording1
    }
    //OneCell tableviewcell delegate properties.
    var oneclick = Bool()
    var brownClick = Bool()
    var creatProject = CreateProjectViewController()
    
    //SQLite DataBase section.
    var tableName: String!
    var isEdit : Bool = false
    var recordingData: RecordingInFo!
    var marrRecordingData : NSMutableArray = NSMutableArray()
    var project: ProjectList!
    
    //View Section.
    var playerTimer: Timer?
    var time: Timer?
    var playingTime: Timer?
    var recordTme: Timer?
    var recordTme2: Timer?
    var beatTimer: Timer?
    var beatTimer1: Timer?
    var updateUI1: Timer?
    var updateUI2: Timer?
    var timeLabel: String!
    var timeLabel2: String!
    @IBOutlet var bottom_height: NSLayoutConstraint!
    var recordings = [URL]()
    
    @IBOutlet var threeOfButton: UIView!
    @IBOutlet var lyricsButton: UIButton!
    @IBOutlet var recordingButton: UIButton!
    @IBOutlet var AddRecording2View: UIView!
    @IBOutlet var addRecording2View_Button: UIButton!
    @IBOutlet var player_Timelabel: UILabel!
    
    
    var record_bool = false
    var top_number = Bool()
    var cancel_Alert = Bool()
    var textviewCell = Bool()
    var recordCell = Bool()
    var collectionArray = [String]()
    var n = 0
    var isEditRecording = false
    var offscreenCells: NSMutableDictionary!
    var recordingCell: UITableViewCell!
    var recordButton_tag = Int()
    var senderTag_btn = 0
    var senderTag = Int()
    var lyricsButtonTouched = false
    var recording2ButtonTouched = false
    var textView_temp = UITextView()
    //when user click "Lyrics" Button, this mehtod is called
    @IBAction func LyricsButtonTouched(_ sender: Any) {
        
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
        
        lyricsButtonTouched = true
        //Column inserting in SQLDatabase.------- TextView
        let recordingInfo: RecordingInFo = RecordingInFo()
        recordingInfo.lyrics_txt = ""
        recordingInfo.Record_Url = ""
        recordingInfo.insertLyrics_Boll = "right"
        recordingInfo.insertRecord2_Bool = "mistake"
        let add_date = "\(month)/\(day)/\(year)"
        recordingInfo.created_Date = add_date
        recordingInfo.created_time = "00:00:00"
        
        let NN = self.marrRecordingData.count + 1
        recordingInfo.recordName = "Lyrics\(NN)"
        let isInserted = ModelManager.getInstance().addRecordingData(recordInfo: recordingInfo, tableName: self.tableName)
        if isInserted {
            print("Successfully inserted recording Data(TextView)")
            print("recordinginfo.index is \(recordingInfo.RecordIndex)")
        }
        self.getRecordingData()
    }
    //When user click "Recording2" button, this method is called
    @IBAction func RecordingButton2Touched(_ sender: Any) {
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
        
        recordCell = true
        //Column inserting in SQLDatabase.-------- recording URL
        let recordingInfo: RecordingInFo = RecordingInFo()
        recordingInfo.lyrics_txt = ""
        recordingInfo.Record_Url = ""
        recordingInfo.insertRecord2_Bool = "right"
        recordingInfo.insertLyrics_Boll = "mistake"
        let add_date = "\(month)/\(day)/\(year)"
        recordingInfo.created_Date = add_date
        recordingInfo.created_time = "00:00:00"
        
        let NN = self.marrRecordingData.count + 1
        recordingInfo.recordName = "Recording\(NN)"

        let isInserted = ModelManager.getInstance().addRecordingData(recordInfo: recordingInfo, tableName: self.tableName)
        if isInserted {
            print("Successfully inserted recording Data(RecordingButton)")
        }
        self.getRecordingData()
        //brownButton click is false in the first.
        brownClick = false
        print("self.ModelManager.data of count is \(self.marrRecordingData.count)")
        textviewCell = false
        lyricsButtonTouched = false
        top_number = true
    }
    
    //TableView Section.
    @IBOutlet var TableView: UITableView!
    //Play Section.
    var url: URL!
    var audioFile: AKAudioFile?
    var recording = Bool()
    var loadFile = AKSampler()
    var Beat_bool = true
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    var timer: Timer!
    var plot: AKNodeOutputPlot!
    var playPlot: AKNodeOutputPlot!
    let noteFrequencies = [16.35,17.32,18.35,19.45,20.6,21.83,23.12,24.5,25.96,27.5,29.14,30.87]
    let noteNamesWithSharps = ["C", "C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"]
    let noteNamesWithFlats = ["C", "D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    // Recording Section.
    var recorder: AKNodeRecorder?
    var player: AKAudioPlayer?
    var Beatplayer: AKAudioPlayer?
    var Beatplayer1: AKAudioPlayer?
    var drumloop = try? AKAudioFile()
    var micBooster: AKBooster?
    var mp3Booster: AKBooster?
    var mp3Booster_play: AKBooster?
    
    var mainMixer_Record: AKMixer?
    var mainMixer_Play: AKMixer?
    var micMixer: AKMixer?
    var audioInputPlot: EZAudioPlot!
    //var audioInputPlot_record: EZAudioPlot!
    @IBOutlet var audioOutPlot: EZAudioPlot!
    @IBOutlet var waveForm: UIImageView!
    
    var recordingBool = Bool()
    var playBool = Bool()
    var volumeBool = Bool()
    var first = Bool()
    
    var currentFileName: String!
    var circlebtn_touched = Bool()
    
    var state = State.readyToRecord
    var state1 = State1.readyToRecord1
    var iRecordCnt = 1
    
    @IBOutlet var AddBeatView: UIView!
    @IBOutlet var infoLabel1: UILabel!
    @IBOutlet var AddBeatButton: UIButton!
    @IBOutlet var startView: UIView!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var view_volumeSlider: UIView!
    @IBOutlet var playButton: UIButton!
    //when user click volume icon, this method is called.
    @IBAction func ChangeVolume(_ sender: UISlider) {
        
//        if Bool_recordState == true {
//            self.loadFile.volume = Double(sender.value)
//        }
//        else{
//             player?.volume = Double(sender.value)
//        }
       
        //player?.volume = Double(sender.value)
        Beatplayer?.volume = Double(sender.value)
    }
    //When user click "Add beat or import music" stick button, this method is called.
    @IBAction func AddBeatsButtonTouched(_ sender: UIButton) {
        self.startView.isHidden = true
        self.AddBeatView.isHidden = false
        self.AddBeatButton.isHidden = true
    }
    //when user click "rotate" button, this method is called.
    @IBAction func AddRecording2Button(_ sender: UIButton) {
        self.AddRecording2View.isHidden = false
        self.bottom_height.constant = 120
        self.addRecording2View_Button.setImage(UIImage(named: "rotate_select"), for: .normal)
    }
    //when user click "+" stick button, this method is called.
    @IBAction func AddRecording2(_ sender: UIButton) {
        self.threeOfButton.isHidden = false
        self.AddRecording2View.isHidden = true
    }
    //when user click the play button of bottom bar, this method is called.
    @IBAction func PlayButtonTouched(_ sender: UIButton) {
        
        //when user click this button in the first, and when not starting recording, this part is called.
        if first == true {
            
            if Beat_bool == false {
                self.playButton.setImage(UIImage(named: "stop"), for: .normal)
                
                let beatMixer = AKMixer(mp3Booster!)
                AudioKit.output = beatMixer
                AudioKit.start()
                Beatplayer?.volume = 1
                Beatplayer?.play()
                let sss = 1 / 60
                print("timeInterval is \(sss)")
                beatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(sss), target: self, selector: #selector(NewProjectViewController.Time_Label), userInfo: nil, repeats: true)
                self.audioOutPlot.isHidden = false
                self.playerPlot()
                self.audioOutPlot.addSubview(playPlot)
            }else {
                self.playButton.setImage(UIImage(named: "stop"), for: .normal)
                let beatMixer = AKMixer(mp3Booster!)
                AudioKit.output = beatMixer
                AudioKit.start()
                Beatplayer?.volume = 1
                Beatplayer?.play()
                let sss = 1 / 60
                print("timeInterval is \(sss)")
                beatTimer1 = Timer.scheduledTimer(timeInterval: TimeInterval(sss), target: self, selector: #selector(NewProjectViewController.Time_Label), userInfo: nil, repeats: true)
                self.audioOutPlot.isHidden = false
                self.playerPlot()
                self.audioOutPlot.addSubview(playPlot)
            }
                Beat_bool = true
                first = false
        }else if Beat_bool == true {
                Beatplayer?.stop()
                self.playerPlotStop()
                AudioKit.stop()
            
                self.record_bool = true
                self.TableView.reloadData()

                
                self.playButton.setImage(UIImage(named: "play_btn"), for: .normal)
                Beat_bool = false
                first = true
        }
        //After ending the recording, when user click this button, this part is called.
        else {
                listRecordings()
            
            if self.recordings.count > 0{
                if playBool == false {
                    playBool = true
                    recording = false
                    //infoLabel.text = "Playing..."
                    mic.avAudioNode.removeTap(onBus: 0)
                    // When playback is implemented, it is implemented with beat.
                    drumloop = try? AKAudioFile(readFileName: "Malek-Smile.mp3", baseDir: .resources)
                    Beatplayer1 = try? AKAudioPlayer(file: self.drumloop!)
                    mp3Booster_play = AKBooster(Beatplayer1!)
                    mp3Booster_play?.gain = 1
                    Beatplayer1?.volume = 1
                    
                    //From document direcotory URL, it should be played recorded audio file.
                    self.marrRecordingData = NSMutableArray()
                    self.marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
                    let recordingInfo1: RecordingInFo = self.marrRecordingData.object(at: self.senderTag) as! RecordingInFo
                    print("senderTag is \(self.senderTag)")
                    if recordingInfo1.Record_Url == ""  {
                        
                    }
                    let Url: URL! = NSURL(string: recordingInfo1.Record_Url)! as URL
                    print("Url is \(Url!)")
                    self.audioFile = try! AKAudioFile(forReading: Url!)
                    player = try? AKAudioPlayer(file: self.audioFile!)
                    player?.looping = false
                    player?.volume = 3
                    let booster = AKBooster(player!)
                    mainMixer_Play = AKMixer(booster, mp3Booster_play!)
                    AudioKit.output = mainMixer_Play
                    AudioKit.start()
                    player!.play()
                    Beatplayer1?.play()
                    let ss = 1 / 60
                    print("timeInterval is \(ss)")
                    playingTime = Timer.scheduledTimer(timeInterval: TimeInterval(ss), target: self, selector: #selector(NewProjectViewController.Time_Label), userInfo: nil, repeats: true)
                    //button state display.
                    self.playButton.setImage(UIImage(named: "stop"), for: .normal)
                    time = Timer.scheduledTimer(timeInterval: (player?.endTime)!, target: self, selector: #selector(NewProjectViewController.loadFileStop), userInfo: nil, repeats: false)
                    self.audioOutPlot.isHidden = false
                    self.playerPlot()
                    //Timer initialize
                    playerTimer = Timer.scheduledTimer(timeInterval: (player?.endTime)!, target: self, selector: #selector(NewProjectViewController.playerPlotStop), userInfo: nil, repeats: false)
                    first = false
                    
                }else if playBool == true {
                    
                    AudioKit.stop()
                    Beatplayer1?.stop()
                    player?.stop()
                    try! self.player?.reloadFile()
                    playBool = false
                    self.playerPlotStop()
                    
                    self.record_bool = true
                    self.TableView.reloadData()

                    self.playButton.setImage(UIImage(named: "play_btn"), for: .normal)
                }
            }
        }
    }
    
    func Time_Label() {
        if player?.isPlaying == true {
            let min = Int((player?.currentTime)! / 60)
            let sec = Int((player?.currentTime.truncatingRemainder(dividingBy: 60))!)
            let minisec = Int(((player?.currentTime.truncatingRemainder(dividingBy: 60))! - sec) * 60)
            let s = String(format: "%02d:%02d:%02d", min, sec, minisec)
            self.player_Timelabel.text = s
        }
        if Beatplayer?.isPlaying == true {
            let min = Int((Beatplayer?.currentTime)! / 60)
            let sec = Int((Beatplayer?.currentTime.truncatingRemainder(dividingBy: 60))!)
            let minisec = Int(((Beatplayer?.currentTime.truncatingRemainder(dividingBy: 60))! - sec) * 60)
            let s = String(format: "%02d:%02d:%02d", min, sec, minisec)
            self.player_Timelabel.text = s
        }
    }
    
    func loadFileStop() {
        
        Beatplayer1?.stop()
        player?.stop()
        AudioKit.stop()
        playBool = false
        try! self.player?.reloadFile()
        self.playerPlotStop()
        self.record_bool = true
        self.playButton.setImage(UIImage(named: "play_btn"), for: .normal)
        self.TableView.reloadData()
    }
    
    struct Constants {
        static let empty = ""
    }
    
    
    func setupUIForRecording () {
        micBooster!.gain = 1
    }
    //When recording, it shows.
    func setupPlot() {
        plot = AKNodeOutputPlot(mic!, frame: self.audioInputPlot.bounds)
        
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.gray
        plot.backgroundColor = UIColor.darkGray
        audioInputPlot.addSubview(plot)
    }
    //When playing, it shows.
    func playerPlot() {
        if first == true {
            playPlot = AKNodeOutputPlot(Beatplayer!, frame: self.audioOutPlot.bounds)
        }
        else {
            playPlot = AKNodeOutputPlot(player!, frame: self.audioOutPlot.bounds)
        }
        playPlot.plotType = .rolling
        playPlot.shouldFill = true
        playPlot.shouldMirror = true
        if first == true {
            playPlot.gain = 0.75
        }else {
            playPlot.gain = 0.35
        }
        playPlot.color = UIColor.darkGray
        playPlot.backgroundColor = UIColor.black
        audioOutPlot.addSubview(playPlot)
    }
    //When playing is finished, it is removed from superView.
    func playerPlotStop() {
        self.playPlot.removeFromSuperview()
        self.audioOutPlot.isHidden = true
    }
    
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
        print(self.recordings.count)
        
    }
    
    func deleteRecording(_ url:URL) {
        
        print("removing file at \(url.absoluteString)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error deleting recording")
        }
        
        DispatchQueue.main.async(execute: {
            self.listRecordings()
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        listRecordings()
        first = true
        //---------------------
        drumloop = try? AKAudioFile(readFileName: "Malek-Smile.mp3", baseDir: .resources)
        Beatplayer = try? AKAudioPlayer(file: self.drumloop!)
        mp3Booster = AKBooster(Beatplayer!)
        mp3Booster?.gain = 1
        Beatplayer?.volume = 3
        
        //----------------------
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
        // Clean tempFiles !
        AKAudioFile.cleanTempDirectory()
        // Session settings
        AKSettings.bufferLength = .medium
        do {
            try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
        } catch { print("Errored setting category.") }
        // Patching
        micMixer = AKMixer(mic)
        micBooster = AKBooster(micMixer!)
        micBooster?.gain = 0
        // Will set the level of microphone monitoring
        recorder = try? AKNodeRecorder(node: micMixer!)
        mainMixer_Record = AKMixer(micBooster!, mp3Booster!, silence!)

        self.audioOutPlot.isHidden = true
    }
    // database intialize
    func getRecordingData()
    {
        marrRecordingData = NSMutableArray()
        marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
        print("The MarrStudentData is \(self.marrRecordingData.count)")
        self.TableView.reloadData()
    }
    //this method is updated EZAudioPlot view in continuously.
    func updateUI() {
        if tracker.amplitude > 0.1 {
            var frequency = Float(tracker.frequency)
            while (frequency > Float(noteFrequencies[noteFrequencies.count-1])) {
                frequency = frequency / 2.0
            }
            while (frequency < Float(noteFrequencies[0])) {
                frequency = frequency * 2.0
            }
            var minDistance: Float = 10000.0
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if (distance < minDistance){
                    minDistance = distance
                }
            }
        }
    }
    //this method is implemented when view should be went into PurchaseViewController
    @IBAction func SeguePublish(_ sender: UIBarButtonItem) {
        if playBool == true {
            player?.stop()
            Beatplayer?.stop()
            AudioKit.stop()
            try! recorder?.reset()
            try! self.player?.reloadFile()
            
        }
        print("count is \(self.recordings.count)")
        //print("SHareingManager  string is \(SharingMananger.sharedInstance.shareTextView[self.recordings.count - 1])")
        let create = self.storyboard?.instantiateViewController(withIdentifier: "purchase") as! PurchaseViewController
        self.present(create, animated: true, completion: nil)
    }
    //when it is to go to the main view, this method is called.
    @IBAction func SegueMainView(_ sender: UIBarButtonItem) {
        
        if playBool == true {
            player?.stop()
            Beatplayer?.stop()
            AudioKit.stop()
            try! recorder?.reset()
            try! self.player?.reloadFile()
            //mic.avAudioNode.removeTap(onBus: 0)
        }
        
        let mainview = self.storyboard?.instantiateViewController(withIdentifier: "lmProject") as! LMRootViewController
        self.present(mainview, animated: true, completion: nil)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        listRecordings()
        //playing state is false
        playBool = false
        //TableView bottom height initialize.
        self.bottom_height.constant = 120
        self.view_volumeSlider.isHidden = true
        self.volumeBool = false
        //Record CircleButton touche Bool initialize.
        circlebtn_touched = false
        //When recordCell is inserted.
        top_number = true
        //When Alert View of Cancel button is clicked.
        cancel_Alert = false
        //keyboard dismiss.
        self.hideKeyboardWhenTappedAround()
        //slider rotating
        volumeSlider.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        //tableView section.
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.register(UINib(nibName: "OneCell", bundle: nil), forCellReuseIdentifier: "onecell")
        self.TableView.register(UINib(nibName: "TextViewCell", bundle: nil), forCellReuseIdentifier: "text")
        self.TableView.register(UINib(nibName: "RecordViewCell", bundle: nil), forCellReuseIdentifier: "record")
        recordCell = false
        textviewCell = false
        
        //SQLDatabase intialize
        if isEditRecording == true {
            self.tableName = project.ProjectName
            print("New Project View tablename is \(self.tableName)")
            marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
            self.TableView.reloadData()
            self.recordingBool = false
        }else {
            
            self.getRecordingData()
            self.recordingBool = true

        }
        print("the current TableName is \(self.tableName)")
        
        self.AddBeatButton.isHidden = false
        self.AddBeatView.isHidden = true
        self.threeOfButton.isHidden = true
        self.AddRecording2View.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TalbleViewDatasource.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.marrRecordingData.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let right = "right"
        let recordData = marrRecordingData.object(at: indexPath.row) as! RecordingInFo
        if recordData.insertLyrics_Boll == right {
            let textCell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! TextViewCell
            textCell.insertTxtView.text = recordData.lyrics_txt
            textCell.insertTxtView.tag = indexPath.row
            textCell.insertTxtView.delegate = self
            //tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            return textCell
        }
        else if recordData.insertRecord2_Bool == right {
            marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
            let recordData: RecordingInFo = marrRecordingData.object(at: indexPath.row) as! RecordingInFo
            let recordCell = tableView.dequeueReusableCell(withIdentifier: "record", for: indexPath) as! RecordViewCell
            recordCell.insertRecord_btn.tag = indexPath.row
            recordCell.insertRecord_btn.isEnabled = self.record_bool
            recordCell.mSelectView.tag = indexPath.row
            self.audioInputPlot.tag = indexPath.row
            recordCell.recordDate_RCell.text = recordData.created_Date
            recordCell.recordName_RCell.text = recordData.recordName
            //When recording circle button click audioInputPlot displaying.
            if recorder?.isRecording == true {
                if self.senderTag == recordCell.insertRecord_btn.tag {
                    recordCell.recordTime_RCell.text = timeLabel2
                }
            }else {
                recordCell.recordTime_RCell.text = recordData.created_time
            }
            if self.circlebtn_touched == true {
                if self.audioInputPlot.tag == self.senderTag {
                    self.audioInputPlot = recordCell.recordViewCell
                }
            }
            //recordCell.mSelectView.isHidden = true
            recordCell.view_volumeSlider.isHidden = true
            //tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            if recordCell.buttonDelegate == nil {
                recordCell.buttonDelegate = self
            }
            return recordCell
        }
        else {
            
            marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
            let recordData: RecordingInFo = marrRecordingData.object(at: indexPath.row) as! RecordingInFo
            let oneCell = tableView.dequeueReusableCell(withIdentifier: "onecell", for: indexPath) as! OneCell
            oneCell.insertTextView.text = recordData.lyrics_txt
            oneCell.insertRecord_btn.tag = indexPath.row
            oneCell.insertRecord_btn.isEnabled = self.record_bool
            oneCell.insertTextView.tag = indexPath.row
            oneCell.insertTextView.delegate = self
            oneCell.view_VolumeSliderOne.isHidden = true
            oneCell.recordName.text = recordData.recordName
            oneCell.recordName.isHidden = false
            oneCell.recordingDate_one.text = recordData.created_Date
            oneCell.recordingDate_one.isHidden = false
            if recorder?.isRecording == true {
                if self.senderTag == oneCell.insertRecord_btn.tag {
                    oneCell.recordTime.text = timeLabel
                }
            }else {
                oneCell.recordTime.text = recordData.created_time
            }
            oneclick = false
            self.audioInputPlot = oneCell.oneCellView
            //self.audioInputPlot.tag = indexPath.row
                        
            if oneCell.buttonDelegate == nil {
                oneCell.buttonDelegate = self
            }            
            return oneCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let button1 = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            
            let recordInfo: RecordingInFo = self.marrRecordingData.object(at: indexPath.row) as! RecordingInFo
            let number = recordInfo.RecordIndex
            
            let alert = UIAlertController(title: "",
                                          message: "Are you sure you want to delete Recording \(number)?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                
                let isDeleted = ModelManager.getInstance().deleteRecordingData(recordInfo: recordInfo, tableName: self.tableName)
                if isDeleted {
                    if recordInfo.Record_Url == "" {
                        print("Record URL Data is not!.")
                    }
                    else {
                        let Url: URL! = NSURL(string: recordInfo.Record_Url)! as URL
                        self.deleteRecording(Url!)
                        print("Successfully Deleted")
                    }
                }
                self.getRecordingData()
                self.playButton.isEnabled = false
                self.record_bool = true

                self.TableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
                print("The replace recording was canceled")
            }))
            self.present(alert, animated:true, completion:nil)

        }
        button1.backgroundColor = UIColor.lightGray
        return [button1]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let right = "right"
        let recordData = marrRecordingData.object(at: indexPath.row) as! RecordingInFo
        print("insetLyrics_Bool is \(recordData.insertLyrics_Boll)")
        if recordData.insertLyrics_Boll == right {
            return 132
        }
        else if recordData.insertRecord2_Bool == right {
            return 190
        }
        else {
            return 318
        }
        
    }
    
    // ButtOneCellDelegate.
    func Record_oneCell(cell: OneCell) {
        
        self.senderTag = cell.insertRecord_btn.tag
        if self.senderTag == 0 {
            
            self.circlebtn_touched = true
            print("WHen RecordCircleButton touche is \(cell.insertRecord_btn.tag)")
            self.getRecordingData()
            print("marrRecordingData.count is \(marrRecordingData.count)")
            let nb = marrRecordingData.count - 1
            if cell.insertRecord_btn.tag == nb {
                if top_number == true {
                    self.recordingBool = true
                    top_number = false
                }else {
                    print("This button is double clicked")
                }
            }
            if state == .readyToRecord {
                cell.insertRecord_btn.setImage(UIImage(named: "recordStarting_select"), for: .normal)
            }else {
                cell.insertRecord_btn.setImage(UIImage(named: "recordStarting"), for: .normal)
            }
            
            self.TableView.reloadData()
            // Recording session
            SharingMananger.sharedInstance.isCreated = true
            switch state {
            case .readyToRecord :
                state = .recording
                self.playButton.isEnabled = false
                first = false
                //AudioKit Starting.
                AudioKit.output = mainMixer_Record
                AudioKit.start()
                // microphone will be monitored while recording. only if headphones are plugged
                if AKSettings.headPhonesPlugged {
                    micBooster!.gain = 1
                }
                
                time?.invalidate()
                time = nil
                playerTimer?.invalidate()
                playerTimer = nil
                playingTime?.invalidate()
                playingTime = nil
                beatTimer?.invalidate()
                beatTimer = nil
                beatTimer1?.invalidate()
                beatTimer1 = nil
                //At the recording Cell, when circle record Button is click in first, it calls.
                if self.recordingBool == true {
                    do {
                        self.setupUIForRecording()
                        try recorder?.record()
                        Beatplayer?.play()
                        updateUI1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(NewProjectViewController.updateUI), userInfo: nil, repeats: true)
                        
                        let ss = 1 / 60
                        print("timeInterval is \(ss)")
                        recordTme = Timer.scheduledTimer(timeInterval: TimeInterval(ss), target: self, selector: #selector(NewProjectViewController.RecordTime), userInfo: nil, repeats: true)
                        
                        self.setupPlot()
                    } catch { print("Errored recording.") }
                    self.recordingBool = false
                }
                    // At the recording Cell, when circle record Button is click in more second, it calls.
                else{
                    let alert = UIAlertController(title: "Recorder",
                                                  message: "Would you please replace your previous recording?",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                        
                        self.RecordButtonTouchAgain()
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
                        self.cancel_Alert = true
                        print("The replace recording was canceled")
                    }))
                    self.present(alert, animated:true, completion:nil)
                }
                recording = true
            case .recording :
                recordTme?.invalidate()
                recordTme = nil
                updateUI1?.invalidate()
                updateUI1 = nil
                // Microphone monitoring is muted.
                micBooster!.gain = 0
                self.playButton.isEnabled = true
                
                // Bottom bar show/hidden.
                self.bottom_height.constant = 60
                self.AddRecording2View.isHidden = true
                self.threeOfButton.isHidden = true
                self.addRecording2View_Button.setImage(UIImage(named: "rotate"), for: .normal)
                
                //When recording file is saved in document direcotry, it shows current time.
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd--HH-mm-ss"
                currentFileName = "recording-\(format.string(from: Date())).m4a"
                print(currentFileName)
                let recordedDuration = recorder != nil ? recorder?.audioFile?.duration  : 0
                if recordedDuration! > 0.0 {
                    recorder?.stop()
                    Beatplayer?.stop()
                    AudioKit.stop()
                    // Convert to .caf file into m4a file.
                    let fileName = recorder?.audioFile?.url.lastPathComponent
                    do {
                        let nonExistentFile = try AKAudioFile(readFileName: fileName!, baseDir: .temp)
                        nonExistentFile.exportAsynchronously(name: currentFileName, baseDir: .documents, exportFormat: .m4a) { exportedFile, error in
                            print("myExportCallBack has been triggered. It means that export ended")
                            if error == nil {
                                print("Export succeeded")
                                self.url = exportedFile?.directoryPath.appendingPathComponent((exportedFile?.fileNamePlusExtension)!)
                                // the recording url is saved in sql database tablename.
                                print("WHen export succeed sendertag is \(self.senderTag)")
                                self.marrRecordingData = NSMutableArray()
                                self.marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
                                let recordData: RecordingInFo = self.marrRecordingData.object(at: self.senderTag) as! RecordingInFo
                                let recordingInfo: RecordingInFo = RecordingInFo()
                                recordingInfo.RecordIndex = recordData.RecordIndex
                                recordingInfo.lyrics_txt = recordData.lyrics_txt
                                recordingInfo.insertLyrics_Boll = recordData.insertLyrics_Boll
                                recordingInfo.insertRecord2_Bool = recordData.insertRecord2_Bool
                                recordingInfo.Record_Url = self.url.absoluteString
                                print("recordingInfo.Record_Url is \(recordingInfo.Record_Url)")
                                recordingInfo.created_Date = recordData.created_Date
                                recordingInfo.recordName = recordData.recordName
                                recordingInfo.created_time = recordData.created_time
                                let isUpdated = ModelManager.getInstance().updateRecordingData(recordInfo: recordingInfo, tableName: self.tableName)
                                if isUpdated {
                                    print("Successfully is updated")
                                }
                                else {
                                    print("Updating is false")
                                }
                            }
                            else {
                                print("Export failed\(String(describing: error))")
                            }
                        }
                    } catch let error as NSError {
                        print("There's an error: \(error)")
                    }
                    self.record_bool = false
                    circlebtn_touched = false
                    self.TableView.reloadData()
                    state = .readyToRecord
                }
                self.plot.removeFromSuperview()
            }
            
            
            
            if self.cancel_Alert == true {
                cell.insertRecord_btn.setImage(UIImage(named: "recordStarting"), for: .normal)
                self.cancel_Alert = false
            }
            marrRecordingData = NSMutableArray()
            marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)

        }
    }
    
    func RecordTime() {
        let min = Int((recorder?.recordedDuration)! / 60)
        let sec = Int((recorder?.recordedDuration.truncatingRemainder(dividingBy: 60))!)
        let minisec = Int(((recorder?.recordedDuration.truncatingRemainder(dividingBy: 60))! - sec) * 60)
        timeLabel = String(format: "%02d:%02d:%02d", min, sec, minisec)
        self.TableView.reloadData()

    }
    
    func RecordButtonTouchAgain() {
        
        print("RecordingButton was tapped again")
        
        // Will set the level of microphone monitoring
        let recordingInfo: RecordingInFo = self.marrRecordingData.object(at: self.senderTag) as! RecordingInFo
        self.deleteRecording(URL(fileURLWithPath: recordingInfo.Record_Url))
        do {
            try self.recorder?.reset()
        } catch { print("Errored resetting.") }
        self.setupUIForRecording()
        do {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(NewProjectViewController.updateUI), userInfo: nil, repeats: true)
            self.setupPlot()
            
            try self.recorder?.record()
            
            let ss = 1 / 60
            print("timeInterval is \(ss)")
            self.recordTme = Timer.scheduledTimer(timeInterval: TimeInterval(ss), target: self, selector: #selector(NewProjectViewController.RecordTime), userInfo: nil, repeats: true)
            
            self.Beatplayer?.play()
        } catch { print("Errored recording.") }
        
        

    }
    
    //At OneCell of tableview, when brown_button click.
    func BrownTouched(cell: OneCell) {
        if recorder?.isRecording == true {
            if oneclick == false {
                cell.btn_brownColor.frame = CGRect(x: 54, y: 30, width: 319, height: 2)
                self.plot.gain = 0.35
                oneclick = true
                
            }else {
                cell.btn_brownColor.frame = CGRect(x: 54, y: 7, width: 319, height: 2)
                self.plot.gain = 1
                oneclick = false
            }

        }
    }
    //When "M" button click
    func MTouched(cell: OneCell) {
        if recorder?.isRecording == true {
            cell.btn_brownColor.isHidden = true
            cell.oneCellView.isHidden = true
            cell.sAmView.isHidden = true
            cell.MselectView.isHidden = false
            cell.MselectButton_one.setTitle("M", for: .normal)
            cell.MselectButton_one.setTitleColor(UIColor.init(red: 161/255, green: 78/255, blue: 51/255, alpha: 1), for: .normal)
            //recorder?.stop()
            micBooster?.gain = 0
            mic.stop()
        }
    }
    //When "brown M" button click
    func MselectTouched(cell: OneCell) {
            cell.btn_brownColor.isHidden = false
            cell.oneCellView.isHidden = false
            cell.sAmView.isHidden = false
            cell.MselectView.isHidden = true
            cell.MselectButton_one.setTitle("", for: .normal)
        
                //try recorder?.record()
                micBooster?.gain = 1
                mp3Booster?.gain = 1
                mic.start()
                
        
    }
    //When "S" button click
    func STouched(cell: OneCell) {
        if recorder?.isRecording == true {
            mp3Booster?.gain = 0
            cell.btn_brownColor.isHidden = true
            cell.oneCellView.isHidden = true
            cell.sAmView.isHidden = true
            cell.MselectView.isHidden = false
            
            cell.MselectButton_one.setTitle("S", for: .normal)
            cell.MselectButton_one.setTitleColor(UIColor.init(red: 161/255, green: 78/255, blue: 51/255, alpha: 1), for: .normal)

        }
    }
    //When Volume slider click
    func ShowVolumeSlider_One(cell: OneCell) {
        if recorder?.isRecording == true {
            if volumeBool == false {
                cell.view_VolumeSliderOne.isHidden = false
                volumeBool = true
            }else {
                cell.view_VolumeSliderOne.isHidden = true
                volumeBool = false
            }
        }
    }
    //when volume slider click, this method is called.
    func ChangeVolume_One(cell: OneCell) {
        if recorder?.isRecording == true {
            Beatplayer?.volume = Double(cell.volumeSlider_One.value)
        }
    }
    
    // ButtonRecordCellDelegate.
    
    func RecordButton_Touched(cell: RecordViewCell) {
        
        self.senderTag = cell.insertRecord_btn.tag
        
        
        if self.senderTag > 0 {
            
            self.circlebtn_touched = true
            print("WHen RecordCircleButton touche is \(cell.insertRecord_btn.tag)")
            self.getRecordingData()
            print("marrRecordingData.count is \(marrRecordingData.count)")
            let nb = marrRecordingData.count - 1
            if cell.insertRecord_btn.tag == nb {
                if top_number == true {
                    self.recordingBool = true
                    top_number = false
                }else {
                    print("This button is double clicked")
                }
            }
            if state1 == .readyToRecord1 {
                cell.insertRecord_btn.setImage(UIImage(named: "recordStarting_select"), for: .normal)
            }else {
                cell.insertRecord_btn.setImage(UIImage(named: "recordStarting"), for: .normal)
            }
            self.TableView.reloadData()
            
            // Recording session
            SharingMananger.sharedInstance.isCreated = true
            switch state1 {
            case .readyToRecord1 :
                state1 = .recording1
                self.playButton.isEnabled = false
                first = false
                //AudioKit Starting.
                AudioKit.output = mainMixer_Record
                AudioKit.start()
                // microphone will be monitored while recording. only if headphones are plugged
                if AKSettings.headPhonesPlugged {
                    micBooster!.gain = 1
                }
                
                time?.invalidate()
                time = nil
                playerTimer?.invalidate()
                playerTimer = nil
                playingTime?.invalidate()
                beatTimer = nil
                beatTimer?.invalidate()
                playingTime = nil
                beatTimer1?.invalidate()
                beatTimer1 = nil
                //At the recording Cell, when circle record Button is click in first, it calls.
                if self.recordingBool == true {
                    do {
                        self.setupUIForRecording()
                        try recorder?.record()
                        Beatplayer?.play()
                        updateUI2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(NewProjectViewController.updateUI), userInfo: nil, repeats: true)
                        
                        let ss = 1 / 60
                        print("timeInterval is \(ss)")
                        recordTme2 = Timer.scheduledTimer(timeInterval: TimeInterval(ss), target: self, selector: #selector(NewProjectViewController.RecordTime1), userInfo: nil, repeats: true)
                        
                        self.setupPlot()
                    } catch { print("Errored recording.") }
                    self.recordingBool = false
                }
                    // At the recording Cell, when circle record Button is click in more second, it calls.
                else{
                    let alert = UIAlertController(title: "Recorder",
                                                  message: "Would you please replace your previous recording?",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                        
                        self.RecordButtonTouchAgain1()
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
                        self.cancel_Alert = true
                        print("The replace recording was canceled")
                    }))
                    self.present(alert, animated:true, completion:nil)
                }
                recording = true
            case .recording1 :
                recordTme2?.invalidate()
                recordTme2 = nil
                updateUI2?.invalidate()
                updateUI2 = nil
                // Microphone monitoring is muted.
                micBooster!.gain = 0
                self.playButton.isEnabled = true
                
                // Bottom bar show/hidden.
                self.bottom_height.constant = 60
                self.AddRecording2View.isHidden = true
                self.threeOfButton.isHidden = true
                self.addRecording2View_Button.setImage(UIImage(named: "rotate"), for: .normal)
                
                //When recording file is saved in document direcotry, it shows current time.
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd--HH-mm-ss"
                currentFileName = "recording-\(format.string(from: Date())).m4a"
                print(currentFileName)
                let recordedDuration = recorder != nil ? recorder?.audioFile?.duration  : 0
                if recordedDuration! > 0.0 {
                    recorder?.stop()
                    Beatplayer?.stop()
                    AudioKit.stop()
                    // Convert to .caf file into m4a file.
                    let fileName = recorder?.audioFile?.url.lastPathComponent
                    do {
                        let nonExistentFile = try AKAudioFile(readFileName: fileName!, baseDir: .temp)
                        nonExistentFile.exportAsynchronously(name: currentFileName, baseDir: .documents, exportFormat: .m4a) { exportedFile, error in
                            print("myExportCallBack has been triggered. It means that export ended")
                            if error == nil {
                                print("Export succeeded")
                                self.url = exportedFile?.directoryPath.appendingPathComponent((exportedFile?.fileNamePlusExtension)!)
                                // the recording url is saved in sql database tablename.
                                print("WHen export succeed sendertag is \(self.senderTag)")
                                self.marrRecordingData = NSMutableArray()
                                self.marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
                                let recordData: RecordingInFo = self.marrRecordingData.object(at: self.senderTag) as! RecordingInFo
                                let recordingInfo: RecordingInFo = RecordingInFo()
                                recordingInfo.RecordIndex = recordData.RecordIndex
                                recordingInfo.lyrics_txt = recordData.lyrics_txt
                                recordingInfo.insertLyrics_Boll = recordData.insertLyrics_Boll
                                recordingInfo.insertRecord2_Bool = recordData.insertRecord2_Bool
                                recordingInfo.Record_Url = self.url.absoluteString
                                print("recordingInfo.Record_Url is \(recordingInfo.Record_Url)")
                                recordingInfo.created_Date = recordData.created_Date
                                recordingInfo.recordName = recordData.recordName
                                recordingInfo.created_time = recordData.created_time
                                let isUpdated = ModelManager.getInstance().updateRecordingData(recordInfo: recordingInfo, tableName: self.tableName)
                                if isUpdated {
                                    print("Successfully is updated")
                                }
                                else {
                                    print("Updating is false")
                                }
                            }
                            else {
                                print("Export failed\(String(describing: error))")
                            }
                        }
                    } catch let error as NSError {
                        print("There's an error: \(error)")
                    }
                    self.record_bool = false
                    circlebtn_touched = false
                    self.TableView.reloadData()
                    state1 = .readyToRecord1
                }
                self.plot.removeFromSuperview()
            }
            
            
            
            if self.cancel_Alert == true {
                cell.insertRecord_btn.setImage(UIImage(named: "recordStarting"), for: .normal)
                self.cancel_Alert = false
            }
            marrRecordingData = NSMutableArray()
            marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)

        }
    }
    
    func RecordTime1() {
        let min = Int((recorder?.recordedDuration)! / 60)
        let sec = Int((recorder?.recordedDuration.truncatingRemainder(dividingBy: 60))!)
        let minisec = Int(((recorder?.recordedDuration.truncatingRemainder(dividingBy: 60))! - sec) * 60)
        timeLabel2 = String(format: "%02d:%02d:%02d", min, sec, minisec)
        self.TableView.reloadData()
        
        
    }
    
    func RecordButtonTouchAgain1() {
        
        print("RecordingButton was tapped again")
        
        // Will set the level of microphone monitoring
        let recordingInfo: RecordingInFo = self.marrRecordingData.object(at: self.senderTag) as! RecordingInFo
        self.deleteRecording(URL(fileURLWithPath: recordingInfo.Record_Url))
        do {
            try self.recorder?.reset()
        } catch { print("Errored resetting.") }
        self.setupUIForRecording()
        do {
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(NewProjectViewController.updateUI), userInfo: nil, repeats: true)
            self.setupPlot()
            
            try self.recorder?.record()
            
            let ss = 1 / 60
            print("timeInterval is \(ss)")
            self.recordTme2 = Timer.scheduledTimer(timeInterval: TimeInterval(ss), target: self, selector: #selector(NewProjectViewController.RecordTime1), userInfo: nil, repeats: true)
            
            self.Beatplayer?.play()
            
        } catch { print("Errored recording.") }
        
        
        
    }

    
    //In RecordCell, when brown_Button click.
    func Brown_Touched(cell: RecordViewCell) {
        if recorder?.isRecording == true {
            if brownClick == false {
                cell.btn_brown.frame = CGRect(x: 54, y: 30, width: 319, height: 2)
                self.plot.gain = 0.35
                brownClick = true
            }else {
                cell.btn_brown.frame = CGRect(x: 54, y: 7, width: 319, height: 2)
                self.plot.gain = 1
                brownClick = false
            }

        }
    }
    //When "M" button click.
    func M_Touched(cell: RecordViewCell) {
        if recorder?.isRecording == true {
            cell.btn_brown.isHidden = true
            cell.recordViewCell.isHidden = true
            cell.sAmView.isHidden = true
            cell.mSelectView.isHidden = false
            cell.MselectButton.setTitle("M", for: .normal)
            cell.MselectButton.setTitleColor(UIColor.init(red: 161/255, green: 78/255, blue: 51/255, alpha: 1), for: .normal)
            //recorder?.stop()
            micBooster?.gain = 0
            mic.stop()
        }
    }
    // When "brown_button" click.
    func Mselect_Touched(cell: RecordViewCell) {
            cell.btn_brown.isHidden = false
            cell.recordViewCell.isHidden = false
            cell.sAmView.isHidden = false
            cell.mSelectView.isHidden = true
            cell.MselectButton.setTitle("", for: .normal)
        
                //try recorder?.record()
                micBooster?.gain = 1
                mp3Booster?.gain = 1
                mic.start()
        
    }
    // When "S" button click.
    func S_Touched(cell: RecordViewCell) {
        if recorder?.isRecording == true {
            cell.btn_brown.isHidden = true
            cell.recordViewCell.isHidden = true
            cell.sAmView.isHidden = true
            cell.mSelectView.isHidden = false
            cell.MselectButton.setTitle("S", for: .normal)
            cell.MselectButton.setTitleColor(UIColor.init(red: 161/255, green: 78/255, blue: 51/255, alpha: 1), for: .normal)

            mp3Booster?.gain = 0
        }
    }
    // When volume slider click.
    func Show_volumeSlider(cell: RecordViewCell) {
        if recorder?.isRecording == true {
            if volumeBool == false {
                cell.view_volumeSlider.isHidden = false
                volumeBool = true
            }
            else {
                cell.view_volumeSlider.isHidden = true
                volumeBool = false
            }
        }
    }
    //When volume slider click, this method is called.
    func ChangeVolume_Record(cell: RecordViewCell) {
        if recorder?.isRecording == true {
            Beatplayer?.volume = Double(cell.slider_Record.value)
        }
    }
}
//UITextViewDelegate method.
extension NewProjectViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.returnKeyType = UIReturnKeyType.next
        
        var cell: UIView! = textView
        while (cell != nil) && !(cell is UITableViewCell) {
            cell = cell?.superview
        }
        //use the UITableViewCell superview to get the NSIndexPath
        let indexPath: IndexPath? = TableView.indexPathForRow(at: (cell?.center)!)
        TableView.scrollToRow(at: indexPath!, at: .top, animated: true)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let count = textView.tag
        print("tag is \(count)")
        marrRecordingData = NSMutableArray()
        marrRecordingData = ModelManager.getInstance().getAllRecordingData(tableName: self.tableName)
        let recordData: RecordingInFo = marrRecordingData.object(at: count) as! RecordingInFo
        let recordingInfo: RecordingInFo = RecordingInFo()
        recordingInfo.RecordIndex = recordData.RecordIndex
        print("recordinginfo.index is \(recordingInfo.RecordIndex)")
        recordingInfo.lyrics_txt = textView.text
        recordingInfo.insertLyrics_Boll = recordData.insertLyrics_Boll
        recordingInfo.insertRecord2_Bool = recordData.insertRecord2_Bool
        recordingInfo.Record_Url = recordData.Record_Url
        let isUpdated = ModelManager.getInstance().updateRecordingData(recordInfo: recordingInfo, tableName: self.tableName)
        if isUpdated {
            print("Successfully is updated")
        }
        else {
            print("Updating is false")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = TableView.contentOffset
        UIView.setAnimationsEnabled(false)
        TableView.beginUpdates()
        TableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        TableView.setContentOffset(currentOffset, animated: false)
    }

}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    static func imageWithBackgroundColor(image: UIImage, bgColor: UIColor) -> UIColor {
        let size = CGSize(width: 70, height: 70)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        
        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context!.setFillColor(bgColor.cgColor)
        context!.addRect(rectangle)
        context!.drawPath(using: .fill)
        
        context?.draw(image.cgImage!, in: rectangle)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: img!)
        
    }
}


