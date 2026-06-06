@echo off
REM Build Paralives 2D Map and auto-deploy to BepInEx\plugins (path set by GameDir in the csproj).
echo Building Paralives 2D Map (Release)...
dotnet build -c Release "%~dp0Paralives2DMap.csproj"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo BUILD FAILED. See the errors above.
    pause
    exit /b %ERRORLEVEL%
)
echo.
echo Build + deploy succeeded. Launch Paralives, load a save, press F7 (or click "Open 2D Map").
pause
