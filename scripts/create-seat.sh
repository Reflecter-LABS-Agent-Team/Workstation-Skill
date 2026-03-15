#!/bin/bash
# create-seat.sh - Create a new agent seat

set -e

SEAT_NAME=$1
SEAT_ROLE=${2:-agent}
DISCORD_CHANNEL=${3:-}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-$HOME/Workstation/ReflecterLABS-AgentTeam/.env}"

if [ -z "$SEAT_NAME" ]; then
    echo "Usage: create-seat.sh <seat-name> [role] [discord-channel-id]"
    echo ""
    echo "Examples:"
    echo "  create-seat.sh engineer developer 1480863964220096583"
    echo "  create-seat.sh manager project-manager"
    exit 1
fi

# Load env
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "❌ Error: Environment file not found. Run init-workstation.sh first."
    exit 1
fi

# Validate
if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_ORG" ]; then
    echo "❌ Error: GITHUB_TOKEN and GITHUB_ORG must be set in $ENV_FILE"
    exit 1
fi

SEAT_LOWER=$(echo "$SEAT_NAME" | tr '[:upper:]' '[:lower:]')
REPO_NAME="seat-${SEAT_LOWER}"
SEAT_PATH="${AGENTS_BASE:-$HOME/.openclaw/workspace/agents}/$SEAT_NAME"

echo "🪑 Creating seat: $SEAT_NAME"
echo "   Role: $SEAT_ROLE"
echo "   Repo: $GITHUB_ORG/$REPO_NAME"
echo "   Path: $SEAT_PATH"
echo ""

# Create GitHub repo
echo "📦 Creating GitHub repository..."
REPO_CHECK=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$GITHUB_ORG/$REPO_NAME" | grep -c '"id"' || true)

if [ "$REPO_CHECK" -gt 0 ]; then
    echo "  ⚠️  Repository already exists"
else
    curl -s -X POST \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/orgs/$GITHUB_ORG/repos" \
        -d "{\"name\":\"$REPO_NAME\",\"private\":true,\"description\":\"Workstation seat for $SEAT_NAME\",\"auto_init\":true}" > /dev/null
    echo "  ✅ Created repository"
fi

# Create local seat directory
echo "📁 Creating local seat..."
mkdir -p "$SEAT_PATH"
cd "$SEAT_PATH"

if [ -d ".git" ]; then
    echo "  ⚠️  Git already initialized"
else
    git init
    
    # Configure remote with token
    REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_ORG}/${REPO_NAME}.git"
    git remote add origin "$REPO_URL"
    
    # Create base files
    mkdir -p memory
    
    # AGENTS.md
    cat > AGENTS.md <<EOF
# AGENTS.md - $SEAT_NAME

## 🏢 Workstation Integration

**Seat ID**: $SEAT_LOWER  
**Role**: $SEAT_ROLE  
**Organization**: $GITHUB_ORG

### 🔄 Workflows

- Sync: workstation-seat-sync.sh
- Status: workstation-seat-status.sh

## Session Startup

1. Read SOUL.md
2. Read memory/YYYY-MM-DD.md
3. Check HEARTBEAT.md

## Memory

- Daily: memory/YYYY-MM-DD.md
- Long-term: MEMORY.md (main session only)
EOF

    # HEARTBEAT.md
    cat > HEARTBEAT.md <<'EOF'
# HEARTBEAT.md

_Heartbeat: Check status, reply HEARTBEAT_OK if nothing needs attention._

## Checklist

- [ ] Review pending tasks
- [ ] Check for sync needs
- [ ] Respond to mentions

## Status

_Last check:_
EOF

    # MEMORY.md
    cat > MEMORY.md <<EOF
# MEMORY.md - Long-Term Memory

**Seat**: $SEAT_LOWER  
**Activated**: $(date +%Y-%m-%d)

## Notes

EOF

    # TOOLS.md
    cat > TOOLS.md <<'EOF'
# TOOLS.md - Local Tools

## Workstation Commands

```bash
# Sync seat
~/.openclaw/skills/workstation/scripts/seat-sync.sh

# Check status
~/.openclaw/skills/workstation/scripts/seat-status.sh

# Claim file
~/.openclaw/skills/workstation/scripts/seat-claim.sh path/to/file.md 45 "reason"
```
EOF

    # IDENTITY.md
    cat > IDENTITY.md <<EOF
# IDENTITY.md

- **Name:** $SEAT_NAME
- **Role:** $SEAT_ROLE
- **Emoji:** 🤖

## Public Bio

Agent for ReflecterLABS Agent Team.
EOF

    # SOUL.md (template - should be customized)
    cat > SOUL.md <<EOF
# SOUL.md - $SEAT_NAME

## Core Truths

- Mission: [Define core mission]
- Values: [Define key values]

## Boundaries

- [Define boundaries]

## Vibe

[Define personality]

## Continuity

[Define memory priorities]
EOF

    # Daily log
    mkdir -p memory
    cat > "memory/$(date +%Y-%m-%d).md" <<EOF
# $(date +%Y-%m-%d) - Daily Log

## 🌅 Start

- Seat initialized

## Activities

- [x] Workstation setup

## Notes

First day as $SEAT_NAME.
EOF

    # Commit and push
    git add .
    git commit -m "Initial seat setup for $SEAT_NAME"
    git branch -M main
    git push -u origin main --force
    
    echo "  ✅ Created and pushed local seat"
fi

# Update workstation.json
echo "📝 Updating workstation.json..."
WORKSTATION_JSON="${WORKSTATION_BASE:-$HOME/Workstation}/ReflecterLABS-AgentTeam/workstation.json"

if [ -f "$WORKSTATION_JSON" ]; then
    echo "  ⚠️  Please manually add seat to workstation.json:"
    cat <<EOF
    {
      "id": "$SEAT_LOWER",
      "name": "$SEAT_NAME",
      "role": "$SEAT_ROLE",
      "emoji": "🤖",
      "status": "active",
      "discord_channel_id": "${DISCORD_CHANNEL:-}",
      "github_repo": "https://github.com/$GITHUB_ORG/$REPO_NAME",
      "workspace_path": "$SEAT_PATH",
      "permissions": ["sync-own-seat"]
    }
EOF
else
    echo "  ⚠️  workstation.json not found. Run init-workstation.sh first."
fi

echo ""
echo "✅ Seat '$SEAT_NAME' created successfully!"
echo ""
echo "Location: $SEAT_PATH"
echo "Repo: https://github.com/$GITHUB_ORG/$REPO_NAME"
echo ""
