import SwiftUI

// Editable Merits List View
struct EditableAdvantagesListView: View {
    @Binding var selectedAdvantages: [BackgroundBase]
    let characterType: CharacterType
    let onRefresh: () -> Void
    @State private var showingAddAdvantage = false
    
    var body: some View {
        Button("Add Merit") {
            showingAddAdvantage = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddAdvantage) {
            AddAdvantageView(selectedAdvantages: $selectedAdvantages, characterType: characterType, onRefresh: onRefresh)
        }
    }
}

// Editable Flaws List View
struct EditableFlawsListView: View {
    @Binding var selectedFlaws: [BackgroundBase]
    let characterType: CharacterType
    let onRefresh: () -> Void
    @State private var showingAddFlaw = false
    
    var body: some View {
        Button("Add Flaw") {
            showingAddFlaw = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws, characterType: characterType, onRefresh: onRefresh)
        }
    }
}

// Editable Character Background Merits List View
struct EditableCharacterBackgroundMeritsListView: View {
    @Binding var backgroundMerits: [CharacterBackground]
    let onRefresh: () -> Void
    @State private var showingAddBackground = false
    
    var body: some View {
        Button("Add Background") {
            showingAddBackground = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddBackground) {
            AddCharacterBackgroundView(
                selectedBackgrounds: $backgroundMerits,
                backgroundType: .merit,
                onRefresh: onRefresh
            )
        }
    }
}

// Editable Character Background Flaws List View
struct EditableCharacterBackgroundFlawsListView: View {
    @Binding var backgroundFlaws: [CharacterBackground]
    let onRefresh: () -> Void
    @State private var showingAddBackground = false
    
    var body: some View {
        Button("Add Background") {
            showingAddBackground = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddBackground) {
            AddCharacterBackgroundView(
                selectedBackgrounds: $backgroundFlaws,
                backgroundType: .flaw,
                onRefresh: onRefresh
            )
        }
    }
}

// Helper view for managing advantages list
struct AdvantagesListView: View {
    @Binding var selectedAdvantages: [BackgroundBase]
    let characterType: CharacterType
    @State private var showingAddAdvantage = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Merits")
                    .font(.headline)
                Spacer()
                Text("Total Cost: \(selectedAdvantages.reduce(0) { $0 + $1.cost })")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(selectedAdvantages) { advantage in
                HStack {
                    Text(advantage.name)
                    Spacer()
                    Text("\(advantage.cost) pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(action: {
                        selectedAdvantages.removeAll { $0.id == advantage.id }
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add Merit") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showingAddAdvantage = true
            }
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $showingAddAdvantage) {
            AddAdvantageView(selectedAdvantages: $selectedAdvantages, characterType: characterType, onRefresh: {})
        }
    }
}

// Helper view for adding advantages
struct AddAdvantageView: View {
    @Binding var selectedAdvantages: [BackgroundBase]
    let characterType: CharacterType
    let onRefresh: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var selectedPredefined: BackgroundBase?
    @State private var customName = ""
    @State private var customCost = 1
    @State private var customDescription = ""
    @State private var isCustom = false
    
    var filteredAdvantages: [BackgroundBase] {
        V5Constants.getAdvantagesForCharacterType(characterType)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Predefined Merits") {
                    ForEach(filteredAdvantages) { advantage in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(advantage.name)
                                Spacer()
                                Text("\(advantage.cost) pts")
                                    .foregroundColor(.secondary)
                                Button("Add") {
                                    let newAdvantage = BackgroundBase(name: advantage.name, cost: advantage.cost, description: advantage.description, isCustom: advantage.isCustom, suitableCharacterTypes: advantage.suitableCharacterTypes)
                                    selectedAdvantages.append(newAdvantage)
                                    // Trigger refresh in parent view
                                    onRefresh()
                                    // Small delay to ensure state update is processed
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        dismiss()
                                    }
                                }
                            }
                            if !advantage.description.isEmpty {
                                Text(advantage.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                    .padding(.leading, 4)
                            }
                        }
                    }
                }
                
                Section("Custom Merit") {
                    TextField("Name", text: $customName)
                    TextField("Description (optional)", text: $customDescription)
                        .font(.caption)
                    Stepper("Cost: \(customCost)", value: $customCost, in: 1...10)
                    Button("Add Custom") {
                        let customAdvantage = BackgroundBase(name: customName, cost: customCost, description: customDescription, isCustom: true, suitableCharacterTypes: [characterType])
                        selectedAdvantages.append(customAdvantage)
                        // Trigger refresh in parent view
                        onRefresh()
                        // Small delay to ensure state update is processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(customName.isEmpty)
                }
            }
            .navigationTitle("Add Merit")
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

