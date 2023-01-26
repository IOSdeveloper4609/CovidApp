//
//  AppearanceSegmentControlProtocol.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 29.10.2021.
//

import UIKit

protocol AppearanceSegmentControlProtocol: ThemeAppearance {}

extension AppearanceSegmentControlProtocol {
    /// Стиль для сегмента переключателя экранов
    var screenChangeControlStyle: UISegmentedControl.Style {
        return UISegmentedControl.Style(backgroundColor: theme.colorAssets.segmentControlBackground,
                                        selectedViewColor: theme.colorAssets.selectedSegmentControlBackground)
    }
}
