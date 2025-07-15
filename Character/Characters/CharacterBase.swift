import SwiftUI



// Character Type enumeration
enum CharacterType: String, Codable, CaseIterable {
    case vampire = "Vampire"
    case ghoul = "Ghoul"
    case mage = "Mage"
    
    var displayName: String {
        switch self {
        case .vampire:
            return "Vampire"
        case .ghoul:
            return "Ghoul"
        case .mage:
            return "Mage"
        }
    }
}

protocol DisciplineCapable: BaseCharacter {
    var v5Disciplines: [V5Discipline] { get set }
    
    // Add a custom discipline
    func addCustomV5Discipline(_ discipline: V5Discipline)
    
    // Toggle a power selection for a discipline at a specific level
    func toggleV5Power(_ powerId: UUID, for disciplineName: String, at level: Int)
    
    // Get all available disciplines (standard + custom)
    func getAllAvailableV5Disciplines() -> [V5Discipline]
    
    func processDisciplineChanges(original: [V5Discipline], updated: [V5Discipline], changes: inout [String])
}

extension DisciplineCapable {    
    
    // Add a custom discipline
    func addCustomV5Discipline(_ discipline: V5Discipline) {
        var customDiscipline = discipline
        customDiscipline.isCustom = true
        if !v5Disciplines.contains(where: { $0.name == discipline.name }) {
            v5Disciplines.append(customDiscipline)
        }
    }
    
    // Toggle a power selection for a discipline at a specific level
    func toggleV5Power(_ powerId: UUID, for disciplineName: String, at level: Int) {
        if let index = v5Disciplines.firstIndex(where: { $0.name == disciplineName }) {
            v5Disciplines[index].togglePower(powerId, at: level)
            // Recalculate derived values since powers may affect health/willpower
            if let baseCharacter = self as? BaseCharacter {
                baseCharacter.recalculateDerivedValues()
            }
        }
    }
    
    // Get all available disciplines (standard + custom)
    func getAllAvailableV5Disciplines() -> [V5Discipline] {
        let standardDisciplines = V5Constants.v5Disciplines
        let customDisciplines = v5Disciplines.filter { $0.isCustom }
        let existingNames = Set(v5Disciplines.map(\.name))
        
        // Return standard disciplines that aren't already added plus all custom ones
        let availableStandard = standardDisciplines.filter { !existingNames.contains($0.name) }
        return availableStandard + customDisciplines
    }
    
    // Calculate discipline bonus to health from selected powers
    func getDisciplineHealthBonus() -> Int {
        var bonus = 0
        for discipline in v5Disciplines {
            for level in discipline.getLevels() {
                let selectedPowers = discipline.selectedPowers[level] ?? []
                for power in selectedPowers {
                    if power.addToHealth {
                        bonus += discipline.currentLevel()
                    }
                }
            }
        }
        return bonus
    }
    
    // Calculate discipline bonus to willpower from selected powers  
    func getDisciplineWillpowerBonus() -> Int {
        var bonus = 0
        for discipline in v5Disciplines {
            for level in discipline.getLevels() {
                let selectedPowers = discipline.selectedPowers[level] ?? []
                for power in selectedPowers {
                    if power.addToWillpower {
                        bonus += discipline.currentLevel()
                    }
                }
            }
        }
        return bonus
    }
    
    func processDisciplineChanges(original: [V5Discipline], updated: [V5Discipline], changes: inout [String]) {
        // Check V5 discipline changes
        let allV5DisciplineNames = Set(original.map(\.name)).union(Set(updated.map(\.name)))
        for disciplineName in allV5DisciplineNames {
            let originalDiscipline = original.first { $0.name == disciplineName }
            let updatedDiscipline = updated.first { $0.name == disciplineName }
            
            if originalDiscipline != nil && updatedDiscipline == nil {
                changes.append("lost \(originalDiscipline!.name)")
            }
            
            if updatedDiscipline != nil && originalDiscipline == nil {
                var summary = "learned \(updatedDiscipline!.name)"
                if updatedDiscipline!.getAllSelectedPowerNames().count > 0 {
                    summary += "(\(updatedDiscipline!.getAllSelectedPowerNames().joined(separator: ", ")))"
                }
                changes.append(summary)
            }
            
            // Check power selection changes
            if let orig = originalDiscipline, let upd = updatedDiscipline {

                let originalPowers = orig.getAllSelectedPowerNames()
                let updatedPowers = upd.getAllSelectedPowerNames()
                    
                if originalPowers != updatedPowers {
                    let addedCount = updatedPowers.subtracting(originalPowers).count
                    let removedCount = originalPowers.subtracting(updatedPowers).count
                    
                    if addedCount > 0 {
                        changes.append("added \(updatedPowers.subtracting(originalPowers).joined(separator: ", ")) to \(disciplineName)")
                    }
                    if removedCount > 0 {
                        changes.append("removed \(originalPowers.subtracting(updatedPowers).joined(separator: ", ")) from \(disciplineName)")
                    }
                }
            }
        }
    }
}

