//
//  CharacterCreationViewModel.swift
//  Character
//
//  Created by User on 12.07.2025.
//


import SwiftUI

class CharacterCreationViewModel: ObservableObject {
    @Published var character: any BaseCharacter

    init(characterType: CharacterType) {
        self.character = Self.createCharacter(of: characterType)
    }

    func setCharacterType(_ type: CharacterType) {
        self.character = Self.createCharacter(of: type)
    }

    static func createCharacter(of type: CharacterType) -> any BaseCharacter {
        switch type {
        case .vampire:
            return VampireCharacter()
        case .ghoul:
            return GhoulCharacter()
        case .mage:
            return MageCharacter()
        }
    }

    // MARK: - Type-safe downcasts

    var asVampire: VampireCharacter? {
        character as? VampireCharacter
    }

    var asGhoul: GhoulCharacter? {
        character as? GhoulCharacter
    }

    var asMage: MageCharacter? {
        character as? MageCharacter
    }
    
    var asVampireForced: VampireCharacter {
        character as! VampireCharacter
    }

    var asGhoulForced: GhoulCharacter {
        character as! GhoulCharacter
    }

    var asMageForced: MageCharacter {
        character as! MageCharacter
    }

    // MARK: - SwiftUI Bindings

    func vampireBinding() -> Binding<VampireCharacter>? {
        guard let _ = character as? VampireCharacter else { return nil }
        return Binding(
            get: {
                self.character as! VampireCharacter
            },
            set: {
                self.character = $0
            }
        )
    }
    
    func ghoulBinding() -> Binding<GhoulCharacter>? {
        guard let _ = character as? GhoulCharacter else { return nil }
        return Binding(
            get: {
                self.character as! GhoulCharacter
            },
            set: {
                self.character = $0
            }
        )
    }
    
    func mageBinding() -> Binding<MageCharacter>? {
        guard let _ = character as? MageCharacter else { return nil }
        return Binding(
            get: {
                self.character as! MageCharacter
            },
            set: {
                self.character = $0
            }
        )
    }

    private func binding<T: BaseCharacter>(as type: T.Type) -> Binding<T>? {
        guard let casted = character as? T else { return nil }
        return Binding<T>(
            get: { casted },
            set: { self.character = $0 }
        )
    }

    // MARK: - General binding (use cautiously if you know the type)

    var baseBinding: Binding<any BaseCharacter> {
        Binding(
            get: { self.character },
            set: { self.character = $0 }
        )
    }
}
