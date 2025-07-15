# Predator Paths Implementation

This implementation adds predator paths to vampire character creation in the Vampire: The Masquerade V5 character app.

## Features Added

### 10 Canonical Predator Paths
- **Alleycat**: Street hunter (Athletics Parkour, Larceny Security, Obvious Predator flaw)
- **Bagger**: Blood bank feeder (Resources merit, Larceny Security, feeding restrictions)
- **Blood Leech**: Vampire hunter (Brawl Grappling, Stealth Ambush, Enemy flaw)
- **Cleaver**: Mundane life maintainer (Herd merit, Subterfuge Innocent Face, Dark Secret)
- **Consensualist**: Willing victim feeder (Medicine Phlebotomy, Persuasion Seduction)
- **Farmer**: Animal feeder (Animalism 1, Animal Ken specialization, feeding inefficiency)
- **Osiris**: Cult leader (Herd 3, Leadership Cult, follower responsibility)
- **Sandman**: Sleep feeder (Stealth Breaking and Entering, Medicine Anesthesiology, Dark Secret)
- **Scene Queen**: Party hunter (Etiquette High Society, Performance Dancing)
- **Siren**: Seducer (Persuasion Seduction, Subterfuge Lies, Enemy flaw)

### Rich Bonus System
- Skill specializations
- Discipline dots
- Merits and flaws
- Feeding descriptions and restrictions

### Seamless Integration
- New stage in character creation wizard (after clan selection)
- Only affects vampire characters
- Proper navigation and validation
- Comprehensive test coverage

## Files Modified
- `Character/Characters/HelperStructs.swift` - Added data structures
- `Character/Characters/Constants.swift` - Added predator path definitions
- `Character/Characters/VampireCharacter.swift` - Added predator path property
- `Character/Creation/CharacterCreationWizard.swift` - Added wizard stage
- `Character/Creation/PredatorPathSelectionStage.swift` - New UI component
- `CharacterTests/PredatorPathTests.swift` - New test suite

## Usage
Players now select a predator path during vampire character creation, which provides:
1. Mechanical bonuses (specializations, disciplines, merits)
2. Drawbacks and restrictions
3. Feeding guidance and style

The implementation follows V5 rules and provides meaningful character differentiation based on hunting methods.