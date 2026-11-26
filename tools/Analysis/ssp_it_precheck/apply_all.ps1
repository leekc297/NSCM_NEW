# 새 판(V10 ~) 사본에 한 번에 반영 : ① 사전점검 시트 본문 ② 새 시트 「검증쿼리(사전점검)」. 기존 검증쿼리 시트는 건드리지 않음
# 전제 : 사전점검 시트가 원본 틀(1행 머리글 · 2행 구역 머리 · 3 ~ 8행 빈 자료 행 · 9행 사이 행 · 10행 구역 머리 · 11 ~ 18행) 그대로
param([string]$Path, [string]$ScnJson, [string]$VqJson, [string]$Note1, [string]$Note2)
$ErrorActionPreference = 'Stop'
$d = Get-Content -Raw -Encoding UTF8 $ScnJson | ConvertFrom-Json
$vq = Get-Content -Raw -Encoding UTF8 $VqJson | ConvertFrom-Json
$NEW = '검증쿼리(사전점검)'
$xl = New-Object -ComObject Excel.Application
$xl.Visible = $false; $xl.DisplayAlerts = $false; $xl.ScreenUpdating = $false
try {
    $wb = $xl.Workbooks.Open($Path)
    if ($wb.ReadOnly) { throw '파일이 다른 Excel 에 열려 있어 읽기 전용으로 열림. 저장되지 않으므로 중단' }
    foreach ($s in $wb.Worksheets) { if ($s.Name -eq $NEW) { throw "이미 $NEW 시트가 있음" } }
    # ── 1. 사전점검 ───────────────────────────────────────────────────────
    $ws = $wb.Worksheets.Item('사전점검')
    if (-not ([string]$ws.Cells.Item(2, 1).Value2).StartsWith('■') -or -not ([string]$ws.Cells.Item(10, 1).Value2).StartsWith('■') -or [string]$ws.Cells.Item(4, 5).Value2 -ne '') { throw '사전점검 시트가 원본 틀과 다름' }
    $T = 301
    [void]$ws.Rows.Item(2).Copy($ws.Rows.Item($T)); [void]$ws.Rows.Item(4).Copy($ws.Rows.Item($T + 1)); [void]$ws.Rows.Item(9).Copy($ws.Rows.Item($T + 2))
    [void]$ws.Range('2:18').EntireRow.Delete(); $T = $T - 17
    $r = 2; $no = 0; $si = 0
    foreach ($s in $d.sections) {
        $si++
        [void]$ws.Rows.Item($T).Copy($ws.Rows.Item($r)); $ws.Cells.Item($r, 1).Value2 = [string]$s.title; $r++
        foreach ($row in $s.rows) {
            $no++
            [void]$ws.Rows.Item($T + 1).Copy($ws.Rows.Item($r))
            $ws.Cells.Item($r, 1).Value2 = $no
            for ($c = 0; $c -lt 7; $c++) { $t = [string]$row[$c]; if ($t -match '^\d+$') { $t = "'" + $t }; $ws.Cells.Item($r, $c + 2).Value2 = $t }   # 단위 40 은 문자로(테스트케이스 시트와 같게)
            $ws.Cells.Item($r, 10).Value2 = '-'
            [void]$ws.Rows.Item($r).AutoFit(); $r++
        }
        if ($si -lt $d.sections.Count) { [void]$ws.Rows.Item($T + 2).Copy($ws.Rows.Item($r)); $r++ }
    }
    [void]$ws.Range("$($T):$($T + 2)").EntireRow.Delete()
    $xl.CutCopyMode = 0
    "사전점검 : 케이스 $($no)건 · 마지막 행 $($r - 1)"
    # ── 2. 새 시트 = 검증쿼리 복사본(서식 · 폭 그대로) ───────────────────
    $q = $wb.Worksheets.Item('검증쿼리')
    [void]$q.Copy([Type]::Missing, $q)
    $n = $wb.Worksheets.Item($q.Index + 1)
    if ($n.Name -eq $q.Name -or [string]$n.Cells.Item(2, 1).Value2 -ne [string]$q.Cells.Item(2, 1).Value2) { throw '검증쿼리 복사본 위치가 예상과 다름' }
    $n.Name = $NEW
    $n.Cells.Item(1, 6).Value2 = 'TO-BE SQL(Oracle)'
    [void]$n.Cells.Item(1, 6).Copy(); [void]$n.Cells.Item(1, 7).PasteSpecial(-4122); $n.Cells.Item(1, 7).Value2 = 'AS-IS SQL(MSSQL)'
    $n.Range('G1').ColumnWidth = [double]$n.Range('F1').ColumnWidth
    [void]$n.Cells.Item(2, 6).Copy(); [void]$n.Cells.Item(2, 7).PasteSpecial(-4122)      # 2행 = 자료 행 서식 틀
    $last = $n.UsedRange.Row + $n.UsedRange.Rows.Count - 1
    [void]$n.Range("3:$last").EntireRow.Delete()
    $r = 2
    foreach ($v in $vq) {
        if ($r -gt 2) { [void]$n.Rows.Item(2).Copy(); [void]$n.Rows.Item($r).PasteSpecial(-4122) }
        for ($c = 0; $c -lt 7; $c++) { $n.Cells.Item($r, $c + 1).Value2 = [string]$v[$c] }
        $lines = [Math]::Max(([string]$v[5]).Split("`n").Count, ([string]$v[6]).Split("`n").Count)
        $n.Rows.Item($r).RowHeight = [Math]::Min(409, [Math]::Max(48, 12 * $lines)); $r++
    }
    $lastVq = $r - 1; $r++
    $noteRow = 0; for ($k = 34; $k -le 60; $k++) { if (([string]$q.Cells.Item($k, 1).Value2).StartsWith('※')) { $noteRow = $k; break } }
    if (-not $noteRow) { throw '검증쿼리 시트 안내 줄을 찾지 못함' }
    foreach ($t in @($Note1, $Note2)) { [void]$q.Rows.Item($noteRow).Copy(); [void]$n.Rows.Item($r).PasteSpecial(-4122); $n.Cells.Item($r, 1).Value2 = [string]$t; $r++ }
    $xl.CutCopyMode = 0
    [void]$n.Activate(); $w = $xl.ActiveWindow; $w.FreezePanes = $false; $w.ScrollRow = 1; $w.ScrollColumn = 1; [void]$n.Range('A2').Select(); $w.FreezePanes = $true; [void]$n.Range('A1').Select()
    "$NEW : 쿼리 $($vq.Count)건(행 2 ~ $lastVq) · 안내 2줄 · 위치 = 검증쿼리 다음"
    [void]$wb.Worksheets.Item(1).Activate()
    $wb.Save(); $wb.Close($false)
    '저장 완료'
}
finally {
    $xl.ScreenUpdating = $true
    $xl.Quit()
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($xl)
}
