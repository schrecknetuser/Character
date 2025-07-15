import SwiftUI

// Data structures for character traits with costs (renamed to avoid confusion with character backgrounds)
struct BackgroundBase: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var cost: Int
    var description: String = ""
    var isCustom: Bool = false
    var suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)
    
    init(name: String, cost: Int, description: String = "", isCustom: Bool = false, suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)) {
        self.name = name
        self.cost = cost
        self.description = description
        self.isCustom = isCustom
        self.suitableCharacterTypes = suitableCharacterTypes
    }
}

// New structure for character backgrounds (separate from merits/flaws)
struct CharacterBackground: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var cost: Int
    var comment: String = ""
    var type: BackgroundType
    var suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)
    
    init(name: String, cost: Int, comment: String = "", type: BackgroundType, suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)) {
        self.name = name
        self.cost = cost
        self.comment = comment
        self.type = type
        self.suitableCharacterTypes = suitableCharacterTypes
    }
}

// Background type enumeration for merit vs flaw backgrounds
enum BackgroundType: String, Codable, CaseIterable {
    case merit = "merit"
    case flaw = "flaw"
    
    var displayName: String {
        switch self {
        case .merit:
            return "Merit"
        case .flaw:
            return "Flaw"
        }
    }
}

// Data structure for skill specializations
struct Specialization: Identifiable, Codable, Hashable {
    var id = UUID()
    var skillName: String
    var name: String
    
    init(skillName: String, name: String) {
        self.skillName = skillName
        self.name = name
    }
}

// Data structure for change log entries
struct ChangeLogEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var timestamp: Date
    var summary: String
    
    init(summary: String) {
        self.timestamp = Date()
        self.summary = summary
    }
}

// Data structure for skills with specialization information
struct SkillInfo: Codable, Hashable {
    var name: String
    var specializationExamples: [String]
    var requiresFreeSpecialization: Bool
    
    init(name: String, specializationExamples: [String] = [], requiresFreeSpecialization: Bool = false) {
        self.name = name
        self.specializationExamples = specializationExamples
        self.requiresFreeSpecialization = requiresFreeSpecialization
    }
}

// Health tracking states
enum HealthState: String, Codable, CaseIterable {
    case ok = "ok"
    case superficial = "superficial"
    case aggravated = "aggravated"
}

// Willpower tracking states (same as health)
typealias WillpowerState = HealthState

// Humanity tracking states
enum HumanityState: String, Codable, CaseIterable {
    case checked = "checked"
    case unchecked = "unchecked"
    case stained = "stained"
}

// Hubris and Quiet tracking states (for mages - no stains)
enum MageTraitState: String, Codable, CaseIterable {
    case checked = "checked"
    case unchecked = "unchecked"
}

// Data structure for mage instruments
struct Instrument: Identifiable, Codable, Hashable {
    var id = UUID()
    var description: String
    var usage: String
    
    init(description: String, usage: String = "") {
        self.description = description
        self.usage = usage
    }
}

// MARK: - V5 Discipline System

// Data structure for a single discipline power
struct V5DisciplinePower: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var level: Int
    var isCustom: Bool = false
    var addToHealth: Bool = false
    var addToWillpower: Bool = false
    
    init(name: String, description: String, level: Int, isCustom: Bool = false, addToHealth: Bool = false, addToWillpower: Bool = false) {
        self.name = name
        self.description = description
        self.level = level
        self.isCustom = isCustom
        self.addToHealth = addToHealth
        self.addToWillpower = addToWillpower
    }
    
    // Custom coding to maintain backwards compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        level = try container.decode(Int.self, forKey: .level)
        isCustom = try container.decodeIfPresent(Bool.self, forKey: .isCustom) ?? false
        addToHealth = try container.decodeIfPresent(Bool.self, forKey: .addToHealth) ?? false
        addToWillpower = try container.decodeIfPresent(Bool.self, forKey: .addToWillpower) ?? false
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, level, isCustom, addToHealth, addToWillpower
    }
}

