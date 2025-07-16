import SwiftUI
import UIKit

extension String {
    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}

class PDFGenerator {
    static func generateCharacterPDF(for character: any BaseCharacter) -> Data? {
        // Load the VtM5e template PDF from the bundle
        guard let templateURL = Bundle.main.url(forResource: "VtM5e_ENG_CharacterSheet_2pLAYER", withExtension: "pdf"),
              let templateData = try? Data(contentsOf: templateURL) else {
            print("Could not load VtM5e template PDF from bundle")
            // Fallback: try to load from main directory for testing
            if let fallbackData = loadTemplateFromMainDirectory() {
                return generateWithTemplate(character: character, templateData: fallbackData)
            }
            return nil
        }
        
        return generateWithTemplate(character: character, templateData: templateData)
    }
    
    private static func loadTemplateFromMainDirectory() -> Data? {
        let templatePath = "/home/runner/work/Character/Character/VtM5e_ENG_CharacterSheet_2pLAYER.pdf"
        return try? Data(contentsOf: URL(fileURLWithPath: templatePath))
    }
    
    private static func generateWithTemplate(character: any BaseCharacter, templateData: Data) -> Data? {
        // Create PDF with template as background and overlay character data
        let pageSize = CGSize(width: 612, height: 792) // Letter size to match template
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        return renderer.pdfData { context in
            context.beginPage()
            
            // Draw the template as background
            if let templateImage = createImageFromPDF(data: templateData) {
                templateImage.draw(in: CGRect(origin: .zero, size: pageSize))
            }
            
            // Overlay character data on top of template at specific coordinates
            switch character.characterType {
            case .vampire:
                if let vampire = character as? VampireCharacter {
                    overlayVampireData(vampire: vampire, pageSize: pageSize)
                }
            case .ghoul:
                if let ghoul = character as? GhoulCharacter {
                    overlayGhoulData(ghoul: ghoul, pageSize: pageSize)
                }
            case .mage:
                if let mage = character as? MageCharacter {
                    overlayMageData(mage: mage, pageSize: pageSize)
                }
            }
        }
    }
    
    // MARK: - Template Background and Coordinate-based Overlay
    
    private static func createImageFromPDF(data: Data) -> UIImage? {
        guard let provider = CGDataProvider(data: data),
              let pdfDoc = CGPDFDocument(provider),
              let pdfPage = pdfDoc.page(at: 1) else {
            return nil
        }
        
        let pageRect = pdfPage.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(pdfPage)
        }
        
