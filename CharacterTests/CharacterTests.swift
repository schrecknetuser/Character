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
        
        // Check default condition tracking
        #expect(character.hunger == 1)
        #expect(character.health == 3)
        
        // Check that character traits are initialized properly
        #expect(character.advantages.isEmpty)
        #expect(character.flaws.isEmpty)
        #expect(character.convictions.isEmpty)
        #expect(character.touchstones.isEmpty)
        #expect(character.chronicleTenets.isEmpty)
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
    
    @Test func testAdvantageFlawCosts() async throws {
        // Test advantage and flaw cost calculations
        var character = Character(name: "Test", clan: "Brujah", generation: 12)
        
        // Add some advantages
        character.advantages = [
            Advantage(name: "Allies", cost: 3),
            Advantage(name: "Resources", cost: 3),
            Advantage(name: "Custom Advantage", cost: 2, isCustom: true)
        ]
        
        // Add some flaws
        character.flaws = [
            Flaw(name: "Enemy", cost: -1),
            Flaw(name: "Hunted", cost: -3),
            Flaw(name: "Custom Flaw", cost: -2, isCustom: true)
        ]
        
        // Test cost calculations
        #expect(character.totalAdvantageCost == 8) // 3 + 3 + 2
        #expect(character.totalFlawValue == -6) // -1 + -3 + -2
        #expect(character.netAdvantageFlawCost == 2) // 8 + (-6)
    }
    
    @Test func testPredefinedAdvantagesAndFlaws() async throws {
        // Test that predefined advantages and flaws exist
        #expect(!V5Constants.predefinedAdvantages.isEmpty)
        #expect(!V5Constants.predefinedFlaws.isEmpty)
        
        // Test that some expected advantages exist
        #expect(V5Constants.predefinedAdvantages.contains { $0.name == "Allies" })
        #expect(V5Constants.predefinedAdvantages.contains { $0.name == "Resources" })
        #expect(V5Constants.predefinedAdvantages.contains { $0.name == "Herd" })
        
        // Test that some expected flaws exist
        #expect(V5Constants.predefinedFlaws.contains { $0.name == "Enemy" })
        #expect(V5Constants.predefinedFlaws.contains { $0.name == "Hunted" })
        #expect(V5Constants.predefinedFlaws.contains { $0.name == "Dark Secret" })
        
        // Test that flaw costs are negative
        for flaw in V5Constants.predefinedFlaws {
            #expect(flaw.cost < 0)
        }
        
        // Test that advantage costs are positive
        for advantage in V5Constants.predefinedAdvantages {
            #expect(advantage.cost > 0)
        }
    }
}
