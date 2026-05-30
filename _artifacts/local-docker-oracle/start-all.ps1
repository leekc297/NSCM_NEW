# NSCM 통합 안전 기동 스크립트 (Docker Oracle + BE Spring Boot + FE Vite)
#
# 사용법:
#   cd C:\Projects\NSCM\_artifacts\local-docker-oracle
#   .\start-all.ps1                     # 3종 기동
#   .\start-all.ps1 -OpenBrowser        # 기동 후 http://localhost:5173 자동 열기
#   .\start-all.ps1 -SkipDocker         # Docker 는 이미 떠있다고 가정
#   .\start-all.ps1 -SkipBe             # BE 만 생략
#   .\start-all.ps1 -SkipFe             # FE 만 생략
#
# 원칙:
#   - pnpm install / dev / local / build / type-check 절대 호출하지 않음
#   - turbo run * 절대 호출하지 않음
#   - vite 는 반드시 절대 경로 `nscm-fe\apps\web\node_modules\.bin\vite.cmd` 호출
#   - 환경(node_modules junction) 파괴 방지가 최우선

[CmdletBinding()]
param(
  [switch]$OpenBrowser,
  [switch]$SkipDocker,
  [switch]$SkipBe,
  [switch]$SkipFe,
  [int]$DockerReadyTimeoutSec  = 600,
  [int]$BeReadyTimeoutSec      = 300,
  [int]$FeReadyTimeoutSec      = 120
)

$ErrorActionPreference = "Continue"  # native exe stderr 를 ErrorRecord 로 wrap 하는 PS5.1 동작 회피

# 고정 경로
$RepoRoot      = "C:\Projects\NSCM"
$DockerDir     = "$RepoRoot\_artifacts\local-docker-oracle"
$ComposeFile   = "$DockerDir\docker-compose.yml"
$BeDir         = "$RepoRoot\nscm-be"
$FeWebDir      = "$RepoRoot\nscm-fe\apps\web"
$ViteCmd       = "$FeWebDir\node_modules\.bin\vite.cmd"
$StateDir      = "D:\NSCM_backup\state"
$BeLogDir      = "$BeDir\logs"
$FeLogFile     = "$FeWebDir\.start-all-fe.out"
$BeLogFile     = "$BeLogDir\start-all_be.out"

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg"  -ForegroundColor Red }

# ----- 0. PRE-CHECK -----
Write-Step "0. PRE-CHECK"

# 0.1 Docker Desktop
if (-not $SkipDocker) {
  $dockerProc = Get-Process "com.docker.proxy","Docker Desktop" -ErrorAction SilentlyContinue
  if (-not $dockerProc) {
    Write-Warn2 "Docker Desktop 프로세스 미감지. 자동 기동 시도."
    try {
      $dockerExe = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
      if (Test-Path $dockerExe) {
        Start-Process $dockerExe
        Write-Host "    Docker Desktop 기동 중... 60초 대기"
        Start-Sleep -Seconds 60
      } else {
        Write-Fail "Docker Desktop 미설치 또는 경로 다름. 수동 기동 후 재시도."
        exit 1
      }
    } catch {
      Write-Fail "Docker Desktop 자동 기동 실패: $_"
      exit 1
    }
  }
  & docker info *> $null
  if ($LASTEXITCODE -ne 0) {
    Write-Fail "Docker 데몬 응답 없음. Docker Desktop 완전 기동 대기 후 재시도."
    exit 1
  }
  Write-OK "Docker 데몬 응답 정상"
}

# 0.2 FE vite.cmd 존재 확인
if (-not $SkipFe) {
  if (-not (Test-Path $ViteCmd)) {
    Write-Fail "vite.cmd 미발견: $ViteCmd"
    Write-Host "    FE node_modules 가 손상됐을 가능성. 다음 명령으로 복구:" -ForegroundColor Yellow
    Write-Host "      C:\Projects\NSCM\nscm-fe\.local-packs\hoist-from-pnpm-store.ps1" -ForegroundColor Yellow
    exit 1
  }
  Write-OK "FE vite.cmd 존재 확인"
}

