@echo off
pushd "%~dp0%"

jai first.jai - release
if %errorLevel% neq 0 goto end
echo.

xcopy /Y build_release\focus.* C:\Soft\Focus
if %errorLevel% neq 0 goto end

:end
popd
exit /B %errorLevel%
