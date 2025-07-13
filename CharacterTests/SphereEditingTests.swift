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
        // Test that sphere modifications work through the proper @Published pattern used in editing mode
        let character = MageCharacter()
        
        // Verify initial state
        #expect(character.spheres["Forces"] == 0)
        #expect(character.spheres["Life"] == 0)
        #expect(character.spheres["Mind"] == 0)
        
        // Simulate the @Published-aware modification pattern used in MageSpheresTab editing mode
        // This tests the exact same pattern: create new dictionary, modify it, assign back
        
        // Test Forces sphere (0 -> 3)
        var newSpheres = character.spheres
        newSpheres["Forces"] = 3
        character.spheres = newSpheres
        #expect(character.spheres["Forces"] == 3)
        
        // Test Life sphere (0 -> 2)
        newSpheres = character.spheres
        newSpheres["Life"] = 2
        character.spheres = newSpheres
        #expect(character.spheres["Life"] == 2)
        
        // Test Mind sphere (0 -> 1)
        newSpheres = character.spheres
        newSpheres["Mind"] = 1
        character.spheres = newSpheres
        #expect(character.spheres["Mind"] == 1)
        
        // Test that other spheres remain unchanged
        #expect(character.spheres["Matter"] == 0)
        #expect(character.spheres["Spirit"] == 0)
        
        // Test decrementing (3 -> 2)
        newSpheres = character.spheres
        newSpheres["Forces"] = 2
        character.spheres = newSpheres
        #expect(character.spheres["Forces"] == 2)
        
        // Test setting back to 0 (2 -> 0)
        newSpheres = character.spheres
        newSpheres["Life"] = 0
        character.spheres = newSpheres
        #expect(character.spheres["Life"] == 0)
    }
    
    @Test func testSphereDirectModificationWithinValidRange() async throws {
        // Test that sphere values stay within the valid range (0-5) with @Published-aware modification
        let character = MageCharacter()
        
        // Test valid range using @Published-aware pattern
        for level in 0...5 {
            var newSpheres = character.spheres
            newSpheres["Forces"] = level
            character.spheres = newSpheres
            #expect(character.spheres["Forces"] == level)
        }
        
        // The UI should prevent values outside 0-5, but test that the model can handle it
        var newSpheres = character.spheres
        newSpheres["Forces"] = 6
        character.spheres = newSpheres
        #expect(character.spheres["Forces"] == 6) // Model allows it, UI should prevent it
        
        newSpheres = character.spheres
        newSpheres["Forces"] = -1
        character.spheres = newSpheres
        #expect(character.spheres["Forces"] == -1) // Model allows it, UI should prevent it
        
        // Reset to valid value
        newSpheres = character.spheres
        newSpheres["Forces"] = 3
        character.spheres = newSpheres
        #expect(character.spheres["Forces"] == 3)
    }
    
    @Test func testSphereChangeTracking() async throws {
        // Test that sphere changes are properly tracked for change logging
        let originalCharacter = MageCharacter()
        var newSpheres = originalCharacter.spheres
        newSpheres["Forces"] = 2
        newSpheres["Life"] = 1
        newSpheres["Mind"] = 0
        originalCharacter.spheres = newSpheres
        
        let updatedCharacter = originalCharacter.clone() as! MageCharacter
        
        // Simulate sphere modifications using the @Published-aware pattern
        newSpheres = updatedCharacter.spheres
        newSpheres["Forces"] = 3  // 2 -> 3
        newSpheres["Life"] = 0    // 1 -> 0
        newSpheres["Mind"] = 2    // 0 -> 2
        newSpheres["Matter"] = 1  // 0 -> 1
        updatedCharacter.spheres = newSpheres
        
        let changeSummary = originalCharacter.generateChangeSummary(for: updatedCharacter)
        
        #expect(changeSummary.contains("forces 2→3"))
        #expect(changeSummary.contains("life 1→0"))
        #expect(changeSummary.contains("mind 0→2"))
        #expect(changeSummary.contains("matter 0→1"))
    }
    
    @Test func testAllMageSpheresCanBeModifiedDirectly() async throws {
        // Test that all nine mage spheres can be modified using @Published-aware pattern
        let character = MageCharacter()
        
        // Test all spheres from V5Constants.mageSpheres
        for sphere in V5Constants.mageSpheres {
            // Test initial state
            #expect(character.spheres[sphere] == 0)
            
            // Test setting to level 3 (using @Published-aware pattern)
            var newSpheres = character.spheres
            newSpheres[sphere] = 3
            character.spheres = newSpheres
            #expect(character.spheres[sphere] == 3)
            
            // Test incrementing (simulate + button: 3 -> 4)
            let currentLevel = character.spheres[sphere] ?? 0
            newSpheres = character.spheres
            newSpheres[sphere] = currentLevel + 1
            character.spheres = newSpheres
            #expect(character.spheres[sphere] == 4)
            
            // Test decrementing (simulate - button: 4 -> 3)
            let newCurrentLevel = character.spheres[sphere] ?? 0
            newSpheres = character.spheres
            newSpheres[sphere] = newCurrentLevel - 1
            character.spheres = newSpheres
            #expect(character.spheres[sphere] == 3)
            
            // Reset for next iteration
            newSpheres = character.spheres
            newSpheres[sphere] = 0
            character.spheres = newSpheres
            #expect(character.spheres[sphere] == 0)
        }
    }
}