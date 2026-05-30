# Re-apply PL/SQL DDL files (with / terminator inserted)
param(
  [string]$SrcDir = "C:\Projects\NSCM\_artifacts\local-docker-oracle\ddl_fixed",
  [string]$Container = "nscm-oracle",
  [string]$Conn = "SCM_MGR/!SCMroqkf2026@//localhost:1521/FREEPDB1",
  [string]$LogDir = "C:\Projects\NSCM\_artifacts\local-docker-oracle\ddl_logs_fixed"
)
$ErrorActionPreference = "Continue"
$env:MSYS_NO_PATHCONV = "1"
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }

# Only PL/SQL files (TABLE/INDEX/SEQUENCE/SYNONYM already loaded)
$order = @(
  '02_types.sql',
  '06_views.sql',
  '07_functions.sql',
  '08_procedures_01.sql','08_procedures_02.sql','08_procedures_03.sql','08_procedures_04.sql','08_procedures_05.sql',
  '09_packages_01.sql','09_packages_02.sql','09_packages_03.sql'
)

$started = Get-Date
foreach ($f in $order) {
  $src = Join-Path $SrcDir $f
  if (-not (Test-Path $src)) { Write-Output "SKIP: $f"; continue }
  $tgt = "/tmp/ddl_$f"
  docker cp $src "${Container}:$tgt" 2>$null | Out-Null
  $logFile = Join-Path $LogDir ($f -replace '\.sql$','.log')
  $elapsed = (Get-Date) - $started
  Write-Output ("[{0:N1}s] running {1}" -f $elapsed.TotalSeconds, $f)
  "EXIT" | docker exec -i $Container sqlplus -S $Conn "@$tgt" 2>&1 | Out-File -FilePath $logFile -Encoding utf8
  Write-Output ("  exit=$LASTEXITCODE")
}
$elapsed = (Get-Date) - $started
Write-Output ("Done in {0:N1} min" -f $elapsed.TotalMinutes)
