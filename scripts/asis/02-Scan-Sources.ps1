<#
.SYNOPSIS
    AS-IS C# 소스 단일 패스 스캔 (read-only). 파일을 1회만 읽어 3개 산출물을 동시 생성합니다.
.DESCRIPTION
    산출물:
      doc/asis/screen-inventory.csv : 화면 단위 요약 (Claude Code 가 화면 작업 시작할 때 읽는 유일한 파일)
      doc/asis/screen-file-map.csv  : 화면-파일 1:N 상세 (커버리지 장부의 원본)
      doc/asis/dynamic-ui.csv       : 동적 그리드/컨트롤 생성 코드 위치 (파일:라인)
      doc/asis/_probe/unmapped-files.csv : 화면ID를 못 붙인 파일 (누락 추적용)

    03-Extract-SpInventory.ps1 를 먼저 돌렸다면 -SpNameListPath 로 실제 SP 목록을 넘기세요.
    명명규칙 추측 없이 정확히 매칭됩니다.
.EXAMPLE
    .\02-Scan-Sources.ps1
.EXAMPLE
    .\02-Scan-Sources.ps1 -SpNameListPath C:\Projects\NSCM\doc\asis\sp-inventory.csv
#>
[CmdletBinding()]
param(
    [string]$AsisRoot,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'asis-config.psd1'),
    [string]$FoxmlIndexPath,
    [string]$SpNameListPath,
    [int]$SnippetLength = 160
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'lib\AsisCommon.psm1') -Force

$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $AsisRoot) { $AsisRoot = $cfg.AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $cfg.DocRoot }

$rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\','/')
$outDir   = Join-Path $DocRoot 'asis'
if (-not $FoxmlIndexPath) { $FoxmlIndexPath = Join-Path $outDir 'foxml-index.json' }

Write-AsisBanner "AS-IS 소스 스캔  |  ROOT = $rootFull"

# -------------------------------------------------------------------------
# 참조 인덱스 로드
# -------------------------------------------------------------------------
$foxmlSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
if (Test-Path -LiteralPath $FoxmlIndexPath) {
    $fx = Get-Content -LiteralPath $FoxmlIndexPath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($id in @($fx.foxml_ids)) { if ($id) { [void]$foxmlSet.Add([string]$id) } }
    foreach ($id in @($fx.query_ids)) { if ($id) { [void]$foxmlSet.Add([string]$id) } }
    Write-Host "[ref] foxml 식별자 $($foxmlSet.Count)건 로드" -ForegroundColor DarkGray
} else {
    Write-Warning "foxml-index.json 이 없습니다. 01-Extract-Foxml.ps1 을 먼저 실행하면 foxml 호출관계가 채워집니다."
}

$spSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
if ($SpNameListPath -and (Test-Path -LiteralPath $SpNameListPath)) {
    foreach ($row in (Import-AsisCsv -Path $SpNameListPath)) {
        foreach ($col in @('object_name','name','sp_name')) {
            if ($row.PSObject.Properties.Name -contains $col -and $row.$col) {
                [void]$spSet.Add([string]$row.$col); break
            }
        }
    }
    Write-Host "[ref] 실제 SP명 $($spSet.Count)건 로드 (정확 매칭 사용)" -ForegroundColor DarkGray
}

# -------------------------------------------------------------------------
# 정규식 준비 (compiled — 파일 수천 개에서 체감 차이가 큽니다)
# -------------------------------------------------------------------------
$RxOpt = [System.Text.RegularExpressions.RegexOptions]'Compiled'
$RxOptI = [System.Text.RegularExpressions.RegexOptions]'Compiled, IgnoreCase'

$dynRx = @()
foreach ($p in $cfg.DynamicUiPattern) {
    $dynRx += [pscustomobject]@{
        name = [string]$p.name
        rx   = New-Object System.Text.RegularExpressions.Regex(([string]$p.pattern), $RxOpt)
    }
}
$spRx        = New-Object System.Text.RegularExpressions.Regex($cfg.SpNamePattern, $RxOptI)
$spCtxRx     = New-Object System.Text.RegularExpressions.Regex($cfg.SpCallContextPattern, $RxOptI)
# C# 문자열 리터럴 (일반 + verbatim)
$literalRx   = New-Object System.Text.RegularExpressions.Regex('@"(?<v>(?:[^"]|"")*)"|"(?<s>(?:[^"\\\r\n]|\\.)*)"', $RxOpt)

# -------------------------------------------------------------------------
# 스캔
# -------------------------------------------------------------------------
$files = @(Get-AsisFiles -Root $rootFull -Extension $cfg.SourceExtension -ExcludeDirectory $cfg.ExcludeDirectory)
Write-Host ("[1/4] 소스 {0:N0}건 스캔 시작" -f $files.Count) -ForegroundColor Yellow

