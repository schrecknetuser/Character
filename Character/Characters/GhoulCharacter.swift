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
        
        // Process base character changes first
        generateBaseChangeSummary(for: updated, changes: &changes)
        
        // Check ghoul-specific traits
        if self.humanity != other.humanity {
            changes.append("humanity \(self.humanity)→\(other.humanity)")
        }
        
        // Check ghoul-specific date changes
        if self.dateOfGhouling != other.dateOfGhouling {
            let originalDate = self.dateOfGhouling != nil ? formatDate(self.dateOfGhouling!) : "not set"
            let newDate = other.dateOfGhouling != nil ? formatDate(other.dateOfGhouling!) : "not set"
            changes.append("date of ghouling \(originalDate)→\(newDate)")
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
        
}
