import SwiftUI

struct GhoulNameAndChronicleStage: View {
    @Binding var character: GhoulCharacter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name & Chronicle")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Character Name")
                        .font(.headline)
                    TextField("Enter character name", text: $character.name)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Chronicle Name")
                        .font(.headline)
                    TextField("Enter chronicle name", text: $character.chronicleName)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Character Concept")
                        .font(.headline)
                    TextField("Enter character concept", text: $character.concept)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of Birth")
                        .font(.headline)
                    DatePicker("Date of Birth", selection: Binding(
                        get: { character.dateOfBirth ?? Date() },
                        set: { character.dateOfBirth = $0 }
                    ), displayedComponents: .date)
                    .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of Ghouling")
                        .font(.headline)
                    DatePicker("Date of Ghouling", selection: Binding(
                        get: { character.dateOfGhouling ?? Date() },
                        set: { character.dateOfGhouling = $0 }
                    ), displayedComponents: .date)
                    .labelsHidden()
                }
            }
            
            Spacer()
        }
        .padding()
    }
}