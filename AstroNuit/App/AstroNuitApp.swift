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
    @Published var isNightMode = false
    @Published var useGlassEffect = true
    @Published var showConstellationLines = true
    @Published var maxStarMagnitude = 5.5
    @Published var currentDate = Date()
    @Published var isSensorMode = false
}
