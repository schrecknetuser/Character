import SwiftUI

struct DataTab: View {
    @Binding var character: Character
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                Section(header: Text("Session Management")) {
                    HStack {
                        Text("Current Session:")
                            .fontWeight(.medium)
                            .font(.system(size: dynamicFontSize))
                        
                        Spacer()
                        
                        if isEditing {
                            HStack(spacing: 10) {
                                Button("-") {
                                    if character.currentSession > 1 {
                                        character.currentSession -= 1
                                    }
                                }
                                .frame(width: 30, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                                .disabled(character.currentSession <= 1)
                                
                                Text("\(character.currentSession)")
                                    .font(.system(size: dynamicFontSize))
                                    .frame(minWidth: 30)
                                
                                Button("+") {
                                    character.currentSession += 1
                                }
                                .frame(width: 30, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                            }
                        } else {
                            Text("\(character.currentSession)")
                                .font(.system(size: dynamicFontSize))
                        }
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
                                    Text("Session \(entry.session)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                    
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
            }
            .onChange(of: geometry.size) { _, newSize in
                calculateOptimalFontSize(for: newSize)
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