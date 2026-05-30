# NSCM Figma REST API fetch + 정리
#
# 사용법:
#   .\fetch-figma.ps1 -Url "https://www.figma.com/design/c9V.../node-id=5883-145780"
#   .\fetch-figma.ps1 -Url <URL> -OutFile temp.json
#   .\fetch-figma.ps1 -FileKey c9VYF8oleb9TczKeFWi4ka -NodeId "5883:145780"
#   .\fetch-figma.ps1 -Url <URL> -Minimal       # 이름/크기만 추출
#   .\fetch-figma.ps1 -Url <URL> -ImageExport   # 이미지 export URL 받기
#
# 인증:
#   C:\Projects\NSCM\.figma_token (1줄 token)
#
# Exit codes:
#   0 = OK
#   1 = .figma_token 없음
#   2 = URL 파싱 실패
#   3 = HTTP 4xx/5xx
#   4 = JSON 파싱 실패

[CmdletBinding(DefaultParameterSetName='ByUrl')]
param(
  [Parameter(ParameterSetName='ByUrl', Mandatory=$true, Position=0)]
  [string]$Url,

  [Parameter(ParameterSetName='ByKey', Mandatory=$true)]
  [string]$FileKey,

  [Parameter(ParameterSetName='ByKey')]
  [string]$NodeId = "",

  [string]$OutFile = "",
  [string]$TokenFile = "C:\Projects\NSCM\.figma_token",
  [int]$Depth = 5,
  [switch]$Minimal,
  [switch]$ImageExport,
  [string]$ImageFormat = "png",  # png / svg / jpg / pdf
  [int]$ImageScale = 1
)

$ErrorActionPreference = "Continue"

