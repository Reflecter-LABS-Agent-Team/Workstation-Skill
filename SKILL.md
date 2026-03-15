---
name: workstation
description: ReflecterLABS Agent Team Workstation - Git-backed persistence for AI agents. Use for seat sync, status checks, and workstation operations. Triggers on "workstation", "seat sync", "agent status".
---

# Workstation Skill

Sistema BYOA (Bring Your Own Agent) para el equipo de agentes de ReflecterLABS.

---

## ¿Qué es Workstation?

Cada **agente** tiene un **Seat** - un directorio Git-backed con:
- **Identidad** (SOUL.md)
- **Memoria** (MEMORY.md, memory/)
- **Configuración** (AGENTS.md, TOOLS.md)
- **KBs compartidas** (imports/KB-*/)

**Todo se sincroniza a GitHub** para persistencia entre sesiones.

---

## Comandos Esenciales

```bash
# Sincronizar (SIEMPRE al terminar)
~/.openclaw/skills/workstation/scripts/workstation-sync

# Ver estado del equipo
~/.openclaw/skills/workstation/scripts/workstation-status

# Setup inicial
~/.openclaw/skills/workstation/scripts/workstation-init
```

---

## 🎯 Incorporación al Contexto del Agente

### Flujo Estándar

```
AGENTS.md (punto de entrada)
    ↓
├─ TOOLS.md → URLs/repos, config técnica, comandos
├─ SOUL.md → Identidad del agente
├─ MEMORY.md → Memoria persistente
└─ memory/ → Logs diarios
```

### Paso a Paso

1. **Leer AGENTS.md**
   - Entiende qué es Workstation
   - Conoce tu rol en el equipo
   - Identifica la referencia a TOOLS.md

2. **Leer TOOLS.md**
   - Obtén tu **URL de repositorio**
   - Conoce tu **ruta local**
   - Identifica **comandos disponibles**

3. **Leer SOUL.md**
   - Recuerda tu identidad

4. **Trabajar**
   - Documentar en memory/YYYY-MM-DD.md

5. **Sincronizar**
   - `workstation-sync` al terminar

---

## 📂 Estructura de Archivos por Agente

### AGENTS.md (OBLIGATORIO - Leer primero)
Contiene:
- Qué es Workstation
- Tu rol en el equipo
- Referencia a TOOLS.md ("Ver para URLs/repos")
- Flujo de incorporación
- Comandos básicos

### TOOLS.md (OBLIGATORIO - Leer segundo)
Contiene:
```markdown
## Mi Seat
- **ID**: {seat-id}
- **Repositorio**: https://github.com/.../seat-{nombre}
- **Ruta local**: ~/.openclaw/workspace/agents/{Nombre}
- **Branch**: main

## Workstation Config
- **Skill path**: ~/.openclaw/skills/workstation/
- **SSOT**: ~/Workstation/ReflecterLABS-AgentTeam/

## Comandos Disponibles
| Comando | Descripción |
|---------|-------------|
| `workstation-sync` | Sincroniza cambios a GitHub |
```

### Resto de archivos
- **SOUL.md** - Identidad
- **MEMORY.md** - Memoria largo plazo
- **HEARTBEAT.md** - Checklist diario
- **memory/** - Logs diarios

---

## 📁 Estructura de la Skill

```
workstation/
├── SKILL.md                    # Este archivo
├── README.md                   # Documentación
├── scripts/
│   ├── workstation-init        # Setup inicial
│   ├── workstation-sync        # Sincronizar seat
│   ├── workstation-status      # Ver estado
│   ├── create-seat.sh          # Crear nuevo seat
│   └── clone-seat.sh           # Clonar seat existente
└── templates/
    ├── AGENTS.md.template      # Template para AGENTS.md
    └── TOOLS.md.template       # Template para TOOLS.md
```

---

## 🆕 Incorporar Agente Existente

Si hay un agente en `~/.openclaw/workspace/agents/{Nombre}` sin Workstation:

### 1. Crear AGENTS.md y TOOLS.md desde templates
### 2. Crear Repo GitHub
```bash
~/.openclaw/skills/workstation/scripts/create-seat.sh "Nombre" "rol"
```

### 3. Sincronizar
```bash
~/.openclaw/skills/workstation/scripts/workstation-sync
```

---

## 🔄 Flujo de Trabajo Diario

1. **Inicio**: AGENTS.md → TOOLS.md → SOUL.md
2. **Trabajo**: Documentar en archivos
3. **Fin**: `workstation-sync`

---

## 🆘 Troubleshooting

### "¿Cuál es mi repo?"
Leer TOOLS.md - ahí está la URL.

### "¿Dónde están los comandos?"
Leer TOOLS.md - tabla de comandos.

### "¿Cómo incorporo Workstation?"
Flujo: AGENTS.md → TOOLS.md → SOUL.md → trabajo → sync

---

_Last updated: 2026-03-15_
