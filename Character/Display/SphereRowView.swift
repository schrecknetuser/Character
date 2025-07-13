import SwiftUI

struct SphereRowView: View {
    let sphereName: String
    let initialLevel: Int
    let onChange: (Int) -> Void
    
    @State private var localLevel: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(sphereName)
                    .font(.headline)
                    .frame(minWidth: 120, alignment: .leading)

                Spacer()

                HStack(spacing: 8) {
                    Button(action: {
                        if localLevel > 0 {
                            localLevel -= 1
                            onChange(localLevel)
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(localLevel > 0 ? .red : .gray)
                    }
                    .disabled(localLevel <= 0)
                    .buttonStyle(.borderless)

                    Text("\(localLevel)")
                        .font(.headline)
                        .frame(minWidth: 30)

                    Button(action: {
                        if localLevel < 5 {
                            localLevel += 1
                            onChange(localLevel)
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(localLevel < 5 ? .green : .gray)
                    }
                    .disabled(localLevel >= 5)
                    .buttonStyle(.borderless)
                }
            }

            // Dots visualization
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(index < localLevel ? Color.primary : Color.clear)
                        .stroke(Color.primary, lineWidth: 1)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            self.localLevel = initialLevel
        }
    }
}
