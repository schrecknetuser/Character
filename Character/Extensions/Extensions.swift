import SwiftUI

// String extension for trimming whitespace
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// UI Layout Constants
struct UIConstants {
    // MARK: - Base Constants (iOS Design Standards)
    
    /// Standard iOS tab bar height (can vary with safe area, but 49pt is the content height)
    private static let iOSTabBarContentHeight: CGFloat = 49
    
    /// Standard floating action button size following Material Design guidelines
    private static let standardFABSize: CGFloat = 56
    
    /// Standard spacing between UI elements
    private static let standardSpacing: CGFloat = 16
    
    /// Standard margin from screen edges
    private static let standardMargin: CGFloat = 20
    
    // MARK: - Public Interface
    
    /// Size for floating action buttons
    static var floatingButtonSize: CGFloat {
        return standardFABSize
    }
    
    /// Spacing between floating buttons
    static var floatingButtonSpacing: CGFloat {
        return standardSpacing
    }
    
    /// Spacing from screen edges
    static var screenEdgeSpacing: CGFloat {
        return standardMargin
    }
    
    /// Spacing between buttons and tab bar
    static var buttonTabBarSpacing: CGFloat {
        return 5
    }
    
    // MARK: - Dynamic Calculations
    
    /// Calculate bottom padding for content to prevent button overlap
    static func contentBottomPadding() -> CGFloat {
        return floatingButtonSize + buttonTabBarSpacing
    }
    
    /// Calculate bottom padding for floating buttons positioning
    static func floatingButtonBottomPadding() -> CGFloat {
        return iOSTabBarContentHeight + buttonTabBarSpacing
    }
}


