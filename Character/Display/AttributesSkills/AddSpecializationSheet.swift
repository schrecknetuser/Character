import SwiftUI

struct AddSpecializationSheet: View {
    let skillName: String
    @Binding var character: any BaseCharacter
    @Binding var isPresented: Bool
    @State private var specializationText = ""
    @State private var selectedSkill = ""

    private var skillsWithPoints: [String] {
        return character.getSkillsWithPoints()
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Specialization")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Skill:")
                        .font(.headline)

                    Picker("Skill", selection: $selectedSkill) {
                        Text("Select a skill...").tag("")
                        ForEach(skillsWithPoints, id: \.self) { skill in
                            Text(skill).tag(skill)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Specialization:")
                        .font(.headline)

                    TextField("Enter specialization", text: $specializationText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if !selectedSkill.isEmpty,
                       let skillInfo = V5Constants.getSkillInfo(for: selectedSkill),
                       !skillInfo.specializationExamples.isEmpty {
                        Text("Examples: \(skillInfo.specializationExamples.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Add Specialization")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSpecialization()
                    }
                    .disabled(selectedSkill.isEmpty || specializationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            if !skillName.isEmpty && skillsWithPoints.contains(skillName) {
                selectedSkill = skillName
            } else if skillsWithPoints.count == 1 {
                selectedSkill = skillsWithPoints[0]
            }
        }
    }

    private func addSpecialization() {
        let trimmedText = specializationText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty && !selectedSkill.isEmpty else { return }

        let newSpecialization = Specialization(skillName: selectedSkill, name: trimmedText)
        character.specializations.append(newSpecialization)

        isPresented = false
    }
}
