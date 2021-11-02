//
//  DetailCountryView.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 26.10.2021.
//

import UIKit

class ProgressView: InstancedFromBuilder, ProgressViewProtocol {
    
    let layout = Layout()
    let appearance = Appearance()
    
    private var typeLabel: UILabel?
    private var countLabel: UILabel?
    private var plusCountLabel: UILabel?
    private var progressView: UIProgressView?
    
    override func setupSubviews() {
        
        typeLabel = UILabel()
        typeLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel = UILabel()
        countLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        plusCountLabel = UILabel()
        plusCountLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        progressView = UIProgressView()
        progressView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setupLayouts() {
        pin(height: layout.size.height)
        
        addSubview(typeLabel!)
        typeLabel?.pinToSuperview(edges: [.top,.left], insets: layout.typeLabelInsets)
        
        addSubview(countLabel!)
        countLabel?.pinTop(toBottom: typeLabel!, spacing: layout.countLabelInsets.top)
        countLabel?.pinToSuperview(edges: [.left], insets: layout.countLabelInsets)
        
        addSubview(plusCountLabel!)
        plusCountLabel?.pinToSuperview(edges: [.right], insets: layout.plusCountLabelInsets)
        if layout.plusCountLabelCenterY {
            plusCountLabel?.pinCenter(to: countLabel!, of: .vertical)
        }
        
        addSubview(progressView!)
        progressView?.pinTop(toBottom: countLabel!, spacing: layout.progressViewInsets.top)
        progressView?.pinToSuperview(edges: [.left,.right], insets: layout.progressViewInsets)
        progressView?.pin(height: layout.progressViewSize.height)
    }
    
    override func setupAppearances() {
        typeLabel?.font = appearance.typeLabelFont
        typeLabel?.textColor = appearance.typeLabelColor
        
        countLabel?.font = appearance.countLabelFont
        countLabel?.textColor = appearance.countLabelColor
        
        plusCountLabel?.font = appearance.plusCountLabelFont
        plusCountLabel?.textColor = appearance.plusCountLabelColor
        
        progressView?.backgroundColor = appearance.progressViewColorEmpty
    }
    
    func setName(_ text: String) {
        typeLabel?.text = text
    }
    
    func setCount(_ text: String) {
        countLabel?.text = text
    }
    
    func setPlusCount(_ text: String?) {
        plusCountLabel?.text = text
    }
    
    func setProgress(_ value: Float) {
        progressView?.setProgress(value, animated: true)
    }
    
    func setProgressColor(_ color: UIColor) {
        progressView?.tintColor = color
    }
}
