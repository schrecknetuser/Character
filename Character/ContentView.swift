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
                    NavigationLink(destination: CharacterDetailView(character: $store.characters[index], store: store)) {
                        VStack(alignment: .leading) {
                            Text(store.characters[index].name).font(.headline)
                            Text("\(store.characters[index].clan), Gen \(store.characters[index].generation)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Text("BP: \(store.characters[index].bloodPotency)")
                                Text("Humanity: \(store.characters[index].humanity)")
                                Text("Hunger: \(store.characters[index].hunger)")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
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
            .fullScreenCover(isPresented: $showingAddSheet) {
                CharacterCreationWizard(store: store)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
