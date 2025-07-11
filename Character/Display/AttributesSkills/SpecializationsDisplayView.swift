import SwiftUI

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

    private enum ColumnItem {
        case skillName(String)
        case specialization(Specialization)
    }

    private struct TableRow {
        var physical: ColumnItem?
        var social: ColumnItem?
        var mental: ColumnItem?
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Specializations")
                .font(.system(size: titleFontSize, weight: .bold))

            // Table header
            HStack {
                Text("Physical")
                    .font(.system(size: headerFontSize, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Social")
                    .font(.system(size: headerFontSize, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Mental")
                    .font(.system(size: headerFontSize, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                // Table content
                ForEach(generateRows().indices, id: \.self) { index in
                    let row = generateRows()[index]
                    HStack(alignment: .top) {
                        specializationCell(item: row.physical)
                        specializationCell(item: row.social)
                        specializationCell(item: row.mental)
                    }
                    .frame(minHeight: rowHeight)
                }
                
                // Add button
                if isEditing {
                    Button("+ Add Specialization") {
                        showingAddSpecialization = true
                    }
                    .font(.system(size: dynamicFontSize))
                    .foregroundColor(.blue)
                    .padding(.top, 8)
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

    // MARK: - Row and block construction

    private func generateRows() -> [TableRow] {
        let physicalBlocks = getColumnBlocks(for: V5Constants.physicalSkills)
        let socialBlocks = getColumnBlocks(for: V5Constants.socialSkills)
        let mentalBlocks = getColumnBlocks(for: V5Constants.mentalSkills)

        let maxBlockCount = max(physicalBlocks.count, socialBlocks.count, mentalBlocks.count)

        let paddedPhysical = physicalBlocks + Array(repeating: [], count: maxBlockCount - physicalBlocks.count)
        let paddedSocial = socialBlocks + Array(repeating: [], count: maxBlockCount - socialBlocks.count)
        let paddedMental = mentalBlocks + Array(repeating: [], count: maxBlockCount - mentalBlocks.count)

        var rows: [TableRow] = []

        for blockIndex in 0..<maxBlockCount {
            let physBlock = paddedPhysical[blockIndex]
            let socBlock = paddedSocial[blockIndex]
            let mentBlock = paddedMental[blockIndex]

            let maxHeight = max(physBlock.count, socBlock.count, mentBlock.count)

            for line in 0..<maxHeight {
                let row = TableRow(
                    physical: line < physBlock.count ? physBlock[line] : nil,
                    social: line < socBlock.count ? socBlock[line] : nil,
                    mental: line < mentBlock.count ? mentBlock[line] : nil
                )
                rows.append(row)
            }
        }

        return rows
    }

    private func getColumnBlocks(for skills: [String]) -> [[ColumnItem]] {
        var blocks: [[ColumnItem]] = []

        for skill in skills {
            let specs = character.getSpecializations(for: skill)
            if !specs.isEmpty {
                var block: [ColumnItem] = [.skillName(skill)]
                block.append(contentsOf: specs.map { .specialization($0) })
                blocks.append(block)
            }
        }

        return blocks
    }

    // MARK: - Cell rendering

    @ViewBuilder
    private func specializationCell(item: ColumnItem?) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if let item = item {
                switch item {
                case .skillName(let skill):
                    Text(skill)
                        .font(.system(size: dynamicFontSize, weight: .medium))
                        .lineLimit(1)

                case .specialization(let specialization):
                    HStack {
                        Text("\(specialization.name)")
                            .font(.system(size: dynamicFontSize))
                            .foregroundColor(.secondary)
                            .lineLimit(1)

                        Spacer()

                        if isEditing {
                            Button("✎") {
                                editingSpecialization = specialization
                                editingSpecializationText = specialization.name
                            }
                            .font(.system(size: dynamicFontSize))
                            .foregroundColor(.blue)

                            Button("×") {
                                removeSpecialization(specialization)
                            }
                            .font(.system(size: dynamicFontSize))
                            .foregroundColor(.red)
                        }
                    }
                    .padding(.leading, 8)
                }
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Edit/Remove

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
