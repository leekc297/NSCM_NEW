# 검증쿼리 시트에 AS-IS SQL(MSSQL) 열 추가 + 사전점검 시트 테스트케이스 문구 갱신(Excel 로 직접 저장)
param([string]$Path, [string]$Json, [string]$TestNote)
$ErrorActionPreference = 'Stop'
$d = Get-Content -Raw -Encoding UTF8 $Json | ConvertFrom-Json
$xl = New-Object -ComObject Excel.Application
$xl.Visible = $false; $xl.DisplayAlerts = $false; $xl.ScreenUpdating = $false
try {
    $wb = $xl.Workbooks.Open($Path)
    # ── 검증쿼리 : G 열 ───────────────────────────────────────────────────
    $q = $wb.Worksheets.Item('검증쿼리')
    if ([string]$q.Cells.Item(1, 7).Value2 -ne '') { throw "검증쿼리 G1 에 이미 값이 있음 : $($q.Cells.Item(1, 7).Value2)" }
    [void]$q.Cells.Item(1, 6).Copy(); [void]$q.Cells.Item(1, 7).PasteSpecial(-4122)
    $q.Cells.Item(1, 7).Value2 = 'AS-IS SQL(MSSQL)'
    $q.Range('G1').ColumnWidth = [double]$q.Range('F1').ColumnWidth
    $cnt = 0; $r = 2
    while (([string]$q.Cells.Item($r, 1).Value2).StartsWith('VQ-')) {
        $id = [string]$q.Cells.Item($r, 1).Value2
        [void]$q.Cells.Item($r, 6).Copy(); [void]$q.Cells.Item($r, 7).PasteSpecial(-4122)
        $tb = ($d.vq | Where-Object { $_.id -eq $id }).sql        # TO-BE SQL 이 바뀐 추가 쿼리는 F 열도 갱신
        if ($tb -and [string]$q.Cells.Item($r, 6).Value2 -ne [string]$tb) { $q.Cells.Item($r, 6).Value2 = [string]$tb; "  TO-BE SQL 갱신 : $id" }
        $sql = $d.asis.$id
        if ($sql) {
            $q.Cells.Item($r, 7).Value2 = [string]$sql; $cnt++
            $h = [Math]::Min(409, 12 * ([string]$sql).Split("`n").Count)
            if ($h -gt $q.Rows.Item($r).RowHeight) { $q.Rows.Item($r).RowHeight = $h }
        } else { $q.Cells.Item($r, 7).Value2 = '-' }
        $r++
    }
    $lastVq = $r - 1
    # 안내 문구 : 마지막 안내 줄 아래에 1줄 추가
    $n = $lastVq + 1
    while (-not ([string]$q.Cells.Item($n, 1).Value2).StartsWith('※')) { $n++; if ($n -gt $lastVq + 5) { throw '안내 문구를 찾지 못함' } }
    while (([string]$q.Cells.Item($n + 1, 1).Value2).StartsWith('※')) { $n++ }
    [void]$q.Rows.Item($n).Copy(); [void]$q.Rows.Item($n + 1).PasteSpecial(-4122)
    $q.Cells.Item($n + 1, 1).Value2 = ([string]$d.asis_note).Replace('__ASIS_TEST__', $TestNote)
    $xl.CutCopyMode = 0
    "검증쿼리 : VQ 행 2 ~ $lastVq · AS-IS SQL $($cnt)개 · 안내 행 $($n + 1)"
    # ── 사전점검 : 테스트케이스 문구 ──────────────────────────────────────
    $ws = $wb.Worksheets.Item('사전점검')
    $rows = @(); foreach ($s in $d.sections) { foreach ($x in $s.rows) { $rows += , $x } }
    $r = 2; $i = 0; $chg = 0
    while ($i -lt $rows.Count) {
        $a = $ws.Cells.Item($r, 1).Value2
        if ($a -is [double] -and [int]$a -eq $i + 1) {
            $new = [string]$rows[$i][3]
            if ([string]$ws.Cells.Item($r, 5).Value2 -ne $new) { $ws.Cells.Item($r, 5).Value2 = $new; [void]$ws.Rows.Item($r).AutoFit(); $chg++ }
            $i++
        }
        $r++; if ($r -gt 200) { throw "사전점검 No $($i + 1) 행을 찾지 못함" }
    }
    "사전점검 : 케이스 $($rows.Count)건 확인 · 문구 변경 $($chg)건"
    [void]$ws.Activate()
    $wb.Save(); $wb.Close($false)
    '저장 완료'
}
finally {
    $xl.ScreenUpdating = $true
    $xl.Quit()
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($xl)
}