// MARK: - Character with Humanity Protocol
protocol CharacterWithHumanity: BaseCharacter {
    var humanity: Int { get set }
    var humanityStates: [HumanityState] { get set }
}

// MARK: - Base Character Protocol
protocol BaseCharacter: AnyObject, Identifiable, Codable, ObservableObject {
    var id: UUID { get set }
    var name: String { get set }
    var characterType: CharacterType { get }
    
    var physicalAttributes: [String: Int] { get set }
    var socialAttributes: [String: Int] { get set }
    var mentalAttributes: [String: Int] { get set }

    var physicalSkills: [String: Int] { get set }
    var socialSkills: [String: Int] { get set }
    var mentalSkills: [String: Int] { get set }

    var willpower: Int { get set }
    var experience: Int { get set }
    var spentExperience: Int { get set }

    var ambition: String { get set }
    var desire: String { get set }
    var chronicleName: String { get set }
    var concept: String { get set }
    var characterDescription: String { get set }
    var notes: String { get set }
    
    var dateOfBirth: Date? { get set }

    var advantages: [BackgroundBase] { get set }
    var flaws: [BackgroundBase] { get set }
    var backgroundMerits: [CharacterBackground] { get set }
    var backgroundFlaws: [CharacterBackground] { get set }
    var convictions: [String] { get set }
    var touchstones: [String] { get set }

    var specializations: [Specialization] { get set }
    var currentSession: Int { get set }
    var changeLog: [ChangeLogEntry] { get set }
    var isArchived: Bool { get set }

    var health: Int { get set }
    var healthStates: [HealthState] { get set }
    var willpowerStates: [WillpowerState] { get set }

    var totalAdvantageCost: Int { get }
    var totalFlawValue: Int { get }
    var netAdvantageFlawCost: Int { get }
    var availableExperience: Int { get }
    var healthBoxCount: Int { get }
    var willpowerBoxCount: Int { get }

    func getSpecializations(for skillName: String) -> [Specialization]
    func getSkillsWithPoints() -> [String]
    func getSkillsRequiringFreeSpecializationWithPoints() -> [String]
    func recalculateDerivedValues()
    func getAttributeValue(attribute: String) -> Int
    func getSkillValue(skill: String) -> Int
    func generateChangeSummary(for updated: any BaseCharacter) -> String
    func clone() -> any BaseCharacter
}

// MARK: - CharacterBase
class CharacterBase: BaseCharacter {
    @Published var id = UUID()
    @Published var name: String = ""
    let characterType: CharacterType

    @Published var physicalAttributes: [String: Int]
    @Published var socialAttributes: [String: Int]
    @Published var mentalAttributes: [String: Int]

    @Published var physicalSkills: [String: Int]
    @Published var socialSkills: [String: Int]
    @Published var mentalSkills: [String: Int]

    @Published var willpower: Int
    @Published var experience: Int = 0
    @Published var spentExperience: Int = 0

    @Published var ambition: String = ""
    @Published var desire: String = ""
    @Published var chronicleName: String = ""
    @Published var concept: String = ""
    @Published var characterDescription: String = ""
    @Published var notes: String = ""
    
    @Published var dateOfBirth: Date? = nil

    @Published var advantages: [BackgroundBase] = []
    @Published var flaws: [BackgroundBase] = []
    @Published var backgroundMerits: [CharacterBackground] = []
    @Published var backgroundFlaws: [CharacterBackground] = []
    @Published var convictions: [String] = []
    @Published var touchstones: [String] = []

    @Published var specializations: [Specialization] = []
    @Published var currentSession: Int = 1
    @Published var changeLog: [ChangeLogEntry] = []
    @Published var isArchived: Bool = false

