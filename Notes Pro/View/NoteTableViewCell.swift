//
//  NoteTableViewCell.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    var note: Note! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        let truncateText = note.text
        noteTextLabel.text = truncateText.truncated(after: 100)
        dateLabel.text = note.date.currentDateToSting
        if note.modify {
            stateLabel.text = "Ред."
        } else {
            stateLabel.text = nil
        }
    }
}
