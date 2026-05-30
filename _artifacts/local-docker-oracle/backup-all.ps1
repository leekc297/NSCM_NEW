# NSCM 풀스택 통합 백업
#   - 소스 git bundle (전체 히스토리)
#   - FE node_modules + .local-packs (junction 보존 tar)
#   - FE/BE config-local
#   - Docker Oracle (expdp FULL=Y Data Pump)
#   - manifest.json + git-head.txt + git-dirty.txt
#
# 사용법:
#   .\backup-all.ps1                                    # 수동 (manual\YYYY-MM-DD_HHMM\)
#   .\backup-all.ps1 -Label pre-major-refactor          # manual\YYYY-MM-DD_HHMM_pre-major-refactor\
#   .\backup-all.ps1 -ScheduledMode                     # Task Scheduler 야간 (daily\YYYY-MM-DD_0200\)
#   .\backup-all.ps1 -SkipFeTar                         # FE node_modules 생략 (테스트용)
#   .\backup-all.ps1 -SkipOracleDmp                     # Oracle dmp 생략 (테스트용)
#
# 보존:
#   - daily: 최근 7개 + 30일 초과 자동 삭제
#   - manual: 30일 초과 자동 삭제

[CmdletBinding()]
param(
  [string]$BackupRoot = "D:\NSCM_backup",
  [switch]$ScheduledMode,
  [string]$Label = "",
  [switch]$SkipSource,
  [switch]$SkipFeTar,
  [switch]$SkipBeConfig,
  [switch]$SkipOracleDmp,
  [int]$DailyKeep = 7,
  [int]$ManualKeepDays = 30,
  [int]$MinFreeGb = 10,
  [string]$Container = "nscm-oracle",
  [string]$SysPassword = "!SCMroqkf2026",
  [string]$Pdb = "FREEPDB1"
)

$ErrorActionPreference = "Continue"  # PS5.1 native exe stderr ErrorRecord wrap 회피
$RepoRoot = "C:\Projects\NSCM"
$FeRoot   = "$RepoRoot\nscm-fe"
$BeRoot   = "$RepoRoot\nscm-be"

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg"  -ForegroundColor Red }

