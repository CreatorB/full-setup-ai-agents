# Local CPU-Only Setup

This section is a recommended configuration path, not a fully validated reproduction of the GPU-based setup.

## Goal

Provide a practical direction for users who do not have a usable local GPU.

## Recommendation

Prefer smaller optimized models from the NovaforgeAI Ollama catalog:

- https://ollama.com/novaforgeai

If local CPU inference is too slow for daily work, use API-backed providers instead of forcing a weak local-only workflow.

Recommended API-backed directions:

- OpenCode
- Z.AI
- OpenRouter
- Anthropic

## Suggested CPU-Only Strategy

- choose the smallest coding-oriented NovaforgeAI model that still behaves acceptably on your hardware
- favor lower latency and predictability over large contexts
- keep expectations realistic for multi-file autonomous workflows
- if local inference is too slow, keep local models only as a fallback and move your main coding model to an API provider

## Suggested Starting Point

If available in the catalog, start with a smaller optimized coding model such as:

- `novaforgeai/starcoder2:3b-optimized`
- `novaforgeai/qwen2.5:3b-optimized`

Current note:

- `novaforgeai/qwen2.5:3b-optimized` looks like a good small CPU-only candidate, but it should still be treated as experimental until file-tool behavior is verified in your actual agent workflow.

For heavier CPU-only experiments, consider larger coding-oriented models only if latency is acceptable.

## API-Backed CPU-Only Strategy

For many CPU-only users, the better long-term path is:

- local small models for backup or offline use
- API-backed models for real daily coding

### Recommended Order To Evaluate

1. **OpenCode** for a stronger coding-oriented hosted workflow
2. **Z.AI** for another API-first option when local CPU performance is not practical
3. **OpenRouter** if you want broad provider and model flexibility
4. **Anthropic** if you want premium coding and reasoning quality and cost is acceptable

## Practical Advice

- use Aider or Pi first if you want a simpler CPU-only agent workflow
- use Hermes only when you specifically want its agent shell and tool workflow
- do not assume bigger local models are better if they become too slow to be useful

## Agent Guidance

- Aider is still likely the best first agent for direct coding tasks
- Pi is a strong second option for a cleaner minimal interface
- Hermes can still be useful, but model obedience matters even more on slower CPU-only setups

## Important Caveat

CPU-only local agents can still be useful, but they usually require:

- smaller models
- shorter sessions
- more explicit prompts
- tighter verification after edits

## Recommendation for Contributors

If you validate a CPU-only setup with NovaforgeAI models, consider contributing:

- tested model list
- RAM requirements
- latency notes
- best agent per task
- whether local-only or API-backed turned out to be the more practical daily workflow
