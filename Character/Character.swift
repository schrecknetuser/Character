import SwiftUI

struct Character: Identifiable, Codable {
    var id = UUID()
    var name: String
    var clan: String
    var generation: Int
    var attributes: [String: Int]
    var disciplines: [String: Int]
    var advantages: [String]
    var flaws: [String]
    var hunger: Int
    var health: Int
}

class CharacterStore: ObservableObject {
    @Published var characters: [Character] {
        didSet {
            save()
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "characters"),
           let decoded = try? JSONDecoder().decode([Character].self, from: data) {
            characters = decoded
        } else {
            characters = []
        }
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(characters) {
            UserDefaults.standard.set(encoded, forKey: "characters")
        }
    }

    func addCharacter(_ character: Character) {
        characters.append(character)
    }

    func deleteCharacter(at offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }
}
