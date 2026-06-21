# regression-impact.ps1
#
# 사용처: 작업 종료 직전 — 현재 working tree 의 변경 영역별 영향 화면 인벤토리 출력.
# 의도: 신규/수정 화면이 기존 다른 화면을 깨뜨릴 가능성 자동 보고. 룰 #62 (regression-zero) 보조 도구.
#
# 사용법:
#   PS> cd C:\Projects\NSCM
#   PS> .\_artifacts\_local_setup\regression-impact.ps1
#
# 출력:
#   1) Hard Boundary 6 영역 변경 (packages/shared·foundation·lges, features/{X}/src/components/, nscm-be)
#   2) 도메인 안 인접 화면 인벤토리 (features/{domain}/src/pages/ 각 화면 + components/ 사용처 grep)
#   3) procedures.d.ts (글로벌 SHEETS 유니온) 변경 여부 — 모든 화면 type 영향

$ErrorActionPreference = 'Continue'
Set-Location -Path 'C:\Projects\NSCM'

Write-Host ""
Write-Host "===== regression-impact (룰 #62 보조) =====" -ForegroundColor Cyan

# git diff --name-only HEAD — staged + unstaged 합집합.
# PowerShell 5.1 의 native stderr 사고 회피 — cmd /c 로 stderr 만 nul 리다이렉트.
$changed = & cmd /c "git diff --name-only HEAD 2>nul"
$untracked = & cmd /c "git ls-files --others --exclude-standard 2>nul"
$all = @($changed) + @($untracked) | Where-Object { $_ -and $_.Trim() } | Sort-Object -Unique

if (-not $all) {
  Write-Host "변경 파일 없음. 종료." -ForegroundColor Green
  exit 0
}

Write-Host ""
Write-Host "[변경 파일 전체]" -ForegroundColor Yellow
$all | ForEach-Object { Write-Host "  $_" }

# 1) Hard Boundary 위반 영역
$hbPattern = '^(nscm-fe/)?(packages/(shared|foundation|lges)/|features/[^/]+/src/components/)|^nscm-be/'
$hbHits = $all | Where-Object { $_ -match $hbPattern }
Write-Host ""
Write-Host "[1] Hard Boundary 영역 변경" -ForegroundColor Yellow
if ($hbHits) {
  $hbHits | ForEach-Object { Write-Host "  ! $_" -ForegroundColor Red }
  Write-Host "  → 분리 PR + 4 도메인 (admin/authority/demand/master) 1 화면씩 cross-check 권고." -ForegroundColor Yellow
} else {
  Write-Host "  변경 없음 (Hard Boundary 준수)" -ForegroundColor Green
}

# 2) 영향 받는 도메인 안 인접 화면
$domainHits = $all | Where-Object { $_ -match '^(nscm-fe/)?features/([^/]+)/src/pages/([^/]+)' } | ForEach-Object {
  if ($_ -match 'features/([^/]+)/src/pages/([^/]+)') {
    [PSCustomObject]@{ Domain = $Matches[1]; Screen = $Matches[2]; Path = $_ }
  }
} | Select-Object Domain, Screen -Unique

Write-Host ""
Write-Host "[2] 변경된 화면 + 같은 도메인 인접 화면 (regression cross-check 대상)" -ForegroundColor Yellow
$domainGroups = $domainHits | Group-Object Domain
if (-not $domainGroups) {
  Write-Host "  화면 단위 변경 없음" -ForegroundColor Green
} else {
  foreach ($g in $domainGroups) {
    $domain = $g.Name
    $changedScreens = $g.Group | ForEach-Object { $_.Screen } | Sort-Object -Unique
    Write-Host "  [$domain] 변경 화면: $($changedScreens -join ', ')" -ForegroundColor Cyan
    $pagesRoot = "nscm-fe/features/$domain/src/pages"
    if (Test-Path $pagesRoot) {
      $allScreens = Get-ChildItem -Path $pagesRoot -Directory | Select-Object -ExpandProperty Name
      $neighbors = $allScreens | Where-Object { $_ -notin $changedScreens }
      if ($neighbors) {
        Write-Host "    인접 화면 (regression 의심 대상 — 최소 1~2 진입 확인 권고):" -ForegroundColor Gray
        $neighbors | ForEach-Object { Write-Host "      - $_" }
      }
    }
  }
}

# 3) procedures.d.ts (글로벌 SHEETS / ProcRequest / ResponseData) 변경
$proc = $all | Where-Object { $_ -match 'procedures\.d\.ts$' }
Write-Host ""
Write-Host "[3] 글로벌 type (procedures.d.ts) 변경" -ForegroundColor Yellow
if ($proc) {
  $proc | ForEach-Object { Write-Host "  ! $_" -ForegroundColor Red }
  Write-Host "  → SHEETS 유니온 / RESPONSE_SET 추가 시 기존 화면 type narrow 영향 가능." -ForegroundColor Yellow
  Write-Host "    `pnpm gen:i18n` + 전체 type-check (클라우드) 권고." -ForegroundColor Yellow
} else {
  Write-Host "  변경 없음" -ForegroundColor Green
}

Write-Host ""
Write-Host "===== 보고 양식 (사용자 회신용) =====" -ForegroundColor Cyan
Write-Host "변경 파일: $($all.Count)" -ForegroundColor Gray
Write-Host "Hard Boundary 위반: $(if ($hbHits) { $hbHits.Count } else { 0 })" -ForegroundColor Gray
Write-Host "영향 도메인: $(($domainGroups | ForEach-Object { $_.Name }) -join ', ')" -ForegroundColor Gray
Write-Host "글로벌 type 변경: $(if ($proc) { 'YES' } else { 'NO' })" -ForegroundColor Gray
Write-Host ""
