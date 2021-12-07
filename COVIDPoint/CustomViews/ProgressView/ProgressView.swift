//
//  DetailCountryView.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 26.10.2021.
//

import UIKit

enum ProgressViewType {
    case confirmed
    case deaths
    case recovered
}

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
        let typeLabelFont: UIFont = .systemFont(ofSize: 14, weight: .medium)
        let typeLabelColor: UIColor = .black
        let countLabelFont: UIFont = .systemFont(ofSize: 24, weight: .bold)
        let countLabelColor: UIColor = .black
        let plusCountLabelFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
        let plusCountLabelColor: UIColor = .gray
        let progressViewBackgroundColor: UIColor = .scaleLightGray
    }
}


class ProgressView: InstancedFromBuilder, ProgressViewProtocol {
    
    let layout = Layout()
    let appearance = Appearance()
    
    private var typeLabel: UILabel?
    private var countLabel: UILabel?
    private var plusCountLabel: UILabel?
    private var progressView: CustomProgressView?
    
    override func setupSubviews() {
        
        typeLabel = UILabel()
        typeLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel = UILabel()
        countLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        plusCountLabel = UILabel()
        plusCountLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        progressView = CustomProgressView()
        progressView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setupLayouts() {
        pin(height: layout.size.height)
        
        addSubview(typeLabel ?? UILabel())
        typeLabel?.pinToSuperview(edges: [.top,.left], insets: layout.typeLabelInsets)
        
        addSubview(countLabel ?? UILabel())
        countLabel?.pinTop(toBottom: typeLabel ?? UILabel(), spacing: layout.countLabelInsets.top)
        countLabel?.pinToSuperview(edges: [.left], insets: layout.countLabelInsets)
        
        addSubview(plusCountLabel ?? UILabel())
        plusCountLabel?.pinToSuperview(edges: [.right], insets: layout.plusCountLabelInsets)
        if layout.plusCountLabelCenterY {
            plusCountLabel?.pinCenter(to: countLabel ?? UILabel(), of: .vertical)
        }
        
        addSubview(progressView ?? UIView())
        progressView?.pinTop(toBottom: countLabel ?? UILabel(), spacing: layout.progressViewInsets.top)
        progressView?.pinToSuperview(edges: [.left,.right], insets: layout.progressViewInsets)
    }
    
    override func setupAppearances() {
        typeLabel?.font = appearance.typeLabelFont
        typeLabel?.textColor = appearance.typeLabelColor
        
        countLabel?.font = appearance.countLabelFont
        countLabel?.textColor = appearance.countLabelColor
        
        plusCountLabel?.font = appearance.plusCountLabelFont
        plusCountLabel?.textColor = appearance.plusCountLabelColor
        
        progressView?.backgroundColor = appearance.progressViewBackgroundColor
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
    
    func setProgress(_ value: CGFloat) {
        progressView?.setProgress(value, animated: true)
    }
    
    func setProgressGradientColor(_ colors: [UIColor]) {
        progressView?.gradientColors = colors
    }
}
