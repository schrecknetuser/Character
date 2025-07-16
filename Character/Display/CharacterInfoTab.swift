import SwiftUI


struct CharacterInfoTab: View {
    @Binding var character: any BaseCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var newInstrumentDescription: String = ""
    @State private var newInstrumentUsage: String = ""
    @State private var refreshID: UUID = UUID()
    @State private var showPredatorTypeSelection: Bool = false
    @State private var showPredatorTypeInfo: Bool = false
    
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
                    
                    // Date of Birth
                    HStack {
                        Text("Date of Birth:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        if isEditing {
                            DatePicker("", selection: Binding(
                                get: { character.dateOfBirth ?? Date() },
                                set: { character.dateOfBirth = $0 }
                            ), displayedComponents: .date)
                            .labelsHidden()
                        } else {
                            if let dateOfBirth = character.dateOfBirth {
                                Text(dateOfBirth, style: .date)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    
                    // Character-specific dates
                    if let vampire = character as? VampireCharacter {
                        HStack {
                            Text("Date of Embrace:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            if isEditing {
                                DatePicker("", selection: Binding(
                                    get: { vampire.dateOfEmbrace ?? Date() },
                                    set: { vampire.dateOfEmbrace = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()
                            } else {
                                if let dateOfEmbrace = vampire.dateOfEmbrace {
                                    Text(dateOfEmbrace, style: .date)
                                        .font(.system(size: dynamicFontSize))
                                } else {
                                    Text("Not set")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                        }
                        
                        // Predator Path
                        HStack {
                            Text("Predator Type:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            if isEditing {
                                Button(action: {
                                    showPredatorTypeSelection = true
                                }) {
                                    Text(vampire.predatorType.isEmpty ? "Select Type" : vampire.predatorType)
                                        .font(.system(size: dynamicFontSize))
                                        .foregroundColor(vampire.predatorType.isEmpty ? .secondary : .primary)
                                }
                            } else {
                                if !vampire.predatorType.isEmpty {
                                    Button(action: {
                                        showPredatorTypeInfo = true
                                    }) {
                                        Text(vampire.predatorType)
                                            .font(.system(size: dynamicFontSize))
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Text("Not set")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                        }
                    } else if let ghoul = character as? GhoulCharacter {
                        HStack {
                            Text("Date of Ghouling:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            if isEditing {
                                DatePicker("", selection: Binding(
                                    get: { ghoul.dateOfGhouling ?? Date() },
                                    set: { ghoul.dateOfGhouling = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()
                            } else {
                                if let dateOfGhouling = ghoul.dateOfGhouling {
                                    Text(dateOfGhouling, style: .date)
                                        .font(.system(size: dynamicFontSize))
                                } else {
                                    Text("Not set")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                        }
                    } else if let mage = character as? MageCharacter {
                        HStack {
                            Text("Date of Awakening:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            if isEditing {
                                DatePicker("", selection: Binding(
                                    get: { mage.dateOfAwakening ?? Date() },
                                    set: { mage.dateOfAwakening = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()
                            } else {
                                if let dateOfAwakening = mage.dateOfAwakening {
                                    Text(dateOfAwakening, style: .date)
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
                
                // Add mage essence, resonance, and synergy section for mage characters
                if let mageCharacter = character as? MageCharacter {
                    Section(header: Text("Mage Traits")) {
                        // Essence
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Essence:")
                                    .fontWeight(.medium)
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Picker("Essence", selection: Binding(
                                        get: { mageCharacter.essence },
                                        set: { mageCharacter.essence = $0 }
                                    )) {
                                        ForEach(MageEssence.allCases, id: \.self) { essence in
                                            Text(essence.displayName).tag(essence)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .font(.system(size: dynamicFontSize))
                                } else {
                                    Text(mageCharacter.essence.displayName)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                            Text("Description: \(mageCharacter.essence.description)")
                                .font(.system(size: dynamicFontSize - 2))
                                .foregroundColor(.secondary)
                        }
                        
                        // Resonance
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Resonance:")
                                    .fontWeight(.medium)
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Picker("Resonance", selection: Binding(
                                        get: { mageCharacter.resonance },
                                        set: { mageCharacter.resonance = $0 }
                                    )) {
                                        ForEach(MageResonance.allCases, id: \.self) { resonance in
                                            Text(resonance.displayName).tag(resonance)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .font(.system(size: dynamicFontSize))
                                } else {
                                    Text(mageCharacter.resonance.displayName)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                            Text("Description: \(mageCharacter.resonance.description)")
                                .font(.system(size: dynamicFontSize - 2))
                                .foregroundColor(.secondary)
                        }
                        
                        // Synergy
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Synergy:")
                                    .fontWeight(.medium)
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Picker("Synergy", selection: Binding(
                                        get: { mageCharacter.synergy },
                                        set: { mageCharacter.synergy = $0 }
                                    )) {
                                        ForEach(MageSynergy.allCases, id: \.self) { synergy in
                                            Text(synergy.displayName).tag(synergy)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .font(.system(size: dynamicFontSize))
                                } else {
                                    Text(mageCharacter.synergy.displayName)
                                        .font(.system(size: dynamicFontSize))
                                }
                            }
                            Text("Description: \(mageCharacter.synergy.description)")
                                .font(.system(size: dynamicFontSize - 2))
                                .foregroundColor(.secondary)
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
                            .foregroundColor(isEditing ? .secondary : .primary)
                        Spacer()
                        Text("\(character.experience - character.spentExperience)")
                            .font(.system(size: dynamicFontSize))
                            .foregroundColor(isEditing ? .secondary : .primary)
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                // Add bottom padding to prevent floating buttons from covering content
                Color.clear.frame(height: UIConstants.contentBottomPadding())
            }
            .onAppear {
                calculateOptimalFontSize(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSize(for: newSize)
            }
            .sheet(isPresented: $showPredatorTypeSelection) {
                if let vampire = character as? VampireCharacter {
                    PredatorTypeSelectionModal(vampire: vampire, isPresented: $showPredatorTypeSelection)
                }
            }
            .sheet(isPresented: $showPredatorTypeInfo) {
                if let vampire = character as? VampireCharacter {
                    PredatorTypeDisplayModal(vampire: vampire, isPresented: $showPredatorTypeInfo)
                }
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
