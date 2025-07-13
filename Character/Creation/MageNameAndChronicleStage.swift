import SwiftUI

struct MageNameAndChronicleStage: View {
    @Binding var character: MageCharacter
    
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
                    Text("Paradigm")
                        .font(.headline)
                    TextField("Enter paradigm", text: $character.paradigm, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Practice")
                        .font(.headline)
                    TextField("Enter practice", text: $character.practice)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}