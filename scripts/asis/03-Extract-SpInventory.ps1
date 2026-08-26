<#
.SYNOPSIS
    AS-IS MS SQL Server 오브젝트 전수 추출 (read-only). SP/함수/뷰 정의를 파일로 떨어뜨립니다.
.DESCRIPTION
    sys.sql_modules 기반이라 SSMS 스크립팅보다 빠르고 누락이 없습니다.
    접속 정보는 파라미터로만 받으며 스크립트에 하드코딩하지 않습니다.
    실행하는 SQL 은 전부 SELECT 입니다. DB를 변경하지 않습니다.

    산출물:
      doc/asis/sp-inventory.csv     : 오브젝트 1건당 1행 (정의 길이, 파라미터, 파일경로)
      doc/asis/sp-params.csv        : 파라미터 상세
      doc/asis/sp-dependencies.csv  : 오브젝트 간 참조관계 (sys.sql_expression_dependencies)
      doc/asis/sp/<schema>.<name>.sql : 정의 원문

    Windows PowerShell 5.1 실행을 권장합니다 (System.Data.SqlClient 기본 제공).
.EXAMPLE
    # Windows 인증
    .\03-Extract-SpInventory.ps1 -Server localhost -Database GSCM -IntegratedSecurity
.EXAMPLE
    # SQL 인증 (실행 시 비밀번호를 물어봅니다)
    .\03-Extract-SpInventory.ps1 -Server 10.0.0.5 -Database GSCM -Credential (Get-Credential sa)
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Server,
    [Parameter(Mandatory)][string]$Database,
    [switch]$IntegratedSecurity,
    [System.Management.Automation.PSCredential]$Credential,
    [string]$DocRoot,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'asis-config.psd1'),
    [int]$CommandTimeoutSec = 600,
    [switch]$TrustServerCertificate
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot 'lib\AsisCommon.psm1') -Force

$cfg = Import-AsisConfig -Path $ConfigPath
if (-not $DocRoot) { $DocRoot = $cfg.DocRoot }
$outDir = Join-Path $DocRoot 'asis'
$sqlDir = Join-Path $outDir 'sp'

Write-AsisBanner "AS-IS MSSQL 오브젝트 추출  |  $Server / $Database"

if (-not $IntegratedSecurity -and -not $Credential) {
    throw "-IntegratedSecurity 또는 -Credential 중 하나는 필요합니다."
}

# -------------------------------------------------------------------------
# SqlClient 확보
# -------------------------------------------------------------------------
$sqlClientOk = $false
try { Add-Type -AssemblyName System.Data -ErrorAction Stop } catch { }
if ([System.Type]::GetType('System.Data.SqlClient.SqlConnection, System.Data')) { $sqlClientOk = $true }
if (-not $sqlClientOk) {
    try {
        [void][System.Reflection.Assembly]::LoadWithPartialName('System.Data')
        if ([System.Type]::GetType('System.Data.SqlClient.SqlConnection, System.Data')) { $sqlClientOk = $true }
    } catch { }
}
if (-not $sqlClientOk) {
    throw @"
System.Data.SqlClient 를 로드할 수 없습니다.
→ Windows PowerShell 5.1 에서 실행하세요:
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath" -Server $Server -Database $Database $(if($IntegratedSecurity){'-IntegratedSecurity'})
"@
}

# -------------------------------------------------------------------------
# 접속 문자열
# -------------------------------------------------------------------------
$csb = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
$csb['Data Source']     = $Server
$csb['Initial Catalog'] = $Database
$csb['Application Name'] = 'NSCM-AsisIndex'
$csb['Connect Timeout'] = 30
if ($IntegratedSecurity) {
    $csb['Integrated Security'] = $true
} else {
    $csb['User ID']  = $Credential.UserName
    $csb['Password'] = $Credential.GetNetworkCredential().Password
}
if ($TrustServerCertificate) {
    try { $csb['TrustServerCertificate'] = $true } catch { }
}

