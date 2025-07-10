import SwiftUI

// Shared box size constant for consistency
private let statusBoxSize: CGFloat = 25

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