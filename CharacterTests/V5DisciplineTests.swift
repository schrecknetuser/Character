import Testing
@testable import Character

struct V5DisciplineTests {
    
    @Test func testV5DisciplinePowerCreation() async throws {
        let power = V5DisciplinePower(
            name: "Feral Whispers",
            description: "Communicate with animals through growls and sounds",
            level: 1
        )
        
        #expect(power.name == "Feral Whispers")
        #expect(power.level == 1)
        #expect(power.isCustom == false)
        #expect(power.id != UUID()) // Should have a unique ID
    }
    
    @Test func testV5DisciplineCreation() async throws {
        let power1 = V5DisciplinePower(name: "Feral Whispers", description: "Talk to animals", level: 1)
        let power2 = V5DisciplinePower(name: "Bond Famulus", description: "Bond with animal", level: 1)
        
        var discipline = V5Discipline(name: "Animalism")
        discipline.addPower(power1, to: 1)
        discipline.addPower(power2, to: 1)
        
        #expect(discipline.name == "Animalism")
        #expect(discipline.isCustom == false)
        #expect(discipline.getPowers(for: 1).count == 2)
        #expect(discipline.getPowers(for: 2).count == 0)
        
        let level1Powers = discipline.getPowers(for: 1)
        #expect(level1Powers.contains { $0.name == "Feral Whispers" })
        #expect(level1Powers.contains { $0.name == "Bond Famulus" })
    }
    
    @Test func testV5DisciplineProgress() async throws {
        var progress = V5DisciplineProgress(disciplineName: "Animalism", currentLevel: 2)
        let powerId1 = UUID()
        let powerId2 = UUID()
        
        #expect(progress.disciplineName == "Animalism")
        #expect(progress.currentLevel == 2)
        #expect(progress.getSelectedPowers(for: 1).isEmpty)
        
        // Test power selection
        progress.togglePower(powerId1, at: 1)
        #expect(progress.isPowerSelected(powerId1, at: 1))
        #expect(!progress.isPowerSelected(powerId2, at: 1))
        #expect(progress.getSelectedPowers(for: 1).count == 1)
        
        // Test power deselection
        progress.togglePower(powerId1, at: 1)
        #expect(!progress.isPowerSelected(powerId1, at: 1))
        #expect(progress.getSelectedPowers(for: 1).isEmpty)
        
        // Test multiple powers at different levels
        progress.togglePower(powerId1, at: 1)
        progress.togglePower(powerId2, at: 2)
        #expect(progress.getSelectedPowers(for: 1).count == 1)
        #expect(progress.getSelectedPowers(for: 2).count == 1)
        
        // Test accessible levels
        let accessibleLevels = progress.getAccessibleLevels()
        #expect(accessibleLevels == [1, 2])
    }
    
    @Test func testV5Constants() async throws {
        // Test that V5 disciplines are defined
        #expect(!V5Constants.v5Disciplines.isEmpty)
        #expect(V5Constants.v5Disciplines.count >= 6) // Should have at least the 6 we defined
        
        // Test specific disciplines exist
        let animalism = V5Constants.getV5Discipline(named: "Animalism")
        #expect(animalism != nil)
        #expect(animalism?.name == "Animalism")
        #expect(!animalism!.getPowers(for: 1).isEmpty)
        
        let auspex = V5Constants.getV5Discipline(named: "Auspex")
        #expect(auspex != nil)
        #expect(auspex?.name == "Auspex")
        
        // Test discipline names
        let disciplineNames = V5Constants.getAllV5DisciplineNames()
        #expect(disciplineNames.contains("Animalism"))
        #expect(disciplineNames.contains("Auspex"))
        #expect(disciplineNames.contains("Celerity"))
        #expect(disciplineNames.contains("Dominate"))
        #expect(disciplineNames.contains("Fortitude"))
        #expect(disciplineNames.contains("Presence"))
    }
    
    @Test func testVampireCharacterV5Disciplines() async throws {
        var character = VampireCharacter()
        
        // Test initial state
        #expect(character.v5Disciplines.isEmpty)
        #expect(character.customV5Disciplines.isEmpty)
        #expect(!character.isUsingV5Disciplines)
        
        // Test adding a discipline
        character.setV5DisciplineLevel("Animalism", to: 2)
        #expect(character.v5Disciplines.count == 1)
        #expect(character.isUsingV5Disciplines)
        
        let progress = character.getV5DisciplineProgress(for: "Animalism")
        #expect(progress != nil)
        #expect(progress?.currentLevel == 2)
        #expect(progress?.disciplineName == "Animalism")
        
        // Test power selection
        if let animalism = V5Constants.getV5Discipline(named: "Animalism") {
            let level1Powers = animalism.getPowers(for: 1)
            if let firstPower = level1Powers.first {
                character.toggleV5Power(firstPower.id, for: "Animalism", at: 1)
                
                let selectedPowers = character.getSelectedV5Powers(for: "Animalism", at: 1)
                #expect(selectedPowers.count == 1)
                #expect(selectedPowers.first?.id == firstPower.id)
            }
        }
        
        // Test removing discipline
        character.removeV5Discipline("Animalism")
        #expect(character.v5Disciplines.isEmpty)
        #expect(!character.isUsingV5Disciplines)
    }
    
