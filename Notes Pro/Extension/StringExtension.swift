//
//  StringExtension.swift
//  Notes Pro
//
//  Created by Yaroslav Zakharchuk on 5/10/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation

extension String {
    
    func truncated(after count: Int) -> String {
        if count > self.count {
            return self
        }
        let truncateAfter = index(startIndex, offsetBy: count)
        guard endIndex > truncateAfter else { return self }
        return String(self[startIndex..<truncateAfter]) + "…"
    }
}
