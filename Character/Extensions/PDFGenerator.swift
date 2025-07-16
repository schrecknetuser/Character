import SwiftUI
import UIKit

extension String {
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}

class PDFGenerator {
    static func generateCharacterPDF(for character: any BaseCharacter) -> Data? {
        // Use standard A4 page size for proper printing
        let pageSize = CGSize(width: 595.28, height: 841.89) // A4 in points
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        do {
            return renderer.pdfData { context in
                context.beginPage()
                
                switch character.characterType {
                case .vampire:
                    if let vampire = character as? VampireCharacter {
                        drawVampireCharacterSheet(vampire: vampire, context: context, pageSize: pageSize)
                    }
                case .ghoul:
                    if let ghoul = character as? GhoulCharacter {
                        drawGhoulCharacterSheet(ghoul: ghoul, context: context, pageSize: pageSize)
                    }
                case .mage:
                    if let mage = character as? MageCharacter {
                        drawMageCharacterSheet(mage: mage, context: context, pageSize: pageSize)
                    }
                }
            }
        } catch {
            print("PDF generation error: \(error)")
            return nil
        }
    }
    
    // MARK: - Character Sheet Drawing Methods
    
    private static func drawVampireCharacterSheet(vampire: VampireCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        var currentY: CGFloat = margin
        
        // Draw decorative border around entire sheet
        drawPageBorder(pageSize: pageSize, margin: 20)
        
        // Header with title and logo area
        currentY += drawStyledHeader("VAMPIRE: THE MASQUERADE", subtitle: "CHARACTER SHEET", 
                                   at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 30
        
        // Character Information Section with decorative frame
        let infoSectionHeight: CGFloat = 120
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: infoSectionHeight))
        
        currentY += 10
        drawSectionHeaderInFrame("CHARACTER INFORMATION", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 25
        
        // Basic info in styled form fields
        let columnWidth = (pageSize.width - 3 * margin - 40) / 2
        let leftColumn = margin + 20
        let rightColumn = margin + columnWidth + 40
        
        currentY += drawStyledFieldRow("Name:", vampire.name, "Chronicle:", vampire.chronicleName, 
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawStyledFieldRow("Concept:", vampire.concept, "Clan:", vampire.clan,
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawStyledFieldRow("Predator Type:", vampire.predatorType, "Generation:", "\(vampire.generation)",
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += 30
        
        // Attributes Section with decorative styling
        let attributesHeight: CGFloat = 150
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: attributesHeight))
        currentY += 10
        drawSectionHeaderInFrame("ATTRIBUTES", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 20
        currentY += drawStyledAttributes(character: vampire, startY: currentY, margin: margin + 20, pageSize: pageSize)
        currentY += 30
        
        // Skills Section with decorative styling
        let skillsHeight: CGFloat = 180
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: skillsHeight))
        currentY += 10
        drawSectionHeaderInFrame("SKILLS", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 20
        currentY += drawStyledSkills(character: vampire, startY: currentY, margin: margin + 20, pageSize: pageSize)
        currentY += 30
        
        // Health and Willpower with boxes
        currentY += drawStyledHealthWillpower(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 30
        
        // Disciplines with decorative styling
        if currentY < pageSize.height - 200 {
            let disciplinesHeight: CGFloat = min(150, pageSize.height - currentY - 50)
            drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: disciplinesHeight))
            currentY += 10
            drawSectionHeaderInFrame("DISCIPLINES", at: CGPoint(x: margin + 10, y: currentY))
            currentY += 20
            currentY += drawStyledDisciplines(character: vampire, startY: currentY, margin: margin + 20, pageSize: pageSize, maxHeight: disciplinesHeight - 40)
            currentY += 20
        }
        
        // Vampire Traits at bottom if space available
        if currentY < pageSize.height - 80 {
            currentY += drawStyledVampireTraits(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        }
    }
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        var currentY: CGFloat = margin
        
        // Draw decorative border around entire sheet
        drawPageBorder(pageSize: pageSize, margin: 20)
        
        // Header
        currentY += drawStyledHeader("VAMPIRE: THE MASQUERADE", subtitle: "GHOUL CHARACTER SHEET", 
                                   at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 30
        
        // Character Information Section
        let infoSectionHeight: CGFloat = 100
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: infoSectionHeight))
        
