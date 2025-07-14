import SwiftUI

// V5 Discipline Powers View for a specific level
struct V5DisciplinePowersView: View {
    let level: Int
    let powers: [V5DisciplinePower]
    let selectedPowerIds: Set<UUID>
    let isEditing: Bool
    let onPowerToggle: (UUID) -> Void
    @Binding var refreshID: UUID
    
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
                        onToggle: {
                            onPowerToggle(power.id)
                        },
                        refreshID: $refreshID
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
    @Binding var refreshID: UUID
    
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

struct V5DisciplineDetailView<T: DisciplineCapable>: View {
    @Binding var character: T
    var disciplineName: String
    var isEditing: Bool
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
                    ForEach(discipline.getLevels(), id: \.self) { level in
                        PowerLevelSectionView(
                            character: $character,
                            level: level,
                            discipline: discipline,
                            isEditing: isEditing,
                            refreshID: $refreshID
                        )
                    }

                    if isEditing {
                        CustomPowerSectionView(
                            discipline: discipline,
                            selectedLevel: $selectedLevelForCustomPower,
                            showingCustomPowerCreation: $showingCustomPowerCreation
                        )
                    }
                } else {
                    Text("Discipline not found")
                        .foregroundColor(.secondary)
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
                    character: character
                )
            }
        }
    }
}


struct DisciplineHeaderSectionView: View {
    let discipline: V5Discipline

