from pathlib import Path

p = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
text = p.read_text(encoding='utf-8')
lines = text.splitlines()

# Check around the problem lines
stack = []
openers = {'(': ')', '{': '}', '[': ']'}
closers = {')': '(', '}': '{', ']': '['}

print("Analyzing lines 1185-1195 with stack state:")
for lineno in range(1184, min(1195, len(lines))):
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
            elif ch in openers:
                stack.append((ch, lineno + 1, i))
            elif ch in closers:
                if not stack:
                    print(f'Line {lineno+1}: Unmatched close "{ch}" at col {i}')
                    break
                op, op_line, op_col = stack.pop()
                if op != closers[ch]:
                    print(f'Line {lineno+1}: Mismatch! Expected "{closers[op]}" but got "{ch}"')
                    break
    
    # Show stack state after this line
    print(f"Line {lineno+1:4d}: {line[:90]:<90} | Stack: {[(x[0], x[1]) for x in stack]}")
