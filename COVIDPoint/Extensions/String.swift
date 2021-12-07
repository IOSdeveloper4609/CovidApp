//
//  String.swift
//  COVIDPoint
//
//  Created by usermac on 06.12.2021.
//

import Foundation

extension String {
    func localisation() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localisation",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
