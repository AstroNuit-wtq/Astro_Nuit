import SwiftUI
import SceneKit

struct SkyScreen: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        SceneView(
            scene: SkySceneBuilder.build(maxMagnitude: appState.maxStarMagnitude, date: appState.currentDate, showConstellations: appState.showConstellationLines),
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .ignoresSafeArea()
        .background(Color.black)
    }
}

enum SkySceneBuilder {
    static func build(maxMagnitude: Double, date: Date, showConstellations: Bool) -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        for star in BrightStarCatalog.stars where star.mag <= maxMagnitude {
            let radius = CGFloat(max(0.008, 0.035 - star.mag * 0.004))
            let sphere = SCNSphere(radius: radius)
            let mat = SCNMaterial()
            mat.diffuse.contents = UIColor.white
            mat.emission.contents = star.color
            mat.lightingModel = .constant
            sphere.materials = [mat]
            let node = SCNNode(geometry: sphere)
            node.position = star.position
            node.name = star.name
            scene.rootNode.addChildNode(node)
        }

        for body in AstronomyEngine.Body.allCases {
            let eq = AstronomyEngine.position(of: body, at: date)
            let sphere = SCNSphere(radius: body.baseSize)
            let mat = SCNMaterial()
            mat.diffuse.contents = body.color
            mat.emission.contents = body.color
            mat.lightingModel = .constant
            sphere.materials = [mat]
            let node = SCNNode(geometry: sphere)
            node.position = AstronomyEngine.cartesian(from: eq)
            node.name = body.displayName
            scene.rootNode.addChildNode(node)
        }

        let cam = SCNNode()
        cam.camera = SCNCamera()
        cam.camera?.zFar = 100
        cam.camera?.fieldOfView = 65
        scene.rootNode.addChildNode(cam)
        return scene
    }
}

struct BrightStar {
    let name: String
    let ra: Double
    let dec: Double
    let mag: Double
    let spectral: String
    var position: SCNVector3 {
        let raRad = ra * .pi / 12
        let decRad = dec * .pi / 180
        let r: Float = 10
        return SCNVector3(r * Float(cos(decRad) * cos(raRad)), r * Float(sin(decRad)), r * Float(cos(decRad) * sin(raRad)))
    }
    var color: UIColor {
        switch spectral.prefix(1) {
        case "O", "B": return UIColor(red: 0.7, green: 0.8, blue: 1, alpha: 1)
        case "A": return UIColor(red: 0.9, green: 0.95, blue: 1, alpha: 1)
        case "F": return .white
        case "G": return UIColor(red: 1, green: 0.98, blue: 0.85, alpha: 1)
        case "K": return UIColor(red: 1, green: 0.85, blue: 0.6, alpha: 1)
        case "M": return UIColor(red: 1, green: 0.65, blue: 0.45, alpha: 1)
        default: return .white
        }
    }
}

enum BrightStarCatalog {
    static let stars: [BrightStar] = [
        .init(name: "Sirius", ra: 6.7525, dec: -16.7161, mag: -1.46, spectral: "A1"),
        .init(name: "Canopus", ra: 6.3992, dec: -52.6956, mag: -0.74, spectral: "A9"),
        .init(name: "Arcturus", ra: 14.2610, dec: 19.1825, mag: -0.05, spectral: "K1.5"),
        .init(name: "Vega", ra: 18.6156, dec: 38.7836, mag: 0.03, spectral: "A0"),
        .init(name: "Capella", ra: 5.2782, dec: 45.9980, mag: 0.08, spectral: "G5"),
        .init(name: "Rigel", ra: 5.2423, dec: -8.2017, mag: 0.13, spectral: "B8"),
        .init(name: "Procyon", ra: 7.6550, dec: 5.2250, mag: 0.34, spectral: "F5"),
        .init(name: "Betelgeuse", ra: 5.9195, dec: 7.4070, mag: 0.42, spectral: "M2"),
        .init(name: "Altair", ra: 19.8463, dec: 8.8683, mag: 0.76, spectral: "A7"),
        .init(name: "Aldebaran", ra: 4.5987, dec: 16.5092, mag: 0.86, spectral: "K5"),
        .init(name: "Antares", ra: 16.4901, dec: -26.4319, mag: 0.96, spectral: "M1"),
        .init(name: "Spica", ra: 13.4199, dec: -11.1613, mag: 0.98, spectral: "B1"),
        .init(name: "Pollux", ra: 7.7553, dec: 28.0262, mag: 1.14, spectral: "K0"),
        .init(name: "Fomalhaut", ra: 22.9608, dec: -29.6222, mag: 1.16, spectral: "A3"),
        .init(name: "Deneb", ra: 20.6905, dec: 45.2803, mag: 1.25, spectral: "A2"),
        .init(name: "Regulus", ra: 10.1395, dec: 11.9672, mag: 1.35, spectral: "B7"),
        .init(name: "Bellatrix", ra: 5.4189, dec: 6.3497, mag: 1.64, spectral: "B2"),
        .init(name: "Alnilam", ra: 5.6036, dec: -1.2019, mag: 1.69, spectral: "B0"),
        .init(name: "Alioth", ra: 12.9005, dec: 55.9598, mag: 1.77, spectral: "A1"),
        .init(name: "Dubhe", ra: 11.0621, dec: 61.7510, mag: 1.79, spectral: "K0"),
        .init(name: "Alkaid", ra: 13.7924, dec: 49.3133, mag: 1.86, spectral: "B3"),
        .init(name: "Polaris", ra: 2.5303, dec: 89.2641, mag: 1.98, spectral: "F7"),
    ]
}
