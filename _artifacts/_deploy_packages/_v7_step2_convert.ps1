# ============================================================================
# v7 Step 2 — 보수적 SQL 변환 + CREATE PROCEDURE 분리 (inline, no function)
# 작성: 2026-06-04 (재작성 — PowerShell array unwrap 회피 위해 inline 로직)
# ============================================================================

$ErrorActionPreference = 'Continue'

$sqlPlusSafePrefix = '^(WHENEVER|DEFINE|UNDEFINE|SHOW|SPOOL|COLUMN|VARIABLE|ACCEPT|HOST|CLEAR|STORE|TIMING|ATTRIBUTE|AUTOCOMMIT|AUTOTRACE|PROMPT|REMARK|REM|PAUSE|HELP|QUIT|DISCONNECT|PASSWORD|STARTUP|SHUTDOWN|BREAK|BTITLE|TTITLE|COMPUTE|REPHEADER|REPFOOTER|EDIT|SAVE|GET|CHANGE|ARCHIVE|XQUERY)\b'
$createProcRegex = '^\s*CREATE\s+OR\s+REPLACE\s+(EDITIONABLE\s+)?(PROCEDURE|FUNCTION|PACKAGE\s+BODY|PACKAGE|TRIGGER|TYPE)\b'

# Convert function (이전과 동일)
function Convert-Source {
    param([string]$Content)

    $Content = [regex]::Replace($Content, '/\*[\s\S]*?\*/', '')
    $Content = $Content -replace '\)\s+NEW\b', ') SRC'
    $Content = $Content -replace '\bNEW\.', 'SRC.'

    $lines = $Content -split "`r?`n"
    $out = New-Object System.Collections.Generic.List[string]
    $prevBlank = $false
    $inCreateBlock = $false
    $inAnonBlock = $false

    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        $trim = $line.TrimStart()

        if (-not $inCreateBlock -and -not $inAnonBlock -and $line -imatch $createProcRegex) {
            $inCreateBlock = $true
            $out.Add($line)
            continue
        }
        if ($inCreateBlock) {
            if ($trim -eq '/') { $inCreateBlock = $false; continue }
            if ($trim -match '^--') { continue }
            $out.Add($line)
            $prevBlank = $false
            continue
        }
        if ($inAnonBlock) {
            if ($trim -eq '/') { $inAnonBlock = $false; continue }
            if ($trim -match '^END\s*(\w+)?\s*;\s*$') { $inAnonBlock = $false; continue }
            continue
        }

        if ($trim -match '^--') { continue }
        if ($trim -eq '') {
            if ($prevBlank) { continue }
            $prevBlank = $true; $out.Add($line); continue
        }
        $prevBlank = $false
        if ($trim -eq '/') { continue }
        if ($trim -imatch $sqlPlusSafePrefix) { continue }
        if ($trim -match '^@@?[A-Za-z]') { continue }
        if ($trim -match '^&[a-zA-Z_]') { continue }
        if ($line -cmatch '^SET\s+\w+\b' -and $line -notmatch '^SET\s+\w+\s*=') { continue }
        if ($trim -imatch '^EXIT\s*;?\s*$' -or $trim -imatch '^EXIT\s+(SUCCESS|FAILURE|WARNING|COMMIT|ROLLBACK)\b') { continue }
        if ($trim -imatch '^CONNECT\s+\w+/' -and $trim -notmatch 'CONNECT\s+BY\b') { continue }
        if ($line -cmatch '^DECLARE\b' -or $line -cmatch '^BEGIN\s*$') { $inAnonBlock = $true; continue }
        $out.Add($line)
    }
    return ($out -join "`r`n")
}

# ============================================================================
# 처리 (inline split)
# ============================================================================
$root = 'C:\Projects\NSCM\_artifacts\_deploy_packages'
$deployFolders = @('DMF0008_deploy_2026-06-02', 'DMF0043_deploy_2026-06-02', 'DMF0043_01_deploy_2026-06-02', 'DMF0072_deploy_2026-06-02')

$totalFiles = 0
$totalSplitOut = 0

