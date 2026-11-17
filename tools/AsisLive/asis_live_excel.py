# -*- coding: utf-8 -*-
"""런처가 띄운 Excel 기록·종료 (2026-11-13 · 사용자 지시 "EXCEL DOWN 등으로 런처가 EXCEL 을 실행한 경우에도 EXCEL 확인 후 종료")

  snap()                  지금 떠 있는 Excel(PID·열린 통합 문서) = 사용자 것으로 보고 기준으로 잡는다
  close_new(before, hp)   기준 뒤에 새로 열린 통합 문서만 기록(이름·경로·시트별 행/열·파일 크기)하고 저장 없이 닫는다
                          → {"closed":[…], "left":[…]} · left = 근거가 없어 닫지 않은 것
  직접 실행:  python tools/AsisLive/asis_live_excel.py snap | close <snap.json>
원칙  사용자가 열어 둔 통합 문서·Excel 은 닫지 않는다(11-13 실측: 런처가 내려받은 파일이 사용자가 쓰던 Excel 안에 열림 → 프로세스를 끝내면 사용자 문서까지 닫힌다).
구현  excel_guard.ps1 을 Windows PowerShell 로 실행(스크립트 본문을 읽어 실행 · 설정 변경 없음).
"""
import json, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
PS1 = os.path.join(HERE, "excel_guard.ps1")
LDIR = os.path.abspath(os.path.join(HERE, "..", "..", "GSCM", "02.Launcher", "GSCM.Launcher", "bin", "Debug"))


def _run(env, timeout=90):
    e = dict(os.environ); e.update(env)
    try:
        cmd = "& ([scriptblock]::Create([IO.File]::ReadAllText($env:XG_PS1, [Text.Encoding]::UTF8)))"; e["XG_PS1"] = PS1
        p = subprocess.run(["powershell.exe", "-NoProfile", "-NonInteractive", "-Command", cmd], capture_output=True, env=e, timeout=timeout)
        txt = p.stdout.decode("utf-8", "replace").strip()
        line = [l for l in txt.splitlines() if l.strip().startswith("{")]
        if not line: return {"error": "출력 없음: " + (p.stderr.decode("cp949", "replace") or txt)[:300]}
        return json.loads(line[-1])
    except Exception as ex:
        return {"error": "%s: %s" % (type(ex).__name__, str(ex)[:200])}


def snap():
    return _run({"XG_MODE": "snap"})


def close_new(before, host_pids=()):
    if not isinstance(before, dict) or before.get("error") or "pids" not in before: return {"error": "기준(snap) 없음: %s" % (before or {}).get("error"), "closed": [], "left": []}
    fd, tmp = tempfile.mkstemp(suffix=".json"); os.close(fd)
    try:
        with open(tmp, "w", encoding="utf-8") as f: json.dump({"pids": before.get("pids") or [], "books": before.get("books") or [], "at": before.get("at")}, f, ensure_ascii=False)
        r = _run({"XG_MODE": "close", "XG_BEFORE": tmp, "XG_HOSTPIDS": ",".join(str(x) for x in host_pids), "XG_LAUNCHERDIR": LDIR})
    finally:
        try: os.remove(tmp)
        except Exception: pass
    for k in ("closed", "left"):
        v = r.get(k)
        r[k] = [] if v is None else v if isinstance(v, list) else [v]
    for e in r["closed"]:                                    # Excel 쪽에서 시트 정보를 못 읽은 것은 내려받은 파일을 직접 읽어 채운다
        if isinstance(e, dict) and not e.get("sheets"): e.update(file_info(e.get("path") or e.get("title") or ""))
    return r


def file_info(hint):
    """창 제목("<파일 이름> - Excel")이나 경로로 내려받은 파일을 찾아 시트별 행·열 수를 읽는다. 못 찾으면 그 사실을 적는다."""
    name = os.path.basename(hint.replace(" - Excel", "").replace("[보호된 보기]", "").replace("[Protected View]", "").strip())
    if not name: return {"file_note": "파일 이름을 알 수 없음"}
    cand = [hint] if os.path.isabs(hint) and os.path.exists(hint) else [os.path.join(d, name) for d in (LDIR, os.path.join(os.path.expanduser("~"), "Downloads"), os.path.join(os.path.expanduser("~"), "Documents"), tempfile.gettempdir()) if os.path.exists(os.path.join(d, name))]
    if not cand: return {"file_note": "파일을 찾지 못함: " + name}
    out = {"path": cand[0], "file_bytes": os.path.getsize(cand[0])}
    try:
        import openpyxl
        wb = openpyxl.load_workbook(cand[0], read_only=True, data_only=True)
        out["sheets"] = [{"sheet": ws.title, "rows": ws.max_row, "cols": ws.max_column} for ws in wb.worksheets]; wb.close()
    except Exception as ex:
        out["file_note"] = "시트 읽기 실패: %s" % str(ex)[:120]
    return out


def host_pids():
    try:
        o = subprocess.run(["tasklist", "/FI", "IMAGENAME eq AsisLive.Host.exe", "/FO", "CSV", "/NH"], capture_output=True, text=True, errors="replace").stdout
        return [int(l.split('","')[1]) for l in o.splitlines() if l.startswith('"AsisLive')]
    except Exception:
        return []


if __name__ == "__main__":
    for _s in (sys.stdout, sys.stderr):
        try: _s.reconfigure(encoding="utf-8", errors="replace")
        except Exception: pass
    a = sys.argv[1:]
    if a and a[0] == "snap": print(json.dumps(snap(), ensure_ascii=False))
    elif len(a) > 1 and a[0] == "close": print(json.dumps(close_new(json.load(open(a[1], encoding="utf-8")), host_pids()), ensure_ascii=False, indent=1))
    else: print(__doc__)
