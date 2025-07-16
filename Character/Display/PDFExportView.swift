import SwiftUI
import UIKit

struct PDFExportView: View {
    let character: any BaseCharacter
    @Binding var isPresented: Bool
    @State private var pdfData: Data?
    @State private var isGenerating = false
    @State private var showingShareSheet = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                Text("Export Character Sheet")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Generate a PDF character sheet for \(character.name)")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: generatePDF) {
                    HStack {
                        if isGenerating {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "doc.badge.plus")
                        }
                        Text(isGenerating ? "Generating..." : "Generate PDF")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(isGenerating ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
                .disabled(isGenerating)
                
                if pdfData != nil {
                    Button(action: { showingShareSheet = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share PDF")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("PDF Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let pdfData = pdfData {
                    ActivityViewController(activityItems: [createPDFURL(from: pdfData)])
                }
            }
        }
    }
    
    private func generatePDF() {
        isGenerating = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let pdf = PDFGenerator.generateCharacterPDF(for: character) {
                DispatchQueue.main.async {
                    self.pdfData = pdf
                    self.isGenerating = false
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to generate PDF. Please try again."
                    self.isGenerating = false
                }
            }
        }
    }
    
    private func createPDFURL(from data: Data) -> URL {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(character.name)_CharacterSheet.pdf")
        
        try? data.write(to: tempURL)
        return tempURL
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}