# nscm-fe-post-import-setup.ps1
# ============================================================
# 클라우드에서 nscm-fe 폴더를 일괄 이관한 직후 로컬 환경 동작에 필요한
# 3 가지 fix 를 한 번에 적용한다. Nexus 가 차단된 오프라인 상황에서
# 실행 가능 (모든 source 는 디스크 내 캐시 사용).
#
# 사용:
#   powershell -ExecutionPolicy Bypass -File C:\Projects\NSCM\_artifacts\_local_setup\nscm-fe-post-import-setup.ps1
#
# 트리거 명령 (Claude Code 대화):
#   "nscm-fe 일관 이관 후 local 환경설정"
#
# 적용 fix:
#   1) lru-cache v5.1.1 nested 복사 — @babel/helper-compilation-targets 의 Babel transform 사고 fix
#   2) js-tokens v9.0.1 nested 복사 — strip-literal 의 unplugin-auto-import transform 사고 fix
#   3) apps/web/.env.local 생성 — apiClient baseURL 을 5173 Vite proxy 와 정합되게 override
#
# 이력:
#   2026-06-19 — 신규. 사용자 요청 (로그인 ERR_CONNECTION_REFUSED 사고 + Babel/jsTokens transform 사고 root cause fix 후 자동화)
#   상세 컨텍스트: _artifacts/_local_setup/README.md
# ============================================================

$ErrorActionPreference = 'Stop'
$FE_ROOT = "C:\Projects\NSCM\nscm-fe"
$ts = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "============================================================"
Write-Host " nscm-fe Post-Import Local Setup  ($([DateTime]::Now))"
Write-Host "============================================================"
Write-Host ""

# ---------- 0. precondition check ----------
if (-not (Test-Path "$FE_ROOT\node_modules")) {
    Write-Host "[FAIL] $FE_ROOT\node_modules not found. pnpm install 필요 (Nexus 살아있을 때)." -ForegroundColor Red
    exit 1
}
Write-Host "[0/4] precondition OK  ($FE_ROOT\node_modules 존재)" -ForegroundColor Green
Write-Host ""

# ---------- 1. lru-cache v5.1.1 nested copy ----------
Write-Host "[1/4] @babel/helper-compilation-targets → lru-cache@5.1.1 nested copy"
$src1 = "$FE_ROOT\node_modules\.pnpm\lru-cache@5.1.1\node_modules\lru-cache"
$dst1 = "$FE_ROOT\node_modules\@babel\helper-compilation-targets\node_modules\lru-cache"

if (-not (Test-Path $src1)) {
    Write-Host "  [WARN] source 없음: $src1" -ForegroundColor Yellow
    Write-Host "         → .pnpm 캐시에 lru-cache@5.1.1 가 없음. pnpm install 후 재시도." -ForegroundColor Yellow
} elseif (Test-Path "$dst1\package.json") {
    $existVer = (Get-Content "$dst1\package.json" -Encoding UTF8 | Select-String '"version"' | Select-Object -First 1).ToString()
    if ($existVer -match '5\.1\.1') {
        Write-Host "  [SKIP] 이미 v5.1.1 적용됨" -ForegroundColor DarkGray
    } else {
        Copy-Item -Recurse -Force $src1 $dst1
        Write-Host "  [OK] 덮어쓰기 완료 ($existVer → 5.1.1)" -ForegroundColor Green
    }
} else {
    New-Item -ItemType Directory -Force -Path (Split-Path $dst1 -Parent) | Out-Null
    Copy-Item -Recurse -Force $src1 $dst1
    Write-Host "  [OK] 신규 복사 완료" -ForegroundColor Green
}
Write-Host ""

# ---------- 2. js-tokens v9.0.1 nested copy ----------
Write-Host "[2/4] strip-literal → js-tokens@9.0.1 nested copy"
$src2 = "$FE_ROOT\node_modules\.pnpm\js-tokens@9.0.1\node_modules\js-tokens"
$dst2 = "$FE_ROOT\node_modules\strip-literal\node_modules\js-tokens"

