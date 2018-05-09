//
//  OneCell.swift
//  VocalRecording
//
//  Created by dev on 3/28/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

protocol ButtonOneCellDelegate {
    func BrownTouched(cell: OneCell)
    func MTouched(cell: OneCell)
    func MselectTouched(cell: OneCell)
    func STouched(cell: OneCell)
    func ShowVolumeSlider_One(cell: OneCell)
    func ChangeVolume_One(cell: OneCell)
    func Record_oneCell(cell: OneCell)
}

class OneCell: UITableViewCell {
    
    var buttonDelegate: ButtonOneCellDelegate?
    @IBOutlet var insertTextView: UITextView!
    @IBOutlet var insertMainView: UIView!
    @IBOutlet var insertRecord_btn: UIButton!
    @IBOutlet var btn_brownColor: UIButton!
    @IBOutlet var sAmView: UIView!
    @IBOutlet weak var MselectView: UIView!
    @IBOutlet var oneCellView: EZAudioPlot!
    @IBOutlet var view_VolumeSliderOne: UIView!
    @IBOutlet var volumeSlider_One: UISlider!
    @IBOutlet var MselectButton_one: UIButton!
    @IBOutlet var recordingDate_one: UILabel!
    @IBOutlet var recordName: UILabel!
    @IBOutlet var recordTime: UILabel!
    var recorder: AKNodeRecorder?
    
    @IBAction func ValueChangeVolume_One(_ sender: UISlider) {
        if let delegate = buttonDelegate {
            delegate.ChangeVolume_One(cell: self)
        }
    }
    
    @IBAction func ShowVolumeSlider_One(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.ShowVolumeSlider_One(cell: self)
        }
    }
    
    @IBAction func Brown_Touched(_ sender: UIButton) {
        
        if let delegate = buttonDelegate {
            delegate.BrownTouched(cell: self)
        }
    }

    @IBAction func M_Touched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.MTouched(cell: self)
        }
    }
    @IBAction func Mselect_Touched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.MselectTouched(cell: self)
        }
    }
    @IBAction func S_Touched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.STouched(cell: self)
        }
    }
    
    @IBAction func RecordingButton_One(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.Record_oneCell(cell: self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //slider rotating
        self.MselectView.isHidden = true
        self.recordingDate_one.isHidden = false
        self.recordName.isHidden = false
        self.recordTime.isHidden = false
        self.volumeSlider_One.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
