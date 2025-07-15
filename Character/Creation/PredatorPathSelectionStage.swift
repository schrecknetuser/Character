import SwiftUI

struct PredatorPathSelectionStage: View {
    @ObservedObject var character: VampireCharacter
    var onChange: (() -> Void)? = nil
    
    @State private var selectedPath: PredatorPath?
    
    var body: some View {
        Form {
            PredatorPathSelectionView(
                vampire: character,
                selectedPath: $selectedPath,
                showNoneOption: true,
                showCustomOption: true,
                onChange: onChange
            )
            
            Section(footer: Text("Choose how your vampire hunts for blood. Each predator path provides unique advantages and challenges. You may also choose 'None' for no specific hunting style or create a custom predator path.")) {
                EmptyView()
            }
        }
    }
}