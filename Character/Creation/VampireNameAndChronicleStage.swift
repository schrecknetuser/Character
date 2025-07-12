import SwiftUI

struct VampireNameAndChronicleStage: View {
    @Binding var character: VampireCharacter
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Character Information")) {
                TextField("Character Name", text: $character.name)
                    .focused($isNameFieldFocused)
                
                TextField("Chronicle Name", text: $character.chronicleName)
            }
            
            Section(header: Text("Character Details")) {
                HStack {
                    Text("Generation:")
                    Spacer()
                    Stepper(value: $character.generation, in: 4...16) {
                        Text("\(character.generation)")
                    }
                }
                
                HStack {
                    Text("Blood Potency:")
                    Spacer()
                    Stepper(value: $character.bloodPotency, in: 0...10) {
                        Text("\(character.bloodPotency)")
                    }
                }
            }
            
            Section(footer: Text("All fields are required to proceed.")) {
                EmptyView()
            }
        }
        .onAppear {
            isNameFieldFocused = true
        }
    }
}
