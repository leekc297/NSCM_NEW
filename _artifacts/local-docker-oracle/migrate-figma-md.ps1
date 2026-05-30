# Doc/_analysis/.../figma_link.md 397개 → Doc/_figma/screens/{화면ID}.md 이관 (복사)
#
# 사용자 결정 (2026-05-30): 분석서와 Figma 정보 분리.
# 원본 figma_link.md 는 유지 + 안내 line 추가. 새 폴더의 파일이 진실 source.
#
# 사용법:
#   .\migrate-figma-md.ps1                  # 일괄 이관 + report
#   .\migrate-figma-md.ps1 -DryRun          # 실제 변경 없이 액션만 출력
#   .\migrate-figma-md.ps1 -ReportOnly      # 카운트만 출력

[CmdletBinding()]
param(
  [string]$AnalysisRoot = "C:\Projects\NSCM\Doc\_analysis",
  [string]$FigmaRoot    = "C:\Projects\NSCM\Doc\_figma",
  [switch]$DryRun,
  [switch]$ReportOnly
)

$ErrorActionPreference = "Continue"

function Write-Step($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg){ Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  [FAIL] $msg"  -ForegroundColor Red }

# ----- 0. PRE-CHECK -----
Write-Step "0. PRE-CHECK"
if (-not (Test-Path $AnalysisRoot)) {
  Write-Fail "AnalysisRoot 부재: $AnalysisRoot"
  exit 1
}
Write-OK "AnalysisRoot: $AnalysisRoot"

$ScreensDir = Join-Path $FigmaRoot "screens"
if (-not $DryRun -and -not (Test-Path $ScreensDir)) {
  New-Item -ItemType Directory -Path $ScreensDir -Force | Out-Null
  Write-OK "신규 디렉토리: $ScreensDir"
}

# ----- 1. figma_link.md 검색 -----
Write-Step "1. figma_link.md 검색"
$mdFiles = Get-ChildItem -Path $AnalysisRoot -Filter "figma_link.md" -Recurse -File -ErrorAction SilentlyContinue
Write-OK "발견: $($mdFiles.Count) 건"

if ($ReportOnly) {
  Write-Step "REPORT ONLY 모드"
  $mdFiles | Group-Object { Split-Path (Split-Path $_.FullName -Parent) -Parent | Split-Path -Leaf } |
    Sort-Object Name | ForEach-Object { "  $($_.Name): $($_.Count)" }
  exit 0
}

# ----- 2. 화면 ID 추출 + 이관 -----
Write-Step "2. 이관 (copy)"
$report = @()
$counter = 0
foreach ($md in $mdFiles) {
  $counter++
  # 부모 폴더명이 화면 ID (예: Doc/_analysis/domain_DM/screens/DMF0007/figma_link.md → DMF0007)
  $parentDir = Split-Path $md.FullName -Parent
  $rawFolder = Split-Path $parentDir -Leaf

  # 화면 ID 정규화:
  #   "FP00100_Line.UIL"            → "FP00100_Line"     (마지막 .UIL/.designer 제거)
  #   "DMF0021_SalesPlan - 복사본"   → "DMF0021_SalesPlan" ('-' 뒤 한글 + 공백 제거)
  #   "SSP0301_SqlPopup.designer"   → "SSP0301_SqlPopup"
  $screenId = $rawFolder -replace '\.(UIL|designer|cs|Designer)\s*$', ''
  $screenId = $screenId -replace '\s*-\s*[^A-Za-z0-9_-].*$', ''   # ' - 복사본' 등 한글 접미사 제거
  $screenId = $screenId.Trim()

  # 화면 ID 유효성: 영문/숫자/언더스코어/하이픈만
  if ($screenId -notmatch '^[A-Za-z0-9_-]+$') {
    Write-Warn2 "[$counter/$($mdFiles.Count)] 화면 ID 비정상 ('$rawFolder' → '$screenId'): $($md.FullName)"
    $report += [pscustomobject]@{
      idx=$counter; screenId=$rawFolder; src=$md.FullName; dst=""; status='SKIP_INVALID_ID'
    }
    continue
  }

  $dstPath = Join-Path $ScreensDir "$screenId.md"

  if ($DryRun) {
    Write-Host "  [DRY] $screenId → $dstPath" -ForegroundColor Magenta
    $report += [pscustomobject]@{
      idx=$counter; screenId=$screenId; src=$md.FullName; dst=$dstPath; status='DRY'
    }
    continue
  }

  # 기존 파일 있으면 _v2 등 추가
  $effectiveDst = $dstPath
  $suffix = 2
  while (Test-Path $effectiveDst) {
    $effectiveDst = Join-Path $ScreensDir "${screenId}_v${suffix}.md"
    $suffix++
  }

  Copy-Item $md.FullName $effectiveDst -Force
  $status = 'OK'
  if ($effectiveDst -ne $dstPath) { $status = 'OK_RENAMED' }

  # 원본에 안내 line 추가 (이미 있으면 skip)
  $origContent = Get-Content $md.FullName -Raw -ErrorAction SilentlyContinue
  if ($origContent -and ($origContent -notmatch '진실 source')) {
    $banner = @"
> ⚠️ **이 파일은 이관되었습니다 (2026-05-30).** 진실 source 는 다음 파일입니다:
> ``C:\Projects\NSCM\Doc\_figma\screens\${screenId}.md``
> 본 파일은 분석서 호환성을 위해 유지됨.

"@
    $newContent = $banner + $origContent
    Set-Content $md.FullName -Value $newContent -Encoding utf8
  }

  $report += [pscustomobject]@{
    idx=$counter; screenId=$screenId; src=$md.FullName; dst=$effectiveDst; status=$status
  }

  if ($counter % 50 -eq 0) {
    Write-Host "  ... 진행: $counter / $($mdFiles.Count)"
  }
}

# ----- 3. CSV report -----
Write-Step "3. REPORT"
$reportCsv = Join-Path $FigmaRoot "_migration_report_$(Get-Date -Format 'yyyy-MM-dd_HHmm').csv"
if (-not $DryRun) {
  $report | Export-Csv -Path $reportCsv -NoTypeInformation -Encoding utf8
  Write-OK "Report: $reportCsv"
}

# 통계
$grouped = $report | Group-Object status | Sort-Object Name
foreach ($g in $grouped) {
  Write-Host ("  {0,-20} : {1,5} 건" -f $g.Name, $g.Count)
}
Write-Host ""
Write-Host "총 처리: $($report.Count) / 발견: $($mdFiles.Count)" -ForegroundColor Green

if (-not $DryRun) {
  Write-Host ""
  Write-Host "[다음 단계]" -ForegroundColor Yellow
  Write-Host "  Doc/_figma/screens/ 안에 화면별 Figma 정보 파일이 생성됨."
  Write-Host "  신규 화면 작업 시 해당 파일의 URL/Node ID 를 확인하고"
  Write-Host "  fetch-figma.ps1 -Url <URL> 으로 자동 추출 가능."
}

exit 0
