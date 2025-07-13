import SwiftUI

struct SpheresStage: View {
    @ObservedObject var character: MageCharacter
    
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


