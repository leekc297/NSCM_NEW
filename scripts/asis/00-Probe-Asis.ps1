<#
.SYNOPSIS
    AS-IS 트리 구조 정찰(read-only). 이후 추출 스크립트의 정규식을 튜닝할 근거를 만듭니다.
.DESCRIPTION
    가장 먼저 1회 실행하세요. 원본을 절대 수정하지 않습니다.
    산출물: doc/asis/_probe/probe-report.md, ext-histogram.csv, name-samples.csv
.EXAMPLE
    .\00-Probe-Asis.ps1
.EXAMPLE
    .\00-Probe-Asis.ps1 -AsisRoot D:\legacy\GSCM -SampleCount 60
#>
[CmdletBinding()]
param(
    [string]$AsisRoot,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'asis-config.psd1'),
    [int]$SampleCount = 40
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'lib\AsisCommon.psm1') -Force

$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $AsisRoot) { $AsisRoot = $cfg.AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $cfg.DocRoot }

$outDir = Join-Path $DocRoot 'asis\_probe'
Write-AsisBanner "AS-IS 구조 정찰  |  ROOT = $AsisRoot"

if (-not (Test-Path -LiteralPath $AsisRoot)) {
    throw "AS-IS 루트를 찾을 수 없습니다: $AsisRoot  (-AsisRoot 로 지정하세요)"
}

$rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\','/')
$excludeSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($d in $cfg.ExcludeDirectory) { [void]$excludeSet.Add($d) }

Write-Host '[1/6] 파일 열거 중...' -ForegroundColor Yellow
$sw = [System.Diagnostics.Stopwatch]::StartNew()

