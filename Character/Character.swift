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
    
    // Physical Skills
    static let physicalSkills = ["Athletics", "Brawl", "Craft", "Drive", "Firearms", "Larceny", "Melee", "Stealth", "Survival"]
    
    // Social Skills
    static let socialSkills = ["Animal Ken", "Etiquette", "Insight", "Intimidation", "Leadership", "Performance", "Persuasion", "Streetwise", "Subterfuge"]
    
    // Mental Skills
    static let mentalSkills = ["Academics", "Awareness", "Finance", "Investigation", "Medicine", "Occult", "Politics", "Science", "Technology"]
    
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
    
    // V5 Disciplines
    var disciplines: [String: Int]
    
    // V5 Character Traits
    var advantages: [Advantage]
    var flaws: [Flaw]
    var convictions: [String]
    var touchstones: [String]
    var chronicleTenets: [String]
    
    // V5 Condition Tracking
    var hunger: Int
    var health: Int
    
    // Custom decoding to handle backward compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode basic properties
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        clan = try container.decode(String.self, forKey: .clan)
        generation = try container.decode(Int.self, forKey: .generation)
        
        // Decode attributes and skills
        physicalAttributes = try container.decode([String: Int].self, forKey: .physicalAttributes)
        socialAttributes = try container.decode([String: Int].self, forKey: .socialAttributes)
        mentalAttributes = try container.decode([String: Int].self, forKey: .mentalAttributes)
        physicalSkills = try container.decode([String: Int].self, forKey: .physicalSkills)
        socialSkills = try container.decode([String: Int].self, forKey: .socialSkills)
        mentalSkills = try container.decode([String: Int].self, forKey: .mentalSkills)
        
        // Decode core traits
        bloodPotency = try container.decode(Int.self, forKey: .bloodPotency)
        humanity = try container.decode(Int.self, forKey: .humanity)
        willpower = try container.decode(Int.self, forKey: .willpower)
        experience = try container.decode(Int.self, forKey: .experience)
        
        // Decode disciplines
        disciplines = try container.decode([String: Int].self, forKey: .disciplines)
        
        // Handle backward compatibility for advantages and flaws
        if let newAdvantages = try? container.decode([Advantage].self, forKey: .advantages) {
            // New format - structured advantages with costs
            advantages = newAdvantages
        } else if let oldAdvantages = try? container.decode([String].self, forKey: .advantages) {
            // Old format - convert string array to Advantage array
            advantages = oldAdvantages.map { Advantage(name: $0, cost: 1, isCustom: true) }
        } else {
            advantages = []
        }
        
        if let newFlaws = try? container.decode([Flaw].self, forKey: .flaws) {
            // New format - structured flaws with costs
            flaws = newFlaws
        } else if let oldFlaws = try? container.decode([String].self, forKey: .flaws) {
            // Old format - convert string array to Flaw array
            flaws = oldFlaws.map { Flaw(name: $0, cost: -1, isCustom: true) }
        } else {
            flaws = []
        }
        
        // Decode remaining traits (these haven't changed)
        convictions = try container.decode([String].self, forKey: .convictions)
        touchstones = try container.decode([String].self, forKey: .touchstones)
        chronicleTenets = try container.decode([String].self, forKey: .chronicleTenets)
        
        // Decode condition tracking
        hunger = try container.decode(Int.self, forKey: .hunger)
        health = try container.decode(Int.self, forKey: .health)
    }
    
    // Standard encoding (always use new format)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(clan, forKey: .clan)
        try container.encode(generation, forKey: .generation)
        
        try container.encode(physicalAttributes, forKey: .physicalAttributes)
        try container.encode(socialAttributes, forKey: .socialAttributes)
        try container.encode(mentalAttributes, forKey: .mentalAttributes)
        try container.encode(physicalSkills, forKey: .physicalSkills)
        try container.encode(socialSkills, forKey: .socialSkills)
        try container.encode(mentalSkills, forKey: .mentalSkills)
        
        try container.encode(bloodPotency, forKey: .bloodPotency)
        try container.encode(humanity, forKey: .humanity)
        try container.encode(willpower, forKey: .willpower)
        try container.encode(experience, forKey: .experience)
        
        try container.encode(disciplines, forKey: .disciplines)
        try container.encode(advantages, forKey: .advantages)
        try container.encode(flaws, forKey: .flaws)
        try container.encode(convictions, forKey: .convictions)
        try container.encode(touchstones, forKey: .touchstones)
        try container.encode(chronicleTenets, forKey: .chronicleTenets)
        
        try container.encode(hunger, forKey: .hunger)
        try container.encode(health, forKey: .health)
    }
    
    // Coding keys for Codable
    enum CodingKeys: String, CodingKey {
        case id, name, clan, generation
        case physicalAttributes, socialAttributes, mentalAttributes
        case physicalSkills, socialSkills, mentalSkills
        case bloodPotency, humanity, willpower, experience
        case disciplines, advantages, flaws, convictions, touchstones, chronicleTenets
        case hunger, health
    }
    
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
        
        // Initialize core traits
        self.bloodPotency = 1
        self.humanity = 7
        self.willpower = 3
        self.experience = 0
        
        // Initialize disciplines (empty by default)
        self.disciplines = [:]
        
        // Initialize character traits
        self.advantages = []
        self.flaws = []
        self.convictions = []
        self.touchstones = []
        self.chronicleTenets = []
        
        // Initialize condition tracking
        self.hunger = 1
        self.health = 3
    }
    
    // Full initializer for existing characters or manual creation
    init(name: String, clan: String, generation: Int, physicalAttributes: [String: Int], socialAttributes: [String: Int], mentalAttributes: [String: Int], physicalSkills: [String: Int], socialSkills: [String: Int], mentalSkills: [String: Int], bloodPotency: Int, humanity: Int, willpower: Int, experience: Int, disciplines: [String: Int], advantages: [Advantage], flaws: [Flaw], convictions: [String], touchstones: [String], chronicleTenets: [String], hunger: Int, health: Int) {
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
        self.hunger = hunger
        self.health = health
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
}

class CharacterStore: ObservableObject {
    @Published var characters: [Character] {
        didSet {
            save()
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "characters") {
            do {
                let decoded = try JSONDecoder().decode([Character].self, from: data)
                characters = decoded
            } catch {
                print("Failed to decode character data: \(error)")
                print("This may be due to a format change. Initializing with empty character list.")
                characters = []
            }
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
}
