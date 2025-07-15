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
    
    // Predefined predator types for vampires
    static let predatorTypes: [PredatorType] = [
        PredatorType(
            name: "Alleycat",
            description: "Those who find violence to be the quickest way to get what they want might gravitate towards this hunting style. Alleycats are a vampire who feeds by brute force and outright attack and feeds from whomever they can when they can. Intimidation is a route easily taken to make their victims cower or even Dominating the victims to not report the attack or mask it as something else entirely.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Intimidation (Stickups) or Brawl (Grappling)", skillName: "Intimidation", specializationName: "Stickups"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of either Celerity or Potence", disciplineName: "Celerity"),
                PredatorTypeBonus(type: .merit, description: "Three dots of Criminal Contacts", meritName: "Criminal Contacts")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Lose one dot of Humanity", flawName: "Humanity Loss")
            ],
            feedingDescription: "Strength + Brawl is to take blood by force or threat. Wits + Streetwise can be used to find criminals as if a vigilante figure."
        ),
        
        PredatorType(
            name: "Bagger",
            description: "Sometimes the best blood doesn't come from a live body. Baggers are kindred who take an approach most are unable to with their ability to consume preserved, defractionated or rancid blood through (•••) Iron Gullet, allowing them to feed from unusual sources such as blood bags or corpses. Perhaps they work in a hospital or blood bank or they might even have enough knowledge about the black market to obtain their blood. Ventrue are unable to pick this Predator type.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Larceny (Lock Picking) or Streetwise (Black Market)", skillName: "Larceny", specializationName: "Lock Picking"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Blood Sorcery (Tremere and Banu Haqim only), Oblivion (Hecata only), or Obfuscate", disciplineName: "Obfuscate"),
                PredatorTypeBonus(type: .merit, description: "Iron Gullet Merit (3 pts)", meritName: "Iron Gullet")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Enemy Flaw (2 pts) - someone who believes this vampire owes them something", flawName: "Enemy")
            ],
            feedingDescription: "Intelligence + Streetwise can be used to find, gain access and purchase the goods."
        ),
        
        PredatorType(
            name: "Blood Leech",
            description: "Some Kindred might see feeding from mortals as inherently wrong or disgusting regardless of others' rationale. Blood Leech is a feeding style that is not looked upon kindly by many vampires making it risky unless the Kindred has a position of power and can keep their little secret secure. Regardless, with their rejection of mortal blood, they instead feed upon the vitae of other vampires through hunting those weaker than them, coercion, or taking Blood as payment.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Brawl (Kindred) or Stealth (Against Kindred)", skillName: "Brawl", specializationName: "Kindred"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Celerity or Protean", disciplineName: "Celerity"),
                PredatorTypeBonus(type: .other, description: "Increase blood potency by one")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Lose one dot of Humanity", flawName: "Humanity Loss"),
                PredatorTypeBonus(type: .flaw, description: "Dark Secret Flaw: Diablerist (2 pts), or Shunned Flaw (2 pts)", flawName: "Dark Secret"),
                PredatorTypeBonus(type: .flaw, description: "Feeding Flaw: Prey Exclusion (Mortals) (2 pts)", flawName: "Prey Exclusion")
            ],
            feedingDescription: "This Predator Type is suggested to not be abstracted down to a dice pool."
        ),
        
        PredatorType(
            name: "Cleaver",
            description: "The sweetest blood might be from those closest to them, the Cleaver takes advantage of that idea while taking blood from either their own close family and friends or even those close to someone else. Covertly stealing the blood from their victims while still maintaining ties to them. Cleavers will go to extreme lengths to keep their condition a secret from their victims but some may instead take a less than pleasant route. The Camarilla forbids the practice of taking a human family in this fashion, as it's a breach waiting to happen.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Persuasion (Gaslighting) or Subterfuge (Coverups)", skillName: "Persuasion", specializationName: "Gaslighting"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Dominate or Animalism", disciplineName: "Dominate"),
                PredatorTypeBonus(type: .merit, description: "Herd Advantage (2 pts)", meritName: "Herd")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Dark Secret Flaw: Cleaver (1 pt)", flawName: "Dark Secret")
            ],
            feedingDescription: "Manipulation + Subterfuge is used to condition the victims, socializing with them and feeding from them without the cover being blown."
        ),
        
        PredatorType(
            name: "Consensualist",
            description: "Consent is a dangerous thing to gather when they're a blood-sucking monster, but Consensualists make do. They never feed against the victim's free will, instead pretending to be a representative of a charity blood drive, someone with a blood kink within the kink community, or blatantly admitting to their victims what they are and getting their permission to feed. To the Camarilla, the last method is considered a masquerade breach but perhaps to a philosophical Anarch, it might be an acceptable risk to take.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Medicine (Phlebotomy) or Persuasion (Vessels)", skillName: "Medicine", specializationName: "Phlebotomy"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Auspex or Fortitude", disciplineName: "Auspex"),
                PredatorTypeBonus(type: .merit, description: "Gain one dot of Humanity", meritName: "Humanity")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Dark Secret Flaw: Masquerade Breacher (1 pt)", flawName: "Dark Secret"),
                PredatorTypeBonus(type: .flaw, description: "Feeding Flaw: Prey Exclusion (Non-consenting) (1 pt)", flawName: "Prey Exclusion")
            ],
            feedingDescription: "Manipulation + Persuasion allows the kindred to take blood by consent, under the guide of medical work or mutual kink."
        ),
        
        PredatorType(
            name: "Farmer",
            description: "Perhaps this vampire was once someone who worked as an activist or an aid worker, regardless of their reasoning the Farmer only feed from animals as their primary source of blood. The beast may gnaw at them with its throes of hunger, but they've successfully managed to avoid killing mortals except on the occasional bad night. Ventrue may not pick this Predator type and it cannot be taken on characters with Blood Potency 3 or higher.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Animal Ken (specific animal) or Survival (Hunting)", skillName: "Animal Ken", specializationName: "Specific Animal"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Animalism or Protean", disciplineName: "Animalism"),
                PredatorTypeBonus(type: .merit, description: "Gain one dot of Humanity", meritName: "Humanity")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Feeding Flaw: Farmer (2 pts)", flawName: "Farmer")
            ],
            feedingDescription: "Composure + Animal Ken is the roll to find and catch the chosen animal."
        ),
        
        PredatorType(
            name: "Osiris",
            description: "More than not, Osiris are celebrities within mortal society. Musicians, writers, priests, and even cult leaders may find an easy time finding their blood by utilizing those already around them. They tend to feed from their fans or worshippers which means they have easy access to blood, but followers tend to attract their own problems with the local authority or worse.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Occult (specific tradition) or Performance (specific entertainment field)", skillName: "Occult", specializationName: "Specific Tradition"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Blood Sorcery (Tremere or Banu Haqim only) or Presence", disciplineName: "Presence"),
                PredatorTypeBonus(type: .merit, description: "Spend three dots between Fame and Herd Backgrounds", meritName: "Fame and Herd")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Spend two dots between Enemies and Mythic Flaws", flawName: "Enemies and Mythic")
            ],
            feedingDescription: "Manipulation + Subterfuge or Intimidation + Fame are both used to feed from the adoring fans."
        ),
        
        PredatorType(
            name: "Sandman",
            description: "If they never wake during the feed it never happened, right? Sandman prefers to hunt on sleeping mortals than anyone else by using stealth or Disciplines to feed from their victims they are rarely caught in the act, though when they are, problems are sure to occur. Maybe they were anti-social in life or perhaps they find the route of seduction or violence too much for them and find comfort in the silence of this feeding style.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Medicine (Anesthetics) or Stealth (Break-in)", skillName: "Medicine", specializationName: "Anesthetics"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Auspex or Obfuscate", disciplineName: "Auspex"),
                PredatorTypeBonus(type: .merit, description: "Resources (1 pt)", meritName: "Resources")
            ],
            drawbacks: [],
            feedingDescription: "Dexterity + Stealth is for casing a location, breaking in and feeding without leaving a trace."
        ),
        
        PredatorType(
            name: "Scene Queen",
            description: "Similar to Osiris these Kindred find comfort in a particular subculture rather than a wider audience. Hunting in or around a subculture they likely belonged to in their previous life, their victims adore them for their status, and those who have an inkling of what they are disbelieved. The scene itself could be anything, from street culture to high fashion, and the unifying trait is the use of those around them.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Etiquette (specific scene), Leadership (specific scene), or Streetwise (specific scene)", skillName: "Etiquette", specializationName: "Specific Scene"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Dominate or Potence", disciplineName: "Dominate"),
                PredatorTypeBonus(type: .merit, description: "Fame Advantage (1 pt)", meritName: "Fame"),
                PredatorTypeBonus(type: .merit, description: "Contact Advantage (1 pt)", meritName: "Contact")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Either Influence Flaw: Disliked (outside their subculture) (1 pt) or Feeding Flaw: Prey Exclusion (a different subculture than theirs) (1 pt)", flawName: "Influence")
            ],
            feedingDescription: "Manipulation + Persuasion aids in feeding from those within the Kindred's subgroup, through conditioning and isolation to gain blood or gaslighting or forced silence."
        ),
        
        PredatorType(
            name: "Siren",
            description: "Everyone knows that sex sells and the Siren uses this to their advantage. Almost exclusively feeding while feigning sex or sexual interest, they utilize Disciplines and seduction to lure away a possible meal. Moving through clubs and one-night stands are skills they've mastered and regardless of how sexy they feel, deep in their darkest moments, they realize at best they are problematic and at worst a serial sexual assaulter.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Persuasion (Seduction) or Subterfuge (Seduction)", skillName: "Persuasion", specializationName: "Seduction"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Fortitude or Presence", disciplineName: "Fortitude"),
                PredatorTypeBonus(type: .merit, description: "Looks Merit: Beautiful (2 pts)", meritName: "Beautiful")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Enemy Flaw: spurned lover or jealous partner (1 pt)", flawName: "Enemy")
            ],
            feedingDescription: "Charisma + Subterfuge is how sirens feed under the guise of sexual acts."
        ),
        
        PredatorType(
            name: "Extortionist",
            description: "On the surface, Extortionists acquire their blood in exchange for services such as protection, security, or surveillance. Though, for as many times as the service might be genuine, there are many more times when the service has been offered from fabricated information to make the deal feel that much sweeter.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Intimidation (Coercion) or Larceny (Security)", skillName: "Intimidation", specializationName: "Coercion"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Dominate or Potence", disciplineName: "Dominate"),
                PredatorTypeBonus(type: .merit, description: "Spend three dots between Contacts and Resources Backgrounds", meritName: "Contacts and Resources")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Enemy Flaw: police or escaped victim (2 pts)", flawName: "Enemy")
            ],
            feedingDescription: "Strength/Manipulation + Intimidation to feed through coercion."
        ),
        
        PredatorType(
            name: "Graverobber",
            description: "Similar to Baggers these kindred understand there's no good in wasting good blood, even if others cannot consume it. Often they find themselves digging up corpses or working or mortuaries to obtain their bodies, yet regardless of what the name suggests, they prefer feeding from mourners at a gravesite or a hospital. This Predator Type often requires a haven or other connections to a church, hospital, or morgue as a way to obtain the bodies.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Occult (Grave Rituals) or Medicine (Cadavers)", skillName: "Occult", specializationName: "Grave Rituals"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Fortitude or Oblivion", disciplineName: "Fortitude"),
                PredatorTypeBonus(type: .merit, description: "Feeding Merit: Iron Gullet (3 pts)", meritName: "Iron Gullet"),
                PredatorTypeBonus(type: .merit, description: "Haven Advantage (1 pt)", meritName: "Haven")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Herd Flaw: Obvious Predator (2 pts)", flawName: "Obvious Predator")
            ],
            feedingDescription: "Resolve + Medicine for sifting through the dead for a body with blood. Manipulation + Insight for moving among miserable mortals."
        ),
        
        PredatorType(
            name: "Roadside Killer",
            description: "These Kindred never stay in one spot for too long and are always on the move, hunting those who won't be missed if they disappear alongside the road. Roadside Killers know the risk is just as worth as the reward. Perhaps this Kindred was once a truck driver themselves or maybe they met their fate alongside the road as well.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Survival (the road) or Investigation (vampire cant)", skillName: "Survival", specializationName: "The Road"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Fortitude or Protean", disciplineName: "Fortitude"),
                PredatorTypeBonus(type: .merit, description: "Two additional dots of migrating Herd", meritName: "Migrating Herd")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Feeding Flaw: Prey Exclusion (locals)", flawName: "Prey Exclusion")
            ],
            feedingDescription: "Dexterity/Charisma + Drive to feed by picking up down and outs with no other options."
        ),
        
        PredatorType(
            name: "Grim Reaper",
            description: "Hunting inside hospice care facilities, assisted living homes, and other places where those who are near death reside. Grim Reapers are constantly on the move in an effort to locate new victims near the end of their lives to feed from. Hunting in this style may also earn a taste for specific diseases making them easier to identify.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Awareness (Death) or Larceny (Forgery)", skillName: "Awareness", specializationName: "Death"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Auspex or Oblivion", disciplineName: "Auspex"),
                PredatorTypeBonus(type: .merit, description: "One dot of Allies or Influence associated with the medical community", meritName: "Allies"),
                PredatorTypeBonus(type: .merit, description: "Gain one dot of Humanity", meritName: "Humanity")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Feeding Flaw: Prey Exclusion (Healthy Mortals) (1 pt)", flawName: "Prey Exclusion")
            ],
            feedingDescription: "Intelligence + Awareness/Medicine in order to find victims."
        ),
        
        PredatorType(
            name: "Montero",
            description: "Montero carry on a tradition held by aristocratic Spaniards where they hunted deer and used teams to drive them into the huntsman. Retainers drive the victims towards the vampire for them to feed. This is not always done in the traditional style but in the forms of long cons, flash mobs, or gang pursuits.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Leadership (Hunting Pack) or Stealth (Stakeout)", skillName: "Leadership", specializationName: "Hunting Pack"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Dominate or Obfuscate", disciplineName: "Dominate"),
                PredatorTypeBonus(type: .merit, description: "Retainers (2 pts)", meritName: "Retainers")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Lose one dot of Humanity", flawName: "Humanity Loss")
            ],
            feedingDescription: "Intelligence + Stealth represents the expert planning of well-trained Retainers. Whereas a well-practiced plan and patient waiting is represented by Resolve + Stealth."
        ),
        
        PredatorType(
            name: "Pursuer",
            description: "For those who prefer to stalk their victim, learning their habits and routines, determining if they will cause an outcry if they disappear or not. The Pursuer strikes when the time is right and when hunger is at a perfect balance.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Investigation (Profiling) or Stealth (Shadowing)", skillName: "Investigation", specializationName: "Profiling"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Animalism or Auspex", disciplineName: "Animalism"),
                PredatorTypeBonus(type: .merit, description: "Bloodhound Merit (1 pt)", meritName: "Bloodhound"),
                PredatorTypeBonus(type: .merit, description: "One dot of Contacts from the morally flexible inhabitants", meritName: "Contacts")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Lose one dot of Humanity", flawName: "Humanity Loss")
            ],
            feedingDescription: "Intelligence + Investigation to locate and find a victim no one will notice is gone. Stamina + Stealth for long stalking of unaware urban victims."
        ),
        
        PredatorType(
            name: "Trapdoor",
            description: "Much like the spider, this vampire builds a nest and lures their prey inside. Be it an amusement park, an abandoned house, or an underground club, the victim comes to them. There the trapdoor might only play with their mind and terrorize them, imprison them to drain them slowly, or take a deep drink and then send them home.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Persuasion (Marketing) or Stealth (Ambushes or Traps)", skillName: "Persuasion", specializationName: "Marketing"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Protean or Obfuscate", disciplineName: "Protean"),
                PredatorTypeBonus(type: .merit, description: "Haven (1 pt)", meritName: "Haven"),
                PredatorTypeBonus(type: .merit, description: "One dot of either Retainers or Herd, or a second Haven dot", meritName: "Retainers or Herd")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "One Haven Flaw, either Creepy (1 pt) or Haunted (1 pt)", flawName: "Haven Flaw")
            ],
            feedingDescription: "Charisma + Stealth for the victims that enter expecting a fun-filled night. Dexterity + Stealth to feed upon trespassers. Wits + Awareness + Haven dots is used to navigate the maze of the den itself."
        ),
        
        PredatorType(
            name: "Tithe Collector",
            description: "They hold enough power that other Kindred around them pay tribute in the form of specially selected vessels, who are delivered regularly, or upon request. The vessels must be kept in reasonable condition and returned, but otherwise the Masquerade is everyone else's problem.",
            bonuses: [
                PredatorTypeBonus(type: .skillSpecialization, description: "One specialty in either Intimidation (Kindred) or Leadership (Kindred)", skillName: "Intimidation", specializationName: "Kindred"),
                PredatorTypeBonus(type: .disciplineDot, description: "One dot of Dominate or Presence", disciplineName: "Dominate"),
                PredatorTypeBonus(type: .merit, description: "Three dots of Domain or Status", meritName: "Domain or Status")
            ],
            drawbacks: [
                PredatorTypeBonus(type: .flaw, description: "Adversary (2 pts)", flawName: "Adversary")
            ],
            feedingDescription: "Authority and power allow this predator type to receive vessels from other Kindred as tribute."
        )
    ]
    
    // Helper methods for predator types
    static func getPredatorType(named name: String) -> PredatorType? {
        return predatorTypes.first { $0.name == name }
    }
    
    static func getAllPredatorTypeNames() -> [String] {
        return predatorTypes.map { $0.name }
    }
}
