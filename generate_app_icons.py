#!/usr/bin/env python3
"""
Generate Flutter app icons with brand blue color (#30588C)
This script creates adaptive icons for Android and iOS with the brand colors.
"""

from PIL import Image, ImageDraw
import os
from pathlib import Path

# Brand colors
BRAND_PRIMARY_BLUE = "#30588C"  # Main brand color
BRAND_DEEP_BLUE = "#2E608C"    # Headers, emphasis, navigation
BRAND_MUTED_STEEL_BLUE = "#3D5A73"  # Secondary UI elements

# Android icon sizes (mdpi = 48x48 as base, others are scaled)
ANDROID_SIZES = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
}

def create_android_icon(size, brand_color):
    """Create a simple Android app icon with brand color background and white app icon."""
    img = Image.new('RGBA', (size, size), color=brand_color)
    draw = ImageDraw.Draw(img)
    
    # Draw a simple white app icon in the center (e.g., shopping bag or box shape)
    padding = size // 4
    x1, y1 = padding, padding
    x2, y2 = size - padding, size - padding
    
    # Draw white circle as background for icon
    draw.ellipse([x1, y1, x2, y2], fill='white')
    
    # Draw a simple box/package shape inside
    inner_padding = size // 3
    box_x1 = inner_padding
    box_y1 = inner_padding + (size // 8)
    box_x2 = size - inner_padding
    box_y2 = size - inner_padding
    
    draw.rectangle([box_x1, box_y1, box_x2, box_y2], outline=brand_color, width=2)
    
    return img

def create_ios_icon(size, brand_color):
    """Create iOS app icon with brand color background."""
    img = Image.new('RGBA', (size, size), color=brand_color)
    draw = ImageDraw.Draw(img)
    
    # Add rounded corners effect and simple centered icon
    padding = size // 4
    x1, y1 = padding, padding
    x2, y2 = size - padding, size - padding
    
    # Draw white circle
    draw.ellipse([x1, y1, x2, y2], fill='white')
    
    return img

def generate_android_icons():
    """Generate Android app icons."""
    print("Generating Android app icons...")
    
    base_path = Path("android/app/src/main/res")
    
    for density, size in ANDROID_SIZES.items():
        dir_path = base_path / f"mipmap-{density}"
        dir_path.mkdir(parents=True, exist_ok=True)
        
        # Create launcher icon
        icon = create_android_icon(size, BRAND_PRIMARY_BLUE)
        icon_path = dir_path / "ic_launcher.png"
        icon.save(icon_path, 'PNG')
        print(f"  ✓ Created {icon_path} ({size}x{size})")
        
        # Create background
        bg = Image.new('RGBA', (size, size), color=BRAND_PRIMARY_BLUE)
        bg_path = dir_path / "ic_launcher_background.png"
        bg.save(bg_path, 'PNG')
        
        # Create foreground (white circle with icon)
        fg = create_android_icon(size, 'white')
        fg_path = dir_path / "ic_launcher_foreground.png"
        fg.save(fg_path, 'PNG')

def generate_ios_icons():
    """Generate iOS app icons."""
    print("\nGenerating iOS app icons...")
    
    # iOS icon sizes (width x height)
    ios_sizes = {
        'AppIcon-20@2x.png': 40,
        'AppIcon-20@3x.png': 60,
        'AppIcon-20@2x~ipad.png': 40,
        'AppIcon-20~ipad.png': 20,
        'AppIcon-29.png': 29,
        'AppIcon-29@2x.png': 58,
        'AppIcon-29@3x.png': 87,
        'AppIcon-29@2x~ipad.png': 58,
        'AppIcon-29~ipad.png': 29,
        'AppIcon-40@2x.png': 80,
        'AppIcon-40@3x.png': 120,
        'AppIcon-40@2x~ipad.png': 80,
        'AppIcon-40~ipad.png': 40,
        'AppIcon-60@2x~car.png': 120,
        'AppIcon-60@3x~car.png': 180,
        'AppIcon-83.5@2x~ipad.png': 167,
        'AppIcon@2x.png': 120,
        'AppIcon@3x.png': 180,
        'AppIcon@2x~ipad.png': 152,
        'AppIcon@3x.png': 180,
        'AppIcon~ipad.png': 76,
        'AppIcon~ios-marketing.png': 1024,
    }
    
    base_path = Path("ios/Runner/Assets.xcassets/AppIcon.appiconset")
    
    for filename, size in ios_sizes.items():
        icon = create_ios_icon(size, BRAND_PRIMARY_BLUE)
        icon_path = base_path / filename
        icon.save(icon_path, 'PNG')
        print(f"  ✓ Created {icon_path} ({size}x{size})")

def main():
    """Main entry point."""
    print("=" * 60)
    print("Flutter App Icon Generator")
    print("Brand Color: #30588C (Primary Blue)")
    print("=" * 60)
    
    try:
        generate_android_icons()
        generate_ios_icons()
        print("\n" + "=" * 60)
        print("✓ Successfully generated all app icons!")
        print("=" * 60)
    except Exception as e:
        print(f"\n✗ Error generating icons: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
