//
//  SwipeGestureDemo.swift
//  Character
//
//  Created by Copilot on 13.07.2025.
//  Demo script showing swipe gesture functionality
//

import SwiftUI

// This is a demonstration of how the swipe gesture logic works
// This file is for documentation purposes and is not part of the main app
struct SwipeGestureDemo {
    
    static func demonstrateSwipeLogic() {
        print("=== Swipe Gesture Logic Demonstration ===")
        
        // Simulate different character types
        let characterTypes: [(String, [String])] = [
            ("Vampire", ["Character", "Status", "Attributes & Skills", "Disciplines", "Merits & Flaws", "Data"]),
            ("Ghoul", ["Character", "Status", "Attributes & Skills", "Disciplines", "Merits & Flaws", "Data"]),
            ("Mage", ["Character", "Status", "Attributes & Skills", "Spheres", "Merits & Flaws", "Data"])
        ]
        
        for (charType, tabs) in characterTypes {
            print("\n--- \(charType) Character ---")
            print("Available tabs: \(tabs)")
            print("Total tabs: \(tabs.count)")
            
            var currentTab = 0
            let maxTab = tabs.count - 1
            
            // Demonstrate swipe left (next tab) from beginning
            print("\nStarting at tab \(currentTab): '\(tabs[currentTab])'")
            
            // Swipe left to move to next tab
            if currentTab < maxTab {
                currentTab += 1
            }
            print("After swipe left → tab \(currentTab): '\(tabs[currentTab])'")
            
            // Move to last tab
            currentTab = maxTab
            print("Moving to last tab \(currentTab): '\(tabs[currentTab])'")
            
            // Try swiping left at boundary (should do nothing)
            let beforeBoundarySwipe = currentTab
            if currentTab < maxTab {
                currentTab += 1
            }
            if currentTab == beforeBoundarySwipe {
                print("Swipe left at boundary → no change (stays at tab \(currentTab))")
            }
            
            // Swipe right to move to previous tab
            if currentTab > 0 {
                currentTab -= 1
            }
            print("After swipe right → tab \(currentTab): '\(tabs[currentTab])'")
            
            // Move to first tab
            currentTab = 0
            print("Moving to first tab \(currentTab): '\(tabs[currentTab])'")
            
            // Try swiping right at boundary (should do nothing)
            let beforeFirstBoundarySwipe = currentTab
            if currentTab > 0 {
                currentTab -= 1
            }
            if currentTab == beforeFirstBoundarySwipe {
                print("Swipe right at boundary → no change (stays at tab \(currentTab))")
            }
        }
        
        print("\n=== Swipe Distance Threshold Demo ===")
        let swipeExamples = [
            ("Small swipe", 30.0, false),
            ("Medium swipe", 50.0, false),
            ("Large left swipe", -60.0, true),
            ("Large right swipe", 80.0, true),
            ("Vertical swipe", 0.0, false) // More vertical than horizontal
        ]
        
        for (description, horizontalAmount, shouldTrigger) in swipeExamples {
            let willTrigger = abs(horizontalAmount) > 50
            let direction = horizontalAmount > 0 ? "right" : "left"
            print("\(description) (\(horizontalAmount)): \(willTrigger ? "triggers \(direction) navigation" : "no action")")
        }
    }
}