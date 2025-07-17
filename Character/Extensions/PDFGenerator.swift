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
        // Try to use fillable PDF form approach first
        if let filledPDFData = generateWithFillableFields(character: character) {
            return filledPDFData
        }
        
        // Fallback to creating a clean custom PDF layout
        return generateCustomLayout(character: character)
    }
    
    private static func generateWithFillableFields(character: any BaseCharacter) -> Data? {
        // Load the VtM5e template PDF from the bundle
        guard let templateURL = Bundle.main.url(forResource: "VtM5e_ENG_CharacterSheet_2pLAYER", withExtension: "pdf") else {
            // Fallback: try to load from main directory for testing
            let templatePath = "/home/runner/work/Character/Character/VtM5e_ENG_CharacterSheet_2pLAYER.pdf"
            guard let fallbackURL = URL(string: "file://\(templatePath)") else {
                return nil
            }
            return fillPDFFields(templateURL: fallbackURL, character: character)
        }
        
        return fillPDFFields(templateURL: templateURL, character: character)
    }
    
    private static func fillPDFFields(templateURL: URL, character: any BaseCharacter) -> Data? {
        guard let pdfDocument = PDFDocument(url: templateURL) else {
            print("Could not load PDF document from template")
            return nil
        }
        
        // Get the first page and its annotations (form fields)
        guard let page = pdfDocument.page(at: 0) else {
            print("Could not get first page of PDF")
            return nil
        }
        
        let annotations = page.annotations
        print("Found \(annotations.count) annotations in PDF")
        
        // Fill form fields based on character data
        for annotation in annotations {
            if let widget = annotation as? PDFAnnotation {
                fillFieldBasedOnCharacter(widget: widget, character: character)
            }
        }
        
        // Return the modified PDF data
        return pdfDocument.dataRepresentation()
    }
    
    private static func fillFieldBasedOnCharacter(widget: PDFAnnotation, character: any BaseCharacter) {
        guard let fieldName = widget.fieldName else { return }
        
        // Fill basic character information
        switch fieldName.lowercased() {
        case "name", "character_name", "charactername":
            widget.widgetStringValue = character.name
        case "concept", "pcconcept":
            widget.widgetStringValue = character.concept
        case "chronicle", "chronicle_name", "chronicles":
            widget.widgetStringValue = character.chronicleName
        case "player":
            widget.widgetStringValue = "" // Leave blank for manual fill
        case "ambition":
            widget.widgetStringValue = character.ambition
        case "desire":
            widget.widgetStringValue = character.desire
        case "notes", "pc_notes":
            widget.widgetStringValue = character.notes
        case "cexp":
            widget.widgetStringValue = "\(character.availableExperience)"
        case "texp":
            widget.widgetStringValue = "\(character.experience)"
        case "generation":
            if let vampire = character as? VampireCharacter {
                widget.widgetStringValue = "\(vampire.generation)"
            }
        case "sire":
            widget.widgetStringValue = "" // Leave blank as requested
        case "sect":
            widget.widgetStringValue = "" // Leave blank for manual fill
        case "title":
            widget.widgetStringValue = "" // Leave blank for manual fill
        case "birthday":
            if let birthDate = character.dateOfBirth {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                widget.widgetStringValue = formatter.string(from: birthDate)
            }
        case "age":
            widget.widgetStringValue = "" // Leave blank for manual calculation
        case "embrace":
            if let vampire = character as? VampireCharacter,
               let embraceDate = vampire.dateOfEmbrace {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                widget.widgetStringValue = formatter.string(from: embraceDate)
            }
        case "apparent age":
            widget.widgetStringValue = "" // Leave blank for manual fill
        default:
            // Handle character-specific fields
            if let vampire = character as? VampireCharacter {
                fillVampireSpecificField(fieldName: fieldName, widget: widget, vampire: vampire)
            } else if let ghoul = character as? GhoulCharacter {
                fillGhoulSpecificField(fieldName: fieldName, widget: widget, ghoul: ghoul)
            } else if let mage = character as? MageCharacter {
                fillMageSpecificField(fieldName: fieldName, widget: widget, mage: mage)
            }
        }
    }
    
    private static func fillVampireSpecificField(fieldName: String, widget: PDFAnnotation, vampire: VampireCharacter) {
        switch fieldName.lowercased() {
        case "clan":
            widget.widgetStringValue = vampire.clan
        case "generation":
            widget.widgetStringValue = "\(vampire.generation)"
        case "predator", "predator_type", "predatortype", "predator type":
            widget.widgetStringValue = vampire.predatorType
        case "sire":
            widget.widgetStringValue = "" // Leave blank as requested
        case "blood_potency", "bloodpotency":
            widget.widgetStringValue = "\(vampire.bloodPotency)"
        case "humanity":
            widget.widgetStringValue = "\(vampire.humanity)"
        case "hunger":
            widget.widgetStringValue = "\(vampire.hunger)"
        default:
            // Handle attributes, skills, and other complex fields
            fillAttributeOrSkillField(fieldName: fieldName, widget: widget, character: vampire)
        }
    }
    
    private static func fillGhoulSpecificField(fieldName: String, widget: PDFAnnotation, ghoul: GhoulCharacter) {
        switch fieldName {
        case "clan":
            widget.widgetStringValue = "Ghoul"
        case "humanity":
            widget.widgetStringValue = "\(ghoul.humanity)"
        default:
            fillAttributeOrSkillField(fieldName: fieldName, widget: widget, character: ghoul)
        }
    }
    
    private static func fillMageSpecificField(fieldName: String, widget: PDFAnnotation, mage: MageCharacter) {
        switch fieldName {
        case "clan":
            widget.widgetStringValue = "Mage"
        default:
            fillAttributeOrSkillField(fieldName: fieldName, widget: widget, character: mage)
        }
    }
    
    private static func fillAttributeOrSkillField(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Handle attribute button fields (format: Str-1, Str-2, etc.)
        let attributeMapping = [
            "Str": "Strength",
            "Dex": "Dexterity", 
            "Sta": "Stamina",
            "Cha": "Charisma",
            "Man": "Manipulation",
            "Com": "Composure",
            "Int": "Intelligence",
            "Wit": "Wits",
            "Res": "Resolve"
        ]
        
        // Check if this is an attribute button field
        for (prefix, attributeName) in attributeMapping {
            if fieldName.hasPrefix(prefix + "-") {
                let components = fieldName.split(separator: "-")
                if components.count == 2, let level = Int(components[1]) {
                    let attributeValue = character.getAttributeValue(attribute: attributeName)
                    widget.widgetStringValue = (level <= attributeValue) ? "Yes" : "Off"
                    return
                }
            }
        }
        
        // Handle skill button fields
        fillSkillButtonField(fieldName: fieldName, widget: widget, character: character)
        
        // Handle merit/flaw button fields
        fillMeritFlawButtonField(fieldName: fieldName, widget: widget, character: character)
        
        // Handle specialization fields
        fillSpecializationField(fieldName: fieldName, widget: widget, character: character)
        
        // Handle conviction/touchstone fields
        fillConvictionTouchstoneField(fieldName: fieldName, widget: widget, character: character)
        
        // Handle discipline fields
        fillDisciplineField(fieldName: fieldName, widget: widget, character: character)
        
        // Handle other vampire-specific button fields
        fillVampireButtonFields(fieldName: fieldName, widget: widget, character: character)
    }
    
    private static func fillVampireButtonFields(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Handle Blood Potency, Humanity, Health, and Willpower button fields
        if let vampire = character as? VampireCharacter {
            // Blood Potency buttons
            if fieldName.hasPrefix("BloodPotency-") {
                let components = fieldName.split(separator: "-")
                if components.count == 2, let level = Int(components[1]) {
                    widget.widgetStringValue = (level <= vampire.bloodPotency) ? "Yes" : "Off"
                    return
                }
            }
            
            // Humanity buttons
            if fieldName.hasPrefix("Humanity-") {
                let components = fieldName.split(separator: "-")
                if components.count == 2, let level = Int(components[1]) {
                    widget.widgetStringValue = (level <= vampire.humanity) ? "Yes" : "Off"
                    return
                }
            }
        }
        
        // Health buttons (for all character types)
        if fieldName.hasPrefix("Health-") {
            let components = fieldName.split(separator: "-")
            if components.count == 2, let level = Int(components[1]) {
                widget.widgetStringValue = (level <= character.health) ? "Yes" : "Off"
                return
            }
        }
        
        // Willpower buttons (for all character types)
        if fieldName.hasPrefix("WP-") || fieldName.hasPrefix("cWill-") {
            let components = fieldName.split(separator: "-")
            if components.count == 2, let level = Int(components[1]) {
                widget.widgetStringValue = (level <= character.willpower) ? "Yes" : "Off"
                return
            }
        }
    }
    
    private static func fillSkillButtonField(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Map skill field names to actual skill names (based on PDF template field names)
        let skillMapping = [
            "Ath": "Athletics",
            "Bra": "Brawl", 
            "Cra": "Craft",
            "Dri": "Drive",
            "Fri": "Firearms",
            "Lar": "Larceny",
            "Mel": "Melee",
            "Ste": "Stealth",
            "Sur": "Survival",
            "AniKen": "Animal Ken",
            "Etiq": "Etiquette",
            "Insi": "Insight",
            "Inti": "Intimidation",
            "Lead": "Leadership",
            "Perf": "Performance",
            "Pers": "Persuasion",
            "Stre": "Streetwise",
            "Subt": "Subterfuge",
            "Acad": "Academics",
            "Awar": "Awareness",
            "Fina": "Finance",
            "Inve": "Investigation",
            "Medi": "Medicine",
            "Occu": "Occult",
            "Poli": "Politics",
            "Scie": "Science",
            "Tech": "Technology"
        ]
        
        for (fieldPrefix, skillName) in skillMapping {
            if fieldName.hasPrefix(fieldPrefix + "-") {
                let components = fieldName.split(separator: "-")
                if components.count == 2, let level = Int(components[1]) {
                    let skillValue = character.getSkillValue(skill: skillName)
                    widget.widgetStringValue = (level <= skillValue) ? "Yes" : "Off"
                    return
                }
            }
        }
    }
    
    private static func fillMeritFlawButtonField(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Handle Merit text fields (Merit1, Merit2, etc.)
        if fieldName.hasPrefix("Merit") && !fieldName.contains("-") {
            let pattern = "Merit(\\d+)"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: fieldName, options: [], range: NSRange(location: 0, length: fieldName.count)) {
                let indexRange = Range(match.range(at: 1), in: fieldName)!
                if let index = Int(fieldName[indexRange]) {
                    let meritIndex = index - 1 // Convert to 0-based indexing
                    
                    // Check advantages (merits) first
                    if meritIndex < character.advantages.count {
                        let merit = character.advantages[meritIndex]
                        widget.widgetStringValue = merit.name
                        return
                    }
                    
                    // Check background merits
                    let backgroundMeritIndex = meritIndex - character.advantages.count
                    if backgroundMeritIndex >= 0 && backgroundMeritIndex < character.backgroundMerits.count {
                        let merit = character.backgroundMerits[backgroundMeritIndex]
                        widget.widgetStringValue = merit.name
                        return
                    }
                }
            }
        }
        
        // Handle Merit button fields (Merit1-1, Merit1-2, etc.)
        if fieldName.hasPrefix("Merit") && fieldName.contains("-") {
            let pattern = "Merit(\\d+)-(\\d+)"
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: fieldName, options: [], range: NSRange(location: 0, length: fieldName.count)) {
                let meritIndexRange = Range(match.range(at: 1), in: fieldName)!
                let levelRange = Range(match.range(at: 2), in: fieldName)!
                
                if let meritIndex = Int(fieldName[meritIndexRange]),
                   let level = Int(fieldName[levelRange]) {
                    let meritIndex0 = meritIndex - 1 // Convert to 0-based indexing
                    
                    // Check advantages (merits) first
                    if meritIndex0 < character.advantages.count {
                        let merit = character.advantages[meritIndex0]
                        widget.widgetStringValue = (level <= merit.cost) ? "Yes" : "Off"
                        return
                    }
                    
                    // Check background merits
                    let backgroundMeritIndex = meritIndex0 - character.advantages.count
                    if backgroundMeritIndex >= 0 && backgroundMeritIndex < character.backgroundMerits.count {
                        let merit = character.backgroundMerits[backgroundMeritIndex]
                        widget.widgetStringValue = (level <= merit.cost) ? "Yes" : "Off"
                        return
                    }
                }
            }
        }
    }
    
    private static func fillSpecializationField(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Map specialization field names to skill names
        let specMapping = [
            "specAth": "Athletics",
            "specBra": "Brawl", 
            "specCra": "Craft",
            "specDri": "Drive",
            "specFir": "Firearms",
            "specLar": "Larceny",
            "specMel": "Melee",
            "specStea": "Stealth",
            "specSur": "Survival",
            "specAniKen": "Animal Ken",
            "specEtiq": "Etiquette",
            "specInsi": "Insight",
            "specInti": "Intimidation",
            "specLea": "Leadership",
            "specPerf": "Performance",
            "specPers": "Persuasion",
            "specStree": "Streetwise",
            "specSubt": "Subterfuge",
            "specAcad": "Academics",
            "specAwar": "Awareness",
            "specFina": "Finance",
            "specInve": "Investigation",
            "specMedi": "Medicine",
            "specOccu": "Occult",
            "specPoli": "Politics",
            "specScie": "Science",
            "specTech": "Technology"
        ]
        
        if let skillName = specMapping[fieldName] {
            let specs = character.getSpecializations(for: skillName)
            if !specs.isEmpty {
                // Fill with the first specialization found
                widget.widgetStringValue = specs[0].name
            }
        }
    }
    
    private static func fillConvictionTouchstoneField(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Handle conviction and touchstone fields based on actual field names
        switch fieldName {
        case "Convictions":
            // Fill with all convictions separated by newlines
            let convictions = character.convictions.joined(separator: "\n")
            widget.widgetStringValue = convictions
        case "touchstoneNotes":
            // Fill with all touchstones separated by newlines
            let touchstones = character.touchstones.joined(separator: "\n")
            widget.widgetStringValue = touchstones
        case "chronicleTenets":
            // Leave blank for manual fill
            widget.widgetStringValue = ""
        default:
            break
        }
    }
    
    private static func fillDisciplineField(fieldName: String, widget: PDFAnnotation, character: any BaseCharacter) {
        // Handle discipline fields for vampire characters
        if let vampire = character as? VampireCharacter {
            // Handle discipline name fields (Disc1, Disc2, etc.)
            if fieldName.hasPrefix("Disc") && fieldName.count <= 5 && !fieldName.contains("-") && !fieldName.contains("_") {
                let pattern = "Disc(\\d+)"
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   let match = regex.firstMatch(in: fieldName, options: [], range: NSRange(location: 0, length: fieldName.count)) {
                    let indexRange = Range(match.range(at: 1), in: fieldName)!
                    if let index = Int(fieldName[indexRange]) {
                        let disciplineIndex = index - 1 // Convert to 0-based indexing
                        if disciplineIndex < vampire.v5Disciplines.count {
                            widget.widgetStringValue = vampire.v5Disciplines[disciplineIndex].name
                        }
                    }
                }
            }
            
            // Handle discipline level button fields (Disc1-1, Disc1-2, etc.)
            if fieldName.hasPrefix("Disc") && fieldName.contains("-") {
                let pattern = "Disc(\\d+)-(\\d+)"
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   let match = regex.firstMatch(in: fieldName, options: [], range: NSRange(location: 0, length: fieldName.count)) {
                    let disciplineIndexRange = Range(match.range(at: 1), in: fieldName)!
                    let levelRange = Range(match.range(at: 2), in: fieldName)!
                    
                    if let disciplineIndex = Int(fieldName[disciplineIndexRange]),
                       let level = Int(fieldName[levelRange]) {
                        let disciplineIndex0 = disciplineIndex - 1 // Convert to 0-based indexing
                        if disciplineIndex0 < vampire.v5Disciplines.count {
                            let discipline = vampire.v5Disciplines[disciplineIndex0]
                            let disciplineLevel = discipline.currentLevel()
                            widget.widgetStringValue = (level <= disciplineLevel) ? "Yes" : "Off"
                        }
                    }
                }
            }
            
            // Handle discipline ability fields (Disc1_Ability1, etc.)
            if fieldName.contains("_Ability") {
                let pattern = "Disc(\\d+)_Ability(\\d+)"
                if let regex = try? NSRegularExpression(pattern: pattern, options: []),
                   let match = regex.firstMatch(in: fieldName, options: [], range: NSRange(location: 0, length: fieldName.count)) {
                    let disciplineIndexRange = Range(match.range(at: 1), in: fieldName)!
                    let abilityIndexRange = Range(match.range(at: 2), in: fieldName)!
                    
                    if let disciplineIndex = Int(fieldName[disciplineIndexRange]),
                       let abilityIndex = Int(fieldName[abilityIndexRange]) {
                        let disciplineIndex0 = disciplineIndex - 1 // Convert to 0-based indexing
                        if disciplineIndex0 < vampire.v5Disciplines.count {
                            let discipline = vampire.v5Disciplines[disciplineIndex0]
                            let allSelectedPowers = discipline.getAllSelectedPowerNames()
                            let abilityIndex0 = abilityIndex - 1 // Convert to 0-based indexing
                            if abilityIndex0 < allSelectedPowers.count {
                                let selectedPowersArray = Array(allSelectedPowers)
                                widget.widgetStringValue = selectedPowersArray[abilityIndex0]
                            }
                        }
                    }
                }
            }
        }
    }
    
    private static func generateCustomLayout(character: any BaseCharacter) -> Data? {
        // Create a clean, professional character sheet if fillable fields don't work
        let pageSize = CGSize(width: 612, height: 792) // Letter size
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        return renderer.pdfData { context in
            context.beginPage()
            
            // Set up the graphics context
            let cgContext = context.cgContext
            UIGraphicsPushContext(cgContext)
            
            // Create a clean, form-style character sheet
            switch character.characterType {
            case .vampire:
                if let vampire = character as? VampireCharacter {
                    drawVampireSheet(vampire: vampire, pageSize: pageSize)
                }
            case .ghoul:
                if let ghoul = character as? GhoulCharacter {
                    drawGhoulSheet(ghoul: ghoul, pageSize: pageSize)
                }
            case .mage:
                if let mage = character as? MageCharacter {
                    drawMageSheet(mage: mage, pageSize: pageSize)
                }
            }
            
            UIGraphicsPopContext()
        }
    }
    
    // MARK: - Clean Form-Style Layout Methods
    
    private static func drawVampireSheet(vampire: VampireCharacter, pageSize: CGSize) {
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        // Title
        drawFormTitle(text: "VAMPIRE: THE MASQUERADE 5TH EDITION", y: &currentY, pageSize: pageSize)
        currentY += 20
        
        // Character Information Section
        drawSectionHeader(text: "CHARACTER INFORMATION", y: &currentY, pageSize: pageSize)
        drawFormField(label: "Name:", value: vampire.name, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Concept:", value: vampire.concept, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Chronicle:", value: vampire.chronicleName, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Player:", value: "_________________", y: &currentY, pageSize: pageSize)
        currentY += 10
        
        // Vampire Specifics
        drawFormField(label: "Clan:", value: vampire.clan, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Generation:", value: "\(vampire.generation)", y: &currentY, pageSize: pageSize)
        drawFormField(label: "Predator Type:", value: vampire.predatorType, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Sire:", value: "_________________", y: &currentY, pageSize: pageSize)
        currentY += 10
        
        drawFormField(label: "Ambition:", value: vampire.ambition, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Desire:", value: vampire.desire, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        // Attributes
        drawAttributesSection(character: vampire, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        // Skills  
        drawSkillsSection(character: vampire, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        // Health and Willpower (always blank boxes)
        drawHealthWillpowerSection(character: vampire, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        // Vampire Traits
        drawVampireTraitsSection(vampire: vampire, y: &currentY, pageSize: pageSize)
    }
    
    private static func drawGhoulSheet(ghoul: GhoulCharacter, pageSize: CGSize) {
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        drawFormTitle(text: "GHOUL CHARACTER SHEET", y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawSectionHeader(text: "CHARACTER INFORMATION", y: &currentY, pageSize: pageSize)
        drawFormField(label: "Name:", value: ghoul.name, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Concept:", value: ghoul.concept, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Chronicle:", value: ghoul.chronicleName, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Player:", value: "_________________", y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawAttributesSection(character: ghoul, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawSkillsSection(character: ghoul, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawHealthWillpowerSection(character: ghoul, y: &currentY, pageSize: pageSize)
    }
    
    private static func drawMageSheet(mage: MageCharacter, pageSize: CGSize) {
        let margin: CGFloat = 50
        var currentY: CGFloat = margin
        
        drawFormTitle(text: "MAGE CHARACTER SHEET", y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawSectionHeader(text: "CHARACTER INFORMATION", y: &currentY, pageSize: pageSize)
        drawFormField(label: "Name:", value: mage.name, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Concept:", value: mage.concept, y: &currentY, pageSize: pageSize)
        drawFormField(label: "Chronicle:", value: mage.chronicleName, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawAttributesSection(character: mage, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawSkillsSection(character: mage, y: &currentY, pageSize: pageSize)
        currentY += 20
        
        drawHealthWillpowerSection(character: mage, y: &currentY, pageSize: pageSize)
        currentY += 40
        
        drawText(text: "Mage character sheet implementation in progress", x: 50, y: currentY, fontSize: 12, color: .gray)
    }
    
    // MARK: - Form Drawing Helper Methods
    
    private static func drawFormTitle(text: String, y: inout CGFloat, pageSize: CGSize) {
        drawText(text: text, x: pageSize.width / 2, y: y, fontSize: 18, bold: true, centered: true)
        y += 25
    }
    
    private static func drawSectionHeader(text: String, y: inout CGFloat, pageSize: CGSize) {
        drawText(text: text, x: 50, y: y, fontSize: 14, bold: true, color: .systemRed)
        drawLine(x1: 50, y1: y + 2, x2: pageSize.width - 50, y2: y + 2, color: .systemRed)
        y += 20
    }
    
    private static func drawFormField(label: String, value: String, y: inout CGFloat, pageSize: CGSize) {
        drawText(text: label, x: 50, y: y, fontSize: 11, bold: true)
        drawText(text: value, x: 150, y: y, fontSize: 11)
        drawLine(x1: 150, y1: y + 2, x2: 450, y2: y + 2)
        y += 18
    }
    
    private static func drawAttributesSection(character: any BaseCharacter, y: inout CGFloat, pageSize: CGSize) {
        drawSectionHeader(text: "ATTRIBUTES", y: &y, pageSize: pageSize)
        
        let attributes = [
            ("Physical", ["Strength", "Dexterity", "Stamina"]),
            ("Social", ["Charisma", "Manipulation", "Composure"]),
            ("Mental", ["Intelligence", "Wits", "Resolve"])
        ]
        
        let startX: CGFloat = 50
        let columnWidth: CGFloat = 150
        
        for (index, (category, attributeList)) in attributes.enumerated() {
            let x = startX + CGFloat(index) * columnWidth
            
            drawText(text: category, x: x, y: y, fontSize: 12, bold: true)
            var attrY = y + 15
            
            for attribute in attributeList {
                let value = character.getAttributeValue(attribute: attribute)
                let dots = generateDotString(value: value, max: 5)
                
                drawText(text: attribute, x: x, y: attrY, fontSize: 10)
                drawText(text: dots, x: x + 80, y: attrY, fontSize: 10)
                attrY += 15
            }
        }
        
        y += 80
    }
    
    private static func drawSkillsSection(character: any BaseCharacter, y: inout CGFloat, pageSize: CGSize) {
        drawSectionHeader(text: "SKILLS", y: &y, pageSize: pageSize)
        
        let skillCategories = [
            ("Physical", ["Athletics", "Brawl", "Craft", "Drive", "Firearms", "Larceny", "Melee", "Stealth", "Survival"]),
            ("Social", ["Animal Ken", "Etiquette", "Insight", "Intimidation", "Leadership", "Performance", "Persuasion", "Streetwise", "Subterfuge"]),
            ("Mental", ["Academics", "Awareness", "Finance", "Investigation", "Medicine", "Occult", "Politics", "Science", "Technology"])
        ]
        
        let startX: CGFloat = 50
        let columnWidth: CGFloat = 150
        
        for (index, (category, skillList)) in skillCategories.enumerated() {
            let x = startX + CGFloat(index) * columnWidth
            
            drawText(text: category, x: x, y: y, fontSize: 12, bold: true)
            var skillY = y + 15
            
            for skill in skillList {
                let value = character.getSkillValue(skill: skill)
                let dots = generateDotString(value: value, max: 5)
                
                drawText(text: skill, x: x, y: skillY, fontSize: 9)
                drawText(text: dots, x: x + 80, y: skillY, fontSize: 10)
                skillY += 12
            }
        }
        
        y += 130
    }
    
    private static func drawHealthWillpowerSection(character: any BaseCharacter, y: inout CGFloat, pageSize: CGSize) {
        drawSectionHeader(text: "HEALTH & WILLPOWER", y: &y, pageSize: pageSize)
        
        // Health boxes (always blank)
        drawText(text: "Health:", x: 50, y: y, fontSize: 11, bold: true)
        let healthBoxes = String(repeating: "□ ", count: character.health)
        drawText(text: healthBoxes, x: 120, y: y, fontSize: 12)
        y += 18
        
        // Willpower boxes (always blank)
        drawText(text: "Willpower:", x: 50, y: y, fontSize: 11, bold: true)
        let willpowerBoxes = String(repeating: "□ ", count: character.willpower)
        drawText(text: willpowerBoxes, x: 120, y: y, fontSize: 12)
        y += 25
    }
    
    private static func drawVampireTraitsSection(vampire: VampireCharacter, y: inout CGFloat, pageSize: CGSize) {
        drawSectionHeader(text: "VAMPIRE TRAITS", y: &y, pageSize: pageSize)
        
        drawFormField(label: "Blood Potency:", value: "\(vampire.bloodPotency)", y: &y, pageSize: pageSize)
        drawFormField(label: "Humanity:", value: "\(vampire.humanity)", y: &y, pageSize: pageSize)
        drawFormField(label: "Hunger:", value: "\(vampire.hunger)", y: &y, pageSize: pageSize)
        
        // Clan information
        drawFormField(label: "Clan Bane:", value: vampire.getClanBane(), y: &y, pageSize: pageSize)
        drawFormField(label: "Clan Compulsion:", value: vampire.getClanCompulsion(), y: &y, pageSize: pageSize)
        
        // Experience
        drawFormField(label: "Total Experience:", value: "\(vampire.experience)", y: &y, pageSize: pageSize)
        drawFormField(label: "Spent Experience:", value: "\(vampire.spentExperience)", y: &y, pageSize: pageSize)
    }
    
    private static func drawText(text: String, x: CGFloat, y: CGFloat, fontSize: CGFloat = 10, bold: Bool = false, color: UIColor = .black, centered: Bool = false) {
        let font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textSize = attributedString.size()
        
        let drawX = centered ? x - (textSize.width / 2) : x
        attributedString.draw(at: CGPoint(x: drawX, y: y))
    }
    
    private static func drawLine(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, color: UIColor = .black) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(1.0)
        context?.move(to: CGPoint(x: x1, y: y1))
        context?.addLine(to: CGPoint(x: x2, y: y2))
        context?.strokePath()
    }
    
    private static func generateDotString(value: Int, max: Int) -> String {
        let filled = String(repeating: "●", count: value)
        let empty = String(repeating: "○", count: max - value)
        return filled + empty
    }
}