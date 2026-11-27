# 2026-11-26 개선안 20261126164445_VISION_5 시험: harness-gen-context.ps1 발동 조건과 폴더 판정. 임시 폴더(NSCM_ROOT), 실제 Doc\gen 을 읽지 않음
#   사용: powershell -NoProfile -ExecutionPolicy Bypass -File tools/Harness/test/t_harness_gen_context.ps1
$ErrorActionPreference = 'Stop'
$OutputEncoding = New-Object System.Text.UTF8Encoding $false  # 자식 powershell 표준 입력으로 한글 프롬프트 전달(PS5 기본 ASCII)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$hook = Join-Path $PSScriptRoot '..\hooks\harness-gen-context.ps1'
$tmp = Join-Path $env:TEMP ("hgc_" + [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force "$tmp\Doc\gen\SCP0005" | Out-Null
New-Item -ItemType Directory -Force "$tmp\Doc\gen\SCP0028" | Out-Null
Set-Content "$tmp\Doc\gen\SCP0028\GEN_NOTES.md" '생성 메모 표본' -Encoding UTF8
$script:ok = $true
function Invoke-Hook([string]$prompt, [string]$orch) {
  $env:NSCM_ROOT = $tmp; if ($orch) { $env:VIBE_ORCH = $orch } else { Remove-Item Env:VIBE_ORCH -ErrorAction SilentlyContinue }
  $json = @{ prompt = $prompt } | ConvertTo-Json -Compress
  $out = $json | powershell -NoProfile -ExecutionPolicy Bypass -File $hook
  return ($out -join "`n")
}
function Test-Case([string]$name, [bool]$cond, [string]$x) { if ($cond) { "PASS $name" } else { "FAIL $name $x"; $script:ok = $false } }
$o = Invoke-Hook 'SSP0020 신규 개발 진행해줘' '1'
Test-Case '① VMO 가 띄운 Claude(VIBE_ORCH=1) = 발동 안 함' ($o.Trim() -eq '') $o
$o = Invoke-Hook "개선안 목록:`n- SSP0020 체크 결과 보기`n- 생성기 시험 추가" ''
Test-Case '② 화면ID 와 의도 단어가 다른 줄 = 발동 안 함' ($o.Trim() -eq '') $o
$o = Invoke-Hook 'SSP0099 화면을 신규 개발해줘' ''
Test-Case '③ 실제 신규 지시 · 폴더 없음 = 1) 부터 실행' (($o -match '\[Harness\] 화면 SSP0099') -and ($o -match 'SSP0099 없음')) $o
$o = Invoke-Hook 'SCP0005 이식 구현 이어서 해줘' ''
Test-Case '④ 폴더 있음 · GEN_NOTES 없음 = 다시 생성 금지 안내' (($o -match 'SCP0005 있음') -and ($o -match '다시 실행 금지') -and ($o -notmatch '없음 —')) $o
$o = Invoke-Hook 'SCP0028 개발 계속' ''
Test-Case '⑤ GEN_NOTES 있음 = 메모 첨부' ($o -match '생성 메모 표본') $o
$o = Invoke-Hook '신규 화면 개발 일정 알려줘' ''
Test-Case '⑥ 화면ID 없음 = 발동 안 함' ($o.Trim() -eq '') $o
Remove-Item Env:NSCM_ROOT, Env:VIBE_ORCH -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $tmp
if ($script:ok) { 'ALL PASS'; exit 0 } else { 'SOME FAIL'; exit 1 }
