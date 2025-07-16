//
//  CharacterDescriptionNotesTests.swift
//  CharacterTests
//
//  Created by User on 16.07.2025.
//

import Testing
@testable import Character

struct CharacterDescriptionNotesTests {

    @Test func testVampireCharacterDescriptionAndNotesPreservedOnClone() async throws {
        // Test that character description and notes are preserved when cloning a Vampire character
        let original = VampireCharacter()
        original.name = "Test Vampire"
        original.clan = "Brujah"
        original.characterDescription = "A brooding vampire with dark hair and piercing eyes. Known for their fierce temper and unwavering convictions."
        original.notes = "Session 1: Met the Prince\nSession 2: Discovered the conspiracy\nSession 3: Fought the Sabbat"
        
        let clone = original.clone()
        
        #expect(clone.characterDescription == original.characterDescription)
        #expect(clone.notes == original.notes)
        #expect(clone.characterDescription == "A brooding vampire with dark hair and piercing eyes. Known for their fierce temper and unwavering convictions.")
        #expect(clone.notes == "Session 1: Met the Prince\nSession 2: Discovered the conspiracy\nSession 3: Fought the Sabbat")
    }
    
    @Test func testMageCharacterDescriptionAndNotesPreservedOnClone() async throws {
        // Test that character description and notes are preserved when cloning a Mage character
        let original = MageCharacter()
        original.name = "Test Mage"
        original.characterDescription = "A wise mage with silver hair and knowing eyes. Carries an ancient tome and wears robes of deep blue."
        original.notes = "Paradigm notes: Reality is malleable through will\nInstruments: Ancient tome, crystal orb\nSpecial: Can see through illusions"
        
        let clone = original.clone()
        
        #expect(clone.characterDescription == original.characterDescription)
        #expect(clone.notes == original.notes)
        #expect(clone.characterDescription == "A wise mage with silver hair and knowing eyes. Carries an ancient tome and wears robes of deep blue.")
        #expect(clone.notes == "Paradigm notes: Reality is malleable through will\nInstruments: Ancient tome, crystal orb\nSpecial: Can see through illusions")
    }
    
    @Test func testGhoulCharacterDescriptionAndNotesPreservedOnClone() async throws {
        // Test that character description and notes are preserved when cloning a Ghoul character
        let original = GhoulCharacter()
        original.name = "Test Ghoul"
        original.characterDescription = "A loyal ghoul servant with enhanced strength and agility. Shows signs of supernatural vitality."
        original.notes = "Feeding schedule: Weekly vitae from domitor\nSpecial abilities: Enhanced healing\nWeakness: Blood bond level 3"
        
        let clone = original.clone()
        
        #expect(clone.characterDescription == original.characterDescription)
        #expect(clone.notes == original.notes)
        #expect(clone.characterDescription == "A loyal ghoul servant with enhanced strength and agility. Shows signs of supernatural vitality.")
        #expect(clone.notes == "Feeding schedule: Weekly vitae from domitor\nSpecial abilities: Enhanced healing\nWeakness: Blood bond level 3")
    }
    
    @Test func testEmptyDescriptionAndNotesPreservedOnClone() async throws {
        // Test that empty character description and notes are preserved when cloning
        let original = VampireCharacter()
        original.name = "Test Vampire"
        original.clan = "Ventrue"
        original.characterDescription = ""
        original.notes = ""
        
        let clone = original.clone()
        
        #expect(clone.characterDescription == "")
        #expect(clone.notes == "")
        #expect(clone.characterDescription == original.characterDescription)
        #expect(clone.notes == original.notes)
    }
    
    @Test func testMultilineDescriptionAndNotesPreservedOnClone() async throws {
        // Test that multi-line character description and notes are preserved when cloning
        let multilineDescription = """
        A complex character with multiple facets:
        
        Physical: Tall, athletic build with scars from past battles
        Mental: Sharp intellect, quick wit, tendency towards paranoia
        Social: Charismatic but guarded, loyal to close allies
        
        Background: Former soldier turned supernatural investigator
        """
        
        let multilineNotes = """
        Important plot points:
        • Discovered the secret about the missing artifacts
        • Has unresolved conflict with the antagonist
        • Potential romantic subplot with Sarah
        
        Combat notes:
        - Favors ranged weapons
        - Weak against fire attacks
        - Has defensive disciplines
        
        Character development:
        ☐ Learn to trust others
        ☐ Resolve past trauma
        ☐ Find redemption
        """
        
        let original = VampireCharacter()
        original.name = "Complex Character"
        original.characterDescription = multilineDescription
        original.notes = multilineNotes
        
        let clone = original.clone()
        
        #expect(clone.characterDescription == original.characterDescription)
        #expect(clone.notes == original.notes)
        #expect(clone.characterDescription == multilineDescription)
        #expect(clone.notes == multilineNotes)
    }
    
    @Test func testEditModeSimulation() async throws {
        // Test that simulates the actual edit mode scenario described in the issue
        let character = VampireCharacter()
        character.name = "Edit Test Vampire"
        character.clan = "Toreador"
        character.characterDescription = "Original description that should not be lost"
        character.notes = "Original notes that should not be lost"
        
        // Simulate what happens when entering edit mode (from CharacterDetailView.swift line 219)
        let draftCharacter = character.clone()
        
        // Verify that the draft has the same description and notes as the original
        #expect(draftCharacter.characterDescription == character.characterDescription)
        #expect(draftCharacter.notes == character.notes)
        #expect(draftCharacter.characterDescription == "Original description that should not be lost")
        #expect(draftCharacter.notes == "Original notes that should not be lost")
        
        // Simulate making other changes to the draft (name change)
        var mutableDraft = draftCharacter as! VampireCharacter
        mutableDraft.name = "Modified Name"
        
        // Verify that description and notes are still intact after other modifications
        #expect(mutableDraft.characterDescription == "Original description that should not be lost")
        #expect(mutableDraft.notes == "Original notes that should not be lost")
    }
}