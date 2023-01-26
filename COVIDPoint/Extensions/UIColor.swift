//
//  UIColor.swift
//  COVIDPoint
//
//  Created by Azat Kirakosyan on 29.10.2021.
//

import UIKit

public extension UIColor {
    static let white97 = UIColor.white.withAlphaComponent(0.97)
    static let black97 = UIColor.black.withAlphaComponent(0.97)
    static let segmentGray = UIColor(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
    static let black = UIColor(red: 0, green: 0, blue: 0)
    static let gray = UIColor(red: 134, green: 134, blue: 134)
    static let darkGray = UIColor(red: 71, green: 75, blue: 77)
    static let darkRed = UIColor(red: 152, green: 38, blue: 60)
    static let lightRed = UIColor(red: 244, green: 1, blue: 47)
    static let darkGreen = UIColor(red: 87, green: 138, blue: 81)
    static let lightGreen = UIColor(red: 124, green: 199, blue: 116)
    static let scaleLightGray = UIColor(hex: "#F0F0F0")
    static let backgroundCircleRadius = UIColor(red: 0.02352941176, green: 0.2823529412, blue: 0.6745098039, alpha: 1)
    static let backgroundContainerForButtons = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
}

public extension UIColor {
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            let index = String.Index(utf16Offset: 1, in: "")
            hexWithoutSymbol = String(hex[index...])
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func colorFromHex(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func getGradientPoint(_ colors: [UIColor], gradient: CGFloat) -> UIColor {
        
        let leng: CGFloat = CGFloat(colors.count - 1)
        
        if Int(leng * gradient) + 1 >= colors.count {
            return colors.last ?? UIColor.white
        }
        
        let index = Int(leng * gradient)
        
        let firstColor: UIColor? = colors[index]
        let secondColor: UIColor? = colors[index + 1]
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        var redRes: CGFloat = 0
        var greenRes: CGFloat = 0
        var blueRes: CGFloat = 0
        var alphaRes: CGFloat = 0
        
        firstColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let value = CGFloat(leng * gradient).truncatingRemainder(dividingBy: 1)
        
        redRes = red * (1 - value)
        greenRes = green * (1 - value)
        blueRes = blue * (1 - value)
        alphaRes = alpha * (1 - value)

        secondColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        redRes += (red * value)
        greenRes += (green * value)
        blueRes += (blue * value)
        alphaRes += (alpha * value)
        
        let colorRes = UIColor(red: redRes, green: greenRes, blue: blueRes, alpha: alphaRes)
        return colorRes
    }
}