// Helper view for managing flaws list
struct FlawsListView: View {
    @Binding var selectedFlaws: [BackgroundBase]
    let characterType: CharacterType
    @State private var showingAddFlaw = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Flaws")
                    .font(.headline)
                Spacer()
                Text("Total Value: \(abs(selectedFlaws.reduce(0) { $0 + $1.cost })) pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(selectedFlaws) { flaw in
                HStack {
                    Text(flaw.name)
                    Spacer()
                    Text("\(abs(flaw.cost)) pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(action: {
                        selectedFlaws.removeAll { $0.id == flaw.id }
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add Flaw") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showingAddFlaw = true
            }
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws, characterType: characterType, onRefresh: {})
        }
    }
}

// Helper view for adding flaws
struct AddFlawView: View {
    @Binding var selectedFlaws: [BackgroundBase]
    let characterType: CharacterType
    let onRefresh: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var customName = ""
    @State private var customCost = 1
    @State private var customDescription = ""
    
    var filteredFlaws: [BackgroundBase] {
        V5Constants.getFlawsForCharacterType(characterType)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Predefined Flaws") {
                    ForEach(filteredFlaws) { flaw in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(flaw.name)
                                Spacer()
                                Text("\(abs(flaw.cost)) pts")
                                    .foregroundColor(.secondary)
                                Button("Add") {
                                    let newFlaw = BackgroundBase(name: flaw.name, cost: flaw.cost, description: flaw.description, isCustom: flaw.isCustom, suitableCharacterTypes: flaw.suitableCharacterTypes)
                                    selectedFlaws.append(newFlaw)
                                    // Trigger refresh in parent view
                                    onRefresh()
                                    // Small delay to ensure state update is processed
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        dismiss()
                                    }
                                }
                            }
                            if !flaw.description.isEmpty {
                                Text(flaw.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                    .padding(.leading, 4)
                            }
                        }
                    }
                }
                
                Section("Custom Flaw") {
                    TextField("Name", text: $customName)
                    TextField("Description (optional)", text: $customDescription)
                        .font(.caption)
                    Stepper("Value: \(customCost)", value: $customCost, in: 1...10)
                    Button("Add Custom") {
                        let customFlaw = BackgroundBase(name: customName, cost: -customCost, description: customDescription, isCustom: true, suitableCharacterTypes: [characterType]) // Negative cost for flaws
                        selectedFlaws.append(customFlaw)
                        // Trigger refresh in parent view
                        onRefresh()
                        // Small delay to ensure state update is processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(customName.isEmpty)
                }
            }
            .navigationTitle("Add Flaw")
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

struct AdvantagesFlawsTab: View {
    @Binding var character: any BaseCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var captionFontSize: CGFloat = 12
    @State private var refreshID: UUID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                // Backgrounds (merits) section - comes before merits
                Section(header: Text("Backgrounds (Merits)")) {
                    if character.backgroundMerits.isEmpty {
                        Text("No background merits recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.backgroundMerits) { background in
                            CharacterBackgroundRowView(
                                background: background,
                                dynamicFontSize: dynamicFontSize,
                                captionFontSize: captionFontSize,
                                isEditing: isEditing,
                                onEdit: { editedBackground in
                                    if let index = character.backgroundMerits.firstIndex(where: { $0.id == background.id }) {
                                        character.backgroundMerits[index] = editedBackground
                                        refreshID = UUID()
                                    }
                                },
                                onDelete: {
                                    character.backgroundMerits.removeAll { $0.id == background.id }
                                    refreshID = UUID()
                                }
                            )
                        }

                    }
                    
                    if isEditing {
                        EditableCharacterBackgroundMeritsListView(backgroundMerits: $character.backgroundMerits, onRefresh: {
                            refreshID = UUID()
                        })
                    }
                }
                
