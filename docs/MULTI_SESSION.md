# Multi-Session Agent Configuration

## Configuración de Sesiones Múltiples

Cada agente tiene **dos sesiones**:
1. **Sesión Privada** - Canal individual del agente
2. **Sesión Global** - Canal de reunión compartido

### Estructura de Canales por Agente

| Agente | Canal Privado | Canal Global (Reunión) |
|--------|--------------|------------------------|
| Commander | 1482427420094107669 | 1482524442482442282 |
| Manager | 1482427277903007754 | 1482524442482442282 |
| Engineer | 1480863964220096583 | 1482524442482442282 |
| Researcher | 1480864081253634080 | 1482524442482442282 |
| Marketing | 1479242726515146823 | 1482524442482442282 |
| Seller | 1480863129608130561 | 1482524442482442282 |
| Newscaster | 1482427785849864283 | 1482524442482442282 |
| DevOps | 1482427420094107669 | 1482524442482442282 |

### Comportamiento por Tipo de Sesión

#### Sesión Privada
- Recibe **todos** los mensajes del canal privado
- Responde a todas las consultas
- Contexto: Comunicación 1-a-1 con el agente

#### Sesión Global (Reunión)
- Recibe mensajes del canal #agenteam-reflecterlabs
- **Responde solo si:**
  - Es mencionado por nombre (@Agente)
  - La pregunta va dirigida a su rol
  - Es una coordinación de equipo
- **Usa reacciones si:**
  - Solo necesita ACK (👍 ✅ 💡)
  - No aporta valor una respuesta completa

### Comandos de Activación

```bash
# Activar un agente específico en el canal global
~/.openclaw/skills/workstation/scripts/workstation-activate-agent Commander
~/.openclaw/skills/workstation/scripts/workstation-activate-agent Manager
# ... etc para cada agente
```

### Configuración del Gateway

Para cada agente, crear una entrada en la configuración del Gateway:

```json
{
  "agent": "Manager",
  "seat_path": "~/.openclaw/workspace/agents/Manager",
  "channels": [
    "1482427277903007754",
    "1482524442482442282"
  ],
  "routing": {
    "1482427277903007754": "always_respond",
    "1482524442482442282": "respond_on_mention"
  }
}
```

### Flujo de Trabajo en Reuniones

1. **Inicio de reunión** en #agenteam-reflecterlabs
2. **Todos los agentes** están escuchando
3. **Cuando alguien habla**:
   - Si no menciona a nadie → Todos escuchan, nadie responde
   - Si menciona @Manager → Solo Manager responde
   - Si es una pregunta general → El más relevante responde
4. **Fin de reunión** → Todos sincronizan sus estados

### Reglas de Etiqueta en Reuniones

- **Mencionar** al agente específico cuando se le habla
- **Esperar** la respuesta antes de continuar
- **Usar reacciones** para ACK rápido
- **Un agente a la vez** (evitar overlapping)

_Last updated: 2026-03-15_
