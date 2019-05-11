//
//  NotesTableViewExtension.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/11/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

extension NotesTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            state = .`default`
        } else {
            notes = Array(DBManager.sharedInstance.getDataFromDB().filter("text CONTAINS '\(searchText)'"))
            state = .searching
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
