import SwiftUI

// MARK: - Vampire
class VampireCharacter: CharacterBase, DisciplineCapable, CharacterWithHumanity {
    @Published var clan: String
    @Published var generation: Int
    @Published var bloodPotency: Int
    @Published var humanity: Int
    @Published var hunger: Int
    @Published var humanityStates: [HumanityState]
    @Published var dateOfEmbrace: Date? = nil
    @Published var v5Disciplines: [V5Discipline] = []
    @Published var predatorType: String = ""
    @Published var customPredatorTypes: [PredatorType] = []

    enum CodingKeys: String, CodingKey {
        case clan, generation, bloodPotency, humanity, hunger, disciplines, v5Disciplines, humanityStates, dateOfEmbrace, predatorType, customPredatorTypes
    }

    override init(characterType: CharacterType = .vampire) {
        self.clan = ""
        self.generation = 13
        self.bloodPotency = 1
        self.hunger = 1
        self.v5Disciplines = []
        
        let defaultHumanity: Int = 7
        self.humanity = defaultHumanity
        
        var humanityArray = Array(repeating: HumanityState.unchecked, count: 10)
        for i in 0...(defaultHumanity - 1) {
            humanityArray[i] = HumanityState.checked
        }
        
        self.humanityStates = humanityArray
        self.predatorType = V5Constants.predatorTypes.first!.name
        
        super.init(characterType: characterType)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clan = try container.decode(String.self, forKey: .clan)
        self.generation = try container.decode(Int.self, forKey: .generation)
        self.bloodPotency = try container.decode(Int.self, forKey: .bloodPotency)
        self.humanity = try container.decode(Int.self, forKey: .humanity)
        self.hunger = try container.decode(Int.self, forKey: .hunger)
        self.v5Disciplines = try container.decodeIfPresent([V5Discipline].self, forKey: .v5Disciplines) ?? []
        self.humanityStates = try container.decode([HumanityState].self, forKey: .humanityStates)
        self.dateOfEmbrace = try container.decodeIfPresent(Date.self, forKey: .dateOfEmbrace)
        self.predatorType = try container.decodeIfPresent(String.self, forKey: .predatorType) ?? ""
        self.customPredatorTypes = try container.decodeIfPresent([PredatorType].self, forKey: .customPredatorTypes) ?? []
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
        try container.encode(v5Disciplines, forKey: .v5Disciplines)
        try container.encode(humanityStates, forKey: .humanityStates)
        try container.encodeIfPresent(dateOfEmbrace, forKey: .dateOfEmbrace)
        try container.encode(predatorType, forKey: .predatorType)
        try container.encode(customPredatorTypes, forKey: .customPredatorTypes)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! VampireCharacter
        
        // Process base character changes first
        generateBaseChangeSummary(for: updated, changes: &changes)
        
        // Check vampire-specific traits
        if self.clan != other.clan {
            changes.append("clan \(self.clan)→\(other.clan)")
        }
        if self.predatorType != other.predatorType {
            changes.append("predator type \(self.predatorType)→\(other.predatorType)")
        }
        if self.generation != other.generation {
            changes.append("generation \(self.generation)→\(other.generation)")
        }
        if self.bloodPotency != other.bloodPotency {
            changes.append("blood potency \(self.bloodPotency)→\(other.bloodPotency)")
        }
        if self.humanity != other.humanity {
            changes.append("humanity \(self.humanity)→\(other.humanity)")
        }
        
        // Check vampire-specific date changes
        if self.dateOfEmbrace != other.dateOfEmbrace {
            let originalDate = self.dateOfEmbrace != nil ? formatDate(self.dateOfEmbrace!) : "not set"
            let newDate = other.dateOfEmbrace != nil ? formatDate(other.dateOfEmbrace!) : "not set"
            changes.append("date of embrace \(originalDate)→\(newDate)")
        }
        
        // Check V5 discipline changes
        processDisciplineChanges(original: self.v5Disciplines, updated: other.v5Disciplines, changes: &changes)
        
        if changes.isEmpty {
            return ""
        } else {
            return changes.joined(separator: "\n")
        }
    }
    
    override func clone() -> any BaseCharacter {
        let copy = VampireCharacter()
        cloneBase(into: copy)

        // Copy Vampire-specific properties
        copy.clan = self.clan
        copy.generation = self.generation
        copy.bloodPotency = self.bloodPotency
        copy.humanity = self.humanity
        copy.humanityStates = self.humanityStates
        copy.hunger = self.hunger
        copy.v5Disciplines = self.v5Disciplines
        copy.dateOfEmbrace = self.dateOfEmbrace
        copy.predatorType = self.predatorType
        copy.customPredatorTypes = self.customPredatorTypes

        return copy
    }
    
    // MARK: - V5 Discipline Helper Methods
    
    // Get a specific discipline by name
    func getV5Discipline(named name: String) -> V5Discipline? {
        // Check character's disciplines first
        if let discipline = v5Disciplines.first(where: { $0.name == name }) {
            return discipline
        }
        // Then check standard disciplines
        return V5Constants.v5Disciplines.first { $0.name == name }
    }
    
    // Get discipline progress (returns nil if not learned)
    func getV5DisciplineProgress(for disciplineName: String) -> V5Discipline? {
        return v5Disciplines.first { $0.name == disciplineName }
    }
    
    // Remove a V5 discipline
    func removeV5Discipline(_ disciplineName: String) {
        v5Disciplines.removeAll { $0.name == disciplineName }
        // Recalculate derived values since discipline deletion may affect health/willpower
        recalculateDerivedValues()
    }
    
    // Get selected powers for a discipline at a specific level
    func getSelectedV5Powers(for disciplineName: String, at level: Int) -> [V5DisciplinePower] {
        guard let discipline = v5Disciplines.first(where: { $0.name == disciplineName }) else {
            return []
        }
        
        let selectedIds = discipline.getSelectedPowers(for: level)
        let availablePowers = discipline.getPowers(for: level)
        
        return availablePowers.filter { selectedIds.contains($0.id) }
    }
    
    // Check if using V5 discipline system (has any V5 disciplines)
    var isUsingV5Disciplines: Bool {
        return !v5Disciplines.isEmpty
    }
    
    // Get clan bane description
    func getClanBane() -> String {
        // This would typically come from a clan database/constants
        // For now, return a placeholder or basic mapping
        switch clan.lowercased() {
        case "brujah":
            return "Lose control when under stress (frenzy on aggravated damage)"
        case "gangrel":
            return "Gain animal features when hungry"
        case "malkavian":
            return "Suffer from mental derangement"
        case "nosferatu":
            return "Hideous appearance (social difficulty)"
        case "toreador":
            return "Become entranced by beauty"
        case "tremere":
            return "Blood bond to clan hierarchy"
        case "ventrue":
            return "Restrictive feeding requirements"
        default:
            return "Clan-specific bane (see rulebook)"
        }
    }
    
    // Get clan compulsion description
    func getClanCompulsion() -> String {
        // This would typically come from a clan database/constants
        switch clan.lowercased() {
        case "brujah":
            return "Rebellion - must challenge authority"
        case "gangrel":
            return "Feral Impulses - act on animal instincts"
        case "malkavian":
            return "Delusion - believe something untrue"
        case "nosferatu":
            return "Cryptophilia - obsess over secrets"
        case "toreador":
            return "Obsession - fixate on beauty"
        case "tremere":
            return "Perfectionism - nothing less than perfect"
        case "ventrue":
            return "Arrogance - dominate and control"
        default:
            return "Clan-specific compulsion (see rulebook)"
        }
    }
    
}
