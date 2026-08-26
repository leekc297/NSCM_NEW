# -*- coding: utf-8 -*-
"""[E20260825-SAVEPOPCLOB] 일괄입력 팝업 동적 SQL 버퍼 CLOB 전환 — ORA-06502 정정 (hook #106 계보)"""
import io, json, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

old = """    V_Prod_Cols VARCHAR2(32767); -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정
    v_nsql VARCHAR2(4000 CHAR);"""
new = """    V_Prod_Cols VARCHAR2(32767); -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정
    v_nsql CLOB;   /* [E20260825-SAVEPOPCLOB] 구 VARCHAR2(4000) — 원장 재적재로 기간 도메인 확대(구간 99일자)
                      후 동적 PIVOT 목록(v_prod/v_prod_cols) 포함 조립이 4000 초과 = ORA-06502 (BODY 11025행 실측).
                      hook #106(대량 동적 SQL = CLOB) 표준 처방 — OPEN FOR CLOB 는 19c 네이티브 지원. */"""
assert src.count(old) == 1, "anchor not unique: %d" % src.count(old)
out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_savepop_clob.json")
out.write_text(json.dumps([{"old": old, "new": new}], ensure_ascii=False, indent=1), encoding="utf-8")
print("edits 생성")
