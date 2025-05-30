@echo off
pushd "%~dp0%"

set BUILD_TYPE=%~1

if "%BUILD_TYPE%" equ "debug" (
    REM ok
) else if "%BUILD_TYPE%" equ "release" (
    REM ok
) else if "%BUILD_TYPE%" equ "" (
    set BUILD_TYPE=release
) else (
    echo Invalid build type name: "%BUILD_TYPE%". Expected "debug", "release" or empty
    set errorLevel=1
    goto end
)

jai first.jai - %BUILD_TYPE%
if %errorLevel% neq 0 goto end
echo.

xcopy /Y build_%BUILD_TYPE%\focus.* C:\Soft\Focus
if %errorLevel% neq 0 goto end

:end
popd
exit /B %errorLevel%
