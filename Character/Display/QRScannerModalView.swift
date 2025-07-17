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
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    // Small delay to ensure UI is ready
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.scanner.startScanning()
                    }
                } else {
                    self.errorMessage = "Camera access is required to scan QR codes"
                    self.showError = true
                }
            }
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
    let scanner: QRCodeScanner
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Remove any existing preview layers
        uiView.layer.sublayers?.removeAll(where: { $0 is AVCaptureVideoPreviewLayer })
        
        // Add the preview layer if available
        if let previewLayer = scanner.getPreviewLayer() {
            previewLayer.frame = uiView.bounds
            uiView.layer.addSublayer(previewLayer)
        }
    }
}

#Preview {
    QRScannerModalView(
        isPresented: .constant(true),
        store: CharacterStore()
    )
}