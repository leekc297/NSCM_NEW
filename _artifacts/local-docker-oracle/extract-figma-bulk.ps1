# NSCM Figma 파일 전체 일괄 추출
#
# 동작:
#   1) 전체 file fetch (depth 무제한)
#   2) page 트리 walk → frame name 파싱 → 화면 ID 추출
#   3) 매핑 표 CSV 작성
#   4) screens/{화면ID}.md 자동 갱신 (Layout 요약 섹션)
#   5) 옵션: 각 frame 의 image batch export
#   6) report 출력
#
# 사용법:
#   .\extract-figma-bulk.ps1 -Url "https://figma.com/design/c9V..."
#   .\extract-figma-bulk.ps1 -Url <URL> -WithImages -ImageFormat svg
#   .\extract-figma-bulk.ps1 -Url <URL> -DryRun
#   .\extract-figma-bulk.ps1 -FileKey c9V... -WithImages
#
# 인증: C:\Projects\NSCM\.figma_token

[CmdletBinding(DefaultParameterSetName='ByUrl')]
param(
  [Parameter(ParameterSetName='ByUrl', Mandatory=$true, Position=0)]
  [string]$Url,

  [Parameter(ParameterSetName='ByKey', Mandatory=$true)]
  [string]$FileKey,

  [string]$TokenFile  = "C:\Projects\NSCM\.figma_token",
  [string]$FigmaRoot  = "C:\Projects\NSCM\Doc\_figma",
  [int]$Depth         = 0,                     # 0 = 무제한 (Figma API 의 depth 미지정 시)
  [switch]$WithImages,
  [string]$ImageFormat = "svg",                # svg / png / jpg / pdf
  [int]$ImageScale     = 1,
  [int]$ImageBatchSize = 50,                   # 한 batch 의 frame 수 (rate limit 회피)
  [switch]$UpdateScreenMd,                     # 기본 OFF (덮어쓰기 위험)
  [switch]$DryRun,
  [switch]$UseCached                           # _full.json 이 있으면 재사용
)

$ErrorActionPreference = "Continue"

