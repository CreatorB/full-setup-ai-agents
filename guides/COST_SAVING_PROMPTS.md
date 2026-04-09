# Cost-Saving Master Prompts

This guide provides battle-tested prompts for the Architect & Builder workflow, designed to minimize API token usage while maximizing output quality.

## The Problem

Using premium AI models (Claude Opus, GPT-4, Gemini Pro) for everything is expensive. A single feature implementation can easily consume 50,000+ tokens, especially when the AI rewrites entire files or generates boilerplate code.

## The Solution

Split the workflow into two distinct phases:
1. **Architecture** (premium model) - High-level design, planning, specifications
2. **Execution** (cheap/free model) - Actual code implementation

**Token savings: 85-95%**

## Phase 1: The Architect

Use this prompt with **Claude Opus** or **Gemini Pro** for architectural design.

### Master Prompt: The Architect

```markdown
Act as an Expert Software Architect and Principal Engineer. Your task is to design a comprehensive Technical Specification Document for the feature/system requested below.

CRITICAL INSTRUCTION TO SAVE TOKENS:
DO NOT write the actual implementation code. DO NOT write full functions. Your output must ONLY contain high-level architecture, logic flows, file structures, and strict pseudocode.

Please provide the output in clean Markdown format with the following sections:

1. System Overview
   - Brief summary of how the solution works
   - Key architectural decisions and rationale
   - Integration points with existing systems

2. File Structure
   - Tree representation of files to be created or modified
   - Brief description of each file's purpose
   - Dependencies between files

3. Tech Stack & Dependencies
   - Specific libraries, modules, or APIs needed
   - Version requirements if critical
   - External service integrations (e.g., Cloudinary API, specific frameworks)

4. Data Flow / State Management
   - How data moves between frontend and backend
   - State management approach (if applicable)
   - API contracts (request/response shapes)
   - Database schema changes (if needed)

5. Step-by-Step Logic (Pseudocode)
   - Core algorithms in structured pseudocode
   - Edge cases to handle
   - Error handling strategy
   - Security considerations
   - Performance optimizations

6. Execution Order
   - Numbered list of which file/component should be built first
   - Dependencies between components
   - Testing strategy for each component

7. Potential Pitfalls
   - Common mistakes to avoid
   - Tricky edge cases
   - Performance bottlenecks to watch for

Here is the feature I want to build:

[DESCRIBE YOUR FEATURE IN DETAIL HERE]

Context about existing system:
[ADD RELEVANT CONTEXT: tech stack, constraints, integrations, etc.]

Constraints:
[LIST ANY CONSTRAINTS: performance requirements, compatibility needs, etc.]
```

### Example Feature Request

```markdown
Here is the feature I want to build:

A responsive image drawer menu for a landing page that:
- Uses Cloudinary API for image optimization
- Shows thumbnails in a drawer that slides from the right
- Allows drag-and-drop image upload
- Compresses images before uploading
- Works on mobile and desktop

Context about existing system:
- Static HTML/CSS/Vanilla JavaScript site (no frameworks)
- Already using Bootstrap 5 for layout
- Hosted on Netlify

Constraints:
- Must work without page refresh (SPA-like behavior)
- Images should load progressively
- Maximum bundle size: 100KB (excluding images)
```

## Phase 2: The Builder

Take the complete Technical Specification from Claude/Gemini Pro and feed it to a **cheaper executor**.

### Master Prompt: The Builder

```markdown
Act as a Senior Full-Stack Developer. I will provide you with a Technical Specification Document written by an Expert Architect.

Your task is to write the COMPLETE, production-ready, and fully functional code based EXACTLY on this specification.

IMPLEMENTATION RULES:
1. Follow the file structure and execution order provided in the spec
2. Write clean, well-commented code with clear variable names
3. Do not skip any logic mentioned in the pseudocode
4. Implement all edge cases and error handling described
5. Add security validations as specified
6. Output code block by block, clearly stating the filename above each block
7. If the spec mentions "placeholder" or "stub", implement it fully anyway
8. Include necessary imports and dependencies at the top of each file

OUTPUT FORMAT:
For each file, use this format:

---
**File: `path/to/file.ext`**

```language
[COMPLETE FILE CONTENTS HERE]
```

Brief explanation: [What this file does and how it fits into the architecture]
---

Here is the Technical Specification:

[PASTE THE COMPLETE SPEC FROM CLAUDE/GEMINI PRO HERE]
```

### Recommended Executors

Choose based on your needs:

**For API-based execution:**
- **Gemini 3 Flash** - Blazing fast, huge context (1M tokens), very cheap (~$0.01/1M tokens)
- **Claude Sonnet** - Balanced speed and quality, good for complex implementations
- **Gemini 1.5 Pro** - Higher quality than Flash, still much cheaper than Opus

