import SwiftUI

// Attribute preset - similar to SkillPreset but for attributes
enum AttributePreset: CaseIterable {
    case standard
    
    var name: String {
        switch self {
        case .standard: return "Standard Attribute Set"
        }
    }
    
    var values: [Int] {
        switch self {
        case .standard: return [4, 3, 3, 3, 2, 2, 2, 2, 1]
        }
    }
}

struct AttributePresetView: View {
    let preset: AttributePreset
    let presetValues: [Int]
    let selectedValues: [Int]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(preset.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            let valuesWithStatus: [(Int, Bool)] = {
                var statusList: [(Int, Bool)] = presetValues.map { ($0, false) }
                
                for i in selectedValues {
                    if let matchIndex = statusList.firstIndex(where: { $0.0 == i && !$0.1 }) {
                        statusList[matchIndex].1 = true
                    }
                }

                return statusList
            }()
                
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 9), spacing: 6) {
                ForEach(Array(valuesWithStatus.enumerated()), id: \.offset) { index, value in
                    Text("\(value.0)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(4)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(4)
                        .strikethrough(value.1)
                }
            }
        }
    }
}

struct AttributeCategoryView: View {
    let title: String
    let attributes: [String]
    @Binding var characterAttributes: [String: Int]
    let availableValues: [Int]
    let dynamicFontSize: CGFloat
    let headerFontSize: CGFloat
    let rowHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: headerFontSize, weight: .semibold))
                .foregroundColor(.secondary)
            
            ForEach(attributes, id: \.self) { attribute in
                HStack {
                    Text(attribute)
                        .font(.system(size: dynamicFontSize))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Picker("", selection: Binding(
                        get: { characterAttributes[attribute] ?? 1 },
                        set: { characterAttributes[attribute] = $0 }
                    )) {
                        let currentValue = characterAttributes[attribute] ?? 1
                        let uniqueValues = Set(availableValues + [currentValue])
                        
                        ForEach(uniqueValues.sorted(by: >), id: \.self) { value in
                            Text("\(value)")
                                .font(.system(size: dynamicFontSize))
                                .tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 55)
                }
                .frame(minHeight: rowHeight)
            }
        }
    }
}



struct AttributesStage: View {
    @Binding var character: any BaseCharacter
    @State private var selectedPresetValues: [AttributePreset: [Int]] = [:]
    
    @State private var dynamicFontSize: CGFloat = 14
    @State private var titleFontSize: CGFloat = 20
    @State private var headerFontSize: CGFloat = 17
    @State private var rowHeight: CGFloat = 20
    
    private var allAttributes: [String] {
        V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes
    }
    
    private func getPresetValues(for preset: AttributePreset) -> [Int] {
        selectedPresetValues[preset] ?? preset.values
    }
    
    private var allAttributeValues: [Int] {
        allAttributes.compactMap { attribute in
            if V5Constants.physicalAttributes.contains(attribute) {
                return character.physicalAttributes[attribute]
            } else if V5Constants.socialAttributes.contains(attribute) {
                return character.socialAttributes[attribute]
            } else if V5Constants.mentalAttributes.contains(attribute) {
                return character.mentalAttributes[attribute]
            }
            return 1
        }.filter { $0 > 1 } // Only count assigned values (> 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Presets section
                    VStack(alignment: .leading) {
                        Text("Attribute Preset")
                            .font(.headline)
                        
                        ForEach(AttributePreset.allCases, id: \.self) { preset in
                            AttributePresetView(
                                preset: preset,
                                presetValues: getPresetValues(for: preset),
                                selectedValues: allAttributeValues
                            )
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Attributes section
                    VStack(alignment: .leading) {
                        Text("Attributes")
                            .font(.headline)
                        
                        HStack(spacing: 15) {
                            // Physical Attributes
                            AttributeCategoryView(
                                title: "Physical",
                                attributes: V5Constants.physicalAttributes,
                                characterAttributes: $character.physicalAttributes,
                                availableValues: getAvailableValuesForSelection(),
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            // Social Attributes
                            AttributeCategoryView(
                                title: "Social",
                                attributes: V5Constants.socialAttributes,
                                characterAttributes: $character.socialAttributes,
                                availableValues: getAvailableValuesForSelection(),
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            // Mental Attributes
                            AttributeCategoryView(
                                title: "Mental",
                                attributes: V5Constants.mentalAttributes,
                                characterAttributes: $character.mentalAttributes,
                                availableValues: getAvailableValuesForSelection(),
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Progress indicator
                    VStack(alignment: .leading) {
                        Text("Progress: \(allAttributeValues.count) of \(AttributePreset.standard.values.count) values assigned")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        let remainingValues = AttributePreset.standard.values.count - allAttributeValues.count
                        Text("Remaining values: \(remainingValues)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if allAttributeValues.count < AttributePreset.standard.values.count {
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
            }
            .onAppear {
                initializePresetValues()
                calculateOptimalFontSizes(for: geometry.size)
            }
            .onChange(of: allAttributeValues) {
                // Update is automatic with new system
            }
        }
    }
    
    private func initializePresetValues() {
        selectedPresetValues[.standard] = AttributePreset.standard.values
    }
    
    private func getAvailableValuesForSelection() -> [Int] {
        var availableValues: [Int] = AttributePreset.standard.values
        
        // Remove already used values (but keep 1 always available)
        let usedValues = allAttributeValues
        for usedValue in usedValues {
            if usedValue > 1, let index = availableValues.firstIndex(of: usedValue) {
                availableValues.remove(at: index)
            }
        }
        
        // Always include 1 as it's unlimited (base value)
        if !availableValues.contains(1) {
            availableValues.append(1)
        }
        
        return Array(Set(availableValues)).sorted(by: >)
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width and available space
        let availableWidth = (size.width - 120) / 3 // Account for padding and 3 columns
        
        // Find the longest text among all displayed values
        let allDisplayedTexts = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes +
                               ["Physical", "Social", "Mental", "Attributes"]
        let longestText = allDisplayedTexts.max(by: { $0.count < $1.count }) ?? "Intelligence"
        
        // Determine optimal font size based on available width per column
        let scaleFactor = min(1.0, availableWidth / (CGFloat(longestText.count) * 8))
        
        // Base font sizes
        let baseDynamicSize: CGFloat = 11
        let baseTitleSize: CGFloat = 17
        let baseHeaderSize: CGFloat = 14
        let baseRowHeight: CGFloat = 24
        
        // Calculate scaled sizes
        dynamicFontSize = max(9, min(13, baseDynamicSize * scaleFactor))
        titleFontSize = max(15, min(19, baseTitleSize * scaleFactor))
        headerFontSize = max(12, min(16, baseHeaderSize * scaleFactor))
        rowHeight = max(22, min(28, baseRowHeight * scaleFactor))
    }
    
    static func areAllAttributesAssigned(character: any BaseCharacter) -> Bool {
        let allAttributes = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes
        
        // Count how many attributes have values > 1 (assigned from the pool)
        var assignedCount = 0
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
                assignedCount += 1
            }
        }
        
        // All 9 values from the preset must be assigned
        return assignedCount == AttributePreset.standard.values.count
    }
}
