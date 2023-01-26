//
//  CustomProgressView.swift
//  TestProject
//
//  Created by Azat Kirakosyan on 08.11.2021.
//

import UIKit

class CustomProgressView: UIView {
    
    var defaultHeight: CGFloat = 5
    var defaultBackgroundColor: UIColor = UIColor.gray
    var gradientColors: [UIColor] = []
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        setupLayouts()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupLayouts() {
        self.pin(height: defaultHeight)
        self.layer.cornerRadius = defaultHeight / 2
        self.layer.masksToBounds = true
    }
    
    func setupAppearance() {
        self.backgroundColor = defaultBackgroundColor
    }
    
    func setProgress(_ value: CGFloat, animated: Bool) {
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let duration: CFTimeInterval = 1
        
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0)
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.cornerRadius = self.frame.height / 2
        gradient.masksToBounds = true
        
        if animated {
            let animationBounds = CABasicAnimation(keyPath: "bounds")
            animationBounds.fromValue = CGRect(x: 0, y: 0, width: 0, height: frame.height)
            animationBounds.toValue = CGRect(x: 0, y: 0, width: (value * frame.width), height: frame.height)
            animationBounds.duration = duration
            animationBounds.fillMode = .forwards
            animationBounds.isRemovedOnCompletion = false
            gradient.add(animationBounds, forKey: nil)
            
            let animationPosition = CABasicAnimation(keyPath: "position")
            animationPosition.fromValue = CGPoint(x: 0, y: frame.height / 2)
            animationPosition.toValue = CGPoint(x: (value * frame.width) / 2, y: frame.height / 2)
            animationPosition.duration = duration
            animationPosition.fillMode = .forwards
            animationPosition.isRemovedOnCompletion = false
            gradient.add(animationPosition, forKey: nil)
        }
        
        self.layer.addSublayer(gradient)
    }
}
