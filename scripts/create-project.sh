#!/bin/bash
# create-project.sh - Create a new project within KB-Projects

set -e

PROJECT_NAME=$1
PROJECT_DESCRIPTION=${2:-""}

ENV_FILE="${ENV_FILE:-$HOME/Workstation/ReflecterLABS-AgentTeam/.env}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: create-project.sh <project-name> [description]"
    exit 1
fi

if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

KB_PROJECTS_PATH="${WORKSTATION_BASE:-$HOME/Workstation}/KB-Projects"

if [ ! -d "$KB_PROJECTS_PATH" ]; then
    echo "❌ Error: KB-Projects not found. Run create-kb.sh projects first."
    exit 1
fi

PROJECT_DIR="$KB_PROJECTS_PATH/$PROJECT_NAME"

echo "📁 Creating project: $PROJECT_NAME"
mkdir -p "$PROJECT_DIR"

cat > "$PROJECT_DIR/README.md" <<EOF
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## Status

**Phase**: Planning  
**Start**: $(date +%Y-%m-%d)  
**Target**: 

## Goals

- [ ] Goal 1
- [ ] Goal 2

## Team

- 

## Resources

- 

## Notes

EOF

cat > "$PROJECT_DIR/backlog.md" <<EOF
# Backlog: $PROJECT_NAME

## TODO

| Task | Assignee | Priority | Status |
|------|----------|----------|--------|
| Setup project | | P0 | Done |

## In Progress

## Done

EOF

cd "$KB_PROJECTS_PATH"
git add "$PROJECT_NAME"
git commit -m "Create project: $PROJECT_NAME"
git push

echo "✅ Project '$PROJECT_NAME' created in KB-Projects"
echo "Location: $PROJECT_DIR"
