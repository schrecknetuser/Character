import SwiftUI

// Shared box size constant for consistency
let statusBoxSize: CGFloat = 25

// Health/Willpower Box View
struct HealthBoxView: View {
    let state: HealthState
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: statusBoxSize, height: statusBoxSize)
            
            switch state {
            case .ok:
                EmptyView()
            case .superficial:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: statusBoxSize))
                    path.addLine(to: CGPoint(x: statusBoxSize, y: 0))
                }
                .stroke(Color.primary, lineWidth: 1)
            case .aggravated:
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: statusBoxSize, y: statusBoxSize))
                    }
                    .stroke(Color.primary, lineWidth: 1)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: statusBoxSize))
                        path.addLine(to: CGPoint(x: statusBoxSize, y: 0))
                    }
                    .stroke(Color.primary, lineWidth: 1)
                }
            }
        }
        .frame(width: statusBoxSize, height: statusBoxSize)
    }
}

// Humanity Box View
struct HumanityBoxView: View {
    let state: HumanityState
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: statusBoxSize, height: statusBoxSize)
            
            switch state {
            case .unchecked:
                EmptyView()
            case .checked:
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: statusBoxSize - 2, height: statusBoxSize - 2)
            case .stained:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: statusBoxSize))
                    path.addLine(to: CGPoint(x: statusBoxSize, y: 0))
                }
                .stroke(Color.primary, lineWidth: 1)
            }
        }
        .frame(width: statusBoxSize, height: statusBoxSize)
    }
}

// Blood Drop View for Hunger tracking
struct BloodDropView: View {
    let isFilled: Bool
    
    var body: some View {
        Image(systemName: isFilled ? "drop.fill" : "drop")
            .font(.system(size: statusBoxSize - 5))
            .foregroundColor(isFilled ? .red : .gray)
            .frame(width: statusBoxSize, height: statusBoxSize)
    }
}

// Magic Symbol View for Paradox tracking
struct MagicSymbolView: View {
    let isFilled: Bool
    
    var body: some View {
        Image(systemName: isFilled ? "star.fill" : "star")
            .font(.system(size: statusBoxSize - 5))
            .foregroundColor(isFilled ? .purple : .gray)
            .frame(width: statusBoxSize, height: statusBoxSize)
    }
}

// Mage Trait Box View (for hubris and quiet - no stains)
struct MageTraitBoxView: View {
    let state: MageTraitState
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: statusBoxSize, height: statusBoxSize)
            
            switch state {
            case .unchecked:
                EmptyView()
            case .checked:
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: statusBoxSize - 2, height: statusBoxSize - 2)
            }
        }
        .frame(width: statusBoxSize, height: statusBoxSize)
    }
}

// Status Row View for displaying a row of boxes
struct StatusRowView: View {
    let title: String
    let healthStates: [HealthState]?
    let humanityStates: [HumanityState]?
    let availableWidth: CGFloat
    
    init(title: String, healthStates: [HealthState], availableWidth: CGFloat) {
        self.title = title
        self.healthStates = healthStates
        self.humanityStates = nil
        self.availableWidth = availableWidth
    }
    
    init(title: String, humanityStates: [HumanityState], availableWidth: CGFloat) {
        self.title = title
        self.healthStates = nil
        self.humanityStates = humanityStates
        self.availableWidth = availableWidth
    }
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5 // box + spacing
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            if let healthStates = healthStates {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                    ForEach(healthStates.indices, id: \.self) { index in
                        HealthBoxView(state: healthStates[index])
                    }
                }
            }
            
            if let humanityStates = humanityStates {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                    ForEach(humanityStates.indices, id: \.self) { index in
                        HumanityBoxView(state: humanityStates[index])
                    }
                }
            }
        }
    }
}

enum StatusType {
    case health
    case willpower
}

// Editable Status Row View for Health and Willpower
struct EditableStatusRowView: View {
    @Binding var character: any BaseCharacter
    let title: String
    let type: StatusType
    let availableWidth: CGFloat
    var onChange: (() -> Void)? = nil
    
