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
        
        // Test QR code generation
        let qrImage = QRCodeGenerator.generateQRCode(from: vampire)
        XCTAssertNotNil(qrImage, "QR code should be generated successfully")
        
        // Test character data transfer
        let anyCharacter = AnyCharacter(vampire)
        guard let characterData = try? JSONEncoder().encode(anyCharacter),
              let jsonString = String(data: characterData, encoding: .utf8) else {
            XCTFail("Failed to encode character data")
            return
        }
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: jsonString)
        XCTAssertNotNil(importedCharacter, "Character should be imported successfully")
        XCTAssertEqual(importedCharacter?.name, vampire.name, "Character name should match")
        XCTAssertEqual(importedCharacter?.characterType, vampire.characterType, "Character type should match")
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
}