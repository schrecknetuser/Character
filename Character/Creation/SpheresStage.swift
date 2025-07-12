import SwiftUI

struct SpheresStage: View {
    @Binding var character: MageCharacter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Spheres")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            Text("Select your mage's spheres and their levels (0-5):")
                .foregroundColor(.secondary)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(V5Constants.mageSpheres, id: \.self) { sphere in
                        SphereRowView(
                            sphereName: sphere,
                            sphereLevel: Binding(
                                get: { character.spheres[sphere] ?? 0 },
                                set: { character.spheres[sphere] = $0 }
                            )
                        )
                    }
                }
                .padding(.vertical)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct SphereRowView: View {
    let sphereName: String
    @Binding var sphereLevel: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(sphereName)
                    .font(.headline)
                    .frame(minWidth: 120, alignment: .leading)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        if sphereLevel > 0 {
                            sphereLevel -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(sphereLevel > 0 ? .red : .gray)
                    }
                    .disabled(sphereLevel <= 0)
                    
                    Text("\(sphereLevel)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        if sphereLevel < 5 {
                            sphereLevel += 1
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(sphereLevel < 5 ? .green : .gray)
                    }
                    .disabled(sphereLevel >= 5)
                }
            }
            
            // Dots visualization
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Circle()
                        .fill(index < sphereLevel ? Color.primary : Color.clear)
                        .stroke(Color.primary, lineWidth: 1)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .padding(.vertical, 4)
    }
}