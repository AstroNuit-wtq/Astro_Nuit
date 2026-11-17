import Foundation

struct Nebula: Identifiable {
    let id = UUID()
    let name: String
    let nameRU: String
    let type: String
    let constellation: String
    let distance: String
    let description: String
    let imageURL: String   // Only public domain / NASA / ESA links
    let credit: String
}

enum NebulaCatalog {
    
    static let all: [Nebula] = [
        Nebula(
            name: "Orion Nebula",
            nameRU: "Туманность Ориона (M42)",
            type: "Эмиссионная / отражательная",
            constellation: "Орион",
            distance: "≈ 1344 световых года",
            description: "Одна из самых ярких туманностей ночного неба. Область активного звездообразования. Видна невооружённым глазом.",
            imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic0601a.jpg",
            credit: "NASA, ESA, M. Robberto (STScI/ESA) et al. — public domain / NASA"
        ),
        Nebula(
            name: "Crab Nebula",
            nameRU: "Крабовидная туманность (M1)",
            type: "Остаток сверхновой",
            constellation: "Телец",
            distance: "≈ 6500 световых лет",
            description: "Остаток сверхновой, вспыхнувшей в 1054 году. В центре находится пульсар. Источник сильного радио- и рентгеновского излучения.",
            imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic0515a.jpg",
            credit: "NASA, ESA, J. Hester, A. Loll (ASU) — public domain / NASA"
        ),
        Nebula(
            name: "Ring Nebula",
            nameRU: "Кольцевая туманность (M57)",
            type: "Планетарная туманность",
            constellation: "Лира",
            distance: "≈ 2280 световых лет",
            description: "Классическая планетарная туманность — сброшенная оболочка умирающей звезды. Центральная звезда — белый карлик.",
            imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic1310a.jpg",
            credit: "NASA, ESA, C.R. O'Dell (Vanderbilt University) — public domain / NASA"
        ),
        Nebula(
            name: "Eagle Nebula",
            nameRU: "Туманность Орла (M16) — Столпы Творения",
            type: "Эмиссионная туманность",
            constellation: "Змея",
            distance: "≈ 7000 световых лет",
            description: "Знаменитые «Столпы Творения» — плотные колонны газа и пыли, в которых рождаются новые звёзды.",
            imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic1501a.jpg",
            credit: "NASA, ESA, Hubble Heritage Team — public domain / NASA"
        ),
        Nebula(
            name: "Helix Nebula",
            nameRU: "Туманность Улитка (NGC 7293)",
            type: "Планетарная туманность",
            constellation: "Водолей",
            distance: "≈ 650 световых лет",
            description: "Одна из ближайших к нам планетарных туманностей. Часто называют «Глазом Бога» из-за внешнего вида.",
            imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic0311a.jpg",
            credit: "NASA, ESA, C.R. O'Dell (Vanderbilt) — public domain / NASA"
        ),
        Nebula(
            name: "Carina Nebula",
            nameRU: "Туманность Киля (NGC 3372)",
            type: "Эмиссионная туманность",
            constellation: "Киль",
            distance: "≈ 7500 световых лет",
            description: "Огромная область звездообразования. Содержит знаменитую звезду Эта Киля и множество молодых массивных звёзд.",
            imageURL: "https://cdn.spacetelescope.org/archives/images/large/heic0707a.jpg",
            credit: "NASA, ESA, N. Smith (University of California, Berkeley) — public domain / NASA"
        )
    ]
}
