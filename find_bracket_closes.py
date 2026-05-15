from pathlib import Path

p = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
text = p.read_text(encoding='utf-8')
lines = text.splitlines()

# Count nesting for brackets from line 431 to 1186
open_depth = 0
open_locations = []

for lineno in range(430, 1186):  # Start from line 431 (0-indexed 430)
    line = lines[lineno]
    in_single = False
    in_double = False
    
    for i, ch in enumerate(line):
        if in_single:
            if ch == "'":
                in_single = False
        elif in_double:
            if ch == '"':
                in_double = False
        else:
            if ch == "'":
                in_single = True
            elif ch == '"':
                in_double = True
            elif ch == '[':
                open_depth += 1
                open_locations.append((lineno + 1, ch, open_depth))
            elif ch == ']':
                open_depth -= 1
                if open_depth < 0:
                    print(f"ERROR: Bracket depth went negative at line {lineno+1}")
                    print(f"  Recent opens: {open_locations[-5:]}")
                    break
                # Print when we close major bracket levels
                if len(open_locations) > 0:
                    last_open_line = open_locations[-1][0]
                    open_locations.pop()
                    if open_depth == 0:
                        print(f"Line {lineno+1}: Closed bracket from line {last_open_line}, depth now 0")
                    elif open_depth == 1 and last_open_line == 431:
                        print(f"Line {lineno+1}: Closed MAIN bracket from line 431, depth now 1")

print(f"\nFinal bracket depth: {open_depth}")
if open_depth > 0:
    print(f"Unclosed brackets: {open_locations}")
