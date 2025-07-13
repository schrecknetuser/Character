import SwiftUI


struct ConvictionsAndTouchstonesStage: View {
    @Binding var character: any BaseCharacter
    @State private var newConviction = ""
    @State private var newTouchstone = ""
    @State private var refreshID = UUID()
    
    var body: some View {
        Form {
            Section(header: Text("Convictions")) {
                if character.convictions.isEmpty {
                    Text("No convictions defined")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.convictions.indices, id: \.self) { index in
                        HStack {
                            Text(character.convictions[index])
                            Spacer()
                            Button("Remove") {
                                character.convictions.remove(at: index)
                                refresh()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter new conviction", text: $newConviction, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2...4)
                    Button("Add Conviction") {
                        if !newConviction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            character.convictions.append(newConviction.trimmingCharacters(in: .whitespacesAndNewlines))
                            newConviction = ""
                            refresh()
                        }
                    }
                    .disabled(newConviction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            
            Section(header: Text("Touchstones")) {
                if character.touchstones.isEmpty {
                    Text("No touchstones defined")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(character.touchstones.indices, id: \.self) { index in
                        HStack {
                            Text(character.touchstones[index])
                            Spacer()
                            Button("Remove") {
                                character.touchstones.remove(at: index)
                                refresh()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Enter new touchstone", text: $newTouchstone, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2...4)
                    Button("Add Touchstone") {
                        if !newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            character.touchstones.append(newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines))
                            newTouchstone = ""
                            refresh()
                        }
                    }
                    .disabled(newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            
            Section(footer: Text("Convictions and touchstones are optional for character creation.")) {
                EmptyView()
            }
        }
        .id(refreshID)
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}
