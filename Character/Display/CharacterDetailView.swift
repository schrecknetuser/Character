import SwiftUI

struct CharacterDetailView: View {
    @Binding var character: any BaseCharacter
    @ObservedObject var store: CharacterStore

    @State private var isEditing = false
    @State private var draftCharacter: BaseCharacter?

    var activeCharacterBinding: Binding<any BaseCharacter> {
        Binding(
            get: { isEditing ? draftCharacter! : character },
            set: { newValue in
                if isEditing {
                    draftCharacter = newValue
                } else {
                    character = newValue
                }
            }
        )
    }

    var body: some View {
        TabView {
            CharacterInfoTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Character")
                }

            if character.characterType == .vampire {
                if let vampire = (isEditing ? draftCharacter : character) as? VampireCharacter {
                    let binding = Binding<VampireCharacter>(
                        get: { vampire },
                        set: { updated in draftCharacter = updated }
                    )
                    VampireStatusTab(character: binding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Status")
                        }
                }
            } else if character.characterType == .ghoul {
                if let ghoul = (isEditing ? draftCharacter : character) as? GhoulCharacter {
                    let binding = Binding<GhoulCharacter>(
                        get: { ghoul },
                        set: { updated in draftCharacter = updated }
                    )
                    GhoulStatusTab(character: binding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Status")
                        }
                }
            } else if character.characterType == .mage {
                if let mage = (isEditing ? draftCharacter : character) as? MageCharacter {
                    let binding = Binding<MageCharacter>(
                        get: { mage },
                        set: { updated in draftCharacter = updated }
                    )
                    MageStatusTab(character: binding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "star.circle.fill")
                            Text("Status")
                        }
                }
            }

            AttributesSkillsTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Attributes & Skills")
                }

            if character.characterType == .vampire {
                if let vampire = (isEditing ? draftCharacter : character) as? VampireCharacter {
                    let binding = Binding<VampireCharacter>(
                        get: { vampire },
                        set: { updated in draftCharacter = updated }
                    )
                    DisciplinesTab(character: binding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "flame.fill")
                            Text("Disciplines")
                        }
                }
            } else if character.characterType == .ghoul {
                if let ghoul = (isEditing ? draftCharacter : character) as? GhoulCharacter {
                    let binding = Binding<GhoulCharacter>(
                        get: { ghoul },
                        set: { updated in draftCharacter = updated }
                    )
                    DisciplinesTab(character: binding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "flame.fill")
                            Text("Disciplines")
                        }
                }
            } else if character.characterType == .mage {
                if let mage = (isEditing ? draftCharacter : character) as? MageCharacter {
                    let binding = Binding<MageCharacter>(
                        get: { mage },
                        set: { updated in draftCharacter = updated }
                    )
                    MageSpheresTab(character: binding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "sparkles")
                            Text("Spheres")
                        }
                }
            }

            AdvantagesFlawsTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Merits & Flaws")
                }

            DataTab(character: activeCharacterBinding, isEditing: $isEditing)
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
                        if let draft = draftCharacter {
                            let summary = character.generateChangeSummary(for: draft)
                            if !summary.isEmpty {
                                let logEntry = ChangeLogEntry(summary: summary)
                                draft.changeLog.append(logEntry)
                            }
                            character = draft
                            store.updateCharacter(character)
                        }
                        draftCharacter = nil
                    } else {
                        draftCharacter = character.clone()
                    }
                    isEditing.toggle()
                }
            }
        }
        .onDisappear {
            if isEditing {
                draftCharacter = nil // Just discard the draft
                isEditing = false
            }
        }
    }
}

