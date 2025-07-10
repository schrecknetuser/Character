import SwiftUI

struct CharacterDetailView: View {
    var character: Character

    var body: some View {
        Form {
            Section(header: Text("Basics")) {
                Text("Name: \(character.name)")
                Text("Clan: \(character.clan)")
                Text("Generation: \(character.generation)")
            }

            Section(header: Text("Attributes")) {
                ForEach(character.attributes.sorted(by: { $0.key < $1.key }), id: \ .key) { key, value in
                    Text("\(key): \(value)")
                }
            }

            Section(header: Text("Disciplines")) {
                ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \ .key) { key, value in
                    Text("\(key): \(value)")
                }
            }

            Section(header: Text("Advantages")) {
                ForEach(character.advantages, id: \ .self) { adv in
                    Text(adv)
                }
            }

            Section(header: Text("Flaws")) {
                ForEach(character.flaws, id: \ .self) { flaw in
                    Text(flaw)
                }
            }

            Section(header: Text("Hunger & Health")) {
                Text("Hunger: \(character.hunger)")
                Text("Health: \(character.health)")
            }
        }
        .navigationTitle(character.name)
    }
}
