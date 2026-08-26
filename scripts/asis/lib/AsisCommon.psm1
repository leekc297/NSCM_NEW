<#
.SYNOPSIS
    NSCM AS-IS 인덱싱 공용 라이브러리
.DESCRIPTION
    Windows PowerShell 5.1 및 PowerShell 7+ 양쪽에서 동작합니다.
    한글 소스(CP949/UTF-8) 인코딩 자동 판별, 파일 열거, CSV 출력을 담당합니다.
.NOTES
    이 모듈은 AS-IS 소스를 읽기만 합니다. 어떤 경우에도 원본을 수정하지 않습니다.
#>

Set-StrictMode -Version 2.0

# ---------------------------------------------------------------------------
# 인코딩 처리
# ---------------------------------------------------------------------------

$script:Cp949 = $null
try {
    # PowerShell 7 / .NET Core 에서는 CodePagesEncodingProvider 등록이 필요합니다.
    [System.Text.Encoding]::RegisterProvider([System.Text.CodePagesEncodingProvider]::Instance)
} catch {
    # .NET Framework(PS 5.1)에서는 RegisterProvider 가 없거나 이미 등록되어 있습니다. 무시.
}
try   { $script:Cp949 = [System.Text.Encoding]::GetEncoding(949) }
catch { $script:Cp949 = [System.Text.Encoding]::Default }

$script:Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Get-AsisEncoding {
    <#
    .SYNOPSIS
        BOM을 검사해 파일 인코딩을 판별합니다. BOM이 없으면 UTF-8 유효성을 검사하고,
        실패하면 CP949(한국어 ANSI)로 간주합니다.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][byte[]]$Bytes)

    if ($Bytes.Length -ge 3 -and $Bytes[0] -eq 0xEF -and $Bytes[1] -eq 0xBB -and $Bytes[2] -eq 0xBF) {
        return [System.Text.Encoding]::UTF8
    }
    if ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) {
        return [System.Text.Encoding]::Unicode
    }
    if ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFE -and $Bytes[1] -eq 0xFF) {
        return [System.Text.Encoding]::BigEndianUnicode
    }

    # BOM 없음: 엄격한 UTF-8 디코딩을 시도한다. 실패하면 CP949.
    try {
        $strict = New-Object System.Text.UTF8Encoding($false, $true)
        [void]$strict.GetString($Bytes)
        return $strict
    } catch {
        return $script:Cp949
    }
}

function Read-AsisText {
    <#
    .SYNOPSIS
        인코딩을 자동 판별해 파일 전체를 문자열로 읽습니다. 실패 시 $null 반환.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [int]$MaxSizeKB = 8192
    )

    try {
        $fi = New-Object System.IO.FileInfo($Path)
        if ($fi.Length -gt ($MaxSizeKB * 1KB)) {
            Write-Verbose "SKIP (too large, $([math]::Round($fi.Length/1MB,1))MB): $Path"
            return $null
        }
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        if ($bytes.Length -eq 0) { return '' }
        $enc = Get-AsisEncoding -Bytes $bytes
        return $enc.GetString($bytes)
    } catch {
        Write-Warning "READ FAIL: $Path -- $($_.Exception.Message)"
        return $null
    }
}

function Read-AsisLines {
    <#
    .SYNOPSIS
        Read-AsisText 의 라인 배열 버전. 라인번호가 필요한 스캔에 사용합니다.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [int]$MaxSizeKB = 8192
    )
    $text = Read-AsisText -Path $Path -MaxSizeKB $MaxSizeKB
    if ($null -eq $text) { return $null }
    return $text -split "`r`n|`n|`r"
}

# ---------------------------------------------------------------------------
# 파일 열거
# ---------------------------------------------------------------------------