        currentY += 10
        drawSectionHeaderInFrame("CHARACTER INFORMATION", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 25
        
        let columnWidth = (pageSize.width - 3 * margin - 40) / 2
        let leftColumn = margin + 20
        let rightColumn = margin + columnWidth + 40
        
        currentY += drawStyledFieldRow("Name:", ghoul.name, "Chronicle:", ghoul.chronicleName,
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawStyledFieldRow("Concept:", ghoul.concept, "Humanity:", "\(ghoul.humanity)",
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += 30
        
        // Attributes, Skills, Health/Willpower, Disciplines - same styling as vampire
        let attributesHeight: CGFloat = 150
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: attributesHeight))
        currentY += 10
        drawSectionHeaderInFrame("ATTRIBUTES", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 20
        currentY += drawStyledAttributes(character: ghoul, startY: currentY, margin: margin + 20, pageSize: pageSize)
        currentY += 30
        
        let skillsHeight: CGFloat = 180
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: skillsHeight))
        currentY += 10
        drawSectionHeaderInFrame("SKILLS", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 20
        currentY += drawStyledSkills(character: ghoul, startY: currentY, margin: margin + 20, pageSize: pageSize)
        currentY += 30
        
        currentY += drawStyledHealthWillpower(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 30
        
        if currentY < pageSize.height - 150 {
            let disciplinesHeight: CGFloat = min(120, pageSize.height - currentY - 50)
            drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: disciplinesHeight))
            currentY += 10
            drawSectionHeaderInFrame("DISCIPLINES", at: CGPoint(x: margin + 10, y: currentY))
            currentY += 20
            currentY += drawStyledDisciplines(character: ghoul, startY: currentY, margin: margin + 20, pageSize: pageSize, maxHeight: disciplinesHeight - 40)
        }
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        var currentY: CGFloat = margin
        
        // Draw decorative border around entire sheet
        drawPageBorder(pageSize: pageSize, margin: 20)
        
