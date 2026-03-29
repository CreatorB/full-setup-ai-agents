# OpenClaw Custom Skills

## Skills (7 total)

| # | Skill | LLM? | Trigger | Description |
|---|---|---|---|---|
| 1 | coding-assistant | Yes | On-demand (terminal/Telegram) | Multi-stack coding across web, mobile, backend, DevOps, and infrastructure |
| 2 | doc-writer | Yes | On-demand | Multi-lingual documentation and technical writing (ID/EN/AR) |
| 3 | notif-monitor | No | Cron */5 | Unified monitor: email, WhatsApp groups, Telegram groups |
| 4 | student-grader | Yes | Triggered by notif-monitor | Grade student assignments from email attachments |
| 5 | infra-monitor | No | Cron */3 | MikroTik, UniFi, Aruba, CCTV Xiaomi 360, PABX, power outage detection |
| 6 | teaching-material | Yes | On-demand | Generate teaching materials for IT/ICT grades 7-12 |
| 7 | daily-planner | Yes | Cron 04:00 + 13:00 | Smart daily schedule aggregating data from all skills |

## Supported Tech Stacks (coding-assistant)

### Web Development
- **Frontend:** Next.js, React.js, TypeScript, Vue, Tailwind CSS, Bootstrap
- **Backend:** PHP (Laravel, CodeIgniter), Node.js, Express.js, Spring Boot, FastAPI, Go, .NET
- **API:** REST, GraphQL, WebSocket
- **CMS:** WordPress, Strapi, Odoo, Drupal

### Mobile Development
- **Cross-platform:** Flutter, React Native
- **Native:** Java/Kotlin (Android), Swift (iOS)

### Databases
- **SQL:** MySQL, PostgreSQL, SQLite
- **NoSQL:** MongoDB, Firebase Firestore
- **Caching:** Redis, Memcached

### DevOps & Cloud
- **Cloud:** AWS, Google Cloud, DigitalOcean
- **CI/CD:** GitHub Actions, GitLab CI, Jenkins
- **Containers:** Docker, Docker Compose, Kubernetes
- **Monitoring:** Sentry, Google Analytics

### Infrastructure
- **Networking:** MikroTik, UniFi, Aruba Switch, PABX
- **IoT/Hardware:** Arduino, Raspberry Pi, CCTV Xiaomi 360
- **Security:** SSL/TLS, vulnerability assessment, ethical hacking

## Design Principles

- Skills without LLM = lightweight cron + API/SSH/IMAP (no VRAM usage)
- Skills with LLM = Ollama on-demand, release VRAM when done
- Sensitive data (grades, personal info) = local only, never cloud
- All notifications routed to Telegram (primary channel)
- Multi-lingual support: Indonesian, English, Arabic

## Each Skill Directory

Each skill directory contains:
- `README.md` — Purpose, triggers, dependencies, configuration
- Implementation files (to be added as skills are built)
