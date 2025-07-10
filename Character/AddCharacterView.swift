import SwiftUI

struct AddCharacterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: CharacterStore

    @State private var name = ""
    @State private var clan = ""
    @State private var generation = 13
    @State private var attributes = ["Strength": 1, "Dexterity": 1, "Stamina": 1]
    @State private var disciplines = ["Obfuscate": 0, "Dominate": 0]
    @State private var advantagesText = ""
    @State private var flawsText = ""
    @State private var hunger = 1
    @State private var health = 5

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basics")) {
                    TextField("Name", text: $name)
                    TextField("Clan", text: $clan)
                    Stepper("Generation: \(generation)", value: $generation, in: 4...15)
                }

                Section(header: Text("Attributes")) {
                    ForEach(attributes.keys.sorted(), id: \ .self) { key in
                        Stepper("\(key): \(attributes[key]!)", value: Binding(
                            get: { attributes[key]! },
                            set: { attributes[key] = $0 }
                        ), in: 0...5)
                    }
                }

                Section(header: Text("Disciplines")) {
                    ForEach(disciplines.keys.sorted(), id: \ .self) { key in
                        Stepper("\(key): \(disciplines[key]!)", value: Binding(
                            get: { disciplines[key]! },
                            set: { disciplines[key] = $0 }
                        ), in: 0...5)
                    }
                }

                Section(header: Text("Advantages")) {
                    TextField("Advantages (comma-separated)", text: $advantagesText)
                }

                Section(header: Text("Flaws")) {
                    TextField("Flaws (comma-separated)", text: $flawsText)
                }

                Section(header: Text("Hunger & Health")) {
                    Stepper("Hunger: \(hunger)", value: $hunger, in: 0...5)
                    Stepper("Health: \(health)", value: $health, in: 1...10)
                }
            }
            .navigationTitle("New Character")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newCharacter = Character(
                            name: name,
                            clan: clan,
                            generation: generation,
                            attributes: attributes,
                            disciplines: disciplines,
                            advantages: advantagesText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                            flaws: flawsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                            hunger: hunger,
                            health: health
                        )
                        store.addCharacter(newCharacter)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}
