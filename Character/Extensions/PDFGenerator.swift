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
        
        // Title
        currentY += drawTitle("VAMPIRE: THE MASQUERADE CHARACTER SHEET", at: CGPoint(x: margin, y: currentY), pageSize: pageSize, fontSize: 16)
        currentY += 20
        
        // Character Information Section
        currentY += drawSectionHeader("CHARACTER INFORMATION", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        
        // Basic info in two columns
        let columnWidth = (pageSize.width - 3 * margin) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + margin
        
        currentY += drawFieldRow("Name:", vampire.name, "Chronicle:", vampire.chronicleName, 
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawFieldRow("Concept:", vampire.concept, "Clan:", vampire.clan,
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawFieldRow("Predator Type:", vampire.predatorType, "Generation:", "\(vampire.generation)",
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += 20
        
        // Attributes Section
        currentY += drawSectionHeader("ATTRIBUTES", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawAttributes(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Skills Section  
        currentY += drawSectionHeader("SKILLS", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawSkills(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Health and Willpower
        currentY += drawHealthWillpower(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Disciplines
        currentY += drawSectionHeader("DISCIPLINES", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawDisciplines(character: vampire, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Vampire Traits
        currentY += drawVampireTraits(vampire: vampire, startY: currentY, margin: margin, pageSize: pageSize)
    }
    
    private static func drawGhoulCharacterSheet(ghoul: GhoulCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        var currentY: CGFloat = margin
        
        // Title
        currentY += drawTitle("GHOUL CHARACTER SHEET", at: CGPoint(x: margin, y: currentY), pageSize: pageSize, fontSize: 16)
        currentY += 20
        
        // Character Information
        currentY += drawSectionHeader("CHARACTER INFORMATION", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        
        let columnWidth = (pageSize.width - 3 * margin) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + margin
        
        currentY += drawFieldRow("Name:", ghoul.name, "Chronicle:", ghoul.chronicleName,
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawFieldRow("Concept:", ghoul.concept, "Humanity:", "\(ghoul.humanity)",
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += 20
        
        // Attributes, Skills, Health/Willpower, Disciplines - same as vampire
        currentY += drawSectionHeader("ATTRIBUTES", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawAttributes(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        currentY += drawSectionHeader("SKILLS", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawSkills(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        currentY += drawHealthWillpower(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        currentY += drawSectionHeader("DISCIPLINES", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawDisciplines(character: ghoul, startY: currentY, margin: margin, pageSize: pageSize)
    }
    
    private static func drawMageCharacterSheet(mage: MageCharacter, context: UIGraphicsPDFRendererContext, pageSize: CGSize) {
        let margin: CGFloat = 40
        var currentY: CGFloat = margin
        
        // Title
        currentY += drawTitle("MAGE CHARACTER SHEET", at: CGPoint(x: margin, y: currentY), pageSize: pageSize, fontSize: 16)
        currentY += 20
        
        // Basic info
        currentY += drawSectionHeader("CHARACTER INFORMATION", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        
        let columnWidth = (pageSize.width - 3 * margin) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + margin
        
        currentY += drawFieldRow("Name:", mage.name, "Chronicle:", mage.chronicleName,
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += drawFieldRow("Concept:", mage.concept, "", "",
                                 leftX: leftColumn, rightX: rightColumn, y: currentY, columnWidth: columnWidth)
        currentY += 20
        
        // Attributes only for now
        currentY += drawSectionHeader("ATTRIBUTES", at: CGPoint(x: margin, y: currentY), pageSize: pageSize)
        currentY += 10
        currentY += drawAttributes(character: mage, startY: currentY, margin: margin, pageSize: pageSize)
        currentY += 20
        
        // Note about full implementation
        drawText("Full Mage implementation coming soon", at: CGPoint(x: margin, y: currentY), fontSize: 12, bold: true, color: .gray)
    }
    
    
    // MARK: - Drawing Helper Methods
    
    @discardableResult
    private static func drawTitle(_ text: String, at point: CGPoint, pageSize: CGSize, fontSize: CGFloat) -> CGFloat {
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedString.size()
        let centeredX = (pageSize.width - textSize.width) / 2
        let textRect = CGRect(x: centeredX, y: point.y, width: textSize.width, height: textSize.height)
        
        attributedString.draw(in: textRect)
        return textSize.height
    }
    
    @discardableResult
    private static func drawSectionHeader(_ text: String, at point: CGPoint, pageSize: CGSize) -> CGFloat {
        let font = UIFont.boldSystemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textRect = CGRect(x: point.x, y: point.y, width: pageSize.width - 2 * point.x, height: 20)
        
        attributedString.draw(in: textRect)
        
        // Draw underline
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: point.x, y: point.y + 18))
        context?.addLine(to: CGPoint(x: pageSize.width - point.x, y: point.y + 18))
        context?.strokePath()
        
        return 20
    }
    
    @discardableResult
    private static func drawFieldRow(_ leftLabel: String, _ leftValue: String, _ rightLabel: String, _ rightValue: String, 
                                   leftX: CGFloat, rightX: CGFloat, y: CGFloat, columnWidth: CGFloat) -> CGFloat {
        drawField(leftLabel, value: leftValue, at: CGPoint(x: leftX, y: y), width: columnWidth)
        if !rightLabel.isEmpty {
            drawField(rightLabel, value: rightValue, at: CGPoint(x: rightX, y: y), width: columnWidth)
        }
        return 20
    }
    
    private static func drawField(_ label: String, value: String, at point: CGPoint, width: CGFloat) {
        let labelFont = UIFont.systemFont(ofSize: 10, weight: .medium)
        let valueFont = UIFont.systemFont(ofSize: 10)
        
        // Draw label
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: labelFont,
            .foregroundColor: UIColor.black
        ]
        let labelString = NSAttributedString(string: label, attributes: labelAttributes)
        let labelSize = labelString.size()
        labelString.draw(at: point)
        
        // Draw value with underline
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: valueFont,
            .foregroundColor: UIColor.black
        ]
        let valueString = NSAttributedString(string: value, attributes: valueAttributes)
        let valuePoint = CGPoint(x: point.x + labelSize.width + 5, y: point.y)
        valueString.draw(at: valuePoint)
        
        // Draw underline for field
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(0.5)
        context?.move(to: CGPoint(x: valuePoint.x, y: point.y + 12))
        context?.addLine(to: CGPoint(x: point.x + width, y: point.y + 12))
        context?.strokePath()
    }
    
    @discardableResult
    private static func drawAttributes(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 4 * margin) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + margin/2
        let mentalX = margin + 2 * (columnWidth + margin/2)
        
        var maxHeight: CGFloat = 0
        
        // Physical Attributes
        var physicalY = startY
        drawText("PHYSICAL", at: CGPoint(x: physicalX, y: physicalY), fontSize: 10, bold: true)
        physicalY += 15
        
        for attribute in V5Constants.physicalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawText("\(attribute):", at: CGPoint(x: physicalX, y: physicalY), fontSize: 9)
            drawText(dotString, at: CGPoint(x: physicalX + 60, y: physicalY), fontSize: 9)
            physicalY += 12
        }
        maxHeight = max(maxHeight, physicalY - startY)
        
        // Social Attributes
        var socialY = startY
        drawText("SOCIAL", at: CGPoint(x: socialX, y: socialY), fontSize: 10, bold: true)
        socialY += 15
        
        for attribute in V5Constants.socialAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawText("\(attribute):", at: CGPoint(x: socialX, y: socialY), fontSize: 9)
            drawText(dotString, at: CGPoint(x: socialX + 60, y: socialY), fontSize: 9)
            socialY += 12
        }
        maxHeight = max(maxHeight, socialY - startY)
        
        // Mental Attributes
        var mentalY = startY
        drawText("MENTAL", at: CGPoint(x: mentalX, y: mentalY), fontSize: 10, bold: true)
        mentalY += 15
        
        for attribute in V5Constants.mentalAttributes {
            let value = character.getAttributeValue(attribute: attribute)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawText("\(attribute):", at: CGPoint(x: mentalX, y: mentalY), fontSize: 9)
            drawText(dotString, at: CGPoint(x: mentalX + 60, y: mentalY), fontSize: 9)
            mentalY += 12
        }
        maxHeight = max(maxHeight, mentalY - startY)
        
        return maxHeight
    }
    
    @discardableResult
    private static func drawSkills(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 4 * margin) / 3
        let physicalX = margin
        let socialX = margin + columnWidth + margin/2
        let mentalX = margin + 2 * (columnWidth + margin/2)
        
        var maxHeight: CGFloat = 0
        
        // Physical Skills
        var physicalY = startY
        drawText("PHYSICAL", at: CGPoint(x: physicalX, y: physicalY), fontSize: 10, bold: true)
        physicalY += 15
        
        for skill in V5Constants.physicalSkills {
            let value = character.getSkillValue(skill: skill)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawText("\(skill):", at: CGPoint(x: physicalX, y: physicalY), fontSize: 9)
            drawText(dotString, at: CGPoint(x: physicalX + 60, y: physicalY), fontSize: 9)
            physicalY += 12
        }
        maxHeight = max(maxHeight, physicalY - startY)
        
        // Social Skills
        var socialY = startY
        drawText("SOCIAL", at: CGPoint(x: socialX, y: socialY), fontSize: 10, bold: true)
        socialY += 15
        
        for skill in V5Constants.socialSkills {
            let value = character.getSkillValue(skill: skill)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawText("\(skill):", at: CGPoint(x: socialX, y: socialY), fontSize: 9)
            drawText(dotString, at: CGPoint(x: socialX + 60, y: socialY), fontSize: 9)
            socialY += 12
        }
        maxHeight = max(maxHeight, socialY - startY)
        
        // Mental Skills
        var mentalY = startY
        drawText("MENTAL", at: CGPoint(x: mentalX, y: mentalY), fontSize: 10, bold: true)
        mentalY += 15
        
        for skill in V5Constants.mentalSkills {
            let value = character.getSkillValue(skill: skill)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawText("\(skill):", at: CGPoint(x: mentalX, y: mentalY), fontSize: 9)
            drawText(dotString, at: CGPoint(x: mentalX + 60, y: mentalY), fontSize: 9)
            mentalY += 12
        }
        maxHeight = max(maxHeight, mentalY - startY)
        
        return maxHeight
    }
    
    @discardableResult
    private static func drawHealthWillpower(character: any BaseCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        let columnWidth = (pageSize.width - 3 * margin) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + margin
        
        // Health
        drawText("HEALTH:", at: CGPoint(x: leftColumn, y: startY), fontSize: 10, bold: true)
        var healthBoxes = ""
        for i in 0..<character.health {
            if i < character.healthStates.count {
                switch character.healthStates[i] {
                case .ok: healthBoxes += "□ "
                case .superficial: healthBoxes += "/ "
                case .aggravated: healthBoxes += "✗ "
                }
            } else {
                healthBoxes += "□ "
            }
        }
        drawText(healthBoxes, at: CGPoint(x: leftColumn + 50, y: startY), fontSize: 9)
        
        // Willpower
        drawText("WILLPOWER:", at: CGPoint(x: rightColumn, y: startY), fontSize: 10, bold: true)
        var willpowerBoxes = ""
        for i in 0..<character.willpower {
            if i < character.willpowerStates.count {
                switch character.willpowerStates[i] {
                case .ok: willpowerBoxes += "□ "
                case .superficial: willpowerBoxes += "/ "
                case .aggravated: willpowerBoxes += "✗ "
                }
            } else {
                willpowerBoxes += "□ "
            }
        }
        drawText(willpowerBoxes, at: CGPoint(x: rightColumn + 70, y: startY), fontSize: 9)
        
        return 20
    }
    
    @discardableResult
    private static func drawDisciplines(character: any DisciplineCapable, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        var currentY = startY
        
        if character.v5Disciplines.isEmpty {
            drawText("None", at: CGPoint(x: margin, y: currentY), fontSize: 10, color: .gray)
            return 15
        }
        
        for discipline in character.v5Disciplines {
            let level = discipline.currentLevel()
            let dotString = String(repeating: "●", count: level) + String(repeating: "○", count: 5 - level)
            
            drawText("\(discipline.name):", at: CGPoint(x: margin, y: currentY), fontSize: 10, bold: true)
            drawText(dotString, at: CGPoint(x: margin + 80, y: currentY), fontSize: 10)
            currentY += 15
            
            // List selected powers
            let selectedPowers = discipline.getAllSelectedPowerNames()
            if !selectedPowers.isEmpty {
                let powersText = "Powers: \(Array(selectedPowers).joined(separator: ", "))"
                drawText(powersText, at: CGPoint(x: margin + 10, y: currentY), fontSize: 8, color: .darkGray)
                currentY += 12
            }
            currentY += 5
        }
        
        return currentY - startY
    }
    
    @discardableResult
    private static func drawVampireTraits(vampire: VampireCharacter, startY: CGFloat, margin: CGFloat, pageSize: CGSize) -> CGFloat {
        drawSectionHeader("VAMPIRE TRAITS", at: CGPoint(x: margin, y: startY), pageSize: pageSize)
        var currentY = startY + 25
        
        let columnWidth = (pageSize.width - 3 * margin) / 2
        let leftColumn = margin
        let rightColumn = margin + columnWidth + margin
        
        drawField("Hunger:", value: "\(vampire.hunger)", at: CGPoint(x: leftColumn, y: currentY), width: columnWidth)
        drawField("Blood Potency:", value: "\(vampire.bloodPotency)", at: CGPoint(x: rightColumn, y: currentY), width: columnWidth)
        currentY += 25
        
        drawField("Humanity:", value: "\(vampire.humanity)", at: CGPoint(x: leftColumn, y: currentY), width: columnWidth)
        drawField("Experience:", value: "\(vampire.experience)", at: CGPoint(x: rightColumn, y: currentY), width: columnWidth)
        currentY += 25
        
        return currentY - startY
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
}