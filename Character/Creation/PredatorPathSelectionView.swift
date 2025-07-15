import SwiftUI

// Shared predator path selection component to avoid duplication
struct PredatorPathSelectionView: View {
    @ObservedObject var vampire: VampireCharacter
    @Binding var selectedPath: PredatorPath?
    var showNoneOption: Bool = true
    var showCustomOption: Bool = true
    var onChange: (() -> Void)? = nil
    
    @State private var showingCustomPathForm: Bool = false
    @State private var customPathName: String = ""
    @State private var customPathDescription: String = ""
    @State private var customPathFeedingDescription: String = ""
    
    private var availablePaths: [PredatorPath] {
        var paths = V5Constants.predatorPaths
        
        // Add "None" option as a special path if enabled
        if showNoneOption {
            let nonePath = PredatorPath(
                name: "None",
                description: "No specific predator path chosen",
                bonuses: [],
                drawbacks: [],
                feedingDescription: "Feeds as needed without a specialized hunting method"
            )
            paths.insert(nonePath, at: 0)
        }
        
        // Add custom paths from the vampire character
        paths.append(contentsOf: vampire.customPredatorPaths)
        
        return paths
    }
    
    var body: some View {
        Group {
            Section(header: Text("Select Predator Path")) {
                ForEach(availablePaths) { path in
                    Button(action: {
                        selectedPath = path
                        if path.name != "None" {
                            vampire.predatorPath = path.name
                        } else {
                            vampire.predatorPath = ""
                        }
                        onChange?()
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: selectedPath?.name == path.name ? "circle.fill" : "circle")
                                    .foregroundColor(selectedPath?.name == path.name ? .accentColor : .secondary)
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
                if showCustomOption {
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
                    // Add to vampire's custom paths
                    vampire.customPredatorPaths.append(path)
                    selectedPath = path
                    vampire.predatorPath = path.name
                    // Clear form fields
                    customPathName = ""
                    customPathDescription = ""
                    customPathFeedingDescription = ""
                    onChange?()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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
                }
            }
        }
    }
}