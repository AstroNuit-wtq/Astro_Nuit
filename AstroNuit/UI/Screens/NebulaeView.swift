import SwiftUI

struct Nebula: Identifiable {
    let id = UUID()
    let nameRU: String
    let type: String
    let description: String
    let imageURL: String
    let credit: String
}

enum NebulaCatalog {
    static let all: [Nebula] = [
        Nebula(nameRU: "Туманность Ориона (M42)", type: "Эмиссионная", description: "Одна из самых ярких туманностей. Область активного звездообразования.", imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic0601a.jpg", credit: "NASA, ESA"),
        Nebula(nameRU: "Крабовидная туманность (M1)", type: "Остаток сверхновой", description: "Остаток сверхновой 1054 года. В центре — пульсар.", imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic0515a.jpg", credit: "NASA, ESA"),
        Nebula(nameRU: "Кольцевая туманность (M57)", type: "Планетарная", description: "Классическая планетарная туманность в Лире.", imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic1310a.jpg", credit: "NASA, ESA"),
        Nebula(nameRU: "Столпы Творения (M16)", type: "Эмиссионная", description: "Знаменитые колонны газа и пыли в туманности Орла.", imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic1501a.jpg", credit: "NASA, ESA"),
    ]
}

struct NebulaeView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(NebulaCatalog.all) { nebula in
                        VStack(alignment: .leading, spacing: 10) {
                            AsyncImage(url: URL(string: nebula.imageURL)) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFill().frame(height: 180).clipped()
                                } else {
                                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3)).frame(height: 180)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(nebula.nameRU).font(.headline).foregroundStyle(.white)
                            Text(nebula.type).font(.subheadline).foregroundStyle(.white.opacity(0.6))
                            Text(nebula.description).font(.body).foregroundStyle(.white.opacity(0.85))
                            Text(nebula.credit).font(.caption2).foregroundStyle(.white.opacity(0.4))
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Туманности")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
