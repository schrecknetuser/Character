//
//  SphereEditingTests.swift
//  CharacterTests
//
//  Created for testing sphere editing fix
//

import Testing
@testable import Character

struct SphereEditingTests {
    
    @Test func testMageSpheresCanBeModifiedDirectly() async throws {
        // Test that sphere modifications work through the direct modification pattern used in editing mode
        let character = MageCharacter()
        
        // Verify initial state
        #expect(character.spheres["Forces"] == 0)
        #expect(character.spheres["Life"] == 0)
        #expect(character.spheres["Mind"] == 0)
        
        // Simulate the direct modification pattern used in MageSpheresTab editing mode
        // This tests the exact same pattern: character.spheres[sphere] = newValue
        
        // Test Forces sphere
        character.spheres["Forces"] = 3
        #expect(character.spheres["Forces"] == 3)
        
        // Test Life sphere  
        character.spheres["Life"] = 2
        #expect(character.spheres["Life"] == 2)
        
        // Test Mind sphere
        character.spheres["Mind"] = 1
        #expect(character.spheres["Mind"] == 1)
        
        // Test that other spheres remain unchanged
        #expect(character.spheres["Matter"] == 0)
        #expect(character.spheres["Spirit"] == 0)
        
        // Test decrementing
        character.spheres["Forces"] = 2 // 3 -> 2
        #expect(character.spheres["Forces"] == 2)
        
        // Test setting back to 0
        character.spheres["Life"] = 0 // 2 -> 0
        #expect(character.spheres["Life"] == 0)
    }
    
    @Test func testSphereDirectModificationWithinValidRange() async throws {
        // Test that sphere values stay within the valid range (0-5) with direct modification
        let character = MageCharacter()
        
        // Test valid range
        for level in 0...5 {
            character.spheres["Forces"] = level
            #expect(character.spheres["Forces"] == level)
        }
        
        // The UI should prevent values outside 0-5, but test that the model can handle it
        character.spheres["Forces"] = 6
        #expect(character.spheres["Forces"] == 6) // Model allows it, UI should prevent it
        
        character.spheres["Forces"] = -1
        #expect(character.spheres["Forces"] == -1) // Model allows it, UI should prevent it
        
        // Reset to valid value
        character.spheres["Forces"] = 3
        #expect(character.spheres["Forces"] == 3)
    }
    
    @Test func testSphereChangeTracking() async throws {
        // Test that sphere changes are properly tracked for change logging
        let originalCharacter = MageCharacter()
        originalCharacter.spheres["Forces"] = 2
        originalCharacter.spheres["Life"] = 1
        originalCharacter.spheres["Mind"] = 0
        
        let updatedCharacter = originalCharacter.clone() as! MageCharacter
        
        // Simulate sphere modifications like the UI would do
        updatedCharacter.spheres["Forces"] = 3  // 2 -> 3
        updatedCharacter.spheres["Life"] = 0    // 1 -> 0
        updatedCharacter.spheres["Mind"] = 2    // 0 -> 2
        updatedCharacter.spheres["Matter"] = 1  // 0 -> 1
        
        let changeSummary = originalCharacter.generateChangeSummary(for: updatedCharacter)
        
        #expect(changeSummary.contains("forces 2→3"))
        #expect(changeSummary.contains("life 1→0"))
        #expect(changeSummary.contains("mind 0→2"))
        #expect(changeSummary.contains("matter 0→1"))
    }
    
    @Test func testAllMageSpheresCanBeModifiedDirectly() async throws {
        // Test that all nine mage spheres can be modified using direct modification
        let character = MageCharacter()
        
        // Test all spheres from V5Constants.mageSpheres
        for sphere in V5Constants.mageSpheres {
            // Test initial state
            #expect(character.spheres[sphere] == 0)
            
            // Test setting to level 3
            character.spheres[sphere] = 3
            #expect(character.spheres[sphere] == 3)
            
            // Test incrementing (simulate + button)
            let currentLevel = character.spheres[sphere] ?? 0
            character.spheres[sphere] = currentLevel + 1
            #expect(character.spheres[sphere] == 4)
            
            // Test decrementing (simulate - button)
            let newCurrentLevel = character.spheres[sphere] ?? 0
            character.spheres[sphere] = newCurrentLevel - 1
            #expect(character.spheres[sphere] == 3)
            
            // Reset for next iteration
            character.spheres[sphere] = 0
            #expect(character.spheres[sphere] == 0)
        }
    }
}