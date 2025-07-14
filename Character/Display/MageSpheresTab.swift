import SwiftUI

struct MageSpheresTab: View {
    @Binding var character: MageCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Spheres")) {
                    if isEditing {
                        // Use the same UI as creation mode when editing
                        ForEach(V5Constants.mageSpheres, id: \.self) { sphere in
                            SphereRowView(
                                sphereName: sphere,
                                initialLevel: character.spheres[sphere] ?? 0,
                                onChange: { newValue in
                                    var newSpheres = character.spheres
                                    newSpheres[sphere] = newValue
                                    character.spheres = newSpheres
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
                
                Section(header: Text("Arete")) {
                    SphereRowView(
                        labelText: "Arete",
                        initialLevel: character.arete,
                        onChange: { newValue in
                            character.arete = newValue
                        },
                        isEditing: isEditing
                    )
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                // Add bottom padding to prevent floating buttons from covering content
                // Button height (56) + spacing above button (20) + tab bar height (49) + spacing (20) = 145
                Color.clear.frame(height: 145)
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
