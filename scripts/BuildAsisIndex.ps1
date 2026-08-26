<#
================================================================================
 NSCM AS-IS 인덱서 + 커버리지 장부  (단일 파일 / read-only)
================================================================================

 Claude Code 가 매 세션 AS-IS 트리를 전부 훑는 것을 없애기 위한 인덱스를 만듭니다.
 AS-IS 소스를 읽기만 하며, 원본은 절대 수정하지 않습니다.
 진행 중인 다른 작업(Claude Code, Visual Studio)에 영향이 없습니다.

 사용법
 ------
   인덱스 생성 :  powershell -NoProfile -ExecutionPolicy Bypass -File .\Build-AsisIndex.ps1
   화면 완료판정:  powershell -NoProfile -ExecutionPolicy Bypass -File .\Build-AsisIndex.ps1 -CheckScreen DMF0052
   전체 잔량   :  powershell -NoProfile -ExecutionPolicy Bypass -File .\Build-AsisIndex.ps1 -CheckScreen * -Summary

 산출물 (기본 C:\Projects\NSCM\doc)
 ----------------------------------
   asis\screen-inventory.csv   화면 1행 요약  ← Claude Code 가 화면당 이 행 1개만 읽음
   asis\screen-file-map.csv    화면-파일 1:N 상세
   asis\query-refs.csv         화면-쿼리/SP 연결 (FoxDataRequest 등 리터럴 전수)
   asis\dynamic-ui.csv         동적 그리드 코드 위치를 "구간(start~end)"으로 집계
   asis\_probe\*.csv           진단(미매핑 파일, 레이어 분포 등)
   coverage\<domain>.csv       커버리지 장부

 요구사항: Windows PowerShell 5.1 이상. 외부 모듈·인터넷 불필요.
