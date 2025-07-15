import SwiftUI

struct PredatorPathSelectionStage: View {
    @ObservedObject var character: VampireCharacter
    var onChange: (() -> Void)? = nil
    
    @State private var selectedPath: PredatorPath?
    
    var body: some View {
        Form {
            Section(header: Text("Select Predator Path")) {
                ForEach(V5Constants.predatorPaths) { path in
                    Button(action: {
                        character.predatorPath = path.name
                        selectedPath = path
                        onChange?()
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: character.predatorPath == path.name ? "circle.fill" : "circle")
                                    .foregroundColor(character.predatorPath == path.name ? .accentColor : .secondary)
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
            }
            
            if let selectedPath = selectedPath {
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
            
            Section(footer: Text("Choose how your vampire hunts for blood. Each predator path provides unique advantages and challenges.")) {
                EmptyView()
            }
        }
        .onAppear {
            if !character.predatorPath.isEmpty {
                selectedPath = V5Constants.getPredatorPath(named: character.predatorPath)
            }
        }
    }
}