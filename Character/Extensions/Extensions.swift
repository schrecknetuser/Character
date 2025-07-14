import SwiftUI

// String extension for trimming whitespace
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// UI Layout Constants
struct UIConstants {
    // Button constants
    static let floatingButtonSize: CGFloat = 56
    static let floatingButtonSpacing: CGFloat = 16
    static let screenEdgeSpacing: CGFloat = 20
    
    // Tab bar constants
    static let standardTabBarHeight: CGFloat = 49
    
    // Spacing constants
    static let buttonTabBarSpacing: CGFloat = 20
    
    // Calculated bottom padding for content to prevent button overlap
    static func contentBottomPadding(safeAreaBottom: CGFloat = 0) -> CGFloat {
        return floatingButtonSize + buttonTabBarSpacing + standardTabBarHeight + screenEdgeSpacing
    }
    
    // Calculated bottom padding for floating buttons
    static func floatingButtonBottomPadding(safeAreaBottom: CGFloat) -> CGFloat {
        return safeAreaBottom + standardTabBarHeight + buttonTabBarSpacing
    }
}


