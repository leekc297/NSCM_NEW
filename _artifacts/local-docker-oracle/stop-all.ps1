# NSCM 통합 정지 스크립트 (FE → BE → Docker 역순)
#
# 사용법:
#   .\stop-all.ps1                  # 3종 정지 (Docker volume 유지)
#   .\stop-all.ps1 -SkipDocker      # Docker 는 그대로 두고 BE/FE 만 정지
#   .\stop-all.ps1 -Force           # PID 모르더라도 포트 사용 프로세스 강제 종료
#
# Volume 절대 삭제하지 않음 (docker compose down 호출 X)

[CmdletBinding()]
param(
  [switch]$SkipDocker,
  [switch]$Force
)

$ErrorActionPreference = "Continue"

$RepoRoot   = "C:\Projects\NSCM"
$DockerDir  = "$RepoRoot\_artifacts\local-docker-oracle"
$StateDir   = "D:\NSCM_backup\state"
$PidsFile   = "$StateDir\last-pids.json"

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }

# ----- 1. PIDs 로드 -----
$pids = @{}
if (Test-Path $PidsFile) {
  try { $pids = Get-Content $PidsFile -Raw | ConvertFrom-Json -AsHashtable } catch { $pids = @{} }
}

function Stop-PortProcess($port, $name) {
  $tcp = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
  if (-not $tcp) { return $false }
  foreach ($c in $tcp) {
    try {
      $proc = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue
      if ($proc) {
        Stop-Process -Id $c.OwningProcess -Force
        Write-OK "$name (PID=$($c.OwningProcess), name=$($proc.ProcessName)) 종료"
      }
    } catch {
      Write-Warn2 "$name PID=$($c.OwningProcess) 종료 실패: $_"
    }
  }
  return $true
}

# ----- 2. FE 정지 -----
Write-Step "1. FE 정지"
if ($pids.fePid -and (Get-Process -Id $pids.fePid -ErrorAction SilentlyContinue)) {
  try {
    Stop-Process -Id $pids.fePid -Force
    Write-OK "FE PID=$($pids.fePid) 종료"
  } catch {
    Write-Warn2 "FE PID 종료 실패: $_"
  }
}
if ($Force -or -not $pids.fePid) {
  Stop-PortProcess 5173 "FE" | Out-Null
}

# ----- 3. BE 정지 -----
Write-Step "2. BE 정지"
if ($pids.bePid -and (Get-Process -Id $pids.bePid -ErrorAction SilentlyContinue)) {
  try {
    # gradle daemon 자식 프로세스 정리
    $children = Get-CimInstance Win32_Process -Filter "ParentProcessId=$($pids.bePid)" -ErrorAction SilentlyContinue
    foreach ($c in $children) {
      try { Stop-Process -Id $c.ProcessId -Force -ErrorAction SilentlyContinue } catch {}
    }
    Stop-Process -Id $pids.bePid -Force
    Write-OK "BE PID=$($pids.bePid) + 자식 종료"
  } catch {
    Write-Warn2 "BE PID 종료 실패: $_"
  }
}
if ($Force -or -not $pids.bePid) {
  Stop-PortProcess 8080 "BE" | Out-Null
}

# ----- 4. Docker (volume 유지) -----
if (-not $SkipDocker) {
  Write-Step "3. Docker (compose stop, volume 유지)"
  Push-Location $DockerDir
  try {
    & docker compose stop 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
      Write-OK "docker compose stop 완료 (volume nscm-oracle-data 유지)"
    } else {
      Write-Warn2 "docker compose stop exit=$LASTEXITCODE"
    }
  } finally {
    Pop-Location
  }
} else {
  Write-Step "3. Docker (SKIP)"
}

# ----- 5. PIDs 파일 비우기 -----
if (Test-Path $PidsFile) {
  $pids.bePid = $null
  $pids.fePid = $null
  $pids.lastStoppedAt = (Get-Date).ToString("o")
  $pids | ConvertTo-Json | Set-Content $PidsFile -Encoding utf8
}

Write-Host ""
Write-Host "정지 완료. Volume nscm-oracle-data 는 그대로 보존됨." -ForegroundColor Green
exit 0
