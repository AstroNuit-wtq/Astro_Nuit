import SwiftUI

@main
struct AstroNuitApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var isNightMode: Bool = false
    @Published var useGlassEffect: Bool = true
    @Published var visualMode: VisualMode = .scientific
    @Published var showConstellationLines: Bool = true
    @Published var showConstellationNames: Bool = true
    @Published var showConstellationArt: Bool = false
    @Published var maxStarMagnitude: Double = 5.5
    @Published var currentDate: Date = Date()
    @Published var isSensorMode: Bool = false
    
    enum VisualMode: String, CaseIterable {
        case scientific = "Научный"
        case atmospheric = "Атмосферный"
    }
}
