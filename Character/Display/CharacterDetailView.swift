import SwiftUI

struct CharacterDetailView: View {
    @Binding var character: any BaseCharacter
    @ObservedObject var store: CharacterStore
    
    @State private var isEditing = false
    @State private var draftCharacter: (any BaseCharacter)?
    @State private var selectedTab = 0
    @State private var showingStatusModal = false
    @State private var showingDataModal = false
    
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
    
    // Helper function to get available tabs for the current character type (excluding Status and Data)
    private var availableTabs: [String] {
        var tabs = ["Character"]
        
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
        tabs.append("Background")
        
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
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $selectedTab) {
                    CharacterInfoTab(character: activeCharacterBinding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Character")
                        }
                        .tag(0)
                    
                    AttributesSkillsTab(character: activeCharacterBinding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "brain.head.profile")
                            Text("Attributes & Skills")
                        }
                        .tag(1)
                    
                    if character.characterType == .vampire {
                        if let vampire = (isEditing ? draftCharacter : character) as? VampireCharacter {
                            let binding = Binding<VampireCharacter>(
                                get: { vampire },
                                set: { updated in draftCharacter = updated }
                            )
                            V5DisciplinesTab(character: binding, isEditing: $isEditing)
                                .tabItem {
                                    Image(systemName: "flame.fill")
                                    Text("Disciplines")
                                }
                                .tag(2)
                        }
                    } else if character.characterType == .ghoul {
                        if let ghoul = (isEditing ? draftCharacter : character) as? GhoulCharacter {
                            let binding = Binding<GhoulCharacter>(
                                get: { ghoul },
                                set: { updated in draftCharacter = updated }
                            )
                            V5DisciplinesTab(character: binding, isEditing: $isEditing)
                                .tabItem {
                                    Image(systemName: "flame.fill")
                                    Text("Disciplines")
                                }
                                .tag(2)
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
                                .tag(2)
                        }
                    }
                    
                    AdvantagesFlawsTab(character: activeCharacterBinding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "star.fill")
                            Text("Merits & Flaws")
                        }
                        .tag(3)
                    
                    CharacterBackgroundTab(character: activeCharacterBinding, isEditing: $isEditing)
                        .tabItem {
                            Image(systemName: "doc.text.fill")
                            Text("Background")
                        }
                        .tag(4)
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
                
                // Floating Action Buttons
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack {
                            // Status Button
                            Button(action: {
                                showingStatusModal = true
                            }) {
                                Image(systemName: "heart.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: UIConstants.floatingButtonSize, height: UIConstants.floatingButtonSize)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .accessibilityLabel("Status")
                            .accessibilityHint("Opens character status for editing")
                            
                            // Data Button
                            Button(action: {
                                showingDataModal = true
                            }) {
                                Image(systemName: "doc.text.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: UIConstants.floatingButtonSize, height: UIConstants.floatingButtonSize)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .accessibilityLabel("Data")
                            .accessibilityHint("Shows character data and change log")
                        }
                        .padding(.trailing, UIConstants.screenEdgeSpacing)
                        .padding(.bottom, UIConstants.floatingButtonBottomPadding())
                    }
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
            .fullScreenCover(isPresented: $showingStatusModal) {
                StatusModalView(character: activeCharacterBinding, isPresented: $showingStatusModal, store: store)
            }
            .sheet(isPresented: $showingDataModal) {
                DataModalView(character: activeCharacterBinding, isPresented: $showingDataModal)
            }
            .onDisappear {
                if isEditing {
                    draftCharacter = nil // Just discard the draft
                    isEditing = false
                }
            }
        }
    }
}
