// V5 Character System Constants
struct V5Constants {
    // Physical Attributes
    static let physicalAttributes = ["Strength", "Dexterity", "Stamina"]
    
    // Social Attributes
    static let socialAttributes = ["Charisma", "Manipulation", "Composure"]
    
    // Mental Attributes
    static let mentalAttributes = ["Intelligence", "Wits", "Resolve"]
    
    // Physical Skills (for backward compatibility)
    static let physicalSkills = ["Athletics", "Brawl", "Craft", "Drive", "Firearms", "Larceny", "Melee", "Stealth", "Survival"]
    
    // Social Skills (for backward compatibility)
    static let socialSkills = ["Animal Ken", "Etiquette", "Insight", "Intimidation", "Leadership", "Performance", "Persuasion", "Streetwise", "Subterfuge"]
    
    // Mental Skills (for backward compatibility)
    static let mentalSkills = ["Academics", "Awareness", "Finance", "Investigation", "Medicine", "Occult", "Politics", "Science", "Technology"]
    
    // Detailed skill information with specialization examples
    static let physicalSkillsInfo = [
        SkillInfo(name: "Athletics", specializationExamples: ["Climbing", "Running", "Swimming", "Parkour", "Acrobatics"]),
        SkillInfo(name: "Brawl", specializationExamples: ["Boxing", "Wrestling", "Martial Arts", "Grappling", "Dirty Fighting"]),
        SkillInfo(name: "Craft", specializationExamples: ["Woodworking", "Metalworking", "Painting", "Sculpture", "Electronics"], requiresFreeSpecialization: true),
        SkillInfo(name: "Drive", specializationExamples: ["Cars", "Motorcycles", "Trucks", "Racing", "Off-road"]),
        SkillInfo(name: "Firearms", specializationExamples: ["Pistols", "Rifles", "Shotguns", "Archery", "Thrown Weapons"]),
        SkillInfo(name: "Larceny", specializationExamples: ["Lockpicking", "Pickpocketing", "Security Systems", "Safecracking", "Sleight of Hand"]),
        SkillInfo(name: "Melee", specializationExamples: ["Swords", "Knives", "Clubs", "Improvised Weapons", "Fencing"]),
        SkillInfo(name: "Stealth", specializationExamples: ["Hiding", "Moving Silently", "Camouflage", "Crowds", "Shadows"]),
        SkillInfo(name: "Survival", specializationExamples: ["Tracking", "Foraging", "Navigation", "Weather Prediction", "Urban Survival"])
    ]
    
    static let socialSkillsInfo = [
        SkillInfo(name: "Animal Ken", specializationExamples: ["Dogs", "Cats", "Horses", "Wild Animals", "Rats"]),
        SkillInfo(name: "Etiquette", specializationExamples: ["High Society", "Corporate", "Street", "Academic", "Criminal"]),
        SkillInfo(name: "Insight", specializationExamples: ["Emotions", "Lies", "Fear", "Desires", "Motivations"]),
        SkillInfo(name: "Intimidation", specializationExamples: ["Physical Threats", "Stare Down", "Verbal Abuse", "Torture", "Social Pressure"]),
        SkillInfo(name: "Leadership", specializationExamples: ["Military", "Corporate", "Gang", "Cult", "Noble"]),
        SkillInfo(name: "Performance", specializationExamples: ["Acting", "Singing", "Dancing", "Comedy", "Oratory"], requiresFreeSpecialization: true),
        SkillInfo(name: "Persuasion", specializationExamples: ["Fast Talk", "Seduction", "Sales", "Oratory", "Lies"]),
        SkillInfo(name: "Streetwise", specializationExamples: ["Rumors", "Black Market", "Drugs", "Gangs", "Fence"]),
        SkillInfo(name: "Subterfuge", specializationExamples: ["Lying", "Misdirection", "Innocent Face", "Changing Subject", "Long Con"])
    ]
    
    static let mentalSkillsInfo = [
        SkillInfo(name: "Academics", specializationExamples: ["History", "Literature", "Anthropology", "Art", "Law"], requiresFreeSpecialization: true),
        SkillInfo(name: "Awareness", specializationExamples: ["Ambushes", "Crowds", "Supernatural", "Details", "Eavesdropping"]),
        SkillInfo(name: "Finance", specializationExamples: ["Accounting", "Investment", "Banking", "Appraisal", "Forgery"]),
        SkillInfo(name: "Investigation", specializationExamples: ["Crime Scenes", "Research", "Surveillance", "Forensics", "Internet"]),
        SkillInfo(name: "Medicine", specializationExamples: ["First Aid", "Surgery", "Pathology", "Pharmacy", "Veterinary"]),
        SkillInfo(name: "Occult", specializationExamples: ["Kindred Lore", "Rituals", "Ghosts", "Witchcraft", "Mythology"]),
        SkillInfo(name: "Politics", specializationExamples: ["City", "Kindred", "Corporate", "Church", "Anarchs"]),
        SkillInfo(name: "Science", specializationExamples: ["Biology", "Chemistry", "Physics", "Psychology", "Computer Science"], requiresFreeSpecialization: true),
        SkillInfo(name: "Technology", specializationExamples: ["Computers", "Electronics", "Programming", "Hacking", "Data Recovery"])
    ]
    
