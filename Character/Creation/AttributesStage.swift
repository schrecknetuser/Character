import SwiftUI

struct DraggableValueBox: View {
    let value: Int
    let id: UUID
    @State private var isDragging = false
    
    var body: some View {
        Text("\(value)")
            .font(.title2)
            .fontWeight(.bold)
            .frame(width: 50, height: 50)
            .background(Color.blue.opacity(isDragging ? 0.6 : 0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isDragging)
            .draggable(AttributeDragData(value: value, sourceAttribute: nil)) {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
    }
}

struct AttributeDropRow: View {
    let attribute: String
    @Binding var assignedValues: [String: Int]
    @Binding var availableValues: [(Int, UUID)]
    @Binding var characterAttributes: [String: Int]
    @Binding var character: Character
    @State private var isTargeted = false
    
    var body: some View {
        VStack {
            Text(attribute)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Drop zone - made much larger and more responsive
            ZStack {
                Rectangle()
                    .stroke(isTargeted ? Color.blue : Color.gray, lineWidth: isTargeted ? 2 : 1)
                    .frame(height: 80) // Large drop zone
                    .background(
                        Group {
                            if isTargeted {
                                Color.blue.opacity(0.3)
                            } else if assignedValues[attribute] != nil {
                                Color.green.opacity(0.2)
                            } else {
                                Color.gray.opacity(0.1)
                            }
                        }
                    )
                    .animation(.easeInOut(duration: 0.1), value: isTargeted)
                
                if let value = assignedValues[attribute] {
                    Text("\(value)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .draggable(AttributeDragData(value: value, sourceAttribute: attribute)) {
                            Text("\(value)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(width: 50, height: 50)
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                } else {
                    Text("—")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .dropDestination(for: AttributeDragData.self) { items, location in
                guard let draggedItem = items.first else { return false }
                assignValueToAttribute(attribute: attribute, dragData: draggedItem)
                return true
            } isTargeted: { targeted in
                isTargeted = targeted
            }
        }
    }
    
    private func assignValueToAttribute(attribute: String, dragData: AttributeDragData) {
        let value = dragData.value
        let sourceAttribute = dragData.sourceAttribute
        
        // If this attribute already has a value, return it to available values
        if let currentValue = assignedValues[attribute] {
            availableValues.append((currentValue, UUID()))
            availableValues.sort { $0.0 > $1.0 }
        }
        
        // Handle the source of the drag
        if let sourceAttr = sourceAttribute {
            // Dragged from another attribute - remove from source
            assignedValues.removeValue(forKey: sourceAttr)
            
            // Reset source attribute to base value in the correct character attribute category
            if V5Constants.physicalAttributes.contains(sourceAttr) {
                character.physicalAttributes[sourceAttr] = 1
            } else if V5Constants.socialAttributes.contains(sourceAttr) {
                character.socialAttributes[sourceAttr] = 1
            } else if V5Constants.mentalAttributes.contains(sourceAttr) {
                character.mentalAttributes[sourceAttr] = 1
            }
        } else {
            // Dragged from unassigned pool - remove from available values
            if let index = availableValues.firstIndex(where: { $0.0 == value }) {
                availableValues.remove(at: index)
            }
        }
        
        // Assign the new value
        assignedValues[attribute] = value
        characterAttributes[attribute] = value
    }
}

struct AttributesStage: View {
    @Binding var character: Character
    @State private var availableValues: [(Int, UUID)] = [(4, UUID()), (3, UUID()), (3, UUID()), (3, UUID()), (2, UUID()), (2, UUID()), (2, UUID()), (2, UUID()), (1, UUID())]
    @State private var assignedValues: [String: Int] = [:]
    
    private var allAttributes: [String] {
        V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Available values section
            VStack(alignment: .leading) {
                Text("Unassigned Values")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
                    ForEach(availableValues, id: \.1) { valueWithId in
                        DraggableValueBox(value: valueWithId.0, id: valueWithId.1)
                    }
                }
                .dropDestination(for: AttributeDragData.self) { items, location in
                    guard let draggedItem = items.first else { return false }
                    
                    // Find the attribute that had this value and remove it
                    if let sourceAttribute = draggedItem.sourceAttribute {
                        availableValues.append((draggedItem.value, UUID()))
                        availableValues.sort { $0.0 > $1.0 }
                        assignedValues.removeValue(forKey: sourceAttribute)
                        
                        // Reset the character attribute to base value
                        if V5Constants.physicalAttributes.contains(sourceAttribute) {
                            character.physicalAttributes[sourceAttribute] = 1
                        } else if V5Constants.socialAttributes.contains(sourceAttribute) {
                            character.socialAttributes[sourceAttribute] = 1
                        } else if V5Constants.mentalAttributes.contains(sourceAttribute) {
                            character.mentalAttributes[sourceAttribute] = 1
                        }
                    }
                    return true
                } isTargeted: { targeted in
                    // Add visual feedback for targeting the unassigned area
                    // This could be used to change the background color when hovering
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            
            // Attributes table
            VStack(alignment: .leading) {
                Text("Attributes")
                    .font(.headline)
                
                // Table header
                HStack {
                    Text("Physical")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                    
                    Text("Social")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                    
                    Text("Mental")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 10)
                
                // Attribute rows
                ForEach(0..<3, id: \.self) { rowIndex in
                    HStack {
                        // Physical attribute
                        AttributeDropRow(
                            attribute: V5Constants.physicalAttributes[rowIndex],
                            assignedValues: $assignedValues,
                            availableValues: $availableValues,
                            characterAttributes: $character.physicalAttributes,
                            character: $character
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Social attribute
                        AttributeDropRow(
                            attribute: V5Constants.socialAttributes[rowIndex],
                            assignedValues: $assignedValues,
                            availableValues: $availableValues,
                            characterAttributes: $character.socialAttributes,
                            character: $character
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Mental attribute
                        AttributeDropRow(
                            attribute: V5Constants.mentalAttributes[rowIndex],
                            assignedValues: $assignedValues,
                            availableValues: $availableValues,
                            characterAttributes: $character.mentalAttributes,
                            character: $character
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 2)
                }
            }
            
            // Progress indicator
            VStack(alignment: .leading) {
                Text("Progress: \(assignedValues.count) of \(allAttributes.count) attributes assigned")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Remaining values: \(availableValues.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if assignedValues.count < allAttributes.count || !availableValues.isEmpty {
                    Text("Assign all attribute values to proceed.")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("All values assigned! You can proceed to the next stage.")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .onAppear {
            initializeAttributeValues()
        }
    }
    
    private func initializeAttributeValues() {
        // Initialize from character's current attribute values if any are not 1
        for attribute in allAttributes {
            var currentValue = 1
            if V5Constants.physicalAttributes.contains(attribute) {
                currentValue = character.physicalAttributes[attribute] ?? 1
            } else if V5Constants.socialAttributes.contains(attribute) {
                currentValue = character.socialAttributes[attribute] ?? 1
            } else if V5Constants.mentalAttributes.contains(attribute) {
                currentValue = character.mentalAttributes[attribute] ?? 1
            }
            
            if currentValue > 1 {
                assignedValues[attribute] = currentValue
                if let index = availableValues.firstIndex(where: { $0.0 == currentValue }) {
                    availableValues.remove(at: index)
                }
            }
        }
    }
    
    static func areAllAttributesAssigned(character: Character) -> Bool {
        let allAttributes = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes
        
        // Check if all attributes have values > 1 (meaning they were assigned)
        var assignedCount = 0
        for attribute in allAttributes {
            var currentValue = 0
            if V5Constants.physicalAttributes.contains(attribute) {
                currentValue = character.physicalAttributes[attribute] ?? 0
            } else if V5Constants.socialAttributes.contains(attribute) {
                currentValue = character.socialAttributes[attribute] ?? 0
            } else if V5Constants.mentalAttributes.contains(attribute) {
                currentValue = character.mentalAttributes[attribute] ?? 0
            }
            
            if currentValue > 0 {
                assignedCount += 1
            }
        }
        
        // All 9 attributes must be assigned and we must have used all 9 available values
        return assignedCount == allAttributes.count
    }
}