function Invoke-AsisQuery {
    param([Parameter(Mandatory)][string]$Query)
    $conn = New-Object System.Data.SqlClient.SqlConnection($csb.ConnectionString)
    try {
        $conn.Open()
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $Query
        $cmd.CommandTimeout = $CommandTimeoutSec
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
        $ds = New-Object System.Data.DataSet
        [void]$adapter.Fill($ds)
        if ($ds.Tables.Count -eq 0) { return @() }
        return @($ds.Tables[0].Rows)
    } finally {
        if ($conn.State -ne 'Closed') { $conn.Close() }
        $conn.Dispose()
    }
}

# -------------------------------------------------------------------------
# 1. 오브젝트 정의
# -------------------------------------------------------------------------
$typeList = ($cfg.SqlObjectType | ForEach-Object { "'" + ($_ -replace "'", "''") + "'" }) -join ','

Write-Host '[1/4] 오브젝트 정의 조회...' -ForegroundColor Yellow
$qObjects = @"
SELECT  s.name              AS schema_name,
        o.name              AS object_name,
        o.type              AS object_type,
        o.type_desc         AS object_type_desc,
        o.create_date       AS create_date,
        o.modify_date       AS modify_date,
        CASE WHEN m.definition IS NULL THEN 1 ELSE 0 END AS is_encrypted,
        m.definition        AS definition
FROM    sys.objects o
        INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
        LEFT  JOIN sys.sql_modules m ON m.object_id = o.object_id
WHERE   o.type IN ($typeList)
        AND o.is_ms_shipped = 0
ORDER BY s.name, o.name;
"@

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$objects = Invoke-AsisQuery -Query $qObjects
Write-Host ("      {0:N0}건 ({1:N1}s)" -f $objects.Count, $sw.Elapsed.TotalSeconds)

if (-not (Test-Path -LiteralPath $sqlDir)) { [void](New-Item -ItemType Directory -Force -Path $sqlDir) }

$invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
$inventory = New-Object System.Collections.ArrayList
$encrypted = 0
$utf8Bom = New-Object System.Text.UTF8Encoding($true)

foreach ($r in $objects) {
    $schemaName = [string]$r['schema_name']
    $objectName = [string]$r['object_name']
    $fullName   = "$schemaName.$objectName"

    $safe = $fullName
    foreach ($c in $invalidChars) { $safe = $safe.Replace($c, '_') }
    $sqlFile = Join-Path $sqlDir ($safe + '.sql')

    $isEnc = ([int]$r['is_encrypted'] -eq 1)
    $def = ''
    if (-not $isEnc -and $r['definition'] -isnot [System.DBNull]) { $def = [string]$r['definition'] }

    if ($isEnc) {
        $encrypted++
        $relFile = ''
        $lineCount = 0
        $charLen = 0
    } else {
        [System.IO.File]::WriteAllText($sqlFile, $def, $utf8Bom)
        $relFile = "doc/asis/sp/$safe.sql"
        $lineCount = @($def -split "`r`n|`n|`r").Count
        $charLen = $def.Length
    }

    [void]$inventory.Add([pscustomobject]@{
        schema_name  = $schemaName
        object_name  = $objectName
        full_name    = $fullName
        object_type  = [string]$r['object_type']
        type_desc    = [string]$r['object_type_desc']
        create_date  = ([datetime]$r['create_date']).ToString('yyyy-MM-dd HH:mm:ss')
        modify_date  = ([datetime]$r['modify_date']).ToString('yyyy-MM-dd HH:mm:ss')
        is_encrypted = $(if ($isEnc) { 1 } else { 0 })
        line_count   = $lineCount
        char_length  = $charLen
        sql_file     = $relFile
    })
}

