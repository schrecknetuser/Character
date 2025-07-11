import SwiftUI

// Add Sphere View for Mages
struct AddMageSphereView: View {
    @Binding var character: MageCharacter
    @Environment(\.dismiss) var dismiss
    
    var availableSpheres: [String] {
        V5Constants.mageSpheres.filter { (character.spheres[$0] ?? 0) == 0 }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Available Spheres") {
                    ForEach(availableSpheres, id: \.self) { sphere in
                        Button(sphere) {
                            character.spheres[sphere] = 1
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add Sphere")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MageSpheresTab: View {
    @Binding var character: MageCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var showingAddSphere = false
    @State private var refreshID: UUID = UUID()
    
    var learnedSpheres: [(String, Int)] {
        character.spheres.filter { $0.value > 0 }.sorted { $0.key < $1.key }
    }
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Spheres")) {
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
                                if isEditing {
                                    Picker("", selection: Binding(
                                        get: { character.spheres[sphere] ?? 0 },
                                        set: { newValue in
                                            character.spheres[sphere] = newValue
                                            refreshID = UUID()
                                        }
                                    )) {
                                        ForEach(0...5, id: \.self) { value in
                                            Text("Level \(value)").tag(value)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                } else {
                                    Text("Level \(level)")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: dynamicFontSize * 0.8))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                            }
                        }
                    }
                    
                    if isEditing {
                        Button("Add Sphere") {
                            showingAddSphere = true
                        }
                        .foregroundColor(.accentColor)
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
            .onAppear {
                calculateOptimalFontSize(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSize(for: newSize)
            }
            .sheet(isPresented: $showingAddSphere) {
                AddMageSphereView(character: $character)
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