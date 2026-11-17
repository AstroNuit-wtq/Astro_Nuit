import SwiftUI

struct NebulaeView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(NebulaCatalog.all) { nebula in
                        NebulaCard(nebula: nebula)
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Туманности")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct NebulaCard: View {
    let nebula: Nebula
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            AsyncImage(url: URL(string: nebula.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                case .failure:
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("Не удалось загрузить").foregroundStyle(.white.opacity(0.5)))
                case .empty:
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(ProgressView().tint(.white))
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(nebula.nameRU)
                .font(.title3.bold())
                .foregroundStyle(.white)
            
            Text("\(nebula.type) • \(nebula.constellation)")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            
            Text(nebula.distance)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
            
            Text(nebula.description)
                .font(.body)
                .foregroundStyle(.white.opacity(0.85))
                .lineSpacing(3)
            
            Text(nebula.credit)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
