import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation
import Compression
import Foundation

// MARK: - Compression Utilities
struct DataCompressor {
    /// Compress data using gzip and encode as base64 for QR codes
    static func compressForQR(_ data: Data) -> String? {
        guard let compressedData = compress(data: data) else {
            print("Failed to compress data")
            return nil
        }
        
        let base64String = compressedData.base64EncodedString()
        print("Original size: \(data.count) bytes")
        print("Compressed size: \(compressedData.count) bytes")
        print("Base64 size: \(base64String.count) characters")
        print("Compression ratio: \(String(format: "%.1f", Double(compressedData.count) / Double(data.count) * 100))%")
        
        return base64String
    }
    
    /// Decompress base64 encoded gzip data
    static func decompressFromQR(_ base64String: String) -> Data? {
        guard let compressedData = Data(base64Encoded: base64String) else {
            print("Failed to decode base64 data")
            return nil
        }
        
        return decompress(data: compressedData)
    }
    
    /// Compress data using gzip
    private static func compress(data: Data) -> Data? {
        return data.withUnsafeBytes { bytes in
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
            defer { buffer.deallocate() }
            
            let compressedSize = compression_encode_buffer(
                buffer, data.count,
                bytes.bindMemory(to: UInt8.self).baseAddress!, data.count,
                nil, COMPRESSION_LZFSE
            )
            
            guard compressedSize > 0 else {
                print("Compression failed with LZFSE, trying LZMA")
                
                // Try LZMA compression as fallback
                let lzmaSize = compression_encode_buffer(
                    buffer, data.count,
                    bytes.bindMemory(to: UInt8.self).baseAddress!, data.count,
                    nil, COMPRESSION_LZMA
                )
                
                guard lzmaSize > 0 else {
                    print("All compression algorithms failed")
                    return nil
                }
                
                return Data(bytes: buffer, count: lzmaSize)
            }
            
            return Data(bytes: buffer, count: compressedSize)
        }
    }
    
    /// Decompress gzip data
    private static func decompress(data: Data) -> Data? {
        return data.withUnsafeBytes { bytes in
            // Estimate decompressed size (start with 4x compressed size)
            let estimatedSize = data.count * 4
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: estimatedSize)
            defer { buffer.deallocate() }
            
            // Try LZFSE first
            var decompressedSize = compression_decode_buffer(
                buffer, estimatedSize,
                bytes.bindMemory(to: UInt8.self).baseAddress!, data.count,
                nil, COMPRESSION_LZFSE
            )
            
            if decompressedSize == 0 {
                print("LZFSE decompression failed, trying LZMA")
                
                // Try LZMA as fallback
                decompressedSize = compression_decode_buffer(
                    buffer, estimatedSize,
                    bytes.bindMemory(to: UInt8.self).baseAddress!, data.count,
                    nil, COMPRESSION_LZMA
                )
                
                if decompressedSize == 0 {
                    print("All decompression algorithms failed")
                    return nil
                }
            }
            
            return Data(bytes: buffer, count: decompressedSize)
        }
    }
}

// MARK: - QR Code Generation
struct QRCodeGenerator {
    /// Generate a QR code image from character data using gzip+base64 compression
    static func generateQRCode(from character: any BaseCharacter) -> UIImage? {
        // Convert character to JSON for compression
        let characterData = CharacterDataTransfer.prepareCharacterForQR(character)
        
        // Use pretty-printed JSON since compression will handle the redundancy
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        
        guard let jsonData = try? encoder.encode(characterData),
              let compressedString = DataCompressor.compressForQR(jsonData) else {
            print("Failed to compress character data")
            return nil
        }
        
        print("QR code compressed data length: \(compressedString.count) characters")
        
        // Verify the data can be decoded back
        if let _ = CharacterDataTransfer.importCharacter(from: compressedString) {
            print("✓ QR data validation successful")
        } else {
            print("✗ QR data validation failed - generated data cannot be imported")
            return nil
        }
        
        return generateQRCode(from: compressedString)
    }
    
