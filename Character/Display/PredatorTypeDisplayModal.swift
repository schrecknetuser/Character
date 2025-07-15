import SwiftUI

struct PredatorTypeDisplayModal: View {
    let vampire: VampireCharacter
    @Binding var isPresented: Bool
    
    private var currentPredatorType: PredatorType? {
        if vampire.predatorType.isEmpty {
            return nil
        }
        
        // Check canonical types first
        if let canonicalType = V5Constants.predatorTypes.first(where: { $0.name == vampire.predatorType }) {
            return canonicalType
        }
        
        // Check custom types
        if let customType = vampire.customPredatorTypes.first(where: { $0.name == vampire.predatorType }) {
            return customType
        }
        
        return nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                if let predatorType = currentPredatorType {
                    Section(header: Text("Predator Type")) {
                        Text(predatorType.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Section(header: Text("Description")) {
                        Text(predatorType.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    Section(header: Text("Feeding Method")) {
                        Text(predatorType.feedingDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    if !predatorType.bonuses.isEmpty {
                        Section(header: Text("Bonuses")) {
                            ForEach(predatorType.bonuses) { bonus in
                                Text("• \(bonus.description)")
                                    .font(.body)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    
                    if !predatorType.drawbacks.isEmpty {
                        Section(header: Text("Drawbacks")) {
                            ForEach(predatorType.drawbacks) { drawback in
                                Text("• \(drawback.description)")
                                    .font(.body)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                } else {
                    Section {
                        Text("No predator type selected")
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                }
            }
            .navigationTitle("Predator Type Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}