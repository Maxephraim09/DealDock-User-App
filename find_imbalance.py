from pathlib import Path

file_path = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
lines = file_path.read_text().splitlines()

paren_count = 0
brace_count = 0

for line_num, line in enumerate(lines, 1):
    line_paren_change = 0
    line_brace_change = 0
    
    for char in line:
        if char == '(':
            paren_count += 1
            line_paren_change += 1
        elif char == ')':
            paren_count -= 1
            line_paren_change -= 1
        elif char == '{':
            brace_count += 1
            line_brace_change += 1
        elif char == '}':
            brace_count -= 1
            line_brace_change -= 1
    
    # Print lines where balance changes
    if paren_count < 0 or brace_count < 0:
        print(f"Line {line_num}: parens={paren_count}, braces={brace_count}")
        print(f"  {line}")
        if paren_count < 0:
            print(f"  ERROR: Too many closing parentheses!")
            break
        if brace_count < 0:
            print(f"  ERROR: Too many closing braces!")
            break

print(f"\nFinal: parens={paren_count}, braces={brace_count}")
