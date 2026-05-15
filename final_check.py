from pathlib import Path

text = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart').read_text(encoding='utf-8')
stack = []
openers = {'(': ')', '{': '}', '[': ']'}
closers = {')': '(', '}': '{', ']': '['}

for lineno, line in enumerate(text.splitlines(), 1):
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
                stack.append((ch, lineno, i))
            elif ch in closers:
                if not stack:
                    print(f'Unmatched close "{ch}" at line {lineno} col {i}')
                    raise SystemExit(1)
                op, op_line, op_col = stack.pop()
                if op != closers[ch]:
                    print(f'Mismatch "{op}" at line {op_line} col {op_col} with "{ch}" at line {lineno} col {i}')
                    raise SystemExit(1)

if stack:
    print(f'Unmatched open "{stack[-1][0]}" at line {stack[-1][1]} col {stack[-1][2]}')
else:
    print('All braces balanced!')
