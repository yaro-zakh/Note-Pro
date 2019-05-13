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
    var textInSearchBar = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButton()
        detectTapInEmptyTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupBarButton() {
        let sortedButton = UIBarButtonItem(image: cutImage(name: "sort", size: 20), style: .plain, target: self, action: #selector(sortNotes))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        navigationItem.rightBarButtonItems = [addButton, sortedButton]
    }
    
    func detectTapInEmptyTable() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        tableView.backgroundView = UIView()
        tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    func pushToSecondVC(note: Note?) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "addNoteViewController") as! AddNoteViewController
        secondVC.currentNote = note
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func cutImage(name: String, size: Int) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: size, height: size)).image { _ in
            UIImage(named: name)?.draw(in: CGRect(x: 0, y: 0, width: size, height: size))}
    }
    
    func getSortedNotes(value: String, desc: Bool) {
        if state == .searching {
            notes = Array(DBManager.sharedInstance.getDataFromDB().filter("text CONTAINS '\(self.textInSearchBar)'").sorted(byKeyPath: value, ascending: desc))
        } else {
            state = .sort
            notes = Array(DBManager.sharedInstance.getDataFromDB().sorted(byKeyPath: value, ascending: desc))
        }
        tableView.reloadData()
    }
    
    @objc func tableTapped() {
        searchBar.endEditing(true)
    }
    
    @objc func sortNotes() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По алфавиту", style: .default, handler: { (_) in
            self.getSortedNotes(value: "text", desc: true)
        }))
        
        alert.addAction(UIAlertAction(title: "От новых к старым", style: .default, handler: { (_) in
            self.getSortedNotes(value: "date", desc: false)
        }))
        
        alert.addAction(UIAlertAction(title: "От старых к новым", style: .default, handler: { (_) in
            self.getSortedNotes(value: "date", desc: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    @objc func addNewNote() {
        searchBar.text = nil
        searchBar.endEditing(true)
        state = .save
        pushToSecondVC(note: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .searching || state == .sort {
            return notes.count
        }
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! NoteTableViewCell
        if state == .searching || state == .sort {
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
            var editNote = Note()
            if state == .searching || state == .sort {
                editNote = self.notes[indexPath.row]
            } else {
                editNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
            }
            state = .edit
            self.pushToSecondVC(note: editNote)
        })
        editAction.image = cutImage(name: "edit", size: 30)
        editAction.backgroundColor = .gray
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            if state == .searching || state == .sort {
                self.notes.remove(at: indexPath.row)
            }
            let deleteNote = DBManager.sharedInstance.getDataFromDB()[indexPath.row] as Note
            DBManager.sharedInstance.deleteFromDb(object: deleteNote)
            tableView.deleteRows(at: [indexPath], with: .left)
        })
        deleteAction.image = cutImage(name: "delete", size: 30)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