function Get-AsisFiles {
    <#
    .SYNOPSIS
        AS-IS 루트 아래에서 대상 확장자 파일을 열거합니다. 빌드 산출물 폴더는 제외합니다.
    .OUTPUTS
        System.IO.FileInfo
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Root,
        [string[]]$Extension = @('.cs'),
        [string[]]$ExcludeDirectory = @('bin','obj','.vs','.git','packages','TestResults','node_modules','_ReSharper','Debug','Release')
    )

    if (-not (Test-Path -LiteralPath $Root)) {
        throw "AS-IS 루트를 찾을 수 없습니다: $Root"
    }

    $extSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($e in $Extension) { [void]$extSet.Add($e) }

    # 경로 세그먼트 단위 제외 (부분 문자열 오탐 방지)
    $excludeSet = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($d in $ExcludeDirectory) { [void]$excludeSet.Add($d) }

    $rootFull = (Resolve-Path -LiteralPath $Root).ProviderPath.TrimEnd('\','/')

    Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object {
            if (-not $extSet.Contains($_.Extension)) { return $false }
            $rel = $_.FullName.Substring($rootFull.Length).TrimStart('\','/')
            $segments = $rel -split '[\\/]'
            # 마지막 세그먼트는 파일명이므로 제외 검사 대상이 아님
            for ($i = 0; $i -lt $segments.Length - 1; $i++) {
                if ($excludeSet.Contains($segments[$i])) { return $false }
            }
            return $true
        }
}

function Get-AsisRelativePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$FullPath,
        [Parameter(Mandatory)][string]$Root
    )
    $rootFull = (Resolve-Path -LiteralPath $Root).ProviderPath.TrimEnd('\','/')
    if ($FullPath.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase)) {
        return $FullPath.Substring($rootFull.Length).TrimStart('\','/')
    }
    return $FullPath
}

# ---------------------------------------------------------------------------
# 출력
# ---------------------------------------------------------------------------

function Write-AsisCsv {
    <#
    .SYNOPSIS
        UTF-8 BOM CSV로 저장합니다. (Excel에서 한글이 깨지지 않도록 BOM 필수)
        레코드가 0건이어도 헤더만 있는 빈 파일을 남겨 후속 스크립트가 실패하지 않게 합니다.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Data,
        [Parameter(Mandatory)][string]$Path,
        [string[]]$Header
    )

    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        [void](New-Item -ItemType Directory -Force -Path $dir)
    }

    $rows = @($Data)
    if ($rows.Count -eq 0) {
        if (-not $Header -or $Header.Count -eq 0) {
            throw "Write-AsisCsv: 데이터가 0건이면 -Header 가 필요합니다. ($Path)"
        }
        $line = ($Header | ForEach-Object { '"' + ($_ -replace '"','""') + '"' }) -join ','
        [System.IO.File]::WriteAllText($Path, $line + "`r`n", (New-Object System.Text.UTF8Encoding($true)))
    } else {
        $csv = $rows | ConvertTo-Csv -NoTypeInformation
        [System.IO.File]::WriteAllText($Path, ($csv -join "`r`n") + "`r`n", (New-Object System.Text.UTF8Encoding($true)))
    }
    Write-Host ("  [OUT] {0}  ({1} rows)" -f $Path, $rows.Count) -ForegroundColor DarkGray
}

function Write-AsisText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Path,
        [switch]$Bom
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        [void](New-Item -ItemType Directory -Force -Path $dir)
    }
    $enc = if ($Bom) { New-Object System.Text.UTF8Encoding($true) } else { $script:Utf8NoBom }
    [System.IO.File]::WriteAllText($Path, $Content, $enc)
    Write-Host ("  [OUT] {0}" -f $Path) -ForegroundColor DarkGray
}

function Import-AsisCsv {
    <#
    .SYNOPSIS
        UTF-8(BOM 포함) CSV를 읽습니다. 파일이 없으면 빈 배열.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return @() }
    return @(Import-Csv -LiteralPath $Path -Encoding UTF8)
}

# ---------------------------------------------------------------------------
# 해시 / 화면ID
# ---------------------------------------------------------------------------

function Get-AsisSha256 {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)
    try {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
    } catch {
        return ''
    }
}

