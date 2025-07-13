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
                            initialLevel: character.spheres[sphere] ?? 0,
                            onChange: { newValue in
                                var newSpheres = character.spheres
                                newSpheres[sphere] = newValue
                                character.spheres = newSpheres
                            }
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


