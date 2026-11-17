import SwiftUI

struct BottomToolbar: View {
    @EnvironmentObject var appState: AppState
    var onNebulae: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 16) {
            ToolbarButton(icon: "magnifyingglass")
            
            Button {
                onNebulae()
            } label: {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }
            
            ToolbarButton(icon: "slider.horizontal.3")
            
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    appState.isNightMode.toggle()
                }
            } label: {
                Image(systemName: appState.isNightMode ? "moon.fill" : "moon")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(appState.isNightMode ? AppTheme.nightRed : .white)
                    .frame(width: 44, height: 44)
            }
            
            ToolbarButton(icon: appState.isSensorMode ? "location.north.line.fill" : "location.north.line")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            GlassPanel(cornerRadius: 22) { Color.clear }
        }
    }
}

struct ToolbarButton: View {
    let icon: String
    
    var body: some View {
        Button {
        } label: {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
        }
    }
}