    /// Generate a QR code image from string data
    static func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        // Ensure string is valid UTF-8 and not too long
        guard let data = string.data(using: .utf8) else {
            print("Failed to encode string as UTF-8")
            return nil
        }
        
        print("Generating QR code for \(data.count) bytes of data")
        
        // Check data size - QR codes have limits
        if data.count > 2000 {
            print("Warning: Data size (\(data.count) bytes) may be too large for reliable QR code scanning")
        }
        
        filter.message = data
        
        // Use medium error correction for better balance between reliability and capacity
        filter.correctionLevel = "M"
        
        guard let outputImage = filter.outputImage else {
            print("Failed to generate QR code - data might be too large or invalid")
            return nil
        }
        
        // Create a properly scaled image without interpolation artifacts
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        // Render with nearest neighbor to keep sharp pixels
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            print("Failed to create CGImage from QR code")
            return nil
        }
        
        let finalImage = UIImage(cgImage: cgImage)
        print("Generated QR code image: \(finalImage.size)")
        
        return finalImage
    }
}

// MARK: - QR Code Scanning
class QRCodeScanner: NSObject, ObservableObject {
    @Published var scannedCode: String?
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override init() {
        super.init()
    }
    
    func startScanning() {
        hasError = false
        scannedCode = nil
        
        // Clean up any existing session
        stopScanning()
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            setError("Camera not available")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if captureSession?.canAddInput(videoInput) == true {
                captureSession?.addInput(videoInput)
            } else {
                setError("Could not add video input")
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if captureSession?.canAddOutput(metadataOutput) == true {
                captureSession?.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                setError("Could not add metadata output")
                return
            }
            
            // Create preview layer and ensure it's configured properly
            if let session = captureSession {
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer?.videoGravity = .resizeAspectFill
                
                // Start session on background queue after setup is complete
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                    
                    // Notify on main thread that session has started
                    DispatchQueue.main.async {
                        // Trigger UI update
                        self.objectWillChange.send()
                    }
                }
            }
            
        } catch {
            setError("Camera setup failed: \(error.localizedDescription)")
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        captureSession = nil
        previewLayer = nil
    }
    
    private func setError(_ message: String) {
        errorMessage = message
        hasError = true
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Stop scanning once we get a result
            stopScanning()
            
            // Update on main thread
            DispatchQueue.main.async {
                self.scannedCode = stringValue
            }
        }
    }
}

// MARK: - Full Character Data for QR Codes (with gzip compression)
struct FullCharacterData: Codable {
    // Basic info (full field names since compression handles redundancy)
    let name: String
    let type: String
    let concept: String
    let chronicleName: String
    
    // Attributes
    let physicalAttributes: [String: Int]
    let socialAttributes: [String: Int]
    let mentalAttributes: [String: Int]
    
    // Skills
    let physicalSkills: [String: Int]
    let socialSkills: [String: Int]
    let mentalSkills: [String: Int]
    
    // Essential character stats
    let willpower: Int
    let health: Int
    
    // Specializations (array to handle multiple specializations per skill)
    let specializations: [[String]] // [skillName, specializationName] pairs
    
    // Experience fields
    let experience: Int
    let spentExperience: Int
    
    // Character details
    let ambition: String
    let desire: String
    let characterDescription: String
    let notes: String
    
    // Date fields
    let dateOfBirth: Date?
    
    // Background merits and flaws with costs preserved
    let backgroundMerits: [[String]] // [name, cost] pairs
    let backgroundFlaws: [[String]] // [name, cost] pairs
    
    // Merit/Flaw names only (descriptions from constants)
    let advantageNames: [String]
    let flawNames: [String]
    
    // Convictions and touchstones
    let convictions: [String]
    let touchstones: [String]
    
