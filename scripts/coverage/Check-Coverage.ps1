<#
.SYNOPSIS
    화면(또는 도메인 전체)의 커버리지 완료 판정. 완료면 exit 0, 미완이면 exit 1.
.DESCRIPTION
    Claude Code 가 "이 화면 다 했습니다" 라고 선언하기 전에 반드시 통과해야 하는 게이트입니다.

    완료 조건:
      1. 해당 화면의 모든 행이 status in (done, n/a, gone)
      2. status=done 인 행은 evidence_path 가 비어있지 않고 실제 파일이 존재
      3. sha256 이 현재 AS-IS 원본과 일치 (원본이 바뀌었으면 미완 처리)

    Stop hook / PostToolUse hook 에서 호출하면 세션 종료 시 자동 경고가 됩니다.
.EXAMPLE
    .\Check-Coverage.ps1 -ScreenId DMF0043
.EXAMPLE
    .\Check-Coverage.ps1 -Domain DM -Summary
.EXAMPLE
    # 전체 미완 현황만 빠르게
    .\Check-Coverage.ps1 -Summary
#>
[CmdletBinding()]
param(
    [string]$ScreenId,
    [string]$Domain,
    [string]$AsisRoot,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot '..\asis\asis-config.psd1'),
    [switch]$Summary,
    [switch]$SkipHashCheck,
    [switch]$Quiet
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot '..\asis\lib\AsisCommon.psm1') -Force

$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $AsisRoot) { $AsisRoot = $cfg.AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $cfg.DocRoot }

$covDir   = Join-Path $DocRoot 'coverage'
$rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\','/')
$projRoot = Split-Path -Parent $DocRoot   # evidence_path 의 기준 루트

if (-not (Test-Path -LiteralPath $covDir)) {
    Write-Error "커버리지 장부 폴더가 없습니다: $covDir  (Init-Coverage.ps1 을 먼저 실행하세요)"
    exit 2
}

$ledgerFiles = @(Get-ChildItem -LiteralPath $covDir -Filter '*.csv' -File)
if ($Domain) { $ledgerFiles = @($ledgerFiles | Where-Object { $_.BaseName -ieq $Domain }) }
if ($ledgerFiles.Count -eq 0) {
    Write-Error "대상 장부가 없습니다. (covDir=$covDir, Domain=$Domain)"
    exit 2
}

$all = New-Object System.Collections.ArrayList
foreach ($lf in $ledgerFiles) {
    foreach ($r in (Import-AsisCsv -Path $lf.FullName)) {
        Add-Member -InputObject $r -NotePropertyName '_ledger' -NotePropertyValue $lf.BaseName -Force
        [void]$all.Add($r)
    }
}

if ($ScreenId) {
    $all = @($all | Where-Object { $_.screen_id -ieq $ScreenId })
    if ($all.Count -eq 0) {
        Write-Error "장부에 화면ID '$ScreenId' 가 없습니다. screen-inventory.csv 를 확인하세요."
        exit 2
    }
}

# -------------------------------------------------------------------------
# 판정
# -------------------------------------------------------------------------
$problems = New-Object System.Collections.ArrayList
$doneCount = 0; $naCount = 0; $goneCount = 0

