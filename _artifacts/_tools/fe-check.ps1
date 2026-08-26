<#
.SYNOPSIS
  넥서스(사내 레지스트리) 접속 없이 nscm-fe 의 type-check / lint 를 로컬에서 돌린다.

.DESCRIPTION
  ## 왜 필요한가 (2026-08-23 실측)
  전역 pnpm 은 11.1.1 인데 저장소 `package.json` 이 `"packageManager": "pnpm@10.28.2"` 를 요구한다.
  pnpm 10+ 의 "package manager 버전 자동 전환" 기능이 **요구 버전을 레지스트리에서 내려받으려** 하고,
  그 레지스트리는 프로젝트 `.npmrc` 의 사내 넥서스(`http://10.94.57.6:8081`)다.
  사외망에서는 여기서 멈춘다 — `pnpm --version` 조차 응답이 없다.
      [ERROR] GET http://10.94.57.6:8081/repository/npm-group/pnpm: fetch failed

  ## 해결
  요구 버전과 **같은 pnpm(10.28.2)** 을 이 저장소 밖 도구 폴더에 설치해 두고, 그것을 PATH 앞에 세운다.
  버전이 일치하면 자동 전환 자체가 일어나지 않아 네트워크를 타지 않는다.
  설치는 이미 끝난 `node_modules` 를 그대로 쓰므로 install 도 필요 없다.

  ⚠ 시도했다가 안 된 것 (재시도 방지 기록)
    · 사용자 `%USERPROFILE%\.npmrc` 에 `manage-package-manager-versions=false` → pnpm 11 이 무시(npm 은 경고)
    · `pnpm-workspace.yaml` 에 `managePackageManagerVersions: false`          → 동일하게 계속 내려받기 시도

.PARAMETER Task
  type-check(기본) / lint / lint:fix / test / gen / all

.PARAMETER Filter
  turbo --filter 값 (예: @demand, @shared). 미지정 = 전 패키지.

.EXAMPLE
  powershell -File _artifacts\_tools\fe-check.ps1 type-check
  powershell -File _artifacts\_tools\fe-check.ps1 lint -Filter @demand
#>
param(
  [Parameter(Position = 0)]
  [ValidateSet('type-check', 'lint', 'lint:fix', 'test', 'gen', 'all')]
  [string]$Task = 'type-check',
  [string]$Filter
)

$ErrorActionPreference = 'Stop'

$PnpmDir = 'C:\Projects\NSCM\_artifacts\_tools\pnpm-10.28.2'
$FeDir   = 'C:\Projects\NSCM\nscm-fe'

if (-not (Test-Path (Join-Path $PnpmDir 'pnpm.cmd'))) {
  Write-Host "⛔ 고정 pnpm 이 없습니다: $PnpmDir" -ForegroundColor Red
  Write-Host '   복구:  npm i -g --prefix "' + $PnpmDir + '" pnpm@10.28.2 --registry=https://registry.npmjs.org/'
  exit 1
}

# 고정 pnpm 을 PATH 최우선 — turbo 가 각 패키지 스크립트를 pnpm 으로 실행하므로 자식 프로세스까지 이걸 쓴다
$env:Path = "$PnpmDir;$env:Path"
# 바깥으로 나가는 부가 통신 차단 (업데이트 확인 / 텔레메트리)
$env:TURBO_NO_UPDATE_NOTIFIER = '1'
$env:TURBO_TELEMETRY_DISABLED = '1'
$env:DO_NOT_TRACK             = '1'
$env:NEXT_TELEMETRY_DISABLED  = '1'

Set-Location $FeDir
$ver = & pnpm --version
Write-Host "pnpm $ver  (요구 = $((Get-Content package.json | Select-String 'packageManager').ToString().Trim()))" -ForegroundColor Cyan
Write-Host "task=$Task  filter=$(if ($Filter) { $Filter } else { '(전체)' })" -ForegroundColor Cyan

$turboArgs = @('run')
switch ($Task) {
  'all' { $turboArgs += @('lint', 'type-check') }
  'gen' { $turboArgs = $null }
  default { $turboArgs += $Task }
}
if ($Filter) { $turboArgs += @('--filter', $Filter) }
# 한 패키지가 실패해도 나머지를 끝까지 돌린다 — 전체 현황을 한 번에 본다
$turboArgs += '--continue'

# gen(아이콘/i18n 생성)은 turbo 없이 node 스크립트 직접 — 네트워크 불필요
if ($Task -eq 'gen' -or $Task -eq 'all' -or $Task -eq 'type-check') {
  Write-Host '--- gen (icons + i18n) ---' -ForegroundColor DarkGray
  & node scripts/generate-icons.mjs
  & node scripts/sync-i18n.mjs
  if ($LASTEXITCODE -ne 0) { Write-Host '⚠ gen 실패 — 계속 진행' -ForegroundColor Yellow }
}
if ($null -eq $turboArgs) { exit 0 }

Write-Host "--- turbo $($turboArgs -join ' ') ---" -ForegroundColor DarkGray
& .\node_modules\.bin\turbo.cmd @turboArgs
exit $LASTEXITCODE
