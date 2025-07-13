//
//  SphereEditingTests.swift
//  CharacterTests
//
//  Created for testing sphere editing fix
//

import Testing
@testable import Character

struct SphereEditingTests {
    
    @Test func testMageSpheresCanBeModifiedInEditingBinding() async throws {
        // Test that sphere modifications work through the binding pattern used in editing mode
        let character = MageCharacter()
        
        // Verify initial state
        #expect(character.spheres["Forces"] == 0)
        #expect(character.spheres["Life"] == 0)
        #expect(character.spheres["Mind"] == 0)
        
        // Simulate the binding pattern used in MageSpheresTab editing mode
        // This tests the exact same pattern: Binding(get: { character.spheres[sphere] ?? 0 }, set: { character.spheres[sphere] = $0 })
        
        // Test Forces sphere
        let forcesGetter = { character.spheres["Forces"] ?? 0 }
        let forcesSetter = { (newValue: Int) in character.spheres["Forces"] = newValue }
        
        #expect(forcesGetter() == 0)
        forcesSetter(3)
        #expect(forcesGetter() == 3)
        #expect(character.spheres["Forces"] == 3)
        
        // Test Life sphere
        let lifeGetter = { character.spheres["Life"] ?? 0 }
        let lifeSetter = { (newValue: Int) in character.spheres["Life"] = newValue }
        
        #expect(lifeGetter() == 0)
        lifeSetter(2)
        #expect(lifeGetter() == 2)
        #expect(character.spheres["Life"] == 2)
        
        // Test Mind sphere
        let mindGetter = { character.spheres["Mind"] ?? 0 }
        let mindSetter = { (newValue: Int) in character.spheres["Mind"] = newValue }
        
        #expect(mindGetter() == 0)
        mindSetter(1)
        #expect(mindGetter() == 1)
        #expect(character.spheres["Mind"] == 1)
        
        // Test that other spheres remain unchanged
        #expect(character.spheres["Matter"] == 0)
        #expect(character.spheres["Spirit"] == 0)
        
        // Test decrementing
        forcesSetter(2) // 3 -> 2
        #expect(forcesGetter() == 2)
        #expect(character.spheres["Forces"] == 2)
        
        // Test setting back to 0
        lifeSetter(0) // 2 -> 0
        #expect(lifeGetter() == 0)
        #expect(character.spheres["Life"] == 0)
    }
    
    @Test func testSphereBindingWithinValidRange() async throws {
        // Test that sphere values stay within the valid range (0-5)
        let character = MageCharacter()
        
        // Test setter function for Forces
        let forcesSetter = { (newValue: Int) in character.spheres["Forces"] = newValue }
        let forcesGetter = { character.spheres["Forces"] ?? 0 }
        
        // Test valid range
        for level in 0...5 {
            forcesSetter(level)
            #expect(forcesGetter() == level)
        }
        
        // The UI should prevent values outside 0-5, but test that the model can handle it
        forcesSetter(6)
        #expect(forcesGetter() == 6) // Model allows it, UI should prevent it
        
        forcesSetter(-1)
        #expect(forcesGetter() == -1) // Model allows it, UI should prevent it
        
        // Reset to valid value
        forcesSetter(3)
        #expect(forcesGetter() == 3)
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
    
    @Test func testAllMageSpheresCanBeModified() async throws {
        // Test that all nine mage spheres can be modified using the binding pattern
        let character = MageCharacter()
        
        // Test all spheres from V5Constants.mageSpheres
        for sphere in V5Constants.mageSpheres {
            let getter = { character.spheres[sphere] ?? 0 }
            let setter = { (newValue: Int) in character.spheres[sphere] = newValue }
            
            // Test initial state
            #expect(getter() == 0)
            
            // Test setting to level 3
            setter(3)
            #expect(getter() == 3)
            #expect(character.spheres[sphere] == 3)
            
            // Test incrementing (simulate + button)
            setter(getter() + 1)
            #expect(getter() == 4)
            
            // Test decrementing (simulate - button)
            setter(getter() - 1)
            #expect(getter() == 3)
            
            // Reset for next iteration
            setter(0)
            #expect(getter() == 0)
        }
    }
}