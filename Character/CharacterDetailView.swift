import SwiftUI

struct CharacterDetailView: View {
    var character: Character

    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                Text("Name: \(character.name)")
                Text("Clan: \(character.clan)")
                Text("Generation: \(character.generation)")
            }
            
            Section(header: Text("Core Traits")) {
                Text("Blood Potency: \(character.bloodPotency)")
                Text("Humanity: \(character.humanity)")
                Text("Willpower: \(character.willpower)")
                Text("Experience: \(character.experience)")
            }

            Section(header: Text("Physical Attributes")) {
                ForEach(character.physicalAttributes.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }
            
            Section(header: Text("Social Attributes")) {
                ForEach(character.socialAttributes.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }
            
            Section(header: Text("Mental Attributes")) {
                ForEach(character.mentalAttributes.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }
            
            Section(header: Text("Physical Skills")) {
                ForEach(character.physicalSkills.filter { $0.value > 0 }.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }
            
            Section(header: Text("Social Skills")) {
                ForEach(character.socialSkills.filter { $0.value > 0 }.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }
            
            Section(header: Text("Mental Skills")) {
                ForEach(character.mentalSkills.filter { $0.value > 0 }.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }

            Section(header: Text("Disciplines")) {
                ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }

            Section(header: Text("Advantages")) {
                ForEach(character.advantages, id: \.self) { adv in
                    Text(adv)
                }
            }

            Section(header: Text("Flaws")) {
                ForEach(character.flaws, id: \.self) { flaw in
                    Text(flaw)
                }
            }
            
            Section(header: Text("Convictions")) {
                ForEach(character.convictions, id: \.self) { conviction in
                    Text(conviction)
                }
            }
            
            Section(header: Text("Touchstones")) {
                ForEach(character.touchstones, id: \.self) { touchstone in
                    Text(touchstone)
                }
            }
            
            Section(header: Text("Chronicle Tenets")) {
                ForEach(character.chronicleTenets, id: \.self) { tenet in
                    Text(tenet)
                }
            }

            Section(header: Text("Condition Tracking")) {
                Text("Hunger: \(character.hunger)")
                Text("Health: \(character.health)")
            }
        }
        .navigationTitle(character.name)
    }
}
