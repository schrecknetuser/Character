import XCTest
@testable import Character

final class QRCodeTests: XCTestCase {
    
    func testQRCodeGeneration() throws {
        // Create a test vampire character
        let vampire = VampireCharacter()
        vampire.name = "Test Vampire"
        vampire.clan = "Toreador"
        vampire.concept = "Artist"
        vampire.chronicleName = "Test Chronicle"
        
        // Test QR code generation (now uses compressed format)
        let qrImage = QRCodeGenerator.generateQRCode(from: vampire)
        XCTAssertNotNil(qrImage, "QR code should be generated successfully")
        
        // Test character data transfer using compressed format
        let compressedData = CharacterDataTransfer.compressCharacterForQR(vampire)
        guard let characterData = try? JSONEncoder().encode(compressedData),
              let jsonString = String(data: characterData, encoding: .utf8) else {
            XCTFail("Failed to encode compressed character data")
            return
        }
        
        print("Compressed QR data length: \(jsonString.count) characters")
        XCTAssertLessThan(jsonString.count, 2000, "Compressed data should be under 2000 characters for reliable QR scanning")
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: jsonString)
        XCTAssertNotNil(importedCharacter, "Character should be imported successfully")
        XCTAssertEqual(importedCharacter?.name, vampire.name, "Character name should match")
        XCTAssertEqual(importedCharacter?.characterType, vampire.characterType, "Character type should match")
        
