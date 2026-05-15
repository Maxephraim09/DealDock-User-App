#!/usr/bin/env python3
import subprocess
import sys

try:
    result = subprocess.run(
        ['flutter', 'analyze', 'lib/screen_ui/multi_vendor_service/restaurant_details_screen/restaurant_details_screen.dart'],
        capture_output=True,
        text=True,
        timeout=30
    )
    print(result.stdout)
    print(result.stderr)
    sys.exit(result.returncode)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
