import SwiftUI

struct PredatorTypeSelectionModal: View {
    @ObservedObject var vampire: VampireCharacter
    @Binding var isPresented: Bool
    
    @State private var selectedType: PredatorType?
    @State private var showingCustomTypeForm: Bool = false
    @State private var customTypeName: String = ""
    @State private var customTypeDescription: String = ""
    @State private var customTypeFeedingDescription: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                PredatorTypeSelectionView(
                    vampire: vampire,
                    selectedType: $selectedType,
                    showCustomOption: true,
                    onCustomTypeRequested: {
                        showingCustomTypeForm = true
                    }
                )
            }
            .navigationTitle("Predator Type")
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
        .sheet(isPresented: $showingCustomTypeForm) {
            CustomPredatorTypeForm(
                typeName: $customTypeName,
                typeDescription: $customTypeDescription,
                feedingDescription: $customTypeFeedingDescription,
                onSave: { type in
                    // Add to vampire's custom types
                    vampire.customPredatorTypes.append(type)
                    selectedType = type
                    vampire.predatorType = type.name
                    // Clear form fields
                    customTypeName = ""
                    customTypeDescription = ""
                    customTypeFeedingDescription = ""
                },
                onCancel: {
                    // Clear form fields on cancel
                    customTypeName = ""
                    customTypeDescription = ""
                    customTypeFeedingDescription = ""
                }
            )
        }
    }
}
