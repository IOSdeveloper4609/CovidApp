//
//  DetailCountryView.swift
//  COVIDPoint
//
//  Created by Ahtem Sitjalilov on 26.10.2021.
//

import UIKit
import SDWebImage

extension CountryNameView {
    struct Layout {
        var size: CGSize = CGSize(width: 0, height: 30)
        var countryLabelInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        var countryLabelCenterY: Bool = true
        var countryIconCorner: Bool = true
        var countryIconInsets: UIEdgeInsets = UIEdgeInsets(all: 0)
        var countryIconSize: CGSize = CGSize(width: 50, height: 50)
        var countryIconCenterY: Bool = true
    }

    struct Appearance: AppearanceProtocol {
        var countryLabelFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        var countryLabelColor: UIColor = .black
        var countryIconCorner: Bool = true
    }
}

class CountryNameView: InstancedFromBuilder, CountryNameViewProtocol {
    
    let layout = Layout()
    let appearance = Appearance()
    
    private var countryLabel: UILabel?
    private var countryIcon: UIImageView?
    
    override func setupSubviews() {
        countryLabel = UILabel()
        countryLabel?.numberOfLines = 0
        countryLabel?.translatesAutoresizingMaskIntoConstraints = false

        countryIcon = UIImageView()
        countryIcon?.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setupLayouts() {
        pin(height: layout.size.height)
        
        addSubview(countryIcon ?? UIImageView())
        countryIcon?.pinToSuperview(edges: [.right], insets: layout.countryIconInsets)
        countryIcon?.pin(size: layout.countryIconSize)
        if layout.countryIconCenterY {
            countryIcon?.pinCenterToSuperview(of: .vertical)
        }
        
        guard let _countryIcon = countryIcon else {
            return
        }

        addSubview(countryLabel ?? UILabel())
        countryLabel?.rightAnchor.constraint(equalTo: _countryIcon.leftAnchor,constant: -20).isActive = true
        countryLabel?.pinToSuperview(edges: [.left], insets: layout.countryLabelInsets)
        if layout.countryLabelCenterY {
            countryLabel?.pinCenterToSuperview(of: .vertical)
        }

    }

    override func setupAppearances() {
        countryLabel?.font = appearance.countryLabelFont
        countryLabel?.textColor = appearance.countryLabelColor

        if appearance.countryIconCorner {
            countryIcon?.layer.masksToBounds = true
            countryIcon?.layer.cornerRadius = 25
        }
    }

    func setName(_ text: String) {
        countryLabel?.text = text
    }

    func setIcon(_ countryCode: String) {
        let urlStr = String(format: Constants.flags, countryCode.lowercased())
        let url = URL(string: urlStr)
        countryIcon?.sd_setImage(with: url)
        self.addSubview(countryIcon ?? UIImageView())
    }
}
