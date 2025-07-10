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
            characters = decoded.map { migrateCharacterIfNeeded($0) }
        } else {
            characters = []
        }
    }
    
    // Migration function for backward compatibility
    private func migrateCharacterIfNeeded(_ character: Character) -> Character {
        // Check if this is an old character that needs migration
        // If any of the new properties are missing, create a new character with defaults
        var migratedCharacter = character
        
        // Initialize any missing attributes/skills with defaults if needed
        if character.physicalAttributes.isEmpty {
            migratedCharacter.physicalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.physicalAttributes.map { ($0, 1) })
        }
        if character.socialAttributes.isEmpty {
            migratedCharacter.socialAttributes = Dictionary(uniqueKeysWithValues: V5Constants.socialAttributes.map { ($0, 1) })
        }
        if character.mentalAttributes.isEmpty {
            migratedCharacter.mentalAttributes = Dictionary(uniqueKeysWithValues: V5Constants.mentalAttributes.map { ($0, 1) })
        }
        
        if character.physicalSkills.isEmpty {
            migratedCharacter.physicalSkills = Dictionary(uniqueKeysWithValues: V5Constants.physicalSkills.map { ($0, 0) })
        }
        if character.socialSkills.isEmpty {
            migratedCharacter.socialSkills = Dictionary(uniqueKeysWithValues: V5Constants.socialSkills.map { ($0, 0) })
        }
        if character.mentalSkills.isEmpty {
            migratedCharacter.mentalSkills = Dictionary(uniqueKeysWithValues: V5Constants.mentalSkills.map { ($0, 0) })
        }
        
        return migratedCharacter
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
