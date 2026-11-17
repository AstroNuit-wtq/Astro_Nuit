import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLaunch = true
    @State private var showNebulae = false

    var body: some View {
        ZStack {
            SkyScreen()
            VStack {
                TopBar()
                Spacer()
                BottomToolbar(onNebulae: { showNebulae = true })
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            if showLaunch {
                LaunchView {
                    withAnimation(.easeOut(duration: 0.8)) { showLaunch = false }
                }
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
        .sheet(isPresented: $showNebulae) { NebulaeView() }
    }
}

struct LaunchView: View {
    let onFinish: () -> Void
    @State private var opacity = 0.0
    @State private var scale = 0.8
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { onFinish() }
        }
    }
}

struct TopBar: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        HStack {
            Label("Текущее место", systemImage: "location.fill")
                .font(.system(size: 13, weight: .medium))
            Spacer()
            Text(appState.currentDate.formatted(date: .abbreviated, time: .shortened))
                .font(.system(size: 13, weight: .medium, design: .monospaced))
        }
        .foregroundStyle(.white.opacity(0.9))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
