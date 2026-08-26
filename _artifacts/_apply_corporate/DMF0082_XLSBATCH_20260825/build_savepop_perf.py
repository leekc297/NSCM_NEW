# -*- coding: utf-8 -*-
"""[E20260825-SAVEPOPPERF] B1 CC(직전/마지막 주차 가격) — 집계+재조인 -> KEEP LAST 단일 스캔 (등가 증명 완료)"""
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

i = src.find("PROCEDURE P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP")
j = src.find("PROCEDURE P_DMF0082", i + 50)

# CC 블록: 헤더 주석부터 ') CC' 직전까지 (81 B1 분기 내 유일)
h = src.find("\t\tLEFT JOIN (\n\t\t\t-- \ube44\uad50\uc6a9 \ub370\uc774\ud130 ( \uc9c1\uc804\uc8fc\ucc28-\uc5c6\uc73c\uba74 \ub9c8\uc9c0\ub9c9 \uc8fc\ucc28 )", i)
assert i < h < j, "CC header not found in 81 branch"
e = src.find("\t\t) CC", h)
assert h < e < j, "CC tail not found"
old = src[h:e + len("\t\t) CC")]
assert src.count(old) == 1, "CC block not unique"

new = """\t\tLEFT JOIN (
\t\t\t-- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
\t\t\t/* [E20260825-SAVEPOPPERF] 구: 전체 과거 이력 GROUP BY(MAX 일자) 후 원본 재조인 — 재적재로 과거 이력이
\t\t\t   60만행(2023~)으로 확대되며 본 팝업 67s 중 ~55s 지배 (ASH 라인20 SORT GROUP BY CPU 54샘플 실측).
\t\t\t   신: MAX(PRICE) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) 단일 스캔 — 재조인 제거.
\t\t\t   등가 실측: 6,171행·행해시 합계 동일 / 27.3s -> 0.6s (prove_cc_equiv.py 2026-08-25) */
\t\t\tSELECT
\t\t\t\tDIVISION_ID,
\t\t\t\tPROJECT_CODE,
\t\t\t\tSCM_SITE_ID,
\t\t\t\tPLANT_SITE_ID,
\t\t\t\tITEM_ID,
\t\t\t\tCURRENCY,
\t\t\t\tMEASURE,
\t\t\t\tDOM_EXP,
\t\t\t\tFCST_TYPE,
\t\t\t\tINCOTERMS,
\t\t\t\tMAX(PRICE) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS PRICE,
\t\t\t\tMAX(YYYYMMDD) AS YYYYMMDD,
\t\t\t\t'-' AS CELL_PROD_SITE_ID --[DIV81] 컬럼 부재
\t\t\tFROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/
\t\t\tWHERE DIVISION_ID = p_division_id
\t\t\tAND MEASURE = 'LOC'
\t\t\tAND YYYYMMDD < p_from_yyyymmdd
\t\t\tGROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
\t\t) CC"""

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_savepop_perf.json")
out.write_text(json.dumps([{"old": old, "new": new}], ensure_ascii=False, indent=1), encoding="utf-8")
print("edit 생성: old=%d자 new=%d자" % (len(old), len(new)))
