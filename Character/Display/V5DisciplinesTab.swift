import SwiftUI

// V5 Discipline Powers View for a specific level
struct V5DisciplinePowersView: View {
    let disciplineName: String
    let level: Int
    let powers: [V5DisciplinePower]
    let selectedPowerIds: Set<UUID>
    let isEditing: Bool
    let onPowerToggle: (UUID) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if powers.isEmpty {
                Text("No powers available at level \(level)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            } else {
                ForEach(powers) { power in
                    V5PowerRowView(
                        power: power,
                        isSelected: selectedPowerIds.contains(power.id),
                        isEditing: isEditing,
                        onToggle: { onPowerToggle(power.id) }
                    )
                }
            }
        }
    }
}

// Enhanced power row view with tap and hold gesture for descriptions
struct V5PowerRowView: View {
    let power: V5DisciplinePower
    let isSelected: Bool
    let isEditing: Bool
    let onToggle: () -> Void
    @State private var showingDescription = false
    
    var body: some View {
        HStack(alignment: .top) {
            if isEditing {
                Button(action: onToggle) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
                .buttonStyle(.borderless)
            } else {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(power.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(power.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .onLongPressGesture {
                showingDescription = true
            }
            
            Spacer()
            
            if power.isCustom {
                Text("Custom")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(4)
            }
        }
        .alert(power.name, isPresented: $showingDescription) {
            Button("OK") { }
        } message: {
            Text(power.description)
        }
    }
}

// V5 Discipline Detail View
struct V5DisciplineDetailView<T: DisciplineCapable>: View {
    @Binding var character: T
    let disciplineName: String
    @Binding var isEditing: Bool
    @Environment(\.dismiss) var dismiss
    @State var refreshID: UUID = UUID()
    @State private var showingCustomPowerCreation = false
    @State private var selectedLevelForCustomPower = 1
    
    private var discipline: V5Discipline? {
        character.v5Disciplines.first { $0.name == disciplineName }
    }
    
    var body: some View {
        NavigationView {
            Form {
                if let discipline = discipline {
                    // Level selector
                    if isEditing {
                        Section("Discipline Level") {
                            Picker("Level", selection: Binding(
                                get: { discipline.currentLevel },
                                set: { newLevel in
                                    character.setV5DisciplineLevel(disciplineName, to: newLevel)
                                }
                            )) {
                                ForEach(0...5, id: \.self) { level in
                                    Text("Level \(level)").tag(level)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    } else {
                        Section {
                            HStack {
                                Text("Discipline Level")
                                Spacer()
                                Text("\(discipline.currentLevel)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Powers for each level
                    ForEach(1...discipline.currentLevel, id: \.self) { level in
                        Section("Level \(level) Powers") {
                            V5DisciplinePowersView(
                                disciplineName: disciplineName,
                                level: level,
                                powers: discipline.getPowers(for: level),
                                selectedPowerIds: discipline.getSelectedPowers(for: level),
                                isEditing: isEditing,
                                onPowerToggle: { powerId in
                                    character.toggleV5Power(powerId, for: disciplineName, at: level)
                                    refreshID = UUID()
                                }
                            )
                        }
                    }
                    
                    // Add custom power section if editing
                    if isEditing {
                        Section("Custom Powers") {
                            if discipline.currentLevel > 0 {
                                Picker("Level for Custom Power", selection: $selectedLevelForCustomPower) {
                                    ForEach(1...discipline.currentLevel, id: \.self) { level in
                                        Text("Level \(level)").tag(level)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                Button("Add Custom Power to Level \(selectedLevelForCustomPower)") {
                                    showingCustomPowerCreation = true
                                }
                                .foregroundColor(.accentColor)
                            } else {
                                Text("Increase discipline level to add custom powers")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                } else {
                    Section {
                        Text("Discipline not found")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(disciplineName)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingCustomPowerCreation) {
                CustomPowerCreationView(
                    disciplineName: disciplineName,
                    level: selectedLevelForCustomPower,
                    character: character
                )
            }
            .onAppear {
                // Set default level for custom power creation
                if let discipline = discipline, discipline.currentLevel > 0 {
                    selectedLevelForCustomPower = discipline.currentLevel
                }
            }
        }
    }
}

// V5 Add Discipline View
struct V5AddDisciplineView<T: DisciplineCapable>: View {
    @Binding var character: T
    @Environment(\.dismiss) var dismiss
    
    private var availableDisciplines: [V5Discipline] {
        let existingNames = Set(character.v5Disciplines.map(\.name))
        return character.getAllAvailableV5Disciplines().filter { !existingNames.contains($0.name) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Available V5 Disciplines") {
                    ForEach(availableDisciplines) { discipline in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(discipline.name)
                                    .font(.headline)
                                Spacer()
                                if discipline.isCustom {
                                    Text("Custom")
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.2))
                                        .foregroundColor(.orange)
                                        .cornerRadius(4)
                                }
                                Button("Add") {
                                    character.setV5DisciplineLevel(discipline.name, to: 1)
                                    dismiss()
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
                            }
                            
                            // Show level 1 powers preview
                            let level1Powers = discipline.getPowers(for: 1)
                            if !level1Powers.isEmpty {
                                Text("Level 1 Powers: \(level1Powers.map { $0.name }.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section {
                    Button("Create Custom Discipline") {
                        // TODO: Implement custom discipline creation
                    }
                    .foregroundColor(.accentColor)
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

// V5 Disciplines Tab
struct V5DisciplinesTab<T: DisciplineCapable>: View {
    @Binding var character: T
    @Binding var isEditing: Bool
    @State private var showingAddDiscipline = false
    @State private var selectedDiscipline: String?
    @State private var showingDisciplineDetail = false
    @State private var showingMigrationAlert = false
    
    var body: some View {
        Form {
            // Migration section for legacy disciplines
            if !character.disciplines.isEmpty && character.v5Disciplines.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.blue)
                            Text("Upgrade to V5 Disciplines")
                                .font(.headline)
                        }
                        
                        Text("You have legacy disciplines. Upgrade to V5 format to access individual powers and enhanced features.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Upgrade Now") {
                            character.migrateLegacyDisciplinesToV5()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // V5 Disciplines section
            Section(header: Text("V5 Disciplines")) {
                if character.v5Disciplines.isEmpty {
                    Text("No V5 disciplines learned")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.v5Disciplines.sorted(by: { $0.name < $1.name })) { discipline in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(discipline.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                
                                if isEditing {
                                    Picker("", selection: Binding(
                                        get: { discipline.currentLevel },
                                        set: { newLevel in
                                            if newLevel == 0 {
                                                character.removeV5Discipline(discipline.name)
                                            } else {
                                                character.setV5DisciplineLevel(discipline.name, to: newLevel)
                                            }
                                        }
                                    )) {
                                        ForEach(0...5, id: \.self) { level in
                                            Text("Level \(level)").tag(level)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                } else {
                                    Text("Level \(discipline.currentLevel)")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                
                                Button(action: {
                                    selectedDiscipline = discipline.name
                                    showingDisciplineDetail = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            
                            // Show selected powers as a list
                            let allSelectedPowers = getAllSelectedPowers(for: discipline)
                            if !allSelectedPowers.isEmpty {
                                ForEach(allSelectedPowers, id: \.id) { power in
                                    PowerRowView(power: power)
                                        .padding(.leading, 8)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                if isEditing {
                    Button("Add V5 Discipline") {
                        showingAddDiscipline = true
                    }
                    .foregroundColor(.accentColor)
                }
            }
            
            // Legacy disciplines section (if any remain)
            if !character.disciplines.isEmpty {
                Section(header: Text("Legacy Disciplines")) {
                    ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { discipline, level in
                        HStack {
                            Text(discipline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Level \(level)")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddDiscipline) {
            V5AddDisciplineView(character: $character)
        }
        .sheet(isPresented: $showingDisciplineDetail) {
            if let disciplineName = selectedDiscipline {
                V5DisciplineDetailView(
                    character: $character,
                    disciplineName: disciplineName,
                    isEditing: $isEditing
                )
            }
        }
    }
    
    // Helper function to get all selected powers for a discipline
    private func getAllSelectedPowers(for discipline: V5Discipline) -> [V5DisciplinePower] {
        var allPowers: [V5DisciplinePower] = []
        for level in 1...discipline.currentLevel {
            let selectedIds = discipline.getSelectedPowers(for: level)
            let levelPowers = discipline.getPowers(for: level)
            let selectedPowers = levelPowers.filter { selectedIds.contains($0.id) }
            allPowers.append(contentsOf: selectedPowers)
        }
        
        return allPowers.sorted { $0.level < $1.level }
    }
}

// Power row view with tap and hold gesture for description popup
struct PowerRowView: View {
    let power: V5DisciplinePower
    @State private var showingDescription = false
    
    var body: some View {
        HStack {
            Text("• \(power.name)")
                .font(.caption)
                .fontWeight(.medium)
            
            Text("(Level \(power.level))")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if power.isCustom {
                Text("Custom")
                    .font(.caption2)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(3)
            }
        }
        .contentShape(Rectangle())
        .onLongPressGesture {
            showingDescription = true
        }
        .alert(power.name, isPresented: $showingDescription) {
            Button("OK") { }
        } message: {
            Text(power.description)
        }
    }
}
