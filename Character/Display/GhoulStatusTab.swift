import SwiftUI

struct GhoulStatusTab: View {
    @Binding var character: GhoulCharacter
    @Binding var isEditing: Bool
    @State private var refreshID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                let baseBinding: Binding<any BaseCharacter> = Binding<any BaseCharacter>(
                    get: { character },
                    set: { newValue in
                        if let newGhoul = newValue as? GhoulCharacter {
                            character = newGhoul
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
                        EditableHumanityRowView(
                            character: $character,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                    } else {
                        StatusRowView(title: "Health", healthStates: character.healthStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Willpower", healthStates: character.willpowerStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Humanity", humanityStates: character.humanityStates, availableWidth: geometry.size.width - 40)
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