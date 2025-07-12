import SwiftUI


struct AmbitionAndDesireStage: View {
    @Binding var character: any BaseCharacter
    
    var body: some View {
        Form {
            Section(header: Text("Character Goals")) {
                VStack(alignment: .leading) {
                    Text("Ambition")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("What does your character want to achieve?", text: $character.ambition, axis: .vertical)
                        .lineLimit(3...6)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading) {
                    Text("Desire")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("What does your character crave?", text: $character.desire, axis: .vertical)
                        .lineLimit(3...6)
                }
                .padding(.vertical, 4)
            }
            
            Section(footer: Text("Ambition and desire help define your character's motivations. They are optional for character creation.")) {
                EmptyView()
            }
        }
    }
}
