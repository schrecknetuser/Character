import SwiftUI

struct AddCharacterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: CharacterStore

    @State private var name = ""
    @State private var clan = ""
    @State private var generation = 13
    
    // Character background
    @State private var ambition = ""
    @State private var desire = ""
    @State private var chronicleName = ""
    
    // V5 Attributes
    @State private var physicalAttributes: [String: Int] = [:]
    @State private var socialAttributes: [String: Int] = [:]
    @State private var mentalAttributes: [String: Int] = [:]
    
    // V5 Skills
    @State private var physicalSkills: [String: Int] = [:]
    @State private var socialSkills: [String: Int] = [:]
    @State private var mentalSkills: [String: Int] = [:]
    
    // V5 Core Traits
    @State private var bloodPotency = 1
    @State private var humanity = 7
    @State private var willpower = 3
    @State private var experience = 0
    @State private var spentExperience = 0
    
    // V5 Disciplines
    @State private var selectedDisciplines: [String: Int] = [:]
    
    // V5 Character Traits
    @State private var advantagesText = ""
    @State private var flawsText = ""
    @State private var convictionsText = ""
    @State private var touchstonesText = ""
    @State private var chronicleTenetsText = ""
    
    // V5 Condition Tracking
    @State private var hunger = 1
    @State private var health = 3
    
    init(store: CharacterStore) {
        self.store = store
        
        // Initialize attributes with default values
        _physicalAttributes = State(initialValue: Dictionary(uniqueKeysWithValues: V5Constants.physicalAttributes.map { ($0, 1) }))
        _socialAttributes = State(initialValue: Dictionary(uniqueKeysWithValues: V5Constants.socialAttributes.map { ($0, 1) }))
        _mentalAttributes = State(initialValue: Dictionary(uniqueKeysWithValues: V5Constants.mentalAttributes.map { ($0, 1) }))
        
        // Initialize skills with default values
        _physicalSkills = State(initialValue: Dictionary(uniqueKeysWithValues: V5Constants.physicalSkills.map { ($0, 0) }))
        _socialSkills = State(initialValue: Dictionary(uniqueKeysWithValues: V5Constants.socialSkills.map { ($0, 0) }))
        _mentalSkills = State(initialValue: Dictionary(uniqueKeysWithValues: V5Constants.mentalSkills.map { ($0, 0) }))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $name)
                    Picker("Clan", selection: $clan) {
                        Text("Select Clan").tag("")
                        ForEach(V5Constants.clans, id: \.self) { clanName in
                            Text(clanName).tag(clanName)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Stepper("Generation: \(generation)", value: $generation, in: 4...15)
                }
                
                Section(header: Text("Character Background")) {
                    TextField("Chronicle Name", text: $chronicleName)
                    TextField("Ambition", text: $ambition, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Desire", text: $desire, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section(header: Text("Core Traits")) {
                    Stepper("Blood Potency: \(bloodPotency)", value: $bloodPotency, in: 0...10)
                    Stepper("Humanity: \(humanity)", value: $humanity, in: 0...10)
                    Stepper("Willpower: \(willpower)", value: $willpower, in: 1...10)
                    Stepper("Experience: \(experience)", value: $experience, in: 0...999)
                    Stepper("Spent Experience: \(spentExperience)", value: $spentExperience, in: 0...experience)
                }

                Section(header: Text("Physical Attributes")) {
                    ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                        Stepper("\(attribute): \(physicalAttributes[attribute] ?? 1)", value: Binding(
                            get: { physicalAttributes[attribute] ?? 1 },
                            set: { physicalAttributes[attribute] = $0 }
                        ), in: 1...5)
                    }
                }
                
                Section(header: Text("Social Attributes")) {
                    ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                        Stepper("\(attribute): \(socialAttributes[attribute] ?? 1)", value: Binding(
                            get: { socialAttributes[attribute] ?? 1 },
                            set: { socialAttributes[attribute] = $0 }
                        ), in: 1...5)
                    }
                }
                
                Section(header: Text("Mental Attributes")) {
                    ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                        Stepper("\(attribute): \(mentalAttributes[attribute] ?? 1)", value: Binding(
                            get: { mentalAttributes[attribute] ?? 1 },
                            set: { mentalAttributes[attribute] = $0 }
                        ), in: 1...5)
                    }
                }
                
                Section(header: Text("Physical Skills")) {
                    ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                        Stepper("\(skill): \(physicalSkills[skill] ?? 0)", value: Binding(
                            get: { physicalSkills[skill] ?? 0 },
                            set: { physicalSkills[skill] = $0 }
                        ), in: 0...5)
                    }
                }
                
                Section(header: Text("Social Skills")) {
                    ForEach(V5Constants.socialSkills, id: \.self) { skill in
                        Stepper("\(skill): \(socialSkills[skill] ?? 0)", value: Binding(
                            get: { socialSkills[skill] ?? 0 },
                            set: { socialSkills[skill] = $0 }
                        ), in: 0...5)
                    }
                }
                
                Section(header: Text("Mental Skills")) {
                    ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                        Stepper("\(skill): \(mentalSkills[skill] ?? 0)", value: Binding(
                            get: { mentalSkills[skill] ?? 0 },
                            set: { mentalSkills[skill] = $0 }
                        ), in: 0...5)
                    }
                }

                Section(header: Text("Disciplines")) {
                    ForEach(V5Constants.disciplines, id: \.self) { discipline in
                        Stepper("\(discipline): \(selectedDisciplines[discipline] ?? 0)", value: Binding(
                            get: { selectedDisciplines[discipline] ?? 0 },
                            set: { selectedDisciplines[discipline] = $0 }
                        ), in: 0...5)
                    }
                }

                Section(header: Text("Character Traits")) {
                    TextField("Advantages (comma-separated)", text: $advantagesText, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Flaws (comma-separated)", text: $flawsText, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Convictions (comma-separated)", text: $convictionsText, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Touchstones (comma-separated)", text: $touchstonesText, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Chronicle Tenets (comma-separated)", text: $chronicleTenetsText, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section(header: Text("Condition Tracking")) {
                    Stepper("Hunger: \(hunger)", value: $hunger, in: 0...5)
                    Stepper("Health: \(health)", value: $health, in: 1...10)
                }
            }
            .navigationTitle("New V5 Character")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newCharacter = Character(
                            name: name,
                            clan: clan,
                            generation: generation,
                            physicalAttributes: physicalAttributes,
                            socialAttributes: socialAttributes,
                            mentalAttributes: mentalAttributes,
                            physicalSkills: physicalSkills,
                            socialSkills: socialSkills,
                            mentalSkills: mentalSkills,
                            bloodPotency: bloodPotency,
                            humanity: humanity,
                            willpower: willpower,
                            experience: experience,
                            spentExperience: spentExperience,
                            ambition: ambition,
                            desire: desire,
                            chronicleName: chronicleName,
                            disciplines: selectedDisciplines.filter { $0.value > 0 },
                            advantages: advantagesText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                            flaws: flawsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                            convictions: convictionsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                            touchstones: touchstonesText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                            chronicleTenets: chronicleTenetsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty },
                            hunger: hunger,
                            health: health
                        )
                        store.addCharacter(newCharacter)
                        dismiss()
                    }
                    .disabled(name.isEmpty || clan.isEmpty)
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
