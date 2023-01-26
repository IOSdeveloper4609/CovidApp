//
//  HistogramView.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 02.11.2021.
//

import UIKit

class HistogramView: InstancedFromBuilder, HistogramViewProtocol {
    
    let layout = Layout()
    let appearance = Appearance()
    
    var title: UILabel?
    var stackView: UIStackView?
    var startData: UILabel?
    var endData: UILabel?
    
    override func setupSubviews() {
        title = UILabel()
        title?.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.axis = .horizontal
        stackView?.distribution = .equalSpacing
        stackView?.alignment = .bottom
        
        startData = UILabel()
        startData?.translatesAutoresizingMaskIntoConstraints = false
        
        endData = UILabel()
        endData?.translatesAutoresizingMaskIntoConstraints = false
    }
        
    override func setupLayouts() {
        
        addSubview(title!)
        title?.pinToSuperview(edges: [.top,.left], insets: layout.titleInsets)
        
        addSubview(stackView!)
        stackView?.pinTop(toBottom: title!, spacing: layout.stackViewInsets.top)
        stackView?.pinToSuperview(edges: [.left,.right], insets: layout.stackViewInsets)
        stackView?.pin(height: layout.stackViewSize.height)
        
        addSubview(startData!)
        startData?.pinTop(toBottom: stackView!, spacing: layout.startDataInserts.top)
        startData?.pinToSuperview(edges: [.left], insets: layout.startDataInserts)
        
        addSubview(endData!)
        endData?.pinTop(toBottom: stackView!, spacing: layout.endDataInserts.top)
        endData?.pinToSuperview(edges: [.right], insets: layout.endDataInserts)
    }
    
    override func setupAppearances() {
        title?.font = appearance.titleFont
        title?.textColor = appearance.titleColor
        
        startData?.font = appearance.startDataFont
        startData?.textColor = appearance.startDataColor
        
        endData?.font = appearance.endDataFont
        endData?.textColor = appearance.endDataColor
    }
    
    func setTitle(_ text: String) {
        title?.text = text
    }
    
    func setColumn(_ countHeight: [CGFloat]) {
        stackView?.subviews.forEach { view in
            stackView?.removeArrangedSubview(view)
        }
        
        countHeight.forEach { heightColumn in
            let column = UIView()
            column.translatesAutoresizingMaskIntoConstraints = false
            stackView?.addArrangedSubview(column)
            column.pin(size: CGSize(width: layout.stackViewColumnSize.width, height: layout.stackViewSize.height * heightColumn))
            column.backgroundColor = UIColor.getGradientPoint(appearance.histogramColumnGradient, gradient: heightColumn)
        }
    }
    
    func setStartData(_ text: String) {
        startData?.text = text
    }
    
    func setEndData(_ text: String) {
        endData?.text = text
    }
}
