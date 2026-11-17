# AS-IS Live — 런처가 띄운 Excel 을 기록하고 닫는다 (2026-11-13 · 사용자 지시 "EXCEL 확인 후 종료")
#   입력(환경 변수)  XG_MODE = snap | close     XG_BEFORE = snap 결과 JSON 파일 경로(close 때)     XG_HOSTPIDS = 자동화 런처 PID 목록(쉼표)
#   snap   지금 떠 있는 Excel 프로세스 PID 와 열려 있는 통합 문서 전체 경로를 적는다(= 사용자 것. 건드리지 않을 기준).
#   close  snap 뒤에 새로 열린 통합 문서만: 이름·경로·시트별 사용 행/열 수·파일 크기를 기록하고 저장 없이 닫는다.
#          닫는 문서 = 기준 시각 뒤에 만들어진 파일 · 런처 실행 폴더(XG_LAUNCHERDIR) 아래 파일 · 자동화가 띄운 Excel 안의 문서뿐. 근거 없는 새 문서는 남긴다(left).
#          snap 때 없던 Excel 프로세스는, 통합 문서가 하나도 안 남았을 때만 끝낸다. 사용자가 열어 둔 통합 문서·Excel 은 닫지 않는다.
#   한계   GetActiveObject 는 Excel 인스턴스 1개만 준다. 그 밖의 새 인스턴스는 부모가 자동화 런처이거나 COM 자동화(-Embedding)로 뜬 것만 창 제목을 기록하고 끝낸다.
#          그 조건에 안 맞는 새 Excel 은 사용자 것일 수 있으므로 기록만 하고 남긴다(left).
$ErrorActionPreference = 'Stop'
Add-Type -Namespace XG -Name U -MemberDefinition '[DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);'
function AppPid($app) { $p = [uint32]0; [void][XG.U]::GetWindowThreadProcessId([IntPtr]$app.Hwnd, [ref]$p); return [int]$p }
function GetApp { try { return [Runtime.InteropServices.Marshal]::GetActiveObject('Excel.Application') } catch { return $null } }
function Procs { @(Get-CimInstance Win32_Process -Filter "Name='EXCEL.EXE'") }