    @Published var health: Int
    @Published var healthStates: [HealthState]
    @Published var willpowerStates: [WillpowerState]

    enum CodingKeys: String, CodingKey {
        case id, name, characterType,
             physicalAttributes, socialAttributes, mentalAttributes,
             physicalSkills, socialSkills, mentalSkills,
             willpower, experience, spentExperience,
             ambition, desire, chronicleName, concept, characterDescription, notes, dateOfBirth,
             advantages, flaws, backgroundMerits, backgroundFlaws, convictions, touchstones, chronicleTenets,
             specializations, currentSession, changeLog, isArchived,
             health, healthStates, willpowerStates
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        characterType = try container.decode(CharacterType.self, forKey: .characterType)
        physicalAttributes = try container.decode([String: Int].self, forKey: .physicalAttributes)
        socialAttributes = try container.decode([String: Int].self, forKey: .socialAttributes)
        mentalAttributes = try container.decode([String: Int].self, forKey: .mentalAttributes)
        physicalSkills = try container.decode([String: Int].self, forKey: .physicalSkills)
        socialSkills = try container.decode([String: Int].self, forKey: .socialSkills)
        mentalSkills = try container.decode([String: Int].self, forKey: .mentalSkills)
        willpower = try container.decode(Int.self, forKey: .willpower)
        experience = try container.decode(Int.self, forKey: .experience)
        spentExperience = try container.decode(Int.self, forKey: .spentExperience)
        ambition = try container.decode(String.self, forKey: .ambition)
        desire = try container.decode(String.self, forKey: .desire)
        chronicleName = try container.decode(String.self, forKey: .chronicleName)
        concept = try container.decodeIfPresent(String.self, forKey: .concept) ?? ""
        characterDescription = try container.decodeIfPresent(String.self, forKey: .characterDescription) ?? ""
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        advantages = try container.decode([BackgroundBase].self, forKey: .advantages)
        flaws = try container.decode([BackgroundBase].self, forKey: .flaws)
        backgroundMerits = try container.decodeIfPresent([CharacterBackground].self, forKey: .backgroundMerits) ?? []
        backgroundFlaws = try container.decodeIfPresent([CharacterBackground].self, forKey: .backgroundFlaws) ?? []
        convictions = try container.decode([String].self, forKey: .convictions)
        touchstones = try container.decode([String].self, forKey: .touchstones)
        specializations = try container.decode([Specialization].self, forKey: .specializations)
        currentSession = try container.decode(Int.self, forKey: .currentSession)
        changeLog = try container.decode([ChangeLogEntry].self, forKey: .changeLog)
        isArchived = try container.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false
        health = try container.decode(Int.self, forKey: .health)
        healthStates = try container.decode([HealthState].self, forKey: .healthStates)
        willpowerStates = try container.decode([WillpowerState].self, forKey: .willpowerStates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(characterType, forKey: .characterType)
        try container.encode(physicalAttributes, forKey: .physicalAttributes)
        try container.encode(socialAttributes, forKey: .socialAttributes)
        try container.encode(mentalAttributes, forKey: .mentalAttributes)
        try container.encode(physicalSkills, forKey: .physicalSkills)
        try container.encode(socialSkills, forKey: .socialSkills)
        try container.encode(mentalSkills, forKey: .mentalSkills)
        try container.encode(willpower, forKey: .willpower)
        try container.encode(experience, forKey: .experience)
        try container.encode(spentExperience, forKey: .spentExperience)
        try container.encode(ambition, forKey: .ambition)
        try container.encode(desire, forKey: .desire)
        try container.encode(chronicleName, forKey: .chronicleName)
        try container.encode(concept, forKey: .concept)
        try container.encode(characterDescription, forKey: .characterDescription)
        try container.encode(notes, forKey: .notes)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(advantages, forKey: .advantages)
        try container.encode(flaws, forKey: .flaws)
        try container.encode(backgroundMerits, forKey: .backgroundMerits)
        try container.encode(backgroundFlaws, forKey: .backgroundFlaws)
        try container.encode(convictions, forKey: .convictions)
        try container.encode(touchstones, forKey: .touchstones)
        try container.encode(specializations, forKey: .specializations)
        try container.encode(currentSession, forKey: .currentSession)
        try container.encode(changeLog, forKey: .changeLog)
        try container.encode(isArchived, forKey: .isArchived)
        try container.encode(health, forKey: .health)
        try container.encode(healthStates, forKey: .healthStates)
        try container.encode(willpowerStates, forKey: .willpowerStates)
    }

