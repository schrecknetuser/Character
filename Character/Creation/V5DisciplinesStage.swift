import SwiftUI

// V5 Disciplines Creation Stage
struct V5DisciplinesStage<T: DisciplineCapable>: View {
    @ObservedObject var character: T
    @State private var showingAddDiscipline = false
    @State private var selectedDiscipline: String?
    @State private var showingDisciplineDetail = false
    
    var body: some View {
        Form {
            Section(header: Text("V5 Disciplines")) {
                if character.v5Disciplines.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No disciplines selected")
                            .foregroundColor(.secondary)
                        
                        Text("Disciplines grant supernatural powers to your vampire. Each discipline has multiple powers per level that you can choose from.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ForEach(character.v5Disciplines.sorted(by: { $0.name < $1.name })) { discipline in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(discipline.name)
                                    .font(.headline)
                                Spacer()
                                
                                Picker("Level", selection: Binding(
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
                                
                                Button("Powers") {
                                    selectedDiscipline = discipline.name
                                    showingDisciplineDetail = true
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                            
                            // Show progress summary
                            if discipline.currentLevel > 0 {
                                HStack {
                                    ForEach(1...discipline.currentLevel, id: \.self) { level in
                                        let selectedCount = discipline.getSelectedPowers(for: level).count
                                        let totalCount = discipline.getPowers(for: level).count
                                        
                                        VStack(spacing: 2) {
                                            Text("L\(level)")
                                                .font(.caption2)
                                                .fontWeight(.medium)
                                            Text("\(selectedCount)/\(totalCount)")
                                                .font(.caption2)
                                                .foregroundColor(selectedCount > 0 ? .accentColor : .secondary)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(selectedCount > 0 ? Color.accentColor.opacity(0.1) : Color.secondary.opacity(0.1))
                                        .cornerRadius(4)
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Button("Add Discipline") {
                    showingAddDiscipline = true
                }
                .foregroundColor(.accentColor)
            }
            
            Section(footer: Text("Disciplines are optional for character creation. You can add and modify them later. Select multiple powers per level as desired.")) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showingAddDiscipline) {
            EnhancedV5CreationAddDisciplineView(character: character)
        }
        .sheet(isPresented: $showingDisciplineDetail) {
            if let disciplineName = selectedDiscipline {
                V5CreationDisciplineDetailView(
                    character: character,
                    disciplineName: disciplineName
                )
            }
        }
    }
}

// V5 Add Discipline View for Character Creation
struct V5CreationAddDisciplineView<T: DisciplineCapable>: View {
    @ObservedObject var character: T
    @Environment(\.dismiss) var dismiss
    
    private var availableDisciplines: [V5Discipline] {
        let existingNames = Set(character.v5Disciplines.map(\.name))
        return character.getAllAvailableV5Disciplines().filter { !existingNames.contains($0.name) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Available Disciplines") {
                    ForEach(availableDisciplines) { discipline in
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
                            }
                            
                            // Show level 1 powers
                            let level1Powers = discipline.getPowers(for: 1)
                            if !level1Powers.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Level 1 Powers:")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                    
                                    ForEach(level1Powers) { power in
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("• \(power.name)")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                            Text(power.description)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.leading, 8)
                            }
                            
                            Button("Add \(discipline.name)") {
                                character.setV5DisciplineLevel(discipline.name, to: 1)
                                dismiss()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                        .padding(.vertical, 8)
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

// V5 Discipline Detail View for Character Creation
struct V5CreationDisciplineDetailView<T: DisciplineCapable>: View {
    @ObservedObject var character: T
    let disciplineName: String
    @Environment(\.dismiss) var dismiss
    
    private var discipline: V5Discipline? {
        character.v5Disciplines.first { $0.name == disciplineName }
    }
    
    var body: some View {
        NavigationView {
            Form {
                if let discipline = discipline {
                    // Level selector
                    Section("Discipline Level") {
                        Picker("Level", selection: Binding(
                            get: { discipline.currentLevel },
                            set: { newLevel in
                                character.setV5DisciplineLevel(disciplineName, to: newLevel)
                            }
                        )) {
                            ForEach(1...5, id: \.self) { level in
                                Text("Level \(level)").tag(level)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Powers for each level
                    ForEach(1...discipline.currentLevel, id: \.self) { level in
                        Section("Level \(level) Powers") {
                            let powers = discipline.getPowers(for: level)
                            let selectedIds = discipline.getSelectedPowers(for: level)
                            
                            if powers.isEmpty {
                                Text("No powers available at this level")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Select powers you want to learn:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    ForEach(powers) { power in
                                        Button(action: {
                                            character.toggleV5Power(power.id, for: disciplineName, at: level)
                                        }) {
                                            HStack(alignment: .top, spacing: 12) {
                                                Image(systemName: selectedIds.contains(power.id) ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(selectedIds.contains(power.id) ? .accentColor : .secondary)
                                                
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(power.name)
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.primary)
                                                    
                                                    Text(power.description)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                        .multilineTextAlignment(.leading)
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
                                        .buttonStyle(PlainButtonStyle())
                                        .padding(.vertical, 4)
                                    }
                                }
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
        }
    }
}

// Enhanced V5 Add Discipline View for Character Creation
struct EnhancedV5CreationAddDisciplineView<T: DisciplineCapable>: View {
    @ObservedObject var character: T
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
                        CreationDisciplineRow(discipline: discipline) {
                            character.setV5DisciplineLevel(discipline.name, to: 1)
                            dismiss()
                        }
                    }
                }
                
                if !availableDisciplines.filter({ $0.isCustom }).isEmpty {
                    Section("Custom Disciplines") {
                        ForEach(availableDisciplines.filter { $0.isCustom }) { discipline in
                            CreationDisciplineRow(discipline: discipline) {
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
                CustomDisciplineCreationView(character: character)
            }
        }
    }
}

// Helper view for discipline rows in creation
struct CreationDisciplineRow: View {
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
            }
            
            // Show level 1 powers
            let level1Powers = discipline.getPowers(for: 1)
            if !level1Powers.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level 1 Powers:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    ForEach(level1Powers) { power in
                        VStack(alignment: .leading, spacing: 2) {
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
                            Text(power.description)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.leading, 8)
            }
            
            Button("Add \(discipline.name)") {
                onAdd()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(.vertical, 8)
    }
}