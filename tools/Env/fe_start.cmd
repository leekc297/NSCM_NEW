@echo off
rem FE dev server start + i18n JSON auto-regeneration (2026-11-13, user request: generate i18n JSON on FE START).
rem Called by Vibe_Manager quick.json "FE Start" with cwd = nscm-fe\apps\web (works from cmd /c and from a PowerShell terminal).
rem  1) fe_start_i18n.py runs in the background: waits for local BE (8080), then regenerates nscm-fe\public\locales\*.json.
rem     It never blocks vite. Turn off with VIBE_FE_I18N=off. If python is not on PATH the step is skipped silently.
rem  2) vite runs in the foreground exactly as before.
where python >nul 2>nul && start "" /b python "%~dp0fe_start_i18n.py"
call node_modules\.bin\vite.cmd --port 5173 --host 127.0.0.1 %*