**For local execution (FREE):**
- **qwen2.5-coder:3b** - Fast and capable, great for focused specs
- **deepseek-coder:6.7b-instruct-q4_0** - Better quality, handles more complexity
- **codellama:13b-instruct** - High quality for larger contexts (if you have VRAM)

## Advanced Strategies

### Strategy: Diff-Only Outputs

When modifying existing files, add this to your prompts:

```markdown
MODIFICATION MODE:
Only output the changed sections of code, NOT the entire file.
Format:

**File: `path/to/file.ext`**
**Change Type:** [Add/Modify/Delete]
**Location:** [Function name or line range]

```language
[ONLY THE CHANGED CODE SECTION]
```

**Instructions:** [Where to insert/what to replace]
```

### Strategy: Skeletal Context

For large codebases, don't paste all files. Use this approach:

```markdown
I have a project with the following structure:

[PASTE DIRECTORY TREE HERE - use `tree` command]

I'm encountering this issue:
[DESCRIBE THE PROBLEM]

Based on the project structure above, which 3-5 files should I provide to you for detailed analysis?

[Then provide only those specific files in the next message]
```

### Strategy: Incremental Implementation

For complex features, break the architecture phase into chunks:

```markdown
Act as an Expert Software Architect.

I need to build: [FEATURE DESCRIPTION]

But I want to implement it incrementally in 3 phases:

Phase 1: Basic functionality (MVP)
Phase 2: Error handling and edge cases
Phase 3: Performance optimizations and polish

For Phase 1 ONLY, create a Technical Specification following the format you used before.
Focus on the minimum viable implementation that demonstrates the core feature.

[Then repeat for Phase 2 and Phase 3 separately]
```

## Cost Comparison

### Traditional All-Premium Approach

```
Feature: Image drawer with upload
├─ Architecture & Planning: 5,000 tokens
├─ Implementation code: 45,000 tokens
├─ Revisions & fixes: 10,000 tokens
└─ Total: 60,000 tokens × $15/1M = $0.90 per feature
```

### Architect & Builder Approach

```
Feature: Image drawer with upload
├─ Architecture (Claude Opus): 5,000 tokens × $15/1M = $0.075
├─ Implementation (Gemini Flash): 2,000 tokens × $0.01/1M = $0.00002
├─ Revisions (Gemini Flash): 1,000 tokens × $0.01/1M = $0.00001
└─ Total: $0.075 per feature
```

**Savings: 92%** ($0.90 → $0.075)

### Architect & Local Builder Approach

```
Feature: Image drawer with upload
├─ Architecture (Claude Opus): 5,000 tokens × $15/1M = $0.075
├─ Implementation (Local qwen2.5-coder:3b): 0 tokens = $0.00
├─ Revisions (Local): 0 tokens = $0.00
└─ Total: $0.075 per feature
```

**Savings: 92%** with even faster iteration since local is instant.

## Real-World Examples

### Example 1: CRUD API Implementation

**Architect Prompt:**
```markdown
Create a Technical Specification for a RESTful API that manages a task list with:
- User authentication (JWT)
- CRUD operations for tasks
- Task categories and tags
- Task assignment to users
- Due dates and reminders

Tech Stack: Node.js, Express, PostgreSQL, Prisma ORM
```

**Builder Prompt:**
```markdown
[Copy entire spec from Claude]

Implement this using:
- Express 4.x
- Prisma ORM
- JWT for authentication
- Proper error handling middleware
- Input validation with express-validator
```

### Example 2: React Component Library

**Architect Prompt:**
```markdown
Design a reusable Button component library with:
- Multiple variants (primary, secondary, danger, ghost)
- Size options (sm, md, lg)
- Loading states
- Icon support
- Accessibility (ARIA labels, keyboard navigation)
- TypeScript support

Must work with React 18+ and be tree-shakeable.
```

**Builder Prompt:**
```markdown
[Spec from Claude]

Implement using:
- React 18
- TypeScript
- CSS Modules for styling
- Storybook stories for each variant
- Jest + React Testing Library tests
```

## Tips for Success

### For Architecture Phase

1. **Be specific about constraints** - Tell Claude about performance requirements, browser support, bundle size limits
2. **Provide context** - Share relevant parts of existing codebase structure
3. **Request examples** - Ask for example data structures or API responses
4. **Specify non-functional requirements** - Security, accessibility, performance, SEO

### For Execution Phase

