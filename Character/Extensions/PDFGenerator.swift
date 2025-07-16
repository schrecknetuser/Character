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
        
        // Draw red border around entire page
        drawRedPageBorder(pageSize: pageSize, margin: 20)
        
        var currentY: CGFloat = margin
        
        // Draw VtM logo and header
        currentY += drawVtMLogoHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 15
        
        // Character identity section (name, player, chronicle)
        currentY += drawCharacterIdentitySection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 10
        
        // Character details section (concept, clan, generation, sire, ambition)
        currentY += drawVampireDetailsSection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Predator Type and Experience section
        currentY += drawPredatorExperienceSection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Attributes section in three columns
        currentY += drawAttributesSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Skills section in three columns  
        currentY += drawSkillsSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Health and Willpower (always blank)
        currentY += drawHealthWillpowerSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Vampire-specific traits (Hunger, Humanity, Blood Potency, etc.)
        currentY += drawVampireTraitsSection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Check if we need a second page for disciplines and merits/flaws
        if currentY > pageSize.height - 200 {
            context.beginPage()
            currentY = margin
            drawRedPageBorder(pageSize: pageSize, margin: 20)
            currentY += 20
        }
        
        // Disciplines section
        currentY += drawDisciplinesSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: min(200, pageSize.height - currentY - 100))
        currentY += 15
        
        // Check if we need space for merits/flaws
        if currentY > pageSize.height - 150 {
            context.beginPage()
            currentY = margin
            drawRedPageBorder(pageSize: pageSize, margin: 20)
            currentY += 20
        }
        
        // Merits and Flaws section
        currentY += drawMeritsFlawsSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 80)
        
        // Notes section at bottom if space
        if currentY < pageSize.height - 100 {
            currentY += 15
            drawNotesSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 40)
        }
    }
    
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        
        // Draw red border around entire page
        drawRedPageBorder(pageSize: pageSize, margin: 20)
        
        var currentY: CGFloat = margin
        
        // Draw VtM logo and header for ghoul
        currentY += drawVtMLogoHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize, subtitle: "GHOUL CHARACTER SHEET")
        currentY += 15
        
        // Character identity section
        currentY += drawCharacterIdentitySection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 10
        
        // Ghoul-specific details
        currentY += drawGhoulDetailsSection(ghoul: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Attributes and Skills
        currentY += drawAttributesSection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        currentY += drawSkillsSection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Health and Willpower
        currentY += drawHealthWillpowerSection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Disciplines section
        if currentY < pageSize.height - 150 {
            currentY += drawDisciplinesSection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 50)
        }
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        
        // Draw red border around entire page
        drawRedPageBorder(pageSize: pageSize, margin: 20)
        
        var currentY: CGFloat = margin
        
        // Draw Mage header
        currentY += drawMageLogoHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 15
        
        // Character identity section
        currentY += drawCharacterIdentitySection(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 10
        
        // Basic details
        currentY += drawMageDetailsSection(mage: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes and Skills
        currentY += drawAttributesSection(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Note about full implementation
        drawStyledNote("Full Mage character sheet implementation coming soon", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
    }
    
    
    // MARK: - VTM-Style Drawing Methods with Red Borders and Logo
    
    @discardableResult
    private static func drawRedPageBorder(pageSize: CGSize, margin: CGFloat) -> CGFloat {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(3.0)
        
        // Draw outer red border
        let borderRect = CGRect(x: margin, y: margin, width: pageSize.width - 2 * margin, height: pageSize.height - 2 * margin)
        context?.stroke(borderRect)
        
        // Draw inner decorative border
        context?.setLineWidth(1.0)
        let innerMargin = margin + 5
        let innerBorderRect = CGRect(x: innerMargin, y: innerMargin, width: pageSize.width - 2 * innerMargin, height: pageSize.height - 2 * innerMargin)
        context?.stroke(innerBorderRect)
        
        return 0
    }
    
    @discardableResult
    private static func drawVtMLogoHeader(at point: CGPoint, pageSize: CGSize, subtitle: String = "CHARACTER SHEET") -> CGFloat {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw VTM logo placeholder (red circle with ankh)
        let logoSize: CGFloat = 40
        let logoX = pageSize.width - 80
        let logoY = point.y + 10
        
        context?.setFillColor(UIColor.systemRed.cgColor)
        context?.fillEllipse(in: CGRect(x: logoX, y: logoY, width: logoSize, height: logoSize))
        
        // Draw ankh symbol in white (simplified)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(3.0)
        let ankhCenterX = logoX + logoSize/2
        let ankhCenterY = logoY + logoSize/2
        // Vertical line
        context?.move(to: CGPoint(x: ankhCenterX, y: logoY + 8))
        context?.addLine(to: CGPoint(x: ankhCenterX, y: logoY + logoSize - 8))
        // Horizontal line
        context?.move(to: CGPoint(x: logoX + 8, y: ankhCenterY))
        context?.addLine(to: CGPoint(x: logoX + logoSize - 8, y: ankhCenterY))
        // Top loop (circle)
        context?.strokeEllipse(in: CGRect(x: ankhCenterX - 6, y: logoY + 8, width: 12, height: 12))
        context?.strokePath()
        
        // Draw main title
        let titleFont = UIFont.boldSystemFont(ofSize: 22)
        let titleText = "VAMPIRE: THE MASQUERADE"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: titleText, attributes: titleAttributes)
        let titleSize = titleString.size()
        let titleRect = CGRect(x: point.x, y: point.y, width: titleSize.width, height: titleSize.height)
        titleString.draw(in: titleRect)
        
        // Draw subtitle
        let subtitleFont = UIFont.boldSystemFont(ofSize: 12)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemRed
        ]
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        let subtitleSize = subtitleString.size()
        let subtitleRect = CGRect(x: point.x, y: point.y + titleSize.height + 2, width: subtitleSize.width, height: subtitleSize.height)
        subtitleString.draw(in: subtitleRect)
        
        // Draw decorative red line
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        let lineY = point.y + titleSize.height + subtitleSize.height + 8
        context?.move(to: CGPoint(x: point.x, y: lineY))
        context?.addLine(to: CGPoint(x: pageSize.width - 120, y: lineY))
        context?.strokePath()
        
        return titleSize.height + subtitleSize.height + 15
    }
    
    @discardableResult
    private static func drawMageLogoHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        // Similar to VTM but with Mage styling
        let titleFont = UIFont.boldSystemFont(ofSize: 22)
        let titleText = "MAGE: THE AWAKENING"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: titleText, attributes: titleAttributes)
        let titleSize = titleString.size()
        let titleRect = CGRect(x: point.x, y: point.y, width: titleSize.width, height: titleSize.height)
        titleString.draw(in: titleRect)
        
        // Draw subtitle
        let subtitleFont = UIFont.boldSystemFont(ofSize: 12)
        let subtitleText = "CHARACTER SHEET"
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemBlue
        ]
        let subtitleString = NSAttributedString(string: subtitleText, attributes: subtitleAttributes)
        let subtitleSize = subtitleString.size()
        let subtitleRect = CGRect(x: point.x, y: point.y + titleSize.height + 2, width: subtitleSize.width, height: subtitleSize.height)
        subtitleString.draw(in: subtitleRect)
        
        return titleSize.height + subtitleSize.height + 15
    }
    
    
    @discardableResult
    private static func drawCharacterIdentitySection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        // Name, Player, Chronicle in first row
        drawStyledField("Name", value: character.name, 
                       at: CGPoint(x: margin, y: startY), 
                       width: fieldWidth, fontSize: 11, isBold: true)
        
        drawStyledField("Player", value: "", 
                       at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                       width: fieldWidth, fontSize: 11, isBold: false)
        
        drawStyledField("Chronicle", value: character.chronicleName,
                       at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                       width: fieldWidth, fontSize: 11, isBold: false)
        
        return 35
    }
    
    @discardableResult
    private static func drawVampireDetailsSection(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 30) / 4
        
        // First row: Concept, Clan, Generation, Sire
        drawStyledField("Concept", value: vampire.concept,
                       at: CGPoint(x: margin, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Clan", value: vampire.clan,
                       at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Generation", value: "\(vampire.generation)",
                       at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Sire", value: "",
                       at: CGPoint(x: margin + 3 * (fieldWidth + 10), y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        // Second row: Ambition, Desire, etc.
        let secondRowY = startY + 30
        
        drawStyledField("Ambition", value: vampire.ambition,
                       at: CGPoint(x: margin, y: secondRowY), 
                       width: fieldWidth * 1.5, fontSize: 10)
        
        drawStyledField("Desire", value: vampire.desire,
                       at: CGPoint(x: margin + (fieldWidth * 1.5) + 10, y: secondRowY), 
                       width: fieldWidth * 1.5, fontSize: 10)
        
        return 65
    }
    
    @discardableResult
    private static func drawPredatorExperienceSection(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        drawStyledField("Predator Type", value: vampire.predatorType,
                       at: CGPoint(x: margin, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Total Experience", value: "\(vampire.experience)",
                       at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Spent Experience", value: "\(vampire.spentExperience)",
                       at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        return 30
    }
    
    @discardableResult
    private static func drawGhoulDetailsSection(ghoul: GhoulCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        drawStyledField("Concept", value: ghoul.concept,
                       at: CGPoint(x: margin, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Domitor", value: "",
                       at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Humanity", value: "\(ghoul.humanity)",
                       at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        return 30
    }
    
    @discardableResult
    private static func drawMageDetailsSection(mage: MageCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawStyledField("Concept", value: mage.concept,
                       at: CGPoint(x: margin, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Path", value: "",
                       at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        return 30
    }
    
    
    private static func drawStyledField(_ label: String, value: String, at point: CGPoint, width: CGFloat, fontSize: CGFloat = 10, valueSize: CGFloat = 10, isBold: Bool = false) {
        let labelFont = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let valueFont = UIFont.systemFont(ofSize: valueSize)
        
        // Draw label
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black
        ]
        let labelString = NSAttributedString(string: label.uppercased(), attributes: labelAttributes)
        labelString.draw(at: point)
        
        // Draw red underline for the field
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(1.5)
        
        let lineY = point.y + 18
        context?.move(to: CGPoint(x: point.x, y: lineY))
        context?.addLine(to: CGPoint(x: point.x + width, y: lineY))
        context?.strokePath()
        
        // Draw value if present
        if !value.isEmpty {
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: valueFont,
                .foregroundColor: UIColor.black
            ]
            let valueString = NSAttributedString(string: value, attributes: valueAttributes)
            valueString.draw(at: CGPoint(x: point.x + 2, y: point.y + 20))
        }
    }
    
    @discardableResult
    private static func drawAttributesSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // Section title with red styling
        drawSectionHeader("ATTRIBUTES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let attributesStartY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + 20
        let mentalX = margin + 2 * (columnWidth + 20)
        
        var maxHeight: CGFloat = 0
        
        // Physical Attributes
        var currentY = attributesStartY
        drawAttributeCategory("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawAttributeLine(attribute, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Social Attributes
        currentY = attributesStartY
        drawAttributeCategory("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawAttributeLine(attribute, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Mental Attributes
        currentY = attributesStartY
        drawAttributeCategory("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawAttributeLine(attribute, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        return maxHeight + 25
    }
    
    @discardableResult
    private static func drawSkillsSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // Section title with red styling
        drawSectionHeader("SKILLS", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let skillsStartY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + 20
        let mentalX = margin + 2 * (columnWidth + 20)
        
        var maxHeight: CGFloat = 0
        
        // Physical Skills
        var currentY = skillsStartY
        drawAttributeCategory("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawAttributeLine(skill, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Social Skills
        currentY = skillsStartY
        drawAttributeCategory("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawAttributeLine(skill, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Mental Skills
        currentY = skillsStartY
        drawAttributeCategory("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawAttributeLine(skill, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        return maxHeight + 25
    }
    
    private static func drawSectionHeader(_ text: String, at point: CGPoint, pageSize: CGSize) {
        let font = UIFont.boldSystemFont(ofSize: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemRed
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
        
        // Draw red underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 17))
        context?.addLine(to: CGPoint(x: point.x + 150, y: point.y + 17))
        context?.strokePath()
    }
    
    private static func drawAttributeCategory(_ text: String, at point: CGPoint) {
        let font = UIFont.boldSystemFont(ofSize: 11)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: point)
        
        // Draw black underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 14))
        context?.addLine(to: CGPoint(x: point.x + 80, y: point.y + 14))
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawAttributeLine(_ name: String, value: Int, at point: CGPoint, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 9)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        // Draw attribute/skill name
        let nameString = NSAttributedString(string: name, attributes: attributes)
        nameString.draw(at: point)
        
        // Draw dots
        let dotStartX = point.x + 70
        let dotSize: CGFloat = 7
        let dotSpacing: CGFloat = 10
        
        for i in 0..<5 {
            let dotX = dotStartX + CGFloat(i) * dotSpacing
            let dotCenter = CGPoint(x: dotX + dotSize/2, y: point.y + dotSize/2 + 1)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            
            let dotRect = CGRect(x: dotX, y: point.y + 1, width: dotSize, height: dotSize)
            context?.strokeEllipse(in: dotRect)
            
            if i < value {
                context?.setFillColor(UIColor.black.cgColor)
                context?.fillEllipse(in: dotRect)
            }
        }
        
        return 14
    }
    
    
    @discardableResult
    private static func drawHealthWillpowerSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 2 * margin - 20) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + 20
        
        // Health Section (always blank boxes)
        drawHealthWillpowerTracker("HEALTH", character.health, at: CGPoint(x: leftColumn, y: startY), width: columnWidth)
        
        // Willpower Section (always blank boxes)
        drawHealthWillpowerTracker("WILLPOWER", character.willpower, at: CGPoint(x: rightColumn, y: startY), width: columnWidth)
        
        return 70
    }
    
    private static func drawHealthWillpowerTracker(_ label: String, _ maxValue: Int, at point: CGPoint, width: CGFloat) {
        // Draw section title with red styling
        let font = UIFont.boldSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemRed
        ]
        
        let labelString = NSAttributedString(string: label, attributes: attributes)
        labelString.draw(at: point)
        
        // Draw red underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(1.5)
        context?.move(to: CGPoint(x: point.x, y: point.y + 15))
        context?.addLine(to: CGPoint(x: point.x + 80, y: point.y + 15))
        context?.strokePath()
        
        // Draw tracker boxes (always empty/blank)
        let boxSize: CGFloat = 12
        let boxSpacing: CGFloat = 14
        let startX = point.x
        let startY = point.y + 20
        
        for i in 0..<maxValue {
            let boxX = startX + CGFloat(i % 10) * boxSpacing
            let boxY = startY + CGFloat(i / 10) * (boxSize + 3)
            let boxRect = CGRect(x: boxX, y: boxY, width: boxSize, height: boxSize)
            
            context?.setFillColor(UIColor.white.cgColor)
            context?.fill(boxRect)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            context?.stroke(boxRect)
            
            // Always leave boxes empty - don't show current damage states
        }
    }
    
    @discardableResult
    private static func drawVampireTraitsSection(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // First row of vampire-specific traits
        let fieldWidth = (pageSize.width - 2 * margin - 30) / 4
        
        drawStyledField("Hunger", value: "\(vampire.hunger)",
                       at: CGPoint(x: margin, y: startY), 
                       width: fieldWidth - 10, fontSize: 10)
        
        drawStyledField("Humanity", value: "\(vampire.humanity)",
                       at: CGPoint(x: margin + fieldWidth, y: startY), 
                       width: fieldWidth - 10, fontSize: 10)
        
        drawStyledField("Blood Potency", value: "\(vampire.bloodPotency)",
                       at: CGPoint(x: margin + 2 * fieldWidth, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Blood Surge", value: "",
                       at: CGPoint(x: margin + 3 * fieldWidth + 10, y: startY), 
                       width: fieldWidth, fontSize: 10)
        
        // Second row of traits (blank fields as requested)
        let secondRowY = startY + 35
        
        drawStyledField("Power Bonus", value: "",
                       at: CGPoint(x: margin, y: secondRowY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Rouse Re-Roll", value: "",
                       at: CGPoint(x: margin + fieldWidth + 10, y: secondRowY), 
                       width: fieldWidth, fontSize: 10)
        
        drawStyledField("Feeding Penalty", value: "",
                       at: CGPoint(x: margin + 2 * fieldWidth + 10, y: secondRowY), 
                       width: fieldWidth + 20, fontSize: 10)
        
        // Third row - Clan abilities
        let thirdRowY = startY + 70
        
        drawStyledField("Clan Bane", value: "",
                       at: CGPoint(x: margin, y: thirdRowY), 
                       width: fieldWidth * 2, fontSize: 10)
        
        drawStyledField("Clan Compulsion", value: "",
                       at: CGPoint(x: margin + (fieldWidth * 2) + 20, y: thirdRowY), 
                       width: fieldWidth * 2, fontSize: 10)
        
        return 105
    }
    
    @discardableResult
    private static func drawDisciplinesSection(character: any DisciplineCapable, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        // Section title with red styling
        drawSectionHeader("DISCIPLINES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        var currentY = startY + 25
        
        if character.v5Disciplines.isEmpty {
            let font = UIFont.italicSystemFont(ofSize: 10)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.gray
            ]
            let text = NSAttributedString(string: "No disciplines learned", attributes: attributes)
            text.draw(at: CGPoint(x: margin, y: currentY))
            return 40
        }
        
        for discipline in character.v5Disciplines {
            if currentY - startY > maxHeight - 40 { break }
            
            let level = discipline.currentLevel()
            
            // Draw discipline name with red styling
            let nameFont = UIFont.boldSystemFont(ofSize: 11)
            let nameAttributes: [NSAttributedString.Key: Any] = [
                .font: nameFont,
                .foregroundColor: UIColor.systemRed
            ]
            let nameString = NSAttributedString(string: discipline.name.uppercased(), attributes: nameAttributes)
            nameString.draw(at: CGPoint(x: margin, y: currentY))
            
            // Draw dots for level
            let dotStartX = margin + 120
            let dotSize: CGFloat = 8
            let dotSpacing: CGFloat = 12
            
            for i in 0..<5 {
                let dotX = dotStartX + CGFloat(i) * dotSpacing
                let dotRect = CGRect(x: dotX, y: currentY + 2, width: dotSize, height: dotSize)
                
                let context = UIGraphicsGetCurrentContext()
                context?.setStrokeColor(UIColor.black.cgColor)
                context?.setLineWidth(1.0)
                context?.strokeEllipse(in: dotRect)
                
                if i < level {
                    context?.setFillColor(UIColor.black.cgColor)
                    context?.fillEllipse(in: dotRect)
                }
            }
            
            currentY += 18
            
            // List selected powers
            let selectedPowers = discipline.getAllSelectedPowerNames()
            if !selectedPowers.isEmpty && currentY - startY < maxHeight - 25 {
                let powersText = Array(selectedPowers).joined(separator: ", ")
                let powerFont = UIFont.systemFont(ofSize: 9)
                let powerAttributes: [NSAttributedString.Key: Any] = [
                    .font: powerFont,
                    .foregroundColor: UIColor.darkGray
                ]
                let powerString = NSAttributedString(string: powersText, attributes: powerAttributes)
                powerString.draw(at: CGPoint(x: margin + 10, y: currentY))
                currentY += 12
            }
            currentY += 8
        }
        
        return currentY - startY
    }
    
    @discardableResult
    private static func drawMeritsFlawsSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        // Section title with red styling
        drawSectionHeader("MERITS & FLAWS", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        var currentY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 20) / 2
        let meritsColumn = margin
        let flawsColumn = margin + columnWidth + 20
        
        // Merits column
        let meritsFont = UIFont.boldSystemFont(ofSize: 11)
        let meritsAttributes: [NSAttributedString.Key: Any] = [
            .font: meritsFont,
            .foregroundColor: UIColor.black
        ]
        let meritsString = NSAttributedString(string: "MERITS", attributes: meritsAttributes)
        meritsString.draw(at: CGPoint(x: meritsColumn, y: currentY))
        
        // Flaws column
        let flawsString = NSAttributedString(string: "FLAWS", attributes: meritsAttributes)
        flawsString.draw(at: CGPoint(x: flawsColumn, y: currentY))
        
        currentY += 20
        
        let meritsStartY = currentY
        let flawsStartY = currentY
        
        // Draw merits
        currentY = meritsStartY
        for merit in character.advantages {
            if currentY - startY > maxHeight - 25 { break }
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(merit.name) (\(merit.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: meritsColumn, y: currentY))
            currentY += 12
        }
        
        // Draw background merits
        for backgroundMerit in character.backgroundMerits where backgroundMerit.type == .merit {
            if currentY - startY > maxHeight - 25 { break }
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(backgroundMerit.name) (\(backgroundMerit.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: meritsColumn, y: currentY))
            currentY += 12
        }
        
        // Draw flaws
        currentY = flawsStartY
        for flaw in character.flaws {
            if currentY - startY > maxHeight - 25 { break }
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(flaw.name) (\(flaw.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: flawsColumn, y: currentY))
            currentY += 12
        }
        
        // Draw background flaws
        for backgroundFlaw in character.backgroundFlaws where backgroundFlaw.type == .flaw {
            if currentY - startY > maxHeight - 25 { break }
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(backgroundFlaw.name) (\(backgroundFlaw.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: flawsColumn, y: currentY))
            currentY += 12
        }
        
        return max(currentY - startY, 80)
    }
    
    @discardableResult
    private static func drawNotesSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        // Section title with red styling
        drawSectionHeader("NOTES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        var currentY = startY + 25
        
        if !character.notes.isEmpty {
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            // Draw notes text (truncated if too long)
            let notesText = character.notes
            let textString = NSAttributedString(string: notesText, attributes: attributes)
            let textRect = CGRect(x: margin, y: currentY, width: pageSize.width - 2 * margin, height: maxHeight - 30)
            textString.draw(in: textRect)
        }
        
        return maxHeight
    }
    
    private static func drawStyledNote(_ text: String, at point: CGPoint, pageSize: CGSize) {
        let font = UIFont.italicSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        let noteString = NSAttributedString(string: text, attributes: attributes)
        noteString.draw(at: point)
    }
}