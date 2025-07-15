import SwiftUI

struct PredatorPathSelectionModal: View {
    @ObservedObject var vampire: VampireCharacter
    @Binding var isPresented: Bool
    
    @State private var selectedPath: PredatorPath?
    @State private var showingCustomPathForm: Bool = false
    @State private var customPathName: String = ""
    @State private var customPathDescription: String = ""
    @State private var customPathFeedingDescription: String = ""
    
    private var availablePaths: [PredatorPath] {
        var paths = V5Constants.predatorPaths
        
        // Add "None" option as a special path
        let nonePath = PredatorPath(
            name: "None",
            description: "No specific predator path chosen",
            bonuses: [],
            drawbacks: [],
            feedingDescription: "Feeds as needed without a specialized hunting method"
        )
        paths.insert(nonePath, at: 0)
        
        // Add custom paths if any exist
        // TODO: Implement custom path storage
        
        return paths
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Predator Path")) {
                    ForEach(availablePaths) { path in
                        Button(action: {
                            selectedPath = path
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: selectedPath?.id == path.id ? "circle.fill" : "circle")
                                        .foregroundColor(selectedPath?.id == path.id ? .accentColor : .secondary)
                                    Text(path.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                
                                Text(path.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical, 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Custom path option
                    Button(action: {
                        showingCustomPathForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.accentColor)
                            Text("Create Custom Path")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if let selectedPath = selectedPath, selectedPath.name != "None" {
                    Section(header: Text("Path Details")) {
                        Text(selectedPath.feedingDescription)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    if !selectedPath.bonuses.isEmpty {
                        Section(header: Text("Bonuses")) {
                            ForEach(selectedPath.bonuses) { bonus in
                                Text("• \(bonus.description)")
                                    .font(.body)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    if !selectedPath.drawbacks.isEmpty {
                        Section(header: Text("Drawbacks")) {
                            ForEach(selectedPath.drawbacks) { drawback in
                                Text("• \(drawback.description)")
                                    .font(.body)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Predator Path")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Done") {
                    if let selectedPath = selectedPath {
                        vampire.predatorPath = selectedPath.name == "None" ? "" : selectedPath.name
                    }
                    isPresented = false
                }
                .disabled(selectedPath == nil)
            )
        }
        .onAppear {
            // Set initial selection based on current vampire predator path
            if vampire.predatorPath.isEmpty {
                selectedPath = availablePaths.first { $0.name == "None" }
            } else {
                selectedPath = availablePaths.first { $0.name == vampire.predatorPath }
            }
        }
        .sheet(isPresented: $showingCustomPathForm) {
            CustomPredatorPathForm(
                isPresented: $showingCustomPathForm,
                pathName: $customPathName,
                pathDescription: $customPathDescription,
                feedingDescription: $customPathFeedingDescription,
                onSave: { path in
                    selectedPath = path
                    // TODO: Save custom path for future use
                }
            )
        }
    }
}

struct CustomPredatorPathForm: View {
    @Binding var isPresented: Bool
    @Binding var pathName: String
    @Binding var pathDescription: String
    @Binding var feedingDescription: String
    var onSave: (PredatorPath) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Path Information")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name:")
                            .fontWeight(.medium)
                        TextField("Enter path name", text: $pathName)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description:")
                            .fontWeight(.medium)
                        TextField("Enter path description", text: $pathDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Feeding Description:")
                            .fontWeight(.medium)
                        TextField("How does this predator hunt?", text: $feedingDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                
                Section(footer: Text("Custom predator paths allow you to create unique hunting styles for your vampire character.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Custom Path")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    let customPath = PredatorPath(
                        name: pathName.trim(),
                        description: pathDescription.trim(),
                        bonuses: [],
                        drawbacks: [],
                        feedingDescription: feedingDescription.trim()
                    )
                    onSave(customPath)
                    isPresented = false
                }
                .disabled(pathName.trim().isEmpty || pathDescription.trim().isEmpty)
            )
        }
    }
}