Write-AsisCsv -Data $inventory -Path (Join-Path $outDir 'sp-inventory.csv') `
    -Header @('schema_name','object_name','full_name','object_type','type_desc','create_date','modify_date','is_encrypted','line_count','char_length','sql_file')

if ($encrypted -gt 0) {
    Write-Warning "WITH ENCRYPTION 오브젝트 $encrypted 건 — 정의를 가져올 수 없습니다. sp-inventory.csv 의 is_encrypted=1 행 확인"
}

# -------------------------------------------------------------------------
# 2. 파라미터
# -------------------------------------------------------------------------
Write-Host '[2/4] 파라미터 조회...' -ForegroundColor Yellow
$qParams = @"
SELECT  s.name AS schema_name,
        o.name AS object_name,
        p.parameter_id,
        p.name AS param_name,
        t.name AS type_name,
        p.max_length,
        p.precision,
        p.scale,
        p.is_output,
        p.has_default_value
FROM    sys.parameters p
        INNER JOIN sys.objects o ON o.object_id = p.object_id
        INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
        LEFT  JOIN sys.types   t ON t.user_type_id = p.user_type_id
WHERE   o.type IN ($typeList)
        AND o.is_ms_shipped = 0
ORDER BY s.name, o.name, p.parameter_id;
"@
$paramRows = Invoke-AsisQuery -Query $qParams
$params = foreach ($r in $paramRows) {
    [pscustomobject]@{
        full_name        = "$([string]$r['schema_name']).$([string]$r['object_name'])"
        parameter_id     = [int]$r['parameter_id']
        param_name       = [string]$r['param_name']
        type_name        = [string]$r['type_name']
        max_length       = [int]$r['max_length']
        precision        = [int]$r['precision']
        scale            = [int]$r['scale']
        is_output        = [int]$r['is_output']
        has_default      = [int]$r['has_default_value']
    }
}
Write-AsisCsv -Data $params -Path (Join-Path $outDir 'sp-params.csv') `
    -Header @('full_name','parameter_id','param_name','type_name','max_length','precision','scale','is_output','has_default')

# -------------------------------------------------------------------------
# 3. 참조 관계
# -------------------------------------------------------------------------
Write-Host '[3/4] 참조 관계 조회...' -ForegroundColor Yellow
$deps = @()
try {
    $qDeps = @"
SELECT  s.name  AS schema_name,
        o.name  AS object_name,
        d.referenced_schema_name AS ref_schema,
        d.referenced_entity_name AS ref_name,
        ISNULL(ro.type_desc, 'UNRESOLVED') AS ref_type
FROM    sys.sql_expression_dependencies d
        INNER JOIN sys.objects o ON o.object_id = d.referencing_id
        INNER JOIN sys.schemas s ON s.schema_id = o.schema_id
        LEFT  JOIN sys.objects ro ON ro.object_id = d.referenced_id
WHERE   o.type IN ($typeList)
        AND o.is_ms_shipped = 0
ORDER BY s.name, o.name, d.referenced_entity_name;
"@
    $depRows = Invoke-AsisQuery -Query $qDeps
    $deps = foreach ($r in $depRows) {
        [pscustomobject]@{
            full_name  = "$([string]$r['schema_name']).$([string]$r['object_name'])"
            ref_schema = $(if ($r['ref_schema'] -is [System.DBNull]) { '' } else { [string]$r['ref_schema'] })
            ref_name   = [string]$r['ref_name']
            ref_type   = [string]$r['ref_type']
        }
    }
} catch {
    Write-Warning "참조 관계 조회 실패(권한 부족 가능): $($_.Exception.Message)"
}
Write-AsisCsv -Data $deps -Path (Join-Path $outDir 'sp-dependencies.csv') `
    -Header @('full_name','ref_schema','ref_name','ref_type')

# -------------------------------------------------------------------------
# 4. 요약
# -------------------------------------------------------------------------
Write-Host '[4/4] 요약' -ForegroundColor Yellow
$byType = $inventory | Group-Object type_desc | Sort-Object Count -Descending
Write-Host ''
foreach ($g in $byType) { Write-Host ("    {0,-24} {1,6}" -f $g.Name, $g.Count) }
Write-Host ''
Write-Host ("  총 {0:N0}건 / 정의 파일 {1}" -f $inventory.Count, $sqlDir)
Write-Host ''
Write-Host "다음 단계: 02-Scan-Sources.ps1 을 -SpNameListPath 와 함께 다시 돌리면" -ForegroundColor Cyan
Write-Host "화면-SP 연결이 명명규칙 추측 없이 정확해집니다." -ForegroundColor Cyan
Write-Host ("  .\02-Scan-Sources.ps1 -SpNameListPath `"{0}`"" -f (Join-Path $outDir 'sp-inventory.csv')) -ForegroundColor Cyan
Write-Host ''
Write-Host '완료.' -ForegroundColor Green