================================================================================
#>
[CmdletBinding()]
param(
    [string]$AsisRoot,
    [string]$DocRoot,

    # 커버리지 판정 모드. 화면ID 또는 '*'
    [string]$CheckScreen,
    [switch]$Summary,
    [switch]$SkipHashCheck,

    # 동적 UI 구간 병합 간격(줄). 이 간격 이내면 한 구간으로 묶습니다.
    [int]$RegionGap = 15,

    [switch]$SkipCoverage,
    [int]$MaxFileSizeKB = 8192
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

# ==============================================================================
#  설정  — 여기만 고치면 됩니다
# ==============================================================================

$CFG_AsisRoot = 'C:\Projects\NSCM\GSCM'
$CFG_DocRoot  = 'C:\Projects\NSCM\doc'

# 스캔할 최상위 폴더 (실측 기준). 비우면 전체 스캔.
$CFG_IncludeTop = @(
    '01.Framework', '03.BIZ', '04.WSL', '05.IFL', '06.UIL',
    '20.RFC', '21.WebService', '22.UIWebService'
)

# 최상위 폴더 → 레이어 이름
$CFG_LayerOfTop = @{
    '01.Framework'    = 'FW'
    '03.BIZ'          = 'BIZ'
    '04.WSL'          = 'WSL'
    '05.IFL'          = 'IFL'
    '06.UIL'          = 'UIL'
    '20.RFC'          = 'RFC'
    '21.WebService'   = 'WS'
    '22.UIWebService' = 'UIWS'
}

# 경로 세그먼트 완전일치로 제외 (3rd party 소스, 빌드 산출물, 디자이너 리소스)
$CFG_ExcludeDir = @(
    'bin', 'obj', '.vs', '.git', '.svn', 'packages', 'TestResults', 'node_modules',
    '_ReSharper', 'Backup', 'BACKUP', '_bak',
    'unvell.ReoGrid', 'Simplexcel', 'Properties'
)

# 화면ID: FP06970(2+5), DMF0004(3+4), DM0001(2+4), SCP0121, SSP0026 ...
$CFG_ScreenIdPattern = '(?<id>[A-Za-z]{2,4}\d{4,5})'

# 화면ID 접두사 → 도메인 (긴 접두사 우선)
$CFG_DomainPrefix = @(
    @{ domain = 'DM';  prefixes = @('DMF', 'DM') }
    @{ domain = 'SCP'; prefixes = @('SCP') }
    @{ domain = 'SSP'; prefixes = @('SSP') }
    @{ domain = 'FP';  prefixes = @('FP') }
    @{ domain = 'SCM'; prefixes = @('SCM') }
    # SAP 연계 화면 (SD=판매, MM=자재, PP=생산계획, LE=물류, EIF=인터페이스)
    @{ domain = 'IF';  prefixes = @('NEIF', 'NSD', 'NMM', 'NPP', 'NLE', 'GSD', 'FDM', 'FM', 'MM') }
    @{ domain = 'QA';  prefixes = @('QA') }
)

# 화면 전용 csproj 가 아닌 것으로 볼 프로젝트명 패턴 (템플릿/빈 프로젝트)
$CFG_TemplateProjectPattern = '_Empty_|^GSCM\.Template|^GSCM\.Test\.|Sample'

# 쿼리/SP 참조 추출 — 전부 문자열 리터럴 기반 (실측 확인됨)
$CFG_QueryPattern = @(
    @{ kind = 'FoxDataRequest'; pattern = 'new\s+FoxDataRequest\s*\(\s*"(?<q>[^"]{3,200})"' }
    @{ kind = 'ExecProc';       pattern = '(?:FP_)?Execute(?:Procedure|Proc)\w*\s*\(\s*"(?<q>[^"]{3,200})"' }
    @{ kind = 'ServicesAdd';    pattern = '\.Services\.Add\s*\(\s*"(?<q>[^"]{3,200})"' }
    @{ kind = 'QueryID';        pattern = 'QueryID\s*=\s*"(?<q>[^"]{3,200})"' }
    @{ kind = 'ExecDataSet';    pattern = 'Execute(?:DataSet|NonQuery|Scalar|Reader)\s*\(\s*"(?<q>[^"]{3,200})"' }
)

# 리터럴 연결 형태:  ("PR_UI_" + "FP00599" + "_" + "find_x").ToUpper()
$CFG_ConcatPattern = '"(?:[^"\\\r\n]|\\.)*"(?:\s*\+\s*"(?:[^"\\\r\n]|\\.)*"){1,8}'
# 연결 결과가 이 패턴에 맞을 때만 쿼리로 인정
$CFG_ConcatAccept  = '^(?:PR_|UP_|SP_|USP_)[A-Za-z0-9_\.]{3,}$'

# 동적 UI 패턴 (FarPoint Spread 주력, DevExpress·WinForms 보조)
$CFG_DynPattern = @(
    @{ name = 'Spread.Create';  pattern = 'new\s+FpSpread\b|new\s+SpreadSheet\b' }
    @{ name = 'Spread.Sheet';   pattern = '\.Sheets\s*\[|\.ActiveSheet\b|SheetView\b|\.SheetCount\s*=' }
    @{ name = 'Spread.Column';  pattern = '\.Columns\s*\[|\.Columns\.Add\b|\.ColumnCount\s*=|\.AddColumns?\s*\(' }
    @{ name = 'Spread.CellType';pattern = 'CellType\b' }
    @{ name = 'Spread.Header';  pattern = '\.ColumnHeader\b|\.RowHeader\b|ColHeader|SetColumnHeader' }
    @{ name = 'DevEx.Grid';     pattern = 'GridControl\b|XtraGrid|BandedGridView\b|GridBand\b' }
    @{ name = 'DevEx.Column';   pattern = 'GridColumn\b|RepositoryItem\w*\b|\.Columns\.AddField\b|\.Columns\.AddVisible\b' }
    @{ name = 'WinForms.Grid';  pattern = 'DataGridView(?:Column|TextBoxColumn|ComboBoxColumn)?\b' }
    @{ name = 'Factory';        pattern = '\bCreateColumn\w*\s*\(|\bAddColumn\w*\s*\(|\bInitGrid\w*\s*\(|\bSetGrid\w*\s*\(|\bBindGrid\w*\s*\(|\bMakeGrid\w*\s*\(' }
    @{ name = 'Control.Add';    pattern = '\.Controls\.Add\s*\(' }
)

# Designer 자동생성 파일은 동적 UI 구간에서 제외 (신호 대비 잡음이 큼)
$CFG_DynSkipFilePattern = '\.Designer\.cs$|Resources\.Designer\.cs$|AssemblyInfo\.cs$'

# ==============================================================================
#  공용 함수
# ==============================================================================

if (-not $AsisRoot) { $AsisRoot = $CFG_AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $CFG_DocRoot }

$script:Cp949 = $null
try { [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance) } catch { }
try   { $script:Cp949 = [System.Text.Encoding]::GetEncoding(949) }
catch { $script:Cp949 = [System.Text.Encoding]::Default }

function Write-Banner {
    param([string]$Title)
    Write-Host ''
    Write-Host ('=' * 74) -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host ('=' * 74) -ForegroundColor Cyan
}

function Read-AsisText {
    param([string]$Path)
    try {
        $fi = New-Object System.IO.FileInfo($Path)
        if ($fi.Length -gt ($MaxFileSizeKB * 1KB)) { return $null }
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        if ($bytes.Length -eq 0) { return '' }
        if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            return [System.Text.Encoding]::UTF8.GetString($bytes)
        }
        if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
            return [System.Text.Encoding]::Unicode.GetString($bytes)
        }
        try {
            $strict = New-Object System.Text.UTF8Encoding($false, $true)
            return $strict.GetString($bytes)
        } catch {
            return $script:Cp949.GetString($bytes)
        }
    } catch {
        Write-Warning "READ FAIL: $Path"
        return $null
    }
}

function Write-Csv8 {
    param($Data, [string]$Path, [string[]]$Header)
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { [void](New-Item -ItemType Directory -Force -Path $dir) }
    $rows = @($Data)
    $enc = New-Object System.Text.UTF8Encoding($true)
    if ($rows.Count -eq 0) {
        $line = ($Header | ForEach-Object { '"' + ($_ -replace '"', '""') + '"' }) -join ','
        [System.IO.File]::WriteAllText($Path, $line + "`r`n", $enc)
    } else {
        $csv = $rows | ConvertTo-Csv -NoTypeInformation
        [System.IO.File]::WriteAllText($Path, ($csv -join "`r`n") + "`r`n", $enc)
    }
    Write-Host ("  [OUT] {0}   ({1:N0} rows)" -f $Path, $rows.Count) -ForegroundColor DarkGray
}

function Import-Csv8 {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    return @(Import-Csv -LiteralPath $Path -Encoding UTF8)
}

function Get-Sha256 {
    param([string]$Path)
    try { return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant() }
    catch { return '' }
}

function Get-DomainOf {
    param([string]$ScreenId)
    if ([string]::IsNullOrWhiteSpace($ScreenId)) { return 'UNKNOWN' }
    foreach ($d in $CFG_DomainPrefix) {
        foreach ($p in $d.prefixes) {
            if ($ScreenId.StartsWith($p, [StringComparison]::OrdinalIgnoreCase)) { return $d.domain }
        }
    }
    return 'UNKNOWN'
}

# ==============================================================================
#  커버리지 판정 모드
# ==============================================================================

