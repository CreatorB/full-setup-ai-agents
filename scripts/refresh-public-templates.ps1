$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

$mappings = @(
    @{ Source = "C:\Users\Alendia\.aider\.aider.conf.yml"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\aider\.aider.conf.yml" },
    @{ Source = "C:\Users\Alendia\.aider\.aider-jan.conf.yml"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\aider\.aider-jan.conf.yml" },
    @{ Source = "C:\Users\Alendia\.aider\.aider-orlex.conf.yml"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\aider\.aider-orlex.conf.yml" },
    @{ Source = "C:\Users\Alendia\.aider\.aider-opus4b.conf.yml"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\aider\.aider-opus4b.conf.yml" },
    @{ Source = "C:\Users\Alendia\.pi\agent\AGENTS.md"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\pi\AGENTS.md" },
    @{ Source = "C:\Users\Alendia\.pi\agent\models.json"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\pi\models.json" },
    @{ Source = "C:\Users\Alendia\.pi\agent\settings.json"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\pi\settings.json" },
    @{ Source = "C:\Users\Alendia\scripts\ajan.cmd"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\scripts\ajan.cmd" },
    @{ Source = "C:\Users\Alendia\scripts\hdev.cmd"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\scripts\hdev.cmd" },
    @{ Source = "C:\Users\Alendia\scripts\pijan.cmd"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\scripts\pijan.cmd" },
    @{ Source = "\\wsl$\kali-linux\home\creatorbe\.hermes\config.yaml"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\hermes\config.yaml" },
    @{ Source = "\\wsl$\kali-linux\home\creatorbe\.hermes\SOUL.md"; Destination = Join-Path $repoRoot "templates\local-gpu-4gb\hermes\SOUL.md" }
)

foreach ($map in $mappings) {
    if (-not (Test-Path $map.Source)) {
        Write-Warning "Missing source: $($map.Source)"
        continue
    }

    $parent = Split-Path -Parent $map.Destination
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Copy-Item -Force $map.Source $map.Destination
    Write-Host "Refreshed $($map.Destination)"
}

$envExample = Join-Path $repoRoot "templates\local-gpu-4gb\hermes\.env.example"
@(
    "OPENAI_API_KEY=ollama",
    "OPENAI_BASE_URL=http://host.docker.internal:11434/v1",
    "LLM_MODEL=fredrezones55/Jan-code:Q4_K_M"
) | Set-Content -Path $envExample -Encoding ASCII

Write-Host "Public template refresh complete. Review docs if commands or model strategy changed."
