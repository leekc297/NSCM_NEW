# Insert PL/SQL terminator '/' after each statement in DDL files
# Pattern: each "CREATE OR REPLACE (TYPE|FUNCTION|PROCEDURE|PACKAGE|TRIGGER|PACKAGE BODY)" block
# ends with ";" and must be followed by "/" so sqlplus actually compiles it.

param(
  [string]$SrcDir = "C:\TRANFILE\DB\DDL",
  [string]$OutDir = "C:\Projects\NSCM\_artifacts\local-docker-oracle\ddl_fixed"
)
$ErrorActionPreference = "Stop"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }

$targets = @(
  '02_types.sql',
  '06_views.sql',
  '07_functions.sql',
  '08_procedures_01.sql','08_procedures_02.sql','08_procedures_03.sql','08_procedures_04.sql','08_procedures_05.sql',
  '09_packages_01.sql','09_packages_02.sql','09_packages_03.sql'
)

foreach ($f in $targets) {
  $src = Join-Path $SrcDir $f
  $dst = Join-Path $OutDir $f
  if (-not (Test-Path $src)) { Write-Output "SKIP: $f"; continue }

  $raw = [System.IO.File]::ReadAllText($src)

  # Strategy: insert "\n/\n" after every "<terminator>;\n" where <terminator> ends a top-level
  # PL/SQL block. We detect block ends by looking for the END of the block:
  #   ");\n"          for TYPE AS OBJECT (...)
  #   "END;\n"        for FUNCTION / PROCEDURE / PACKAGE / TYPE BODY (matches last END;)
  #   "END <NAME>;\n" same
  #
  # Easier robust approach: split on lines starting with "CREATE OR REPLACE" (top-level), keep
  # the CREATE in each chunk; for each chunk, find its last non-empty/non-comment line; if it
  # doesn't end with "/", append "\n/\n".
  $lines = $raw -split "(`r?`n)"   # keep separators

  # We'll process by splitting into top-level statements at lines whose trimmed text starts with "CREATE OR REPLACE"
  # Easier: write a simple state machine.
  $sb = New-Object System.Text.StringBuilder
  $contentLines = $raw -split "`r?`n"
  $chunkLines = @()

  function Emit-Chunk($buffer) {
    if ($buffer.Count -eq 0) { return $null }
    # Find last non-blank, non-comment line
    $lastIdx = -1
    for ($i = $buffer.Count - 1; $i -ge 0; $i--) {
      $t = ($buffer[$i]).Trim()
      if ($t -eq '') { continue }
      if ($t.StartsWith('--')) { continue }
      $lastIdx = $i; break
    }
    if ($lastIdx -lt 0) { return ($buffer -join "`r`n") }
    $lastText = ($buffer[$lastIdx]).TrimEnd()
    if ($lastText -eq '/' -or $lastText.EndsWith('/')) {
      return ($buffer -join "`r`n")
    }
    # Insert "/" on its own line after the lastIdx
    $result = New-Object System.Collections.ArrayList
    for ($i = 0; $i -le $lastIdx; $i++) { [void]$result.Add($buffer[$i]) }
    [void]$result.Add('/')
    for ($i = $lastIdx + 1; $i -lt $buffer.Count; $i++) { [void]$result.Add($buffer[$i]) }
    return ($result -join "`r`n")
  }

  $output = New-Object System.Text.StringBuilder
  foreach ($ln in $contentLines) {
    $t = $ln.TrimStart()
    if ($t -match '^(CREATE\s+OR\s+REPLACE|CREATE\s+(FORCE\s+)?(EDITIONABLE\s+)?(NONEDITIONABLE\s+)?(TYPE|FUNCTION|PROCEDURE|PACKAGE|VIEW|TRIGGER))\b') {
      # Emit previous chunk
      if ($chunkLines.Count -gt 0) {
        $emitted = Emit-Chunk $chunkLines
        [void]$output.AppendLine($emitted)
      }
      $chunkLines = @($ln)
    } else {
      $chunkLines += $ln
    }
  }
  if ($chunkLines.Count -gt 0) {
    $emitted = Emit-Chunk $chunkLines
    [void]$output.AppendLine($emitted)
  }

  [System.IO.File]::WriteAllText($dst, $output.ToString())
  $origSize = (Get-Item $src).Length
  $newSize = (Get-Item $dst).Length
  Write-Output ("  {0,-30}  {1,12:N0} -> {2,12:N0}" -f $f, $origSize, $newSize)
}
Write-Output "Done"
