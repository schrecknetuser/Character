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
                Text("Name: \(character.name)")
                if !character.chronicleName.isEmpty {
                    Text("Chronicle: \(character.chronicleName)")
                }
            }
            
            Section(header: Text("Character Background")) {
                if !character.ambition.isEmpty {
                    Text("Ambition: \(character.ambition)")
                }
                if !character.desire.isEmpty {
                    Text("Desire: \(character.desire)")
                }
            }
            
            Section(header: Text("Convictions")) {
                if character.convictions.isEmpty {
                    Text("No convictions recorded")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.convictions, id: \.self) { conviction in
                        Text(conviction)
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
                    }
                }
            }
            
            Section(header: Text("Experience")) {
                Text("Total Experience: \(character.experience)")
                Text("Spent Experience: \(character.spentExperience)")
                Text("Available Experience: \(character.experience - character.spentExperience)")
            }
        }
    }
}

// Second Tab - Status
struct StatusTab: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                StatusRowView(title: "Health", healthStates: character.healthStates)
                
                StatusRowView(title: "Willpower", healthStates: character.willpowerStates)
                
                StatusRowView(title: "Humanity", humanityStates: character.humanityStates)
            }
            .padding()
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
                                .foregroundColor(.blue)
                            
                            ForEach(V5Constants.physicalAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(character.physicalAttributes[attribute] ?? 0)")
                                        .frame(width: 30, alignment: .center)
                                        .padding(.horizontal, 8)
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
                                .foregroundColor(.green)
                            
                            ForEach(V5Constants.socialAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(character.socialAttributes[attribute] ?? 0)")
                                        .frame(width: 30, alignment: .center)
                                        .padding(.horizontal, 8)
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
                                .foregroundColor(.purple)
                            
                            ForEach(V5Constants.mentalAttributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(character.mentalAttributes[attribute] ?? 0)")
                                        .frame(width: 30, alignment: .center)
                                        .padding(.horizontal, 8)
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
                                .foregroundColor(.blue)
                            
                            ForEach(V5Constants.physicalSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(character.physicalSkills[skill] ?? 0)")
                                        .frame(width: 30, alignment: .center)
                                        .padding(.horizontal, 8)
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
                                .foregroundColor(.green)
                            
                            ForEach(V5Constants.socialSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(character.socialSkills[skill] ?? 0)")
                                        .frame(width: 30, alignment: .center)
                                        .padding(.horizontal, 8)
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
                                .foregroundColor(.purple)
                            
                            ForEach(V5Constants.mentalSkills, id: \.self) { skill in
                                HStack {
                                    Text(skill)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(character.mentalSkills[skill] ?? 0)")
                                        .frame(width: 30, alignment: .center)
                                        .padding(.horizontal, 8)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Level \(level)")
                                .foregroundColor(.secondary)
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
                    ForEach(character.advantages, id: \.self) { advantage in
                        Text(advantage)
                    }
                }
            }
            
            Section(header: Text("Flaws")) {
                if character.flaws.isEmpty {
                    Text("No flaws recorded")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.flaws, id: \.self) { flaw in
                        Text(flaw)
                    }
                }
            }
        }
    }
}
