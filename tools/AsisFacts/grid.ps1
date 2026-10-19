<#
  3단계: division × sheet 별 실제 Grid 정의
   1) grid --plan-only : 실행 계획/안전성 판정만 (DB 미접속)  →  Doc\asisfacts\db\grid\grid_sp_safety.csv, grid_plan.csv
   2) grid             : 쓰기 없는 *_SPREAD_TITLE SP 만 트랜잭션 안에서 실행 후 항상 ROLLBACK
   3) pack             : 화면별 grid_rule.csv(메타 규칙 전개) + grid_diff.csv(실행 결과와 차이) + 요약 10장
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File grid.ps1            # 계획 확인 후 실행
         powershell -NoProfile -ExecutionPolicy Bypass -File grid.ps1 -PlanOnly  # 계획만
#>
param([switch]$PlanOnly)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Join-Path $here "asisfacts.json"
$exe = Join-Path $here "_bin\AsisFacts.dll"
dotnet build (Join-Path $here "AsisFacts.csproj") -c Release -o (Join-Path $here "_bin") | Select-String "error|Build succeeded"
if ($LASTEXITCODE -ne 0) { Write-Host "빌드 실패" -ForegroundColor Red; exit 1 }
dotnet $exe grid --plan-only --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "계획 생성 실패" -ForegroundColor Red; exit 1 }
if ($PlanOnly) { exit 0 }
dotnet $exe grid --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "Grid 실행 실패" -ForegroundColor Red; exit 1 }
dotnet $exe pack --config $cfg
if ($LASTEXITCODE -ne 0) { Write-Host "화면 Pack 실패" -ForegroundColor Red; exit 1 }
Write-Host "완료: 화면별 grid_rule.csv / grid_diff.csv / 요약 10장" -ForegroundColor Green
