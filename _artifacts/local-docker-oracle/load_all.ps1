# =============================================================================
# load_all.ps1
# NSCM 로컬 Docker Oracle 일괄 적재 스크립트 (PowerShell 5.1)
#
# 전제:
#   - docker-compose.yml 로 nscm-oracle 컨테이너가 healthy 상태로 떠 있음
#   - To-be_v2_converted 가 컨테이너 /work 로 마운트됨
#   - _artifacts/local-docker-oracle 가 컨테이너 /artifacts 로 마운트됨 (rw)
#
# 동작:
#   1. SYS DBA 로 00_create_schema.sql      (SCM_MGR + 역할 3개)
#   2. SYS DBA 로 01_create_tablespaces.sql (TS_SCM_D01/X01 + quota)
#   3. SCM_MGR 로 99_Verification/01_compile_order.sql (전체 DDL 적재, 워크디렉토리는 /work/99_Verification)
#   4. SCM_MGR 로 99_verify_compile.sql (결과 검증)
#
# 사용:
#   cd C:\Projects\NSCM\_artifacts\local-docker-oracle
#   .\load_all.ps1
# =============================================================================

$ErrorActionPreference = "Stop"

$Container = "nscm-oracle"
$Pdb       = "FREEPDB1"
$Pwd       = "!SCMroqkf2026"
$AppUser   = "SCM_MGR"

function Test-DatabaseReady {
    # Docker healthcheck 는 gvenzl/oracle-free:23-slim-faststart 에서 false-negative 가 잦음.
    # "DATABASE IS READY TO USE!" 메시지가 container log 에 찍히는 것을 truth-source 로 사용.
    $logs = docker logs $Container 2>&1 | Out-String
    return ($logs -match "DATABASE IS READY TO USE!")
}

function Wait-Ready([int]$timeoutSec = 900) {
    Write-Host "[1/5] Waiting for $Container DB to be ready (timeout ${timeoutSec}s)..."
    $deadline = (Get-Date).AddSeconds($timeoutSec)
    while ((Get-Date) -lt $deadline) {
        if (Test-DatabaseReady) {
            Write-Host "      OK Database ready."
            return
        }
        Start-Sleep -Seconds 5
    }
    throw "Container $Container DB did not become ready within $timeoutSec seconds."
}

function Invoke-Sqlplus(
    [string]$ConnString,
    [string]$ScriptPath,
    [string]$LogPath,
    [string]$WorkDir = "/artifacts"
) {
    Write-Host "[exec] sqlplus $ConnString @$ScriptPath  (cwd=$WorkDir)"
    # -L = no re-prompt on bad login (fail fast)
    # -w = container working directory (for SQL*Plus @@ relative-path resolution)
    $env:MSYS_NO_PATHCONV = "1"
    docker exec -i -w $WorkDir $Container sqlplus -L "$ConnString" "@$ScriptPath" `
        | Tee-Object -FilePath $LogPath
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "sqlplus exit=$LASTEXITCODE for $ScriptPath (see $LogPath)"
        # 적재 단계의 errors 는 INVALID 객체로 표현되고 sqlplus 가 종료 코드를 따로 주지 않으므로
        # 여기서 throw 하지 않고 다음 단계로 진행 (검증 단계에서 INVALID 보고).
    }
}

# ---------------------------------------------------------------------------
# 0. Pre-flight
# ---------------------------------------------------------------------------
Wait-Ready

# ---------------------------------------------------------------------------
# 1. Schema (SYS DBA)
# ---------------------------------------------------------------------------
Write-Host "[2/5] Creating SCM_MGR schema + roles (SYS DBA)..."
$sysConn = "sys/`"$Pwd`"@//localhost:1521/$Pdb as sysdba"
Invoke-Sqlplus -ConnString $sysConn `
               -ScriptPath "/artifacts/00_create_schema.sql" `
               -LogPath    "./logs_00_create_schema.txt"

# ---------------------------------------------------------------------------
# 2. Tablespaces (SYS DBA)
# ---------------------------------------------------------------------------
Write-Host "[3/5] Creating TS_SCM_D01/TS_SCM_X01 tablespaces (SYS DBA)..."
Invoke-Sqlplus -ConnString $sysConn `
               -ScriptPath "/artifacts/01_create_tablespaces.sql" `
               -LogPath    "./logs_01_create_tablespaces.txt"

# ---------------------------------------------------------------------------
# 3. Bulk load (SCM_MGR) — 01_compile_order.sql 이 모든 폴더를 순서대로 호출
#    WorkDir 를 /work/99_Verification 으로 잡아야 @@ 상대경로가 정상 resolve 됨.
# ---------------------------------------------------------------------------
Write-Host "[4/5] Loading To-be_v2_converted DDL (this can take 15-30 min)..."
$appConn = "$AppUser/`"$Pwd`"@//localhost:1521/$Pdb"
Invoke-Sqlplus -ConnString $appConn `
               -ScriptPath "01_compile_order.sql" `
               -LogPath    "./logs_01_compile_order.txt" `
               -WorkDir    "/work/99_Verification"

# ---------------------------------------------------------------------------
# 4. Verify
# ---------------------------------------------------------------------------
Write-Host "[5/5] Verifying compile results..."
Invoke-Sqlplus -ConnString $appConn `
               -ScriptPath "/artifacts/99_verify_compile.sql" `
               -LogPath    "./logs_99_verify_compile.txt"

Write-Host ""
Write-Host "============================================================"
Write-Host " DONE. Inspect:"
Write-Host "   ./logs_00_create_schema.txt"
Write-Host "   ./logs_01_create_tablespaces.txt"
Write-Host "   ./logs_01_compile_order.txt"
Write-Host "   ./logs_99_verify_compile.txt"
Write-Host "============================================================"
