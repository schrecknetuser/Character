import SwiftUI

struct StatusTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    if isEditing {
                        EditableStatusRowView(character: $character, title: "Health", type: .health, availableWidth: geometry.size.width - 40)
                        
                        EditableStatusRowView(character: $character, title: "Willpower", type: .willpower, availableWidth: geometry.size.width - 40)
                        
                        EditableHumanityRowView(character: $character, availableWidth: geometry.size.width - 40)
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
}
