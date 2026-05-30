# Bulk CSV → Oracle import via sqlldr
# Reads C:\TRANFILE\DB\*.csv (already copied to container /tmp/csv)
# Generates per-table .ctl using SCM_MGR column metadata
# Skips DM_* files (user excluded)
#
# 2026-05-30 보강:
#   - 5개 테이블 적재마다 check-oracle-size.ps1 호출 → 7GB CRIT 시 자동 중단
#   - 중단 시 남은 CSV 목록을 bulk_load_csv.resume.txt 에 보존
#   - -Resume 으로 재개 가능
#   - -SizeCheckEvery 로 측정 주기 조정 (기본 5)
#   - -SizeThresholdGb 로 임계 조정 (기본 7.0)
#   - -DisableSizeCheck 로 측정 비활성 (테스트용)

param(
  [string]$Schema = "SCM_MGR",
  [string]$Password = "!SCMroqkf2026",
  [string]$Pdb = "FREEPDB1",
  [string]$Container = "nscm-oracle",
  [string]$ColumnsTsv = "C:\Projects\NSCM\_artifacts\local-docker-oracle\scm_mgr_columns.tsv",
  [string]$CtlOutDir = "C:\Projects\NSCM\_artifacts\local-docker-oracle\ctl",
  [string]$LogOutFile = "C:\Projects\NSCM\_artifacts\local-docker-oracle\bulk_load_csv.log",
  [string[]]$Only = @(),                                 # optional: limit to specific table names
  [int]$SizeCheckEvery = 5,                              # check size every N tables
  [double]$SizeThresholdGb = 7.0,                        # CRIT threshold (Oracle Free 12GB 한도 대비)
  [switch]$DisableSizeCheck,
  [switch]$Resume,                                       # resume from bulk_load_csv.resume.txt
  [string]$ResumeFile = "C:\Projects\NSCM\_artifacts\local-docker-oracle\bulk_load_csv.resume.txt"
)

$ErrorActionPreference = "Continue"
$env:MSYS_NO_PATHCONV = "1"

if (-not (Test-Path $CtlOutDir)) { New-Item -ItemType Directory -Path $CtlOutDir -Force | Out-Null }

# ----- Step 1. Parse column metadata -----
Write-Output "Step 1: Parse column metadata..."
$cols = @{}
Get-Content $ColumnsTsv -Encoding utf8 | ForEach-Object {
  $line = $_.Trim()
  # Type may contain "(6)" e.g. TIMESTAMP(6) — match anything until end
  if ($line -match "^([A-Z0-9_]+)`t(\d+)`t([A-Z0-9_]+)`t(.+)$") {
    $t = $matches[1]; $cid = [int]$matches[2]; $cn = $matches[3]; $dt = $matches[4].Trim()
    # Strip "(N)" / "(N,M)" precision/scale suffix for type comparison
    $dtBase = $dt -replace '\(.+?\)$',''
    if (-not $cols.ContainsKey($t)) { $cols[$t] = @() }
    $cols[$t] += [pscustomobject]@{ id=$cid; name=$cn; type=$dtBase }
  }
}
Write-Output "  Tables parsed: $($cols.Count)"

# ----- Step 2. List target CSVs in container -----
Write-Output "Step 2: List target CSVs..."
if ($Resume) {
  if (-not (Test-Path $ResumeFile)) {
    Write-Output "  -Resume 지정됐으나 ResumeFile 없음: $ResumeFile -- 전체 목록으로 진행"
    $csvList = docker exec $Container bash -c "ls /tmp/csv | grep -v '^DM_'" 2>&1 | Where-Object { $_ -like "*.csv" }
  } else {
    $csvList = Get-Content $ResumeFile -Encoding utf8 | Where-Object { $_ -and $_ -like "*.csv" }
    Write-Output "  Resume 모드 — ResumeFile 에서 $($csvList.Count) 건 로드"
  }
} else {
  $csvList = docker exec $Container bash -c "ls /tmp/csv | grep -v '^DM_'" 2>&1 | Where-Object { $_ -like "*.csv" }
}
Write-Output "  CSVs: $($csvList.Count)"

