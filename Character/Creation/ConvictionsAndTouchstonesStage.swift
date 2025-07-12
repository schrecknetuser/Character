import SwiftUI


struct ConvictionsAndTouchstonesStage: View {
    @Binding var character: any BaseCharacter
    @State private var newConviction = ""
    @State private var newTouchstone = ""
    @State private var showingAddConviction = false
    @State private var showingAddTouchstone = false
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
                
                Button("Add Conviction") {
                    showingAddConviction = true
                }
                .foregroundColor(.accentColor)
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
                
                Button("Add Touchstone") {
                    showingAddTouchstone = true
                }
                .foregroundColor(.accentColor)
            }
            
            Section(footer: Text("Convictions and touchstones are optional for character creation.")) {
                EmptyView()
            }
        }
        .alert("Add Conviction", isPresented: $showingAddConviction) {
            TextField("Enter conviction", text: $newConviction)
            Button("Add") {
                if !newConviction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    character.convictions.append(newConviction.trimmingCharacters(in: .whitespacesAndNewlines))
                    newConviction = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newConviction = ""
            }
        }
        .alert("Add Touchstone", isPresented: $showingAddTouchstone) {
            TextField("Enter touchstone", text: $newTouchstone)
            Button("Add") {
                if !newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    character.touchstones.append(newTouchstone.trimmingCharacters(in: .whitespacesAndNewlines))
                    newTouchstone = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newTouchstone = ""
            }
        }
        .id(refreshID)
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}
