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
            return Vampire()
        case .mage:
            return Vampire()
        case .ghoul:
            return Vampire()
        }
    }

    // MARK: - Type-safe downcasts

    var asVampire: Vampire? {
        character as? Vampire
    }

    /*var asMage: Mage? {
        character as? Mage
    }

    var asGhoul: Ghoul? {
        character as? Ghoul
    }*/
    
    var asVampireForced: Vampire {
        character as! Vampire
    }

    // MARK: - SwiftUI Bindings

    var vampireBinding: Binding<Vampire>? {
        guard let vampire = character as? Vampire else { return nil }
        return Binding(
            get: { vampire },
            set: { [weak self] newValue in
                self?.character = newValue
            }
        )
    }

    /*var mageBinding: Binding<Mage>? {
        binding(as: Mage.self)
    }

    var ghoulBinding: Binding<Ghoul>? {
        binding(as: Ghoul.self)
    }*/

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
