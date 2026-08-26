<#
.SYNOPSIS
    .foxml 전수 파싱 → SQL 본문 / 파라미터 / 쿼리ID 카탈로그 생성 (read-only)
.DESCRIPTION
    산출물:
      doc/asis/foxml-catalog.csv   : foxml_id, file, query_id, sql_kind, params, tables, sp_refs, line_count, sha256
      doc/asis/foxml-catalog.md    : 사람이 읽는 카탈로그(쿼리 본문 포함)
      doc/asis/foxml-index.json    : 02-Scan-Sources.ps1 이 소비하는 이름 인덱스
    XML 스키마를 모르므로 구조 무관 walker 로 처리하고, XML 파싱 실패 시 정규식으로 폴백합니다.
.EXAMPLE
    .\01-Extract-Foxml.ps1
#>
[CmdletBinding()]
param(
    [string]$AsisRoot,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'asis-config.psd1'),
    [int]$MaxSqlCharsInMd = 4000
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'lib\AsisCommon.psm1') -Force

$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $AsisRoot) { $AsisRoot = $cfg.AsisRoot }
if (-not $DocRoot)  { $DocRoot  = $cfg.DocRoot }

Write-AsisBanner "foxml 전수 추출  |  ROOT = $AsisRoot"

$rootFull = (Resolve-Path -LiteralPath $AsisRoot).ProviderPath.TrimEnd('\','/')
$outDir   = Join-Path $DocRoot 'asis'

$sqlRx   = New-Object System.Text.RegularExpressions.Regex($cfg.SqlDetectPattern, 'Compiled')
$paramRx = New-Object System.Text.RegularExpressions.Regex($cfg.FoxmlParamPattern, 'Compiled')
$spRx    = New-Object System.Text.RegularExpressions.Regex($cfg.SpNamePattern, 'Compiled, IgnoreCase')
$tableRx = New-Object System.Text.RegularExpressions.Regex(
    '(?is)\b(?:FROM|JOIN|INTO|UPDATE)\s+(?<t>(?:\[[^\]]+\]|[A-Za-z_][A-Za-z0-9_]*)(?:\s*\.\s*(?:\[[^\]]+\]|[A-Za-z_][A-Za-z0-9_]*)){0,2})',
    'Compiled')

$files = @(Get-AsisFiles -Root $rootFull -Extension $cfg.FoxmlExtension -ExcludeDirectory $cfg.ExcludeDirectory)
Write-Host ("[1/3] .foxml {0:N0}건 발견" -f $files.Count) -ForegroundColor Yellow

if ($files.Count -eq 0) {
    Write-Warning "foxml 파일이 없습니다. asis-config.psd1 의 FoxmlExtension 을 확인하세요. (현재: $($cfg.FoxmlExtension -join ','))"
}

$catalog  = New-Object System.Collections.ArrayList
$mdBlocks = New-Object System.Collections.ArrayList
$parseFail = New-Object System.Collections.ArrayList
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$i = 0

function Get-SqlKind {
    param([string]$Sql)
    $s = $Sql.TrimStart()
    if ($s -imatch '^\s*(WITH|SELECT)')      { return 'SELECT' }
    if ($s -imatch '^\s*INSERT')             { return 'INSERT' }
    if ($s -imatch '^\s*UPDATE')             { return 'UPDATE' }
    if ($s -imatch '^\s*DELETE')             { return 'DELETE' }
    if ($s -imatch '^\s*MERGE')              { return 'MERGE'  }
    if ($s -imatch '^\s*(EXEC|EXECUTE)\b')   { return 'EXEC'   }
    return 'MIXED'
}

foreach ($f in $files) {
    $i++
    if ($i % 200 -eq 0) { Write-Host ("      {0}/{1} ..." -f $i, $files.Count) -ForegroundColor DarkGray }

    $text = Read-AsisText -Path $f.FullName -MaxSizeKB $cfg.MaxFileSizeKB
    if ($null -eq $text) { continue }

    $rel     = Get-AsisRelativePath -FullPath $f.FullName -Root $rootFull
    $foxmlId = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $sha     = Get-AsisSha256 -Path $f.FullName

    # ---- 쿼리 노드 수집: XML 우선, 실패 시 정규식 ----
    $queries = New-Object System.Collections.ArrayList   # @{ qid; sql; node }

    $xmlOk = $false
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.PreserveWhitespace = $true
        $xml.LoadXml($text)
        $xmlOk = $true

        $stack = New-Object System.Collections.Stack
        $stack.Push($xml.DocumentElement)
        while ($stack.Count -gt 0) {
            $node = $stack.Pop()
            if ($null -eq $node) { continue }

            # 자식 요소가 없는(=leaf) 노드의 텍스트만 SQL 후보로 본다.
            $childElements = @($node.ChildNodes | Where-Object { $_.NodeType -eq [System.Xml.XmlNodeType]::Element })
            if ($childElements.Count -eq 0) {
                $inner = $node.InnerText
                if ($inner -and $inner.Trim().Length -ge 12 -and $sqlRx.IsMatch($inner)) {
                    # 쿼리 식별자: id/name/key 속성 → 없으면 노드명
                    $qid = $null
                    foreach ($attrName in @('id','name','key','queryId','sqlId','QueryID')) {
                        $a = $node.Attributes
                        if ($a) {
                            $found = $a | Where-Object { $_.Name -ieq $attrName } | Select-Object -First 1
                            if ($found) { $qid = $found.Value; break }
                        }
                    }
                    if (-not $qid) { $qid = $node.Name }
                    [void]$queries.Add(@{ qid = $qid; sql = $inner.Trim(); node = $node.Name })
                }
            } else {
                foreach ($c in $childElements) { $stack.Push($c) }
            }
        }
    } catch {
        $xmlOk = $false
        [void]$parseFail.Add([pscustomobject]@{ file = $rel; reason = $_.Exception.Message })
    }

    if (-not $xmlOk -or $queries.Count -eq 0) {
        # 폴백: CDATA 블록, 그 다음 SQL 키워드로 시작하는 덩어리
        foreach ($m in [regex]::Matches($text, '(?s)<!\[CDATA\[(?<c>.*?)\]\]>')) {
            $c = $m.Groups['c'].Value
            if ($c.Trim().Length -ge 12 -and $sqlRx.IsMatch($c)) {
                [void]$queries.Add(@{ qid = "$foxmlId#cdata$($queries.Count+1)"; sql = $c.Trim(); node = 'CDATA' })
            }
        }
        if ($queries.Count -eq 0 -and $sqlRx.IsMatch($text)) {
            # 태그를 제거한 전체 텍스트를 하나의 쿼리로 취급
            $stripped = [regex]::Replace($text, '<[^>]+>', ' ')
            if ($stripped.Trim().Length -ge 12) {
                [void]$queries.Add(@{ qid = "$foxmlId#raw"; sql = $stripped.Trim(); node = 'RAW' })
            }
        }
    }

    if ($queries.Count -eq 0) {
        [void]$catalog.Add([pscustomobject]@{
            foxml_id   = $foxmlId
            file       = $rel
            query_id   = ''
            sql_kind   = 'NONE'
            params     = ''
            tables     = ''
            sp_refs    = ''
            line_count = 0
            sha256     = $sha
        })
        continue
    }

    [void]$mdBlocks.Add("## $foxmlId")
    [void]$mdBlocks.Add("")
    [void]$mdBlocks.Add("- 파일: ``$rel``")
    [void]$mdBlocks.Add("- 쿼리 수: $($queries.Count)")
    [void]$mdBlocks.Add("")

    foreach ($q in $queries) {
        $sql = [string]$q.sql

        $ps = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
        foreach ($m in $paramRx.Matches($sql)) {
            $v = $m.Groups['p'].Value
            if (-not $v) { $v = $m.Groups['p2'].Value }
            if ($v) { [void]$ps.Add($v) }
        }

        $tbls = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
        foreach ($m in $tableRx.Matches($sql)) {
            $t = ($m.Groups['t'].Value -replace '[\[\]\s]', '')
            if ($t -and $t -notmatch '^\(') { [void]$tbls.Add($t) }
        }

        $sps = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
        foreach ($m in $spRx.Matches($sql)) { [void]$sps.Add($m.Groups['sp'].Value) }

        $lineCount = @($sql -split "`r`n|`n|`r").Count

        [void]$catalog.Add([pscustomobject]@{
            foxml_id   = $foxmlId
            file       = $rel
            query_id   = [string]$q.qid
            sql_kind   = Get-SqlKind -Sql $sql
            params     = (($ps | Sort-Object) -join ';')
            tables     = (($tbls | Sort-Object) -join ';')
            sp_refs    = (($sps | Sort-Object) -join ';')
            line_count = $lineCount
            sha256     = $sha
        })

        $shown = if ($sql.Length -gt $MaxSqlCharsInMd) {
            $sql.Substring(0, $MaxSqlCharsInMd) + "`n-- ... (truncated, 전체는 원본 파일 참조)"
        } else { $sql }

        [void]$mdBlocks.Add("### $($q.qid)  [$(Get-SqlKind -Sql $sql)]")
        [void]$mdBlocks.Add("")
        if ($ps.Count -gt 0)   { [void]$mdBlocks.Add("- params: ``$(($ps   | Sort-Object) -join ', ')``") }
        if ($tbls.Count -gt 0) { [void]$mdBlocks.Add("- tables: ``$(($tbls | Sort-Object) -join ', ')``") }
        if ($sps.Count -gt 0)  { [void]$mdBlocks.Add("- sp: ``$(($sps    | Sort-Object) -join ', ')``") }
        [void]$mdBlocks.Add("")
        [void]$mdBlocks.Add('```sql')
        [void]$mdBlocks.Add($shown)
        [void]$mdBlocks.Add('```')
        [void]$mdBlocks.Add("")
    }
}
$sw.Stop()