    init(characterType: CharacterType) {
        self.characterType = characterType

        let initialPhysicalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.physicalAttributes.map { ($0, 1) })
        let initialSocialAttributes = Dictionary(uniqueKeysWithValues: V5Constants.socialAttributes.map { ($0, 1) })
        let initialMentalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.mentalAttributes.map { ($0, 1) })

        let initialPhysicalSkills = Dictionary(uniqueKeysWithValues: V5Constants.physicalSkills.map { ($0, 0) })
        let initialSocialSkills = Dictionary(uniqueKeysWithValues: V5Constants.socialSkills.map { ($0, 0) })
        let initialMentalSkills = Dictionary(uniqueKeysWithValues: V5Constants.mentalSkills.map { ($0, 0) })

        // Calculate values before assigning to properties
        let stamina = initialPhysicalAttributes["Stamina"] ?? 1
        let resolve = initialMentalAttributes["Resolve"] ?? 1
        let composure = initialSocialAttributes["Composure"] ?? 1
        
        let health = stamina + 3
        let willpower = resolve + composure

        self.physicalAttributes = initialPhysicalAttributes
        self.socialAttributes = initialSocialAttributes
        self.mentalAttributes = initialMentalAttributes

        self.physicalSkills = initialPhysicalSkills
        self.socialSkills = initialSocialSkills
        self.mentalSkills = initialMentalSkills

