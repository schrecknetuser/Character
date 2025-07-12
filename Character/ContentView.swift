//
//  ContentView.swift
//  Character
//
//  Created by User on 10.07.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var store = CharacterStore()
    @State private var showingAddSheet = false
    
    // Helper function to get character symbol and additional info
    private func getCharacterDisplayInfo(_ character: any BaseCharacter) -> (symbol: String, additionalInfo: String) {
        switch character.characterType {
        case .vampire:
            let vampire = character as! VampireCharacter
            let clan = vampire.clan.isEmpty ? "No Clan" : vampire.clan
            return ("🧛", "Clan: \(clan)")
        case .mage:
            let mage = character as! MageCharacter
            let areteInfo = "Arete \(mage.arete)"
            return ("🔮", areteInfo)
        case .ghoul:
            let ghoul = character as! GhoulCharacter
            let humanityInfo = "Humanity \(ghoul.humanity)"
            return ("🧟", humanityInfo)
        }
    }

    // Helper function to group characters by chronicle
    private func groupedCharacters() -> [(chronicleName: String, characters: [AnyCharacter])] {
        let charactersByChronicle = Dictionary(grouping: store.characters) { character in
            character.character.chronicleName.isEmpty ? "" : character.character.chronicleName
        }
        
        // Separate empty chronicle and named chronicles
        let emptyChronicleCharacters = charactersByChronicle[""] ?? []
        let namedChronicles = charactersByChronicle.filter { $0.key != "" }
        
        // Sort characters within each group alphabetically
        let sortedEmptyChronicle = emptyChronicleCharacters.sorted { $0.character.name < $1.character.name }
        
        var result: [(chronicleName: String, characters: [AnyCharacter])] = []
        
        // Add empty chronicle group first if it exists
        if !sortedEmptyChronicle.isEmpty {
            result.append((chronicleName: "", characters: sortedEmptyChronicle))
        }
        
        // Sort chronicle names alphabetically and add their characters
        let sortedChronicleNames = namedChronicles.keys.sorted()
        for chronicleName in sortedChronicleNames {
            let characters = namedChronicles[chronicleName]!.sorted { $0.character.name < $1.character.name }
            result.append((chronicleName: chronicleName, characters: characters))
        }
        
        return result
    }

    var body: some View {
        NavigationView {
            List {
                let groups = groupedCharacters()
                
                ForEach(groups.indices, id: \.self) { groupIndex in
                    let group = groups[groupIndex]
                    
                    if group.chronicleName.isEmpty {
                        // Characters without chronicle - display directly without grouping
                        Section {
                            ForEach(group.characters.indices, id: \.self) { index in
                                let characterIndex = store.characters.firstIndex { $0.id == group.characters[index].id }!
                                let character = store.characters[characterIndex].character
                                let characterBinding = $store.characters[characterIndex].character
                                let displayInfo = getCharacterDisplayInfo(character)
                                
                                NavigationLink(destination: CharacterDetailView(character: characterBinding, store: store)) {
                                    HStack {
                                        Text(displayInfo.symbol)
                                            .font(.title2)
                                        VStack(alignment: .leading) {
                                            Text(character.name).font(.headline)
                                            HStack {
                                                Text("\(character.characterType.displayName)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Text("• \(displayInfo.additionalInfo)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                if !character.concept.isEmpty {
                                                    Text("• \(character.concept)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } header: {
                            if !groups.first(where: { !$0.chronicleName.isEmpty })?.chronicleName.isEmpty ?? true {
                                Text("No Chronicle")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        }
                        .onDelete { offsets in
                            let charactersToDelete = offsets.map { group.characters[$0].id }
                            let indicesToDelete = IndexSet(store.characters.enumerated().compactMap { index, character in
                                charactersToDelete.contains(character.id) ? index : nil
                            })
                            store.deleteCharacter(at: indicesToDelete)
                        }
                    } else {
                        // Named chronicle - use DisclosureGroup for collapsibility
                        DisclosureGroup {
                            ForEach(group.characters.indices, id: \.self) { index in
                                let characterIndex = store.characters.firstIndex { $0.id == group.characters[index].id }!
                                let character = store.characters[characterIndex].character
                                let characterBinding = $store.characters[characterIndex].character
                                let displayInfo = getCharacterDisplayInfo(character)
                                
                                NavigationLink(destination: CharacterDetailView(character: characterBinding, store: store)) {
                                    HStack {
                                        Text(displayInfo.symbol)
                                            .font(.title2)
                                        VStack(alignment: .leading) {
                                            Text(character.name).font(.headline)
                                            HStack {
                                                Text("\(character.characterType.displayName)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Text("• \(displayInfo.additionalInfo)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                if !character.concept.isEmpty {
                                                    Text("• \(character.concept)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .onDelete { offsets in
                                let charactersToDelete = offsets.map { group.characters[$0].id }
                                let indicesToDelete = IndexSet(store.characters.enumerated().compactMap { index, character in
                                    charactersToDelete.contains(character.id) ? index : nil
                                })
                                store.deleteCharacter(at: indicesToDelete)
                            }
                        } label: {
                            HStack {
                                Text(group.chronicleName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(group.characters.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.secondary.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingAddSheet) {
                CharacterCreationWizard(store: store)
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
