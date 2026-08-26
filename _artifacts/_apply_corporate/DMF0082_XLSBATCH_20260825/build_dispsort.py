# -*- coding: utf-8 -*-
"""[E20260826-DISPSORT] MAIN/CURRENT 행 정렬 = 표시값 정합 — END_CUSTOMER 정렬 키를 비40 한정
   사이트 파생 고객명(FE ENDCUSTDISP 동일 축)으로 치환. 최종 SQL 을 XFIN 래퍼로 감싸 정규 상관(캡처 0)."""
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

def add(old, new, expect=1):
    n = src.count(old)
    assert n == expect, "count %d != %d: %s" % (n, expect, old[:80])
    edits.append({"old": old, "new": new})

DISP_EXPR = ("CASE WHEN XFIN.DIVISION_ID = ''40'' THEN XFIN.END_CUSTOMER "
             "ELSE NVL((SELECT MAX(S9.END_CUSTOMER) FROM SCM_MGR.SCM_MST_SITE S9 "
             "WHERE S9.DIVISION_ID = XFIN.DIVISION_ID AND S9.SCM_SITE_ID = XFIN.SCM_SITE_ID "
             "AND S9.SITE_TYPE = ''SALES'' AND S9.VALID_YN = ''Y''), XFIN.END_CUSTOMER) END")

ORD_PATCH = """
    /* [E20260826-DISPSORT] 행 정렬 = 화면 표시값 정합 (사용자 신고 2026-08-26: Audi->VW 일부->BMW).
       비40 그리드의 END_CUSTOMER 표시값은 FE 가 사이트 파생 고객명(ENDCUSTDISP)으로 교체하는데
       정렬 키는 원장값(=프로젝트 코드)이라 표시 기준으로 어긋나 보인다(사내 실호출 재현).
       정렬 키만 동일 파생식(사이트->고객명, SALES/VALID)으로 치환 — 40 은 원값 유지(회귀 0).
       XFIN = 최종 SQL 래퍼 별칭 (아래 OPEN 직전 래핑) — 정규 상관으로 컬럼 캡처 위험 제거. */
    IF INSTR(V_ORDERBY, 'END_CUSTOMER') > 0 THEN
        V_ORDERBY := REPLACE(V_ORDERBY, 'END_CUSTOMER',
            '""" + DISP_EXPR + """');
    END IF;
"""

# ---- GET: ① V_ORDERBY 후처리 뒤 치환 추가 ----
old_g1 = """    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

    -- ====================================================================================================
    -- 권한 그룹 조회"""
new_g1 = """    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
""" + ORD_PATCH + """
    -- ====================================================================================================
    -- 권한 그룹 조회"""
add(old_g1, new_g1)

# ---- GET: ② 최종 조립 — ORDER BY 를 래퍼 밖으로 ----
old_g2 = """    V_SQL := REPLACE(V_SQL, '[@V_ORDERBY]',     V_ORDERBY);

    OPEN O_RC1 FOR V_SQL;"""
new_g2 = """    V_SQL := REPLACE(V_SQL, '[@V_ORDERBY]',     '');
    /* [E20260826-DISPSORT] XFIN 래퍼 — ORDER BY 를 래퍼 밖에 부착 (파생 정렬식의 정규 상관 대상) */
    V_SQL := 'SELECT * FROM (' || CHR(10) || V_SQL || CHR(10) || ') XFIN ' || V_ORDERBY;

    OPEN O_RC1 FOR V_SQL;"""
add(old_g2, new_g2)

# ---- CURRENT: ① 동일 치환 추가 ----
old_c1 = """    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');   /* CAST ... NUMERIC(10,2) */
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');"""
new_c1 = """    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');   /* CAST ... NUMERIC(10,2) */
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
""" + ORD_PATCH
add(old_c1, new_c1)

# ---- CURRENT: ② 최종 조립 래퍼 ----
old_c2 = "    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',     V_ORDERBY);"
new_c2 = """    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',     '');
    /* [E20260826-DISPSORT] XFIN 래퍼 (GET 지점과 동일) */
    V_SQL_TEXT := 'SELECT * FROM (' || CHR(10) || V_SQL_TEXT || CHR(10) || ') XFIN ' || V_ORDERBY;"""
add(old_c2, new_c2)

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_dispsort.json")
out.write_text(json.dumps(edits, ensure_ascii=False, indent=1), encoding="utf-8")
print("edits %d건 생성" % len(edits))
