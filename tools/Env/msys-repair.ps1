# MSYS2(Git Bash) 'add_item ... failed, errno 1' 복구 — 2026-10-22
# 원인: msys-2.0.dll 의 사용자별 공유 메모리 초기화 경합(git-for-windows/git#6368 · msys2/msys2-runtime#333 미배포).
#   초기화 중인 bash 가 강제 종료되면 공유 메모리가 '반쯤 초기화'된 채 남아, 모든 MSYS 프로세스가 끝날 때까지 새 bash 가 전부 실패한다.
# 평소 예방: tools/Env/msys-anchor.vbs (시작프로그램 등록) 가 sleep.exe infinity 를 상시 띄워 초기화가 한 번만 일어나게 한다.
# 이 스크립트: 이미 오염된 상태를 복구 — Git for Windows 의 MSYS 프로세스를 전부 종료(⚠ 다른 Claude 세션의 실행 중 Bash 명령도 끊긴다) → 앵커 재기동 → 확인.
#   powershell -NoProfile -ExecutionPolicy Bypass -File tools\Env\msys-repair.ps1
$git = 'C:\Program Files\Git\'
$find = { Get-CimInstance Win32_Process | Where-Object { $_.ExecutablePath -and $_.ExecutablePath.StartsWith($git, [StringComparison]::OrdinalIgnoreCase) } }
# 다른 세션이 몇 초 안에 bash 를 다시 띄우므로 3초 동안 0.1초 간격으로 반복 종료한 뒤 곧바로 앵커를 띄운다(이슈 보고의 검증된 방식)
$t0 = Get-Date; $n = 0
while (((Get-Date) - $t0).TotalSeconds -lt 3) { & $find | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue; $n++ }; Start-Sleep -Milliseconds 100 }
Start-Process -FilePath ($git + 'usr\bin\sleep.exe') -ArgumentList 'infinity' -WindowStyle Hidden
Start-Sleep -Milliseconds 500
$o = & ($git + 'bin\bash.exe') -c -l 'echo ok' 2>&1 | Out-String
"MSYS 프로세스 종료 $n 회 · 앵커 재기동 · bash 확인: " + $(if ($o -match 'ok' -and $o -notmatch 'fatal') { '정상' } else { '실패 — ' + $o.Trim() })
