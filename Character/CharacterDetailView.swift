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
                ForEach(character.advantages) { advantage in
                    HStack {
                        Text(advantage.name)
                        Spacer()
                        Text("\(advantage.cost) pts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if advantage.isCustom {
                            Text("(Custom)")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                if !character.advantages.isEmpty {
                    HStack {
                        Text("Total Cost:")
                            .font(.headline)
                        Spacer()
                        Text("\(character.totalAdvantageCost) pts")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }

            Section(header: Text("Flaws")) {
                ForEach(character.flaws) { flaw in
                    HStack {
                        Text(flaw.name)
                        Spacer()
                        Text("\(abs(flaw.cost)) pts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if flaw.isCustom {
                            Text("(Custom)")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                if !character.flaws.isEmpty {
                    HStack {
                        Text("Total Value:")
                            .font(.headline)
                        Spacer()
                        Text("\(abs(character.totalFlawValue)) pts")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
                if !character.advantages.isEmpty || !character.flaws.isEmpty {
                    HStack {
                        Text("Net Cost:")
                            .font(.headline)
                        Spacer()
                        Text("\(character.netAdvantageFlawCost) pts")
                            .font(.headline)
                            .foregroundColor(character.netAdvantageFlawCost <= 0 ? .green : .red)
                    }
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
