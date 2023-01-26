//
//  DetailCountryView.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 26.10.2021.
//

import UIKit
import SDWebImage

class CountryNameView: InstancedFromBuilder, CountryNameViewProtocol {
    
    let layout = Layout()
    let appearance = Appearance()
    
    private var countryLabel: UILabel?
    private var countryIcon: UIImageView?
    
    override func setupSubviews() {
        countryLabel = UILabel()
        countryLabel?.translatesAutoresizingMaskIntoConstraints = false

        countryIcon = UIImageView()
        countryIcon?.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setupLayouts() {
        pin(height: layout.size.height)

        addSubview(countryLabel!)
        countryLabel?.pinToSuperview(edges: [.left], insets: layout.countryLabelInsets)
        if layout.countryLabelCenterY {
            countryLabel?.pinCenterToSuperview(of: .vertical)
        }

        addSubview(countryIcon!)
        countryIcon?.pinToSuperview(edges: [.right], insets: layout.countryIconInsets)
        countryIcon?.pin(size: layout.countryIconSize)
        if layout.countryIconCenterY {
            countryIcon?.pinCenterToSuperview(of: .vertical)
        }
    }

    override func setupAppearances() {
        countryLabel?.font = appearance.countryLabelFont
        countryLabel?.textColor = appearance.countryLabelColor

        if appearance.countryIconCorner {
            countryIcon?.layer.masksToBounds = true
            countryIcon?.layer.cornerRadius = layout.size.height / 2
        }
    }

    func setName(_ text: String) {
        countryLabel?.text = text
    }

    func setIcon(_ countryCode: String) {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let urlStr = String(format: Constants.flags, countryCode)
        let url = URL(string: urlStr)
        image.sd_setImage(with: url)
        countryIcon?.addSubview(image)
        image.pinToSuperview()
    }
}
