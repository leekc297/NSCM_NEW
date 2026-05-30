# Apply DDL files in C:\TRANFILE\DB\DDL to SCM_MGR in proper order
param(
  [string]$SrcDir = "C:\TRANFILE\DB\DDL",
  [string]$Container = "nscm-oracle",
  [string]$Conn = "SCM_MGR/!SCMroqkf2026@//localhost:1521/FREEPDB1",
  [string]$LogDir = "C:\Projects\NSCM\_artifacts\local-docker-oracle\ddl_logs"
)
$ErrorActionPreference = "Continue"
$env:MSYS_NO_PATHCONV = "1"
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }

$order = @(
  '02_types.sql',
  '03_sequences.sql',
  '04_tables_01.sql','04_tables_02.sql','04_tables_03.sql','04_tables_04.sql','04_tables_05.sql','04_tables_06.sql',
  '05_indexes.sql',
  '06_views.sql',
  '07_functions.sql',
  '08_procedures_01.sql','08_procedures_02.sql','08_procedures_03.sql','08_procedures_04.sql','08_procedures_05.sql',
  '09_packages_01.sql','09_packages_02.sql','09_packages_03.sql',
  '11_synonyms_01.sql'
)

$started = Get-Date
foreach ($f in $order) {
  $src = Join-Path $SrcDir $f
  if (-not (Test-Path $src)) { Write-Output "SKIP (not found): $f"; continue }
  $tgt = "/tmp/ddl_$f"
  docker cp $src "${Container}:$tgt" 2>$null | Out-Null
  $logFile = Join-Path $LogDir ($f -replace '\.sql$','.log')
  $elapsed = (Get-Date) - $started
  Write-Output ("[{0:N1}s] running {1}" -f $elapsed.TotalSeconds, $f)
  "EXIT" | docker exec -i $Container sqlplus -S $Conn "@$tgt" 2>&1 | Out-File -FilePath $logFile -Encoding utf8
  $exit = $LASTEXITCODE
  Write-Output ("  exit=$exit  log=$logFile")
}
$elapsed = (Get-Date) - $started
Write-Output ("Done in {0:N1} minutes" -f $elapsed.TotalMinutes)
