#!/bin/bash
# create-kb.sh - Create a new Knowledge Base

set -e

KB_NAME=$1
KB_DESCRIPTION=${2:-"Knowledge Base for ReflecterLABS Agent Team"}
ACCESS_MODE=${3:-all}  # all, or comma-separated seat names

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${ENV_FILE:-$HOME/Workstation/ReflecterLABS-AgentTeam/.env}"

if [ -z "$KB_NAME" ]; then
    echo "Usage: create-kb.sh <kb-name> [description] [access-mode]"
    echo ""
    echo "Examples:"
    echo "  create-kb.sh core \"Organizational knowledge\" all"
    echo "  create-kb.sh projects \"Active projects\" \"commander,manager,engineer\""
    exit 1
fi

# Load env
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "❌ Error: Environment file not found. Run init-workstation.sh first."
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_ORG" ]; then
    echo "❌ Error: GITHUB_TOKEN and GITHUB_ORG must be set"
    exit 1
fi

KB_LOWER=$(echo "$KB_NAME" | tr '[:upper:]' '[:lower:]')
REPO_NAME="kb-${KB_LOWER}"
KB_PATH="${WORKSTATION_BASE:-$HOME/Workstation}/KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')"

echo "📚 Creating Knowledge Base: $KB_NAME"
echo "   Description: $KB_DESCRIPTION"
echo "   Access: $ACCESS_MODE"
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
        -d "{\"name\":\"$REPO_NAME\",\"private\":true,\"description\":\"$KB_DESCRIPTION\",\"auto_init\":true}" > /dev/null
    echo "  ✅ Created repository"
fi

# Create local KB
echo "📁 Creating local KB..."
mkdir -p "$KB_PATH"
cd "$KB_PATH"

if [ -d ".git" ]; then
    echo "  ⚠️  Git already initialized"
else
    git init
    REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_ORG}/${REPO_NAME}.git"
    git remote add origin "$REPO_URL"
    
    # Create README
    cat > README.md <<EOF
# KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')

$KB_DESCRIPTION

## Access

Seats with access: $ACCESS_MODE

## Structure

- Place knowledge files here
- Use markdown for documents
- Organize in subdirectories as needed

## Usage

This KB is symlinked into seats via:
\`\`\`
imports/KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')/
\`\`\`
EOF

    git add .
    git commit -m "Initial KB setup"
    git branch -M main
    git push -u origin main --force
    
    echo "  ✅ Created and pushed KB"
fi

# Create symlinks in seats
echo "🔗 Creating symlinks in seats..."
AGENTS_DIR="${AGENTS_BASE:-$HOME/.openclaw/workspace/agents}"

for seat_dir in "$AGENTS_DIR"/*/; do
    if [ -d "$seat_dir" ]; then
        seat_name=$(basename "$seat_dir")
        imports_dir="$seat_dir/imports"
        
        mkdir -p "$imports_dir"
        
        # Remove existing symlink if any
        if [ -L "$imports_dir/KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')" ]; then
            rm "$imports_dir/KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')"
        fi
        
        # Create symlink
        ln -s "$KB_PATH" "$imports_dir/KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')"
        echo "  ✅ Linked to $seat_name"
    fi
done

# Update workstation.json
echo "📝 Please add to workstation.json:"
cat <<EOF
    {
      "id": "kb-$KB_LOWER",
      "name": "KB-$(echo "$KB_NAME" | sed 's/.*/\u&/')",
      "description": "$KB_DESCRIPTION",
      "github_repo": "https://github.com/$GITHUB_ORG/$REPO_NAME",
      "seats_with_access": [$(echo "$ACCESS_MODE" | sed 's/[^,][^,]*/"&"/g')],
      "auto_sync": true
    }
EOF

echo ""
echo "✅ Knowledge Base '$KB_NAME' created!"
echo ""