# ----- 1. Token -----
if (-not (Test-Path $TokenFile)) {
  Write-Host "ERROR: $TokenFile 없음" -ForegroundColor Red
  Write-Host "  1) https://www.figma.com/settings 접속" -ForegroundColor Yellow
  Write-Host "  2) Personal access tokens → Generate new token (scope: File content Read)" -ForegroundColor Yellow
  Write-Host "  3) `"figd_XXXX...`" | Out-File -FilePath $TokenFile -NoNewline -Encoding ascii" -ForegroundColor Yellow
  exit 1
}
$Token = (Get-Content $TokenFile -Raw).Trim()
if ($Token.Length -lt 10) {
  Write-Host "ERROR: $TokenFile 내용이 비정상 (length=$($Token.Length))" -ForegroundColor Red
  exit 1
}

# ----- 2. URL 파싱 -----
if ($PSCmdlet.ParameterSetName -eq 'ByUrl') {
  if ($Url -match '/(?:design|file)/([A-Za-z0-9]+)') {
    $FileKey = $matches[1]
  } else {
    Write-Host "ERROR: URL 에서 file_key 추출 실패: $Url" -ForegroundColor Red
    exit 2
  }
  if ($Url -match 'node-id=([^&]+)') {
    $NodeId = $matches[1]
  } else {
    $NodeId = ""
  }
}

# Figma node-id 는 URL 에서 "5883-145780" 형태로 인코딩됨. API 호출 시는 콜론 "5883:145780".
$ApiNodeId = $NodeId -replace '-', ':'

# ----- 3. API 호출 -----
$Headers = @{ "X-Figma-Token" = $Token }
$Endpoint = "https://api.figma.com/v1/files/$FileKey"
if ($ApiNodeId) {
  $Endpoint += "?ids=$([uri]::EscapeDataString($ApiNodeId))&depth=$Depth&geometry=paths"
} else {
  $Endpoint += "?depth=$Depth"
}

Write-Host "[fetch] $Endpoint" -ForegroundColor Cyan

try {
  $Response = Invoke-RestMethod -Uri $Endpoint -Headers $Headers -Method Get -TimeoutSec 60
} catch {
  Write-Host "ERROR: HTTP 호출 실패 — $_" -ForegroundColor Red
  exit 3
}

# ----- 4. 응답 정리 -----
function Summarize-Node {
  param($Node, [int]$Indent = 0, [int]$MaxDepth = 4)
  if (-not $Node) { return @() }
  if ($Indent -gt $MaxDepth) { return @() }
  $pad = "  " * $Indent
  $line = "$pad- [$($Node.type)] $($Node.name)"
  if ($Node.absoluteBoundingBox) {
    $bb = $Node.absoluteBoundingBox
    $line += "  ({0:N0}x{1:N0})" -f $bb.width, $bb.height
  }
  if ($Node.characters) {
    $text = ($Node.characters -replace "`n", " ").Substring(0, [Math]::Min(50, $Node.characters.Length))
    $line += "  text=`"$text`""
  }
  $out = @($line)
  if ($Node.children) {
    foreach ($child in $Node.children) {
      $out += (Summarize-Node -Node $child -Indent ($Indent + 1) -MaxDepth $MaxDepth)
    }
  }
  return $out
}

Write-Host ""
Write-Host "=== Figma File ===" -ForegroundColor Green
Write-Host "  name        : $($Response.name)"
Write-Host "  lastModified: $($Response.lastModified)"
Write-Host "  version     : $($Response.version)"
if ($Response.editorType) { Write-Host "  editorType  : $($Response.editorType)" }

if ($Minimal) {
  if ($OutFile) {
    @{
      file_key = $FileKey
      node_id = $NodeId
      name = $Response.name
      lastModified = $Response.lastModified
    } | ConvertTo-Json | Set-Content $OutFile -Encoding utf8
    Write-Host "  saved (minimal): $OutFile"
  }
  exit 0
}

# 전체 JSON 저장
if ($OutFile) {
  $OutDir = Split-Path $OutFile -Parent
  if ($OutDir -and -not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
  }
  $Response | ConvertTo-Json -Depth 100 | Set-Content $OutFile -Encoding utf8
  $bytes = (Get-Item $OutFile).Length
  Write-Host "  saved       : $OutFile ($([math]::Round($bytes/1KB, 1)) KB)" -ForegroundColor Green
}

# 노드 트리 출력
Write-Host ""
Write-Host "=== Node tree (depth <= 4) ===" -ForegroundColor Green
if ($Response.nodes) {
  # 특정 node 요청한 경우 — Response.nodes 가 dict
  foreach ($key in $Response.nodes.PSObject.Properties.Name) {
    $nodeEntry = $Response.nodes.$key.document
    Summarize-Node -Node $nodeEntry | ForEach-Object { Write-Host $_ }
  }
} elseif ($Response.document) {
  Summarize-Node -Node $Response.document | ForEach-Object { Write-Host $_ }
}

# Components / Styles
if ($Response.components -and ($Response.components.PSObject.Properties.Name.Count -gt 0)) {
  Write-Host ""
  Write-Host "=== Components ($($Response.components.PSObject.Properties.Name.Count)) ===" -ForegroundColor Green
  foreach ($cid in ($Response.components.PSObject.Properties.Name | Select-Object -First 20)) {
    Write-Host "  $cid : $($Response.components.$cid.name)"
  }
}
if ($Response.styles -and ($Response.styles.PSObject.Properties.Name.Count -gt 0)) {
  Write-Host ""
  Write-Host "=== Styles ($($Response.styles.PSObject.Properties.Name.Count)) ===" -ForegroundColor Green
  foreach ($sid in ($Response.styles.PSObject.Properties.Name | Select-Object -First 10)) {
    $s = $Response.styles.$sid
    Write-Host "  [$($s.styleType)] $($s.name)"
  }
}

# ----- 5. Image export (옵션) -----
if ($ImageExport -and $NodeId) {
  Write-Host ""
  Write-Host "=== Image export ===" -ForegroundColor Green
  $ImgEndpoint = "https://api.figma.com/v1/images/$FileKey" +
                 "?ids=$([uri]::EscapeDataString($ApiNodeId))" +
                 "&format=$ImageFormat&scale=$ImageScale"
  try {
    $ImgResp = Invoke-RestMethod -Uri $ImgEndpoint -Headers $Headers -Method Get
    if ($ImgResp.err) {
      Write-Host "  ERROR: $($ImgResp.err)" -ForegroundColor Red
    } else {
      foreach ($k in $ImgResp.images.PSObject.Properties.Name) {
        $imgUrl = $ImgResp.images.$k
        Write-Host "  [$k] $imgUrl"
        if ($OutFile) {
          $ImgFile = [System.IO.Path]::ChangeExtension($OutFile, ".$ImageFormat")
          Invoke-WebRequest -Uri $imgUrl -OutFile $ImgFile -UseBasicParsing
          Write-Host "  downloaded: $ImgFile" -ForegroundColor Green
        }
      }
    }
  } catch {
    Write-Host "  ERROR: image export 실패 — $_" -ForegroundColor Red
  }
}

exit 0
