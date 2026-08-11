#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MAIN GRID 편집셀 미표시 — 실측 진단 (조회 전용)
   가설 A: Transfer 로 SEND_YN='Y' 가 되어 화면이 잠긴 것(정상 동작)
   가설 B: EDITFLAGSTD 미적용으로 EDIT_FLAG 판정이 구식(ADMIN 리터럴)인 것
   가설 C: B-1 삭제 영향 (REPORT_GROUP2) — MAIN GRID 경로에 없으면 배제
"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

sec("[가설 A] Transfer 실행 여부 + SEND_YN 상태 (division 40 최근 버전)")
show(*fetch(cur, """
SELECT VERSION_NO, VERSION_TYPE, SEND_YN, ORI_VERSION_NO,
       TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI:SS') updated, LAST_UPDATED_BY
  FROM DM_MDF_VERSION WHERE DIVISION_ID='40'
 ORDER BY LAST_UPDATE_DATE DESC FETCH FIRST 8 ROWS ONLY"""))

sec("[가설 A-b] 최근 BUTTON 로그 (Transfer / SEARCH 실행 이력)")
show(*fetch(cur, """
SELECT TO_CHAR(LOG_ST_DTM,'HH24:MI:SS') t, MNU_ID, MNU_BTN_CD, SHT_NM,
       SUBSTR(EXCT_MSG_CTN,1,90) err
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0044' AND LOG_ST_DTM > SYSTIMESTAMP - INTERVAL '60' MINUTE
 ORDER BY LOG_ST_DTM DESC FETCH FIRST 20 ROWS ONLY"""))

sec("[가설 B] 사용자 minyonglee1 의 권한그룹 — EDIT_FLAG 판정식 입력값")
show(*fetch(cur, """
SELECT * FROM (
  SELECT USER_ID, GROUP_ID FROM SCM_ADM_USER_GR_M WHERE USER_ID='minyonglee1'
) ORDER BY GROUP_ID"""))

sec("[가설 B-b] 라이브 EDIT_FLAG 판정식 원문 (MAIN GRID)")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND (UPPER(TEXT) LIKE '%EDIT_FLAG%' OR UPPER(TEXT) LIKE '%V_GROUP_ID%')
                ORDER BY LINE""")
for ln, tx in cur.fetchall():
    print(f"    L{ln:5d} | {tx.rstrip()[:170]}")

sec("[가설 C] MAIN GRID SP 가 REPORT_GROUP2 를 쓰는가 (B-1 영향 판정)")
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 1063 AND 1714 AND UPPER(TEXT) LIKE '%REPORT_GROUP2%'""")
n = cur.fetchone()[0]
print(f"    P_DMF0044_GET_SALES_REPORTS_DATA(L1063~1714) 내 REPORT_GROUP2 참조 = {n} 건"
      f"   {'⇒ B-1 무관 ✅' if n == 0 else '⇒ 영향 검토 필요'}")

sec("[실측] MAIN GRID 원장의 DATA_TYPE 분포 — EDIT_FLAG 조건 (DATA_TYPE='2') 충족 여부")
show(*fetch(cur, """
SELECT VERSION_NO, DATA_TYPE, COUNT(*) rows_
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID='40'
   AND VERSION_NO IN (SELECT VERSION_NO FROM (
        SELECT VERSION_NO FROM DM_MDF_VERSION WHERE DIVISION_ID='40'
         ORDER BY LAST_UPDATE_DATE DESC FETCH FIRST 3 ROWS ONLY))
 GROUP BY VERSION_NO, DATA_TYPE ORDER BY VERSION_NO, DATA_TYPE"""))

con.close()
