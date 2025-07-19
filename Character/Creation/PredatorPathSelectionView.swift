import SwiftUI

// Shared predator type selection component to avoid duplication
struct PredatorTypeSelectionView: View {
    @ObservedObject var vampire: VampireCharacter
    @Binding var selectedType: PredatorType?
    var showCustomOption: Bool = true
    var onChange: (() -> Void)? = nil
    var onCustomTypeRequested: (() -> Void)? = nil
    
    @State private var showingCustomTypeForm: Bool = false
    @State private var customTypeName: String = ""
    @State private var customTypeDescription: String = ""
    @State private var customTypeFeedingDescription: String = ""        
    
    private var availableTypes: [PredatorType] {
        var types = V5Constants.predatorTypes
        
        // Add custom types from the vampire character
        types.append(contentsOf: vampire.customPredatorTypes)
        
        return types
    }
    
    var body: some View {
        Group {
            Section(header: Text("Select Predator Type")) {
                Picker("Predator Type", selection: Binding(
                    get: { selectedType?.name ?? "" },
                    set: { typeName in
                        selectedType = availableTypes.first { $0.name == typeName }
                        if typeName != "None" && !typeName.isEmpty {
                            vampire.predatorType = typeName
                        } else {
                            vampire.predatorType = ""
                        }
                        onChange?()
                    }
                )) {
                    ForEach(availableTypes) { type in
                        Text(type.name).tag(type.name)
                    }
                }
                .pickerStyle(.menu)
                
                // Custom type option
                if showCustomOption {
                    Button(action: {
                        if let onCustomTypeRequested = onCustomTypeRequested {
                            // Use callback if provided (for modal context)
                            onCustomTypeRequested()
                        } else {
                            // Fall back to internal sheet management (for creation context)
                            showingCustomTypeForm = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.accentColor)
                            Text("Create Custom Type")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            if let selectedType = selectedType, selectedType.name != "None" {
                Section(header: Text("Description")) {
                    Text(selectedType.description)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Section(header: Text("Feeding Method")) {
                    Text(selectedType.feedingDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                if !selectedType.bonuses.isEmpty {
                    Section(header: Text("Bonuses")) {
                        ForEach(selectedType.bonuses) { bonus in
                            Text("• \(bonus.description)")
                                .font(.body)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                if !selectedType.drawbacks.isEmpty {
                    Section(header: Text("Drawbacks")) {
                        ForEach(selectedType.drawbacks) { drawback in
                            Text("• \(drawback.description)")
                                .font(.body)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Set initial selection based on current vampire predator type
            if vampire.predatorType.isEmpty {
                selectedType = availableTypes.first { $0.name == "None" }
            } else {
                selectedType = availableTypes.first { $0.name == vampire.predatorType }
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

struct CustomPredatorTypeForm: View {
    @Binding var typeName: String
    @Binding var typeDescription: String
    @Binding var feedingDescription: String
    var onSave: (PredatorType) -> Void
    var onCancel: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Type Information")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name:")
                            .fontWeight(.medium)
                        TextField("Enter type name", text: $typeName)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description:")
                            .fontWeight(.medium)
                        TextField("Enter type description", text: $typeDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Feeding Description:")
                            .fontWeight(.medium)
                        TextField("How does this predator hunt?", text: $feedingDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                
                Section(footer: Text("Custom predator types allow you to create unique hunting styles for your vampire character.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Custom Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel?()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let customType = PredatorType(
                            name: typeName.trim(),
                            description: typeDescription.trim(),
                            bonuses: [],
                            drawbacks: [],
                            feedingDescription: feedingDescription.trim()
                        )
                        onSave(customType)
                        dismiss()
                    }
                    .disabled(typeName.trim().isEmpty || typeDescription.trim().isEmpty)
                }
            }
        }
    }
}
