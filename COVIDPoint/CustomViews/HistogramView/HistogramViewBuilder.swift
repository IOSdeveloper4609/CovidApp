//
//  HistogramViewBuilder.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 02.11.2021.
//

import UIKit

extension HistogramView {
    struct Layout {
        var titleInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        
        var stackViewInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        var stackViewSize: CGSize = CGSize(width: 0, height: 90)
        var stackViewColumnSize: CGSize = CGSize(width: 8, height: 0)
        
        var startDataInserts: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        var endDataInserts: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    struct Appearance: AppearanceProtocol {
        
        var titleFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        var titleColor: UIColor = UIColor.black
        
        var histogramColumnGradient: [UIColor] = [.green,.yellow,.orange,.red]
        
        var startDataFont: UIFont = UIFont.systemFont(ofSize: 11, weight: .medium)
        var startDataColor: UIColor = UIColor.black
        
        var endDataFont: UIFont = UIFont.systemFont(ofSize: 11, weight: .medium)
        var endDataColor: UIColor = UIColor.black
    }
}
