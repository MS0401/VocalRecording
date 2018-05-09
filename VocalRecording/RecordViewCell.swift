//
//  RecordViewCell.swift
//  VocalRecording
//
//  Created by dev on 3/30/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import AudioKit

protocol ButtonRecordCellDelegate {
    func Brown_Touched(cell: RecordViewCell)
    func M_Touched(cell: RecordViewCell)
    func Mselect_Touched(cell: RecordViewCell)
    func S_Touched(cell: RecordViewCell)
    func Show_volumeSlider(cell: RecordViewCell)
    func ChangeVolume_Record(cell: RecordViewCell)
    func RecordButton_Touched(cell: RecordViewCell)
}

class RecordViewCell: UITableViewCell {
    
    var buttonDelegate: ButtonRecordCellDelegate?
    @IBOutlet var insertRecord_btn: UIButton!
    
    @IBOutlet var btn_brown: UIButton!
    @IBOutlet var mSelectView: UIView!
    @IBOutlet var recordViewCell: EZAudioPlot!
    @IBOutlet var sAmView: UIView!
    @IBOutlet var view_volumeSlider: UIView!
    @IBOutlet var slider_Record: UISlider!
    @IBOutlet var MselectButton: UIButton!
    @IBOutlet var recordDate_RCell: UILabel!
    @IBOutlet var recordName_RCell: UILabel!
    @IBOutlet var recordTime_RCell: UILabel!
    
    
    @IBAction func ValueChange_Record(_ sender: UISlider) {
        if let delegate = buttonDelegate {
            delegate.ChangeVolume_Record(cell: self)
        }
    }
    @IBAction func ShowVolumeSlider(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.Show_volumeSlider(cell: self)
        }
    }
    
    @IBAction func BrownTouched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.Brown_Touched(cell: self)
        }
    }
    @IBAction func MTouched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.M_Touched(cell: self)
        }
    }
    @IBAction func MselectTouched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.Mselect_Touched(cell: self)
        }
    }
    @IBAction func STouched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.S_Touched(cell: self)
        }
    }
    
    
    @IBAction func RecordButtonTouched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.RecordButton_Touched(cell: self)
        }
    }
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //slider rotating
        self.mSelectView.isHidden = true
        self.slider_Record.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