foreach ($r in $all) {
    $status = ([string]$r.status).Trim().ToLowerInvariant()

    switch ($status) {
        'gone' { $goneCount++; continue }
        'n/a'  { $naCount++;   continue }
        'na'   { $naCount++;   continue }
        'done' {
            $doneCount++
            $ev = [string]$r.evidence_path
            if ([string]::IsNullOrWhiteSpace($ev)) {
                [void]$problems.Add([pscustomobject]@{
                    screen_id = $r.screen_id; file_path = $r.file_path
                    issue = 'EVIDENCE_MISSING'; detail = 'status=done 인데 evidence_path 가 비어 있음'
                })
                continue
            }
            $evFull = if ([System.IO.Path]::IsPathRooted($ev)) { $ev } else { Join-Path $projRoot $ev }
            if (-not (Test-Path -LiteralPath $evFull)) {
                [void]$problems.Add([pscustomobject]@{
                    screen_id = $r.screen_id; file_path = $r.file_path
                    issue = 'EVIDENCE_NOT_FOUND'; detail = $evFull
                })
                continue
            }
            if (-not $SkipHashCheck) {
                $srcFull = Join-Path $rootFull $r.file_path
                if (Test-Path -LiteralPath $srcFull) {
                    $cur = Get-AsisSha256 -Path $srcFull
                    if ($r.sha256 -and $cur -and $cur -ne [string]$r.sha256) {
                        [void]$problems.Add([pscustomobject]@{
                            screen_id = $r.screen_id; file_path = $r.file_path
                            issue = 'SOURCE_CHANGED'; detail = 'AS-IS 원본이 변경됨 — 재검토 필요'
                        })
                    }
                }
            }
        }
        default {
            [void]$problems.Add([pscustomobject]@{
                screen_id = $r.screen_id; file_path = $r.file_path
                issue = 'NOT_DONE'; detail = "status=$($r.status)"
            })
        }
    }
}

# -------------------------------------------------------------------------
# 출력
# -------------------------------------------------------------------------
if ($Summary -and -not $ScreenId) {
    $byScreen = $all | Group-Object screen_id
    $incomplete = @()
    foreach ($g in $byScreen) {
        $t = @($g.Group | Where-Object { ([string]$_.status).Trim().ToLowerInvariant() -notin @('done','n/a','na','gone') }).Count
        if ($t -gt 0) {
            $incomplete += [pscustomobject]@{
                screen_id = $g.Name
                domain    = $g.Group[0]._ledger
                total     = $g.Count
                remaining = $t
            }
        }
    }
    if (-not $Quiet) {
        Write-Host ''
        Write-Host ("커버리지 요약  |  화면 {0} / 파일 {1}" -f $byScreen.Count, $all.Count) -ForegroundColor Cyan
        Write-Host ("  done={0}  n/a={1}  gone={2}  미완={3}" -f $doneCount, $naCount, $goneCount, $problems.Count)
        Write-Host ''
        if ($incomplete.Count -gt 0) {
            Write-Host '  미완 화면 (남은 파일 수 내림차순)' -ForegroundColor Yellow
            foreach ($x in ($incomplete | Sort-Object remaining -Descending | Select-Object -First 40)) {
                Write-Host ("    {0,-12} {1,-6} {2,3}/{3,-3}" -f $x.screen_id, $x.domain, $x.remaining, $x.total)
            }
            if ($incomplete.Count -gt 40) { Write-Host ("    ... 외 {0}개 화면" -f ($incomplete.Count - 40)) }
        } else {
            Write-Host '  미완 화면 없음.' -ForegroundColor Green
        }
        Write-Host ''
    }
}

if ($problems.Count -eq 0) {
    if (-not $Quiet) {
        $label = if ($ScreenId) { "화면 $ScreenId" } elseif ($Domain) { "도메인 $Domain" } else { '전체' }
        Write-Host "OK  $label : 커버리지 완료 (done=$doneCount, n/a=$naCount, gone=$goneCount)" -ForegroundColor Green
    }
    exit 0
}

if (-not $Quiet) {
    $label = if ($ScreenId) { "화면 $ScreenId" } elseif ($Domain) { "도메인 $Domain" } else { '전체' }
    Write-Host ''
    Write-Host "INCOMPLETE  $label : 미해결 $($problems.Count)건" -ForegroundColor Red
    Write-Host ''
    foreach ($p in ($problems | Select-Object -First 60)) {
        Write-Host ("  [{0,-18}] {1,-12} {2}" -f $p.issue, $p.screen_id, $p.file_path) -ForegroundColor Red
        if ($p.issue -ne 'NOT_DONE') { Write-Host ("      -> {0}" -f $p.detail) -ForegroundColor DarkRed }
    }
    if ($problems.Count -gt 60) { Write-Host ("  ... 외 {0}건" -f ($problems.Count - 60)) -ForegroundColor Red }
    Write-Host ''
}

exit 1
