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
                }
            }
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

struct AttributeColumnView: View {
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
                    
                    // Specializations Section
                    if !character.specializations.isEmpty || isEditing {
                        SpecializationsTableView(
                            character: $character,
                            isEditing: isEditing,
                            dynamicFontSize: dynamicFontSize,
                            titleFontSize: titleFontSize,
                            headerFontSize: headerFontSize,
                            rowHeight: rowHeight
                        )
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

struct SpecializationsTableView: View {
    @Binding var character: Character
    let isEditing: Bool
    let dynamicFontSize: CGFloat
    let titleFontSize: CGFloat
    let headerFontSize: CGFloat
    let rowHeight: CGFloat
    @State private var showingAddSpecialization = false
    @State private var selectedSkillForSpecialization = ""
    @State private var editingSpecialization: Specialization?
    @State private var editingSpecializationText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Specializations")
                .font(.system(size: titleFontSize, weight: .bold))
            
            // Calculate maximum rows needed across all columns
            let maxRows = calculateMaxRows()
            
            // 3-column layout for specializations
            HStack(alignment: .top, spacing: 12) {
                SpecializationColumnView(
                    title: "Physical",
                    skills: V5Constants.physicalSkills,
                    character: $character,
                    isEditing: isEditing,
                    dynamicFontSize: dynamicFontSize,
                    headerFontSize: headerFontSize,
                    rowHeight: rowHeight,
                    maxRows: maxRows,
                    onEdit: { specialization in
                        editingSpecialization = specialization
                        editingSpecializationText = specialization.name
                    },
                    onRemove: removeSpecialization
                ).frame(maxWidth: .infinity)
                
                SpecializationColumnView(
                    title: "Social",
                    skills: V5Constants.socialSkills,
                    character: $character,
                    isEditing: isEditing,
                    dynamicFontSize: dynamicFontSize,
                    headerFontSize: headerFontSize,
                    rowHeight: rowHeight,
                    maxRows: maxRows,
                    onEdit: { specialization in
                        editingSpecialization = specialization
                        editingSpecializationText = specialization.name
                    },
                    onRemove: removeSpecialization
                ).frame(maxWidth: .infinity)
                
                SpecializationColumnView(
                    title: "Mental",
                    skills: V5Constants.mentalSkills,
                    character: $character,
                    isEditing: isEditing,
                    dynamicFontSize: dynamicFontSize,
                    headerFontSize: headerFontSize,
                    rowHeight: rowHeight,
                    maxRows: maxRows,
                    onEdit: { specialization in
                        editingSpecialization = specialization
                        editingSpecializationText = specialization.name
                    },
                    onRemove: removeSpecialization
                ).frame(maxWidth: .infinity)
            }
            
            // Add specialization button in edit mode
            if isEditing {
                Button("+ Add Specialization") {
                    showingAddSpecialization = true
                }
                .font(.system(size: dynamicFontSize))
                .foregroundColor(.blue)
                .padding(.top, 8)
            }
        }
        .sheet(isPresented: $showingAddSpecialization) {
            AddSpecializationSheet(
                skillName: selectedSkillForSpecialization,
                character: $character,
                isPresented: $showingAddSpecialization
            )
        }
        .alert("Edit Specialization", isPresented: .constant(editingSpecialization != nil)) {
            TextField("Specialization", text: $editingSpecializationText)
            Button("Save") {
                saveEditedSpecialization()
            }
            Button("Cancel") {
                editingSpecialization = nil
            }
        }
    }
    
    private func calculateMaxRows() -> Int {
        let physicalRows = getColumnRowCount(V5Constants.physicalSkills)
        let socialRows = getColumnRowCount(V5Constants.socialSkills)
        let mentalRows = getColumnRowCount(V5Constants.mentalSkills)
        
        return max(physicalRows, socialRows, mentalRows)
    }
    
    private func getColumnRowCount(_ skills: [String]) -> Int {
        var rows = 0
        for skill in skills {
            let specializations = character.getSpecializations(for: skill)
            if !specializations.isEmpty {
                rows += 1 + specializations.count // 1 for skill name + count of specializations
            }
        }
        return rows
    }
    
    private func saveEditedSpecialization() {
        guard let editingSpec = editingSpecialization else { return }
        
        if let index = character.specializations.firstIndex(where: { $0.id == editingSpec.id }) {
            character.specializations[index].name = editingSpecializationText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        editingSpecialization = nil
        editingSpecializationText = ""
    }
    
    private func removeSpecialization(_ specialization: Specialization) {
        character.specializations.removeAll { $0.id == specialization.id }
    }
}

struct SpecializationColumnView: View {
    let title: String
    let skills: [String]
    @Binding var character: Character
    let isEditing: Bool
    let dynamicFontSize: CGFloat
    let headerFontSize: CGFloat
    let rowHeight: CGFloat
    let maxRows: Int
    let onEdit: (Specialization) -> Void
    let onRemove: (Specialization) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: headerFontSize, weight: .semibold))
            
            // Calculate the content for this column
            let columnContent = getColumnContent()
            
            // Display content rows up to maxRows, filling with empty rows if needed
            ForEach(0..<maxRows, id: \.self) { index in
                HStack {
                    if index < columnContent.count {
                        let item = columnContent[index]
                        
                        switch item {
                        case .skillName(let skillName):
                            Text(skillName)
                                .font(.system(size: dynamicFontSize, weight: .medium))
                                .lineLimit(1)
                            Spacer()
                            
                        case .specialization(let specialization):
                            HStack {
                                Text("• \(specialization.name)")
                                    .font(.system(size: dynamicFontSize - 1))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                if isEditing {
                                    Button("✎") {
                                        onEdit(specialization)
                                    }
                                    .font(.system(size: dynamicFontSize - 2))
                                    .foregroundColor(.blue)
                                    
                                    Button("×") {
                                        onRemove(specialization)
                                    }
                                    .font(.system(size: dynamicFontSize - 2))
                                    .foregroundColor(.red)
                                }
                            }
                            .padding(.leading, 16)
                        }
                    } else {
                        // Empty row to maintain consistent height
                        Spacer()
                    }
                }
                .frame(minHeight: rowHeight)
            }
        }
    }
    
    // Enum to represent different types of content in the column
    private enum ColumnItem {
        case skillName(String)
        case specialization(Specialization)
    }
    
    private func getColumnContent() -> [ColumnItem] {
        var items: [ColumnItem] = []
        
        for skill in skills {
            let specializations = character.getSpecializations(for: skill)
            if !specializations.isEmpty {
                items.append(.skillName(skill))
                for specialization in specializations {
                    items.append(.specialization(specialization))
                }
            }
        }
        
        return items
    }
}
