//
//  AddNoteViewController.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit
import RealmSwift

class AddNoteViewController: UIViewController {

    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var currentNote: Note?
    var rightButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = rightButton
        
        switch state {
        case .save:
            addRightButton(title: "Сохранить", state: .save)
        case .view:
            viewNote()
        case .edit:
            viewNote()
            addRightButton(title: "Редактировать", state: .edit)
        }
        
        //Listen for keyboard event
        addKeyboardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewNote() {
        noteText.isEditable = false
        noteText.text = currentNote?.text
    }
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func addRightButton(title: String, state: StateNote) {
        rightButton.title = title
        rightButton.style = .plain
        rightButton.target = self
        if state == .edit {
            rightButton.action = #selector(touchEditBarButtonItem)
        } else if state == .save {
            rightButton.action = #selector(touchSaveBarButtonItem)
        }
    }
    
    @objc func touchEditBarButtonItem() {
        noteText.isEditable = true
        addRightButton(title: "Сохранить", state: .save)
    }
    
    @objc func touchSaveBarButtonItem() {
        let note = Note()
        
        if noteText.text!.isEmpty {
            alertMessage(title: "Error", message: "You can not save an empty note")
        } else {
            if(currentNote == nil) {
                note.id = DBManager.sharedInstance.getDataFromDB().count
            }
            note.text = noteText.text!
            if state == .edit {
                note.date = "Ред. " + Date().currentDateToSting
            } else {
                note.date = Date().currentDateToSting
            }
            DBManager.sharedInstance.addData(object: note)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            bottomConstraint.constant = keyboard.height
        } else {
            bottomConstraint.constant = 0
        }
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: keyboard settings
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
