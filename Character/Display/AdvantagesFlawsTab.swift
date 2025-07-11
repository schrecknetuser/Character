import SwiftUI

// Editable Merits List View
struct EditableAdvantagesListView: View {
    @Binding var selectedAdvantages: [Advantage]
    @State private var showingAddAdvantage = false
    
    var body: some View {
        Button("Add Merit") {
            showingAddAdvantage = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddAdvantage) {
            AddAdvantageView(selectedAdvantages: $selectedAdvantages)
        }
    }
}

// Editable Flaws List View
struct EditableFlawsListView: View {
    @Binding var selectedFlaws: [Flaw]
    @State private var showingAddFlaw = false
    
    var body: some View {
        Button("Add Flaw") {
            showingAddFlaw = true
        }
        .foregroundColor(.accentColor)
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws)
        }
    }
}

// Helper view for managing advantages list
struct AdvantagesListView: View {
    @Binding var selectedAdvantages: [Advantage]
    @State private var showingAddAdvantage = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Merits")
                    .font(.headline)
                Spacer()
                Text("Total Cost: \(selectedAdvantages.reduce(0) { $0 + $1.cost })")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(selectedAdvantages) { advantage in
                HStack {
                    Text(advantage.name)
                    Spacer()
                    Text("\(advantage.cost) pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(action: {
                        selectedAdvantages.removeAll { $0.id == advantage.id }
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add Merit") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showingAddAdvantage = true
            }
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $showingAddAdvantage) {
            AddAdvantageView(selectedAdvantages: $selectedAdvantages)
        }
    }
}

// Helper view for adding advantages
struct AddAdvantageView: View {
    @Binding var selectedAdvantages: [Advantage]
    @Environment(\.dismiss) var dismiss
    @State private var selectedPredefined: Advantage?
    @State private var customName = ""
    @State private var customCost = 1
    @State private var isCustom = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Predefined Merits") {
                    ForEach(V5Constants.predefinedAdvantages) { advantage in
                        HStack {
                            Text(advantage.name)
                            Spacer()
                            Text("\(advantage.cost) pts")
                                .foregroundColor(.secondary)
                            Button("Add") {
                                let newAdvantage = Advantage(name: advantage.name, cost: advantage.cost, isCustom: advantage.isCustom)
                                selectedAdvantages.append(newAdvantage)
                                // Small delay to ensure state update is processed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                }
                            }
                            .disabled(selectedAdvantages.contains { $0.name == advantage.name })
                        }
                    }
                }
                
                Section("Custom Merit") {
                    TextField("Name", text: $customName)
                    Stepper("Cost: \(customCost)", value: $customCost, in: 1...10)
                    Button("Add Custom") {
                        let customAdvantage = Advantage(name: customName, cost: customCost, isCustom: true)
                        selectedAdvantages.append(customAdvantage)
                        // Small delay to ensure state update is processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(customName.isEmpty)
                }
            }
            .navigationTitle("Add Merit")
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

// Helper view for managing flaws list
struct FlawsListView: View {
    @Binding var selectedFlaws: [Flaw]
    @State private var showingAddFlaw = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Flaws")
                    .font(.headline)
                Spacer()
                Text("Total Value: \(abs(selectedFlaws.reduce(0) { $0 + $1.cost })) pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(selectedFlaws) { flaw in
                HStack {
                    Text(flaw.name)
                    Spacer()
                    Text("\(abs(flaw.cost)) pts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button(action: {
                        selectedFlaws.removeAll { $0.id == flaw.id }
                    }) {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Button("Add Flaw") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showingAddFlaw = true
            }
            .foregroundColor(.accentColor)
        }
        .sheet(isPresented: $showingAddFlaw) {
            AddFlawView(selectedFlaws: $selectedFlaws)
        }
    }
}

// Helper view for adding flaws
struct AddFlawView: View {
    @Binding var selectedFlaws: [Flaw]
    @Environment(\.dismiss) var dismiss
    @State private var customName = ""
    @State private var customCost = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section("Predefined Flaws") {
                    ForEach(V5Constants.predefinedFlaws) { flaw in
                        HStack {
                            Text(flaw.name)
                            Spacer()
                            Text("\(abs(flaw.cost)) pts")
                                .foregroundColor(.secondary)
                            Button("Add") {
                                let newFlaw = Flaw(name: flaw.name, cost: flaw.cost, isCustom: flaw.isCustom)
                                selectedFlaws.append(newFlaw)
                                // Small delay to ensure state update is processed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    dismiss()
                                }
                            }
                            .disabled(selectedFlaws.contains { $0.name == flaw.name })
                        }
                    }
                }
                
                Section("Custom Flaw") {
                    TextField("Name", text: $customName)
                    Stepper("Value: \(customCost)", value: $customCost, in: 1...10)
                    Button("Add Custom") {
                        let customFlaw = Flaw(name: customName, cost: -customCost, isCustom: true) // Negative cost for flaws
                        selectedFlaws.append(customFlaw)
                        // Small delay to ensure state update is processed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                    .disabled(customName.isEmpty)
                }
            }
            .navigationTitle("Add Flaw")
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

struct AdvantagesFlawsTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    @State private var captionFontSize: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Merits")) {
                    if character.advantages.isEmpty {
                        Text("No merits recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.advantages) { advantage in
                            HStack {
                                Text(advantage.name)
                                    .font(.system(size: dynamicFontSize))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                if advantage.isCustom {
                                    Text("(Custom)")
                                        .font(.system(size: captionFontSize))
                                        .foregroundColor(.orange)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                                Text("\(advantage.cost) pts")
                                    .font(.system(size: captionFontSize))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                                if isEditing {
                                    Button("Remove") {
                                        character.advantages.removeAll { $0.id == advantage.id }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        HStack {
                            Text("Total Cost:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text("\(character.totalAdvantageCost) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    if isEditing {
                        EditableAdvantagesListView(selectedAdvantages: $character.advantages)
                    }
                }
                
                Section(header: Text("Flaws")) {
                    if character.flaws.isEmpty {
                        Text("No flaws recorded")
                            .foregroundColor(.secondary)
                            .font(.system(size: dynamicFontSize))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    } else {
                        ForEach(character.flaws) { flaw in
                            HStack {
                                Text(flaw.name)
                                    .font(.system(size: dynamicFontSize))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                if flaw.isCustom {
                                    Text("(Custom)")
                                        .font(.system(size: captionFontSize))
                                        .foregroundColor(.orange)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                }
                                Text("\(abs(flaw.cost)) pts")
                                    .font(.system(size: captionFontSize))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.6)
                                if isEditing {
                                    Button("Remove") {
                                        character.flaws.removeAll { $0.id == flaw.id }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        HStack {
                            Text("Total Value:")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text("\(abs(character.totalFlawValue)) pts")
                                .font(.system(size: dynamicFontSize, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    if isEditing {
                        EditableFlawsListView(selectedFlaws: $character.flaws)
                    }
                }
            }
            .onAppear {
                calculateOptimalFontSizes(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSizes(for: newSize)
            }
        }
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width with more conservative scaling
        let scaleFactor = min(1.2, size.width / 375) // iPhone standard width, cap at 1.2x
        
        let baseDynamicSize: CGFloat = 16
        let baseCaptionSize: CGFloat = 12
        
        dynamicFontSize = max(11, min(18, baseDynamicSize * scaleFactor))
        captionFontSize = max(9, min(14, baseCaptionSize * scaleFactor))
    }
}
