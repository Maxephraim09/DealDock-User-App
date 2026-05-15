from pathlib import Path

file_path = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
lines = file_path.read_text().splitlines()

braces_stack = []  # for { }
parens_stack = []  # for ( )
brackets_stack = []  # for [ ]

for line_num, line in enumerate(lines, 1):
    for col_num, char in enumerate(line, 1):
        if char == '{':
            braces_stack.append((line_num, col_num))
        elif char == '}':
            if braces_stack:
                opening = braces_stack.pop()
            else:
                print(f"Extra closing }} at line {line_num} col {col_num}")
        elif char == '(':
            parens_stack.append((line_num, col_num))
        elif char == ')':
            if parens_stack:
                opening = parens_stack.pop()
            else:
                print(f"Extra closing ) at line {line_num} col {col_num}")
        elif char == '[':
            brackets_stack.append((line_num, col_num))
        elif char == ']':
            if brackets_stack:
                opening = brackets_stack.pop()
            else:
                print(f"Extra closing ] at line {line_num} col {col_num}")

print(f"\nUnmatched opening braces {{: {len(braces_stack)}")
for line_num, col_num in braces_stack:
    print(f"  Line {line_num} col {col_num}: {lines[line_num-1]}")

print(f"\nUnmatched opening parens (: {len(parens_stack)}")
for line_num, col_num in parens_stack:
    print(f"  Line {line_num} col {col_num}: {lines[line_num-1]}")

print(f"\nUnmatched opening brackets [: {len(brackets_stack)}")
for line_num, col_num in brackets_stack:
    print(f"  Line {line_num} col {col_num}: {lines[line_num-1]}")
