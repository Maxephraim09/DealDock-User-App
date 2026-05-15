# Brand Color Update - Code Reference

## Color Constants Reference

### Theme Colors (`lib/themes/app_them_data.dart`)

```dart
// === Brand Colors ===
static const Color brandPrimaryBlue = Color(0xFF30588C);        // Main brand color
static const Color brandDeepBlue = Color(0xFF2E608C);           // Headers, emphasis, navigation
static const Color brandMutedSteelBlue = Color(0xFF3D5A73);    // Secondary UI elements
```

## Theme Implementation (`lib/themes/styles.dart`)

### Updated ThemeData

**Before:**
```dart
primaryColor: isDarkTheme ? AppThemeData.dangerDark300 : AppThemeData.danger300,
```

**After:**
```dart
primaryColor: isDarkTheme ? AppThemeData.brandDeepBlue : AppThemeData.brandPrimaryBlue,
```

### Theme Color Usage

The primary color is now used throughout the app:

```dart
// In widgets, use:
color: Theme.of(context).primaryColor

// Or use brand colors directly:
color: AppThemeData.brandPrimaryBlue
color: AppThemeData.brandDeepBlue
color: AppThemeData.brandMutedSteelBlue
```

## Color Usage Examples

### Example 1: App Bar with Brand Color
```dart
AppBar(
  backgroundColor: Theme.of(context).primaryColor,  // Now shows brand blue
  title: Text('My App'),
)
```

### Example 2: Button with Brand Color
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,  // Brand blue
  ),
  onPressed: () {},
  child: Text('Action'),
)
```

### Example 3: Text with Brand Color
```dart
Text(
  'Highlighted Text',
  style: AppThemeData.semiBoldTextStyle(
    color: AppThemeData.brandPrimaryBlue,
  ),
)
```

## Available Color Constants for Use

### Brand Colors
- `AppThemeData.brandPrimaryBlue` (#30588C) - Main actions and UI
- `AppThemeData.brandDeepBlue` (#2E608C) - Headers and emphasis
- `AppThemeData.brandMutedSteelBlue` (#3D5A73) - Secondary elements

### Status Colors (Still Available)
- `AppThemeData.success400` - Success states
- `AppThemeData.danger300` - Error/warning states
- `AppThemeData.warning300` - Warning states
- `AppThemeData.info300` - Information states

### Neutral Colors
- `AppThemeData.grey50` to `AppThemeData.grey900` - Grayscale spectrum

## Implementation Guide

### Step 1: Update Existing UI Elements

For buttons:
```dart
// Old (if using red/danger):
onPressed: () {},

// New (now uses brand blue):
onPressed: () {},
// No changes needed! Theme is applied automatically
```

### Step 2: Gradual Migration

No immediate changes needed for hard-coded colors. They can be migrated incrementally:

```dart
// Can be updated to:
style: TextStyle(color: AppThemeData.brandPrimaryBlue)

// Or use theme:
style: TextStyle(color: Theme.of(context).primaryColor)
```

### Step 3: Dark Mode Support

Dark theme automatically uses the correct color:
```dart
// Light mode: #30588C (Primary Blue)
// Dark mode: #2E608C (Deep Blue)
// Automatically determined by themeController.themeMode
```

## Testing Checklist

- [ ] App bar displays with brand blue (#30588C)
- [ ] Buttons use brand blue by default
- [ ] Dark mode displays deep blue (#2E608C)
- [ ] App icons show brand blue background
- [ ] No compilation errors
- [ ] All screens render correctly
- [ ] Cross-platform consistency (Android & iOS)

## Customization

### Change Brand Color Globally

Edit in `lib/themes/app_them_data.dart`:

```dart
static const Color brandPrimaryBlue = Color(0xFFYOURCOLOR);
```

All components using `Theme.of(context).primaryColor` will update automatically.

### Override in Specific Widget

```dart
Container(
  color: AppThemeData.brandMutedSteelBlue,  // Use secondary color here
)
```

## App Icons

All icons have been regenerated with the brand blue color (#30588C):

### Android Icons
- Location: `android/app/src/main/res/mipmap-*/`
- Sizes: 48x48, 72x72, 96x96, 144x144, 192x192

### iOS Icons
- Location: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Sizes: 20x20 to 1024x1024 (all variants)

## Files Modified

1. **lib/themes/app_them_data.dart**
   - Added brand color constants

2. **lib/themes/styles.dart**
   - Updated primaryColor to use brand colors

3. **Android & iOS icon assets**
   - Regenerated with brand blue background

## Rollback Instructions

If you need to revert to the previous color scheme:

```dart
// In lib/themes/styles.dart
primaryColor: isDarkTheme ? AppThemeData.dangerDark300 : AppThemeData.danger300,
```

## Performance Impact

- **No impact** - Colors are compile-time constants
- **Memory**: Minimal (just a few additional color definitions)
- **Runtime**: No additional overhead

## Browser/Device Compatibility

- ✓ All Android versions (API 16+)
- ✓ All iOS versions (iOS 11+)
- ✓ Web platforms
- ✓ All screen densities and sizes

---

**Last Updated:** April 24, 2026
**Version:** 1.0
