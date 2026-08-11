# -*- coding: utf-8 -*-
"""사용자가 Delete 를 시도한 버전들의 현재 상태 + 최근 ACTION 로그 상관"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("== division 40 REPORT 버전 — 최근 갱신순 20 ==")
cur.execute("""SELECT VERSION_NO, VERSION_TYPE, SEND_YN,
                      TO_CHAR(CREATION_DATE,'MM-DD HH24:MI'), TO_CHAR(LAST_UPDATE_DATE,'MM-DD HH24:MI'),
                      NVL(VERSION_DESCRIPTION,'<NULL>')
                 FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID='40' AND VERSION_TYPE LIKE 'REPORT%'
                ORDER BY NVL(LAST_UPDATE_DATE, CREATION_DATE) DESC FETCH FIRST 20 ROWS ONLY""")
for r in cur.fetchall():
    print("  %-26s %-12s send=%s  cre=%s  upd=%s  desc=%s" % r)

print("\n== 최근 2시간 DMF0044 ACTION 호출 (성공/실패 모두) ==")
cur.execute("""SELECT TO_CHAR(CREATION_DATE,'HH24:MI:SS'), MNU_BTN_CD,
                      CASE WHEN EXCT_MSG_CTN IS NULL THEN '정상' ELSE '오류' END
                 FROM SCM_MGR.SCM_COM_SYS_LOG
                WHERE MNU_ID='DMF0044' AND MNU_BTN_CD IN ('ACTION','TRANSFER')
                  AND CREATION_DATE > SYSDATE - 2/24
                ORDER BY CREATION_DATE DESC FETCH FIRST 15 ROWS ONLY""")
for r in cur.fetchall():
    print("  %s [%s] %s" % r)

print("\n== SEND_YN 분포 (div 40 REPORT) ==")
cur.execute("""SELECT SEND_YN, COUNT(*) FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID='40' AND VERSION_TYPE LIKE 'REPORT%' GROUP BY SEND_YN ORDER BY 1""")
for r in cur.fetchall():
    print("  send=%s  %d건" % r)

print("\n== 목록 SP 가 지금 돌려주는 오늘 생성분 ==")
cur.execute("""SELECT VERSION_NO, SEND_YN, NVL(VERSION_DESCRIPTION,'<NULL>')
                 FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID='40' AND CREATION_DATE > TRUNC(SYSDATE)
                ORDER BY CREATION_DATE""")
for r in cur.fetchall():
    print("  %-26s send=%s desc=%s" % r)
con.close()
