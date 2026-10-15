# opencode-config

Configuración global de OpenCode, incluyendo agentes personalizados, instrucciones de desarrollo y ajustes generales. Repositorio destinado a respaldar, versionar y restaurar la configuración en diferentes ordenadores.

## Estructura del repositorio

```
opencode-config/
├── opencode.json          # Configuración de OpenCode (agente por defecto, permisos, MCP)
├── AGENTS.md              # Instrucciones globales de desarrollo para agentes
├── README.md              # Este archivo
├── .gitattributes         # Normalización de finales de línea
└── agents/
    ├── docs.md            # Agente de documentación técnica
    ├── reviewer.md        # Agente de revisión de código
    └── tester.md          # Agente de diseño y ejecución de pruebas
```

## Agentes personalizados

Los agentes viven en la carpeta `agents/` y se definen con metadatos YAML al inicio del archivo:

| Agente | Descripción | Modo | Permisos destacados |
|--------|-------------|------|---------------------|
| `docs` | Especialista en documentación técnica, README, APIs y explicación de código | subagent | `read`, `glob`, `grep`, `list` |
| `reviewer` | Revisa código en busca de errores, riesgos de seguridad y problemas de mantenibilidad | subagent | `read`, `glob`, `grep`, `list` |
| `tester` | Diseña y ejecuta pruebas para comprobar el comportamiento del software | subagent | `read`, `glob`, `grep`, `list`, `bash` (bajo solicitud) |

Ninguno de estos agentes puede modificar archivos ni ejecutar comandos de forma destructiva sin autorización explícita.

## Configuración de OpenCode (`opencode.json`)

- **Agente por defecto:** `plan`
- **Permisos:**
  - `read`: `ask`
  - `edit`, `bash`, `external_directory`, `*`: `ask`
- **MCP:** servidor `context7` remoto en `https://mcp.context7.com/mcp`

### Recomendaciones para un entorno de desarrollo

| Recomendación | Estado actual | ¿Por qué cambiarlo? |
|---------------|---------------|---------------------|
| **Agente por defecto** | `plan` (solo planifica) | Es conservador y seguro. Si eres un desarrollador activo que usa OpenCode a diario, considera cambiarlo a un agente generalista (por ejemplo, el agente principal de OpenCode) para mayor productividad, dejando `plan` para tareas complejas que requieran desglose paso a paso. |

| **Modelo / proveedor por defecto** | No especificado | Si OpenCode lo soporta, agrega un campo `model` o `provider` en `opencode.json` para evitar que cada ordenador use un modelo distinto (diferentes costos, calidad y comportamiento). Consulta la documentación oficial de OpenCode para saber qué campo usar en tu versión. |

### Cómo desactivar el MCP remoto

Si trabajas con código propietario o regulado, comenta o elimina el bloque `mcp.servers.context7` en `opencode.json` y reinicia OpenCode. Consulta la sección [Privacidad y servicios remotos (MCP)](README.md#privacidad-y-servicios-remotos-mcp).

## Privacidad y servicios remotos (MCP)

Este repositorio configura un servidor MCP remoto (`context7`) en `opencode.json`:

- **Tipo:** remoto
- **URL:** `https://mcp.context7.com/mcp`

### Qué debes saber

- OpenCode puede enviar fragmentos de código, nombres de archivos, rutas y metadatos del proyecto al servidor remoto para recuperar documentación.
- Revisa la política de privacidad del proveedor del MCP antes de usarlo en proyectos sensibles o confidenciales.
- Si trabajas con código propietario o regulado, considera desactivar este servidor o reemplazarlo por un servidor MCP local.
- No almacenes claves de API ni tokens dentro de `opencode.json`. Úsalos a través de variables de entorno si el servidor las soporta.

### Cómo desactivarlo

Comenta o elimina el bloque `mcp.servers.context7` en `opencode.json` y reinicia OpenCode.

## Instalación y configuración en Windows

Esta guía asume OpenCode **v2.0.29** (o superior). Si usas otra versión, ajusta las rutas o comandos según corresponda.

### 1. Clonar el repositorio

Abre PowerShell y clona este repositorio en tu usuario:

```powershell
git clone <url-del-repositorio> $env:USERPROFILE\opencode-config
```

### 2. Ubicación de la configuración en Windows

OpenCode lee su configuración global desde el directorio de usuario, por ejemplo:

```
%USERPROFILE%\.opencode\
```

Si la carpeta no existe, créala:

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.opencode" -Force
```

### 3. Copiar los archivos de configuración

Desde el repositorio clonado, copia lo siguiente a `%USERPROFILE%\.opencode\`:

| Origen | Destino |
|--------|---------|
| `opencode.json` | `%USERPROFILE%\.opencode\opencode.json` |
| `agents/` | `%USERPROFILE%\.opencode\agents\` |
| `AGENTS.md` | `%USERPROFILE%\.opencode\AGENTS.md` |

Ejemplo en PowerShell:

```powershell
Copy-Item -Path "$env:USERPROFILE\opencode-config\opencode.json" -Destination "$env:USERPROFILE\.opencode\opencode.json"
Copy-Item -Path "$env:USERPROFILE\opencode-config\agents" -Destination "$env:USERPROFILE\.opencode\agents" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\opencode-config\AGENTS.md" -Destination "$env:USERPROFILE\.opencode\AGENTS.md"
```

### 4. Reiniciar OpenCode

Cierra y vuelve a abrir OpenCode para que cargue `opencode.json`, los agentes personalizados y las instrucciones de `AGENTS.md`.

### 5. Verificación

- Abre OpenCode y confirma que el agente por defecto es `plan`.
- Verifica que aparecen los agentes `docs`, `reviewer` y `tester` en el selectorio de agentes.
- Revisa que los permisos coincidan con lo definido en `opencode.json` (`read: allow`, resto `ask`).

### Versiones probadas

| Versión de OpenCode | Estado | Fecha |
|---------------------|--------|-------|
| v2.0.29 | Probado | Oct 2026 |

## Instrucciones de desarrollo

Consulta [`AGENTS.md`](AGENTS.md) para conocer las reglas de trabajo, estándares de calidad, verificaciones y directrices de comunicación que rigen en este repositorio.

## Seguridad

- No comitees secretos, contraseñas, tokens ni claves API.
- No leas archivos `.env` salvo que sea imprescindible y esté autorizado.
- No ejecutes comandos destructivos sin aprobación explícita.

## Contribución

Si quieres proponer mejoras a la configuración o a los agentes:

1. Abre un issue describiendo el cambio.
2. Realiza los cambios en una rama separada.
3. Verifica que los archivos de configuración sigan siendo válidos (JSON en `opencode.json`, Markdown en agentes y README).
4. Abre un pull request.

---

_Mantén este README actualizado cuando agregues, elimines o modifiques agentes o la configuración de OpenCode._