$mode = $env:XG_MODE
$out = @{ mode = $mode; at = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') }
try {
    if ($mode -eq 'snap') {
        $out.pids = @(Procs | ForEach-Object { [int]$_.ProcessId })
        $books = @(); $app = GetApp
        if ($app) { try { foreach ($wb in $app.Workbooks) { $books += [string]$wb.FullName } } catch { $out.snap_error = $_.Exception.Message } }
        $out.books = $books
    }
    elseif ($mode -eq 'close') {
        $before = Get-Content -Raw -Encoding UTF8 $env:XG_BEFORE | ConvertFrom-Json
        $closed = @(); $left = @(); $handled = @()
        $bp = @($before.pids | ForEach-Object { [int]$_ }); $bb = @($before.books | ForEach-Object { [string]$_ })
        $hp = @(); if ($env:XG_HOSTPIDS) { $hp = @($env:XG_HOSTPIDS -split ',' | Where-Object { $_ } | ForEach-Object { [int]$_ }) }
        # 새 Excel 이 막 뜨는 중이면 문서가 열릴 때까지 잠깐 기다린다(11-13 실측: 바로 읽으면 문서 목록이 비어 시트 정보 없이 닫힘)
        $np = @(Procs | Where-Object { $bp -notcontains [int]$_.ProcessId }); $app = $null
        if ($np.Count -gt 0) { for ($i = 0; $i -lt 5; $i++) { $app = GetApp; if ($app) { $wc = 0; try { $wc = [int]$app.Workbooks.Count } catch { }; if ($wc -gt 0) { break } }; Start-Sleep -Seconds 2 } } else { $app = GetApp }
        if ($app) {
            $apid = AppPid $app; $new = @()
            try { foreach ($wb in $app.Workbooks) { if ($bb -notcontains [string]$wb.FullName) { $new += $wb } } } catch { $out.enum_error = $_.Exception.Message }
            $since = [datetime]::ParseExact([string]$before.at, 'yyyy-MM-dd HH:mm:ss', $null).AddSeconds(-5); $ldir = [string]$env:XG_LAUNCHERDIR
            foreach ($wb in $new) {
                $e = @{ name = [string]$wb.Name; path = [string]$wb.FullName; excel_pid = $apid }
                # 자동화가 만든 파일이라는 근거: 기준 시각 뒤에 만들어졌거나 쓰인 파일 · 런처 실행 폴더 아래 파일 · 새로 뜬 Excel(부모가 자동화 런처) 안의 문서
                $mine = $false
                try {
                    if (Test-Path -LiteralPath $e.path) { $fi = Get-Item -LiteralPath $e.path; $e.file_created = $fi.CreationTime.ToString('HH:mm:ss'); if ($fi.CreationTime -ge $since -or $fi.LastWriteTime -ge $since) { $mine = $true } }
                    if ($ldir -and $e.path.ToLower().StartsWith($ldir.ToLower())) { $mine = $true }
                    if ($bp -notcontains $apid) { $pp = Get-CimInstance Win32_Process -Filter "ProcessId=$apid"; if ($pp -and (($hp -contains [int]$pp.ParentProcessId) -or ([string]$pp.CommandLine -match '(?i)-Embedding|/automation'))) { $mine = $true } }
                } catch { }
                if (-not $mine) { $e.why = '자동화가 만든 문서라는 근거 없음(사용자가 연 문서일 수 있음) — 닫지 않음'; $left += $e; continue }
                try {
                    $sh = @(); foreach ($ws in $wb.Worksheets) { $ur = $ws.UsedRange; $sh += @{ sheet = [string]$ws.Name; rows = [int]$ur.Rows.Count; cols = [int]$ur.Columns.Count; a1 = [string]$ws.Cells.Item(1, 1).Text } }
                    $e.sheets = $sh
                    if (Test-Path -LiteralPath $e.path) { $e.file_bytes = (Get-Item -LiteralPath $e.path).Length }
                    $app.DisplayAlerts = $false; $wb.Close($false); $app.DisplayAlerts = $true; $e.closed = $true
                } catch { $e.closed = $false; $e.error = $_.Exception.Message }
                $closed += $e
            }
            if ($bp -notcontains $apid) {
                $handled += $apid
                $n = -1; try { $n = [int]$app.Workbooks.Count } catch { }
                if ($n -eq 0) { try { $app.Quit(); $out.quit_pid = $apid } catch { $out.quit_error = $_.Exception.Message } }
                elseif ($n -gt 0) { $left += @{ pid = $apid; why = "통합 문서 $n 개가 남아 있어 끝내지 않음" } }
            }
            [void][Runtime.InteropServices.Marshal]::ReleaseComObject($app)
        }
        Start-Sleep -Milliseconds 800
        foreach ($p in Procs) {
            $id = [int]$p.ProcessId
            if ($bp -contains $id) { continue }
            if ($out.quit_pid -eq $id) { Start-Sleep -Milliseconds 1500; if (-not (Get-Process -Id $id -ErrorAction SilentlyContinue)) { continue } }
            $gp = Get-Process -Id $id -ErrorAction SilentlyContinue; if (-not $gp) { continue }
            $auto = ($hp -contains [int]$p.ParentProcessId) -or ([string]$p.CommandLine -match '(?i)-Embedding|/automation')
            $e = @{ pid = $id; parent = [int]$p.ParentProcessId; title = [string]$gp.MainWindowTitle; started = $p.CreationDate.ToString('HH:mm:ss'); automation = $auto }
            if ($handled -contains $id) { continue }
            if ($auto) { try { Stop-Process -Id $id -Force; $e.closed = $true } catch { $e.closed = $false; $e.error = $_.Exception.Message }; $closed += $e }
            else { $e.why = '자동화가 띄웠다는 근거 없음(사용자 것일 수 있음) — 닫지 않음'; $left += $e }
        }
        $out.closed = $closed; $out.left = $left
    }
    else { $out.error = 'XG_MODE 는 snap | close' }
} catch { $out.error = $_.Exception.Message }
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$out | ConvertTo-Json -Depth 6 -Compress
