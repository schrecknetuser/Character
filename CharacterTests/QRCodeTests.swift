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