#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 이관 누락 축 전수 스윕 — 'DMF0082' 를 담는 **모든 SCM_ADM_*/SCM_MST_* 메타 테이블**을
기계적으로 찾아 기준선(2026-08-12) 이후 변경 여부를 판정한다.

⚠ 2026-08-14 사고: 델타 서베이를 테이블별로 손으로 짜다가 컬럼명 오류(BTN_ID)로 BTN 축이
   조용히 스킵됐고, 그 결과 Excel Form 버튼 배선이 패키지에서 빠졌다.
   ⇒ 축 목록을 사람이 나열하지 않고 **딕셔너리에서 기계적으로 도출**한다.
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

CUT = "2026-08-12"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ① 후보 = SCM_ADM_/SCM_MST_ 접두 + LAST_UPDATE_DATE 보유 + 'DMF0082' 를 담을 만한 문자열 컬럼 보유
cur.execute("""
  SELECT t.TABLE_NAME
    FROM ALL_TABLES t
   WHERE t.OWNER='SCM_MGR'
     AND (t.TABLE_NAME LIKE 'SCM_ADM_%' OR t.TABLE_NAME LIKE 'SCM_MST_%')
     AND t.TABLE_NAME NOT LIKE '%_H'
     AND t.TABLE_NAME NOT LIKE '%_BAK%'
     AND t.TABLE_NAME NOT LIKE '%DROP%'
     AND EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS c WHERE c.OWNER='SCM_MGR'
                  AND c.TABLE_NAME=t.TABLE_NAME AND c.COLUMN_NAME='LAST_UPDATE_DATE')
   ORDER BY 1""")
tables = [r[0] for r in cur.fetchall()]

print(f"# 후보 테이블 {len(tables)}개 — 'DMF0082' 보유 & {CUT} 이후 변경 판정\n")
hits = []
for t in tables:
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME=:t AND DATA_TYPE IN ('VARCHAR2','CHAR')""", {"t": t})
    scols = [r[0] for r in cur.fetchall()]
    if not scols:
        continue
    where = " OR ".join(f"{c} LIKE '%DMF0082%'" for c in scols)
    try:
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE {where}")
        total = cur.fetchone()[0]
        if total == 0:
            continue
        cur.execute(f"""SELECT COUNT(*), TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI')
                          FROM SCM_MGR.{t}
                         WHERE ({where}) AND LAST_UPDATE_DATE >= TO_DATE('{CUT}','YYYY-MM-DD')""")
        chg, last = cur.fetchone()
        mark = "⛔ 변경" if chg else "  동일"
        print(f"{mark}  {t:<34} 전체 {total:>5}행 / 기준선이후 {chg:>4}행  {last or ''}")
        if chg:
            hits.append((t, total, chg, last))
    except Exception as e:
        print(f"  SKIP  {t:<34} {str(e)[:60]}")

print("\n" + "=" * 96)
print(f"## 기준선 이후 변경 테이블 {len(hits)}개 — 이관 패키지에 전부 담겨야 한다")
for t, total, chg, last in hits:
    print(f"   {t:<34} 변경 {chg}행 (전체 {total}행)  최종 {last}")

con.close()
