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
        
        // Test QR code generation (now uses gzip+base64 compression)
        let qrImage = QRCodeGenerator.generateQRCode(from: vampire)
        XCTAssertNotNil(qrImage, "QR code should be generated successfully")
        
        // Test character data transfer using gzip+base64 compression
        let fullData = CharacterDataTransfer.prepareCharacterForQR(vampire)
        
        // Encode to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let jsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode character data")
            return
        }
        
        // Compress using gzip+base64
        guard let compressedString = DataCompressor.compressForQR(jsonData) else {
            XCTFail("Failed to compress character data")
            return
        }
        
        print("Gzip+Base64 compressed QR data length: \(compressedString.count) characters")
        print("Original JSON size: \(jsonData.count) bytes")
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: compressedString)
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
        let invalidData = "This is not valid base64 data"
        let character = CharacterDataTransfer.importCharacter(from: invalidData)
        XCTAssertNil(character, "Invalid data should not import a character")
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
        
        // Test character data transfer using gzip+base64 compression
        let fullData = CharacterDataTransfer.prepareCharacterForQR(mage)
        
        // Encode to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let jsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode mage character data")
            return
        }
        
        // Compress using gzip+base64
        guard let compressedString = DataCompressor.compressForQR(jsonData) else {
            XCTFail("Failed to compress mage character data")
            return
        }
        
        print("Mage gzip+base64 compressed QR data length: \(compressedString.count) characters")
        print("Mage original JSON size: \(jsonData.count) bytes")
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: compressedString)
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
        
        // Test character data transfer using gzip+base64 compression
        let fullData = CharacterDataTransfer.prepareCharacterForQR(ghoul)
        
        // Encode to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let jsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode ghoul character data")
            return
        }
        
        // Compress using gzip+base64
        guard let compressedString = DataCompressor.compressForQR(jsonData) else {
            XCTFail("Failed to compress ghoul character data")
            return
        }
        
        print("Ghoul gzip+base64 compressed QR data length: \(compressedString.count) characters")
        print("Ghoul original JSON size: \(jsonData.count) bytes")
        
        // Test import
        let importedCharacter = CharacterDataTransfer.importCharacter(from: compressedString)
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
        // Create a character with lots of data to test compression on larger datasets
        let vampire = VampireCharacter()
        vampire.name = "Complex Test Vampire with Very Long Name That Repeats Common Words"
        vampire.clan = "Toreador"
        vampire.concept = "Renaissance Artist with Extensive Background"
        vampire.chronicleName = "Chronicle of Eternal Nights and Endless Adventures"
        vampire.characterDescription = "A very detailed character description that contains multiple paragraphs of text with repeated words and phrases to test compression efficiency. This vampire has lived for centuries and has extensive experience in various arts and crafts. The character has deep connections to the art world and maintains numerous contacts across different cities. This description demonstrates how gzip compression can handle large text fields efficiently."
        vampire.notes = "Session 1: Met the Prince and discussed territory rights. Session 2: Investigated strange occurrences in the museum district. Session 3: Attended the Elysium gathering and made new contacts. Session 4: Dealt with Sabbat incursion. Session 5: Explored the underground tunnels. These notes contain repetitive session structures that should compress well with gzip."
        vampire.ambition = "To become the greatest artist in the domain and establish a lasting legacy"
        vampire.desire = "To find redemption for past mistakes and protect mortal artists"
        
        // Add multiple similar specializations
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Singing"))
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Dancing"))
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Acting"))
        vampire.specializations.append(Specialization(skillName: "Craft", name: "Painting"))
        vampire.specializations.append(Specialization(skillName: "Craft", name: "Sculpting"))
        vampire.specializations.append(Specialization(skillName: "Craft", name: "Photography"))
        
        // Add background elements
        vampire.backgroundMerits.append(CharacterBackground(name: "Contacts", cost: 3, type: .merit))
        vampire.backgroundMerits.append(CharacterBackground(name: "Resources", cost: 4, type: .merit))
        vampire.backgroundMerits.append(CharacterBackground(name: "Haven", cost: 2, type: .merit))
        vampire.backgroundFlaws.append(CharacterBackground(name: "Enemy", cost: -2, type: .flaw))
        vampire.backgroundFlaws.append(CharacterBackground(name: "Hunted", cost: -3, type: .flaw))
        
        // Test gzip+base64 compression
        let fullData = CharacterDataTransfer.prepareCharacterForQR(vampire)
        
        // Encode to pretty-printed JSON (gzip will handle the redundancy)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let prettyJsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode character data")
            return
        }
        
        // Encode to compact JSON for comparison
        encoder.outputFormatting = []
        guard let compactJsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode character data")
            return
        }
        
        // Compress using gzip+base64
        guard let gzipCompressedString = DataCompressor.compressForQR(prettyJsonData) else {
            XCTFail("Failed to compress character data")
            return
        }
        
        print("=== Gzip+Base64 Compression Analysis ===")
        print("Pretty JSON size: \(prettyJsonData.count) bytes")
        print("Compact JSON size: \(compactJsonData.count) bytes")
        print("Gzip+Base64 compressed size: \(gzipCompressedString.count) characters")
        
        let prettyCompressionRatio = Double(gzipCompressedString.count) / Double(prettyJsonData.count)
        let compactCompressionRatio = Double(gzipCompressedString.count) / Double(compactJsonData.count)
        
        print("Compression ratio vs pretty JSON: \(String(format: "%.1f", prettyCompressionRatio * 100))%")
        print("Compression ratio vs compact JSON: \(String(format: "%.1f", compactCompressionRatio * 100))%")
        
        // Test that compression is effective
        XCTAssertLessThan(prettyCompressionRatio, 0.8, "Gzip should compress pretty JSON significantly")
        XCTAssertLessThan(compactCompressionRatio, 1.0, "Gzip should be better than or equal to compact JSON")
        
        // Test with even larger data to show how gzip scales
        let largeDescription = String(repeating: vampire.characterDescription, count: 5)
        let largeNotes = String(repeating: vampire.notes, count: 3)
        vampire.characterDescription = largeDescription
        vampire.notes = largeNotes
        
        let largeFullData = CharacterDataTransfer.prepareCharacterForQR(vampire)
        guard let largeJsonData = try? encoder.encode(largeFullData),
              let largeCompressedString = DataCompressor.compressForQR(largeJsonData) else {
            XCTFail("Failed to compress large character data")
            return
        }
        
        print("\n=== Large Data Compression Test ===")
        print("Large JSON size: \(largeJsonData.count) bytes")
        print("Large compressed size: \(largeCompressedString.count) characters")
        
        let largeCompressionRatio = Double(largeCompressedString.count) / Double(largeJsonData.count)
        print("Large data compression ratio: \(String(format: "%.1f", largeCompressionRatio * 100))%")
        
        // With repetitive data, gzip should perform even better
        XCTAssertLessThan(largeCompressionRatio, prettyCompressionRatio, "Gzip should perform better with more repetitive data")
        
        // Verify the compressed data can be decompressed and imported
        let importedCharacter = CharacterDataTransfer.importCharacter(from: gzipCompressedString)
        XCTAssertNotNil(importedCharacter, "Compressed character should be imported successfully")
        
        if let importedVampire = importedCharacter as? VampireCharacter {
            XCTAssertEqual(importedVampire.name, vampire.name, "Character name should match")
            XCTAssertEqual(importedVampire.specializations.count, vampire.specializations.count, "Specializations should match")
            XCTAssertEqual(importedVampire.backgroundMerits.count, vampire.backgroundMerits.count, "Background merits should match")
        }
    }
    
    func testQRBugFixes() throws {
        // Test specific bug fixes for QR export with gzip+base64 compression
        let vampire = VampireCharacter()
        vampire.name = "Bug Fix Test Vampire"
        vampire.clan = "Toreador"
        vampire.concept = "Test Artist"
        vampire.chronicleName = "Test Chronicle"
        vampire.characterDescription = "Test description with multiple paragraphs and repeated words that should compress well with gzip compression algorithm."
        vampire.notes = "Test notes with session information: Session 1 notes, Session 2 notes, Session 3 notes. These repetitive structures should compress efficiently."
        vampire.experience = 15
        vampire.spentExperience = 10
        vampire.ambition = "Test ambition with detailed goals"
        vampire.desire = "Test desire with specific motivations"
        
        // Add multiple specializations for the same skill (this used to cause crashes)
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Singing"))
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Dancing"))
        vampire.specializations.append(Specialization(skillName: "Performance", name: "Acting"))
        vampire.specializations.append(Specialization(skillName: "Craft", name: "Painting"))
        
        // Add background merits and flaws with costs
        vampire.backgroundMerits.append(CharacterBackground(name: "Contacts", cost: 3, type: .merit))
        vampire.backgroundMerits.append(CharacterBackground(name: "Resources", cost: 2, type: .merit))
        vampire.backgroundFlaws.append(CharacterBackground(name: "Enemy", cost: -2, type: .flaw))
        
        // Test that compression doesn't crash with multiple specializations
        let fullData = CharacterDataTransfer.prepareCharacterForQR(vampire)
        
        // Test that we can encode to JSON and compress without crashing
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let jsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode character data with multiple specializations")
            return
        }
        
        guard let compressedString = DataCompressor.compressForQR(jsonData) else {
            XCTFail("Failed to compress character data with multiple specializations")
            return
        }
        
        print("QR data with multiple specializations: \(compressedString.count) characters")
        print("Original JSON size: \(jsonData.count) bytes")
        
        // Test that import works correctly
        let importedCharacter = CharacterDataTransfer.importCharacter(from: compressedString)
        XCTAssertNotNil(importedCharacter, "Character should be imported successfully")
        
        guard let importedVampire = importedCharacter as? VampireCharacter else {
            XCTFail("Imported character should be a VampireCharacter")
            return
        }
        
        // Test that all fields are preserved
        XCTAssertEqual(importedVampire.experience, vampire.experience, "Experience should be preserved")
        XCTAssertEqual(importedVampire.spentExperience, vampire.spentExperience, "Spent experience should be preserved")
        XCTAssertEqual(importedVampire.ambition, vampire.ambition, "Ambition should be preserved")
        XCTAssertEqual(importedVampire.desire, vampire.desire, "Desire should be preserved")
        XCTAssertEqual(importedVampire.characterDescription, vampire.characterDescription, "Character description should be preserved")
        XCTAssertEqual(importedVampire.notes, vampire.notes, "Notes should be preserved")
        
        // Test that multiple specializations are preserved
        XCTAssertEqual(importedVampire.specializations.count, vampire.specializations.count, "All specializations should be preserved")
        
        let performanceSpecs = importedVampire.specializations.filter { $0.skillName == "Performance" }
        XCTAssertEqual(performanceSpecs.count, 3, "Multiple specializations for same skill should be preserved")
        
        let specNames = Set(performanceSpecs.map { $0.name })
        XCTAssertTrue(specNames.contains("Singing"), "Singing specialization should be preserved")
        XCTAssertTrue(specNames.contains("Dancing"), "Dancing specialization should be preserved")
        XCTAssertTrue(specNames.contains("Acting"), "Acting specialization should be preserved")
        
        // Test that background merits/flaws preserve costs
        XCTAssertEqual(importedVampire.backgroundMerits.count, vampire.backgroundMerits.count, "Background merits should be preserved")
        XCTAssertEqual(importedVampire.backgroundFlaws.count, vampire.backgroundFlaws.count, "Background flaws should be preserved")
        
        let contactsMerit = importedVampire.backgroundMerits.first { $0.name == "Contacts" }
        XCTAssertNotNil(contactsMerit, "Contacts merit should be preserved")
        XCTAssertEqual(contactsMerit?.cost, 3, "Contacts merit cost should be preserved")
        
        let enemyFlaw = importedVampire.backgroundFlaws.first { $0.name == "Enemy" }
        XCTAssertNotNil(enemyFlaw, "Enemy flaw should be preserved")
        XCTAssertEqual(enemyFlaw?.cost, -2, "Enemy flaw cost should be preserved")
    }
    
    func testGzipCompressionWithLargeText() throws {
        // Test that gzip compression handles unlimited length fields well
        let vampire = VampireCharacter()
        vampire.name = "Large Text Test Vampire"
        vampire.clan = "Toreador"
        
        // Create very large text fields to test gzip compression
        let repeatedText = "This is a test of gzip compression with repeated text patterns. "
        vampire.characterDescription = String(repeating: repeatedText, count: 50) // ~3000 characters
        vampire.notes = String(repeating: "Session notes: investigated, discovered, reported. ", count: 30) // ~1500 characters
        
        // Test compression
        let fullData = CharacterDataTransfer.prepareCharacterForQR(vampire)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let jsonData = try? encoder.encode(fullData) else {
            XCTFail("Failed to encode large text character data")
            return
        }
        
        guard let compressedString = DataCompressor.compressForQR(jsonData) else {
            XCTFail("Failed to compress large text character data")
            return
        }
        
        print("Large text JSON size: \(jsonData.count) bytes")
        print("Large text compressed size: \(compressedString.count) characters")
        
        let compressionRatio = Double(compressedString.count) / Double(jsonData.count)
        print("Large text compression ratio: \(String(format: "%.1f", compressionRatio * 100))%")
        
        // With repetitive text, gzip should achieve excellent compression
        XCTAssertLessThan(compressionRatio, 0.3, "Gzip should achieve excellent compression on repetitive text")
        
        // Test that the compressed data can be decompressed correctly
        let importedCharacter = CharacterDataTransfer.importCharacter(from: compressedString)
        XCTAssertNotNil(importedCharacter, "Character with large text should be imported successfully")
        
        if let importedVampire = importedCharacter as? VampireCharacter {
            XCTAssertEqual(importedVampire.characterDescription, vampire.characterDescription, "Large description should be preserved")
            XCTAssertEqual(importedVampire.notes, vampire.notes, "Large notes should be preserved")
        }
    }
    
    func testDateFieldsExport() throws {
        // Test that all date fields are properly exported and imported
        let testDate = Date(timeIntervalSince1970: 1000000000) // Fixed test date
        
        // Test vampire with dateOfBirth and dateOfEmbrace
        let vampire = VampireCharacter()
        vampire.name = "Date Test Vampire"
        vampire.clan = "Toreador"
        vampire.dateOfBirth = testDate
        vampire.dateOfEmbrace = Date(timeIntervalSince1970: 1500000000)
        
        // Test QR export and import
        let vampireQR = QRCodeGenerator.generateQRCode(from: vampire)
        XCTAssertNotNil(vampireQR, "Vampire QR code should be generated")
        
        // Test data transfer
        let vampireData = CharacterDataTransfer.prepareCharacterForQR(vampire)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        guard let jsonData = try? encoder.encode(vampireData),
              let compressedString = DataCompressor.compressForQR(jsonData) else {
            XCTFail("Failed to compress vampire data")
            return
        }
        
        let importedVampire = CharacterDataTransfer.importCharacter(from: compressedString)
        XCTAssertNotNil(importedVampire, "Vampire should be imported")
        
        if let importedVampire = importedVampire as? VampireCharacter {
            XCTAssertEqual(importedVampire.dateOfBirth, vampire.dateOfBirth, "dateOfBirth should be preserved")
            XCTAssertEqual(importedVampire.dateOfEmbrace, vampire.dateOfEmbrace, "dateOfEmbrace should be preserved")
        } else {
            XCTFail("Imported character should be a VampireCharacter")
        }
        
        // Test ghoul with dateOfBirth and dateOfGhouling
        let ghoul = GhoulCharacter()
        ghoul.name = "Date Test Ghoul"
        ghoul.dateOfBirth = testDate
        ghoul.dateOfGhouling = Date(timeIntervalSince1970: 1600000000)
        
        let ghoulData = CharacterDataTransfer.prepareCharacterForQR(ghoul)
        guard let ghoulJsonData = try? encoder.encode(ghoulData),
              let ghoulCompressedString = DataCompressor.compressForQR(ghoulJsonData) else {
            XCTFail("Failed to compress ghoul data")
            return
        }
        
        let importedGhoul = CharacterDataTransfer.importCharacter(from: ghoulCompressedString)
        XCTAssertNotNil(importedGhoul, "Ghoul should be imported")
        
        if let importedGhoul = importedGhoul as? GhoulCharacter {
            XCTAssertEqual(importedGhoul.dateOfBirth, ghoul.dateOfBirth, "dateOfBirth should be preserved")
            XCTAssertEqual(importedGhoul.dateOfGhouling, ghoul.dateOfGhouling, "dateOfGhouling should be preserved")
        } else {
            XCTFail("Imported character should be a GhoulCharacter")
        }
        
        // Test mage with dateOfBirth and dateOfAwakening
        let mage = MageCharacter()
        mage.name = "Date Test Mage"
        mage.dateOfBirth = testDate
        mage.dateOfAwakening = Date(timeIntervalSince1970: 1700000000)
        
        let mageData = CharacterDataTransfer.prepareCharacterForQR(mage)
        guard let mageJsonData = try? encoder.encode(mageData),
              let mageCompressedString = DataCompressor.compressForQR(mageJsonData) else {
            XCTFail("Failed to compress mage data")
            return
        }
        
        let importedMage = CharacterDataTransfer.importCharacter(from: mageCompressedString)
        XCTAssertNotNil(importedMage, "Mage should be imported")
        
        if let importedMage = importedMage as? MageCharacter {
            XCTAssertEqual(importedMage.dateOfBirth, mage.dateOfBirth, "dateOfBirth should be preserved")
            XCTAssertEqual(importedMage.dateOfAwakening, mage.dateOfAwakening, "dateOfAwakening should be preserved")
        } else {
            XCTFail("Imported character should be a MageCharacter")
        }
        
        // Test nil dates (should not crash)
        let vampireNilDates = VampireCharacter()
        vampireNilDates.name = "Nil Date Vampire"
        vampireNilDates.dateOfBirth = nil
        vampireNilDates.dateOfEmbrace = nil
        
        let nilDateData = CharacterDataTransfer.prepareCharacterForQR(vampireNilDates)
        guard let nilDateJsonData = try? encoder.encode(nilDateData),
              let nilDateCompressedString = DataCompressor.compressForQR(nilDateJsonData) else {
            XCTFail("Failed to compress nil date data")
            return
        }
        
        let importedNilDateVampire = CharacterDataTransfer.importCharacter(from: nilDateCompressedString)
        XCTAssertNotNil(importedNilDateVampire, "Vampire with nil dates should be imported")
        
        if let importedNilDateVampire = importedNilDateVampire as? VampireCharacter {
            XCTAssertNil(importedNilDateVampire.dateOfBirth, "dateOfBirth should remain nil")
            XCTAssertNil(importedNilDateVampire.dateOfEmbrace, "dateOfEmbrace should remain nil")
        } else {
            XCTFail("Imported character should be a VampireCharacter")
        }
        
        print("Date fields export test completed successfully")
    }
}