if ($CheckScreen) {
    $covDir = Join-Path $DocRoot 'coverage'
    if (-not (Test-Path -LiteralPath $covDir)) {
        Write-Host "커버리지 장부가 없습니다: $covDir" -ForegroundColor Red
        Write-Host "먼저 인덱스를 생성하세요:  .\Build-AsisIndex.ps1" -ForegroundColor Red
        exit 2
    }

    $rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\', '/')
    $projRoot = Split-Path -Parent $DocRoot

    $all = New-Object System.Collections.ArrayList
    foreach ($lf in @(Get-ChildItem -LiteralPath $covDir -Filter '*.csv' -File)) {
        foreach ($r in (Import-Csv8 -Path $lf.FullName)) { [void]$all.Add($r) }
    }
    if ($CheckScreen -ne '*') {
        $all = @($all | Where-Object { $_.screen_id -ieq $CheckScreen })
        if ($all.Count -eq 0) {
            Write-Host "장부에 화면ID '$CheckScreen' 가 없습니다." -ForegroundColor Red
            exit 2
        }
    }

    $problems = New-Object System.Collections.ArrayList
    $done = 0; $na = 0; $gone = 0
    foreach ($r in $all) {
        $st = ([string]$r.status).Trim().ToLowerInvariant()
        if ($st -eq 'gone') { $gone++; continue }
        if ($st -eq 'n/a' -or $st -eq 'na') { $na++; continue }
        if ($st -ne 'done') {
            [void]$problems.Add([pscustomobject]@{ screen_id = $r.screen_id; file_path = $r.file_path; issue = 'NOT_DONE'; detail = "status=$st" })
            continue
        }
        $done++
        $ev = [string]$r.evidence_path
        if ([string]::IsNullOrWhiteSpace($ev)) {
            [void]$problems.Add([pscustomobject]@{ screen_id = $r.screen_id; file_path = $r.file_path; issue = 'EVIDENCE_MISSING'; detail = 'evidence_path 비어 있음' })
            continue
        }
        $evFull = if ([System.IO.Path]::IsPathRooted($ev)) { $ev } else { Join-Path $projRoot $ev }
        if (-not (Test-Path -LiteralPath $evFull)) {
            [void]$problems.Add([pscustomobject]@{ screen_id = $r.screen_id; file_path = $r.file_path; issue = 'EVIDENCE_NOT_FOUND'; detail = $evFull })
            continue
        }
        if (-not $SkipHashCheck) {
            $src = Join-Path $rootFull $r.file_path
            if (Test-Path -LiteralPath $src) {
                $cur = Get-Sha256 -Path $src
                if ($r.sha256 -and $cur -and $cur -ne [string]$r.sha256) {
                    [void]$problems.Add([pscustomobject]@{ screen_id = $r.screen_id; file_path = $r.file_path; issue = 'SOURCE_CHANGED'; detail = 'AS-IS 원본 변경 — 재검토 필요' })
                }
            }
        }
    }

    if ($Summary) {
        $byScreen = $all | Group-Object screen_id
        $inc = @()
        foreach ($g in $byScreen) {
            $t = @($g.Group | Where-Object { ([string]$_.status).Trim().ToLowerInvariant() -notin @('done', 'n/a', 'na', 'gone') }).Count
            if ($t -gt 0) { $inc += [pscustomobject]@{ screen_id = $g.Name; total = $g.Count; remaining = $t } }
        }
        Write-Host ''
        Write-Host ("커버리지 요약   화면 {0:N0} / 파일 {1:N0}" -f $byScreen.Count, $all.Count) -ForegroundColor Cyan
        Write-Host ("  done={0}  n/a={1}  gone={2}  미완={3}" -f $done, $na, $gone, $problems.Count)
        Write-Host ''
        if ($inc.Count -gt 0) {
            Write-Host '  미완 화면 (남은 파일 수 순)' -ForegroundColor Yellow
            foreach ($x in ($inc | Sort-Object remaining -Descending | Select-Object -First 40)) {
                Write-Host ("    {0,-14} {1,4}/{2,-4}" -f $x.screen_id, $x.remaining, $x.total)
            }
            if ($inc.Count -gt 40) { Write-Host ("    ... 외 {0}개 화면" -f ($inc.Count - 40)) }
        } else {
            Write-Host '  미완 화면 없음.' -ForegroundColor Green
        }
        Write-Host ''
    }

    if ($problems.Count -eq 0) {
        Write-Host "OK  $CheckScreen : 커버리지 완료 (done=$done, n/a=$na, gone=$gone)" -ForegroundColor Green
        exit 0
    }
    Write-Host ''
    Write-Host "INCOMPLETE  $CheckScreen : 미해결 $($problems.Count)건" -ForegroundColor Red
    foreach ($p in ($problems | Select-Object -First 50)) {
        Write-Host ("  [{0,-18}] {1,-14} {2}" -f $p.issue, $p.screen_id, $p.file_path) -ForegroundColor Red
        if ($p.issue -ne 'NOT_DONE') { Write-Host ("       -> {0}" -f $p.detail) -ForegroundColor DarkRed }
    }
    if ($problems.Count -gt 50) { Write-Host ("  ... 외 {0}건" -f ($problems.Count - 50)) -ForegroundColor Red }
    Write-Host ''
    exit 1
}

# ==============================================================================
#  인덱스 생성 모드
# ==============================================================================

Write-Banner "NSCM AS-IS 인덱서   |   $AsisRoot"

if (-not (Test-Path -LiteralPath $AsisRoot)) {
    throw "AS-IS 루트를 찾을 수 없습니다: $AsisRoot   (-AsisRoot 로 지정하세요)"
}
$rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\', '/')
$outDir   = Join-Path $DocRoot 'asis'
$probeDir = Join-Path $outDir '_probe'

# ---- 파일 열거 ---------------------------------------------------------------
Write-Host '[1/7] 파일 열거...' -ForegroundColor Yellow
$swAll = [System.Diagnostics.Stopwatch]::StartNew()