        self.health = health
        self.willpower = willpower
        self.healthStates = Array(repeating: .ok, count: health)
        self.willpowerStates = Array(repeating: .ok, count: willpower)
    }

    var totalAdvantageCost: Int {
        advantages.reduce(0) { $0 + $1.cost } + backgroundMerits.reduce(0) { $0 + $1.cost }
    }

    var totalFlawValue: Int {
        flaws.reduce(0) { $0 + $1.cost } + backgroundFlaws.reduce(0) { $0 + $1.cost }
    }

    var netAdvantageFlawCost: Int {
        totalAdvantageCost + totalFlawValue
    }

    var availableExperience: Int {
        experience - spentExperience
    }

    var healthBoxCount: Int {
        self.health
    }

    var willpowerBoxCount: Int {
        self.willpower
    }

    func getSpecializations(for skillName: String) -> [Specialization] {
        specializations.filter { $0.skillName == skillName }
    }

    func getSkillsWithPoints() -> [String] {
        let mergedSkills = physicalSkills.merging(socialSkills, uniquingKeysWith: { $1 })
                .merging(mentalSkills, uniquingKeysWith: { $1 })

        return mergedSkills
            .filter { $0.value > 0 }
            .map { $0.key }
            .sorted()
    }

    func getSkillsRequiringFreeSpecializationWithPoints() -> [String] {
        let skillsWithPoints = getSkillsWithPoints()
        let skillsRequiringFree = V5Constants.getSkillsRequiringFreeSpecialization()
        return skillsWithPoints.filter { skillsRequiringFree.contains($0) }
    }

    func recalculateDerivedValues() {
        let stamina = physicalAttributes["Stamina"] ?? 1
        let resolve = mentalAttributes["Resolve"] ?? 1
        let composure = socialAttributes["Composure"] ?? 1

        // Calculate base values
        var newHealth = stamina + 3
        var newWillpower = resolve + composure
        
        // Add discipline bonuses if this character has disciplines
        if let disciplineCharacter = self as? DisciplineCapable {
            newHealth += disciplineCharacter.getDisciplineHealthBonus()
            newWillpower += disciplineCharacter.getDisciplineWillpowerBonus()
        }

        if newHealth != health {
            health = newHealth
            if healthStates.count < newHealth {
                healthStates.append(contentsOf: Array(repeating: .ok, count: newHealth - healthStates.count))
            } else {
                // Remove excess wounds when health decreases, starting from the end
                let excessWounds = healthStates.count - newHealth
                if excessWounds > 0 {
                    // Count wounds from the end and remove them
                    var woundsToRemove = 0
                    for i in stride(from: healthStates.count - 1, through: newHealth, by: -1) {
                        if healthStates[i] != .ok {
                            woundsToRemove += 1
                        }
                    }
                    
                    // Truncate the array but preserve existing wounds in remaining slots
                    healthStates = Array(healthStates.prefix(newHealth))
                }
            }
        }

        if newWillpower != willpower {
            willpower = newWillpower
            if willpowerStates.count < newWillpower {
                willpowerStates.append(contentsOf: Array(repeating: .ok, count: newWillpower - willpowerStates.count))
            } else {
                willpowerStates = Array(willpowerStates.prefix(newWillpower))
            }
        }
    }

    func getAttributeValue(attribute: String) -> Int {
        physicalAttributes[attribute] ?? socialAttributes[attribute] ?? mentalAttributes[attribute] ?? 0
    }

    func getSkillValue(skill: String) -> Int {
        physicalSkills[skill] ?? socialSkills[skill] ?? mentalSkills[skill] ?? 0
    }

    func generateChangeSummary(for updated: any BaseCharacter) -> String {
        return ""
    }
    
    func processBackgroundChanges(original: [BackgroundBase], updated: [BackgroundBase], name: String, changes: inout [String])
    {
        let originalSet = Set(original)
        let updatedSet = Set(updated)

        let removed = originalSet.subtracting(updatedSet)
        let added = updatedSet.subtracting(originalSet)

        if !removed.isEmpty || !added.isEmpty {
            if !removed.isEmpty {
                let removedNames = removed.map { $0.name }.joined(separator: ", ")
                changes.append("\(name)s removed: \(removedNames)")
            }
            if !added.isEmpty {
                let addedNames = added.map { $0.name }.joined(separator: ", ")
                changes.append("\(name)s added: \(addedNames)")
            }
        }
    }
    
    func processCharacterBackgroundChanges(original: [CharacterBackground], updated: [CharacterBackground], name: String, changes: inout [String])
    {
        let originalSet = Set(original.map(\.id))
        let updatedSet = Set(updated.map(\.id))

        let removed = originalSet.subtracting(updatedSet)
        let added = updatedSet.subtracting(originalSet)

        if !removed.isEmpty || !added.isEmpty {
            if !removed.isEmpty {
                let removedBackgrounds = original.filter { removed.contains($0.id) }
                let removedNames = removedBackgrounds.map { "\($0.name) (\($0.cost) pts)" }.joined(separator: ", ")
                changes.append("\(name) removed: \(removedNames)")
            }
            if !added.isEmpty {
                let addedBackgrounds = updated.filter { added.contains($0.id) }
                let addedNames = addedBackgrounds.map { "\($0.name) (\($0.cost) pts)" }.joined(separator: ", ")
                changes.append("\(name) added: \(addedNames)")
            }
        }
        
        // Check for changes in existing backgrounds (same ID but different content)
        let commonIds = Set(original.map(\.id)).intersection(Set(updated.map(\.id)))
        for id in commonIds {
            if let originalBg = original.first(where: { $0.id == id }),
               let updatedBg = updated.first(where: { $0.id == id }),
               originalBg != updatedBg {
                var changeDetails: [String] = []
                if originalBg.cost != updatedBg.cost {
                    changeDetails.append("cost \(originalBg.cost) → \(updatedBg.cost)")
                }
                if originalBg.comment != updatedBg.comment {
                    changeDetails.append("comment updated")
                }
                if !changeDetails.isEmpty {
                    changes.append("\(name) \(originalBg.name) modified: \(changeDetails.joined(separator: ", "))")
                }
            }
        }
    }
        
    func processSpecializationChanges(original: [Specialization], updated: [Specialization], changes: inout [String])
    {
        let originalSet = Set(original)
        let updatedSet = Set(updated)

        let removed = originalSet.subtracting(updatedSet)
        let added = updatedSet.subtracting(originalSet)

        if !removed.isEmpty || !added.isEmpty {
            if !removed.isEmpty {
                let removedNames = removed.map { $0.name }.joined(separator: ", ")
                changes.append("specializations removed: \(removedNames)")
            }
            if !added.isEmpty {
                let addedNames = added.map { $0.name }.joined(separator: ", ")
                changes.append("specializations added: \(addedNames)")
            }
        }
    }
    
    func processStringArrayChanges(original: [String], updated: [String], name: String, changes: inout [String])
    {
        let originalSet = Set(original)
        let updatedSet = Set(updated)

        let removed = originalSet.subtracting(updatedSet)
        let added = updatedSet.subtracting(originalSet)

        if !removed.isEmpty || !added.isEmpty {
            if !removed.isEmpty {
                let removedItems = removed.joined(separator: ", ")
                changes.append("\(name) removed: \(removedItems)")
            }
            if !added.isEmpty {
                let addedItems = added.joined(separator: ", ")
                changes.append("\(name) added: \(addedItems)")
            }
        }
    }
    
    func cloneBase<T: CharacterBase>(into copy: T) {
        copy.id = self.id
        copy.name = self.name
        copy.physicalAttributes = self.physicalAttributes
        copy.socialAttributes = self.socialAttributes
        copy.mentalAttributes = self.mentalAttributes
        copy.physicalSkills = self.physicalSkills
        copy.socialSkills = self.socialSkills
        copy.mentalSkills = self.mentalSkills
        copy.willpower = self.willpower
        copy.experience = self.experience
        copy.spentExperience = self.spentExperience
        copy.ambition = self.ambition
        copy.desire = self.desire
        copy.chronicleName = self.chronicleName
        copy.concept = self.concept
        copy.dateOfBirth = self.dateOfBirth
        copy.advantages = self.advantages
        copy.flaws = self.flaws
        copy.backgroundMerits = self.backgroundMerits
        copy.backgroundFlaws = self.backgroundFlaws
        copy.convictions = self.convictions
        copy.touchstones = self.touchstones
        copy.specializations = self.specializations
        copy.currentSession = self.currentSession
        copy.changeLog = self.changeLog
        copy.isArchived = self.isArchived
        copy.health = self.health
        copy.healthStates = self.healthStates
        copy.willpowerStates = self.willpowerStates
    }
    
    func clone() -> any BaseCharacter {
        return self as any BaseCharacter
    }
}


