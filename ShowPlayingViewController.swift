//
//  ShowPlayingViewController.swift
//  VocalRecording
//
//  Created by dev on 3/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

class ShowPlayingViewController: UIViewController, PagedFlowViewDelegate, PagedFlowViewDataSource {
    
    
    @IBOutlet var HPageFlowView: PagedFlowView!
    
    @IBOutlet var lyricsTextView: UITextView!
    
    var imgeArray = ["yosemite0.png", "yosemite1.png","yosemite2.png", "yosemite3.png", "yosemite4.png", "yosemite5.png", "yosemite6.png"]
    
    var mySliderView = MTZTiltReflectionSlider()// NYSliderPopover()

    var recordings = [URL]()
    var audioPlayer: AKAudioPlayer?
    var audioFile: AKAudioFile?
    var sampler: AKSampler?
    var mixer: AKMixer?
    var moogLader: AKMoogLadder?
    var bool = false
    var mynumber: Int!
    var loadFile = AKSampler()
    var mp3Booster: AKBooster?


    @IBAction func segueShowPlaying(_ sender: UIBarButtonItem) {
        
        if bool == true {
            audioPlayer?.stop()
            AudioKit.stop()
        }

        
        let createProject = self.storyboard?.instantiateViewController(withIdentifier: "lmProject") as! LMRootViewController
        self.present(createProject, animated: true, completion: nil)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        listRecordings()
        
        self.HPageFlowView.delegate = self
        self.HPageFlowView.dataSource = self
        self.HPageFlowView.minimumPageAlpha = 0.4
        self.HPageFlowView.minimumPageScale = 0.8
        self.HPageFlowView.orientation = PagedFlowViewOrientationHorizontal
        
        self.hideKeyboardWhenTappedAround1()
        self.lyricsTextView.textColor = UIColor.white
        
        if SharingMananger.sharedInstance.shareTextView.count > 0 {
            self.lyricsTextView.text = SharingMananger.sharedInstance.shareTextView[SharingMananger.sharedInstance.indexpath]
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // PagedFlowView Delegate
    func sizeForPage(in flowView: PagedFlowView!) -> CGSize {
        return CGSize(width: self.view.bounds.size.width - 84, height: (self.view.bounds.size.width - 84) * 25 / 16 )
    }
    
    func flowView(_ flowView: PagedFlowView!, didScrollToPageAt index: Int) {
        print("Scrolled to page #\(index)")
    }
    func flowView(_ flowView: PagedFlowView!, didTapPageAt index: Int) {
        print("Tapped on page #\(index)")
    }
    
    // PagedFlowView Datasource
    func numberOfPages(in flowView: PagedFlowView!) -> Int {
        return self.imgeArray.count
    }
    
    func flowView(_ flowView: PagedFlowView!, cellForPageAt index: Int) -> UIView! {
        var myView = flowView.dequeueReusableCell()
        let Width = flowView.bounds.size.width
        
        myView = UIView()
        myView?.layer.cornerRadius = 6
        myView?.layer.masksToBounds = true
        let image = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(50), width: CGFloat(Width), height: CGFloat(Width - 70)))
        print("myImage of size(width is \(Width)")
        print("myImage of size(height) is \(Width - 70)")
        
        
        image.image = UIImage(named: self.imgeArray[index])
        myView?.addSubview(image)
        
        let mySubView: UIView = UIView.init(frame: CGRect(x: 0, y: 350, width: Width, height: 75))
        mySubView.backgroundColor = UIColor.darkGray
        
        // PlayButton
        let myButton = UIButton(frame: CGRect(x: CGFloat(10), y: CGFloat(13), width: CGFloat(15), height: CGFloat(15)))
        myButton.setImage(UIImage(named: "up_btn"), for: UIControlState.normal)
        myButton.addTarget(self, action: #selector(PageFlowViewController.Play), for: .touchUpInside)
        mySubView.addSubview(myButton)
        
        // startTime
        let startTime = UILabel(frame: CGRect(x: 40, y: 17, width: 30, height: 10))
        startTime.text = "00:00"
        startTime.font = UIFont.systemFont(ofSize: 10)
        startTime.textColor = UIColor.white
        mySubView.addSubview(startTime)
        
        // progressBar
        
        mySliderView = MTZTiltReflectionSlider.init(frame: CGRect(x: 70, y: 17, width: 170, height: 28))
        
        mySliderView.size = MTZTiltReflectionSliderSizeSmall
        mySliderView.startMotionDetection()
        //mySliderView = NYSliderPopover.init(frame: CGRect(x: 70, y: 17, width: 170, height: 28))
        mySliderView.addTarget(self, action: #selector(PageFlowViewController.sliderValueChanged(_:)), for: .valueChanged)
        mySubView.addSubview(mySliderView)
        
        // EndTime
        let EndTime = UILabel(frame: CGRect(x: 245, y: 17, width: 30, height: 10))
        EndTime.text = "02:30"
        EndTime.font = UIFont.systemFont(ofSize: 10)
        EndTime.textColor = UIColor.white
        mySubView.addSubview(EndTime)
        
        // FavoriteButton
        let FavoriteButtn = UIButton(frame: CGRect(x: 10, y: 40, width: 15, height: 15))
        FavoriteButtn.setImage(UIImage(named: "favorite"), for: UIControlState.normal)
        mySubView.addSubview(FavoriteButtn)
        
        // Favorite Label
        let favoriteLabel = UILabel(frame: CGRect(x: 40, y: 37, width: 70, height: 20))
        favoriteLabel.text = "FAVORITE"
        favoriteLabel.textColor = UIColor.white
        favoriteLabel.font = UIFont.systemFont(ofSize: 14)
        mySubView.addSubview(favoriteLabel)
        
        // Plus Button
        let plusButton = UIButton(frame: CGRect(x: 180, y: 40, width: 15, height: 15))
        plusButton.setImage(UIImage(named: "plus"), for: UIControlState.normal)
        mySubView.addSubview(plusButton)
        
        // plus Label
        let plusLabel = UILabel(frame: CGRect(x: 220, y: 37, width: 70, height: 20))
        plusLabel.text = "ADD TO..."
        plusLabel.textColor = UIColor.white
        plusLabel.font = UIFont.systemFont(ofSize: 14)
        mySubView.addSubview(plusLabel)
        
        
        myView?.addSubview(mySubView)
        
        return myView
        
        
    }
    //when user click play button, this method is called.
    func Play() {
        if bool == false {
            let drumloop = try? AKAudioFile(readFileName: "Malek-Smile.mp3", baseDir: .resources)
            self.loadFile = (drumloop?.sampler!)!
            try! self.loadFile.loadAudioFile(drumloop!)
            mp3Booster = AKBooster(self.loadFile)
            mp3Booster?.gain = 1
            
            let beatMixer = AKMixer(mp3Booster!)
            AudioKit.output = beatMixer
            AudioKit.start()
            self.loadFile.volume = 30.0
            self.loadFile.play()
            bool = true
        }else {
            self.loadFile.stop()
            AudioKit.stop()
            bool = false
        }
    }
    
    func listRecordings() {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            print("saving section")
            let urls = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.recordings = urls.filter({ (name: URL) -> Bool in
                return name.lastPathComponent.hasSuffix("m4a")})
        } catch let error as NSError {
            print(error.localizedDescription)
        }catch {
            print("something went wrong listing recordings")
        }
        
    }
    //Slider value changed.
    func sliderValueChanged(_ sender: UISlider!) {
        self.mySliderView.popover.textLabel.text = "OK!"
        print("mySlider of value is \(sender.value)")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround1() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard1))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard1() {
        view.endEditing(true)
    }
}

