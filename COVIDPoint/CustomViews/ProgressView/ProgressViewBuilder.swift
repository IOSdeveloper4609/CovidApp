//
//  DetailBuilder.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 26.10.2021.
//

import UIKit

extension ProgressView {
    
    struct Layout {
        let size: CGSize = CGSize(width: 0, height: 66)
        
        let typeLabelInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        
        let countLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        
        let plusCountLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let plusCountLabelCenterY: Bool = true
        
        let progressViewInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        let progressViewSize: CGSize = CGSize(width: 0, height: 6)
    }

    struct Appearance: AppearanceProtocol {
        let typeLabelFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        let typeLabelColor: UIColor = UIColor.black
        
        let countLabelFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let countLabelColor: UIColor = UIColor.black
        
        let plusCountLabelFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        let plusCountLabelColor: UIColor = UIColor.gray
        
        let progressViewBackgroundColor: UIColor = UIColor.scaleLightGray
    }
}
