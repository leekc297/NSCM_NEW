#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""B-1 삭제 전 최종 확인 2가지 (조회 전용)
   (1) 남길 행('-')이 지울 행(' ')의 내용을 모두 담고 있는가 — 최신 갱신분 유실 방지
   (2) SEGMENT4 를 조건으로 쓰는 소비자가 있는가 — 있으면 삭제가 그쪽을 깨뜨린다
"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] 4행 나란히 비교 — 차이나는 컬럼만")
show(*fetch(cur, """
SELECT SEGMENT1, '['||SEGMENT4||']' seg4, SEGMENT2, SEGMENT3, SEGMENT5, DISPLAY_SEQ, VALID_YN,
       DESCRIPTION, '['||ATTRIBUTE1||']' attr1,
       TO_CHAR(CREATION_DATE,'YY-MM-DD HH24:MI') created,
       TO_CHAR(LAST_UPDATE_DATE,'YY-MM-DD HH24:MI') updated, LAST_UPDATED_BY
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2' AND SEGMENT1 IN ('LGE/KT&'||'G','동남아')
 ORDER BY SEGMENT1, SEGMENT4"""))

sec("[2] 지울 행(' ')이 남길 행('-')보다 최신인가 — 유실 위험 판정")
show(*fetch(cur, """
SELECT SEGMENT1,
       MAX(CASE WHEN SEGMENT4=' ' THEN TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') END) upd_space,
       MAX(CASE WHEN SEGMENT4='-' THEN TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') END) upd_dash,
       MAX(CASE WHEN SEGMENT4=' ' THEN DESCRIPTION END) desc_space,
       MAX(CASE WHEN SEGMENT4='-' THEN DESCRIPTION END) desc_dash,
       CASE WHEN MAX(CASE WHEN SEGMENT4=' ' THEN DESCRIPTION END)
               = MAX(CASE WHEN SEGMENT4='-' THEN DESCRIPTION END)
            THEN 'DESCRIPTION 동일' ELSE '⚠ DESCRIPTION 상이' END desc_cmp
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2' AND SEGMENT1 IN ('LGE/KT&'||'G','동남아')
 GROUP BY SEGMENT1 ORDER BY SEGMENT1"""))

sec("[3] SEGMENT4 를 조건/투영으로 쓰는 소비자 (REPORT_GROUP2 참조 객체 한정)")
show(*fetch(cur, """
SELECT owner, name, type, line, TRIM(text) txt
  FROM all_source
 WHERE UPPER(text) LIKE '%SEGMENT4%'
   AND (owner, name) IN ( SELECT owner, name FROM all_source
                           WHERE UPPER(text) LIKE '%REPORT_GROUP2%' )
 ORDER BY owner, name, line FETCH FIRST 30 ROWS ONLY"""))
cur.execute("""SELECT COUNT(*) FROM all_source
                WHERE UPPER(text) LIKE '%SEGMENT4%'
                  AND (owner, name) IN ( SELECT owner, name FROM all_source
                                          WHERE UPPER(text) LIKE '%REPORT_GROUP2%' )""")
print(f"\n  → SEGMENT4 언급 라인 총 {cur.fetchone()[0]} 건")

sec("[4] 삭제 대상 확정 쿼리 (건수 확인)")
show(*fetch(cur, """
SELECT COUNT(*) delete_target_rows
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2' AND SEGMENT4=' '
   AND EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL X
                 WHERE X.LOOKUP_TYPE='REPORT_GROUP2' AND X.SEGMENT1=SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT1
                   AND X.SEGMENT4='-' )"""))

con.close()
