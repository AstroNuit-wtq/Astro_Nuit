import SwiftUI
import SceneKit

struct SkyScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedName: String? = nil
    
    var body: some View {
        ZStack {
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
            
            // Simple selection overlay
            if let name = selectedName {
                VStack {
                    Spacer()
                    ObjectCard(name: name) {
                        selectedName = nil
                    }
                    .padding()
                }
            }
        }
    }
}

struct ObjectCard: View {
    let name: String
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            Text("Нажми на объект для информации (в следующих версиях будет подробная карточка)")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

enum SkySceneBuilder {
    
    static func build(maxMagnitude: Double, date: Date, showConstellations: Bool) -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        
        // Stars
        let stars = BrightStarCatalog.stars.filter { $0.mag <= maxMagnitude }
        var starNodes: [String: SCNNode] = [:]
        
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
            node.name = star.name
            scene.rootNode.addChildNode(node)
            starNodes[star.name] = node
        }
        
        // Planets + Sun + Moon
        for body in AstronomyEngine.Body.allCases {
            let eq = AstronomyEngine.position(of: body, at: date)
            let pos = AstronomyEngine.cartesian(from: eq)
            
            let sphere = SCNSphere(radius: body.baseSize)
            let material = SCNMaterial()
            material.diffuse.contents = body.color
            material.emission.contents = body.color
            material.lightingModel = .constant
            sphere.materials = [material]
            
            let node = SCNNode(geometry: sphere)
            node.position = pos
            node.name = body.displayName
            scene.rootNode.addChildNode(node)
        }
        
        // Constellation lines (major ones)
        if showConstellations {
            addConstellationLines(to: scene, starNodes: starNodes)
        }
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 100
        cameraNode.camera?.fieldOfView = 65
        cameraNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
    
    private static func addConstellationLines(to scene: SCNScene, starNodes: [String: SCNNode]) {
        // Simple line helper
        func line(from a: String, to b: String) {
            guard let n1 = starNodes[a], let n2 = starNodes[b] else { return }
            let positions: [SCNVector3] = [n1.position, n2.position]
            let source = SCNGeometrySource(vertices: positions)
            let indices: [Int32] = [0, 1]
            let element = SCNGeometryElement(indices: indices, primitiveType: .line)
            let geometry = SCNGeometry(sources: [source], elements: [element])
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white.withAlphaComponent(0.35)
            material.lightingModel = .constant
            geometry.materials = [material]
            let node = SCNNode(geometry: geometry)
            scene.rootNode.addChildNode(node)
        }
        
        // Orion
        line(from: "Betelgeuse", to: "Bellatrix")
        line(from: "Bellatrix", to: "Alnilam")
        line(from: "Alnilam", to: "Rigel")
        line(from: "Betelgeuse", to: "Alnilam")
        
        // Big Dipper / Ursa Major (using available stars)
        line(from: "Dubhe", to: "Merak") // Merak may not exist, will skip
        line(from: "Dubhe", to: "Alioth")
        line(from: "Alioth", to: "Alkaid")
        
        // Summer Triangle
        line(from: "Vega", to: "Deneb")
        line(from: "Deneb", to: "Altair")
        line(from: "Altair", to: "Vega")
        
        // Taurus
        line(from: "Aldebaran", to: "Elnath")
    }
}

struct BrightStar {
    let name: String
    let ra: Double
    let dec: Double
    let mag: Double
    let spectral: String
    
    var position: SCNVector3 {
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
    static let stars: [BrightStar] = [
        BrightStar(name: "Sirius", ra: 6.7525, dec: -16.7161, mag: -1.46, spectral: "A1"),
        BrightStar(name: "Canopus", ra: 6.3992, dec: -52.6956, mag: -0.74, spectral: "A9"),
        BrightStar(name: "Arcturus", ra: 14.2610, dec: 19.1825, mag: -0.05, spectral: "K1.5"),
        BrightStar(name: "Vega", ra: 18.6156, dec: 38.7836, mag: 0.03, spectral: "A0"),
        BrightStar(name: "Capella", ra: 5.2782, dec: 45.9980, mag: 0.08, spectral: "G5"),
        BrightStar(name: "Rigel", ra: 5.2423, dec: -8.2017, mag: 0.13, spectral: "B8"),
        BrightStar(name: "Procyon", ra: 7.6550, dec: 5.2250, mag: 0.34, spectral: "F5"),
        BrightStar(name: "Betelgeuse", ra: 5.9195, dec: 7.4070, mag: 0.42, spectral: "M2"),
        BrightStar(name: "Achernar", ra: 1.6286, dec: -57.2367, mag: 0.46, spectral: "B6"),
        BrightStar(name: "Altair", ra: 19.8463, dec: 8.8683, mag: 0.76, spectral: "A7"),
        BrightStar(name: "Aldebaran", ra: 4.5987, dec: 16.5092, mag: 0.86, spectral: "K5"),
        BrightStar(name: "Antares", ra: 16.4901, dec: -26.4319, mag: 0.96, spectral: "M1"),
        BrightStar(name: "Spica", ra: 13.4199, dec: -11.1613, mag: 0.98, spectral: "B1"),
        BrightStar(name: "Pollux", ra: 7.7553, dec: 28.0262, mag: 1.14, spectral: "K0"),
        BrightStar(name: "Fomalhaut", ra: 22.9608, dec: -29.6222, mag: 1.16, spectral: "A3"),
        BrightStar(name: "Deneb", ra: 20.6905, dec: 45.2803, mag: 1.25, spectral: "A2"),
        BrightStar(name: "Regulus", ra: 10.1395, dec: 11.9672, mag: 1.35, spectral: "B7"),
        BrightStar(name: "Adhara", ra: 6.9771, dec: -28.9721, mag: 1.50, spectral: "B2"),
        BrightStar(name: "Castor", ra: 7.5766, dec: 31.8885, mag: 1.58, spectral: "A1"),
        BrightStar(name: "Bellatrix", ra: 5.4189, dec: 6.3497, mag: 1.64, spectral: "B2"),
        BrightStar(name: "Elnath", ra: 5.4382, dec: 28.6075, mag: 1.65, spectral: "B7"),
        BrightStar(name: "Alnilam", ra: 5.6036, dec: -1.2019, mag: 1.69, spectral: "B0"),
        BrightStar(name: "Alioth", ra: 12.9005, dec: 55.9598, mag: 1.77, spectral: "A1"),
        BrightStar(name: "Dubhe", ra: 11.0621, dec: 61.7510, mag: 1.79, spectral: "K0"),
        BrightStar(name: "Alkaid", ra: 13.7924, dec: 49.3133, mag: 1.86, spectral: "B3"),
        BrightStar(name: "Polaris", ra: 2.5303, dec: 89.2641, mag: 1.98, spectral: "F7"),
        BrightStar(name: "Mirfak", ra: 3.4054, dec: 49.8612, mag: 1.79, spectral: "F5"),
        BrightStar(name: "Alhena", ra: 6.6286, dec: 16.3993, mag: 1.93, spectral: "A0"),
        BrightStar(name: "Alphard", ra: 9.4597, dec: -8.6586, mag: 1.99, spectral: "K3"),
    ]
}
