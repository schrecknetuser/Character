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
            }
            
            Spacer()
        }
        .padding()
    }
}