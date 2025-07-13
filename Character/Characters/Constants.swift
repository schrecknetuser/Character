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
    
    // Major V5 Disciplines (legacy - for backward compatibility)
    static let disciplines = ["Animalism", "Auspex", "Blood Sorcery", "Celerity", "Dominate", "Fortitude", "Obfuscate", "Potence", "Presence", "Protean", "Hecata Sorcery", "Lasombra Oblivion", "Oblivion", "Obeah", "Quietus", "Serpentis", "Vicissitude"]
    
    // MARK: - V5 Discipline System
    
    // Predefined V5 Disciplines with powers per level
    static let v5Disciplines: [V5Discipline] = [
        // Animalism
        V5Discipline(
            name: "Animalism",
            powers: [
                1: [
                    V5DisciplinePower(name: "Feral Whispers", description: "Communicate with animals through growls, barks, and other animal sounds", level: 1),
                    V5DisciplinePower(name: "Bond Famulus", description: "Create a blood bond with an animal, making it a loyal servant", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Animal Succulence", description: "Gain more sustenance from feeding on animal blood", level: 2),
                    V5DisciplinePower(name: "Sense the Beast", description: "Feel the emotional state and basic nature of animals and humans", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Animal Messenger", description: "Send simple messages through animals", level: 3),
                    V5DisciplinePower(name: "Subsume the Spirit", description: "Possess an animal, controlling its body while your own lies dormant", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Animalistic Reprisal", description: "Transform into a hybrid beast form with enhanced combat abilities", level: 4),
                    V5DisciplinePower(name: "Raise the Familiar", description: "Grant supernatural intelligence and abilities to a bound animal", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Drawing Out the Beast", description: "Transfer your Beast to another, making them frenzied while you become calm", level: 5),
                    V5DisciplinePower(name: "Conquer the Beast", description: "Dominate and control the beasts within others, preventing frenzy or forcing it", level: 5)
                ]
            ]
        ),
        
        // Auspex
        V5Discipline(
            name: "Auspex",
            powers: [
                1: [
                    V5DisciplinePower(name: "Heightened Senses", description: "Dramatically enhance all five senses", level: 1),
                    V5DisciplinePower(name: "Sense the Unseen", description: "Perceive supernatural beings and energies that are hidden", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Premonition", description: "Gain flashes of insight about immediate future dangers", level: 2),
                    V5DisciplinePower(name: "Scry the Soul", description: "Learn about a person's nature, emotions, and supernatural traits by studying them", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Share the Senses", description: "Experience what one of your familiars or ghouled animals senses", level: 3),
                    V5DisciplinePower(name: "Spirit's Touch", description: "Learn the history of an object by touching it", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Telepathy", description: "Read surface thoughts and communicate mentally with others", level: 4),
                    V5DisciplinePower(name: "Clairvoyance", description: "Project your senses to distant locations you've visited before", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Possession", description: "Enter and control another person's body while your own lies dormant", level: 5),
                    V5DisciplinePower(name: "Insight", description: "Understand complex situations and predict behavioral patterns", level: 5)
                ]
            ]
        ),
        
        // Celerity
        V5Discipline(
            name: "Celerity",
            powers: [
                1: [
                    V5DisciplinePower(name: "Cat's Grace", description: "Gain supernatural balance and coordination", level: 1),
                    V5DisciplinePower(name: "Rapid Reflexes", description: "React with supernatural speed to danger", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Fleetness", description: "Move at supernatural speeds for extended periods", level: 2),
                    V5DisciplinePower(name: "Blur of Motion", description: "Move so fast you become difficult to see and target", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Traversal", description: "Move through small spaces and across difficult terrain with ease", level: 3),
                    V5DisciplinePower(name: "Draught of Elegance", description: "Share your supernatural grace with others through blood", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Blink", description: "Move instantly from one position to another nearby location", level: 4),
                    V5DisciplinePower(name: "Grace", description: "Perform impossible feats of agility and movement", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Split Second", description: "Act multiple times in the span of a single moment", level: 5),
                    V5DisciplinePower(name: "Lightning Strike", description: "Attack with such speed that defense is nearly impossible", level: 5)
                ]
            ]
        ),
        
        // Dominate
        V5Discipline(
            name: "Dominate",
            powers: [
                1: [
                    V5DisciplinePower(name: "Compel", description: "Force a simple, single-word command upon a mortal", level: 1),
                    V5DisciplinePower(name: "Cloud Memory", description: "Alter or erase specific memories from a mortal's mind", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Mesmerize", description: "Implant a complex command that activates under specific conditions", level: 2),
                    V5DisciplinePower(name: "Dementation", description: "Inflict temporary madness or confusion upon a victim", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "The Forgetful Mind", description: "Extensively rewrite memories and personality traits", level: 3),
                    V5DisciplinePower(name: "Submerged Directive", description: "Implant deep, long-term commands that can remain dormant for years", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Rationalize", description: "Make victims accept and rationalize impossible or contradictory ideas", level: 4),
                    V5DisciplinePower(name: "Mass Manipulation", description: "Dominate multiple individuals simultaneously", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Terminal Decree", description: "Issue commands that can cause a victim to harm or kill themselves", level: 5),
                    V5DisciplinePower(name: "Vessel", description: "Turn a mortal into a perfect, unthinking servant", level: 5)
                ]
            ]
        ),
        
        // Fortitude
        V5Discipline(
            name: "Fortitude",
            powers: [
                1: [
                    V5DisciplinePower(name: "Resilience", description: "Reduce damage from physical attacks", level: 1),
                    V5DisciplinePower(name: "Unswayable Mind", description: "Resist mental intrusion and emotional manipulation", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Toughness", description: "Ignore wound penalties and continue fighting despite injury", level: 2),
                    V5DisciplinePower(name: "Enduring Beasts", description: "Resist the effects of frenzy and maintain control", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Defy Bane", description: "Reduce damage from your clan's specific weaknesses", level: 3),
                    V5DisciplinePower(name: "Fortify the Inner Self", description: "Become immune to supernatural fear and emotional control", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Draught of Endurance", description: "Share your supernatural toughness with others through blood", level: 4),
                    V5DisciplinePower(name: "Flesh of Marble", description: "Transform your skin into stone-like hardness", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Prowess from Pain", description: "Gain strength and speed from taking damage", level: 5),
                    V5DisciplinePower(name: "Defy Death", description: "Survive otherwise fatal injuries and continue functioning", level: 5)
                ]
            ]
        ),
        
        // Presence
        V5Discipline(
            name: "Presence",
            powers: [
                1: [
                    V5DisciplinePower(name: "Awe", description: "Become supernaturally charismatic and captivating", level: 1),
                    V5DisciplinePower(name: "Daunt", description: "Project an aura of menace that intimidates others", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Lingering Kiss", description: "Make feeding pleasurable for mortals, creating addiction", level: 2),
                    V5DisciplinePower(name: "Dread Gaze", description: "Paralyze victims with supernatural terror", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Entrancement", description: "Create powerful emotional bonds and obsession in others", level: 3),
                    V5DisciplinePower(name: "Irresistible Voice", description: "Make your words supernaturally persuasive", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Summon", description: "Call specific individuals to your location across great distances", level: 4),
                    V5DisciplinePower(name: "Star Magnetism", description: "Become irresistibly attractive to everyone around you", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Majesty", description: "Become so magnificent that others dare not harm you", level: 5),
                    V5DisciplinePower(name: "Mass Manipulation", description: "Affect entire crowds with your presence", level: 5)
                ]
            ]
        )
    ]
    
    // Helper methods for V5 Disciplines
    static func getV5Discipline(named name: String) -> V5Discipline? {
        return v5Disciplines.first { $0.name == name }
    }
    
    static func getAllV5DisciplineNames() -> [String] {
        return v5Disciplines.map { $0.name }
    }
    
    // Mage Spheres (nine spheres of magic)
    static let mageSpheres = ["Correspondence", "Entropy", "Forces", "Life", "Matter", "Mind", "Prime", "Spirit", "Time"]
    
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
