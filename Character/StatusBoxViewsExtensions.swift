import SwiftUI

// Paradox Row View for displaying paradox as magic symbols
struct ParadoxRowView: View {
    let paradox: Int
    let availableWidth: CGFloat
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Paradox")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(0..<5, id: \.self) { index in
                    MagicSymbolView(isFilled: index < paradox)
                }
            }
        }
    }
}

// Editable Paradox Row View
struct EditableParadoxRowView: View {
    @Binding var character: MageCharacter
    let availableWidth: CGFloat
    var onChange: (() -> Void)? = nil
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Paradox")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(0..<5, id: \.self) { index in
                    MagicSymbolView(isFilled: index < character.paradox)
                }
            }
            
            // Paradox controls
            HStack {
                if character.paradox > 0 {
                    Button(action: {
                        if character.paradox > 0 {
                            character.paradox -= 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Paradox Level: \(character.paradox)")
                    .font(.body)
                
                Spacer()
                
                if character.paradox < 5 {
                    Button(action: {
                        if character.paradox < 5 {
                            character.paradox += 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}

// Mage Trait Row View for displaying hubris or quiet
struct MageTraitRowView: View {
    let title: String
    let states: [MageTraitState]
    let availableWidth: CGFloat
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(states.indices, id: \.self) { index in
                    MageTraitBoxView(state: states[index])
                }
            }
        }
    }
}

// Editable Mage Trait Row View for hubris and quiet
struct EditableMageTraitRowView: View {
    @Binding var character: MageCharacter
    let title: String
    let traitType: MageTraitType
    let availableWidth: CGFloat
    var onChange: (() -> Void)? = nil
    
    private var states: [MageTraitState] {
        switch traitType {
        case .hubris:
            return character.hubrisStates
        case .quiet:
            return character.quietStates
        }
    }
    
    private var currentValue: Int {
        switch traitType {
        case .hubris:
            return character.hubris
        case .quiet:
            return character.quiet
        }
    }
    
    private func updateStates(_ newStates: [MageTraitState]) {
        switch traitType {
        case .hubris:
            character.hubrisStates = newStates
        case .quiet:
            character.quietStates = newStates
        }
    }
    
    private func updateValue(_ newValue: Int) {
        switch traitType {
        case .hubris:
            character.hubris = newValue
        case .quiet:
            character.quiet = newValue
        }
    }
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(states.indices, id: \.self) { index in
                    MageTraitBoxView(state: states[index])
                }
            }
            
            // Trait controls
            HStack {
                if currentValue > 0 {
                    Button(action: {
                        if currentValue > 0 {
                            decreaseTrait()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("\(title): \(currentValue)")
                    .font(.body)
                
                Spacer()
                
                if currentValue < 5 {
                    Button(action: {
                        if currentValue < 5 {
                            increaseTrait()
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    private func decreaseTrait() {
        var newStates = states
        if let index = newStates.lastIndex(of: .checked) {
            newStates[index] = .unchecked
        }
        newStates = reorderMageTraitStates(newStates)
        updateStates(newStates)
        updateValue(currentValue - 1)
        onChange?()
    }
    
    private func increaseTrait() {
        var newStates = states
        if let index = newStates.firstIndex(of: .unchecked) {
            newStates[index] = .checked
        }
        newStates = reorderMageTraitStates(newStates)
        updateStates(newStates)
        updateValue(currentValue + 1)
        onChange?()
    }
    
    private func reorderMageTraitStates(_ states: [MageTraitState]) -> [MageTraitState] {
        let checkedCount = states.filter { $0 == .checked }.count
        let uncheckedCount = states.filter { $0 == .unchecked }.count
        
        var reorderedStates: [MageTraitState] = []
        reorderedStates.append(contentsOf: Array(repeating: .checked, count: checkedCount))
        reorderedStates.append(contentsOf: Array(repeating: .unchecked, count: uncheckedCount))
        
        return reorderedStates
    }
}

enum MageTraitType {
    case hubris
    case quiet
}

// Arete Row View for displaying arete
struct AreteRowView: View {
    let arete: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Arete")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("\(arete)")
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

// Editable Arete Row View
struct EditableAreteRowView: View {
    @Binding var character: MageCharacter
    var onChange: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Arete")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Arete controls
            HStack {
                if character.arete > 0 {
                    Button(action: {
                        if character.arete > 0 {
                            character.arete -= 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Arete: \(character.arete)")
                    .font(.body)
                
                Spacer()
                
                if character.arete < 5 {
                    Button(action: {
                        if character.arete < 5 {
                            character.arete += 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}