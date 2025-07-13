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
