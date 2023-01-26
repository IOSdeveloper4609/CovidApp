//
//  AppearanceViewProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 28.10.2021.
//

import UIKit

protocol AppearanceViewProtocol: ThemeAppearance {}

extension AppearanceViewProtocol {
    /// Стиль с полупрозрачным фоном
    var translucentBackgroundStyle: UIView.Style {
        return UIView.Style(backgroundColor: theme.colorAssets.translucentBackground,
                            backgroundGradient: nil)
    }
}
