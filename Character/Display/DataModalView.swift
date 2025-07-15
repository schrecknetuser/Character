import SwiftUI

struct DataModalView: View {
    @Binding var character: any BaseCharacter
    @Binding var isPresented: Bool
    var store: CharacterStore?
    @State private var dynamicFontSize: CGFloat = 16
    @State var refreshID: UUID = UUID()
    @State private var initialSessionCount: Int = 1
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Form {
                    Section(header: Text("Session Management")) {
                        HStack {
                            if character.currentSession > 1 {
                                Button(action: {
                                    if character.currentSession > 1 {
                                        character.currentSession -= 1
                                        refreshID = UUID()
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                            
                            Text("Current Session: \(character.currentSession)")
                                .fontWeight(.medium)
                                .font(.system(size: dynamicFontSize))
                            
                            Spacer()
                            
                            Button(action: {
                                character.currentSession += 1
                                refreshID = UUID()
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    
                    Section(header: Text("Change Log")) {
                        if character.changeLog.isEmpty {
                            Text("No changes recorded")
                                .foregroundColor(.secondary)
                                .font(.system(size: dynamicFontSize))
                        } else {
                            ForEach(character.changeLog.reversed()) { entry in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(formatDate(entry.timestamp))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Text(entry.summary)
                                        .font(.system(size: dynamicFontSize - 1))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
                .onAppear {
                    calculateOptimalFontSize(for: geometry.size)
                    initialSessionCount = character.currentSession
                }
                .onChange(of: geometry.size) { _, newSize in
                    calculateOptimalFontSize(for: newSize)
                }
            }
            .navigationTitle("Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Check if session count has changed and log it
                        if character.currentSession != initialSessionCount {
                            let logEntry = ChangeLogEntry(summary: "Session changed from \(initialSessionCount) to \(character.currentSession)")
                            character.changeLog.append(logEntry)
                            
                            // Update character in store if available
                            store?.updateCharacter(character)
                        }
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func calculateOptimalFontSize(for size: CGSize) {
        // Calculate based on screen width with more conservative scaling
        let baseSize: CGFloat = 16
        let minSize: CGFloat = 11
        let maxSize: CGFloat = 18
        
        // Scale font size based on available width
        let scaleFactor = min(1.2, size.width / 375) // iPhone standard width, cap at 1.2x
        let calculatedSize = baseSize * scaleFactor
        
        dynamicFontSize = max(minSize, min(maxSize, calculatedSize))
    }
}
