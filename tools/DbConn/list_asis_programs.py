# -*- coding: utf-8 -*-
"""
list_asis_programs — AS-IS DB(.env.asis MSSQL) 접속해서 사용 중(UseYN='Y')인 프로그램 목록을 JSON stdout 으로 반환.
  python list_asis_programs.py                전체
  python list_asis_programs.py --filter SCP   ProgramID LIKE 'SCP%' 만

결과: {"ok": true, "items": [{"id","name","path"}, ...]}
접속 실패/드라이버 미설치: {"ok": false, "reason": "..."} 종료코드 1 — 호출측(워크벤치)은 QuickPick 에서 "DB 미연결" 로 표시
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    import dbconn  # noqa
except Exception as e:
    print(json.dumps({"ok": False, "reason": f"dbconn import 실패: {e}"}, ensure_ascii=False))
    sys.exit(1)

flt = None
args = sys.argv[1:]
for i, a in enumerate(args):
    if a == '--filter' and i + 1 < len(args):
        flt = args[i + 1].upper()

try:
    cx = dbconn.connect('asis')
except Exception as e:
    print(json.dumps({"ok": False, "reason": f"AS-IS DB 접속 실패: {str(e).splitlines()[0][:300]}"}, ensure_ascii=False))
    sys.exit(1)

try:
    cur = cx.cursor()
    sql = "SELECT ProgramID, ProgramName, ProgramPath FROM dbo.TB_FX_ProgramInfo WHERE UseYN='Y'"
    params = []
    if flt:
        sql += " AND UPPER(ProgramID) LIKE ?"
        params.append(flt + '%')
    sql += " ORDER BY ProgramID"
    cur.execute(sql, params) if params else cur.execute(sql)
    rows = cur.fetchall()
    items = [{"id": (r[0] or '').strip(), "name": (r[1] or '').strip(), "path": (r[2] or '').strip()} for r in rows]
    items = [x for x in items if x["id"]]
    print(json.dumps({"ok": True, "items": items}, ensure_ascii=False))
except Exception as e:
    print(json.dumps({"ok": False, "reason": f"조회 실패: {str(e).splitlines()[0][:300]}"}, ensure_ascii=False))
    sys.exit(1)
finally:
    try: cx.close()
    except Exception: pass
