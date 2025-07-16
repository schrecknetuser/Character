import SwiftUI

struct QRDisplayModalView: View {
    let character: any BaseCharacter
    @Binding var isPresented: Bool
    
    @State private var qrImage: UIImage?
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Export Character")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Scan this QR code with another device running this app to import \(character.name)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // Character summary
                VStack(alignment: .leading, spacing: 8) {
                    Text(CharacterDataTransfer.getCharacterSummary(for: character))
                        .font(.body)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // QR Code display
                if let qrImage = qrImage {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                } else {
                    ProgressView("Generating QR Code...")
                        .frame(width: 200, height: 200)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button("Share") {
                        showShareSheet = true
                    }
                    .buttonStyle(.bordered)
                    .disabled(qrImage == nil)
                    
                    Button("Close") {
                        isPresented = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .onAppear {
            generateQRCode()
        }
        .sheet(isPresented: $showShareSheet) {
            if let qrImage = qrImage {
                ShareSheet(items: [qrImage])
            }
        }
    }
    
    private func generateQRCode() {
        DispatchQueue.global(qos: .background).async {
            let generatedImage = QRCodeGenerator.generateQRCode(from: character)
            
            DispatchQueue.main.async {
                self.qrImage = generatedImage
            }
        }
    }
}

// Share sheet for sharing the QR code image
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    QRDisplayModalView(
        character: VampireCharacter(),
        isPresented: .constant(true)
    )
}