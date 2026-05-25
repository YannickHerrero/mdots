# Global instructions

## Bash tool usage

Never chain commands with `&&`, `||`, or `;` in a single Bash tool call. Use separate, parallel Bash tool calls instead so each command matches the allow rules individually.
