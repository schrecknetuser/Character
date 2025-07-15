import Testing
@testable import Character

struct PredatorTypeTests {
    
    @Test func testPredatorTypeInitialization() async throws {
        // Test that predator types are properly defined
        let predatorTypes = V5Constants.predatorTypes
        
        #expect(predatorTypes.count > 0)
        #expect(predatorTypes.contains { $0.name == "Alleycat" })
        #expect(predatorTypes.contains { $0.name == "Bagger" })
        #expect(predatorTypes.contains { $0.name == "Cleaver" })
        #expect(predatorTypes.contains { $0.name == "Siren" })
    }
    
    @Test func testPredatorTypeDetails() async throws {
        // Test specific predator type details
        let alleycat = V5Constants.getPredatorType(named: "Alleycat")
        
        #expect(alleycat != nil)
        #expect(alleycat?.name == "Alleycat")
        #expect(alleycat?.description.isEmpty == false)
        #expect(alleycat?.bonuses.isEmpty == false)
        #expect(alleycat?.drawbacks.isEmpty == false)
        #expect(alleycat?.feedingDescription.isEmpty == false)
    }
    
    @Test func testVampireCharacterPredatorType() async throws {
        // Test that vampire characters can have predator types
        let vampire = VampireCharacter()
        
        #expect(vampire.predatorType == "")
        
        vampire.predatorType = "Alleycat"
        #expect(vampire.predatorType == "Alleycat")
    }
    
    @Test func testPredatorTypeBonusTypes() async throws {
        // Test that predator type bonuses have proper types
        let farmer = V5Constants.getPredatorType(named: "Farmer")
        
        #expect(farmer != nil)
        
        let disciplineBonus = farmer?.bonuses.first { $0.type == .disciplineDot }
        #expect(disciplineBonus != nil)
        #expect(disciplineBonus?.disciplineName == "Animalism")
        
        let skillBonus = farmer?.bonuses.first { $0.type == .skillSpecialization }
        #expect(skillBonus != nil)
        #expect(skillBonus?.skillName == "Animal Ken")
    }
    
    @Test func testAllPredatorTypeNames() async throws {
        // Test that we can get all predator type names
        let typeNames = V5Constants.getAllPredatorTypeNames()
        
        #expect(typeNames.count > 0)
        #expect(typeNames.contains("Alleycat"))
        #expect(typeNames.contains("Bagger"))
        #expect(typeNames.contains("Blood Leech"))
        #expect(typeNames.contains("Cleaver"))
        #expect(typeNames.contains("Consensualist"))
        #expect(typeNames.contains("Farmer"))
        #expect(typeNames.contains("Osiris"))
        #expect(typeNames.contains("Sandman"))
        #expect(typeNames.contains("Scene Queen"))
        #expect(typeNames.contains("Siren"))
    }
}