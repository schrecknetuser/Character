import SwiftUI


// MARK: - Mage
class MageCharacter: CharacterBase {
    @Published var spheres: [String: Int]
    @Published var paradox: Int
    @Published var hubris: Int
    @Published var quiet: Int
    @Published var arete: Int
    @Published var hubrisStates: [MageTraitState]
    @Published var quietStates: [MageTraitState]
    @Published var paradigm: String
    @Published var practice: String
    @Published var instruments: [Instrument]
    @Published var dateOfAwakening: Date? = nil

    enum CodingKeys: String, CodingKey {
        case spheres, paradox, hubris, quiet, arete, hubrisStates, quietStates, paradigm, practice, instruments, dateOfAwakening
    }

    override init(characterType: CharacterType = .mage) {
        self.spheres = Dictionary(uniqueKeysWithValues: V5Constants.mageSpheres.map { ($0, 0) })
        self.paradox = 1
        self.hubris = 0
        self.quiet = 0
        self.arete = 2
        self.hubrisStates = Array(repeating: .unchecked, count: 5)
        self.quietStates = Array(repeating: .unchecked, count: 5)
        self.paradigm = ""
        self.practice = ""
        self.instruments = []
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
        self.paradigm = try container.decodeIfPresent(String.self, forKey: .paradigm) ?? ""
        self.practice = try container.decodeIfPresent(String.self, forKey: .practice) ?? ""
        self.instruments = try container.decodeIfPresent([Instrument].self, forKey: .instruments) ?? []
        self.dateOfAwakening = try container.decodeIfPresent(Date.self, forKey: .dateOfAwakening)
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
        try container.encode(paradigm, forKey: .paradigm)
        try container.encode(practice, forKey: .practice)
        try container.encode(instruments, forKey: .instruments)
        try container.encodeIfPresent(dateOfAwakening, forKey: .dateOfAwakening)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! MageCharacter
                
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
        if self.paradigm != other.paradigm {
            changes.append("paradigm \(self.paradigm)→\(other.paradigm)")
        }
        if self.practice != other.practice {
            changes.append("practice \(self.practice)→\(other.practice)")
        }
        
        // Check convictions and touchstones changes
        processStringArrayChanges(original: self.convictions, updated: other.convictions, name: "convictions", changes: &changes)
        processStringArrayChanges(original: self.touchstones, updated: other.touchstones, name: "touchstones", changes: &changes)
        
        // Check instruments changes
        processInstrumentChanges(original: self.instruments, updated: other.instruments, changes: &changes)
        
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
        
        // Check date changes
        if self.dateOfBirth != other.dateOfBirth {
            let originalDate = self.dateOfBirth != nil ? formatDate(self.dateOfBirth!) : "not set"
            let newDate = other.dateOfBirth != nil ? formatDate(other.dateOfBirth!) : "not set"
            changes.append("date of birth \(originalDate)→\(newDate)")
        }
        if self.dateOfAwakening != other.dateOfAwakening {
            let originalDate = self.dateOfAwakening != nil ? formatDate(self.dateOfAwakening!) : "not set"
            let newDate = other.dateOfAwakening != nil ? formatDate(other.dateOfAwakening!) : "not set"
            changes.append("date of awakening \(originalDate)→\(newDate)")
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
        processCharacterBackgroundChanges(original: self.backgroundMerits, updated: other.backgroundMerits, name: "background merit", changes: &changes)
        processCharacterBackgroundChanges(original: self.backgroundFlaws, updated: other.backgroundFlaws, name: "background flaw", changes: &changes)
        
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
        copy.paradigm = self.paradigm
        copy.practice = self.practice
        copy.instruments = self.instruments
        copy.dateOfAwakening = self.dateOfAwakening

        return copy
    }
    
    private func processInstrumentChanges(original: [Instrument], updated: [Instrument], changes: inout [String]) {
        let originalSet = Set(original)
        let updatedSet = Set(updated)

        let removed = originalSet.subtracting(updatedSet)
        let added = updatedSet.subtracting(originalSet)

        if !removed.isEmpty || !added.isEmpty {
            if !removed.isEmpty {
                let removedNames = removed.map { $0.description }.joined(separator: ", ")
                changes.append("instruments removed: \(removedNames)")
            }
            if !added.isEmpty {
                let addedNames = added.map { $0.description }.joined(separator: ", ")
                changes.append("instruments added: \(addedNames)")
            }
        }
    }
    
    // Helper function to format dates consistently
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
