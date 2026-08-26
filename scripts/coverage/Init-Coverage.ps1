<#
.SYNOPSIS
    커버리지 장부 생성·갱신. "SKIP 금지" 프롬프트 규칙을 검증 가능한 산출물로 대체합니다.
.DESCRIPTION
    doc/asis/screen-file-map.csv 를 근거로 doc/coverage/<domain>.csv 를 만듭니다.

    갱신 규칙 (재실행해도 작업 결과가 날아가지 않습니다):
      - 신규 파일           → status=todo 로 추가
      - sha256 변경         → status=todo 로 회귀 (AS-IS 원본이 바뀌었으므로 재검토 필요)
      - sha256 동일         → 기존 status / evidence_path 유지
      - 원본에서 사라진 파일 → status=gone 으로 표시 (행은 남겨 이력 추적)

    status 값: todo | wip | done | n/a | gone
.EXAMPLE
    .\Init-Coverage.ps1
.EXAMPLE
    .\Init-Coverage.ps1 -Domain DM
#>
[CmdletBinding()]
param(
    [string]$AsisRoot,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot '..\asis\asis-config.psd1'),
    [string[]]$Domain,
    [switch]$IncludeUnmapped,
    [switch]$TrustMapHash
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot '..\asis\lib\AsisCommon.psm1') -Force

$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $AsisRoot) { $AsisRoot = $cfg.AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $cfg.DocRoot }

$mapPath = Join-Path $DocRoot 'asis\screen-file-map.csv'
$covDir  = Join-Path $DocRoot 'coverage'

Write-AsisBanner '커버리지 장부 생성/갱신'

if (-not (Test-Path -LiteralPath $mapPath)) {
    throw "screen-file-map.csv 가 없습니다. 02-Scan-Sources.ps1 을 먼저 실행하세요.`n  경로: $mapPath"
}

$rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\','/')
$map = Import-AsisCsv -Path $mapPath
Write-Host "[1/3] screen-file-map.csv $($map.Count)행 로드" -ForegroundColor Yellow

$rows = @($map | Where-Object { $_.screen_id -or $IncludeUnmapped })
if ($Domain) {
    $domSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($d in $Domain) { [void]$domSet.Add($d) }
    $rows = @($rows | Where-Object { $domSet.Contains($_.domain) })
}

$groups = $rows | Group-Object domain
$now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$summary = New-Object System.Collections.ArrayList

Write-Host "[2/3] 도메인별 장부 작성..." -ForegroundColor Yellow

