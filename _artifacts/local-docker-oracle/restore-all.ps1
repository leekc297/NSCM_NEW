# NSCM 풀스택 통합 원복
#   - 소스 git fetch/reset (또는 새 워크트리)
#   - FE node_modules tar 풀기
#   - FE/BE config 복원
#   - Docker Oracle volume 재생성 + impdp FULL
#
# 사용법:
#   .\restore-all.ps1 -BackupDir D:\NSCM_backup\daily\2026-05-30_0200
#   .\restore-all.ps1 -BackupDir ... -DryRun        # 실행하지 않고 액션만 출력
#   .\restore-all.ps1 -BackupDir ... -Force         # 사용자 확인 prompt 생략
#   .\restore-all.ps1 -BackupDir ... -SkipSource    # 소스 git reset 생략
#   .\restore-all.ps1 -BackupDir ... -SkipFeTar     # FE tar 추출 생략
#   .\restore-all.ps1 -BackupDir ... -SkipOracleDmp # Oracle impdp 생략

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$BackupDir,
  [switch]$DryRun,
  [switch]$Force,
  [switch]$SkipSource,
  [switch]$SkipFeTar,
  [switch]$SkipBeConfig,
  [switch]$SkipOracleDmp,
  [string]$Container = "nscm-oracle",
  [string]$SysPassword = "!SCMroqkf2026",
  [string]$Pdb = "FREEPDB1"
)

$ErrorActionPreference = "Stop"
$RepoRoot = "C:\Projects\NSCM"
$FeRoot   = "$RepoRoot\nscm-fe"
$BeRoot   = "$RepoRoot\nscm-be"
$DockerDir = "$RepoRoot\_artifacts\local-docker-oracle"

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg"  -ForegroundColor Red }
function Write-DryRun($msg){ Write-Host "  [DRY]  $msg" -ForegroundColor Magenta }

# ----- 0. PRE-CHECK -----
Write-Step "0. PRE-CHECK"
if (-not (Test-Path $BackupDir)) {
  Write-Fail "BackupDir 부재: $BackupDir"
  exit 1
}
$manifestPath = "$BackupDir\manifest.json"
if (-not (Test-Path $manifestPath)) {
  Write-Fail "manifest.json 부재 — 유효한 백업이 아님"
  exit 1
}
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
Write-OK ("manifest 로드 — 작성: {0} / 총 {1:N0} MB / source: {2}" -f $manifest.createdAt, $manifest.totalMb, $manifest.source)

if (-not $Force -and -not $DryRun) {
  Write-Host ""
  Write-Host "!!! WARNING !!!" -ForegroundColor Red
  Write-Host "원복은 다음 작업을 수행합니다:" -ForegroundColor Yellow
  Write-Host "  - 소스 git reset --hard (현재 변경사항 stash 됨)"
  Write-Host "  - FE node_modules 전체 교체"
  Write-Host "  - Oracle PDB 전체 reset (docker compose down -v + impdp)"
  Write-Host "  - BE config-local 덮어쓰기"
  Write-Host ""
  $ans = Read-Host "정말 진행? 'YES' 입력"
  if ($ans -ne "YES") {
    Write-Host "취소" -ForegroundColor Yellow
    exit 0
  }
}

# ----- 1. STOP RUNNING SERVERS -----
Write-Step "1. STOP RUNNING SERVERS"
$stopScript = "$DockerDir\stop-all.ps1"
if (Test-Path $stopScript) {
  if ($DryRun) {
    Write-DryRun "$stopScript -Force -SkipDocker"
  } else {
    & $stopScript -Force -SkipDocker
  }
}

