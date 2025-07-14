import SwiftUI

// Custom Discipline Creation View
struct CustomDisciplineCreationView<T: DisciplineCapable>: View {
    @ObservedObject var character: T
    @Environment(\.dismiss) var dismiss
    
    @State private var disciplineName: String = ""
    @State private var disciplineDescription: String = ""
    @State private var powers: [Int: [V5DisciplinePower]] = [:]
    @State private var currentLevel: Int = 1
    @State private var showingAddPowerAlert = false
    @State private var newPowerName: String = ""
    @State private var newPowerDescription: String = ""
    @State private var showDeleteConfirmation = false
    @State private var powerToDelete: V5DisciplinePower?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Discipline Information") {
                    TextField("Discipline Name", text: $disciplineName)
                    TextField("Description (Optional)", text: $disciplineDescription, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section("Powers by Level") {
                    Picker("Level", selection: $currentLevel) {
                        ForEach(1...5, id: \.self) { level in
                            Text("Level \(level)").tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    let currentPowers = powers[currentLevel] ?? []
                    
                    if currentPowers.isEmpty {
                        Text("No powers defined for level \(currentLevel)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(currentPowers) { power in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(power.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Button("Remove") {
                                        showDeleteConfirmation = true
                                        powerToDelete = power
                                    }
                                    .foregroundColor(.red)
                                    .font(.caption)
                                }
                                
                                Text(power.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    
                    Button("Add Power to Level \(currentLevel)") {
                        showingAddPowerAlert = true
                    }
                    .foregroundColor(.accentColor)
                }
                
                Section("Preview") {
                    if !disciplineName.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(disciplineName)
                                .font(.headline)
                            
                            if !disciplineDescription.isEmpty {
                                Text(disciplineDescription)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ForEach(1...5, id: \.self) { level in
                                let levelPowers = powers[level] ?? []
                                if !levelPowers.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Level \(level) (\(levelPowers.count) powers)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                        
                                        ForEach(levelPowers) { power in
                                            Text("• \(power.name)")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.leading, 8)
                                }
                            }
                        }
                    } else {
                        Text("Enter a discipline name to see preview")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Create Custom Discipline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createDiscipline()
                    }
                    .disabled(disciplineName.isEmpty || powers.isEmpty)
                }
            }
            .alert("Add Power", isPresented: $showingAddPowerAlert) {
                TextField("Power Name", text: $newPowerName)
                TextField("Power Description", text: $newPowerDescription)
                Button("Add") {
                    addPower()
                }
                .disabled(newPowerName.isEmpty)
                Button("Cancel", role: .cancel) {
                    newPowerName = ""
                    newPowerDescription = ""
                }
            } message: {
                Text("Create a new power for level \(currentLevel)")
            }
            .alert("Delete Power", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let power = powerToDelete {
                        removePower(power)
                    }
                    powerToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    powerToDelete = nil
                }
            } message: {
                if let power = powerToDelete {
                    Text("Are you sure you want to delete '\(power.name)'? This action cannot be undone.")
                }
            }
        }
    }
    
    private func addPower() {
        let power = V5DisciplinePower(
            name: newPowerName,
            description: newPowerDescription.isEmpty ? "Custom power" : newPowerDescription,
            level: currentLevel,
            isCustom: true
        )
        
        if powers[currentLevel] == nil {
            powers[currentLevel] = []
        }
        powers[currentLevel]?.append(power)
        
        newPowerName = ""
        newPowerDescription = ""
    }
    
    private func removePower(_ power: V5DisciplinePower) {
        powers[currentLevel]?.removeAll { $0.id == power.id }
        if powers[currentLevel]?.isEmpty == true {
            powers.removeValue(forKey: currentLevel)
        }
    }
    
    private func createDiscipline() {
        let discipline = V5Discipline(
            name: disciplineName,
            powers: powers,
            isCustom: true
        )
        
        character.addCustomV5Discipline(discipline)
        dismiss()
    }
}

// Custom Power Creation View (for existing disciplines)
struct CustomPowerCreationView<T: DisciplineCapable>: View {
    let disciplineName: String
    @ObservedObject var character: T
    @Environment(\.dismiss) var dismiss
    
