# PowerShell script to package the Paralives 2D Map mod into a releasable build

$ErrorActionPreference = "Stop"

$ProjectDir = $PSScriptRoot
$Version = "1.2.2"
$ZipName = "Paralives2DMap-v$Version.zip"
$ZipPath = Join-Path $ProjectDir $ZipName
$StagingDir = Join-Path $ProjectDir "staging"
$DllPath = Join-Path $ProjectDir "bin\Release\Paralives2DMap.dll"
$ReadmeSource = Join-Path $ProjectDir "src\README-Release.md"

Write-Host "1. Building Paralives 2D Map (Release)..." -ForegroundColor Cyan
dotnet build -c Release "$ProjectDir\Paralives2DMap.csproj"

if (-not (Test-Path $DllPath)) {
    Write-Error "Build failed: DLL not found at $DllPath"
}

Write-Host "2. Creating clean staging folder structure..." -ForegroundColor Cyan
if (Test-Path $StagingDir) {
    Remove-Item -Recurse -Force $StagingDir
}

$PluginStaging = New-Item -ItemType Directory -Force -Path (Join-Path $StagingDir "BepInEx\plugins\Paralives2DMap")

Write-Host "3. Copying release files to staging..." -ForegroundColor Cyan
Copy-Item $DllPath -Destination $PluginStaging
Copy-Item $ReadmeSource -Destination (Join-Path $PluginStaging "README.md")

Write-Host "4. Packaging into ZIP archive..." -ForegroundColor Cyan
if (Test-Path $ZipPath) {
    Remove-Item -Force $ZipPath
}

# Compress staging directory
Compress-Archive -Path (Join-Path $StagingDir "BepInEx") -DestinationPath $ZipPath -Force

Write-Host "5. Cleaning up staging directory..." -ForegroundColor Cyan
Remove-Item -Recurse -Force $StagingDir

Write-Host "`nRelease build completed successfully!" -ForegroundColor Green
Write-Host "Package is ready at: $ZipPath" -ForegroundColor Green
