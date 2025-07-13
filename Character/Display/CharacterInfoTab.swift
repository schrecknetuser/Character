import SwiftUI


struct CharacterInfoTab: View {
    @Binding var character: any BaseCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var newConviction: String = ""
    @State private var newTouchstone: String = ""
    @State private var newInstrumentDescription: String = ""
    @State private var newInstrumentUsage: String = ""
    @State private var refreshID: UUID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Basic Information")) {
                    HStack {
                        Text("Name:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Name", text: $character.name)
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                        } else {
                            Text(character.name)
                                .font(.system(size: dynamicFontSize))
                        }
                    }
                    
                    HStack {
                        Text("Character Type:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        Text(character.characterType.displayName)
                            .font(.system(size: dynamicFontSize))
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Concept:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Concept", text: $character.concept)
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                        } else {
                            if !character.concept.isEmpty {
                                Text(character.concept)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    
                    HStack {
                        Text("Chronicle:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Chronicle Name", text: $character.chronicleName)
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                        } else {
                            if !character.chronicleName.isEmpty {
                                Text(character.chronicleName)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                }
                
                Section(header: Text("Character Background")) {
                    HStack {
                        Text("Ambition:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Ambition", text: $character.ambition)
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                        } else {
                            if !character.ambition.isEmpty {
                                Text(character.ambition)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    HStack {
                        Text("Desire:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Desire", text: $character.desire)
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                        } else {
                            if !character.desire.isEmpty {
                                Text(character.desire)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                }
                
                // Add mage-specific fields
                if let mageCharacter = character as? MageCharacter {
                    Section(header: Text("Mage Information")) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Paradigm:")
                                    .fontWeight(.medium)
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                            }
                            if isEditing {
                                TextField("Paradigm", text: Binding(
                                    get: { mageCharacter.paradigm },
                                    set: { mageCharacter.paradigm = $0 }
                                ), axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(3...6)
                            } else {
                                if !mageCharacter.paradigm.isEmpty {
                                    Text(mageCharacter.paradigm)
                                        .font(.system(size: dynamicFontSize))
                                } else {
                                    Text("Not set")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Practice:")
                                    .fontWeight(.medium)
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                            }
                            if isEditing {
                                TextField("Practice", text: Binding(
                                    get: { mageCharacter.practice },
                                    set: { mageCharacter.practice = $0 }
                                ))
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                if !mageCharacter.practice.isEmpty {
                                    Text(mageCharacter.practice)
                                        .font(.system(size: dynamicFontSize))
                                } else {
                                    Text("Not set")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Convictions")) {
                    if character.convictions.isEmpty {
                        Text("No convictions recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.convictions.indices, id: \.self) { index in
                            HStack {
                                Text(character.convictions[index])
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Button("Remove") {
                                        character.convictions.remove(at: index)
                                        refreshID = UUID()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    if isEditing {
                        HStack {
                            TextField("New conviction", text: $newConviction)
                                .font(.system(size: dynamicFontSize))
                            Button("Add") {
                                if !newConviction.trim().isEmpty {
                                    character.convictions.append(newConviction.trim())
                                    newConviction = ""
                                }
                            }
                            .disabled(newConviction.trim().isEmpty)
                        }
                    }
                }
                
                Section(header: Text("Touchstones")) {
                    if character.touchstones.isEmpty {
                        Text("No touchstones recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.touchstones.indices, id: \.self) { index in
                            HStack {
                                Text(character.touchstones[index])
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Button("Remove") {
                                        character.touchstones.remove(at: index)
                                        refreshID = UUID()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    if isEditing {
                        HStack {
                            TextField("New touchstone", text: $newTouchstone)
                                .font(.system(size: dynamicFontSize))
                            Button("Add") {
                                if !newTouchstone.trim().isEmpty {
                                    character.touchstones.append(newTouchstone.trim())
                                    newTouchstone = ""
                                }
                            }
                            .disabled(newTouchstone.trim().isEmpty)
                        }
                    }
                }
                
                // Add instruments section for mage characters
                if let mageCharacter = character as? MageCharacter {
                    Section(header: Text("Instruments")) {
                        if mageCharacter.instruments.isEmpty {
                            Text("No instruments recorded")
                                .foregroundColor(.secondary)
                                .font(.system(size: dynamicFontSize))
                        } else {
                            ForEach(mageCharacter.instruments.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(mageCharacter.instruments[index].description)
                                            .font(.system(size: dynamicFontSize))
                                            .fontWeight(.medium)
                                        Spacer()
                                        if isEditing {
                                            Button("Remove") {
                                                mageCharacter.instruments.remove(at: index)
                                                refreshID = UUID()
                                            }
                                            .font(.caption)
                                            .foregroundColor(.red)
                                        }
                                    }
                                    if !mageCharacter.instruments[index].usage.isEmpty {
                                        Text("Usage: \(mageCharacter.instruments[index].usage)")
                                            .font(.system(size: dynamicFontSize - 2))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        if isEditing {
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Description (required)", text: $newInstrumentDescription)
                                    .font(.system(size: dynamicFontSize))
                                TextField("Usage (optional)", text: $newInstrumentUsage)
                                    .font(.system(size: dynamicFontSize))
                                Button("Add Instrument") {
                                    if !newInstrumentDescription.trim().isEmpty {
                                        let instrument = Instrument(
                                            description: newInstrumentDescription.trim(),
                                            usage: newInstrumentUsage.trim()
                                        )
                                        mageCharacter.instruments.append(instrument)
                                        newInstrumentDescription = ""
                                        newInstrumentUsage = ""
                                    }
                                }
                                .disabled(newInstrumentDescription.trim().isEmpty)
                            }
                        }
                    }
                }
                
                Section(header: Text("Experience")) {
                    HStack {
                        Text("Total Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Total", value: $character.experience, formatter: NumberFormatter())
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        } else {
                            Text("\(character.experience)")
                                .font(.system(size: dynamicFontSize))
                        }
                    }
                    HStack {
                        Text("Spent Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            TextField("Spent", value: $character.spentExperience, formatter: NumberFormatter())
                                .font(.system(size: dynamicFontSize))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        } else {
                            Text("\(character.spentExperience)")
                                .font(.system(size: dynamicFontSize))
                        }
                    }
                    HStack {
                        Text("Available Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        Text("\(character.experience - character.spentExperience)")
                            .font(.system(size: dynamicFontSize))
                    }
                }
            }
            .onAppear {
                calculateOptimalFontSize(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSize(for: newSize)
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
