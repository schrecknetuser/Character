import SwiftUI


// MARK: - Ghoul
class GhoulCharacter: CharacterBase, CharacterWithDisciplines, CharacterWithHumanity {
    @Published var humanity: Int
    @Published var disciplines: [String: Int]
    @Published var humanityStates: [HumanityState]
    @Published var dateOfGhouling: Date? = nil

    enum CodingKeys: String, CodingKey {
        case humanity, disciplines, humanityStates, dateOfGhouling
    }

    override init(characterType: CharacterType = .ghoul) {
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
        self.humanity = try container.decode(Int.self, forKey: .humanity)
        self.disciplines = try container.decode([String: Int].self, forKey: .disciplines)
        self.humanityStates = try container.decode([HumanityState].self, forKey: .humanityStates)
        self.dateOfGhouling = try container.decodeIfPresent(Date.self, forKey: .dateOfGhouling)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(humanity, forKey: .humanity)
        try container.encode(disciplines, forKey: .disciplines)
        try container.encode(humanityStates, forKey: .humanityStates)
        try container.encodeIfPresent(dateOfGhouling, forKey: .dateOfGhouling)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! GhoulCharacter
                
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
        copy.dateOfGhouling = self.dateOfGhouling

        return copy
    }
}