    var body: some View {
        Section {
            HStack {
                Text("Discipline Level")
                Spacer()
                Text("\(discipline.currentLevel())")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PowerLevelSectionView<T: DisciplineCapable>: View {
    @Binding var character: T
    let level: Int
    let discipline: V5Discipline
    let isEditing: Bool
    @Binding var refreshID: UUID

    var body: some View {
        Section("Level \(level) Powers") {
            V5DisciplinePowersView(
                level: level,
                powers: discipline.getPowers(for: level),
                selectedPowerIds: discipline.getSelectedPowers(for: level),
                isEditing: isEditing,
                onPowerToggle: { powerId in
                    character.toggleV5Power(powerId, for: discipline.name, at: level)
                    refreshID = UUID()
                },
                refreshID: $refreshID,
            )
        }
    }
}

struct CustomPowerSectionView: View {
    let discipline: V5Discipline
    @Binding var selectedLevel: Int
    @Binding var showingCustomPowerCreation: Bool

    var body: some View {
        Section("Custom Powers") {

            Picker("Level for Custom Power", selection: $selectedLevel) {
                ForEach(1...V5Discipline.theoreticalMaxLevel, id: \.self) { level in
                    Text("Level \(level)").tag(level)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Button("Add Custom Power to Level \(selectedLevel)") {
                showingCustomPowerCreation = true
            }
            .foregroundColor(.accentColor)

        }
    }
}

struct AvailableDisciplinesSection: View {
    let disciplines: [V5Discipline]
    let onAdd: (V5Discipline) -> Void

    var body: some View {
        Section("Available V5 Disciplines") {
            ForEach(disciplines) { discipline in
                TabDisciplineRow(discipline: discipline, onAdd: onAdd)
            }
        }
    }
}

struct TabDisciplineRow: View {
    let discipline: V5Discipline
    let onAdd: (V5Discipline) -> Void

    var body: some View {
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
                    onAdd(discipline)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }

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





// V5 Add Discipline View
struct V5AddDisciplineView<T: DisciplineCapable>: View {
    @Binding var character: T
    @Environment(\.dismiss) var dismiss
    @State private var showingCustomDisciplineCreation = false

    private var availableDisciplines: [V5Discipline] {
        let existingNames = Set(character.v5Disciplines.map(\.name))
        return character.getAllAvailableV5Disciplines()
            .filter { !existingNames.contains($0.name) }
    }

    var body: some View {
        NavigationView {
            Form {
                AvailableDisciplinesSection(
                    disciplines: availableDisciplines,
                    onAdd: { discipline in
                        character.v5Disciplines.append(discipline)
                        dismiss()
                    }
                )

                Section {
                    Button("Create Custom Discipline") {
                        showingCustomDisciplineCreation = true
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
            .sheet(isPresented: $showingCustomDisciplineCreation) {
                CustomDisciplineCreationView(character: character)
            }
        }
    }
}


struct V5DisciplineRowView<T: DisciplineCapable>: View {
    @Binding var character: T
    let discipline: V5Discipline
    let isEditing: Bool
    @Binding var selectedDiscipline: V5Discipline?
    @Binding var showingDisciplineDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(discipline.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                
                
                Text("Level \(discipline.currentLevel())")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                if isEditing {
                    Button(action: {
                        character.v5Disciplines.removeAll { $0.id == discipline.id }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.borderless)
                }
                
                Button(action: {
                    selectedDiscipline = discipline
                    showingDisciplineDetail = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.accentColor)
                }
            }
            
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
    
    private func getAllSelectedPowers(for discipline: V5Discipline) -> [V5DisciplinePower] {
        var allPowers: [V5DisciplinePower] = []
        for level in discipline.getLevels() {
            let selectedIds = discipline.getSelectedPowers(for: level)
            let levelPowers = discipline.getPowers(for: level)
            let selectedPowers = levelPowers.filter { selectedIds.contains($0.id) }
            allPowers.append(contentsOf: selectedPowers)
        }
        return allPowers.sorted { $0.level < $1.level }
    }
}

// V5 Disciplines Tab
struct V5DisciplinesTab<T: DisciplineCapable>: View {
    @Binding var character: T
    @Binding var isEditing: Bool
    @State private var showingAddDiscipline = false
    @State private var selectedDiscipline: V5Discipline?
    @State private var showingDisciplineDetail = false
    
    var body: some View {
        Form {
            
            // V5 Disciplines section
            Section(header: Text("V5 Disciplines")) {
                if character.v5Disciplines.isEmpty {
                    Text("No V5 disciplines learned")
                        .foregroundColor(.secondary)
                } else {
                    let sortedDisciplines: [V5Discipline] = character.v5Disciplines.sorted(by: { $0.name < $1.name })
                    
                    ForEach(sortedDisciplines) { discipline in
                        V5DisciplineRowView(
                            character: $character,
                            discipline: discipline,
                            isEditing: isEditing,
                            selectedDiscipline: $selectedDiscipline,
                            showingDisciplineDetail: $showingDisciplineDetail
                        )
                    }
                    .onDelete(perform: isEditing ? deleteDisciplines : nil)
                }
                
                if isEditing {
                    Button("Add V5 Discipline") {
                        showingAddDiscipline = true
                    }
                    .foregroundColor(.accentColor)
                }
            }
                        
        }
        .sheet(isPresented: $showingAddDiscipline) {
            V5AddDisciplineView(character: $character)
        }
        .sheet(isPresented: $showingDisciplineDetail) {
            if let selected = selectedDiscipline {
                V5DisciplineDetailView(
                    character: $character,
                    disciplineName: selected.name,
                    isEditing: isEditing
                )
            }
        }
    }
    
    // Helper function to get all selected powers for a discipline
    private func getAllSelectedPowers(for discipline: V5Discipline) -> [V5DisciplinePower] {
        var allPowers: [V5DisciplinePower] = []
        for level in 1...discipline.currentLevel() {
            let selectedIds = discipline.getSelectedPowers(for: level)
            let levelPowers = discipline.getPowers(for: level)
            let selectedPowers = levelPowers.filter { selectedIds.contains($0.id) }
            allPowers.append(contentsOf: selectedPowers)
        }
        
        return allPowers.sorted { $0.level < $1.level }
    }
    
    private func deleteDisciplines(at offsets: IndexSet) {
        let sortedDisciplines = character.v5Disciplines.sorted(by: { $0.name < $1.name })
        for index in offsets {
            let disciplineToDelete = sortedDisciplines[index]
            character.v5Disciplines.removeAll { $0.id == disciplineToDelete.id }
        }
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
