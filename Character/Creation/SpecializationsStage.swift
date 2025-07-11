import SwiftUI

struct SpecializationsStage: View {
    @Binding var character: Character
    @State private var newSpecializationText: [String: String] = [:]
    @State private var selectedSkillForAdditional: String = ""
    @State private var additionalSpecializationText: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Skill Specializations")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Characters with points in Academics, Craft, Performance, or Science must select a free specialization for each of those skills. You may also select one additional specialization for any skill you have points in.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Required specializations section
                let requiredSkills = character.getSkillsRequiringFreeSpecializationWithPoints()
                if !requiredSkills.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Required Specializations")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        ForEach(requiredSkills, id: \.self) { skillName in
                            SpecializationInputView(
                                skillName: skillName,
                                character: $character,
                                newSpecializationText: $newSpecializationText,
                                isRequired: true
                            )
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Additional specialization section
                let skillsWithPoints = character.getSkillsWithPoints()
                if !skillsWithPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Additional Specialization")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        Text("Select one additional skill to specialize in:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Picker("Select Skill", selection: $selectedSkillForAdditional) {
                                Text("Select a skill...").tag("")
                                ForEach(skillsWithPoints.sorted(), id: \.self) { skill in
                                    Text(skill).tag(skill)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            if !selectedSkillForAdditional.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    TextField("Enter specialization", text: $additionalSpecializationText)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    if let skillInfo = V5Constants.getSkillInfo(for: selectedSkillForAdditional),
                                       !skillInfo.specializationExamples.isEmpty {
                                        Text("Examples: \(skillInfo.specializationExamples.joined(separator: ", "))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Button("Add Specialization") {
                                        addAdditionalSpecialization()
                                    }
                                    .disabled(additionalSpecializationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Current specializations display
                if !character.specializations.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Current Specializations")
                            .font(.headline)
                        
                        ForEach(character.specializations) { specialization in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(specialization.skillName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(specialization.name)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button("Remove") {
                                    removeSpecialization(specialization)
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func addAdditionalSpecialization() {
        let trimmedText = additionalSpecializationText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty && !selectedSkillForAdditional.isEmpty else { return }
        
        let newSpecialization = Specialization(skillName: selectedSkillForAdditional, name: trimmedText)
        character.specializations.append(newSpecialization)
        
        // Reset the form
        additionalSpecializationText = ""
        selectedSkillForAdditional = ""
    }
    
    private func removeSpecialization(_ specialization: Specialization) {
        character.specializations.removeAll { $0.id == specialization.id }
    }
}

struct SpecializationInputView: View {
    let skillName: String
    @Binding var character: Character
    @Binding var newSpecializationText: [String: String]
    let isRequired: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(skillName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if isRequired {
                    Text("(Required)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            let currentSpecializations = character.getSpecializations(for: skillName)
            
            if isRequired && currentSpecializations.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    TextField("Enter specialization", text: Binding(
                        get: { newSpecializationText[skillName] ?? "" },
                        set: { newSpecializationText[skillName] = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let skillInfo = V5Constants.getSkillInfo(for: skillName),
                       !skillInfo.specializationExamples.isEmpty {
                        Text("Examples: \(skillInfo.specializationExamples.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Add Required Specialization") {
                        addSpecialization(for: skillName)
                    }
                    .disabled((newSpecializationText[skillName] ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            } else if !currentSpecializations.isEmpty {
                Text("✓ \(currentSpecializations.first?.name ?? "")")
                    .font(.body)
                    .foregroundColor(.green)
            }
        }
    }
    
    private func addSpecialization(for skillName: String) {
        guard let text = newSpecializationText[skillName] else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newSpecialization = Specialization(skillName: skillName, name: trimmedText)
        character.specializations.append(newSpecialization)
        
        // Clear the text field
        newSpecializationText[skillName] = ""
    }
}