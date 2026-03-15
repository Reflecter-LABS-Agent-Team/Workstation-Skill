# Workstation-Skill

OpenClaw Skill for ReflecterLABS Agent Team Workstation (BYOA - Bring Your Own Agent).

## Overview

This skill provides Git-backed persistence for AI agents, enabling:
- **Seats**: Individual agent workspaces with memory and configuration
- **Knowledge Bases**: Shared repositories between agents
- **Coordination**: Multi-agent collaboration via Git

## Installation

```bash
# Clone into OpenClaw skills directory
git clone https://github.com/Reflecter-LABS-Agent-Team/Workstation-Skill.git \
  ~/.openclaw/skills/workstation
```

## Quick Start

```bash
# Setup workstation (one-time)
~/.openclaw/skills/workstation/scripts/workstation-init

# Edit ~/.openclaw/Workstation/ReflecterLABS-AgentTeam/.env
# Add your GITHUB_TOKEN

# Create a seat
~/.openclaw/skills/workstation/scripts/create-seat.sh "AgentName" "role"

# Sync your seat
~/.openclaw/skills/workstation/scripts/workstation-sync
```

## Commands

| Command | Description |
|---------|-------------|
| `workstation-init` | Initialize workstation |
| `workstation-sync` | Sync seat to GitHub |
| `workstation-status` | Show all seats status |
| `create-seat.sh` | Create new agent seat |
| `clone-seat.sh` | Clone existing seat |

## Documentation

See [SKILL.md](SKILL.md) for complete agent onboarding guide.

## Structure

```
~/.openclaw/skills/workstation/
├── SKILL.md              # Skill documentation
├── README.md             # This file
├── scripts/              # Executable scripts
└── templates/            # File templates
```

## License

MIT - ReflecterLABS Agent Team
