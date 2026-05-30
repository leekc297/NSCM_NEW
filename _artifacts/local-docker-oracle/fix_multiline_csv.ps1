# Convert multi-line quoted CSV records to single-line by replacing
# newlines INSIDE quoted fields with spaces. Newlines outside quotes
# remain as record terminators.
param(
  [Parameter(Mandatory=$true)][string]$Src,
  [Parameter(Mandatory=$true)][string]$Dst
)
$ErrorActionPreference = "Stop"
$content = [System.IO.File]::ReadAllText($Src)
$sb = New-Object System.Text.StringBuilder ($content.Length)
$inQuoted = $false
$i = 0
$len = $content.Length
while ($i -lt $len) {
  $c = $content[$i]
  if ($c -eq '"') {
    # Toggle quoted state; escaped "" stays inside the field
    if ($inQuoted -and $i + 1 -lt $len -and $content[$i+1] -eq '"') {
      [void]$sb.Append('""')
      $i += 2
      continue
    }
    $inQuoted = -not $inQuoted
    [void]$sb.Append($c)
    $i++
    continue
  }
  if ($inQuoted -and ($c -eq "`r" -or $c -eq "`n")) {
    # CR or LF inside quoted field -> single space (collapse CRLF too)
    [void]$sb.Append(' ')
    if ($c -eq "`r" -and $i + 1 -lt $len -and $content[$i+1] -eq "`n") { $i += 2 } else { $i++ }
    continue
  }
  [void]$sb.Append($c)
  $i++
}
[System.IO.File]::WriteAllText($Dst, $sb.ToString())
$origLines = ([System.IO.File]::ReadAllText($Src) -split "`r?`n").Count
$newLines  = ([System.IO.File]::ReadAllText($Dst) -split "`r?`n").Count
Write-Output ("  {0,-50}  orig_lines={1}  new_lines={2}" -f (Split-Path $Src -Leaf), $origLines, $newLines)
