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
            description: "Utilized by those who desire a close and supernatural bond with the animal world as well as a vampire's own Beast.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Bond Famulus", description: "Create an enhanced animal companion.\nDice pool: Charisma + Animal Ken", level: 1),
                    V5DisciplinePower(name: "Sense the Beast", description: "Sense hostility and supernatural traits.\nDice pool: Resolve + Animalism\nOpposing pool: Composure + Subterfuge", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Animal Messenger", description: "Use a Famulus to send a message.", level: 2),
                    V5DisciplinePower(name: "Atavism", description: "Revert animals to primal instincts.\nDice pool: Composure + Animalism", level: 2),
                    V5DisciplinePower(name: "Feral Whispers", description: "Communicate or summon animals.\nDice pool: Manipulation/Charisma + Animalism", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Messenger's Command", description: "Use Compel or Mesmerize through a Famulus.\nDice pool: See Compel or Mesmerize\nOpposing pool: See Compel or Mesmerize", level: 3),
                    V5DisciplinePower(name: "Animal Succulence", description: "Slake additional hunger from animals; reduce Blood Potency slaking penalty.", level: 3),
                    V5DisciplinePower(name: "Plague of Beasts", description: "Mark a target for animal attention.\nDice pool: Manipulation + Animalism\nOpposing pool: Composure + Animal Ken", level: 3),
                    V5DisciplinePower(name: "Quell the Beast", description: "Force a vampire's beast to slumber or lethargy on mortals.\nDice pool: Charisma + Animalism\nOpposing pool: Stamina + Resolve", level: 3),
                    V5DisciplinePower(name: "Scent of Prey", description: "Track mortals who witnessed a masquerade breach.\nDice pool: Resolve + Animalism", level: 3),
                    V5DisciplinePower(name: "Unliving Hive", description: "Extend Animalism influence to insect swarms.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Subsume the Spirit", description: "Possess an animal's body.\nDice pool: Manipulation + Animalism", level: 4),
                    V5DisciplinePower(name: "Sway the Flock", description: "Influence behavior of animals in an area.\nDice pool: Composure + Animalism", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Animal Dominion", description: "Command flocks or packs of animals.\nDice pool: Charisma + Animalism", level: 5),
                    V5DisciplinePower(name: "Coax the Bestial Temper", description: "Influence difficulty to resist Frenzy.\nDice pool: Manipulation + Animalism", level: 5),
                    V5DisciplinePower(name: "Drawing Out the Beast", description: "Transfer frenzy to another victim.\nDice pool: Wits + Animalism\nOpposing pool: Composure + Resolve", level: 5),
                    V5DisciplinePower(name: "Spirit Walk", description: "Transfer consciousness from one animal to another.", level: 5)
                ]
            ]
        ),
        
        // Auspex
        V5Discipline(
            name: "Auspex",
            description: "Enables users to hone their senses both physical and psychic in order to bolster their awareness, perceptions, or even see visions of the future.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Heightened Senses", description: "Enhance vampiric senses and add Auspex rating to all perception rolls.\nDice pool: Wits + Resolve", level: 1),
                    V5DisciplinePower(name: "Sense the Unseen", description: "Sense supernatural activity.\nDice pool: Wits/Resolve + Auspex\nOpposing pool: Wits + Obfuscate (if target is using Obfuscate), otherwise Resolve", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Panacea", description: "Heals Willpower and calms nerves.\nDice pool: Composure + Auspex", level: 2),
                    V5DisciplinePower(name: "Premonition", description: "Receive visions of the future.\nDice pool: Resolve + Auspex", level: 2),
                    V5DisciplinePower(name: "Reveal Temperament", description: "Smell the Resonance of a target and/or detect Dyscrasia.\nDice pool: Intelligence + Auspex\nOpposing pool: Composure + Subterfuge", level: 2),
                    V5DisciplinePower(name: "Unerring Pursuit", description: "Track a victim.\nDice pool: Resolve + Auspex\nOpposing pool: Wits + Awareness (victim may roll to glimpse tracker)", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Vermin Vision", description: "Share senses with animals.\nDice pool: Resolve + Animalism", level: 3),
                    V5DisciplinePower(name: "Fatal Flaw", description: "Find a target's weakness.\nDice pool: Intelligence + Auspex\nOpposing pool: Composure (mental weaknesses), Stamina (physical weaknesses) + Subterfuge", level: 3),
                    V5DisciplinePower(name: "Scry the Soul", description: "Perceive detailed information about the target.\nDice pool: Intelligence + Auspex\nOpposing pool: Composure + Subterfuge", level: 3),
                    V5DisciplinePower(name: "Share the Senses", description: "Tap into another's senses.\nDice pool: Resolve + Auspex", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Spirit's Touch", description: "Gather emotional residue from objects or locations.\nDice pool: Intelligence + Auspex", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Clairvoyance", description: "Gain information from surroundings.\nDice pool: Intelligence + Auspex", level: 5),
                    V5DisciplinePower(name: "Possession", description: "Possess a mortal body.\nDice pool: Resolve + Auspex\nOpposing pool: Resolve + Intelligence", level: 5),
                    V5DisciplinePower(name: "Telepathy", description: "Read minds and project thoughts.\nDice pool: Resolve + Auspex\nOpposing pool: Wits + Subterfuge", level: 5),
                    V5DisciplinePower(name: "Unburdening the Bestial Soul", description: "Remove or protect from Stains.\nDice pool: Composure + Auspex", level: 5)
                ]
            ]
        ),
        
        // Celerity
        V5Discipline(
            name: "Celerity",
            description: "Powers up the movement of the user, enabling them to have unnatural quickness in their movement and supernatural reflexes.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Cat's Grace", description: "Automatically pass balance tests.", level: 1),
                    V5DisciplinePower(name: "Fluent Swiftness", description: "Reroll Blood Surge on Dexterity or Celerity test.", level: 1),
                    V5DisciplinePower(name: "Rapid Reflexes", description: "Faster reactions and minor actions.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Fleetness", description: "Add Celerity rating to non-combat Dexterity tests or defending.", level: 2),
                    V5DisciplinePower(name: "Rush Job", description: "Perform a long task in mere seconds.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Blink", description: "Close distance in a straight line at incredible speed.\nDice pool: Dexterity + Athletics", level: 3),
                    V5DisciplinePower(name: "Traversal", description: "Move over vertical or liquid surfaces.\nDice pool: Dexterity + Athletics", level: 3),
                    V5DisciplinePower(name: "Weaving", description: "Remove penalty from dodging multiple ranged attackers.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Blurred Momentum", description: "Avoid attacks with fewer successes than Celerity rating.", level: 4),
                    V5DisciplinePower(name: "Draught of Elegance", description: "Share Celerity-enhanced vitae with others.", level: 4),
                    V5DisciplinePower(name: "Unerring Aim", description: "World slows down to make one devastatingly accurate attack.", level: 4),
                    V5DisciplinePower(name: "Unseen Strike", description: "Surprise attack by vanishing and reappearing.\nDice pool: Dexterity + Celerity\nOpposing pool: Wits + Awareness", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Lightning Strike", description: "Attack with blinding speed.", level: 5),
                    V5DisciplinePower(name: "Split Second", description: "Alter a current scene moment retroactively within reason.", level: 5)
                ]
            ]
        ),
        
        // Dominate
        V5Discipline(
            name: "Dominate",
            description: "Allows the user to use mind control through eye contact and spoken word as well as manipulate memories of their victims.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Cloud Memory", description: "Make someone forget the current moment.\nDice pool: Charisma + Dominate\nOpposing pool: Wits + Resolve", level: 1),
                    V5DisciplinePower(name: "Compel", description: "Issue a single command.\nDice pool: Charisma + Dominate\nOpposing pool: Intelligence + Resolve", level: 1),
                    V5DisciplinePower(name: "Slavish Devotion", description: "Makes victims already under Dominate resist other Dominate attempts more easily.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Mesmerize", description: "Issue complex commands.\nDice pool: Manipulation + Dominate\nOpposing pool: Intelligence + Resolve", level: 2),
                    V5DisciplinePower(name: "Dementation", description: "Drive others insane.\nDice pool: Manipulation + Dominate\nOpposing pool: Composure + Intelligence", level: 2),
                    V5DisciplinePower(name: "Domitor's Favor", description: "Make defiance while under a Blood Bond more difficult.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Forgetful Mind", description: "Rewrite someone's memory.\nDice pool: Manipulation + Dominate\nOpposing pool: Intelligence + Resolve", level: 3),
                    V5DisciplinePower(name: "Submerged Directive", description: "Implant Dominate orders as passive, lingering suggestions.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Ancestral Dominion", description: "Command a descendant against their will.\nDice pool: Manipulation + Dominate\nOpposing pool: Intelligence + Resolve", level: 4),
                    V5DisciplinePower(name: "Implant Suggestion", description: "Temporarily change another's opinion or personality.\nDice pool: Manipulation + Dominate\nOpposing pool: Composure + Resolve", level: 4),
                    V5DisciplinePower(name: "Rationalize", description: "Convince victim the Dominate action was their own idea.", level: 4),
                    V5DisciplinePower(name: "Tabula Rasa", description: "Erase a target's identity and self-recognition.\nDice pool: Resolve + Dominate\nOpposing pool: Composure + Resolve", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Lethe's Call", description: "Erase weeks of memory.\nDice pool: Manipulation + Dominate\nOpposing pool: Intelligence + Resolve", level: 5),
                    V5DisciplinePower(name: "Mass Manipulation", description: "Apply another Dominate power to a group.\n(Use strongest opponent's pool as target)", level: 5),
                    V5DisciplinePower(name: "Terminal Decree", description: "Allow lethal or extreme commands under Dominate.", level: 5)
                ]
            ]
        ),
        
        // Fortitude
        V5Discipline(
            name: "Fortitude",
            description: "Strengthens the user's physical and mental resistance.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Fluent Endurance", description: "Reroll the Blood Surge rouse check on a Stamina or Fortitude test.", level: 1),
                    V5DisciplinePower(name: "Resilience", description: "Add Fortitude rating to the health track.", level: 1, addToHealth: true),
                    V5DisciplinePower(name: "Unswayable Mind", description: "Add Fortitude rating to rolls resisting supernatural or coercive effects.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Earth's Perseverance", description: "Become immovable from current spot.", level: 2),
                    V5DisciplinePower(name: "Enduring Beasts", description: "Share the vampire's toughness with animals.\nDice pool: Stamina + Animalism", level: 2),
                    V5DisciplinePower(name: "Invigorating Vitae", description: "Heal mortals faster with vampire blood.", level: 2),
                    V5DisciplinePower(name: "Obdurate", description: "Maintain footing when struck with massive force.\nDice pool: Wits + Survival", level: 2),
                    V5DisciplinePower(name: "Toughness", description: "Subtract Fortitude rating from all superficial damage taken before halving.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Defy Bane", description: "Convert Aggravated damage to Superficial.\nDice pool: Wits + Survival", level: 3),
                    V5DisciplinePower(name: "Fortify the Inner Façade", description: "Increase Difficulty of powers that read or influence the mind.", level: 3),
                    V5DisciplinePower(name: "Seal the Beast's Maw", description: "Ignore hunger effects temporarily at cost of reduced dice pools.", level: 3),
                    V5DisciplinePower(name: "Valeren", description: "Mend another vampire's injuries.\nDice pool: Intelligence + Fortitude", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Draught of Endurance", description: "Turn vitae into a Fortitude buff for others.", level: 4),
                    V5DisciplinePower(name: "Gorgon's Scales", description: "Resonance provides specific Fortitude bonuses.", level: 4),
                    V5DisciplinePower(name: "Shatter", description: "Inflict damage normally blocked by Toughness back onto attacker.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Flesh of Marble", description: "Ignore first source of physical damage each turn unless it's sunlight.", level: 5),
                    V5DisciplinePower(name: "Prowess from Pain", description: "Ignore Health damage penalties and boost Attributes.", level: 5)
                ]
            ]
        ),
        
        // Presence
        V5Discipline(
            name: "Presence",
            description: "Enables the user to use subtle manipulation, control, and swaying of emotions to guide others towards a goal.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Awe", description: "Add Presence rating to any Skill roll involving Persuasion, Performance, or Charisma related rolls.\nEffect lasts for one scene or until ended by the user.\nOnce the power wears off, the victim reverts to their original opinions.", level: 1),
                    V5DisciplinePower(name: "Daunt", description: "Add Presence rating to any intimidation rolls.\nEffect lasts for one scene or until ended by the user.\nCannot be used at the same time as Awe.", level: 1),
                    V5DisciplinePower(name: "Eyes of the Serpent", description: "Immobilize a victim by making eye contact.\nDice pool: Charisma + Presence\nOpposing pool: Wits + Composure\nEffect lasts until eye contact is broken or the scene ends. Vampires can break this by spending Willpower any turn after the first.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Lingering Kiss", description: "Usable during feedings, the victim gains a bonus to Social attribute.\nEffect lasts for one night per Presence rating.\nWithdrawal causes penalties equal to original bonus. Cannot be used on those under Blood Bond. Unbondable cannot take this power.", level: 2),
                    V5DisciplinePower(name: "Melpominee", description: "Use Presence powers through sound alone, without seeing the target.\nAllows use of Awe, Daunt, Dread Gaze, Entrance, and Majesty.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Clear the Field", description: "Clear a space calmly and orderly, exempting certain individuals.\nDice pool: Composure + Presence\nOpposing pool: Wits + Composure\nUser may exempt number of individuals equal to their Composure.", level: 3),
                    V5DisciplinePower(name: "Dread Gaze", description: "Instill fear to make a target flee.\nDice pool: Charisma + Presence\nOpposing pool: Composure + Resolve\nEffect lasts one turn. A critical win causes a vampire to make a difficulty 3 terror Frenzy test.", level: 3),
                    V5DisciplinePower(name: "Entrancement", description: "Influence someone to keep user happy; add Presence rating to all social rolls against them.\nDice pool: Charisma + Presence\nOpposing pool: Composure + Wits\nEffect lasts one hour plus one per margin. Harmful or opposing requests require a second roll or cause failure.", level: 3),
                    V5DisciplinePower(name: "Thrown Voice", description: "Throw voice to any point in sight.\nEffect lasts for one scene.\nRoll required only if used with other presence-enhancing powers.", level: 3),
                    V5DisciplinePower(name: "True Love's Face", description: "Appear as someone the victim has strong emotional ties with.\nDice pool: Manipulation + Presence\nOpposing pool: Composure + Wits\nEffect lasts for one scene. May cause stains if target is the victim's touchstone.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Irresistible Voice", description: "User's voice alone allows use of Dominate.\nPassive effect.\nDoes not work through technology.", level: 4),
                    V5DisciplinePower(name: "Magnum Opus", description: "Infuse Presence into art or creative works.\nDice pool: Charisma/Manipulation + Craft\nAudiences resist with Composure + Resolve.", level: 4),
                    V5DisciplinePower(name: "Suffuse the Edifice", description: "Extend Presence onto a building.\nAs per power transmitted\nIf user is present, they become the focus.", level: 4),
                    V5DisciplinePower(name: "Summon", description: "Call someone affected by Presence or who tasted user's vitae.\nDice pool: Manipulation + Presence\nOpposing pool: Composure + Intelligence\nEffect lasts for one night. Victim won't harm themselves to reach user.", level: 4),
                    V5DisciplinePower(name: "Wingman", description: "Extend Presence to another character.\nAs per power used.\nCannot double bonus with the same Presence power.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Majesty", description: "All who see the user are stunned, acting only for self-preservation.\nDice pool: Charisma + Presence\nOpposing pool: Composure + Resolve\nEffect lasts for one scene. Winning the contest gives one turn plus one per margin of free action.", level: 5),
                    V5DisciplinePower(name: "Star Magnetism", description: "Allows Presence powers to be used through live-feed tech.\nRequires one extra Rouse Check.\nIf using Entrancement, must say the target's name clearly.", level: 5)
                ]
            ]
        ),
        
        // Blood Sorcery
        V5Discipline(
            name: "Blood Sorcery",
            description: "A type of blood magic that allows the practitioners to manipulate the blood, mortal or vampiric.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Corrosive Vitae", description: "Turn vitae corrosive.", level: 1),
                    V5DisciplinePower(name: "Shape the Sanguine Sacrament", description: "Shape blood into a form or image.\nDice pool: Manipulation + Blood Sorcery", level: 1),
                    V5DisciplinePower(name: "A Taste for Blood", description: "Discover traits of another through their blood.\nDice pool: Resolve + Blood Sorcery", level: 1),
                    V5DisciplinePower(name: "Koldunic Sorcery", description: "Attune with and sense through an element.\nDice pool: Resolve + Blood Sorcery\nOpposing pool: Wits or Resolve + Obfuscate", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Blood's Curse", description: "Temporarily increase another vampire's Bane Severity.\nDice pool: Intelligence + Blood Sorcery\nOpposing pool: Stamina + Occult/Fortitude", level: 2),
                    V5DisciplinePower(name: "Extinguish Vitae", description: "Increase another Kindred's Hunger.\nDice pool: Intelligence + Blood Sorcery\nOpposing pool: Stamina + Composure", level: 2),
                    V5DisciplinePower(name: "Scour Secrets", description: "Quickly review large amounts of content.\nDice pool: Intelligence + Blood Sorcery", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Blood of Potency", description: "Temporarily increase Blood Potency.\nDice pool: Resolve + Blood Sorcery", level: 3),
                    V5DisciplinePower(name: "Scorpion's Touch", description: "Change own vitae into paralyzing poison.\nDice pool: Strength + Blood Sorcery\nOpposing pool: Stamina + Occult/Fortitude", level: 3),
                    V5DisciplinePower(name: "Transitive Bond", description: "Extend properties of Blood Bond.", level: 3),
                    V5DisciplinePower(name: "Ripples of the Heart", description: "Manipulate blood or blood effects on others.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Theft of Vitae", description: "Manipulate blood from a victim through air to feed.\nDice pool: Wits + Blood Sorcery\nOpposing pool: Wits + Occult", level: 4),
                    V5DisciplinePower(name: "Blood Aegis", description: "Create a protective Blood barrier.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Baal's Caress", description: "Turn own vitae into lethal poison.\nDice pool: Strength + Blood Sorcery\nOpposing pool: Stamina + Occult/Fortitude", level: 5),
                    V5DisciplinePower(name: "Cauldron of Blood", description: "Boil the victim's blood in their body.\nDice pool: Resolve + Blood Sorcery\nOpposing pool: Composure + Occult/Fortitude", level: 5),
                    V5DisciplinePower(name: "Reclamation of Vitae", description: "Reclaim blood used to create ghouls remotely.", level: 5)
                ]
            ]
        ),
        
        // Obfuscate
        V5Discipline(
            name: "Obfuscate",
            description: "The art of not being seen even in crowds either through being wholly unseen or by blending in.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Cloak of Shadows", description: "Stand still to blend into surroundings.", level: 1),
                    V5DisciplinePower(name: "Ensconce", description: "Others ignore small objects carried on the vampire's body.", level: 1),
                    V5DisciplinePower(name: "Silence of Death", description: "Nullify sounds the user makes.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Cache", description: "Hide nearby objects not held by the vampire.", level: 2),
                    V5DisciplinePower(name: "Chimerstry", description: "Create brief but realistic hallucinations.\nDice pool: Manipulation + Obfuscate\nOpposing pool: Composure + Wits", level: 2),
                    V5DisciplinePower(name: "Ghost's Passing", description: "Obfuscate an animal's tracks.", level: 2),
                    V5DisciplinePower(name: "Unseen Passage", description: "Move while remaining hidden.", level: 2),
                    V5DisciplinePower(name: "Ventriloquism", description: "Throw voice so only target hears.\nDice pool: Wits + Obfuscate\nOpposing pool: Resolve + Composure", level: 2),
                    V5DisciplinePower(name: "Doubletalk", description: "Say one thing while conveying something else.\nDice pool: Composure + Obfuscate\nOpposing pool: Wits + Auspex", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Fata Morgana", description: "Create elaborate hallucinations.\nDice pool: Manipulation + Obfuscate", level: 3),
                    V5DisciplinePower(name: "Ghost in the Machine", description: "Transmit Obfuscate through live camera feeds.", level: 3),
                    V5DisciplinePower(name: "Mask of a Thousand Faces", description: "Appear as a mundane person and interact normally.", level: 3),
                    V5DisciplinePower(name: "Mask of Isolation", description: "Force another to appear as a forgettable face.\nDice pool: Manipulation + Obfuscate\nOpposing pool: Charisma + Insight", level: 3),
                    V5DisciplinePower(name: "Mental Maze", description: "Remove victim's sense of direction and orientation.\nDice pool: Charisma + Obfuscate\nOpposing pool: Wits + Resolve", level: 3),
                    V5DisciplinePower(name: "Mind Masque", description: "Conceal or alter emotional/thought profile from supernatural perception.\nDice pool: Intelligence + Obfuscate", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Conceal", description: "Cloak an inanimate object.\nDice pool: Intelligence + Obfuscate", level: 4),
                    V5DisciplinePower(name: "Vanish", description: "Activate stealth even while being watched.\nDice pool: Wits + Obfuscate\nOpposing pool: Wits + Awareness", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Cloak the Gathering", description: "Extend Obfuscate to companions.", level: 5),
                    V5DisciplinePower(name: "Impostor's Guise", description: "Appear as someone else.\nDice pool: Wits + Obfuscate", level: 5)
                ]
            ]
        ),
        
        // Potence
        V5Discipline(
            name: "Potence",
            description: "Strengthens the user's physical prowess.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Fluent Strength", description: "Reroll Blood Surge rouse checks on Strength or Potence rolls.", level: 1),
                    V5DisciplinePower(name: "Lethal Body", description: "Unarmed attacks deal Aggravated Health damage to mortals and ignore 1 level of armor per Potence rating.", level: 1),
                    V5DisciplinePower(name: "Soaring Leap", description: "Leap a number of meters equal to three times Potence rating.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Prowess", description: "Add Potence to unarmed damage; add half Potence (rounded up) to Melee damage.", level: 2),
                    V5DisciplinePower(name: "Relentless Grasp", description: "Gain supernatural grip strength.\nNote: Does not affect the initial grapple test.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Brutal Feed", description: "Feeding becomes violent, halving feeding actions on vampires.", level: 3),
                    V5DisciplinePower(name: "Spark of Rage", description: "Add Potence to incite violent actions in crowds.\nDice pool: Manipulation + Potence\nOpposing pool (vs vampires): Intelligence + Composure", level: 3),
                    V5DisciplinePower(name: "Uncanny Grip", description: "Climb or hang unsupported using supernatural grip.", level: 3),
                    V5DisciplinePower(name: "Wrecker", description: "Double Potence rating for feats of Strength (not vs living targets).", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Draught of Might", description: "Let others drink vitae to gain Potence boost for one night.", level: 4),
                    V5DisciplinePower(name: "Crash Down", description: "Deal damage in a small area with Soaring Leap.\nDice pool: Strength + Potence\nOpposing pool: Dexterity + Athletics", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Earth Shock", description: "Create a shockwave that knocks targets prone.\nNote: Only usable once per scene.", level: 5),
                    V5DisciplinePower(name: "Fist of Caine", description: "Inflict Aggravated damage to all targets.", level: 5),
                    V5DisciplinePower(name: "Subtle Hammer", description: "Channel strength into one body part; provides large bonus to limited-movement attacks.", level: 5)
                ]
            ]
        ),
        
        // Protean
        V5Discipline(
            name: "Protean",
            description: "Grants the ability to change one's shape, grow claws, meld into the earth, or become fog.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Eyes of the Beast", description: "See in total darkness.\n+2 bonus dice to intimidation against mortals while active.\nEffect lasts as long as desired.", level: 1),
                    V5DisciplinePower(name: "Weight of the Feather", description: "Become almost weightless.\nDice pool: Wits + Survival\nEffect lasts as long as desired.\nDice pool only used when activated as a reaction.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Feral Weapons", description: "Grow claws or elongate fangs.\n+2 damage with claws; no called shot penalty with fangs.\nSuperficial damage not halved. Lasts one scene.", level: 2),
                    V5DisciplinePower(name: "Vicissitude", description: "Sculpt own flesh permanently.\nDice pool: Resolve + Protean\nAmalgam: Dominate ●●\nEach success grants one change.", level: 2),
                    V5DisciplinePower(name: "Serpent's Kiss", description: "Inject vitae through bite.\nUsed to transport powers like Scorpion's Touch.\nEffect lasts one scene.", level: 2),
                    V5DisciplinePower(name: "The False Sip", description: "Prevent ingestion of blood.\nMust vomit it up within a scene or spend additional Rouse Check.\nAmalgam: Fortitude ●", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Earth Meld", description: "Sink into and merge with natural earth.\nLasts until disturbed or sunrise.\nOnly works on natural surfaces.", level: 3),
                    V5DisciplinePower(name: "Fleshcrafting", description: "Alter another's flesh.\nDice pool: Resolve + Protean\nOpposing pool: Stamina + Resolve\nAmalgam: Vicissitude, Dominate ●●\nMargin of success equals number of changes.", level: 3),
                    V5DisciplinePower(name: "Shapechange", description: "Transform into animal of similar body mass.\nGain the physical traits of the chosen animal.\nEffect lasts for one scene.", level: 3),
                    V5DisciplinePower(name: "Visceral Absorption", description: "Absorb corpse remains into own body.\nDice pool: Strength + Protean\nAmalgam: Blood Sorcery ●●\nReduces Hunger by 1 per body up to Blood Sorcery rating (not below 1).", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Horrid Form", description: "Transform into monstrous form.\nGrants changes equal to Protean rating.\nAll crits are messy; Frenzy checks at +2 Difficulty.\nAmalgam: Vicissitude, Dominate ●●", level: 4),
                    V5DisciplinePower(name: "Metamorphosis", description: "Transform into larger animal.\nSame rules as Shapechange.\nPrerequisite: Shapechange\nEffect lasts one scene.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Blood Form", description: "Become amorphous mass of blood.\nAmalgam: Blood Sorcery ●●\nCan be consumed, forming blood bonds.\nEffect lasts one scene or until ended.", level: 5),
                    V5DisciplinePower(name: "The Heart of Darkness", description: "Remove and hide own heart.", level: 5)
                ]
            ]
        ),
        
        // Oblivion
        V5Discipline(
            name: "Oblivion",
            description: "Has two branches: one allows the user to manipulate shadows at will and the other enables necromancy or usage of spirits, though both tap into the Abyss.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Ashes to Ashes", description: "Destroy a corpse by dissolving it.\nDice pool: Stamina + Oblivion\nOpposing pool: Stamina + Medicine/Fortitude\nIf the body is not animated it will dissolve throughout three turns with no test needed.", level: 1),
                    V5DisciplinePower(name: "Binding Fetter", description: "Identify a fetter by use of their senses.\nDice pool: Wits + Oblivion\nDuring its use the user receives a -2 penalty to all Awareness, Wits, and Resolve rolls.", level: 1),
                    V5DisciplinePower(name: "Oblivion Sight", description: "See in darkness clearly and see ghosts present.\nWhile in use there is a two-dice penalty to social interactions with mortals.", level: 1),
                    V5DisciplinePower(name: "Shadow Cloak", description: "+2 bonus to stealth rolls and intimidation against mortals.\nPassive effect.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Arms of Ahriman", description: "Conjures shadow appendages the user can control.\nDice pool: Wits + Oblivion\nUser cannot take other actions. Arms do not require Composure + Resolve to escape.", level: 2),
                    V5DisciplinePower(name: "Fatal Prediction", description: "Increase the chances of a mortal being harmed by exterior forces.\nDice pool: Resolve + Oblivion\nOpposing pool: Wits + Occult\nFor every margin of success, victim takes 1 Aggravated damage. The vampire cannot interact with the victim.", level: 2),
                    V5DisciplinePower(name: "Fatal Precognition", description: "Vision of a non-vampire's death.\nDice pool: Resolve + Oblivion\nThe vampire must be able to see or hear the target.", level: 2),
                    V5DisciplinePower(name: "Shadow Cast", description: "Conjure shadows from the user's body.\nStanding in the shadow causes more Willpower damage from social conflict.", level: 2),
                    V5DisciplinePower(name: "Where the Veil Thins", description: "Determine the density of the Shroud in their area.\nDice pool: Intelligence + Oblivion", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Aura of Decay", description: "Make plants wilt, animals/humans sick, and food spoil.\nDice pool: Stamina + Oblivion\nOpposing pool: Stamina + Medicine/Fortitude\nAll social rolls take a -2 dice penalty while active. Contaminated food causes 2 Superficial Damage.", level: 3),
                    V5DisciplinePower(name: "Passion Feast", description: "Slake Hunger on the passion of wraiths.\nDice pool: Resolve + Oblivion\nOpposing pool: Resolve + Composure\nHunger consumed does not return the next night.", level: 3),
                    V5DisciplinePower(name: "Shadow Perspective", description: "Project senses into a shadow within line of sight.\nUndetectable except via supernatural means.", level: 3),
                    V5DisciplinePower(name: "Shadow Servant", description: "Use a shadow to spy or scare.\nThe servant has no mind and can be destroyed by bright light.", level: 3),
                    V5DisciplinePower(name: "Touch of Oblivion", description: "Withers a body part on touch.\nInflicting damage may cause Stains. Requires the user to grip the target.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Necrotic Plague", description: "Manifest supernatural illness.\nDice pool: Intelligence + Oblivion\nOpposing pool: Stamina + Medicine/Fortitude\nCan only be healed via vitae. Cannot be treated medically.", level: 4),
                    V5DisciplinePower(name: "Stygian Shroud", description: "Darkness spews out of a nearby shadow to cover area.\nShadow can extend up to twice Oblivion rating in meters.", level: 4),
                    V5DisciplinePower(name: "Umbrous Clutch", description: "Use victim's shadow to teleport them to user.\nDice pool: Wits + Oblivion\nOpposing pool: Dexterity + Wits\nMortals are terrified; vampires make Difficulty 4 frenzy test.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Shadow Step", description: "Step into one shadow and appear in another.\nA willing person may be taken but will share Stains if any occur.", level: 5),
                    V5DisciplinePower(name: "Skuld Fulfilled", description: "Reintroduce illnesses the victim has recovered from.\nDice pool: Stamina + Oblivion\nOpposing pool: Stamina + Stamina/Fortitude\nRemoves ghoul immunity to aging and vitae.", level: 5),
                    V5DisciplinePower(name: "Tenebrous Avatar", description: "Turn body into a shadow to move freely.\nUser is immune to damage except sunlight and fire.", level: 5),
                    V5DisciplinePower(name: "Withering Spirit", description: "Erode a victim's spirit.\nDice pool: Resolve + Oblivion\nOpposing pool: Resolve + Occult/Fortitude\nIf target is Impaired, they won't return as a wraith.", level: 5)
                ]
            ]
        ),
        
        // Oblivion Ceremonies
        V5Discipline(
            name: "Oblivion Ceremonies",
            description: "dark rites that harness the powers of death and the underworld to summon spirits, command decay, or breach the Shroud.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Compel Spirit", description: "Force a ghost to manifest and interact.\nDice pool: Manipulation + Oblivion\nOpposing pool: Resolve + Composure\nCeremony requires 10 minutes and a personal item.", level: 1),
                    V5DisciplinePower(name: "Eyes of the Dead", description: "See through the eyes of a corpse's final moments.\nDice pool: Intelligence + Oblivion\nRequires touching the corpse. Shows last few minutes of life.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "Summon Soul", description: "Call forth the ghost of a specific deceased person.\nDice pool: Charisma + Oblivion\nOpposing pool: Resolve + Composure\nRequires knowing the ghost's true name and a personal item.", level: 2),
                    V5DisciplinePower(name: "Ritual of Death", description: "Create a zone where death energy accumulates.\nDice pool: Intelligence + Oblivion\nZone enhances all Oblivion powers used within it.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Soul Burn", description: "Inflict spiritual damage that persists beyond death.\nDice pool: Resolve + Oblivion\nOpposing pool: Composure + Resolve\nDamage affects both living and unliving targets.", level: 3),
                    V5DisciplinePower(name: "Ward vs. Spirits", description: "Create barriers that repel ghosts and wraiths.\nDice pool: Intelligence + Oblivion\nWard lasts for one month and covers a building.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Bind Wraith", description: "Permanently enslave a powerful ghost.\nDice pool: Manipulation + Oblivion\nOpposing pool: Resolve + Composure\nRequires elaborate ceremony lasting several hours.", level: 4),
                    V5DisciplinePower(name: "Create Shadowland", description: "Establish a permanent zone where the dead can manifest.\nDice pool: Intelligence + Oblivion\nArea becomes easier for spirits to interact with the living.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Mass Summoning", description: "Call forth an army of the dead.\nDice pool: Charisma + Oblivion\nSummons multiple wraiths and zombies to serve.", level: 5),
                    V5DisciplinePower(name: "Sever the Gauntlet", description: "Permanently tear open barriers between life and death.\nDice pool: Resolve + Oblivion\nCreates a permanent portal to the underworld.", level: 5)
                ]
            ]
        ),
        
        // Blood Sorcery Rituals
        V5Discipline(
            name: "Blood Sorcery Rituals",
            description: "Structured magical rites that channel vitae and occult knowledge to produce versatile supernatural effects.",
            powers: [
                1: [
                    V5DisciplinePower(name: "Astromancy", description: "Learn information such as Skills, Desires and Convictions about someone.\nRitual roll: Intelligence + Blood Sorcery\nAdd 1 die if caster knows either Birth or Embrace date (not both).", level: 1),
                    V5DisciplinePower(name: "Beelzebeatit", description: "Animals avoid the area.\nRitual roll: Intelligence + Blood Sorcery\nDoes not repel directed or controlled animals.", level: 1),
                    V5DisciplinePower(name: "Bind the Accusing Tongue", description: "Prevent someone from speaking ill of the caster.\nRitual roll: Intelligence + Blood Sorcery\nVictim can resist by rolling Composure + Resolve.", level: 1),
                    V5DisciplinePower(name: "Blood Apocrypha", description: "Embed messages into blood or vessels.\nRitual roll: Intelligence + Blood Sorcery\nFirst person to taste receives the message if they are the target or have A Taste for Blood.", level: 1),
                    V5DisciplinePower(name: "Blood Walk", description: "Learn generation, name, and sire of a subject.\nRitual roll: Intelligence + Blood Sorcery\nRequires a Rouse Check from the subject.", level: 1),
                    V5DisciplinePower(name: "Bloody Message", description: "Reveal a message to specific individuals that disappears after being read.\nRitual roll: Intelligence + Blood Sorcery\nRoll when enchanting the surface.", level: 1),
                    V5DisciplinePower(name: "Blood to Water", description: "Transform blood into water.\nRitual roll: Intelligence + Blood Sorcery\nRemoves all traces of blood.", level: 1),
                    V5DisciplinePower(name: "Clinging of the Insect", description: "Allows caster to cling to surfaces.\nRitual roll: Intelligence + Blood Sorcery\nRequires hands and feet to cling.", level: 1),
                    V5DisciplinePower(name: "Coax the Garden", description: "Use nearby plant life for defense.\nRitual roll: Intelligence + Blood Sorcery\nPlants target all but the caster.", level: 1),
                    V5DisciplinePower(name: "Craft Bloodstone", description: "Create a tracking stone.\nRitual roll: Intelligence + Blood Sorcery\nLimit equals Resolve in number of stones.", level: 1),
                    V5DisciplinePower(name: "Douse the Fear", description: "Suppress fear of fire temporarily.\nRitual roll: Intelligence + Blood Sorcery\nWears off at end of scene.", level: 1),
                    V5DisciplinePower(name: "Enrich the Blood", description: "Make a mortal more nourishing.\nRitual roll: Intelligence + Blood Sorcery\nDoes not affect Kindred vitae.", level: 1),
                    V5DisciplinePower(name: "Herd Ward (Minor)", description: "Ward a kine to prevent feeding.\nRitual roll: Intelligence + Blood Sorcery\nRoll is made when feeding attempt occurs.", level: 1),
                    V5DisciplinePower(name: "Letter Ward", description: "Ward a letter against unwanted readers.\nRitual roll: Intelligence + Blood Sorcery\nRoll when letter is opened by someone else.", level: 1),
                    V5DisciplinePower(name: "Revealing the Crimson Trail", description: "Reveal blood traces.\nRitual roll: Intelligence + Blood Sorcery\nVery old traces may require Resolve + Awareness.", level: 1),
                    V5DisciplinePower(name: "Seal the Brand", description: "Make a tattoo permanent on a vampire.\nRitual roll: Intelligence + Blood Sorcery\nInflicts 1 Superficial damage.", level: 1),
                    V5DisciplinePower(name: "Shared Memory", description: "Experience another's Memoriam.\nRitual roll: Intelligence + Blood Sorcery\nCan observe but not influence.", level: 1),
                    V5DisciplinePower(name: "Wake with Evening's Freshness", description: "Awaken during the day when danger is near.\nRitual roll: Intelligence + Blood Sorcery\nRoll made only if real danger appears.", level: 1),
                    V5DisciplinePower(name: "Ward Against Ghouls", description: "Protect against Ghouls.\nRitual roll: Intelligence + Blood Sorcery\nUses standard Ward rules.", level: 1)
                ],
                2: [
                    V5DisciplinePower(name: "As Fog on Water", description: "Walk on water silently.\nRitual roll: Intelligence + Blood Sorcery\nMay be ended early or kept active for one night.", level: 2),
                    V5DisciplinePower(name: "Calling the Aura's Remnants", description: "Speak with residual aura of the dead.\nRitual roll: Intelligence + Blood Sorcery\nAura only has memories up to moment of death.", level: 2),
                    V5DisciplinePower(name: "Calix Secretus", description: "Store vitae for later.\nRitual roll: Intelligence + Blood Sorcery\nTwo stored Rouse Checks slake one Hunger.", level: 2),
                    V5DisciplinePower(name: "Communicate with Kindred Sire", description: "Telepathically link Sire and Childe.\nRitual roll: Intelligence + Blood Sorcery\nMajor disturbances break the link.", level: 2),
                    V5DisciplinePower(name: "Craftmaster", description: "Gain temporary dots and specialties in a Craft skill.\nRitual roll: Intelligence + Blood Sorcery\nOn total failure, suffer Aggravated damage.", level: 2),
                    V5DisciplinePower(name: "Depths of Nightmare", description: "Induce unhealable Willpower damage with nightmares.\nRitual roll: Intelligence + Blood Sorcery\nFailure causes pleasant dreams that point to caster.", level: 2),
                    V5DisciplinePower(name: "Elemental Grasp", description: "Command a chosen element to cause damage.\nRitual roll: Intelligence + Blood Sorcery\nGain +1 die if element is already active (e.g. water in a flood).", level: 2),
                    V5DisciplinePower(name: "Enhance Dyscrasia", description: "Allow multiple Kindred to feed on a Dyscrasia.\nRitual roll: Intelligence + Blood Sorcery\nOften used with Enrich the Blood first.", level: 2),
                    V5DisciplinePower(name: "Eyes of Babel", description: "Gain ability to read/speak target's known languages.\nRitual roll: Intelligence + Blood Sorcery\nRequires consumption of eyes and tongue. May cause Stains.", level: 2),
                    V5DisciplinePower(name: "Illuminate Trail of Prey", description: "Track a specific individual.\nRitual roll: Intelligence + Blood Sorcery\nCaster must know the target's face.", level: 2),
                    V5DisciplinePower(name: "Le Sang de l'Amour", description: "Create a link between two who desire each other.\nRitual roll: Intelligence + Blood Sorcery\nRoll failure disorients and reduces Composure.", level: 2),
                    V5DisciplinePower(name: "Soporific Touch", description: "Weaken victim against mundane and supernatural manipulation.\nRitual roll: Intelligence + Blood Sorcery\nActivated after contact; opposed by Stamina + Resolve.", level: 2),
                    V5DisciplinePower(name: "Silentia Mortis", description: "Replicates Silence of Death (Obfuscate ●).\nRitual roll: Intelligence + Blood Sorcery\nIf cast on another, they must make a Rouse Check.", level: 2),
                    V5DisciplinePower(name: "Shroud of Silence", description: "Prevent sounds from escaping a room.\nRitual roll: Intelligence + Blood Sorcery\nRequires vitae from Kindred with Obfuscate.", level: 2),
                    V5DisciplinePower(name: "Stolen Memory", description: "Access sire's memories.\nRitual roll: Intelligence + Blood Sorcery\nDifficulty increases by 2 for each generation past sire.", level: 2),
                    V5DisciplinePower(name: "Tiamat Glistens", description: "Attune to a place of power (e.g., Furcus).\nRitual roll: Intelligence + Blood Sorcery\nOnly one caster can be attuned at a time.", level: 2),
                    V5DisciplinePower(name: "Truth of Blood", description: "Discern truth from lies.\nRitual roll: Resolve + Blood Sorcery\nOpposed by Composure + Occult.", level: 2),
                    V5DisciplinePower(name: "Unseen Underground", description: "Become invisible underground.\nRitual roll: Intelligence + Blood Sorcery\nEnds if caster rises above ground or acts hostile.", level: 2),
                    V5DisciplinePower(name: "Viscera Garden", description: "Grow blood-fed plants that can consume corpses.\nRitual roll: Intelligence + Blood Sorcery\nRequire monthly Rouse Checks. Mortals are more susceptible to Disciplines after ingestion.", level: 2),
                    V5DisciplinePower(name: "Ward against Spirits", description: "Protect against spirits.\nRitual roll: Intelligence + Blood Sorcery\nUses standard Ward rules.", level: 2),
                    V5DisciplinePower(name: "Warding Circle against Ghouls", description: "Protect against Ghouls.\nRitual roll: Intelligence + Blood Sorcery\nCost: Three Rouse Checks. Uses standard Ward rules.", level: 2),
                    V5DisciplinePower(name: "Web of Hunger", description: "Resist the Beckoning.\nRitual roll: Intelligence + Blood Sorcery\nCounts as Level 2 if cast with dagger; otherwise Level 4.", level: 2)
                ],
                3: [
                    V5DisciplinePower(name: "Bladed Hands", description: "Sharpens hands into deadly weapons.\nRitual roll: Intelligence + Blood Sorcery\nHands count as light piercing weapons with +2 modifier.", level: 3),
                    V5DisciplinePower(name: "Bloodless Feast", description: "Purify blood into clear substance.\nRitual roll: Intelligence + Blood Sorcery\nUsers become more vulnerable to diablerie.", level: 3),
                    V5DisciplinePower(name: "Blood Sigil", description: "Tattoo that stores messages.\nRitual roll: Intelligence + Blood Sorcery\nRead via Resolve + Occult or Auspex (Sense the Unseen).", level: 3),
                    V5DisciplinePower(name: "Communal Vigor", description: "Share Blood Potency with packmates.\nRitual roll: Intelligence + Blood Sorcery\nGain bonus dice to Dominate and Presence rolls vs pack.", level: 3),
                    V5DisciplinePower(name: "Dagon's Call", description: "Rupture blood vessels of a distant target.\nRitual roll: Resolve + Blood Sorcery\nCan be used up to two more times with extra Rouse Checks.", level: 3),
                    V5DisciplinePower(name: "Deflection of Wooden Doom", description: "Protect against being staked.\nRitual roll: Intelligence + Blood Sorcery\nRoll only triggered upon being staked.", level: 3),
                    V5DisciplinePower(name: "Elemental Shelter", description: "Merge with an elemental medium (e.g. earth, fire).\nRitual roll: Intelligence + Blood Sorcery\nKoldun's body is detectable via Wits + Awareness or Auspex.", level: 3),
                    V5DisciplinePower(name: "Essence of Air", description: "Allows flight.\nRitual roll: Intelligence + Blood Sorcery\nHighly discouraged due to Masquerade concerns.", level: 3),
                    V5DisciplinePower(name: "Eyes of the Past", description: "See what occurred in the current location in the past.\nRitual roll: Intelligence + Blood Sorcery\nLimited to events from past five years.", level: 3),
                    V5DisciplinePower(name: "Fire in the Blood", description: "Inflict fire-like pain internally.\nRitual roll: Intelligence + Blood Sorcery\nTarget can only be affected once per night.", level: 3),
                    V5DisciplinePower(name: "Firewalker", description: "Temporarily resist fire.\nRitual roll: Intelligence + Blood Sorcery\nRitual can affect others; all parts must come from caster.", level: 3),
                    V5DisciplinePower(name: "Galvanic Ruination", description: "Short-circuits nearby electronics.\nRitual roll: Intelligence + Blood Sorcery\nMay extend range by increasing difficulty.", level: 3),
                    V5DisciplinePower(name: "Gentle Mind", description: "Protect another from frenzy.\nRitual roll: Intelligence + Blood Sorcery\nRequires shared blood; cannot cast on self.", level: 3),
                    V5DisciplinePower(name: "Haunted House", description: "Create illusion of a haunted haven.\nRitual roll: Intelligence + Blood Sorcery\nEffect lasts for ten years.", level: 3),
                    V5DisciplinePower(name: "Herd Ward (Major)", description: "Ward protects entire location housing herd.\nRitual roll: Intelligence + Blood Sorcery\nRoll triggered when unauthorized feeding occurs.", level: 3),
                    V5DisciplinePower(name: "Illusion of Peaceful Death", description: "Make corpse appear naturally deceased.\nRitual roll: Intelligence + Blood Sorcery\nRequires body with at least half its blood.", level: 3),
                    V5DisciplinePower(name: "Illusion of Perfection", description: "Become bland and unnoticeable.\nRitual roll: Intelligence + Blood Sorcery\nActs like Mask of a Thousand Faces.", level: 3),
                    V5DisciplinePower(name: "Nepenthe", description: "Potion to remove Stains.\nRitual roll: Intelligence + Blood Sorcery\nRepeated use makes Stains permanent.", level: 3),
                    V5DisciplinePower(name: "One with the Blade", description: "Bind weapon to self and make it resilient.\nRitual roll: Intelligence + Blood Sorcery\nOnly one weapon may hold ritual at a time.", level: 3),
                    V5DisciplinePower(name: "Sanguine Watcher", description: "Create rat-like observer from vitae.\nRitual roll: Intelligence + Blood Sorcery\nInstructions must be explicit.", level: 3),
                    V5DisciplinePower(name: "Seeing with the Sky's Eyes", description: "View target from a bird's perspective.\nRitual roll: Intelligence + Blood Sorcery\nAsk one question per success; crits grant three extras.", level: 3),
                    V5DisciplinePower(name: "Seeking Tiamat", description: "Locate ley lines (Furcus).\nRitual roll: Intelligence + Blood Sorcery\nCritical wins locate and point toward multiple furcae.", level: 3),
                    V5DisciplinePower(name: "Sleep of Judas", description: "Drug and incapacitate vampire.\nRitual roll: Intelligence + Blood Sorcery\nRoll triggered once target is drugged.", level: 3),
                    V5DisciplinePower(name: "Soul of the Hemonculus", description: "Create a loyal, shrunken clone of the caster.\nRitual roll: Intelligence + Blood Sorcery\nCannot be Embraced or ghouled; sun-immune.", level: 3),
                    V5DisciplinePower(name: "The Unseen Change", description: "Force Lupines to shift into Wolf Form.\nRitual roll: Intelligence + Blood Sorcery\nMust overcome Willpower to avoid transformation.", level: 3),
                    V5DisciplinePower(name: "Trespass", description: "Flow through cracks and gaps like liquid.\nRitual roll: Intelligence + Blood Sorcery\nMay be attacked if noticed.", level: 3),
                    V5DisciplinePower(name: "Viral Haruspex", description: "Read illness-based omens across a population.\nRitual roll: Intelligence + Blood Sorcery\nMust drink from diseased individual within 24 hours.", level: 3),
                    V5DisciplinePower(name: "Ward against Lupines", description: "Wards against werewolves.\nRitual roll: Intelligence + Blood Sorcery\nUses standard ward rules.", level: 3),
                    V5DisciplinePower(name: "Warding Circle against Spirits", description: "Wards against spirits.\nRitual roll: Intelligence + Blood Sorcery\nCost: Three Rouse Checks.", level: 3)
                ],
                4: [
                    V5DisciplinePower(name: "Compel the Inanimate", description: "Give a command to an inanimate object which it follows minutes later.\nRitual roll: Intelligence + Blood Sorcery\nCaster must remain nearby. Detectable via Wits + Auspex vs. Composure + Blood Sorcery.", level: 4),
                    V5DisciplinePower(name: "Defense of the Sacred Haven", description: "Shroud a haven in mystical darkness to protect from sunlight.\nRitual roll: Intelligence + Blood Sorcery\nRoll is made at sunrise.", level: 4),
                    V5DisciplinePower(name: "Egregore Consultation", description: "Access knowledge from others infected with the same illness.\nRitual roll: Intelligence + Blood Sorcery\nCommon Skills in the area may provide up to +2 dice.", level: 4),
                    V5DisciplinePower(name: "Eyes of the Nighthawk", description: "Take control of a carnivorous bird and act through it.\nRitual roll: Intelligence + Blood Sorcery\nCan use most non-physical Disciplines through the bird.", level: 4),
                    V5DisciplinePower(name: "Feast of Ashes", description: "Prevent a Kindred from drinking blood for one night.\nRitual roll: Intelligence + Blood Sorcery\nVictim resists with Resolve + Willpower. They may eat ashes to slake Hunger down to 3.", level: 4),
                    V5DisciplinePower(name: "Guided Memory", description: "Experience memories guided by another vampire's blood.\nRitual roll: Intelligence + Blood Sorcery\nMay unlock Disciplines, Merits, or other gifts.", level: 4),
                    V5DisciplinePower(name: "Incorporeal Passage", description: "Become ghostlike and immaterial.\nRitual roll: Intelligence + Blood Sorcery\nCan only interact via sight and sound.", level: 4),
                    V5DisciplinePower(name: "Innocence of the Child's Heart", description: "Block Scry the Soul to conceal Diablerie and traits.\nRitual roll: Intelligence + Blood Sorcery\nRare ritual known only to Nicolai or with ST discretion.", level: 4),
                    V5DisciplinePower(name: "Innocence's Veil", description: "Conceal Diablerie traces.\nRitual roll: Intelligence + Blood Sorcery\nCannot be detected by A Taste for Blood or Scry the Soul.", level: 4),
                    V5DisciplinePower(name: "Invisible Chains of Binding", description: "Root a target to a single spot.\nRitual roll: Intelligence + Blood Sorcery\nTarget is immobilized for one hour per margin success unless freed.", level: 4),
                    V5DisciplinePower(name: "Land's Sustenance", description: "Feed from a place of power and cause suffering.\nRitual roll: Intelligence + Blood Sorcery\nGrants auto-successes on Rouse Checks once per session based on margin.", level: 4),
                    V5DisciplinePower(name: "Rending the Sweet Earth", description: "Pull a vampire from Earth Meld.\nRitual roll: Intelligence + Blood Sorcery\nAwakens target unless they are in torpor or caster rolls a Critical Win.", level: 4),
                    V5DisciplinePower(name: "Riding the Earth's Vein", description: "Travel from one furcus to another random one.\nRitual roll: Intelligence + Blood Sorcery\nOne-way travel. Destination is not controllable.", level: 4),
                    V5DisciplinePower(name: "Protean Curse", description: "Transform a target into a bat (like Metamorphosis).\nRitual roll: Intelligence + Blood Sorcery\nCannot be cast on the caster.", level: 4),
                    V5DisciplinePower(name: "Ward against Cainites", description: "Protect against other vampires.\nRitual roll: Intelligence + Blood Sorcery\nUses standard Ward rules. Vampires may identify the caster with Intelligence + Auspex vs. Intelligence + Blood Sorcery.", level: 4),
                    V5DisciplinePower(name: "Warding Circle against Lupines", description: "Protect against werewolves.\nRitual roll: Intelligence + Blood Sorcery\nCost: Three Rouse Checks. Uses standard Ward rules.", level: 4)
                ],
                5: [
                    V5DisciplinePower(name: "Antebrachia Ignium", description: "Set the user's arms on fire.\nRitual roll: Intelligence + Blood Sorcery\nOnly the arms are resistant to fire.", level: 5),
                    V5DisciplinePower(name: "Atrocity's Release", description: "Reverse the effects of Diablerie.\nRitual roll: Intelligence + Blood Sorcery\nCan be resisted with Resolve + Blood Sorcery.", level: 5),
                    V5DisciplinePower(name: "Dominion", description: "Block Animalism, Auspex, Dominate, and Presence within a building.\nRitual roll: Intelligence + Blood Sorcery\nArea of effect depends on number of Rouse Checks.", level: 5),
                    V5DisciplinePower(name: "Eden's Bounty", description: "Drain blood from nearby creatures.\nRitual roll: Intelligence + Blood Sorcery\nMortals suffer −1 to Physical rolls and 1 Aggravated damage for remainder of chapter.", level: 5),
                    V5DisciplinePower(name: "Elemental Attack", description: "Attack using an element; can be chained into a natural disaster.\nRitual roll: Intelligence + Blood Sorcery\nGains extra die if element is already active. May chain with other rituals.", level: 5),
                    V5DisciplinePower(name: "Escape to True Sanctuary", description: "Create a one-way portal.\nRitual roll: Intelligence + Blood Sorcery\nRequires twelve Rouse Checks in total. Only one set of circles can be active.", level: 5),
                    V5DisciplinePower(name: "Fisher King", description: "Become one with the land to gain its secrets.\nRitual roll: Intelligence + Blood Sorcery\nAsk questions with Wits + Streetwise or Survival; can be chained with Land's Sustenance and Compel the Inanimate.", level: 5),
                    V5DisciplinePower(name: "Heart of Stone", description: "Transform the heart to stone to avoid staking.\nRitual roll: Intelligence + Blood Sorcery\nCannot use Presence; bonuses to resist social influence.", level: 5),
                    V5DisciplinePower(name: "Reawakened Vigor", description: "Recover Blood Potency faster after torpor.\nRitual roll: Intelligence + Blood Sorcery\nInflicts Aggravated damage on others (not the caster).", level: 5),
                    V5DisciplinePower(name: "Shaft of Belated Dissolution", description: "Create a stake that targets the heart.\nRitual roll: Intelligence + Blood Sorcery\nIf not a heart hit, a splinter moves toward it; causes Final Death on success.", level: 5),
                    V5DisciplinePower(name: "Simulacrum Gate", description: "Create a teleport gate for multiple vampires.\nRitual roll: Intelligence + Blood Sorcery\nRare; possible Stains on use.", level: 5),
                    V5DisciplinePower(name: "Transferring the Soul", description: "Take over a body post-diablerie.\nRitual roll: Intelligence + Blood Sorcery and Intelligence + Oblivion\nRequires assistance from another Kindred with Oblivion ●●●●● or dual mastery.", level: 5),
                    V5DisciplinePower(name: "Warding Circle against Cainites", description: "Wards against vampires.\nRitual roll: Intelligence + Blood Sorcery\nCost: Three Rouse Checks. Uses standard ward rules.", level: 5)
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
    
    // Mage Traits Descriptions
    static let mageEssenceDescription = "Mage's mystical connection to the universe's foundational forces, shaping how they perceive and channel magical energy."
    static let mageResonanceDescription = "The unique emotional and thematic flavor of a mage's magic, shaped by their personality and beliefs."
    static let mageSynergyDescription = "Inward flow of cosmic principles through a mage, reflecting their alignment with universal forces."
    
    // V5 Clans
    static let clans = ["Brujah", "Gangrel", "Malkavian", "Nosferatu", "Toreador", "Tremere", "Ventrue", "Banu Haqim", "Hecata", "Lasombra", "Ministry", "Ravnos", "Salubri", "Tzimisce", "Caitiff", "Thin-Blood"]
    
    // Predefined V5 Advantages with costs - Comprehensive Merit System
    static let predefinedAdvantages = [
        
        // MARK: - Looks
        BackgroundBase(name: "Beautiful", cost: 2, description: "Add one die to related Social pools", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Stunning", cost: 4, description: "Add two dice to related Social pools", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Semblance of the Methuselah", cost: 2, description: "With an appearance strikingly similar to a methuselah, gain one die on rolls to impress, intimidate or attract the attention who recognize your face. As well as gain other bonuses such as status or additional die when meeting the methuselah they resemble.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Famous Face", cost: 1, description: "Appear as someone famous and gain two dice in social tests where this works to their benefit. Take a two-dice penalty whenever they attempt to hide in a crowd or avoid recognition.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Ingénue", cost: 1, description: "They appear innocent and blameless, add two dice to any rolls related to avoiding suspicion or deflecting blame at the Storytellers' discretion.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Remarkable Feature", cost: 1, description: "Possessing a rare, memorable feature such as eye color or unusual complexion. Add two-dice to social interactions with strangers and take a one-die penalty to disguise yourself.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Up All Night", cost: 2, description: "Treat Humanity as one higher (Max 10) when using Blush of Life, eating, drinking, or sexual intercourse.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Up All Night (Enhanced)", cost: 4, description: "Treat Humanity as two higher (Max 10) when using Blush of Life, eating, drinking, or sexual intercourse.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Substance Use
        BackgroundBase(name: "High Functioning Addict", cost: 1, description: "Add one die to either Physical, Social, or Mental pool when the last feeding had the drug of their desire.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // MARK: - Archaic
        BackgroundBase(name: "Custodian of History", cost: 1, description: "Grants +1 to all relevant Skill tests pertaining to a chosen period or character in Kindred lore.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Bonding
        BackgroundBase(name: "Short Bond", cost: 2, description: "Bonds decrease by two levels each month if not reinforced.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Unbondable", cost: 5, description: "Unable to be bonded.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Bonds of Fealty", cost: 3, description: "Their Dominate powers do not require eye contacts on those bound to them. The character must have Dominate in order to take this.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Enduring Bond", cost: 1, description: "The bonds they create last longer, only weakening every other month", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Feeding
        BackgroundBase(name: "Bloodhound", cost: 1, description: "Able to sniff out resonances without tasting them.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Iron Gullet", cost: 3, description: "Able to consume rancid, defractionated, or otherwise unedible blood to other vampires.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Vessel Recognition", cost: 1, description: "With a Resolve + Awareness test at Difficulty 2 they can tell if a mortal has been fed on recently. A critical win lets them sense if the feed is recurring, meaning there is a chance it's a herd member.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Mythic
        BackgroundBase(name: "Eat Food", cost: 2, description: "Can consume food but still with no nourishment.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Cold Dead Hunger", cost: 3, description: "Add two dice to resist Hunger frenzy.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Pack Diablerie", cost: 2, description: "The character will always be the one to take the soul unless they otherwise choose during Diablerie. Additionally, if they help another consume the soul, they gain 5 experience points to spend in the same manner as if they'd committed the Diablerie themselves.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Luck of the Devil", cost: 4, description: "Once per session when misfortune occurs it can be redirected towards someone close to them for the victim to take the fall.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Nuit Mode", cost: 2, description: "The Kindred's body does not revert to it's death-state each night, enabling them to keep new haircuts and body modifications. They can mend these changes anytime as if they were Aggravated damage. This does not work for characters with BP higher than 1.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Object of Power (Minor)", cost: 1, description: "Reroll one die per story, excluding Hunger.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Object of Power (Moderate)", cost: 2, description: "Gain one bonus die to all Level 1 Ritual tests.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Object of Power (Major)", cost: 3, description: "Free premonition warning once per session, when someone will cause them harm.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // MARK: - Psychological
        BackgroundBase(name: "Unholy Will", cost: 2, description: "Add one die to any pool when resisting or contesting against an individual with True Faith when related to their faith. The character also suffers one less point of damage from holy sources.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Unholy Will (Enhanced)", cost: 4, description: "Add two dice to any pool when resisting or contesting against an individual with True Faith when related to their faith. The character also suffers two fewer points of damage from holy sources.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Soothed Beast", cost: 1, description: "With a SPC as an obsession, once per session they can ignore one Bestial or Messy Critical. Gain three Stains if they die.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "False Love", cost: 1, description: "With a SPC as an obsession, when in their presence treat the character's treat Humanity as one higher (Max 10) for purposes of using Blush of Life, eating, drinking, or sexual intercourse. Gain three Stains if they die.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Blood Ties
        BackgroundBase(name: "Consanguineous Sense", cost: 2, description: "You can detect whether another Kindred is in your direct bloodline. This does not tell you their Generation.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Consanguineous Influence", cost: 2, description: "You gain a bonus die when using Mental Disciplines on a vampire of your own Clan, or a direct descendant or ancestor. You gain 2 bonus dice instead on those within 2 generations of you such as your grandsire.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Sins of the Father", cost: 2, description: "You show no signs if you commit diablerie on a direct descendant or ancestor.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Sins of the Father (Enhanced)", cost: 3, description: "You show no signs if you commit diablerie on a direct descendant or ancestor. This extends to all members of your clan.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Other
        BackgroundBase(name: "Check the Trunk", cost: 1, description: "Easy access to an armory or cache of tools, none of these items can exceed the value of something a Resources 2 character could access. Add two dice to Preperation Rolls.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Side Hustler", cost: 2, description: "Once per session they can get their hands on an item, information, or access to an event as if they had two dots in the related Resources, Contacts, or Influence.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Tempered Will", cost: 3, description: "They are always aware when someone is attempting to use Dominate or Presence against them. They may add two additional dice to resistance pools once per session, which can only be taken by those with no dots in Dominate or Presence.", suitableCharacterTypes: [.vampire, .ghoul]),
        BackgroundBase(name: "Untouchable", cost: 5, description: "Once per story they are able to escape all official punishment for a crime that would otherwise see them destroyed.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Caitiff Only
        BackgroundBase(name: "Favored Blood", cost: 4, description: "Be able to purchase any Discipline even if they've never tasted the vitae of another vampire who has it. Cannot be taken with the Muddled Blood Flaw.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Mark of Caine", cost: 2, description: "Gain two bonus dice on any attempt to intimidate or bully other vampires who believe in the myth of Caine. Anyone who attempts diablerie on the Caitiff cannot add their Blood Potency to the roll and failure results in a Bestial fail.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Mockingbird", cost: 3, description: "For one night, if they've drank the Blood from another vampire, the Caitiff may utilize one of the Disciplines the vampire possesses. It cannot be a level higher than the Caitiff's own highest Discipline, it is rolled like a normal power except in powers that require a roll the Caitiff uses the donor's Discipline level and Caitiff's attributes.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Sun-Scarred", cost: 5, description: "The first turn of being exposed to sunlight take no Health damage, take 1 Aggravated Willpower damage, and automatically succeed on terror Frenzy. For the remainder of the scene, all damage from the sun is converted into Superficial damage.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Uncle Fangs", cost: 3, description: "They have easy access to a local coterie of three to five thin-bloods, and treat this group as Allies even though they are undead. Cannot be taken with Liquidator.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Thin-Blood Only  
        BackgroundBase(name: "Anarch Comrades", cost: 1, description: "Befriended an Anarch group, and act as a one-dot Anarch Mawla.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Camarilla Contact", cost: 1, description: "Caught the attention of someone within the Camarilla, acts as a one-dot Camarilla Mawla.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Catenating Blood", cost: 2, description: "Can create Blood Bonds and embrace other thin-bloods.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Day Drinker", cost: 2, description: "Able to walk in the sun. Sunlight halves their Health Tracker (rounded up) and removes all vampiric abilities.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Discipline Affinity", cost: 2, description: "Natural ability for one Discipline. Gain one dot and can retain additional levels at the experience cost of out-of-clan. Consuming matching resonance does not reward them with extra temporary dots.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Lifelike", cost: 2, description: "Has a heartbeat, can eat food, and enjoy sexual activities. Most medical checks reveal nothing, as long as it's during the night.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Thin-blood Alchemist", cost: 2, description: "Gain one dot and one formula of Thin-blood Alchemy.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Vampiric Resilience", cost: 2, description: "Take damage like a regular vampire.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Abhorrent Blood", cost: 2, description: "With Blood so disgusting any vampire who attempts to drink from them must spend two points of Willpower each turn. Mortals and Thin-blood Alchemy are not affected by this.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Faith-Proof", cost: 1, description: "They are too close to mortality for True Faith to affect them.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Low Appetite", cost: 1, description: "When waking up at sunset with Hunger 0 or 1, roll two dice on the Rouse Check and take the highest between the two.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Lucid Dreamer", cost: 1, description: "Once per session, they can receive a clue from the previous night's memories or a hint about the story.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Mortality's Mien", cost: 2, description: "Appearing more mortal than most vampires their vampiric nature cannot be detected through auras. In addition, receive two dice in any attempt to make yourself appear mortal in other methods such as makeup.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Swift Feeder", cost: 1, description: "Able to slake one Hunger in one turn as well as lick the wound closed. This can only be used once per scene.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Ghouls Only
        BackgroundBase(name: "Blood Empathy", cost: 2, description: "The ghoul can feel if their regnant is in danger or otherwise, needs them immediately, this does not allow for telepathic communication.", suitableCharacterTypes: [.ghoul]),
        BackgroundBase(name: "Unseemly Aura", cost: 2, description: "Their aura has become indistinguishable from a Kindred.", suitableCharacterTypes: [.ghoul]),
        
        // MARK: - Cults
        BackgroundBase(name: "Apocryphal Texts", cost: 1, description: "The character possesses writings from one of the church's leaders or prominent figures. On applicable rolls gain two dice Intelligence rolls. As a 1 dot optional flaw that can come with this merit the Willpower damage modifier for social combat is increased by 1.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Inspired Artist", cost: 2, description: "When using the cult's symbols or message in art, add a 1-die penalty to onlookers to resist Social rolls from cult members.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Traveling Preacher", cost: 2, description: "Having spread the cult's message where they go, reduce the difficulty on rolls to avoid the Second Inquisition by 1.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Memories of the Fallen (Thin-bloods)", cost: 2, description: "On Blood Alchemy rolls related to Ashe, one rolled 10 counts as two 10s. Two rolled 10s still count as four.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Streamer", cost: 2, description: "Once per story, the character can call upon their fanbase to perform something simple and nonviolent for them.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Dark Mother's Song", cost: 2, description: "Add three dice in Manipulation rolls when convincing others to worship Lilith.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Fire Resistant", cost: 1, description: "Convert Aggravated Health damage from fire to Superficial Health damage equal to their Blood Potency for one Rouse Check instead of three during daysleep.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Vigilant", cost: 2, description: "The character knows when they are being watched unless it's through supernatural means, they still must roll to know who and where from.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Fixer", cost: 2, description: "Once per story, call in a favor or threaten a former client.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Go to Ground", cost: 1, description: "Add two dice on rolls when evading pursuit.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Insidious Whispers", cost: 2, description: "When making a Social roll to undermine a Conviction, one rolled 10 counts as two 10s. Two rolled 10s still count as four.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Gematria", cost: 1, description: "The ability to understand a coded cipher allowing both encrypting and decrypting messages.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Bull-Slayer", cost: 3, description: "During Extended Tests, The character can reroll up to three regular dice without spending Willpower once per scene.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Bargainer", cost: 1, description: "Reduce the Difficulty to assess a transaction by 1.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Archangel's Grace", cost: 2, description: "Replace the Athletics Skill with the Performance Skill or vice versa when doing something akin to heavy cardio.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Mask (1)", cost: 1, description: "A fake identity that allows the vampire to keep their true selves away from mortal's prying eyes, including getting bank accounts, a birth certificate and everything else a vampire might need to masquerade as a human.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Mask (2)", cost: 2, description: "A fake identity that allows the vampire to keep their true selves away from mortal's prying eyes, including getting bank accounts, a birth certificate and everything else a vampire might need to masquerade as a human.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Zeroed", cost: 1, description: "All of the character's past self has been purged from all systems as if they never existed. The character must have a 2-dot mask in order to take this.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Cobbler", cost: 1, description: "The ability to create or source out masks. Making a mask takes 3 days per dot. The character must have a 2-dot mask in order to take this.", suitableCharacterTypes: [.vampire]),
        
        BackgroundBase(name: "Capacious Avatar", cost: 2, description: "Your Avatar is unusually capacious. Your capacity for Quintessence Empowerment is equal to one more than normal.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Mighty Avatar", cost: 4, description: "Your Avatar is especially mighty. Your capacity for Quintessence Empowerment is equal to two more than normal.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Avatar Resonance (2)", cost: 2, description: "Your resonance is especially in tune with your dominant emotion. Whether it is kindness, hate, anger, sadness, or curiosity. When you pick this merit pick an emotion, typically one tied to your Essence. When you are in severely affected by this emotion you may choose to gain a bonus of +1 on any casting rolls, however after you do this you must immediately make a Disassociation Roll with a penalty equal to the number of times you have used this this chapter as the paradox and your emotion mix.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Avatar Resonance (4)", cost: 4, description: "Your resonance is especially in tune with your dominant emotion. Whether it is kindness, hate, anger, sadness, or curiosity. When you pick this merit pick an emotion, typically one tied to your Essence. When you are in severely affected by this emotion you may choose to gain a bonus of +2 on any casting rolls, however after you do this you must immediately make a Disassociation Roll with a penalty equal to the number of times you have used this this chapter as the paradox and your emotion mix.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Brutal Avatar", cost: 2, description: "+1 to your Spellcasting rolls. All rolls to counterspell your magic gain 2 dice provided they are capable of counterspelling.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Beast Affinity", cost: 1, description: "Animals are unusually drawn to you, although you can’t speak to them you can communicate on a limited level based on body language and tone. One specific type of animal is affected (i.e. Crows).", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Beast Kinship", cost: 2, description: "Animals are unusually drawn to you, although you can’t speak to them you can communicate on a limited level based on body language and tone. One specific group of animal is affected (i.e. Birds).", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Beast Mastery", cost: 3, description: "Animals are unusually drawn to you, although you can’t speak to them you can communicate on a limited level based on body language and tone. All natural animals are affected.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Beast Mastery", cost: 5, description: "Animals are unusually drawn to you, although you can’t speak to them you can communicate on a limited level based on body language and tone. Even super natural animals are affected by your aura, although it only covers non-sapient creatures.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Combat Tool", cost: 2, description: "Your character has studied extensively in akashayana Do, magical swords, hypertech gun, ecstatic dance or in another skill that can be used as a magickal tool. This allows her to use combat techniques as Tools for instant spells. When taking this Merit, choose a Skill, which your character must have three or more dots in. This Merit allows use of that Skill in combat as a Tool, adding dice to a spell cast on subsequent turns, or to a spell cast reflexively in the same turn as the combat action. You may purchase this Merit multiple times to reflect the other styles.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "True Grit", cost: 3, description: "You refuse to go down in a fight extends beyond the limits of normal human bodies. You may take a point of aggravated will power damage to temporarily gain 3 health boxes that disappear at the end of the scene. Any damage in them is shifted to your remaining health when they are removed, this can result in superficial converting to aggravated, and can cause you to keel over and die when the fighting ends.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Eidetic Memory", cost: 2, description: "Your memory is picture perfect. You roll all memory checks at up to plus 3 depending on visual element and may remember forgettable visual details.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
       BackgroundBase(name: "Paradox Magnet", cost: 2, description: "Your memory is picture perfect. You roll all memory checks at up to plus 3 depending on visual element and may remember forgettable visual details.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Paradoxical Dispersal", cost: 2, description: "Whenever you lose Paradox without Backlashing you lose an extra point of paradox for each 10 rolled.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Feel The Burn", cost: 3, description: "Whenever someone suffers Burn nearby you may spend a number of Will power points to take that much Burn instead of the target. You may use this a maximum of once per story.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Paradox Magnet", cost: 2, description: "Your memory is picture perfect. You roll all memory checks at up to plus 3 depending on visual element and may remember forgettable visual details.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Quickening", cost: 3, description: "You can maintain 1 extra spell per penalty over normal before increasing your penalty.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Branch Sect", cost: 1, description: "This individual’s sect is incredibly similar to a specific sect with whom they are currently considered as ‘Different’. Treat them as part of that sect for the purposes of multi-casting penalties. Cannot be bought by non- Disparate sects.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Branch Sect", cost: 1, description: "This individual’s sect is incredibly similar to a specific sect with whom they are currently considered as ‘Different’. Treat them as part of that sect for the purposes of multi-casting penalties. Cannot be bought by non- Disparate sects.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Compatible Sect", cost: 2, description: "This individual’s sect is compatible in its methods with a certain faction outside of its own. Treat them as ‘Different’ instead of ‘Radically Different’ with the selected sect fac tion. Cannot be bought by non-Disparate sects.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Umbral Sight", cost: 3, description: "You instinctively recognize spirits from the Umbral, you gain an additional 3 to your dice pool when rolling to recognize spirits from the Umbra and you may make awareness tests to pierce their veils and deceit even when you would normally require the Spirit sphere to do so.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Stomping Ground", cost: 1, description: "You know your do main (no more than a half dozen city blocks) like the back of your hand. Roll one more die any time you roll for any test related to local knowledge.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "My City", cost: 3, description: "Cab drivers come to you for directions. In your domain (up to the size of a major city) you gain an automatic success in addition to your roll anytime you roll for a test related to local knowledge.", suitableCharacterTypes: [.mage]),
       BackgroundBase(name: "Iron Will", cost: 5, description: "When rolling Willpower tests, you do so ignoring superficial willpower damage.", suitableCharacterTypes: [.mage])
        ]
    
    // Predefined V5 Flaws with costs (negative values as they give points back) - Comprehensive Flaw System
    static let predefinedFlaws = [
        // MARK: - Linguistics
        BackgroundBase(name: "Illiterate", cost: -2, description: "The Character cannot read nor write and their Science and Academics Skills may not go beyond 1 dot.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // MARK: - Looks
        BackgroundBase(name: "Ugly", cost: -1, description: "Lose one die from related Social pools", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Repulsive", cost: -2, description: "Lose two dice from related Social pools", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Stench", cost: -1, description: "Their breath and body odor are supernaturally foul. Lose one die from seduction and similar Social pools, and lose two from Stealth pools unless they are upwind.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Transparent", cost: -1, description: "Unable to lie due to a terrible poker face or a strong urge to be truthful. Lose one die in any pools requiring Subterfuge, they cannot take any dots in Subterfuge either.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Unblinking Visage", cost: -2, description: "Treat Humanity as two lower (Min 0) when using Blush of Life, eating, drinking, or sexual intercourse.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Substance Use
        BackgroundBase(name: "Addiction", cost: -1, description: "Unless the action is to immediately gain their drug, lose one die to all pools if the last feeding was not on the drug of their choice.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Hopeless Addiction", cost: -2, description: "Unless the action is to immediately gain their drug, lose two dice to all pools if the last feeding was not on the drug of their choice.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Archaic Flaws
        BackgroundBase(name: "Living in the Past", cost: -1, description: "Unable to grasp modern society's mindset, one or more of the character's convictions reflect outdated views.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Archaic", cost: -2, description: "Cannot use computers, cellphones, and the character's Technology rating is always 0.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Grief Phobia", cost: -1, description: "Lose one die to all tests made while in the presence of a phobic stimulus.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Old Tricks", cost: -1, description: "All specialties are required to be Archaic.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Bonding
        BackgroundBase(name: "Bond Junkie", cost: -1, description: "The bond is sweeter to the character, they lose one die when acting against Blood Bonds.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Long Bond", cost: -1, description: "Bonds fade slower, decreasing by one level every 3 months without reinforcement.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Bondslave", cost: -2, description: "Bond instantly to another kindred with just one drink, not three.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Supernatural
        BackgroundBase(name: "Two Masters", cost: -1, description: "Be Blood Bound to two individuals at the same time.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Feeding
        BackgroundBase(name: "Prey Exclusion", cost: -1, description: "Unable to feed from a certain group and take Stains as if breaking a Chronicle Tenet when they do.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Methuselah's Thirst", cost: -1, description: "Hunger can only be slaked to 0 by Supernatural blood.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Farmer", cost: -2, description: "Must spend 2 Willpower Points to feed on human blood. Ventrue may not take this.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Organovore", cost: -2, description: "Slake only by consuming human flesh and organs.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Vein Tapper", cost: -1, description: "Finding the act of feeding to be personal, they go out of their way to feed from the unaware, drugged or unconscious victims.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Outdated Preference", cost: -2, description: "Either capture and force mortals to adhere to their wanted preference, or always spend 1 WP to feed.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Mythic
        BackgroundBase(name: "Folkloric Bane", cost: -1, description: "Take Aggravated Damage when touching a specific object rooted in vampire mythos of what harms them, example Silver.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Folkloric Block", cost: -1, description: "Must spend Willpower or move away from a specific object vampires are known to fear in Vampire Mythos, example Holy Symbols.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Stigmata", cost: -1, description: "Bleed from wounds on the hands, feet, and forehead when at Hunger 4.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Stake Bait", cost: -2, description: "When staked they meet Final Death.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Starving Decay", cost: -2, description: "When their Hunger is 3 or higher their body shrivels and decays. Take a two-dice penalty to Physical tests, and social interactions with mortals, this Flaw can risk the Masquerade.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Twice Cursed", cost: -2, description: "Take the Clan's variant Bane in addition to the regular Bane. The Storyteller can prohibit this flaw if the second Bane wouldn't mesh with the chronicle.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Psychological
        BackgroundBase(name: "Beacon of Profanity", cost: -1, description: "Mortals with any amount of True Faith can sense your presence, regardless of True Faith level.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Crisis of Faith", cost: -1, description: "Whenever there is a bestial failure, take one point of superficial Willpower damage in addition to other outcomes.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Horrible Scars of Penitence", cost: -1, description: "This flaw is equivalent to Repulsive when around those not within the cult.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Groveling Worm", cost: -2, description: "The character must find the time to scourge their own flesh once per session for two points of Superficial Health damage or they suffer one point of Aggravated Willpower damage at the next session. Cannot be taken with Penitence Merit.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Contagion
        BackgroundBase(name: "Disease Vector", cost: -1, description: "When feeding from a sick mortal, the illness is always contracted and will be passed onto the next vessel.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Plaguebringer", cost: -1, description: "The Kindred carries a disease that cannot be removed from their vitae. At one dot the disease is minor with visible traces.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Plaguebringer (Enhanced)", cost: -2, description: "The Kindred carries a disease that cannot be removed from their vitae. The disease can be potentially fatal if not treated. It is passed through the bite.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Diablerie
        BackgroundBase(name: "Blatant Diablerist", cost: -1, description: "Powers and Merits capable of sensing Diablerie will always reveal evidence of Diablerie even if the test would otherwise fail to show any information.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Inherited Bane", cost: -2, description: "You gain another Clan's Bane in addition to your own. Tremere can use this Flaw to gain the Salubri's Bane without commiting Diablerie.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Other
        BackgroundBase(name: "Knowledge Hungry", cost: -1, description: "At character creation pick a topic that your character desires to study. When they come across the methods to learn these things, they must make a Willpower roll at Difficulty 3 to resist.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Prestation Debts", cost: -1, description: "They owe other Kindred boons, even if these boons are paid off the Kindred lords over them. The Boon-owning Kindred keeps a one-die bonus in Social combat against the one who owes it.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Risk-Taker", cost: -1, description: "When confronted with a risky temptation that the character hasn't done before, they suffer a two-dice penalty for all actions till they participate or the scene ends.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Weak-Willed", cost: -2, description: "Even when they are aware that someone is attempting to sway they may not use the active resistance systems to avoid the attempts.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        // MARK: - Caitiff Only
        BackgroundBase(name: "Befouling Vitae", cost: -2, description: "Any mortal they Embrace or kill by feeding returns as a wight within a few nights.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Clan Curse", cost: -2, description: "They suffer a Clan Bane of their choice, likely from their sire, with its severity halved and rounded down. (Minimum of 1)", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Debt Peon", cost: -2, description: "They owe boons to a high-status vampire, even when paid off they will find new ways to have leverage over the Caitiff. The vampire owed the boons gains a two-dice bonus to Social combat against the Caitiff when in front of other Kindred.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Liquidator", cost: -1, description: "Take a two-dice penalty to all your Social skill dice pools against thin-bloods except for Intimidation rolls. Cannot be taken with the Uncle Fangs Merit.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Muddled Blood", cost: -1, description: "Even if they possess the Discipline, they must drink the Blood of someone who possesses it in order to buy dots. Cannot be taken with the Favored Blood Merit.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Walking Omen", cost: -2, description: "Scrying, premonition, and other forms of future telling point to the Caitiff as the source of misfortune, how this Flaw functions in play is ultimately up to the Storyteller.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Word-Scarred", cost: -1, description: "The Caitiff body is covered to some degree with ancient vampiric lore text. The extent of what this Flaw does in play is up to the player(s) and Storyteller.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Thin-Blood Only
        BackgroundBase(name: "Shunned by the Anarchs", cost: -1, description: "They've done something and the Anarch shun them, more likely to throw them to the Camarilla than help. Cannot take Anarch Comrades with this Flaw.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Branded by the Camarilla", cost: -1, description: "An unhealable and painful brand given by the Camarilla to know what they are. Can take Camarilla Contact with this Flaw.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Bestial Temper", cost: -1, description: "Frenzy test as normal vampire rules", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Vitae Dependency", cost: -2, description: "Must slake one hunger of vampire vitae each week else they'll lose access to all their vampiric powers.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Dead Flesh", cost: -1, description: "Medical inspections will report them as deceased and take a one-die penalty to face-to-face Social tests with a mortal. Cannot take Lifelike with this Flaw.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Baby Teeth", cost: -1, description: "Never developed fangs, or grew ones that were not sharp enough to break the skin.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Mortal Frailty", cost: -2, description: "Mend like a mortal, unable to rouse the blood. Cannot take Vampiric Resilience with this Flaw.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Heliophobia", cost: -1, description: "Fear sunlight as if a full vampire, terror Frenzy from sunlight.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Night Terrors", cost: -1, description: "Once per session suffer from night terrors and receive a one-die penalty for all actions for the rest of the scene.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Plague Bearers", cost: -2, description: "Still susceptible to mortal illnesses, whenever they feed they have a chance to catch a sickness by rolling a die and it lands on '1'. Mortal medicine does not heal you, only slaking from a healthy immune system to Hunger 0 does.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Sloppy Drinker", cost: -1, description: "When feeding make a Dex + Medicine test against a Difficulty equal to the amount of Hunger slaked. On a failure, the wound is too ragged to close and the victim may bleed out from the Masquerade-threatening wound.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Sun-Faded", cost: -2, description: "Alchemy and Disciplines are unusable in the sunlight, but can be used inside at a two-dice penalty during the day so long as they are away from any sunlight.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Supernatural Tell", cost: -2, description: "Something about them makes them easy to spot for supernatural creatures. Lose two dice from Stealth pools and similar against other supernatural creatures.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Twilight Presence", cost: -1, description: "Mortals don't want to be around them and even other Kindred find them more unpleasant than other thin-bloods. Lose one die from Social pools involving others except for other thin-bloods who can adjust to their strange demeanor.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Unending Hunger", cost: -1, description: "When feeding in a scene, slake one Hunger less, this only applies once per scene.", suitableCharacterTypes: [.vampire]),
        
        // MARK: - Ghouls Only
        BackgroundBase(name: "Baneful Blood", cost: -1, description: "The character experiences the bane of their first domitor, this does not change if they get a new domitor. The domitor must be of Clan Lasombra, Malkavian, Ministry, Nosferatu, Ravnos, Salubri, or Toreador.", suitableCharacterTypes: [.ghoul]),
        BackgroundBase(name: "Baneful Blood (Enhanced)", cost: -2, description: "The character experiences the bane of their first domitor more severely, this does not change if they get a new domitor. The domitor must be of Clan Lasombra, Malkavian, Ministry, Nosferatu, Ravnos, Salubri, or Toreador.", suitableCharacterTypes: [.ghoul]),
        BackgroundBase(name: "Crone's Curse", cost: -2, description: "The character appears at least a decade older than they actually are which reduces their health tracker by one.", suitableCharacterTypes: [.ghoul]),
        BackgroundBase(name: "Distressing Fangs", cost: -1, description: "Having developed fangs like kindred, the character suffers one die on Social pools with mortals.", suitableCharacterTypes: [.ghoul]),
        
        // MARK: - Cults
        BackgroundBase(name: "Excommunicated", cost: -1, description: "They've done something to be cast out. Subtract two dice from all rolls dealing with the cult.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Excommunicated (Enhanced)", cost: -2, description: "They've done something to be cast out. The cult actively seeks to destroy you in any way possible.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Faithless", cost: -2, description: "Being a member for the benefits instead of being a true believer. Lose two dice on rolls pertaining to the Cult from Resolve and Composure rolls.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Ashe Addiction", cost: -2, description: "In addition to the Ashe rules in Cults of the Blood Gods, after a failed Blood Alchemy roll, take a two dice penalty for all actions till the session ends", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Schism (Lasombra)", cost: -1, description: "Suffer a two-dice penalty on Social rolls with members of your cult.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "False Alarm", cost: -1, description: "Every failed Awareness roll counts as a total failure.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Empty", cost: -1, description: "People attempt to remove themselves from the character's unnerving presence. Subtract two dice from Social rolls", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Failed Initiate", cost: -1, description: "The character faltered during the process of becoming a member, being assigned a guide who will interrupt plans, offer instruction, or demand the character prove themselves at any time.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Yearning", cost: -1, description: "Missing their master, they must spend two Willpower to work against their master's wishes.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Disliked", cost: -1, description: "Subtract one die from Social tests involving groups outside of the character's loyal followers.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Despised", cost: -2, description: "One group/region of the city goes out of its way to destroy the character's plans.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Obvious Predator", cost: -2, description: "A predatory vibe removes two dice from any hunting pool except Physical stalking, chasing, and killing. Lose on die from any Social test intended to calm humans. Cannot maintain a Herd.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Known Corpse", cost: -1, description: "People know the vampire died recently and react in turn if they see them.", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Known Blankbody", cost: -2, description: "The character's name, history, associates, and more are all in several agency databases. Inquisition can recognize them as a vampire.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Shameful Childe", cost: -1, description: "Embraced a childe but abandoned them", suitableCharacterTypes: [.vampire]),
        BackgroundBase(name: "Touchstone Embraced by your Enemies", cost: -2, description: "A former Touchstone didn't die or change as a person, someone Embraced them. This is a single Neonate, but they have allies and confrontation carries the risk of Stains.", suitableCharacterTypes: [.vampire, .ghoul]),
        BackgroundBase(name: "Destitute", cost: -1, description: "No money, no home, and no monetary value beyond themselves.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Stalkers", cost: -1, description: "Something about the character tends to attract others who get a little bit too attached and just won't let go. Be it a former retainer or a past lover, should they get rid of them, another soon appears.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Suspect", cost: -1, description: "Breaking the rules or weaseling out of something owed has netted this character the ire of this Sect. Stay out of sight and mind and nothing will happen until they prove their worth again but until then take a 2 dice penalty to Social tests with the offended Factions.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        BackgroundBase(name: "Shunned", cost: -2, description: "Despised by a Sect, a line was crossed that never should have been, and now members of this group actively work against them at any opportunity.", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
        BackgroundBase(name: "Limited Avatar", cost: -2, description: "Your Avatar is poor. Your capacity for Quintessence Empowerment is equal to one less than normal.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Bard’s Tongue", cost: -2, description: "Things you say sometime become true in unfortunate ways. The Storyteller should use this to hamper your character with ill fortune but not necessarily directly imperil you.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Curiosity", cost: -1, description: "Your curiosity overrides your common sense. Resisting temptation requires a successful Wits + Resolve (2) check.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Slight Curse", cost: -1, description: "Tech fails around you, traffic jams occur whenever you drive, tires go flat.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Moderate Curse", cost: -2, description: "Your car breaks down when you need it, your expensive clothes end up stained, and tools break when you use them.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Severe Curse", cost: -3, description: "Accidents happen frequent to you, your bank account and internet accounts are frequently hacked, you keep getting your wallet and phone stolen, and driving anywhere is a risk.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Slight Echoes", cost: -1, description: "Animals shy away from you, milks sours in your presence, a strange smell appropriate to your nature follows and proceeds you or similar. Sensitive people might get odd feelings around you. Typically, this will be associated with your Affinity Sphere.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Slight Echoes", cost: -2, description: "People who know what to look for recognize you on sight. Flowers loom or wither in your presence or music echoes through the air. Holy or unholy symbols repulse you and might force you to make a willpower check.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Major Echoes", cost: -3, description: "Even sleepers notice how you stand out. Your shadow moves of its own accord, you don’t cast reflections, cold winds follow you, or people feel nauseous in your presence. People who know folklore might know the precautions to take (Intelligence + Occult maybe used to counterspell against you, Resolve + Occult vs your Willpower may be used to keep you at bay physically).", suitableCharacterTypes: [.mage]),
        
        BackgroundBase(name: "Folkloric Bane - Fire", cost: -3, description: "Fire burns you more than most. When using mystical methods to avoid, reduce, or otherwise diminish flames you roll 1 less dice and all flame-based attacks deal 1 extra point of aggra-vated damage against you.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Folkloric Bane - Threshold (1)", cost: -1, description: "When crossing into private property where someone lives you lose 1 Arete while there unless explicitly invited by someone who lives there.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Folkloric Bane - Threshold (2)", cost: -2, description: "When crossing into private property where someone lives you lose 2 Arete while there unless explicitly invited by someone who lives there.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Folkloric Bane - Threshold (3)", cost: -3, description: "When crossing into private property where someone lives you lose 3 Arete while there unless explicitly invited by someone who lives there.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Folkloric Bane - Running Water", cost: -2, description: "Standing over bodies of water causes your magic to seep away in proportion to the volume and speed at which it is flowing. In game terms you take a penalty to your Arete: around 1 for a small stream, heavy rain or sewers, 2 for a small sedate river, torrential rain or deep lake, 4 for a major rushing river or deep ocean and 5 for Niagara Falls. If this penalty reduces your Arete to 0 or below you may not cast and any ongoing spells you are maintaining end.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Folkloric Bane - Sleeper Bane", cost: -2, description: "Mundane humans are your downfall. Sleepers count as having rolled 1 success more with any successful attack against you and your mystical methods of reducing the damage reduce it by 1 less.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Haunted", cost: -3, description: "A wraith plagues you for some reason and makes your life hell. It can possess you or people you know, slam doors, twist your dreams, and throw things around.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Lifesaver", cost: -3, description: "You refuse to kill under even the most significant or dire of circumstances, or work directly with people who do. When you or your allies kill another human or partly human, being permanently lose 1 point of Willpower until the end of the chronicle. The storyteller may rule that excessive torture or similar will count for this too.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Love", cost: -1, description: "There is someone you would do anything to protect. You must spend willpower to roll Willpower (dificulty 3) to resist protecting or defending them via the most direct means possible.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Bloodthirsty", cost: -2, description: "You enjoy killing. Whenever you are faced with the chance to kill someone you must succeed on a Willpower (difficulty 2) roll not to.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Masochist", cost: -1, description: "Take –1 to all rolls when you have no physical damage and +1 when you have half your health left (rounded up) or less.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Permanent Paradox (2)", cost: -2, description: "You’ve caused some serious backlash in the past and you have 1 points of paradox that can never be removed for any reason.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Permanent Paradox (2)", cost: -5, description: "You’ve caused some serious backlash in the past and you have 2 points of paradox that can never be removed for any reason.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Painful Paradox", cost: -2, description: "Regardless of the reason, burn damage you cause due to backlash is always physical.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Phylactery", cost: -3, description: "Your avatar is trapped and sealed in an object for some reason. You may only cast spells when this object is on your immediate person.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Divergent Sect", cost: -3, description: "The individual’s sect uses techniques similar to either the Technocracy or the Traditions, allowing them to multi-cast with the group (treat ‘Radically Different Sect’ as just ‘Different Sect’). However, their techniques have diverged from most mainstream sects of his faction. Any multicast with other sects they are part of takes a –1 penalty. Cannot be bought by non-Disparate sects.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Insular", cost: -1, description: "You rarely leave your domain (no larger than a half dozen city blocks). Roll one less die anytime you roll for any test related to local knowledge.", suitableCharacterTypes: [.mage]),
        BackgroundBase(name: "Weak Willed", cost: -1, description: "You permanently have a point of aggravated willpower damage that may not be removed under any circumstance.", suitableCharacterTypes: [.mage]),
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
        CharacterBackgroundDefinition(name: "Bond resistance", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Allies", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Contacts", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "City Secrets", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Domain", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Demesne", suitableCharacterTypes: [.mage]),
        CharacterBackgroundDefinition(name: "Enhancement", suitableCharacterTypes: [.mage]),
        CharacterBackgroundDefinition(name: "Fame", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Familiar", suitableCharacterTypes: [.mage]),
        CharacterBackgroundDefinition(name: "Gardener", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Haven", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Influence", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Herd", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Linguistics", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Mawla", suitableCharacterTypes: [.vampire]),
        CharacterBackgroundDefinition(name: "Penitence", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Resources", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Retainers", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Requisitions", suitableCharacterTypes: [.mage]),
        CharacterBackgroundDefinition(name: "Status", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "True Faith", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Wonder", suitableCharacterTypes: [.mage]),
        CharacterBackgroundDefinition(name: "Zealotry", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
    ]
    
    static let characterBackgroundFlawDefinitions = [
        CharacterBackgroundDefinition(name: "Adversary", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Banned From", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Dark Secret", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Enemy", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Infamy", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        CharacterBackgroundDefinition(name: "Secret Master", suitableCharacterTypes: [.vampire, .ghoul, .mage]),
        
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
            description: "Feeds by brute force and intimidation, taking blood through violence and threats from whoever they can overpower.",
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
            description: "Feeds from preserved blood, corpses, or blood bags using Iron Gullet ability. Often works in hospitals or black market.",
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
            description: "Rejects mortal blood and feeds exclusively on other vampires through hunting, coercion, or payment.",
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
            description: "Feeds from close family and friends while maintaining normal relationships, hiding their vampiric nature.",
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
            description: "Never feeds without consent, using medical pretenses, kink communities, or open admission to gain permission.",
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
            description: "Feeds exclusively from animals, avoiding harming mortals despite the beast's hunger for human blood.",
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
            description: "Celebrity or cult leader who feeds from their devoted fans and worshippers, enjoying easy access but attracting problems.",
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
            description: "Feeds from sleeping victims using stealth and disciplines, preferring the safety of unconscious prey.",
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
            description: "Hunts within a specific subculture they belonged to in life, using their status and the disbelief of witnesses.",
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
            description: "Uses seduction and sexual attraction to lure victims, feeding during intimate encounters in clubs and nightlife.",
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
            description: "Trades protection services for blood, often using fabricated threats to make deals more appealing.",
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
            description: "Feeds from corpses and mourners around graveyards, morgues, and hospitals using Iron Gullet ability.",
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
            description: "Always on the move, hunts transients and travelers who won't be missed when they disappear.",
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
            description: "Hunts in hospice facilities and medical centers, feeding from those near death with specific disease preferences.",
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
            description: "Uses retainers to drive victims into carefully planned ambushes, following aristocratic Spanish hunting traditions.",
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
            description: "Stalks victims extensively, learning their routines before striking when no one will notice their absence.",
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
            description: "Builds elaborate lairs to lure victims inside, terrorizing or slowly draining them before release.",
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
            description: "Powerful enough to receive vessels as tribute from other Kindred, who deliver and maintain them.",
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