foreach ($df in $deployFolders) {
    Write-Host "`n========== $df ==========" -ForegroundColor Cyan
    $dfPath = Join-Path $root $df
    foreach ($sub in @('02_DB_Meta_SQL', '03_SP_PKG', '04_Verify')) {
        $subPath = Join-Path $dfPath $sub
        if (-not (Test-Path $subPath)) { continue }
        $archivePath = Join-Path $subPath '_sqlplus_originals'
        if (-not (Test-Path $archivePath)) { New-Item -ItemType Directory -Path $archivePath -Force | Out-Null }

        $sourceFiles = Get-ChildItem -Path $subPath -Filter '*.sql' -File `
            | Where-Object { $_.Name -notmatch '_DBeaver\.sql$' -and $_.Name -notmatch '^\d{3}_' } `
            | Sort-Object Name

        $seq = 0
        foreach ($sf in $sourceFiles) {
            $seq += 10
            $content = Get-Content -Path $sf.FullName -Raw -Encoding UTF8
            $converted = Convert-Source -Content $content

            # === INLINE SPLIT logic ===
            $cvLines = $converted -split "`r?`n"
            $procStarts = New-Object System.Collections.Generic.List[int]
            for ($i = 0; $i -lt $cvLines.Length; $i++) {
                if ($cvLines[$i] -imatch $createProcRegex) {
                    $procStarts.Add($i)
                }
            }

            $baseStem = [System.IO.Path]::GetFileNameWithoutExtension($sf.Name)

            if ($procStarts.Count -le 1) {
                # single block
                $outName = ('{0:D3}_{1}.sql' -f $seq, $baseStem)
                $outPath = Join-Path $subPath $outName
                [System.IO.File]::WriteAllText($outPath, $converted, [System.Text.UTF8Encoding]::new($false))
                $totalFiles++
                Write-Host ("  {0,-65} OK ({1} PROC)" -f $outName, $procStarts.Count)
            }
            else {
                # split each PROCEDURE into a separate file
                $blockIdx = 0

                # header (before first PROCEDURE) if non-empty
                if ($procStarts[0] -gt 0) {
                    $headerLines = $cvLines[0..($procStarts[0]-1)]
                    $headerStr = ($headerLines -join "`r`n").Trim()
                    if ($headerStr.Length -gt 0) {
                        $headerName = ('{0:D3}_{1}__00_header.sql' -f ($seq + $blockIdx), $baseStem)
                        $headerPath = Join-Path $subPath $headerName
                        [System.IO.File]::WriteAllText($headerPath, $headerStr + "`r`n", [System.Text.UTF8Encoding]::new($false))
                        $totalFiles++; $totalSplitOut++
                        Write-Host ("  {0,-65} HEADER" -f $headerName) -ForegroundColor DarkGray
                        $blockIdx++
                    }
                }

                for ($p = 0; $p -lt $procStarts.Count; $p++) {
                    $startLine = $procStarts[$p]
                    $endLine = if ($p -lt $procStarts.Count - 1) { $procStarts[$p+1] - 1 } else { $cvLines.Length - 1 }
                    $procLines = $cvLines[$startLine..$endLine]
                    $procContent = ($procLines -join "`r`n").Trim() + "`r`n"

                    # extract PROCEDURE name (schema-qualified 처리)
                    $procName = 'block'
                    if ($cvLines[$startLine] -match 'CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+)?(?:PROCEDURE|FUNCTION|PACKAGE\s+BODY|PACKAGE|TRIGGER|TYPE)\s+(?:["\w]+\s*\.\s*)?"?([A-Za-z_]\w*)"?') {
                        $procName = $matches[1]
                    }

                    $outName = ('{0:D3}_{1}__{2}.sql' -f ($seq + $blockIdx), $baseStem, $procName)
                    $outPath = Join-Path $subPath $outName
                    [System.IO.File]::WriteAllText($outPath, $procContent, [System.Text.UTF8Encoding]::new($false))
                    $totalFiles++; $totalSplitOut++
                    Write-Host ("  {0,-65} SPLIT" -f $outName) -ForegroundColor DarkYellow
                    $blockIdx++
                }

                # next file seq jump
                $seq = $seq + $blockIdx - 1
            }

            $archiveDest = Join-Path $archivePath $sf.Name
            Move-Item -Path $sf.FullName -Destination $archiveDest -Force
        }

        $dbeaverPairs = Get-ChildItem -Path $subPath -Filter '*_DBeaver.sql' -File
        foreach ($db in $dbeaverPairs) {
            $archiveDest = Join-Path $archivePath $db.Name
            Move-Item -Path $db.FullName -Destination $archiveDest -Force
        }
    }
}

Write-Host ("`n=== 변환 완료: {0} files (split out: {1}) ===" -f $totalFiles, $totalSplitOut) -ForegroundColor Green
