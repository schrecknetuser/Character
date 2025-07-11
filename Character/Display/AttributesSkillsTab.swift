import SwiftUI

struct SkillColumnView: View {
    let title: String
    let skills: [String]
    @Binding var skillValues: [String: Int]
    @Binding var character: Character
    let isEditing: Bool
    let dynamicFontSize: CGFloat
    let headerFontSize: CGFloat
    let rowHeight: CGFloat
    @State private var showingAddSpecialization = false
    @State private var selectedSkillForSpecialization = ""
    @State private var newSpecializationText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: headerFontSize, weight: .semibold))

            ForEach(skills, id: \.self) { skill in
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(skill)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)

                        Spacer()

                        if isEditing {
                            Picker("", selection: Binding(
                                get: { skillValues[skill] ?? 0 },
                                set: { skillValues[skill] = $0 }
                            )) {
                                ForEach(0...5, id: \.self) { value in
                                    Text("\(value)")
                                        .font(.system(size: dynamicFontSize))
                                        .tag(value)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 55)
                            .clipped()
                        } else {
                            Text("\(skillValues[skill] ?? 0)")
                                .font(.system(size: dynamicFontSize, weight: .medium))
                                .frame(width: 25, alignment: .center)
                        }
                    }
                    .frame(minHeight: rowHeight)
                    
                    // Display specializations for this skill
                    let specializations = character.getSpecializations(for: skill)
                    if !specializations.isEmpty {
                        SpecializationsDisplayView(
                            specializations: specializations,
                            isEditing: isEditing,
                            dynamicFontSize: dynamicFontSize,
                            onRemove: { specialization in
                                character.specializations.removeAll { $0.id == specialization.id }
                            }
                        )
                    }
                    
                    // Add specialization button in edit mode
                    if isEditing && (skillValues[skill] ?? 0) > 0 {
                        Button("+ Add Specialization") {
                            selectedSkillForSpecialization = skill
                            showingAddSpecialization = true
                        }
                        .font(.system(size: dynamicFontSize - 2))
                        .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSpecialization) {
            AddSpecializationSheet(
                skillName: selectedSkillForSpecialization,
                character: $character,
                isPresented: $showingAddSpecialization
            )
        }
    }
}

struct SpecializationsDisplayView: View {
    let specializations: [Specialization]
    let isEditing: Bool
    let dynamicFontSize: CGFloat
    let onRemove: (Specialization) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(specializations) { specialization in
                HStack {
                    Text(specialization.name)
                        .font(.system(size: dynamicFontSize - 1))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    if isEditing {
                        Button("×") {
                            onRemove(specialization)
                        }
                        .font(.system(size: dynamicFontSize - 2))
                        .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
            }
        }
        .padding(.leading, 16)
    }
}

struct AddSpecializationSheet: View {
    let skillName: String
    @Binding var character: Character
    @Binding var isPresented: Bool
    @State private var specializationText = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add Specialization for \(skillName)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter specialization", text: $specializationText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if let skillInfo = V5Constants.getSkillInfo(for: skillName),
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
                    .disabled(specializationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func addSpecialization() {
        let trimmedText = specializationText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newSpecialization = Specialization(skillName: skillName, name: trimmedText)
        character.specializations.append(newSpecialization)
        
        isPresented = false
    }
}
    let title: String
    let attributes: [String]
    @Binding var attributeValues: [String: Int]
    let isEditing: Bool
    let dynamicFontSize: CGFloat
    let headerFontSize: CGFloat
    let rowHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: headerFontSize, weight: .semibold))

            ForEach(attributes, id: \.self) { attribute in
                HStack(spacing: 6) {
                    Text(attribute)
                        .font(.system(size: dynamicFontSize))
                        .lineLimit(1)

                    Spacer()

                    if isEditing {
                        Picker("", selection: Binding(
                            get: { attributeValues[attribute] ?? 1 },
                            set: { attributeValues[attribute] = $0 }
                        )) {
                            ForEach(0...5, id: \.self) { value in
                                Text("\(value)")
                                    .font(.system(size: dynamicFontSize))
                                    .tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 55)
                        .clipped()
                    } else {
                        Text("\(attributeValues[attribute] ?? 1)")
                            .font(.system(size: dynamicFontSize, weight: .medium))
                            .frame(width: 25, alignment: .center)
                    }
                }
                .frame(minHeight: rowHeight)
            }
        }
    }
}

struct AttributesSkillsTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 14
    @State private var titleFontSize: CGFloat = 20
    @State private var headerFontSize: CGFloat = 17
    @State private var rowHeight: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Attributes Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Attributes")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 12) {
                            AttributeColumnView(
                                title: "Physical",
                                attributes: V5Constants.physicalAttributes,
                                attributeValues: $character.physicalAttributes,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            AttributeColumnView(
                                title: "Mental",
                                attributes: V5Constants.mentalAttributes,
                                attributeValues: $character.mentalAttributes,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            AttributeColumnView(
                                title: "Social",
                                attributes: V5Constants.socialAttributes,
                                attributeValues: $character.socialAttributes,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Skills Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Skills")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 12) {
                            // Physical Skills Column
                            
                            SkillColumnView(
                                title: "Physical",
                                skills: V5Constants.physicalSkills,
                                skillValues: $character.physicalSkills,
                                character: $character,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            SkillColumnView(
                                title: "Social",
                                skills: V5Constants.socialSkills,
                                skillValues: $character.socialSkills,
                                character: $character,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            SkillColumnView(
                                title: "Mental",
                                skills: V5Constants.mentalSkills,
                                skillValues: $character.mentalSkills,
                                character: $character,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .onAppear {
                    calculateOptimalFontSizes(for: geometry.size)
                }
                .onChange(of: geometry.size) { _, newSize in
                    calculateOptimalFontSizes(for: newSize)
                }
            }
        }
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width and available space
        let availableWidth = (size.width - 120) / 3 // Account for padding and 3 columns, more conservative
        
        // Find the longest text among all displayed values
        let allDisplayedTexts = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes +
                               V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills +
                               ["Physical", "Social", "Mental", "Attributes", "Skills"]
        let longestText = allDisplayedTexts.max(by: { $0.count < $1.count }) ?? "Intelligence"
        
        // Determine optimal font size based on available width per column
        let scaleFactor = min(1.0, availableWidth / (CGFloat(longestText.count) * 8)) // More conservative character width estimate
        
        // Base font sizes adjusted for actual content - more conservative
        let baseDynamicSize: CGFloat = 11
        let baseTitleSize: CGFloat = 17
        let baseHeaderSize: CGFloat = 14
        let baseRowHeight: CGFloat = 24
        
        // Calculate scaled sizes with more conservative scaling
        dynamicFontSize = max(9, min(13, baseDynamicSize * scaleFactor))
        titleFontSize = max(15, min(19, baseTitleSize * scaleFactor))
        headerFontSize = max(12, min(16, baseHeaderSize * scaleFactor))
        rowHeight = max(22, min(28, baseRowHeight * scaleFactor))
    }
}
