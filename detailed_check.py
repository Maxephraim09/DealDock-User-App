from pathlib import Path

p = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
text = p.read_text(encoding='utf-8')
lines = text.splitlines()

stack = []
openers = {'(': ')', '{': '}', '[': ']'}
closers = {')': '(', '}': '{', ']': '['}

for lineno, line in enumerate(text.splitlines(), 1):
    in_single = False
    in_double = False
    i = 0
    while i < len(line):
        ch = line[i]
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
                stack.append((ch, lineno, i))
            elif ch in closers:
                if not stack:
                    print(f'ERROR: Unmatched close "{ch}" at line {lineno} col {i}')
                    raise SystemExit(1)
                op, op_line, op_col = stack.pop()
                if op != closers[ch]:
                    print(f'MISMATCH: "{op}" at line {op_line} col {op_col} with "{ch}" at line {lineno} col {i}')
                    print(f'Stack depth was: {len(stack) + 1}')
                    
                    # Show context
                    print(f'Opened at: {lines[op_line-1]}')
                    print(f'Closed at: {line}')
                    
                    # Show recent stack
                    print(f'Recent stack items:')
                    for item in stack[-5:]:
                        print(f'  {item}')
                    raise SystemExit(1)
        i += 1

print('All braces balanced!')
