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
                    HStack(alignment: .top) {
                        if isEditing {
                            Button(action: { onPowerToggle(power.id) }) {
                                Image(systemName: selectedPowerIds.contains(power.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedPowerIds.contains(power.id) ? .accentColor : .secondary)
                            }
                        } else {
                            if selectedPowerIds.contains(power.id) {
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
                }
            }
        }
    }
}

// V5 Discipline Detail View
struct V5DisciplineDetailView: View {
    @Binding var character: VampireCharacter
    let disciplineName: String
    @Binding var isEditing: Bool
    @Environment(\.dismiss) var dismiss
    
    private var discipline: V5Discipline? {
        character.getV5Discipline(named: disciplineName)
    }
    
    private var progress: V5DisciplineProgress? {
        character.getV5DisciplineProgress(for: disciplineName)
    }
    
    var body: some View {
        NavigationView {
            Form {
                if let discipline = discipline, let progress = progress {
                    // Level selector
                    if isEditing {
                        Section("Discipline Level") {
                            Picker("Level", selection: Binding(
                                get: { progress.currentLevel },
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
                                Text("\(progress.currentLevel)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Powers for each level
                    ForEach(1...progress.currentLevel, id: \.self) { level in
                        Section("Level \(level) Powers") {
                            V5DisciplinePowersView(
                                disciplineName: disciplineName,
                                level: level,
                                powers: discipline.getPowers(for: level),
                                selectedPowerIds: progress.getSelectedPowers(for: level),
                                isEditing: isEditing,
                                onPowerToggle: { powerId in
                                    character.toggleV5Power(powerId, for: disciplineName, at: level)
                                }
                            )
                        }
                    }
                    
                    // Add custom power section if editing
                    if isEditing {
                        Section("Custom Powers") {
                            Button("Add Custom Power") {
                                // TODO: Implement add custom power functionality
                                // This would open CustomPowerCreationView
                            }
                            .foregroundColor(.accentColor)
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
        }
    }
}

// V5 Add Discipline View
struct V5AddDisciplineView: View {
    @Binding var character: VampireCharacter
    @Environment(\.dismiss) var dismiss
    
    private var availableDisciplines: [V5Discipline] {
        let existingNames = Set(character.v5Disciplines.keys)
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
struct V5DisciplinesTab: View {
    @Binding var character: VampireCharacter
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
                    ForEach(character.v5Disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { disciplineName, progress in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(disciplineName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                
                                if isEditing {
                                    Picker("", selection: Binding(
                                        get: { progress.currentLevel },
                                        set: { newLevel in
                                            if newLevel == 0 {
                                                character.removeV5Discipline(disciplineName)
                                            } else {
                                                character.setV5DisciplineLevel(disciplineName, to: newLevel)
                                            }
                                        }
                                    )) {
                                        ForEach(0...5, id: \.self) { level in
                                            Text("Level \(level)").tag(level)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                } else {
                                    Text("Level \(progress.currentLevel)")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                
                                Button(action: {
                                    selectedDiscipline = disciplineName
                                    showingDisciplineDetail = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            
                            // Show selected powers count
                            let totalSelectedPowers = (1...progress.currentLevel).reduce(0) { total, level in
                                total + progress.getSelectedPowers(for: level).count
                            }
                            
                            if totalSelectedPowers > 0 {
                                Text("\(totalSelectedPowers) powers selected")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
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
            EnhancedV5AddDisciplineView(character: $character)
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
}