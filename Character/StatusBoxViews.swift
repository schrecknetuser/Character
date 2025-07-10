import SwiftUI

// Health/Willpower Box View
struct HealthBoxView: View {
    let state: HealthState
    let size: CGFloat = 30
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: size, height: size)
            
            switch state {
            case .ok:
                EmptyView()
            case .superficial:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: size))
                    path.addLine(to: CGPoint(x: size, y: 0))
                }
                .stroke(Color.primary, lineWidth: 1)
            case .aggravated:
                ZStack {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: size, y: size))
                    }
                    .stroke(Color.primary, lineWidth: 1)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: size))
                        path.addLine(to: CGPoint(x: size, y: 0))
                    }
                    .stroke(Color.primary, lineWidth: 1)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

// Humanity Box View
struct HumanityBoxView: View {
    let state: HumanityState
    let size: CGFloat = 30
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.primary, lineWidth: 1)
                .frame(width: size, height: size)
            
            switch state {
            case .unchecked:
                EmptyView()
            case .checked:
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: size - 2, height: size - 2)
            case .stained:
                Path { path in
                    path.move(to: CGPoint(x: 0, y: size))
                    path.addLine(to: CGPoint(x: size, y: 0))
                }
                .stroke(Color.primary, lineWidth: 1)
            }
        }
        .frame(width: size, height: size)
    }
}

// Status Row View for displaying a row of boxes
struct StatusRowView: View {
    let title: String
    let healthStates: [HealthState]?
    let humanityStates: [HumanityState]?
    
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
            
            if let healthStates = healthStates {
                // Sort boxes: aggravated first, then superficial, then ok
                let sortedBoxes = healthStates.enumerated().sorted { (first, second) in
                    let order: [HealthState] = [.aggravated, .superficial, .ok]
                    let firstIndex = order.firstIndex(of: first.element) ?? order.count
                    let secondIndex = order.firstIndex(of: second.element) ?? order.count
                    return firstIndex < secondIndex
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(35)), count: min(10, healthStates.count)), spacing: 5) {
                    ForEach(sortedBoxes, id: \.offset) { index, state in
                        HealthBoxView(state: state)
                    }
                }
            }
            
            if let humanityStates = humanityStates {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(35)), count: min(10, humanityStates.count)), spacing: 5) {
                    ForEach(humanityStates.indices, id: \.self) { index in
                        HumanityBoxView(state: humanityStates[index])
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}