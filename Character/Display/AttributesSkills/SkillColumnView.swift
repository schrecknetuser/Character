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
