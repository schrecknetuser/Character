import Testing
@testable import Character

struct PDFGenerationTests {
    
    @Test func testVampirePDFGeneration() async throws {
        // Create a test vampire character
        let vampire = VampireCharacter()
        vampire.name = "Test Vampire"
        vampire.clan = "Ventrue"
        vampire.concept = "Corporate Executive"
        vampire.chronicleName = "Test Chronicle"
        vampire.predatorType = "Sandman"
        vampire.generation = 10
        vampire.bloodPotency = 2
        vampire.humanity = 6
        vampire.hunger = 2
        vampire.experience = 15
        
        // Set some attributes
        vampire.physicalAttributes["Strength"] = 3
        vampire.physicalAttributes["Dexterity"] = 2
        vampire.physicalAttributes["Stamina"] = 3
        vampire.socialAttributes["Charisma"] = 4
        vampire.socialAttributes["Manipulation"] = 3
        vampire.socialAttributes["Composure"] = 3
        vampire.mentalAttributes["Intelligence"] = 3
        vampire.mentalAttributes["Wits"] = 2
        vampire.mentalAttributes["Resolve"] = 3
        
        // Set some skills
        vampire.socialSkills["Persuasion"] = 4
        vampire.socialSkills["Leadership"] = 3
        vampire.mentalSkills["Finance"] = 3
        vampire.physicalSkills["Brawl"] = 2
        
        // Generate PDF
        let pdfData = PDFGenerator.generateCharacterPDF(for: vampire)
        
        // Verify PDF was generated
        #expect(pdfData != nil)
        #expect((pdfData?.count ?? 0) > 1000)
        
        // Verify it starts with PDF magic bytes
        if let data = pdfData, data.count >= 4 {
            let prefix = data.prefix(4)
            let pdfSignature = Data([0x25, 0x50, 0x44, 0x46]) // "%PDF"
            #expect(prefix == pdfSignature)
        }
    }
    
    @Test func testGhoulPDFGeneration() async throws {
        // Create a test ghoul character
        let ghoul = GhoulCharacter()
        ghoul.name = "Test Ghoul"
        ghoul.concept = "Loyal Servant"
        ghoul.chronicleName = "Test Chronicle"
        ghoul.humanity = 7
        ghoul.experience = 10
        
        // Set some basic attributes
        ghoul.physicalAttributes["Strength"] = 2
        ghoul.socialAttributes["Charisma"] = 3
        ghoul.mentalAttributes["Intelligence"] = 2
        
        // Generate PDF
        let pdfData = PDFGenerator.generateCharacterPDF(for: ghoul)
        
        // Verify PDF was generated
        #expect(pdfData != nil)
        #expect((pdfData?.count ?? 0) > 1000)
    }
    
    @Test func testMagePDFGeneration() async throws {
        // Create a test mage character
        let mage = MageCharacter()
        mage.name = "Test Mage"
        mage.concept = "Academic Researcher"
        mage.chronicleName = "Test Chronicle"
        mage.paradigm = "Hermetic Order"
        mage.practice = "High Ritual Magic"
        mage.arete = 3
        
        // Set some basic attributes
        mage.physicalAttributes["Strength"] = 2
        mage.socialAttributes["Charisma"] = 2
        mage.mentalAttributes["Intelligence"] = 4
        
        // Set some spheres
        mage.spheres["Forces"] = 2
        mage.spheres["Prime"] = 1
        mage.spheres["Correspondence"] = 1
        
        // Generate PDF
        let pdfData = PDFGenerator.generateCharacterPDF(for: mage)
        
        // Verify PDF was generated
        #expect(pdfData != nil)
        #expect((pdfData?.count ?? 0) > 1000)
        
        // Verify quintessence defaults to 0
        #expect(mage.quintessence == 0)
    }
    
    @Test func testPDFGenerationWithEmptyCharacter() async throws {
        // Test with minimal character data
        let vampire = VampireCharacter()
        vampire.name = ""
        vampire.clan = ""
        
        // Should still generate a PDF, just with empty fields
        let pdfData = PDFGenerator.generateCharacterPDF(for: vampire)
        
        #expect(pdfData != nil)
    }
    
    @Test func testMageQuintessenceDefaultsToZero() async throws {
        // Create a new mage character
        let mage = MageCharacter()
        
        // Quintessence should default to 0
        #expect(mage.quintessence == 0)
        
        // Even after cloning
        let clonedMage = mage.clone() as! MageCharacter
        #expect(clonedMage.quintessence == 0)
    }
    
    @Test func testMageQuintessenceEditable() async throws {
        // Create a new mage character
        let mage = MageCharacter()
        
        // Should start at 0
        #expect(mage.quintessence == 0)
        
        // Should be able to increase to 7
        mage.quintessence = 3
        #expect(mage.quintessence == 3)
        
        mage.quintessence = 7
        #expect(mage.quintessence == 7)
        
        // Should be able to decrease back to 0
        mage.quintessence = 2
        #expect(mage.quintessence == 2)
        
        mage.quintessence = 0
        #expect(mage.quintessence == 0)
    }
}