function Resolve-AsisScreenId {
    <#
    .SYNOPSIS
        파일명 → 폴더명 순으로 화면ID를 추출합니다. 못 찾으면 빈 문자열.
    .PARAMETER Pattern
        named group 'id' 를 포함한 정규식. 예: '(?<id>[A-Z]{2,5}\d{3,5})'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$FullPath,
        [Parameter(Mandatory)][string]$Pattern
    )

    $rx = New-Object System.Text.RegularExpressions.Regex(
        $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $leaf = [System.IO.Path]::GetFileNameWithoutExtension($FullPath)
    $m = $rx.Match($leaf)
    if ($m.Success) { return $m.Groups['id'].Value.ToUpperInvariant() }

    # 파일명에 없으면 상위 폴더명에서 (가까운 쪽부터)
    $dir = Split-Path -Parent $FullPath
    while ($dir) {
        $name = Split-Path -Leaf $dir
        if (-not $name) { break }
        $m = $rx.Match($name)
        if ($m.Success) { return $m.Groups['id'].Value.ToUpperInvariant() }
        $parent = Split-Path -Parent $dir
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    return ''
}

function Resolve-AsisLayer {
    <#
    .SYNOPSIS
        경로/파일명 토큰으로 UIL/WSL/BIZ/DAC 레이어를 판정합니다.
    .PARAMETER LayerToken
        @{ UIL = @('UIL','UI','Form'); WSL = @('WSL','Service'); BIZ = @('BIZ','Business') } 형태
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$FullPath,
        [Parameter(Mandatory)][hashtable]$LayerToken
    )

    $leaf = [System.IO.Path]::GetFileNameWithoutExtension($FullPath)
    $segments = @($FullPath -split '[\\/]')

    # 1) 파일명 토큰 우선 (예: DMF0043_UIL.cs, UIL_DMF0043.cs)
    foreach ($layer in $LayerToken.Keys) {
        foreach ($token in $LayerToken[$layer]) {
            if ($leaf -match "(^|[_\.\-])$([regex]::Escape($token))($|[_\.\-])") { return $layer }
        }
    }
    # 2) 폴더 세그먼트 (하위 → 상위 순으로 가까운 것을 우선)
    for ($i = $segments.Length - 2; $i -ge 0; $i--) {
        foreach ($layer in $LayerToken.Keys) {
            foreach ($token in $LayerToken[$layer]) {
                if ($segments[$i] -ieq $token) { return $layer }
            }
        }
    }
    # 3) 파일명 접미/접두 포함 (느슨한 매칭, 마지막 수단)
    foreach ($layer in $LayerToken.Keys) {
        foreach ($token in $LayerToken[$layer]) {
            if ($leaf -match [regex]::Escape($token)) { return $layer }
        }
    }
    return 'ETC'
}

function Resolve-AsisDomain {
    <#
    .SYNOPSIS
        화면ID 접두사로 도메인(DM/SCP 등)을 판정합니다.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$ScreenId,
        [Parameter(Mandatory)][hashtable]$DomainPrefix
    )
    if ([string]::IsNullOrWhiteSpace($ScreenId)) { return 'UNKNOWN' }
    foreach ($domain in $DomainPrefix.Keys) {
        foreach ($prefix in $DomainPrefix[$domain]) {
            if ($ScreenId.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { return $domain }
        }
    }
    return 'UNKNOWN'
}

function Import-AsisConfig {
    <#
    .SYNOPSIS
        asis-config.psd1 를 로드합니다.
    #>
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "설정 파일을 찾을 수 없습니다: $Path"
    }
    return Import-PowerShellDataFile -LiteralPath $Path
}

function Write-AsisBanner {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Title)
    Write-Host ''
    Write-Host ("=" * 72) -ForegroundColor Cyan
    Write-Host ("  $Title") -ForegroundColor Cyan
    Write-Host ("=" * 72) -ForegroundColor Cyan
}

Export-ModuleMember -Function `
    Get-AsisEncoding, Read-AsisText, Read-AsisLines, Get-AsisFiles, Get-AsisRelativePath, `
    Write-AsisCsv, Write-AsisText, Import-AsisCsv, Get-AsisSha256, `
    Resolve-AsisScreenId, Resolve-AsisLayer, Resolve-AsisDomain, Import-AsisConfig, Write-AsisBanner
