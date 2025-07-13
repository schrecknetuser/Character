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
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(sphere)
                                        .font(.headline)
                                        .frame(minWidth: 120, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 8) {
                                        Button(action: {
                                            let currentLevel = character.spheres[sphere] ?? 0
                                            if currentLevel > 0 {
                                                print("Decreasing \(sphere) from \(currentLevel) to \(currentLevel - 1)")
                                                character.spheres[sphere] = currentLevel - 1
                                                refresh()
                                            }
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor((character.spheres[sphere] ?? 0) > 0 ? .red : .gray)
                                        }
                                        .disabled((character.spheres[sphere] ?? 0) <= 0)
                                        
                                        Text("\(character.spheres[sphere] ?? 0)")
                                            .font(.headline)
                                            .frame(minWidth: 30)
                                        
                                        Button(action: {
                                            let currentLevel = character.spheres[sphere] ?? 0
                                            if currentLevel < 5 {
                                                print("Increasing \(sphere) from \(currentLevel) to \(currentLevel + 1)")
                                                character.spheres[sphere] = currentLevel + 1
                                                refresh()
                                            }
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor((character.spheres[sphere] ?? 0) < 5 ? .green : .gray)
                                        }
                                        .disabled((character.spheres[sphere] ?? 0) >= 5)
                                    }
                                }
                                
                                // Dots visualization
                                HStack(spacing: 4) {
                                    ForEach(0..<5) { index in
                                        Circle()
                                            .fill(index < (character.spheres[sphere] ?? 0) ? Color.primary : Color.clear)
                                            .stroke(Color.primary, lineWidth: 1)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
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
