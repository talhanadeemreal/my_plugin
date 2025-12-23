$ErrorActionPreference = "Stop"

function Check-Command {
    param ([string]$Name)
    if (Get-Command $Name -ErrorAction SilentlyContinue) {
        return $true
    }
    return $false
}

Write-Host "Checking build environment..."

if (-not (Check-Command "hetu")) {
    Write-Error "The 'hetu' CLI is not installed or not in your PATH.`nPlease install it by running: dart pub global activate hetu_script_dev_tools`nMake sure Dart is installed and the pub cache is in your PATH."
}

Write-Host "Compiling plugin..."

if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Force -Path "build" | Out-Null
}

try {
    # Assuming main.ht is the entry point based on plugin.json or standard structure
    # If the entry point is different, update the source path below.
    # The output format is typically a .smplug file (which is often just a zip or raw bytes depending on the implementation, 
    # but standards suggest compiling to bytecode first).
    
    # Standard compilation: compile source to bytecode
    hetu compile src/main.ht
    
    # For Spotube, usually we rename/package it as .smplug
    # If it's just a raw bytecode rename:
    Move-Item "src/main.out" "build/plugin.smplug" -Force
    
    Write-Host "Build successful! Output: build/plugin.smplug" -ForegroundColor Green
}
catch {
    Write-Error "Compilation failed: $_"
}