    // Character-specific data
    let vampireData: VampireFullData?
    let ghoulData: GhoulFullData?
    let mageData: MageFullData?
}

struct VampireFullData: Codable {
    let clan: String
    let generation: Int
    let bloodPotency: Int
    let humanity: Int
    let hunger: Int
    let predatorType: String
    let dateOfEmbrace: Date?
    let selectedDisciplinePowers: [String: [String]]
}

struct GhoulFullData: Codable {
    let humanity: Int
    let dateOfGhouling: Date?
    let selectedDisciplinePowers: [String: [String]]
}

struct MageFullData: Codable {
    let arete: Int
    let paradox: Int
    let hubris: Int
    let quiet: Int
    let paradigm: String
    let practice: String
    let essence: String
    let resonance: String
    let synergy: String
    let dateOfAwakening: Date?
    let spheres: [String: Int]
}

// MARK: - Character Import/Export Utilities
struct CharacterDataTransfer {
    /// Try to import a character from QR code data (gzip+base64 compressed)
    static func importCharacter(from qrData: String) -> (any BaseCharacter)? {
        // First try to decompress as gzip+base64
        guard let decompressedData = DataCompressor.decompressFromQR(qrData) else {
            print("Failed to decompress QR data")
            return nil
        }
        
        do {
            // Try to decode the full format
            let fullData = try JSONDecoder().decode(FullCharacterData.self, from: decompressedData)
            return expandCharacterFromFull(fullData)
        } catch {
            print("Failed to decode character from QR data: \(error)")
            return nil
        }
    }
    
    /// Generate a formatted summary of character data for display
    static func getCharacterSummary(for character: any BaseCharacter) -> String {
        var summary = "Character: \(character.name)\n"
        summary += "Type: \(character.characterType.displayName)\n"
        
        if !character.concept.isEmpty {
            summary += "Concept: \(character.concept)\n"
        }
        
        if !character.chronicleName.isEmpty {
            summary += "Chronicle: \(character.chronicleName)\n"
        }
        
        // Add character-specific info
        switch character.characterType {
        case .vampire:
            if let vampire = character as? VampireCharacter, !vampire.clan.isEmpty {
                summary += "Clan: \(vampire.clan)\n"
            }
        case .mage:
            if let mage = character as? MageCharacter {
                summary += "Arete: \(mage.arete)\n"
            }
        case .ghoul:
            if let ghoul = character as? GhoulCharacter {
                summary += "Humanity: \(ghoul.humanity)\n"
            }
        }
        
        return summary
    }
    
