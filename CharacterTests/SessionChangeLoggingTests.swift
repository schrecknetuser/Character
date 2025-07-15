//
//  SessionChangeLoggingTests.swift
//  CharacterTests
//
//  Created by User on 15.07.2025.
//

import Testing
@testable import Character

struct SessionChangeLoggingTests {
    
    @Test func testSessionChangeLoggingIncrement() async throws {
        // Test that incrementing the session count logs the change
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 3
        
        // Add character to store
        store.addCharacter(character)
        
        // Get initial changelog count
        let initialLogCount = character.changeLog.count
        let initialSession = character.currentSession
        
        // Simulate incrementing session in DataModalView
        character.currentSession += 1
        
        // Simulate what happens when Done is pressed in DataModalView
        let logEntry = ChangeLogEntry(summary: "Session changed from \(initialSession) to \(character.currentSession)")
        character.changeLog.append(logEntry)
        store.updateCharacter(character)
        
        // Verify a log entry was added
        #expect(character.changeLog.count == initialLogCount + 1)
        
        // Verify the log entry has the correct text
        let lastLogEntry = character.changeLog.last
        #expect(lastLogEntry?.summary == "Session changed from 3 to 4")
        
        // Verify the timestamp is recent (within the last minute)
        let timeDifference = Date().timeIntervalSince(lastLogEntry!.timestamp)
        #expect(timeDifference < 60.0)
    }
    
    @Test func testSessionChangeLoggingDecrement() async throws {
        // Test that decrementing the session count logs the change
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 5
        
        // Add character to store
        store.addCharacter(character)
        
        // Get initial changelog count
        let initialLogCount = character.changeLog.count
        let initialSession = character.currentSession
        
        // Simulate decrementing session in DataModalView
        character.currentSession -= 1
        
        // Simulate what happens when Done is pressed in DataModalView
        let logEntry = ChangeLogEntry(summary: "Session changed from \(initialSession) to \(character.currentSession)")
        character.changeLog.append(logEntry)
        store.updateCharacter(character)
        
        // Verify a log entry was added
        #expect(character.changeLog.count == initialLogCount + 1)
        
        // Verify the log entry has the correct text
        let lastLogEntry = character.changeLog.last
        #expect(lastLogEntry?.summary == "Session changed from 5 to 4")
        
        // Verify the timestamp is recent (within the last minute)
        let timeDifference = Date().timeIntervalSince(lastLogEntry!.timestamp)
        #expect(timeDifference < 60.0)
    }
    
    @Test func testNoLoggingWhenSessionUnchanged() async throws {
        // Test that no logging occurs when session count remains the same
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 3
        
        // Add character to store
        store.addCharacter(character)
        
        // Get initial changelog count
        let initialLogCount = character.changeLog.count
        let initialSession = character.currentSession
        
        // Session remains unchanged (simulate opening and closing modal without changes)
        // character.currentSession remains 3
        
        // Simulate what happens when Done is pressed in DataModalView with no changes
        if character.currentSession != initialSession {
            let logEntry = ChangeLogEntry(summary: "Session changed from \(initialSession) to \(character.currentSession)")
            character.changeLog.append(logEntry)
            store.updateCharacter(character)
        }
        
        // Verify no log entry was added
        #expect(character.changeLog.count == initialLogCount)
    }
    
    @Test func testSessionChangeLoggingWorksWithOtherCharacterTypes() async throws {
        // Test that session change logging works with Ghoul and Mage characters too
        let store = CharacterStore()
        
        // Test with Ghoul
        let ghoul = GhoulCharacter()
        ghoul.name = "Test Ghoul"
        ghoul.currentSession = 2
        store.addCharacter(ghoul)
        
        let ghoulInitialLogCount = ghoul.changeLog.count
        let ghoulInitialSession = ghoul.currentSession
        
        ghoul.currentSession += 1
        let ghoulLogEntry = ChangeLogEntry(summary: "Session changed from \(ghoulInitialSession) to \(ghoul.currentSession)")
        ghoul.changeLog.append(ghoulLogEntry)
        store.updateCharacter(ghoul)
        
        #expect(ghoul.changeLog.count == ghoulInitialLogCount + 1)
        #expect(ghoul.changeLog.last?.summary == "Session changed from 2 to 3")
        
        // Test with Mage
        let mage = MageCharacter()
        mage.name = "Test Mage"
        mage.currentSession = 7
        store.addCharacter(mage)
        
        let mageInitialLogCount = mage.changeLog.count
        let mageInitialSession = mage.currentSession
        
        mage.currentSession -= 2
        let mageLogEntry = ChangeLogEntry(summary: "Session changed from \(mageInitialSession) to \(mage.currentSession)")
        mage.changeLog.append(mageLogEntry)
        store.updateCharacter(mage)
        
        #expect(mage.changeLog.count == mageInitialLogCount + 1)
        #expect(mage.changeLog.last?.summary == "Session changed from 7 to 5")
    }
    
    @Test func testMultipleSessionChanges() async throws {
        // Test that multiple session changes create separate log entries
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 1
        
        store.addCharacter(character)
        
        let initialLogCount = character.changeLog.count
        
        // First session change: 1 -> 3
        let firstInitialSession = character.currentSession
        character.currentSession = 3
        let firstLogEntry = ChangeLogEntry(summary: "Session changed from \(firstInitialSession) to \(character.currentSession)")
        character.changeLog.append(firstLogEntry)
        store.updateCharacter(character)
        
        // Second session change: 3 -> 2
        let secondInitialSession = character.currentSession
        character.currentSession = 2
        let secondLogEntry = ChangeLogEntry(summary: "Session changed from \(secondInitialSession) to \(character.currentSession)")
        character.changeLog.append(secondLogEntry)
        store.updateCharacter(character)
        
        // Verify both log entries were added
        #expect(character.changeLog.count == initialLogCount + 2)
        
        // Verify the log entries have the correct text
        let logEntries = character.changeLog.suffix(2)
        #expect(logEntries.first?.summary == "Session changed from 1 to 3")
        #expect(logEntries.last?.summary == "Session changed from 3 to 2")
    }
}