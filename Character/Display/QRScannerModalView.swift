import SwiftUI
import AVFoundation

struct QRScannerModalView: View {
    @Binding var isPresented: Bool
    @ObservedObject var store: CharacterStore
    
    @StateObject private var scanner = QRCodeScanner()
    @State private var importedCharacter: (any BaseCharacter)?
    @State private var showImportConfirmation = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera preview
                CameraPreviewView(scanner: scanner)
                    .edgesIgnoringSafeArea(.all)
                
                // Overlay elements
                VStack {
                    // Top instruction bar
                    HStack {
                        Spacer()
                        Text("Scan QR Code to Import Character")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    // Scanning frame overlay
                    Rectangle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .overlay(
                            VStack {
                                HStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 3)
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 3)
                                }
                                Spacer()
                                HStack {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 3)
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 3)
                                }
                            }
                        )
                    
                    Spacer()
                    
                    // Bottom controls
                    Button("Cancel") {
                        scanner.stopScanning()
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            requestCameraPermission()
        }
        .onDisappear {
            scanner.stopScanning()
        }
        .onChange(of: scanner.scannedCode) { newValue in
            if let qrData = newValue {
                handleScannedCode(qrData)
            }
        }
        .onChange(of: scanner.hasError) { hasError in
            if hasError {
                errorMessage = scanner.errorMessage
                showError = true
            }
        }
        .alert("Import Character", isPresented: $showImportConfirmation) {
            Button("Import") {
                if let character = importedCharacter {
                    store.addCharacter(character)
                }
                isPresented = false
            }
            Button("Cancel", role: .cancel) {
                importedCharacter = nil
            }
        } message: {
            if let character = importedCharacter {
                Text("Import character '\(character.name)' (\(character.characterType.displayName))?")
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // Already have permission, start immediately
            scanner.startScanning()
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        // Small delay to ensure UI is ready
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.scanner.startScanning()
                        }
                    } else {
                        self.errorMessage = "Camera access is required to scan QR codes"
                        self.showError = true
                    }
                }
            }
        case .denied, .restricted:
            self.errorMessage = "Camera access denied. Please enable camera access in Settings."
            self.showError = true
        @unknown default:
            self.errorMessage = "Unknown camera permission status"
            self.showError = true
        }
    }
    
    private func handleScannedCode(_ qrData: String) {
        // Try to import character from the scanned data
        if let character = CharacterDataTransfer.importCharacter(from: qrData) {
            importedCharacter = character
            showImportConfirmation = true
        } else {
            errorMessage = "Invalid QR code. This doesn't appear to be a valid character."
            showError = true
        }
    }
}

// Camera preview wrapper for SwiftUI
struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var scanner: QRCodeScanner
    
    func makeUIView(context: Context) -> CameraView {
        let view = CameraView()
        view.backgroundColor = UIColor.black
        return view
    }
    
    func updateUIView(_ uiView: CameraView, context: Context) {
        uiView.setPreviewLayer(scanner.getPreviewLayer())
    }
}

// Custom UIView to handle camera preview layer
class CameraView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer?) {
        // Only update if we have a new layer
        guard layer !== previewLayer else { return }
        
        // Remove old layer
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
        
        // Add new layer
        if let newLayer = layer {
            previewLayer = newLayer
            newLayer.frame = bounds
            newLayer.videoGravity = .resizeAspectFill
            
            // Ensure the connection is active
            if let connection = newLayer.connection, connection.isEnabled {
                // Set video orientation if supported
                if connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }
            }
            
            self.layer.addSublayer(newLayer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update preview layer frame when view bounds change
        previewLayer?.frame = bounds
    }
}

#Preview {
    QRScannerModalView(
        isPresented: .constant(true),
        store: CharacterStore()
    )
}