if (-not (Test-Path $src2)) {
    Write-Host "  [WARN] source 없음: $src2" -ForegroundColor Yellow
} elseif (Test-Path "$dst2\package.json") {
    $existVer = (Get-Content "$dst2\package.json" -Encoding UTF8 | Select-String '"version"' | Select-Object -First 1).ToString()
    if ($existVer -match '9\.0\.1') {
        Write-Host "  [SKIP] 이미 v9.0.1 적용됨" -ForegroundColor DarkGray
    } else {
        Copy-Item -Recurse -Force $src2 $dst2
        Write-Host "  [OK] 덮어쓰기 완료 ($existVer → 9.0.1)" -ForegroundColor Green
    }
} else {
    New-Item -ItemType Directory -Force -Path (Split-Path $dst2 -Parent) | Out-Null
    Copy-Item -Recurse -Force $src2 $dst2
    Write-Host "  [OK] 신규 복사 완료" -ForegroundColor Green
}
Write-Host ""

# ---------- 3. apps/web/.env.local override ----------
Write-Host "[3/4] apps/web/.env.local 생성 (VITE_PROXY_BASE_URL=/api 상대경로 override)"
$envLocal = "$FE_ROOT\apps\web\.env.local"
$envContent = @"
# Local override (gitignored) — 5173/127.0.0.1 로 띄울 때 apiClient.baseURL 을
# 상대경로로 설정. vite.config 의 server.proxy '/api' → http://localhost:8080 forward.
# 원본 .env 의 VITE_PROXY_BASE_URL=http://localhost:3000/api 는 3000 으로 hardcode 되어
# 5173 띄울 때 ERR_CONNECTION_REFUSED 발생 — 이 파일이 우선 적용되어 fix.
VITE_PROXY_BASE_URL=/api
"@

if (Test-Path $envLocal) {
    $exist = Get-Content $envLocal -Encoding UTF8 -Raw
    if ($exist -match 'VITE_PROXY_BASE_URL=/api') {
        Write-Host "  [SKIP] 이미 적용됨" -ForegroundColor DarkGray
    } else {
        Copy-Item $envLocal "$envLocal.bak-$ts" -Force
        Set-Content -Path $envLocal -Value $envContent -Encoding UTF8 -NoNewline
        Write-Host "  [OK] 갱신 완료 (백업: .env.local.bak-$ts)" -ForegroundColor Green
    }
} else {
    Set-Content -Path $envLocal -Value $envContent -Encoding UTF8 -NoNewline
    Write-Host "  [OK] 신규 생성" -ForegroundColor Green
}
Write-Host ""

# ---------- 4. Vite cache invalidate ----------
Write-Host "[4/4] Vite cache 정리 (apps/web/node_modules/.vite 삭제)"
$viteCache = "$FE_ROOT\apps\web\node_modules\.vite"
if (Test-Path $viteCache) {
    Remove-Item -Recurse -Force $viteCache -ErrorAction SilentlyContinue
    Write-Host "  [OK] 삭제 완료" -ForegroundColor Green
} else {
    Write-Host "  [SKIP] cache 없음" -ForegroundColor DarkGray
}
Write-Host ""

# ---------- summary ----------
Write-Host "============================================================"
Write-Host " 완료. 이어서 다음 명령으로 BE+FE 기동:"
Write-Host "============================================================"
Write-Host "   BE: cd /d C:\Projects\NSCM\nscm-be && gradlew.bat bootRun --args=`"--spring.profiles.active=local`""
Write-Host "   FE: cd /d C:\Projects\NSCM\nscm-fe\apps\web && node_modules\.bin\vite.cmd --port 5173 --host 127.0.0.1"
Write-Host ""
Write-Host "   접속: http://127.0.0.1:5173/    (사용자 ID: minyonglee1)"
Write-Host "============================================================"
