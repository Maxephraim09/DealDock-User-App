from pathlib import Path

text = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart').read_text(encoding='utf-8')
lines = text.splitlines()

# Check around line 158-1193
print("Tracing parentheses from NestedScrollView:")
paren_balance = 0
brace_balance = 0

for lineno in range(157, 1193):  # 158-1193 (0-indexed)
    line = lines[lineno]
    paren_count = line.count('(') - line.count(')')
    brace_count = line.count('{') - line.count('}')
    paren_balance += paren_count
    brace_balance += brace_count
    
    if brace_count != 0 or paren_count != 0 or lineno > 1185:
        print(f"Line {lineno+1:4d}: P{paren_balance:+3d} B{brace_balance:+3d} | {line[:70]}")

print(f"\nFinal: P{paren_balance:+d} B{brace_balance:+d}")
