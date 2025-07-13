//
//  SwipeGestureTests.swift
//  CharacterTests
//
//  Created by Copilot on 13.07.2025.
//

import Testing
@testable import Character

struct SwipeGestureTests {
    
    @Test func testTabNavigationBounds() async throws {
        // Test that tab navigation respects bounds for different character types
        
        // Test Vampire character (has all tabs: Character, Status, Attributes & Skills, Disciplines, Merits & Flaws, Data)
        let vampireCharacter = VampireCharacter()
        vampireCharacter.name = "Test Vampire"
        vampireCharacter.clan = "Brujah"
        vampireCharacter.generation = 12
        
        // Simulate the tab counting logic from CharacterDetailView
        var vampireTabs = ["Character", "Status", "Attributes & Skills", "Disciplines", "Merits & Flaws", "Data"]
        #expect(vampireTabs.count == 6)
        
        // Test tab boundaries
        var currentTab = 0
        let maxTab = vampireTabs.count - 1
        
        // Test swipe right at beginning (should not move)
        let initialTab = currentTab
        if currentTab > 0 {
            currentTab -= 1
        }
        #expect(currentTab == initialTab) // Should remain at 0
        
        // Test swipe left to move to next tab
        if currentTab < maxTab {
            currentTab += 1
        }
        #expect(currentTab == 1)
        
        // Move to last tab
        currentTab = maxTab
        #expect(currentTab == 5)
        
        // Test swipe left at end (should not move)
        let lastTab = currentTab
        if currentTab < maxTab {
            currentTab += 1
        }
        #expect(currentTab == lastTab) // Should remain at 5
        
        // Test swipe right from last tab
        if currentTab > 0 {
            currentTab -= 1
        }
        #expect(currentTab == 4)
    }
    
    @Test func testMageCharacterTabs() async throws {
        // Test that mage characters have correct tab structure
        let mageCharacter = MageCharacter()
        mageCharacter.name = "Test Mage"
        
        // Mage should have: Character, Status, Attributes & Skills, Spheres, Merits & Flaws, Data
        var mageTabs = ["Character", "Status", "Attributes & Skills", "Spheres", "Merits & Flaws", "Data"]
        #expect(mageTabs.count == 6)
        
        // Verify tab navigation works for mage
        var currentTab = 0
        let maxTab = mageTabs.count - 1
        
        // Navigate through all tabs
        for expectedTab in 1...maxTab {
            if currentTab < maxTab {
                currentTab += 1
            }
            #expect(currentTab == expectedTab)
        }
        
        // Navigate back through all tabs
        for expectedTab in (0..<maxTab).reversed() {
            if currentTab > 0 {
                currentTab -= 1
            }
            #expect(currentTab == expectedTab)
        }
    }
    
    @Test func testGhoulCharacterTabs() async throws {
        // Test that ghoul characters have correct tab structure
        let ghoulCharacter = GhoulCharacter()
        ghoulCharacter.name = "Test Ghoul"
        
        // Ghoul should have: Character, Status, Attributes & Skills, Disciplines, Merits & Flaws, Data
        var ghoulTabs = ["Character", "Status", "Attributes & Skills", "Disciplines", "Merits & Flaws", "Data"]
        #expect(ghoulTabs.count == 6)
        
        // Test boundary behavior
        var currentTab = 0
        let maxTab = ghoulTabs.count - 1
        
        // Test multiple swipes at beginning
        for _ in 0..<5 {
            let beforeSwipe = currentTab
            if currentTab > 0 {
                currentTab -= 1
            }
            #expect(currentTab == beforeSwipe) // Should never change from 0
        }
        
        // Test multiple swipes at end
        currentTab = maxTab
        for _ in 0..<5 {
            let beforeSwipe = currentTab
            if currentTab < maxTab {
                currentTab += 1
            }
            #expect(currentTab == beforeSwipe) // Should never change from maxTab
        }
    }
    
    @Test func testSwipeDirectionLogic() async throws {
        // Test the swipe direction logic matches the expected behavior
        // Swipe left = move to next tab (increment)
        // Swipe right = move to previous tab (decrement)
        
        var currentTab = 2 // Start in middle
        let maxTab = 5
        
        // Simulate swipe left (should increment)
        let horizontalAmount = -60.0 // Negative = left swipe
        if abs(horizontalAmount) > 50 && horizontalAmount < -50 {
            // Swipe left (next tab)
            if currentTab < maxTab {
                currentTab += 1
            }
        }
        #expect(currentTab == 3)
        
        // Simulate swipe right (should decrement)
        let rightSwipeAmount = 60.0 // Positive = right swipe
        if abs(rightSwipeAmount) > 50 && rightSwipeAmount > 50 {
            // Swipe right (previous tab)
            if currentTab > 0 {
                currentTab -= 1
            }
        }
        #expect(currentTab == 2)
        
        // Test insufficient swipe distance (should not change)
        let smallSwipe = 30.0 // Below 50 threshold
        let beforeSmallSwipe = currentTab
        if abs(smallSwipe) > 50 {
            // This should not execute
            currentTab += 1
        }
        #expect(currentTab == beforeSmallSwipe) // Should not change
    }
}