        // Header
        currentY += drawStyledHeader("MAGE: THE AWAKENING", subtitle: "CHARACTER SHEET", 
                                   at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 30
        
        // Character Information
        let infoSectionHeight: CGFloat = 100
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: infoSectionHeight))
        
        currentY += 10
        drawSectionHeaderInFrame("CHARACTER INFORMATION", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 25
        
        let columnWidth = (pageSize.width - 3 * margin - 40) / 2
        let leftColumn = margin + 20
        let rightColumn = margin + columnWidth + 40
        
        currentY += drawStyledFieldRow("Name:", mage.name, "Chronicle:", mage.chronicleName,
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawStyledFieldRow("Concept:", mage.concept, "", "",
                                      leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += 30
        
        // Attributes only for now
        let attributesHeight: CGFloat = 150
        drawSectionFrame(rect: CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: attributesHeight))
        currentY += 10
        drawSectionHeaderInFrame("ATTRIBUTES", at: CGPoint(x: margin + 10, y: currentY))
        currentY += 20
        currentY += drawStyledAttributes(character: mage, startY: currentY, margin: margin + 20, pageSize: pageSize)
        currentY += 50
        
        // Note about full implementation
        let noteRect = CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin, height: 40)
        drawSectionFrame(rect: noteRect)
        let noteFont = UIFont.italicSystemFont(ofSize: 12)
        let noteAttributes: [NSAttributedString.Key: Any] = [
            .font: noteFont,
            .foregroundColor: UIColor.gray
        ]
        let noteString = NSAttributedString(string: "Full Mage implementation coming soon", attributes: noteAttributes)
        noteString.draw(at: CGPoint(x: margin + 10, y: currentY + 15))
    }
    
    
    // MARK: - Drawing Helper Methods with Visual Styling
    
    private static func drawPageBorder(pageSize: CGSize, margin: CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(2.0)
        
        // Outer border
        let borderRect = CGRect(x: margin, y: margin, width: pageSize.width - 2*margin, height: pageSize.height - 2*margin)
        context?.stroke(borderRect)
        
        // Inner decorative border
        context?.setLineWidth(0.5)
        let innerBorderRect = CGRect(x: margin + 5, y: margin + 5, width: pageSize.width - 2*margin - 10, height: pageSize.height - 2*margin - 10)
        context?.stroke(innerBorderRect)
    }
    
    @discardableResult
    private static func drawStyledHeader(_ title: String, subtitle: String, at point: CGPoint, pageSize: CGSize) -> CGFloat {
        // Draw header background
        let headerRect = CGRect(x: point.x, y: point.y, width: pageSize.width - 2*point.x, height: 60)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(headerRect)
        
        // Draw title in white on black background
        let titleFont = UIFont.boldSystemFont(ofSize: 18)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.white
        ]
        
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let titleSize = titleString.size()
        let titleRect = CGRect(x: (pageSize.width - titleSize.width) / 2, y: point.y + 10, width: titleSize.width, height: titleSize.height)
        titleString.draw(in: titleRect)
        
        // Draw subtitle
        let subtitleFont = UIFont.systemFont(ofSize: 12)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.white
        ]
        
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        let subtitleSize = subtitleString.size()
        let subtitleRect = CGRect(x: (pageSize.width - subtitleSize.width) / 2, y: point.y + 35, width: subtitleSize.width, height: subtitleSize.height)
        subtitleString.draw(in: subtitleRect)
        
        return 60
    }
    
    private static func drawSectionFrame(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw section background with light gray fill
        context?.setFillColor(UIColor(white: 0.97, alpha: 1.0).cgColor)
        context?.fill(rect)
        
        // Draw border
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.stroke(rect)
        
        // Draw corner decorations
        let cornerSize: CGFloat = 8
        context?.setFillColor(UIColor.black.cgColor)
        
        // Top-left corner
        context?.fill(CGRect(x: rect.minX, y: rect.minY, width: cornerSize, height: 1))
        context?.fill(CGRect(x: rect.minX, y: rect.minY, width: 1, height: cornerSize))
        
        // Top-right corner
        context?.fill(CGRect(x: rect.maxX - cornerSize, y: rect.minY, width: cornerSize, height: 1))
        context?.fill(CGRect(x: rect.maxX - 1, y: rect.minY, width: 1, height: cornerSize))
        
        // Bottom-left corner
        context?.fill(CGRect(x: rect.minX, y: rect.maxY - 1, width: cornerSize, height: 1))
        context?.fill(CGRect(x: rect.minX, y: rect.maxY - cornerSize, width: 1, height: cornerSize))
        
        // Bottom-right corner
        context?.fill(CGRect(x: rect.maxX - cornerSize, y: rect.maxY - 1, width: cornerSize, height: 1))
        context?.fill(CGRect(x: rect.maxX - 1, y: rect.maxY - cornerSize, width: 1, height: cornerSize))
    }
    
    private static func drawSectionHeaderInFrame(_ text: String, at point: CGPoint) {
        let font = UIFont.boldSystemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
    }
    
    @discardableResult
    private static func drawStyledFieldRow(_ leftLabel: String, _ leftValue: String, _ rightLabel: String, _ rightValue: String, 
                                         leftX: CGFloat, rightX: CGFloat, y: CGFloat, columnWidth: CGFloat) -> CGFloat {
        drawStyledField(leftLabel, value: leftValue, at: CGPoint(x: leftX, y: y), width: columnWidth)
        if !rightLabel.isEmpty {
            drawStyledField(rightLabel, value: rightValue, at: CGPoint(x: rightX, y: y), width: columnWidth)
        }
        return 25
    }
    
    private static func drawStyledField(_ label: String, value: String, at point: CGPoint, width: CGFloat) {
        let labelFont = UIFont.boldSystemFont(ofSize: 10)
        let valueFont = UIFont.systemFont(ofSize: 10)
        
        // Draw label
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black
        ]
        let labelString = NSAttributedString(string: label, attributes: labelAttributes)
        let labelSize = labelString.size()
        labelString.draw(at: point)
        
        // Draw form field box
        let fieldRect = CGRect(x: point.x + labelSize.width + 5, y: point.y + 12, width: width - labelSize.width - 10, height: 18)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(fieldRect)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(0.8)
        context?.stroke(fieldRect)
        
        // Draw value inside the box
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: valueFont,
            .foregroundColor: UIColor.black
        ]
        let valueString = NSAttributedString(string: value, attributes: valueAttributes)
        let valueRect = CGRect(x: fieldRect.minX + 3, y: fieldRect.minY + 2, width: fieldRect.width - 6, height: fieldRect.height - 4)
        valueString.draw(in: valueRect)
    }
    
    
    @discardableResult
    private static func drawStyledAttributes(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 4 * margin) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + margin/2
        let mentalX = margin + 2 * (columnWidth + margin/2)
        
        var maxHeight: CGFloat = 0
        
        // Physical Attributes
        var physicalY = startY
        drawStyledAttributeCategory("PHYSICAL", at: CGPoint(x: physicalX, y: physicalY))
        physicalY += 20
        
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            physicalY += drawStyledAttributeLine(attribute, value: value, at: CGPoint(x: physicalX, y: physicalY), width: columnWidth)
        }
        maxHeight = max(maxHeight, physicalY - startY)
        
        // Social Attributes
        var socialY = startY
        drawStyledAttributeCategory("SOCIAL", at: CGPoint(x: socialX, y: socialY))
        socialY += 20
        
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            socialY += drawStyledAttributeLine(attribute, value: value, at: CGPoint(x: socialX, y: socialY), width: columnWidth)
        }
        maxHeight = max(maxHeight, socialY - startY)
        
        // Mental Attributes
        var mentalY = startY
        drawStyledAttributeCategory("MENTAL", at: CGPoint(x: mentalX, y: mentalY))
        mentalY += 20
        
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            mentalY += drawStyledAttributeLine(attribute, value: value, at: CGPoint(x: mentalX, y: mentalY), width: columnWidth)
        }
        maxHeight = max(maxHeight, mentalY - startY)
        
        return maxHeight
    }
    
    private static func drawStyledAttributeCategory(_ text: String, at point: CGPoint) {
        let font = UIFont.boldSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
        
        // Draw underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 15))
        context?.addLine(to: CGPoint(x: point.x + 80, y: point.y + 15))
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawStyledAttributeLine(_ name: String, value: Int, at point: CGPoint, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 10)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        // Draw attribute name
        let nameString = NSAttributedString(string: "\(name):", attributes: attributes)
        nameString.draw(at: point)
        
        // Draw dots in boxes
        let dotStartX = point.x + 70
        let boxSize: CGFloat = 10
        let boxSpacing: CGFloat = 12
        
        for i in 0..<5 {
            let boxX = dotStartX + CGFloat(i) * boxSpacing
            let boxRect = CGRect(x: boxX, y: point.y + 1, width: boxSize, height: boxSize)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(UIColor.white.cgColor)
            context?.fill(boxRect)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(0.5)
            context?.stroke(boxRect)
            
            if i < value {
                // Fill with dot
                context?.setFillColor(UIColor.black.cgColor)
                let dotRect = CGRect(x: boxX + 2, y: point.y + 3, width: boxSize - 4, height: boxSize - 4)
                context?.fillEllipse(in: dotRect)
            }
        }
        
        return 15
    }
    
    @discardableResult
    private static func drawStyledSkills(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 4 * margin) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + margin/2
        let mentalX = margin + 2 * (columnWidth + margin/2)
        
        var maxHeight: CGFloat = 0
        
        // Physical Skills
        var physicalY = startY
        drawStyledAttributeCategory("PHYSICAL", at: CGPoint(x: physicalX, y: physicalY))
        physicalY += 20
        
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            physicalY += drawStyledAttributeLine(skill, value: value, at: CGPoint(x: physicalX, y: physicalY), width: columnWidth)
        }
        maxHeight = max(maxHeight, physicalY - startY)
        
        // Social Skills
        var socialY = startY
        drawStyledAttributeCategory("SOCIAL", at: CGPoint(x: socialX, y: socialY))
        socialY += 20
        
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            socialY += drawStyledAttributeLine(skill, value: value, at: CGPoint(x: socialX, y: socialY), width: columnWidth)
        }
        maxHeight = max(maxHeight, socialY - startY)
        
        // Mental Skills
        var mentalY = startY
        drawStyledAttributeCategory("MENTAL", at: CGPoint(x: mentalX, y: mentalY))
        mentalY += 20
        
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            mentalY += drawStyledAttributeLine(skill, value: value, at: CGPoint(x: mentalX, y: mentalY), width: columnWidth)
        }
        maxHeight = max(maxHeight, mentalY - startY)
        
        return maxHeight
    }
    
    @discardableResult
    private static func drawStyledHealthWillpower(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 3 * margin) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + margin
        
        // Health Section
        drawStyledTracker("HEALTH", character.health, character.healthStates, at: CGPoint(x: leftColumn, y: startY), width: columnWidth)
        
        // Willpower Section
        drawStyledTracker("WILLPOWER", character.willpower, character.willpowerStates, at: CGPoint(x: rightColumn, y: startY), width: columnWidth)
        
        return 50
    }
    
    private static func drawStyledTracker(_ label: String, _ maxValue: Int, _ states: [DamageState], at point: CGPoint, width: CGFloat) {
        // Draw label with frame
        let font = UIFont.boldSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let labelString = NSAttributedString(string: label, attributes: attributes)
        labelString.draw(at: point)
        
        // Draw tracker boxes
        let boxSize: CGFloat = 15
        let boxSpacing: CGFloat = 17
        let startX = point.x
        let startY = point.y + 20
        
        for i in 0..<maxValue {
            let boxX = startX + CGFloat(i % 10) * boxSpacing
            let boxY = startY + CGFloat(i / 10) * (boxSize + 2)
            let boxRect = CGRect(x: boxX, y: boxY, width: boxSize, height: boxSize)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(UIColor.white.cgColor)
            context?.fill(boxRect)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            context?.stroke(boxRect)
            
            // Draw damage state if present
            if i < states.count {
                let centerX = boxX + boxSize / 2
                let centerY = boxY + boxSize / 2
                
                switch states[i] {
                case .superficial:
                    // Draw slash
                    context?.setStrokeColor(UIColor.black.cgColor)
                    context?.setLineWidth(2.0)
                    context?.move(to: CGPoint(x: boxX + 2, y: boxY + 2))
                    context?.addLine(to: CGPoint(x: boxX + boxSize - 2, y: boxY + boxSize - 2))
                    context?.strokePath()
                case .aggravated:
                    // Draw X
                    context?.setStrokeColor(UIColor.black.cgColor)
                    context?.setLineWidth(2.0)
                    context?.move(to: CGPoint(x: boxX + 2, y: boxY + 2))
                    context?.addLine(to: CGPoint(x: boxX + boxSize - 2, y: boxY + boxSize - 2))
                    context?.move(to: CGPoint(x: boxX + boxSize - 2, y: boxY + 2))
                    context?.addLine(to: CGPoint(x: boxX + 2, y: boxY + boxSize - 2))
                    context?.strokePath()
                case .ok:
                    // Leave empty
                    break
                }
            }
        }
    }
    
    @discardableResult
    private static func drawStyledDisciplines(character: any DisciplineCapable, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        var currentY = startY
        
        if character.v5Disciplines.isEmpty {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.italicSystemFont(ofSize: 10),
                .foregroundColor: UIColor.gray
            ]
            let text = NSAttributedString(string: "No disciplines learned", attributes: attributes)
            text.draw(at: CGPoint(x: margin, y: currentY))
            return 15
        }
        
        for discipline in character.v5Disciplines {
            if currentY - startY > maxHeight - 30 { break }
            
            let level = discipline.currentLevel()
            
            // Draw discipline name in a styled box
            let disciplineRect = CGRect(x: margin, y: currentY, width: pageSize.width - 2*margin - 40, height: 20)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(UIColor(white: 0.9, alpha: 1.0).cgColor)
            context?.fill(disciplineRect)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(0.5)
            context?.stroke(disciplineRect)
            
            // Draw discipline name
            let font = UIFont.boldSystemFont(ofSize: 11)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let nameString = NSAttributedString(string: discipline.name, attributes: attributes)
            nameString.draw(at: CGPoint(x: margin + 5, y: currentY + 3))
            
            // Draw dots for level
            let dotStartX = pageSize.width - margin - 80
            let boxSize: CGFloat = 8
            let boxSpacing: CGFloat = 10
            
            for i in 0..<5 {
                let boxX = dotStartX + CGFloat(i) * boxSpacing
                let boxRect = CGRect(x: boxX, y: currentY + 6, width: boxSize, height: boxSize)
                
                context?.setFillColor(UIColor.white.cgColor)
                context?.fill(boxRect)
                context?.setStrokeColor(UIColor.black.cgColor)
                context?.setLineWidth(0.5)
                context?.stroke(boxRect)
                
                if i < level {
                    context?.setFillColor(UIColor.black.cgColor)
                    let dotRect = CGRect(x: boxX + 1, y: currentY + 7, width: boxSize - 2, height: boxSize - 2)
                    context?.fillEllipse(in: dotRect)
                }
            }
            
            currentY += 25
            
            // List selected powers
            let selectedPowers = discipline.getAllSelectedPowerNames()
            if !selectedPowers.isEmpty && currentY - startY < maxHeight - 20 {
                let powersText = "Powers: \(Array(selectedPowers).joined(separator: ", "))"
                let powerAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 9),
                    .foregroundColor: UIColor.darkGray
                ]
                let powerString = NSAttributedString(string: powersText, attributes: powerAttributes)
                powerString.draw(at: CGPoint(x: margin + 10, y: currentY))
                currentY += 15
            }
            currentY += 5
        }
        
        return currentY - startY
    }
    
    @discardableResult
    private static func drawStyledVampireTraits(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let traitsHeight: CGFloat = 80
        let traitsRect = CGRect(x: margin, y: startY, width: pageSize.width - 2*margin, height: traitsHeight)
        drawSectionFrame(rect: traitsRect)
        
        let currentY = startY + 10
        drawSectionHeaderInFrame("VAMPIRE TRAITS", at: CGPoint(x: margin + 10, y: currentY))
        
        let fieldY = currentY + 25
        let columnWidth = (pageSize.width - 3 * margin - 40) / 2
        let leftColumn = margin + 20
        let rightColumn = margin + columnWidth + 40
        
        drawStyledField("Hunger:", value: "\(vampire.hunger)", at: CGPoint(x: leftColumn, y: fieldY), width: columnWidth)
        drawStyledField("Blood Potency:", value: "\(vampire.bloodPotency)", at: CGPoint(x: rightColumn, y: fieldY), width: columnWidth)
        
        let fieldY2 = fieldY + 30
        drawStyledField("Humanity:", value: "\(vampire.humanity)", at: CGPoint(x: leftColumn, y: fieldY2), width: columnWidth)
        drawStyledField("Experience:", value: "\(vampire.experience)", at: CGPoint(x: rightColumn, y: fieldY2), width: columnWidth)
        
        return traitsHeight + 10
    }
    
    private static func drawText(_ text: String, at point: CGPoint, fontSize: CGFloat, bold: Bool = false, color: UIColor = .black) {
        let font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
    }
}
}