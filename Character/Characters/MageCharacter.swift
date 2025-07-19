import SwiftUI


// MARK: - Mage
class MageCharacter: CharacterBase {
    @Published var spheres: [String: Int]
    @Published var paradox: Int
    @Published var hubris: Int
    @Published var quiet: Int
    @Published var arete: Int
    @Published var quintessence: Int
    @Published var hubrisStates: [MageTraitState]
    @Published var quietStates: [MageTraitState]
    @Published var paradigm: String
    @Published var practice: String
    @Published var instruments: [Instrument]
    @Published var dateOfAwakening: Date? = nil
    @Published var essence: MageEssence
    @Published var resonance: MageResonance
    @Published var synergy: MageSynergy

    enum CodingKeys: String, CodingKey {
        case spheres, paradox, hubris, quiet, arete, quintessence, hubrisStates, quietStates, paradigm, practice, instruments, dateOfAwakening, essence, resonance, synergy
    }

    override init(characterType: CharacterType = .mage) {
        self.spheres = Dictionary(uniqueKeysWithValues: V5Constants.mageSpheres.map { ($0, 0) })
        self.paradox = 1
        self.hubris = 0
        self.quiet = 0
        self.arete = 2
        self.quintessence = 0  // Default to 0, can be edited to 0-7
        self.hubrisStates = Array(repeating: .unchecked, count: 5)
        self.quietStates = Array(repeating: .unchecked, count: 5)
        self.paradigm = ""
        self.practice = ""
        self.instruments = []
        self.essence = .none
        self.resonance = .none
        self.synergy = .none
        super.init(characterType: characterType)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spheres = try container.decode([String: Int].self, forKey: .spheres)
        self.paradox = try container.decode(Int.self, forKey: .paradox)
        self.hubris = try container.decode(Int.self, forKey: .hubris)
        self.quiet = try container.decode(Int.self, forKey: .quiet)
        self.arete = try container.decode(Int.self, forKey: .arete)
        self.quintessence = try container.decodeIfPresent(Int.self, forKey: .quintessence) ?? 0  // Default to 0 for existing characters
        self.hubrisStates = try container.decode([MageTraitState].self, forKey: .hubrisStates)
        self.quietStates = try container.decode([MageTraitState].self, forKey: .quietStates)
        self.paradigm = try container.decodeIfPresent(String.self, forKey: .paradigm) ?? ""
        self.practice = try container.decodeIfPresent(String.self, forKey: .practice) ?? ""
        self.instruments = try container.decodeIfPresent([Instrument].self, forKey: .instruments) ?? []
        self.dateOfAwakening = try container.decodeIfPresent(Date.self, forKey: .dateOfAwakening)
        self.essence = try container.decodeIfPresent(MageEssence.self, forKey: .essence) ?? .none
        self.resonance = try container.decodeIfPresent(MageResonance.self, forKey: .resonance) ?? .none
        self.synergy = try container.decodeIfPresent(MageSynergy.self, forKey: .synergy) ?? .none
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
        try container.encode(quintessence, forKey: .quintessence)
        try container.encode(hubrisStates, forKey: .hubrisStates)
        try container.encode(quietStates, forKey: .quietStates)
        try container.encode(paradigm, forKey: .paradigm)
        try container.encode(practice, forKey: .practice)
        try container.encode(instruments, forKey: .instruments)
        try container.encodeIfPresent(dateOfAwakening, forKey: .dateOfAwakening)
        try container.encode(essence, forKey: .essence)
        try container.encode(resonance, forKey: .resonance)
        try container.encode(synergy, forKey: .synergy)
    }
    
    override func generateChangeSummary(for updated: any BaseCharacter) -> String {
        var changes: [String] = []
        
        let other = updated as! MageCharacter
        
        // Process base character changes first
        generateBaseChangeSummary(for: updated, changes: &changes)
        
        // Check mage-specific traits
        if self.paradigm != other.paradigm {
            changes.append("paradigm \(self.paradigm)→\(other.paradigm)")
        }
        if self.practice != other.practice {
            changes.append("practice \(self.practice)→\(other.practice)")
        }
        if self.essence != other.essence {
            changes.append("essence \(self.essence.displayName)→\(other.essence.displayName)")
        }
        if self.resonance != other.resonance {
            changes.append("resonance \(self.resonance.displayName)→\(other.resonance.displayName)")
        }
        if self.synergy != other.synergy {
            changes.append("synergy \(self.synergy.displayName)→\(other.synergy.displayName)")
        }
        if self.arete != other.arete {
            changes.append("arete \(self.arete)→\(other.arete)")
        }
        if self.quintessence != other.quintessence {
            changes.append("quintessence \(self.quintessence)→\(other.quintessence)")
        }
        if self.hubris != other.hubris {
            changes.append("hubris \(self.hubris)→\(other.hubris)")
        }
        if self.quiet != other.quiet {
            changes.append("quiet \(self.quiet)→\(other.quiet)")
        }
        
        // Check mage-specific date changes
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
        
        // Check instruments changes
        processInstrumentChanges(original: self.instruments, updated: other.instruments, changes: &changes)
        
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
        copy.quintessence = self.quintessence
        copy.hubrisStates = self.hubrisStates
        copy.quietStates = self.quietStates
        copy.paradigm = self.paradigm
        copy.practice = self.practice
        copy.instruments = self.instruments
        copy.dateOfAwakening = self.dateOfAwakening
        copy.essence = self.essence
        copy.resonance = self.resonance
        copy.synergy = self.synergy

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
}
