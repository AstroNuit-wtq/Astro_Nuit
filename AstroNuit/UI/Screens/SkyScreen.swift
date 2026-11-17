import SwiftUI
import SceneKit

struct SkyScreen: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        SceneView(
            scene: SkySceneBuilder.build(
                maxMagnitude: appState.maxStarMagnitude,
                date: appState.currentDate,
                showConstellations: appState.showConstellationLines
            ),
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
            let radius = CGFloat(max(0.006, 0.03 - star.mag * 0.0035))
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
            sphere.segmentCount = 48

            let mat = SCNMaterial()
            if let tex = loadTexture(for: body) {
                mat.diffuse.contents = tex
                mat.lightingModel = .blinn
            } else {
                mat.diffuse.contents = body.color
                mat.emission.contents = body.color.withAlphaComponent(0.7)
                mat.lightingModel = .constant
            }
            sphere.materials = [mat]

            let node = SCNNode(geometry: sphere)
            node.position = AstronomyEngine.cartesian(from: eq)
            node.name = body.displayName

            let duration: Double = (body == .jupiter || body == .saturn) ? 50 : 90
            let rot = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: duration)
            node.runAction(SCNAction.repeatForever(rot))

            scene.rootNode.addChildNode(node)
        }

        let light = SCNLight()
        light.type = .omni
        light.intensity = 900
        let lightNode = SCNNode()
        lightNode.light = light
        scene.rootNode.addChildNode(lightNode)

        let cam = SCNNode()
        cam.camera = SCNCamera()
        cam.camera?.zFar = 100
        cam.camera?.fieldOfView = 65
        scene.rootNode.addChildNode(cam)

        return scene
    }

    private static func loadTexture(for body: AstronomyEngine.Body) -> UIImage? {
        let name: String
        switch body {
        case .sun: name = "sun"
        case .moon: name = "moon"
        case .mercury: name = "mercury"
        case .venus: name = "venus"
        case .mars: name = "mars"
        case .jupiter: name = "jupiter"
        case .saturn: name = "saturn"
        case .uranus: name = "uranus"
        case .neptune: name = "neptune"
        }
        if let img = UIImage(named: name) { return img }
        if let path = Bundle.main.path(forResource: name, ofType: "jpg"),
           let img = UIImage(contentsOfFile: path) { return img }
        if let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Textures"),
           let img = UIImage(contentsOfFile: path) { return img }
        if let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Resources/Textures"),
           let img = UIImage(contentsOfFile: path) { return img }
        return nil
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
        return SCNVector3(
            r * Float(cos(decRad) * cos(raRad)),
            r * Float(sin(decRad)),
            r * Float(cos(decRad) * sin(raRad))
        )
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
        .init(name: "Achernar", ra: 1.6286, dec: -57.2367, mag: 0.46, spectral: "B6"),
        .init(name: "Altair", ra: 19.8463, dec: 8.8683, mag: 0.76, spectral: "A7"),
        .init(name: "Aldebaran", ra: 4.5987, dec: 16.5092, mag: 0.86, spectral: "K5"),
        .init(name: "Antares", ra: 16.4901, dec: -26.4319, mag: 0.96, spectral: "M1"),
        .init(name: "Spica", ra: 13.4199, dec: -11.1613, mag: 0.98, spectral: "B1"),
        .init(name: "Pollux", ra: 7.7553, dec: 28.0262, mag: 1.14, spectral: "K0"),
        .init(name: "Fomalhaut", ra: 22.9608, dec: -29.6222, mag: 1.16, spectral: "A3"),
        .init(name: "Deneb", ra: 20.6905, dec: 45.2803, mag: 1.25, spectral: "A2"),
        .init(name: "Regulus", ra: 10.1395, dec: 11.9672, mag: 1.35, spectral: "B7"),
        .init(name: "Adhara", ra: 6.9771, dec: -28.9721, mag: 1.50, spectral: "B2"),
        .init(name: "Castor", ra: 7.5766, dec: 31.8885, mag: 1.58, spectral: "A1"),
        .init(name: "Bellatrix", ra: 5.4189, dec: 6.3497, mag: 1.64, spectral: "B2"),
        .init(name: "Elnath", ra: 5.4382, dec: 28.6075, mag: 1.65, spectral: "B7"),
        .init(name: "Alnilam", ra: 5.6036, dec: -1.2019, mag: 1.69, spectral: "B0"),
        .init(name: "Alioth", ra: 12.9005, dec: 55.9598, mag: 1.77, spectral: "A1"),
        .init(name: "Dubhe", ra: 11.0621, dec: 61.7510, mag: 1.79, spectral: "K0"),
        .init(name: "Alkaid", ra: 13.7924, dec: 49.3133, mag: 1.86, spectral: "B3"),
        .init(name: "Polaris", ra: 2.5303, dec: 89.2641, mag: 1.98, spectral: "F7"),
        .init(name: "Mirfak", ra: 3.4054, dec: 49.8612, mag: 1.79, spectral: "F5"),
        .init(name: "Alhena", ra: 6.6286, dec: 16.3993, mag: 1.93, spectral: "A0"),
        .init(name: "Alphard", ra: 9.4597, dec: -8.6586, mag: 1.99, spectral: "K3"),
        .init(name: "Hamal", ra: 2.1195, dec: 23.4625, mag: 2.00, spectral: "K2"),
        .init(name: "Diphda", ra: 0.7265, dec: -17.9867, mag: 2.04, spectral: "K0"),
        .init(name: "Nunki", ra: 18.9211, dec: -26.2967, mag: 2.05, spectral: "B2"),
        .init(name: "Alpheratz", ra: 0.1398, dec: 29.0906, mag: 2.06, spectral: "B9"),
        .init(name: "Mirach", ra: 1.1622, dec: 35.6206, mag: 2.06, spectral: "M0"),
        .init(name: "Kochab", ra: 14.8451, dec: 74.1555, mag: 2.08, spectral: "K4"),
        .init(name: "Saiph", ra: 5.7959, dec: -9.6699, mag: 2.09, spectral: "B0"),
        .init(name: "Denebola", ra: 11.8177, dec: 14.5721, mag: 2.14, spectral: "A3"),
        .init(name: "Algol", ra: 3.1361, dec: 40.9556, mag: 2.12, spectral: "B8"),
        .init(name: "Gacrux", ra: 12.5194, dec: -57.1133, mag: 1.63, spectral: "M3"),
    ]
}
