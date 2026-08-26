<#
.SYNOPSIS
    AS-IS 인덱스 + 커버리지 장부 전체 파이프라인 실행 (read-only).
.DESCRIPTION
    AS-IS 소스와 DB를 읽기만 합니다. TO-BE 소스, git, node_modules 는 건드리지 않으므로
    Claude Code 가 다른 창에서 작업 중이어도 안전합니다.

    실행 순서:
      1. 00-Probe-Asis        (-SkipProbe 로 생략 가능)
      2. 01-Extract-Foxml
      3. 03-Extract-SpInventory  (-Server/-Database 를 준 경우에만)
      4. 02-Scan-Sources         (SP 목록이 있으면 자동으로 -SpNameListPath 연결)
      5. Init-Coverage
.EXAMPLE
    # 소스만
    .\Run-AsisIndex.ps1
.EXAMPLE
    # 소스 + AS-IS DB
    .\Run-AsisIndex.ps1 -Server localhost -Database GSCM -IntegratedSecurity
#>
[CmdletBinding()]
param(
    [string]$AsisRoot,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'asis\asis-config.psd1'),
    [string]$Server,
    [string]$Database,
    [switch]$IntegratedSecurity,
    [System.Management.Automation.PSCredential]$Credential,
    [switch]$SkipProbe,
    [switch]$SkipCoverage
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'asis\lib\AsisCommon.psm1') -Force
$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $AsisRoot) { $AsisRoot = $cfg.AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $cfg.DocRoot }

$asisDir = Join-Path $PSScriptRoot 'asis'
$covScriptDir = Join-Path $PSScriptRoot 'coverage'
$total = [System.Diagnostics.Stopwatch]::StartNew()

Write-AsisBanner "NSCM AS-IS 인덱스 파이프라인"
Write-Host "  AsisRoot : $AsisRoot"
Write-Host "  DocRoot  : $DocRoot"
Write-Host "  Config   : $ConfigPath"
Write-Host ''

$common = @{ AsisRoot = $AsisRoot; DocRoot = $DocRoot; ConfigPath = $ConfigPath }

# --- 1. 정찰 -------------------------------------------------------------
if (-not $SkipProbe) {
    & (Join-Path $asisDir '00-Probe-Asis.ps1') @common
} else {
    Write-Host '[skip] 00-Probe-Asis' -ForegroundColor DarkGray
}

# --- 2. foxml ------------------------------------------------------------
& (Join-Path $asisDir '01-Extract-Foxml.ps1') @common

# --- 3. AS-IS DB ---------------------------------------------------------
$spListPath = Join-Path $DocRoot 'asis\sp-inventory.csv'
if ($Server -and $Database) {
    $dbArgs = @{ Server = $Server; Database = $Database; DocRoot = $DocRoot; ConfigPath = $ConfigPath }
    if ($IntegratedSecurity) { $dbArgs['IntegratedSecurity'] = $true }
    if ($Credential)         { $dbArgs['Credential'] = $Credential }
    & (Join-Path $asisDir '03-Extract-SpInventory.ps1') @dbArgs
} else {
    Write-Host ''
    Write-Host '[skip] 03-Extract-SpInventory  (-Server/-Database 미지정)' -ForegroundColor DarkGray
    if (Test-Path -LiteralPath $spListPath) {
        Write-Host "       기존 sp-inventory.csv 를 재사용합니다." -ForegroundColor DarkGray
    }
}

# --- 4. 소스 스캔 --------------------------------------------------------
$scanArgs = $common.Clone()
if (Test-Path -LiteralPath $spListPath) { $scanArgs['SpNameListPath'] = $spListPath }
& (Join-Path $asisDir '02-Scan-Sources.ps1') @scanArgs

# --- 5. 커버리지 장부 ----------------------------------------------------
if (-not $SkipCoverage) {
    & (Join-Path $covScriptDir 'Init-Coverage.ps1') @common
} else {
    Write-Host '[skip] Init-Coverage' -ForegroundColor DarkGray
}

$total.Stop()
Write-AsisBanner ("파이프라인 완료  |  총 {0:N1}분" -f $total.Elapsed.TotalMinutes)

Write-Host '산출물:' -ForegroundColor Green
foreach ($p in @(
    'asis\_probe\probe-report.md',
    'asis\screen-inventory.csv',
    'asis\screen-file-map.csv',
    'asis\dynamic-ui.csv',
    'asis\foxml-catalog.csv',
    'asis\foxml-catalog.md',
    'asis\sp-inventory.csv',
    'coverage\'
)) {
    $full = Join-Path $DocRoot $p
    $mark = if (Test-Path -LiteralPath $full) { 'OK ' } else { '-- ' }
    Write-Host ("  {0} {1}" -f $mark, $full)
}
Write-Host ''
Write-Host '다음: doc\asis\_probe\probe-report.md 를 먼저 확인하고,' -ForegroundColor Cyan
Write-Host '      적중률이 낮으면 scripts\asis\asis-config.psd1 을 고친 뒤 재실행하세요.' -ForegroundColor Cyan
