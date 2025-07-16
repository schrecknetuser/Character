import SwiftUI
import UIKit
import PDFKit

extension String {
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}

class PDFGenerator {
    static func generateCharacterPDF(for character: any BaseCharacter) -> Data? {
        let pageSize = CGSize(width: 595.2, height: 841.8) // A4 size in points
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        do {
            return renderer.pdfData { context in
                context.beginPage()
                
                switch character.characterType {
                case .vampire:
                    if let vampire = character as? VampireCharacter {
                        drawVampireCharacterSheet(vampire: vampire, in: context.cgContext, pageSize: pageSize)
                    }
                case .ghoul:
                    if let ghoul = character as? GhoulCharacter {
                        drawGhoulCharacterSheet(ghoul: ghoul, in: context.cgContext, pageSize: pageSize)
                    }
                case .mage:
                    if let mage = character as? MageCharacter {
                        drawMageCharacterSheet(mage: mage, in: context.cgContext, pageSize: pageSize)
                    }
                }
            }
        } catch {
            print("PDF generation error: \(error)")
            return nil
        }
    }
    
    private static func drawVampireCharacterSheet(vampire: VampireCharacter, in context: CGContext, pageSize: CGSize) {
        let margin: CGFloat = 30
        let workingWidth = pageSize.width - (margin * 2)
        var currentY: CGFloat = margin
        
        // Header Info Row 1: Name, Player, Chronicle
        let thirdWidth = workingWidth / 3
        currentY = drawFormField("Name", value: vampire.name, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Player", value: "", 
                         at: CGPoint(x: margin + thirdWidth, y: currentY), 
                         width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Chronicle", value: vampire.chronicleName, 
                         at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                         width: thirdWidth - 5, in: context)
        currentY += 35
        
        // Header Info Row 2: Concept, Sire, Ambition
        currentY = drawFormField("Concept", value: vampire.concept, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Sire", value: "", 
                         at: CGPoint(x: margin + thirdWidth, y: currentY), 
                         width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Ambition", value: "", 
                         at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                         width: thirdWidth - 5, in: context)
        currentY += 35
        
        // Header Info Row 3: Clan, Predator, Generation
        currentY = drawFormField("Clan", value: vampire.clan, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Predator", value: vampire.predatorType, 
                         at: CGPoint(x: margin + thirdWidth, y: currentY), 
                         width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Generation", value: "\(vampire.generation)", 
                         at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                         width: thirdWidth - 5, in: context)
        currentY += 50
        
        // Attributes Section
        currentY = drawAttributesFormSection(character: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 15
        
        // Health and Willpower (side by side with attributes)
        let healthWillpowerY = currentY - 80  // Position next to attributes
        drawHealthWillpowerBoxes(character: vampire, at: CGPoint(x: margin + workingWidth - 200, y: healthWillpowerY), in: context)
        
        // Skills Section  
        currentY = drawSkillsFormSection(character: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Disciplines Section
        currentY = drawDisciplinesFormSection(character: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 15
        
        // Vampire-specific traits section
        currentY = drawVampireTraitsForm(vampire: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 15
        
        // Experience and Notes section
        if currentY < pageSize.height - 100 {
            drawExperienceAndNotes(vampire: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        }
    }
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, in context: CGContext, pageSize: CGSize) {
        let margin: CGFloat = 30
        let workingWidth = pageSize.width - (margin * 2)
        var currentY: CGFloat = margin
        
        // Header Info Row 1: Name, Player, Chronicle
        let thirdWidth = workingWidth / 3
        currentY = drawFormField("Name", value: ghoul.name, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Player", value: "", 
                         at: CGPoint(x: margin + thirdWidth, y: currentY), 
                         width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Chronicle", value: ghoul.chronicleName, 
                         at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                         width: thirdWidth - 5, in: context)
        currentY += 35
        
        // Header Info Row 2: Concept, Sire, Ambition
        currentY = drawFormField("Concept", value: ghoul.concept, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Sire", value: "", 
                         at: CGPoint(x: margin + thirdWidth, y: currentY), 
                         width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Ambition", value: "", 
                         at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                         width: thirdWidth - 5, in: context)
        currentY += 50
        
        // Attributes Section
        currentY = drawAttributesFormSection(character: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 15
        
        // Health and Willpower (side by side with attributes)
        let healthWillpowerY = currentY - 80  // Position next to attributes
        drawHealthWillpowerBoxes(character: ghoul, at: CGPoint(x: margin + workingWidth - 200, y: healthWillpowerY), in: context)
        
        // Skills Section  
        currentY = drawSkillsFormSection(character: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Disciplines Section
        currentY = drawDisciplinesFormSection(character: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 15
        
        // Ghoul-specific traits section
        currentY = drawGhoulTraitsForm(ghoul: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 15
        
        // Experience and Notes section
        if currentY < pageSize.height - 100 {
            drawGhoulExperienceAndNotes(ghoul: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        }
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, in context: CGContext, pageSize: CGSize) {
        let margin: CGFloat = 30
        let workingWidth = pageSize.width - (margin * 2)
        var currentY: CGFloat = margin
        
        // Title
        currentY = drawText("MAGE CHARACTER SHEET", 
                           at: CGPoint(x: margin, y: currentY), 
                           fontSize: 16, 
                           bold: true, 
                           in: context, 
                           maxWidth: workingWidth)
        currentY += 10
        
        currentY = drawText("(Stub Implementation - Full sheet coming soon)", 
                           at: CGPoint(x: margin, y: currentY), 
                           fontSize: 12, 
                           bold: false, 
                           in: context, 
                           maxWidth: workingWidth)
        currentY += 30
        
        // Basic character info
        let thirdWidth = workingWidth / 3
        currentY = drawFormField("Name", value: mage.name, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Player", value: "", 
                         at: CGPoint(x: margin + thirdWidth, y: currentY), 
                         width: thirdWidth - 5, in: context)
        
        _ = drawFormField("Chronicle", value: mage.chronicleName, 
                         at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                         width: thirdWidth - 5, in: context)
        currentY += 35
        
        currentY = drawFormField("Concept", value: mage.concept, 
                                at: CGPoint(x: margin, y: currentY), 
                                width: workingWidth, in: context)
        currentY += 50
        
        // Basic Attributes Section (just the headers for now)
        currentY = drawAttributesFormSection(character: mage, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
    }
    
    // MARK: - Form-based Section Drawing Methods
    
    private static func drawFormField(_ label: String, value: String, at point: CGPoint, width: CGFloat, in context: CGContext) -> CGFloat {
        let labelY = drawText(label, at: point, fontSize: 10, bold: true, in: context, maxWidth: width)
        
        // Draw underline for the field
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: point.x, y: labelY + 8))
        context.addLine(to: CGPoint(x: point.x + width, y: labelY + 8))
        context.strokePath()
        
        // Draw the value above the line
        if !value.isEmpty {
            _ = drawText(value, at: CGPoint(x: point.x, y: labelY - 5), fontSize: 10, bold: false, in: context, maxWidth: width)
        }
        
        return labelY + 15
    }
    
    private static func drawAttributesFormSection(character: any BaseCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("ATTRIBUTES", at: CGPoint(x: point.x, y: currentY), fontSize: 12, bold: true, in: context, maxWidth: maxWidth)
        currentY += 10
        
        let columnWidth = (maxWidth - 200) / 3 // Leave space for health/willpower
        
        // Column headers
        _ = drawText("Physical", at: CGPoint(x: point.x, y: currentY), fontSize: 10, bold: true, in: context, maxWidth: columnWidth)
        _ = drawText("Social", at: CGPoint(x: point.x + columnWidth, y: currentY), fontSize: 10, bold: true, in: context, maxWidth: columnWidth)
        _ = drawText("Mental", at: CGPoint(x: point.x + (columnWidth * 2), y: currentY), fontSize: 10, bold: true, in: context, maxWidth: columnWidth)
        currentY += 15
        
        // Physical Attributes
        var physicalY = currentY
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            physicalY = drawAttributeWithDots(attribute, value: value, at: CGPoint(x: point.x, y: physicalY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Social Attributes
        var socialY = currentY
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            socialY = drawAttributeWithDots(attribute, value: value, at: CGPoint(x: point.x + columnWidth, y: socialY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Mental Attributes
        var mentalY = currentY
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            mentalY = drawAttributeWithDots(attribute, value: value, at: CGPoint(x: point.x + (columnWidth * 2), y: mentalY), in: context, maxWidth: columnWidth - 10)
        }
        
        return max(physicalY, max(socialY, mentalY)) + 10
    }
    
    private static func drawSkillsFormSection(character: any BaseCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("SKILLS", at: CGPoint(x: point.x, y: currentY), fontSize: 12, bold: true, in: context, maxWidth: maxWidth)
        currentY += 10
        
        let columnWidth = maxWidth / 3
        
        // Physical Skills
        var physicalY = currentY
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            let specialization = getSkillSpecialization(character: character, skill: skill)
            let displayName = specialization.isEmpty ? skill : "\(skill) (\(specialization))"
            physicalY = drawAttributeWithDots(displayName, value: value, at: CGPoint(x: point.x, y: physicalY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Social Skills
        var socialY = currentY
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            let specialization = getSkillSpecialization(character: character, skill: skill)
            let displayName = specialization.isEmpty ? skill : "\(skill) (\(specialization))"
            socialY = drawAttributeWithDots(displayName, value: value, at: CGPoint(x: point.x + columnWidth, y: socialY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Mental Skills
        var mentalY = currentY
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            let specialization = getSkillSpecialization(character: character, skill: skill)
            let displayName = specialization.isEmpty ? skill : "\(skill) (\(specialization))"
            mentalY = drawAttributeWithDots(displayName, value: value, at: CGPoint(x: point.x + (columnWidth * 2), y: mentalY), in: context, maxWidth: columnWidth - 10)
        }
        
        return max(physicalY, max(socialY, mentalY)) + 10
    }
    
    private static func drawDisciplinesFormSection(character: any DisciplineCapable, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("DISCIPLINES", at: CGPoint(x: point.x, y: currentY), fontSize: 12, bold: true, in: context, maxWidth: maxWidth)
        currentY += 10
        
        let columnWidth = maxWidth / 2
        var leftY = currentY
        var rightY = currentY
        var useLeftColumn = true
        
        if character.v5Disciplines.isEmpty {
            currentY = drawText("(No disciplines learned)", at: CGPoint(x: point.x, y: currentY), fontSize: 10, bold: false, in: context, maxWidth: maxWidth)
        } else {
            for discipline in character.v5Disciplines {
                let level = discipline.currentLevel()
                let xPos = useLeftColumn ? point.x : point.x + columnWidth
                var yPos = useLeftColumn ? leftY : rightY
                
                // Draw discipline name with dots
                let dots = String(repeating: "●", count: min(level, 5)) + String(repeating: "○", count: max(0, 5 - level))
                yPos = drawText("\(discipline.name)", at: CGPoint(x: xPos, y: yPos), fontSize: 10, bold: true, in: context, maxWidth: columnWidth - 10)
                yPos = drawText("[\(dots)]", at: CGPoint(x: xPos, y: yPos - 5), fontSize: 8, bold: false, in: context, maxWidth: columnWidth - 10)
                
                // Draw powers
                let selectedPowers = discipline.getAllSelectedPowerNames()
                for power in Array(selectedPowers).sorted() {
                    yPos = drawText("• \(power)", at: CGPoint(x: xPos + 10, y: yPos), fontSize: 9, bold: false, in: context, maxWidth: columnWidth - 20)
                }
                yPos += 5
                
                if useLeftColumn {
                    leftY = yPos
                } else {
                    rightY = yPos
                }
                useLeftColumn.toggle()
            }
        }
        
        return max(leftY, rightY) + 10
    }
    
    private static func drawHealthWillpowerBoxes(character: any BaseCharacter, at point: CGPoint, in context: CGContext) {
        let boxSize: CGFloat = 12
        let spacing: CGFloat = 2
        
        // Health section
        var currentY = drawText("Health", at: point, fontSize: 10, bold: true, in: context, maxWidth: 150)
        
        let healthBoxesPerRow = 5
        for i in 0..<character.health {
            let row = i / healthBoxesPerRow
            let col = i % healthBoxesPerRow
            let x = point.x + CGFloat(col) * (boxSize + spacing)
            let y = currentY + CGFloat(row) * (boxSize + spacing)
            
            drawHealthBox(at: CGPoint(x: x, y: y), size: boxSize, state: i < character.healthStates.count ? character.healthStates[i] : .ok, in: context)
        }
        currentY += CGFloat((character.health - 1) / healthBoxesPerRow + 1) * (boxSize + spacing) + 10
        
        // Willpower section
        currentY = drawText("Willpower", at: CGPoint(x: point.x, y: currentY), fontSize: 10, bold: true, in: context, maxWidth: 150)
        
        for i in 0..<character.willpower {
            let row = i / healthBoxesPerRow
            let col = i % healthBoxesPerRow
            let x = point.x + CGFloat(col) * (boxSize + spacing)
            let y = currentY + CGFloat(row) * (boxSize + spacing)
            
            drawHealthBox(at: CGPoint(x: x, y: y), size: boxSize, state: i < character.willpowerStates.count ? character.willpowerStates[i] : .ok, in: context)
        }
    }
    
    private static func drawVampireTraitsForm(vampire: VampireCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        let halfWidth = maxWidth / 2
        
        // Left column - Hunger, Humanity, Blood Potency
        var leftY = currentY
        leftY = drawFormField("Hunger", value: "\(vampire.hunger)", at: CGPoint(x: point.x, y: leftY), width: halfWidth - 20, in: context)
        leftY = drawFormField("Humanity", value: "\(vampire.humanity)", at: CGPoint(x: point.x, y: leftY), width: halfWidth - 20, in: context)
        leftY = drawFormField("Blood Potency", value: "\(vampire.bloodPotency)", at: CGPoint(x: point.x, y: leftY), width: halfWidth - 20, in: context)
        
        // Right column - Advantages section
        var rightY = currentY
        rightY = drawText("Advantages", at: CGPoint(x: point.x + halfWidth, y: rightY), fontSize: 10, bold: true, in: context, maxWidth: halfWidth)
        rightY = drawFormField("Blood Surge", value: "", at: CGPoint(x: point.x + halfWidth, y: rightY), width: halfWidth - 20, in: context)
        rightY = drawFormField("Power Bonus", value: "", at: CGPoint(x: point.x + halfWidth, y: rightY), width: halfWidth - 20, in: context)
        rightY = drawFormField("Mend Amount", value: "", at: CGPoint(x: point.x + halfWidth, y: rightY), width: halfWidth - 20, in: context)
        rightY = drawFormField("Rouse Re-Roll", value: "", at: CGPoint(x: point.x + halfWidth, y: rightY), width: halfWidth - 20, in: context)
        rightY = drawFormField("Feeding Penalty", value: "", at: CGPoint(x: point.x + halfWidth, y: rightY), width: halfWidth - 20, in: context)
        
        currentY = max(leftY, rightY) + 10
        
        // Full width fields
        currentY = drawFormField("Clan Bane", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
        currentY += 10
        currentY = drawFormField("Clan Compulsion", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
        
        return currentY + 10
    }
    
    private static func drawExperienceAndNotes(vampire: VampireCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) {
        var currentY = point.y
        let halfWidth = maxWidth / 2
        
        // Experience tracking
        currentY = drawFormField("Experience", value: "\(vampire.experience)", at: CGPoint(x: point.x, y: currentY), width: halfWidth - 20, in: context)
        _ = drawFormField("Spent Experience", value: "\(vampire.spentExperience)", at: CGPoint(x: point.x + halfWidth, y: point.y), width: halfWidth - 20, in: context)
        currentY += 10
        
        // Notes section
        currentY = drawFormField("Notes", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
        currentY += 10
        currentY = drawFormField("Chronicle Tenets", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
        currentY += 10
        currentY = drawFormField("Convictions & Touchstones", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
    }
    
    private static func drawGhoulTraitsForm(ghoul: GhoulCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        let halfWidth = maxWidth / 2
        
        // Left column - Humanity
        currentY = drawFormField("Humanity", value: "\(ghoul.humanity)", at: CGPoint(x: point.x, y: currentY), width: halfWidth - 20, in: context)
        
        // Add space for ghoul-specific traits if needed
        return currentY + 10
    }
    
    private static func drawGhoulExperienceAndNotes(ghoul: GhoulCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) {
        var currentY = point.y
        let halfWidth = maxWidth / 2
        
        // Experience tracking
        currentY = drawFormField("Experience", value: "\(ghoul.experience)", at: CGPoint(x: point.x, y: currentY), width: halfWidth - 20, in: context)
        _ = drawFormField("Spent Experience", value: "\(ghoul.spentExperience)", at: CGPoint(x: point.x + halfWidth, y: point.y), width: halfWidth - 20, in: context)
        currentY += 10
        
        // Notes section
        currentY = drawFormField("Notes", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
        currentY += 10
        currentY = drawFormField("Chronicle Tenets", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
        currentY += 10
        currentY = drawFormField("Convictions & Touchstones", value: "", at: CGPoint(x: point.x, y: currentY), width: maxWidth, in: context)
    }
    
    // MARK: - Helper Drawing Methods
    
    @discardableResult
    private static func drawText(_ text: String, at point: CGPoint, fontSize: CGFloat, bold: Bool, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textRect = CGRect(x: point.x, y: point.y, width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = attributedString.boundingRect(with: textRect.size, options: [.usesLineFragmentOrigin], context: nil)
        
        attributedString.draw(in: CGRect(x: point.x, y: point.y, width: maxWidth, height: boundingRect.height))
        
        return point.y + boundingRect.height + 5
    }
    
    @discardableResult
    private static func drawAttributeWithDots(_ name: String, value: Int, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        // Draw attribute name first
        let nameY = drawText(name, at: point, fontSize: 9, bold: false, in: context, maxWidth: maxWidth)
        
        // Draw dots on the same line as the name
        let dotSize: CGFloat = 6
        let dotSpacing: CGFloat = 2
        let startX = point.x + 5
        let dotY = nameY - 12
        
        for i in 0..<5 {
            let x = startX + CGFloat(i) * (dotSize + dotSpacing)
            let dotRect = CGRect(x: x, y: dotY, width: dotSize, height: dotSize)
            
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(0.5)
            
            if i < value {
                // Filled dot
                context.setFillColor(UIColor.black.cgColor)
                context.fillEllipse(in: dotRect)
            } else {
                // Empty dot
                context.strokeEllipse(in: dotRect)
            }
        }
        
        return nameY + 3
    }
    
    private static func drawHealthBox(at point: CGPoint, size: CGFloat, state: HealthState, in context: CGContext) {
        let rect = CGRect(x: point.x, y: point.y, width: size, height: size)
        
        // Draw box outline
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(0.5)
        context.stroke(rect)
        
        // Fill based on state
        switch state {
        case .ok:
            // Empty box - do nothing
            break
        case .superficial:
            // Draw diagonal line
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(1)
            context.move(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: CGPoint(x: point.x + size, y: point.y + size))
            context.strokePath()
        case .aggravated:
            // Draw X
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(1)
            context.move(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: CGPoint(x: point.x + size, y: point.y + size))
            context.move(to: CGPoint(x: point.x + size, y: point.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y + size))
            context.strokePath()
        }
    }
    
    private static func getSkillSpecialization(character: any BaseCharacter, skill: String) -> String {
        // This is a placeholder - in a real implementation you'd check for skill specializations
        // For now, return empty string since specializations aren't implemented in the data model
        return ""
    }
}