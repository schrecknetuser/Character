import SwiftUI

struct VampireStatusTab: View {
    @Binding var character: Vampire
    @Binding var isEditing: Bool
    @State private var refreshID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                let baseBinding: Binding<any BaseCharacter> = Binding<any BaseCharacter>(
                    get: { character },
                    set: { newValue in
                        if let newVampire = newValue as? Vampire {
                            character = newVampire
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
                        EditableHungerRowView(
                            character: $character,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableGenerationRowView(
                            character: $character,
                            onChange: {refresh()}
                        )
                        EditableBloodPotencyRowView(
                            character: $character,
                            onChange: {refresh()}
                        )
                    } else {
                        StatusRowView(title: "Health", healthStates: character.healthStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Willpower", healthStates: character.willpowerStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Humanity", humanityStates: character.humanityStates, availableWidth: geometry.size.width - 40)
                        HungerRowView(hunger: character.hunger, availableWidth: geometry.size.width - 40)
                        GenerationRowView(generation: character.generation)
                        BloodPotencyRowView(bloodPotency: character.bloodPotency)
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
