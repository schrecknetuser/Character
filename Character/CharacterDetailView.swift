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
