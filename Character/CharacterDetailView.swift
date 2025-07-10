import SwiftUI

struct CharacterDetailView: View {
    @Binding var character: Character
    @ObservedObject var store: CharacterStore
    @State private var isEditing = false

    var body: some View {
        TabView {
            // First Tab - Character Information
            CharacterInfoTab(character: character, isEditing: $isEditing)
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
            
            // Fifth Tab - Advantages and Flaws
            AdvantagesFlawsTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Advantages & Flaws")
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
    let character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Basic Information")) {
                    HStack {
                        Text("Name:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        Text(character.name)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    if !character.chronicleName.isEmpty {
                        HStack {
                            Text("Chronicle:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text(character.chronicleName)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Character Background")) {
                    if !character.ambition.isEmpty {
                        HStack {
                            Text("Ambition:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text(character.ambition)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    if !character.desire.isEmpty {
                        HStack {
                            Text("Desire:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text(character.desire)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Convictions")) {
                    if character.convictions.isEmpty {
                        Text("No convictions recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.convictions, id: \.self) { conviction in
                            Text(conviction)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Touchstones")) {
                    if character.touchstones.isEmpty {
                        Text("No touchstones recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.touchstones, id: \.self) { touchstone in
                            Text(touchstone)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Experience")) {
                    HStack {
                        Text("Total Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        Text("\(character.experience)")
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                    }
                    HStack {
                        Text("Spent Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        Text("\(character.spentExperience)")
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                    }
                    HStack {
                        Text("Available Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        Text("\(character.experience - character.spentExperience)")
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                    }
                }
            }
            .onAppear {
                calculateOptimalFontSize(for: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
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
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        HStack(alignment: .top, spacing: 20) {
                            // Physical Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Physical")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                                    HStack {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
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
                                            .frame(width: 70)
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
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                                    HStack {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
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
                                            .frame(width: 70)
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
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                                    HStack {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
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
                                            .frame(width: 70)
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
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        
                        HStack(alignment: .top, spacing: 20) {
                            // Physical Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Physical")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                                    HStack {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
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
                                            .frame(width: 70)
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
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                ForEach(V5Constants.socialSkills, id: \.self) { skill in
                                    HStack {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
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
                                            .frame(width: 70)
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
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                                    HStack {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
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
                                            .frame(width: 70)
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
                .onChange(of: geometry.size) { newSize in
                    calculateOptimalFontSizes(for: newSize)
                }
            }
        }
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width and available space
        let availableWidth = (size.width - 80) / 3 // Account for padding and 3 columns
        
        // Find the longest text among all displayed values
        let allDisplayedTexts = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes +
                               V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills +
                               ["Physical", "Social", "Mental", "Attributes", "Skills"]
        let longestText = allDisplayedTexts.max(by: { $0.count < $1.count }) ?? "Intelligence"
        
        // Determine optimal font size based on available width per column
        let scaleFactor = min(1.0, availableWidth / (CGFloat(longestText.count) * 8)) // Rough character width estimate
        
        // Base font sizes adjusted for actual content
        let baseDynamicSize: CGFloat = 14
        let baseTitleSize: CGFloat = 20
        let baseHeaderSize: CGFloat = 17
        let baseRowHeight: CGFloat = 20
        
        // Calculate scaled sizes with more conservative scaling
        dynamicFontSize = max(9, min(16, baseDynamicSize * scaleFactor))
        titleFontSize = max(14, min(24, baseTitleSize * scaleFactor))
        headerFontSize = max(12, min(20, baseHeaderSize * scaleFactor))
        rowHeight = max(16, min(24, baseRowHeight * scaleFactor))
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
            .onChange(of: geometry.size) { newSize in
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

// Fifth Tab - Advantages and Flaws
struct AdvantagesFlawsTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var captionFontSize: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Advantages")) {
                    if character.advantages.isEmpty {
                        Text("No advantages recorded")
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
            .onChange(of: geometry.size) { newSize in
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

// Editable Advantages List View
struct EditableAdvantagesListView: View {
    @Binding var selectedAdvantages: [Advantage]
    @State private var showingAddAdvantage = false
    
    var body: some View {
        Button("Add Advantage") {
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

// Status Type Enum
enum StatusType {
    case health
    case willpower
}

// Editable Status Row View
struct EditableStatusRowView: View {
    @Binding var character: Character
    let title: String
    let type: StatusType
    let availableWidth: CGFloat
    
    private var states: [HealthState] {
        switch type {
        case .health:
            return character.healthStates
        case .willpower:
            return character.willpowerStates
        }
    }
    
    private var boxCount: Int {
        switch type {
        case .health:
            return character.healthBoxCount
        case .willpower:
            return character.willpowerBoxCount
        }
    }
    
    private func updateStates(_ newStates: [HealthState]) {
        switch type {
        case .health:
            character.healthStates = newStates
        case .willpower:
            character.willpowerStates = newStates
        }
    }
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            // Ensure we have the right number of boxes
            let adjustedStates = adjustStateArrayToCount(states, targetCount: boxCount)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(adjustedStates.indices, id: \.self) { index in
                    HealthBoxView(state: adjustedStates[index])
                }
            }
            
            // Superficial damage controls
            HStack {
                if canDecreaseSuperficial() {
                    Button(action: {
                        decreaseSuperficial()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Superficial")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseSuperficial() {
                    Button(action: {
                        increaseSuperficial()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
            
            // Aggravated damage controls
            HStack {
                if canDecreaseAggravated() {
                    Button(action: {
                        decreaseAggravated()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Aggravated")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseAggravated() {
                    Button(action: {
                        increaseAggravated()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 4)
        }
        .onAppear {
            // Ensure state arrays are correct size when view appears
            let adjustedStates = adjustStateArrayToCount(states, targetCount: boxCount)
            updateStates(adjustedStates)
        }
    }
    
    private func adjustStateArrayToCount(_ currentStates: [HealthState], targetCount: Int) -> [HealthState] {
        var adjustedStates = currentStates
        
        if adjustedStates.count < targetCount {
            // Add missing boxes as ok
            adjustedStates.append(contentsOf: Array(repeating: .ok, count: targetCount - adjustedStates.count))
        } else if adjustedStates.count > targetCount {
            // Remove excess boxes, prioritizing ok boxes first
            while adjustedStates.count > targetCount {
                if let okIndex = adjustedStates.lastIndex(of: .ok) {
                    adjustedStates.remove(at: okIndex)
                } else if let superficialIndex = adjustedStates.lastIndex(of: .superficial) {
                    adjustedStates.remove(at: superficialIndex)
                } else if let aggravatedIndex = adjustedStates.lastIndex(of: .aggravated) {
                    adjustedStates.remove(at: aggravatedIndex)
                }
            }
        }
        
        return adjustedStates
    }
    
    // Superficial damage logic
    private func canDecreaseSuperficial() -> Bool {
        states.contains(.superficial)
    }
    
    private func canIncreaseSuperficial() -> Bool {
        states.contains(.ok) || (!states.contains(.ok) && states.contains(.superficial))
    }
    
    private func decreaseSuperficial() {
        var newStates = states
        // Remove from right to left (last index first)
        if let index = newStates.lastIndex(of: .superficial) {
            newStates[index] = .ok
            updateStates(newStates)
        }
    }
    
    private func increaseSuperficial() {
        var newStates = states
        if let index = newStates.firstIndex(of: .ok) {
            newStates[index] = .superficial
            updateStates(newStates)
        } else if !newStates.contains(.ok) && newStates.contains(.superficial) {
            // Convert superficial to aggravated if no ok boxes
            if let index = newStates.firstIndex(of: .superficial) {
                newStates[index] = .aggravated
                updateStates(newStates)
            }
        }
    }
    
    // Aggravated damage logic
    private func canDecreaseAggravated() -> Bool {
        states.contains(.aggravated)
    }
    
    private func canIncreaseAggravated() -> Bool {
        !states.filter({ $0 != .aggravated }).isEmpty
    }
    
    private func decreaseAggravated() {
        var newStates = states
        // Remove from right to left (last index first)
        if let index = newStates.lastIndex(of: .aggravated) {
            newStates[index] = .ok
            updateStates(newStates)
        }
    }
    
    private func increaseAggravated() {
        var newStates = states
        if let index = newStates.firstIndex(of: .ok) {
            newStates[index] = .aggravated
            updateStates(newStates)
        } else if let index = newStates.firstIndex(of: .superficial) {
            newStates[index] = .aggravated
            updateStates(newStates)
        }
    }
}

// Editable Humanity Row View
struct EditableHumanityRowView: View {
    @Binding var character: Character
    let availableWidth: CGFloat
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Humanity")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(character.humanityStates.indices, id: \.self) { index in
                    HumanityBoxView(state: character.humanityStates[index])
                }
            }
            
            // Humanity controls
            HStack {
                if canDecreaseHumanity() {
                    Button(action: {
                        decreaseHumanity()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Humanity")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseHumanity() {
                    Button(action: {
                        increaseHumanity()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
            
            // Stains controls
            HStack {
                if canDecreaseStains() {
                    Button(action: {
                        decreaseStains()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Stains")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseStains() {
                    Button(action: {
                        increaseStains()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 4)
        }
    }
    
    // Humanity logic
    private func canDecreaseHumanity() -> Bool {
        character.humanityStates.contains(.checked)
    }
    
    private func canIncreaseHumanity() -> Bool {
        character.humanityStates.contains(.unchecked)
    }
    
    private func decreaseHumanity() {
        // Remove from left to right (first index first)
        if let index = character.humanityStates.firstIndex(of: .checked) {
            character.humanityStates[index] = .unchecked
        }
    }
    
    private func increaseHumanity() {
        if let index = character.humanityStates.firstIndex(of: .unchecked) {
            character.humanityStates[index] = .checked
        }
    }
    
    // Stains logic
    private func canDecreaseStains() -> Bool {
        character.humanityStates.contains(.stained)
    }
    
    private func canIncreaseStains() -> Bool {
        character.humanityStates.contains(.unchecked)
    }
    
    private func decreaseStains() {
        // Remove from left to right (first index first)
        if let index = character.humanityStates.firstIndex(of: .stained) {
            character.humanityStates[index] = .unchecked
        }
    }
    
    private func increaseStains() {
        // Add from right to left (last unchecked first)
        if let index = character.humanityStates.lastIndex(of: .unchecked) {
            character.humanityStates[index] = .stained
        }
    }
}
