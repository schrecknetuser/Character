import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation

// MARK: - QR Code Generation
struct QRCodeGenerator {
    /// Generate a QR code image from character data
    static func generateQRCode(from character: any BaseCharacter) -> UIImage? {
        // Convert character to compressed JSON for smaller QR codes
        let compressedData = CharacterDataTransfer.compressCharacterForQR(character)
        guard let characterData = try? JSONEncoder().encode(compressedData),
              let jsonString = String(data: characterData, encoding: .utf8) else {
            print("Failed to encode character data")
            return nil
        }
        
        print("QR code data length: \(jsonString.count) characters")
        return generateQRCode(from: jsonString)
    }
    
    /// Generate a QR code image from string data
    static func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        // Set error correction level to high for better reliability
        filter.correctionLevel = "H"
        
        guard let outputImage = filter.outputImage else {
            print("Failed to generate QR code")
            return nil
        }
        
        // Scale up the QR code for better visibility
        let scaleX = 200.0 / outputImage.extent.size.width
        let scaleY = 200.0 / outputImage.extent.size.height
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            print("Failed to create CGImage from QR code")
            return nil
        }
        
        return UIImage(cgImage: cgImage)
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

// MARK: - Compressed Character Data for QR Codes
struct CompressedCharacterData: Codable {
    // Basic info
    let name: String
    let type: CharacterType
    let concept: String
    let chronicleName: String
    
    // Attributes (values only)
    let physicalAttributes: [String: Int]
    let socialAttributes: [String: Int]
    let mentalAttributes: [String: Int]
    
    // Skills (values only)
    let physicalSkills: [String: Int]
    let socialSkills: [String: Int]
    let mentalSkills: [String: Int]
    
    // Essential character stats
    let willpower: Int
    let health: Int
    
    // Specializations (names only)
    let specializations: [String: String] // skillName: specializationName
    
    // Character-specific data
    let vampireData: VampireCompressedData?
    let ghoulData: GhoulCompressedData?
    let mageData: MageCompressedData?
    
    // Merit/Flaw names only (descriptions from constants)
    let advantageNames: [String]
    let flawNames: [String]
    let backgroundMeritNames: [String]
    let backgroundFlawNames: [String]
    
    // Convictions and touchstones
    let convictions: [String]
    let touchstones: [String]
}

struct VampireCompressedData: Codable {
    let clan: String
    let generation: Int
    let bloodPotency: Int
    let humanity: Int
    let hunger: Int
    let predatorType: String
    // Discipline power names only (descriptions from constants)
    let selectedDisciplinePowers: [String: [String]] // disciplineName: [powerNames]
}

struct GhoulCompressedData: Codable {
    let humanity: Int
    // Note: Ghoul has v5Disciplines, not its own disciplines
    let selectedDisciplinePowers: [String: [String]]
}

struct MageCompressedData: Codable {
    let arete: Int
    let paradox: Int
    let hubris: Int
    let quiet: Int
    let paradigm: String
    let practice: String
    let essence: String
    let resonance: String
    let synergy: String
    let spheres: [String: Int]
    // Note: Mage doesn't have v5Disciplines in the actual model
}

