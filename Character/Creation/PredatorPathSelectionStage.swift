import SwiftUI

struct PredatorPathSelectionStage: View {
    @ObservedObject var character: VampireCharacter
    var onChange: (() -> Void)? = nil
    
    @State private var selectedPath: PredatorPath?
    @State private var showingCustomPathForm: Bool = false
    @State private var customPathName: String = ""
    @State private var customPathDescription: String = ""
    @State private var customPathFeedingDescription: String = ""
    
    var body: some View {
        Form {
            PredatorPathSelectionView(
                vampire: character,
                selectedPath: $selectedPath,
                showNoneOption: true,
                showCustomOption: true,
                onChange: onChange,
                onCustomPathRequested: {
                    showingCustomPathForm = true
                }
            )
            
            Section(footer: Text("Choose how your vampire hunts for blood. Each predator path provides unique advantages and challenges. You may also choose 'None' for no specific hunting style or create a custom predator path.")) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showingCustomPathForm) {
            CustomPredatorPathForm(
                pathName: $customPathName,
                pathDescription: $customPathDescription,
                feedingDescription: $customPathFeedingDescription,
                onSave: { path in
                    // Add to vampire's custom paths
                    character.customPredatorPaths.append(path)
                    selectedPath = path
                    character.predatorPath = path.name
                    // Clear form fields
                    customPathName = ""
                    customPathDescription = ""
                    customPathFeedingDescription = ""
                    onChange?()
                },
                onCancel: {
                    // Clear form fields on cancel
                    customPathName = ""
                    customPathDescription = ""
                    customPathFeedingDescription = ""
                }
            )
        }
    }
}