# ----- 2. SOURCE RESTORE -----
if (-not $SkipSource -and (Test-Path "$BackupDir\source.bundle")) {
  Write-Step "2. SOURCE (git bundle)"
  Push-Location $RepoRoot
  try {
    $bundleAbs = (Resolve-Path "$BackupDir\source.bundle").Path
    if ($DryRun) {
      Write-DryRun "git stash push -m 'pre-restore $(Get-Date)'"
      Write-DryRun "git fetch '$bundleAbs' main:restore-tmp"
      Write-DryRun "git reset --hard restore-tmp"
    } else {
      # 변경사항 stash
      $dirty = & git status -s
      if ($dirty) {
        $stashMsg = "pre-restore-$([DateTime]::Now.ToString('yyyyMMdd_HHmm'))"
        & git stash push -u -m $stashMsg 2>&1 | Out-Null
        Write-OK "현재 변경사항 stash: $stashMsg"
      }
      # bundle 에서 fetch
      & git fetch $bundleAbs main:restore-tmp 2>&1 | Out-Null
      if ($LASTEXITCODE -ne 0) {
        # main 이름 아니면 HEAD 추적
        & git fetch $bundleAbs HEAD:restore-tmp 2>&1 | Out-Null
      }
      & git reset --hard restore-tmp 2>&1 | Out-Null
      & git branch -D restore-tmp 2>&1 | Out-Null
      $head = & git rev-parse --short HEAD
      Write-OK "소스 reset 완료. HEAD=$head"
    }
  } finally {
    Pop-Location
  }
} else {
  Write-Step "2. SOURCE (SKIP)"
}

