import SwiftUI

// Health/Willpower Box View
struct HealthBoxView: View {
    let state: HealthState
    @ScaledMetric private var boxSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: boxSize, height: boxSize)
            
            switch state {
            case .ok:
                EmptyView()
            case .superficial:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: boxSize))
                    path.addLine(to: CGPoint(x: boxSize, y: 0))
                }
                .stroke(Color.primary, lineWidth: 1)
            case .aggravated:
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: boxSize, y: boxSize))
                    }
                    .stroke(Color.primary, lineWidth: 1)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: boxSize))
                        path.addLine(to: CGPoint(x: boxSize, y: 0))
                    }
                    .stroke(Color.primary, lineWidth: 1)
                }
            }
        }
        .frame(width: boxSize, height: boxSize)
    }
}

// Humanity Box View
struct HumanityBoxView: View {
    let state: HumanityState
    @ScaledMetric private var boxSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: boxSize, height: boxSize)
            
            switch state {
            case .unchecked:
                EmptyView()
            case .checked:
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: boxSize - 2, height: boxSize - 2)
            case .stained:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: boxSize))
                    path.addLine(to: CGPoint(x: boxSize, y: 0))
                }
                .stroke(Color.primary, lineWidth: 1)
            }
        }
        .frame(width: boxSize, height: boxSize)
    }
}

// Status Row View for displaying a row of boxes
struct StatusRowView: View {
    let title: String
    let healthStates: [HealthState]?
    let humanityStates: [HumanityState]?
    @ScaledMetric private var boxSpacing: CGFloat = 35
    @ScaledMetric private var gridSpacing: CGFloat = 5
    
    init(title: String, healthStates: [HealthState]) {
        self.title = title
        self.healthStates = healthStates
        self.humanityStates = nil
    }
    
    init(title: String, humanityStates: [HumanityState]) {
        self.title = title
        self.healthStates = nil
        self.humanityStates = humanityStates
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            
            if let healthStates = healthStates {
                // Sort boxes: aggravated first, then superficial, then ok
                let sortedStates = healthStates.sorted { first, second in
                    let order: [HealthState] = [.aggravated, .superficial, .ok]
                    let firstIndex = order.firstIndex(of: first) ?? order.count
                    let secondIndex = order.firstIndex(of: second) ?? order.count
                    return firstIndex < secondIndex
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(boxSpacing)), count: min(10, sortedStates.count)), spacing: gridSpacing) {
                    ForEach(sortedStates.indices, id: \.self) { index in
                        HealthBoxView(state: sortedStates[index])
                    }
                }
            }
            
            if let humanityStates = humanityStates {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(boxSpacing)), count: min(10, humanityStates.count)), spacing: gridSpacing) {
                    ForEach(humanityStates.indices, id: \.self) { index in
                        HumanityBoxView(state: humanityStates[index])
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}