$fileRows  = New-Object System.Collections.ArrayList
$dynRows   = New-Object System.Collections.ArrayList
$unmapped  = New-Object System.Collections.ArrayList
$screens   = @{}   # screenId -> aggregate

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$i = 0

foreach ($f in $files) {
    $i++
    if ($i % 250 -eq 0) {
        Write-Host ("      {0}/{1}  ({2:N0}s)" -f $i, $files.Count, $sw.Elapsed.TotalSeconds) -ForegroundColor DarkGray
    }

    $text = Read-AsisText -Path $f.FullName -MaxSizeKB $cfg.MaxFileSizeKB
    if ($null -eq $text) { continue }

    $rel      = Get-AsisRelativePath -FullPath $f.FullName -Root $rootFull
    $screenId = Resolve-AsisScreenId -FullPath $f.FullName -Pattern $cfg.ScreenIdPattern
    $layer    = Resolve-AsisLayer    -FullPath $f.FullName -LayerToken $cfg.LayerToken
    $domain   = Resolve-AsisDomain   -ScreenId $screenId -DomainPrefix $cfg.DomainPrefix

    if (-not $screenId) {
        [void]$unmapped.Add([pscustomobject]@{ rel_path = $rel; layer = $layer; size_kb = [math]::Round($f.Length/1KB,1) })
    }

    # ---- 문자열 리터럴에서 foxml / SP 참조 ----
    $foxRefs = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $spRefs  = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)

    if ($foxmlSet.Count -gt 0 -or $spSet.Count -gt 0) {
        foreach ($m in $literalRx.Matches($text)) {
            $lit = $m.Groups['s'].Value
            if (-not $lit) { $lit = $m.Groups['v'].Value }
            if (-not $lit -or $lit.Length -lt 3 -or $lit.Length -gt 512) { continue }

            $candidates = @($lit)
            if ($lit -match '[\\/\.]') {
                $candidates += [System.IO.Path]::GetFileNameWithoutExtension(($lit -replace '/', '\'))
            }
            foreach ($c in $candidates) {
                if (-not $c) { continue }
                if ($foxmlSet.Contains($c)) { [void]$foxRefs.Add($c) }
                if ($spSet.Contains($c))    { [void]$spRefs.Add($c) }
            }
        }
    }

    # 정규식 기반 SP명(명명규칙) — 실제 SP 목록이 없을 때의 보조 수단
    foreach ($m in $spRx.Matches($text)) { [void]$spRefs.Add($m.Groups['sp'].Value) }

    $spConfidence = if ($spSet.Count -gt 0) { 'exact' }
                    elseif ($spCtxRx.IsMatch($text)) { 'high' }
                    else { 'low' }

    # ---- 동적 UI: 라인 단위 ----
    $lines = $text -split "`r`n|`n|`r"
    $dynHits = 0
    for ($ln = 0; $ln -lt $lines.Length; $ln++) {
        $line = $lines[$ln]
        if ($line.Length -lt 4) { continue }
        foreach ($d in $dynRx) {
            if ($d.rx.IsMatch($line)) {
                $dynHits++
                $snippet = $line.Trim()
                if ($snippet.Length -gt $SnippetLength) { $snippet = $snippet.Substring(0, $SnippetLength) + '...' }
                [void]$dynRows.Add([pscustomobject]@{
                    screen_id = $screenId
                    domain    = $domain
                    layer     = $layer
                    rel_path  = $rel
                    line_no   = $ln + 1
                    pattern   = $d.name
                    snippet   = $snippet
                })
                break   # 한 줄에 여러 패턴이 맞아도 1건만 기록
            }
        }
    }

    [void]$fileRows.Add([pscustomobject]@{
        screen_id   = $screenId
        domain      = $domain
        layer       = $layer
        rel_path    = $rel
        line_count  = $lines.Length
        dyn_ui_hits = $dynHits
        foxml_refs  = (($foxRefs | Sort-Object) -join ';')
        sp_refs     = (($spRefs  | Sort-Object) -join ';')
        sp_conf     = $spConfidence
        sha256      = (Get-AsisSha256 -Path $f.FullName)
    })

    if ($screenId) {
        if (-not $screens.ContainsKey($screenId)) {
            $screens[$screenId] = [pscustomobject]@{
                screen_id  = $screenId
                domain     = $domain
                files      = (New-Object System.Collections.ArrayList)
                byLayer    = @{}
                fox        = (New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase))
                sp         = (New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase))
                dynFiles   = (New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase))
                lines      = 0
            }
        }
        $agg = $screens[$screenId]
        [void]$agg.files.Add($rel)
        if (-not $agg.byLayer.ContainsKey($layer)) { $agg.byLayer[$layer] = New-Object System.Collections.ArrayList }
        [void]$agg.byLayer[$layer].Add($rel)
        foreach ($x in $foxRefs) { [void]$agg.fox.Add($x) }
        foreach ($x in $spRefs)  { [void]$agg.sp.Add($x) }
        if ($dynHits -gt 0) { [void]$agg.dynFiles.Add($rel) }
        $agg.lines += $lines.Length
    }
}
$sw.Stop()