# 0.3 포트 충돌 점검
function Test-PortInUse($port) {
  $r = Test-NetConnection -ComputerName 127.0.0.1 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
  return [bool]$r
}
$ports = @{ 1521="Oracle"; 8080="BE"; 5173="FE" }
foreach ($p in $ports.Keys) {
  if (Test-PortInUse $p) {
    Write-Warn2 "포트 $p ($($ports[$p])) 이미 사용 중 — 기존 프로세스를 그대로 사용"
  } else {
    Write-OK "포트 $p ($($ports[$p])) 가용"
  }
}

# 0.4 상태 디렉토리
if (-not (Test-Path $StateDir)) {
  try {
    New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
    Write-OK "상태 디렉토리 생성: $StateDir"
  } catch {
    Write-Warn2 "D:\NSCM_backup\state 생성 실패 — PIDs 보존 생략"
    $StateDir = $null
  }
}

# 0.5 BE 로그 디렉토리
if (-not (Test-Path $BeLogDir)) {
  New-Item -ItemType Directory -Path $BeLogDir -Force | Out-Null
}

# ----- 1. DOCKER (Oracle 23ai Free) -----
if (-not $SkipDocker) {
  Write-Step "1. DOCKER (Oracle)"
  Push-Location $DockerDir
  try {
    & docker compose -f $ComposeFile up -d *> $null
    if ($LASTEXITCODE -ne 0) {
      Write-Fail "docker compose up 실패"
      exit 1
    }
    Write-OK "docker compose up -d 호출"

    # Listener READY 가 1차 판정 (healthcheck unhealthy 라도 listener 가 응답하면 통신 가능)
    Write-Host "    Oracle Listener READY 대기 (최대 ${DockerReadyTimeoutSec}초)..."
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $ready = $false
    $healthStatus = "unknown"
    while ($sw.Elapsed.TotalSeconds -lt $DockerReadyTimeoutSec) {
      $healthStatus = (& docker inspect --format='{{.State.Health.Status}}' nscm-oracle 2>$null) -as [string]
      $lsnr = & docker exec nscm-oracle bash -c "lsnrctl status 2>/dev/null | grep -c READY" 2>$null
      if ($healthStatus -eq "healthy" -or [int]$lsnr -gt 0) {
        $ready = $true
        break
      }
      Start-Sleep -Seconds 5
    }
    if (-not $ready) {
      Write-Fail "Oracle 응답 없음 timeout (${DockerReadyTimeoutSec}s). docker compose logs oracle 확인 필요."
      exit 1
    }
    if ($healthStatus -eq "healthy") {
      Write-OK ("Oracle healthy ({0:N0}초)" -f $sw.Elapsed.TotalSeconds)
    } else {
      Write-OK ("Oracle Listener READY (healthcheck=$healthStatus, {0:N0}초)" -f $sw.Elapsed.TotalSeconds)
      Write-Host "    (healthcheck 가 unhealthy 라벨이지만 SQL 통신 가능 — gvenzl healthcheck.sh 가 SCM_MGR ping 으로 판정, 무시해도 됨)" -ForegroundColor DarkGray
    }
  } finally {
    Pop-Location
  }
} else {
  Write-Step "1. DOCKER (SKIP)"
}

