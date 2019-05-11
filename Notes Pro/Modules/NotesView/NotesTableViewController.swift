//
//  NotesTableViewController.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit
import RealmSwift

var state = StateNote.save

class NotesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func pushToSecondVC(note: Note?) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "addNoteViewController") as! AddNoteViewController
        secondVC.currentNote = note
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        state = .save
//        let saveNoteVC = storyboard?.instantiateViewController(withIdentifier: "addNoteViewController") as! AddNoteViewController
//        saveNoteVC.currentNote = nil
//        navigationController?.pushViewController(saveNoteVC, animated: true)
        pushToSecondVC(note: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! NoteTableViewCell
        let note = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
        cell.note = note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        state = .view
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
//        let viewNoteVC = storyboard?.instantiateViewController(withIdentifier: "addNoteViewController") as! AddNoteViewController
//        viewNoteVC.currentNote = selectedNote
//        navigationController?.pushViewController(viewNoteVC, animated: true)
        pushToSecondVC(note: selectedNote)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            state = .edit
            let editNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
            self.pushToSecondVC(note: editNote)
        })
        editAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "edit")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))}
        editAction.backgroundColor = .gray
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let deleteNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
            DBManager.sharedInstance.deleteFromDb(object: deleteNote)
        })
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "delete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))}
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
