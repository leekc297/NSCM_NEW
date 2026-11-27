<#
  TobeFacts — To-Be(FE nscm-fe + BE nscm-be) Fact 추출 → 교차검증 → 화면별 Pack
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1            # 전체
         powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1 -SkipCheck # 교차검증 생략
  결과:  Doc\tobefacts\*.csv, Doc\tobefacts\screens\<MENU_ID>\<MENU_ID>_summary.md, crosscheck_report.csv
#>
param([switch]$SkipCheck)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfgPath = Join-Path $here "tobefacts.json"
$cfg = Get-Content $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) { Write-Host "node 를 찾지 못했습니다 (nscm-fe 가 요구하는 Node 20+ 필요)" -ForegroundColor Red; exit 1 }
$Python = $null
foreach ($cand in @("python", "python3", "py")) { $c = Get-Command $cand -ErrorAction SilentlyContinue; if ($c) { $Python = $c; break } }
Write-Host "1/3 추출 (FE + BE)" -ForegroundColor Cyan
& node (Join-Path $here "index.js") scan --config $cfgPath
if ($LASTEXITCODE -ne 0) { Write-Host "추출 실패" -ForegroundColor Red; exit 1 }
if (-not $SkipCheck) {
  if (-not $Python) { Write-Host "python 이 없어 교차검증을 건너뜁니다" -ForegroundColor Yellow }
  else {
    Write-Host "2/3 독립 교차검증 (자체 렉서)" -ForegroundColor Cyan
    & $Python.Source (Join-Path $here "verify\crosscheck.py") --fe $cfg.feRoot --out $cfg.outDir --config $cfgPath
    if ($LASTEXITCODE -ne 0) { Write-Host "교차검증 불일치 - $($cfg.outDir)\crosscheck_report.csv 확인" -ForegroundColor Red; exit 1 }
  }
}
Write-Host "3/3 화면별 Pack" -ForegroundColor Cyan
& node (Join-Path $here "index.js") pack --config $cfgPath
if ($LASTEXITCODE -ne 0) { Write-Host "Pack 실패" -ForegroundColor Red; exit 1 }
Write-Host "4/4 프레임워크·공통 카탈로그" -ForegroundColor Cyan
& node (Join-Path $here "framework.js") --config $cfgPath
if ($LASTEXITCODE -ne 0) { Write-Host "카탈로그 실패" -ForegroundColor Red; exit 1 }
Write-Host "완료: $($cfg.outDir)  (화면별: $($cfg.outDir)\screens\<MENU_ID>\<MENU_ID>_summary.md)" -ForegroundColor Green