$all = @(Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force -ErrorAction SilentlyContinue)
$kept = New-Object System.Collections.ArrayList
$excludedCount = 0
foreach ($f in $all) {
    $rel = $f.FullName.Substring($rootFull.Length).TrimStart('\','/')
    $segments = $rel -split '[\\/]'
    $skip = $false
    for ($i = 0; $i -lt $segments.Length - 1; $i++) {
        if ($excludeSet.Contains($segments[$i])) { $skip = $true; break }
    }
    if ($skip) { $excludedCount++ } else { [void]$kept.Add($f) }
}
Write-Host ("      전체 {0:N0}건 / 제외 {1:N0}건 / 대상 {2:N0}건  ({3:N1}s)" -f `
    $all.Count, $excludedCount, $kept.Count, $sw.Elapsed.TotalSeconds)

# -------------------------------------------------------------------------
Write-Host '[2/6] 확장자 히스토그램...' -ForegroundColor Yellow
$extHist = $kept | Group-Object { if ($_.Extension) { $_.Extension.ToLowerInvariant() } else { '(none)' } } |
    Sort-Object Count -Descending |
    ForEach-Object {
        [pscustomobject]@{
            extension  = $_.Name
            file_count = $_.Count
            total_mb   = [math]::Round((($_.Group | Measure-Object Length -Sum).Sum) / 1MB, 2)
        }
    }

# -------------------------------------------------------------------------
Write-Host '[3/6] 화면ID 패턴 적중률 측정...' -ForegroundColor Yellow
$srcExt = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($e in $cfg.SourceExtension) { [void]$srcExt.Add($e) }
$srcFiles = @($kept | Where-Object { $srcExt.Contains($_.Extension) })

$idRx = New-Object System.Text.RegularExpressions.Regex(
    $cfg.ScreenIdPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

$hitByName = 0; $hitByDir = 0; $miss = 0
$idSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
$missSamples = New-Object System.Collections.ArrayList

foreach ($f in $srcFiles) {
    $leaf = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $m = $idRx.Match($leaf)
    if ($m.Success) {
        $hitByName++; [void]$idSet.Add($m.Groups['id'].Value.ToUpperInvariant())
    } else {
        $id = Resolve-AsisScreenId -FullPath $f.FullName -Pattern $cfg.ScreenIdPattern
        if ($id) { $hitByDir++; [void]$idSet.Add($id) }
        else {
            $miss++
            if ($missSamples.Count -lt $SampleCount) {
                [void]$missSamples.Add((Get-AsisRelativePath -FullPath $f.FullName -Root $rootFull))
            }
        }
    }
}

# -------------------------------------------------------------------------
Write-Host '[4/6] 레이어 토큰 분포...' -ForegroundColor Yellow
$layerHist = @{}
foreach ($f in $srcFiles) {
    $layer = Resolve-AsisLayer -FullPath $f.FullName -LayerToken $cfg.LayerToken
    if (-not $layerHist.ContainsKey($layer)) { $layerHist[$layer] = 0 }
    $layerHist[$layer]++
}

# 폴더 세그먼트 상위 빈도 (레이어 규칙 힌트)
$segHist = @{}
foreach ($f in $srcFiles) {
    $rel = $f.FullName.Substring($rootFull.Length).TrimStart('\','/')
    $segments = $rel -split '[\\/]'
    for ($i = 0; $i -lt $segments.Length - 1; $i++) {
        $s = $segments[$i]
        if (-not $segHist.ContainsKey($s)) { $segHist[$s] = 0 }
        $segHist[$s]++
    }
}
$topSegments = $segHist.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 30

# -------------------------------------------------------------------------
Write-Host '[5/6] foxml 샘플 확인...' -ForegroundColor Yellow
$foxExt = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($e in $cfg.FoxmlExtension) { [void]$foxExt.Add($e) }
$foxFiles = @($kept | Where-Object { $foxExt.Contains($_.Extension) })

$foxSample = ''
$foxElementHist = @{}
if ($foxFiles.Count -gt 0) {
    $first = $foxFiles[0]
    $txt = Read-AsisText -Path $first.FullName -MaxSizeKB $cfg.MaxFileSizeKB
    if ($txt) {
        $lines = ($txt -split "`r`n|`n|`r") | Select-Object -First 60
        $foxSample = "파일: " + (Get-AsisRelativePath -FullPath $first.FullName -Root $rootFull) + "`n`n" + ($lines -join "`n")
    }
    # 요소명 빈도 (최대 200개 파일 표본)
    foreach ($fx in ($foxFiles | Select-Object -First 200)) {
        $t = Read-AsisText -Path $fx.FullName -MaxSizeKB $cfg.MaxFileSizeKB
        if (-not $t) { continue }
        foreach ($m in [regex]::Matches($t, '<(?<n>[A-Za-z_][\w\.\-]*)[\s/>]')) {
            $n = $m.Groups['n'].Value
            if (-not $foxElementHist.ContainsKey($n)) { $foxElementHist[$n] = 0 }
            $foxElementHist[$n]++
        }
    }
}
$topFoxElements = $foxElementHist.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 25

# -------------------------------------------------------------------------
Write-Host '[6/6] 인코딩 / 동적UI 패턴 사전 적중 확인...' -ForegroundColor Yellow
$encHist = @{}
$dynHitHist = @{}
$spNameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)

$dynRx = @()
foreach ($p in $cfg.DynamicUiPattern) {
    $dynRx += [pscustomobject]@{
        name = $p.name
        rx   = New-Object System.Text.RegularExpressions.Regex($p.pattern, 'Compiled')
    }
}
$spRx = New-Object System.Text.RegularExpressions.Regex($cfg.SpNamePattern, 'Compiled, IgnoreCase')

$probeSample = @($srcFiles | Get-Random -Count ([math]::Min(400, [math]::Max($srcFiles.Count,1))) -ErrorAction SilentlyContinue)
if ($srcFiles.Count -le 400) { $probeSample = $srcFiles }

