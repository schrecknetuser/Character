import SwiftUI

struct CharacterDetailView: View {
    @Binding var character: Character
    @ObservedObject var store: CharacterStore
    @State private var isEditing = false
    @State private var originalCharacter: Character?

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
                            let changeSummary = generateChangeSummary(from: original, to: character)
                            if !changeSummary.isEmpty {
                                let logEntry = ChangeLogEntry(summary: changeSummary, session: character.currentSession)
                                character.changeLog.append(logEntry)
                            }
                        }
                        // Save changes
                        store.updateCharacter(character)
                        originalCharacter = nil
                    } else {
                        // Starting edit - capture original state
                        originalCharacter = character
                    }
                    isEditing.toggle()
                }
            }
        }
    }
    
    private func generateChangeSummary(from original: Character, to updated: Character) -> String {
        var changes: [String] = []
        
        // Check basic information changes
        if original.name != updated.name {
            changes.append("name changed")
        }
        if original.clan != updated.clan {
            changes.append("clan changed")
        }
        if original.generation != updated.generation {
            changes.append("generation changed")
        }
        
        // Check attribute changes
        for attribute in V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes {
            let originalVal = getAttributeValue(character: original, attribute: attribute)
            let updatedVal = getAttributeValue(character: updated, attribute: attribute)
            if originalVal != updatedVal {
                changes.append("\(attribute.lowercased()) \(originalVal)→\(updatedVal)")
            }
        }
        
        // Check skill changes
        for skill in V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills {
            let originalVal = getSkillValue(character: original, skill: skill)
            let updatedVal = getSkillValue(character: updated, skill: skill)
            if originalVal != updatedVal {
                changes.append("\(skill.lowercased()) \(originalVal)→\(updatedVal)")
            }
        }
        
        // Check core traits
        if original.bloodPotency != updated.bloodPotency {
            changes.append("blood potency \(original.bloodPotency)→\(updated.bloodPotency)")
        }
        if original.humanity != updated.humanity {
            changes.append("humanity \(original.humanity)→\(updated.humanity)")
        }
        if original.hunger != updated.hunger {
            changes.append("hunger \(original.hunger)→\(updated.hunger)")
        }
        if original.experience != updated.experience {
            changes.append("experience \(original.experience)→\(updated.experience)")
        }
        if original.spentExperience != updated.spentExperience {
            changes.append("spent experience \(original.spentExperience)→\(updated.spentExperience)")
        }
        
        // Check discipline changes
        let allDisciplines = Set(original.disciplines.keys).union(Set(updated.disciplines.keys))
        for discipline in allDisciplines {
            let originalVal = original.disciplines[discipline] ?? 0
            let updatedVal = updated.disciplines[discipline] ?? 0
            if originalVal != updatedVal {
                changes.append("\(discipline.lowercased()) \(originalVal)→\(updatedVal)")
            }
        }
        
        // Check advantages/flaws count changes
        if original.advantages.count != updated.advantages.count {
            changes.append("advantages count changed")
        }
        if original.flaws.count != updated.flaws.count {
            changes.append("flaws count changed")
        }
        
        // Check session change
        if original.currentSession != updated.currentSession {
            changes.append("session \(original.currentSession)→\(updated.currentSession)")
        }
        
        if changes.isEmpty {
            return "Minor updates"
        } else if changes.count <= 3 {
            return changes.joined(separator: ", ")
        } else {
            return "\(changes.count) changes: \(changes.prefix(2).joined(separator: ", "))..."
        }
    }
    
    private func getAttributeValue(character: Character, attribute: String) -> Int {
        return character.physicalAttributes[attribute] ?? 
               character.socialAttributes[attribute] ?? 
               character.mentalAttributes[attribute] ?? 0
    }
    
    private func getSkillValue(character: Character, skill: String) -> Int {
        return character.physicalSkills[skill] ?? 
               character.socialSkills[skill] ?? 
               character.mentalSkills[skill] ?? 0
    }
}
