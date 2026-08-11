#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ETC 저장 무반영 진단 — BE 호출 로그 + SP 로그 + 원장 실제 변화 (조회 전용)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] 최근 DMF0044 BUTTON 로그 (SAVE 계열 포함) — 무엇이 호출됐나")
show(*fetch(cur, """
SELECT TO_CHAR(LOG_ST_DTM,'HH24:MI:SS') t, MNU_BTN_CD, SHT_NM, CALL_PGM_URL,
       CASE WHEN EXCT_MSG_CTN IS NULL THEN '-' ELSE SUBSTR(EXCT_MSG_CTN,1,70) END err
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0044' AND LOG_ST_DTM > SYSTIMESTAMP - INTERVAL '45' MINUTE
 ORDER BY LOG_ST_DTM DESC FETCH FIRST 25 ROWS ONLY"""))

sec("[2] 가장 최근 SAVE 호출의 payload 전문 (무엇을 보냈나)")
cur.execute("""
SELECT TO_CHAR(LOG_ST_DTM,'HH24:MI:SS'), MNU_BTN_CD, CALL_PGM_URL, SYS_LOG_MSG_CTN, EXCT_MSG_CTN
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0044' AND UPPER(MNU_BTN_CD) LIKE '%SAVE%'
   AND LOG_ST_DTM > SYSTIMESTAMP - INTERVAL '45' MINUTE
 ORDER BY LOG_ST_DTM DESC FETCH FIRST 3 ROWS ONLY""")
rows = cur.fetchall()
if not rows:
    print("  ⚠ 최근 45분 내 SAVE 계열 BUTTON 로그 없음 — 버튼코드가 다르거나 호출 자체가 없었음")
else:
    for r in rows:
        t, btn, url, payload, err = r
        pl = payload.read() if hasattr(payload, 'read') else payload
        er = err.read() if hasattr(err, 'read') else err
        print(f"\n  --- {t} / {btn} / {url}")
        print(f"  payload: {str(pl)[:2500]}")
        print(f"  error  : {str(er)[:600] if er else '(없음)'}")

sec("[3] SP 배치 로그 — 저장 SP 가 실제로 돌았나 / 몇 건 처리했나")
show(*fetch(cur, """
SELECT TO_CHAR(EVENT_DATE,'HH24:MI:SS') t, PROGRAM_NAME, LOG_TYPE,
       SUBSTR(LOG_MESSAGE,1,90) msg, SUBSTR(DESCRIPTION,1,120) descr,
       SQL_ERR_CODE, SUBSTR(SQL_ERR_MSG,1,90) err
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE EVENT_DATE > SYSDATE - 45/1440
 ORDER BY EVENT_DATE DESC FETCH FIRST 25 ROWS ONLY"""))

sec("[4] 원장 최근 변경 — ETC 저장 대상표/조회 원천표 각각 (읽는 표 ≠ 쓰는 표 확인)")
for tbl in ('DM_PLN_SALES_ETC_REPORT_C', 'DM_PLN_SALES_PLAN_REPORT_C'):
    try:
        show(*fetch(cur, f"""
        SELECT '{tbl}' tbl, VERSION_NO, COUNT(*) rows_,
               TO_CHAR(MAX(LAST_UPDATE_DATE),'HH24:MI:SS') last_upd,
               MAX(LAST_UPDATED_BY) last_by
          FROM {tbl}
         WHERE DIVISION_ID='40' AND LAST_UPDATE_DATE > SYSDATE - 45/1440
         GROUP BY VERSION_NO ORDER BY last_upd DESC"""))
    except Exception as e:
        print(f"  {tbl}: {str(e)[:150]}")

sec("[5] API_M 배선 — DMF0044 의 SAVE 계열 버튼이 어떤 SP 로 연결돼 있나")
show(*fetch(cur, """
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, PROC_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE MNU_ID='DMF0044' ORDER BY SHT_NM, MNU_BTN_CD"""))

con.close()
