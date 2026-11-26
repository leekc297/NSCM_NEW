# V9 사본의 사전점검 · 검증쿼리 시트 채우기(Excel 로 직접 저장 — 프로세스 그림 시트 보존)
param([string]$Path, [string]$Json)
$ErrorActionPreference = 'Stop'
$d = Get-Content -Raw -Encoding UTF8 $Json | ConvertFrom-Json
$xl = New-Object -ComObject Excel.Application
$xl.Visible = $false; $xl.DisplayAlerts = $false; $xl.ScreenUpdating = $false
try {
    $wb = $xl.Workbooks.Open($Path)
    # ── 사전점검 ──────────────────────────────────────────────────────────
    $ws = $wb.Worksheets.Item('사전점검')
    $T = 301                                   # 서식 틀 임시 보관 행(구역 머리 · 자료 행 · 구역 사이 빈 행)
    [void]$ws.Rows.Item(2).Copy($ws.Rows.Item($T))
    [void]$ws.Rows.Item(4).Copy($ws.Rows.Item($T + 1))
    [void]$ws.Rows.Item(9).Copy($ws.Rows.Item($T + 2))
    [void]$ws.Range('2:18').EntireRow.Delete()
    $T = $T - 17
    $r = 2; $no = 0; $si = 0
    foreach ($s in $d.sections) {
        $si++
        [void]$ws.Rows.Item($T).Copy($ws.Rows.Item($r))
        $ws.Cells.Item($r, 1).Value2 = [string]$s.title
        $r++
        foreach ($row in $s.rows) {
            $no++
            [void]$ws.Rows.Item($T + 1).Copy($ws.Rows.Item($r))
            $ws.Cells.Item($r, 1).Value2 = $no
            for ($c = 0; $c -lt 7; $c++) { $ws.Cells.Item($r, $c + 2).Value2 = [string]$row[$c] }
            $ws.Cells.Item($r, 10).Value2 = '-'
            [void]$ws.Rows.Item($r).AutoFit()
            $r++
        }
        if ($si -lt $d.sections.Count) { [void]$ws.Rows.Item($T + 2).Copy($ws.Rows.Item($r)); $r++ }
    }
    [void]$ws.Range("$($T):$($T + 2)").EntireRow.Delete()
    $xl.CutCopyMode = 0
    "사전점검 : 마지막 행 $($r - 1) · 케이스 $no"
    # ── 검증쿼리 ──────────────────────────────────────────────────────────
    $q = $wb.Worksheets.Item('검증쿼리')
    $last = 33                                 # VQ-32 행
    if ([string]$q.Cells.Item($last, 1).Value2 -ne 'VQ-32') { throw "검증쿼리 33행이 VQ-32 가 아님 : $($q.Cells.Item($last, 1).Value2)" }
    $r = $last + 1
    foreach ($v in $d.vq) {
        [void]$q.Rows.Item($r).Insert()
        [void]$q.Rows.Item($last).Copy()
        [void]$q.Rows.Item($r).PasteSpecial(-4122)     # 서식만
        $q.Cells.Item($r, 1).Value2 = [string]$v.id
        $q.Cells.Item($r, 2).Value2 = [string]$v.cat
        $q.Cells.Item($r, 3).Value2 = [string]$v.what
        $q.Cells.Item($r, 4).Value2 = [string]$v.tabs
        $q.Cells.Item($r, 5).Value2 = [string]$v.point
        $q.Cells.Item($r, 6).Value2 = [string]$v.sql
        $lines = ([string]$v.sql).Split("`n").Count
        $q.Rows.Item($r).RowHeight = [Math]::Min(409, 12 * $lines)
        $r++
    }
    # 안내 문구(기존 2줄 아래에 1줄 추가)
    $n2 = $r + 2                               # 빈 행 1 + 기존 안내 2줄 → 그 둘째 줄
    if (-not ([string]$q.Cells.Item($n2, 1).Value2).StartsWith('※')) { throw "안내 문구 위치가 예상과 다름 : 행 $n2" }
    [void]$q.Rows.Item($n2).Copy()
    [void]$q.Rows.Item($n2 + 1).PasteSpecial(-4122)
    $q.Cells.Item($n2 + 1, 1).Value2 = [string]$d.vq_note
    $xl.CutCopyMode = 0
    "검증쿼리 : VQ $($d.vq.Count)개 추가 · 마지막 VQ 행 $($r - 1) · 안내 행 $($n2 + 1)"
    [void]$wb.Worksheets.Item('사전점검').Activate()
    $wb.Save()
    $wb.Close($false)
    '저장 완료'
}
finally {
    $xl.ScreenUpdating = $true
    $xl.Quit()
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($xl)
}
