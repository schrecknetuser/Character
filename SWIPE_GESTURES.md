# Swipe Gesture Implementation

## Overview
Added swipe gesture support to the character detail view tabs to allow users to navigate between tabs by swiping left or right.

## How It Works

### Swipe Directions
- **Swipe Left**: Moves to the next tab (right direction)
- **Swipe Right**: Moves to the previous tab (left direction)

### Behavior
- Swipes are only triggered when the horizontal movement exceeds 50 points
- Swipes at the tab boundaries do nothing (as requested)
- Only horizontal swipes are processed (more horizontal than vertical movement)

### Tab Structure
All character types have 6 tabs in the following order:

1. **Character** (tab 0) - Always present
2. **Status** (tab 1) - Character type specific (Vampire/Ghoul/Mage)
3. **Attributes & Skills** (tab 2) - Always present  
4. **Disciplines/Spheres** (tab 3) - Character type specific
   - Vampires and Ghouls: "Disciplines"
   - Mages: "Spheres"
5. **Merits & Flaws** (tab 4) - Always present
6. **Data** (tab 5) - Always present

### Implementation Details

#### State Management
```swift
@State private var selectedTab = 0
```

#### Tab Selection
```swift
TabView(selection: $selectedTab) {
    // Tab content with .tag() modifiers
}
```

#### Gesture Recognition
```swift
.gesture(
    DragGesture()
        .onEnded { value in
            let horizontalAmount = value.translation.x
            let verticalAmount = value.translation.y
            
            // Only process horizontal swipes
            if abs(horizontalAmount) > abs(verticalAmount) {
                if horizontalAmount > 50 {
                    // Swipe right (previous tab)
                    handleSwipe(direction: .right)
                } else if horizontalAmount < -50 {
                    // Swipe left (next tab)
                    handleSwipe(direction: .left)
                }
            }
        }
)
```

#### Boundary Handling
```swift
private func handleSwipe(direction: SwipeDirection) {
    let maxTabIndex = availableTabs.count - 1
    
    switch direction {
    case .left:
        // Swipe left moves to next tab (right)
        if selectedTab < maxTabIndex {
            selectedTab += 1
        }
    case .right:
        // Swipe right moves to previous tab (left)
        if selectedTab > 0 {
            selectedTab -= 1
        }
    }
}
```

## Testing
The implementation includes comprehensive tests in `SwipeGestureTests.swift` that verify:
- Tab boundary behavior for all character types
- Swipe direction logic
- Navigation limits at first and last tabs
- Threshold requirements for gesture recognition

## User Experience
- Natural swipe gestures for tab navigation
- Visual feedback through tab transitions
- Consistent behavior across all character types
- No disruption to existing tap-to-select tab functionality