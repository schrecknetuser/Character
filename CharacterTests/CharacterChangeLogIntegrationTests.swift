//
//  CharacterChangeLogIntegrationTests.swift
//  CharacterTests
//
//  Created to test the complete change logging flow for character description and notes.
//

import Testing
@testable import Character

struct CharacterChangeLogIntegrationTests {
    
    @Test func testFullChangeLogIntegrationForVampireCharacter() async throws {
        // Test the complete flow from character editing to change log entry creation
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Integration Test Vampire"
        character.clan = "Ventrue"
        character.characterDescription = "Original vampire description"
        character.notes = "Original vampire notes"
        
        store.addCharacter(character)
        
        // Simulate entering edit mode (this is what happens in CharacterDetailView)
        let draftCharacter = character.clone() as! VampireCharacter
        
        // Make changes to description and notes
        draftCharacter.characterDescription = "Updated vampire description with new details"
        draftCharacter.notes = "Updated notes with session information"
        
        // Simulate saving changes (this is what happens when Save is pressed)
        let changeSummary = character.generateChangeSummary(for: draftCharacter)
        
        #expect(!changeSummary.isEmpty, "Change summary should not be empty when description and notes are changed")
        #expect(changeSummary.contains("character description updated"), "Change summary should include character description update")
        #expect(changeSummary.contains("notes updated"), "Change summary should include notes update")
        
        // Simulate the complete save flow
        let initialLogCount = character.changeLog.count
        
        if !changeSummary.isEmpty {
            let logEntry = ChangeLogEntry(summary: changeSummary)
            draftCharacter.changeLog.append(logEntry)
        }
        
        // Verify the change log was updated correctly
        #expect(draftCharacter.changeLog.count == initialLogCount + 1, "Change log should have one new entry")
        
        let lastLogEntry = draftCharacter.changeLog.last
        #expect(lastLogEntry != nil, "Last log entry should exist")
        #expect(lastLogEntry!.summary.contains("character description updated"), "Log entry should mention character description")
        #expect(lastLogEntry!.summary.contains("notes updated"), "Log entry should mention notes")
        
        // Verify timestamp is recent
        let timeDifference = Date().timeIntervalSince(lastLogEntry!.timestamp)
        #expect(timeDifference < 60.0, "Log entry timestamp should be recent")
    }
    
    @Test func testNoChangeLogEntryWhenNoChanges() async throws {
        // Test that no log entry is created when description and notes are unchanged
        let character = VampireCharacter()
        character.name = "No Changes Test"
        character.characterDescription = "Same description"
        character.notes = "Same notes"
        
        let draftCharacter = character.clone() as! VampireCharacter
        // Don't change description or notes
        
        let changeSummary = character.generateChangeSummary(for: draftCharacter)
        
        #expect(changeSummary.isEmpty, "Change summary should be empty when no changes are made")
    }
    
    @Test func testOnlyDescriptionChangeLogged() async throws {
        // Test that only description change is logged when only description changes
        let character = GhoulCharacter()
        character.name = "Description Only Test"
        character.characterDescription = "Original description"
        character.notes = "Unchanged notes"
        
        let draftCharacter = character.clone() as! GhoulCharacter
        draftCharacter.characterDescription = "Changed description"
        // Keep notes the same
        
        let changeSummary = character.generateChangeSummary(for: draftCharacter)
        
        #expect(!changeSummary.isEmpty, "Change summary should not be empty")
        #expect(changeSummary.contains("character description updated"), "Should log description change")
        #expect(!changeSummary.contains("notes updated"), "Should not log notes change when notes unchanged")
    }
    
    @Test func testOnlyNotesChangeLogged() async throws {
        // Test that only notes change is logged when only notes changes
        let character = MageCharacter()
        character.name = "Notes Only Test"
        character.characterDescription = "Unchanged description"
        character.notes = "Original notes"
        
        let draftCharacter = character.clone() as! MageCharacter
        draftCharacter.notes = "Changed notes"
        // Keep description the same
        
        let changeSummary = character.generateChangeSummary(for: draftCharacter)
        
        #expect(!changeSummary.isEmpty, "Change summary should not be empty")
        #expect(changeSummary.contains("notes updated"), "Should log notes change")
        #expect(!changeSummary.contains("character description updated"), "Should not log description change when description unchanged")
    }
    
    @Test func testEmptyToContentChangeLogged() async throws {
        // Test that changes from empty to content are properly logged
        let character = VampireCharacter()
        character.name = "Empty to Content Test"
        character.characterDescription = ""
        character.notes = ""
        
        let draftCharacter = character.clone() as! VampireCharacter
        draftCharacter.characterDescription = "Now has description"
        draftCharacter.notes = "Now has notes"
        
        let changeSummary = character.generateChangeSummary(for: draftCharacter)
        
        #expect(changeSummary.contains("character description updated"), "Should log when adding description to empty field")
        #expect(changeSummary.contains("notes updated"), "Should log when adding notes to empty field")
    }
    
    @Test func testContentToEmptyChangeLogged() async throws {
        // Test that changes from content to empty are properly logged
        let character = VampireCharacter()
        character.name = "Content to Empty Test"
        character.characterDescription = "Has description"
        character.notes = "Has notes"
        
        let draftCharacter = character.clone() as! VampireCharacter
        draftCharacter.characterDescription = ""
        draftCharacter.notes = ""
        
        let changeSummary = character.generateChangeSummary(for: draftCharacter)
        
        #expect(changeSummary.contains("character description updated"), "Should log when clearing description")
        #expect(changeSummary.contains("notes updated"), "Should log when clearing notes")
    }
}