# ----- Step 3. Map CSV → table -----
function Get-TableName($csvName) {
  # Remove timestamp suffix _NNNNNNNNNNNN (12 digits) before .csv
  $t = $csvName -replace '_\d{12}\.csv$', ''
  $t = $t -replace '\.csv$', ''
  # FP_MGR.* CSVs are not in SCM_MGR schema
  return $t.ToUpper()
}

# ----- Step 4. Generate ctl + sqlldr for each table -----
$summary = @()
$processed = 0
$total = $csvList.Count
foreach ($csv in $csvList) {
  $processed++
  $table = Get-TableName $csv
  # FP_MGR not loaded here
  if ($csv -like "FP_MGR.*") {
    $summary += [pscustomobject]@{ csv=$csv; table=$table; status='SKIP_FP_MGR'; rows=0 }
    continue
  }
  if (-not $cols.ContainsKey($table)) {
    $summary += [pscustomobject]@{ csv=$csv; table=$table; status='TABLE_MISSING'; rows=0 }
    continue
  }
  if ($Only.Count -gt 0 -and ($Only -notcontains $table)) {
    $summary += [pscustomobject]@{ csv=$csv; table=$table; status='SKIP_FILTER'; rows=0 }
    continue
  }

  # Build ctl column defs
  # Last column gets a CR-strip wrapper because Windows CSVs end lines with \r\n
  # and sqlldr captures the trailing \r into the last field's value.
  $colMeta = $cols[$table] | Sort-Object id
  $colDefs = @()
  $lastIdx = $colMeta.Count - 1
  for ($i = 0; $i -lt $colMeta.Count; $i++) {
    $c = $colMeta[$i]
    $isLast = ($i -eq $lastIdx)
    # Always quote column name in field-list to safely handle reserved words
    # (LEVEL, DATE, etc.) and names starting with a digit (e.g. 2LEVEL_DEPT_ID).
    # Bind reference inside SQL expression must stay unquoted (sqlldr requirement),
    # and sqlldr matches bind names to field-list names case-insensitively.
    $qname = "`"$($c.name)`""
    $bind = ":$($c.name)"
    $expr = $bind
    if ($isLast) { $expr = "REPLACE($bind, CHR(13), '')" }
    if ($c.type -eq 'DATE') {
      $colDefs += "  $qname `"to_date(SUBSTR($expr,1,19),'YYYY-MM-DD HH24:MI:SS')`""
    } elseif ($c.type -eq 'TIMESTAMP') {
      $colDefs += "  $qname `"to_timestamp($expr,'YYYY-MM-DD HH24:MI:SS.FF3')`""
    } elseif ($c.type -eq 'CLOB' -or $c.type -eq 'BLOB') {
      if ($isLast) {
        $colDefs += "  $qname CHAR(1000000) `"REPLACE($bind, CHR(13), '')`""
      } else {
        $colDefs += "  $qname CHAR(1000000)"
      }
    } else {
      if ($isLast) {
        $colDefs += "  $qname CHAR(4000) `"REPLACE($bind, CHR(13), '')`""
      } else {
        $colDefs += "  $qname CHAR(4000)"
      }
    }
  }
  $colDefStr = $colDefs -join ",`r`n"

  $ctl = @"
OPTIONS (SKIP=1, ERRORS=1000, READSIZE=20971520, BINDSIZE=20971520)
LOAD DATA
CHARACTERSET AL32UTF8
INFILE '/tmp/csv/$csv'
APPEND
INTO TABLE $Schema.$table
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
$colDefStr
)
"@
  $ctlPath = Join-Path $CtlOutDir "$table.ctl"
  $ctl | Out-File -FilePath $ctlPath -Encoding ascii

  # Copy ctl to container
  docker cp $ctlPath "${Container}:/tmp/csv/$table.ctl" 2>$null | Out-Null

  # Run sqlldr
  $logFile = "$table.log"
  $badFile = "$table.bad"
  Write-Output ("[{0}/{1}] {2}" -f $processed, $total, $table)
  $out = docker exec $Container bash -c "cd /tmp/csv && sqlldr '$Schema/$Password@//localhost:1521/$Pdb' control=$table.ctl log=$logFile bad=$badFile silent=feedback 2>&1" 2>&1
  $exit = $LASTEXITCODE

  # Parse rows loaded from log
  $logOutput = docker exec $Container bash -c "cat /tmp/csv/$logFile 2>/dev/null" 2>&1
  $rowsLoaded = 0
  $rowsRejected = 0
  if ($logOutput -match 'Total logical records read:\s+(\d+)') { }
  if ($logOutput -match '(\d+)\s+Rows successfully loaded\.') { $rowsLoaded = [int]$matches[1] }
  if ($logOutput -match '(\d+)\s+Rows not loaded due to data errors\.') { $rowsRejected = [int]$matches[1] }

  $status = if ($exit -eq 0 -and $rowsRejected -eq 0) { 'OK' } elseif ($exit -eq 0 -and $rowsRejected -gt 0) { 'OK_WITH_REJECTS' } else { "FAIL_$exit" }
  $summary += [pscustomobject]@{ csv=$csv; table=$table; status=$status; rows=$rowsLoaded; rejected=$rowsRejected }

  # ----- Size check (every N tables) -----
  if (-not $DisableSizeCheck -and ($processed % $SizeCheckEvery -eq 0)) {
    $checkScript = Join-Path $PSScriptRoot "check-oracle-size.ps1"
    if (Test-Path $checkScript) {
      & $checkScript -Quiet -Threshold $SizeThresholdGb -Container $Container -SysPassword $Password -Pdb $Pdb
      $checkExit = $LASTEXITCODE
      if ($checkExit -eq 7) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Red
        Write-Host "@@ABORT@@ ${SizeThresholdGb}GB 임계 도달. bulk_load_csv 중단." -ForegroundColor Red
        Write-Host "========================================" -ForegroundColor Red
        $remaining = $csvList | Select-Object -Skip $processed
        $remaining | Set-Content $ResumeFile -Encoding utf8
        Write-Host "남은 $($remaining.Count) 건을 ResumeFile 에 저장: $ResumeFile" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "[재개 방법]"
        Write-Host "  1) check-oracle-size.ps1 실행 -> Top 세그먼트 확인"
        Write-Host "  2) 정리 (DELETE / PURGE / 컨테이너 재구축)"
        Write-Host "  3) .\bulk_load_csv.ps1 -Resume"
        break
      }
    } else {
      Write-Output "  (size check skip — check-oracle-size.ps1 미발견)"
    }
  }
}

# Resume 완료 시 ResumeFile 정리
if ($Resume -and (Test-Path $ResumeFile) -and ($processed -ge $csvList.Count)) {
  Remove-Item $ResumeFile -Force
  Write-Output "Resume 완료 — ResumeFile 삭제"
}

# ----- Step 5. Summary -----
$summary | ConvertTo-Json -Depth 3 | Out-File $LogOutFile -Encoding utf8
Write-Output ""
Write-Output "=== Summary ==="
$summary | Group-Object status | ForEach-Object { "  $($_.Name): $($_.Count) files" }
$totalRows = ($summary | Measure-Object rows -Sum).Sum
$totalRej = ($summary | Measure-Object rejected -Sum).Sum
Write-Output "  Total rows loaded:    $totalRows"
Write-Output "  Total rows rejected:  $totalRej"
Write-Output "  Summary log: $LogOutFile"
