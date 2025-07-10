import SwiftUI

struct CharacterDetailView: View {
    var character: Character

    var body: some View {
        TabView {
            // First Tab - Character Information
            CharacterInfoTab(character: character)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Character")
                }
            
            // Second Tab - Status
            StatusTab(character: character)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Status")
                }
            
            // Third Tab - Attributes and Skills
            AttributesSkillsTab(character: character)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Attributes & Skills")
                }
            
            // Fourth Tab - Disciplines
            DisciplinesTab(character: character)
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Disciplines")
                }
            
            // Fifth Tab - Advantages and Flaws
            AdvantagesFlawsTab(character: character)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Advantages & Flaws")
                }
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// First Tab - Character Information
struct CharacterInfoTab: View {
    let character: Character
    @State private var dynamicFontSize: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Basic Information")) {
                    HStack {
                        Text("Name:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        Text(character.name)
                            .font(.system(size: dynamicFontSize))
                            .minimumScaleFactor(0.5)
                    }
                    if !character.chronicleName.isEmpty {
                        HStack {
                            Text("Chronicle:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            Text(character.chronicleName)
                                .font(.system(size: dynamicFontSize))
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
                            Spacer()
                            Text(character.ambition)
                                .font(.system(size: dynamicFontSize))
                                .minimumScaleFactor(0.5)
                        }
                    }
                    if !character.desire.isEmpty {
                        HStack {
                            Text("Desire:")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            Text(character.desire)
                                .font(.system(size: dynamicFontSize))
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Convictions")) {
                    if character.convictions.isEmpty {
                        Text("No convictions recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.convictions, id: \.self) { conviction in
                            Text(conviction)
                                .font(.system(size: dynamicFontSize))
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Touchstones")) {
                    if character.touchstones.isEmpty {
                        Text("No touchstones recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.touchstones, id: \.self) { touchstone in
                            Text(touchstone)
                                .font(.system(size: dynamicFontSize))
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                
                Section(header: Text("Experience")) {
                    HStack {
                        Text("Total Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        Text("\(character.experience)")
                            .font(.system(size: dynamicFontSize))
                    }
                    HStack {
                        Text("Spent Experience:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        Spacer()
                        Text("\(character.spentExperience)")
                            .font(.system(size: dynamicFontSize))
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
            .onChange(of: geometry.size) { newSize in
                calculateOptimalFontSize(for: newSize)
            }
        }
    }
    
    private func calculateOptimalFontSize(for size: CGSize) {
        // Calculate based on screen width - smaller screens get smaller text
        let baseSize: CGFloat = 16
        let minSize: CGFloat = 12
        let maxSize: CGFloat = 18
        
        // Scale font size based on available width
        let scaleFactor = size.width / 375 // iPhone standard width
        let calculatedSize = baseSize * scaleFactor
        
        dynamicFontSize = max(minSize, min(maxSize, calculatedSize))
    }
}

// Second Tab - Status
struct StatusTab: View {
    let character: Character
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    StatusRowView(title: "Health", healthStates: character.healthStates, availableWidth: geometry.size.width - 40)
                    
                    StatusRowView(title: "Willpower", healthStates: character.willpowerStates, availableWidth: geometry.size.width - 40)
                    
                    StatusRowView(title: "Humanity", humanityStates: character.humanityStates, availableWidth: geometry.size.width - 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
}

// Third Tab - Attributes and Skills
struct AttributesSkillsTab: View {
    let character: Character
    @State private var dynamicFontSize: CGFloat = 14
    @State private var titleFontSize: CGFloat = 20
    @State private var headerFontSize: CGFloat = 17
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Attributes Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Attributes")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 20) {
                            // Physical Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Physical")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                                    HStack {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .minimumScaleFactor(0.5)
                                        Spacer()
                                        Text("\(character.physicalAttributes[attribute] ?? 0)")
                                            .font(.system(size: dynamicFontSize, weight: .medium))
                                            .frame(width: 25, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Social Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Social")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                                    HStack {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .minimumScaleFactor(0.5)
                                        Spacer()
                                        Text("\(character.socialAttributes[attribute] ?? 0)")
                                            .font(.system(size: dynamicFontSize, weight: .medium))
                                            .frame(width: 25, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Mental Attributes Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mental")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                                    HStack {
                                        Text(attribute)
                                            .font(.system(size: dynamicFontSize))
                                            .minimumScaleFactor(0.5)
                                        Spacer()
                                        Text("\(character.mentalAttributes[attribute] ?? 0)")
                                            .font(.system(size: dynamicFontSize, weight: .medium))
                                            .frame(width: 25, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Skills Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Skills")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 20) {
                            // Physical Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Physical")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                                    HStack {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .minimumScaleFactor(0.5)
                                        Spacer()
                                        Text("\(character.physicalSkills[skill] ?? 0)")
                                            .font(.system(size: dynamicFontSize, weight: .medium))
                                            .frame(width: 25, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Social Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Social")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.socialSkills, id: \.self) { skill in
                                    HStack {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .minimumScaleFactor(0.5)
                                        Spacer()
                                        Text("\(character.socialSkills[skill] ?? 0)")
                                            .font(.system(size: dynamicFontSize, weight: .medium))
                                            .frame(width: 25, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Mental Skills Column
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mental")
                                    .font(.system(size: headerFontSize, weight: .semibold))
                                
                                ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                                    HStack {
                                        Text(skill)
                                            .font(.system(size: dynamicFontSize))
                                            .minimumScaleFactor(0.5)
                                        Spacer()
                                        Text("\(character.mentalSkills[skill] ?? 0)")
                                            .font(.system(size: dynamicFontSize, weight: .medium))
                                            .frame(width: 25, alignment: .center)
                                            .padding(.horizontal, 6)
                                            .cornerRadius(4)
                                    }
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
        // Calculate based on screen width - smaller screens get smaller text
        let scaleFactor = size.width / 375 // iPhone standard width
        
        // Base font sizes
        let baseDynamicSize: CGFloat = 14
        let baseTitleSize: CGFloat = 20
        let baseHeaderSize: CGFloat = 17
        
        // Calculate scaled sizes
        dynamicFontSize = max(10, min(16, baseDynamicSize * scaleFactor))
        titleFontSize = max(16, min(24, baseTitleSize * scaleFactor))
        headerFontSize = max(14, min(20, baseHeaderSize * scaleFactor))
    }
}

// Fourth Tab - Disciplines
struct DisciplinesTab: View {
    let character: Character
    @State private var dynamicFontSize: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Disciplines")) {
                    if character.disciplines.isEmpty {
                        Text("No disciplines learned")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { discipline, level in
                            HStack {
                                Text(discipline)
                                    .font(.system(size: dynamicFontSize))
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                Text("Level \(level)")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize * 0.8))
                            }
                        }
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
        // Calculate based on screen width - smaller screens get smaller text
        let baseSize: CGFloat = 16
        let minSize: CGFloat = 12
        let maxSize: CGFloat = 18
        
        // Scale font size based on available width
        let scaleFactor = size.width / 375 // iPhone standard width
        let calculatedSize = baseSize * scaleFactor
        
        dynamicFontSize = max(minSize, min(maxSize, calculatedSize))
    }
}

// Fifth Tab - Advantages and Flaws
struct AdvantagesFlawsTab: View {
    let character: Character
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
                    } else {
                        ForEach(character.advantages) { advantage in
                            HStack {
                                Text(advantage.name)
                                    .font(.system(size: dynamicFontSize))
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                if advantage.isCustom {
                                    Text("(Custom)")
                                        .font(.system(size: captionFontSize))
                                        .foregroundColor(.orange)
                                }
                                Text("\(advantage.cost) pts")
                                    .font(.system(size: captionFontSize))
                                    .foregroundColor(.secondary)
                            }
                        }
                        HStack {
                            Text("Total Cost:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                            Spacer()
                            Text("\(character.totalAdvantageCost) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Section(header: Text("Flaws")) {
                    if character.flaws.isEmpty {
                        Text("No flaws recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.flaws) { flaw in
                            HStack {
                                Text(flaw.name)
                                    .font(.system(size: dynamicFontSize))
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                if flaw.isCustom {
                                    Text("(Custom)")
                                        .font(.system(size: captionFontSize))
                                        .foregroundColor(.orange)
                                }
                                Text("\(abs(flaw.cost)) pts")
                                    .font(.system(size: captionFontSize))
                                    .foregroundColor(.secondary)
                            }
                        }
                        HStack {
                            Text("Total Value:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                            Spacer()
                            Text("\(abs(character.totalFlawValue)) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                if !character.advantages.isEmpty || !character.flaws.isEmpty {
                    Section(header: Text("Net Cost")) {
                        HStack {
                            Text("Advantages - Flaws:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                            Spacer()
                            Text("\(character.netAdvantageFlawCost) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(character.netAdvantageFlawCost <= 0 ? .green : .red)
                        }
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
        // Calculate based on screen width - smaller screens get smaller text
        let scaleFactor = size.width / 375 // iPhone standard width
        
        let baseDynamicSize: CGFloat = 16
        let baseCaptionSize: CGFloat = 12
        
        dynamicFontSize = max(12, min(18, baseDynamicSize * scaleFactor))
        captionFontSize = max(10, min(14, baseCaptionSize * scaleFactor))
    }
}