1. **Copy the ENTIRE spec** - Don't summarize or paraphrase
2. **Be explicit about language/framework versions** - "React 18.2" not "latest React"
3. **Request tests** - Even if not in the spec, ask for unit tests
4. **Ask for error handling** - Make it explicit if architect didn't detail it enough

### For Iteration

1. **Use diff mode** for tweaks - Don't regenerate entire files
2. **Local models for experiments** - Try multiple approaches for free
3. **Premium for debugging** - When stuck, escalate to Claude Opus for analysis

## Automation Opportunities

### Shell Script for Workflow

```bash
#!/bin/bash
# architect-builder.sh

echo "=== Architect Phase ==="
echo "Paste your feature description, then press Ctrl+D:"
FEATURE=$(cat)

echo "Sending to Claude Opus for architecture..."
# Use Claude API to get spec
SPEC=$(claude-api architect "$FEATURE")

echo "=== Architecture Complete ==="
echo "$SPEC" > spec.md
cat spec.md

echo ""
echo "=== Builder Phase ==="
echo "Sending to Gemini Flash for implementation..."
# Use Gemini API to generate code
gemini-api build "$SPEC"

echo "=== Implementation Complete ==="
```

### IDE Integration

Most modern AI coding assistants support custom prompts. Save these as templates:
- VS Code: `.vscode/prompts/`
- Cursor: Settings > Prompts
- Aider: `.aider.prompts.md`

## Affordable AI Subscription Services

For tasks requiring cloud AI models, these services offer budget-friendly options:

| Provider | URL | Notes |
|---|---|---|
| **z.ai** | https://z.ai | Affordable subscription plans |
| **Minimax** | https://www.minimax.io | Competitive pricing |
| **Deepseek** | https://deepseek.com | Cost-effective for many tasks |

## OpenCode Context Optimization Workflow

OpenCode with DCP plugin provides automated context management. Here's the recommended workflow:

### Quick Reference: DCP Commands

```
1. /dcp context       ← Check token status first
2. /dcp sweep 10     ← Prune last 10 tool calls manually  
3. /dcp context       ← Verify if context is clean enough
4. /compact          ← Only if still over 80% full
```

### DCP Auto-Pruning Strategy (20-40% Savings Automatically)

DCP runs automatically in background with 4 strategies:
- **Deduplication** → Remove duplicate tool calls (read same file 3x → keep 1)
- **Purge Errors** → Remove error tool inputs from 4+ turns ago
- **AI Discard** → AI actively discards irrelevant context
- **AI Extract** → AI saves important info before discarding

### Context Management Priority

```
1. AGENTS.md          → Free, no chat tokens consumed
2. DCP auto-pruning   → 20-40% savings without effort
3. Plan mode first    → Avoid wasteful iterations
4. Session per task   → Clean context for each task
5. /dcp sweep manual  → When context gets heavy
6. /compact           → Last resort only
```

## OpenCode Configuration for Cost Efficiency

### Recommended Config (`~/.config/opencode/opencode.jsonc`)

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "options": { "baseURL": "http://localhost:11434/v1" },
      "models": {
        "fredrezones55/Jan-code:Q4_K_M": {
          "name": "fredrezones55/Jan-code:Q4_K_M",
          "tools": true
        }
      }
    }
  },
  "plugin": [
    "@tarquinen/opencode-dcp@latest",
    "opencode-memory-plugin"
  ]
}
```

### OpenCode Daily Workflow

1. **Start Session**
   ```powershell
   cd D:\IT\HSN\Developments\sources\projects\hydsoft
   opencode .
   ```

2. **Essential Commands** (press `Ctrl+P` or type `/`):
   ```
   /review           → Review uncommitted changes
   /review branch    → Compare branch changes
   /compact          → Compress session when too long
   /bug              → Report to GitHub
   Tab               → Switch to other agents (Build, Kimi, etc.)
   ```

3. **DCP Manual Controls**:
   ```
   /dcp              → See all DCP commands
   /dcp context      → Token breakdown (System/User/Assistant/Tools)
   /dcp stats        → Total pruning statistics
   /dcp sweep        → Prune tools from last user message
   /dcp sweep 5      → Prune 5 most recent tool calls
   ```

### Memory Plugin Integration

```bash
/memory             → View all memories
/memory add         → Add manual memory
/memory clear       → Clear all memories
```

## Conclusion

The Architect & Builder workflow is not about being cheap—it's about being **smart with resources**.

Premium models excel at:
- System design
- Architecture decisions
- Complex problem decomposition
- Debugging tricky issues

Cheap/local models excel at:
- Code generation
- Boilerplate creation
- Refactoring
- Test writing

Use each for what it does best, and save 90%+ on API costs while maintaining quality.
