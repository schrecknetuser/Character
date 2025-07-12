import SwiftUI

struct DisciplinesStage: View {
    @ObservedObject var character: Vampire
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
            CreationAddDisciplineView(character: character)
        }
    }
}

struct CreationAddDisciplineView: View {
    @ObservedObject var character: Vampire
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
