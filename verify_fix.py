from pathlib import Path

file_path = Path('lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart')
content = file_path.read_text()

open_parens = content.count('(')
close_parens = content.count(')')
open_braces = content.count('{')
close_braces = content.count('}')

print(f'Parentheses: {open_parens} open, {close_parens} close, diff={close_parens - open_parens}')
print(f'Braces: {open_braces} open, {close_braces} close, diff={close_braces - open_braces}')

if open_parens == close_parens and open_braces == close_braces:
    print('✓ All parentheses and braces balanced!')
else:
    print('✗ Still imbalanced')
