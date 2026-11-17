import SwiftUI
import SceneKit

struct SkyScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        SceneView(
            scene: SkySceneBuilder.build(maxMagnitude: appState.maxStarMagnitude),
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .ignoresSafeArea()
        .background(Color.black)
    }
}

enum SkySceneBuilder {
    
    static func build(maxMagnitude: Double) -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        
        // Bright stars (subset of Yale Bright Star Catalog style data)
        let stars = BrightStarCatalog.stars.filter { $0.mag <= maxMagnitude }
        
        for star in stars {
            let radius = CGFloat(max(0.008, 0.035 - star.mag * 0.004))
            let sphere = SCNSphere(radius: radius)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white
            material.emission.contents = star.color
            material.lightingModel = .constant
            sphere.materials = [material]
            
            let node = SCNNode(geometry: sphere)
            node.position = star.position
            scene.rootNode.addChildNode(node)
        }
        
        // Simple camera
        let camera = SCNCamera()
        camera.zFar = 100
        camera.fieldOfView = 60
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
}

struct BrightStar {
    let name: String
    let ra: Double      // hours
    let dec: Double     // degrees
    let mag: Double
    let spectral: String
    
    var position: SCNVector3 {
        // Convert RA/Dec to cartesian on unit sphere (simplified)
        let raRad = ra * .pi / 12.0
        let decRad = dec * .pi / 180.0
        let r: Float = 10
        return SCNVector3(
            r * Float(cos(decRad) * cos(raRad)),
            r * Float(sin(decRad)),
            r * Float(cos(decRad) * sin(raRad))
        )
    }
    
    var color: UIColor {
        switch spectral.prefix(1) {
        case "O", "B": return UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1)
        case "A": return UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1)
        case "F": return UIColor.white
        case "G": return UIColor(red: 1.0, green: 0.98, blue: 0.85, alpha: 1)
        case "K": return UIColor(red: 1.0, green: 0.85, blue: 0.6, alpha: 1)
        case "M": return UIColor(red: 1.0, green: 0.65, blue: 0.45, alpha: 1)
        default: return UIColor.white
        }
    }
}