    // Helper methods to access skill information
    static func getSkillInfo(for skillName: String) -> SkillInfo? {
        let allSkills = physicalSkillsInfo + socialSkillsInfo + mentalSkillsInfo
        return allSkills.first { $0.name == skillName }
    }
    
    static func getAllSkillsInfo() -> [SkillInfo] {
        return physicalSkillsInfo + socialSkillsInfo + mentalSkillsInfo
    }
    
    static func getSkillsRequiringFreeSpecialization() -> [String] {
        return getAllSkillsInfo().filter { $0.requiresFreeSpecialization }.map { $0.name }
    }
    
    // Major V5 Disciplines
    static let disciplines = ["Animalism", "Auspex", "Blood Sorcery", "Celerity", "Dominate", "Fortitude", "Obfuscate", "Potence", "Presence", "Protean", "Hecata Sorcery", "Lasombra Oblivion", "Oblivion", "Obeah", "Quietus", "Serpentis", "Vicissitude"]
    
    // V5 Clans
    static let clans = ["Brujah", "Gangrel", "Malkavian", "Nosferatu", "Toreador", "Tremere", "Ventrue", "Banu Haqim", "Hecata", "Lasombra", "Ministry", "Ravnos", "Salubri", "Tzimisce", "Caitiff", "Thin-Blood"]
    
    // Predefined V5 Advantages with costs
    static let predefinedAdvantages = [
        // Universal backgrounds suitable for all character types
        Background(name: "Allies", cost: 3, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Contacts", cost: 1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Fame", cost: 1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Influence", cost: 2, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Resources", cost: 3, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Retainers", cost: 2, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Status", cost: 2, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Iron Will", cost: 5, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Time Sense", cost: 1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Eidetic Memory", cost: 2, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Linguistics", cost: 1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // Vampire-specific backgrounds
        Background(name: "Herd", cost: 3, suitableCharacterTypes: [.vampire]),
        Background(name: "Haven", cost: 2, suitableCharacterTypes: [.vampire]),
        Background(name: "Feeding Grounds", cost: 1, suitableCharacterTypes: [.vampire]),
        Background(name: "Domain", cost: 2, suitableCharacterTypes: [.vampire]),
        Background(name: "Thin-Blooded Alchemy", cost: 5, suitableCharacterTypes: [.vampire])
    ]
    
    // Predefined V5 Flaws with costs (negative values as they give points back)
    static let predefinedFlaws = [
        // Universal flaws suitable for all character types
        Background(name: "Enemy", cost: -1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Dark Secret", cost: -1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Hunted", cost: -3, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Anachronism", cost: -1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Archaic", cost: -1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Disgraced", cost: -2, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Shunned", cost: -1, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        Background(name: "Suspect", cost: -2, suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // Vampire-specific flaws
        Background(name: "Folkloric Block", cost: -2, suitableCharacterTypes: [.vampire]),
        Background(name: "Clan Curse", cost: -2, suitableCharacterTypes: [.vampire]),
        Background(name: "Feeding Restriction", cost: -1, suitableCharacterTypes: [.vampire]),
        Background(name: "Obvious Predator", cost: -2, suitableCharacterTypes: [.vampire]),
        Background(name: "Prey Exclusion", cost: -1, suitableCharacterTypes: [.vampire]),
        Background(name: "Stigmata", cost: -2, suitableCharacterTypes: [.vampire]),
        Background(name: "Thin-Blooded", cost: -4, suitableCharacterTypes: [.vampire]),
        Background(name: "Caitiff", cost: -2, suitableCharacterTypes: [.vampire])
    ]
    
    // Helper methods to filter backgrounds by character type
    static func getAdvantagesForCharacterType(_ characterType: CharacterType) -> [Background] {
        return predefinedAdvantages.filter { $0.suitableCharacterTypes.contains(characterType) }
    }
    
    static func getFlawsForCharacterType(_ characterType: CharacterType) -> [Background] {
        return predefinedFlaws.filter { $0.suitableCharacterTypes.contains(characterType) }
    }
}
