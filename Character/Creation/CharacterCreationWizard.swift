import SwiftUI
import UniformTypeIdentifiers

// Make Int conform to Transferable for drag and drop functionality
/*extension Int: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .plainText)
    }
}*/

// Helper struct to track drag source
struct AttributeDragData: Transferable, Codable {
    let value: Int
    let sourceAttribute: String?
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
    }
}

enum CreationStage: Int, CaseIterable {
    case nameAndChronicle = 0
    case clan = 1
    case attributes = 2
    case skills = 3
    case specializations = 4
    case disciplines = 5
    case meritsAndFlaws = 6
    case convictionsAndTouchstones = 7
    case ambitionAndDesire = 8
    
    var title: String {
        switch self {
        case .nameAndChronicle: return "Name & Chronicle"
        case .clan: return "Clan"
        case .attributes: return "Attributes"
        case .skills: return "Skills"
        case .specializations: return "Specializations"
        case .disciplines: return "Disciplines"
        case .meritsAndFlaws: return "Merits & Flaws"
        case .convictionsAndTouchstones: return "Convictions & Touchstones"
        case .ambitionAndDesire: return "Ambition & Desire"
        }
    }
}

struct CharacterCreationWizard: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: CharacterStore
    
    @State private var currentStage: CreationStage = .nameAndChronicle
    @State private var character = Character()
    
    var body: some View {
        NavigationView {
            VStack {
                // Progress indicator
                ProgressView(value: Double(currentStage.rawValue + 1), total: Double(CreationStage.allCases.count))
                    .padding(.horizontal)
                
                Text("\(currentStage.rawValue + 1) of \(CreationStage.allCases.count): \(currentStage.title)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Current stage content
                Group {
                    switch currentStage {
                        case .nameAndChronicle:
                            NameAndChronicleStage(character: $character)
                        case .clan:
                            ClanSelectionStage(character: $character)
                        case .attributes:
                            AttributesStage(character: $character)
                        case .skills:
                            SkillsStage(character: $character)
                        case .specializations:
                            SpecializationsStage(character: $character)
                        case .disciplines:
                            DisciplinesStage(character: $character)
                        case .meritsAndFlaws:
                            MeritsAndFlawsStage(character: $character)
                        case .convictionsAndTouchstones:
                            ConvictionsAndTouchstonesStage(character: $character)
                        case .ambitionAndDesire:
                            AmbitionAndDesireStage(character: $character)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Navigation buttons
                HStack {
                    Button("Back") {
                        if currentStage.rawValue > 0 {
                            currentStage = CreationStage(rawValue: currentStage.rawValue - 1) ?? .nameAndChronicle
                        }
                    }
                    .disabled(currentStage == .nameAndChronicle)
                    
                    Spacer()
                    
                    if currentStage == .ambitionAndDesire {
                        Button("Create Character") {
                            // Recalculate derived values before saving
                            character.recalculateDerivedValues()
                            store.addCharacter(character)
                            dismiss()
                        }
                        .disabled(!canProceedFromCurrentStage())
                    } else {
                        Button("Next") {
                            if currentStage.rawValue < CreationStage.allCases.count - 1 {
                                currentStage = CreationStage(rawValue: currentStage.rawValue + 1) ?? .ambitionAndDesire
                            }
                        }
                        .disabled(!canProceedFromCurrentStage())
                    }
                }
                .padding()
            }
            .navigationTitle("Create Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func canProceedFromCurrentStage() -> Bool {
        switch currentStage {
        case .nameAndChronicle:
            return !character.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !character.chronicleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .clan:
            return !character.clan.isEmpty
        case .attributes:
            return AttributesStage.areAllAttributesAssigned(character: character)
        case .skills:
            return true // Skills can be left at 0
        case .specializations:
            // Check that all required specializations are filled
            let requiredSkills = character.getSkillsRequiringFreeSpecializationWithPoints()
            return requiredSkills.allSatisfy { skillName in
                !character.getSpecializations(for: skillName).isEmpty
            }
        case .disciplines:
            return true // Disciplines can be empty
        case .meritsAndFlaws:
            return true // Merits and flaws can be empty
        case .convictionsAndTouchstones:
            return true // Convictions and touchstones can be empty
        case .ambitionAndDesire:
            return true // Ambition and desire can be empty
        }
    }
}