    private var states: [HealthState] {
        switch type {
        case .health:
            return character.healthStates
        case .willpower:
            return character.willpowerStates
        }
    }
    
    private var boxCount: Int {
        switch type {
        case .health:
            return character.healthBoxCount
        case .willpower:
            return character.willpowerBoxCount
        }
    }
    
    private func updateStates(_ newStates: [HealthState]) {
        switch type {
        case .health:
            character.healthStates = newStates
        case .willpower:
            character.willpowerStates = newStates
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
            
            // Ensure we have the right number of boxes
            let adjustedStates = adjustStateArrayToCount(states, targetCount: boxCount)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(adjustedStates.indices, id: \.self) { index in
                    HealthBoxView(state: adjustedStates[index])
                }
            }
            
            // Superficial damage controls
            HStack {
                if canDecreaseSuperficial() {
                    Button(action: {
                        decreaseSuperficial()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Superficial")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseSuperficial() {
                    Button(action: {
                        increaseSuperficial()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 8)
            
            // Aggravated damage controls
            HStack {
                if canDecreaseAggravated() {
                    Button(action: {
                        decreaseAggravated()
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Aggravated")
                    .font(.body)
                
                Spacer()
                
                if canIncreaseAggravated() {
                    Button(action: {
                        increaseAggravated()
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.top, 4)
        }
        .onAppear {
            // Ensure state arrays are correct size when view appears
            let adjustedStates = adjustStateArrayToCount(states, targetCount: boxCount)
            updateStates(adjustedStates)
        }
    }
    
    private func adjustStateArrayToCount(_ currentStates: [HealthState], targetCount: Int) -> [HealthState] {
        var adjustedStates = currentStates
        
        if adjustedStates.count < targetCount {
            // Add missing boxes as ok
            adjustedStates.append(contentsOf: Array(repeating: .ok, count: targetCount - adjustedStates.count))
        } else if adjustedStates.count > targetCount {
            // Remove excess boxes, prioritizing ok boxes first
            while adjustedStates.count > targetCount {
                if let okIndex = adjustedStates.lastIndex(of: .ok) {
                    adjustedStates.remove(at: okIndex)
                } else if let superficialIndex = adjustedStates.lastIndex(of: .superficial) {
                    adjustedStates.remove(at: superficialIndex)
                } else if let aggravatedIndex = adjustedStates.lastIndex(of: .aggravated) {
                    adjustedStates.remove(at: aggravatedIndex)
                }
            }
        }
        
        return adjustedStates
    }
    
    // Helper function to reorder health states: aggravated first, then superficial, then ok
    private func reorderHealthStates(_ states: [HealthState]) -> [HealthState] {
        let aggravatedCount = states.filter { $0 == .aggravated }.count
        let superficialCount = states.filter { $0 == .superficial }.count
        let okCount = states.filter { $0 == .ok }.count
        
        var reorderedStates: [HealthState] = []
        reorderedStates.append(contentsOf: Array(repeating: .aggravated, count: aggravatedCount))
        reorderedStates.append(contentsOf: Array(repeating: .superficial, count: superficialCount))
        reorderedStates.append(contentsOf: Array(repeating: .ok, count: okCount))
        
        return reorderedStates
    }
    
    // Superficial damage logic
    private func canDecreaseSuperficial() -> Bool {
        states.contains(.superficial)
    }
    
    private func canIncreaseSuperficial() -> Bool {
        // Can increase if there are ok boxes OR if there are superficial boxes that can be converted to aggravated
        states.contains(.ok) || states.contains(.superficial)
    }
    
    private func decreaseSuperficial() {
        var newStates = states
        if let index = newStates.lastIndex(of: .superficial) {
            newStates[index] = .ok
        }
        
        // Reorder states: aggravated first, then superficial, then ok
        newStates = reorderHealthStates(newStates)
        updateStates(newStates)
        
        onChange?()
    }
    
    private func increaseSuperficial() {
        var newStates = states
        if let index = newStates.firstIndex(of: .ok) {
            newStates[index] = .superficial
        } else if !states.contains(.ok) && states.contains(.superficial) {
            // If no empty boxes and there are superficial boxes, convert one superficial to aggravated
            if let index = newStates.firstIndex(of: .superficial) {
                newStates[index] = .aggravated
            }
        }
        
        // Reorder states: aggravated first, then superficial, then ok
        newStates = reorderHealthStates(newStates)
        updateStates(newStates)
        
        onChange?()
    }
    
    // Aggravated damage logic
    private func canDecreaseAggravated() -> Bool {
        states.contains(.aggravated)
    }
    
    private func canIncreaseAggravated() -> Bool {
        // Can increase if there are any non-aggravated boxes (ok or superficial)
        states.contains(.ok) || states.contains(.superficial)
    }
    
    private func decreaseAggravated() {
        var newStates = states
        if let index = newStates.lastIndex(of: .aggravated) {
            newStates[index] = .ok
        }
        
        // Reorder states: aggravated first, then superficial, then ok
        newStates = reorderHealthStates(newStates)
        updateStates(newStates)
        
        onChange?()
    }
    
    private func increaseAggravated() {
        var newStates = states
        if let index = newStates.firstIndex(of: .ok) {
            newStates[index] = .aggravated
        } else if let index = newStates.firstIndex(of: .superficial) {
            newStates[index] = .aggravated
        }
        
        // Reorder states: aggravated first, then superficial, then ok
        newStates = reorderHealthStates(newStates)
        updateStates(newStates)
        
        onChange?()
    }
}

// Editable Humanity Row View
struct EditableHumanityRowView<T: CharacterWithHumanity>: View {
    @Binding var character: T
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

// Hunger Row View for displaying hunger as blood drops
struct HungerRowView: View {
    let hunger: Int
    let availableWidth: CGFloat
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hunger")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(0..<5, id: \.self) { index in
                    BloodDropView(isFilled: index < hunger)
                }
            }
        }
    }
}

// Editable Hunger Row View
struct EditableHungerRowView: View {
    @Binding var character: VampireCharacter
    let availableWidth: CGFloat
    var onChange: (() -> Void)? = nil
    
    private var boxesPerRow: Int {
        let boxWithSpacing = statusBoxSize + 5
        return max(1, Int(availableWidth / boxWithSpacing))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hunger")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                ForEach(0..<5, id: \.self) { index in
                    BloodDropView(isFilled: index < character.hunger)
                }
            }
            
            // Hunger controls
            HStack {
                if character.hunger > 0 {
                    Button(action: {
                        if character.hunger > 0 {
                            character.hunger -= 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Hunger Level: \(character.hunger)")
                    .font(.body)
                
                Spacer()
                
                if character.hunger < 5 {
                    Button(action: {
                        if character.hunger < 5 {
                            character.hunger += 1
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

// Generation Row View for displaying generation
struct GenerationRowView: View {
    let generation: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Generation")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("\(generation)")
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

// Editable Generation Row View
struct EditableGenerationRowView: View {
    @Binding var character: VampireCharacter
    var onChange: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Generation")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Generation controls
            HStack {
                if character.generation > 0 {
                    Button(action: {
                        if character.generation > 0 {
                            character.generation -= 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Generation: \(character.generation)")
                    .font(.body)
                
                Spacer()
                
                if character.generation < 16 {
                    Button(action: {
                        if character.generation < 16 {
                            character.generation += 1
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

// Blood Potency Row View for displaying blood potency
struct BloodPotencyRowView: View {
    let bloodPotency: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Blood Potency")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("\(bloodPotency)")
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

// Editable Blood Potency Row View
struct EditableBloodPotencyRowView: View {
    @Binding var character: VampireCharacter
    var onChange: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Blood Potency")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Blood Potency controls
            HStack {
                if character.bloodPotency > 0 {
                    Button(action: {
                        if character.bloodPotency > 0 {
                            character.bloodPotency -= 1
                            onChange?()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Blood Potency: \(character.bloodPotency)")
                    .font(.body)
                
                Spacer()
                
                if character.bloodPotency < 10 {
                    Button(action: {
                        if character.bloodPotency < 10 {
                            character.bloodPotency += 1
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
