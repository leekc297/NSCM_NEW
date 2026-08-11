#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""EDIT_FLAG 실측 — BE 로그의 실제 파라미터 그대로 SP 호출 (조회 SP, 부작용 없음)
   DATA_TYPE 1(Cutoff) / 2(ETC) 각각 EDIT_FLAG 분포를 본다."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 600000
cur = con.cursor()

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

sec("[0] SP 파라미터 목록 (호출 정합 확인)")
show(*fetch(cur, """SELECT position, argument_name, data_type, in_out
                      FROM all_arguments WHERE owner='SCM_MGR' AND package_name='PKG_DMF0044'
                       AND object_name='P_DMF0044_GET_SALES_REPORTS_DATA' ORDER BY position"""))

sec("[1] V_GROUP_ID 판정식 직접 평가 (AUTHUNION 포함) — P_USER_GROUP='minyonglee1'")
for label, ug, uid, cby in (("BE 실제 전달값", 'minyonglee1', 'minyonglee1', 'minyonglee1'),):
    cur.execute("""
    SELECT CASE WHEN EXISTS (
             SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
              WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND VALID_YN='Y' AND SEGMENT2='ALL'
                AND ( SEGMENT1 = :p_ug
                      OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                       WHERE G.USER_ID IN (:p_ug, :p_uid, :p_cby) AND G.USE_YN='Y') )
           ) THEN 'ADMIN' ELSE '(빈값)' END FROM DUAL""",
                {"p_ug": ug, "p_uid": uid, "p_cby": cby})   # :uid 는 Oracle 내장함수명 → ORA-01745
    print(f"  {label}: V_GROUP_ID = {cur.fetchone()[0]!r}")

sec("[1-b] 이 사용자의 보유 그룹 vs GET_ADMIN_GROUP 등재 현황")
show(*fetch(cur, """SELECT USER_ID, USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                     WHERE USER_ID='minyonglee1' ORDER BY USER_GR_ID"""))
show(*fetch(cur, """SELECT SEGMENT1, SEGMENT2, VALID_YN FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' ORDER BY SEGMENT2, SEGMENT1"""))

sec("[2] SP 실호출 — DATA_TYPE 1(Cutoff) / 2(ETC) 별 EDIT_FLAG 분포")
for dt, nm in (('1', 'Cutoff'), ('2', 'ETC')):
    try:
        c_data = con.cursor(); c_res = con.cursor()
        # 파라미터 순서 = SP 정의 그대로: (DIVISION, MDF_TYPE, YYYY, SP_VERSION_NO, DATA_TYPE,
        #   USER_GROUP, CREATED_BY, USER_ID, MNU_ID, O_RC1, O_RESULT)
        #   ⚠ BE 실제 전달: USER_GROUP='minyonglee1', CREATED_BY=sesUserId=NULL, USER_ID='minyonglee1'
        cur.callproc("PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA",
                     ['40', 'REPORT_SP_W', '2026', 'R_S_20260810_V009_C', dt,
                      'minyonglee1', None, 'minyonglee1', 'DMF0044', c_data, c_res])
        cols = [x[0] for x in c_data.description]
        rows = c_data.fetchall()
        if 'EDIT_FLAG' in cols:
            i = cols.index('EDIT_FLAG')
            from collections import Counter
            cnt = Counter(r[i] for r in rows)
            print(f"  DATA_TYPE={dt} ({nm}) : {len(rows):,}행 / EDIT_FLAG 분포 {dict(cnt)}")
        else:
            print(f"  DATA_TYPE={dt} ({nm}) : {len(rows):,}행 / ⚠ EDIT_FLAG 컬럼 없음 — cols={cols[:15]}")
    except Exception as e:
        print(f"  DATA_TYPE={dt} ({nm}) : ⛔ {str(e)[:200]}")

con.close()