enum BrightStarCatalog {
    // A small but real set of the brightest stars for the first working version
    static let stars: [BrightStar] = [
        BrightStar(name: "Sirius",     ra: 6.7525, dec: -16.7161, mag: -1.46, spectral: "A1"),
        BrightStar(name: "Canopus",    ra: 6.3992, dec: -52.6956, mag: -0.74, spectral: "A9"),
        BrightStar(name: "Rigil Kentaurus", ra: 14.6601, dec: -60.8356, mag: -0.27, spectral: "G2"),
        BrightStar(name: "Arcturus",   ra: 14.2610, dec: 19.1825, mag: -0.05, spectral: "K1.5"),
        BrightStar(name: "Vega",       ra: 18.6156, dec: 38.7836, mag: 0.03, spectral: "A0"),
        BrightStar(name: "Capella",    ra: 5.2782,  dec: 45.9980, mag: 0.08, spectral: "G5"),
        BrightStar(name: "Rigel",      ra: 5.2423,  dec: -8.2017, mag: 0.13, spectral: "B8"),
        BrightStar(name: "Procyon",    ra: 7.6550,  dec: 5.2250,  mag: 0.34, spectral: "F5"),
        BrightStar(name: "Betelgeuse", ra: 5.9195,  dec: 7.4070,  mag: 0.42, spectral: "M2"),
        BrightStar(name: "Achernar",   ra: 1.6286,  dec: -57.2367, mag: 0.46, spectral: "B6"),
        BrightStar(name: "Hadar",      ra: 14.0637, dec: -60.3728, mag: 0.61, spectral: "B1"),
        BrightStar(name: "Altair",     ra: 19.8463, dec: 8.8683,  mag: 0.76, spectral: "A7"),
        BrightStar(name: "Aldebaran",  ra: 4.5987,  dec: 16.5092, mag: 0.86, spectral: "K5"),
        BrightStar(name: "Antares",    ra: 16.4901, dec: -26.4319, mag: 0.96, spectral: "M1"),
        BrightStar(name: "Spica",      ra: 13.4199, dec: -11.1613, mag: 0.98, spectral: "B1"),
        BrightStar(name: "Pollux",     ra: 7.7553,  dec: 28.0262, mag: 1.14, spectral: "K0"),
        BrightStar(name: "Fomalhaut",  ra: 22.9608, dec: -29.6222, mag: 1.16, spectral: "A3"),
        BrightStar(name: "Deneb",      ra: 20.6905, dec: 45.2803, mag: 1.25, spectral: "A2"),
        BrightStar(name: "Regulus",    ra: 10.1395, dec: 11.9672, mag: 1.35, spectral: "B7"),
        BrightStar(name: "Adhara",     ra: 6.9771,  dec: -28.9721, mag: 1.50, spectral: "B2"),
        BrightStar(name: "Castor",     ra: 7.5766,  dec: 31.8885, mag: 1.58, spectral: "A1"),
        BrightStar(name: "Polaris",    ra: 2.5303,  dec: 89.2641, mag: 1.98, spectral: "F7"),
        // A few more for density
        BrightStar(name: "Bellatrix",  ra: 5.4189,  dec: 6.3497,  mag: 1.64, spectral: "B2"),
        BrightStar(name: "Elnath",     ra: 5.4382,  dec: 28.6075, mag: 1.65, spectral: "B7"),
        BrightStar(name: "Miaplacidus",ra: 9.2200,  dec: -69.7172, mag: 1.67, spectral: "A2"),
        BrightStar(name: "Alnilam",    ra: 5.6036,  dec: -1.2019, mag: 1.69, spectral: "B0"),
        BrightStar(name: "Alnair",     ra: 22.1372, dec: -46.9609, mag: 1.74, spectral: "B7"),
        BrightStar(name: "Alioth",     ra: 12.9005, dec: 55.9598, mag: 1.77, spectral: "A1"),
        BrightStar(name: "Regor",      ra: 8.1589,  dec: -47.3366, mag: 1.78, spectral: "WC"),
        BrightStar(name: "Mirfak",     ra: 3.4054,  dec: 49.8612, mag: 1.79, spectral: "F5"),
        BrightStar(name: "Dubhe",      ra: 11.0621, dec: 61.7510, mag: 1.79, spectral: "K0"),
        BrightStar(name: "Kaus Australis", ra: 18.4029, dec: -34.3844, mag: 1.79, spectral: "B9"),
        BrightStar(name: "Wezen",      ra: 7.1395,  dec: -26.3932, mag: 1.83, spectral: "F8"),
        BrightStar(name: "Alkaid",     ra: 13.7924, dec: 49.3133, mag: 1.86, spectral: "B3"),
        BrightStar(name: "Sargas",     ra: 17.6219, dec: -42.9978, mag: 1.86, spectral: "F1"),
        BrightStar(name: "Avior",      ra: 8.3752,  dec: -59.5095, mag: 1.86, spectral: "K3"),
        BrightStar(name: "Menkalinan", ra: 5.9923,  dec: 44.9474, mag: 1.90, spectral: "A2"),
        BrightStar(name: "Atria",      ra: 16.8111, dec: -69.0277, mag: 1.91, spectral: "K2"),
        BrightStar(name: "Alhena",     ra: 6.6286,  dec: 16.3993, mag: 1.93, spectral: "A0"),
        BrightStar(name: "Peacock",    ra: 20.4275, dec: -56.7350, mag: 1.94, spectral: "B2"),
        BrightStar(name: "Alsephina",  ra: 10.7790, dec: -49.4201, mag: 1.95, spectral: "A1"),
        BrightStar(name: "Mirzam",     ra: 6.3783,  dec: -17.9559, mag: 1.98, spectral: "B1"),
        BrightStar(name: "Alphard",    ra: 9.4597,  dec: -8.6586,  mag: 1.99, spectral: "K3"),
        BrightStar(name: "Polaris",    ra: 2.5303,  dec: 89.2641, mag: 1.98, spectral: "F7"),
    ]
}
