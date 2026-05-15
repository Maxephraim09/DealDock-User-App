from pathlib import Path
import re

p = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
text = p.read_text(encoding='utf-8')
lines = text.splitlines()

# Find the main children: [ in the body parameter (around line 431)
print("Looking for the main body children: [")
print()

# Scan from the body: line and trace opening/closing
for start_line in [420, 430, 440]:
    if start_line < len(lines):
        print(f"Checking around line {start_line}:")
        stack = []
        opened_at = {}
        for lineno in range(start_line, min(start_line + 20, len(lines))):
            line = lines[lineno]
            open_count = line.count('[')
            close_count = line.count(']')
            print(f"  Line {lineno+1:4d}: +{open_count}  -{close_count}  | {line[:70]}")
            stack.append((open_count - close_count))
        total = sum(stack)
        print(f"  Total nesting: {total}")
        print()
