import SwiftUI

struct GhoulStatusTab: View {
    @Binding var character: GhoulCharacter
    @Binding var isEditing: Bool
    @State private var refreshID = UUID()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                let baseBinding: Binding<any BaseCharacter> = Binding<any BaseCharacter>(
                    get: { character },
                    set: { newValue in
                        if let newGhoul = newValue as? GhoulCharacter {
                            character = newGhoul
                        }
                    }
                )
                
                VStack(alignment: .leading, spacing: 30) {
                    if isEditing {
                        EditableStatusRowView(
                            character: baseBinding,
                            title: "Health",
                            type: .health,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableStatusRowView(
                            character: baseBinding,
                            title: "Willpower",
                            type: .willpower,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                        EditableGhoulHumanityRowView(
                            character: $character,
                            availableWidth: geometry.size.width - 40,
                            onChange: {refresh()}
                        )
                    } else {
                        StatusRowView(title: "Health", healthStates: character.healthStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Willpower", healthStates: character.willpowerStates, availableWidth: geometry.size.width - 40)
                        StatusRowView(title: "Humanity", humanityStates: character.humanityStates, availableWidth: geometry.size.width - 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private func refresh() {
        refreshID = UUID()
    }
}

// Editable Humanity Row View for Ghouls (similar to vampires)
struct EditableGhoulHumanityRowView: View {
    @Binding var character: GhoulCharacter
    let availableWidth: CGFloat
    var onChange: (() -> Void)? = nil
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Humanity")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(character.humanityStates.indices, id: \.self) { index in
                    HumanityBoxView(state: character.humanityStates[index])
                }
            }
            
            // Humanity controls
            HStack {
                if canDecreaseHumanity() {
                    Button(action: {
                        decreaseHumanity()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Humanity")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseHumanity() {
                    Button(action: {
                        increaseHumanity()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
            
            // Stains controls
            HStack {
                if canDecreaseStains() {
                    Button(action: {
                        decreaseStains()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Stains")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseStains() {
                    Button(action: {
                        increaseStains()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 4)
        }
    }
    
    // Humanity logic
    private func canDecreaseHumanity() -> Bool {
        character.humanityStates.contains(.checked)
    }
    
    private func canIncreaseHumanity() -> Bool {
        character.humanityStates.contains(.unchecked)
    }
    
    private func decreaseHumanity() {
        if let index = character.humanityStates.lastIndex(of: .checked) {
            character.humanityStates[index] = .unchecked
        }
        
        // Reorder humanity states: checked first, then unchecked, then stained on the right
        character.humanityStates = reorderHumanityStates(character.humanityStates)
        onChange?()
    }
    
    private func increaseHumanity() {
        if let index = character.humanityStates.firstIndex(of: .unchecked) {
            character.humanityStates[index] = .checked
        }
        
        // Reorder humanity states: checked first, then unchecked, then stained on the right
        character.humanityStates = reorderHumanityStates(character.humanityStates)
        onChange?()
    }
    
    // Stains logic
    private func canDecreaseStains() -> Bool {
        character.humanityStates.contains(.stained)
    }
    
    private func canIncreaseStains() -> Bool {
        character.humanityStates.contains(.unchecked)
    }
    
    private func decreaseStains() {
        // Remove stains from left to right (first stained box found)
        if let index = character.humanityStates.firstIndex(of: .stained) {
            character.humanityStates[index] = .unchecked
        }
        
        // Reorder humanity states: checked first, then unchecked, then stained on the right
        character.humanityStates = reorderHumanityStates(character.humanityStates)
        onChange?()
    }
    
    private func increaseStains() {
        // Find an unchecked box to convert to stained (stains are added from right to left)
        if let index = character.humanityStates.lastIndex(of: .unchecked) {
            character.humanityStates[index] = .stained
        }
        
        // Reorder humanity states: checked first, then unchecked, then stained on the right
        character.humanityStates = reorderHumanityStates(character.humanityStates)
        onChange?()
    }
    
    // Helper function to reorder humanity states: checked first, then unchecked, then stained on the right
    private func reorderHumanityStates(_ states: [HumanityState]) -> [HumanityState] {
        let checkedCount = states.filter { $0 == .checked }.count
        let stainedCount = states.filter { $0 == .stained }.count
        let uncheckedCount = states.filter { $0 == .unchecked }.count
        
        var reorderedStates: [HumanityState] = []
        reorderedStates.append(contentsOf: Array(repeating: .checked, count: checkedCount))
        reorderedStates.append(contentsOf: Array(repeating: .unchecked, count: uncheckedCount))
        reorderedStates.append(contentsOf: Array(repeating: .stained, count: stainedCount))
        
        return reorderedStates
    }
}