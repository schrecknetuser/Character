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

    var body: some View {
        NavigationView {
            List {
                ForEach(store.characters.indices, id: \.self) { index in
                    let character = store.characters[index].character
                    let characterBinding = $store.characters[index].character
                    NavigationLink(destination: CharacterDetailView(character: characterBinding, store: store)) {
                        VStack(alignment: .leading) {
                            Text(character.name).font(.headline)
                            Text("\(character.characterType.displayName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: store.deleteCharacter)
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
