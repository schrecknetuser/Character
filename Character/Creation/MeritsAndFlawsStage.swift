import SwiftUI

struct MeritsAndFlawsStage: View {
    @Binding var character: any BaseCharacter
    @State private var refreshID = UUID()
    
    var body: some View {
        Form {
            Section(header: Text("Merits")) {
                if character.advantages.isEmpty {
                    Text("No merits selected")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.advantages) { merit in
                        HStack {
                            Text(merit.name)
                            Spacer()
                            Text("\(merit.cost) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button("Remove") {
                                character.advantages.removeAll { $0.id == merit.id }
                                refresh()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        Text("Total Cost:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(character.advantages.reduce(0) { $0 + $1.cost }) pts")
                            .fontWeight(.semibold)
                    }
                }
                
                CreationMeritsListView(selectedMerits: $character.advantages, characterType: character.characterType)
            }
            
            Section(header: Text("Flaws")) {
                if character.flaws.isEmpty {
                    Text("No flaws selected")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.flaws) { flaw in
                        HStack {
                            Text(flaw.name)
                            Spacer()
                            Text("\(abs(flaw.cost)) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button("Remove") {
                                character.flaws.removeAll { $0.id == flaw.id }
                                refresh()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        Text("Total Value:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(abs(character.flaws.reduce(0) { $0 + $1.cost })) pts")
                            .fontWeight(.semibold)
                    }
                }
                
                CreationFlawsListView(selectedFlaws: $character.flaws, characterType: character.characterType)
            }
            
            Section(footer: Text("Merits and flaws are optional for character creation.")) {
                EmptyView()
            }
        }
        .id(refreshID)
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}

struct CreationMeritsListView: View {
    @Binding var selectedMerits: [Background]
    let characterType: CharacterType
    @State private var showingAddMerit = false
    
    var body: some View {
        Button("Add Merit") {
            showingAddMerit = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddMerit) {
            AddAdvantageView(selectedAdvantages: $selectedMerits, characterType: characterType)
        }
    }
}

struct CreationFlawsListView: View {
    @Binding var selectedFlaws: [Background]
    let characterType: CharacterType
    @State private var showingAddFlaw = false
    
    var body: some View {
        Button("Add Flaw") {
            showingAddFlaw = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws, characterType: characterType)
        }
    }
}
