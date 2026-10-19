# verify_hooks.ps1 — 2026-10-12 재구성 검증 (Windows PowerShell 에서 실행)
#   powershell -NoProfile -ExecutionPolicy Bypass -File C:\Projects\NSCM\scripts\rules\verify_hooks.ps1
$ErrorActionPreference = 'Stop'
$root = 'C:\Projects\NSCM'
$hooks = "$root\.claude\hooks"
Write-Host "== 1. 구문 검사 (parse) =="
foreach ($f in Get-ChildItem "$hooks\*.ps1") {
  $errs = $null
  [System.Management.Automation.Language.Parser]::ParseFile($f.FullName, [ref]$null, [ref]$errs) | Out-Null
  if ($errs.Count) { Write-Host "  FAIL $($f.Name): $($errs[0].Message)" -ForegroundColor Red } else { Write-Host "  OK   $($f.Name)" }
}
Write-Host "== 2. attach-context LITE/FULL 판별 =="
$cases = @(
  @{ p = 'DMF0043 화면의 SALES_SITE_ID 컬럼 타입이 뭐야?'; expect = 'LITE' },
  @{ p = 'SHEET_COLUMNS 에 INPUT_TP_CD 값 종류 설명해줘'; expect = 'LITE' },
  @{ p = 'DMF0043 화면 컬럼 폭 수정해줘'; expect = 'FULL' },
  @{ p = 'PKG_DMF0082 조회 SP 성능 개선 적용'; expect = 'FULL' },
  @{ p = '!full 이 SP 뭐하는거야?'; expect = 'FULL' },
  @{ p = 'DMF0099 신규 화면 생성'; expect = 'FULL' }
)
foreach ($c in $cases) {
  $json = @{ prompt = $c.p } | ConvertTo-Json -Compress
  $out = $json | powershell -NoProfile -ExecutionPolicy Bypass -File "$hooks\attach-context.ps1"
  $mode = if (($out -join "`n") -match '\[LITE\]') { 'LITE' } elseif (($out -join "`n") -match '\[FULL\]') { 'FULL' } else { 'NONE' }
  $bytes = [Text.Encoding]::UTF8.GetByteCount(($out -join "`n"))
  $mark = if ($mode -eq $c.expect) { 'OK  ' } else { 'FAIL' }
  Write-Host ("  {0} expect={1} got={2} attached={3}KB  <- {4}" -f $mark, $c.expect, $mode, [int]($bytes/1KB), $c.p)
}
Write-Host "== 3. check-rules-read (가짜 transcript) =="
$tmp = Join-Path $env:TEMP 'nscm_fake_transcript.jsonl'
'{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{"file_path":"C:\\Projects\\NSCM\\Doc\\_rules_consolidation\\TRIGGER_ROUTER.md"}}]}}' | Set-Content $tmp -Encoding UTF8
$payload = @{ tool_name = 'Write'; tool_input = @{ file_path = 'C:\Projects\NSCM\nscm-fe\features\demand\src\pages\x\X.tsx' }; transcript_path = $tmp } | ConvertTo-Json -Compress
$payload | powershell -NoProfile -ExecutionPolicy Bypass -File "$hooks\check-rules-read.ps1" 2>&1 | Out-String | Write-Host
Write-Host ("  exit={0}  (기대: 2 — ui-work-entry-playbook 등 3개 미열람 차단)" -f $LASTEXITCODE)
Write-Host "== 4. 추출본 drift =="
python "$root\scripts\rules\build_router.py" --check
Write-Host "== 5. 상시 컨텍스트 크기 =="
Write-Host ("  CLAUDE.md = {0} bytes (구 20,153)" -f (Get-Item "$root\CLAUDE.md").Length)
Get-ChildItem "$root\.claude\rules\*.md" | ForEach-Object { Write-Host ("  rules/{0} = {1} bytes (경로 매칭 시만 로드)" -f $_.Name, $_.Length) }
