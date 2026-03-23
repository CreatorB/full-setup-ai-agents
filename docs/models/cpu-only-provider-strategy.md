# CPU-Only Provider Strategy

For CPU-only environments, there are usually two realistic paths:

- local-only with small models
- API-backed daily usage with local fallback

## Local-Only

Use local-only when you value:

- privacy
- offline access
- zero per-token cost
- experimentation with small local models

The tradeoff is speed and lower practical reliability for complex multi-step workflows.

## API-Backed

Use API-backed models when your CPU cannot support a practical daily coding workflow.

Recommended options to evaluate:

- **OpenCode** for coding-oriented hosted usage
- **Z.AI** for another remote model path stronger than weak local CPU inference
- **OpenRouter** for flexible routing and multi-provider access
- **Anthropic** for premium coding and reasoning if budget allows

## Best Practical Rule

- local small models for fallback and experimentation
- hosted models for real daily coding work

## Agent Advice

- **Aider** remains the easiest first choice for direct file editing
- **Pi** is a strong second option when you want a clean provider/model layer
- **Hermes Agent** can work well, but only if the chosen provider-model combination is obedient enough for tool workflows
