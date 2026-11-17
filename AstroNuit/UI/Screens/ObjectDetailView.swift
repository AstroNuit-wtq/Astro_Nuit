import SwiftUI

struct ObjectDetailView: View {
    let name: String
    @Environment(\.dismiss) private var dismiss
    @State private var showCrossSection = false
    
    private var info: (title: String, subtitle: String, text: String) {
        CelestialDescriptions.description(for: name)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text(info.title)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        
                        Text(info.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    // Description
                    Text(info.text)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineSpacing(4)
                    
                    // Cross section button (for planets)
                    if isPlanet {
                        Button {
                            showCrossSection = true
                        } label: {
                            Label("Вид в разрезе", systemImage: "circle.lefthalf.filled")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .foregroundStyle(.white)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(24)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $showCrossSection) {
                CrossSectionView(planetName: name)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var isPlanet: Bool {
        let planets = ["Солнце", "Луна", "Меркурий", "Венера", "Марс", "Юпитер", "Сатурн", "Уран", "Нептун",
                       "Sun", "Moon", "Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
        return planets.contains(name)
    }
}

// MARK: - Cross Section
struct CrossSectionView: View {
    let planetName: String
    @Environment(\.dismiss) private var dismiss
    
    private var layers: [(name: String, description: String)] {
        switch planetName.lowercased() {
        case "земля", "earth":
            return [
                ("Кора", "Тонкий внешний слой (5–70 км)."),
                ("Мантия", "Вязкий слой силикатов (≈ 2900 км)."),
                ("Внешнее ядро", "Жидкое железо-никелевое ядро."),
                ("Внутреннее ядро", "Твёрдое железо-никелевое ядро.")
            ]
        case "марс", "mars":
            return [
                ("Кора", "Толще земной, базальтовая."),
                ("Мантия", "Силикатная мантия."),
                ("Ядро", "Жидкое/твёрдое железо-сульфидное ядро.")
            ]
        case "юпитер", "jupiter":
            return [
                ("Атмосфера", "Водород, гелий, облака аммиака."),
                ("Металлический водород", "Слой жидкого металлического водорода."),
                ("Ядро", "Предположительно скальное/ледяное ядро.")
            ]
        case "солнце", "sun":
            return [
                ("Ядро", "Термоядерные реакции (≈ 15 млн °C)."),
                ("Зона излучения", "Энергия передаётся излучением."),
                ("Конвективная зона", "Перемешивание плазмы."),
                ("Фотосфера", "Видимая «поверхность»."),
                ("Хромосфера и корона", "Внешние слои атмосферы.")
            ]
        default:
            return [
                ("Внешний слой", "Атмосфера или кора."),
                ("Промежуточный слой", "Мантия или металлический водород."),
                ("Ядро", "Центральная область.")
            ]
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Строение: \(planetName)")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    Text("Упрощённая схема слоёв (на основе открытых научных данных)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    ForEach(Array(layers.enumerated()), id: \.offset) { index, layer in
                        HStack(alignment: .top, spacing: 14) {
                            Circle()
                                .fill(Color.blue.opacity(0.8 - Double(index) * 0.15))
                                .frame(width: 16, height: 16)
                                .padding(.top, 4)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(layer.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(layer.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.75))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .padding(24)
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
