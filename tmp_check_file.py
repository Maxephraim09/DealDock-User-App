from pathlib import Path
p = Path('lib/screen_ui/multi_vendor_service/wallet_screen/transfer_screen.dart')
text = p.read_text()
for i, line in enumerate(text.splitlines(), 1):
    if i in [40,41,42,43,44,45,70,80,120,140,160,180,220,240,260,280]:
        print(f'{i}: {line}')
print('paren_count', text.count('('), 'paren_close', text.count(')'))
print('bracket_count', text.count('['), 'bracket_close', text.count(']'))
print('brace_count', text.count('{'), 'brace_close', text.count('}'))
