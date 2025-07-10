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
                // Sort boxes: aggravated first, then superficial, then ok
                let sortedStates = healthStates.sorted { first, second in
                    let order: [HealthState] = [.aggravated, .superficial, .ok]
                    let firstIndex = order.firstIndex(of: first) ?? order.count
                    let secondIndex = order.firstIndex(of: second) ?? order.count
                    return firstIndex < secondIndex
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(statusBoxSize), spacing: 5), count: boxesPerRow), spacing: 5) {
                    ForEach(sortedStates.indices, id: \.self) { index in
                        HealthBoxView(state: sortedStates[index])
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
    @Binding var character: Character
    let title: String
    let type: StatusType
    let availableWidth: CGFloat
    
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
                Button(action: {
                    decreaseSuperficial()
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
                .disabled(!canDecreaseSuperficial())
                
                Text("Superficial")
                    .font(.body)
                
                Spacer()
                
                Button(action: {
                    increaseSuperficial()
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }
                .disabled(!canIncreaseSuperficial())
            }
            .padding(.top, 8)
            
            // Aggravated damage controls
            HStack {
                Button(action: {
                    decreaseAggravated()
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
                .disabled(!canDecreaseAggravated())
                
                Text("Aggravated")
                    .font(.body)
                
                Spacer()
                
                Button(action: {
                    increaseAggravated()
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }
                .disabled(!canIncreaseAggravated())
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
    
    // Superficial damage logic
    private func canDecreaseSuperficial() -> Bool {
        states.contains(.superficial)
    }
    
    private func canIncreaseSuperficial() -> Bool {
        states.contains(.ok)
    }
    
    private func decreaseSuperficial() {
        var newStates = states
        if let index = newStates.firstIndex(of: .superficial) {
            newStates[index] = .ok
            updateStates(newStates)
        }
    }
    
    private func increaseSuperficial() {
        var newStates = states
        if let index = newStates.firstIndex(of: .ok) {
            newStates[index] = .superficial
            updateStates(newStates)
        } else if let index = newStates.firstIndex(of: .superficial) {
            newStates[index] = .aggravated
            updateStates(newStates)
        }
    }
    
    // Aggravated damage logic
    private func canDecreaseAggravated() -> Bool {
        states.contains(.aggravated)
    }
    
    private func canIncreaseAggravated() -> Bool {
        !states.filter({ $0 != .aggravated }).isEmpty
    }
    
    private func decreaseAggravated() {
        var newStates = states
        if let index = newStates.firstIndex(of: .aggravated) {
            newStates[index] = .ok
            updateStates(newStates)
        }
    }
    
    private func increaseAggravated() {
        var newStates = states
        if let index = newStates.firstIndex(of: .ok) {
            newStates[index] = .aggravated
            updateStates(newStates)
        } else if let index = newStates.firstIndex(of: .superficial) {
            newStates[index] = .aggravated
            updateStates(newStates)
        }
    }
}

// Editable Humanity Row View
struct EditableHumanityRowView: View {
    @Binding var character: Character
    let availableWidth: CGFloat
    
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
                Button(action: {
                    decreaseHumanity()
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
                .disabled(!canDecreaseHumanity())
                
                Text("Humanity")
                    .font(.body)
                
                Spacer()
                
                Button(action: {
                    increaseHumanity()
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }
                .disabled(!canIncreaseHumanity())
            }
            .padding(.top, 8)
            
            // Stains controls
            HStack {
                Button(action: {
                    decreaseStains()
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
                .disabled(!canDecreaseStains())
                
                Text("Stains")
                    .font(.body)
                
                Spacer()
                
                Button(action: {
                    increaseStains()
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }
                .disabled(!canIncreaseStains())
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
        if let index = character.humanityStates.firstIndex(of: .checked) {
            character.humanityStates[index] = .unchecked
        }
    }
    
    private func increaseHumanity() {
        if let index = character.humanityStates.firstIndex(of: .unchecked) {
            character.humanityStates[index] = .checked
        }
    }
    
    // Stains logic
    private func canDecreaseStains() -> Bool {
        character.humanityStates.contains(.stained)
    }
    
    private func canIncreaseStains() -> Bool {
        character.humanityStates.contains(.unchecked)
    }
    
    private func decreaseStains() {
        if let index = character.humanityStates.firstIndex(of: .stained) {
            character.humanityStates[index] = .unchecked
        }
    }
    
    private func increaseStains() {
        if let index = character.humanityStates.firstIndex(of: .unchecked) {
            character.humanityStates[index] = .stained
        }
    }
}