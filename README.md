
# Anti-Yes-Machine Workflow for Claude Code

A development workflow that encourages critical thinking and prevents superficial code approval. This workflow transforms Claude from a "yes-machine" that might overlook issues into a critical reviewer that actively seeks improvements.

## Philosophy

Most AI assistants tend to be overly agreeable, often approving code that "looks fine" without deep analysis. This workflow implements an "anti-yes-machine" approach through:

- **Proactive questioning** before implementation
- **Critical analysis** of existing code
- **Alternative thinking** to challenge assumptions
- **Adversarial testing** to find breaking points

## Installation

1. Copy the `.claude/` directory to your project root:
   ```bash
   cp -r /path/to/anti-yes-machine/.claude ./
   ```

2. Ensure your project has a `CLAUDE.md` file that references your guidelines:
   ```markdown
   # Project Guidelines
   
   This project follows strict architectural guidelines:
   - Core Rules: see `.claude/guidelines/core-rules.md`
   - Detailed Guidelines: see `.claude/guidelines/detailed-guidelines.md`
   - Implementation Playbook: see `.claude/guidelines/ai-agent-playbook.md`
   ```

3. Verify installation:
   ```bash
   claude /help
   ```
   You should see the custom commands listed.

## Available Commands

### `/plan [task description]`
**Purpose**: Analyze and clarify before coding

Use this BEFORE implementing any feature. Claude will:
- Identify reusable components
- Determine correct feature location
- Clarify ambiguous requirements
- Consider edge cases upfront
- Assess impact on existing code

**Example**:
```bash
/plan implement user notification system with email and in-app alerts
```

### `/check [files/feature]`
**Purpose**: Critical code review

Use this AFTER implementation. Claude will actively search for:
- Architecture violations
- Security vulnerabilities
- Missing error handling
- Performance issues
- Accessibility problems

**Example**:
```bash
/check features/notifications/
```

### `/rethink [problem/feature]`
**Purpose**: Challenge assumptions and explore alternatives

Use this when STUCK or before major decisions. Triggers extended thinking to:
- Question if you're solving the right problem
- Explore radically different approaches
- Identify hidden trade-offs
- Consider build vs. buy decisions
- Find simpler solutions

**Example**:
```bash
/rethink our approach to real-time notifications
```

### `/break [component/feature]`
**Purpose**: Generate adversarial tests

Use this BEFORE deployment. Claude will create tests for:
- Edge cases and invalid inputs
- Race conditions
- Security exploits
- Performance limits
- Integration failures

**Example**:
```bash
/break NotificationService
```

## Typical Workflow

### 1. Starting a New Feature
```bash
> /plan add shopping cart persistence across sessions

Claude: Before implementing, I need to clarify:
- Should we use localStorage, IndexedDB, or server-side storage?
- How long should cart items persist?
- What happens when prices change while items are in cart?
[...]
```

### 2. After Initial Implementation
```bash
> /check features/cart/

Claude: Critical issues found:
❌ No encryption for sensitive cart data in localStorage
❌ Race condition when updating quantities rapidly
⚠️ Cart totals recalculated on every render
[...]
```

### 3. When Facing Challenges
```bash
> /rethink cart state management getting complex with discounts

Claude: [Extended thinking activated]
Let me thoroughly analyze this problem...
Current approach uses local state with complex calculations...
Alternative approaches:
1. State machine pattern for cart states
2. Move calculations to backend
3. Use a cart service library like Saleor
[...]
```

### 4. Before Shipping
```bash
> /break CartCheckout component

Claude: Generated breaking test cases:
- Test: Submit with expired session token
- Test: Concurrent checkout attempts  
- Test: Unicode in promo codes
- Test: Negative quantities via API
[...]
```

## Best Practices

1. **Use `/plan` first** - Prevent problems before they occur
2. **Be specific with `/check`** - Target specific files or features
3. **Use `/rethink` for big decisions** - It activates extended thinking
4. **Run `/break` before deploys** - Catch issues before users do

## Integration with Project Guidelines

This workflow works best with structured guidelines:

```
.claude/
├── commands/          # Anti-yes-machine commands
│   ├── plan.md
│   ├── check.md
│   ├── rethink.md
│   └── break.md
└── guidelines/        # Your project rules
    ├── core-rules.md
    ├── detailed-guidelines.md
    └── ai-agent-playbook.md
```

The commands automatically reference your guidelines, ensuring consistent critical analysis aligned with your project standards.

## Why This Works

1. **Cognitive Modes** - Each command triggers a different analytical mindset
2. **Proactive Prevention** - `/plan` catches issues before they're written  
3. **Deep Analysis** - `/rethink` uses extended thinking for complex problems
4. **Adversarial Testing** - `/break` thinks like an attacker
5. **Continuous Improvement** - Regular `/check` maintains quality

## Troubleshooting

**Commands not showing in `/help`**
- Ensure `.claude/commands/` exists in your project root
- Check that `.md` files have proper frontmatter

**Claude seems too critical**
- This is by design! The workflow encourages finding issues
- If there truly are no problems, Claude will acknowledge that

**Extended thinking not activating**
- The `/rethink` command includes triggers for extended thinking
- It works best with complex, open-ended problems

## Contributing

To modify commands, edit the `.md` files in `.claude/commands/`. Each command supports:
- Custom frontmatter for metadata
- `$ARGUMENTS` placeholder for dynamic input
- References to project files with `@filename`
- Bash command execution with `!command`

Remember: The goal is not to make development harder, but to catch issues early when they're cheap to fix.
