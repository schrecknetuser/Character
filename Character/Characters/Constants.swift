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
                    V5DisciplinePower(name: "Resilience", description: "Reduce damage from physical attacks", level: 1, addToHealth: true),
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
        ),
        
        // Blood Sorcery
        V5Discipline(
            name: "Blood Sorcery",
            powers: [
                1: [
                    V5DisciplinePower(name: "Corrosive Vitae", description: "Transform your blood into a caustic acid", level: 1),
                    V5DisciplinePower(name: "A Taste for Blood", description: "Learn about someone by tasting their blood", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Extinguish Vitae", description: "Destroy a portion of another vampire's blood", level: 2),
                    V5DisciplinePower(name: "Blood of Potency", description: "Temporarily increase your blood potency", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Scorpion's Touch", description: "Turn your blood into a deadly poison", level: 3),
                    V5DisciplinePower(name: "Blood Tempering", description: "Strengthen objects with vampiric blood", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Theft of Vitae", description: "Steal blood from a distance", level: 4),
                    V5DisciplinePower(name: "Cauldron of Blood", description: "Boil the blood within a victim's veins", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Blood of Acid", description: "Transform all your blood into destructive acid", level: 5),
                    V5DisciplinePower(name: "Ritual of Blood", description: "Perform powerful blood magic rituals", level: 5)
                ]
            ]
        ),
        
        // Obfuscate
        V5Discipline(
            name: "Obfuscate",
            powers: [
                1: [
                    V5DisciplinePower(name: "Cloak of Shadows", description: "Become invisible in darkness and shadow", level: 1),
                    V5DisciplinePower(name: "Silence of Death", description: "Move without making any sound", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Unseen Passage", description: "Become invisible while moving slowly", level: 2),
                    V5DisciplinePower(name: "Mask of a Thousand Faces", description: "Alter your appearance to look like someone else", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Chimerstry", description: "Create simple illusions that affect multiple senses", level: 3),
                    V5DisciplinePower(name: "Ghost in the Machine", description: "Become invisible to electronic surveillance", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Vanish from the Mind's Eye", description: "Vanish from sight even while being observed", level: 4),
                    V5DisciplinePower(name: "Fata Morgana", description: "Create complex, interactive illusions", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Cloak the Gathering", description: "Make an entire group invisible", level: 5),
                    V5DisciplinePower(name: "Impose Reality", description: "Make illusions temporarily real", level: 5)
                ]
            ]
        ),
        
        // Potence
        V5Discipline(
            name: "Potence",
            powers: [
                1: [
                    V5DisciplinePower(name: "Lethal Body", description: "Your unarmed attacks become supernaturally deadly", level: 1),
                    V5DisciplinePower(name: "Soaring Leap", description: "Jump incredible distances with supernatural strength", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Prowess", description: "Gain supernatural might in all physical endeavors", level: 2),
                    V5DisciplinePower(name: "Brutal Feed", description: "Feed violently and efficiently from victims", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Uncanny Grip", description: "Climb any surface and never lose your hold", level: 3),
                    V5DisciplinePower(name: "Spark of Rage", description: "Channel anger into devastating attacks", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Draught of Might", description: "Share your supernatural strength with others through blood", level: 4),
                    V5DisciplinePower(name: "Fists of Caine", description: "Your punches can damage even vampires", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Earthshock", description: "Strike the ground to create devastating tremors", level: 5),
                    V5DisciplinePower(name: "Flick", description: "Instantly incapacitate foes with casual gestures", level: 5)
                ]
            ]
        ),
        
        // Protean
        V5Discipline(
            name: "Protean",
            powers: [
                1: [
                    V5DisciplinePower(name: "Eyes of the Beast", description: "See perfectly in total darkness", level: 1),
                    V5DisciplinePower(name: "Weight of the Feather", description: "Become incredibly light and graceful", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Feral Weapons", description: "Transform your hands into claws or fangs", level: 2),
                    V5DisciplinePower(name: "Earth Meld", description: "Merge with the earth for protection and rest", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Shapechange", description: "Transform into an animal form", level: 3),
                    V5DisciplinePower(name: "Metamorphosis", description: "Partially transform, gaining animal traits", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Horrid Form", description: "Transform into a monstrous combat form", level: 4),
                    V5DisciplinePower(name: "Fleshcraft", description: "Reshape your body in unnatural ways", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Mist Form", description: "Transform into insubstantial mist", level: 5),
                    V5DisciplinePower(name: "One with the Land", description: "Merge with and control the natural environment", level: 5)
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
        BackgroundBase(name: "Allies", cost: 3, description: "Friends and supporters who provide assistance", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Contacts", cost: 1, description: "Network of information sources", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Fame", cost: 1, description: "Public recognition and celebrity status", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Influence", cost: 2, description: "Political or social power within institutions", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Resources", cost: 3, description: "Financial wealth and material assets", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Retainers", cost: 2, description: "Loyal servants and subordinates", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Status", cost: 2, description: "Formal rank or position in society", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Iron Will", cost: 5, description: "Exceptional mental fortitude and resistance", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Time Sense", cost: 1, description: "Innate ability to track time precisely", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Eidetic Memory", cost: 2, description: "Perfect recall of past events and information", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Linguistics", cost: 1, description: "Natural talent for learning languages", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // Vampire-specific backgrounds
        BackgroundBase(name: "Herd", cost: 3, description: "Reliable group of mortal blood sources", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Haven", cost: 2, description: "Secure and well-equipped dwelling", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Feeding Grounds", cost: 1, description: "Territory rich in potential prey", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Domain", cost: 2, description: "Area under your control and influence", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Thin-Blooded Alchemy", cost: 5, description: "Knowledge of thin-blood formulae and distillation", suitableCharacterTypes: [.vampire])
    ]
    
    // Predefined V5 Flaws with costs (negative values as they give points back)
    static let predefinedFlaws = [
        // Universal flaws suitable for all character types
        BackgroundBase(name: "Enemy", cost: -1, description: "Someone who actively works against you", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Dark Secret", cost: -1, description: "Hidden information that could ruin you if revealed", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Hunted", cost: -3, description: "Actively pursued by dangerous individuals or groups", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Anachronism", cost: -1, description: "Outdated mannerisms that mark you as old-fashioned", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Archaic", cost: -1, description: "Difficulty adapting to modern technology and customs", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Disgraced", cost: -2, description: "Fallen from favor and social standing", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Shunned", cost: -1, description: "Rejected by certain social groups or communities", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Suspect", cost: -2, description: "Under constant suspicion for past actions", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // Vampire-specific flaws
        BackgroundBase(name: "Folkloric Block", cost: -2, description: "Bound by traditional vampire limitations", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Clan Curse", cost: -2, description: "Suffers from an intensified clan weakness", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Feeding Restriction", cost: -1, description: "Limited to specific types of blood or prey", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Obvious Predator", cost: -2, description: "Difficulty hiding your predatory nature", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Prey Exclusion", cost: -1, description: "Cannot feed on certain types of mortals", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Stigmata", cost: -2, description: "Bleeds constantly, leaving obvious traces", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Thin-Blooded", cost: -4, description: "Weak vampiric blood with reduced powers", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Caitiff", cost: -2, description: "Clanless vampire with no inherited abilities", suitableCharacterTypes: [.vampire])
    ]
    
    // Character Background definitions (separate from merits/flaws)
    struct CharacterBackgroundDefinition {
        let name: String
        let suitableCharacterTypes: Set<CharacterType>
        
        init(name: String, suitableCharacterTypes: Set<CharacterType> = Set(CharacterType.allCases)) {
            self.name = name
            self.suitableCharacterTypes = suitableCharacterTypes
        }
    }
    
    static let characterBackgroundMeritDefinitions = [
        CharacterBackgroundDefinition(name: "Haven", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Resources", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Allies", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Retainers", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Contacts", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Domain", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Languages", suitableCharacterTypes: [.vampire, .ghoul, .mage])
    ]
    
    static let characterBackgroundFlawDefinitions = [
        CharacterBackgroundDefinition(name: "Adversary", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Enemy", suitableCharacterTypes: [.vampire, .ghoul, .mage])
    ]
    
    // Legacy string arrays for backward compatibility
    static let characterBackgroundMerits = characterBackgroundMeritDefinitions.map { $0.name }
    static let characterBackgroundFlaws = characterBackgroundFlawDefinitions.map { $0.name }
    
    // Helper methods to filter backgrounds by character type
    static func getAdvantagesForCharacterType(_ characterType: CharacterType) -> [BackgroundBase] {
        return predefinedAdvantages.filter { $0.suitableCharacterTypes.contains(characterType) }
    }
    
    static func getFlawsForCharacterType(_ characterType: CharacterType) -> [BackgroundBase] {
        return predefinedFlaws.filter { $0.suitableCharacterTypes.contains(characterType) }
    }
    
    static func getCharacterBackgroundMeritsForCharacterType(_ characterType: CharacterType) -> [CharacterBackgroundDefinition] {
        return characterBackgroundMeritDefinitions.filter { $0.suitableCharacterTypes.contains(characterType) }
    }
    
    static func getCharacterBackgroundFlawsForCharacterType(_ characterType: CharacterType) -> [CharacterBackgroundDefinition] {
        return characterBackgroundFlawDefinitions.filter { $0.suitableCharacterTypes.contains(characterType) }
    }
    
    // MARK: - Predator Paths
    
    // Predefined predator paths for vampires
    static let predatorPaths: [PredatorPath] = [
        PredatorPath(
            name: "Alleycat",
            description: "You stalk the streets and back alleys, hunting among the homeless, drug addicts, and other urban predators.",
            bonuses: [
                PredatorPathBonus(type: .skillSpecialization, description: "Athletics specialization in Parkour", skillName: "Athletics", specializationName: "Parkour"),
                PredatorPathBonus(type: .skillSpecialization, description: "Larceny specialization in Security Systems", skillName: "Larceny", specializationName: "Security Systems")
            ],
            drawbacks: [
                PredatorPathBonus(type: .flaw, description: "Obvious Predator (2 pts)", flawName: "Obvious Predator")
            ],
            feedingDescription: "Hunt in urban areas, feeding on the vulnerable and desperate."
        ),
        
        PredatorPath(
            name: "Bagger",
            description: "You feed on stored blood from hospitals, blood banks, or morgues rather than living victims.",
            bonuses: [
                PredatorPathBonus(type: .merit, description: "Resources (1 pt)", meritName: "Resources"),
                PredatorPathBonus(type: .skillSpecialization, description: "Larceny specialization in Security Systems", skillName: "Larceny", specializationName: "Security Systems")
            ],
            drawbacks: [
                PredatorPathBonus(type: .feeding, description: "Must hunt for stored blood; bag blood is less nourishing")
            ],
            feedingDescription: "Acquire blood from medical sources, morgues, or blood banks."
        ),
        
        PredatorPath(
            name: "Blood Leech",
            description: "You feed on other vampires, stealing their vitae through violence or trickery.",
            bonuses: [
                PredatorPathBonus(type: .skillSpecialization, description: "Brawl specialization in Grappling", skillName: "Brawl", specializationName: "Grappling"),
                PredatorPathBonus(type: .skillSpecialization, description: "Stealth specialization in Ambush", skillName: "Stealth", specializationName: "Ambush")
            ],
            drawbacks: [
                PredatorPathBonus(type: .flaw, description: "Enemy: Targeted vampire or their allies", flawName: "Enemy"),
                PredatorPathBonus(type: .feeding, description: "Diablerie risks and Kindred politics complications")
            ],
            feedingDescription: "Prey upon other vampires, taking their blood by force or stealth."
        ),
        
        PredatorPath(
            name: "Cleaver",
            description: "You maintain your mortal life as a façade, carefully feeding from family, friends, or colleagues.",
            bonuses: [
                PredatorPathBonus(type: .merit, description: "Herd (2 pts)", meritName: "Herd"),
                PredatorPathBonus(type: .skillSpecialization, description: "Subterfuge specialization in Innocent Face", skillName: "Subterfuge", specializationName: "Innocent Face")
            ],
            drawbacks: [
                PredatorPathBonus(type: .flaw, description: "Dark Secret: Vampiric nature", flawName: "Dark Secret")
            ],
            feedingDescription: "Feed carefully from your mortal contacts while maintaining the Masquerade."
        ),
        
        PredatorPath(
            name: "Consensualist",
            description: "You only feed from willing participants, often through BDSM communities or blood-sharing cults.",
            bonuses: [
                PredatorPathBonus(type: .skillSpecialization, description: "Medicine specialization in Phlebotomy", skillName: "Medicine", specializationName: "Phlebotomy"),
                PredatorPathBonus(type: .skillSpecialization, description: "Persuasion specialization in Seduction", skillName: "Persuasion", specializationName: "Seduction")
            ],
            drawbacks: [
                PredatorPathBonus(type: .feeding, description: "Requires willing participants; complications if consent is violated")
            ],
            feedingDescription: "Feed only from willing mortals who consent to being blood sources."
        ),
        
        PredatorPath(
            name: "Farmer",
            description: "You feed exclusively on animals, avoiding human blood and its complications.",
            bonuses: [
                PredatorPathBonus(type: .disciplineDot, description: "Animalism 1", disciplineName: "Animalism"),
                PredatorPathBonus(type: .skillSpecialization, description: "Animal Ken specialization in specific animal type", skillName: "Animal Ken", specializationName: "Specific Animal")
            ],
            drawbacks: [
                PredatorPathBonus(type: .feeding, description: "Animal blood is less nourishing; may need to feed more often")
            ],
            feedingDescription: "Feed exclusively on animals, maintaining your humanity at the cost of efficiency."
        ),
        
        PredatorPath(
            name: "Osiris",
            description: "You maintain a group of devoted followers who willingly provide blood in exchange for your guidance.",
            bonuses: [
                PredatorPathBonus(type: .merit, description: "Herd (3 pts)", meritName: "Herd"),
                PredatorPathBonus(type: .skillSpecialization, description: "Leadership specialization in Cult", skillName: "Leadership", specializationName: "Cult")
            ],
            drawbacks: [
                PredatorPathBonus(type: .flaw, description: "Responsibility to maintain your followers"),
                PredatorPathBonus(type: .feeding, description: "Must maintain follower loyalty and devotion")
            ],
            feedingDescription: "Lead a group of devoted mortals who serve as willing blood sources."
        ),
        
        PredatorPath(
            name: "Sandman",
            description: "You feed from sleeping victims, entering their homes and feeding while they remain unconscious.",
            bonuses: [
                PredatorPathBonus(type: .skillSpecialization, description: "Stealth specialization in Breaking and Entering", skillName: "Stealth", specializationName: "Breaking and Entering"),
                PredatorPathBonus(type: .skillSpecialization, description: "Medicine specialization in Anesthesiology", skillName: "Medicine", specializationName: "Anesthesiology")
            ],
            drawbacks: [
                PredatorPathBonus(type: .flaw, description: "Dark Secret: Breaking and entering", flawName: "Dark Secret")
            ],
            feedingDescription: "Feed from sleeping mortals, entering their homes at night."
        ),
        
        PredatorPath(
            name: "Scene Queen",
            description: "You hunt at nightclubs, parties, and social gatherings, using the chaos to feed unnoticed.",
            bonuses: [
                PredatorPathBonus(type: .skillSpecialization, description: "Etiquette specialization in High Society", skillName: "Etiquette", specializationName: "High Society"),
                PredatorPathBonus(type: .skillSpecialization, description: "Performance specialization in Dancing", skillName: "Performance", specializationName: "Dancing")
            ],
            drawbacks: [
                PredatorPathBonus(type: .feeding, description: "Dependent on social scenes; may struggle in isolation")
            ],
            feedingDescription: "Hunt at parties and social gatherings, blending in with the crowd."
        ),
        
        PredatorPath(
            name: "Siren",
            description: "You use seduction and attraction to lure willing victims into intimate situations for feeding.",
            bonuses: [
                PredatorPathBonus(type: .skillSpecialization, description: "Persuasion specialization in Seduction", skillName: "Persuasion", specializationName: "Seduction"),
                PredatorPathBonus(type: .skillSpecialization, description: "Subterfuge specialization in Lies", skillName: "Subterfuge", specializationName: "Lies")
            ],
            drawbacks: [
                PredatorPathBonus(type: .flaw, description: "Enemy: Spurned lovers or their allies", flawName: "Enemy")
            ],
            feedingDescription: "Seduce mortals into intimate situations where feeding is possible."
        )
    ]
    
    // Helper methods for predator paths
    static func getPredatorPath(named name: String) -> PredatorPath? {
        return predatorPaths.first { $0.name == name }
    }
    
    static func getAllPredatorPathNames() -> [String] {
        return predatorPaths.map { $0.name }
    }
}
