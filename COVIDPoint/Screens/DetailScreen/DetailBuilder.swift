//
//  DetailBuilder.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 26.10.2021.
//

import UIKit

extension DetailViewController {
    struct Layout {
        var stackViewInsets: UIEdgeInsets = UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20)
        var stackViewSpacing: CGFloat = 14
    }
    
    struct Appearance: AppearanceProtocol {
        let progressConfirmedStartColor: UIColor = UIColor.gray
        let progressConfirmedEndColor: UIColor = UIColor.darkGray
        
        let progressDeathsStartColor: UIColor = UIColor.darkRed
        let progressDeathsEndColor: UIColor = UIColor.lightRed
        
        let progressRecoveredStartColor: UIColor = UIColor.darkGreen
        let progressRecoveredEndColor: UIColor = UIColor.lightGreen
    }
}
