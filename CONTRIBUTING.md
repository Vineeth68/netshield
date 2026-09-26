# Contributing to NetShield

Thanks for your interest in NetShield! This started as a hackathon project (Team Byteme, Hackathon 2026) and contributions are welcome.

## Ways to contribute

- **Blocklists** — suggest or curate additional ad/tracker/betting/content blocklists in `config/pihole/custom-blocklists.txt`.
- **Install automation** — improve `scripts/install.sh` (e.g. idempotency, error handling, support for other Pi models/OSes).
- **Documentation** — clarify setup steps, add troubleshooting notes, or expand `docs/ARCHITECTURE.md`.
- **New features** — see the [Roadmap](README.md#roadmap) in the README for ideas (mobile app, scheduled blocking, multi-Pi failover, etc.).

## Getting started

1. Fork the repo and clone your fork.
2. Create a feature branch: `git checkout -b feature/my-improvement`.
3. Make your changes and test them on real hardware where possible.
4. Commit with a clear message and open a pull request describing what changed and why.

## Reporting issues

Please include:
- Raspberry Pi model and OS version
- Pi-hole and Tailscale versions (`pihole -v`, `tailscale version`)
- Steps to reproduce the issue
- Relevant logs (redact anything sensitive, e.g. real domains you visit)

## Code of Conduct

Be respectful and constructive. This is a hackathon-born, community-friendly project — everyone was new to something once.
