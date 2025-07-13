import SwiftUI

struct CharacterDetailView: View {
    @Binding var character: any BaseCharacter
    @ObservedObject var store: CharacterStore

    @State private var isEditing = false
    @State private var draftCharacter: BaseCharacter?
    @State private var selectedTab = 0

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
    
    // Helper function to get available tabs for the current character type
    private var availableTabs: [String] {
        var tabs = ["Character"]
        
        switch character.characterType {
        case .vampire:
            tabs.append("Status")
        case .ghoul:
            tabs.append("Status")
        case .mage:
            tabs.append("Status")
        }
        
        tabs.append("Attributes & Skills")
        
        switch character.characterType {
        case .vampire:
            tabs.append("Disciplines")
        case .ghoul:
            tabs.append("Disciplines")
        case .mage:
            tabs.append("Spheres")
        }
        
        tabs.append("Merits & Flaws")
        tabs.append("Data")
        
        return tabs
    }
    
    // Helper function to handle swipe gestures
    private func handleSwipe(direction: SwipeDirection) {
        let maxTabIndex = availableTabs.count - 1
        
        switch direction {
        case .left:
            // Swipe left moves to next tab (right)
            if selectedTab < maxTabIndex {
                selectedTab += 1
            }
        case .right:
            // Swipe right moves to previous tab (left)
            if selectedTab > 0 {
                selectedTab -= 1
            }
        }
    }
    
    private enum SwipeDirection {
        case left, right
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            CharacterInfoTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Character")
                }
                .tag(0)

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
                        .tag(1)
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
                        .tag(1)
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
                        .tag(1)
                }
            }

            AttributesSkillsTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Attributes & Skills")
                }
                .tag(2)

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
                        .tag(3)
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
                        .tag(3)
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
                        .tag(3)
                }
            }

            AdvantagesFlawsTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Merits & Flaws")
                }
                .tag(4)

            DataTab(character: activeCharacterBinding, isEditing: $isEditing)
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Data")
                }
                .tag(5)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    // Only process horizontal swipes (more horizontal than vertical movement)
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        if horizontalAmount > 50 {
                            // Swipe right (previous tab)
                            handleSwipe(direction: .right)
                        } else if horizontalAmount < -50 {
                            // Swipe left (next tab)
                            handleSwipe(direction: .left)
                        }
                    }
                }
        )
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

