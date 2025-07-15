//
//  DataModalFlowTests.swift  
//  CharacterTests
//
//  Created by User on 15.07.2025.
//

import Testing
@testable import Character

struct DataModalFlowTests {
    
    @Test func testCompleteSessionChangeFlow() async throws {
        // Test the complete flow: open modal -> change session -> close modal -> verify logging
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 1
        
        store.addCharacter(character)
        
        // Simulate opening DataModalView (capture initial session)
        let initialSessionCount = character.currentSession
        #expect(initialSessionCount == 1)
        
        let initialLogCount = character.changeLog.count
        
        // Simulate user incrementing session in the modal
        character.currentSession += 1
        #expect(character.currentSession == 2)
        
        // Simulate closing modal with Done button (our logging logic)
        if character.currentSession != initialSessionCount {
            let logEntry = ChangeLogEntry(summary: "Session changed from \(initialSessionCount) to \(character.currentSession)")
            character.changeLog.append(logEntry)
            store.updateCharacter(character)
        }
        
        // Verify the session was updated
        #expect(character.currentSession == 2)
        
        // Verify a log entry was added
        #expect(character.changeLog.count == initialLogCount + 1)
        
        // Verify the log entry content
        let lastEntry = character.changeLog.last
        #expect(lastEntry?.summary == "Session changed from 1 to 2")
        
        // Verify timestamp is recent
        let timeDifference = Date().timeIntervalSince(lastEntry!.timestamp)
        #expect(timeDifference < 60.0)
    }
    
    @Test func testModalOpenCloseWithoutChange() async throws {
        // Test opening and closing modal without changing session - no logging should occur
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 5
        
        store.addCharacter(character)
        
        // Simulate opening DataModalView (capture initial session)
        let initialSessionCount = character.currentSession
        #expect(initialSessionCount == 5)
        
        let initialLogCount = character.changeLog.count
        
        // User does not change session
        // character.currentSession remains 5
        
        // Simulate closing modal with Done button (our logging logic)
        if character.currentSession != initialSessionCount {
            let logEntry = ChangeLogEntry(summary: "Session changed from \(initialSessionCount) to \(character.currentSession)")
            character.changeLog.append(logEntry)
            store.updateCharacter(character)
        }
        
        // Verify the session was not changed
        #expect(character.currentSession == 5)
        
        // Verify no log entry was added
        #expect(character.changeLog.count == initialLogCount)
    }
    
    @Test func testMultipleSessionChangesInSequence() async throws {
        // Test multiple modal opens/closes with different session changes
        let store = CharacterStore()
        let character = VampireCharacter()
        character.name = "Test Vampire"
        character.clan = "Brujah"
        character.generation = 12
        character.currentSession = 1
        
        store.addCharacter(character)
        let initialLogCount = character.changeLog.count
        
        // First modal interaction: 1 -> 3
        var modalInitialSession = character.currentSession
        character.currentSession = 3
        if character.currentSession != modalInitialSession {
            let logEntry = ChangeLogEntry(summary: "Session changed from \(modalInitialSession) to \(character.currentSession)")
            character.changeLog.append(logEntry)
            store.updateCharacter(character)
        }
        
        // Second modal interaction: 3 -> 2
        modalInitialSession = character.currentSession
        character.currentSession = 2
        if character.currentSession != modalInitialSession {
            let logEntry = ChangeLogEntry(summary: "Session changed from \(modalInitialSession) to \(character.currentSession)")
            character.changeLog.append(logEntry)
            store.updateCharacter(character)
        }
        
        // Third modal interaction: 2 -> 2 (no change)
        modalInitialSession = character.currentSession
        // character.currentSession remains 2
        if character.currentSession != modalInitialSession {
            let logEntry = ChangeLogEntry(summary: "Session changed from \(modalInitialSession) to \(character.currentSession)")
            character.changeLog.append(logEntry)
            store.updateCharacter(character)
        }
        
        // Verify final session value
        #expect(character.currentSession == 2)
        
        // Verify only 2 log entries were added (not 3, since one had no change)
        #expect(character.changeLog.count == initialLogCount + 2)
        
        // Verify log entry contents
        let logEntries = character.changeLog.suffix(2)
        #expect(logEntries.first?.summary == "Session changed from 1 to 3")
        #expect(logEntries.last?.summary == "Session changed from 3 to 2")
    }
}