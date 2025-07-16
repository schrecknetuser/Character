import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation

// MARK: - QR Code Generation
struct QRCodeGenerator {
    /// Generate a QR code image from character data
    static func generateQRCode(from character: any BaseCharacter) -> UIImage? {
        // Convert character to JSON
        guard let characterData = try? JSONEncoder().encode(AnyCharacter(character)),
              let jsonString = String(data: characterData, encoding: .utf8) else {
            print("Failed to encode character data")
            return nil
        }
        
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
    
    func startScanning() {
        hasError = false
        scannedCode = nil
        
        captureSession = AVCaptureSession()
        
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
            
            DispatchQueue.global(qos: .background).async {
                self.captureSession?.startRunning()
            }
            
        } catch {
            setError("Camera setup failed: \(error.localizedDescription)")
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    private func setError(_ message: String) {
        errorMessage = message
        hasError = true
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        guard let captureSession = captureSession else { return nil }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        
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

// MARK: - Character Import/Export Utilities
struct CharacterDataTransfer {
    /// Try to import a character from QR code data
    static func importCharacter(from qrData: String) -> (any BaseCharacter)? {
        guard let data = qrData.data(using: .utf8) else {
            print("Failed to convert QR data to Data")
            return nil
        }
        
        do {
            let anyCharacter = try JSONDecoder().decode(AnyCharacter.self, from: data)
            return anyCharacter.character
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
}