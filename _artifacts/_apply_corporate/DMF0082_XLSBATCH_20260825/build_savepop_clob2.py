# -*- coding: utf-8 -*-
"""[E20260825-SAVEPOPCLOB2] 일괄입력 팝업 동적 PIVOT 목록 — LISTAGG(4000 한계) -> CLOB 루프 집계"""
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

edits = []

def add(old, new):
    assert src.count(old) == 1, "not unique (%d): %s" % (src.count(old), old[:70])
    edits.append({"old": old, "new": new})

# 선언: V_Prod / V_Prod_Cols -> CLOB (v_nsql 은 SAVEPOPCLOB 에서 이미 CLOB)
add("""    V_Prod VARCHAR2(32767);
    V_Prod_Cols VARCHAR2(32767); -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정""",
    """    V_Prod CLOB;        /* [E20260825-SAVEPOPCLOB2] 구 VARCHAR2(32767) — CLOB 통일 (동적 PIVOT 목록) */
    V_Prod_Cols CLOB;   -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정 [E20260825-SAVEPOPCLOB2] CLOB""")

# LISTAGG -> CLOB 루프
add("""	SELECT LISTAGG('''' || A.YYYYMMDD || ''' AS "' || A.YYYYMMDD || '"', ',') WITHIN GROUP (ORDER BY YYYYMMDD) -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정
	     , LISTAGG('"' || A.YYYYMMDD || '"', ',') WITHIN GROUP (ORDER BY YYYYMMDD)
	INTO V_Prod, V_Prod_Cols
	FROM (
	    SELECT DISTINCT YYYYMMDD FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE
	) A;""",
    """	/* [E20260825-SAVEPOPCLOB2] 구 LISTAGG — SQL VARCHAR2 4000 한계로 재적재(기간 일자 도메인 확대) 후
	   ORA-01489 (BODY 10767행 실측, 구간 20260824~20270125). CLOB 루프 집계로 상한 제거 (기능 등가 — 정렬·구분자 동일). */
	V_Prod := NULL; V_Prod_Cols := NULL;
	FOR r IN (SELECT DISTINCT YYYYMMDD FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE ORDER BY YYYYMMDD) LOOP
	    IF V_Prod IS NOT NULL THEN
	        V_Prod := V_Prod || ','; V_Prod_Cols := V_Prod_Cols || ',';
	    END IF;
	    V_Prod      := V_Prod      || '''' || r.YYYYMMDD || ''' AS "' || r.YYYYMMDD || '"';
	    V_Prod_Cols := V_Prod_Cols || '"' || r.YYYYMMDD || '"';
	END LOOP;""")

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_savepop_clob2.json")
out.write_text(json.dumps(edits, ensure_ascii=False, indent=1), encoding="utf-8")
print("edits %d건 생성" % len(edits))
