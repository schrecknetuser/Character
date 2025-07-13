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
        .onDisappear {
            // If user leaves the character detail view while editing without saving,
            // discard unsaved changes by restoring the original character
            if isEditing && originalCharacter != nil {
                discardUnsavedChanges()
            }
        }
    }
    
    private func discardUnsavedChanges() {
        guard let original = originalCharacter else { return }
        
        // Restore the character to its original state
        restoreCharacter(from: original)
        
        // Clear the original character reference and exit editing mode
        originalCharacter = nil
        isEditing = false
    }
    
    private func restoreCharacter(from original: any BaseCharacter) {
        // Restore all basic properties from the original character
        character.name = original.name
        character.physicalAttributes = original.physicalAttributes
        character.socialAttributes = original.socialAttributes
        character.mentalAttributes = original.mentalAttributes
        character.physicalSkills = original.physicalSkills
        character.socialSkills = original.socialSkills
        character.mentalSkills = original.mentalSkills
        character.willpower = original.willpower
        character.experience = original.experience
        character.spentExperience = original.spentExperience
        character.ambition = original.ambition
        character.desire = original.desire
        character.chronicleName = original.chronicleName
        character.concept = original.concept
        character.advantages = original.advantages
        character.flaws = original.flaws
        character.convictions = original.convictions
        character.touchstones = original.touchstones
        character.specializations = original.specializations
        character.currentSession = original.currentSession
        character.changeLog = original.changeLog
        character.health = original.health
        character.healthStates = original.healthStates
        character.willpowerStates = original.willpowerStates
        
        // Handle character-type specific properties
        switch character.characterType {
        case .vampire:
            if let vampireChar = character as? VampireCharacter,
               let originalVampire = original as? VampireCharacter {
                vampireChar.clan = originalVampire.clan
                vampireChar.generation = originalVampire.generation
                vampireChar.bloodPotency = originalVampire.bloodPotency
                vampireChar.hunger = originalVampire.hunger
                vampireChar.humanity = originalVampire.humanity
                vampireChar.humanityStates = originalVampire.humanityStates
                vampireChar.disciplines = originalVampire.disciplines
            }
        case .mage:
            if let mageChar = character as? MageCharacter,
               let originalMage = original as? MageCharacter {
                mageChar.spheres = originalMage.spheres
                mageChar.paradox = originalMage.paradox
                mageChar.hubris = originalMage.hubris
                mageChar.quiet = originalMage.quiet
                mageChar.arete = originalMage.arete
                mageChar.hubrisStates = originalMage.hubrisStates
                mageChar.quietStates = originalMage.quietStates
                mageChar.paradigm = originalMage.paradigm
                mageChar.practice = originalMage.practice
                mageChar.instruments = originalMage.instruments
            }
        case .ghoul:
            if let ghoulChar = character as? GhoulCharacter,
               let originalGhoul = original as? GhoulCharacter {
                ghoulChar.humanity = originalGhoul.humanity
                ghoulChar.humanityStates = originalGhoul.humanityStates
                ghoulChar.disciplines = originalGhoul.disciplines
            }
        }
    }
}
