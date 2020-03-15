@echo off
echo Build love.js
cmd /c build_love.js_debug.bat
cmd /c build_love.js_release-compatibility.bat
cmd /c build_love.js_release-performance.bat
pause
