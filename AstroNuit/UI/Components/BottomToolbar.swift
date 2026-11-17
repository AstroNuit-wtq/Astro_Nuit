import SwiftUI

struct BottomToolbar: View {
    @EnvironmentObject var appState: AppState
    var onNebulae: () -> Void = {}

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "magnifyingglass").frame(width: 44, height: 44)
            Button(action: onNebulae) {
                Image(systemName: "sparkles").frame(width: 44, height: 44)
            }
            Image(systemName: "slider.horizontal.3").frame(width: 44, height: 44)
            Button {
                appState.isNightMode.toggle()
            } label: {
                Image(systemName: appState.isNightMode ? "moon.fill" : "moon")
                    .foregroundStyle(appState.isNightMode ? .red : .white)
                    .frame(width: 44, height: 44)
            }
            Image(systemName: "location.north.line").frame(width: 44, height: 44)
        }
        .font(.system(size: 20, weight: .medium))
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
