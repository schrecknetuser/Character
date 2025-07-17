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
    case predatorType = 3
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
        case .predatorType: return "Predator Type"
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
    
    @State private var currentStage: CreationStage
    @StateObject private var viewModel: CharacterCreationViewModel
    @State private var selectedCharacterType: CharacterType
    @State private var isCharacterSaved: Bool = false // Track if character was saved to store
    
    // Support for resuming creation from existing character
    var existingCharacter: (any BaseCharacter)?
    
    init(store: CharacterStore, existingCharacter: (any BaseCharacter)? = nil) {
        self.store = store
        self.existingCharacter = existingCharacter
        
        // If resuming creation, set up the initial state
        if let existing = existingCharacter {
            self._selectedCharacterType = State(initialValue: existing.characterType)
            self._currentStage = State(initialValue: CreationStage(rawValue: existing.creationProgress) ?? .characterType)
            self._isCharacterSaved = State(initialValue: true)
            self._viewModel = StateObject(wrappedValue: CharacterCreationViewModel(existingCharacter: existing))
        } else {
            self._selectedCharacterType = State(initialValue: .vampire)
            self._currentStage = State(initialValue: .characterType)
            self._isCharacterSaved = State(initialValue: false)
            self._viewModel = StateObject(wrappedValue: CharacterCreationViewModel(characterType: .vampire))
        }
    }
    
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
                    case .predatorType:
                        if selectedCharacterType == .vampire {
                            PredatorTypeSelectionStage(character: viewModel.asVampireForced, onChange: {
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
                                while targetStage == .clan || targetStage == .predatorType {
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
                            // Complete character creation
                            store.completeCharacterCreation(viewModel.character)
                            dismiss()
                        }
                        .disabled(!canProceedFromCurrentStage())
                    } else {
                        Button("Next") {
                            // Save character after first stage if not already saved
                            if currentStage == .characterType && !isCharacterSaved {
                                viewModel.setCharacterType(selectedCharacterType)
                                store.addCharacterInCreation(viewModel.character)
                                isCharacterSaved = true
                            }
                            
                            if currentStage.rawValue < CreationStage.allCases.count - 1 {
                                var targetStage = CreationStage(rawValue: currentStage.rawValue + 1) ?? .ambitionAndDesire
                                
                                // Skip vampire-only stages for non-vampires
                                if selectedCharacterType != .vampire {
                                    while targetStage == .clan || targetStage == .predatorType {
                                        if targetStage.rawValue < CreationStage.allCases.count - 1 {
                                            targetStage = CreationStage(rawValue: targetStage.rawValue + 1) ?? .ambitionAndDesire
                                        } else {
                                            break
                                        }
                                    }
                                }
                                
                                currentStage = targetStage
                                
                                // Update progress in store
                                if isCharacterSaved {
                                    store.updateCharacterCreationProgress(viewModel.character, stage: currentStage.rawValue)
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
            case .predatorType:
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
