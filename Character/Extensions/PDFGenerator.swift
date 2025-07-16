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
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        // Draw VtM5e style header with logo space
        currentY += drawVtMHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 20
        
        // Character Name and Player section (large prominent fields)
        currentY += drawCharacterIdentitySection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Chronicle, Concept, Clan, Generation row
        currentY += drawCharacterDetailsSection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Predator Type, Sire, Ambition row
        currentY += drawCharacterBackgroundSection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes section with proper VtM5e styling
        currentY += drawOfficialStyleAttributes(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Skills section with proper VtM5e styling  
        currentY += drawOfficialStyleSkills(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Health and Willpower (always blank boxes)
        currentY += drawBlankHealthWillpower(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Vampire-specific traits
        currentY += drawVampireTraitsSection(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Disciplines section
        if currentY < pageSize.height - 150 {
            currentY += drawOfficialStyleDisciplines(character: vampire, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 50)
        }
    }
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        // Draw VtM5e style header with logo space
        currentY += drawVtMHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize, subtitle: "GHOUL CHARACTER SHEET")
        currentY += 20
        
        // Character Name and Player section
        currentY += drawCharacterIdentitySection(vampire: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Chronicle, Concept, Humanity row (adapted for ghouls)
        currentY += drawGhoulDetailsSection(ghoul: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes section
        currentY += drawOfficialStyleAttributes(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Skills section
        currentY += drawOfficialStyleSkills(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Health and Willpower (always blank)
        currentY += drawBlankHealthWillpower(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Disciplines section
        if currentY < pageSize.height - 150 {
            currentY += drawOfficialStyleDisciplines(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize, maxHeight: pageSize.height - currentY - 50)
        }
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        // Draw Mage header
        currentY += drawMageHeader(at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 20
        
        // Character Name and Player section
        currentY += drawCharacterIdentitySection(vampire: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 15
        
        // Chronicle, Concept row (basic for mages)
        currentY += drawMageDetailsSection(mage: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Attributes section
        currentY += drawOfficialStyleAttributes(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 50
        
        // Note about full implementation
        drawOfficialNote("Full Mage implementation coming soon", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
    }
    
    // MARK: - Official VtM5e Style Drawing Methods
    
    @discardableResult
    private static func drawVtMHeader(at point: CGPoint, pageSize: CGSize, subtitle: String = "CHARACTER SHEET") -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let subtitleFont = UIFont.boldSystemFont(ofSize: 14)
        
        // Draw main title
        let titleText = "VAMPIRE: THE MASQUERADE"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: titleText, attributes: titleAttributes)
        let titleSize = titleString.size()
        let titleRect = CGRect(x: (pageSize.width - titleSize.width) / 2, y: point.y, width: titleSize.width, height: titleSize.height)
        titleString.draw(in: titleRect)
        
        // Draw subtitle
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.black
        ]
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        let subtitleSize = subtitleString.size()
        let subtitleRect = CGRect(x: (pageSize.width - subtitleSize.width) / 2, y: point.y + titleSize.height + 5, width: subtitleSize.width, height: subtitleSize.height)
        subtitleString.draw(in: subtitleRect)
        
        // Draw decorative lines
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        
        let lineY = point.y + titleSize.height + subtitleSize.height + 15
        context?.move(to: CGPoint(x: point.x, y: lineY))
        context?.addLine(to: CGPoint(x: pageSize.width - point.x, y: lineY))
        context?.strokePath()
        
        return titleSize.height + subtitleSize.height + 25
    }
    
    @discardableResult
    private static func drawMageHeader(at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let subtitleFont = UIFont.boldSystemFont(ofSize: 14)
        
        // Draw main title
        let titleText = "MAGE: THE AWAKENING"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: titleText, attributes: titleAttributes)
        let titleSize = titleString.size()
        let titleRect = CGRect(x: (pageSize.width - titleSize.width) / 2, y: point.y, width: titleSize.width, height: titleSize.height)
        titleString.draw(in: titleRect)
        
        // Draw subtitle
        let subtitleText = "CHARACTER SHEET"
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont,
            .foregroundColor: UIColor.black
        ]
        let subtitleString = NSAttributedString(string: subtitleText, attributes: subtitleAttributes)
        let subtitleSize = subtitleString.size()
        let subtitleRect = CGRect(x: (pageSize.width - subtitleSize.width) / 2, y: point.y + titleSize.height + 5, width: subtitleSize.width, height: subtitleSize.height)
        subtitleString.draw(in: subtitleRect)
        
        return titleSize.height + subtitleSize.height + 15
    }
    
    @discardableResult
    private static func drawCharacterIdentitySection(vampire: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let nameWidth = (pageSize.width - 2 * margin) * 0.6
        let playerWidth = (pageSize.width - 2 * margin) * 0.35
        
        // Name field (large)
        drawOfficialField("Name", value: vampire.name, 
                         at: CGPoint(x: margin, y: startY), 
                         width: nameWidth, fontSize: 12, valueSize: 14)
        
        // Player field  
        drawOfficialField("Player", value: "", 
                         at: CGPoint(x: margin + nameWidth + 10, y: startY), 
                         width: playerWidth, fontSize: 10, valueSize: 12)
        
        return 35
    }
    
    @discardableResult
    private static func drawCharacterDetailsSection(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        drawOfficialField("Chronicle", value: vampire.chronicleName,
                         at: CGPoint(x: margin, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Concept", value: vampire.concept,
                         at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Clan", value: vampire.clan,
                         at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                         width: fieldWidth)
        
        let secondRowY = startY + 30
        
        drawOfficialField("Generation", value: "\(vampire.generation)",
                         at: CGPoint(x: margin, y: secondRowY), 
                         width: fieldWidth)
        
        drawOfficialField("Sire", value: "",
                         at: CGPoint(x: margin + fieldWidth + 10, y: secondRowY), 
                         width: fieldWidth)
        
        drawOfficialField("Ambition", value: vampire.ambition,
                         at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: secondRowY), 
                         width: fieldWidth)
        
        return 60
    }
    
    @discardableResult
    private static func drawCharacterBackgroundSection(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        drawOfficialField("Predator Type", value: vampire.predatorType,
                         at: CGPoint(x: margin, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Desire", value: vampire.desire,
                         at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Experience", value: "\(vampire.experience)",
                         at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                         width: fieldWidth)
        
        return 30
    }
    
    @discardableResult
    private static func drawGhoulDetailsSection(ghoul: GhoulCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 20) / 3
        
        drawOfficialField("Chronicle", value: ghoul.chronicleName,
                         at: CGPoint(x: margin, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Concept", value: ghoul.concept,
                         at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Humanity", value: "\(ghoul.humanity)",
                         at: CGPoint(x: margin + 2 * (fieldWidth + 10), y: startY), 
                         width: fieldWidth)
        
        return 30
    }
    
    @discardableResult
    private static func drawMageDetailsSection(mage: MageCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 10) / 2
        
        drawOfficialField("Chronicle", value: mage.chronicleName,
                         at: CGPoint(x: margin, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Concept", value: mage.concept,
                         at: CGPoint(x: margin + fieldWidth + 10, y: startY), 
                         width: fieldWidth)
        
        return 30
    }
    
    private static func drawOfficialField(_ label: String, value: String, at point: CGPoint, width: CGFloat, fontSize: CGFloat = 10, valueSize: CGFloat = 10) {
        let labelFont = UIFont.boldSystemFont(ofSize: fontSize)
        let valueFont = UIFont.systemFont(ofSize: valueSize)
        
        // Draw label
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black
        ]
        let labelString = NSAttributedString(string: label.uppercased(), attributes: labelAttributes)
        labelString.draw(at: point)
        
        // Draw underline for the field
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        
        let lineY = point.y + 18
        context?.move(to: CGPoint(x: point.x, y: lineY))
        context?.addLine(to: CGPoint(x: point.x + width, y: lineY))
        context?.strokePath()
        
        // Draw value
        if !value.isEmpty {
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: valueFont,
                .foregroundColor: UIColor.black
            ]
            let valueString = NSAttributedString(string: value, attributes: valueAttributes)
            valueString.draw(at: CGPoint(x: point.x + 5, y: point.y + 20))
        }
    }
    
    @discardableResult
    private static func drawOfficialStyleAttributes(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 14)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        // Draw section title
        let titleString = NSAttributedString(string: "ATTRIBUTES", attributes: headerAttributes)
        titleString.draw(at: CGPoint(x: margin, y: startY))
        
        let attributesStartY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + 20
        let mentalX = margin + 2 * (columnWidth + 20)
        
        var maxHeight: CGFloat = 0
        
        // Physical Attributes
        var currentY = attributesStartY
        drawOfficialAttributeCategory("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawOfficialAttributeLine(attribute, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Social Attributes
        currentY = attributesStartY
        drawOfficialAttributeCategory("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawOfficialAttributeLine(attribute, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        // Mental Attributes
        currentY = attributesStartY
        drawOfficialAttributeCategory("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 20
        
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            currentY += drawOfficialAttributeLine(attribute, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - attributesStartY)
        
        return maxHeight + 25
    }
    
    private static func drawOfficialAttributeCategory(_ text: String, at point: CGPoint) {
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
        context?.addLine(to: CGPoint(x: point.x + 100, y: point.y + 15))
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawOfficialAttributeLine(_ name: String, value: Int, at point: CGPoint, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 10)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        // Draw attribute name
        let nameString = NSAttributedString(string: name, attributes: attributes)
        nameString.draw(at: point)
        
        // Draw dots
        let dotStartX = point.x + 80
        let dotSize: CGFloat = 8
        let dotSpacing: CGFloat = 12
        
        for i in 0..<5 {
            let dotX = dotStartX + CGFloat(i) * dotSpacing
            let dotCenter = CGPoint(x: dotX + dotSize/2, y: point.y + dotSize/2 + 2)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            
            let dotRect = CGRect(x: dotX, y: point.y + 2, width: dotSize, height: dotSize)
            context?.strokeEllipse(in: dotRect)
            
            if i < value {
                context?.setFillColor(UIColor.black.cgColor)
                context?.fillEllipse(in: dotRect)
            }
        }
        
        return 16
    }
    
    @discardableResult
    private static func drawOfficialStyleSkills(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 14)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        // Draw section title
        let titleString = NSAttributedString(string: "SKILLS", attributes: headerAttributes)
        titleString.draw(at: CGPoint(x: margin, y: startY))
        
        let skillsStartY = startY + 25
        let columnWidth = (pageSize.width - 2 * margin - 40) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + 20
        let mentalX = margin + 2 * (columnWidth + 20)
        
        var maxHeight: CGFloat = 0
        
        // Physical Skills
        var currentY = skillsStartY
        drawOfficialAttributeCategory("PHYSICAL", at: CGPoint(x: physicalX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawOfficialAttributeLine(skill, value: value, at: CGPoint(x: physicalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Social Skills
        currentY = skillsStartY
        drawOfficialAttributeCategory("SOCIAL", at: CGPoint(x: socialX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawOfficialAttributeLine(skill, value: value, at: CGPoint(x: socialX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        // Mental Skills
        currentY = skillsStartY
        drawOfficialAttributeCategory("MENTAL", at: CGPoint(x: mentalX, y: currentY))
        currentY += 20
        
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            currentY += drawOfficialAttributeLine(skill, value: value, at: CGPoint(x: mentalX, y: currentY), width: columnWidth)
        }
        maxHeight = max(maxHeight, currentY - skillsStartY)
        
        return maxHeight + 25
    }
    
    @discardableResult
    private static func drawBlankHealthWillpower(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 2 * margin - 20) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + 20
        
        // Health Section (always blank)
        drawOfficialTracker("HEALTH", character.health, at: CGPoint(x: leftColumn, y: startY), width: columnWidth)
        
        // Willpower Section (always blank)
        drawOfficialTracker("WILLPOWER", character.willpower, at: CGPoint(x: rightColumn, y: startY), width: columnWidth)
        
        return 70
    }
    
    private static func drawOfficialTracker(_ label: String, _ maxValue: Int, at point: CGPoint, width: CGFloat) {
        // Draw label
        let font = UIFont.boldSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let labelString = NSAttributedString(string: label, attributes: attributes)
        labelString.draw(at: point)
        
        // Draw tracker boxes (always empty/blank)
        let boxSize: CGFloat = 12
        let boxSpacing: CGFloat = 14
        let startX = point.x
        let startY = point.y + 20
        
        for i in 0..<maxValue {
            let boxX = startX + CGFloat(i % 10) * boxSpacing
            let boxY = startY + CGFloat(i / 10) * (boxSize + 3)
            let boxRect = CGRect(x: boxX, y: boxY, width: boxSize, height: boxSize)
            
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(UIColor.white.cgColor)
            context?.fill(boxRect)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.setLineWidth(1.0)
            context?.stroke(boxRect)
            
            // Always leave boxes empty - don't draw any damage states
        }
    }
    
    @discardableResult
    private static func drawVampireTraitsSection(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let fieldWidth = (pageSize.width - 2 * margin - 30) / 4
        
        drawOfficialField("Hunger", value: "\(vampire.hunger)",
                         at: CGPoint(x: margin, y: startY), 
                         width: fieldWidth - 10)
        
        drawOfficialField("Humanity", value: "\(vampire.humanity)",
                         at: CGPoint(x: margin + fieldWidth, y: startY), 
                         width: fieldWidth - 10)
        
        drawOfficialField("Blood Potency", value: "\(vampire.bloodPotency)",
                         at: CGPoint(x: margin + 2 * fieldWidth, y: startY), 
                         width: fieldWidth)
        
        drawOfficialField("Blood Surge", value: "",
                         at: CGPoint(x: margin + 3 * fieldWidth + 10, y: startY), 
                         width: fieldWidth)
        
        // Second row of traits
        let secondRowY = startY + 35
        
        drawOfficialField("Power Bonus", value: "",
                         at: CGPoint(x: margin, y: secondRowY), 
                         width: fieldWidth)
        
        drawOfficialField("Rouse Re-Roll", value: "",
                         at: CGPoint(x: margin + fieldWidth + 10, y: secondRowY), 
                         width: fieldWidth)
        
        drawOfficialField("Feeding Penalty", value: "",
                         at: CGPoint(x: margin + 2 * fieldWidth + 10, y: secondRowY), 
                         width: fieldWidth + 20)
        
        return 70
    }
    
    @discardableResult
    private static func drawOfficialStyleDisciplines(character: any DisciplineCapable, startY: CGFloat, margin: CGFloat, pageSize: CGSize, maxHeight: CGFloat) -> CGFloat {
        let titleFont = UIFont.boldSystemFont(ofSize: 14)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.black
        ]
        
        // Draw section title
        let titleString = NSAttributedString(string: "DISCIPLINES", attributes: headerAttributes)
        titleString.draw(at: CGPoint(x: margin, y: startY))
        
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
            
            // Draw discipline name
            let nameFont = UIFont.boldSystemFont(ofSize: 11)
            let nameAttributes: [NSAttributedString.Key: Any] = [
                .font: nameFont,
                .foregroundColor: UIColor.black
            ]
            let nameString = NSAttributedString(string: discipline.name.uppercased(), attributes: nameAttributes)
            nameString.draw(at: CGPoint(x: margin, y: currentY))
            
            // Draw dots for level
            let dotStartX = margin + 150
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
            
            currentY += 20
            
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
                currentY += 15
            }
            currentY += 10
        }
        
        return currentY - startY
    }
    
    private static func drawOfficialNote(_ text: String, at point: CGPoint, pageSize: CGSize) {
        let font = UIFont.italicSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        let noteString = NSAttributedString(string: text, attributes: attributes)
        noteString.draw(at: point)
    }
}
}
}