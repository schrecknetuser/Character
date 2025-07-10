//
//  CharacterTests.swift
//  CharacterTests
//
//  Created by User on 10.07.2025.
//

import Testing
@testable import Character

struct CharacterTests {

    @Test func testCharacterDefaultInitialization() async throws {
        // Test that a new character has proper V5 defaults
        let character = Character(name: "Test Character", clan: "Brujah", generation: 12)
        
        #expect(character.name == "Test Character")
        #expect(character.clan == "Brujah")
        #expect(character.generation == 12)
        
        // Check default attributes (should all be 1)
        #expect(character.physicalAttributes["Strength"] == 1)
        #expect(character.physicalAttributes["Dexterity"] == 1)
        #expect(character.physicalAttributes["Stamina"] == 1)
        
        #expect(character.socialAttributes["Charisma"] == 1)
        #expect(character.socialAttributes["Manipulation"] == 1)
        #expect(character.socialAttributes["Composure"] == 1)
        
        #expect(character.mentalAttributes["Intelligence"] == 1)
        #expect(character.mentalAttributes["Wits"] == 1)
        #expect(character.mentalAttributes["Resolve"] == 1)
        
        // Check default core traits
        #expect(character.bloodPotency == 1)
        #expect(character.humanity == 7)
        #expect(character.willpower == 3)
        #expect(character.experience == 0)
        #expect(character.spentExperience == 0)
        
        // Check character background
        #expect(character.ambition == "")
        #expect(character.desire == "")
        #expect(character.chronicleName == "")
        
        // Check default condition tracking
        #expect(character.hunger == 1)
        #expect(character.health == 3)
        
        // Check status tracking arrays
        #expect(character.healthStates.count == 3)
        #expect(character.willpowerStates.count == 3)
        #expect(character.humanityStates.count == 10)
        #expect(character.healthStates.allSatisfy { $0 == .ok })
        #expect(character.willpowerStates.allSatisfy { $0 == .ok })
        #expect(character.humanityStates.allSatisfy { $0 == .unchecked })
        
        // Check that skills default to 0
        #expect(character.physicalSkills["Athletics"] == 0)
        #expect(character.socialSkills["Persuasion"] == 0)
        #expect(character.mentalSkills["Academics"] == 0)
    }
    
    @Test func testHealthStateEnum() async throws {
        // Test that health state enum has correct cases
        let allCases = HealthState.allCases
        #expect(allCases.contains(.ok))
        #expect(allCases.contains(.superficial))
        #expect(allCases.contains(.aggravated))
        #expect(allCases.count == 3)
    }
    
    @Test func testHumanityStateEnum() async throws {
        // Test that humanity state enum has correct cases
        let allCases = HumanityState.allCases
        #expect(allCases.contains(.unchecked))
        #expect(allCases.contains(.checked))
        #expect(allCases.contains(.stained))
        #expect(allCases.count == 3)
    }
    
    @Test func testV5Constants() async throws {
        // Test that we have the right number of attributes and skills
        #expect(V5Constants.physicalAttributes.count == 3)
        #expect(V5Constants.socialAttributes.count == 3)
        #expect(V5Constants.mentalAttributes.count == 3)
        
        #expect(V5Constants.physicalSkills.count == 9)
        #expect(V5Constants.socialSkills.count == 9)
        #expect(V5Constants.mentalSkills.count == 9)
        
        // Test some specific attributes exist
        #expect(V5Constants.physicalAttributes.contains("Strength"))
        #expect(V5Constants.socialAttributes.contains("Charisma"))
        #expect(V5Constants.mentalAttributes.contains("Intelligence"))
        
        // Test some specific skills exist
        #expect(V5Constants.physicalSkills.contains("Athletics"))
        #expect(V5Constants.socialSkills.contains("Persuasion"))
        #expect(V5Constants.mentalSkills.contains("Academics"))
        
        // Test that major V5 disciplines are present
        #expect(V5Constants.disciplines.contains("Animalism"))
        #expect(V5Constants.disciplines.contains("Auspex"))
        #expect(V5Constants.disciplines.contains("Dominate"))
        
        // Test that major V5 clans are present
        #expect(V5Constants.clans.contains("Brujah"))
        #expect(V5Constants.clans.contains("Toreador"))
        #expect(V5Constants.clans.contains("Ventrue"))
    }
    
    @Test func testCharacterWithDisciplinesAndAdvantages() async throws {
        // Test a character with some disciplines and advantages/flaws
        let character = Character(
            name: "Test Vampire",
            clan: "Toreador",
            generation: 10,
            physicalAttributes: ["Strength": 2, "Dexterity": 4, "Stamina": 2],
            socialAttributes: ["Charisma": 4, "Manipulation": 3, "Composure": 3],
            mentalAttributes: ["Intelligence": 3, "Wits": 3, "Resolve": 2],
            physicalSkills: ["Athletics": 2, "Brawl": 1, "Craft": 0, "Drive": 1, "Firearms": 0, "Larceny": 3, "Melee": 1, "Stealth": 2, "Survival": 0],
            socialSkills: ["Animal Ken": 0, "Etiquette": 3, "Insight": 2, "Intimidation": 1, "Leadership": 2, "Performance": 4, "Persuasion": 3, "Streetwise": 1, "Subterfuge": 2],
            mentalSkills: ["Academics": 2, "Awareness": 3, "Finance": 1, "Investigation": 1, "Medicine": 0, "Occult": 1, "Politics": 2, "Science": 0, "Technology": 1],
            bloodPotency: 2,
            humanity: 6,
            willpower: 6,
            experience: 50,
            spentExperience: 35,
            disciplines: ["Auspex": 2, "Presence": 3, "Celerity": 1],
            advantages: ["Beautiful", "Resources (Wealth)"],
            flaws: ["Obsession (Art)", "Enemy (Rival Artist)"],
            convictions: ["Art must be preserved", "Beauty deserves immortality"],
            touchstones: ["Maria - Art Student", "Vincent - Gallery Owner"],
            chronicleTenets: ["Respect artistic expression"],
            hunger: 2,
            health: 6
        )
        
        // Verify the character data
        #expect(character.name == "Test Vampire")
        #expect(character.clan == "Toreador")
        #expect(character.physicalAttributes["Dexterity"] == 4)
        #expect(character.socialAttributes["Charisma"] == 4)
        #expect(character.mentalAttributes["Intelligence"] == 3)
        #expect(character.socialSkills["Performance"] == 4)
        
        // Verify disciplines
        #expect(character.disciplines["Auspex"] == 2)
        #expect(character.disciplines["Presence"] == 3)
        #expect(character.disciplines["Celerity"] == 1)
        #expect(character.disciplines.count == 3)
        
        // Verify advantages and flaws
        #expect(character.advantages.contains("Beautiful"))
        #expect(character.advantages.contains("Resources (Wealth)"))
        #expect(character.flaws.contains("Obsession (Art)"))
        #expect(character.flaws.contains("Enemy (Rival Artist)"))
        
        // Verify experience tracking
        #expect(character.experience == 50)
        #expect(character.spentExperience == 35)
        #expect((character.experience - character.spentExperience) == 15)
    }
}