$excl = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($d in $CFG_ExcludeDir) { [void]$excl.Add($d) }
$incTop = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($d in $CFG_IncludeTop) { [void]$incTop.Add($d) }

$files = New-Object System.Collections.ArrayList
$skippedTop = 0; $skippedDir = 0
foreach ($f in (Get-ChildItem -LiteralPath $rootFull -Recurse -File -Filter '*.cs' -Force -ErrorAction SilentlyContinue)) {
    $rel = $f.FullName.Substring($rootFull.Length).TrimStart('\', '/')
    $seg = $rel -split '[\\/]'
    if ($incTop.Count -gt 0 -and $seg.Length -gt 0 -and -not $incTop.Contains($seg[0])) { $skippedTop++; continue }
    $bad = $false
    for ($i = 0; $i -lt $seg.Length - 1; $i++) { if ($excl.Contains($seg[$i])) { $bad = $true; break } }
    if ($bad) { $skippedDir++; continue }
    [void]$files.Add($f)
}
Write-Host ("      대상 {0:N0}건   (최상위폴더 제외 {1:N0} / 하위폴더 제외 {2:N0})   {3:N1}s" -f `
    $files.Count, $skippedTop, $skippedDir, $swAll.Elapsed.TotalSeconds)

if ($files.Count -eq 0) { throw "스캔 대상이 0건입니다. 설정의 CFG_IncludeTop 을 확인하세요." }

# ---- 프로젝트(.csproj) / 솔루션(.sln) 매핑 -----------------------------------
# 화면 하나가 개별 .csproj 인 구조이므로, "화면 전용 csproj + sln 등록" 을 현행판으로 본다.
Write-Host '[2/7] 프로젝트-솔루션 매핑...' -ForegroundColor Yellow

$slnSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
$slnCount = 0
foreach ($sln in @(Get-ChildItem -LiteralPath $rootFull -Recurse -File -Filter '*.sln' -ErrorAction SilentlyContinue)) {
    $slnDir = Split-Path -Parent $sln.FullName
    $txt = Read-AsisText -Path $sln.FullName
    if (-not $txt) { continue }
    $slnCount++
    foreach ($m in [regex]::Matches($txt, '=\s*"[^"]+"\s*,\s*"(?<p>[^"]+\.csproj)"')) {
        try {
            $full = [System.IO.Path]::GetFullPath((Join-Path $slnDir ($m.Groups['p'].Value -replace '\\', '/')))
            [void]$slnSet.Add($full)
        } catch { }
    }
}

$projByDir = @{}
foreach ($pj in @(Get-ChildItem -LiteralPath $rootFull -Recurse -File -Filter '*.csproj' -ErrorAction SilentlyContinue)) {
    $d = Split-Path -Parent $pj.FullName
    if ($projByDir.ContainsKey($d)) { continue }
    $projByDir[$d] = [pscustomobject]@{
        name   = [System.IO.Path]::GetFileNameWithoutExtension($pj.Name)
        in_sln = $slnSet.Contains([System.IO.Path]::GetFullPath($pj.FullName))
    }
}
Write-Host ("      .sln {0}개 / .csproj {1}개 / sln 등록 {2}개" -f $slnCount, $projByDir.Count, $slnSet.Count)

function Get-ProjectOfFile {
    param([string]$FullPath)
    $d = Split-Path -Parent $FullPath
    while ($d) {
        if ($projByDir.ContainsKey($d)) { return $projByDir[$d] }
        $up = Split-Path -Parent $d
        if ($up -eq $d) { break }
        $d = $up
    }
    return $null
}

# ---- 정규식 준비 -------------------------------------------------------------
$RXC  = [System.Text.RegularExpressions.RegexOptions]'Compiled'
$RXCI = [System.Text.RegularExpressions.RegexOptions]'Compiled, IgnoreCase'

$idRx = New-Object System.Text.RegularExpressions.Regex($CFG_ScreenIdPattern, $RXCI)

$qRx = @()
foreach ($p in $CFG_QueryPattern) {
    $qRx += [pscustomobject]@{ kind = [string]$p.kind; rx = New-Object System.Text.RegularExpressions.Regex(([string]$p.pattern), $RXC) }
}
$concatRx  = New-Object System.Text.RegularExpressions.Regex($CFG_ConcatPattern, $RXC)
$litRx     = New-Object System.Text.RegularExpressions.Regex('"((?:[^"\\\r\n]|\\.)*)"', $RXC)
$acceptRx  = New-Object System.Text.RegularExpressions.Regex($CFG_ConcatAccept, $RXCI)

$dynRx = @()
foreach ($p in $CFG_DynPattern) {
    $dynRx += [pscustomobject]@{ name = [string]$p.name; rx = New-Object System.Text.RegularExpressions.Regex(([string]$p.pattern), $RXC) }
}
$dynSkipRx = New-Object System.Text.RegularExpressions.Regex($CFG_DynSkipFilePattern, $RXCI)

function Resolve-ScreenIdFromPath {
    param([string]$FullPath)
    $leaf = [System.IO.Path]::GetFileNameWithoutExtension($FullPath)
    $m = $idRx.Match($leaf)
    if ($m.Success) { return $m.Groups['id'].Value.ToUpperInvariant() }
    $dir = Split-Path -Parent $FullPath
    while ($dir) {
        $name = Split-Path -Leaf $dir
        if (-not $name) { break }
        $m = $idRx.Match($name)
        if ($m.Success) { return $m.Groups['id'].Value.ToUpperInvariant() }
        $parent = Split-Path -Parent $dir
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    return ''
}

# ---- 스캔 --------------------------------------------------------------------
Write-Host '[3/7] 소스 스캔 (파일당 1회 읽기)...' -ForegroundColor Yellow

$fileRows = New-Object System.Collections.ArrayList
$queryRows = New-Object System.Collections.ArrayList
$dynRows  = New-Object System.Collections.ArrayList
$unmapped = New-Object System.Collections.ArrayList
$screens  = @{}

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$i = 0
foreach ($f in $files) {
    $i++
    if ($i % 250 -eq 0) {
        Write-Host ("      {0:N0}/{1:N0}   ({2:N0}s)" -f $i, $files.Count, $sw.Elapsed.TotalSeconds) -ForegroundColor DarkGray
    }

    $text = Read-AsisText -Path $f.FullName
    if ($null -eq $text) { continue }

    $rel = $f.FullName.Substring($rootFull.Length).TrimStart('\', '/')
    $seg = $rel -split '[\\/]'
    $layer = if ($CFG_LayerOfTop.ContainsKey($seg[0])) { $CFG_LayerOfTop[$seg[0]] } else { 'ETC' }
    $screenId = Resolve-ScreenIdFromPath -FullPath $f.FullName
    $domain = Get-DomainOf -ScreenId $screenId

    $proj = Get-ProjectOfFile -FullPath $f.FullName
    $projName = if ($proj) { $proj.name } else { '' }
    $inSln    = if ($proj -and $proj.in_sln) { 1 } else { 0 }
    $projKind = 'shared'
    if ($proj) {
        if ($proj.name -match $CFG_TemplateProjectPattern) { $projKind = 'template' }
        elseif ($screenId -and $proj.name.ToUpperInvariant().Contains($screenId)) { $projKind = 'screen' }
    }

    if (-not $screenId) {
        [void]$unmapped.Add([pscustomobject]@{ rel_path = $rel; layer = $layer; project = $projName; size_kb = [math]::Round($f.Length / 1KB, 1) })
    }

    $lines = $text -split "`r`n|`n|`r"
    $qNames = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)

    # ---- 쿼리 참조 (라인 단위: 위치를 남겨야 추적 가능) ----
    for ($ln = 0; $ln -lt $lines.Length; $ln++) {
        $line = $lines[$ln]
        if ($line.IndexOf('"') -lt 0) { continue }

        $isComment = $line.TrimStart().StartsWith('//')

        foreach ($q in $qRx) {
            foreach ($m in $q.rx.Matches($line)) {
                $raw = $m.Groups['q'].Value
                if ([string]::IsNullOrWhiteSpace($raw)) { continue }
                $schema = ''
                $name = $raw
                $dot = $raw.IndexOf('.')
                if ($dot -gt 0 -and $dot -lt ($raw.Length - 1)) {
                    $schema = $raw.Substring(0, $dot); $name = $raw.Substring($dot + 1)
                }
                if ($name -notmatch '^[A-Za-z_][A-Za-z0-9_]{2,}$') { continue }
                $rm = $idRx.Match($name)
                $refScreen = if ($rm.Success) { $rm.Groups['id'].Value.ToUpperInvariant() } else { '' }
                $full = if ($schema) { "$schema.$name" } else { $name }
                # 주석 처리된 호출은 추적용으로 기록만 하고 화면 집계에는 넣지 않는다
                if (-not $isComment) { [void]$qNames.Add($full) }
                [void]$queryRows.Add([pscustomobject]@{
                    screen_id     = $screenId
                    domain        = $domain
                    layer         = $layer
                    rel_path      = $rel
                    line_no       = $ln + 1
                    kind          = $q.kind
                    schema        = $schema
                    query_name    = $name
                    full_name     = $full
                    ref_screen_id = $refScreen
                    commented     = $(if ($isComment) { 1 } else { 0 })
                })
            }
        }

        # 리터럴 연결:  ("PR_UI_" + "FP00599" + "_" + "find_x")
        foreach ($m in $concatRx.Matches($line)) {
            $joined = ''
            foreach ($lm in $litRx.Matches($m.Value)) { $joined += $lm.Groups[1].Value }
            if (-not $acceptRx.IsMatch($joined)) { continue }
            $rm = $idRx.Match($joined)
            $refScreen = if ($rm.Success) { $rm.Groups['id'].Value.ToUpperInvariant() } else { '' }
            $joinedU = $joined.ToUpperInvariant()
            if (-not $isComment) { [void]$qNames.Add($joinedU) }
            [void]$queryRows.Add([pscustomobject]@{
                screen_id     = $screenId
                domain        = $domain
                layer         = $layer
                rel_path      = $rel
                line_no       = $ln + 1
                kind          = 'Concat'
                schema        = ''
                query_name    = $joinedU
                full_name     = $joinedU
                ref_screen_id = $refScreen
                commented     = $(if ($isComment) { 1 } else { 0 })
            })
        }
    }

    # ---- 동적 UI: 라인 히트 → 구간 병합 ----
    $dynHits = 0
    $regions = 0
    if (-not $dynSkipRx.IsMatch($f.Name)) {
        $hits = New-Object System.Collections.ArrayList
        for ($ln = 0; $ln -lt $lines.Length; $ln++) {
            $line = $lines[$ln]
            if ($line.Length -lt 5) { continue }
            foreach ($d in $dynRx) {
                if ($d.rx.IsMatch($line)) {
                    [void]$hits.Add([pscustomobject]@{ ln = $ln + 1; name = $d.name; text = $line.Trim() })
                    break
                }
            }
        }
        $dynHits = $hits.Count

        if ($hits.Count -gt 0) {
            $start = $hits[0].ln; $prev = $hits[0].ln
            $bucket = New-Object System.Collections.ArrayList
            [void]$bucket.Add($hits[0])
            for ($k = 1; $k -le $hits.Count; $k++) {
                $cur = if ($k -lt $hits.Count) { $hits[$k] } else { $null }
                if ($null -ne $cur -and ($cur.ln - $prev) -le $RegionGap) {
                    [void]$bucket.Add($cur); $prev = $cur.ln; continue
                }
                $pat = (@($bucket | Group-Object name | Sort-Object Count -Descending | Select-Object -First 3 -ExpandProperty Name)) -join '|'
                $sample = [string]$bucket[0].text
                if ($sample.Length -gt 150) { $sample = $sample.Substring(0, 150) + '...' }
                [void]$dynRows.Add([pscustomobject]@{
                    screen_id  = $screenId
                    domain     = $domain
                    layer      = $layer
                    rel_path   = $rel
                    start_line = $start
                    end_line   = $prev
                    hits       = $bucket.Count
                    patterns   = $pat
                    sample     = $sample
                })
                $regions++
                if ($null -ne $cur) {
                    $bucket = New-Object System.Collections.ArrayList
                    [void]$bucket.Add($cur)
                    $start = $cur.ln; $prev = $cur.ln
                }
            }
        }
    }

    [void]$fileRows.Add([pscustomobject]@{
        screen_id   = $screenId
        domain      = $domain
        layer       = $layer
        project     = $projName
        project_kind= $projKind
        in_sln      = $inSln
        file_status = ''
        rel_path    = $rel
        line_count  = $lines.Length
        dyn_hits    = $dynHits
        dyn_regions = $regions
        query_count = $qNames.Count
        sha256      = (Get-Sha256 -Path $f.FullName)
    })

    if ($screenId) {
        if (-not $screens.ContainsKey($screenId)) {
            $screens[$screenId] = [pscustomobject]@{
                screen_id = $screenId
                domain    = $domain
                files     = (New-Object System.Collections.ArrayList)
                byLayer   = @{}
                queries   = (New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase))
                dynFiles  = (New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase))
                projects  = (New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase))
                lines     = 0
                regions   = 0
            }
        }
        $a = $screens[$screenId]
        [void]$a.files.Add($rel)
        if ($projName) { [void]$a.projects.Add($projName) }
        if (-not $a.byLayer.ContainsKey($layer)) { $a.byLayer[$layer] = New-Object System.Collections.ArrayList }
        [void]$a.byLayer[$layer].Add($rel)
        foreach ($q in $qNames) { [void]$a.queries.Add($q) }
        if ($regions -gt 0) { [void]$a.dynFiles.Add($rel); $a.regions += $regions }
        $a.lines += $lines.Length
    }
}
$sw.Stop()
Write-Host ("      완료 — 화면 {0:N0} / 파일 {1:N0} / 쿼리참조 {2:N0} / 동적UI구간 {3:N0}   {4:N1}s" -f `
    $screens.Count, $fileRows.Count, $queryRows.Count, $dynRows.Count, $sw.Elapsed.TotalSeconds)

# ---- 현행판 / 구버전 판정 -----------------------------------------------------
# 화면 전용 csproj 가 sln 에 등록되어 있으면 그 파일이 현행판이다.
# 같은 화면의 나머지 사본(통짜 프로젝트 안에 남은 것)은 legacy 로 표시하고
# 커버리지 장부에서 제외한다 — 죽은 사본을 변환 대상으로 잡지 않기 위함.
$curScreens = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($r in $fileRows) {
    if ($r.screen_id -and $r.project_kind -eq 'screen' -and $r.in_sln -eq 1) { [void]$curScreens.Add($r.screen_id) }
}
$legacyCount = 0
foreach ($r in $fileRows) {
    if (-not $r.screen_id) { continue }
    if ($r.project_kind -eq 'template') { $r.file_status = 'template'; continue }
    if ($r.project_kind -eq 'screen' -and $r.in_sln -eq 1) { $r.file_status = 'current'; continue }
    # 중복 판정은 UIL 안에서만 유효하다.
    # BIZ/WSL/WS 는 화면 전용 csproj 로 쪼개지는 대상이 아니므로 legacy 로 보면 안 된다.
    if ($r.layer -eq 'UIL' -and $curScreens.Contains($r.screen_id)) { $r.file_status = 'legacy'; $legacyCount++; continue }
    $r.file_status = 'only'
}
Write-Host ("      현행 판정 — 전용 csproj 보유 화면 {0:N0}개 / 구버전 사본 파일 {1:N0}건" -f $curScreens.Count, $legacyCount) -ForegroundColor Yellow

# ---- 쿼리 → 화면 역매핑 -------------------------------------------------------
# SP 이름에 화면ID가 들어 있으므로(DMF0052_..., PR_UI_FP03033_...) 파일 위치가 아니라
# 쿼리 이름 기준으로도 화면에 연결한다. 공통 쿼리(UP_FX_...)는 ref_screen_id 가 빈다.
Write-Host '[4/7] 쿼리-화면 역매핑...' -ForegroundColor Yellow
$refAdded = 0
foreach ($q in $queryRows) {
    if (-not $q.ref_screen_id) { continue }
    $sid = $q.ref_screen_id
    if (-not $screens.ContainsKey($sid)) { continue }
    if ($q.commented -eq 1) { continue }
    if ($screens[$sid].queries.Add($q.full_name)) { $refAdded++ }
}
Write-Host ("      쿼리 이름 기준으로 {0:N0}건 추가 연결" -f $refAdded)

# ---- 인벤토리 조립 ------------------------------------------------------------
Write-Host '[5/7] 화면 인벤토리 조립...' -ForegroundColor Yellow

function Join-Layer {
    param($Agg, [string]$Layer)
    if ($Agg.byLayer.ContainsKey($Layer)) { return (($Agg.byLayer[$Layer] | Sort-Object) -join ';') }
    return ''
}

$curByScreen = @{}
$legByScreen = @{}
foreach ($r in $fileRows) {
    if (-not $r.screen_id) { continue }
    if ($r.file_status -in @('legacy','template')) {
        if (-not $legByScreen.ContainsKey($r.screen_id)) { $legByScreen[$r.screen_id] = New-Object System.Collections.ArrayList }
        [void]$legByScreen[$r.screen_id].Add($r.rel_path)
    } else {
        if (-not $curByScreen.ContainsKey($r.screen_id)) { $curByScreen[$r.screen_id] = New-Object System.Collections.ArrayList }
        [void]$curByScreen[$r.screen_id].Add($r.rel_path)
    }
}

$inventory = foreach ($k in ($screens.Keys | Sort-Object)) {
    $a = $screens[$k]
    $uil = Join-Layer -Agg $a -Layer 'UIL'
    # 주의: $x = if(){@()}else{@()} 는 파이프라인이 빈 배열을 삼켜 $null 이 된다.
    # 반드시 직접 대입할 것.
    $cur = @()
    if ($curByScreen.ContainsKey($k)) { $cur = @($curByScreen[$k] | Sort-Object) }
    $leg = @()
    if ($legByScreen.ContainsKey($k)) { $leg = @($legByScreen[$k] | Sort-Object) }
    [pscustomobject]@{
        screen_id    = $a.screen_id
        domain       = $a.domain
        status       = $(if ($leg.Count -gt 0) { 'has_legacy' } elseif ($cur.Count -gt 0) { 'ok' } else { 'none' })
        projects     = (($a.projects | Sort-Object) -join ';')
        project_count= $a.projects.Count
        current_files= ($cur -join ';')
        legacy_files = ($leg -join ';')
        file_count   = $a.files.Count
        total_lines  = $a.lines
        layers       = (($a.byLayer.Keys | Sort-Object) -join ';')
        uil_files    = $uil
        biz_files    = (Join-Layer -Agg $a -Layer 'BIZ')
        wsl_files    = (Join-Layer -Agg $a -Layer 'WSL')
        ws_files     = (Join-Layer -Agg $a -Layer 'WS')
        other_files  = ((@($a.byLayer.Keys | Where-Object { $_ -notin @('UIL','BIZ','WSL','WS') } | ForEach-Object { $a.byLayer[$_] }) | Sort-Object) -join ';')
        query_count  = $a.queries.Count
        query_refs   = (($a.queries | Sort-Object) -join ';')
        dyn_files    = (($a.dynFiles | Sort-Object) -join ';')
        dyn_regions  = $a.regions
        entry_file   = $(if ($cur.Count -gt 0) { $cur[0] } elseif ($uil) { ($uil -split ';')[0] } else { ($a.files | Sort-Object | Select-Object -First 1) })
    }
}

Write-Csv8 -Data $inventory -Path (Join-Path $outDir 'screen-inventory.csv') `
    -Header @('screen_id','domain','status','projects','project_count','current_files','legacy_files','file_count','total_lines','layers','uil_files','biz_files','wsl_files','ws_files','other_files','query_count','query_refs','dyn_files','dyn_regions','entry_file')

Write-Csv8 -Data $fileRows -Path (Join-Path $outDir 'screen-file-map.csv') `
    -Header @('screen_id','domain','layer','project','project_kind','in_sln','file_status','rel_path','line_count','dyn_hits','dyn_regions','query_count','sha256')

Write-Csv8 -Data $queryRows -Path (Join-Path $outDir 'query-refs.csv') `
    -Header @('screen_id','domain','layer','rel_path','line_no','kind','schema','query_name','full_name','ref_screen_id','commented')

Write-Csv8 -Data $dynRows -Path (Join-Path $outDir 'dynamic-ui.csv') `
    -Header @('screen_id','domain','layer','rel_path','start_line','end_line','hits','patterns','sample')

if ($unmapped.Count -gt 0) {
    Write-Csv8 -Data $unmapped -Path (Join-Path $probeDir 'unmapped-files.csv') -Header @('rel_path','layer','project','size_kb')
}

# 고유 쿼리 목록 (SP 변환 작업 목록의 원본)
$qUnique = $queryRows | Group-Object full_name | ForEach-Object {
    $g = $_.Group
    [pscustomobject]@{
        query_name   = $_.Name
        schema       = (@($g | Where-Object { $_.schema } | Select-Object -ExpandProperty schema -Unique) -join ';')
        ref_screen   = ($g[0].ref_screen_id)
        domain       = (Get-DomainOf -ScreenId $g[0].ref_screen_id)
        call_sites   = $_.Count
        kinds        = ((@($g | Select-Object -ExpandProperty kind -Unique) | Sort-Object) -join ';')
        active_sites = @($g | Where-Object { $_.commented -eq 0 }).Count
    }
}
Write-Csv8 -Data ($qUnique | Sort-Object domain, query_name) -Path (Join-Path $outDir 'query-inventory.csv') `
    -Header @('query_name','schema','ref_screen','domain','call_sites','kinds','active_sites')

# ---- 커버리지 장부 ------------------------------------------------------------
if (-not $SkipCoverage) {
    Write-Host '[6/7] 커버리지 장부...' -ForegroundColor Yellow
    $covDir = Join-Path $DocRoot 'coverage'
    $now = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

    foreach ($g in ($fileRows | Where-Object { $_.screen_id -and $_.file_status -notin @('legacy','template') } | Group-Object domain)) {
        $dom = if ($g.Name) { $g.Name } else { 'UNKNOWN' }
        $covPath = Join-Path $covDir "$dom.csv"

        $existing = @{}
        foreach ($e in (Import-Csv8 -Path $covPath)) { $existing["$($e.screen_id)|$($e.file_path)"] = $e }

        $newRows = New-Object System.Collections.ArrayList
        $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
        $added = 0; $reverted = 0

        foreach ($m in ($g.Group | Sort-Object screen_id, layer, rel_path)) {
            $key = "$($m.screen_id)|$($m.rel_path)"
            [void]$seen.Add($key)
            if ($existing.ContainsKey($key)) {
                $p = $existing[$key]
                $pSha = if ($p.PSObject.Properties.Name -contains 'sha256') { [string]$p.sha256 } else { '' }
                $pSt  = if ($p.PSObject.Properties.Name -contains 'status') { [string]$p.status } else { 'todo' }
                $pEv  = if ($p.PSObject.Properties.Name -contains 'evidence_path') { [string]$p.evidence_path } else { '' }
                $pNote= if ($p.PSObject.Properties.Name -contains 'note') { [string]$p.note } else { '' }
                if ($pSha -and $pSha -ne $m.sha256) {
                    $st = 'todo'; $ev = $pEv; $note = "AS-IS 원본 변경으로 todo 회귀 (이전=$pSt)"; $upd = $now; $reverted++
                } else {
                    $st = $(if ($pSt) { $pSt } else { 'todo' }); $ev = $pEv; $note = $pNote
                    $upd = if ($p.PSObject.Properties.Name -contains 'updated' -and $p.updated) { [string]$p.updated } else { $now }
                }
            } else {
                $st = 'todo'; $ev = ''; $note = ''; $upd = $now; $added++
            }
            [void]$newRows.Add([pscustomobject]@{
                screen_id = $m.screen_id; layer = $m.layer; file_path = $m.rel_path
                sha256 = $m.sha256; status = $st; evidence_path = $ev; updated = $upd; note = $note
            })
        }

        foreach ($k in $existing.Keys) {
            if ($seen.Contains($k)) { continue }
            $e = $existing[$k]
            [void]$newRows.Add([pscustomobject]@{
                screen_id = $e.screen_id
                layer     = $(if ($e.PSObject.Properties.Name -contains 'layer') { $e.layer } else { '' })
                file_path = $e.file_path
                sha256    = $(if ($e.PSObject.Properties.Name -contains 'sha256') { $e.sha256 } else { '' })
                status    = 'gone'
                evidence_path = $(if ($e.PSObject.Properties.Name -contains 'evidence_path') { $e.evidence_path } else { '' })
                updated   = $now
                note      = 'AS-IS 원본에서 사라짐'
            })
        }

        Write-Csv8 -Data (@($newRows | Sort-Object screen_id, layer, file_path)) -Path $covPath `
            -Header @('screen_id','layer','file_path','sha256','status','evidence_path','updated','note')
        Write-Host ("        {0,-8} 신규 {1,5} / 원본변경 회귀 {2,4}" -f $dom, $added, $reverted) -ForegroundColor DarkGray
    }
} else {
    Write-Host '[6/7] 커버리지 장부 건너뜀' -ForegroundColor DarkGray
}

