import SwiftUI

// MARK: - Vampire
class VampireCharacter: CharacterBase, CharacterWithDisciplines, CharacterWithHumanity {
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
        self.hunger = 1
        self.disciplines = [:]
        
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
        let copy = VampireCharacter()
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
