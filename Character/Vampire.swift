import SwiftUI

// Data structures for character traits with costs
struct Background: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var cost: Int
    var isCustom: Bool = false
    
    init(name: String, cost: Int, isCustom: Bool = false) {
        self.name = name
        self.cost = cost
        self.isCustom = isCustom
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



// V5 Character System Constants
struct V5Constants {
    // Physical Attributes
    static let physicalAttributes = ["Strength", "Dexterity", "Stamina"]
    
    // Social Attributes
    static let socialAttributes = ["Charisma", "Manipulation", "Composure"]
    
    // Mental Attributes
    static let mentalAttributes = ["Intelligence", "Wits", "Resolve"]
    
    // Physical Skills (for backward compatibility)
    static let physicalSkills = ["Athletics", "Brawl", "Craft", "Drive", "Firearms", "Larceny", "Melee", "Stealth", "Survival"]
    
    // Social Skills (for backward compatibility)
    static let socialSkills = ["Animal Ken", "Etiquette", "Insight", "Intimidation", "Leadership", "Performance", "Persuasion", "Streetwise", "Subterfuge"]
    
    // Mental Skills (for backward compatibility)
    static let mentalSkills = ["Academics", "Awareness", "Finance", "Investigation", "Medicine", "Occult", "Politics", "Science", "Technology"]
    
    // Detailed skill information with specialization examples
    static let physicalSkillsInfo = [
        SkillInfo(name: "Athletics", specializationExamples: ["Climbing", "Running", "Swimming", "Parkour", "Acrobatics"]),
        SkillInfo(name: "Brawl", specializationExamples: ["Boxing", "Wrestling", "Martial Arts", "Grappling", "Dirty Fighting"]),
        SkillInfo(name: "Craft", specializationExamples: ["Woodworking", "Metalworking", "Painting", "Sculpture", "Electronics"], requiresFreeSpecialization: true),
        SkillInfo(name: "Drive", specializationExamples: ["Cars", "Motorcycles", "Trucks", "Racing", "Off-road"]),
        SkillInfo(name: "Firearms", specializationExamples: ["Pistols", "Rifles", "Shotguns", "Archery", "Thrown Weapons"]),
        SkillInfo(name: "Larceny", specializationExamples: ["Lockpicking", "Pickpocketing", "Security Systems", "Safecracking", "Sleight of Hand"]),
        SkillInfo(name: "Melee", specializationExamples: ["Swords", "Knives", "Clubs", "Improvised Weapons", "Fencing"]),
        SkillInfo(name: "Stealth", specializationExamples: ["Hiding", "Moving Silently", "Camouflage", "Crowds", "Shadows"]),
        SkillInfo(name: "Survival", specializationExamples: ["Tracking", "Foraging", "Navigation", "Weather Prediction", "Urban Survival"])
    ]
    
    static let socialSkillsInfo = [
        SkillInfo(name: "Animal Ken", specializationExamples: ["Dogs", "Cats", "Horses", "Wild Animals", "Rats"]),
        SkillInfo(name: "Etiquette", specializationExamples: ["High Society", "Corporate", "Street", "Academic", "Criminal"]),
        SkillInfo(name: "Insight", specializationExamples: ["Emotions", "Lies", "Fear", "Desires", "Motivations"]),
        SkillInfo(name: "Intimidation", specializationExamples: ["Physical Threats", "Stare Down", "Verbal Abuse", "Torture", "Social Pressure"]),
        SkillInfo(name: "Leadership", specializationExamples: ["Military", "Corporate", "Gang", "Cult", "Noble"]),
        SkillInfo(name: "Performance", specializationExamples: ["Acting", "Singing", "Dancing", "Comedy", "Oratory"], requiresFreeSpecialization: true),
        SkillInfo(name: "Persuasion", specializationExamples: ["Fast Talk", "Seduction", "Sales", "Oratory", "Lies"]),
        SkillInfo(name: "Streetwise", specializationExamples: ["Rumors", "Black Market", "Drugs", "Gangs", "Fence"]),
        SkillInfo(name: "Subterfuge", specializationExamples: ["Lying", "Misdirection", "Innocent Face", "Changing Subject", "Long Con"])
    ]
    
    static let mentalSkillsInfo = [
        SkillInfo(name: "Academics", specializationExamples: ["History", "Literature", "Anthropology", "Art", "Law"], requiresFreeSpecialization: true),
        SkillInfo(name: "Awareness", specializationExamples: ["Ambushes", "Crowds", "Supernatural", "Details", "Eavesdropping"]),
        SkillInfo(name: "Finance", specializationExamples: ["Accounting", "Investment", "Banking", "Appraisal", "Forgery"]),
        SkillInfo(name: "Investigation", specializationExamples: ["Crime Scenes", "Research", "Surveillance", "Forensics", "Internet"]),
        SkillInfo(name: "Medicine", specializationExamples: ["First Aid", "Surgery", "Pathology", "Pharmacy", "Veterinary"]),
        SkillInfo(name: "Occult", specializationExamples: ["Kindred Lore", "Rituals", "Ghosts", "Witchcraft", "Mythology"]),
        SkillInfo(name: "Politics", specializationExamples: ["City", "Kindred", "Corporate", "Church", "Anarchs"]),
        SkillInfo(name: "Science", specializationExamples: ["Biology", "Chemistry", "Physics", "Psychology", "Computer Science"], requiresFreeSpecialization: true),
        SkillInfo(name: "Technology", specializationExamples: ["Computers", "Electronics", "Programming", "Hacking", "Data Recovery"])
    ]
    
    // Helper methods to access skill information
    static func getSkillInfo(for skillName: String) -> SkillInfo? {
        let allSkills = physicalSkillsInfo + socialSkillsInfo + mentalSkillsInfo
        return allSkills.first { $0.name == skillName }
    }
    
    static func getAllSkillsInfo() -> [SkillInfo] {
        return physicalSkillsInfo + socialSkillsInfo + mentalSkillsInfo
    }
    
    static func getSkillsRequiringFreeSpecialization() -> [String] {
        return getAllSkillsInfo().filter { $0.requiresFreeSpecialization }.map { $0.name }
    }
    
    // Major V5 Disciplines
    static let disciplines = ["Animalism", "Auspex", "Blood Sorcery", "Celerity", "Dominate", "Fortitude", "Obfuscate", "Potence", "Presence", "Protean", "Hecata Sorcery", "Lasombra Oblivion", "Oblivion", "Obeah", "Quietus", "Serpentis", "Vicissitude"]
    
    // V5 Clans
    static let clans = ["Brujah", "Gangrel", "Malkavian", "Nosferatu", "Toreador", "Tremere", "Ventrue", "Banu Haqim", "Hecata", "Lasombra", "Ministry", "Ravnos", "Salubri", "Tzimisce", "Caitiff", "Thin-Blood"]
    
    // Predefined V5 Advantages with costs
    static let predefinedAdvantages = [
        Background(name: "Allies", cost: 3),
        Background(name: "Contacts", cost: 1),
        Background(name: "Fame", cost: 1),
        Background(name: "Herd", cost: 3),
        Background(name: "Influence", cost: 2),
        Background(name: "Resources", cost: 3),
        Background(name: "Retainers", cost: 2),
        Background(name: "Status", cost: 2),
        Background(name: "Haven", cost: 2),
        Background(name: "Feeding Grounds", cost: 1),
        Background(name: "Iron Will", cost: 5),
        Background(name: "Time Sense", cost: 1),
        Background(name: "Eidetic Memory", cost: 2),
        Background(name: "Linguistics", cost: 1),
        Background(name: "Domain", cost: 2),
        Background(name: "Thin-Blooded Alchemy", cost: 5)
    ]
    
    // Predefined V5 Flaws with costs (negative values as they give points back)
    static let predefinedFlaws = [
        Background(name: "Enemy", cost: -1),
        Background(name: "Dark Secret", cost: -1),
        Background(name: "Hunted", cost: -3),
        Background(name: "Folkloric Block", cost: -2),
        Background(name: "Clan Curse", cost: -2),
        Background(name: "Feeding Restriction", cost: -1),
        Background(name: "Obvious Predator", cost: -2),
        Background(name: "Prey Exclusion", cost: -1),
        Background(name: "Stigmata", cost: -2),
        Background(name: "Thin-Blooded", cost: -4),
        Background(name: "Caitiff", cost: -2),
        Background(name: "Anachronism", cost: -1),
        Background(name: "Archaic", cost: -1),
        Background(name: "Disgraced", cost: -2),
        Background(name: "Shunned", cost: -1),
        Background(name: "Suspect", cost: -2)
    ]
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

import Foundation
import SwiftUI

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

    var advantages: [Background] { get set }
    var flaws: [Background] { get set }
    var convictions: [String] { get set }
    var touchstones: [String] { get set }

    var specializations: [Specialization] { get set }
    var currentSession: Int { get set }
    var changeLog: [ChangeLogEntry] { get set }

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

    @Published var advantages: [Background] = []
    @Published var flaws: [Background] = []
    @Published var convictions: [String] = []
    @Published var touchstones: [String] = []

    @Published var specializations: [Specialization] = []
    @Published var currentSession: Int = 1
    @Published var changeLog: [ChangeLogEntry] = []

    @Published var health: Int
    @Published var healthStates: [HealthState]
    @Published var willpowerStates: [WillpowerState]

    enum CodingKeys: String, CodingKey {
        case id, name, characterType,
             physicalAttributes, socialAttributes, mentalAttributes,
             physicalSkills, socialSkills, mentalSkills,
             willpower, experience, spentExperience,
             ambition, desire, chronicleName,
             advantages, flaws, convictions, touchstones, chronicleTenets,
             specializations, currentSession, changeLog,
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
        advantages = try container.decode([Background].self, forKey: .advantages)
        flaws = try container.decode([Background].self, forKey: .flaws)
        convictions = try container.decode([String].self, forKey: .convictions)
        touchstones = try container.decode([String].self, forKey: .touchstones)
        specializations = try container.decode([Specialization].self, forKey: .specializations)
        currentSession = try container.decode(Int.self, forKey: .currentSession)
        changeLog = try container.decode([ChangeLogEntry].self, forKey: .changeLog)
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
        try container.encode(advantages, forKey: .advantages)
        try container.encode(flaws, forKey: .flaws)
        try container.encode(convictions, forKey: .convictions)
        try container.encode(touchstones, forKey: .touchstones)
        try container.encode(specializations, forKey: .specializations)
        try container.encode(currentSession, forKey: .currentSession)
        try container.encode(changeLog, forKey: .changeLog)
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
        advantages.reduce(0) { $0 + $1.cost }
    }

    var totalFlawValue: Int {
        flaws.reduce(0) { $0 + $1.cost }
    }

    var netAdvantageFlawCost: Int {
        totalAdvantageCost + totalFlawValue
    }

    var availableExperience: Int {
        experience - spentExperience
    }

    var healthBoxCount: Int {
        (physicalAttributes["Stamina"] ?? 1) + 3
    }

    var willpowerBoxCount: Int {
        (mentalAttributes["Resolve"] ?? 1) + (socialAttributes["Composure"] ?? 1)
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

        let newHealth = stamina + 3
        let newWillpower = resolve + composure

        if newHealth != health {
            health = newHealth
            if healthStates.count < newHealth {
                healthStates.append(contentsOf: Array(repeating: .ok, count: newHealth - healthStates.count))
            } else {
                healthStates = Array(healthStates.prefix(newHealth))
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
    
    func processBackgroundChanges(original: [Background], updated: [Background], name: String, changes: inout [String])
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
        copy.advantages = self.advantages
        copy.flaws = self.flaws
        copy.convictions = self.convictions
        copy.touchstones = self.touchstones
        copy.specializations = self.specializations
        copy.currentSession = self.currentSession
        copy.changeLog = self.changeLog
        copy.health = self.health
        copy.healthStates = self.healthStates
        copy.willpowerStates = self.willpowerStates
    }
    
    func clone() -> any BaseCharacter {
        return self as any BaseCharacter
    }
}

// MARK: - Vampire
class Vampire: CharacterBase {
    @Published var clan: String
    @Published var generation: Int
    @Published var bloodPotency: Int
    @Published var humanity: Int
    @Published var hunger: Int
    @Published var disciplines: [String: Int]
    @Published var humanityStates: [HumanityState]

    enum CodingKeys: String, CodingKey {
        case clan, generation, bloodPotency, humanity, hunger, disciplines, humanityStates
    }

    override init(characterType: CharacterType = .vampire) {
        self.clan = ""
        self.generation = 13
        self.bloodPotency = 1
        self.humanity = 7
        self.hunger = 1
        self.disciplines = [:]
        self.humanityStates = Array(repeating: .unchecked, count: 10)
        super.init(characterType: characterType)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clan = try container.decode(String.self, forKey: .clan)
        self.generation = try container.decode(Int.self, forKey: .generation)
        self.bloodPotency = try container.decode(Int.self, forKey: .bloodPotency)
        self.humanity = try container.decode(Int.self, forKey: .humanity)
        self.hunger = try container.decode(Int.self, forKey: .hunger)
        self.disciplines = try container.decode([String: Int].self, forKey: .disciplines)
        self.humanityStates = try container.decode([HumanityState].self, forKey: .humanityStates)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clan, forKey: .clan)
        try container.encode(generation, forKey: .generation)
        try container.encode(bloodPotency, forKey: .bloodPotency)
        try container.encode(humanity, forKey: .humanity)
        try container.encode(hunger, forKey: .hunger)
        try container.encode(disciplines, forKey: .disciplines)
        try container.encode(humanityStates, forKey: .humanityStates)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! Vampire
                
        // Check basic information changes
        if self.name != other.name {
            changes.append("clan \(self.name)→\(other.name)")
        }
        if self.clan != other.clan {
            changes.append("clan \(self.clan)→\(other.clan)")
        }
        if self.generation != other.generation {
            changes.append("generation \(self.generation)→\(other.generation)")
        }
        
        // Check attribute changes
        for attribute in V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes {
            let originalVal = self.getAttributeValue(attribute: attribute)
            let updatedVal = other.getAttributeValue(attribute: attribute)
            if originalVal != updatedVal {
                changes.append("\(attribute.lowercased()) \(originalVal)→\(updatedVal)")
            }
        }
        
        // Check skill changes
        for skill in V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills {
            let originalVal = self.getSkillValue(skill: skill)
            let updatedVal = other.getSkillValue(skill: skill)
            if originalVal != updatedVal {
                changes.append("\(skill.lowercased()) \(originalVal)→\(updatedVal)")
            }
        }
        
        // Check core traits
        if self.bloodPotency != other.bloodPotency {
            changes.append("blood potency \(self.bloodPotency)→\(other.bloodPotency)")
        }
        if self.humanity != other.humanity {
            changes.append("humanity \(self.humanity)→\(other.humanity)")
        }
        if self.experience != other.experience {
            changes.append("experience \(self.experience)→\(other.experience)")
        }
        if self.spentExperience != other.spentExperience {
            changes.append("spent experience \(self.spentExperience)→\(other.spentExperience)")
        }
        
        // Check discipline changes
        let allDisciplines = Set(self.disciplines.keys).union(Set(other.disciplines.keys))
        for discipline in allDisciplines {
            let originalVal = self.disciplines[discipline] ?? 0
            let updatedVal = other.disciplines[discipline] ?? 0
            if originalVal != updatedVal {
                changes.append("\(discipline.lowercased()) \(originalVal)→\(updatedVal)")
            }
        }
        
        //Check specialisations
        processSpecializationChanges(original: self.specializations, updated: other.specializations, changes: &changes)
        
        // Check advantages/flaws changes
        processBackgroundChanges(original: self.advantages, updated: other.advantages, name: "advantage", changes: &changes)
        processBackgroundChanges(original: self.flaws, updated: other.flaws, name: "flaw", changes: &changes)
        
        if changes.isEmpty {
            return ""
        } else {
            return changes.joined(separator: "\n")
        }
    }
    
    override func clone() -> any BaseCharacter {
        let copy = Vampire()
        cloneBase(into: copy)

        // Copy Vampire-specific properties
        copy.clan = self.clan
        copy.generation = self.generation
        copy.bloodPotency = self.bloodPotency
        copy.humanity = self.humanity
        copy.humanityStates = self.humanityStates
        copy.hunger = self.hunger
        copy.disciplines = self.disciplines

        return copy
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
            character = try container.decode(Vampire.self, forKey: .data)
        case .ghoul:
            character = try container.decode(Vampire.self, forKey: .data)
        case .mage:
            character = try container.decode(Vampire.self, forKey: .data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let vampire = character as? Vampire {
            try container.encode(CharacterType.vampire, forKey: .type)
            try container.encode(vampire, forKey: .data)
        }/* else if let mage = character as? MageCharacter {
            try container.encode(CharacterType.mage, forKey: .type)
            try container.encode(mage, forKey: .data)
        } */else {
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
}
