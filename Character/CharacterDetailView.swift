import SwiftUI

// String extension for trimming whitespace
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct CharacterDetailView: View {
    @Binding var character: Character
    @ObservedObject var store: CharacterStore
    @State private var isEditing = false

    var body: some View {
        TabView {
            // First Tab - Character Information
            CharacterInfoTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Character")
                }
            
            // Second Tab - Status
            StatusTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Status")
                }
            
            // Third Tab - Attributes and Skills
            AttributesSkillsTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Attributes & Skills")
                }
            
            // Fourth Tab - Disciplines
            DisciplinesTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Disciplines")
                }
            
            // Fifth Tab - Merits and Flaws
            AdvantagesFlawsTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Merits & Flaws")
                }

        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        // Save changes
                        store.updateCharacter(character)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}

// First Tab - Character Information
struct CharacterInfoTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var newConviction: String = ""
    @State private var newTouchstone: String = ""
    
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

// Second Tab - Status
struct StatusTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    if isEditing {
                        EditableStatusRowView(character: $character, title: "Health", type: .health, availableWidth: geometry.size.width - 40)
                        
                        EditableStatusRowView(character: $character, title: "Willpower", type: .willpower, availableWidth: geometry.size.width - 40)
                        
                        EditableHumanityRowView(character: $character, availableWidth: geometry.size.width - 40)
                    } else {
                        StatusRowView(title: "Health", healthStates: character.healthStates, availableWidth: geometry.size.width - 40)
                        
                        StatusRowView(title: "Willpower", healthStates: character.willpowerStates, availableWidth: geometry.size.width - 40)
                        
                        StatusRowView(title: "Humanity", humanityStates: character.humanityStates, availableWidth: geometry.size.width - 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
}

// Third Tab - Attributes and Skills
struct AttributesSkillsTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 14
    @State private var titleFontSize: CGFloat = 20
    @State private var headerFontSize: CGFloat = 17
    @State private var rowHeight: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Attributes Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Attributes")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 12) {
                            // Physical Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Physical")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                                    HStack(spacing: 6) {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                        Spacer()
                                        if isEditing {
                                            Picker("", selection: Binding(
                                                get: { character.physicalAttributes[attribute] ?? 1 },
                                                set: { character.physicalAttributes[attribute] = $0 }
                                            )) {
                                                ForEach(0...10, id: \.self) { value in
                                                    Text("\(value)")
                                                        .font(.system(size: dynamicFontSize))
                                                        .tag(value)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 55)
                                            .clipped()
                                        } else {
                                            Text("\(character.physicalAttributes[attribute] ?? 0)")
                                                .font(.system(size: dynamicFontSize, weight: .medium))
                                                .frame(width: 25, alignment: .center)
                                        }
                                    }
                                    .frame(minHeight: rowHeight)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Social Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Social")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                                    HStack(spacing: 6) {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                        Spacer()
                                        if isEditing {
                                            Picker("", selection: Binding(
                                                get: { character.socialAttributes[attribute] ?? 1 },
                                                set: { character.socialAttributes[attribute] = $0 }
                                            )) {
                                                ForEach(0...10, id: \.self) { value in
                                                    Text("\(value)")
                                                        .font(.system(size: dynamicFontSize))
                                                        .tag(value)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 55)
                                            .clipped()
                                        } else {
                                            Text("\(character.socialAttributes[attribute] ?? 0)")
                                                .font(.system(size: dynamicFontSize, weight: .medium))
                                                .frame(width: 25, alignment: .center)
                                        }
                                    }
                                    .frame(minHeight: rowHeight)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Mental Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mental")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                                    HStack(spacing: 6) {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                        Spacer()
                                        if isEditing {
                                            Picker("", selection: Binding(
                                                get: { character.mentalAttributes[attribute] ?? 1 },
                                                set: { character.mentalAttributes[attribute] = $0 }
                                            )) {
                                                ForEach(0...10, id: \.self) { value in
                                                    Text("\(value)")
                                                        .font(.system(size: dynamicFontSize))
                                                        .tag(value)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 55)
                                            .clipped()
                                        } else {
                                            Text("\(character.mentalAttributes[attribute] ?? 0)")
                                                .font(.system(size: dynamicFontSize, weight: .medium))
                                                .frame(width: 25, alignment: .center)
                                        }
                                    }
                                    .frame(minHeight: rowHeight)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Skills Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Skills")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 12) {
                            // Physical Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Physical")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                                    HStack(spacing: 6) {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                        Spacer()
                                        if isEditing {
                                            Picker("", selection: Binding(
                                                get: { character.physicalSkills[skill] ?? 0 },
                                                set: { character.physicalSkills[skill] = $0 }
                                            )) {
                                                ForEach(0...10, id: \.self) { value in
                                                    Text("\(value)")
                                                        .font(.system(size: dynamicFontSize))
                                                        .tag(value)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 55)
                                            .clipped()
                                        } else {
                                            Text("\(character.physicalSkills[skill] ?? 0)")
                                                .font(.system(size: dynamicFontSize, weight: .medium))
                                                .frame(width: 25, alignment: .center)
                                        }
                                    }
                                    .frame(minHeight: rowHeight)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Social Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Social")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.socialSkills, id: \.self) { skill in
                                    HStack(spacing: 6) {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                        Spacer()
                                        if isEditing {
                                            Picker("", selection: Binding(
                                                get: { character.socialSkills[skill] ?? 0 },
                                                set: { character.socialSkills[skill] = $0 }
                                            )) {
                                                ForEach(0...10, id: \.self) { value in
                                                    Text("\(value)")
                                                        .font(.system(size: dynamicFontSize))
                                                        .tag(value)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 55)
                                            .clipped()
                                        } else {
                                            Text("\(character.socialSkills[skill] ?? 0)")
                                                .font(.system(size: dynamicFontSize, weight: .medium))
                                                .frame(width: 25, alignment: .center)
                                        }
                                    }
                                    .frame(minHeight: rowHeight)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Mental Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mental")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                                    HStack(spacing: 6) {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                        Spacer()
                                        if isEditing {
                                            Picker("", selection: Binding(
                                                get: { character.mentalSkills[skill] ?? 0 },
                                                set: { character.mentalSkills[skill] = $0 }
                                            )) {
                                                ForEach(0...10, id: \.self) { value in
                                                    Text("\(value)")
                                                        .font(.system(size: dynamicFontSize))
                                                        .tag(value)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 55)
                                            .clipped()
                                        } else {
                                            Text("\(character.mentalSkills[skill] ?? 0)")
                                                .font(.system(size: dynamicFontSize, weight: .medium))
                                                .frame(width: 25, alignment: .center)
                                        }
                                    }
                                    .frame(minHeight: rowHeight)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .onAppear {
                    calculateOptimalFontSizes(for: geometry.size)
                }
                .onChange(of: geometry.size) { _, newSize in
                    calculateOptimalFontSizes(for: newSize)
                }
            }
        }
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width and available space
        let availableWidth = (size.width - 120) / 3 // Account for padding and 3 columns, more conservative
        
        // Find the longest text among all displayed values
        let allDisplayedTexts = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes +
                               V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills +
                               ["Physical", "Social", "Mental", "Attributes", "Skills"]
        let longestText = allDisplayedTexts.max(by: { $0.count < $1.count }) ?? "Intelligence"
        
        // Determine optimal font size based on available width per column
        let scaleFactor = min(1.0, availableWidth / (CGFloat(longestText.count) * 8)) // More conservative character width estimate
        
        // Base font sizes adjusted for actual content - more conservative
        let baseDynamicSize: CGFloat = 11
        let baseTitleSize: CGFloat = 17
        let baseHeaderSize: CGFloat = 14
        let baseRowHeight: CGFloat = 24
        
        // Calculate scaled sizes with more conservative scaling
        dynamicFontSize = max(9, min(13, baseDynamicSize * scaleFactor))
        titleFontSize = max(15, min(19, baseTitleSize * scaleFactor))
        headerFontSize = max(12, min(16, baseHeaderSize * scaleFactor))
        rowHeight = max(22, min(28, baseRowHeight * scaleFactor))
    }
}

