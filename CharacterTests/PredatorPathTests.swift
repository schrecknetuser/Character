import Testing
@testable import Character

struct PredatorPathTests {
    
    @Test func testPredatorPathInitialization() async throws {
        // Test that predator paths are properly defined
        let predatorPaths = V5Constants.predatorPaths
        
        #expect(predatorPaths.count > 0)
        #expect(predatorPaths.contains { $0.name == "Alleycat" })
        #expect(predatorPaths.contains { $0.name == "Bagger" })
        #expect(predatorPaths.contains { $0.name == "Cleaver" })
        #expect(predatorPaths.contains { $0.name == "Siren" })
    }
    
    @Test func testPredatorPathDetails() async throws {
        // Test specific predator path details
        let alleycat = V5Constants.getPredatorPath(named: "Alleycat")
        
        #expect(alleycat != nil)
        #expect(alleycat?.name == "Alleycat")
        #expect(alleycat?.description.isEmpty == false)
        #expect(alleycat?.bonuses.isEmpty == false)
        #expect(alleycat?.drawbacks.isEmpty == false)
        #expect(alleycat?.feedingDescription.isEmpty == false)
    }
    
    @Test func testVampireCharacterPredatorPath() async throws {
        // Test that vampire characters can have predator paths
        let vampire = VampireCharacter()
        
        #expect(vampire.predatorPath == "")
        
        vampire.predatorPath = "Alleycat"
        #expect(vampire.predatorPath == "Alleycat")
    }
    
    @Test func testPredatorPathBonusTypes() async throws {
        // Test that predator path bonuses have proper types
        let farmer = V5Constants.getPredatorPath(named: "Farmer")
        
        #expect(farmer != nil)
        
        let disciplineBonus = farmer?.bonuses.first { $0.type == .disciplineDot }
        #expect(disciplineBonus != nil)
        #expect(disciplineBonus?.disciplineName == "Animalism")
        
        let skillBonus = farmer?.bonuses.first { $0.type == .skillSpecialization }
        #expect(skillBonus != nil)
        #expect(skillBonus?.skillName == "Animal Ken")
    }
    
    @Test func testAllPredatorPathNames() async throws {
        // Test that we can get all predator path names
        let pathNames = V5Constants.getAllPredatorPathNames()
        
        #expect(pathNames.count > 0)
        #expect(pathNames.contains("Alleycat"))
        #expect(pathNames.contains("Bagger"))
        #expect(pathNames.contains("Blood Leech"))
        #expect(pathNames.contains("Cleaver"))
        #expect(pathNames.contains("Consensualist"))
        #expect(pathNames.contains("Farmer"))
        #expect(pathNames.contains("Osiris"))
        #expect(pathNames.contains("Sandman"))
        #expect(pathNames.contains("Scene Queen"))
        #expect(pathNames.contains("Siren"))
    }
}