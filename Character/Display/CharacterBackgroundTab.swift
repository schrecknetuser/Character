import SwiftUI

struct CharacterBackgroundTab: View {
    @Binding var character: any BaseCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var newConviction: String = ""
    @State private var newTouchstone: String = ""
    @State private var refreshID: UUID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Character Background")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ambition:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        if isEditing {
                            TextField("Ambition", text: $character.ambition, axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(3...6)
                        } else {
                            if !character.ambition.isEmpty {
                                Text(character.ambition)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Desire:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        if isEditing {
                            TextField("Desire", text: $character.desire, axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(3...6)
                        } else {
                            if !character.desire.isEmpty {
                                Text(character.desire)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Convictions")) {
                    if character.convictions.isEmpty {
                        Text("No convictions recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.convictions.indices, id: \.self) { index in
                            HStack {
                                Text(character.convictions[index])
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Button("Remove") {
                                        character.convictions.remove(at: index)
                                        refreshID = UUID()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    if isEditing {
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("New conviction", text: $newConviction, axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(2...4)
                            Button("Add") {
                                if !newConviction.trim().isEmpty {
                                    character.convictions.append(newConviction.trim())
                                    newConviction = ""
                                }
                            }
                            .disabled(newConviction.trim().isEmpty)
                        }
                    }
                }
                
                Section(header: Text("Touchstones")) {
                    if character.touchstones.isEmpty {
                        Text("No touchstones recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                    } else {
                        ForEach(character.touchstones.indices, id: \.self) { index in
                            HStack {
                                Text(character.touchstones[index])
                                    .font(.system(size: dynamicFontSize))
                                Spacer()
                                if isEditing {
                                    Button("Remove") {
                                        character.touchstones.remove(at: index)
                                        refreshID = UUID()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    if isEditing {
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("New touchstone", text: $newTouchstone, axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(2...4)
                            Button("Add") {
                                if !newTouchstone.trim().isEmpty {
                                    character.touchstones.append(newTouchstone.trim())
                                    newTouchstone = ""
                                }
                            }
                            .disabled(newTouchstone.trim().isEmpty)
                        }
                    }
                }
                
                Section(header: Text("Description & Notes")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Character Description:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        if isEditing {
                            TextField("Character Description", text: $character.characterDescription, axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(3...10)
                        } else {
                            if !character.characterDescription.isEmpty {
                                Text(character.characterDescription)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        if isEditing {
                            TextField("Notes", text: $character.notes, axis: .vertical)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(3...10)
                        } else {
                            if !character.notes.isEmpty {
                                Text(character.notes)
                                    .font(.system(size: dynamicFontSize))
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: dynamicFontSize))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                // Add bottom padding to prevent floating buttons from covering content
                Color.clear.frame(height: UIConstants.contentBottomPadding())
            }
            .onAppear {
                calculateOptimalFontSize(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSize(for: newSize)
            }
        }
    }
    
    private func calculateOptimalFontSize(for size: CGSize) {
        // Calculate based on screen width with more conservative scaling
        let baseSize: CGFloat = 16
        let minSize: CGFloat = 11
        let maxSize: CGFloat = 18
        
        // Scale font size based on available width
        let scaleFactor = min(1.2, size.width / 375) // iPhone standard width, cap at 1.2x
        let calculatedSize = baseSize * scaleFactor
        
        dynamicFontSize = max(minSize, min(maxSize, calculatedSize))
    }
}