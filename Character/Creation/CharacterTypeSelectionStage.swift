import SwiftUI

struct CharacterTypeSelectionStage: View {
    @Binding var selectedCharacterType: CharacterType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Choose Character Type")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            Text("Select the type of character you want to create:")
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ForEach(CharacterType.allCases, id: \.self) { characterType in
                    CharacterTypeCard(
                        characterType: characterType,
                        isSelected: selectedCharacterType == characterType,
                        onSelect: {
                            selectedCharacterType = characterType
                        }
                    )
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct CharacterTypeCard: View {
    let characterType: CharacterType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(characterType.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(characterType.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.secondary)
                            .font(.title2)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.secondary.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension CharacterType {
    var description: String {
        switch self {
        case .vampire:
            return "A Kindred creature of the night, possessing supernatural disciplines, struggling with humanity, and driven by the hunger for blood."
        case .ghoul:
            return "A mortal bound to a vampire through the vitae, granted longevity and limited supernatural abilities, struggling with addiction, servitude, and the thirst for power."
        case .mage:
            return "A reality-warping Awakened being, wielding spheres of magic through will and belief, struggling with paradox, identity, and the price of enlightened power."
        }
    }
}

#Preview {
    CharacterTypeSelectionStage(selectedCharacterType: .constant(.vampire))
}
