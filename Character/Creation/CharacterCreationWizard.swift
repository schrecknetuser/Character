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
    case characterType = 0
    case nameAndChronicle = 1
    case clan = 2
    case predatorPath = 3
    case attributes = 4
    case skills = 5
    case specializations = 6
    case disciplines = 7
    case meritsAndFlaws = 8
    case convictionsAndTouchstones = 9
    case ambitionAndDesire = 10
    
    func title(for characterType: CharacterType) -> String {
        switch self {
        case .characterType: return "Character Type"
        case .nameAndChronicle: return "Name & Chronicle"
        case .clan: return "Clan"
        case .predatorPath: return "Predator Path"
        case .attributes: return "Attributes"
        case .skills: return "Skills"
        case .specializations: return "Specializations"
        case .disciplines: return characterType == .mage ? "Spheres" : "Disciplines"
        case .meritsAndFlaws: return "Merits & Flaws"
        case .convictionsAndTouchstones: return "Convictions & Touchstones"
        case .ambitionAndDesire: return "Ambition & Desire"
        }
    }
}

struct CharacterCreationWizard: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: CharacterStore
    @State private var triggerRefresh = false
    
    @State private var currentStage: CreationStage = .characterType
    @StateObject private var viewModel = CharacterCreationViewModel(characterType: .vampire)
    @State private var selectedCharacterType: CharacterType = .vampire
    
    var body: some View {
        NavigationView {
            VStack {
                // Progress indicator
                ProgressView(value: Double(currentStage.rawValue + 1), total: Double(CreationStage.allCases.count))
                    .padding(.horizontal)
                
                Text("\(currentStage.rawValue + 1) of \(CreationStage.allCases.count): \(currentStage.title(for: selectedCharacterType))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Current stage content

                switch currentStage {
                    case .characterType:
                        CharacterTypeSelectionStage(selectedCharacterType: $selectedCharacterType)
                    case .nameAndChronicle:
                        if selectedCharacterType == .vampire, let binding = viewModel.vampireBinding() {
                            VampireNameAndChronicleStage(character: binding)
                        } else if selectedCharacterType == .ghoul, let binding = viewModel.ghoulBinding() {
                            GhoulNameAndChronicleStage(character: binding)
                        } else if selectedCharacterType == .mage, let binding = viewModel.mageBinding() {
                            MageNameAndChronicleStage(character: binding)
                        } else {
                            Text("Character type not yet implemented")
                        }
                    case .clan:
                        if selectedCharacterType == .vampire {
                            ClanSelectionStage(character: viewModel.asVampireForced, onChange: {
                                triggerRefresh.toggle()
                            })
                        } else {
                            // Skip clan selection for non-vampires
                            EmptyView()
                        }
                    case .predatorPath:
                        if selectedCharacterType == .vampire {
                            PredatorPathSelectionStage(character: viewModel.asVampireForced, onChange: {
                                triggerRefresh.toggle()
                            })
                        } else {
                            // Skip predator path selection for non-vampires
                            EmptyView()
                        }
                    case .attributes:
                        AttributesStage(character: viewModel.baseBinding)
                    case .skills:
                        SkillsStage(character: viewModel.baseBinding)
                    case .specializations:
                        SpecializationsStage(character: viewModel.baseBinding, onChange: {
                            triggerRefresh.toggle()
                        })
                    case .disciplines:
                        if selectedCharacterType == .vampire {
                            if let unwrapped = viewModel.vampireBinding() {
                                V5DisciplinesStage(character: unwrapped)
                            }
                        } else if selectedCharacterType == .ghoul {
                            if let unwrapped = viewModel.ghoulBinding() {
                                V5DisciplinesStage(character: unwrapped)
                            }
                        } else if selectedCharacterType == .mage {
                            SpheresStage(character: viewModel.asMageForced)
                        }
                    case .meritsAndFlaws:
                        MeritsAndFlawsStage(character: viewModel.baseBinding)
                    case .convictionsAndTouchstones:
                        ConvictionsAndTouchstonesStage(character: viewModel.baseBinding)
                    case .ambitionAndDesire:
                        AmbitionAndDesireStage(character: viewModel.baseBinding)
                }

                //.frame(maxWidth: .infinity)
                
                // Navigation buttons
                HStack {
                    Button("Back") {
                        if currentStage.rawValue > 0 {
                            var targetStage = CreationStage(rawValue: currentStage.rawValue - 1) ?? .characterType
                            
                            // Skip vampire-only stages for non-vampires
                            if selectedCharacterType != .vampire {
                                while targetStage == .clan || targetStage == .predatorPath {
                                    if targetStage.rawValue > 0 {
                                        targetStage = CreationStage(rawValue: targetStage.rawValue - 1) ?? .characterType
                                    } else {
                                        break
                                    }
                                }
                            }
                            
                            currentStage = targetStage
                        }
                    }
                    .disabled(currentStage == .characterType)
                    
                    Spacer()
                    
                    if currentStage == .ambitionAndDesire {
                        Button("Create Character") {
                            // Recalculate derived values before saving
                            viewModel.character.recalculateDerivedValues()
                            // Log the character creation
                            viewModel.character.changeLog.append(ChangeLogEntry(summary: "Character created."))
                            store.addCharacter(viewModel.character)
                            dismiss()
                        }
                        .disabled(!canProceedFromCurrentStage())
                    } else {
                        Button("Next") {
                            
                            if currentStage == .characterType {
                                viewModel.setCharacterType(selectedCharacterType)
                            }
                            
                            if currentStage.rawValue < CreationStage.allCases.count - 1 {
                                var targetStage = CreationStage(rawValue: currentStage.rawValue + 1) ?? .ambitionAndDesire
                                
                                // Skip vampire-only stages for non-vampires
                                if selectedCharacterType != .vampire {
                                    while targetStage == .clan || targetStage == .predatorPath {
                                        if targetStage.rawValue < CreationStage.allCases.count - 1 {
                                            targetStage = CreationStage(rawValue: targetStage.rawValue + 1) ?? .ambitionAndDesire
                                        } else {
                                            break
                                        }
                                    }
                                }
                                
                                currentStage = targetStage
                            }
                        }
                        .disabled({
                            _ = triggerRefresh
                            return !canProceedFromCurrentStage()
                        }())
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
            case .characterType:
                return true
            case .nameAndChronicle:
                return !viewModel.character.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                       !viewModel.character.chronicleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case .clan:
                return selectedCharacterType != .vampire || (viewModel.asVampire?.clan.isEmpty == false)
            case .predatorPath:
                return true // Allow any predator path choice including "None"
            case .attributes:
                return AttributesStage.areAllAttributesAssigned(character: viewModel.character)
            case .skills:
                return true
            case .specializations:
                let requiredSkills = viewModel.character.getSkillsRequiringFreeSpecializationWithPoints()
                return requiredSkills.allSatisfy { skill in
                    !viewModel.character.getSpecializations(for: skill).isEmpty
                }
            case .disciplines, .meritsAndFlaws, .convictionsAndTouchstones, .ambitionAndDesire:
                return true
            }
        }
}