                Section(header: Text("Merits")) {
                    if character.advantages.isEmpty {
                        Text("No merits recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.advantages) { advantage in
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(advantage.name)
                                        .font(.system(size: dynamicFontSize))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                    if advantage.isCustom {
                                        Text("(Custom)")
                                            .font(.system(size: captionFontSize))
                                            .foregroundColor(.orange)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.6)
                                    }
                                    Text("\(advantage.cost) pts")
                                        .font(.system(size: captionFontSize))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                    if isEditing {
                                        Button("Remove") {
                                            character.advantages.removeAll { $0.id == advantage.id }
                                            refreshID = UUID()
                                        }
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    }
                                }
                                if !advantage.description.isEmpty {
                                    Text(advantage.description)
                                        .font(.system(size: captionFontSize - 1))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                        .padding(.leading, 4)
                                }
                            }
                        }
                        HStack {
                            Text("Total Merit Cost:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text("\(character.totalAdvantageCost) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    if isEditing {
                        EditableAdvantagesListView(selectedAdvantages: $character.advantages, characterType: character.characterType, onRefresh: {
                            refreshID = UUID()
                        })
                    }
                }
                
                // Backgrounds (flaws) section - comes before flaws
                Section(header: Text("Backgrounds (Flaws)")) {
                    if character.backgroundFlaws.isEmpty {
                        Text("No background flaws recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.backgroundFlaws) { background in
                            CharacterBackgroundRowView(
                                background: background,
                                dynamicFontSize: dynamicFontSize,
                                captionFontSize: captionFontSize,
                                isEditing: isEditing,
                                onEdit: { editedBackground in
                                    if let index = character.backgroundFlaws.firstIndex(where: { $0.id == background.id }) {
                                        character.backgroundFlaws[index] = editedBackground
                                        refreshID = UUID()
                                    }
                                },
                                onDelete: {
                                    character.backgroundFlaws.removeAll { $0.id == background.id }
                                    refreshID = UUID()
                                }
                            )
                        }

                    }
                    
                    if isEditing {
                        EditableCharacterBackgroundFlawsListView(backgroundFlaws: $character.backgroundFlaws, onRefresh: {
                            refreshID = UUID()
                        })
                    }
                }
                
                Section(header: Text("Flaws")) {
                    if character.flaws.isEmpty {
                        Text("No flaws recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.flaws) { flaw in
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(flaw.name)
                                        .font(.system(size: dynamicFontSize))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                    if flaw.isCustom {
                                        Text("(Custom)")
                                            .font(.system(size: captionFontSize))
                                            .foregroundColor(.orange)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.6)
                                    }
                                    Text("\(abs(flaw.cost)) pts")
                                        .font(.system(size: captionFontSize))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                    if isEditing {
                                        Button("Remove") {
                                            character.flaws.removeAll { $0.id == flaw.id }
                                            refreshID = UUID()
                                        }
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    }
                                }
                                if !flaw.description.isEmpty {
                                    Text(flaw.description)
                                        .font(.system(size: captionFontSize - 1))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.8)
                                        .padding(.leading, 4)
                                }
                            }
                        }
                        HStack {
                            Text("Total Flaw Value:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text("\(character.totalFlawValue) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    if isEditing {
                        EditableFlawsListView(selectedFlaws: $character.flaws, characterType: character.characterType, onRefresh: {
                            refreshID = UUID()
                        })
                    }
                }
            }
            .id(refreshID)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                // Add bottom padding to prevent floating buttons from covering content
                Color.clear.frame(height: UIConstants.contentBottomPadding())
            }
            .onAppear {
                calculateOptimalFontSizes(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSizes(for: newSize)
            }
        }
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width with more conservative scaling
        let scaleFactor = min(1.2, size.width / 375) // iPhone standard width, cap at 1.2x
        
        let baseDynamicSize: CGFloat = 16
        let baseCaptionSize: CGFloat = 12
        
        dynamicFontSize = max(11, min(18, baseDynamicSize * scaleFactor))
        captionFontSize = max(9, min(14, baseCaptionSize * scaleFactor))
    }
}

