#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0044 TRANSFER 튜닝 STEP1 — 사실 확보 (KILL 확인 / 바인드값 / 룩업 유일성 / 대상 데이터 규모)
   ※ 전부 조회 전용. DML 없음."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t):
    print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] SID 512 KILL 확인 + 잔여 DMF0044 장시간 세션")
show(*fetch(cur, """
SELECT s.sid, s.serial# AS serialno, s.status, s.last_call_et AS elapsed_sec, s.sql_id, s.event,
       SUBSTR(REPLACE(q.sql_text, CHR(10),' '),1,80) AS sql_head
  FROM v$session s LEFT JOIN v$sql q ON q.sql_id=s.sql_id AND q.child_number=s.sql_child_number
 WHERE s.type='USER' AND (s.sid=512 OR (s.status='ACTIVE' AND s.last_call_et>=120))
 ORDER BY s.last_call_et DESC"""))

sec("[2] 킬된 SQL 의 바인드 캡처 — 재현 대상 DIVISION/VERSION/YYYY 확정")
show(*fetch(cur, """
SELECT name, position, datatype_string, value_string,
       TO_CHAR(last_captured,'YYYY-MM-DD HH24:MI:SS') AS captured
  FROM v$sql_bind_capture WHERE sql_id='5dchxk6z8k7hg' ORDER BY position"""))

sec("[3] SCM_ADM_LOOKUP_MASTER_DETAIL — SELECT절 서브쿼리 2건의 조인키 유일성 실측")
show(*fetch(cur, """
SELECT LOOKUP_TYPE,
       COUNT(*) AS rows_all,
       COUNT(DISTINCT SEGMENT1) AS distinct_seg1,
       SUM(CASE WHEN c > 1 THEN 1 ELSE 0 END) AS dup_seg1_keys,
       MAX(c) AS max_rows_per_seg1
  FROM ( SELECT LOOKUP_TYPE, SEGMENT1, COUNT(*) OVER (PARTITION BY LOOKUP_TYPE, SEGMENT1) AS c
           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE IN ('MDF_DEPARTMENT','DMF0044_DEPARTMENT_TEAM2','REPORT_GROUP2') )
 GROUP BY LOOKUP_TYPE ORDER BY LOOKUP_TYPE"""))

sec("[3-1] 중복 키 실물 (있다면) — ROWNUM=1 이 어떤 임의성을 갖고 있었는지 확인")
show(*fetch(cur, """
SELECT LOOKUP_TYPE, SEGMENT1, COUNT(*) AS cnt,
       MIN(SEGMENT2) AS min_seg2, MAX(SEGMENT2) AS max_seg2,
       CASE WHEN MIN(SEGMENT2) = MAX(SEGMENT2) OR (MIN(SEGMENT2) IS NULL AND MAX(SEGMENT2) IS NULL)
            THEN 'SAME' ELSE 'DIFFERENT' END AS seg2_consistency
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE IN ('MDF_DEPARTMENT','DMF0044_DEPARTMENT_TEAM2','REPORT_GROUP2')
 GROUP BY LOOKUP_TYPE, SEGMENT1 HAVING COUNT(*) > 1
 ORDER BY LOOKUP_TYPE, SEGMENT1"""))

sec("[4] DM_MDF_VERSION PK 유일성 (ORI_VERSION_NO 서브쿼리 → JOIN 전환 안전성)")
show(*fetch(cur, """
SELECT c.constraint_name, c.constraint_type, cc.position, cc.column_name
  FROM all_constraints c JOIN all_cons_columns cc
    ON cc.owner=c.owner AND cc.constraint_name=c.constraint_name
 WHERE c.owner='SCM_MGR' AND c.table_name='DM_MDF_VERSION' AND c.constraint_type IN ('P','U')
 ORDER BY c.constraint_name, cc.position"""))

sec("[5] SCM_MST_ITEM_SN 규모 / 통계 / 인덱스 (병목 근원 테이블)")
show(*fetch(cur, """
SELECT o.owner, o.object_type, t.table_name, t.num_rows, t.blocks,
       TO_CHAR(t.last_analyzed,'YYYY-MM-DD HH24:MI') AS last_analyzed
  FROM all_objects o LEFT JOIN all_tables t ON t.owner=o.owner AND t.table_name=o.object_name
 WHERE o.object_name IN ('SCM_MST_ITEM_SN','SCM_ITEM_M') AND o.object_type IN ('TABLE','SYNONYM')"""))
show(*fetch(cur, """
SELECT s.owner, s.synonym_name, s.table_owner, s.table_name
  FROM all_synonyms s WHERE s.synonym_name IN ('SCM_MST_ITEM_SN','SCM_ITEM_M')"""))

sec("[6] 병목 테이블 인덱스 (2순위 SARGable 판단 재료)")
show(*fetch(cur, """
SELECT i.owner, i.index_name, i.uniqueness, i.num_rows, c.column_position, c.column_name
  FROM all_indexes i JOIN all_ind_columns c
    ON c.index_owner=i.owner AND c.index_name=i.index_name
 WHERE i.index_name LIKE '%SCM_ITEM_M%' OR i.index_name LIKE '%ITEM_SN%'
 ORDER BY i.owner, i.index_name, c.column_position"""))

con.close()
