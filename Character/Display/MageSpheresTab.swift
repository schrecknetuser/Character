import SwiftUI

struct MageSpheresTab: View {
    @Binding var character: MageCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var refreshID: UUID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Spheres")) {
                    if isEditing {
                        // Use the same UI as creation mode when editing
                        ForEach(V5Constants.mageSpheres, id: \.self) { sphere in
                            SphereRowView(
                                sphereName: sphere,
                                sphereLevel: Binding(
                                    get: { 
                                        let value = character.spheres[sphere] ?? 0
                                        print("Getting \(sphere) value: \(value)")
                                        return value
                                    },
                                    set: { newValue in 
                                        print("Setting \(sphere) to \(newValue)")
                                        character.spheres[sphere] = newValue
                                        print("Character spheres now: \(character.spheres)")
                                    }
                                ),
                                onChange: { 
                                    print("onChange called for \(sphere), calling refresh()")
                                    refresh() 
                                }
                            )
                        }
                    } else {
                        // Read-only view when not editing
                        let learnedSpheres = character.spheres.filter { $0.value > 0 }.sorted { $0.key < $1.key }
                        if learnedSpheres.isEmpty {
                            Text("No spheres learned")
                                .foregroundColor(.secondary)
                                .font(.system(size: dynamicFontSize))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        } else {
                            ForEach(learnedSpheres, id: \.0) { sphere, level in
                                HStack {
                                    Text(sphere)
                                        .font(.system(size: dynamicFontSize))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                    Text("Level \(level)")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize * 0.8))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                            }
                        }
                    }
                }
                
                if isEditing {
                    Section(header: Text("Arete Configuration")) {
                        HStack {
                            Text("Arete")
                                .font(.system(size: dynamicFontSize))
                            Spacer()
                            Picker("", selection: $character.arete) {
                                ForEach(0...5, id: \.self) { value in
                                    Text("Level \(value)").tag(value)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
            }
            .id(refreshID)
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
    
    private func refresh() {
        refreshID = UUID()
    }
}
