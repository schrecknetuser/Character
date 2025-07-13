import SwiftUI

// MARK: - Vampire
class VampireCharacter: CharacterBase, CharacterWithDisciplines, CharacterWithHumanity {
    @Published var clan: String
    @Published var generation: Int
    @Published var bloodPotency: Int
    @Published var humanity: Int
    @Published var hunger: Int
    @Published var disciplines: [String: Int]
    @Published var v5Disciplines: [String: V5DisciplineProgress] = [:]
    @Published var customV5Disciplines: [V5Discipline] = []
    @Published var humanityStates: [HumanityState]
    @Published var dateOfEmbrace: Date? = nil

    enum CodingKeys: String, CodingKey {
        case clan, generation, bloodPotency, humanity, hunger, disciplines, v5Disciplines, customV5Disciplines, humanityStates, dateOfEmbrace
    }

    override init(characterType: CharacterType = .vampire) {
        self.clan = ""
        self.generation = 13
        self.bloodPotency = 1
        self.hunger = 1
        self.disciplines = [:]
        self.v5Disciplines = [:]
        self.customV5Disciplines = []
        
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
        self.v5Disciplines = try container.decodeIfPresent([String: V5DisciplineProgress].self, forKey: .v5Disciplines) ?? [:]
        self.customV5Disciplines = try container.decodeIfPresent([V5Discipline].self, forKey: .customV5Disciplines) ?? []
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
        try container.encode(disciplines, forKey: .disciplines)
        try container.encode(v5Disciplines, forKey: .v5Disciplines)
        try container.encode(customV5Disciplines, forKey: .customV5Disciplines)
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
        let allV5Disciplines = Set(self.v5Disciplines.keys).union(Set(other.v5Disciplines.keys))
        for disciplineName in allV5Disciplines {
            let originalProgress = self.v5Disciplines[disciplineName]
            let updatedProgress = other.v5Disciplines[disciplineName]
            
            // Check level changes
            let originalLevel = originalProgress?.currentLevel ?? 0
            let updatedLevel = updatedProgress?.currentLevel ?? 0
            if originalLevel != updatedLevel {
                changes.append("\(disciplineName.lowercased()) level \(originalLevel)→\(updatedLevel)")
            }
            
            // Check power selection changes
            if let orig = originalProgress, let upd = updatedProgress {
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
        copy.v5Disciplines = self.v5Disciplines
        copy.customV5Disciplines = self.customV5Disciplines
        copy.dateOfEmbrace = self.dateOfEmbrace

        return copy
    }
    
    // MARK: - V5 Discipline Helper Methods
    
    // Get all available disciplines (standard + custom)
    func getAllAvailableV5Disciplines() -> [V5Discipline] {
        return V5Constants.v5Disciplines + customV5Disciplines
    }
    
    // Get a specific discipline (standard or custom)
    func getV5Discipline(named name: String) -> V5Discipline? {
        return getAllAvailableV5Disciplines().first { $0.name == name }
    }
    
    // Get current progress for a discipline
    func getV5DisciplineProgress(for disciplineName: String) -> V5DisciplineProgress? {
        return v5Disciplines[disciplineName]
    }
    
    // Add or update a V5 discipline
    mutating func setV5DisciplineLevel(_ disciplineName: String, to level: Int) {
        if var progress = v5Disciplines[disciplineName] {
            progress.currentLevel = level
            v5Disciplines[disciplineName] = progress
        } else {
            v5Disciplines[disciplineName] = V5DisciplineProgress(disciplineName: disciplineName, currentLevel: level)
        }
    }
    
    // Remove a V5 discipline
    mutating func removeV5Discipline(_ disciplineName: String) {
        v5Disciplines.removeValue(forKey: disciplineName)
    }
    
    // Toggle a power selection for a discipline at a specific level
    mutating func toggleV5Power(_ powerId: UUID, for disciplineName: String, at level: Int) {
        if var progress = v5Disciplines[disciplineName] {
            progress.togglePower(powerId, at: level)
            v5Disciplines[disciplineName] = progress
        }
    }
    
    // Get selected powers for a discipline at a specific level
    func getSelectedV5Powers(for disciplineName: String, at level: Int) -> [V5DisciplinePower] {
        guard let progress = v5Disciplines[disciplineName],
              let discipline = getV5Discipline(named: disciplineName) else {
            return []
        }
        
        let selectedIds = progress.getSelectedPowers(for: level)
        let availablePowers = discipline.getPowers(for: level)
        
        return availablePowers.filter { selectedIds.contains($0.id) }
    }
    
    // Check if using V5 discipline system (has any V5 disciplines)
    var isUsingV5Disciplines: Bool {
        return !v5Disciplines.isEmpty
    }
    
    // Migrate legacy disciplines to V5 format
    mutating func migrateLegacyDisciplinesToV5() {
        for (disciplineName, level) in disciplines {
            if v5Disciplines[disciplineName] == nil {
                v5Disciplines[disciplineName] = V5DisciplineProgress(disciplineName: disciplineName, currentLevel: level)
            }
        }
    }
    
    // Add a custom discipline
    mutating func addCustomV5Discipline(_ discipline: V5Discipline) {
        if !customV5Disciplines.contains(where: { $0.name == discipline.name }) {
            customV5Disciplines.append(discipline)
        }
    }
}
