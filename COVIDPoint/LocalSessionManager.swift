
import Foundation

protocol LocalSessionManagerProtocol {
    var covidData: Countries? { get set }
}

final class LocalSessionManager: LocalSessionManagerProtocol {
    static let shared = LocalSessionManager()
    
    var covidData: Countries?
}
