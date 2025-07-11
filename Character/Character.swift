import SwiftUI

// Data structures for character traits with costs
struct Advantage: Identifiable, Codable, Hashable {
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
    var session: Int
    
    init(summary: String, session: Int) {
        self.timestamp = Date()
        self.summary = summary
        self.session = session
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

struct Flaw: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var cost: Int // Negative cost for flaws (points gained)
    var isCustom: Bool = false
    
    init(name: String, cost: Int, isCustom: Bool = false) {
        self.name = name
        self.cost = cost
        self.isCustom = isCustom
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
        Advantage(name: "Allies", cost: 3),
        Advantage(name: "Contacts", cost: 1),
        Advantage(name: "Fame", cost: 1),
        Advantage(name: "Herd", cost: 3),
        Advantage(name: "Influence", cost: 2),
        Advantage(name: "Resources", cost: 3),
        Advantage(name: "Retainers", cost: 2),
        Advantage(name: "Status", cost: 2),
        Advantage(name: "Haven", cost: 2),
        Advantage(name: "Feeding Grounds", cost: 1),
        Advantage(name: "Iron Will", cost: 5),
        Advantage(name: "Time Sense", cost: 1),
        Advantage(name: "Eidetic Memory", cost: 2),
        Advantage(name: "Linguistics", cost: 1),
        Advantage(name: "Domain", cost: 2),
        Advantage(name: "Thin-Blooded Alchemy", cost: 5)
    ]
    
    // Predefined V5 Flaws with costs (negative values as they give points back)
    static let predefinedFlaws = [
        Flaw(name: "Enemy", cost: -1),
        Flaw(name: "Dark Secret", cost: -1),
        Flaw(name: "Hunted", cost: -3),
        Flaw(name: "Folkloric Block", cost: -2),
        Flaw(name: "Clan Curse", cost: -2),
        Flaw(name: "Feeding Restriction", cost: -1),
        Flaw(name: "Obvious Predator", cost: -2),
        Flaw(name: "Prey Exclusion", cost: -1),
        Flaw(name: "Stigmata", cost: -2),
        Flaw(name: "Thin-Blooded", cost: -4),
        Flaw(name: "Caitiff", cost: -2),
        Flaw(name: "Anachronism", cost: -1),
        Flaw(name: "Archaic", cost: -1),
        Flaw(name: "Disgraced", cost: -2),
        Flaw(name: "Shunned", cost: -1),
        Flaw(name: "Suspect", cost: -2)
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

struct Character: Identifiable, Codable {
    var id = UUID()
    var name: String
    var clan: String
    var generation: Int
    
    // V5 Core Attributes (9 total)
    var physicalAttributes: [String: Int]  // Strength, Dexterity, Stamina
    var socialAttributes: [String: Int]    // Charisma, Manipulation, Composure
    var mentalAttributes: [String: Int]    // Intelligence, Wits, Resolve
    
    // V5 Skills (27 total)
    var physicalSkills: [String: Int]      // Athletics, Brawl, Craft, Drive, Firearms, Larceny, Melee, Stealth, Survival
    var socialSkills: [String: Int]        // Animal Ken, Etiquette, Insight, Intimidation, Leadership, Performance, Persuasion, Streetwise, Subterfuge
    var mentalSkills: [String: Int]        // Academics, Awareness, Finance, Investigation, Medicine, Occult, Politics, Science, Technology
    
    // V5 Core Traits
    var bloodPotency: Int
    var humanity: Int
    var willpower: Int
    var experience: Int
    
    // Multi-tab fields
    var spentExperience: Int
    var ambition: String
    var desire: String
    var chronicleName: String
    
    // V5 Disciplines
    var disciplines: [String: Int]
    

    // V5 Character Traits
    var advantages: [Advantage]
    var flaws: [Flaw]
    var convictions: [String]
    var touchstones: [String]
    var chronicleTenets: [String]
    
    // Skill Specializations
    var specializations: [Specialization]
    
    // Data Tab - Session tracking and change log
    var currentSession: Int
    var changeLog: [ChangeLogEntry]
    
    // V5 Condition Tracking
    var hunger: Int
    var health: Int
    
    // Multi-tab status tracking arrays
    var healthStates: [HealthState]
    var willpowerStates: [WillpowerState]
    var humanityStates: [HumanityState]
    
    // Default initializer for new characters
    init(name: String = "", clan: String = "", generation: Int = 13) {
        self.name = name
        self.clan = clan
        self.generation = generation
        
        // Initialize attributes with default values (1 dot each)
        self.physicalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.physicalAttributes.map { ($0, 1) })
        self.socialAttributes = Dictionary(uniqueKeysWithValues: V5Constants.socialAttributes.map { ($0, 1) })
        self.mentalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.mentalAttributes.map { ($0, 1) })
        
        // Initialize skills with default values (0 dots each)
        self.physicalSkills = Dictionary(uniqueKeysWithValues: V5Constants.physicalSkills.map { ($0, 0) })
        self.socialSkills = Dictionary(uniqueKeysWithValues: V5Constants.socialSkills.map { ($0, 0) })
        self.mentalSkills = Dictionary(uniqueKeysWithValues: V5Constants.mentalSkills.map { ($0, 0) })
        
        // Initialize core traits with default values for character creation
        self.bloodPotency = 1
        self.humanity = 7
        // Willpower and health are calculated based on attributes
        let stamina = self.physicalAttributes["Stamina"] ?? 1
        let resolve = self.mentalAttributes["Resolve"] ?? 1
        let composure = self.socialAttributes["Composure"] ?? 1
        self.willpower = resolve + composure
        self.health = stamina + 3
        self.experience = 0  // Always start at 0 for new characters
        
        // Multi-tab fields with defaults for character creation
        self.spentExperience = 0  // Always start at 0 for new characters
        self.ambition = ""
        self.desire = ""
        self.chronicleName = ""
        
        // Initialize disciplines (empty by default)
        self.disciplines = [:]
        
        // Initialize character traits
        self.advantages = []
        self.flaws = []
        self.convictions = []
        self.touchstones = []
        self.chronicleTenets = []
        self.specializations = []
        
        // Initialize Data Tab properties
        self.currentSession = 1
        self.changeLog = []
        
        // Initialize condition tracking with defaults
        self.hunger = 1  // Always start at 1 for new characters
        
        // Initialize status tracking arrays based on calculated values
        self.healthStates = Array(repeating: .ok, count: self.health)
        self.willpowerStates = Array(repeating: .ok, count: self.willpower)
        self.humanityStates = Array(repeating: .unchecked, count: 10)
    }
    
    // Full initializer for existing characters or manual creation
    init(name: String, clan: String, generation: Int, physicalAttributes: [String: Int], socialAttributes: [String: Int], mentalAttributes: [String: Int], physicalSkills: [String: Int], socialSkills: [String: Int], mentalSkills: [String: Int], bloodPotency: Int, humanity: Int, willpower: Int, experience: Int, disciplines: [String: Int], advantages: [Advantage], flaws: [Flaw], convictions: [String], touchstones: [String], chronicleTenets: [String], hunger: Int, health: Int, spentExperience: Int = 0, ambition: String = "", desire: String = "", chronicleName: String = "", specializations: [Specialization] = [], currentSession: Int = 1, changeLog: [ChangeLogEntry] = [], healthStates: [HealthState]? = nil, willpowerStates: [WillpowerState]? = nil, humanityStates: [HumanityState]? = nil) {

        self.name = name
        self.clan = clan
        self.generation = generation
        self.physicalAttributes = physicalAttributes
        self.socialAttributes = socialAttributes
        self.mentalAttributes = mentalAttributes
        self.physicalSkills = physicalSkills
        self.socialSkills = socialSkills
        self.mentalSkills = mentalSkills
        self.bloodPotency = bloodPotency
        self.humanity = humanity
        self.willpower = willpower
        self.experience = experience
        self.disciplines = disciplines
        self.advantages = advantages
        self.flaws = flaws
        self.convictions = convictions
        self.touchstones = touchstones
        self.chronicleTenets = chronicleTenets
        self.specializations = specializations
        self.hunger = hunger
        self.health = health
        
        // Multi-tab fields
        self.spentExperience = spentExperience
        self.ambition = ambition
        self.desire = desire
        self.chronicleName = chronicleName
        
        // Data Tab fields
        self.currentSession = currentSession
        self.changeLog = changeLog
        
        // Initialize status tracking arrays with defaults
        self.healthStates = healthStates ?? Array(repeating: .ok, count: max(health, 1))
        self.willpowerStates = willpowerStates ?? Array(repeating: .ok, count: max(willpower, 1))
        self.humanityStates = humanityStates ?? Array(repeating: .unchecked, count: 10)
    }
    
    // Computed properties for advantage/flaw costs
    var totalAdvantageCost: Int {
        advantages.reduce(0) { $0 + $1.cost }
    }
    
    var totalFlawValue: Int {
        flaws.reduce(0) { $0 + $1.cost } // Flaw costs are negative, so this gives total points gained
    }
    
    var netAdvantageFlawCost: Int {
        totalAdvantageCost + totalFlawValue // Since flaw costs are negative, this is the net cost
    }
    
    // Computed properties for status tracking
    var sortedHealthStates: [HealthState] {
        healthStates.sorted { first, second in
            switch (first, second) {
            case (.aggravated, .superficial), (.aggravated, .ok): return true
            case (.superficial, .ok): return true
            default: return false
            }
        }
    }
    
    var sortedWillpowerStates: [WillpowerState] {
        willpowerStates.sorted { first, second in
            switch (first, second) {
            case (.aggravated, .superficial), (.aggravated, .ok): return true
            case (.superficial, .ok): return true
            default: return false
            }
        }
    }
    
    var availableExperience: Int {
        experience - spentExperience
    }
    
    // Computed properties for specializations
    func getSpecializations(for skillName: String) -> [Specialization] {
        return specializations.filter { $0.skillName == skillName }
    }
    
    func getSkillsWithPoints() -> [String] {
        var skillsWithPoints: [String] = []
        
        for (skill, value) in physicalSkills where value > 0 {
            skillsWithPoints.append(skill)
        }
        for (skill, value) in socialSkills where value > 0 {
            skillsWithPoints.append(skill)
        }
        for (skill, value) in mentalSkills where value > 0 {
            skillsWithPoints.append(skill)
        }
        
        return skillsWithPoints
    }
    
    func getSkillsRequiringFreeSpecializationWithPoints() -> [String] {
        let skillsWithPoints = getSkillsWithPoints()
        let skillsRequiringFree = V5Constants.getSkillsRequiringFreeSpecialization()
        return skillsWithPoints.filter { skillsRequiringFree.contains($0) }
    }
    
    // Computed properties for dynamic box counts
    var healthBoxCount: Int {
        (physicalAttributes["Stamina"] ?? 1) + 3
    }
    
    var willpowerBoxCount: Int {
        (mentalAttributes["Resolve"] ?? 1) + (socialAttributes["Composure"] ?? 1)
    }
    
    // Method to recalculate derived values when attributes change
    mutating func recalculateDerivedValues() {
        let stamina = physicalAttributes["Stamina"] ?? 1
        let resolve = mentalAttributes["Resolve"] ?? 1
        let composure = socialAttributes["Composure"] ?? 1
        
        let newHealth = stamina + 3
        let newWillpower = resolve + composure
        
        // Update health and willpower if they changed
        if newHealth != health {
            health = newHealth
            // Adjust health states array
            if healthStates.count < newHealth {
                healthStates.append(contentsOf: Array(repeating: .ok, count: newHealth - healthStates.count))
            } else if healthStates.count > newHealth {
                healthStates = Array(healthStates.prefix(newHealth))
            }
        }
        
        if newWillpower != willpower {
            willpower = newWillpower
            // Adjust willpower states array
            if willpowerStates.count < newWillpower {
                willpowerStates.append(contentsOf: Array(repeating: .ok, count: newWillpower - willpowerStates.count))
            } else if willpowerStates.count > newWillpower {
                willpowerStates = Array(willpowerStates.prefix(newWillpower))
            }
        }
    }
}

class CharacterStore: ObservableObject {
    @Published var characters: [Character] {
        didSet {
            save()
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "characters"),
           let decoded = try? JSONDecoder().decode([Character].self, from: data) {
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

    func addCharacter(_ character: Character) {
        characters.append(character)
    }

    func deleteCharacter(at offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }
    
    func updateCharacter(_ updatedCharacter: Character) {
        if let index = characters.firstIndex(where: { $0.id == updatedCharacter.id }) {
            characters[index] = updatedCharacter
        }
    }
}
