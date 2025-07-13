//
//  ContentView.swift
//  Character
//
//  Created by User on 10.07.2025.
//

import SwiftUI

struct CharacterGroupSection: View {
    let group: (chronicleName: String, characters: [AnyCharacter])
    @ObservedObject var store: CharacterStore
    @Binding var isExpanded: Bool

    var body: some View {
        if group.chronicleName.isEmpty {
            Section {
                ForEach(group.characters.indices, id: \.self) { index in
                    let characterId = group.characters[index].id
                    if let characterIndex = store.characters.firstIndex(where: { $0.id == characterId }) {
                        let character = store.characters[characterIndex].character
                        let characterBinding = $store.characters[characterIndex].character
                        let displayInfo = getCharacterDisplayInfo(character)

                        NavigationLink(destination: CharacterDetailView(character: characterBinding, store: store)) {
                            CharacterRow(character: character, displayInfo: displayInfo)
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
            } header: {
                Text("No Chronicle")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        } else {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(group.characters.indices, id: \.self) { index in
                    let characterId = group.characters[index].id
                    if let characterIndex = store.characters.firstIndex(where: { $0.id == characterId }) {
                        let character = store.characters[characterIndex].character
                        let characterBinding = $store.characters[characterIndex].character
                        let displayInfo = getCharacterDisplayInfo(character)

                        NavigationLink(destination: CharacterDetailView(character: characterBinding, store: store)) {
                            CharacterRow(character: character, displayInfo: displayInfo)
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

    private func getCharacterDisplayInfo(_ character: any BaseCharacter) -> (symbol: String, additionalInfo: String) {
        switch character.characterType {
        case .vampire:
            let vampire = character as! VampireCharacter
            let clan = vampire.clan.isEmpty ? "No Clan" : vampire.clan
            return ("🧛", "\(clan)")
        case .mage:
            let mage = character as! MageCharacter
            //let areteInfo = "Arete \(mage.arete)"
            return ("🔮", "")
        case .ghoul:
            let ghoul = character as! GhoulCharacter
            //let humanityInfo = "Humanity \(ghoul.humanity)"
            return ("🧟", "")
        }
    }
}

struct CharacterRow: View {
    let character: any BaseCharacter
    let displayInfo: (symbol: String, additionalInfo: String)

    var body: some View {
        HStack {
            Text(displayInfo.symbol)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(character.name).font(.headline)
                HStack {
                    if !displayInfo.additionalInfo.isEmpty {
                        Text("\(displayInfo.additionalInfo)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
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

struct CharacterListView: View {
    @ObservedObject var store: CharacterStore
    @Binding var expandedChronicles: [String: Bool]
    let getCharacterDisplayInfo: (any BaseCharacter) -> (symbol: String, additionalInfo: String)

    var body: some View {
        List {
            ForEach(groupedCharacters(), id: \.chronicleName) { group in
                // Ensure default expanded state before the view
                let _ = ensureChronicleHasDefaultState(group.chronicleName)

                CharacterGroupSection(
                    group: group,
                    store: store,
                    isExpanded: Binding(
                        get: { expandedChronicles[group.chronicleName] ?? true },
                        set: { expandedChronicles[group.chronicleName] = $0 }
                    )
                )
            }
        }
    }
    
    @discardableResult
    private func ensureChronicleHasDefaultState(_ chronicleName: String) -> Bool {
        if expandedChronicles[chronicleName] == nil {
            expandedChronicles[chronicleName] = true
            return true
        }
        return false
    }

    private func groupedCharacters() -> [(chronicleName: String, characters: [AnyCharacter])] {
        let charactersByChronicle = Dictionary(grouping: store.characters) { character in
            character.character.chronicleName.isEmpty ? "" : character.character.chronicleName
        }

        let emptyChronicleCharacters = charactersByChronicle[""] ?? []
        let namedChronicles = charactersByChronicle.filter { $0.key != "" }

        let sortedEmptyChronicle = emptyChronicleCharacters.sorted { $0.character.name < $1.character.name }

        var result: [(chronicleName: String, characters: [AnyCharacter])] = []

        if !sortedEmptyChronicle.isEmpty {
            result.append((chronicleName: "", characters: sortedEmptyChronicle))
        }

        let sortedChronicleNames = namedChronicles.keys.sorted()
        for chronicleName in sortedChronicleNames {
            let characters = namedChronicles[chronicleName]!.sorted { $0.character.name < $1.character.name }
            result.append((chronicleName: chronicleName, characters: characters))
        }

        return result
    }
}


struct ContentView: View {
    @StateObject private var store = CharacterStore()
    @State private var showingAddSheet = false
    @State private var expandedGroups: Set<String> = []
    @State private var expandedChronicles: [String: Bool] = [:]
    private let chronicleExpansionKey = "chronicleExpansionState"

    private func saveExpandedChronicles() {
        let boolsAsInts = expandedChronicles.mapValues { $0 ? 1 : 0 }
        UserDefaults.standard.set(boolsAsInts, forKey: chronicleExpansionKey)
    }

    private func loadExpandedChronicles() {
        if let stored = UserDefaults.standard.dictionary(forKey: chronicleExpansionKey) as? [String: Int] {
            expandedChronicles = stored.mapValues { $0 != 0 }
        }
    }
    
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
        NavigationStack {
            CharacterListView(
                store: store,
                expandedChronicles: $expandedChronicles,
                getCharacterDisplayInfo: getCharacterDisplayInfo
            )
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
            loadExpandedChronicles()
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .onChange(of: expandedChronicles) {
            saveExpandedChronicles()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
