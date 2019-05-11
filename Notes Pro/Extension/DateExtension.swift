//
//  StringExtension.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation

extension Date {
    var currentDateToSting:  String  {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm dd.MM.yy "
        let formattedDate = format.string(from: date)
        return formattedDate
    }
}