    /// Prepare character data for QR code compression
    static func prepareCharacterForQR(_ character: any BaseCharacter) -> FullCharacterData {
        // Extract specializations as name pairs
        let specializationPairs = character.specializations.map { spec in
            [spec.skillName, spec.name]
        }
        
        // Extract merit/flaw names only
        let advantageNames = character.advantages.map { $0.name }
        let flawNames = character.flaws.map { $0.name }
        
        // Extract background merits/flaws with costs preserved
        let backgroundMerits = character.backgroundMerits.map { [$0.name, String($0.cost)] }
        let backgroundFlaws = character.backgroundFlaws.map { [$0.name, String($0.cost)] }
        
        // Character-specific data
        var vampireData: VampireFullData? = nil
        var ghoulData: GhoulFullData? = nil
        var mageData: MageFullData? = nil
        
        if let vampire = character as? VampireCharacter {
            let disciplinePowers = extractSelectedDisciplinePowers(vampire.v5Disciplines)
            vampireData = VampireFullData(
                clan: vampire.clan,
                generation: vampire.generation,
                bloodPotency: vampire.bloodPotency,
                humanity: vampire.humanity,
                hunger: vampire.hunger,
                predatorType: vampire.predatorType,
                dateOfEmbrace: vampire.dateOfEmbrace,
                selectedDisciplinePowers: disciplinePowers
            )
        } else if let ghoul = character as? GhoulCharacter {
            let disciplinePowers = extractSelectedDisciplinePowers(ghoul.v5Disciplines)
            ghoulData = GhoulFullData(
                humanity: ghoul.humanity,
                dateOfGhouling: ghoul.dateOfGhouling,
                selectedDisciplinePowers: disciplinePowers
            )
        } else if let mage = character as? MageCharacter {
            mageData = MageFullData(
                arete: mage.arete,
                paradox: mage.paradox,
                hubris: mage.hubris,
                quiet: mage.quiet,
                paradigm: mage.paradigm,
                practice: mage.practice,
                essence: mage.essence.rawValue,
                resonance: mage.resonance.rawValue,
                synergy: mage.synergy.rawValue,
                dateOfAwakening: mage.dateOfAwakening,
                spheres: mage.spheres
            )
        }
        
        return FullCharacterData(
            name: character.name,
            type: character.characterType.rawValue,
            concept: character.concept,
            chronicleName: character.chronicleName,
            physicalAttributes: character.physicalAttributes,
            socialAttributes: character.socialAttributes,
            mentalAttributes: character.mentalAttributes,
            physicalSkills: character.physicalSkills,
            socialSkills: character.socialSkills,
            mentalSkills: character.mentalSkills,
            willpower: character.willpower,
            health: character.health,
            specializations: specializationPairs,
            experience: character.experience,
            spentExperience: character.spentExperience,
            ambition: character.ambition,
            desire: character.desire,
            characterDescription: character.characterDescription,
            notes: character.notes,
            dateOfBirth: character.dateOfBirth,
            backgroundMerits: backgroundMerits,
            backgroundFlaws: backgroundFlaws,
            advantageNames: advantageNames,
            flawNames: flawNames,
            convictions: character.convictions,
            touchstones: character.touchstones,
            vampireData: vampireData,
            ghoulData: ghoulData,
            mageData: mageData
        )
    }
    
    /// Extract selected discipline power names only
    private static func extractSelectedDisciplinePowers(_ disciplines: [V5Discipline]) -> [String: [String]] {
        var result: [String: [String]] = [:]
        
        for discipline in disciplines {
            var powerNames: [String] = []
            for level in discipline.getLevels() {
                let selectedPowers = discipline.selectedPowers[level] ?? []
                powerNames.append(contentsOf: selectedPowers.map { $0.name })
            }
            if !powerNames.isEmpty {
                result[discipline.name] = powerNames
            }
        }
        
        return result
    }
    
