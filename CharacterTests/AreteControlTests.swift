//
//  AreteControlTests.swift
//  CharacterTests
//
//  Created for testing arete control consistency fix
//

import Testing
@testable import Character

struct AreteControlTests {
    
    @Test func testAreteCanBeModifiedDirectly() async throws {
        // Test that arete modifications work through the @Published pattern
        let character = MageCharacter()
        
        // Verify initial state (arete starts at 2 per MageCharacter init)
        #expect(character.arete == 2)
        
        // Test setting arete to different values (0-5 range)
        character.arete = 0
        #expect(character.arete == 0)
        
        character.arete = 3
        #expect(character.arete == 3)
        
        character.arete = 5
        #expect(character.arete == 5)
        
        character.arete = 1
        #expect(character.arete == 1)
    }
    
    @Test func testAreteWithinValidRange() async throws {
        // Test that arete values are within expected range for UI
        let character = MageCharacter()
        
        // Test valid range 0-5 (standard for Mage: The Ascension)
        for level in 0...5 {
            character.arete = level
            #expect(character.arete == level)
        }
        
        // The model should allow values outside 0-5, but UI should prevent it
        character.arete = 6
        #expect(character.arete == 6) // Model allows it, SphereRowView should prevent it
        
        character.arete = -1
        #expect(character.arete == -1) // Model allows it, SphereRowView should prevent it
        
        // Reset to valid value
        character.arete = 3
        #expect(character.arete == 3)
    }
    
    @Test func testAreteChangeTracking() async throws {
        // Test that arete changes are properly tracked for change logging
        let originalCharacter = MageCharacter()
        originalCharacter.arete = 2
        
        let updatedCharacter = originalCharacter.clone() as! MageCharacter
        updatedCharacter.arete = 4  // 2 -> 4
        
        let changeSummary = originalCharacter.generateChangeSummary(for: updatedCharacter)
        
        #expect(changeSummary.contains("arete 2→4"))
    }
    
    @Test func testAreteInCharacterClone() async throws {
        // Test that arete is properly cloned when creating character copies
        let originalCharacter = MageCharacter()
        originalCharacter.arete = 3
        
        let clonedCharacter = originalCharacter.clone() as! MageCharacter
        
        #expect(clonedCharacter.arete == 3)
        
        // Test that modifying clone doesn't affect original
        clonedCharacter.arete = 5
        #expect(originalCharacter.arete == 3)
        #expect(clonedCharacter.arete == 5)
    }
    
    @Test func testAreteEncodingDecoding() async throws {
        // Test that arete is properly encoded and decoded
        let originalCharacter = MageCharacter()
        originalCharacter.arete = 4
        
        // Encode to JSON
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalCharacter)
        
        // Decode from JSON
        let decoder = JSONDecoder()
        let decodedCharacter = try decoder.decode(MageCharacter.self, from: data)
        
        #expect(decodedCharacter.arete == 4)
    }
}