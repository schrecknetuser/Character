import SwiftUI
import UniformTypeIdentifiers

// Make Int conform to Transferable for drag and drop functionality
extension Int: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .plainText)
    }
}

enum CreationStage: Int, CaseIterable {
    case nameAndChronicle = 0
    case clan = 1
    case attributes = 2
    case skills = 3
    case disciplines = 4
    case meritsAndFlaws = 5
    case convictionsAndTouchstones = 6
    case ambitionAndDesire = 7
    
    var title: String {
        switch self {
        case .nameAndChronicle: return "Name & Chronicle"
        case .clan: return "Clan"
        case .attributes: return "Attributes"
        case .skills: return "Skills"
        case .disciplines: return "Disciplines"
        case .meritsAndFlaws: return "Merits & Flaws"
        case .convictionsAndTouchstones: return "Convictions & Touchstones"
        case .ambitionAndDesire: return "Ambition & Desire"
        }
    }
}

struct CharacterCreationWizard: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: CharacterStore
    
    @State private var currentStage: CreationStage = .nameAndChronicle
    @State private var character = Character()
    
    var body: some View {
        NavigationView {
            VStack {
                // Progress indicator
                ProgressView(value: Double(currentStage.rawValue + 1), total: Double(CreationStage.allCases.count))
                    .padding(.horizontal)
                
                Text("\(currentStage.rawValue + 1) of \(CreationStage.allCases.count): \(currentStage.title)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Current stage content
                Group {
                    switch currentStage {
                    case .nameAndChronicle:
                        NameAndChronicleStage(character: $character)
                    case .clan:
                        ClanSelectionStage(character: $character)
                    case .attributes:
                        AttributesStage(character: $character)
                    case .skills:
                        SkillsStage(character: $character)
                    case .disciplines:
                        DisciplinesStage(character: $character)
                    case .meritsAndFlaws:
                        MeritsAndFlawsStage(character: $character)
                    case .convictionsAndTouchstones:
                        ConvictionsAndTouchstonesStage(character: $character)
                    case .ambitionAndDesire:
                        AmbitionAndDesireStage(character: $character)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Navigation buttons
                HStack {
                    Button("Back") {
                        if currentStage.rawValue > 0 {
                            currentStage = CreationStage(rawValue: currentStage.rawValue - 1) ?? .nameAndChronicle
                        }
                    }
                    .disabled(currentStage == .nameAndChronicle)
                    
                    Spacer()
                    
                    if currentStage == .ambitionAndDesire {
                        Button("Create Character") {
                            // Recalculate derived values before saving
                            character.recalculateDerivedValues()
                            store.addCharacter(character)
                            dismiss()
                        }
                        .disabled(!canProceedFromCurrentStage())
                    } else {
                        Button("Next") {
                            if currentStage.rawValue < CreationStage.allCases.count - 1 {
                                currentStage = CreationStage(rawValue: currentStage.rawValue + 1) ?? .ambitionAndDesire
                            }
                        }
                        .disabled(!canProceedFromCurrentStage())
                    }
                }
                .padding()
            }
            .navigationTitle("Create Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func canProceedFromCurrentStage() -> Bool {
        switch currentStage {
        case .nameAndChronicle:
            return !character.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !character.chronicleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .clan:
            return !character.clan.isEmpty
        case .attributes:
            return AttributesStage.areAllAttributesAssigned(character: character)
        case .skills:
            return true // Skills can be left at 0
        case .disciplines:
            return true // Disciplines can be empty
        case .meritsAndFlaws:
            return true // Merits and flaws can be empty
        case .convictionsAndTouchstones:
            return true // Convictions and touchstones can be empty
        case .ambitionAndDesire:
            return true // Ambition and desire can be empty
        }
    }
}

// MARK: - Stage 1: Name and Chronicle
struct NameAndChronicleStage: View {
    @Binding var character: Character
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Character Information")) {
                TextField("Character Name", text: $character.name)
                    .focused($isNameFieldFocused)
                
                TextField("Chronicle Name", text: $character.chronicleName)
            }
            
            Section(footer: Text("Both name and chronicle are required to proceed.")) {
                EmptyView()
            }
        }
        .onAppear {
            isNameFieldFocused = true
        }
    }
}

// MARK: - Stage 2: Clan Selection
struct ClanSelectionStage: View {
    @Binding var character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Select Clan")) {
                ForEach(V5Constants.clans, id: \.self) { clan in
                    HStack {
                        Button(action: {
                            character.clan = clan
                        }) {
                            HStack {
                                Image(systemName: character.clan == clan ? "circle.fill" : "circle")
                                    .foregroundColor(character.clan == clan ? .accentColor : .secondary)
                                Text(clan)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Section(footer: Text("You must select a clan to proceed.")) {
                EmptyView()
            }
        }
    }
}

// MARK: - Stage 3: Attributes with Drag and Drop
struct AttributesStage: View {
    @Binding var character: Character
    @State private var availableValues: [(Int, UUID)] = [(4, UUID()), (3, UUID()), (3, UUID()), (3, UUID()), (2, UUID()), (2, UUID()), (2, UUID()), (2, UUID()), (1, UUID())]
    @State private var assignedValues: [String: Int] = [:]
    
    private var allAttributes: [String] {
        V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Available values section
                VStack(alignment: .leading) {
                    Text("Unassigned Values")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
                        ForEach(availableValues, id: \.1) { valueWithId in
                            DraggableValueBox(value: valueWithId.0, id: valueWithId.1)
                        }
                    }
                    .dropDestination(for: Int.self) { items, location in
                        if let draggedValue = items.first {
                            // Find the attribute that had this value and remove it
                            if let attributeWithValue = assignedValues.first(where: { $0.value == draggedValue })?.key {
                                availableValues.append((draggedValue, UUID()))
                                availableValues.sort { $0.0 > $1.0 }
                                assignedValues.removeValue(forKey: attributeWithValue)
                                
                                // Reset the character attribute to base value
                                if V5Constants.physicalAttributes.contains(attributeWithValue) {
                                    character.physicalAttributes[attributeWithValue] = 1
                                } else if V5Constants.socialAttributes.contains(attributeWithValue) {
                                    character.socialAttributes[attributeWithValue] = 1
                                } else if V5Constants.mentalAttributes.contains(attributeWithValue) {
                                    character.mentalAttributes[attributeWithValue] = 1
                                }
                                return true
                            }
                        }
                        return false
                    } isTargeted: { targeted in
                        // Add visual feedback for targeting the unassigned area
                        // This could be used to change the background color when hovering
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                // Attributes table
                VStack(alignment: .leading) {
                    Text("Attributes")
                        .font(.headline)
                    
                    // Table header
                    HStack {
                        Text("Physical")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                        
                        Text("Social")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                        
                        Text("Mental")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 10)
                    
                    // Attribute rows
                    ForEach(0..<3, id: \.self) { rowIndex in
                        HStack {
                            // Physical attribute
                            AttributeDropRow(
                                attribute: V5Constants.physicalAttributes[rowIndex],
                                assignedValues: $assignedValues,
                                availableValues: $availableValues,
                                characterAttributes: $character.physicalAttributes
                            )
                            .frame(maxWidth: .infinity)
                            
                            // Social attribute
                            AttributeDropRow(
                                attribute: V5Constants.socialAttributes[rowIndex],
                                assignedValues: $assignedValues,
                                availableValues: $availableValues,
                                characterAttributes: $character.socialAttributes
                            )
                            .frame(maxWidth: .infinity)
                            
                            // Mental attribute
                            AttributeDropRow(
                                attribute: V5Constants.mentalAttributes[rowIndex],
                                assignedValues: $assignedValues,
                                availableValues: $availableValues,
                                characterAttributes: $character.mentalAttributes
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                // Progress indicator
                VStack(alignment: .leading) {
                    Text("Progress: \(assignedValues.count) of \(allAttributes.count) attributes assigned")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Remaining values: \(availableValues.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if assignedValues.count < allAttributes.count || !availableValues.isEmpty {
                        Text("Assign all attribute values to proceed.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    } else {
                        Text("All values assigned! You can proceed to the next stage.")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            initializeAttributeValues()
        }
    }
    
    private func initializeAttributeValues() {
        // Initialize from character's current attribute values if any are not 1
        for attribute in allAttributes {
            var currentValue = 1
            if V5Constants.physicalAttributes.contains(attribute) {
                currentValue = character.physicalAttributes[attribute] ?? 1
            } else if V5Constants.socialAttributes.contains(attribute) {
                currentValue = character.socialAttributes[attribute] ?? 1
            } else if V5Constants.mentalAttributes.contains(attribute) {
                currentValue = character.mentalAttributes[attribute] ?? 1
            }
            
            if currentValue > 1 {
                assignedValues[attribute] = currentValue
                if let index = availableValues.firstIndex(where: { $0.0 == currentValue }) {
                    availableValues.remove(at: index)
                }
            }
        }
    }
    
    static func areAllAttributesAssigned(character: Character) -> Bool {
        let allAttributes = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes
        
        // Check if all attributes have values > 1 (meaning they were assigned)
        var assignedCount = 0
        for attribute in allAttributes {
            var currentValue = 1
            if V5Constants.physicalAttributes.contains(attribute) {
                currentValue = character.physicalAttributes[attribute] ?? 1
            } else if V5Constants.socialAttributes.contains(attribute) {
                currentValue = character.socialAttributes[attribute] ?? 1
            } else if V5Constants.mentalAttributes.contains(attribute) {
                currentValue = character.mentalAttributes[attribute] ?? 1
            }
            
            if currentValue > 1 {
                assignedCount += 1
            }
        }
        
        // All 9 attributes must be assigned and we must have used all 9 available values
        return assignedCount == allAttributes.count
    }
}

struct DraggableValueBox: View {
    let value: Int
    let id: UUID
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        Text("\(value)")
            .font(.title2)
            .fontWeight(.bold)
            .frame(width: 50, height: 50)
            .background(Color.blue.opacity(isDragging ? 0.6 : 0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .offset(dragOffset)
            .animation(.easeInOut(duration: 0.1), value: isDragging)
            .draggable(value) {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                        }
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        isDragging = false
                        dragOffset = .zero
                    }
            )
    }
}


struct AttributeDropRow: View {
    let attribute: String
    @Binding var assignedValues: [String: Int]
    @Binding var availableValues: [(Int, UUID)]
    @Binding var characterAttributes: [String: Int]
    @State private var isTargeted = false
    @State private var isDraggedValuePresent = false
    
    var body: some View {
        VStack {
            Text(attribute)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Drop zone - made much larger and more responsive
            ZStack {
                Rectangle()
                    .stroke(isTargeted ? Color.blue : Color.gray, lineWidth: isTargeted ? 2 : 1)
                    .frame(height: 80) // Increased from 60 to 80
                    .background(
                        Group {
                            if isTargeted {
                                Color.blue.opacity(0.3)
                            } else if assignedValues[attribute] != nil {
                                Color.green.opacity(0.2)
                            } else {
                                Color.gray.opacity(0.1)
                            }
                        }
                    )
                    .animation(.easeInOut(duration: 0.1), value: isTargeted)
                
                if let value = assignedValues[attribute] {
                    Text("\(value)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .scaleEffect(isDraggedValuePresent ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: isDraggedValuePresent)
                        .draggable(value) {
                            Text("\(value)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(width: 50, height: 50)
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    isDraggedValuePresent = true
                                }
                                .onEnded { _ in
                                    isDraggedValuePresent = false
                                }
                        )
                } else {
                    Text("—")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .dropDestination(for: Int.self) { items, location in
                if let draggedValue = items.first {
                    assignValueToAttribute(attribute: attribute, value: draggedValue)
                    return true
                }
                return false
            } isTargeted: { targeted in
                isTargeted = targeted
            }
        }
    }
    
    private func assignValueToAttribute(attribute: String, value: Int) {
        // If this attribute already has a value, return it to available values
        if let currentValue = assignedValues[attribute] {
            availableValues.append((currentValue, UUID()))
            availableValues.sort { $0.0 > $1.0 }
        }
        
        // If another attribute has this value, remove it from that attribute (no swapping)
        if let existingAttribute = assignedValues.first(where: { $0.value == value })?.key {
            assignedValues.removeValue(forKey: existingAttribute)
            characterAttributes[existingAttribute] = 1 // Reset to base value
        } else {
            // Remove from available values (if it came from unassigned pool)
            if let index = availableValues.firstIndex(where: { $0.0 == value }) {
                availableValues.remove(at: index)
            }
        }
        
        // Assign the new value
        assignedValues[attribute] = value
        characterAttributes[attribute] = value
    }
}

// MARK: - Stage 4: Skills with Presets
struct SkillsStage: View {
    @Binding var character: Character
    @State private var selectedPresetValues: [SkillPreset: [Int]] = [:]
    @State private var availablePresets: Set<SkillPreset> = [.jackOfAllTrades, .balanced, .specialist]
    
    private var allSkills: [String] {
        V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills
    }
    
    private var allSkillValues: [Int] {
        allSkills.compactMap { skill in
            if V5Constants.physicalSkills.contains(skill) {
                return character.physicalSkills[skill]
            } else if V5Constants.socialSkills.contains(skill) {
                return character.socialSkills[skill]
            } else if V5Constants.mentalSkills.contains(skill) {
                return character.mentalSkills[skill]
            }
            return 0
        }.filter { $0 > 0 }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Presets section
                VStack(alignment: .leading) {
                    Text("Skill Presets")
                        .font(.headline)
                    
                    ForEach(SkillPreset.allCases, id: \.self) { preset in
                        PresetView(
                            preset: preset,
                            selectedValues: selectedPresetValues[preset] ?? preset.values,
                            isAvailable: availablePresets.contains(preset)
                        )
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                // Skills section
                VStack(alignment: .leading) {
                    Text("Skills")
                        .font(.headline)
                    
                    VStack(spacing: 15) {
                        // Physical Skills
                        SkillCategoryView(
                            title: "Physical",
                            skills: V5Constants.physicalSkills,
                            characterSkills: $character.physicalSkills,
                            availableValues: getAvailableValuesForSelection()
                        )
                        
                        // Social Skills
                        SkillCategoryView(
                            title: "Social",
                            skills: V5Constants.socialSkills,
                            characterSkills: $character.socialSkills,
                            availableValues: getAvailableValuesForSelection()
                        )
                        
                        // Mental Skills
                        SkillCategoryView(
                            title: "Mental",
                            skills: V5Constants.mentalSkills,
                            characterSkills: $character.mentalSkills,
                            availableValues: getAvailableValuesForSelection()
                        )
                    }
                }
            }
            .padding()
        }
        .onAppear {
            initializePresetValues()
        }
        .onChange(of: allSkillValues) {
            updateAvailablePresets()
        }
    }
    
    private func initializePresetValues() {
        selectedPresetValues[.jackOfAllTrades] = SkillPreset.jackOfAllTrades.values
        selectedPresetValues[.balanced] = SkillPreset.balanced.values
        selectedPresetValues[.specialist] = SkillPreset.specialist.values
    }
    
    private func getAvailableValuesForSelection() -> [Int] {
        var availableValues: [Int] = []
        
        // Collect values from all available presets
        for preset in availablePresets {
            if let values = selectedPresetValues[preset] {
                availableValues.append(contentsOf: values)
            }
        }
        
        // Remove already used values
        let usedValues = allSkillValues
        for usedValue in usedValues {
            if let index = availableValues.firstIndex(of: usedValue) {
                availableValues.remove(at: index)
            }
        }
        
        // Always include 0 as it's unlimited
        if !availableValues.contains(0) {
            availableValues.append(0)
        }
        
        return Array(Set(availableValues)).sorted(by: >)
    }
    
    private func updateAvailablePresets() {
        availablePresets.removeAll()
        
        // Check each preset to see if current skill selection matches
        for preset in SkillPreset.allCases {
            if canUsePreset(preset) {
                availablePresets.insert(preset)
            }
        }
    }
    
    private func canUsePreset(_ preset: SkillPreset) -> Bool {
        let currentValues = allSkillValues.sorted(by: >)
        let presetValues = preset.values.sorted(by: >)
        
        // Check if current values can be achieved with this preset
        var availableValues = presetValues
        
        for value in currentValues {
            if value == 0 { continue } // 0 is always available
            if let index = availableValues.firstIndex(of: value) {
                availableValues.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
}

enum SkillPreset: CaseIterable {
    case jackOfAllTrades
    case balanced
    case specialist
    
    var name: String {
        switch self {
        case .jackOfAllTrades: return "Jack of all trades"
        case .balanced: return "Balanced"
        case .specialist: return "Specialist"
        }
    }
    
    var values: [Int] {
        switch self {
        case .jackOfAllTrades: return [3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        case .balanced: return [3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1]
        case .specialist: return [4, 3, 3, 3, 2, 2, 2, 1, 1, 1]
        }
    }
}

struct PresetView: View {
    let preset: SkillPreset
    let selectedValues: [Int]
    let isAvailable: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(preset.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isAvailable ? .primary : .gray)
            
            let groupedValues = Dictionary(grouping: selectedValues) { $0 }
                .mapValues { $0.count }
                .sorted { $0.key > $1.key }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 6), spacing: 5) {
                ForEach(groupedValues, id: \.key) { value, count in
                    HStack(spacing: 2) {
                        Text("\(count)×")
                            .font(.caption2)
                        Text("\(value)")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(4)
                    .background(isAvailable ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                    .cornerRadius(4)
                    .strikethrough(!isAvailable)
                }
            }
        }
    }
}

struct SkillCategoryView: View {
    let title: String
    let skills: [String]
    @Binding var characterSkills: [String: Int]
    let availableValues: [Int]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ForEach(skills, id: \.self) { skill in
                HStack {
                    Text(skill)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("", selection: Binding(
                        get: { characterSkills[skill] ?? 0 },
                        set: { characterSkills[skill] = $0 }
                    )) {
                        ForEach(availableValues.sorted(by: >), id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 60)
                }
            }
        }
    }
}

// MARK: - Stage 5: Disciplines
struct DisciplinesStage: View {
    @Binding var character: Character
    @State private var showingAddDiscipline = false
    
    var availableDisciplines: [String] {
        V5Constants.disciplines.filter { !character.disciplines.keys.contains($0) }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Learned Disciplines")) {
                if character.disciplines.isEmpty {
                    Text("No disciplines learned")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { discipline, level in
                        HStack {
                            Text(discipline)
                            Spacer()
                            Picker("", selection: Binding(
                                get: { character.disciplines[discipline] ?? 0 },
                                set: { newValue in
                                    if newValue == 0 {
                                        character.disciplines.removeValue(forKey: discipline)
                                    } else {
                                        character.disciplines[discipline] = newValue
                                    }
                                }
                            )) {
                                ForEach(0...5, id: \.self) { value in
                                    Text("Level \(value)").tag(value)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
                
                Button("Add Discipline") {
                    showingAddDiscipline = true
                }
                .foregroundColor(.accentColor)
            }
            
            Section(footer: Text("Disciplines are optional for character creation.")) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showingAddDiscipline) {
            CreationAddDisciplineView(character: $character)
        }
    }
}

struct CreationAddDisciplineView: View {
    @Binding var character: Character
    @Environment(\.dismiss) var dismiss
    
    var availableDisciplines: [String] {
        V5Constants.disciplines.filter { !character.disciplines.keys.contains($0) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Available Disciplines") {
                    ForEach(availableDisciplines, id: \.self) { discipline in
                        Button(discipline) {
                            character.disciplines[discipline] = 1
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add Discipline")
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

// MARK: - Stage 6: Merits and Flaws
struct MeritsAndFlawsStage: View {
    @Binding var character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Merits")) {
                if character.advantages.isEmpty {
                    Text("No merits selected")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.advantages) { merit in
                        HStack {
                            Text(merit.name)
                            Spacer()
                            Text("\(merit.cost) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button("Remove") {
                                character.advantages.removeAll { $0.id == merit.id }
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        Text("Total Cost:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(character.advantages.reduce(0) { $0 + $1.cost }) pts")
                            .fontWeight(.semibold)
                    }
                }
                
                CreationMeritsListView(selectedMerits: $character.advantages)
            }
            
            Section(header: Text("Flaws")) {
                if character.flaws.isEmpty {
                    Text("No flaws selected")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.flaws) { flaw in
                        HStack {
                            Text(flaw.name)
                            Spacer()
                            Text("\(abs(flaw.cost)) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button("Remove") {
                                character.flaws.removeAll { $0.id == flaw.id }
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        Text("Total Value:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(abs(character.flaws.reduce(0) { $0 + $1.cost })) pts")
                            .fontWeight(.semibold)
                    }
                }
                
                CreationFlawsListView(selectedFlaws: $character.flaws)
            }
            
            Section(footer: Text("Merits and flaws are optional for character creation.")) {
                EmptyView()
            }
        }
    }
}

struct CreationMeritsListView: View {
    @Binding var selectedMerits: [Advantage]
    @State private var showingAddMerit = false
    
    var body: some View {
        Button("Add Merit") {
            showingAddMerit = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddMerit) {
            AddAdvantageView(selectedAdvantages: $selectedMerits)
        }
    }
}

struct CreationFlawsListView: View {
    @Binding var selectedFlaws: [Flaw]
    @State private var showingAddFlaw = false
    
    var body: some View {
        Button("Add Flaw") {
            showingAddFlaw = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws)
        }
    }
}

// MARK: - Stage 7: Convictions and Touchstones
struct ConvictionsAndTouchstonesStage: View {
    @Binding var character: Character
    @State private var newConviction = ""
    @State private var newTouchstone = ""
    @State private var showingAddConviction = false
    @State private var showingAddTouchstone = false
    
    var body: some View {
        Form {
            Section(header: Text("Convictions")) {
                if character.convictions.isEmpty {
                    Text("No convictions defined")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.convictions.indices, id: \.self) { index in
                        HStack {
                            Text(character.convictions[index])
                            Spacer()
                            Button("Remove") {
                                character.convictions.remove(at: index)
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                }
                
                Button("Add Conviction") {
                    showingAddConviction = true
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Touchstones")) {
                if character.touchstones.isEmpty {
                    Text("No touchstones defined")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.touchstones.indices, id: \.self) { index in
                        HStack {
                            Text(character.touchstones[index])
                            Spacer()
                            Button("Remove") {
                                character.touchstones.remove(at: index)
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                }
                
                Button("Add Touchstone") {
                    showingAddTouchstone = true
                }
                .foregroundColor(.accentColor)
            }
            
            Section(footer: Text("Convictions and touchstones are optional for character creation.")) {
                EmptyView()
            }
        }
        .alert("Add Conviction", isPresented: $showingAddConviction) {
            TextField("Enter conviction", text: $newConviction)
            Button("Add") {
                if !newConviction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    character.convictions.append(newConviction.trimmingCharacters(in: .whitespacesAndNewlines))
                    newConviction = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newConviction = ""
            }
        }
        .alert("Add Touchstone", isPresented: $showingAddTouchstone) {
            TextField("Enter touchstone", text: $newTouchstone)
            Button("Add") {
                if !newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    character.touchstones.append(newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines))
                    newTouchstone = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newTouchstone = ""
            }
        }
    }
}

// MARK: - Stage 8: Ambition and Desire
struct AmbitionAndDesireStage: View {
    @Binding var character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Character Goals")) {
                VStack(alignment: .leading) {
                    Text("Ambition")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("What does your character want to achieve?", text: $character.ambition, axis: .vertical)
                        .lineLimit(3...6)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading) {
                    Text("Desire")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("What does your character crave?", text: $character.desire, axis: .vertical)
                        .lineLimit(3...6)
                }
                .padding(.vertical, 4)
            }
            
            Section(footer: Text("Ambition and desire help define your character's motivations. They are optional for character creation.")) {
                EmptyView()
            }
        }
    }
}