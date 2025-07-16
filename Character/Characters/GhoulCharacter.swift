import SwiftUI


// MARK: - Ghoul
class GhoulCharacter:CharacterBase, DisciplineCapable, CharacterWithHumanity {
    @Published var humanity: Int    
    @Published var humanityStates: [HumanityState]
    @Published var dateOfGhouling: Date? = nil
    @Published var v5Disciplines: [V5Discipline] = []

    enum CodingKeys: String, CodingKey {
        case humanity, disciplines, v5Disciplines, humanityStates, dateOfGhouling
    }

    override init(characterType: CharacterType = .ghoul) {
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
        self.humanity = try container.decode(Int.self, forKey: .humanity)
        self.v5Disciplines = try container.decodeIfPresent([V5Discipline].self, forKey: .v5Disciplines) ?? []
        self.humanityStates = try container.decode([HumanityState].self, forKey: .humanityStates)
        self.dateOfGhouling = try container.decodeIfPresent(Date.self, forKey: .dateOfGhouling)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(humanity, forKey: .humanity)
        try container.encode(v5Disciplines, forKey: .v5Disciplines)
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
        if self.characterDescription != other.characterDescription {
            changes.append("character description updated")
        }
        if self.notes != other.notes {
            changes.append("notes updated")
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
        
        // Check date changes
        if self.dateOfBirth != other.dateOfBirth {
            let originalDate = self.dateOfBirth != nil ? formatDate(self.dateOfBirth!) : "not set"
            let newDate = other.dateOfBirth != nil ? formatDate(other.dateOfBirth!) : "not set"
            changes.append("date of birth \(originalDate)→\(newDate)")
        }
        if self.dateOfGhouling != other.dateOfGhouling {
            let originalDate = self.dateOfGhouling != nil ? formatDate(self.dateOfGhouling!) : "not set"
            let newDate = other.dateOfGhouling != nil ? formatDate(other.dateOfGhouling!) : "not set"
            changes.append("date of ghouling \(originalDate)→\(newDate)")
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
        let copy = GhoulCharacter()
        cloneBase(into: copy)

        // Copy Ghoul-specific properties
        copy.humanity = self.humanity
        copy.humanityStates = self.humanityStates
        copy.v5Disciplines = self.v5Disciplines
        copy.dateOfGhouling = self.dateOfGhouling

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
    
    // Helper function to format dates consistently
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
        
}
