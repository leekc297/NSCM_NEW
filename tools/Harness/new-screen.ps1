<#
  To-Be 신규 화면 — 프로그램ID 하나로: As-is Fact Pack 확인 → 골격 생성(gen.js) → nscm-fe 적용 → 1차 게이트 → GEN_NOTES 출력 → (옵션) Claude Code 기동
  사용:  powershell -NoProfile -ExecutionPolicy Bypass -File new-screen.ps1 DMF0052 [-Feature demand] [-Page edi-summary] [-NoApply] [-Claude]
#>
param([Parameter(Mandatory=$true)][string]$Id, [string]$Feature, [string]$Page, [switch]$NoApply, [switch]$Claude)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg = Get-Content (Join-Path $here "harness.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$Id = $Id.ToUpper()
if (-not (Test-Path (Join-Path $cfg.asisOutDir "screens\$Id"))) { Write-Host "As-is Fact Pack 없음: $($cfg.asisOutDir)\screens\$Id — AsisFacts pack 먼저" -ForegroundColor Red; exit 1 }
if (-not (Test-Path (Join-Path $cfg.asisOutDir "agent\$Id\unit_test.md"))) { Write-Host "참고: Agent 문서(단위테스트 초안) 없음 — tools\AsisFacts\agent.ps1 $Id 를 먼저 돌리면 it.todo 가 함께 생성됩니다" -ForegroundColor Yellow }
$args1 = @($Id); if ($Feature) { $args1 += @('--feature', $Feature) }; if ($Page) { $args1 += @('--page', $Page) }; if (-not $NoApply) { $args1 += '--apply' }
Write-Host "1/3 골격 생성" -ForegroundColor Cyan
& node (Join-Path $here "gen.js") @args1 --config (Join-Path $here "harness.json")
if ($LASTEXITCODE -eq 3) { Write-Host "페이지 폴더가 이미 있어 적용하지 않았습니다. Doc\gen\$Id 와 수동 병합하세요." -ForegroundColor Yellow }
elseif ($LASTEXITCODE -ne 0) { exit 1 }
$genDir = Join-Path $cfg.genOutDir $Id
$pageRel = (Get-Content (Join-Path $genDir "register.json") -Raw -Encoding UTF8 | ConvertFrom-Json).routePath
$pageDir = if ($NoApply) { Get-ChildItem -Directory (Join-Path $genDir "features\*\src\pages\*") | Select-Object -First 1 -ExpandProperty FullName } else { Join-Path $cfg.feRoot ("features\" + ($pageRel -replace '/', '\src\pages\')) }
Write-Host "2/3 1차 게이트" -ForegroundColor Cyan
& node (Join-Path $here "check.js") --page $pageDir --config (Join-Path $here "harness.json")
Write-Host "3/3 다음 할 일 — $genDir\GEN_NOTES.md" -ForegroundColor Cyan
Get-Content (Join-Path $genDir "GEN_NOTES.md") -Raw -Encoding UTF8
if ($Claude) {
  Push-Location (Split-Path $cfg.feRoot -Parent)
  $claudeExe = if ($env:CLAUDE_BIN) { $env:CLAUDE_BIN } else { "claude" }  # VibeManager 가 고른 최신 CLI 우선 (PATH claude 구버전 → 400 방지)
  & $claudeExe "tools/Harness/prompts/new_screen.md 를 읽고 화면 $Id 의 TODO(이식) 를 채워주세요. 골격 위치: $pageDir, 메모: Doc/gen/$Id/GEN_NOTES.md"
  Pop-Location
}
