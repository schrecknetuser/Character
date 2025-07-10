import SwiftUI

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
    var advantages: [String]
    var flaws: [String]
    var convictions: [String]
    var touchstones: [String]
    var chronicleTenets: [String]
    
    // V5 Condition Tracking
    var hunger: Int
    var health: Int
    
    // Computed property for backward compatibility
    var attributes: [String: Int] {
        var allAttributes: [String: Int] = [:]
        allAttributes.merge(physicalAttributes) { _, new in new }
        allAttributes.merge(socialAttributes) { _, new in new }
        allAttributes.merge(mentalAttributes) { _, new in new }
        return allAttributes
    }
    
    // Custom coding keys for backward compatibility
    enum CodingKeys: String, CodingKey {
        case id, name, clan, generation
        case physicalAttributes, socialAttributes, mentalAttributes
        case physicalSkills, socialSkills, mentalSkills
        case bloodPotency, humanity, willpower, experience
        case disciplines, advantages, flaws, convictions, touchstones, chronicleTenets
        case hunger, health
        // Old field for backward compatibility
        case legacyAttributes = "attributes"
    }
    
    // Custom decoder for backward compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        clan = try container.decode(String.self, forKey: .clan)
        generation = try container.decode(Int.self, forKey: .generation)
        
        // Try to decode new structure first, fall back to legacy if needed
        if let physical = try? container.decode([String: Int].self, forKey: .physicalAttributes) {
            physicalAttributes = physical
        } else {
            physicalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.physicalAttributes.map { ($0, 1) })
        }
        
        if let social = try? container.decode([String: Int].self, forKey: .socialAttributes) {
            socialAttributes = social
        } else {
            socialAttributes = Dictionary(uniqueKeysWithValues: V5Constants.socialAttributes.map { ($0, 1) })
        }
        
        if let mental = try? container.decode([String: Int].self, forKey: .mentalAttributes) {
            mentalAttributes = mental
        } else {
            mentalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.mentalAttributes.map { ($0, 1) })
        }
        
        // Handle legacy attributes field if present
        if let legacyAttrs = try? container.decode([String: Int].self, forKey: .legacyAttributes) {
            // Merge legacy attributes into new structure
            for (key, value) in legacyAttrs {
                if V5Constants.physicalAttributes.contains(key) {
                    physicalAttributes[key] = value
                } else if V5Constants.socialAttributes.contains(key) {
                    socialAttributes[key] = value
                } else if V5Constants.mentalAttributes.contains(key) {
                    mentalAttributes[key] = value
                }
            }
        }
        
        physicalSkills = (try? container.decode([String: Int].self, forKey: .physicalSkills)) ?? Dictionary(uniqueKeysWithValues: V5Constants.physicalSkills.map { ($0, 0) })
        socialSkills = (try? container.decode([String: Int].self, forKey: .socialSkills)) ?? Dictionary(uniqueKeysWithValues: V5Constants.socialSkills.map { ($0, 0) })
        mentalSkills = (try? container.decode([String: Int].self, forKey: .mentalSkills)) ?? Dictionary(uniqueKeysWithValues: V5Constants.mentalSkills.map { ($0, 0) })
        
        bloodPotency = (try? container.decode(Int.self, forKey: .bloodPotency)) ?? 1
        humanity = (try? container.decode(Int.self, forKey: .humanity)) ?? 7
        willpower = (try? container.decode(Int.self, forKey: .willpower)) ?? 3
        experience = (try? container.decode(Int.self, forKey: .experience)) ?? 0
        
        disciplines = try container.decode([String: Int].self, forKey: .disciplines)
        advantages = try container.decode([String].self, forKey: .advantages)
        flaws = try container.decode([String].self, forKey: .flaws)
        
        convictions = (try? container.decode([String].self, forKey: .convictions)) ?? []
        touchstones = (try? container.decode([String].self, forKey: .touchstones)) ?? []
        chronicleTenets = (try? container.decode([String].self, forKey: .chronicleTenets)) ?? []
        
        hunger = try container.decode(Int.self, forKey: .hunger)
        health = try container.decode(Int.self, forKey: .health)
    }
    
    // Custom encoder (just encode new structure)
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
    init(name: String, clan: String, generation: Int, physicalAttributes: [String: Int], socialAttributes: [String: Int], mentalAttributes: [String: Int], physicalSkills: [String: Int], socialSkills: [String: Int], mentalSkills: [String: Int], bloodPotency: Int, humanity: Int, willpower: Int, experience: Int, disciplines: [String: Int], advantages: [String], flaws: [String], convictions: [String], touchstones: [String], chronicleTenets: [String], hunger: Int, health: Int) {
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
}