// Data structure for a complete V5 discipline with powers per level and progress tracking
struct V5Discipline: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String = ""
    var powers: [Int: [V5DisciplinePower]] // Level -> Powers
    var isCustom: Bool = false
    var selectedPowers: [Int: [V5DisciplinePower]] = [:] // Level -> Selected Power IDs
    var allowAllLevels: Bool = false
    
    static var theoreticalMaxLevel = 10
    
    init(name: String, description: String = "", powers: [Int: [V5DisciplinePower]] = [:], isCustom: Bool = false, allowAllLevels: Bool = false) {
        self.name = name
        self.description = description
        self.powers = powers
        self.isCustom = isCustom
        self.allowAllLevels = allowAllLevels
    }
    
    func getLevels() -> [Int] {
        return Array(powers.keys).sorted()
    }
    
    func isLevelAvailable(_ level: Int) -> Bool {
        return allowAllLevels || level <= currentLevel() + 1
    }
    
    // Get all powers for a specific level
    func getPowers(for level: Int) -> [V5DisciplinePower] {
        return powers[level] ?? []
    }
    
    // Add a power to a specific level
    mutating func addPower(_ power: V5DisciplinePower, level: Int) {
        if powers[level] == nil {
            powers[level] = []
        }
        powers[level]?.append(power)
    }

    
    func currentLevel() -> Int {
        return selectedPowers.values.flatMap { $0.map(\.id) }.count
    }
    
    // Toggle selection of a power at a specific level
    mutating func togglePower(_ powerId: UUID, at level: Int) {
        if selectedPowers[level] == nil {
            selectedPowers[level] = []
        }
        
        if selectedPowers[level]!.contains(where: { $0.id == powerId }) {
            selectedPowers[level]!.removeAll(where: { $0.id == powerId} )
        } else {
            var power = powers[level]!.first(where: { $0.id == powerId })!
            selectedPowers[level]!.append(power)
        }
    }
    
    // Get selected power IDs for a specific level
    func getSelectedPowers(for level: Int) -> Set<UUID> {
        if selectedPowers[level] == nil {
            return Set<UUID>()
        }
        return Set(selectedPowers[level]!.map { $0.id })
    }
    
    func getAllSelectedPowerNames() -> Set<String> {
        return Set(selectedPowers.values.flatMap { $0.map(\.name) })
    }
    
    // Custom coding to maintain backwards compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        powers = try container.decode([Int: [V5DisciplinePower]].self, forKey: .powers)
        isCustom = try container.decodeIfPresent(Bool.self, forKey: .isCustom) ?? false
        selectedPowers = try container.decodeIfPresent([Int: [V5DisciplinePower]].self, forKey: .selectedPowers) ?? [:]
        allowAllLevels = try container.decodeIfPresent(Bool.self, forKey: .allowAllLevels) ?? false
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, powers, isCustom, selectedPowers, allowAllLevels
    }
}

// MARK: - Predator Type System

// Data structure for predator type bonuses/drawbacks
struct PredatorTypeBonus: Identifiable, Codable, Hashable {
    var id = UUID()
    var type: BonusType
    var skillName: String?
    var disciplineName: String?
    var specializationName: String?
    var meritName: String?
    var flawName: String?
    var description: String
    
    enum BonusType: String, Codable, CaseIterable {
        case skillSpecialization = "skillSpecialization"
        case disciplineDot = "disciplineDot"
        case merit = "merit"
        case flaw = "flaw"
        case feeding = "feeding"
        case other = "other"
    }
    
    init(type: BonusType, description: String, skillName: String? = nil, disciplineName: String? = nil, specializationName: String? = nil, meritName: String? = nil, flawName: String? = nil) {
        self.type = type
        self.description = description
        self.skillName = skillName
        self.disciplineName = disciplineName
        self.specializationName = specializationName
        self.meritName = meritName
        self.flawName = flawName
    }
}

// Data structure for predator types
struct PredatorType: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var bonuses: [PredatorTypeBonus]
    var drawbacks: [PredatorTypeBonus]
    var feedingDescription: String
    
    init(name: String, description: String, bonuses: [PredatorTypeBonus] = [], drawbacks: [PredatorTypeBonus] = [], feedingDescription: String = "") {
        self.name = name
        self.description = description
        self.bonuses = bonuses
        self.drawbacks = drawbacks
        self.feedingDescription = feedingDescription
    }
}


