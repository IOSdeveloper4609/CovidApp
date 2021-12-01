//
//  Array.swift
//  COVIDPoint
//
//  Created by usermac on 30.11.2021.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
