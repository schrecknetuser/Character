import SwiftUI

struct PredatorPathSelectionModal: View {
    @ObservedObject var vampire: VampireCharacter
    @Binding var isPresented: Bool
    
    @State private var selectedPath: PredatorPath?
    @State private var showingCustomPathForm: Bool = false
    @State private var customPathName: String = ""
    @State private var customPathDescription: String = ""
    @State private var customPathFeedingDescription: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                PredatorPathSelectionView(
                    vampire: vampire,
                    selectedPath: $selectedPath,
                    showNoneOption: true,
                    showCustomOption: true,
                    onCustomPathRequested: {
                        showingCustomPathForm = true
                    }
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
        .sheet(isPresented: $showingCustomPathForm) {
            CustomPredatorPathForm(
                pathName: $customPathName,
                pathDescription: $customPathDescription,
                feedingDescription: $customPathFeedingDescription,
                onSave: { path in
                    // Add to vampire's custom paths
                    vampire.customPredatorPaths.append(path)
                    selectedPath = path
                    vampire.predatorPath = path.name
                    // Clear form fields
                    customPathName = ""
                    customPathDescription = ""
                    customPathFeedingDescription = ""
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