# ---- 요약 --------------------------------------------------------------------
Write-Host '[7/7] 요약' -ForegroundColor Yellow
$swAll.Stop()

$byDomain = $inventory | Group-Object domain | Sort-Object Count -Descending
$byLayer  = $fileRows  | Group-Object layer  | Sort-Object Count -Descending

Write-Host ''
Write-Host '  도메인별 화면 수' -ForegroundColor White
foreach ($g in $byDomain) { Write-Host ("    {0,-10} {1,6:N0}" -f $g.Name, $g.Count) }
Write-Host ''
Write-Host '  레이어별 파일 수' -ForegroundColor White
foreach ($g in $byLayer)  { Write-Host ("    {0,-10} {1,6:N0}" -f $g.Name, $g.Count) }
Write-Host ''
Write-Host ("  고유 쿼리/SP        : {0:N0}" -f @($qUnique).Count)
Write-Host ("  동적 UI 구간         : {0:N0}" -f $dynRows.Count)
Write-Host ("  화면ID 미매핑 파일   : {0:N0}  ({1:P1})" -f $unmapped.Count, ($unmapped.Count / [math]::Max($fileRows.Count,1)))
Write-Host ("  총 소요              : {0:N1}분" -f $swAll.Elapsed.TotalMinutes)
Write-Host ''

