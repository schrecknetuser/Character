import SwiftUI

struct CharacterDetailView: View {
    @Binding var character: any BaseCharacter
    @ObservedObject var store: CharacterStore
    @State private var isEditing = false
    @State private var originalCharacter: BaseCharacter?

    var body: some View {
        TabView {
            // First Tab - Character Information
            CharacterInfoTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Character")
                }
            
            // Second Tab - Status
            if character.characterType == .vampire {
                let vampireBinding = Binding<VampireCharacter>(
                    get: { character as! VampireCharacter },
                    set: { character = $0 }
                )
                
                VampireStatusTab(character: vampireBinding, isEditing: $isEditing)
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Status")
                    }
            } else if character.characterType == .ghoul {
                let ghoulBinding = Binding<GhoulCharacter>(
                    get: { character as! GhoulCharacter },
                    set: { character = $0 }
                )
                
                GhoulStatusTab(character: ghoulBinding, isEditing: $isEditing)
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Status")
                    }
            } else if character.characterType == .mage {
                let mageBinding = Binding<MageCharacter>(
                    get: { character as! MageCharacter },
                    set: { character = $0 }
                )
                
                MageStatusTab(character: mageBinding, isEditing: $isEditing)
                    .tabItem {
                        Image(systemName: "star.circle.fill")
                        Text("Status")
                    }
            }
            
            
            // Third Tab - Attributes and Skills
            AttributesSkillsTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Attributes & Skills")
                }
            
            // Fourth Tab - Disciplines/Spheres
            if character.characterType == .vampire {
                
                let vampireBinding = Binding<VampireCharacter>(
                    get: { character as! VampireCharacter },
                    set: { character = $0 }
                )
                
                DisciplinesTab(character: vampireBinding, isEditing: $isEditing)
                    .tabItem {
                        Image(systemName: "flame.fill")
                        Text("Disciplines")
                    }
            } else if character.characterType == .ghoul {
                
                let ghoulBinding = Binding<GhoulCharacter>(
                    get: { character as! GhoulCharacter },
                    set: { character = $0 }
                )
                
                DisciplinesTab(character: ghoulBinding, isEditing: $isEditing)
                    .tabItem {
                        Image(systemName: "flame.fill")
                        Text("Disciplines")
                    }
            } else if character.characterType == .mage {
                
                let mageBinding = Binding<MageCharacter>(
                    get: { character as! MageCharacter },
                    set: { character = $0 }
                )
                
                MageSpheresTab(character: mageBinding, isEditing: $isEditing)
                    .tabItem {
                        Image(systemName: "sparkles")
                        Text("Spheres")
                    }
            }
            
            // Fifth Tab - Merits and Flaws
            AdvantagesFlawsTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Merits & Flaws")
                }
            
            // Sixth Tab - Data
            DataTab(character: $character, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Data")
                }

        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        // Generate change summary and log it
                        if let original = originalCharacter {
                            let changeSummary = original.generateChangeSummary(for: character)
                            if !changeSummary.isEmpty {
                                let logEntry = ChangeLogEntry(summary: changeSummary)
                                character.changeLog.append(logEntry)
                            }
                        }
                        // Save changes
                        store.updateCharacter(character)
                        originalCharacter = nil
                    } else {
                        // Starting edit - capture original state
                        originalCharacter = character.clone()
                    }
                    isEditing.toggle()
                }
            }
        }
    }
    
}
