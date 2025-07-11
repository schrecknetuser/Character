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
                            HStack {
                                Text(store.characters[index].characterType.displayName)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                                Spacer()
                            }
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
