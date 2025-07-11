import SwiftUI

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