    @State private var powerName: String = ""
    @State private var powerDescription: String = ""
    @State private var selectedLevel: Int = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section("Power Information") {
                    TextField("Power Name", text: $powerName)
                    TextField("Power Description", text: $powerDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Details") {
                    HStack {
                        Text("Discipline")
                        Spacer()
                        Text(disciplineName)
                            .foregroundColor(.secondary)
                    }
                    
                    Picker("Level", selection: $selectedLevel) {
                        ForEach(1...V5Discipline.theoreticalMaxLevel, id: \.self) { level in
                            Text("Level \(level)").tag(level)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    HStack {
                        Text("Type")
                        Spacer()
                        Text("Custom")
                            .foregroundColor(.orange)
                    }
                }
                
                if !powerName.isEmpty {
                    Section("Preview") {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(powerName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("Custom")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.orange.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(4)
                            }
                            
                            Text(powerDescription.isEmpty ? "Custom power for \(disciplineName)" : powerDescription)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Create Custom Power")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createPower()
                    }
                    .disabled(powerName.isEmpty)
                }
            }
        }
    }
    
    private func createPower() {
        let power = V5DisciplinePower(
            name: powerName,
            description: powerDescription.isEmpty ? "Custom power for \(disciplineName)" : powerDescription,
            level: selectedLevel,
            isCustom: true
        )
        
        // Find the discipline in the character's list and add the power
        if let disciplineIndex = character.v5Disciplines.firstIndex(where: { $0.name == disciplineName }) {
            character.v5Disciplines[disciplineIndex].addPower(power, level: selectedLevel)
        } else {
            // Create a new discipline instance from standard template if it exists
            if let standardDiscipline = V5Constants.getV5Discipline(named: disciplineName) {
                var newDiscipline = standardDiscipline
                newDiscipline.addPower(power, level: selectedLevel)
                character.v5Disciplines.append(newDiscipline)
            }
        }
        
        dismiss()
    }
}

// Enhanced V5 Add Discipline View with Custom Creation
/*struct EnhancedV5AddDisciplineView: View {
    @Binding var character: VampireCharacter
    @Environment(\.dismiss) var dismiss
    @State private var showingCustomCreation = false
    
    private var availableDisciplines: [V5Discipline] {
        let existingNames = Set(character.v5Disciplines.map(\.name))
        return character.getAllAvailableV5Disciplines().filter { !existingNames.contains($0.name) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Standard V5 Disciplines") {
                    ForEach(availableDisciplines.filter { !$0.isCustom }) { discipline in
                        DisciplineRow(discipline: discipline) {
                            character.setV5DisciplineLevel(discipline.name, to: 1)
                            dismiss()
                        }
                    }
                }
                
                if !availableDisciplines.filter({ $0.isCustom }).isEmpty {
                    Section("Custom Disciplines") {
                        ForEach(availableDisciplines.filter { $0.isCustom }) { discipline in
                            DisciplineRow(discipline: discipline) {
                                character.setV5DisciplineLevel(discipline.name, to: 1)
                                dismiss()
                            }
                        }
                    }
                }
                
                Section {
                    Button("Create Custom Discipline") {
                        showingCustomCreation = true
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
            .sheet(isPresented: $showingCustomCreation) {
                CustomDisciplineCreationView(character: $character)
            }
        }
    }
}*/

// Helper view for discipline rows
struct DisciplineRow: View {
    let discipline: V5Discipline
    let onAdd: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
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
                    onAdd()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            
            // Show level 1 powers preview
            let level1Powers = discipline.getPowers(for: 1)
            if !level1Powers.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level 1 Powers:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(level1Powers.prefix(3)) { power in
                        HStack {
                            Text("• \(power.name)")
                                .font(.caption)
                                .fontWeight(.medium)
                            if power.isCustom {
                                Text("Custom")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    if level1Powers.count > 3 {
                        Text("• ... and \(level1Powers.count - 3) more")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, 8)
            }
        }
        .padding(.vertical, 4)
    }
}
