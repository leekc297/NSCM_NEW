# 검증쿼리 시트를 V9 원본 상태로 되돌리고, 추가 쿼리는 새 시트 「검증쿼리(사전점검)」으로 분리(2026-11-24 사용자 지시)
param([string]$Path, [string]$ScnJson, [string]$VqJson, [string]$HeightJson, [string]$Note1, [string]$Note2)
$ErrorActionPreference = 'Stop'
$d = Get-Content -Raw -Encoding UTF8 $ScnJson | ConvertFrom-Json
$vq = Get-Content -Raw -Encoding UTF8 $VqJson | ConvertFrom-Json
$hh = Get-Content -Raw -Encoding UTF8 $HeightJson | ConvertFrom-Json      # V9 원본 행 높이(2 ~ 33행)
$NEW = '검증쿼리(사전점검)'
$xl = New-Object -ComObject Excel.Application
$xl.Visible = $false; $xl.DisplayAlerts = $false; $xl.ScreenUpdating = $false
try {
    $wb = $xl.Workbooks.Open($Path)
    if ($wb.ReadOnly) { throw '파일이 다른 Excel 에 열려 있어 읽기 전용으로 열림 — 저장되지 않으므로 중단(2026-11-24 실제 발생)' }
    foreach ($s in $wb.Worksheets) { if ($s.Name -eq $NEW) { throw "이미 $NEW 시트가 있음" } }
    $q = $wb.Worksheets.Item('검증쿼리')
    # ── 1. 새 시트 = 검증쿼리 복사본(서식 · 폭 · 틀 고정 그대로) ─────────────
    [void]$q.Copy([Type]::Missing, $q)
    $n = $wb.Worksheets.Item($q.Index + 1); $n.Name = $NEW
    # ── 2. 검증쿼리 시트를 V9 원본으로 ───────────────────────────────────
    if ([string]$q.Cells.Item(34, 1).Value2 -ne 'VQ-33' -or [string]$q.Cells.Item(58, 1).Value2 -ne 'VQ-57') { throw '검증쿼리 34 ~ 58행이 VQ-33 ~ 57 이 아님' }
    [void]$q.Range('34:58').EntireRow.Delete()
    if (-not ([string]$q.Cells.Item(37, 1).Value2).StartsWith('※ VQ-33')) { throw '검증쿼리 37행 안내 문구가 예상과 다름' }
    [void]$q.Range('37:38').EntireRow.Delete()
    [void]$q.Columns.Item(7).Delete()
    for ($r = 2; $r -le 33; $r++) { $h = $hh.("$r"); if ($h) { $q.Rows.Item($r).RowHeight = [double]$h } }
    "검증쿼리 : 원본 범위로 복원(마지막 VQ = $($q.Cells.Item(33, 1).Value2))"
    # ── 3. 새 시트 채우기 ────────────────────────────────────────────────
    $n.Cells.Item(1, 6).Value2 = 'TO-BE SQL(Oracle)'
    $last = $n.UsedRange.Row + $n.UsedRange.Rows.Count - 1
    [void]$n.Range("3:$last").EntireRow.Delete()          # 2행 = 자료 행 서식 틀
    $r = 2
    foreach ($v in $vq) {
        if ($r -gt 2) { [void]$n.Rows.Item(2).Copy(); [void]$n.Rows.Item($r).PasteSpecial(-4122) }
        for ($c = 0; $c -lt 7; $c++) { $n.Cells.Item($r, $c + 1).Value2 = [string]$v[$c] }
        $lines = [Math]::Max(([string]$v[5]).Split("`n").Count, ([string]$v[6]).Split("`n").Count)
        $n.Rows.Item($r).RowHeight = [Math]::Min(409, [Math]::Max(48, 12 * $lines))
        $r++
    }
    $lastVq = $r - 1
    # 안내 문구 : 원본 시트 안내 줄 서식을 가져와 2줄
    $r++
    foreach ($t in @($Note1, $Note2)) {
        [void]$q.Rows.Item(35).Copy(); [void]$n.Rows.Item($r).PasteSpecial(-4122)
        $n.Cells.Item($r, 1).Value2 = [string]$t; $r++
    }
    $xl.CutCopyMode = 0
    "$NEW : 쿼리 $($vq.Count)건(행 2 ~ $lastVq) · 안내 2줄"
    # ── 4. 사전점검 문구(프로그램 실행 예시 BEGIN … END;) ─────────────────
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
