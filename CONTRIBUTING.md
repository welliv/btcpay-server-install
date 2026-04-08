# Contributing to BTCPay Server Installer

Thank you for your interest in improving this project.

## How to Contribute

### Report Issues

Found a bug? Something confusing? Open an issue with:
- What you expected to happen
- What actually happened
- Steps to reproduce
- Your server OS and version

### Suggest Features

Open a feature request and describe:
- The use case — what problem would it solve?
- Why it belongs in this skill vs a separate tool
- Any relevant links or context

### Submit PRs

1. Fork the repo
2. Create a branch: `git checkout -b fix/my-fix` or `git checkout -b feature/my-feature`
3. Make your changes
4. Test on a fresh server if possible
5. Commit with a clear message: `git commit -m "Fix: describe what changed"`
6. Push and open a PR

### Coding Standards

- Shell scripts: `set -e` at the top, use `local` for function variables
- Output: clear, colored, actionable — users should know exactly what to do
- No hardcoded IPs or user-specific values
- Test on a clean Ubuntu/Debian VM before submitting

### Branches

- `main` — stable, tested, always deployable
- `develop` — for work-in-progress changes

## Development Setup

```bash
git clone https://github.com/welliv/btcpay-server-install.git
cd btcpay-server-install
```

To test changes locally without deploying to a real server, you can inspect the generated Docker compose files:

```bash
# Preview what deploy.sh would generate (dry run on test server)
docker-compose -f generated/docker-compose.generated.yml config
```

## Questions?

Open an issue and label it as `question`. I'll respond within a few days.