    /// Expand full character data back to character object
    private static func expandCharacterFromFull(_ fullData: FullCharacterData) -> (any BaseCharacter)? {
        let characterType = CharacterType(rawValue: fullData.type) ?? .vampire
        let character: any BaseCharacter
        
        switch characterType {
        case .vampire:
            guard let vampireData = fullData.vampireData else { return nil }
            let vampire = VampireCharacter()
            vampire.clan = vampireData.clan
            vampire.generation = vampireData.generation
            vampire.bloodPotency = vampireData.bloodPotency
            vampire.humanity = vampireData.humanity
            vampire.hunger = vampireData.hunger
            vampire.predatorType = vampireData.predatorType
            vampire.dateOfEmbrace = vampireData.dateOfEmbrace
            
            // Restore disciplines with selected powers
            vampire.v5Disciplines = restoreDisciplines(vampireData.selectedDisciplinePowers)
            
            character = vampire
            
        case .ghoul:
            guard let ghoulData = fullData.ghoulData else { return nil }
            let ghoul = GhoulCharacter()
            ghoul.humanity = ghoulData.humanity
            ghoul.dateOfGhouling = ghoulData.dateOfGhouling
            
            // Restore disciplines with selected powers
            ghoul.v5Disciplines = restoreDisciplines(ghoulData.selectedDisciplinePowers)
            
            character = ghoul
            
        case .mage:
            guard let mageData = fullData.mageData else { return nil }
            let mage = MageCharacter()
            mage.arete = mageData.arete
            mage.paradox = mageData.paradox
            mage.hubris = mageData.hubris
            mage.quiet = mageData.quiet
            mage.paradigm = mageData.paradigm
            mage.practice = mageData.practice
            mage.essence = MageEssence(rawValue: mageData.essence) ?? .none
            mage.resonance = MageResonance(rawValue: mageData.resonance) ?? .none
            mage.synergy = MageSynergy(rawValue: mageData.synergy) ?? .none
            mage.dateOfAwakening = mageData.dateOfAwakening
            mage.spheres = mageData.spheres
            
            character = mage
        }
        
        // Restore common properties
        character.name = fullData.name
        character.concept = fullData.concept
        character.chronicleName = fullData.chronicleName
        character.physicalAttributes = fullData.physicalAttributes
        character.socialAttributes = fullData.socialAttributes
        character.mentalAttributes = fullData.mentalAttributes
        character.physicalSkills = fullData.physicalSkills
        character.socialSkills = fullData.socialSkills
        character.mentalSkills = fullData.mentalSkills
        character.willpower = fullData.willpower
        character.health = fullData.health
        character.experience = fullData.experience
        character.spentExperience = fullData.spentExperience
        character.ambition = fullData.ambition
        character.desire = fullData.desire
        character.characterDescription = fullData.characterDescription
        character.notes = fullData.notes
        character.dateOfBirth = fullData.dateOfBirth
        character.convictions = fullData.convictions
        character.touchstones = fullData.touchstones
        
        // Restore specializations
        character.specializations = fullData.specializations.map { pair in
            guard pair.count == 2 else { return nil }
            return Specialization(skillName: pair[0], name: pair[1])
        }.compactMap { $0 }
        
        // Restore merits/flaws (names only, descriptions from constants)
        character.advantages = restoreMeritsFlaws(fullData.advantageNames, from: V5Constants.predefinedAdvantages)
        character.flaws = restoreMeritsFlaws(fullData.flawNames, from: V5Constants.predefinedFlaws)
        
        // Restore background merits/flaws with costs preserved
        character.backgroundMerits = fullData.backgroundMerits.map { pair in
            guard pair.count == 2, let cost = Int(pair[1]) else { 
                return CharacterBackground(name: pair.first ?? "", cost: 0, type: .merit)
            }
            return CharacterBackground(name: pair[0], cost: cost, type: .merit)
        }
        character.backgroundFlaws = fullData.backgroundFlaws.map { pair in
            guard pair.count == 2, let cost = Int(pair[1]) else { 
                return CharacterBackground(name: pair.first ?? "", cost: 0, type: .flaw)
            }
            return CharacterBackground(name: pair[0], cost: cost, type: .flaw)
        }
        
        // Recalculate derived values
        character.recalculateDerivedValues()
        
        return character
    }
    
    /// Restore disciplines with selected powers from power names
    private static func restoreDisciplines(_ selectedPowers: [String: [String]]) -> [V5Discipline] {
        var disciplines: [V5Discipline] = []
        
        for (disciplineName, powerNames) in selectedPowers {
            // Find the discipline from constants
            if var discipline = V5Constants.v5Disciplines.first(where: { $0.name == disciplineName }) {
                // Find and select the powers by name
                for (level, powers) in discipline.powers {
                    for power in powers {
                        if powerNames.contains(power.name) {
                            discipline.togglePower(power.id, at: level)
                        }
                    }
                }
                disciplines.append(discipline)
            }
        }
        
        return disciplines
    }
    
    /// Restore merits/flaws from names using constant definitions
    private static func restoreMeritsFlaws(_ names: [String], from constants: [BackgroundBase]) -> [BackgroundBase] {
        return names.compactMap { name in
            constants.first(where: { $0.name == name })
        }
    }
}