foreach ($f in $probeSample) {
    try { $bytes = [System.IO.File]::ReadAllBytes($f.FullName) } catch { continue }
    if ($bytes.Length -eq 0) { continue }
    $enc = Get-AsisEncoding -Bytes $bytes
    $encName = $enc.WebName
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF) { $encName = 'utf-8-bom' }
    if (-not $encHist.ContainsKey($encName)) { $encHist[$encName] = 0 }
    $encHist[$encName]++

    $text = $enc.GetString($bytes)
    foreach ($d in $dynRx) {
        $c = $d.rx.Matches($text).Count
        if ($c -gt 0) {
            if (-not $dynHitHist.ContainsKey($d.name)) { $dynHitHist[$d.name] = 0 }
            $dynHitHist[$d.name] += $c
        }
    }
    foreach ($m in $spRx.Matches($text)) { [void]$spNameSet.Add($m.Groups['sp'].Value) }
}

$sw.Stop()

# -------------------------------------------------------------------------
# 리포트 작성
# -------------------------------------------------------------------------
$nl = [Environment]::NewLine
$sb = New-Object System.Text.StringBuilder

function Add-Line { param($t) [void]$sb.AppendLine($t) }

Add-Line "# AS-IS 구조 정찰 리포트"
Add-Line ""
Add-Line "- 생성: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-Line "- ROOT: ``$rootFull``"
Add-Line "- 소요: $([math]::Round($sw.Elapsed.TotalSeconds,1))s"
Add-Line "- 전체 파일 $($all.Count) / 제외 $excludedCount / 대상 $($kept.Count)"
Add-Line ""
Add-Line "> 이 리포트는 읽기 전용 스캔 결과입니다. AS-IS 원본은 변경되지 않았습니다."
Add-Line ""
Add-Line "## 1. 확장자 분포 (상위 25)"
Add-Line ""
Add-Line "| 확장자 | 파일수 | 합계(MB) |"
Add-Line "|---|---:|---:|"
foreach ($e in ($extHist | Select-Object -First 25)) {
    Add-Line "| $($e.extension) | $($e.file_count) | $($e.total_mb) |"
}
Add-Line ""
Add-Line "## 2. 화면ID 패턴 적중률"
Add-Line ""
Add-Line "- 사용 패턴: ``$($cfg.ScreenIdPattern)``"
Add-Line "- 소스 파일 수(대상 확장자 $($cfg.SourceExtension -join ',')): **$($srcFiles.Count)**"
Add-Line "- 파일명에서 적중: **$hitByName**"
Add-Line "- 폴더명에서 적중: **$hitByDir**"
Add-Line "- 미적중: **$miss**"
Add-Line "- 고유 화면ID 수: **$($idSet.Count)**"
Add-Line ""
if ($idSet.Count -gt 0) {
    Add-Line "고유 화면ID 샘플(최대 $SampleCount):"
    Add-Line ""
    Add-Line '```'
    Add-Line (($idSet | Sort-Object | Select-Object -First $SampleCount) -join '  ')
    Add-Line '```'
    Add-Line ""
}
if ($missSamples.Count -gt 0) {
    Add-Line "미적중 파일 샘플 — 패턴 조정이 필요한지 확인하세요:"
    Add-Line ""
    Add-Line '```'
    foreach ($s in $missSamples) { Add-Line $s }
    Add-Line '```'
    Add-Line ""
}
Add-Line "## 3. 레이어 판정 분포"
Add-Line ""
Add-Line "| 레이어 | 파일수 |"
Add-Line "|---|---:|"
foreach ($k in ($layerHist.Keys | Sort-Object)) { Add-Line "| $k | $($layerHist[$k]) |" }
Add-Line ""
Add-Line "**ETC 비중이 높으면 asis-config.psd1 의 LayerToken 을 조정하세요.** 아래 폴더 빈도가 힌트입니다."
Add-Line ""
Add-Line "| 폴더 세그먼트 | 빈도 |"
Add-Line "|---|---:|"
foreach ($s in $topSegments) { Add-Line "| $($s.Key) | $($s.Value) |" }
Add-Line ""
Add-Line "## 4. foxml"
Add-Line ""
Add-Line "- .foxml 파일 수: **$($foxFiles.Count)**"
Add-Line ""
if ($topFoxElements) {
    Add-Line "요소명 빈도(표본 200파일):"
    Add-Line ""
    Add-Line "| 요소 | 빈도 |"
    Add-Line "|---|---:|"
    foreach ($e in $topFoxElements) { Add-Line "| $($e.Key) | $($e.Value) |" }
    Add-Line ""
}
if ($foxSample) {
    Add-Line "첫 파일 샘플(60줄):"
    Add-Line ""
    Add-Line '```xml'
    Add-Line $foxSample
    Add-Line '```'
    Add-Line ""
}
Add-Line "## 5. 인코딩 분포 (표본 $($probeSample.Count)파일)"
Add-Line ""
Add-Line "| 인코딩 | 파일수 |"
Add-Line "|---|---:|"
foreach ($k in ($encHist.Keys | Sort-Object)) { Add-Line "| $k | $($encHist[$k]) |" }
Add-Line ""
Add-Line "## 6. 동적 UI 패턴 사전 적중 (표본 $($probeSample.Count)파일, 매치 횟수)"
Add-Line ""
if ($dynHitHist.Count -eq 0) {
    Add-Line "**적중 0건.** 이 프로젝트는 다른 그리드 API를 쓰고 있을 가능성이 큽니다."
    Add-Line "asis-config.psd1 의 DynamicUiPattern 을 실제 코드에 맞게 교체해야 합니다."
} else {
    Add-Line "| 패턴 | 매치수 |"
    Add-Line "|---|---:|"
    foreach ($e in ($dynHitHist.GetEnumerator() | Sort-Object Value -Descending)) {
        Add-Line "| $($e.Key) | $($e.Value) |"
    }
}
Add-Line ""
Add-Line "## 7. SP 명명규칙 표본"
Add-Line ""
Add-Line "- 사용 패턴: ``$($cfg.SpNamePattern)``"
Add-Line "- 발견된 고유 SP명: **$($spNameSet.Count)**"
Add-Line ""
if ($spNameSet.Count -gt 0) {
    Add-Line '```'
    Add-Line (($spNameSet | Sort-Object | Select-Object -First 60) -join "`n")
    Add-Line '```'
} else {
    Add-Line "**적중 0건.** SP 명명규칙이 다릅니다. 03-Extract-SpInventory.ps1 로 실제 DB에서 SP명을"
    Add-Line "먼저 뽑은 뒤, 그 이름 목록을 02-Scan-Sources.ps1 의 -SpNameListPath 로 넘기는 방식을 쓰세요."
}
Add-Line ""
Add-Line "---"
Add-Line ""
Add-Line "### 다음 할 일"
Add-Line ""
Add-Line "1. 2절 미적중률이 10%를 넘으면 ``ScreenIdPattern`` 수정"
Add-Line "2. 3절 ETC 비중이 크면 ``LayerToken`` 수정"
Add-Line "3. 6절이 0건이면 ``DynamicUiPattern`` 교체"
Add-Line "4. 그 다음 ``Run-AsisIndex.ps1`` 실행"

Write-AsisText -Content $sb.ToString() -Path (Join-Path $outDir 'probe-report.md') -Bom
Write-AsisCsv  -Data $extHist -Path (Join-Path $outDir 'ext-histogram.csv') -Header @('extension','file_count','total_mb')

$nameSamples = @($srcFiles | Select-Object -First 200 | ForEach-Object {
    [pscustomobject]@{
        rel_path  = Get-AsisRelativePath -FullPath $_.FullName -Root $rootFull
        file_name = $_.Name
        screen_id = Resolve-AsisScreenId -FullPath $_.FullName -Pattern $cfg.ScreenIdPattern
        layer     = Resolve-AsisLayer   -FullPath $_.FullName -LayerToken $cfg.LayerToken
    }
})
Write-AsisCsv -Data $nameSamples -Path (Join-Path $outDir 'name-samples.csv') -Header @('rel_path','file_name','screen_id','layer')

Write-Host ''
Write-Host "정찰 완료. 먼저 이 파일을 확인하세요:" -ForegroundColor Green
Write-Host ("  {0}" -f (Join-Path $outDir 'probe-report.md')) -ForegroundColor Green
