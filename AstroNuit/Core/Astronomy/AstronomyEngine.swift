import Foundation
import SceneKit

enum AstronomyEngine {
    
    struct Equatorial {
        var ra: Double
        var dec: Double
    }
    
    static func julianDate(from date: Date) -> Double {
        date.timeIntervalSince1970 / 86400.0 + 2440587.5
    }
    
    enum Body: String, CaseIterable, Identifiable {
        case sun, moon, mercury, venus, mars, jupiter, saturn, uranus, neptune
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .sun: return "Солнце"
            case .moon: return "Луна"
            case .mercury: return "Меркурий"
            case .venus: return "Венера"
            case .mars: return "Марс"
            case .jupiter: return "Юпитер"
            case .saturn: return "Сатурн"
            case .uranus: return "Уран"
            case .neptune: return "Нептун"
            }
        }
        
        var color: UIColor {
            switch self {
            case .sun: return UIColor(red: 1.0, green: 0.95, blue: 0.6, alpha: 1)
            case .moon: return UIColor(red: 0.9, green: 0.9, blue: 0.85, alpha: 1)
            case .mercury: return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            case .venus: return UIColor(red: 1.0, green: 0.9, blue: 0.7, alpha: 1)
            case .mars: return UIColor(red: 1.0, green: 0.4, blue: 0.2, alpha: 1)
            case .jupiter: return UIColor(red: 0.95, green: 0.8, blue: 0.6, alpha: 1)
            case .saturn: return UIColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1)
            case .uranus: return UIColor(red: 0.6, green: 0.9, blue: 0.95, alpha: 1)
            case .neptune: return UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1)
            }
        }
        
        var baseSize: CGFloat {
            switch self {
            case .sun: return 0.18
            case .moon: return 0.12
            case .jupiter, .saturn: return 0.09
            case .mars, .venus: return 0.07
            default: return 0.05
            }
        }
    }
    
    static func position(of body: Body, at date: Date) -> Equatorial {
        let jd = julianDate(from: date)
        let T = (jd - 2451545.0) / 36525.0
        
        func norm(_ x: Double) -> Double {
            var v = x.truncatingRemainder(dividingBy: 360)
            if v < 0 { v += 360 }
            return v
        }
        
        switch body {
        case .sun:
            let L = norm(280.460 + 36000.770 * T)
            let g = norm(357.528 + 35999.050 * T) * .pi / 180
            let lambda = L + 1.915 * sin(g) + 0.020 * sin(2*g)
            return eclipticToEquatorial(lon: lambda, lat: 0.0, T: T)
        case .moon:
            let L = norm(218.316 + 481267.881 * T)
            let M = norm(357.529 + 35999.050 * T) * .pi / 180
            let F = norm(93.272 + 483202.018 * T) * .pi / 180
            let lambda = L + 6.289 * sin(M)
            let beta = 5.128 * sin(F)
            return eclipticToEquatorial(lon: lambda, lat: beta, T: T)
        case .mercury:
            return eclipticToEquatorial(lon: norm(252.251 + 149474.072 * T), lat: 0, T: T)
        case .venus:
            return eclipticToEquatorial(lon: norm(181.980 + 58519.213 * T), lat: 0, T: T)
        case .mars:
            return eclipticToEquatorial(lon: norm(355.433 + 19141.696 * T), lat: 0, T: T)
        case .jupiter:
            return eclipticToEquatorial(lon: norm(34.351 + 3036.303 * T), lat: 0, T: T)
        case .saturn:
            return eclipticToEquatorial(lon: norm(50.077 + 1223.511 * T), lat: 0, T: T)
        case .uranus:
            return eclipticToEquatorial(lon: norm(314.055 + 429.864 * T), lat: 0, T: T)
        case .neptune:
            return eclipticToEquatorial(lon: norm(304.350 + 219.883 * T), lat: 0, T: T)
        }
    }
    
    private static func eclipticToEquatorial(lon: Double, lat: Double, T: Double) -> Equatorial {
        let eps = (23.4393 - 0.0130 * T) * .pi / 180
        let lonR = lon * .pi / 180
        let latR = lat * .pi / 180
        let ra = atan2(sin(lonR) * cos(eps) - tan(latR) * sin(eps), cos(lonR))
        let dec = asin(sin(latR) * cos(eps) + cos(latR) * sin(eps) * sin(lonR))
        var raHours = ra * 12 / .pi
        if raHours < 0 { raHours += 24 }
        return Equatorial(ra: raHours, dec: dec * 180 / .pi)
    }
    
    static func cartesian(from eq: Equatorial, radius: Float = 10) -> SCNVector3 {
        let raRad = eq.ra * .pi / 12.0
        let decRad = eq.dec * .pi / 180.0
        return SCNVector3(
            radius * Float(cos(decRad) * cos(raRad)),
            radius * Float(sin(decRad)),
            radius * Float(cos(decRad) * sin(raRad))
        )
    }
}
