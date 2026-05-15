# Auth Troubleshooting Guide

Quick diagnosis guide for common auth issues after the production fixes.

---

## Issue 1: Biometric Prompt Not Appearing on Startup

### Symptoms
- App starts → No fingerprint prompt
- Biometric is enabled in settings
- User expects to be prompted for biometric

### Diagnosis Checklist
1. ✓ Is biometric actually enabled?
   ```dart
   // Check: Preferences.biometricLoginEnabled() returns true
   ```

2. ✓ Does device have fingerprint enrolled?
   ```dart
   // Check: BiometricService().checkAvailability() succeeds
   ```

3. ✓ Is there a valid Firebase user?
   ```dart
   // Check: FirebaseAuth.instance.currentUser != null
   ```

4. ✓ Check flags in LoginScreenState
   ```dart
   // If _biometricAutoPrompted is true → prompt already fired
   // If _biometricAutoPromptInProgress is true → prompt in progress
   // If BiometricService.isAuthenticating is true → blocked
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| No Firebase user on login screen | Verify login_controller saved session via _saveSessionState() |
| _biometricAutoPrompted stuck true | Check for exception in _autoPromptBiometricLogin(); restart app |
| Device doesn't support biometric | Preferences.setBiometricLoginEnabled(false) auto-triggers |
| Biometric not available | BiometricService.checkAvailability() should handle; check logs |

### Debug Logs to Check
```
[LoginScreen] Biometric login enabled, routing to login screen
[LoginScreen] Loaded saved login email: user@example.com
[LoginScreen] Biometric login not initialized: enabled=true, user=<uid>
[LoginScreen] Biometric unavailable on login screen: <error>
[LoginScreen] Attempting biometric authentication on resume...
```

---

## Issue 2: Email Field Not Pre-Filled

### Symptoms
- After logout + restart app
- Email field is empty
- User must re-type email

### Diagnosis Checklist
1. ✓ Was email saved after login?
   ```dart
   // Check: Preferences.lastLoginEmail() has value
   // Look for: "Saved session state for: user@example.com" in logs
   ```

2. ✓ Was email cleared on logout?
   ```dart
   // Check: clearSessionData() was called
   // Should NOT call clearLastLoginEmail() (only clearSessionData())
   ```

3. ✓ Is _loadSavedSessionState() being called?
   ```dart
   // Check: "Loaded saved login email: ..." appears in logs
   ```

4. ✓ Is the controller ready when we populate it?
   ```dart
   // 300ms delay ensures LoginController is initialized
   // Check: Get.find<LoginController>() doesn't throw
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| Email never saved | Check login_controller calls _saveSessionState() in all paths |
| Email cleared on logout | Verify clearSessionData() preserves lastLoginEmailKey |
| Controller not initialized | Increase delay or use different initialization pattern |
| mounted check failed | Verify widget is still mounted before setting text |

### Debug Logs to Check
```
[LoginController] Saved session state for: user@example.com
[LoginScreen] Loaded saved login email: user@example.com
[LoginScreen] Loaded saved login email: (empty) ← Email wasn't saved
```

---

## Issue 3: "Use Password Instead" Button Doesn't Work

### Symptoms
- Biometric prompt appears → User taps "Use Password Instead"
- Nothing happens or wrong screen shown
- User can't fall back to password

### Diagnosis Checklist
1. ✓ Is the button visible?
   ```dart
   // Check: _showBiometricPrompt is true
   // Button is shown when biometric prompt is active
   ```

2. ✓ Does tap handler work?
   ```dart
   // Check: setState(() { _showBiometricPrompt = false; })
   // Should hide biometric UI and show password form
   ```

3. ✓ Is password form below biometric UI?
   ```dart
   // Check: if (_showBiometricPrompt) { ... } wraps biometric UI
   // Below it should be email/password TextFields
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| Button not visible | If biometric UI not showing, button won't show |
| setState doesn't hide UI | Check if widget is still mounted before setState |
| Wrong form shown | Check Column structure; email/password should be below bio UI |
| Form field not accessible | Ensure TextFields remain interactive when bio UI visible |

### Debug Logs to Check
```
[LoginScreen] Attempting biometric authentication on resume...
[LoginScreen] Biometric authentication successful
[LoginScreen] Biometric auth failed on resume: <error>
```

---

## Issue 4: Biometric Prompts Multiple Times

### Symptoms
- User authenticates with fingerprint
- Prompt appears again immediately
- Prompt loops repeatedly

### Diagnosis Checklist
1. ✓ Is `_biometricAutoPrompted` flag set?
   ```dart
   // Check: Flag set to true before first prompt
   // Prevents re-prompting in _autoPromptBiometricLogin()
   ```

2. ✓ Does BiometricService.isAuthenticating work?
   ```dart
   // Check: Static flag prevents concurrent auth
   // Should be true while biometric prompt is active
   ```

3. ✓ Is build() re-triggering initState?
   ```dart
   // Check: initState should only run once
   // WidgetsBinding.addPostFrameCallback ensures single execution
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| _biometricAutoPrompted not set | Ensure flag set before calling biometric.authenticate() |
| BiometricService.isAuthenticating stuck true | Check if exception thrown during auth; restart app |
| initState called multiple times | Verify StatefulWidget not being recreated; check navigation |
| Build re-triggering auth flow | Remove auth logic from build(); move to initState |

### Debug Logs to Check
```
[LoginScreen] Biometric prompt already handled
[LoginScreen] Biometric authentication already in progress
[LoginScreen] Attempting biometric authentication on resume...
```

---

## Issue 5: Session Not Persisted After Login

