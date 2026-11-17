import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLaunch = true
    @State private var showNebulae = false
    @State private var selectedObject: String? = nil
    
    var body: some View {
        ZStack {
            // Main sky
            SkyScreen()
            
            // UI overlay
            VStack {
                TopBar()
                Spacer()
                BottomToolbar(
                    onNebulae: { showNebulae = true }
                )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            
            // Launch animation
            if showLaunch {
                LaunchView {
                    withAnimation(.easeOut(duration: 0.8)) {
                        showLaunch = false
                    }
                }
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
        .sheet(isPresented: $showNebulae) {
            NebulaeView()
        }
        .sheet(item: $selectedObject) { name in
            ObjectDetailView(name: name)
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

// MARK: - Launch Animation
struct LaunchView: View {
    let onFinish: () -> Void
    @State private var opacity: Double = 0
    @State private var scale: Double = 0.8
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Astro_Nuit")
                    .font(.system(size: 42, weight: .light, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Исследуй ночное небо")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                opacity = 1
                scale = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onFinish()
            }
        }
    }
}

// MARK: - Top Bar
struct TopBar: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.system(size: 13, weight: .medium))
                Text("Текущее место")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.9))
            
            Spacer()
            
            Text(appState.currentDate.formatted(date: .abbreviated, time: .shortened))
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background {
            if appState.useGlassEffect {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
            } else {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.black.opacity(0.55))
            }
        }
    }
}
