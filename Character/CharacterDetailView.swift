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
    
    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                HStack {
                    Text("Name:")
                        .fontWeight(.medium)
                    Spacer()
                    Text(character.name)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                if !character.chronicleName.isEmpty {
                    HStack {
                        Text("Chronicle:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(character.chronicleName)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            
            Section(header: Text("Character Background")) {
                if !character.ambition.isEmpty {
                    HStack {
                        Text("Ambition:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(character.ambition)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                if !character.desire.isEmpty {
                    HStack {
                        Text("Desire:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(character.desire)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            
            Section(header: Text("Convictions")) {
                if character.convictions.isEmpty {
                    Text("No convictions recorded")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.convictions, id: \.self) { conviction in
                        Text(conviction)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            
            Section(header: Text("Touchstones")) {
                if character.touchstones.isEmpty {
                    Text("No touchstones recorded")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.touchstones, id: \.self) { touchstone in
                        Text(touchstone)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
            
            Section(header: Text("Experience")) {
                HStack {
                    Text("Total Experience:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(character.experience)")
                }
                HStack {
                    Text("Spent Experience:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(character.spentExperience)")
                }
                HStack {
                    Text("Available Experience:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(character.experience - character.spentExperience)")
                }
            }
        }
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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                // Attributes Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Attributes")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(alignment: .top, spacing: 20) {
                        // Physical Attributes Column
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Physical")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Text("\(character.physicalAttributes[attribute] ?? 0)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(width: 25, alignment: .center)
                                        .padding(.horizontal, 6)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Social Attributes Column
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Social")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Text("\(character.socialAttributes[attribute] ?? 0)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(width: 25, alignment: .center)
                                        .padding(.horizontal, 6)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Mental Attributes Column
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mental")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Text("\(character.mentalAttributes[attribute] ?? 0)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(width: 25, alignment: .center)
                                        .padding(.horizontal, 6)
                                        .background(Color.gray.opacity(0.2))
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
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(alignment: .top, spacing: 20) {
                        // Physical Skills Column
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Physical")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Text("\(character.physicalSkills[skill] ?? 0)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(width: 25, alignment: .center)
                                        .padding(.horizontal, 6)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Social Skills Column
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Social")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(V5Constants.socialSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Text("\(character.socialSkills[skill] ?? 0)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(width: 25, alignment: .center)
                                        .padding(.horizontal, 6)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Mental Skills Column
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mental")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    Spacer()
                                    Text("\(character.mentalSkills[skill] ?? 0)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(width: 25, alignment: .center)
                                        .padding(.horizontal, 6)
                                        .background(Color.gray.opacity(0.2))
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
        }
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
                    } else {
                        ForEach(character.disciplines.sorted(by: { $0.key < $1.key }), id: \.key) { discipline, level in
                            HStack {
                                Text(discipline)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                Text("Level \(level)")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
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
                    } else {
                        ForEach(character.advantages) { advantage in
                            HStack {
                                Text(advantage.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                if advantage.isCustom {
                                    Text("(Custom)")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                Text("\(advantage.cost) pts")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        HStack {
                            Text("Total Cost:")
                                .font(.headline)
                            Spacer()
                            Text("\(character.totalAdvantageCost) pts")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Section(header: Text("Flaws")) {
                    if character.flaws.isEmpty {
                        Text("No flaws recorded")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(character.flaws) { flaw in
                            HStack {
                                Text(flaw.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                                if flaw.isCustom {
                                    Text("(Custom)")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                Text("\(abs(flaw.cost)) pts")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        HStack {
                            Text("Total Value:")
                                .font(.headline)
                            Spacer()
                            Text("\(abs(character.totalFlawValue)) pts")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                if !character.advantages.isEmpty || !character.flaws.isEmpty {
                    Section(header: Text("Net Cost")) {
                        HStack {
                            Text("Advantages - Flaws:")
                                .font(.headline)
                            Spacer()
                            Text("\(character.netAdvantageFlawCost) pts")
                                .font(.headline)
                                .foregroundColor(character.netAdvantageFlawCost <= 0 ? .green : .red)
                        }
                    }
                }
            }
        }
    }
}