### Symptoms
- User logs in → App closed
- App reopened → Biometric prompt doesn't appear
- User must re-login

### Diagnosis Checklist
1. ✓ Is _saveSessionState() called?
   ```dart
   // Check logs: "Saved session state for: ..."
   // Should appear after every login
   ```

2. ✓ Is Firebase session still valid?
   ```dart
   // Check: FirebaseAuth.instance.currentUser != null after restart
   // Should have same uid
   ```

3. ✓ Is biometric flag preserved?
   ```dart
   // Check: Preferences.biometricLoginEnabled() still true
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| _saveSessionState() not called | Verify it's in all login paths (email, Google, Apple) |
| Firebase session cleared | Check if signOut() was called accidentally |
| Biometric flag cleared | Check if setBiometricLoginEnabled(false) called |
| Preferences not persisting | Verify Preferences.initPref() called in main() |

### Debug Logs to Check
```
[LoginController] Saved session state for: user@example.com
[LoginScreen] Loaded saved login email: user@example.com
[LoginScreen] Biometric login enabled, routing to login screen
```

---

## Issue 6: PIN Creation Shows Password Dialog

### Symptoms
- User taps "Create PIN" in settings
- Asked for password instead of biometric
- User expects fingerprint prompt

### Diagnosis Checklist
1. ✓ Is biometric enabled?
   ```dart
   // Check: Preferences.biometricLoginEnabled() returns true
   ```

2. ✓ Does device support biometric?
   ```dart
   // Check: BiometricService.isAvailable() succeeds
   ```

3. ✓ Is PinSecurityService.authorize() being called?
   ```dart
   // Check: authorize() first tries biometric before password dialog
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| Biometric disabled | User can't use fingerprint; password is fallback |
| Device doesn't support biometric | Password is expected fallback |
| biometric.isAvailable() fails | Check device has fingerprint enrolled |
| User canceled biometric | Password fallback should show |

### Debug Logs to Check
```
[PinSecurityService] Checking biometric availability...
[PinSecurityService] Biometric available, prompting...
[PinSecurityService] Biometric failed or unavailable, showing password dialog
```

---

## Issue 7: Logout Doesn't Clear All Data

### Symptoms
- User logs out
- Some preferences/tokens remain
- Next login shows old data

### Diagnosis Checklist
1. ✓ Is Preferences.clearSessionData() called?
   ```dart
   // Check: more_screen._handleLogout() calls it
   ```

2. ✓ Is FirebaseAuth.signOut() called?
   ```dart
   // Check: Clears Firebase session
   ```

3. ✓ Is app navigating to LoginScreen?
   ```dart
   // Check: Get.offAll(() => const LoginScreen())
   ```

4. ✓ What was cleared? What was preserved?
   ```dart
   // Cleared: tokens, userdata, biometric flag, PIN, etc.
   // Preserved: lastLoginEmail, skipLocation, theme, language
   ```

### Solutions
| Root Cause | Solution |
|-----------|----------|
| clearSessionData() not called | Ensure _handleLogout() in more_screen calls it |
| FirebaseAuth.signOut() not called | Prevents Firebase session from clearing |
| Wrong preferences removed | Check clearSessionData() only removes auth data |
| Login screen caching old data | Verify LoginScreen reloads preferences after logout |

### Debug Logs to Check
```
[MoreScreen] Logging out...
[Preferences] Clearing session data
[LoginScreen] Loaded saved login email: user@example.com
```

---

## Common Error Messages & Solutions

### Error: "Biometric authentication already in progress"
**Cause**: BiometricService.isAuthenticating is stuck true  
**Solution**: Restart the app; check for exception in biometric.authenticate()

### Error: "No signed-in user available for fingerprint login"
**Cause**: FirebaseAuth.instance.currentUser is null  
**Solution**: Verify login saved session via _saveSessionState()

### Error: "Fingerprint not available"
**Cause**: Device doesn't support biometric or fingerprint not enrolled  
**Solution**: Show password form; auto-disable biometric in preferences

### Error: "PIN is too weak"
**Cause**: User entered weak pattern like 1111, 1234, 0000  
**Solution**: Suggest different PIN to user; validate against pattern list

### Error: "PIN attempts exceeded"
**Cause**: User made 5 failed PIN attempts  
**Solution**: User is locked for 15 minutes; show countdown timer

### Error: "Session expired"
**Cause**: Auto-logout timeout reached  
**Solution**: Clear session; redirect to LoginScreen; show message

---

## Performance Optimization Tips

1. **Delay Email Pre-Fill**: 300ms delay allows controller initialization
2. **Async Operations**: Load preferences in background; don't block UI
3. **Guard Concurrent Auth**: Use static flags to prevent multiple biometric prompts
4. **Cache Biometric Availability**: Check once in initState; don't re-check repeatedly
5. **Defer Heavy Operations**: Move Firestore queries to background tasks

---

## Testing Checklist for Issues

- [ ] Test on real device with fingerprint enrolled
- [ ] Test on emulator without fingerprint support
- [ ] Test with network offline
- [ ] Test with weak/no signal
- [ ] Test with app backgrounded for long time
- [ ] Test logout → immediate login
- [ ] Test PIN creation after enabling biometric
- [ ] Test disabling biometric mid-session
- [ ] Test with multiple failed biometric attempts

---

**For more information, see**:
- `AUTH_PRODUCTION_FIX_SUMMARY.md` — Comprehensive fix guide
- `AUTH_QUICK_REFERENCE.md` — Executive summary
- `AUTH_CODE_CHANGES_DETAILED.md` — Exact code changes
