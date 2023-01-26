//
//  ViewInitialization.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 26.10.2021.
//

import UIKit

protocol InstancedFromBuilderInterface {
    
    func setupSubviews()
    func setupLayouts()
    func setupAppearances()
}

class InstancedFromBuilder: UIView, InstancedFromBuilderInterface {
    
    init() {
        super.init(frame: .zero)
        
        self.setupSubviews()
        self.setupLayouts()
        self.setupAppearances()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InstancedFromBuilderInterface || Default Implementation -
    
    func setupSubviews() {
        
    }
    
    func setupLayouts() {
        
    }
    
    func setupAppearances() {
        
    }
    
}
