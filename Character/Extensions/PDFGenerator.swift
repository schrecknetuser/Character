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
            
            // Use clean custom layout that matches VtM5e template style
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
        let margin: CGFloat = 40
        
        // Draw professional border matching VtM style
        drawOfficialVtMBorder(pageSize: pageSize, margin: margin)
        
        var currentY: CGFloat = margin + 15
        
        // Header with VTM logo and title
        currentY += drawOfficialVtMHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 25
        
        // Character identity section
        currentY += drawOfficialCharacterInfo(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes section with proper form styling
        currentY += drawOfficialAttributesSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Skills section with proper form styling
        currentY += drawOfficialSkillsSection(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Check if we need a second page
        if currentY > pageSize.height - 350 {
            context.beginPage()
            currentY = margin + 15
            drawOfficialVtMBorder(pageSize: pageSize, margin: margin)
            currentY += 30
        }
        
        // Health and Willpower (always blank for printing)
        currentY += drawOfficialHealthWillpower(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Vampire-specific traits
        currentY += drawOfficialVampireTraits(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Disciplines section
        currentY += drawOfficialDisciplines(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: min(200, pageSize.height - currentY - 100))
        
        // Check if we need a third page for remaining content
        if currentY > pageSize.height - 150 {
            context.beginPage()
            currentY = margin + 15
            drawOfficialVtMBorder(pageSize: pageSize, margin: margin)
            currentY += 30
        }
        
        // Merits, Flaws, and Experience
        currentY += drawOfficialMeritsFlaws(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 80)
    }
    
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        
        // Draw VTM-style border
        drawOfficialVtMBorder(pageSize: pageSize, margin: margin)
        
        var currentY: CGFloat = margin + 15
        
        // Header for ghoul
        currentY += drawGhoulHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 25
        
        // Character identity
        currentY += drawOfficialCharacterInfo(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes and Skills
        currentY += drawOfficialAttributesSection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        currentY += drawOfficialSkillsSection(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Health and Willpower (blank)
        currentY += drawOfficialHealthWillpower(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Ghoul humanity and disciplines if space allows
        if currentY < pageSize.height - 150 {
            currentY += drawGhoulTraits(ghoul: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
            currentY += 20
            currentY += drawOfficialDisciplines(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 50)
        }
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        
        // Draw border
        drawOfficialVtMBorder(pageSize: pageSize, margin: margin)
        
        var currentY: CGFloat = margin + 15
        
        // Header for mage
        currentY += drawMageHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 25
        
        // Character identity
        currentY += drawOfficialCharacterInfo(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Basic mage details
        currentY += drawMageDetailsRow(mage: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Attributes and Skills
        currentY += drawOfficialAttributesSection(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 25
        
        // Note about implementation
        let font = UIFont.italicSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        let noteText = "Full Mage character sheet implementation coming soon"
        let noteString = NSAttributedString(string: noteText, attributes: attributes)
        noteString.draw(at: CGPoint(x: margin + 15, y: currentY))
    }
    
    // Helper methods for ghoul and mage headers
    @discardableResult
    private static func drawGhoulHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "VAMPIRE: THE MASQUERADE", attributes: titleAttributes)
        titleString.draw(at: point)
        
        let subtitleY = point.y + 28
        let subtitleFont = UIFont.boldSystemFont(ofSize: 14)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemRed,
            .kern: 2.0
        ]
        let subtitleString = NSAttributedString(string: "GHOUL CHARACTER SHEET", attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: point.x, y: subtitleY))
        
        return 50
    }
    
    @discardableResult
    private static func drawMageHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "MAGE: THE AWAKENING", attributes: titleAttributes)
        titleString.draw(at: point)
        
        let subtitleY = point.y + 28
        let subtitleFont = UIFont.boldSystemFont(ofSize: 14)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemBlue,
            .kern: 2.0
        ]
        let subtitleString = NSAttributedString(string: "CHARACTER SHEET", attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: point.x, y: subtitleY))
        
        return 50
    }
    
    @discardableResult
    private static func drawMageDetailsRow(mage: MageCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 2
        
        drawOfficialFormField(label: "CONCEPT", value: mage.concept,
                            at: CGPoint(x: margin + 15, y: startY), 
                            width: fieldWidth)
        
        drawOfficialFormField(label: "PATH", value: "",
                            at: CGPoint(x: margin + fieldWidth + 25, y: startY), 
                            width: fieldWidth)
        
        return 45
    }
    
    @discardableResult
    private static func drawGhoulTraits(ghoul: GhoulCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 30) / 2
        
        drawOfficialFormField(label: "BLOOD BOND", value: "",
                            at: CGPoint(x: margin + 15, y: startY), 
                            width: fieldWidth)
        
        drawOfficialFormField(label: "DOMITOR INFLUENCE", value: "",
                            at: CGPoint(x: margin + fieldWidth + 25, y: startY), 
                            width: fieldWidth)
        
        return 45
    }
    
    
    // MARK: - Official VtM5e Template Style Methods
    
    @discardableResult
    private static func drawOfficialVtMBorder(pageSize: CGSize, margin: CGFloat) -> CGFloat {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw main border frame - thick red border like official template
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(3.0)
        let borderRect = CGRect(x: margin, y: margin, width: pageSize.width - 2 * margin, height: pageSize.height - 2 * margin)
        context?.stroke(borderRect)
        
        // Inner decorative frame
        context?.setLineWidth(1.0)
        let innerMargin = margin + 10
        let innerRect = CGRect(x: innerMargin, y: innerMargin, width: pageSize.width - 2 * innerMargin, height: pageSize.height - 2 * innerMargin)
        context?.stroke(innerRect)
        
        // Add corner ornaments similar to official template
        drawOfficialCornerOrnaments(pageSize: pageSize, margin: margin)
        
        return 0
    }
    
    private static func drawOfficialCornerOrnaments(pageSize: CGSize, margin: CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        
        let ornamentSize: CGFloat = 12
        let offset: CGFloat = 20
        
        // Top-left corner ornament
        let tlX = margin + offset
        let tlY = margin + offset
        context?.move(to: CGPoint(x: tlX - ornamentSize/2, y: tlY))
        context?.addLine(to: CGPoint(x: tlX + ornamentSize/2, y: tlY))
        context?.move(to: CGPoint(x: tlX, y: tlY - ornamentSize/2))
        context?.addLine(to: CGPoint(x: tlX, y: tlY + ornamentSize/2))
        
        // Top-right corner ornament
        let trX = pageSize.width - margin - offset
        let trY = margin + offset
        context?.move(to: CGPoint(x: trX - ornamentSize/2, y: trY))
        context?.addLine(to: CGPoint(x: trX + ornamentSize/2, y: trY))
        context?.move(to: CGPoint(x: trX, y: trY - ornamentSize/2))
        context?.addLine(to: CGPoint(x: trX, y: trY + ornamentSize/2))
        
        // Bottom corners
        let blX = margin + offset
        let blY = pageSize.height - margin - offset
        context?.move(to: CGPoint(x: blX - ornamentSize/2, y: blY))
        context?.addLine(to: CGPoint(x: blX + ornamentSize/2, y: blY))
        context?.move(to: CGPoint(x: blX, y: blY - ornamentSize/2))
        context?.addLine(to: CGPoint(x: blX, y: blY + ornamentSize/2))
        
        let brX = pageSize.width - margin - offset
        let brY = pageSize.height - margin - offset
        context?.move(to: CGPoint(x: brX - ornamentSize/2, y: brY))
        context?.addLine(to: CGPoint(x: brX + ornamentSize/2, y: brY))
        context?.move(to: CGPoint(x: brX, y: brY - ornamentSize/2))
        context?.addLine(to: CGPoint(x: brX, y: brY + ornamentSize/2))
        
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawOfficialVtMHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let context = UIGraphicsGetCurrentContext()
        
        // VTM Ankh logo on the right
        let logoSize: CGFloat = 40
        let logoX = pageSize.width - 100
        let logoY = point.y + 5
        
        // Red circle background for logo
        context?.setFillColor(UIColor.systemRed.cgColor)
        context?.fillEllipse(in: CGRect(x: logoX, y: logoY, width: logoSize, height: logoSize))
        
        // White ankh symbol
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(3.0)
        let centerX = logoX + logoSize/2
        let centerY = logoY + logoSize/2
        
        // Ankh vertical line
        context?.move(to: CGPoint(x: centerX, y: logoY + 8))
        context?.addLine(to: CGPoint(x: centerX, y: logoY + logoSize - 8))
        
        // Ankh horizontal line
        context?.move(to: CGPoint(x: logoX + 10, y: centerY + 3))
        context?.addLine(to: CGPoint(x: logoX + logoSize - 10, y: centerY + 3))
        
        // Ankh top loop
        context?.strokeEllipse(in: CGRect(x: centerX - 6, y: logoY + 8, width: 12, height: 12))
        context?.strokePath()
        
        // Main title
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "VAMPIRE: THE MASQUERADE", attributes: titleAttributes)
        titleString.draw(at: point)
        
        // Subtitle
        let subtitleY = point.y + 28
        let subtitleFont = UIFont.boldSystemFont(ofSize: 14)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.systemRed,
            .kern: 2.0
        ]
        let subtitleString = NSAttributedString(string: "CHARACTER SHEET", attributes: subtitleAttributes)
        subtitleString.draw(at: CGPoint(x: point.x, y: subtitleY))
        
        // Decorative line under title
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.0)
        let lineY = subtitleY + 18
        context?.move(to: CGPoint(x: point.x, y: lineY))
        context?.addLine(to: CGPoint(x: pageSize.width - 120, y: lineY))
        context?.strokePath()
        
        return 60
    }
    
    @discardableResult
    private static func drawOfficialCharacterInfo(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        var currentY = startY
        
        // First row: Name, Player, Chronicle
        drawOfficialFormField(label: "NAME", value: character.name, 
                            at: CGPoint(x: margin, y: currentY), 
                            width: fieldWidth, valueStyle: .bold)
        
        drawOfficialFormField(label: "PLAYER", value: "", 
                            at: CGPoint(x: margin + fieldWidth + 10, y: currentY), 
                            width: fieldWidth)
        
        drawOfficialFormField(label: "CHRONICLE", value: character.chronicleName, 
                            at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: currentY), 
                            width: fieldWidth)
        
        currentY += 45
        
        // Vampire-specific fields if applicable
        if let vampire = character as? VampireCharacter {
            // Second row: Concept, Clan, Generation, Predator
            let smallFieldWidth = (pageSize.width - 2 * margin - 30) / 4
            
            drawOfficialFormField(label: "CONCEPT", value: vampire.concept,
                                at: CGPoint(x: margin, y: currentY), 
                                width: smallFieldWidth)
            
            drawOfficialFormField(label: "CLAN", value: vampire.clan,
                                at: CGPoint(x: margin + smallFieldWidth + 10, y: currentY), 
                                width: smallFieldWidth)
            
            drawOfficialFormField(label: "GENERATION", value: "\(vampire.generation)",
                                at: CGPoint(x: margin + 2 * (smallFieldWidth + 10), y: currentY), 
                                width: smallFieldWidth)
            
            drawOfficialFormField(label: "PREDATOR", value: vampire.predatorType,
                                at: CGPoint(x: margin + 3 * (smallFieldWidth + 10), y: currentY), 
                                width: smallFieldWidth)
            
            currentY += 45
            
            // Third row: Sire, Ambition (wide fields)
            let wideFieldWidth = (pageSize.width - 2 * margin - 10) / 2
            
            drawOfficialFormField(label: "SIRE", value: vampire.sire,
                                at: CGPoint(x: margin, y: currentY), 
                                width: wideFieldWidth)
            
            drawOfficialFormField(label: "AMBITION", value: vampire.ambition,
                                at: CGPoint(x: margin + wideFieldWidth + 10, y: currentY), 
                                width: wideFieldWidth)
            
            currentY += 45
        }
        
        return currentY - startY
    }
    
    private static func drawOfficialFormField(label: String, value: String, at point: CGPoint, width: CGFloat, valueStyle: FormFieldStyle = .normal) {
        // Draw label
        let labelFont = UIFont.boldSystemFont(ofSize: 9)
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black,
            .kern: 1.0
        ]
        let labelString = NSAttributedString(string: label.uppercased(), attributes: labelAttributes)
        labelString.draw(at: point)
        
        // Draw field box with border
        let context = UIGraphicsGetCurrentContext()
        let fieldHeight: CGFloat = 24
        let fieldY = point.y + 14
        let fieldRect = CGRect(x: point.x, y: fieldY, width: width, height: fieldHeight)
        
        // Field background
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(fieldRect)
        
        // Field border
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(0.8)
        context?.stroke(fieldRect)
        
        // Draw value if present
        if !value.isEmpty {
            let valueFont = valueStyle == .bold ? UIFont.boldSystemFont(ofSize: 11) : UIFont.systemFont(ofSize: 11)
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: valueFont,
                .foregroundColor: UIColor.black
            ]
            let valueString = NSAttributedString(string: value, attributes: valueAttributes)
            let textRect = CGRect(x: point.x + 4, y: fieldY + 4, width: width - 8, height: fieldHeight - 8)
            valueString.draw(in: textRect)
        }
    }
    
    enum FormFieldStyle {
        case normal
        case bold
    }
    
    @discardableResult
    private static func drawOfficialAttributesSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // Section title with official styling
        drawOfficialSectionHeader("ATTRIBUTES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let attributesStartY = startY + 30
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin + 15
        let socialX = margin + columnWidth + 35
        let mentalX = margin + 2 * columnWidth + 55
        
        var maxHeight: CGFloat = 0
        
        // Physical Attributes Column
        var currentY = attributesStartY
        drawOfficialColumnHeader("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawOfficialAttributeRow(attribute, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth - 30)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Social Attributes Column
        currentY = attributesStartY
        drawOfficialColumnHeader("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawOfficialAttributeRow(attribute, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth - 30)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Mental Attributes Column
        currentY = attributesStartY
        drawOfficialColumnHeader("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawOfficialAttributeRow(attribute, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth - 30)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        return maxHeight + 30
    }
    
    @discardableResult
    private static func drawOfficialSkillsSection(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        // Section title with official styling
        drawOfficialSectionHeader("SKILLS", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let skillsStartY = startY + 30
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin + 15
        let socialX = margin + columnWidth + 35
        let mentalX = margin + 2 * columnWidth + 55
        
        var maxHeight: CGFloat = 0
        
        // Physical Skills Column
        var currentY = skillsStartY
        drawOfficialColumnHeader("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawOfficialAttributeRow(skill, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth - 30)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Social Skills Column
        currentY = skillsStartY
        drawOfficialColumnHeader("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawOfficialAttributeRow(skill, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth - 30)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Mental Skills Column
        currentY = skillsStartY
        drawOfficialColumnHeader("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawOfficialAttributeRow(skill, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth - 30)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        return maxHeight + 30
    }
    
    private static func drawOfficialSectionHeader(_ title: String, at point: CGPoint, pageSize: CGSize) {
        let font = UIFont.boldSystemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.systemRed,
            .kern: 1.5
        ]
        let titleString = NSAttributedString(string: title, attributes: attributes)
        titleString.draw(at: point)
        
        // Red decorative line under title
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(2.5)
        context?.move(to: CGPoint(x: point.x, y: point.y + 20))
        context?.addLine(to: CGPoint(x: point.x + 150, y: point.y + 20))
        context?.strokePath()
    }
    
    private static func drawOfficialColumnHeader(_ title: String, at point: CGPoint) {
        let font = UIFont.boldSystemFont(ofSize: 11)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
            .kern: 1.0
        ]
        let titleString = NSAttributedString(string: title, attributes: attributes)
        titleString.draw(at: point)
        
        // Black underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 15))
        context?.addLine(to: CGPoint(x: point.x + 80, y: point.y + 15))
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawOfficialAttributeRow(_ name: String, value: Int, at point: CGPoint, width: CGFloat) -> CGFloat {
        // Draw attribute/skill name
        let nameFont = UIFont.systemFont(ofSize: 10)
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: nameFont,
            .foregroundColor: UIColor.black
        ]
        let nameString = NSAttributedString(string: name, attributes: nameAttributes)
        nameString.draw(at: point)
        
        // Draw professional dot notation (circles)
        let dotStartX = point.x + 90
        let dotSize: CGFloat = 8
        let dotSpacing: CGFloat = 12
        
        for i in 0..<5 {
            let dotX = dotStartX + CGFloat(i) * dotSpacing
            let dotY = point.y + 1
            let dotRect = CGRect(x: dotX, y: dotY, width: dotSize, height: dotSize)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.2)
            
            // Draw circle outline
            context?.strokeEllipse(in: dotRect)
            
            // Fill circles up to the character's value
            if i < value {
                context?.setFillColor(UIColor.black.cgColor)
                context?.fillEllipse(in: dotRect)
            }
        }
        
        return 16
    }
    
    @discardableResult
    private static func drawOfficialHealthWillpower(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 2 * margin - 20) / 2
        let leftColumn = margin + 15
        let rightColumn = margin + columnWidth + 35
        
        // Health section (always blank for printing)
        drawOfficialTrackerSection("HEALTH", maxValue: character.health, at: CGPoint(x: leftColumn, y: startY), width: columnWidth - 30)
        
        // Willpower section (always blank for printing)
        drawOfficialTrackerSection("WILLPOWER", maxValue: character.willpower, at: CGPoint(x: rightColumn, y: startY), width: columnWidth - 30)
        
        return 80
    }
    
    private static func drawOfficialTrackerSection(_ label: String, maxValue: Int, at point: CGPoint, width: CGFloat) {
        // Section header
        let headerFont = UIFont.boldSystemFont(ofSize: 12)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: headerFont,
            .foregroundColor: UIColor.systemRed,
            .kern: 1.0
        ]
        let headerString = NSAttributedString(string: label, attributes: headerAttributes)
        headerString.draw(at: point)
        
        // Red underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemRed.cgColor)
        context?.setLineWidth(1.5)
        context?.move(to: CGPoint(x: point.x, y: point.y + 16))
        context?.addLine(to: CGPoint(x: point.x + 80, y: point.y + 16))
        context?.strokePath()
        
        // Draw empty boxes for manual tracking (always blank as requested)
        let boxSize: CGFloat = 12
        let boxSpacing: CGFloat = 15
        let startX = point.x
        let startY = point.y + 22
        
        for i in 0..<maxValue {
            let boxX = startX + CGFloat(i % 8) * boxSpacing  // 8 boxes per row
            let boxY = startY + CGFloat(i / 8) * (boxSize + 4)
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
    private static func drawOfficialVampireTraits(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        drawOfficialSectionHeader("VAMPIRE TRAITS", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        let traitsStartY = startY + 30
        let fieldWidth = (pageSize.width - 2 * margin - 40) / 4
        
        // First row of vampire traits
        drawOfficialFormField(label: "HUNGER", value: "\(vampire.hunger)",
                            at: CGPoint(x: margin + 15, y: traitsStartY), 
                            width: fieldWidth - 10)
        
        drawOfficialFormField(label: "HUMANITY", value: "\(vampire.humanity)",
                            at: CGPoint(x: margin + fieldWidth + 15, y: traitsStartY), 
                            width: fieldWidth - 10)
        
        drawOfficialFormField(label: "BLOOD POTENCY", value: "\(vampire.bloodPotency)",
                            at: CGPoint(x: margin + 2 * fieldWidth + 15, y: traitsStartY), 
                            width: fieldWidth)
        
        drawOfficialFormField(label: "BLOOD SURGE", value: "",
                            at: CGPoint(x: margin + 3 * fieldWidth + 15, y: traitsStartY), 
                            width: fieldWidth)
        
        // Second row
        let secondRowY = traitsStartY + 45
        
        drawOfficialFormField(label: "POWER BONUS", value: "",
                            at: CGPoint(x: margin + 15, y: secondRowY), 
                            width: fieldWidth)
        
        drawOfficialFormField(label: "MEND AMOUNT", value: "",
                            at: CGPoint(x: margin + fieldWidth + 15, y: secondRowY), 
                            width: fieldWidth)
        
        drawOfficialFormField(label: "ROUSE RE-ROLL", value: "",
                            at: CGPoint(x: margin + 2 * fieldWidth + 15, y: secondRowY), 
                            width: fieldWidth + 20)
        
        // Third row - wider fields
        let thirdRowY = traitsStartY + 90
        let wideFieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawOfficialFormField(label: "FEEDING PENALTY", value: "",
                            at: CGPoint(x: margin + 15, y: thirdRowY), 
                            width: wideFieldWidth)
        
        // Fourth and fifth rows - full width clan abilities
        let fourthRowY = traitsStartY + 135
        let fullFieldWidth = pageSize.width - 2 * margin - 30
        
        drawOfficialFormField(label: "CLAN BANE", value: "",
                            at: CGPoint(x: margin + 15, y: fourthRowY), 
                            width: fullFieldWidth)
        
        let fifthRowY = traitsStartY + 180
        drawOfficialFormField(label: "CLAN COMPULSION", value: "",
                            at: CGPoint(x: margin + 15, y: fifthRowY), 
                            width: fullFieldWidth)
        
        return 225
    }
    
    @discardableResult
    private static func drawOfficialDisciplines(character: any DisciplineCapable, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        drawOfficialSectionHeader("DISCIPLINES", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        
        var currentY = startY + 30
        
        if character.v5Disciplines.isEmpty {
            let font = UIFont.italicSystemFont(ofSize: 11)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.gray
            ]
            let text = NSAttributedString(string: "No disciplines learned", attributes: attributes)
            text.draw(at: CGPoint(x: margin + 15, y: currentY))
            return 60
        }
        
        for discipline in character.v5Disciplines {
            if currentY - startY > maxHeight - 80 { break }
            
            let level = discipline.currentLevel()
            
            // Draw discipline name with professional styling
            let nameFont = UIFont.boldSystemFont(ofSize: 12)
            let nameAttributes: [NSAttributedString.Key: Any] = [
                .font: nameFont,
                .foregroundColor: UIColor.systemRed,
                .kern: 1.0
            ]
            let nameString = NSAttributedString(string: discipline.name.uppercased(), attributes: nameAttributes)
            nameString.draw(at: CGPoint(x: margin + 15, y: currentY))
            
            // Draw dots for discipline level
            let dotStartX = margin + 150
            let dotSize: CGFloat = 8
            let dotSpacing: CGFloat = 12
            
            for i in 0..<5 {
                let dotX = dotStartX + CGFloat(i) * dotSpacing
                let dotRect = CGRect(x: dotX, y: currentY + 2, width: dotSize, height: dotSize)
                
                let context = UIGraphicsGetCurrentContext()
                context?.setStrokeColor(UIColor.black.cgColor)
                context?.setLineWidth(1.2)
                context?.strokeEllipse(in: dotRect)
                
                if i < level {
                    context?.setFillColor(UIColor.black.cgColor)
                    context?.fillEllipse(in: dotRect)
                }
            }
            
            currentY += 18
            
            // List selected powers in a clean format
            let selectedPowers = discipline.getAllSelectedPowerNames()
            if !selectedPowers.isEmpty && currentY - startY < maxHeight - 40 {
                let powersText = Array(selectedPowers).joined(separator: ", ")
                let powerFont = UIFont.systemFont(ofSize: 9)
                let powerAttributes: [NSAttributedString.Key: Any] = [
                    .font: powerFont,
                    .foregroundColor: UIColor.darkGray
                ]
                let powerString = NSAttributedString(string: powersText, attributes: powerAttributes)
                let textRect = CGRect(x: margin + 25, y: currentY, width: pageSize.width - 2 * margin - 50, height: 25)
                powerString.draw(in: textRect)
                currentY += 18
            }
            
            currentY += 10
        }
        
        return currentY - startY
    }
    
    @discardableResult
    private static func drawOfficialMeritsFlaws(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        var currentY = startY
        
        // Merits & Flaws section header
        drawOfficialSectionHeader("MERITS & FLAWS", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 30
        
        let columnWidth = (pageSize.width - 2 * margin - 40) / 2
        let meritsColumn = margin + 15
        let flawsColumn = margin + columnWidth + 35
        
        // Column headers
        let headerFont = UIFont.boldSystemFont(ofSize: 11)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: headerFont,
            .foregroundColor: UIColor.black,
            .kern: 1.0
        ]
        let meritsHeader = NSAttributedString(string: "MERITS", attributes: headerAttributes)
        meritsHeader.draw(at: CGPoint(x: meritsColumn, y: currentY))
        
        let flawsHeader = NSAttributedString(string: "FLAWS", attributes: headerAttributes)
        flawsHeader.draw(at: CGPoint(x: flawsColumn, y: currentY))
        
        currentY += 20
        let startListY = currentY
        
        // Draw merits
        currentY = startListY
        for merit in character.advantages {
            if currentY - startY > maxHeight - 80 { break }
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
            if currentY - startY > maxHeight - 80 { break }
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
        var flawsY = startListY
        for flaw in character.flaws {
            if flawsY - startY > maxHeight - 80 { break }
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(flaw.name) (\(flaw.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: flawsColumn, y: flawsY))
            flawsY += 12
        }
        
        // Draw background flaws
        for backgroundFlaw in character.backgroundFlaws where backgroundFlaw.type == .flaw {
            if flawsY - startY > maxHeight - 80 { break }
            let font = UIFont.systemFont(ofSize: 9)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            let text = "\(backgroundFlaw.name) (\(backgroundFlaw.cost))"
            let textString = NSAttributedString(string: text, attributes: attributes)
            textString.draw(at: CGPoint(x: flawsColumn, y: flawsY))
            flawsY += 12
        }
        
        // Experience section
        let experienceY = max(currentY, flawsY) + 25
        if experienceY - startY < maxHeight - 50 {
            let expFieldWidth = (pageSize.width - 2 * margin - 30) / 2
            
            drawOfficialFormField(label: "TOTAL EXPERIENCE", value: "\(character.experience)",
                                at: CGPoint(x: margin + 15, y: experienceY), 
                                width: expFieldWidth)
            
            drawOfficialFormField(label: "SPENT EXPERIENCE", value: "\(character.spentExperience)",
                                at: CGPoint(x: margin + expFieldWidth + 25, y: experienceY), 
                                width: expFieldWidth)
            
            return experienceY - startY + 45
        }
        
        return max(currentY, flawsY) - startY
    }
}