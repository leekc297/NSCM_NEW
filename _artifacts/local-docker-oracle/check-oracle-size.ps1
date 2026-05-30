# NSCM Oracle 용량 측정 + 7GB 임계 자동 감시
#
# 사용법:
#   .\check-oracle-size.ps1                  # 일반 측정 + 콘솔 출력
#   .\check-oracle-size.ps1 -Quiet           # CRIT 시에만 출력
#   .\check-oracle-size.ps1 -Threshold 7.0   # 임계 조정 (기본 7.0 GB)
#   .\check-oracle-size.ps1 -Json            # JSON 출력
#
# Exit codes:
#   0 = SAFE / WARN
#   7 = CRIT (7GB 이상 — bulk_load_csv 자동 중단 트리거)
#   2 = sqlplus 실행 실패 / 컨테이너 미가동

[CmdletBinding()]
param(
  [double]$Threshold = 7.0,
  [double]$WarnThreshold = 6.0,
  [switch]$Quiet,
  [switch]$Json,
  [string]$Container = "nscm-oracle",
  [string]$SysPassword = "!SCMroqkf2026",
  [string]$Pdb = "FREEPDB1"
)

$ErrorActionPreference = "Continue"
$ScriptDir = $PSScriptRoot
$SqlFile   = "$ScriptDir\check-oracle-size.sql"

# ----- 1. 컨테이너 살아있는지 -----
$state = & docker inspect --format='{{.State.Status}}' $Container 2>$null
if ($state -ne "running") {
  if (-not $Quiet) {
    Write-Host "ERROR: $Container 컨테이너가 running 상태가 아님 (현재: $state)" -ForegroundColor Red
  }
  exit 2
}

# ----- 2. SQL 실행 -----
# /artifacts mount 이용 (docker-compose.yml 의 . :/artifacts)
$sqlInContainer = "/artifacts/check-oracle-size.sql"
$sqlplusCmd = "sqlplus -s sys/'$SysPassword'@//localhost:1521/$Pdb as sysdba @$sqlInContainer"
$raw = & docker exec $Container bash -c $sqlplusCmd 2>&1
if ($LASTEXITCODE -ne 0) {
  if (-not $Quiet) {
    Write-Host "ERROR: sqlplus exit=$LASTEXITCODE" -ForegroundColor Red
    Write-Host $raw
  }
  exit 2
}

# ----- 3. 결과 파싱 -----
$totalUserGb = -1.0
$tablespaces = @()
$topSegments = @()
foreach ($line in $raw) {
  $l = "$line".Trim()
  if ($l -match '^TOTAL_USER_GB:([0-9.]+)') {
    $totalUserGb = [double]$matches[1]
  } elseif ($l -match '^TS:([^:]+):([0-9.]+)') {
    $tablespaces += [pscustomobject]@{ name=$matches[1]; gb=[double]$matches[2] }
  } elseif ($l -match '^TOP:([^:]+):([^:]+):([0-9]+)MB') {
    $topSegments += [pscustomobject]@{ name=$matches[1]; type=$matches[2]; mb=[int]$matches[3] }
  }
}

if ($totalUserGb -lt 0) {
  if (-not $Quiet) {
    Write-Host "ERROR: TOTAL_USER_GB 파싱 실패. raw 출력:" -ForegroundColor Red
    $raw | ForEach-Object { Write-Host "  $_" }
  }
  exit 2
}

# ----- 4. 임계 판정 -----
$level = "SAFE"
$exitCode = 0
if ($totalUserGb -ge $Threshold) {
  $level = "CRIT"
  $exitCode = 7
} elseif ($totalUserGb -ge $WarnThreshold) {
  $level = "WARN"
}

# ----- 5. 출력 -----
if ($Json) {
  $obj = [pscustomobject]@{
    level = $level
    totalUserGb = $totalUserGb
    threshold = $Threshold
    warnThreshold = $WarnThreshold
    tablespaces = $tablespaces
    topSegments = $topSegments
    checkedAt = (Get-Date).ToString("o")
  }
  $obj | ConvertTo-Json -Depth 4
  exit $exitCode
}

if ($Quiet -and $level -ne "CRIT") {
  # Quiet 모드: SAFE/WARN 시 단순 1줄
  Write-Host ("{0}: {1} GB" -f $level, $totalUserGb)
  exit $exitCode
}

# Verbose 출력
$color = @{ SAFE="Green"; WARN="Yellow"; CRIT="Red" }[$level]
Write-Host ""
Write-Host "========================================" -ForegroundColor $color
if ($level -eq "CRIT") {
  Write-Host "@@ALERT@@ Oracle 안전 임계 (${Threshold}GB) 초과" -ForegroundColor $color
} elseif ($level -eq "WARN") {
  Write-Host "WARN: Oracle 사용량 안전 임계 (${Threshold}GB) 근접" -ForegroundColor $color
} else {
  Write-Host "OK: Oracle 사용량 안전 범위" -ForegroundColor $color
}
Write-Host "========================================" -ForegroundColor $color

Write-Host ("현재 user_data 사용량: {0,6:N2} GB / 12.00 GB (Free Edition 한도)" -f $totalUserGb)
Write-Host ("안전 임계 (CRIT):     {0,6:N2} GB" -f $Threshold)
Write-Host ("경고 임계 (WARN):     {0,6:N2} GB" -f $WarnThreshold)
Write-Host ("측정 시각:           {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

if ($tablespaces.Count -gt 0) {
  Write-Host ""
  Write-Host "[Tablespace 분포]"
  $tablespaces | Sort-Object gb -Descending | ForEach-Object {
    Write-Host ("  {0,-30} {1,6:N2} GB" -f $_.name, $_.gb)
  }
}

if ($topSegments.Count -gt 0) {
  Write-Host ""
  Write-Host "[Top 15 큰 세그먼트]"
  $i = 0
  foreach ($s in $topSegments) {
    $i++
    Write-Host ("  {0,2}. {1,-50} {2,-10} {3,6:N0} MB" -f $i, $s.name, $s.type, $s.mb)
  }
}

if ($level -eq "CRIT") {
  Write-Host ""
  Write-Host "[권장 조치 (자동 정리 안 함 — 사용자 결정)]" -ForegroundColor Red
  Write-Host "  (1) 불필요한 DM_* 데이터 정리:"
  Write-Host "      DELETE FROM SCM_MGR.<TABLE_NAME> WHERE DIVISION NOT IN ('40','81');"
  Write-Host "  (2) 인덱스 재구성:"
  Write-Host "      ALTER INDEX <INDEX_NAME> REBUILD;"
  Write-Host "  (3) 휴지통 비우기:"
  Write-Host "      PURGE RECYCLEBIN;"
  Write-Host "  (4) 그래도 안 되면 컨테이너 재구축:"
  Write-Host "      cd C:\Projects\NSCM\_artifacts\local-docker-oracle"
  Write-Host "      docker compose down -v ; docker compose up -d"
  Write-Host "      # 그 다음 DDL/CSV 재적재 (룰 29 §6 reset sequence)"
  Write-Host ""
  Write-Host "[CSV 적재 중이었다면]"
  Write-Host "  -> bulk_load_csv.ps1 가 이 시점부터 중단됨"
  Write-Host "  -> 정리 후 재실행: .\bulk_load_csv.ps1 -Resume"
}

exit $exitCode
