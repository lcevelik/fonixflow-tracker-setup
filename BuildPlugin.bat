@echo off
setlocal EnableDelayedExpansion

set PLUGIN="F:\Codebase\fonixflow-tracker-setup\FonixFlowTrackerSetup\FonixFlowTrackerSetup.uplugin"
set OUTPUT_ROOT="F:\Codebase\Build"

set VERSIONS=5.5 5.6 5.7 5.8

for %%V in (%VERSIONS%) do (
    echo.
    echo ============================================================
    echo  Building for UE %%V
    echo ============================================================

    set UAT="D:\UE_Engine\UE_%%V\Engine\Build\BatchFiles\RunUAT.bat"

    if not exist !UAT! (
        echo   [SKIP] UE %%V not found at D:\UE_Engine\UE_%%V
    ) else (
        call !UAT! BuildPlugin ^
            -Plugin=%PLUGIN% ^
            -Package=%OUTPUT_ROOT%\FonixFlowTrackerSetup_%%V ^
            -Rocket

        if !errorlevel! == 0 (
            echo   [OK] UE %%V build succeeded
        ) else (
            echo   [FAIL] UE %%V build failed with error !errorlevel!
        )
    )
)

echo.
echo ============================================================
echo  All done. Output at %OUTPUT_ROOT%
echo ============================================================
pause