        // Test that essential data is preserved
        if let importedVampire = importedCharacter as? VampireCharacter {
            XCTAssertEqual(importedVampire.clan, vampire.clan, "Clan should match")
            XCTAssertEqual(importedVampire.concept, vampire.concept, "Concept should match")
        }
    }
    
    func testCharacterSummary() throws {
        let vampire = VampireCharacter()
        vampire.name = "Test Vampire"
        vampire.clan = "Toreador"
        vampire.concept = "Artist"
        
        let summary = CharacterDataTransfer.getCharacterSummary(for: vampire)
        
        XCTAssertTrue(summary.contains("Test Vampire"), "Summary should contain character name")
        XCTAssertTrue(summary.contains("Vampire"), "Summary should contain character type")
        XCTAssertTrue(summary.contains("Toreador"), "Summary should contain clan")
        XCTAssertTrue(summary.contains("Artist"), "Summary should contain concept")
    }
    
    func testInvalidQRData() throws {
        let invalidData = "This is not valid JSON"
        let character = CharacterDataTransfer.importCharacter(from: invalidData)
        XCTAssertNil(character, "Invalid data should not import a character")
    }
    
    func testBackwardsCompatibility() throws {
        // Test that old full format QR codes still work (fallback)
        let vampire = VampireCharacter()
        vampire.name = "Legacy Test Vampire"
        vampire.clan = "Nosferatu"
        
        // Create legacy format (full AnyCharacter encoding)
        let anyCharacter = AnyCharacter(vampire)
        guard let legacyData = try? JSONEncoder().encode(anyCharacter),
              let legacyJsonString = String(data: legacyData, encoding: .utf8) else {
            XCTFail("Failed to encode legacy character data")
            return
        }
        
        // Test that legacy format can still be imported
        let importedCharacter = CharacterDataTransfer.importCharacter(from: legacyJsonString)
        XCTAssertNotNil(importedCharacter, "Legacy character should be imported successfully")
        XCTAssertEqual(importedCharacter?.name, vampire.name, "Legacy character name should match")
    }
    
    func testMageQRCodeGeneration() throws {
        // Create a test mage character
        let mage = MageCharacter()
        mage.name = "Test Mage"
        mage.concept = "Digital Wizard"
        mage.chronicleName = "Technomancer Chronicle"
        mage.paradigm = "Digital Web Theory"
        mage.practice = "High Ritual Magick"
        mage.arete = 3
        mage.paradox = 2
        mage.hubris = 1
        mage.quiet = 0
        mage.essence = .dynamic
        mage.resonance = .elemental
        mage.synergy = .beneficial
        
        // Set some sphere values
        mage.spheres["Correspondence"] = 2
        mage.spheres["Forces"] = 3
        mage.spheres["Matter"] = 1
        
        // Test QR code generation
        let qrImage = QRCodeGenerator.generateQRCode(from: mage)
        XCTAssertNotNil(qrImage, "QR code should be generated successfully for Mage")
        
        // Test character data transfer using compressed format
        let compressedData = CharacterDataTransfer.compressCharacterForQR(mage)
        guard let characterData = try? JSONEncoder().encode(compressedData),
              let jsonString = String(data: characterData, encoding: .utf8) else {
            XCTFail("Failed to encode compressed mage character data")
            return
        }
        
        print("Mage compressed QR data length: \(jsonString.count) characters")
        XCTAssertLessThan(jsonString.count, 2000, "Compressed mage data should be under 2000 characters for reliable QR scanning")
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: jsonString)
        XCTAssertNotNil(importedCharacter, "Mage character should be imported successfully")
        XCTAssertEqual(importedCharacter?.name, mage.name, "Mage character name should match")
        XCTAssertEqual(importedCharacter?.characterType, mage.characterType, "Mage character type should match")
        
        // Test that essential mage data is preserved
        if let importedMage = importedCharacter as? MageCharacter {
            XCTAssertEqual(importedMage.concept, mage.concept, "Mage concept should match")
            XCTAssertEqual(importedMage.paradigm, mage.paradigm, "Mage paradigm should match")
            XCTAssertEqual(importedMage.practice, mage.practice, "Mage practice should match")
            XCTAssertEqual(importedMage.arete, mage.arete, "Mage arete should match")
            XCTAssertEqual(importedMage.paradox, mage.paradox, "Mage paradox should match")
            XCTAssertEqual(importedMage.hubris, mage.hubris, "Mage hubris should match")
            XCTAssertEqual(importedMage.quiet, mage.quiet, "Mage quiet should match")
            XCTAssertEqual(importedMage.essence, mage.essence, "Mage essence should match")
            XCTAssertEqual(importedMage.resonance, mage.resonance, "Mage resonance should match")
            XCTAssertEqual(importedMage.synergy, mage.synergy, "Mage synergy should match")
            XCTAssertEqual(importedMage.spheres["Correspondence"], mage.spheres["Correspondence"], "Mage sphere values should match")
            XCTAssertEqual(importedMage.spheres["Forces"], mage.spheres["Forces"], "Mage sphere values should match")
            XCTAssertEqual(importedMage.spheres["Matter"], mage.spheres["Matter"], "Mage sphere values should match")
        } else {
            XCTFail("Imported character should be a MageCharacter")
        }
    }
    
    func testMageCharacterSummary() throws {
        let mage = MageCharacter()
        mage.name = "Test Mage"
        mage.concept = "Digital Wizard"
        mage.arete = 3
        
        let summary = CharacterDataTransfer.getCharacterSummary(for: mage)
        
        XCTAssertTrue(summary.contains("Test Mage"), "Summary should contain mage character name")
        XCTAssertTrue(summary.contains("Mage"), "Summary should contain character type")
        XCTAssertTrue(summary.contains("Digital Wizard"), "Summary should contain concept")
        XCTAssertTrue(summary.contains("Arete: 3"), "Summary should contain arete value")
    }
    
    func testGhoulQRCodeGeneration() throws {
        // Create a test ghoul character
        let ghoul = GhoulCharacter()
        ghoul.name = "Test Ghoul"
        ghoul.concept = "Loyal Servant"
        ghoul.chronicleName = "Ghoul Chronicle"
        ghoul.humanity = 6
        
        // Test QR code generation
        let qrImage = QRCodeGenerator.generateQRCode(from: ghoul)
        XCTAssertNotNil(qrImage, "QR code should be generated successfully for Ghoul")
        
        // Test character data transfer using compressed format
        let compressedData = CharacterDataTransfer.compressCharacterForQR(ghoul)
        guard let characterData = try? JSONEncoder().encode(compressedData),
              let jsonString = String(data: characterData, encoding: .utf8) else {
            XCTFail("Failed to encode compressed ghoul character data")
            return
        }
        
        print("Ghoul compressed QR data length: \(jsonString.count) characters")
        XCTAssertLessThan(jsonString.count, 2000, "Compressed ghoul data should be under 2000 characters for reliable QR scanning")
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: jsonString)
        XCTAssertNotNil(importedCharacter, "Ghoul character should be imported successfully")
        XCTAssertEqual(importedCharacter?.name, ghoul.name, "Ghoul character name should match")
        XCTAssertEqual(importedCharacter?.characterType, ghoul.characterType, "Ghoul character type should match")
        
        // Test that essential ghoul data is preserved
        if let importedGhoul = importedCharacter as? GhoulCharacter {
            XCTAssertEqual(importedGhoul.concept, ghoul.concept, "Ghoul concept should match")
            XCTAssertEqual(importedGhoul.humanity, ghoul.humanity, "Ghoul humanity should match")
        } else {
            XCTFail("Imported character should be a GhoulCharacter")
        }
    }

    func testCompressionEfficiency() throws {
        // Create a character with lots of data
        let vampire = VampireCharacter()
        vampire.name = "Complex Test Vampire"
        vampire.clan = "Toreador"
        vampire.concept = "Renaissance Artist"
        vampire.chronicleName = "Chronicle of Eternal Nights"
        vampire.characterDescription = "A detailed character with extensive background"
        vampire.notes = "Lots of session notes and character development"
        
        // Add some specializations
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Singing"))
        vampire.specializations.append(Specialization(skillName: "Craft", name: "Painting"))
        
        // Create both formats
        let compressedData = CharacterDataTransfer.compressCharacterForQR(vampire)
        let anyCharacter = AnyCharacter(vampire)
        
        guard let compressedJson = try? JSONEncoder().encode(compressedData),
              let fullJson = try? JSONEncoder().encode(anyCharacter),
              let compressedString = String(data: compressedJson, encoding: .utf8),
              let fullString = String(data: fullJson, encoding: .utf8) else {
            XCTFail("Failed to encode character data")
            return
        }
        
        print("Full format size: \(fullString.count) characters")
        print("Compressed format size: \(compressedString.count) characters")
        
        // Verify compression is significantly smaller
        let compressionRatio = Double(compressedString.count) / Double(fullString.count)
        XCTAssertLessThan(compressionRatio, 0.5, "Compressed format should be less than 50% of full format")
        XCTAssertLessThan(compressedString.count, 2000, "Compressed format should be under 2000 characters")
    }
}