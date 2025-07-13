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
                
                TextField("Character Concept", text: $character.concept)
                
                DatePicker("Date of Birth", selection: Binding(
                    get: { character.dateOfBirth ?? Date() },
                    set: { character.dateOfBirth = $0 }
                ), displayedComponents: .date)
                
                DatePicker("Date of Embrace", selection: Binding(
                    get: { character.dateOfEmbrace ?? Date() },
                    set: { character.dateOfEmbrace = $0 }
                ), displayedComponents: .date)
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