Write-Host ("[2/4] 스캔 완료 — 화면 {0:N0}개 / 파일 {1:N0}건 / 동적UI {2:N0}건 / {3:N1}s" -f `
    $screens.Count, $fileRows.Count, $dynRows.Count, $sw.Elapsed.TotalSeconds) -ForegroundColor Yellow

# -------------------------------------------------------------------------
# 화면 인벤토리 조립
# -------------------------------------------------------------------------
Write-Host '[3/4] 화면 인벤토리 조립...' -ForegroundColor Yellow

function Join-Layer {
    param($Agg, [string]$Layer)
    if ($Agg.byLayer.ContainsKey($Layer)) { return (($Agg.byLayer[$Layer] | Sort-Object) -join ';') }
    return ''
}

$inventory = foreach ($k in ($screens.Keys | Sort-Object)) {
    $a = $screens[$k]
    $uil = Join-Layer -Agg $a -Layer 'UIL'
    [pscustomobject]@{
        screen_id     = $a.screen_id
        domain        = $a.domain
        file_count    = $a.files.Count
        total_lines   = $a.lines
        uil_files     = $uil
        wsl_files     = (Join-Layer -Agg $a -Layer 'WSL')
        biz_files     = (Join-Layer -Agg $a -Layer 'BIZ')
        dac_files     = (Join-Layer -Agg $a -Layer 'DAC')
        etc_files     = (Join-Layer -Agg $a -Layer 'ETC')
        foxml_refs    = (($a.fox | Sort-Object) -join ';')
        sp_refs       = (($a.sp  | Sort-Object) -join ';')
        dyn_ui_files  = (($a.dynFiles | Sort-Object) -join ';')
        dyn_ui_count  = $a.dynFiles.Count
        entry_file    = if ($uil) { ($uil -split ';')[0] } else { ($a.files | Sort-Object | Select-Object -First 1) }
    }
}

Write-AsisCsv -Data $inventory -Path (Join-Path $outDir 'screen-inventory.csv') `
    -Header @('screen_id','domain','file_count','total_lines','uil_files','wsl_files','biz_files','dac_files','etc_files','foxml_refs','sp_refs','dyn_ui_files','dyn_ui_count','entry_file')

Write-AsisCsv -Data $fileRows -Path (Join-Path $outDir 'screen-file-map.csv') `
    -Header @('screen_id','domain','layer','rel_path','line_count','dyn_ui_hits','foxml_refs','sp_refs','sp_conf','sha256')

Write-AsisCsv -Data $dynRows -Path (Join-Path $outDir 'dynamic-ui.csv') `
    -Header @('screen_id','domain','layer','rel_path','line_no','pattern','snippet')

if ($unmapped.Count -gt 0) {
    Write-AsisCsv -Data $unmapped -Path (Join-Path $outDir '_probe\unmapped-files.csv') -Header @('rel_path','layer','size_kb')
}

# -------------------------------------------------------------------------
# 요약
# -------------------------------------------------------------------------
Write-Host '[4/4] 요약' -ForegroundColor Yellow
$byDomain = $inventory | Group-Object domain | Sort-Object Count -Descending
Write-Host ''
Write-Host '  도메인별 화면 수' -ForegroundColor White
foreach ($g in $byDomain) { Write-Host ("    {0,-10} {1,5}" -f $g.Name, $g.Count) }
$noDyn = @($inventory | Where-Object { $_.dyn_ui_count -eq 0 }).Count
$noFox = @($inventory | Where-Object { -not $_.foxml_refs }).Count
$noSp  = @($inventory | Where-Object { -not $_.sp_refs }).Count
Write-Host ''
Write-Host ("  동적UI 미검출 화면 : {0} / {1}" -f $noDyn, $inventory.Count)
Write-Host ("  foxml 미연결 화면  : {0} / {1}" -f $noFox, $inventory.Count)
Write-Host ("  SP 미연결 화면     : {0} / {1}" -f $noSp,  $inventory.Count)
Write-Host ("  화면ID 미매핑 파일 : {0}" -f $unmapped.Count)
Write-Host ''
if ($unmapped.Count -gt ($fileRows.Count * 0.15)) {
    Write-Warning "미매핑 파일 비율이 15%를 넘습니다. asis-config.psd1 의 ScreenIdPattern 을 점검하세요."
}
Write-Host '완료.' -ForegroundColor Green
