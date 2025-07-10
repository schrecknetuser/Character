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
        .navigationBarTitleDisplayMode(.large)
    }
}

// First Tab - Character Information
struct CharacterInfoTab: View {
    let character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                Text("Name: \(character.name)")
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                if !character.chronicleName.isEmpty {
                    Text("Chronicle: \(character.chronicleName)")
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                }
            }
            
            Section(header: Text("Character Background")) {
                if !character.ambition.isEmpty {
                    Text("Ambition: \(character.ambition)")
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                }
                if !character.desire.isEmpty {
                    Text("Desire: \(character.desire)")
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                }
            }
            
            Section(header: Text("Convictions")) {
                if character.convictions.isEmpty {
                    Text("No convictions recorded")
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                } else {
                    ForEach(character.convictions, id: \.self) { conviction in
                        Text(conviction)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    }
                }
            }
            
            Section(header: Text("Touchstones")) {
                if character.touchstones.isEmpty {
                    Text("No touchstones recorded")
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                } else {
                    ForEach(character.touchstones, id: \.self) { touchstone in
                        Text(touchstone)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    }
                }
            }
            
            Section(header: Text("Experience")) {
                Text("Total Experience: \(character.experience)")
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                Text("Spent Experience: \(character.spentExperience)")
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                Text("Available Experience: \(character.experience - character.spentExperience)")
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Second Tab - Status
struct StatusTab: View {
    let character: Character
    @ScaledMetric private var sectionSpacing: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                StatusRowView(title: "Health", healthStates: character.healthStates)
                
                StatusRowView(title: "Willpower", healthStates: character.willpowerStates)
                
                StatusRowView(title: "Humanity", humanityStates: character.humanityStates)
            }
            .padding()
            .padding(.top) // Extra padding to ensure safe area clearance
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Third Tab - Attributes and Skills
struct AttributesSkillsTab: View {
    let character: Character
    @ScaledMetric private var sectionSpacing: CGFloat = 30
    @ScaledMetric private var columnSpacing: CGFloat = 20
    @ScaledMetric private var rowSpacing: CGFloat = 8
    @ScaledMetric private var headerSpacing: CGFloat = 15
    @ScaledMetric private var valueWidth: CGFloat = 30
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: sectionSpacing) {
                // Attributes Section
                VStack(alignment: .leading, spacing: headerSpacing) {
                    Text("Attributes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    
                    HStack(alignment: .top, spacing: columnSpacing) {
                        // Physical Attributes Column
                        VStack(alignment: .leading, spacing: rowSpacing) {
                            Text("Physical")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                            ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                    Text("\(character.physicalAttributes[attribute] ?? 0)")
                                        .frame(width: valueWidth, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Social Attributes Column
                        VStack(alignment: .leading, spacing: rowSpacing) {
                            Text("Social")
                                .font(.headline)
                                .foregroundColor(.green)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                            ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                    Text("\(character.socialAttributes[attribute] ?? 0)")
                                        .frame(width: valueWidth, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Mental Attributes Column
                        VStack(alignment: .leading, spacing: rowSpacing) {
                            Text("Mental")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                            ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                    Text("\(character.mentalAttributes[attribute] ?? 0)")
                                        .frame(width: valueWidth, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // Skills Section
                VStack(alignment: .leading, spacing: headerSpacing) {
                    Text("Skills")
                        .font(.title2)
                        .fontWeight(.bold)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    
                    HStack(alignment: .top, spacing: columnSpacing) {
                        // Physical Skills Column
                        VStack(alignment: .leading, spacing: rowSpacing) {
                            Text("Physical")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                            ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                    Text("\(character.physicalSkills[skill] ?? 0)")
                                        .frame(width: valueWidth, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Social Skills Column
                        VStack(alignment: .leading, spacing: rowSpacing) {
                            Text("Social")
                                .font(.headline)
                                .foregroundColor(.green)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                            ForEach(V5Constants.socialSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                    Text("\(character.socialSkills[skill] ?? 0)")
                                        .frame(width: valueWidth, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Mental Skills Column
                        VStack(alignment: .leading, spacing: rowSpacing) {
                            Text("Mental")
                                .font(.headline)
                                .foregroundColor(.purple)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            
                            ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                    Text("\(character.mentalSkills[skill] ?? 0)")
                                        .frame(width: valueWidth, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .padding(.top) // Extra padding to ensure safe area clearance
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Fourth Tab - Disciplines
struct DisciplinesTab: View {
    let character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Disciplines")) {
                if character.disciplines.isEmpty {
                    Text("No disciplines learned")
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                } else {
                    ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { discipline, level in
                        HStack {
                            Text(discipline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            Text("Level \(level)")
                                .foregroundColor(.secondary)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                        }
                    }
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

// Fifth Tab - Advantages and Flaws
struct AdvantagesFlawsTab: View {
    let character: Character
    
    var body: some View {
        Form {
            Section(header: Text("Advantages")) {
                if character.advantages.isEmpty {
                    Text("No advantages recorded")
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                } else {
                    ForEach(character.advantages) { advantage in
                        HStack {
                            Text(advantage.name)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            Spacer()
                            Text("\(advantage.cost) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            if advantage.isCustom {
                                Text("(Custom)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            }
                        }
                    }
                    HStack {
                        Text("Total Cost:")
                            .font(.headline)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                        Spacer()
                        Text("\(character.totalAdvantageCost) pts")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    }
                }
            }
            
            Section(header: Text("Flaws")) {
                if character.flaws.isEmpty {
                    Text("No flaws recorded")
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                } else {
                    ForEach(character.flaws) { flaw in
                        HStack {
                            Text(flaw.name)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            Spacer()
                            Text("\(abs(flaw.cost)) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            if flaw.isCustom {
                                Text("(Custom)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                            }
                        }
                    }
                    HStack {
                        Text("Total Value:")
                            .font(.headline)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                        Spacer()
                        Text("\(abs(character.totalFlawValue)) pts")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    }
                }
            }
            
            if !character.advantages.isEmpty || !character.flaws.isEmpty {
                Section(header: Text("Net Cost")) {
                    HStack {
                        Text("Advantages - Flaws:")
                            .font(.headline)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                        Spacer()
                        Text("\(character.netAdvantageFlawCost) pts")
                            .font(.headline)
                            .foregroundColor(character.netAdvantageFlawCost <= 0 ? .green : .red)
                            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    }
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}
