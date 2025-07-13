import SwiftUI

struct AttributeColumnView: View {
    let title: String
    let attributes: [String]
    @Binding var attributeValues: [String: Int]
    let isEditing: Bool
    let dynamicFontSize: CGFloat
    let headerFontSize: CGFloat
    let rowHeight: CGFloat
    @State private var refreshID: UUID = UUID()

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
                            set: {
                                attributeValues[attribute] = $0
                                refreshID = UUID()
                            }
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
