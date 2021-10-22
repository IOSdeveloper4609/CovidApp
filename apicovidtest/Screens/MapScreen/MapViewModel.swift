//
//  GoogleMapViewModel.swift
//  apicovidtest
//
//  Created by Ahtem Sitjalilov on 19.10.2021.
//

import UIKit

extension MapViewModel {
    struct CountryState {
        let id: Int
        var lat: Float?
        var lon: Float?
        var pointColor: UIColor?
    }
}

class MapViewModel {
    
    let networkManager = NetworkManager()
    
    var countries: Countries?
    var countryState: [CountryState] = []
    var maxData: Int = 0
    var minData: Int = 0
    
    let colors: [UIColor] = [.red, .yellow]
    
    func prepareData() {
        getCountries()
        
    }
    
    func getCountries() {
        networkManager.getCountryInfo { result in
            self.countries = result
            self.getCounryState()
        }
    }
    
    func getCounryState() {
        countries?.data?.enumerated().forEach { (index, data) in
            var country = CountryState(id: index)
            country.lat = data.coordinates?.latitude
            country.lon = data.coordinates?.longitude
            country.pointColor = nil
            self.countryState.append(country)
//            guard let deaths = data.today.deaths else {return}
//            if maxData < deaths {
//                self.maxData = deaths
//            }
//            if minData > deaths {
//                self.minData = deaths
//            }
        }
    }
    
    func getColor(_ colors: [UIColor], gradient: CGFloat) -> UIColor {
        
        let gradientPart = CGFloat(colors.count - 1) * gradient
        let gradIndex = Int(gradientPart)
        
        var firstColor: UIColor?
        var secondColor: UIColor?
        guard gradIndex < colors.count - 1 else { return colors.last ?? UIColor.white }
        firstColor = colors[gradIndex]
        secondColor = colors[gradIndex + 1]
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        var redRes: CGFloat = 0
        var greenRes: CGFloat = 0
        var blueRes: CGFloat = 0
        var alphaRes: CGFloat = 0
        
        firstColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        redRes = red * (1.0 - gradientPart)
        greenRes = green * (1.0 - gradientPart)
        blueRes = blue * (1.0 - gradientPart)
        alphaRes = alpha * (1.0 - gradientPart)
        
        secondColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        redRes += (red * gradientPart)
        greenRes += (green * gradientPart)
        blueRes += (blue * gradientPart)
        alphaRes += (alpha * gradientPart)
        
        let colorRes = UIColor(red: redRes, green: greenRes, blue: blueRes, alpha: alphaRes)
        return colorRes
    }
    
}