// MARK: - Character Import/Export Utilities
struct CharacterDataTransfer {
    /// Try to import a character from QR code data
    static func importCharacter(from qrData: String) -> (any BaseCharacter)? {
        guard let data = qrData.data(using: .utf8) else {
            print("Failed to convert QR data to Data")
            return nil
        }
        
        do {
            // Try compressed format first
            let compressedData = try JSONDecoder().decode(CompressedCharacterData.self, from: data)
            return expandCharacterFromCompressed(compressedData)
        } catch {
            // Fallback to legacy full format
            do {
                let anyCharacter = try JSONDecoder().decode(AnyCharacter.self, from: data)
                return anyCharacter.character
            } catch {
                print("Failed to decode character from QR data: \(error)")
                return nil
            }
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
    
    /// Create compressed character data for QR codes
    static func compressCharacterForQR(_ character: any BaseCharacter) -> CompressedCharacterData {
        // Extract specializations as name pairs
        let specializationPairs = Dictionary(
            uniqueKeysWithValues: character.specializations.map { spec in
                (spec.skillName, spec.name)
            }
        )
        
        // Extract merit/flaw names only
        let advantageNames = character.advantages.map { $0.name }
        let flawNames = character.flaws.map { $0.name }
        let backgroundMeritNames = character.backgroundMerits.map { $0.name }
        let backgroundFlawNames = character.backgroundFlaws.map { $0.name }
        
        // Character-specific data
        var vampireData: VampireCompressedData? = nil
        var ghoulData: GhoulCompressedData? = nil
        var mageData: MageCompressedData? = nil
        
        if let vampire = character as? VampireCharacter {
            let disciplinePowers = extractSelectedDisciplinePowers(vampire.v5Disciplines)
            vampireData = VampireCompressedData(
                clan: vampire.clan,
                generation: vampire.generation,
                bloodPotency: vampire.bloodPotency,
                humanity: vampire.humanity,
                hunger: vampire.hunger,
                predatorType: vampire.predatorType,
                selectedDisciplinePowers: disciplinePowers
            )
        } else if let ghoul = character as? GhoulCharacter {
            let disciplinePowers = extractSelectedDisciplinePowers(ghoul.v5Disciplines)
            ghoulData = GhoulCompressedData(
                humanity: ghoul.humanity,
                selectedDisciplinePowers: disciplinePowers
            )
        } else if let mage = character as? MageCharacter {
            mageData = MageCompressedData(
                arete: mage.arete,
                paradox: mage.paradox,
                hubris: mage.hubris,
                quiet: mage.quiet,
                paradigm: mage.paradigm,
                practice: mage.practice,
                essence: mage.essence.rawValue,
                resonance: mage.resonance.rawValue,
                synergy: mage.synergy.rawValue,
                spheres: mage.spheres
            )
        }
        
        return CompressedCharacterData(
            name: character.name,
            type: character.characterType,
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
            vampireData: vampireData,
            ghoulData: ghoulData,
            mageData: mageData,
            advantageNames: advantageNames,
            flawNames: flawNames,
            backgroundMeritNames: backgroundMeritNames,
            backgroundFlawNames: backgroundFlawNames,
            convictions: character.convictions,
            touchstones: character.touchstones
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
    
    /// Expand compressed character data back to full character
    private static func expandCharacterFromCompressed(_ compressed: CompressedCharacterData) -> (any BaseCharacter)? {
        let character: any BaseCharacter
        
        switch compressed.type {
        case .vampire:
            guard let vampireData = compressed.vampireData else { return nil }
            let vampire = VampireCharacter()
            vampire.clan = vampireData.clan
            vampire.generation = vampireData.generation
            vampire.bloodPotency = vampireData.bloodPotency
            vampire.humanity = vampireData.humanity
            vampire.hunger = vampireData.hunger
            vampire.predatorType = vampireData.predatorType
            
            // Restore disciplines with selected powers
            vampire.v5Disciplines = restoreDisciplines(vampireData.selectedDisciplinePowers)
            
            character = vampire
            
        case .ghoul:
            guard let ghoulData = compressed.ghoulData else { return nil }
            let ghoul = GhoulCharacter()
            ghoul.humanity = ghoulData.humanity
            
            // Restore disciplines with selected powers
            ghoul.v5Disciplines = restoreDisciplines(ghoulData.selectedDisciplinePowers)
            
            character = ghoul
            
        case .mage:
            guard let mageData = compressed.mageData else { return nil }
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
            mage.spheres = mageData.spheres
            
            character = mage
        }
        
        // Restore common properties
        character.name = compressed.name
        character.concept = compressed.concept
        character.chronicleName = compressed.chronicleName
        character.physicalAttributes = compressed.physicalAttributes
        character.socialAttributes = compressed.socialAttributes
        character.mentalAttributes = compressed.mentalAttributes
        character.physicalSkills = compressed.physicalSkills
        character.socialSkills = compressed.socialSkills
        character.mentalSkills = compressed.mentalSkills
        character.willpower = compressed.willpower
        character.health = compressed.health
        character.convictions = compressed.convictions
        character.touchstones = compressed.touchstones
        
        // Restore specializations
        character.specializations = compressed.specializations.map { skillName, specName in
            Specialization(skillName: skillName, name: specName)
        }
        
        // Restore merits/flaws (names only, descriptions from constants)
        character.advantages = restoreMeritsFlaws(compressed.advantageNames, from: V5Constants.predefinedAdvantages)
        character.flaws = restoreMeritsFlaws(compressed.flawNames, from: V5Constants.predefinedFlaws)
        
        // Note: Background merits/flaws would need similar restoration from constants
        // For now, just create basic entries
        character.backgroundMerits = compressed.backgroundMeritNames.map { name in
            CharacterBackground(name: name, cost: 0, type: .merit)
        }
        character.backgroundFlaws = compressed.backgroundFlawNames.map { name in
            CharacterBackground(name: name, cost: 0, type: .flaw)
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