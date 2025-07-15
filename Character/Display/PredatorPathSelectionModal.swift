import SwiftUI

struct PredatorPathSelectionModal: View {
    @ObservedObject var vampire: VampireCharacter
    @Binding var isPresented: Bool
    
    @State private var selectedPath: PredatorPath?
    
    var body: some View {
        NavigationView {
            Form {
                PredatorPathSelectionView(
                    vampire: vampire,
                    selectedPath: $selectedPath,
                    showNoneOption: true,
                    showCustomOption: true
                )
            }
            .navigationTitle("Predator Path")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}