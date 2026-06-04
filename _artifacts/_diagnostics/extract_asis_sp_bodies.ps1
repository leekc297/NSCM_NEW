# Extract 19 AS-IS SP bodies for SCM0005/0008/0009 → TO-BE conversion
# Output: _artifacts/_diagnostics/asis_sp_bodies/{SP_NAME}.sql
# 2026-06-04

$envPath = 'C:\Projects\NSCM\.env.asis'
Get-Content $envPath | ForEach-Object {
    if ($_ -match '^([A-Z_]+)=(.+)$') { Set-Variable -Name $matches[1] -Value $matches[2] }
}

$outDir = 'C:\Projects\NSCM\_artifacts\_diagnostics\asis_sp_bodies'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$spList = @(
    # SCM0009 (3 TO-BE → 2 unique AS-IS, Approve/Reject share)
    'UP_FX_GetApprovalAuthRequest',
    'UP_FX_SaveApprovalAuthRequest',

    # SCM0008 (7 TO-BE → 7 AS-IS)
    'UP_FX_GetReqAuthCurrentUser',
    'UP_FX_GetReqAuthGroupInfo',
    'UP_FX_GetReqAuthMyListAdded',
    'UP_FX_GetNewUserAuthRequestList',
    'UP_FX_SaveReqAuthAddMyList',
    'UP_FX_DeleteReqAuthAddedMyList',
    'UP_FX_SaveReqAuthRequestMyList',

    # SCM0005 (9 TO-BE → likely 9 AS-IS, history TBD)
    'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST',
    'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2',
    'PR_DM_ADM_DQ_EXECUTE_HIST',
    'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS',
    'DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS',
    'PR_DM_ADM_DQ_CREATE',
    'PR_DM_ADM_DQ_CREATE_USER_GROUP',
    'PR_DM_ADM_DQ_CREATE_COLUMN',
    'PR_DM_ADM_DQ_CREATE_PARAMETER'
)

$conn = "Server=$ASIS_DB_HOST,$ASIS_DB_PORT;Database=$ASIS_DB_NAME;User Id=$ASIS_DB_USER;Password=$ASIS_DB_PASS;Connect Timeout=10;TrustServerCertificate=True"
Add-Type -AssemblyName System.Data
$c = New-Object System.Data.SqlClient.SqlConnection $conn
$c.Open()

$summary = @()
foreach ($sp in $spList) {
    $cmd = $c.CreateCommand()
    $cmd.CommandText = "SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.$sp')) AS sql_text"
    $r = $cmd.ExecuteScalar()
    $outFile = Join-Path $outDir "$sp.sql"
    if ($r -and $r -ne [System.DBNull]::Value) {
        $r | Out-File -FilePath $outFile -Encoding utf8
        $len = $r.Length
        $lineCount = ($r -split "`n").Count
        $summary += "$sp`t$len bytes`t$lineCount lines"
    } else {
        "-- NOT FOUND in AS-IS DB" | Out-File -FilePath $outFile -Encoding utf8
        $summary += "$sp`tMISSING"
    }
}
$c.Close()

$summary | ForEach-Object { Write-Output $_ }
$summary | Out-File -FilePath (Join-Path $outDir '_inventory.txt') -Encoding utf8
