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
        guard let templateURL = Bundle.main.url(forResource: "template", withExtension: "pdf"),
              let templateDocument = PDFDocument(url: templateURL),
              let templatePage = templateDocument.page(at: 0) else {
            print("Error: Could not load template PDF")
            return nil
        }
        
        let pageSize = templatePage.bounds(for: .mediaBox).size
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        do {
            return renderer.pdfData { context in
                context.beginPage()
                
                // Draw the template as background
                let cgContext = context.cgContext
                cgContext.saveGState()
                
                // Flip the coordinate system for PDF rendering
                cgContext.translateBy(x: 0, y: pageSize.height)
                cgContext.scaleBy(x: 1, y: -1)
                
                templatePage.draw(with: .mediaBox, to: cgContext)
                cgContext.restoreGState()
                
                // Overlay character data on the template
                switch character.characterType {
                case .vampire:
                    if let vampire = character as? VampireCharacter {
                        drawVampireDataOnTemplate(vampire: vampire, in: cgContext, pageSize: pageSize)
                    }
                case .ghoul:
                    if let ghoul = character as? GhoulCharacter {
                        drawGhoulDataOnTemplate(ghoul: ghoul, in: cgContext, pageSize: pageSize)
                    }
                case .mage:
                    if let mage = character as? MageCharacter {
                        drawMageDataOnTemplate(mage: mage, in: cgContext, pageSize: pageSize)
                    }
                }
            }
        } catch {
            print("PDF generation error: \(error)")
            return nil
        }
    }
    
    private static func drawVampireDataOnTemplate(vampire: VampireCharacter, in context: CGContext, pageSize: CGSize) {
        // Template-based coordinate system - these coordinates are estimated
        // and may need adjustment based on the actual template layout
        
        // Character Name - typically in top left
        drawTextOnTemplate(vampire.name, at: CGPoint(x: 80, y: 60), fontSize: 12, in: context)
        
        // Chronicle Name
        drawTextOnTemplate(vampire.chronicleName, at: CGPoint(x: 400, y: 60), fontSize: 12, in: context)
        
        // Concept
        drawTextOnTemplate(vampire.concept, at: CGPoint(x: 80, y: 95), fontSize: 12, in: context)
        
        // Clan
        drawTextOnTemplate(vampire.clan, at: CGPoint(x: 80, y: 130), fontSize: 12, in: context)
        
        // Predator Type
        drawTextOnTemplate(vampire.predatorType, at: CGPoint(x: 280, y: 130), fontSize: 12, in: context)
        
        // Generation
        drawTextOnTemplate("\(vampire.generation)", at: CGPoint(x: 480, y: 130), fontSize: 12, in: context)
        
        // Attributes - typically in three columns
        drawAttributesOnTemplate(character: vampire, startY: 200, in: context)
        
        // Skills - below attributes
        drawSkillsOnTemplate(character: vampire, startY: 350, in: context)
        
        // Health and Willpower boxes
        drawHealthWillpowerOnTemplate(character: vampire, at: CGPoint(x: 400, y: 280), in: context)
        
        // Disciplines
        drawDisciplinesOnTemplate(character: vampire, startY: 500, in: context)
        
        // Vampire-specific traits
        drawVampireTraitsOnTemplate(vampire: vampire, startY: 650, in: context)
    }
    
    private static func drawGhoulDataOnTemplate(ghoul: GhoulCharacter, in context: CGContext, pageSize: CGSize) {
        // Similar to vampire but adapted for ghoul characteristics
        drawTextOnTemplate(ghoul.name, at: CGPoint(x: 80, y: 60), fontSize: 12, in: context)
        drawTextOnTemplate(ghoul.chronicleName, at: CGPoint(x: 400, y: 60), fontSize: 12, in: context)
        drawTextOnTemplate(ghoul.concept, at: CGPoint(x: 80, y: 95), fontSize: 12, in: context)
        
        // Attributes and skills
        drawAttributesOnTemplate(character: ghoul, startY: 200, in: context)
        drawSkillsOnTemplate(character: ghoul, startY: 350, in: context)
        drawHealthWillpowerOnTemplate(character: ghoul, at: CGPoint(x: 400, y: 280), in: context)
        drawDisciplinesOnTemplate(character: ghoul, startY: 500, in: context)
        
        // Ghoul-specific traits (similar to vampire but different positioning)
        drawGhoulTraitsOnTemplate(ghoul: ghoul, startY: 650, in: context)
    }
    
    private static func drawMageDataOnTemplate(mage: MageCharacter, in context: CGContext, pageSize: CGSize) {
        // Basic implementation for mage characters
        drawTextOnTemplate(mage.name, at: CGPoint(x: 80, y: 60), fontSize: 12, in: context)
        drawTextOnTemplate("MAGE CHARACTER", at: CGPoint(x: 80, y: 95), fontSize: 12, in: context)
        drawTextOnTemplate("(Stub Implementation)", at: CGPoint(x: 80, y: 115), fontSize: 10, in: context)
        
        // Basic attributes only
        drawAttributesOnTemplate(character: mage, startY: 200, in: context)
    }
    
    // MARK: - Template-based Helper Methods
    
    private static func drawTextOnTemplate(_ text: String, at point: CGPoint, fontSize: CGFloat, in context: CGContext) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textRect = CGRect(x: point.x, y: point.y, width: 200, height: fontSize + 5)
        
        attributedString.draw(in: textRect)
    }
    
    private static func drawAttributesOnTemplate(character: any BaseCharacter, startY: CGFloat, in context: CGContext) {
        var currentY = startY
        let columnSpacing: CGFloat = 120
        
        // Physical attributes (first column)
        var physicalY = currentY
        for (index, attribute) in V5Constants.physicalAttributes.enumerated() {
            let value = character.getAttributeValue(attribute: attribute)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawTextOnTemplate("\(attribute): \(dotString)", at: CGPoint(x: 80, y: physicalY + CGFloat(index * 15)), fontSize: 9, in: context)
        }
        
        // Social attributes (second column) 
        for (index, attribute) in V5Constants.socialAttributes.enumerated() {
            let value = character.getAttributeValue(attribute: attribute)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawTextOnTemplate("\(attribute): \(dotString)", at: CGPoint(x: 80 + columnSpacing, y: currentY + CGFloat(index * 15)), fontSize: 9, in: context)
        }
        
        // Mental attributes (third column)
        for (index, attribute) in V5Constants.mentalAttributes.enumerated() {
            let value = character.getAttributeValue(attribute: attribute)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawTextOnTemplate("\(attribute): \(dotString)", at: CGPoint(x: 80 + (columnSpacing * 2), y: currentY + CGFloat(index * 15)), fontSize: 9, in: context)
        }
    }
    
    private static func drawSkillsOnTemplate(character: any BaseCharacter, startY: CGFloat, in context: CGContext) {
        var currentY = startY
        let columnSpacing: CGFloat = 120
        
        // Physical skills (first column)
        for (index, skill) in V5Constants.physicalSkills.enumerated() {
            let value = character.getSkillValue(skill: skill)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawTextOnTemplate("\(skill): \(dotString)", at: CGPoint(x: 80, y: currentY + CGFloat(index * 15)), fontSize: 9, in: context)
        }
        
        // Social skills (second column)
        for (index, skill) in V5Constants.socialSkills.enumerated() {
            let value = character.getSkillValue(skill: skill)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawTextOnTemplate("\(skill): \(dotString)", at: CGPoint(x: 80 + columnSpacing, y: currentY + CGFloat(index * 15)), fontSize: 9, in: context)
        }
        
        // Mental skills (third column)
        for (index, skill) in V5Constants.mentalSkills.enumerated() {
            let value = character.getSkillValue(skill: skill)
            let dotString = String(repeating: "●", count: value) + String(repeating: "○", count: 5 - value)
            drawTextOnTemplate("\(skill): \(dotString)", at: CGPoint(x: 80 + (columnSpacing * 2), y: currentY + CGFloat(index * 15)), fontSize: 9, in: context)
        }
    }
    
    private static func drawHealthWillpowerOnTemplate(character: any BaseCharacter, at point: CGPoint, in context: CGContext) {
        // Draw health status as simple text for now
        var healthStatus = "Health: "
        for i in 0..<character.health {
            if i < character.healthStates.count {
                switch character.healthStates[i] {
                case .ok: healthStatus += "□ "
                case .superficial: healthStatus += "/ "
                case .aggravated: healthStatus += "✗ "
                }
            } else {
                healthStatus += "□ "
            }
        }
        drawTextOnTemplate(healthStatus, at: point, fontSize: 9, in: context)
        
        // Draw willpower status
        var willpowerStatus = "Willpower: "
        for i in 0..<character.willpower {
            if i < character.willpowerStates.count {
                switch character.willpowerStates[i] {
                case .ok: willpowerStatus += "□ "
                case .superficial: willpowerStatus += "/ "
                case .aggravated: willpowerStatus += "✗ "
                }
            } else {
                willpowerStatus += "□ "
            }
        }
        drawTextOnTemplate(willpowerStatus, at: CGPoint(x: point.x, y: point.y + 15), fontSize: 9, in: context)
    }
    
    private static func drawDisciplinesOnTemplate(character: any DisciplineCapable, startY: CGFloat, in context: CGContext) {
        var currentY = startY
        
        if character.v5Disciplines.isEmpty {
            drawTextOnTemplate("Disciplines: None", at: CGPoint(x: 80, y: currentY), fontSize: 10, in: context)
        } else {
            for (index, discipline) in character.v5Disciplines.enumerated() {
                let level = discipline.currentLevel()
                let dotString = String(repeating: "●", count: level) + String(repeating: "○", count: 5 - level)
                let disciplineText = "\(discipline.name): \(dotString)"
                drawTextOnTemplate(disciplineText, at: CGPoint(x: 80, y: currentY + CGFloat(index * 15)), fontSize: 9, in: context)
                
                // Add selected powers as a subtitle
                let selectedPowers = discipline.getAllSelectedPowerNames()
                if !selectedPowers.isEmpty {
                    let powersText = "Powers: \(Array(selectedPowers).joined(separator: ", "))"
                    drawTextOnTemplate(powersText, at: CGPoint(x: 100, y: currentY + CGFloat(index * 15) + 10), fontSize: 8, in: context)
                }
            }
        }
    }
    
    private static func drawVampireTraitsOnTemplate(vampire: VampireCharacter, startY: CGFloat, in context: CGContext) {
        var currentY = startY
        
        drawTextOnTemplate("Hunger: \(vampire.hunger)", at: CGPoint(x: 80, y: currentY), fontSize: 10, in: context)
        drawTextOnTemplate("Humanity: \(vampire.humanity)", at: CGPoint(x: 80, y: currentY + 15), fontSize: 10, in: context)
        drawTextOnTemplate("Blood Potency: \(vampire.bloodPotency)", at: CGPoint(x: 80, y: currentY + 30), fontSize: 10, in: context)
        drawTextOnTemplate("Experience: \(vampire.experience)", at: CGPoint(x: 80, y: currentY + 45), fontSize: 10, in: context)
    }
    
    private static func drawGhoulTraitsOnTemplate(ghoul: GhoulCharacter, startY: CGFloat, in context: CGContext) {
        var currentY = startY
        
        drawTextOnTemplate("Humanity: \(ghoul.humanity)", at: CGPoint(x: 80, y: currentY), fontSize: 10, in: context)
        drawTextOnTemplate("Experience: \(ghoul.experience)", at: CGPoint(x: 80, y: currentY + 15), fontSize: 10, in: context)
    }
}
}