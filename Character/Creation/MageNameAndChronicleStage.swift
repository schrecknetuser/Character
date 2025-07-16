import SwiftUI

struct MageNameAndChronicleStage: View {
    @Binding var character: MageCharacter
    @State private var newInstrumentDescription = ""
    @State private var newInstrumentUsage = ""
    @State private var showingAddInstrument = false
    @State private var refreshID = UUID()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Name & Chronicle")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Character Name")
                            .font(.headline)
                        TextField("Enter character name", text: $character.name)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Chronicle Name")
                            .font(.headline)
                        TextField("Enter chronicle name", text: $character.chronicleName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Character Concept")
                            .font(.headline)
                        TextField("Enter character concept", text: $character.concept)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Birth")
                            .font(.headline)
                        DatePicker("Date of Birth", selection: Binding(
                            get: { character.dateOfBirth ?? Date() },
                            set: { character.dateOfBirth = $0 }
                        ), displayedComponents: .date)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Awakening")
                            .font(.headline)
                        DatePicker("Date of Awakening", selection: Binding(
                            get: { character.dateOfAwakening ?? Date() },
                            set: { character.dateOfAwakening = $0 }
                        ), displayedComponents: .date)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Paradigm")
                            .font(.headline)
                        TextField("Enter paradigm", text: $character.paradigm, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Practice")
                            .font(.headline)
                        TextField("Enter practice", text: $character.practice)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Essence")
                            .font(.headline)
                        Text(V5Constants.mageEssenceDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                        Picker("Essence", selection: $character.essence) {
                            ForEach(MageEssence.allCases, id: \.self) { essence in
                                Text(essence.displayName).tag(essence)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Text("\(character.essence.displayName): \(character.essence.description)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Resonance")
                            .font(.headline)
                        Text(V5Constants.mageResonanceDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                        Picker("Resonance", selection: $character.resonance) {
                            ForEach(MageResonance.allCases, id: \.self) { resonance in
                                Text(resonance.displayName).tag(resonance)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Text("\(character.resonance.displayName): \(character.resonance.description)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synergy")
                            .font(.headline)
                        Text(V5Constants.mageSynergyDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                        Picker("Synergy", selection: $character.synergy) {
                            ForEach(MageSynergy.allCases, id: \.self) { synergy in
                                Text(synergy.displayName).tag(synergy)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Text("\(character.synergy.displayName): \(character.synergy.description)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instruments")
                            .font(.headline)
                        
                        if character.instruments.isEmpty {
                            Text("No instruments defined")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        } else {
                            ForEach(character.instruments.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(character.instruments[index].description)
                                            .fontWeight(.medium)
                                        Spacer()
                                        Button("Remove") {
                                            character.instruments.remove(at: index)
                                            refresh()
                                        }
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    }
                                    if !character.instruments[index].usage.isEmpty {
                                        Text("Usage: \(character.instruments[index].usage)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        
                        Button("Add Instrument") {
                            showingAddInstrument = true
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                
                Spacer()
            }
            .padding()
            .alert("Add Instrument", isPresented: $showingAddInstrument) {
                TextField("Description (required)", text: $newInstrumentDescription)
                TextField("Usage (optional)", text: $newInstrumentUsage)
                Button("Add") {
                    if !newInstrumentDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let instrument = Instrument(
                            description: newInstrumentDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                            usage: newInstrumentUsage.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        character.instruments.append(instrument)
                        newInstrumentDescription = ""
                        newInstrumentUsage = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    newInstrumentDescription = ""
                    newInstrumentUsage = ""
                }
            }
            .id(refreshID)
        }
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}
