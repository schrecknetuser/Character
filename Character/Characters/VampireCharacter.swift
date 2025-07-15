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

    enum CodingKeys: String, CodingKey {
        case clan, generation, bloodPotency, humanity, hunger, disciplines, v5Disciplines, humanityStates, dateOfEmbrace
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
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! VampireCharacter
                
        // Check basic information changes
        if self.name != other.name {
            changes.append("name \(self.name)→\(other.name)")
        }
        if self.concept != other.concept {
            changes.append("concept \(self.concept)→\(other.concept)")
        }
        if self.chronicleName != other.chronicleName {
            changes.append("chronicle name \(self.chronicleName)→\(other.chronicleName)")
        }
        if self.ambition != other.ambition {
            changes.append("ambition \(self.ambition)→\(other.ambition)")
        }
        if self.desire != other.desire {
            changes.append("desire \(self.desire)→\(other.desire)")
        }
        if self.clan != other.clan {
            changes.append("clan \(self.clan)→\(other.clan)")
        }
        if self.generation != other.generation {
            changes.append("generation \(self.generation)→\(other.generation)")
        }
        
        // Check convictions and touchstones changes
        processStringArrayChanges(original: self.convictions, updated: other.convictions, name: "convictions", changes: &changes)
        processStringArrayChanges(original: self.touchstones, updated: other.touchstones, name: "touchstones", changes: &changes)
        
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
        
        // Check V5 discipline changes
        processDisciplineChanges(original: self.v5Disciplines, updated: other.v5Disciplines, changes: &changes)
        
        //Check specialisations
        processSpecializationChanges(original: self.specializations, updated: other.specializations, changes: &changes)
        
        // Check advantages/flaws changes
        processBackgroundChanges(original: self.advantages, updated: other.advantages, name: "advantage", changes: &changes)
        processBackgroundChanges(original: self.flaws, updated: other.flaws, name: "flaw", changes: &changes)
        processCharacterBackgroundChanges(original: self.backgroundMerits, updated: other.backgroundMerits, name: "background merit", changes: &changes)
        processCharacterBackgroundChanges(original: self.backgroundFlaws, updated: other.backgroundFlaws, name: "background flaw", changes: &changes)
        
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

}
