#!/usr/bin/env bash
# Minimal installer - just copy the files

set -euo pipefail

# Check we're in the right directory
if [[ ! -d ".claude/commands" ]] || [[ ! -d "frontend" ]]; then
    echo "Error: Run this script from the anti-yes-machine repo root"
    exit 1
fi

# Get target directory
TARGET="${1:-.}"

if [[ ! -d "$TARGET" ]]; then
    echo "Error: Target directory '$TARGET' does not exist"
    exit 1
fi

# Check for conflicts
if [[ -d "$TARGET/.claude" ]]; then
    echo "Warning: .claude directory already exists in $TARGET"
    read -p "Continue? (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 0
fi

# Copy files
echo "Installing anti-yes-machine workflow..."
mkdir -p "$TARGET/.claude"
cp -r .claude/commands "$TARGET/.claude/"
mkdir -p "$TARGET/.claude/guidelines"
cp frontend/fsd/core-rules.md "$TARGET/.claude/guidelines/"
cp frontend/detailed-guideline.md "$TARGET/.claude/guidelines/detailed-guidelines.md"
cp frontend/ai-agent-playbook.md "$TARGET/.claude/guidelines/"

echo "✓ Installation complete!"
echo ""

# Check for CLAUDE.md and provide appropriate guidance
if [[ -f "$TARGET/CLAUDE.md" ]]; then
    echo "⚠️  CLAUDE.md detected in your project"
    echo ""
    echo "The guideline files have been installed but won't be loaded automatically."
    echo "To use them, add these references to your CLAUDE.md:"
    echo ""
    echo "  - Core Rules: @.claude/guidelines/core-rules.md"
    echo "  - Detailed Guidelines: @.claude/guidelines/detailed-guidelines.md"  
    echo "  - AI Agent Playbook: @.claude/guidelines/ai-agent-playbook.md"
    echo ""
else
    echo "Next steps:"
    echo "1. Create CLAUDE.md in your project (see README.md for template)"
fi

echo "2. Run: claude /help to see the new commands"
echo "3. Start using: /plan, /check, /rethink, /break"