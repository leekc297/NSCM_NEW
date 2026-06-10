# NSCM 통합 안전 기동 스크립트 (BE Spring Boot + FE Vite)
#
# 2026-06-10: 사내 Oracle (10.20.100.153:2521:ESSCMD) 직접 연결로 전환되어
#             Docker 기동 단계 제거. (config-local.yml 의 datasources[0] 참조)
#
# 사용법:
#   cd C:\Projects\NSCM\_artifacts\local-docker-oracle
#   .\start-all.ps1                     # BE + FE 기동
#   .\start-all.ps1 -OpenBrowser        # 기동 후 http://localhost:5173 자동 열기
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
  [switch]$SkipBe,
  [switch]$SkipFe,
  [int]$BeReadyTimeoutSec      = 300,
  [int]$FeReadyTimeoutSec      = 180
)

$ErrorActionPreference = "Continue"  # native exe stderr 를 ErrorRecord 로 wrap 하는 PS5.1 동작 회피

# 고정 경로
$RepoRoot      = "C:\Projects\NSCM"
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

# 0.1 FE vite.cmd 존재 확인
if (-not $SkipFe) {
  if (-not (Test-Path $ViteCmd)) {
    Write-Fail "vite.cmd 미발견: $ViteCmd"
    Write-Host "    FE node_modules 가 손상됐을 가능성. 다음 명령으로 복구:" -ForegroundColor Yellow
    Write-Host "      C:\Projects\NSCM\nscm-fe\.local-packs\hoist-from-pnpm-store.ps1" -ForegroundColor Yellow
    exit 1
  }
  Write-OK "FE vite.cmd 존재 확인"
}

# 0.2 포트 충돌 점검
function Test-PortInUse($port) {
  $r = Test-NetConnection -ComputerName 127.0.0.1 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
  return [bool]$r
}
$ports = @{ 8080="BE"; 5173="FE" }
foreach ($p in $ports.Keys) {
  if (Test-PortInUse $p) {
    Write-Warn2 "포트 $p ($($ports[$p])) 이미 사용 중 — 기존 프로세스를 그대로 사용"
  } else {
    Write-OK "포트 $p ($($ports[$p])) 가용"
  }
}

# 0.3 사내 Oracle 도달 확인 (config-local.yml datasources[0])
$OracleHost = "10.20.100.153"
$OraclePort = 2521
if (Test-NetConnection -ComputerName $OracleHost -Port $OraclePort -InformationLevel Quiet -WarningAction SilentlyContinue) {
  Write-OK "사내 Oracle ${OracleHost}:${OraclePort} 도달 확인"
} else {
  Write-Warn2 "사내 Oracle ${OracleHost}:${OraclePort} 미도달 — 사내망/방화벽 확인 필요 (BE HikariPool init 실패 예상)"
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

# ----- 1. BE (Spring Boot) -----
$bePid = $null
if (-not $SkipBe) {
  Write-Step "1. BE (Spring Boot)"
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
  Write-Step "1. BE (SKIP)"
}

# ----- 2. FE (Vite, turbo/pnpm 우회) -----
$fePid = $null
if (-not $SkipFe) {
  Write-Step "2. FE (Vite)"
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
  Write-Step "2. FE (SKIP)"
}

# ----- 3. POST -----
Write-Step "3. POST"

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
Write-Host "BE ready: 8080 / FE ready: 5173" -ForegroundColor Green
Write-Host "  - Oracle  : 사내 ${OracleHost}:${OraclePort}:ESSCMD (SCM_MGR)"
Write-Host "  - BE      : http://localhost:8080  (log: $BeLogFile)"
Write-Host "  - FE      : http://localhost:5173  (log: $FeLogFile)"

if ($OpenBrowser) {
  Start-Process "http://localhost:5173"
}

exit 0
