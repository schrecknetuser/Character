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
    }
    
    
    // MARK: - Character Sheet Drawing Methods
    
    private static func drawVampireCharacterSheet(vampire: VampireCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 30
        
        // Draw decorative red border frame
        drawVTMStyleBorder(pageSize: pageSize, margin: 20)
        
        var currentY: CGFloat = margin
        
        // Header with VTM logo and title
        currentY += drawVTMHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 20
        
        // Character identity row (Name, Player, Chronicle)
        currentY += drawCharacterIdentityRow(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Character details rows (Concept, Clan, Generation, Sire, Ambition)
        currentY += drawVampireDetailsRows(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes section
        currentY += drawAttributesGrid(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Skills section
        currentY += drawSkillsGrid(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Health and Willpower (blank boxes only)
        currentY += drawHealthWillpowerBoxes(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Check if we need a second page
        if currentY > pageSize.height - 300 {
            context.beginPage()
            currentY = margin
            drawVTMStyleBorder(pageSize: pageSize, margin: 20)
            currentY += 30
        }
        
        // Vampire-specific traits
        currentY += drawVampireTraitsGrid(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Disciplines with powers
        currentY += drawDisciplinesWithPowers(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: min(250, pageSize.height - currentY - 150))
        currentY += 20
        
        // Check if we need a third page for merits/flaws
        if currentY > pageSize.height - 200 {
            context.beginPage()
            currentY = margin
            drawVTMStyleBorder(pageSize: pageSize, margin: 20)
            currentY += 30
        }
        
        // Merits, Flaws, and Experience
        currentY += drawMeritsFlawsAndExperience(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 100)
        
        // Notes section at bottom if space remains
        if currentY < pageSize.height - 80 {
            currentY += 15
            drawNotesAndBiography(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        }
    }
    
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 30
        
        // Draw VTM-style border
        drawVTMStyleBorder(pageSize: pageSize, margin: 20)
        
        var currentY: CGFloat = margin
        
        // Header for ghoul
        currentY += drawGhoulHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 20
        
        // Character identity
        currentY += drawCharacterIdentityRow(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Ghoul-specific details
        currentY += drawGhoulDetailsRow(ghoul: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes and Skills
        currentY += drawAttributesGrid(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        currentY += drawSkillsGrid(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Health and Willpower (blank)
        currentY += drawHealthWillpowerBoxes(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Ghoul humanity and disciplines if space allows
        if currentY < pageSize.height - 150 {
            currentY += drawGhoulTraits(ghoul: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
            currentY += 15
            currentY += drawDisciplinesWithPowers(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 50)
        }
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 30
        
        // Draw border
        drawVTMStyleBorder(pageSize: pageSize, margin: 20)
        
        var currentY: CGFloat = margin
        
        // Header for mage
        currentY += drawMageHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 20
        
        // Character identity
        currentY += drawCharacterIdentityRow(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Basic mage details
        currentY += drawMageDetailsRow(mage: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes and Skills
        currentY += drawAttributesGrid(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Note about implementation
        let font = UIFont.italicSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        let noteText = "Full Mage character sheet implementation coming soon"
        let noteString = NSAttributedString(string: noteText, attributes: attributes)
        noteString.draw(at: CGPoint(x: margin, y: currentY))
    }
    
    // Helper methods for ghoul and mage headers
    @discardableResult
    private static func drawGhoulHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 20)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "VAMPIRE: THE MASQUERADE", attributes: titleAttributes)
        titleString.draw(at: point)
        
        let subtitleY = point.y + 22
        let subtitleFont = UIFont.boldSystemFont(ofSize: 11)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemRed
        ]
        let subtitleString = NSAttributedString(string: "GHOUL CHARACTER SHEET", attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: point.x, y: subtitleY))
        
        return 45
    }
    
    @discardableResult
    private static func drawMageHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 20)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "MAGE: THE AWAKENING", attributes: titleAttributes)
        titleString.draw(at: point)
        
        let subtitleY = point.y + 22
        let subtitleFont = UIFont.boldSystemFont(ofSize: 11)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemBlue
        ]
        let subtitleString = NSAttributedString(string: "CHARACTER SHEET", attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: point.x, y: subtitleY))
        
        return 45
    }
    
    @discardableResult
    private static func drawGhoulDetailsRow(ghoul: GhoulCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        drawFormField(label: "CONCEPT", value: ghoul.concept,
                     at: CGPoint(x: margin, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "DOMITOR", value: "",
                     at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "HUMANITY", value: "\(ghoul.humanity)",
                     at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                     width: fieldWidth)
        
        return 40
    }
    
    @discardableResult
    private static func drawMageDetailsRow(mage: MageCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawFormField(label: "CONCEPT", value: mage.concept,
                     at: CGPoint(x: margin, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "PATH", value: "",
                     at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                     width: fieldWidth)
        
        return 40
    }
    
    @discardableResult
    private static func drawGhoulTraits(ghoul: GhoulCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawFormField(label: "BLOOD BOND", value: "",
                     at: CGPoint(x: margin, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "DOMITOR INFLUENCE", value: "",
                     at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                     width: fieldWidth)
        
        return 40
    }
    
    
    // MARK: - VTM-Style Drawing Methods
    
    @discardableResult
    private static func drawVTMStyleBorder(pageSize: CGSize, margin: CGFloat) -> CGFloat {
        let context = UIGraphicsGetCurrentContext()
        
        // Outer red border (thick)
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(4.0)
        let outerRect = CGRect(x: margin, y: margin, width: pageSize.width - 2 * margin, height: pageSize.height - 2 * margin)
        context?.stroke(outerRect)
        
        // Inner decorative border
        context?.setLineWidth(1.5)
        let innerMargin = margin + 8
        let innerRect = CGRect(x: innerMargin, y: innerMargin, width: pageSize.width - 2 * innerMargin, height: pageSize.height - 2 * innerMargin)
        context?.stroke(innerRect)
        
        // Corner decorations
        drawCornerDecorations(pageSize: pageSize, margin: margin)
        
        return 0
    }
    
    private static func drawCornerDecorations(pageSize: CGSize, margin: CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        
        let cornerSize: CGFloat = 15
        let corners = [
            CGPoint(x: margin + 15, y: margin + 15), // top-left
            CGPoint(x: pageSize.width - margin - 15, y: margin + 15), // top-right
            CGPoint(x: margin + 15, y: pageSize.height - margin - 15), // bottom-left
            CGPoint(x: pageSize.width - margin - 15, y: pageSize.height - margin - 15) // bottom-right
        ]
        
        for corner in corners {
            // Draw small decorative cross at each corner
            context?.move(to: CGPoint(x: corner.x - 5, y: corner.y))
            context?.addLine(to: CGPoint(x: corner.x + 5, y: corner.y))
            context?.move(to: CGPoint(x: corner.x, y: corner.y - 5))
            context?.addLine(to: CGPoint(x: corner.x, y: corner.y + 5))
        }
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawVTMHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw VTM Ankh logo
        let logoSize: CGFloat = 35
        let logoX = pageSize.width - 80
        let logoY = point.y + 5
        
        // Red circle background
        context?.setFillColor(UIColor.systemRed.cgColor)
        context?.fillEllipse(in: CGRect(x: logoX, y: logoY, width: logoSize, height: logoSize))
        
        // White ankh symbol
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(2.5)
        let ankhCenterX = logoX + logoSize/2
        let ankhCenterY = logoY + logoSize/2
        
        // Ankh vertical line
        context?.move(to: CGPoint(x: ankhCenterX, y: logoY + 6))
        context?.addLine(to: CGPoint(x: ankhCenterX, y: logoY + logoSize - 6))
        
        // Ankh horizontal line
        context?.move(to: CGPoint(x: logoX + 8, y: ankhCenterY + 2))
        context?.addLine(to: CGPoint(x: logoX + logoSize - 8, y: ankhCenterY + 2))
        
        // Ankh top loop
        context?.strokeEllipse(in: CGRect(x: ankhCenterX - 5, y: logoY + 6, width: 10, height: 10))
        context?.strokePath()
        
        // Main title
        let titleFont = UIFont.boldSystemFont(ofSize: 20)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "VAMPIRE: THE MASQUERADE", attributes: titleAttributes)
        titleString.draw(at: point)
        
        // Subtitle
        let subtitleY = point.y + 22
        let subtitleFont = UIFont.boldSystemFont(ofSize: 11)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemRed
        ]
        let subtitleString = NSAttributedString(string: "CHARACTER SHEET", attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: point.x, y: subtitleY))
        
        // Decorative red line
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        let lineY = subtitleY + 15
        context?.move(to: CGPoint(x: point.x, y: lineY))
        context?.addLine(to: CGPoint(x: pageSize.width - 100, y: lineY))
        context?.strokePath()
        
        return 50
    }
    
    @discardableResult
    private static func drawCharacterIdentityRow(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        // Name (bold value)
        drawFormField(label: "NAME", value: character.name, 
                     at: CGPoint(x: margin, y: startY), 
                     width: fieldWidth, isBold: true)
        
        // Player (blank field)
        drawFormField(label: "PLAYER", value: "", 
                     at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                     width: fieldWidth)
        
        // Chronicle
        drawFormField(label: "CHRONICLE", value: character.chronicleName,
                     at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                     width: fieldWidth)
        
        return 40
    }
    
    @discardableResult
    private static func drawVampireDetailsRows(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 30) / 4
        
        // First row: Concept, Clan, Predator, Generation
        drawFormField(label: "CONCEPT", value: vampire.concept,
                     at: CGPoint(x: margin, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "CLAN", value: vampire.clan,
                     at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "PREDATOR", value: vampire.predatorType,
                     at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "GENERATION", value: "\(vampire.generation)",
                     at: CGPoint(x: margin + 3 * (fieldWidth + 10), y: startY), 
                     width: fieldWidth)
        
        // Second row: Sire, Ambition (wider fields)
        let secondRowY = startY + 40
        let wideFieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawFormField(label: "SIRE", value: "",
                     at: CGPoint(x: margin, y: secondRowY), 
                     width: wideFieldWidth)
        
        drawFormField(label: "AMBITION", value: vampire.ambition,
                     at: CGPoint(x: margin + wideFieldWidth + 10, y: secondRowY), 
                     width: wideFieldWidth)
        
        return 80
    }
    
    private static func drawFormField(label: String, value: String, at point: CGPoint, width: CGFloat, fontSize: CGFloat = 9, isBold: Bool = false) {
        let labelFont = UIFont.boldSystemFont(ofSize: fontSize)
        let valueFont = isBold ? UIFont.boldSystemFont(ofSize: fontSize + 1) : UIFont.systemFont(ofSize: fontSize)
        
        // Draw label in uppercase
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black
        ]
        let labelString = NSAttributedString(string: label.uppercased(), attributes: labelAttributes)
        labelString.draw(at: point)
        
        // Draw underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        let lineY = point.y + 17
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
            valueString.draw(at: CGPoint(x: point.x + 2, y: point.y + 19))
        }
    }
    
    @discardableResult
    private static func drawAttributesGrid(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // Section header
        drawSectionTitle("ATTRIBUTES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let attributesStartY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + 20
        let mentalX = margin + 2 * (columnWidth + 20)
        
        var maxHeight: CGFloat = 0
        
        // Physical column
        var currentY = attributesStartY
        drawColumnHeader("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 18
        
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawAttributeWithDots(attribute, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Social column
        currentY = attributesStartY
        drawColumnHeader("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 18
        
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawAttributeWithDots(attribute, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Mental column
        currentY = attributesStartY
        drawColumnHeader("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 18
        
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawAttributeWithDots(attribute, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        return maxHeight + 25
    }
    
    @discardableResult
    private static func drawSkillsGrid(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // Section header
        drawSectionTitle("SKILLS", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let skillsStartY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + 20
        let mentalX = margin + 2 * (columnWidth + 20)
        
        var maxHeight: CGFloat = 0
        
        // Physical Skills
        var currentY = skillsStartY
        drawColumnHeader("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 18
        
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawAttributeWithDots(skill, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Social Skills
        currentY = skillsStartY
        drawColumnHeader("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 18
        
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawAttributeWithDots(skill, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Mental Skills
        currentY = skillsStartY
        drawColumnHeader("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 18
        
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawAttributeWithDots(skill, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        return maxHeight + 25
    }
    
    
    private static func drawSectionTitle(_ title: String, at point: CGPoint, pageSize: CGSize) {
        let font = UIFont.boldSystemFont(ofSize: 13)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemRed
        ]
        let titleString = NSAttributedString(string: title, attributes: attributes)
        titleString.draw(at: point)
        
        // Red underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 16))
        context?.addLine(to: CGPoint(x: point.x + 120, y: point.y + 16))
        context?.strokePath()
    }
    
    private static func drawColumnHeader(_ title: String, at point: CGPoint) {
        let font = UIFont.boldSystemFont(ofSize: 10)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: title, attributes: attributes)
        titleString.draw(at: point)
        
        // Black underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 13))
        context?.addLine(to: CGPoint(x: point.x + 70, y: point.y + 13))
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawAttributeWithDots(_ name: String, value: Int, at point: CGPoint, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 9)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        // Draw attribute/skill name
        let nameString = NSAttributedString(string: name, attributes: attributes)
        nameString.draw(at: point)
        
        // Draw dots (5 dots total)
        let dotStartX = point.x + 65
        let dotSize: CGFloat = 6
        let dotSpacing: CGFloat = 9
        
        for i in 0..<5 {
            let dotX = dotStartX + CGFloat(i) * dotSpacing
            let dotCenter = CGPoint(x: dotX + dotSize/2, y: point.y + dotSize/2 + 1)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            
            let dotRect = CGRect(x: dotX, y: point.y + 1, width: dotSize, height: dotSize)
            context?.strokeEllipse(in: dotRect)
            
            // Fill dots up to the character's value
            if i < value {
                context?.setFillColor(UIColor.black.cgColor)
                context?.fillEllipse(in: dotRect)
            }
        }
        
        return 13
    }
    
    @discardableResult
    private static func drawHealthWillpowerBoxes(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 2 * margin - 20) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + 20
        
        // Health boxes (always blank)
        drawTrackerBoxes("HEALTH", maxValue: character.health, at: CGPoint(x: leftColumn, y: startY), width: columnWidth, alwaysBlank: true)
        
        // Willpower boxes (always blank)  
        drawTrackerBoxes("WILLPOWER", maxValue: character.willpower, at: CGPoint(x: rightColumn, y: startY), width: columnWidth, alwaysBlank: true)
        
        return 60
    }
    
    private static func drawTrackerBoxes(_ label: String, maxValue: Int, at point: CGPoint, width: CGFloat, alwaysBlank: Bool = true) {
        // Section title
        let font = UIFont.boldSystemFont(ofSize: 11)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemRed
        ]
        let labelString = NSAttributedString(string: label, attributes: attributes)
        labelString.draw(at: point)
        
        // Red underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(1.5)
        context?.move(to: CGPoint(x: point.x, y: point.y + 14))
        context?.addLine(to: CGPoint(x: point.x + 70, y: point.y + 14))
        context?.strokePath()
        
        // Draw boxes (always empty as requested)
        let boxSize: CGFloat = 11
        let boxSpacing: CGFloat = 13
        let startX = point.x
        let startY = point.y + 18
        
        for i in 0..<maxValue {
            let boxX = startX + CGFloat(i % 10) * boxSpacing
            let boxY = startY + CGFloat(i / 10) * (boxSize + 3)
            let boxRect = CGRect(x: boxX, y: boxY, width: boxSize, height: boxSize)
            
            // Always draw empty boxes for printing
            context?.setFillColor(UIColor.white.cgColor)
            context?.fill(boxRect)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            context?.stroke(boxRect)
        }
    }
    
    @discardableResult
    private static func drawVampireTraitsGrid(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 30) / 4
        
        // First row of vampire traits
        drawFormField(label: "HUNGER", value: "\(vampire.hunger)",
                     at: CGPoint(x: margin, y: startY), 
                     width: fieldWidth - 10)
        
        drawFormField(label: "HUMANITY", value: "\(vampire.humanity)",
                     at: CGPoint(x: margin + fieldWidth, y: startY), 
                     width: fieldWidth - 10)
        
        drawFormField(label: "BLOOD POTENCY", value: "\(vampire.bloodPotency)",
                     at: CGPoint(x: margin + 2 * fieldWidth, y: startY), 
                     width: fieldWidth)
        
        drawFormField(label: "BLOOD SURGE", value: "",
                     at: CGPoint(x: margin + 3 * fieldWidth + 10, y: startY), 
                     width: fieldWidth)
        
        // Second row
        let secondRowY = startY + 40
        
        drawFormField(label: "POWER BONUS", value: "",
                     at: CGPoint(x: margin, y: secondRowY), 
                     width: fieldWidth)
        
        drawFormField(label: "MEND AMOUNT", value: "",
                     at: CGPoint(x: margin + fieldWidth + 10, y: secondRowY), 
                     width: fieldWidth)
        
        drawFormField(label: "ROUSE RE-ROLL", value: "",
                     at: CGPoint(x: margin + 2 * fieldWidth + 10, y: secondRowY), 
                     width: fieldWidth + 20)
        
        // Third row - wider fields
        let thirdRowY = startY + 80
        let wideFieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawFormField(label: "FEEDING PENALTY", value: "",
                     at: CGPoint(x: margin, y: thirdRowY), 
                     width: wideFieldWidth)
        
        // Fourth row - clan abilities (full width)
        let fourthRowY = startY + 120
        let fullFieldWidth = pageSize.width - 2 * margin
        
        drawFormField(label: "CLAN BANE", value: "",
                     at: CGPoint(x: margin, y: fourthRowY), 
                     width: fullFieldWidth)
        
        let fifthRowY = startY + 160
        drawFormField(label: "CLAN COMPULSION", value: "",
                     at: CGPoint(x: margin, y: fifthRowY), 
                     width: fullFieldWidth)
        
        return 200
    }
    
    @discardableResult
    private static func drawDisciplinesWithPowers(character: any DisciplineCapable, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        // Section title
        drawSectionTitle("DISCIPLINES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        var currentY = startY + 25
        
        if character.v5Disciplines.isEmpty {
            let font = UIFont.italicSystemFont(ofSize: 10)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.gray
            ]
            let text = NSAttributedString(string: "No disciplines learned", attributes: attributes)
            text.draw(at: CGPoint(x: margin, y: currentY))
            return 50
        }
        
        for discipline in character.v5Disciplines {
            if currentY - startY > maxHeight - 60 { break }
            
            let level = discipline.currentLevel()
            
            // Draw discipline name with dots
            let nameFont = UIFont.boldSystemFont(ofSize: 10)
            let nameAttributes: [NSAttributedString.Key: Any] = [
                .font: nameFont,
                .foregroundColor: UIColor.systemRed
            ]
            let nameString = NSAttributedString(string: discipline.name.uppercased(), attributes: nameAttributes)
            nameString.draw(at: CGPoint(x: margin, y: currentY))
            
            // Draw dots for discipline level
            let dotStartX = margin + 100
            let dotSize: CGFloat = 7
            let dotSpacing: CGFloat = 10
            
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
            
            currentY += 16
            
            // List selected powers
            let selectedPowers = discipline.getAllSelectedPowerNames()
            if !selectedPowers.isEmpty && currentY - startY < maxHeight - 30 {
                let powersText = Array(selectedPowers).joined(separator: ", ")
                let powerFont = UIFont.systemFont(ofSize: 8)
                let powerAttributes: [NSAttributedString.Key: Any] = [
                    .font: powerFont,
                    .foregroundColor: UIColor.darkGray
                ]
                let powerString = NSAttributedString(string: powersText, attributes: powerAttributes)
                let textRect = CGRect(x: margin + 10, y: currentY, width: pageSize.width - 2 * margin - 20, height: 20)
                powerString.draw(in: textRect)
                currentY += 14
            }
            
            currentY += 8
        }
        
        return currentY - startY
    }
    
    @discardableResult
    private static func drawMeritsFlawsAndExperience(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        var currentY = startY
        
        // Merits & Flaws section header
        drawSectionTitle("MERITS & FLAWS", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 25
        
        let columnWidth = (pageSize.width - 2 * margin - 20) / 2
        let meritsColumn = margin
        let flawsColumn = margin + columnWidth + 20
        
        // Column headers
        let headerFont = UIFont.boldSystemFont(ofSize: 10)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: headerFont,
            .foregroundColor: UIColor.black
        ]
        let meritsHeader = NSAttributedString(string: "MERITS", attributes: headerAttributes)
        meritsHeader.draw(at: CGPoint(x: meritsColumn, y: currentY))
        
        let flawsHeader = NSAttributedString(string: "FLAWS", attributes: headerAttributes)
        flawsHeader.draw(at: CGPoint(x: flawsColumn, y: currentY))
        
        currentY += 18
        let startListY = currentY
        
        // Draw merits
        currentY = startListY
        for merit in character.advantages {
            if currentY - startY > maxHeight - 60 { break }
            let font = UIFont.systemFont(ofSize: 8)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(merit.name) (\(merit.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: meritsColumn, y: currentY))
            currentY += 11
        }
        
        // Draw background merits
        for backgroundMerit in character.backgroundMerits where backgroundMerit.type == .merit {
            if currentY - startY > maxHeight - 60 { break }
            let font = UIFont.systemFont(ofSize: 8)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(backgroundMerit.name) (\(backgroundMerit.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: meritsColumn, y: currentY))
            currentY += 11
        }
        
        // Draw flaws
        var flawsY = startListY
        for flaw in character.flaws {
            if flawsY - startY > maxHeight - 60 { break }
            let font = UIFont.systemFont(ofSize: 8)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(flaw.name) (\(flaw.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: flawsColumn, y: flawsY))
            flawsY += 11
        }
        
        // Draw background flaws
        for backgroundFlaw in character.backgroundFlaws where backgroundFlaw.type == .flaw {
            if flawsY - startY > maxHeight - 60 { break }
            let font = UIFont.systemFont(ofSize: 8)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(backgroundFlaw.name) (\(backgroundFlaw.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: flawsColumn, y: flawsY))
            flawsY += 11
        }
        
        // Experience section
        let experienceY = max(currentY, flawsY) + 20
        if experienceY - startY < maxHeight - 40 {
            let expFieldWidth = (pageSize.width - 2 * margin - 10) / 2
            
            drawFormField(label: "TOTAL EXPERIENCE", value: "\(character.experience)",
                         at: CGPoint(x: margin, y: experienceY), 
                         width: expFieldWidth)
            
            drawFormField(label: "SPENT EXPERIENCE", value: "\(character.spentExperience)",
                         at: CGPoint(x: margin + expFieldWidth + 10, y: experienceY), 
                         width: expFieldWidth)
            
            return experienceY - startY + 40
        }
        
        return max(currentY, flawsY) - startY
    }
    
    @discardableResult
    private static func drawNotesAndBiography(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        var currentY = startY
        
        // Notes section
        drawSectionTitle("NOTES", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 25
        
        if !character.notes.isEmpty {
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            let notesText = character.notes
            let textString = NSAttributedString(string: notesText, attributes: attributes)
            let availableHeight = pageSize.height - currentY - 40
            let textRect = CGRect(x: margin, y: currentY, width: pageSize.width - 2 * margin, height: availableHeight)
            textString.draw(in: textRect)
        }
        
        return 60
    }
}