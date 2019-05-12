//
//  DBManager.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/11/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    private var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() -> Results<Note> {
        let results: Results<Note> = database.objects(Note.self)
        return results
    }
    
    func addData(object: Note) {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    
    func updateData(oldObject: Note, newObject: Note) {
        try! database.write {
            oldObject.text = newObject.text
            oldObject.date = newObject.date
            print("Data update")
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: Note) {
        try! database.write {
            database.delete(object)
        }
    }
}
