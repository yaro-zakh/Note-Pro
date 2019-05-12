//
//  NotesTableViewController.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit
import RealmSwift

var state = StateNote.`default`

class NotesTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detectTapInEmptyTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func detectTapInEmptyTable() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        tableView.backgroundView = UIView()
        tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped() {
        searchBar.endEditing(true)
    }
    
    func pushToSecondVC(note: Note?) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "addNoteViewController") as! AddNoteViewController
        secondVC.currentNote = note
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        state = .save
        pushToSecondVC(note: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .searching {
            return notes.count
        }
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! NoteTableViewCell
        if state == .searching {
            cell.note = notes[indexPath.row]
        } else {
            cell.note = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        state = .view
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
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
            if state == .searching {
                self.notes.remove(at: indexPath.row)
            }
            let deleteNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
            DBManager.sharedInstance.deleteFromDb(object: deleteNote)
            tableView.deleteRows(at: [indexPath], with: .left)
        })
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "delete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))}
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
