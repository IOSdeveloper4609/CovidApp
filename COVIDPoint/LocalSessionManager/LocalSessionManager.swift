
import Foundation

protocol LocalSessionManagerProtocol: AnyObject {
    var covidData: Countries? { get set }
}

final class LocalSessionManager: LocalSessionManagerProtocol {
    static let shared = LocalSessionManager()
    
    var covidData: Countries?
}