struct AnyCharacter: Codable, Identifiable {
    var character: any BaseCharacter

    var id: UUID {
        character.id
    }

    enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    init(_ character: any BaseCharacter) {
        self.character = character
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(CharacterType.self, forKey: .type)

        switch type {
        case .vampire:
            character = try container.decode(VampireCharacter.self, forKey: .data)
        case .ghoul:
            character = try container.decode(GhoulCharacter.self, forKey: .data)
        case .mage:
            character = try container.decode(MageCharacter.self, forKey: .data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let vampire = character as? VampireCharacter {
            try container.encode(CharacterType.vampire, forKey: .type)
            try container.encode(vampire, forKey: .data)
        } else if let ghoul = character as? GhoulCharacter {
            try container.encode(CharacterType.ghoul, forKey: .type)
            try container.encode(ghoul, forKey: .data)
        } else if let mage = character as? MageCharacter {
            try container.encode(CharacterType.mage, forKey: .type)
            try container.encode(mage, forKey: .data)
        } else {
            throw EncodingError.invalidValue(character, .init(
                codingPath: [],
                debugDescription: "Unsupported character type"
            ))
        }
    }
}

class CharacterStore: ObservableObject {
    @Published var characters: [AnyCharacter] {
        didSet {
            save()
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "characters"),
           let decoded = try? JSONDecoder().decode([AnyCharacter].self, from: data) {
            characters = decoded
        } else {
            characters = []
        }
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(characters) {
            UserDefaults.standard.set(encoded, forKey: "characters")
        }
    }

    func addCharacter(_ character: any BaseCharacter) {
        characters.append(AnyCharacter(character))
    }

    func deleteCharacter(at offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }
    
    func updateCharacter(_ updatedCharacter: any BaseCharacter) {
        if let index = characters.firstIndex(where: { $0.id == updatedCharacter.id }) {
            characters[index] = AnyCharacter(updatedCharacter)
        }
    }
    
    func archiveCharacter(_ character: any BaseCharacter) {
        var updatedCharacter = character
        updatedCharacter.isArchived = true
        updatedCharacter.changeLog.append(ChangeLogEntry(summary: "Character moved to archive."))
        updateCharacter(updatedCharacter)
    }
    
    func unarchiveCharacter(_ character: any BaseCharacter) {
        var updatedCharacter = character
        updatedCharacter.isArchived = false
        updatedCharacter.changeLog.append(ChangeLogEntry(summary: "Character returned from archive"))
        updateCharacter(updatedCharacter)
    }
}
