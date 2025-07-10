import SwiftUI

// Helper view for managing advantages list
struct AdvantagesListView: View {
    @Binding var selectedAdvantages: [Advantage]
    @State private var showingAddAdvantage = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Advantages")
                    .font(.headline)
                Spacer()
                Text("Total Cost: \(selectedAdvantages.reduce(0) { $0 + $1.cost })")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(selectedAdvantages) { advantage in
                HStack {
                    Text(advantage.name)
                    Spacer()
                    Text("\(advantage.cost) pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(action: {
                        selectedAdvantages.removeAll { $0.id == advantage.id }
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add Advantage") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showingAddAdvantage = true
            }
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $showingAddAdvantage) {
            AddAdvantageView(selectedAdvantages: $selectedAdvantages)
        }
    }
}

// Helper view for adding advantages
struct AddAdvantageView: View {
    @Binding var selectedAdvantages: [Advantage]
    @Environment(\.dismiss) var dismiss
    @State private var selectedPredefined: Advantage?
    @State private var customName = ""
    @State private var customCost = 1
    @State private var isCustom = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Predefined Advantages") {
                    ForEach(V5Constants.predefinedAdvantages) { advantage in
                        HStack {
                            Text(advantage.name)
                            Spacer()
                            Text("\(advantage.cost) pts")
                                .foregroundColor(.secondary)
                            Button("Add") {
                                let newAdvantage = Advantage(name: advantage.name, cost: advantage.cost, isCustom: advantage.isCustom)
                                selectedAdvantages.append(newAdvantage)
                                // Small delay to ensure state update is processed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                }
                            }
                            .disabled(selectedAdvantages.contains { $0.name == advantage.name })
                        }
                    }
                }
                
                Section("Custom Advantage") {
                    TextField("Name", text: $customName)
                    Stepper("Cost: \(customCost)", value: $customCost, in: 1...10)
                    Button("Add Custom") {
                        let customAdvantage = Advantage(name: customName, cost: customCost, isCustom: true)
                        selectedAdvantages.append(customAdvantage)
                        // Small delay to ensure state update is processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(customName.isEmpty)
                }
            }
            .navigationTitle("Add Advantage")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Helper view for managing flaws list
struct FlawsListView: View {
    @Binding var selectedFlaws: [Flaw]
    @State private var showingAddFlaw = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Flaws")
                    .font(.headline)
                Spacer()
                Text("Total Value: \(abs(selectedFlaws.reduce(0) { $0 + $1.cost })) pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(selectedFlaws) { flaw in
                HStack {
                    Text(flaw.name)
                    Spacer()
                    Text("\(abs(flaw.cost)) pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(action: {
                        selectedFlaws.removeAll { $0.id == flaw.id }
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add Flaw") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showingAddFlaw = true
            }
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws)
        }
    }
}

// Helper view for adding flaws
struct AddFlawView: View {
    @Binding var selectedFlaws: [Flaw]
    @Environment(\.dismiss) var dismiss
    @State private var customName = ""
    @State private var customCost = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section("Predefined Flaws") {
                    ForEach(V5Constants.predefinedFlaws) { flaw in
                        HStack {
                            Text(flaw.name)
                            Spacer()
                            Text("\(abs(flaw.cost)) pts")
                                .foregroundColor(.secondary)
                            Button("Add") {
                                let newFlaw = Flaw(name: flaw.name, cost: flaw.cost, isCustom: flaw.isCustom)
                                selectedFlaws.append(newFlaw)
                                // Small delay to ensure state update is processed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                }
                            }
                            .disabled(selectedFlaws.contains { $0.name == flaw.name })
                        }
                    }
                }
                
                Section("Custom Flaw") {
                    TextField("Name", text: $customName)
                    Stepper("Value: \(customCost)", value: $customCost, in: 1...10)
                    Button("Add Custom") {
                        let customFlaw = Flaw(name: customName, cost: -customCost, isCustom: true) // Negative cost for flaws
                        selectedFlaws.append(customFlaw)
                        // Small delay to ensure state update is processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(customName.isEmpty)
                }
            }
            .navigationTitle("Add Flaw")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Helper view for managing string lists (convictions, touchstones, etc.)
struct StringListView: View {
    @Binding var items: [String]
    let title: String
    @State private var newItem = ""
    @State private var showingAdd = false
    
    // Compute singular form of title for button text
    private var singularTitle: String {
        if title.hasSuffix("s") {
            return String(title.dropLast())
        }
        return title
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack {
                    Text(item)
                    Spacer()
                    Button(action: {
                        items.remove(at: index)
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add \(singularTitle)") {
                showingAdd = true
            }
            .foregroundColor(.accentColor)
        }
        .alert("Add \(singularTitle)", isPresented: $showingAdd) {
            TextField("Enter text", text: $newItem)
            Button("Add") {
                if !newItem.isEmpty {
                    items.append(newItem)
                    newItem = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newItem = ""
            }
        }
    }
}

struct AddCharacterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: CharacterStore
    @FocusState private var isNameFieldFocused: Bool

    @State private var name = ""
    @State private var clan = ""
    @State private var generation = 13
    
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
    
    // V5 Disciplines
    @State private var selectedDisciplines: [String: Int] = [:]
    
    // V5 Character Traits
    @State private var selectedAdvantages: [Advantage] = []
    @State private var selectedFlaws: [Flaw] = []
    @State private var convictions: [String] = []
    @State private var touchstones: [String] = []
    @State private var chronicleTenets: [String] = []
    
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
                        .focused($isNameFieldFocused)
                    Picker("Clan", selection: $clan) {
                        Text("Select Clan").tag("")
                        ForEach(V5Constants.clans, id: \.self) { clanName in
                            Text(clanName).tag(clanName)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Stepper("Generation: \(generation)", value: $generation, in: 4...15)
                }
                
                Section(header: Text("Core Traits")) {
                    Stepper("Blood Potency: \(bloodPotency)", value: $bloodPotency, in: 0...10)
                    Stepper("Humanity: \(humanity)", value: $humanity, in: 0...10)
                    Stepper("Willpower: \(willpower)", value: $willpower, in: 1...10)
                    Stepper("Experience: \(experience)", value: $experience, in: 0...999)
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
                    AdvantagesListView(selectedAdvantages: $selectedAdvantages)
                    Divider()
                    FlawsListView(selectedFlaws: $selectedFlaws)
                    Divider()
                    StringListView(items: $convictions, title: "Convictions")
                    Divider()
                    StringListView(items: $touchstones, title: "Touchstones")
                    Divider()
                    StringListView(items: $chronicleTenets, title: "Chronicle Tenets")
                }
                .onTapGesture {
                    // Clear focus from all input fields when tapping anywhere in the character traits section
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                            disciplines: selectedDisciplines.filter { $0.value > 0 },
                            advantages: selectedAdvantages,
                            flaws: selectedFlaws,
                            convictions: convictions,
                            touchstones: touchstones,
                            chronicleTenets: chronicleTenets,
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