function Write-Step($msg)  { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-OK($msg)    { Write-Host "  [OK]   $msg"  -ForegroundColor Green }
function Write-Warn2($msg) { Write-Host "  [WARN] $msg"  -ForegroundColor Yellow }
function Write-Fail($msg)  { Write-Host "  [FAIL] $msg"  -ForegroundColor Red }

# ----- 1. Token + URL 파싱 -----
Write-Step "1. PRE-CHECK"
if (-not (Test-Path $TokenFile)) {
  Write-Fail "$TokenFile 없음 — Personal Access Token 발급 후 저장 필요"
  exit 1
}
$Token = (Get-Content $TokenFile -Raw).Trim()
if ($Token.Length -lt 10) {
  Write-Fail "$TokenFile 내용 비정상 (length=$($Token.Length))"
  exit 1
}
Write-OK "Token: ($($Token.Length) chars)"

if ($PSCmdlet.ParameterSetName -eq 'ByUrl') {
  if ($Url -match '/(?:design|file)/([A-Za-z0-9]+)') {
    $FileKey = $matches[1]
  } else {
    Write-Fail "URL 에서 file_key 추출 실패: $Url"
    exit 2
  }
}
Write-OK "file_key: $FileKey"

$Headers   = @{ "X-Figma-Token" = $Token }
$CacheDir  = Join-Path $FigmaRoot "_api_cache\$FileKey"
$ScreensDir = Join-Path $FigmaRoot "screens"
$ImagesDir = Join-Path $FigmaRoot "_images"
$MappingCsv = Join-Path $FigmaRoot "_figma_screen_mapping.csv"
$FullJsonPath = Join-Path $CacheDir "_full.json"
$ReportPath = Join-Path $FigmaRoot "_extract_report_$(Get-Date -Format 'yyyy-MM-dd_HHmm').csv"

foreach ($d in @($CacheDir, $ScreensDir, $ImagesDir)) {
  if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}

# ----- 2. 전체 file fetch -----
Write-Step "2. 전체 file fetch"
if ($UseCached -and (Test-Path $FullJsonPath)) {
  Write-OK "캐시 재사용: $FullJsonPath ($([math]::Round((Get-Item $FullJsonPath).Length/1KB,1)) KB)"
  $Response = Get-Content $FullJsonPath -Raw | ConvertFrom-Json
} else {
  $Endpoint = "https://api.figma.com/v1/files/$FileKey"
  if ($Depth -gt 0) { $Endpoint += "?depth=$Depth" }
  Write-Host "  [fetch] $Endpoint"
  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  try {
    $Response = Invoke-RestMethod -Uri $Endpoint -Headers $Headers -Method Get -TimeoutSec 120
  } catch {
    Write-Fail "HTTP 호출 실패: $_"
    exit 3
  }
  Write-OK ("응답 수신 ({0:N0}초)" -f $sw.Elapsed.TotalSeconds)

  # 캐시 저장
  $Response | ConvertTo-Json -Depth 100 | Set-Content $FullJsonPath -Encoding utf8
  Write-OK "캐시 저장: $FullJsonPath ($([math]::Round((Get-Item $FullJsonPath).Length/1KB,1)) KB)"
}

Write-Host "  name        : $($Response.name)"
Write-Host "  lastModified: $($Response.lastModified)"

# ----- 3. Page + frame walk -----
Write-Step "3. Page / Frame 트리 walk"

$frames = @()    # collected frames (potential screens)

function Walk-Node {
  param($Node, [string]$PagePath = "")
  if (-not $Node) { return }

  # Page (Canvas)
  if ($Node.type -eq 'CANVAS') {
    foreach ($child in $Node.children) {
      Walk-Node -Node $child -PagePath $Node.name
    }
    return
  }

  # FRAME (top-level screen)
  if ($Node.type -eq 'FRAME' -or $Node.type -eq 'COMPONENT' -or $Node.type -eq 'COMPONENT_SET') {
    $frame = [pscustomobject]@{
      id           = $Node.id
      name         = $Node.name
      type         = $Node.type
      pagePath     = $PagePath
      width        = if ($Node.absoluteBoundingBox) { [int]$Node.absoluteBoundingBox.width } else { 0 }
      height       = if ($Node.absoluteBoundingBox) { [int]$Node.absoluteBoundingBox.height } else { 0 }
      childCount   = if ($Node.children) { $Node.children.Count } else { 0 }
      # screen ID 추출 — frame name 의 시작에 DMF/SYS/COM 등 패턴 매칭
      screenId     = $null
    }
    if ($Node.name -match '^([A-Z]{2,4}\d{4}(?:_\d{2})?)\b') {
      $frame.screenId = $matches[1]
    } elseif ($Node.name -match '\b(DMF|SYS|COM|SCM|SSP|SCP|FP|DM)\d{4}(?:_\d{2})?\b') {
      $frame.screenId = $matches[0]
    }
    $frames += $frame

    # 자식 frame 도 walk (sub-screen 가능성)
    if ($Node.children) {
      foreach ($child in $Node.children) {
        if ($child.type -eq 'FRAME' -or $child.type -eq 'COMPONENT' -or $child.type -eq 'COMPONENT_SET') {
          Walk-Node -Node $child -PagePath "$PagePath > $($Node.name)"
        }
      }
    }
  }
}

Walk-Node -Node $Response.document
Write-OK "수집된 frame: $($frames.Count) 개"

# Page 목록
$pages = $frames | Group-Object pagePath | Sort-Object Name
Write-Host ""
Write-Host "  [Pages]"
foreach ($p in $pages) {
  Write-Host ("    {0,-50} : {1,4} frames" -f $p.Name, $p.Count)
}

# screen ID 매칭된 frame
$mappedFrames = $frames | Where-Object { $_.screenId }
Write-Host ""
Write-Host "  화면 ID 매핑: $($mappedFrames.Count) / $($frames.Count) frame" -ForegroundColor Green

# ----- 4. 매핑 표 CSV -----
Write-Step "4. 매핑 표 CSV"
if (-not $DryRun) {
  $frames | Select-Object screenId, name, pagePath, type, width, height, childCount, id |
    Sort-Object screenId, pagePath, name |
    Export-Csv -Path $MappingCsv -NoTypeInformation -Encoding utf8
  Write-OK "매핑 CSV: $MappingCsv"
}

# ----- 5. screens/{화면ID}.md 자동 갱신 -----
if ($UpdateScreenMd) {
  Write-Step "5. screens/{화면ID}.md 갱신"
  $updated = 0
  $created = 0
  foreach ($f in $mappedFrames) {
    $mdPath = Join-Path $ScreensDir "$($f.screenId).md"

    # node-id 는 URL 인코딩 형태로 변환 (5883:145780 → 5883-145780)
    $urlNodeId = $f.id -replace ':', '-'
    $now = Get-Date -Format "yyyy-MM-dd"

    $newSection = @"
# $($f.screenId) Figma 디자인 정보

> 자동 갱신: $now (extract-figma-bulk.ps1)

## URL
- File   : https://www.figma.com/design/$FileKey/$($Response.name -replace ' ', '-')
- Node   : ?node-id=$urlNodeId
- Page   : $($f.pagePath)
- Frame  : $($f.name)
- Last sync: $now

## Layout 요약 (Figma fetch 결과)
- type        : $($f.type)
- frame size  : $($f.width) x $($f.height)
- child count : $($f.childCount)
- raw node id : $($f.id)

## Cache 위치
- 전체 JSON : Doc/_figma/_api_cache/$FileKey/_full.json
- 매핑 CSV  : Doc/_figma/_figma_screen_mapping.csv

## 변경 이력
- $now : extract-figma-bulk.ps1 자동 갱신
"@

    if ($DryRun) {
      Write-Host "  [DRY] $($f.screenId).md → $mdPath" -ForegroundColor Magenta
    } else {
      if (Test-Path $mdPath) {
        # 기존 파일이 있으면 보존 + 위에 새 섹션 추가 (사용자 작성 내용 보존)
        $existing = Get-Content $mdPath -Raw
        if ($existing -notmatch '자동 갱신: \d{4}-\d{2}-\d{2}') {
          # 신규 자동 섹션 추가
          $newContent = $newSection + "`n`n---`n`n## 기존 내용 (수동 작성)`n`n" + $existing
          Set-Content $mdPath $newContent -Encoding utf8
          $updated++
        } else {
          # 이미 자동 갱신 섹션 있음 — 덮어쓰기
          Set-Content $mdPath $newSection -Encoding utf8
          $updated++
        }
      } else {
        Set-Content $mdPath $newSection -Encoding utf8
        $created++
      }
    }
  }
  Write-OK "신규 생성: $created / 갱신: $updated"
}

# ----- 6. 이미지 batch export -----
if ($WithImages -and $mappedFrames.Count -gt 0) {
  Write-Step "6. 이미지 batch export ($ImageFormat)"
  $batches = [Math]::Ceiling($mappedFrames.Count / $ImageBatchSize)
  Write-Host "  Batch 수: $batches (size=$ImageBatchSize)"

  $downloaded = 0
  $failed     = 0
  for ($i = 0; $i -lt $batches; $i++) {
    $start  = $i * $ImageBatchSize
    $end    = [Math]::Min($start + $ImageBatchSize - 1, $mappedFrames.Count - 1)
    $batchFrames = $mappedFrames[$start..$end]
    $idsParam = ($batchFrames.id | ForEach-Object { [uri]::EscapeDataString($_) }) -join ','

    $ImgEndpoint = "https://api.figma.com/v1/images/$FileKey" +
                   "?ids=$idsParam&format=$ImageFormat&scale=$ImageScale"
    Write-Host ("  [batch {0,3}/{1}] {2} frames..." -f ($i+1), $batches, $batchFrames.Count)
    try {
      $ImgResp = Invoke-RestMethod -Uri $ImgEndpoint -Headers $Headers -Method Get -TimeoutSec 120
      if ($ImgResp.err) {
        Write-Fail "  batch error: $($ImgResp.err)"
        $failed += $batchFrames.Count
        continue
      }
      foreach ($k in $ImgResp.images.PSObject.Properties.Name) {
        $imgUrl = $ImgResp.images.$k
        if (-not $imgUrl) { $failed++; continue }
        $frame = $batchFrames | Where-Object { $_.id -eq $k } | Select-Object -First 1
        $safeName = if ($frame.screenId) { $frame.screenId } else { $k -replace ':', '-' }
        $imgFile = Join-Path $ImagesDir "$safeName.$ImageFormat"
        if (-not $DryRun) {
          Invoke-WebRequest -Uri $imgUrl -OutFile $imgFile -UseBasicParsing -TimeoutSec 60
        }
        $downloaded++
      }
    } catch {
      Write-Fail "  batch 호출 실패: $_"
      $failed += $batchFrames.Count
    }
    # rate limit 보호
    Start-Sleep -Milliseconds 500
  }
  Write-OK "이미지 다운로드: $downloaded / 실패: $failed"
}

# ----- 7. REPORT -----
Write-Step "7. REPORT"
$reportRows = $frames | Select-Object screenId, name, pagePath, type, width, height, childCount,
  @{n='mapped';e={if ($_.screenId) { 'YES' } else { 'NO' }}}
$reportRows | Export-Csv -Path $ReportPath -NoTypeInformation -Encoding utf8

$mappedCount = ($mappedFrames | Measure-Object).Count
$unmappedCount = ($frames | Where-Object { -not $_.screenId } | Measure-Object).Count

Write-Host ""
Write-Host "=== 최종 보고 ===" -ForegroundColor Green
Write-Host ("  Figma file       : {0}" -f $Response.name)
Write-Host ("  Pages            : {0}" -f $pages.Count)
Write-Host ("  Frames           : {0}" -f $frames.Count)
Write-Host ("  화면 ID 매핑     : {0,5} ({1:N1}%)" -f $mappedCount, ($mappedCount/$frames.Count*100))
Write-Host ("  미매핑 frame     : {0,5} (수동 매핑 필요)" -f $unmappedCount)
Write-Host ("  매핑 CSV         : {0}" -f $MappingCsv)
Write-Host ("  Report           : {0}" -f $ReportPath)
if ($UpdateScreenMd) {
  Write-Host ("  screens/{{화면ID}}.md : $created 신규 / $updated 갱신")
}
if ($WithImages) {
  Write-Host ("  Images ({0}) : $downloaded 건 ($ImagesDir)" -f $ImageFormat)
}

exit 0
