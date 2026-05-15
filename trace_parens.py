from pathlib import Path

file_path = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
lines = file_path.read_text().splitlines()

parens_stack = []  # (line, col)

for line_num, line in enumerate(lines, 1):
    for col_num, char in enumerate(line, 1):
        if char == '(':
            parens_stack.append((line_num, col_num, line[:50]))
        elif char == ')':
            if parens_stack:
                opening = parens_stack.pop()
                # print(f"Matched: ({opening[0]},{opening[1]}) with )({line_num},{col_num})")
            else:
                print(f"EXTRA ) at line {line_num} col {col_num}: {line}")
                # Print last 5 opened parens for context
                print("  Recent opens:")
                # Count unmatched opens
                temp_opens = []
                temp_lines_content = lines[:line_num]
                for ln, l in enumerate(temp_lines_content, 1):
                    for cn, c in enumerate(l, 1):
                        if c == '(':
                            temp_opens.append((ln, cn))
                        elif c == ')':
                            if temp_opens:
                                temp_opens.pop()
                if temp_opens:
                    for opening in temp_opens[-5:]:
                        print(f"    Line {opening[0]} col {opening[1]}")

print(f"\nFinal unmatched (: {len(parens_stack)}")
for ln, cn, content in parens_stack:
    print(f"  Line {ln} col {cn}: {content}...")
