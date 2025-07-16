# QR Code Import/Export Feature

This document describes the QR Code import/export functionality that allows sharing character data between devices.

## Features

### Export Character Data
- **Location**: Character Detail View (floating action button with QR code icon)
- **Functionality**: Generates a QR code containing all character data encoded as JSON
- **UI**: Green floating action button next to Status and Data buttons
- **Features**:
  - Shows character summary before QR code
  - Displays large, scannable QR code
  - Share button to save or send QR code image
  - High error correction for reliable scanning

### Import Character Data
- **Location**: Main Characters List (navigation bar, left side)
- **Functionality**: Uses camera to scan QR codes and import character data
- **UI**: QR viewfinder icon in navigation bar
- **Features**:
  - Camera preview with scanning overlay
  - Automatic QR code detection
  - Character import confirmation dialog
  - Error handling for invalid QR codes

## Technical Implementation

### Files Added
1. `Character/Utilities/QRCodeUtilities.swift` - Core QR generation and scanning logic
2. `Character/Display/QRDisplayModalView.swift` - QR code display modal
3. `Character/Display/QRScannerModalView.swift` - Camera scanning modal
4. `CharacterTests/QRCodeTests.swift` - Unit tests for QR functionality

### Dependencies Used
- **Core Image**: For QR code generation using CIFilter.qrCodeGenerator()
- **AVFoundation**: For camera access and QR code scanning
- **SwiftUI**: For UI components and modal presentations

### Data Format
Characters are encoded as JSON using the existing `AnyCharacter` wrapper that handles all character types (Vampire, Mage, Ghoul). The JSON contains all character data including:
- Basic information (name, concept, chronicle)
- Attributes and skills
- Character-specific data (clan, disciplines, spheres, etc.)
- Background information and notes
- Change log and session data

## Required Configuration

### iOS Project Settings
To use the camera scanning functionality, you need to add camera permissions to your project:

1. **Info.plist Configuration**:
   Add the following key-value pair to your Info.plist:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access to scan QR codes for character import.</string>
   ```

2. **Privacy Settings**:
   The app requests camera permission when the QR scanner is first opened. Users must grant permission for the scanning feature to work.

### Error Handling
- **Camera Access Denied**: Shows alert explaining camera permission is required
- **Invalid QR Code**: Shows alert when scanned code doesn't contain valid character data
- **Import Failure**: Handles JSON parsing errors gracefully

## Usage Instructions

### Exporting a Character
1. Open any character in the Character Detail View
2. Tap the green QR code floating action button (bottom right)
3. View the character summary and QR code
4. Optionally tap "Share" to save or send the QR code image
5. Tap "Close" when finished

### Importing a Character
1. From the main Characters list, tap the QR viewfinder icon (top left)
2. Allow camera access when prompted
3. Point camera at a QR code containing character data
4. Review the import confirmation dialog
5. Tap "Import" to add the character to your collection

## Testing

Unit tests are provided in `QRCodeTests.swift` that verify:
- QR code generation from character data
- Character data encoding/decoding
- Character summary generation
- Error handling for invalid data

## Future Enhancements

Potential improvements could include:
- Batch export/import of multiple characters
- QR code customization (size, error correction level)
- Export filters (exclude certain data like change logs)
- Cloud-based sharing as alternative to QR codes