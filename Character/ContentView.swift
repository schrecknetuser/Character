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
    let isArchiveSection: Bool
    @State private var characterToDelete: (any BaseCharacter)? = nil
    @State private var showingDeleteConfirmation = false

    var body: some View {
        Group {
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
                            .swipeActions(edge: .trailing) {
                                Button {
                                    characterToDelete = character
                                    showingDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                if !character.isArchived {
                                    Button {
                                        store.archiveCharacter(character)
                                    } label: {
                                        Label("Archive", systemImage: "archivebox")
                                    }
                                    .tint(.orange)
                                } else {
                                    Button {
                                        store.unarchiveCharacter(character)
                                    } label: {
                                        Label("Unarchive", systemImage: "archivebox.fill")
                                    }
                                    .tint(.green)
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
                            .swipeActions(edge: .trailing) {
                                Button {
                                    characterToDelete = character
                                    showingDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                if !character.isArchived {
                                    Button {
                                        store.archiveCharacter(character)
                                    } label: {
                                        Label("Archive", systemImage: "archivebox")
                                    }
                                    .tint(.orange)
                                } else {
                                    Button {
                                        store.unarchiveCharacter(character)
                                    } label: {
                                        Label("Unarchive", systemImage: "archivebox.fill")
                                    }
                                    .tint(.green)
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
        .alert("Delete Character", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let character = characterToDelete {
                    deleteCharacter(character)
                }
                characterToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                characterToDelete = nil
            }
        } message: {
            if let character = characterToDelete {
                Text("Are you sure you want to delete \(character.name)? This action cannot be undone.")
            }
        }
    }
    
    private func deleteCharacter(_ character: any BaseCharacter) {
        if let index = store.characters.firstIndex(where: { $0.id == character.id }) {
            store.deleteCharacter(at: IndexSet([index]))
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
    @State private var showArchived: Bool = false
    @State private var expandedArchivedChronicles: [String: Bool] = [:]
    @State private var showingCreationWizard = false
    @State private var characterToResume: (any BaseCharacter)? = nil
    let getCharacterDisplayInfo: (any BaseCharacter) -> (symbol: String, additionalInfo: String)

    var body: some View {
        List {
            // Characters in creation section
            let charactersInCreation = store.getCharactersInCreation()
            if !charactersInCreation.isEmpty {
                Section {
                    ForEach(charactersInCreation.indices, id: \.self) { index in
                        let character = charactersInCreation[index].character
                        let displayInfo = getCharacterDisplayInfo(character)
                        
                        Button(action: {
                            characterToResume = character
                            showingCreationWizard = true
                        }) {
                            HStack {
                                CharacterRow(character: character, displayInfo: displayInfo)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("In Creation")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                    Text("Stage \(character.creationProgress + 1)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .onDelete { offsets in
                        let charactersToDelete = offsets.map { charactersInCreation[$0].id }
                        let indicesToDelete = IndexSet(store.characters.enumerated().compactMap { index, character in
                            charactersToDelete.contains(character.id) ? index : nil
                        })
                        store.deleteCharacter(at: indicesToDelete)
                    }
                } header: {
                    Text("Characters in Creation")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
            
            // Active characters grouped by chronicle
            ForEach(groupedActiveCharacters(), id: \.chronicleName) { group in
                // Ensure default expanded state before the view
                let _ = ensureChronicleHasDefaultState(group.chronicleName)

                CharacterGroupSection(
                    group: group,
                    store: store,
                    isExpanded: Binding(
                        get: { expandedChronicles[group.chronicleName] ?? true },
                        set: { expandedChronicles[group.chronicleName] = $0 }
                    ),
                    isArchiveSection: false
                )
            }
            
            // Archive section
            let archivedCharacterGroups = groupedArchivedCharacters()
            if !archivedCharacterGroups.isEmpty {
                let totalArchivedCount = archivedCharacterGroups.reduce(0) { $0 + $1.characters.count }
                DisclosureGroup(isExpanded: $showArchived) {
                    ForEach(archivedCharacterGroups, id: \.chronicleName) { group in
                        // Ensure default expanded state for archived chronicles
                        let _ = ensureArchivedChronicleHasDefaultState(group.chronicleName)
                        
                        CharacterGroupSection(
                            group: group,
                            store: store,
                            isExpanded: Binding(
                                get: { expandedArchivedChronicles[group.chronicleName] ?? true },
                                set: { expandedArchivedChronicles[group.chronicleName] = $0 }
                            ),
                            isArchiveSection: true
                        )
                    }
                } label: {
                    HStack {
                        Text("Archive")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(totalArchivedCount)")
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
        .fullScreenCover(isPresented: $showingCreationWizard) {
            CharacterCreationWizard(store: store, existingCharacter: characterToResume)
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
    
    @discardableResult
    private func ensureArchivedChronicleHasDefaultState(_ chronicleName: String) -> Bool {
        if expandedArchivedChronicles[chronicleName] == nil {
            expandedArchivedChronicles[chronicleName] = true
            return true
        }
        return false
    }

    private func groupedActiveCharacters() -> [(chronicleName: String, characters: [AnyCharacter])] {
        let activeCharacters = store.getCompletedCharacters().filter { !$0.character.isArchived }
        return groupCharacters(activeCharacters)
    }
    
    private func groupedArchivedCharacters() -> [(chronicleName: String, characters: [AnyCharacter])] {
        let archivedCharacters = store.getCompletedCharacters().filter { $0.character.isArchived }
        return groupCharacters(archivedCharacters)
    }
    
    private func groupCharacters(_ characters: [AnyCharacter]) -> [(chronicleName: String, characters: [AnyCharacter])] {
        let charactersByChronicle = Dictionary(grouping: characters) { character in
            let normalizedName = character.character.chronicleName.trimmingCharacters(in: .whitespacesAndNewlines)
            return normalizedName.isEmpty ? "" : normalizedName
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
            // Use the first character's original chronicle name for display to preserve formatting
            let displayName = characters.first?.character.chronicleName.trimmingCharacters(in: .whitespacesAndNewlines) ?? chronicleName
            result.append((chronicleName: displayName, characters: characters))
        }

        return result
    }
}


struct ContentView: View {
    @StateObject private var store = CharacterStore()
    @State private var showingAddSheet = false
    @State private var showingQRScanner = false
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

    var body: some View {
        NavigationStack {
            CharacterListView(
                store: store,
                expandedChronicles: $expandedChronicles,
                getCharacterDisplayInfo: getCharacterDisplayInfo
            )
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingQRScanner = true }) {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    .accessibilityLabel("Import Character")
                    .accessibilityHint("Scan QR code to import character")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingAddSheet) {
                CharacterCreationWizard(store: store)
            }
            .fullScreenCover(isPresented: $showingQRScanner) {
                QRScannerModalView(isPresented: $showingQRScanner, store: store)
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
