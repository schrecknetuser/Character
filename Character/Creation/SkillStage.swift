import SwiftUI


enum SkillPreset: CaseIterable {
    case jackOfAllTrades
    case balanced
    case specialist
    
    var name: String {
        switch self {
        case .jackOfAllTrades: return "Jack of all trades"
        case .balanced: return "Balanced"
        case .specialist: return "Specialist"
        }
    }
    
    var values: [Int] {
        switch self {
        case .jackOfAllTrades: return [3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        case .balanced: return [3, 3, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1]
        case .specialist: return [4, 3, 3, 3, 2, 2, 2, 1, 1, 1]
        }
    }
}

struct PresetView: View {
    let preset: SkillPreset
    let presetValues: [Int]
    let selectedValues: [Int]
    let isPresetAvailable: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(preset.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isPresetAvailable ? .primary : .gray)
            
            let valuesWithStatus: [(Int, Bool)] = {
                var statusList: [(Int, Bool)] = presetValues.map { ($0, false) }
                
                for i in selectedValues {
                    if let matchIndex = statusList.firstIndex(where: { $0.0 == i && !$0.1 }) {
                        statusList[matchIndex].1 = true
                    }
                }

                return statusList
            }()
                
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 20), spacing: 6) {
                ForEach(Array(valuesWithStatus.enumerated()), id: \.offset) { index, value in
                    Text("\(value.0)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(4)
                        .background(isPresetAvailable ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                        .cornerRadius(4)
                        .strikethrough(value.1)
                }
            }
        }
    }
}

struct SkillCategoryView: View {
    let title: String
    let skills: [String]
    @Binding var characterSkills: [String: Int]
    let availableValues: [Int]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ForEach(skills, id: \.self) { skill in
                HStack {
                    Text(skill)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("", selection: Binding(
                        get: { characterSkills[skill] ?? 0 },
                        set: { characterSkills[skill] = $0 }
                    )) {
                        
                        let currentValue = characterSkills[skill] ?? 0
                        let uniqueValues = Set(availableValues + [currentValue])
                        
                        ForEach(uniqueValues.sorted(by: >), id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 60)
                }
            }
        }
    }
}


struct SkillsStage: View {
    @Binding var character: Character
    @State private var selectedPresetValues: [SkillPreset: [Int]] = [:]
    @State private var availablePresets: Set<SkillPreset> = [.jackOfAllTrades, .balanced, .specialist]
    
    private var allSkills: [String] {
        V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills
    }
    
    private func getPresetValues(for preset: SkillPreset) -> [Int] {
        selectedPresetValues[preset] ?? preset.values
    }
    
    private var allSkillValues: [Int] {
        allSkills.compactMap { skill in
            if V5Constants.physicalSkills.contains(skill) {
                return character.physicalSkills[skill]
            } else if V5Constants.socialSkills.contains(skill) {
                return character.socialSkills[skill]
            } else if V5Constants.mentalSkills.contains(skill) {
                return character.mentalSkills[skill]
            }
            return 0
        }.filter { $0 > 0 }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Presets section
                VStack(alignment: .leading) {
                    Text("Skill Presets")
                        .font(.headline)
                    
                    ForEach(SkillPreset.allCases, id: \.self) { preset in
                        PresetView(
                            preset: preset,
                            presetValues: getPresetValues(for: preset),
                            selectedValues: allSkillValues,
                            isPresetAvailable: availablePresets.contains(preset)
                        )
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                // Skills section
                VStack(alignment: .leading) {
                    Text("Skills")
                        .font(.headline)
                    
                    VStack(spacing: 15) {
                        // Physical Skills
                        SkillCategoryView(
                            title: "Physical",
                            skills: V5Constants.physicalSkills,
                            characterSkills: $character.physicalSkills,
                            availableValues: getAvailableValuesForSelection()
                        )
                        
                        // Social Skills
                        SkillCategoryView(
                            title: "Social",
                            skills: V5Constants.socialSkills,
                            characterSkills: $character.socialSkills,
                            availableValues: getAvailableValuesForSelection()
                        )
                        
                        // Mental Skills
                        SkillCategoryView(
                            title: "Mental",
                            skills: V5Constants.mentalSkills,
                            characterSkills: $character.mentalSkills,
                            availableValues: getAvailableValuesForSelection()
                        )
                    }
                }
            }
            .padding()
        }
        .onAppear {
            initializePresetValues()
        }
        .onChange(of: allSkillValues) {
            updateAvailablePresets()
        }
    }
    
    private func initializePresetValues() {
        selectedPresetValues[.jackOfAllTrades] = SkillPreset.jackOfAllTrades.values
        selectedPresetValues[.balanced] = SkillPreset.balanced.values
        selectedPresetValues[.specialist] = SkillPreset.specialist.values
    }
    
    private func getAvailableValuesForSelection() -> [Int] {
        var availableValues: [Int] = []
        
        // Collect values from all available presets
        for preset in availablePresets {
            if let values = selectedPresetValues[preset] {
                availableValues.append(contentsOf: values)
            }
        }
        
        // Remove already used values
        let usedValues = allSkillValues
        for usedValue in usedValues {
            if let index = availableValues.firstIndex(of: usedValue) {
                availableValues.remove(at: index)
            }
        }
        
        // Always include 0 as it's unlimited
        if !availableValues.contains(0) {
            availableValues.append(0)
        }
        
        return Array(Set(availableValues)).sorted(by: >)
    }
    
    private func updateAvailablePresets() {
        availablePresets.removeAll()
        
        // Check each preset to see if current skill selection matches
        for preset in SkillPreset.allCases {
            if canUsePreset(preset) {
                availablePresets.insert(preset)
            }
        }
    }
    
    private func canUsePreset(_ preset: SkillPreset) -> Bool {
        let currentValues = allSkillValues.sorted(by: >)
        let presetValues = preset.values.sorted(by: >)
        
        // Check if current values can be achieved with this preset
        var availableValues = presetValues
        
        for value in currentValues {
            if value == 0 { continue } // 0 is always available
            if let index = availableValues.firstIndex(of: value) {
                availableValues.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
}
