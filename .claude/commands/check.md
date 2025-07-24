---
description: Verify implementation against guidelines and find issues
argument-hint: [files/feature] - what to check
---

Critically review this implementation: $ARGUMENTS

Use the verification checklist from @.claude/guidelines/ai-agent-playbook.md and validate against:
- @.claude/guidelines/core-rules.md - All MUST rules
- @.claude/guidelines/detailed-guidelines.md - Refer to specific sections as needed

Check for:
- Architecture violations (FA rules)
- TypeScript issues (TS rules)
- Missing error/loading states (API rules)
- Component design problems (CD rules)
- Accessibility issues (A11Y rules)

Cross-reference with the "Common Pitfalls to Avoid" section in the playbook.

Be specific with line numbers. Suggest concrete fixes.
Don't just approve - actively look for problems and improvements.
