//
//  HistogramViewBuilder.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 02.11.2021.
//

import UIKit

extension HistogramView {
    struct Layout {
        var titleInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        
        var stackViewInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        var stackViewSize: CGSize = CGSize(width: 0, height: 90)
        
        var startDataInserts: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        var endDataInserts: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    struct Appearance: AppearanceProtocol {
        
        var histogramColumnColor: UIColor = UIColor.gray
    }
}
