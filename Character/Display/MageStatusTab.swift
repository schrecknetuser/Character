import SwiftUI

struct MageStatusTab: View {
    @Binding var character: MageCharacter
    @Binding var isEditing: Bool
    @State private var refreshID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                let baseBinding: Binding<any BaseCharacter> = Binding<any BaseCharacter>(
                    get: { character },
                    set: { newValue in
                        if let newMage = newValue as? MageCharacter {
                            character = newMage
                        }
                    }
                )
                
                VStack(alignment: .leading, spacing: 30) {
                    if isEditing {
                        EditableStatusRowView(
                            character: baseBinding,
                            title: "Health",
                            type: .health,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableStatusRowView(
                            character: baseBinding,
                            title: "Willpower",
                            type: .willpower,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableMageTraitRowView(
                            character: $character,
                            title: "Hubris",
                            traitType: .hubris,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableMageTraitRowView(
                            character: $character,
                            title: "Quiet",
                            traitType: .quiet,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableParadoxRowView(
                            character: $character,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableAreteRowView(
                            character: $character,
                            onChange: {refresh()}
                        )
                    } else {
                        StatusRowView(title: "Health", healthStates: character.healthStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Willpower", healthStates: character.willpowerStates, availableWidth: geometry.size.width - 40)
                        MageTraitRowView(title: "Hubris", states: character.hubrisStates, availableWidth: geometry.size.width - 40)
                        MageTraitRowView(title: "Quiet", states: character.quietStates, availableWidth: geometry.size.width - 40)
                        ParadoxRowView(paradox: character.paradox, availableWidth: geometry.size.width - 40)
                        AreteRowView(arete: character.arete)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}