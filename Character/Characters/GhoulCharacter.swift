import SwiftUI


// MARK: - Ghoul
class GhoulCharacter: CharacterBase, CharacterWithDisciplines, CharacterWithHumanity {
    @Published var humanity: Int
    @Published var disciplines: [String: Int]
    @Published var v5Disciplines: [V5Discipline] = []
    @Published var humanityStates: [HumanityState]
    @Published var dateOfGhouling: Date? = nil

    enum CodingKeys: String, CodingKey {
        case humanity, disciplines, v5Disciplines, humanityStates, dateOfGhouling
    }

    override init(characterType: CharacterType = .ghoul) {
        self.disciplines = [:]
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
        self.disciplines = try container.decode([String: Int].self, forKey: .disciplines)
        self.v5Disciplines = try container.decodeIfPresent([V5Discipline].self, forKey: .v5Disciplines) ?? []
        self.humanityStates = try container.decode([HumanityState].self, forKey: .humanityStates)
        self.dateOfGhouling = try container.decodeIfPresent(Date.self, forKey: .dateOfGhouling)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(humanity, forKey: .humanity)
        try container.encode(disciplines, forKey: .disciplines)
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
        
        // Check V5 discipline changes
        let allV5DisciplineNames = Set(self.v5Disciplines.map(\.name)).union(Set(other.v5Disciplines.map(\.name)))
        for disciplineName in allV5DisciplineNames {
            let originalDiscipline = self.v5Disciplines.first { $0.name == disciplineName }
            let updatedDiscipline = other.v5Disciplines.first { $0.name == disciplineName }
            
            // Check level changes
            let originalLevel = originalDiscipline?.currentLevel ?? 0
            let updatedLevel = updatedDiscipline?.currentLevel ?? 0
            if originalLevel != updatedLevel {
                changes.append("\(disciplineName.lowercased()) level \(originalLevel)→\(updatedLevel)")
            }
            
            // Check power selection changes
            if let orig = originalDiscipline, let upd = updatedDiscipline {
                for level in 1...max(orig.currentLevel, upd.currentLevel) {
                    let originalPowers = orig.getSelectedPowers(for: level)
                    let updatedPowers = upd.getSelectedPowers(for: level)
                    
                    if originalPowers != updatedPowers {
                        let addedCount = updatedPowers.subtracting(originalPowers).count
                        let removedCount = originalPowers.subtracting(updatedPowers).count
                        
                        if addedCount > 0 {
                            changes.append("\(disciplineName.lowercased()) level \(level): +\(addedCount) powers")
                        }
                        if removedCount > 0 {
                            changes.append("\(disciplineName.lowercased()) level \(level): -\(removedCount) powers")
                        }
                    }
                }
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
        copy.v5Disciplines = self.v5Disciplines
        copy.dateOfGhouling = self.dateOfGhouling

        return copy
    }
    
    // MARK: - V5 Discipline Helper Methods
    
    // Get all available disciplines (standard + custom)
    func getAllAvailableV5Disciplines() -> [V5Discipline] {
        let standardDisciplines = V5Constants.v5Disciplines
        let customDisciplines = v5Disciplines.filter { $0.isCustom }
        let existingNames = Set(v5Disciplines.map(\.name))
        
        // Return standard disciplines that aren't already added plus all custom ones
        let availableStandard = standardDisciplines.filter { !existingNames.contains($0.name) }
        return availableStandard + customDisciplines
    }
    
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
    
    // Add or update a V5 discipline level
    func setV5DisciplineLevel(_ disciplineName: String, to level: Int) {
        if let index = v5Disciplines.firstIndex(where: { $0.name == disciplineName }) {
            v5Disciplines[index].currentLevel = level
        } else {
            // Create new discipline from template
            if let template = V5Constants.v5Disciplines.first(where: { $0.name == disciplineName }) {
                var newDiscipline = template
                newDiscipline.currentLevel = level
                v5Disciplines.append(newDiscipline)
            }
        }
    }
    
    // Remove a V5 discipline
    func removeV5Discipline(_ disciplineName: String) {
        v5Disciplines.removeAll { $0.name == disciplineName }
    }
    
    // Toggle a power selection for a discipline at a specific level
    func toggleV5Power(_ powerId: UUID, for disciplineName: String, at level: Int) {
        if let index = v5Disciplines.firstIndex(where: { $0.name == disciplineName }) {
            v5Disciplines[index].togglePower(powerId, at: level)
        }
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
    
    // Migrate legacy disciplines to V5 format
    func migrateLegacyDisciplinesToV5() {
        for (disciplineName, level) in disciplines {
            if !v5Disciplines.contains(where: { $0.name == disciplineName }) {
                if let template = V5Constants.v5Disciplines.first(where: { $0.name == disciplineName }) {
                    var newDiscipline = template
                    newDiscipline.currentLevel = level
                    v5Disciplines.append(newDiscipline)
                }
            }
        }
    }
    
    // Add a custom discipline
    func addCustomV5Discipline(_ discipline: V5Discipline) {
        var customDiscipline = discipline
        customDiscipline.isCustom = true
        if !v5Disciplines.contains(where: { $0.name == discipline.name }) {
            v5Disciplines.append(customDiscipline)
        }
    }
}
