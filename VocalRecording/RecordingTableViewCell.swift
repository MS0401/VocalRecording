//
//  RecordingTableViewCell.swift
//  VocalRecording
//
//  Created by dev on 3/16/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit

protocol CreateButtonDelegate {
    func pencil_btnTouched(cell: RecordingTableViewCell)
}

class RecordingTableViewCell: UITableViewCell {
    
    var buttonDelegate: CreateButtonDelegate?
    @IBOutlet var projectName: UITextField!
    @IBOutlet var nameDetail: UITextField!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var micButton: UIButton!

    @IBAction func PencilButtonTouched(_ sender: UIButton) {
        if let delegate = buttonDelegate {
            delegate.pencil_btnTouched(cell: self)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = UIView(frame:self.frame)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 4
        self.selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