    @Test func testVampireCharacterLegacyMigration() async throws {
        var character = VampireCharacter()
        
        // Add legacy disciplines
        character.disciplines["Animalism"] = 3
        character.disciplines["Auspex"] = 2
        
        #expect(character.disciplines.count == 2)
        #expect(character.v5Disciplines.isEmpty)
        #expect(!character.isUsingV5Disciplines)
        
        // Migrate to V5
        character.migrateLegacyDisciplinesToV5()
        
        #expect(character.v5Disciplines.count == 2)
        #expect(character.isUsingV5Disciplines)
        
        let animalismProgress = character.getV5DisciplineProgress(for: "Animalism")
        #expect(animalismProgress?.currentLevel == 3)
        
        let auspexProgress = character.getV5DisciplineProgress(for: "Animalism")
        #expect(auspexProgress?.currentLevel == 3)
    }
    
    @Test func testVampireCharacterCustomDisciplines() async throws {
        var character = VampireCharacter()
        
        // Create custom discipline
        let customPower = V5DisciplinePower(
            name: "Custom Power",
            description: "A custom supernatural ability",
            level: 1,
            isCustom: true
        )
        
        var customDiscipline = V5Discipline(name: "Custom Discipline", isCustom: true)
        customDiscipline.addPower(customPower, to: 1)
        
        // Add to character
        character.addCustomV5Discipline(customDiscipline)
        #expect(character.customV5Disciplines.count == 1)
        
        // Test that it appears in available disciplines
        let available = character.getAllAvailableV5Disciplines()
        #expect(available.contains { $0.name == "Custom Discipline" })
        
        // Test that it can be learned
        character.setV5DisciplineLevel("Custom Discipline", to: 1)
        let progress = character.getV5DisciplineProgress(for: "Custom Discipline")
        #expect(progress != nil)
        #expect(progress?.currentLevel == 1)
    }
    
    @Test func testV5DisciplineChangeLogging() async throws {
        let originalCharacter = VampireCharacter()
        originalCharacter.setV5DisciplineLevel("Animalism", to: 2)
        
        // Add some power selections
        if let animalism = V5Constants.getV5Discipline(named: "Animalism") {
            let level1Powers = animalism.getPowers(for: 1)
            if let firstPower = level1Powers.first {
                originalCharacter.toggleV5Power(firstPower.id, for: "Animalism", at: 1)
            }
        }
        
        let updatedCharacter = originalCharacter.clone() as! VampireCharacter
        
        // Make changes
        updatedCharacter.setV5DisciplineLevel("Animalism", to: 3)
        updatedCharacter.setV5DisciplineLevel("Auspex", to: 1)
        
        // Add more power selections
        if let animalism = V5Constants.getV5Discipline(named: "Animalism") {
            let level2Powers = animalism.getPowers(for: 2)
            if let secondPower = level2Powers.first {
                updatedCharacter.toggleV5Power(secondPower.id, for: "Animalism", at: 2)
            }
        }
        
        let changeSummary = originalCharacter.generateChangeSummary(for: updatedCharacter)
        #expect(!changeSummary.isEmpty)
        #expect(changeSummary.contains("animalism level 2→3"))
        #expect(changeSummary.contains("auspex level 0→1"))
    }
    
    @Test func testV5DisciplineProgressSerialization() async throws {
        // Test that V5 discipline progress can be encoded and decoded
        var progress = V5DisciplineProgress(disciplineName: "Animalism", currentLevel: 3)
        let powerId1 = UUID()
        let powerId2 = UUID()
        
        progress.togglePower(powerId1, at: 1)
        progress.togglePower(powerId2, at: 2)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(progress)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(V5DisciplineProgress.self, from: data)
        
        #expect(decoded.disciplineName == "Animalism")
        #expect(decoded.currentLevel == 3)
        #expect(decoded.isPowerSelected(powerId1, at: 1))
        #expect(decoded.isPowerSelected(powerId2, at: 2))
        #expect(!decoded.isPowerSelected(powerId1, at: 2))
    }
}