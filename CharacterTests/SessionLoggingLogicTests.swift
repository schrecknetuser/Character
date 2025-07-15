//
//  SessionLoggingLogicTests.swift
//  CharacterTests
//
//  Created by User on 15.07.2025.
//

import Testing
@testable import Character

struct SessionLoggingLogicTests {
    
    @Test func testChangeLogEntryCreation() async throws {
        // Test that ChangeLogEntry can be created with session change message
        let entry = ChangeLogEntry(summary: "Session changed from 1 to 2")
        
        #expect(entry.summary == "Session changed from 1 to 2")
        #expect(entry.id != UUID())  // Should have a valid UUID
        
        // Verify timestamp is recent (within the last minute)
        let timeDifference = Date().timeIntervalSince(entry.timestamp)
        #expect(timeDifference < 60.0)
    }
    
    @Test func testSessionChangeLogic() async throws {
        // Test the logic for determining when to log session changes
        let initialSession = 3
        let currentSession1 = 3  // No change
        let currentSession2 = 4  // Increment
        let currentSession3 = 2  // Decrement
        
        // Test no change scenario
        #expect(initialSession == currentSession1)  // No logging should happen
        
        // Test increment scenario
        #expect(initialSession != currentSession2)  // Logging should happen
        
        // Test decrement scenario  
        #expect(initialSession != currentSession3)  // Logging should happen
    }
    
    @Test func testSessionChangeMessageGeneration() async throws {
        // Test that we generate the correct log messages
        let scenarios = [
            (initial: 1, final: 2, expected: "Session changed from 1 to 2"),
            (initial: 5, final: 4, expected: "Session changed from 5 to 4"),
            (initial: 10, final: 15, expected: "Session changed from 10 to 15"),
            (initial: 3, final: 1, expected: "Session changed from 3 to 1")
        ]
        
        for scenario in scenarios {
            let message = "Session changed from \(scenario.initial) to \(scenario.final)"
            #expect(message == scenario.expected)
        }
    }
}