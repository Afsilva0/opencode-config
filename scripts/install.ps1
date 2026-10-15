# scripts/install.ps1
# Instalación automatizada de opencode-config en Windows
# Requisitos: git instalado y OpenCode instalado

param(
    [string]$RepoUrl = "https://github.com/Afsilva0/opencode-config.git",
    [string]$CloneDir = "$env:USERPROFILE\opencode-config",
    [string]$OpenCodeDir = "$env:USERPROFILE\.opencode"
)

Write-Host "=== Instalación de opencode-config en Windows ===" -ForegroundColor Cyan

# 1. Clonar el repositorio si no existe
if (Test-Path $CloneDir) {
    Write-Host "La carpeta $CloneDir ya existe. Saltando clonación." -ForegroundColor Yellow
} else {
    Write-Host "Clonando repositorio desde $RepoUrl ..." -ForegroundColor Cyan
    git clone $RepoUrl $CloneDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al clonar el repositorio."
        exit 1
    }
}

# 2. Crear el directorio de configuración de OpenCode si no existe
if (-not (Test-Path $OpenCodeDir)) {
    New-Item -ItemType Directory -Path $OpenCodeDir -Force | Out-Null
    Write-Host "Creado directorio de configuración: $OpenCodeDir" -ForegroundColor Green
} else {
    Write-Host "El directorio $OpenCodeDir ya existe." -ForegroundColor Yellow
}

# 3. Copiar archivos de configuración
Write-Host "Copiando archivos de configuración..." -ForegroundColor Cyan

Copy-Item -Path "$CloneDir\opencode.json" -Destination "$OpenCodeDir\opencode.json" -Force
Copy-Item -Path "$CloneDir\AGENTS.md" -Destination "$OpenCodeDir\AGENTS.md" -Force
Copy-Item -Path "$CloneDir\agents" -Destination "$OpenCodeDir\agents" -Recurse -Force

Write-Host "" -ForegroundColor Cyan
Write-Host "=== Instalación completada ===" -ForegroundColor Cyan
Write-Host "Reinicia OpenCode para que cargue opencode.json, los agentes y AGENTS.md." -ForegroundColor Yellow