# ----- 3. FE RESTORE -----
if (-not $SkipFeTar) {
  Write-Step "3. FE (node_modules + .local-packs)"
  $tarPath = "$BackupDir\fe-node-modules.tar"
  $zipPath = "$BackupDir\fe-node-modules.zip"
  if (Test-Path $tarPath) {
    if ($DryRun) {
      Write-DryRun "rd /s /q $FeRoot\node_modules $FeRoot\.local-packs"
      Write-DryRun "tar -xf $tarPath -C $FeRoot"
    } else {
      Push-Location $FeRoot
      try {
        if (Test-Path "$FeRoot\node_modules") {
          # junction 들 우선 제거 (rd /s /q junction 안전)
          cmd /c "rd /s /q `"$FeRoot\node_modules`""
        }
        if (Test-Path "$FeRoot\.local-packs") {
          Remove-Item "$FeRoot\.local-packs" -Recurse -Force -ErrorAction SilentlyContinue
        }
        & "C:\Windows\System32\tar.exe" -xf $tarPath -C $FeRoot 2>&1 | Out-Null
        Write-OK "fe-node-modules.tar 풀기 완료"
      } finally {
        Pop-Location
      }
    }
  } elseif (Test-Path $zipPath) {
    if ($DryRun) {
      Write-DryRun "Expand-Archive $zipPath -DestinationPath $FeRoot"
    } else {
      if (Test-Path "$FeRoot\node_modules") { cmd /c "rd /s /q `"$FeRoot\node_modules`"" }
      if (Test-Path "$FeRoot\.local-packs") { Remove-Item "$FeRoot\.local-packs" -Recurse -Force }
      Expand-Archive $zipPath -DestinationPath $FeRoot -Force
      Write-OK "fe-node-modules.zip 풀기 완료"
    }
  } else {
    Write-Warn2 "FE tar/zip 없음 — 생략"
  }

  # FE config
  if (Test-Path "$BackupDir\fe-config") {
    Get-ChildItem "$BackupDir\fe-config" -File | ForEach-Object {
      $dest = switch ($_.Name) {
        ".env.local"     { "$FeRoot\apps\web\.env.local" }
        "pnpm-lock.yaml" { "$FeRoot\pnpm-lock.yaml" }
        ".npmrc"         { "$FeRoot\.npmrc" }
        default          { "$FeRoot\$($_.Name)" }
      }
      if ($DryRun) {
        Write-DryRun "Copy $($_.FullName) -> $dest"
      } else {
        Copy-Item $_.FullName $dest -Force
      }
    }
    Write-OK "fe-config 복원"
  }
} else {
  Write-Step "3. FE (SKIP)"
}

# ----- 4. BE RESTORE -----
if (-not $SkipBeConfig -and (Test-Path "$BackupDir\be-config")) {
  Write-Step "4. BE config"
  Get-ChildItem "$BackupDir\be-config" -File | ForEach-Object {
    $dest = switch ($_.Name) {
      "config-local.yml" { "$BeRoot\src\main\resources\config\config-local.yml" }
      "application.yml"  { "$BeRoot\src\main\resources\application.yml" }
      default            { "$BeRoot\src\main\resources\$($_.Name)" }
    }
    if ($DryRun) {
      Write-DryRun "Copy $($_.FullName) -> $dest"
    } else {
      Copy-Item $_.FullName $dest -Force
    }
  }
  Write-OK "be-config 복원"
} else {
  Write-Step "4. BE config (SKIP)"
}

# ----- 5. ORACLE RESTORE (volume reset + impdp) -----
if (-not $SkipOracleDmp -and (Test-Path "$BackupDir\oracle-full.dmp")) {
  Write-Step "5. ORACLE (volume reset + impdp)"
  Push-Location $DockerDir
  try {
    if ($DryRun) {
      Write-DryRun "docker compose down -v"
      Write-DryRun "docker compose up -d"
      Write-DryRun "docker cp $BackupDir\oracle-full.dmp ${Container}:/opt/oracle/dpdump_backup/"
      Write-DryRun "docker exec $Container impdp ... FULL=Y"
    } else {
      Write-Host "    5.1 docker compose down -v (volume 삭제)" -ForegroundColor Yellow
      & docker compose down -v 2>&1 | Out-Null

      Write-Host "    5.2 docker compose up -d + healthcheck 대기"
      & docker compose up -d 2>&1 | Out-Null

      $sw = [System.Diagnostics.Stopwatch]::StartNew()
      while ($sw.Elapsed.TotalSeconds -lt 600) {
        $h = & docker inspect --format='{{.State.Health.Status}}' $Container 2>$null
        if ($h -eq "healthy") { break }
        Start-Sleep -Seconds 5
      }
      Write-OK ("Oracle healthy ({0:N0}초)" -f $sw.Elapsed.TotalSeconds)

      Write-Host "    5.3 DIRECTORY 객체 생성 + dmp 복사"
      $createDirSql = @"
SET FEEDBACK OFF
CREATE OR REPLACE DIRECTORY BACKUP_DP AS '/opt/oracle/dpdump_backup';
GRANT READ, WRITE ON DIRECTORY BACKUP_DP TO SYSTEM;
EXIT;
"@
      & docker exec $Container bash -c "mkdir -p /opt/oracle/dpdump_backup" 2>&1 | Out-Null
      $createDirSql | & docker exec -i $Container bash -c "sqlplus -s sys/'$SysPassword'@//localhost:1521/$Pdb as sysdba" 2>&1 | Out-Null
      & docker cp "$BackupDir\oracle-full.dmp" "${Container}:/opt/oracle/dpdump_backup/oracle-full.dmp" 2>&1 | Out-Null

      Write-Host "    5.4 impdp 실행 (수십 분 소요 가능)"
      $impdpCmd = "impdp system/'$SysPassword'@//localhost:1521/$Pdb DIRECTORY=BACKUP_DP DUMPFILE=oracle-full.dmp LOGFILE=impdp.log FULL=Y TABLE_EXISTS_ACTION=REPLACE"
      & docker exec $Container bash -c $impdpCmd 2>&1 | Out-Null
      $impdpExit = $LASTEXITCODE
      & docker cp "${Container}:/opt/oracle/dpdump_backup/impdp.log" "$BackupDir\impdp.log" 2>&1 | Out-Null
      Write-OK "impdp exit=$impdpExit (log: $BackupDir\impdp.log)"
    }
  } finally {
    Pop-Location
  }
} else {
  Write-Step "5. ORACLE (SKIP)"
}

# ----- 6. POST: 재기동 -----
Write-Step "6. POST"
if ($DryRun) {
  Write-DryRun ".\start-all.ps1"
} else {
  $startScript = "$DockerDir\start-all.ps1"
  if (Test-Path $startScript) {
    Write-Host "    재기동: $startScript"
    & $startScript -SkipDocker  # Docker 는 이미 5단계에서 떴음
  }
}

Write-Host ""
Write-Host "RESTORE DONE: $BackupDir" -ForegroundColor Green
exit 0
