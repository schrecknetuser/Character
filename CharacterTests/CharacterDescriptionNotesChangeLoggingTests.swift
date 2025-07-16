//
//  CharacterDescriptionNotesChangeLoggingTests.swift
//  CharacterTests
//
//  Created by User to test character description and notes change logging.
//

import Testing
@testable import Character

struct CharacterDescriptionNotesChangeLoggingTests {
    
    @Test func testVampireCharacterDescriptionChangesAreLogged() async throws {
        // Test that character description changes are logged for Vampire characters
        let original = VampireCharacter()
        original.name = "Test Vampire"
        original.clan = "Brujah"
        original.characterDescription = "Original description"
        original.notes = "Original notes"
        
        let updated = original.clone() as! VampireCharacter
        updated.characterDescription = "Updated description"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        // This should include the character description change but currently doesn't
        #expect(changeSummary.contains("character description"), "Character description changes should be logged")
    }
    
    @Test func testVampireCharacterNotesChangesAreLogged() async throws {
        // Test that notes changes are logged for Vampire characters
        let original = VampireCharacter()
        original.name = "Test Vampire"
        original.clan = "Brujah"
        original.characterDescription = "Test description"
        original.notes = "Original notes"
        
        let updated = original.clone() as! VampireCharacter
        updated.notes = "Updated notes"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        // This should include the notes change but currently doesn't
        #expect(changeSummary.contains("notes"), "Notes changes should be logged")
    }
    
    @Test func testGhoulCharacterDescriptionChangesAreLogged() async throws {
        // Test that character description changes are logged for Ghoul characters
        let original = GhoulCharacter()
        original.name = "Test Ghoul"
        original.characterDescription = "Original description"
        original.notes = "Original notes"
        
        let updated = original.clone() as! GhoulCharacter
        updated.characterDescription = "Updated description"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        // This should include the character description change but currently doesn't
        #expect(changeSummary.contains("character description"), "Character description changes should be logged")
    }
    
    @Test func testGhoulCharacterNotesChangesAreLogged() async throws {
        // Test that notes changes are logged for Ghoul characters
        let original = GhoulCharacter()
        original.name = "Test Ghoul"
        original.characterDescription = "Test description"
        original.notes = "Original notes"
        
        let updated = original.clone() as! GhoulCharacter
        updated.notes = "Updated notes"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        // This should include the notes change but currently doesn't
        #expect(changeSummary.contains("notes"), "Notes changes should be logged")
    }
    
    @Test func testMageCharacterDescriptionChangesAreLogged() async throws {
        // Test that character description changes are logged for Mage characters
        let original = MageCharacter()
        original.name = "Test Mage"
        original.characterDescription = "Original description"
        original.notes = "Original notes"
        
        let updated = original.clone() as! MageCharacter
        updated.characterDescription = "Updated description"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        // This should include the character description change but currently doesn't
        #expect(changeSummary.contains("character description"), "Character description changes should be logged")
    }
    
    @Test func testMageCharacterNotesChangesAreLogged() async throws {
        // Test that notes changes are logged for Mage characters
        let original = MageCharacter()
        original.name = "Test Mage"
        original.characterDescription = "Test description"
        original.notes = "Original notes"
        
        let updated = original.clone() as! MageCharacter
        updated.notes = "Updated notes"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        // This should include the notes change but currently doesn't
        #expect(changeSummary.contains("notes"), "Notes changes should be logged")
    }
    
    @Test func testEmptyToNonEmptyDescriptionChange() async throws {
        // Test logging when description changes from empty to non-empty
        let original = VampireCharacter()
        original.name = "Test Vampire"
        original.characterDescription = ""
        
        let updated = original.clone() as! VampireCharacter
        updated.characterDescription = "New description added"
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        #expect(changeSummary.contains("character description"), "Adding character description should be logged")
    }
    
    @Test func testNonEmptyToEmptyNotesChange() async throws {
        // Test logging when notes change from non-empty to empty
        let original = VampireCharacter()
        original.name = "Test Vampire"
        original.notes = "Some existing notes"
        
        let updated = original.clone() as! VampireCharacter
        updated.notes = ""
        
        let changeSummary = original.generateChangeSummary(for: updated)
        
        #expect(changeSummary.contains("notes"), "Clearing notes should be logged")
    }
}