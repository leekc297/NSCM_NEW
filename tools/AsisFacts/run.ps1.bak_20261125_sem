<#
  AsisFacts 실행 스크립트 (Windows / PowerShell 5.1+)
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1
         powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1 -SkipBuild
  순서:  빌드 → 함정 회귀테스트 → 전체 스캔 → Python 독립 교차검증 → 화면별 Pack (하나라도 실패하면 exit 1)
  As-is 원본은 읽기만 한다. 출력은 asisfacts.json 의 outDir.
#>
param([switch]$SkipBuild, [string]$Python = "python")
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $here
$bin = Join-Path $here "_bin"
$cfg = Join-Path $here "asisfacts.json"
$conf = Get-Content $cfg -Raw -Encoding UTF8 | ConvertFrom-Json
$out = $conf.outDir
$log = Join-Path $here "run-log.txt"
"[$(Get-Date -Format s)] start" | Out-File $log -Encoding utf8

if (-not $SkipBuild) {
  dotnet build -c Release -o $bin 2>&1 | Tee-Object -FilePath $log -Append | Select-String -Pattern "error|Build succeeded"
  if ($LASTEXITCODE -ne 0) { Write-Host "빌드 실패 - $log 확인" -ForegroundColor Red; exit 1 }
}
$exe = Join-Path $bin "AsisFacts.dll"

# 1) 함정 회귀테스트 (주석/문자열/#if)
$trapOut = Join-Path $env:TEMP "asisfacts_trap"
dotnet $exe scan --config $cfg --root (Join-Path $here "tests\trap") --out $trapOut *>> $log
& $Python (Join-Path $here "verify\traptest.py") $trapOut
if ($LASTEXITCODE -ne 0) { Write-Host "함정 회귀테스트 실패" -ForegroundColor Red; exit 1 }

# 2) 전체 스캔
dotnet $exe scan --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "스캔 실패" -ForegroundColor Red; exit 1 }

# 3) 독립 교차검증 (Roslyn ↔ Python 렉서)
& $Python (Join-Path $here "verify\crosscheck.py") --root $conf.asisRoot --out $out --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "교차검증 불일치 - $out\crosscheck_report.csv 확인" -ForegroundColor Red; exit 1 }
# 4) 화면별 Fact Pack (screens\<화면ID>\)
dotnet $exe pack --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "화면 Pack 실패" -ForegroundColor Red; exit 1 }
Write-Host "완료: $out  (화면별 결과: $out\screens\<화면ID>\<화면ID>_summary.md)" -ForegroundColor Green
exit 0
