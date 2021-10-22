import Foundation

struct Countries: Codable {
    var data: [CountriesData]?
}
    
struct CountriesData: Codable {
    var coordinates: Coordinates?
    var name: String?
    var code: String?
    var population: Int?
    var updatedAt: String?
    var today: Today?
    var latestData: LatestData
}

struct Coordinates: Codable {
    var latitude: Float?
    var longitude: Float?
}

struct Today: Codable {
    var deaths: Int?
    var confirmed: Int?
}

struct LatestData: Codable {
    var deaths: Int?
    var confirmed: Int?
    var recovered: Int?
    var critical: Int?
}
