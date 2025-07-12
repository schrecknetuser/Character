import SwiftUI


// Add Discipline View
struct AddDisciplineView: View {
    @Binding var character: Vampire
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


struct DisciplinesTab: View {
    @Binding var character: Vampire
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var showingAddDiscipline = false
    @State private var refreshID: UUID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Disciplines")) {
                    if character.disciplines.isEmpty {
                        Text("No disciplines learned")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { discipline, level in
                            HStack {
                                Text(discipline)
                                    .font(.system(size: dynamicFontSize))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                if isEditing {
                                    Picker("", selection: Binding(
                                        get: { character.disciplines[discipline] ?? 0 },
                                        set: { newValue in
                                            if newValue == 0 {
                                                character.disciplines.removeValue(forKey: discipline)
                                            } else {
                                                character.disciplines[discipline] = newValue
                                            }
                                            refreshID = UUID()
                                        }
                                    )) {
                                        ForEach(0...5, id: \.self) { value in
                                            Text("Level \(value)").tag(value)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                } else {
                                    Text("Level \(level)")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize * 0.8))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                            }
                        }
                    }
                    
                    if isEditing {
                        Button("Add Discipline") {
                            showingAddDiscipline = true
                        }
                        .foregroundColor(.accentColor)
                    }
                }
            }
            .onAppear {
                calculateOptimalFontSize(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSize(for: newSize)
            }
            .sheet(isPresented: $showingAddDiscipline) {
                AddDisciplineView(character: $character)
            }
        }
    }
    
    private func calculateOptimalFontSize(for size: CGSize) {
        // Calculate based on screen width with more conservative scaling
        let baseSize: CGFloat = 16
        let minSize: CGFloat = 11
        let maxSize: CGFloat = 18
        
        // Scale font size based on available width
        let scaleFactor = min(1.2, size.width / 375) // iPhone standard width, cap at 1.2x
        let calculatedSize = baseSize * scaleFactor
        
        dynamicFontSize = max(minSize, min(maxSize, calculatedSize))
    }
}
