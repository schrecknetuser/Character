import SwiftUI

struct AttributesSkillsTab: View {
    @Binding var character: any BaseCharacter
    @Binding var isEditing: Bool
    @State private var dynamicFontSize: CGFloat = 14
    @State private var titleFontSize: CGFloat = 20
    @State private var headerFontSize: CGFloat = 17
    @State private var rowHeight: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Attributes Section
                    VStack(alignment: .center, spacing: 15) {
                        Text("Attributes")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 12) {
                            AttributeColumnView(
                                title: "Physical",
                                attributes: V5Constants.physicalAttributes,
                                attributeValues: $character.physicalAttributes,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            AttributeColumnView(
                                title: "Mental",
                                attributes: V5Constants.mentalAttributes,
                                attributeValues: $character.mentalAttributes,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            AttributeColumnView(
                                title: "Social",
                                attributes: V5Constants.socialAttributes,
                                attributeValues: $character.socialAttributes,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Skills Section
                    VStack(alignment: .center, spacing: 15) {
                        Text("Skills")
                            .font(.system(size: titleFontSize, weight: .bold))
                        
                        HStack(alignment: .top, spacing: 12) {
                            // Physical Skills Column
                            
                            SkillColumnView(
                                title: "Physical",
                                skills: V5Constants.physicalSkills,
                                skillValues: $character.physicalSkills,
                                character: $character,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            SkillColumnView(
                                title: "Social",
                                skills: V5Constants.socialSkills,
                                skillValues: $character.socialSkills,
                                character: $character,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                            
                            SkillColumnView(
                                title: "Mental",
                                skills: V5Constants.mentalSkills,
                                skillValues: $character.mentalSkills,
                                character: $character,
                                isEditing: isEditing,
                                dynamicFontSize: dynamicFontSize,
                                headerFontSize: headerFontSize,
                                rowHeight: rowHeight
                            ).frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Specializations Section
                    if !character.specializations.isEmpty || isEditing {
                        SpecializationsTableView(
                            character: $character,
                            isEditing: isEditing,
                            dynamicFontSize: dynamicFontSize,
                            titleFontSize: titleFontSize,
                            headerFontSize: headerFontSize,
                            rowHeight: rowHeight
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 145) // Add bottom padding to prevent floating buttons from covering content
                                                // Button height (56) + spacing above button (20) + tab bar height (49) + spacing (20) = 145
                .onAppear {
                    calculateOptimalFontSizes(for: geometry.size)
                }
                .onChange(of: geometry.size) { _, newSize in
                    calculateOptimalFontSizes(for: newSize)
                }
            }
        }
    }
    
    private func calculateOptimalFontSizes(for size: CGSize) {
        // Calculate based on screen width and available space
        let availableWidth = (size.width - 120) / 3 // Account for padding and 3 columns, more conservative
        
        // Find the longest text among all displayed values
        let allDisplayedTexts = V5Constants.physicalAttributes + V5Constants.socialAttributes + V5Constants.mentalAttributes +
                               V5Constants.physicalSkills + V5Constants.socialSkills + V5Constants.mentalSkills +
                               ["Physical", "Social", "Mental", "Attributes", "Skills"]
        let longestText = allDisplayedTexts.max(by: { $0.count < $1.count }) ?? "Intelligence"
        
        // Determine optimal font size based on available width per column
        let scaleFactor = min(1.0, availableWidth / (CGFloat(longestText.count) * 8)) // More conservative character width estimate
        
        // Base font sizes adjusted for actual content - more conservative
        let baseDynamicSize: CGFloat = 11
        let baseTitleSize: CGFloat = 17
        let baseHeaderSize: CGFloat = 14
        let baseRowHeight: CGFloat = 24
        
        // Calculate scaled sizes with more conservative scaling
        dynamicFontSize = max(9, min(13, baseDynamicSize * scaleFactor))
        titleFontSize = max(15, min(19, baseTitleSize * scaleFactor))
        headerFontSize = max(12, min(16, baseHeaderSize * scaleFactor))
        rowHeight = max(22, min(28, baseRowHeight * scaleFactor))
    }
}

