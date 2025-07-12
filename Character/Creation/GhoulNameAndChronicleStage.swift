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
            }
            
            Spacer()
        }
        .padding()
    }
}