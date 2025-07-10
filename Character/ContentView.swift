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
                ForEach(store.characters) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        VStack(alignment: .leading) {
                            Text(character.name).font(.headline)
                            Text("\(character.clan), Gen \(character.generation)").font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: store.deleteCharacter)
            }
            .navigationTitle("V5 Characters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddCharacterView(store: store)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
