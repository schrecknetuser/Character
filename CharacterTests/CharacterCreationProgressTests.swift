//
//  CharacterCreationProgressTests.swift
//  CharacterTests
//
//  Created by User on 17.07.2025.
//

import Testing
@testable import Character

struct CharacterCreationProgressTests {
    
    @Test func testCharacterCreationProgressInitialization() async throws {
        let character = VampireCharacter()
        
        // Test that new characters have proper creation progress defaults
        #expect(character.isInCreation == false)
        #expect(character.creationProgress == 0)
    }
    
    @Test func testCharacterStoreCreationMethods() async throws {
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Character"
        
        // Test adding character in creation
        store.addCharacterInCreation(character)
        
        let charactersInCreation = store.getCharactersInCreation()
        #expect(charactersInCreation.count == 1)
        #expect(charactersInCreation[0].character.isInCreation == true)
        #expect(charactersInCreation[0].character.creationProgress == 0)
        
        // Test that completed characters don't include characters in creation
        let completedCharacters = store.getCompletedCharacters()
        #expect(completedCharacters.count == 0)
    }
    
    @Test func testCharacterCreationProgressUpdate() async throws {
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Character"
        
        // Add character in creation
        store.addCharacterInCreation(character)
        
        // Update progress
        store.updateCharacterCreationProgress(character, stage: 3)
        
        let charactersInCreation = store.getCharactersInCreation()
        #expect(charactersInCreation.count == 1)
        #expect(charactersInCreation[0].character.creationProgress == 3)
    }
    
    @Test func testCharacterCreationCompletion() async throws {
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Character"
        
        // Add character in creation
        store.addCharacterInCreation(character)
        
        // Complete creation
        store.completeCharacterCreation(character)
        
        let charactersInCreation = store.getCharactersInCreation()
        #expect(charactersInCreation.count == 0)
        
        let completedCharacters = store.getCompletedCharacters()
        #expect(completedCharacters.count == 1)
        #expect(completedCharacters[0].character.isInCreation == false)
        #expect(completedCharacters[0].character.creationProgress == -1)
    }
    
    @Test func testCharacterCreationWithDifferentTypes() async throws {
        let store = CharacterStore()
        
        // Test vampire character
        let vampire = VampireCharacter()
        vampire.name = "Test Vampire"
        store.addCharacterInCreation(vampire)
        
        // Test mage character
        let mage = MageCharacter()
        mage.name = "Test Mage"
        store.addCharacterInCreation(mage)
        
        // Test ghoul character
        let ghoul = GhoulCharacter()
        ghoul.name = "Test Ghoul"
        store.addCharacterInCreation(ghoul)
        
        let charactersInCreation = store.getCharactersInCreation()
        #expect(charactersInCreation.count == 3)
        
        // Check that all are marked as in creation
        for character in charactersInCreation {
            #expect(character.character.isInCreation == true)
            #expect(character.character.creationProgress == 0)
        }
    }
    
    @Test func testCharacterCreationProgressPersistence() async throws {
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Character"
        
        // Add character in creation and update progress
        store.addCharacterInCreation(character)
        store.updateCharacterCreationProgress(character, stage: 5)
        
        // Create a new store to test persistence
        let newStore = CharacterStore()
        let charactersInCreation = newStore.getCharactersInCreation()
        
        #expect(charactersInCreation.count == 1)
        #expect(charactersInCreation[0].character.creationProgress == 5)
        #expect(charactersInCreation[0].character.isInCreation == true)
    }
}