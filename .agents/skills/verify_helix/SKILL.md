---
name: verify_static_helix_build
description: Essential steps and checklists for verifying the static-helix project before deployment. Triggers when the user asks to "check", "verify", or "test" the helix build.
---

# Helix Verification Protocol

1. **Linting**: Always run `npm run lint` before any manual checks.
2. **Directory Check**: Ensure `.agents/tmp/` is clear of sensitive test data.
3. **Log Audit**: Check `voice_logs/` for any unprocessed user directives.