foreach ($g in $groups) {
    $domainName = if ($g.Name) { $g.Name } else { 'UNKNOWN' }
    $covPath = Join-Path $covDir ("$domainName.csv")

    # 기존 장부를 (screen_id|file_path) 키로 인덱싱
    $existing = @{}
    foreach ($e in (Import-AsisCsv -Path $covPath)) {
        $key = "$($e.screen_id)|$($e.file_path)"
        $existing[$key] = $e
    }

    $newRows = New-Object System.Collections.ArrayList
    $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $added = 0; $reverted = 0; $kept = 0

    foreach ($m in ($g.Group | Sort-Object screen_id, layer, rel_path)) {
        $key = "$($m.screen_id)|$($m.rel_path)"
        [void]$seen.Add($key)

        # 현재 해시는 원본 파일에서 다시 계산한다.
        # (screen-file-map.csv 가 오래됐어도 원본 변경을 놓치지 않기 위함)
        $curSha = [string]$m.sha256
        if (-not $TrustMapHash) {
            $srcFull = Join-Path $rootFull $m.rel_path
            if (Test-Path -LiteralPath $srcFull) {
                $h = Get-AsisSha256 -Path $srcFull
                if ($h) { $curSha = $h }
            }
        }

        if ($existing.ContainsKey($key)) {
            $prev = $existing[$key]
            $prevSha = if ($prev.PSObject.Properties.Name -contains 'sha256') { [string]$prev.sha256 } else { '' }
            $prevStatus = if ($prev.PSObject.Properties.Name -contains 'status') { [string]$prev.status } else { 'todo' }
            $prevEvidence = if ($prev.PSObject.Properties.Name -contains 'evidence_path') { [string]$prev.evidence_path } else { '' }
            $prevNote = if ($prev.PSObject.Properties.Name -contains 'note') { [string]$prev.note } else { '' }

            if ($prevSha -and $prevSha -ne $curSha) {
                $status = 'todo'; $evidence = $prevEvidence
                $note = "AS-IS 원본 변경으로 todo 회귀 (이전 status=$prevStatus)"
                $updated = $now
                $reverted++
            } else {
                $status = if ($prevStatus) { $prevStatus } else { 'todo' }
                $evidence = $prevEvidence
                $note = $prevNote
                $updated = if ($prev.PSObject.Properties.Name -contains 'updated' -and $prev.updated) { [string]$prev.updated } else { $now }
                $kept++
            }
        } else {
            $status = 'todo'; $evidence = ''; $note = ''; $updated = $now
            $added++
        }

        [void]$newRows.Add([pscustomobject]@{
            screen_id     = $m.screen_id
            layer         = $m.layer
            file_path     = $m.rel_path
            sha256        = $curSha
            status        = $status
            evidence_path = $evidence
            updated       = $updated
            note          = $note
        })
    }

    # 원본에서 사라진 행은 gone 으로 보존
    $goneCount = 0
    foreach ($k in $existing.Keys) {
        if (-not $seen.Contains($k)) {
            $e = $existing[$k]
            $st = if ($e.PSObject.Properties.Name -contains 'status') { [string]$e.status } else { '' }
            if ($st -eq 'gone') { $goneCount++ }
            [void]$newRows.Add([pscustomobject]@{
                screen_id     = $e.screen_id
                layer         = $(if ($e.PSObject.Properties.Name -contains 'layer') { $e.layer } else { '' })
                file_path     = $e.file_path
                sha256        = $(if ($e.PSObject.Properties.Name -contains 'sha256') { $e.sha256 } else { '' })
                status        = 'gone'
                evidence_path = $(if ($e.PSObject.Properties.Name -contains 'evidence_path') { $e.evidence_path } else { '' })
                updated       = $now
                note          = 'AS-IS 원본에서 사라짐'
            })
            if ($st -ne 'gone') { $goneCount++ }
        }
    }

    $sorted = @($newRows | Sort-Object screen_id, layer, file_path)
    Write-AsisCsv -Data $sorted -Path $covPath `
        -Header @('screen_id','layer','file_path','sha256','status','evidence_path','updated','note')

    $screensInDomain = @($sorted | Select-Object -ExpandProperty screen_id -Unique).Count
    $todo = @($sorted | Where-Object { $_.status -eq 'todo' }).Count
    $done = @($sorted | Where-Object { $_.status -eq 'done' }).Count

    [void]$summary.Add([pscustomobject]@{
        domain   = $domainName
        screens  = $screensInDomain
        files    = $sorted.Count
        todo     = $todo
        done     = $done
        added    = $added
        reverted = $reverted
        kept     = $kept
        gone     = $goneCount
        path     = $covPath
    })
}

Write-Host "[3/3] 요약" -ForegroundColor Yellow
Write-Host ''
Write-Host ("  {0,-10} {1,7} {2,7} {3,7} {4,7} {5,7} {6,8}" -f 'DOMAIN','SCREENS','FILES','TODO','DONE','ADDED','REVERTED') -ForegroundColor White
foreach ($s in ($summary | Sort-Object domain)) {
    Write-Host ("  {0,-10} {1,7} {2,7} {3,7} {4,7} {5,7} {6,8}" -f `
        $s.domain, $s.screens, $s.files, $s.todo, $s.done, $s.added, $s.reverted)
}
Write-Host ''
if (@($summary | Where-Object { $_.reverted -gt 0 }).Count -gt 0) {
    Write-Warning "AS-IS 원본이 바뀌어 todo 로 회귀한 행이 있습니다. 해당 화면은 재검토가 필요합니다."
    Write-Warning "screen-inventory.csv 도 낡았을 수 있으니 02-Scan-Sources.ps1 을 다시 돌리세요."
}
Write-Host ("장부 위치: {0}" -f $covDir) -ForegroundColor Green
