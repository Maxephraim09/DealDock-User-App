from pathlib import Path
text = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart').read_text()
lines = text.splitlines()
for i in range(1175, min(1195, len(lines))):
    print(f'{i+1:4d}: {lines[i][:100]}')
