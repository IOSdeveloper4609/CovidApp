//
//  CountryNameViewBuilder.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 01.11.2021.
//

import UIKit

extension CountryNameView {
    struct Layout {
        var size: CGSize = CGSize(width: 0, height: 58)
        
        var countryLabelInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        var countryLabelCenterY: Bool = true
        var countryIconCorner: Bool = true
        
        var countryIconInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        var countryIconSize: CGSize = CGSize(width: 58, height: 58)
        var countryIconCenterY: Bool = true
    }

    struct Appearance: AppearanceProtocol {
        var countryLabelFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        var countryLabelColor: UIColor = UIColor.black
        
        var countryIconCorner: Bool = true
    }
}
