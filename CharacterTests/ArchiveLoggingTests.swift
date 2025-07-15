//
//  ArchiveLoggingTests.swift
//  CharacterTests
//
//  Created by User on 15.07.2025.
//

import Testing
@testable import Character

struct ArchiveLoggingTests {

    @Test func testArchiveCharacterLogging() async throws {
        // Test that archiving a character adds the proper log entry
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        
        // Add character to store
        store.addCharacter(character)
        
        // Verify character starts unarchived
        #expect(character.isArchived == false)
        
        // Get initial changelog count
        let initialLogCount = character.changeLog.count
        
        // Archive the character
        store.archiveCharacter(character)
        
        // Verify character is now archived
        #expect(character.isArchived == true)
        
        // Verify a log entry was added
        #expect(character.changeLog.count == initialLogCount + 1)
        
        // Verify the log entry has the correct text
        let lastLogEntry = character.changeLog.last
        #expect(lastLogEntry?.summary == "Character moved to archive.")
        
        // Verify the timestamp is recent (within the last minute)
        let timeDifference = Date().timeIntervalSince(lastLogEntry!.timestamp)
        #expect(timeDifference < 60.0)
    }
    
    @Test func testUnarchiveCharacterLogging() async throws {
        // Test that unarchiving a character adds the proper log entry
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        
        // Add character to store and archive it first
        store.addCharacter(character)
        store.archiveCharacter(character)
        
        // Verify character is archived
        #expect(character.isArchived == true)
        
        // Get current changelog count
        let logCountAfterArchive = character.changeLog.count
        
        // Unarchive the character
        store.unarchiveCharacter(character)
        
        // Verify character is now unarchived
        #expect(character.isArchived == false)
        
        // Verify a log entry was added
        #expect(character.changeLog.count == logCountAfterArchive + 1)
        
        // Verify the log entry has the correct text
        let lastLogEntry = character.changeLog.last
        #expect(lastLogEntry?.summary == "Character returned from archive")
        
        // Verify the timestamp is recent (within the last minute)
        let timeDifference = Date().timeIntervalSince(lastLogEntry!.timestamp)
        #expect(timeDifference < 60.0)
    }
    
    @Test func testArchiveUnarchiveCycle() async throws {
        // Test that archiving and unarchiving creates the correct sequence of log entries
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        
        // Add character to store
        store.addCharacter(character)
        
        let initialLogCount = character.changeLog.count
        
        // Archive the character
        store.archiveCharacter(character)
        #expect(character.changeLog.count == initialLogCount + 1)
        #expect(character.changeLog.last?.summary == "Character moved to archive.")
        
        // Unarchive the character
        store.unarchiveCharacter(character)
        #expect(character.changeLog.count == initialLogCount + 2)
        #expect(character.changeLog.last?.summary == "Character returned from archive")
        
        // Archive again
        store.archiveCharacter(character)
        #expect(character.changeLog.count == initialLogCount + 3)
        #expect(character.changeLog.last?.summary == "Character moved to archive.")
        
        // Verify the sequence of log entries
        let logEntries = character.changeLog.suffix(3)
        let summaries = logEntries.map { $0.summary }
        
        #expect(summaries[0] == "Character moved to archive.")
        #expect(summaries[1] == "Character returned from archive")
        #expect(summaries[2] == "Character moved to archive.")
    }
    
    @Test func testArchiveLoggingWorksWithOtherCharacterTypes() async throws {
        // Test that archive logging works with Ghoul and Mage characters too
        let store = CharacterStore()
        
        // Test with Ghoul
        let ghoul = GhoulCharacter()
        ghoul.name = "Test Ghoul"
        store.addCharacter(ghoul)
        
        let ghoulInitialLogCount = ghoul.changeLog.count
        store.archiveCharacter(ghoul)
        #expect(ghoul.changeLog.count == ghoulInitialLogCount + 1)
        #expect(ghoul.changeLog.last?.summary == "Character moved to archive.")
        
        store.unarchiveCharacter(ghoul)
        #expect(ghoul.changeLog.count == ghoulInitialLogCount + 2)
        #expect(ghoul.changeLog.last?.summary == "Character returned from archive")
        
        // Test with Mage
        let mage = MageCharacter()
        mage.name = "Test Mage"
        store.addCharacter(mage)
        
        let mageInitialLogCount = mage.changeLog.count
        store.archiveCharacter(mage)
        #expect(mage.changeLog.count == mageInitialLogCount + 1)
        #expect(mage.changeLog.last?.summary == "Character moved to archive.")
        
        store.unarchiveCharacter(mage)
        #expect(mage.changeLog.count == mageInitialLogCount + 2)
        #expect(mage.changeLog.last?.summary == "Character returned from archive")
    }
}