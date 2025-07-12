import SwiftUI

// MARK: - Vampire
class VampireCharacter: CharacterBase {
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
        
        let other = updated as! VampireCharacter
                
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

// MARK: - Ghoul
class GhoulCharacter: CharacterBase {
    @Published var humanity: Int
    @Published var disciplines: [String: Int]
    @Published var humanityStates: [HumanityState]

    enum CodingKeys: String, CodingKey {
        case humanity, disciplines, humanityStates
    }

    override init(characterType: CharacterType = .ghoul) {
        self.humanity = 7
        self.disciplines = [:]
        self.humanityStates = Array(repeating: .unchecked, count: 10)
        super.init(characterType: characterType)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.humanity = try container.decode(Int.self, forKey: .humanity)
        self.disciplines = try container.decode([String: Int].self, forKey: .disciplines)
        self.humanityStates = try container.decode([HumanityState].self, forKey: .humanityStates)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(humanity, forKey: .humanity)
        try container.encode(disciplines, forKey: .disciplines)
        try container.encode(humanityStates, forKey: .humanityStates)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! GhoulCharacter
                
        // Check basic information changes
        if self.name != other.name {
            changes.append("name \(self.name)→\(other.name)")
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
        let copy = GhoulCharacter()
        cloneBase(into: copy)

        // Copy Ghoul-specific properties
        copy.humanity = self.humanity
        copy.humanityStates = self.humanityStates
        copy.disciplines = self.disciplines

        return copy
    }
}

// MARK: - Mage
class MageCharacter: CharacterBase {
    @Published var spheres: [String: Int]
    @Published var paradox: Int
    @Published var hubris: Int
    @Published var quiet: Int
    @Published var arete: Int
    @Published var hubrisStates: [MageTraitState]
    @Published var quietStates: [MageTraitState]

    enum CodingKeys: String, CodingKey {
        case spheres, paradox, hubris, quiet, arete, hubrisStates, quietStates
    }

    override init(characterType: CharacterType = .mage) {
        self.spheres = Dictionary(uniqueKeysWithValues: V5Constants.mageSpheres.map { ($0, 0) })
        self.paradox = 1
        self.hubris = 0
        self.quiet = 0
        self.arete = 2
        self.hubrisStates = Array(repeating: .unchecked, count: 6)
        self.quietStates = Array(repeating: .unchecked, count: 6)
        super.init(characterType: characterType)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spheres = try container.decode([String: Int].self, forKey: .spheres)
        self.paradox = try container.decode(Int.self, forKey: .paradox)
        self.hubris = try container.decode(Int.self, forKey: .hubris)
        self.quiet = try container.decode(Int.self, forKey: .quiet)
        self.arete = try container.decode(Int.self, forKey: .arete)
        self.hubrisStates = try container.decode([MageTraitState].self, forKey: .hubrisStates)
        self.quietStates = try container.decode([MageTraitState].self, forKey: .quietStates)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(spheres, forKey: .spheres)
        try container.encode(paradox, forKey: .paradox)
        try container.encode(hubris, forKey: .hubris)
        try container.encode(quiet, forKey: .quiet)
        try container.encode(arete, forKey: .arete)
        try container.encode(hubrisStates, forKey: .hubrisStates)
        try container.encode(quietStates, forKey: .quietStates)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! MageCharacter
                
        // Check basic information changes
        if self.name != other.name {
            changes.append("name \(self.name)→\(other.name)")
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
        if self.arete != other.arete {
            changes.append("arete \(self.arete)→\(other.arete)")
        }
        if self.paradox != other.paradox {
            changes.append("paradox \(self.paradox)→\(other.paradox)")
        }
        if self.hubris != other.hubris {
            changes.append("hubris \(self.hubris)→\(other.hubris)")
        }
        if self.quiet != other.quiet {
            changes.append("quiet \(self.quiet)→\(other.quiet)")
        }
        if self.experience != other.experience {
            changes.append("experience \(self.experience)→\(other.experience)")
        }
        if self.spentExperience != other.spentExperience {
            changes.append("spent experience \(self.spentExperience)→\(other.spentExperience)")
        }
        
        // Check sphere changes
        let allSpheres = Set(self.spheres.keys).union(Set(other.spheres.keys))
        for sphere in allSpheres {
            let originalVal = self.spheres[sphere] ?? 0
            let updatedVal = other.spheres[sphere] ?? 0
            if originalVal != updatedVal {
                changes.append("\(sphere.lowercased()) \(originalVal)→\(updatedVal)")
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
        let copy = MageCharacter()
        cloneBase(into: copy)

        // Copy Mage-specific properties
        copy.spheres = self.spheres
        copy.paradox = self.paradox
        copy.hubris = self.hubris
        copy.quiet = self.quiet
        copy.arete = self.arete
        copy.hubrisStates = self.hubrisStates
        copy.quietStates = self.quietStates

        return copy
    }
}