# ----- 2. BE (Spring Boot) -----
$bePid = $null
if (-not $SkipBe) {
  Write-Step "2. BE (Spring Boot)"
  if (Test-PortInUse 8080) {
    Write-OK "8080 이미 가동 중 — 기존 BE 사용"
  } else {
    # Hidden window 로 gradlew bootRun
    $gradlewCmd = "$BeDir\gradlew.bat"
    if (-not (Test-Path $gradlewCmd)) {
      Write-Fail "gradlew.bat 미발견: $gradlewCmd"
      exit 1
    }
    Write-Host "    bootRun 백그라운드 기동 (log: $BeLogFile)..."
    $beProc = Start-Process -FilePath $gradlewCmd `
      -ArgumentList "bootRun" `
      -WorkingDirectory $BeDir `
      -WindowStyle Hidden `
      -RedirectStandardOutput $BeLogFile `
      -RedirectStandardError "$BeLogFile.err" `
      -PassThru
    $bePid = $beProc.Id
    Write-OK "bootRun PID=$bePid"

    # 8080 polling
    Write-Host "    8080 응답 대기 (최대 ${BeReadyTimeoutSec}초)..."
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $beReady = $false
    while ($sw.Elapsed.TotalSeconds -lt $BeReadyTimeoutSec) {
      if (Test-PortInUse 8080) {
        $beReady = $true
        break
      }
      Start-Sleep -Seconds 3
    }
    if (-not $beReady) {
      Write-Fail "BE 8080 응답 timeout. 로그 확인: $BeLogFile"
      exit 1
    }
    Write-OK ("BE 8080 응답 ({0:N0}초)" -f $sw.Elapsed.TotalSeconds)
  }
} else {
  Write-Step "2. BE (SKIP)"
}

# ----- 3. FE (Vite, turbo/pnpm 우회) -----
$fePid = $null
if (-not $SkipFe) {
  Write-Step "3. FE (Vite)"
  if (Test-PortInUse 5173) {
    Write-OK "5173 이미 가동 중 — 기존 FE 사용"
  } else {
    Write-Host "    vite.cmd 백그라운드 기동 (log: $FeLogFile)..."
    $feProc = Start-Process -FilePath $ViteCmd `
      -ArgumentList "--port","5173","--host","127.0.0.1" `
      -WorkingDirectory $FeWebDir `
      -WindowStyle Hidden `
      -RedirectStandardOutput $FeLogFile `
      -RedirectStandardError "$FeLogFile.err" `
      -PassThru
    $fePid = $feProc.Id
    Write-OK "vite PID=$fePid"

    # 5173 polling
    Write-Host "    5173 응답 대기 (최대 ${FeReadyTimeoutSec}초)..."
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $feReady = $false
    while ($sw.Elapsed.TotalSeconds -lt $FeReadyTimeoutSec) {
      if (Test-PortInUse 5173) {
        $feReady = $true
        break
      }
      Start-Sleep -Seconds 2
    }
    if (-not $feReady) {
      Write-Fail "FE 5173 응답 timeout. 로그 확인: $FeLogFile"
      exit 1
    }
    Write-OK ("FE 5173 응답 ({0:N0}초)" -f $sw.Elapsed.TotalSeconds)
  }
} else {
  Write-Step "3. FE (SKIP)"
}

# ----- 4. POST -----
Write-Step "4. POST"

# PIDs 보존
if ($StateDir) {
  $pidsFile = "$StateDir\last-pids.json"
  $existing = @{}
  if (Test-Path $pidsFile) {
    try { $existing = Get-Content $pidsFile -Raw | ConvertFrom-Json -AsHashtable } catch { $existing = @{} }
  }
  if ($null -eq $existing) { $existing = @{} }
  if ($bePid) { $existing.bePid = $bePid }
  if ($fePid) { $existing.fePid = $fePid }
  $existing.lastStartedAt = (Get-Date).ToString("o")
  $existing | ConvertTo-Json | Set-Content $pidsFile -Encoding utf8
  Write-OK "PIDs 보존: $pidsFile"
}

Write-Host ""
Write-Host "DB ready: 1521 / BE ready: 8080 / FE ready: 5173" -ForegroundColor Green
Write-Host "  - Oracle  : sqlplus SCM_MGR/'!SCMroqkf2026'@//localhost:1521/FREEPDB1"
Write-Host "  - BE      : http://localhost:8080  (log: $BeLogFile)"
Write-Host "  - FE      : http://localhost:5173  (log: $FeLogFile)"

if ($OpenBrowser) {
  Start-Process "http://localhost:5173"
}

exit 0
