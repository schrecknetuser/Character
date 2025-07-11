import SwiftUI

struct NameAndChronicleStage: View {
    @Binding var character: Character
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Character Information")) {
                TextField("Character Name", text: $character.name)
                    .focused($isNameFieldFocused)
                
                TextField("Chronicle Name", text: $character.chronicleName)
            }
            
            Section(footer: Text("Both name and chronicle are required to proceed.")) {
                EmptyView()
            }
        }
        .onAppear {
            isNameFieldFocused = true
        }
    }
}