Write-Host ("[2/3] 파싱 완료 — 쿼리 {0:N0}건 / {1:N1}s" -f $catalog.Count, $sw.Elapsed.TotalSeconds) -ForegroundColor Yellow

# --- 산출물 ---
Write-AsisCsv -Data $catalog -Path (Join-Path $outDir 'foxml-catalog.csv') `
    -Header @('foxml_id','file','query_id','sql_kind','params','tables','sp_refs','line_count','sha256')

$header = @(
    "# foxml 카탈로그",
    "",
    "- 생성: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "- ROOT: ``$rootFull``",
    "- foxml 파일 $($files.Count)건 / 쿼리 $($catalog.Count)건",
    "",
    "> Claude Code 는 이 파일을 통째로 읽지 마세요. 화면 단위로 screen-inventory.csv 의",
    "> foxml_refs 열에 있는 ID만 찾아서 해당 섹션을 보면 됩니다.",
    "",
    "---",
    ""
)
Write-AsisText -Content (($header + $mdBlocks) -join [Environment]::NewLine) `
    -Path (Join-Path $outDir 'foxml-catalog.md') -Bom

# 02-Scan-Sources 가 소비할 이름 인덱스
$idIndex = @($catalog | Where-Object { $_.foxml_id } | Select-Object -ExpandProperty foxml_id -Unique | Sort-Object)
$qIndex  = @($catalog | Where-Object { $_.query_id } | Select-Object -ExpandProperty query_id -Unique | Sort-Object)
$json = [pscustomobject]@{
    generated = (Get-Date -Format 'o')
    root      = $rootFull
    foxml_ids = $idIndex
    query_ids = $qIndex
} | ConvertTo-Json -Depth 4
Write-AsisText -Content $json -Path (Join-Path $outDir 'foxml-index.json')

if ($parseFail.Count -gt 0) {
    Write-AsisCsv -Data $parseFail -Path (Join-Path $outDir '_probe\foxml-parse-fail.csv') -Header @('file','reason')
    Write-Warning "XML 파싱 실패 $($parseFail.Count)건 — 정규식 폴백으로 처리했습니다. _probe\foxml-parse-fail.csv 확인"
}

Write-Host "[3/3] 완료" -ForegroundColor Green