// Helper view for displaying character background rows
struct CharacterBackgroundRowView: View {
    let background: CharacterBackground
    let dynamicFontSize: CGFloat
    let captionFontSize: CGFloat
    let isEditing: Bool
    let onEdit: (CharacterBackground) -> Void
    let onDelete: () -> Void
    @State private var showingEditView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(background.name)
                    .font(.system(size: dynamicFontSize))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                Text("\(abs(background.cost)) pts")
                    .font(.system(size: captionFontSize))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if isEditing {
                    Button("Edit") {
                        showingEditView = true
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    Button("Remove") {
                        onDelete()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            if !background.comment.isEmpty {
                Text(background.comment)
                    .font(.system(size: captionFontSize - 1))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .padding(.leading, 4)
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditCharacterBackgroundView(
                background: background,
                onSave: { editedBackground in
                    onEdit(editedBackground)
                }
            )
        }
    }
}

// Helper view for adding character backgrounds
struct AddCharacterBackgroundView: View {
    @Binding var selectedBackgrounds: [CharacterBackground]
    let backgroundType: BackgroundType
    let onRefresh: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var selectedName = ""
    @State private var cost = 1
    @State private var comment = ""
    @State private var customName = ""
    @State private var isCustom = false
    
    var availableBackgrounds: [String] {
        switch backgroundType {
        case .merit:
            return V5Constants.characterBackgroundMerits
        case .flaw:
            return V5Constants.characterBackgroundFlaws
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Background Selection") {
                    Picker("Background Type", selection: $isCustom) {
                        Text("Predefined Background").tag(false)
                        Text("Custom Background").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if isCustom {
                        TextField("Custom Background Name", text: $customName)
                    } else {
                        Picker("Background Type", selection: $selectedName) {
                            Text("Select Background").tag("")
                            ForEach(availableBackgrounds, id: \.self) { background in
                                Text(background).tag(background)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Stepper("Cost: \(cost)", value: $cost, in: 1...10)
                    
                    TextField("Comment (optional)", text: $comment, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section {
                    Button("Add Background") {
                        let backgroundName = isCustom ? customName : selectedName
                        let newBackground = CharacterBackground(
                            name: backgroundName,
                            cost: backgroundType == .flaw ? -cost : cost, // Negative for flaws
                            comment: comment,
                            type: backgroundType
                        )
                        selectedBackgrounds.append(newBackground)
                        onRefresh()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(isCustom ? customName.isEmpty : selectedName.isEmpty)
                }
            }
            .navigationTitle("Add \(backgroundType.displayName) Background")
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

// Helper view for editing character backgrounds
struct EditCharacterBackgroundView: View {
    let background: CharacterBackground
    let onSave: (CharacterBackground) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var cost: Int
    @State private var comment: String
    
    init(background: CharacterBackground, onSave: @escaping (CharacterBackground) -> Void) {
        self.background = background
        self.onSave = onSave
        self._cost = State(initialValue: abs(background.cost))
        self._comment = State(initialValue: background.comment)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Background Details") {
                    HStack {
                        Text("Type:")
                        Spacer()
                        Text(background.name)
                            .foregroundColor(.secondary)
                    }
                    
                    Stepper("Cost: \(cost)", value: $cost, in: 1...10)
                    
                    TextField("Comment (optional)", text: $comment, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Edit Background")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var editedBackground = background
                        editedBackground.cost = background.type == .flaw ? -cost : cost
                        editedBackground.comment = comment
                        onSave(editedBackground)
                        dismiss()
                    }
                }
            }
        }
    }
}
