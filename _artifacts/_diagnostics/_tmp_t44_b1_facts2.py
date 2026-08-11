#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""B-1 사실확보 (2) — 어느 행이 '이상치'인지 분포로 판정 + 영향범위 (조회 전용)

발견: 두 행은 '중복'이 아니라 **센티널 변형**이다. PK=(LOOKUP_TYPE,SEGMENT1,SEGMENT2,
      SEGMENT3,SEGMENT4,SEGMENT5) 이고 SEGMENT4 만 ' ' vs '-' 로 달라 제약을 통과했다.
      ([[feedback_pk_sentinel_normalization]] 계열 — MSSQL '' → Oracle 이관 시 관례 2종 혼재)
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

sec("[4] REPORT_GROUP2 의 SEGMENT4 값 분포 — 어느 쪽이 관례인가")
show(*fetch(cur, """
SELECT '['||SEGMENT4||']' AS segment4, COUNT(*) rows_,
       ROUND(RATIO_TO_REPORT(COUNT(*)) OVER ()*100,1) pct
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='REPORT_GROUP2'
 GROUP BY SEGMENT4 ORDER BY rows_ DESC"""))

sec("[4-b] 같은 SEGMENT1 이 SEGMENT4 두 값을 모두 갖는 키 (= 이번 문제 키)")
show(*fetch(cur, """
SELECT SEGMENT1, COUNT(*) cnt,
       LISTAGG('['||SEGMENT4||']', ' , ') WITHIN GROUP (ORDER BY SEGMENT4) segment4_values
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='REPORT_GROUP2'
 GROUP BY SEGMENT1 HAVING COUNT(*)>1 ORDER BY SEGMENT1"""))

sec("[4-c] 전체 LOOKUP_TYPE 범위에서 같은 병이 또 있는가 (SEGMENT1 중복)")
show(*fetch(cur, """
SELECT LOOKUP_TYPE, COUNT(*) dup_keys, SUM(cnt) rows_involved
  FROM ( SELECT LOOKUP_TYPE, SEGMENT1, COUNT(*) cnt
           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          GROUP BY LOOKUP_TYPE, SEGMENT1 HAVING COUNT(*)>1 )
 GROUP BY LOOKUP_TYPE ORDER BY rows_involved DESC FETCH FIRST 20 ROWS ONLY"""))

sec("[5] 영향범위 — REPORT_GROUP2 참조 DB 객체 전수")
show(*fetch(cur, """SELECT owner, name, type, COUNT(*) hit_lines FROM all_source
                     WHERE UPPER(text) LIKE '%REPORT_GROUP2%'
                     GROUP BY owner, name, type ORDER BY owner, name"""))

sec("[6] 삭제 후보(' ' 행)를 SEGMENT4 로 참조하는 곳이 있는가 — SEGMENT4 사용 여부")
show(*fetch(cur, """SELECT owner, name, type, line, TRIM(text) txt FROM all_source
                     WHERE UPPER(text) LIKE '%REPORT_GROUP2%'
                       AND owner='SCM_MGR' ORDER BY name, line FETCH FIRST 40 ROWS ONLY"""))

con.close()
