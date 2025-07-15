import SwiftUI

struct PredatorTypeSelectionStage: View {
    @ObservedObject var character: VampireCharacter
    var onChange: (() -> Void)? = nil
    
    @State private var selectedType: PredatorType?
    @State private var showingCustomTypeForm: Bool = false
    @State private var customTypeName: String = ""
    @State private var customTypeDescription: String = ""
    @State private var customTypeFeedingDescription: String = ""
    
    var body: some View {
        Form {
            PredatorTypeSelectionView(
                vampire: character,
                selectedType: $selectedType,
                showNoneOption: true,
                showCustomOption: true,
                onChange: onChange,
                onCustomTypeRequested: {
                    showingCustomTypeForm = true
                }
            )
            
            Section(footer: Text("Choose how your vampire hunts for blood. Each predator type provides unique advantages and challenges. You may also choose 'None' for no specific hunting style or create a custom predator type.")) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showingCustomTypeForm) {
            CustomPredatorTypeForm(
                typeName: $customTypeName,
                typeDescription: $customTypeDescription,
                feedingDescription: $customTypeFeedingDescription,
                onSave: { type in
                    // Add to vampire's custom types
                    character.customPredatorTypes.append(type)
                    selectedType = type
                    character.predatorType = type.name
                    // Clear form fields
                    customTypeName = ""
                    customTypeDescription = ""
                    customTypeFeedingDescription = ""
                    onChange?()
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