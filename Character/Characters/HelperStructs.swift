import SwiftUI

// Data structures for character traits with costs
struct Background: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var cost: Int
    var isCustom: Bool = false
    var suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)
    
    init(name: String, cost: Int, isCustom: Bool = false, suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)) {
        self.name = name
        self.cost = cost
        self.isCustom = isCustom
        self.suitableCharacterTypes = suitableCharacterTypes
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
    
    init(name: String, description: String, level: Int, isCustom: Bool = false) {
        self.name = name
        self.description = description
        self.level = level
        self.isCustom = isCustom
    }
}

// Data structure for a complete V5 discipline with powers per level and progress tracking
struct V5Discipline: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var powers: [Int: [V5DisciplinePower]] // Level -> Powers
    var isCustom: Bool = false
    var selectedPowers: [Int: [V5DisciplinePower]] = [:] // Level -> Selected Power IDs
    var allowAllLevels: Bool = false
    
    static var theoreticalMaxLevel = 10
    
    init(name: String, powers: [Int: [V5DisciplinePower]] = [:], isCustom: Bool = false, allowAllLevels: Bool = false) {
        self.name = name
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
}