function Get-Bytes($path) {
  if (-not (Test-Path $path)) { return 0 }
  $item = Get-Item $path
  if ($item.PSIsContainer) {
    return (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
  } else {
    return $item.Length
  }
}

# ----- 0. PRE-CHECK -----
Write-Step "0. PRE-CHECK"

# 0.1 D 드라이브
if (-not (Test-Path "D:\")) {
  Write-Fail "D:\ 드라이브 부재. 백업 중단."
  if ($ScheduledMode) {
    # Scheduled mode 에서는 에러 로그만 남기고 exit
    $errLog = "C:\Users\$env:USERNAME\AppData\Local\Temp\nscm-backup-error.log"
    "$([DateTime]::Now) D 드라이브 부재" | Add-Content $errLog -Encoding utf8
  }
  exit 1
}

# 0.2 D 드라이브 free space
$dVol = Get-Volume D -ErrorAction SilentlyContinue
if ($dVol) {
  $freeGb = [math]::Round($dVol.SizeRemaining / 1GB, 2)
  Write-OK "D 드라이브 free: $freeGb GB"
  if ($freeGb -lt $MinFreeGb) {
    Write-Warn2 "Free $freeGb GB < $MinFreeGb GB — 오래된 daily 정리 시도"
    $dailyDir = "$BackupRoot\daily"
    if (Test-Path $dailyDir) {
      Get-ChildItem $dailyDir -Directory | Sort-Object Name | Select-Object -SkipLast 1 | Select-Object -First 1 | ForEach-Object {
        Write-Warn2 "삭제: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force
      }
    }
  }
} else {
  Write-Warn2 "Get-Volume D 실패 — free space 측정 생략"
}

# 0.3 Docker container 확인
if (-not $SkipOracleDmp) {
  $state = & docker inspect --format='{{.State.Status}}' $Container 2>$null
  if ($state -ne "running") {
    Write-Fail "$Container 미가동 (현재: $state) — Oracle dmp 백업 불가"
    Write-Host "    .\start-all.ps1 로 기동 후 재시도하거나, -SkipOracleDmp 로 우회" -ForegroundColor Yellow
    exit 1
  }
  $health = & docker inspect --format='{{.State.Health.Status}}' $Container 2>$null
  if ($health -ne "healthy") {
    Write-Warn2 "$Container healthcheck = $health (running 이지만 healthy 아님)"
  }
  Write-OK "$Container running ($health)"
}

# ----- 1. 백업 디렉토리 결정 -----
Write-Step "1. 백업 디렉토리"
$ts = Get-Date -Format "yyyy-MM-dd_HHmm"
if ($ScheduledMode) {
  $TargetDir = "$BackupRoot\daily\$ts"
  $source = "scheduled"
} elseif ($Label) {
  $safeLabel = $Label -replace '[^A-Za-z0-9._-]','_'
  $TargetDir = "$BackupRoot\manual\${ts}_$safeLabel"
  $source = "manual"
} else {
  $TargetDir = "$BackupRoot\manual\$ts"
  $source = "manual"
}

New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
New-Item -ItemType Directory -Path "$TargetDir\fe-config" -Force | Out-Null
New-Item -ItemType Directory -Path "$TargetDir\be-config" -Force | Out-Null
Write-OK "Target: $TargetDir"

$swTotal = [System.Diagnostics.Stopwatch]::StartNew()
$manifest = [ordered]@{
  createdAt = (Get-Date).ToString("o")
  source = $source
  label = $Label
  targetDir = $TargetDir
  components = [ordered]@{}
}

# ----- 2. SOURCE BACKUP -----
if (-not $SkipSource) {
  Write-Step "2. SOURCE (git bundle)"
  Push-Location $RepoRoot
  try {
    $bundlePath = "$TargetDir\source.bundle"
    & git bundle create $bundlePath --all *> $null
    if ($LASTEXITCODE -ne 0) {
      Write-Fail "git bundle 생성 실패"
    } else {
      & git rev-parse HEAD | Set-Content "$TargetDir\git-head.txt" -Encoding utf8
      & git status -s | Set-Content "$TargetDir\git-dirty.txt" -Encoding utf8
      $dirtyCount = (Get-Content "$TargetDir\git-dirty.txt" -ErrorAction SilentlyContinue | Measure-Object).Count
      $bytes = Get-Bytes $bundlePath
      $manifest.components.source = [ordered]@{
        bundlePath = "source.bundle"
        bundleBytes = $bytes
        gitHead = (Get-Content "$TargetDir\git-head.txt" -ErrorAction SilentlyContinue | Select-Object -First 1)
        gitDirtyCount = $dirtyCount
      }
      Write-OK ("source.bundle {0:N0} MB / dirty {1}" -f ($bytes/1MB), $dirtyCount)
    }
  } finally {
    Pop-Location
  }
} else {
  Write-Step "2. SOURCE (SKIP)"
}

# ----- 3. FE BACKUP -----
Write-Step "3. FE (node_modules + .local-packs + config)"

# 3.1 node_modules + .local-packs tar (junction 보존: -h 사용 안 함, symlink 그대로)
if (-not $SkipFeTar) {
  $tarPath = "$TargetDir\fe-node-modules.tar"
  $tarExe = "C:\Windows\System32\tar.exe"
  if (-not (Test-Path $tarExe)) {
    Write-Warn2 "tar.exe 미발견 — Compress-Archive 로 대체 (junction 손실 가능)"
    Compress-Archive -Path "$FeRoot\node_modules","$FeRoot\.local-packs" -DestinationPath "$TargetDir\fe-node-modules.zip" -Force
    $bytes = Get-Bytes "$TargetDir\fe-node-modules.zip"
  } else {
    Push-Location $FeRoot
    try {
      $arg = @("-cf",$tarPath,"node_modules",".local-packs")
      & $tarExe $arg *> $null
      if ($LASTEXITCODE -ne 0) {
        Write-Warn2 "tar exit=$LASTEXITCODE (junction 일부 실패 가능)"
      }
    } finally {
      Pop-Location
    }
    $bytes = Get-Bytes $tarPath
  }
  $manifest.components.feNodeModules = [ordered]@{
    tarPath = "fe-node-modules.tar"
    tarBytes = $bytes
  }
  Write-OK ("fe-node-modules.tar {0:N0} MB" -f ($bytes/1MB))
} else {
  Write-Step "3.1 FE node_modules (SKIP)"
}

# 3.2 FE config
if (Test-Path "$FeRoot\apps\web\.env.local") {
  Copy-Item "$FeRoot\apps\web\.env.local" "$TargetDir\fe-config\.env.local" -Force
}
if (Test-Path "$FeRoot\pnpm-lock.yaml") {
  Copy-Item "$FeRoot\pnpm-lock.yaml" "$TargetDir\fe-config\pnpm-lock.yaml" -Force
}
if (Test-Path "$FeRoot\.npmrc") {
  Copy-Item "$FeRoot\.npmrc" "$TargetDir\fe-config\.npmrc" -Force
}
$manifest.components.feConfig = [ordered]@{
  files = @(Get-ChildItem "$TargetDir\fe-config" -File | ForEach-Object { $_.Name })
}
Write-OK "fe-config 복사 ($($manifest.components.feConfig.files.Count) files)"

# ----- 4. BE BACKUP -----
if (-not $SkipBeConfig) {
  Write-Step "4. BE config"
  $beConfig = "$BeRoot\src\main\resources\config\config-local.yml"
  $beApp    = "$BeRoot\src\main\resources\application.yml"
  if (Test-Path $beConfig) { Copy-Item $beConfig "$TargetDir\be-config\config-local.yml" -Force }
  if (Test-Path $beApp)    { Copy-Item $beApp    "$TargetDir\be-config\application.yml" -Force }
  $manifest.components.beConfig = [ordered]@{
    files = @(Get-ChildItem "$TargetDir\be-config" -File | ForEach-Object { $_.Name })
  }
  Write-OK "be-config 복사 ($($manifest.components.beConfig.files.Count) files)"
} else {
  Write-Step "4. BE config (SKIP)"
}

# ----- 5. ORACLE DATA PUMP -----
if (-not $SkipOracleDmp) {
  Write-Step "5. ORACLE (expdp FULL)"
  $swOra = [System.Diagnostics.Stopwatch]::StartNew()

  # 5.1 DIRECTORY 객체 생성
  $createDirSql = @"
SET FEEDBACK OFF
WHENEVER SQLERROR EXIT FAILURE
CREATE OR REPLACE DIRECTORY BACKUP_DP AS '/opt/oracle/dpdump_backup';
GRANT READ, WRITE ON DIRECTORY BACKUP_DP TO SYSTEM;
EXIT;
"@
  $createDirSql | & docker exec -i $Container bash -c "sqlplus -s sys/'$SysPassword'@//localhost:1521/$Pdb as sysdba" *> $null
  & docker exec $Container bash -c "mkdir -p /opt/oracle/dpdump_backup && rm -f /opt/oracle/dpdump_backup/oracle-full.*" *> $null

  # 5.2 expdp FULL
  $dumpName = "oracle-full"
  # Oracle Free Edition 은 COMPRESSION=ALL 미지원 (ORA-00439). 미사용.
  $expdpCmd = "expdp system/'$SysPassword'@//localhost:1521/$Pdb DIRECTORY=BACKUP_DP DUMPFILE=$dumpName.dmp LOGFILE=$dumpName.log FULL=Y EXCLUDE=STATISTICS"
  Write-Host "    expdp 실행 중 (수십 분 소요 가능)..."
  & docker exec $Container bash -c $expdpCmd *> $null
  $expdpExit = $LASTEXITCODE

  # 5.3 호스트로 복사
  & docker cp "${Container}:/opt/oracle/dpdump_backup/$dumpName.dmp" "$TargetDir\$dumpName.dmp" *> $null
  & docker cp "${Container}:/opt/oracle/dpdump_backup/$dumpName.log" "$TargetDir\$dumpName.log" *> $null
  & docker exec $Container bash -c "rm -rf /opt/oracle/dpdump_backup" *> $null

  $logContent = Get-Content "$TargetDir\$dumpName.log" -ErrorAction SilentlyContinue -Raw
  $expdpOk = ($logContent -and $logContent -match 'successfully completed')
  $dmpBytes = Get-Bytes "$TargetDir\$dumpName.dmp"

  $manifest.components.oracleDmp = [ordered]@{
    dumpPath = "$dumpName.dmp"
    logPath = "$dumpName.log"
    dumpBytes = $dmpBytes
    expdpExit = $expdpExit
    successFlag = $expdpOk
    elapsedSec = [int]$swOra.Elapsed.TotalSeconds
  }
  if ($expdpOk) {
    Write-OK ("expdp OK {0:N0} MB ({1:N0}초)" -f ($dmpBytes/1MB), $swOra.Elapsed.TotalSeconds)
  } else {
    Write-Fail "expdp 실패 — log 확인: $TargetDir\$dumpName.log"
  }
} else {
  Write-Step "5. ORACLE (SKIP)"
}

# ----- 6. MANIFEST -----
Write-Step "6. MANIFEST + RETENTION"
$totalBytes = (Get-ChildItem $TargetDir -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
$manifest.totalBytes = $totalBytes
$manifest.totalMb = [math]::Round($totalBytes/1MB, 0)
$manifest.elapsedSec = [int]$swTotal.Elapsed.TotalSeconds
$manifest | ConvertTo-Json -Depth 5 | Set-Content "$TargetDir\manifest.json" -Encoding utf8
Write-OK ("manifest.json 작성 (total {0:N0} MB / {1:N0}초)" -f ($totalBytes/1MB), $swTotal.Elapsed.TotalSeconds)

# Retention
$retentionLog = "$BackupRoot\retention.log"
$dailyDir = "$BackupRoot\daily"
if (Test-Path $dailyDir) {
  $dailyDirs = Get-ChildItem $dailyDir -Directory | Sort-Object Name
  if ($dailyDirs.Count -gt $DailyKeep) {
    $deleteCount = $dailyDirs.Count - $DailyKeep
    foreach ($d in ($dailyDirs | Select-Object -First $deleteCount)) {
      Remove-Item $d.FullName -Recurse -Force
      "$([DateTime]::Now.ToString('o')) DELETE daily $($d.Name)" | Add-Content $retentionLog -Encoding utf8
      Write-Warn2 "retention: daily $($d.Name) 삭제"
    }
  }
}
$manualDir = "$BackupRoot\manual"
if (Test-Path $manualDir) {
  $cutoff = (Get-Date).AddDays(-$ManualKeepDays)
  Get-ChildItem $manualDir -Directory | Where-Object { $_.CreationTime -lt $cutoff } | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force
    "$([DateTime]::Now.ToString('o')) DELETE manual $($_.Name) (older than $ManualKeepDays days)" | Add-Content $retentionLog -Encoding utf8
    Write-Warn2 "retention: manual $($_.Name) 삭제 (30일 초과)"
  }
}

Write-Host ""
Write-Host ("BACKUP DONE: {0}" -f $TargetDir) -ForegroundColor Green
Write-Host ("  total: {0:N0} MB / {1:N0}초" -f ($totalBytes/1MB), $swTotal.Elapsed.TotalSeconds)

exit 0