// Fourth Tab - Disciplines
struct DisciplinesTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var showingAddDiscipline = false
    
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

// Fifth Tab - Merits and Flaws
struct AdvantagesFlawsTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var captionFontSize: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Merits")) {
                    if character.advantages.isEmpty {
                        Text("No merits recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.advantages) { advantage in
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
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        HStack {
                            Text("Total Cost:")
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
                        EditableAdvantagesListView(selectedAdvantages: $character.advantages)
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
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        HStack {
                            Text("Total Value:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text("\(abs(character.totalFlawValue)) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    if isEditing {
                        EditableFlawsListView(selectedFlaws: $character.flaws)
                    }
                }
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

// Add Discipline View
struct AddDisciplineView: View {
    @Binding var character: Character
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

// Editable Merits List View
struct EditableAdvantagesListView: View {
    @Binding var selectedAdvantages: [Advantage]
    @State private var showingAddAdvantage = false
    
    var body: some View {
        Button("Add Merit") {
            showingAddAdvantage = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddAdvantage) {
            AddAdvantageView(selectedAdvantages: $selectedAdvantages)
        }
    }
}

// Editable Flaws List View
struct EditableFlawsListView: View {
    @Binding var selectedFlaws: [Flaw]
    @State private var showingAddFlaw = false
    
    var body: some View {
        Button("Add Flaw") {
            showingAddFlaw = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws)
        }
    }
}


