//
//  Note.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    @objc dynamic var date = Date()
    @objc dynamic var modify = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

enum StateNote {
    case save, edit, view, searching, sort, `default`
}
