---
description: Find edge cases and generate breaking tests
argument-hint: [component/feature]
---

Generate test cases designed to break this code: $ARGUMENTS

Use the testing templates from @.claude/guidelines/ai-agent-playbook.md as a starting point.
Apply test rules from @.claude/guidelines/detailed-guidelines.md section 8 (Testing).

Focus on:
- Edge cases with invalid or unexpected inputs
- Race conditions and concurrency issues
- Security vulnerabilities (XSS, injection, etc.)
- Performance limits and memory leaks
- Integration points that could fail
- User behaviors we didn't anticipate

Reference the "Testing mistakes" section in the playbook to avoid common pitfalls.

Create specific, executable test cases that would catch real production bugs.
Don't test the happy path - test what could go wrong.
