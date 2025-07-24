---
description: Analyze task and ask clarifying questions before implementing
argument-hint: [task description]
---

Analyze this task before implementing: $ARGUMENTS

Refer to our guidelines:
- Check @.claude/guidelines/core-rules.md for essential architecture patterns
- Review @.claude/guidelines/ai-agent-playbook.md for relevant implementation templates
- Consider @.claude/guidelines/detailed-guidelines.md if specific rules need clarification

Specifically analyze:
1. What existing code can be reused from our features/ or shared/ directories?
2. Which feature folder should this belong to according to FA rules?
3. What edge cases and error states need handling (per API-2, EH rules)?
4. Are there any unclear requirements I should clarify?
5. What impact might this have on other features?

If the playbook has a relevant scenario template, mention it.
Ask questions if anything is ambiguous.
Suggest the implementation approach before coding.
