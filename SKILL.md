---
name: workstation
description: ReflecterLABS Agent Team Workstation - Git-backed persistence for AI agents. Use for seat sync, KB sync, listing repos, and workstation operations. Triggers on "workstation", "seat sync", "kb sync", "list repos", "workstation.json".
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

## 📋 workstation.json - Fuente Central de Verdad

**Ubicación**: `~/Workstation/ReflecterLABS-AgentTeam/workstation.json`

Este archivo contiene toda la configuración de la Workstation:
- **Seats**: Todos los agentes del equipo
- **KBs**: Knowledge Bases compartidas
- **Repos**: URLs de GitHub para cada recurso
- **Settings**: Configuración general

### Estructura

```json
{
  "seats": [
    {
      "id": "commander",
      "name": "Commander",
      "github_repo": "https://github.com/.../seat-commander",
      "workspace_path": "~/.openclaw/workspace/agents/Commander",
      "discord_channel_id": "1482427420094107669"
    }
  ],
  "kbs": [
    {
      "id": "kb-core",
      "name": "Core Knowledge Base",
      "github_repo": "https://github.com/.../kb-core",
      "local_path": "~/Workstation/KB-Core",
      "seats_with_access": ["all"]
    }
  ],
  "settings": {
    "ssot_repo": "https://github.com/.../SSOT",
    "skill_repo": "https://github.com/.../Workstation-Skill"
  }
}
```

### Comandos para Consultar

```bash
# Listar todos los repos (seats, KBs, projects)
~/.openclaw/skills/workstation/scripts/workstation-ls
```

---

## 🛠️ Comandos Esenciales

### Seats (Agentes)
```bash
# Sincronizar tu seat (SIEMPRE al terminar)
~/.openclaw/skills/workstation/scripts/workstation-sync

# Ver estado de todos los seats
~/.openclaw/skills/workstation/scripts/workstation-status
```

### Knowledge Bases
```bash
# Sincronizar KBs (después de editar archivos compartidos)
~/.openclaw/skills/workstation/scripts/workstation-kb-sync

# Sincronizar KB específica
~/.openclaw/skills/workstation/scripts/workstation-kb-sync Core
```

### Información
```bash
# Listar todos los repos configurados
~/.openclaw/skills/workstation/scripts/workstation-ls

# Setup inicial
~/.openclaw/skills/workstation/scripts/workstation-init
```

---

## 📚 Knowledge Bases (KBs)

### ¿Qué son las KBs?

**Knowledge Bases** = Repositorios Git compartidos entre agentes.

Ubicación local: `~/Workstation/KB-{nombre}/`

### KBs Configuradas

| KB | Descripción | Acceso | Local Path |
|----|-------------|--------|------------|
| **KB-Core** | Conocimiento organizacional | Todos los agentes | `~/Workstation/KB-Core/` |
| **KB-Projects** | Proyectos activos | Commander, Manager, Engineer | `~/Workstation/KB-Projects/` |
| **KB-Market** | Inteligencia de mercado | Marketing, Seller, Newscaster, Researcher | `~/Workstation/KB-Market/` |

### Cómo se Accede

Cada agente tiene **symlinks** en su seat:
```
~/.openclaw/workspace/agents/{Seat}/
└── imports/
    ├── KB-Core/ → ~/Workstation/KB-Core/
    ├── KB-Projects/ → ~/Workstation/KB-Projects/
    └── KB-Market/ → ~/Workstation/KB-Market/
```

### Flujo de Trabajo con KBs

1. **Leer**: Accede normalmente via `imports/KB-{nombre}/`
2. **Editar**: Modifica archivos (si tienes permiso)
3. **Sincronizar**: Ejecuta `workstation-kb-sync` para subir cambios
4. **Otros agentes**: Ven los cambios al sincronizar sus seats

**Importante**: Las KBs son **compartidas**. Tus cambios afectan a todos los agentes con acceso.

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
   - Usar imports/KB-*/ para conocimiento compartido

5. **Sincronizar**
   - `workstation-sync` para tu seat
   - `workstation-kb-sync` si editaste KBs

---

## 📂 Estructura Completa

### Sistema de Archivos

```
~/Workstation/                          # Workstation base
├── ReflecterLABS-AgentTeam/
│   ├── workstation.json               # ← FUENTE CENTRAL
│   └── .env                           # Configuración local
├── KB-Core/                           # Knowledge Base compartida
├── KB-Projects/                       # Knowledge Base compartida
└── KB-Market/                         # Knowledge Base compartida

~/.openclaw/
├── skills/workstation/ → ~/Workstation-Skill  # Skill (symlink)
└── workspace/agents/
    ├── Commander/                     # Seat individual
    │   ├── AGENTS.md
    │   ├── TOOLS.md
    │   ├── SOUL.md
    │   ├── MEMORY.md
    │   ├── HEARTBEAT.md
    │   ├── memory/
    │   └── imports/                   # Symlinks a KBs
    │       ├── KB-Core/ → ~/Workstation/KB-Core/
    │       └── ...
    ├── Manager/
    ├── Engineer/
    └── ...
```

### Repositorios GitHub

| Tipo | Repositorio | Ejemplo |
|------|-------------|---------|
| **SSOT** | Configuración central | `SSOT-ReflecterLABS-Agent-Team` |
| **Skill** | Esta skill | `Workstation-Skill` |
| **Seats** | Uno por agente | `seat-commander`, `seat-manager`... |
| **KBs** | Uno por KB | `kb-core`, `kb-projects`, `kb-market` |

---

## 🔄 Flujo de Trabajo Completo

### Al Iniciar Sesión
1. Leer **AGENTS.md** (contexto Workstation)
2. Leer **TOOLS.md** (config técnica)
3. Leer **SOUL.md** (identidad)
4. Revisar **HEARTBEAT.md**

### Durante la Sesión
5. Trabajar normalmente
6. Usar **imports/KB-*/** para conocimiento compartido
7. Documentar en **memory/YYYY-MM-DD.md**
8. Decisiones importantes → **MEMORY.md**

### Al Terminar (IMPORTANTE)
9. **workstation-sync** (siempre)
10. **workstation-kb-sync** (solo si editaste KBs)

---

## 🆘 Troubleshooting

### "¿Cuál es mi repo?"
```bash
~/.openclaw/skills/workstation/scripts/workstation-ls
# O leer TOOLS.md en tu seat
```

### "¿Dónde están las KBs?"
```bash
ls ~/Workstation/KB-*/
# O en tu seat: ls imports/KB-*/
```

### "¿Cómo sincronizo KBs?"
```bash
~/.openclaw/skills/workstation/scripts/workstation-kb-sync
```

### "¿Qué repos existen?"
```bash
# Ver workstation.json
~/.openclaw/skills/workstation/scripts/workstation-ls
```

---

_Last updated: 2026-03-15_
