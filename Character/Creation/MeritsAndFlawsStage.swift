import SwiftUI

struct MeritsAndFlawsStage: View {
    @Binding var character: any BaseCharacter
    @State private var refreshID = UUID()
    
    var body: some View {
        Form {
            Section(header: Text("Backgrounds (Merits)")) {
                if character.backgroundMerits.isEmpty {
                    Text("No background merits selected")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.backgroundMerits) { background in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(background.name)
                                if !background.comment.isEmpty {
                                    Text(background.comment)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Text("\(background.cost) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button("Remove") {
                                character.backgroundMerits.removeAll { $0.id == background.id }
                                refresh()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    

                }
                
                CreationBackgroundMeritsListView(
                    selectedBackgrounds: $character.backgroundMerits,
                    characterType: character.characterType
                )
            }
            
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
                        Text("Total Merit Cost:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(character.totalAdvantageCost) pts")
                            .fontWeight(.semibold)
                    }
                }
                
                CreationMeritsListView(selectedMerits: $character.advantages, characterType: character.characterType)
            }
            
            Section(header: Text("Backgrounds (Flaws)")) {
                if character.backgroundFlaws.isEmpty {
                    Text("No background flaws selected")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.backgroundFlaws) { background in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(background.name)
                                if !background.comment.isEmpty {
                                    Text(background.comment)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Text("\(abs(background.cost)) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Button("Remove") {
                                character.backgroundFlaws.removeAll { $0.id == background.id }
                                refresh()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                    

                }
                
                CreationBackgroundFlawsListView(
                    selectedBackgrounds: $character.backgroundFlaws,
                    characterType: character.characterType
                )
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
                        Text("Total Flaw Value:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(character.totalFlawValue) pts")
                            .fontWeight(.semibold)
                    }
                }
                
                CreationFlawsListView(selectedFlaws: $character.flaws, characterType: character.characterType)
            }
            
            Section(footer: Text("Backgrounds and merits/flaws are optional for character creation.")) {
                EmptyView()
            }
        }
        .id(refreshID)
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}

struct CreationBackgroundMeritsListView: View {
    @Binding var selectedBackgrounds: [CharacterBackground]
    let characterType: CharacterType
    @State private var showingAddBackground = false
    
    var body: some View {
        Button("Add Background Merit") {
            showingAddBackground = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddBackground) {
            AddCharacterBackgroundView(
                selectedBackgrounds: $selectedBackgrounds,
                backgroundType: .merit,
                characterType: characterType,
                onRefresh: {}
            )
        }
    }
}

struct CreationBackgroundFlawsListView: View {
    @Binding var selectedBackgrounds: [CharacterBackground]
    let characterType: CharacterType
    @State private var showingAddBackground = false
    
    var body: some View {
        Button("Add Background Flaw") {
            showingAddBackground = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddBackground) {
            AddCharacterBackgroundView(
                selectedBackgrounds: $selectedBackgrounds,
                backgroundType: .flaw,
                characterType: characterType,
                onRefresh: {}
            )
        }
    }
}

struct CreationMeritsListView: View {
    @Binding var selectedMerits: [BackgroundBase]
    let characterType: CharacterType
    @State private var showingAddMerit = false
    
    var body: some View {
        Button("Add Merit") {
            showingAddMerit = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddMerit) {
            AddAdvantageView(selectedAdvantages: $selectedMerits, characterType: characterType, onRefresh: {})
        }
    }
}

struct CreationFlawsListView: View {
    @Binding var selectedFlaws: [BackgroundBase]
    let characterType: CharacterType
    @State private var showingAddFlaw = false
    
    var body: some View {
        Button("Add Flaw") {
            showingAddFlaw = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws, characterType: characterType, onRefresh: {})
        }
    }
}