        return image
    }
    
    private static func overlayVampireData(vampire: VampireCharacter, pageSize: CGSize) {
        // Character basic information - coordinates based on VtM5e template layout
        drawTextAtCoordinates(text: vampire.name, x: 85, y: 110, fontSize: 11, bold: true)
        drawTextAtCoordinates(text: vampire.concept, x: 85, y: 140, fontSize: 10)
        drawTextAtCoordinates(text: vampire.chronicleName, x: 300, y: 110, fontSize: 10)
        drawTextAtCoordinates(text: vampire.clan, x: 85, y: 170, fontSize: 10)
        drawTextAtCoordinates(text: vampire.predatorType, x: 200, y: 170, fontSize: 10)
        drawTextAtCoordinates(text: "\(vampire.generation)", x: 320, y: 170, fontSize: 10)
        drawTextAtCoordinates(text: vampire.sire, x: 85, y: 200, fontSize: 10)
        drawTextAtCoordinates(text: vampire.ambition, x: 320, y: 200, fontSize: 10)
        drawTextAtCoordinates(text: vampire.desire, x: 450, y: 200, fontSize: 10)
        
        // Attributes - draw dots at specific coordinates
        overlayAttributeDots(character: vampire, pageSize: pageSize)
        
        // Skills - draw dots at specific coordinates  
        overlaySkillDots(character: vampire, pageSize: pageSize)
        
        // Health boxes - draw filled boxes for total capacity
        overlayHealthBoxes(character: vampire, pageSize: pageSize)
        
        // Willpower boxes - draw filled boxes for total capacity
        overlayWillpowerBoxes(character: vampire, pageSize: pageSize)
        
        // Vampire-specific traits
        overlayVampireTraits(vampire: vampire, pageSize: pageSize)
        
        // Disciplines
        overlayDisciplines(character: vampire, pageSize: pageSize)
        
        // Merits and Flaws
        overlayMeritsAndFlaws(character: vampire, pageSize: pageSize)
    }
    
    private static func overlayGhoulData(ghoul: GhoulCharacter, pageSize: CGSize) {
        // Similar to vampire but adapted for ghoul
        drawTextAtCoordinates(text: ghoul.name, x: 85, y: 110, fontSize: 11, bold: true)
        drawTextAtCoordinates(text: ghoul.concept, x: 85, y: 140, fontSize: 10)
        drawTextAtCoordinates(text: ghoul.chronicleName, x: 300, y: 110, fontSize: 10)
        drawTextAtCoordinates(text: "Ghoul", x: 85, y: 170, fontSize: 10)
        
        overlayAttributeDots(character: ghoul, pageSize: pageSize)
        overlaySkillDots(character: ghoul, pageSize: pageSize)
        overlayHealthBoxes(character: ghoul, pageSize: pageSize)
        overlayWillpowerBoxes(character: ghoul, pageSize: pageSize)
        overlayDisciplines(character: ghoul, pageSize: pageSize)
        overlayMeritsAndFlaws(character: ghoul, pageSize: pageSize)
    }
    
    private static func overlayMageData(mage: MageCharacter, pageSize: CGSize) {
        // Basic mage information
        drawTextAtCoordinates(text: mage.name, x: 85, y: 110, fontSize: 11, bold: true)
        drawTextAtCoordinates(text: mage.concept, x: 85, y: 140, fontSize: 10)
        drawTextAtCoordinates(text: mage.chronicleName, x: 300, y: 110, fontSize: 10)
        drawTextAtCoordinates(text: "Mage", x: 85, y: 170, fontSize: 10)
        
        overlayAttributeDots(character: mage, pageSize: pageSize)
        overlaySkillDots(character: mage, pageSize: pageSize)
        overlayHealthBoxes(character: mage, pageSize: pageSize)
        overlayWillpowerBoxes(character: mage, pageSize: pageSize)
        
        // Note about mage implementation
        drawTextAtCoordinates(text: "Mage sheet implementation in progress", x: 85, y: 400, fontSize: 10, color: .gray)
    }
    
    
    // MARK: - Coordinate-based Drawing Helper Methods
    
    private static func drawTextAtCoordinates(text: String, x: CGFloat, y: CGFloat, fontSize: CGFloat = 10, bold: Bool = false, color: UIColor = .black) {
        let font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: CGPoint(x: x, y: y))
    }
    
    private static func drawFilledCircle(x: CGFloat, y: CGFloat, radius: CGFloat = 4, color: UIColor = .black) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2))
    }
    
    private static func drawFilledSquare(x: CGFloat, y: CGFloat, size: CGFloat = 8, color: UIColor = .black) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: x, y: y, width: size, height: size))
    }
    
    private static func overlayAttributeDots(character: any BaseCharacter, pageSize: CGSize) {
        // Physical Attributes - approximate coordinates based on VtM5e template
        let physicalStartX: CGFloat = 50
        let physicalStartY: CGFloat = 250
        let dotSpacing: CGFloat = 12
        let rowHeight: CGFloat = 18
        
        // Strength
        let strengthValue = character.getAttributeValue(attribute: "Strength")
        for i in 0..<strengthValue {
            drawFilledCircle(x: physicalStartX + CGFloat(i) * dotSpacing, y: physicalStartY)
        }
        
        // Dexterity
        let dexterityValue = character.getAttributeValue(attribute: "Dexterity")
        for i in 0..<dexterityValue {
            drawFilledCircle(x: physicalStartX + CGFloat(i) * dotSpacing, y: physicalStartY + rowHeight)
        }
        
        // Stamina
        let staminaValue = character.getAttributeValue(attribute: "Stamina")
        for i in 0..<staminaValue {
            drawFilledCircle(x: physicalStartX + CGFloat(i) * dotSpacing, y: physicalStartY + rowHeight * 2)
        }
        
        // Social Attributes
        let socialStartX: CGFloat = 200
        let socialStartY: CGFloat = 250
        
        // Charisma
        let charismaValue = character.getAttributeValue(attribute: "Charisma")
        for i in 0..<charismaValue {
            drawFilledCircle(x: socialStartX + CGFloat(i) * dotSpacing, y: socialStartY)
        }
        
        // Manipulation
        let manipulationValue = character.getAttributeValue(attribute: "Manipulation")
        for i in 0..<manipulationValue {
            drawFilledCircle(x: socialStartX + CGFloat(i) * dotSpacing, y: socialStartY + rowHeight)
        }
        
        // Composure
        let composureValue = character.getAttributeValue(attribute: "Composure")
        for i in 0..<composureValue {
            drawFilledCircle(x: socialStartX + CGFloat(i) * dotSpacing, y: socialStartY + rowHeight * 2)
        }
        
        // Mental Attributes
        let mentalStartX: CGFloat = 350
        let mentalStartY: CGFloat = 250
        
        // Intelligence
        let intelligenceValue = character.getAttributeValue(attribute: "Intelligence")
        for i in 0..<intelligenceValue {
            drawFilledCircle(x: mentalStartX + CGFloat(i) * dotSpacing, y: mentalStartY)
        }
        
        // Wits
        let witsValue = character.getAttributeValue(attribute: "Wits")
        for i in 0..<witsValue {
            drawFilledCircle(x: mentalStartX + CGFloat(i) * dotSpacing, y: mentalStartY + rowHeight)
        }
        
        // Resolve
        let resolveValue = character.getAttributeValue(attribute: "Resolve")
        for i in 0..<resolveValue {
            drawFilledCircle(x: mentalStartX + CGFloat(i) * dotSpacing, y: mentalStartY + rowHeight * 2)
        }
    }
    
    private static func overlaySkillDots(character: any BaseCharacter, pageSize: CGSize) {
        // Skills section - approximate coordinates
        let skillsStartY: CGFloat = 350
        let dotSpacing: CGFloat = 12
        let rowHeight: CGFloat = 16
        
        // Physical Skills
        let physicalSkillsX: CGFloat = 50
        let physicalSkills = ["Athletics", "Brawl", "Craft", "Drive", "Firearms", "Larceny", "Melee", "Stealth", "Survival"]
        
        for (index, skill) in physicalSkills.enumerated() {
            let skillValue = character.getSkillValue(skill: skill)
            for i in 0..<skillValue {
                drawFilledCircle(x: physicalSkillsX + CGFloat(i) * dotSpacing, y: skillsStartY + CGFloat(index) * rowHeight)
            }
        }
        
        // Social Skills
        let socialSkillsX: CGFloat = 200
        let socialSkills = ["Animal Ken", "Etiquette", "Insight", "Intimidation", "Leadership", "Performance", "Persuasion", "Streetwise", "Subterfuge"]
        
        for (index, skill) in socialSkills.enumerated() {
            let skillValue = character.getSkillValue(skill: skill)
            for i in 0..<skillValue {
                drawFilledCircle(x: socialSkillsX + CGFloat(i) * dotSpacing, y: skillsStartY + CGFloat(index) * rowHeight)
            }
        }
        
        // Mental Skills
        let mentalSkillsX: CGFloat = 350
        let mentalSkills = ["Academics", "Awareness", "Finance", "Investigation", "Medicine", "Occult", "Politics", "Science", "Technology"]
        
        for (index, skill) in mentalSkills.enumerated() {
            let skillValue = character.getSkillValue(skill: skill)
            for i in 0..<skillValue {
                drawFilledCircle(x: mentalSkillsX + CGFloat(i) * dotSpacing, y: skillsStartY + CGFloat(index) * rowHeight)
            }
        }
    }
    
    private static func overlayHealthBoxes(character: any BaseCharacter, pageSize: CGSize) {
        // Health boxes - approximate coordinates
        let healthStartX: CGFloat = 50
        let healthStartY: CGFloat = 520
        let boxSize: CGFloat = 10
        let boxSpacing: CGFloat = 12
        
        for i in 0..<character.health {
            let boxX = healthStartX + CGFloat(i % 8) * boxSpacing
            let boxY = healthStartY + CGFloat(i / 8) * boxSpacing
            drawFilledSquare(x: boxX, y: boxY, size: boxSize)
        }
    }
    
    private static func overlayWillpowerBoxes(character: any BaseCharacter, pageSize: CGSize) {
        // Willpower boxes - approximate coordinates  
        let willpowerStartX: CGFloat = 250
        let willpowerStartY: CGFloat = 520
        let boxSize: CGFloat = 10
        let boxSpacing: CGFloat = 12
        
        for i in 0..<character.willpower {
            let boxX = willpowerStartX + CGFloat(i % 8) * boxSpacing
            let boxY = willpowerStartY + CGFloat(i / 8) * boxSpacing
            drawFilledSquare(x: boxX, y: boxY, size: boxSize)
        }
    }
    
    private static func overlayVampireTraits(vampire: VampireCharacter, pageSize: CGSize) {
        // Blood potency
        drawTextAtCoordinates(text: "\(vampire.bloodPotency)", x: 50, y: 580, fontSize: 12, bold: true)
        
        // Humanity
        drawTextAtCoordinates(text: "\(vampire.humanity)", x: 150, y: 580, fontSize: 12, bold: true)
        
        // Hunger
        drawTextAtCoordinates(text: "\(vampire.hunger)", x: 250, y: 580, fontSize: 12, bold: true)
        
        // Blood potency effects
        let bloodPotencyEffects = getBloodPotencyEffects(bloodPotency: vampire.bloodPotency)
        drawTextAtCoordinates(text: "\(bloodPotencyEffects.surge)", x: 350, y: 580, fontSize: 10)
        drawTextAtCoordinates(text: bloodPotencyEffects.mend, x: 400, y: 580, fontSize: 10)
        drawTextAtCoordinates(text: bloodPotencyEffects.discBonus, x: 500, y: 580, fontSize: 10)
        
        // Clan information
        drawTextAtCoordinates(text: vampire.getClanBane(), x: 50, y: 610, fontSize: 9)
        drawTextAtCoordinates(text: vampire.getClanCompulsion(), x: 50, y: 630, fontSize: 9)
    }
    
    private static func overlayDisciplines(character: any DisciplineCapable, pageSize: CGSize) {
        let disciplinesStartX: CGFloat = 50
        let disciplinesStartY: CGFloat = 670
        let rowHeight: CGFloat = 40
        
        for (index, discipline) in character.v5Disciplines.enumerated() {
            if index >= 6 { break } // Limit to 6 disciplines
            
            let y = disciplinesStartY + CGFloat(index) * rowHeight
            
            // Discipline name
            drawTextAtCoordinates(text: discipline.name.uppercased(), x: disciplinesStartX, y: y, fontSize: 11, bold: true, color: .systemRed)
            
            // Discipline level dots
            let level = discipline.currentLevel()
            for i in 0..<level {
                drawFilledCircle(x: disciplinesStartX + 150 + CGFloat(i) * 12, y: y + 2)
            }
            
            // Powers
            let selectedPowers = Array(discipline.getAllSelectedPowerNames())
            if !selectedPowers.isEmpty {
                let powersText = selectedPowers.prefix(3).joined(separator: ", ")
                drawTextAtCoordinates(text: powersText, x: disciplinesStartX + 15, y: y + 15, fontSize: 8, color: .darkGray)
            }
        }
    }
    
    private static func overlayMeritsAndFlaws(character: any BaseCharacter, pageSize: CGSize) {
        let meritsStartX: CGFloat = 350
        let meritsStartY: CGFloat = 670
        let rowHeight: CGFloat = 12
        
        var currentY = meritsStartY
        
        // Merits
        for merit in character.advantages.prefix(10) {
            drawTextAtCoordinates(text: "\(merit.name) (\(merit.cost))", x: meritsStartX, y: currentY, fontSize: 9)
            currentY += rowHeight
        }
        
        // Background merits
        for backgroundMerit in character.backgroundMerits.prefix(5) {
            drawTextAtCoordinates(text: "\(backgroundMerit.name) (\(backgroundMerit.cost))", x: meritsStartX, y: currentY, fontSize: 9)
            currentY += rowHeight
        }
        
        // Flaws
        for flaw in character.flaws.prefix(5) {
            drawTextAtCoordinates(text: "\(flaw.name) (\(flaw.cost))", x: meritsStartX, y: currentY, fontSize: 9, color: .systemRed)
            currentY += rowHeight
        }
        
        // Experience
        drawTextAtCoordinates(text: "Total XP: \(character.experience)", x: 450, y: 750, fontSize: 10)
        drawTextAtCoordinates(text: "Spent XP: \(character.spentExperience)", x: 450, y: 765, fontSize: 10)
    }
    
    // MARK: - Blood Potency Effects Helper
    
    private static func getBloodPotencyEffects(bloodPotency: Int) -> BloodPotencyEffect {
        switch bloodPotency {
        case 0: return BloodPotencyEffect(surge: 1, mend: "1 superficial", discBonus: "-", discRouse: "-", bane: 0, penalty: "-")
        case 1: return BloodPotencyEffect(surge: 2, mend: "1 superficial", discBonus: "-", discRouse: "Lvl 1", bane: 2, penalty: "-")
        case 2: return BloodPotencyEffect(surge: 2, mend: "2 superficial", discBonus: "Add 1 die", discRouse: "Lvl 1", bane: 2, penalty: "Animal and bagged blood slake half Hunger")
        case 3: return BloodPotencyEffect(surge: 3, mend: "2 superficial", discBonus: "Add 1 die", discRouse: "Lvl 2 and below", bane: 3, penalty: "Animal and bagged blood slake no Hunger")
        case 4: return BloodPotencyEffect(surge: 3, mend: "3 superficial", discBonus: "Add 2 dice", discRouse: "Lvl 2 and below", bane: 3, penalty: "Animal and bagged blood slake no Hunger, Slake 1 less Hunger per human")
        case 5: return BloodPotencyEffect(surge: 4, mend: "3 superficial", discBonus: "Add 2 dice", discRouse: "Lvl 3 and below", bane: 4, penalty: "Animal and bagged blood slake no Hunger, Slake 1 less Hunger per human, Must drain and kill a human to reduce Hunger below 2")
        default: return BloodPotencyEffect(surge: 1, mend: "1 superficial", discBonus: "-", discRouse: "-", bane: 0, penalty: "-")
        }
    }
}

struct BloodPotencyEffect {
    let surge: Int
    let mend: String
    let discBonus: String
    let discRouse: String
    let bane: Int
    let penalty: String
}