$hasLegacy = @($inventory | Where-Object { $_.status -eq 'has_legacy' }).Count
Write-Host ("  구버전 사본이 있는 화면 : {0:N0} / {1:N0}   (커버리지 장부에서 legacy 제외됨)" -f $hasLegacy, @($inventory).Count)
Write-Host ""
$noQuery = @($inventory | Where-Object { $_.query_count -eq 0 }).Count
$noDyn   = @($inventory | Where-Object { $_.dyn_regions -eq 0 }).Count
Write-Host ("  쿼리 미연결 화면     : {0:N0} / {1:N0}" -f $noQuery, @($inventory).Count)
Write-Host ("  동적UI 미검출 화면   : {0:N0} / {1:N0}" -f $noDyn,   @($inventory).Count)
Write-Host ''
Write-Host ("산출물: {0}" -f $outDir) -ForegroundColor Green
Write-Host ''
Write-Host '화면 하나 확인해 보세요:' -ForegroundColor Cyan
$sample = @($inventory | Where-Object { $_.domain -eq 'DM' -and $_.query_count -gt 0 } | Select-Object -First 1)
if ($sample.Count -gt 0) {
    Write-Host ("  Import-Csv '{0}' -Encoding UTF8 | Where-Object screen_id -eq '{1}' | Format-List" -f `
        (Join-Path $outDir 'screen-inventory.csv'), $sample[0].screen_id) -ForegroundColor Cyan
}
