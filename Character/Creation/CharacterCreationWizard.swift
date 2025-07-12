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
    case attributes = 3
    case skills = 4
    case specializations = 5
    case disciplines = 6
    case meritsAndFlaws = 7
    case convictionsAndTouchstones = 8
    case ambitionAndDesire = 9
    
    var title: String {
        switch self {
        case .characterType: return "Character Type"
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
                
                Text("\(currentStage.rawValue + 1) of \(CreationStage.allCases.count): \(currentStage.title)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                // Current stage content

                switch currentStage {
                    case .characterType:
                        CharacterTypeSelectionStage(selectedCharacterType: $selectedCharacterType)
                    case .nameAndChronicle:
                        if selectedCharacterType == .vampire, let binding = viewModel.vampireBinding {
                            VampireNameAndChronicleStage(character: binding)
                        } else if selectedCharacterType == .ghoul, let binding = viewModel.ghoulBinding {
                            GhoulNameAndChronicleStage(character: binding)
                        } else if selectedCharacterType == .mage, let binding = viewModel.mageBinding {
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
                            DisciplinesStage(character: viewModel.asVampireForced)
                        } else if selectedCharacterType == .ghoul {
                            DisciplinesStage(character: viewModel.asGhoulForced)
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
                            if selectedCharacterType != .vampire && currentStage == .attributes {
                                currentStage = .nameAndChronicle
                            } else if selectedCharacterType != .vampire && currentStage == .specializations {
                                currentStage = .meritsAndFlaws
                            } else {
                                let previousStage = CreationStage(rawValue: currentStage.rawValue - 1) ?? .characterType
                                if selectedCharacterType != .vampire && previousStage == .clan {
                                    currentStage = .nameAndChronicle
                                } else {
                                    currentStage = previousStage
                                }
                            }
                        }
                    }
                    .disabled(currentStage == .characterType)
                    
                    Spacer()
                    
                    if currentStage == .ambitionAndDesire {
                        Button("Create Character") {
                            // Recalculate derived values before saving
                            viewModel.character.recalculateDerivedValues()
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
                                
                                if selectedCharacterType != .vampire && currentStage == .nameAndChronicle {
                                    currentStage = .attributes
                                } else if selectedCharacterType != .vampire && currentStage == .meritsAndFlaws {
                                    currentStage = .specializations
                                } else {
                                    let nextStage = CreationStage(rawValue: currentStage.rawValue + 1) ?? .ambitionAndDesire
                                    if selectedCharacterType != .vampire && nextStage == .clan {
                                        currentStage = .attributes
                                    } else {
                                        currentStage = nextStage
                                    }
                                }
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
