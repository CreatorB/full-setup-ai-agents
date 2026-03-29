# coding-assistant

## Purpose

Multi-stack coding assistant covering the full range of web, mobile, backend, DevOps, and infrastructure technologies. Supports code generation, review, debugging, refactoring, testing, and explanation across all stacks.

## LLM Required

Yes. Uses Ollama for code reasoning and generation.

## Trigger

On-demand via terminal or Telegram chat.

## Supported Stacks

### Web Development
| Layer | Technologies |
|---|---|
| Frontend | Next.js, React.js, TypeScript, Vue, Tailwind CSS, Bootstrap |
| Backend | PHP (Laravel, CodeIgniter), Node.js, Express.js, Spring Boot, FastAPI, Go, .NET |
| API | REST, GraphQL, WebSocket |
| CMS | WordPress, Strapi, Odoo, Drupal |

### Mobile Development
| Layer | Technologies |
|---|---|
| Cross-platform | Flutter (Dart), React Native |
| Native Android | Java, Kotlin |
| Native iOS | Swift |

### Databases
| Type | Technologies |
|---|---|
| SQL | MySQL, PostgreSQL, SQLite |
| NoSQL | MongoDB, Firebase Firestore |
| Caching | Redis, Memcached |

### DevOps & Cloud
| Category | Technologies |
|---|---|
| Cloud | AWS, Google Cloud, DigitalOcean |
| CI/CD | GitHub Actions, GitLab CI, Jenkins |
| Containers | Docker, Docker Compose, Kubernetes |
| Monitoring | Sentry, Google Analytics |

### Infrastructure & Networking
| Category | Technologies |
|---|---|
| Routing | MikroTik RouterOS |
| Switching | UniFi, Aruba |
| Telephony | PABX systems |
| IoT | Arduino, Raspberry Pi |
| CCTV | Xiaomi 360 smarthome, IP cameras |
| Security | SSL/TLS, firewall rules, vulnerability scanning |

### System Administration
| Category | Technologies |
|---|---|
| Scripting | Bash, PowerShell, Python |
| OS | Linux (Ubuntu, CentOS, Kali), Windows Server |
| Automation | cron jobs, systemd, Task Scheduler |
| Version Control | Git, GitHub, GitLab, Bitbucket |
| Testing | Jest, PHPUnit, Postman |
| Project Management | Jira, Trello, GitHub Projects |

### AI & Machine Learning (Learning)
| Category | Technologies |
|---|---|
| ML | Python, scikit-learn, TensorFlow, PyTorch |
| LLM | Model training, fine-tuning, GGUF quantization, publishing |
| Hardware | CUDA, Ollama, local inference optimization |

## Capabilities

| Action | Description |
|---|---|
| Generate | Create boilerplate, functions, classes, components, APIs, configs |
| Review | Analyze code for bugs, security issues, performance, best practices |
| Debug | Read error messages and stack traces, suggest fixes |
| Refactor | Identify code smells, propose cleaner patterns |
| Explain | Explain code logic in Indonesian, English, or Arabic |
| Test | Generate unit tests, integration tests, API tests |
| Document | Add inline comments, generate docstrings, write API docs |
| Migrate | Assist with framework migrations, database migrations, version upgrades |
| Deploy | Generate Dockerfiles, CI/CD configs, Kubernetes manifests |

## Example Prompts (via Telegram)

```
"review this Laravel controller for security issues"
"write a Flutter widget for a prayer time card"
"create a REST API endpoint in Go for user registration"
"generate a Dockerfile for this Next.js project"
"explain this MikroTik firewall rule in Indonesian"
"write unit tests for this React component using Jest"
"help me set up GitHub Actions CI/CD for this PHP project"
"debug this Spring Boot error: <paste stack trace>"
"create a PostgreSQL migration for a student grades table"
"write an Arduino sketch to read temperature from DHT22"
```

## Config

No additional configuration needed. Uses the default Ollama model configured in `openclaw.json`.
