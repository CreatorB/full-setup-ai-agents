# NovaforgeAI for CPU-Only Setups

For CPU-only local setups, NovaforgeAI models are a strong family to evaluate first.

Catalog:

- https://ollama.com/novaforgeai

## Selection Advice

- prefer smaller optimized coding models first
- validate latency before adopting them as defaults
- do not assume a larger model is better if it becomes too slow to use productively

## Suggested Approach

1. start with the smallest coding-friendly optimized model in the catalog
2. test basic file edit and refactor tasks
3. verify whether the model completes full CRUD workflows or stalls halfway
4. only move to a larger model if the smaller one is clearly insufficient
