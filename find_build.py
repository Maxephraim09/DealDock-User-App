from pathlib import Path

p = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
text = p.read_text(encoding='utf-8')
lines = text.splitlines()

# Find line 36
print("Line 36:", lines[35])
print()

# Find the _buildRestaurantView function
for i, line in enumerate(lines):
    if 'def _buildRestaurantView' in line or '_buildRestaurantView' in line and 'Widget' in line:
        print(f"Line {i+1}: {line}")
        for j in range(i, min(i+30, len(lines))):
            print(f"Line {j+1}: {lines[j]}")
        break
