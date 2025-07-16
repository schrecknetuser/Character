import SwiftUI
import UIKit
import PDFKit

class PDFGenerator {
    static func generateCharacterPDF(for character: any BaseCharacter) -> Data? {
        let pageSize = CGSize(width: 595.2, height: 841.8) // A4 size in points
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
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
    }
    
    private static func drawVampireCharacterSheet(vampire: VampireCharacter, in context: CGContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        let workingWidth = pageSize.width - (margin * 2)
        var currentY: CGFloat = margin
        
        // Title
        currentY = drawText("VAMPIRE: THE MASQUERADE CHARACTER SHEET", 
                           at: CGPoint(x: margin, y: currentY), 
                           fontSize: 18, 
                           bold: true, 
                           in: context, 
                           maxWidth: workingWidth)
        currentY += 20
        
        // Character Name
        currentY = drawLabeledField("Name:", vampire.name, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: workingWidth)
        currentY += 5
        
        // Basic Info Row
        let thirdWidth = workingWidth / 3
        currentY = drawLabeledField("Concept:", vampire.concept, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: thirdWidth - 10)
        
        _ = drawLabeledField("Clan:", vampire.clan, 
                           at: CGPoint(x: margin + thirdWidth, y: currentY), 
                           in: context, 
                           maxWidth: thirdWidth - 10)
        
        _ = drawLabeledField("Generation:", "\(vampire.generation)", 
                           at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                           in: context, 
                           maxWidth: thirdWidth - 10)
        currentY += 25
        
        // Chronicle and Predator Type
        currentY = drawLabeledField("Chronicle:", vampire.chronicleName, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: thirdWidth * 2 - 10)
        
        _ = drawLabeledField("Predator Type:", vampire.predatorType, 
                           at: CGPoint(x: margin + (thirdWidth * 2), y: currentY), 
                           in: context, 
                           maxWidth: thirdWidth - 10)
        currentY += 25
        
        // Attributes Section
        currentY = drawAttributesSection(character: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Skills Section  
        currentY = drawSkillsSection(character: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Vampire-specific traits
        currentY = drawVampireTraits(vampire: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Disciplines
        currentY = drawDisciplinesSection(character: vampire, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        
        // Unfilled fields as requested
        drawUnfilledFields(at: CGPoint(x: margin, y: pageSize.height - 150), in: context, maxWidth: workingWidth)
    }
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, in context: CGContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        let workingWidth = pageSize.width - (margin * 2)
        var currentY: CGFloat = margin
        
        // Title
        currentY = drawText("GHOUL CHARACTER SHEET", 
                           at: CGPoint(x: margin, y: currentY), 
                           fontSize: 18, 
                           bold: true, 
                           in: context, 
                           maxWidth: workingWidth)
        currentY += 20
        
        // Character Name
        currentY = drawLabeledField("Name:", ghoul.name, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: workingWidth)
        currentY += 5
        
        // Basic Info Row
        let halfWidth = workingWidth / 2
        currentY = drawLabeledField("Concept:", ghoul.concept, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: halfWidth - 10)
        
        _ = drawLabeledField("Chronicle:", ghoul.chronicleName, 
                           at: CGPoint(x: margin + halfWidth, y: currentY), 
                           in: context, 
                           maxWidth: halfWidth - 10)
        currentY += 25
        
        // Attributes Section
        currentY = drawAttributesSection(character: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Skills Section  
        currentY = drawSkillsSection(character: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Ghoul-specific traits
        currentY = drawGhoulTraits(ghoul: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        currentY += 20
        
        // Disciplines
        currentY = drawDisciplinesSection(character: ghoul, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
        
        // Unfilled fields as requested
        drawUnfilledFields(at: CGPoint(x: margin, y: pageSize.height - 150), in: context, maxWidth: workingWidth)
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, in context: CGContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        let workingWidth = pageSize.width - (margin * 2)
        var currentY: CGFloat = margin
        
        // Title
        currentY = drawText("MAGE CHARACTER SHEET (STUB)", 
                           at: CGPoint(x: margin, y: currentY), 
                           fontSize: 18, 
                           bold: true, 
                           in: context, 
                           maxWidth: workingWidth)
        currentY += 20
        
        // Character Name
        currentY = drawLabeledField("Name:", mage.name, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: workingWidth)
        currentY += 5
        
        // Basic Info
        currentY = drawLabeledField("Concept:", mage.concept, 
                                  at: CGPoint(x: margin, y: currentY), 
                                  in: context, 
                                  maxWidth: workingWidth)
        currentY += 25
        
        // Placeholder text for stub implementation
        currentY = drawText("Full Mage character sheet implementation coming soon...", 
                           at: CGPoint(x: margin, y: currentY), 
                           fontSize: 14, 
                           bold: false, 
                           in: context, 
                           maxWidth: workingWidth)
        
        // Basic Attributes Section
        currentY += 30
        currentY = drawAttributesSection(character: mage, at: CGPoint(x: margin, y: currentY), in: context, maxWidth: workingWidth)
    }
    
    // MARK: - Section Drawing Methods
    
    private static func drawAttributesSection(character: any BaseCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("ATTRIBUTES", at: CGPoint(x: point.x, y: currentY), fontSize: 14, bold: true, in: context, maxWidth: maxWidth)
        currentY += 5
        
        let columnWidth = maxWidth / 3
        
        // Physical Attributes
        var physicalY = currentY
        physicalY = drawText("Physical", at: CGPoint(x: point.x, y: physicalY), fontSize: 12, bold: true, in: context, maxWidth: columnWidth)
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            physicalY = drawDottedAttribute(attribute, value: value, at: CGPoint(x: point.x, y: physicalY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Social Attributes
        var socialY = currentY
        socialY = drawText("Social", at: CGPoint(x: point.x + columnWidth, y: socialY), fontSize: 12, bold: true, in: context, maxWidth: columnWidth)
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            socialY = drawDottedAttribute(attribute, value: value, at: CGPoint(x: point.x + columnWidth, y: socialY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Mental Attributes
        var mentalY = currentY
        mentalY = drawText("Mental", at: CGPoint(x: point.x + (columnWidth * 2), y: mentalY), fontSize: 12, bold: true, in: context, maxWidth: columnWidth)
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            mentalY = drawDottedAttribute(attribute, value: value, at: CGPoint(x: point.x + (columnWidth * 2), y: mentalY), in: context, maxWidth: columnWidth - 10)
        }
        
        return max(physicalY, max(socialY, mentalY)) + 10
    }
    
    private static func drawSkillsSection(character: any BaseCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("SKILLS", at: CGPoint(x: point.x, y: currentY), fontSize: 14, bold: true, in: context, maxWidth: maxWidth)
        currentY += 5
        
        let columnWidth = maxWidth / 3
        
        // Physical Skills
        var physicalY = currentY
        physicalY = drawText("Physical", at: CGPoint(x: point.x, y: physicalY), fontSize: 12, bold: true, in: context, maxWidth: columnWidth)
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            physicalY = drawDottedAttribute(skill, value: value, at: CGPoint(x: point.x, y: physicalY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Social Skills
        var socialY = currentY
        socialY = drawText("Social", at: CGPoint(x: point.x + columnWidth, y: socialY), fontSize: 12, bold: true, in: context, maxWidth: columnWidth)
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            socialY = drawDottedAttribute(skill, value: value, at: CGPoint(x: point.x + columnWidth, y: socialY), in: context, maxWidth: columnWidth - 10)
        }
        
        // Mental Skills
        var mentalY = currentY
        mentalY = drawText("Mental", at: CGPoint(x: point.x + (columnWidth * 2), y: mentalY), fontSize: 12, bold: true, in: context, maxWidth: columnWidth)
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            mentalY = drawDottedAttribute(skill, value: value, at: CGPoint(x: point.x + (columnWidth * 2), y: mentalY), in: context, maxWidth: columnWidth - 10)
        }
        
        return max(physicalY, max(socialY, mentalY)) + 10
    }
    
    private static func drawVampireTraits(vampire: VampireCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("VAMPIRE TRAITS", at: CGPoint(x: point.x, y: currentY), fontSize: 14, bold: true, in: context, maxWidth: maxWidth)
        currentY += 5
        
        let columnWidth = maxWidth / 4
        
        // Blood Potency
        currentY = drawDottedAttribute("Blood Potency", value: vampire.bloodPotency, at: CGPoint(x: point.x, y: currentY), in: context, maxWidth: columnWidth)
        
        // Humanity  
        _ = drawDottedAttribute("Humanity", value: vampire.humanity, at: CGPoint(x: point.x + columnWidth, y: point.y + 20), in: context, maxWidth: columnWidth)
        
        // Hunger
        _ = drawDottedAttribute("Hunger", value: vampire.hunger, at: CGPoint(x: point.x + (columnWidth * 2), y: point.y + 20), in: context, maxWidth: columnWidth)
        
        return currentY + 10
    }
    
    private static func drawGhoulTraits(ghoul: GhoulCharacter, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("GHOUL TRAITS", at: CGPoint(x: point.x, y: currentY), fontSize: 14, bold: true, in: context, maxWidth: maxWidth)
        currentY += 5
        
        // Humanity  
        currentY = drawDottedAttribute("Humanity", value: ghoul.humanity, at: CGPoint(x: point.x, y: currentY), in: context, maxWidth: maxWidth / 2)
        
        return currentY + 10
    }
    
    private static func drawDisciplinesSection(character: any DisciplineCapable, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        var currentY = point.y
        
        currentY = drawText("DISCIPLINES", at: CGPoint(x: point.x, y: currentY), fontSize: 14, bold: true, in: context, maxWidth: maxWidth)
        currentY += 5
        
        for discipline in character.v5Disciplines {
            currentY = drawText("• \(discipline.name) (\(discipline.currentLevel()))", 
                               at: CGPoint(x: point.x + 10, y: currentY), 
                               fontSize: 10, 
                               bold: false, 
                               in: context, 
                               maxWidth: maxWidth - 20)
        }
        
        return currentY + 10
    }
    
    private static func drawUnfilledFields(at point: CGPoint, in context: CGContext, maxWidth: CGFloat) {
        var currentY = point.y
        
        currentY = drawText("UNFILLED FIELDS", at: CGPoint(x: point.x, y: currentY), fontSize: 12, bold: true, in: context, maxWidth: maxWidth)
        currentY += 5
        
        let fields = ["Blood Surge: ____", "Power Bonus: ____", "Mend Amount: ____", 
                     "Rouse Re-roll: ____", "Feeding Penalty: ____", "Clan Bane: ____", 
                     "Clan Compulsion: ____"]
        
        let columnWidth = maxWidth / 2
        for (index, field) in fields.enumerated() {
            let x = point.x + (index % 2 == 0 ? 0 : columnWidth)
            let y = currentY + CGFloat(index / 2) * 15
            _ = drawText(field, at: CGPoint(x: x, y: y), fontSize: 10, bold: false, in: context, maxWidth: columnWidth - 10)
        }
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
    private static func drawLabeledField(_ label: String, _ value: String, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        let labelY = drawText(label, at: point, fontSize: 10, bold: true, in: context, maxWidth: maxWidth)
        return drawText(value.isEmpty ? "____" : value, at: CGPoint(x: point.x, y: labelY - 5), fontSize: 10, bold: false, in: context, maxWidth: maxWidth)
    }
    
    @discardableResult
    private static func drawDottedAttribute(_ name: String, value: Int, at point: CGPoint, in context: CGContext, maxWidth: CGFloat) -> CGFloat {
        let dots = String(repeating: "●", count: min(value, 5)) + String(repeating: "○", count: max(0, 5 - value))
        let text = "\(name): \(dots)"
        return drawText(text, at: point, fontSize: 10, bold: false, in: context, maxWidth: maxWidth)
    }
}