import SwiftUI

struct SphereStyleAreteView: View {
    let initialLevel: Int
    let onChange: (Int) -> Void
    let isEditing: Bool
    
    @State private var localLevel: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Arete")
                    .font(.headline)
                    .frame(minWidth: 120, alignment: .leading)

                Spacer()

                if isEditing {
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
                } else {
                    Text("Level \(localLevel)")
                        .font(.headline)
                        .foregroundColor(.secondary)
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
        .onChange(of: initialLevel) { _, newValue in
            self.localLevel = newValue
        }
    }
}