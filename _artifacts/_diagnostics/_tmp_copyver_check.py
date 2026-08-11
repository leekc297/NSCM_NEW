# -*- coding: utf-8 -*-
"""방금 실행된 VERSION COPY 결과 추적 — 신규 버전이 어디에 만들어졌는지 / 목록에 왜 안 뜨는지"""
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

print("== 오늘 생성된 DM_MDF_VERSION 전체 ==")
cur.execute("""SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, SEND_YN,
                      TO_CHAR(CREATION_DATE,'HH24:MI:SS'), CREATED_BY, YYYYMMDD, MV_PLAN_YYYYMM
                 FROM SCM_MGR.DM_MDF_VERSION WHERE CREATION_DATE > TRUNC(SYSDATE)
                ORDER BY CREATION_DATE""")
rows = cur.fetchall()
for r in rows:
    print("  div=%s ver=%-22s desc=%-14s type=%-12s send=%s %s by=%s yyyymmdd=%s mv=%s" % r)
if not rows:
    print("  (없음)")

print("\n== 최근 30분 DMF0044 SYS_LOG (오류/정상 모두) ==")
cur.execute("""SELECT TO_CHAR(CREATION_DATE,'HH24:MI:SS'), MNU_BTN_CD, SUBSTR(EXCT_MSG_CTN,1,260)
                 FROM SCM_MGR.SCM_COM_SYS_LOG
                WHERE MNU_ID='DMF0044' AND CREATION_DATE > SYSDATE - 30/1440
                ORDER BY CREATION_DATE DESC FETCH FIRST 8 ROWS ONLY""")
for t, btn, msg in cur.fetchall():
    body = msg.read() if hasattr(msg, "read") else (msg or "")
    print("  %s [%s] %s" % (t, btn, (body or "(정상)").replace("\n", " ")[:230]))

print("\n== 원본 R_S_20260128_V002_C 헤더 ==")
cur.execute("""SELECT DIVISION_ID, VERSION_TYPE, SEND_YN, TO_CHAR(CREATION_DATE,'YYYY-MM-DD'), YYYYMMDD
                 FROM SCM_MGR.DM_MDF_VERSION WHERE VERSION_NO='R_S_20260128_V002_C'""")
for r in cur.fetchall():
    print("  div=%s type=%s send=%s created=%s yyyymmdd=%s" % r)

print("\n== 오늘자 채번 후보 (RP_/R_ + S/B + 오늘) ==")
cur.execute("""SELECT VERSION_NO, DIVISION_ID, VERSION_TYPE, TO_CHAR(CREATION_DATE,'HH24:MI:SS')
                 FROM SCM_MGR.DM_MDF_VERSION
                WHERE VERSION_NO LIKE '%' || TO_CHAR(SYSDATE,'YYYYMMDD') || '%'
                ORDER BY CREATION_DATE""")
for r in cur.fetchall():
    print("  %-24s div=%s type=%-12s %s" % r)

print("\n== 팝업 목록 SP 가 거르는 조건 확인용: 오늘 생성분의 VERSION_TYPE 분포 ==")
cur.execute("""SELECT VERSION_TYPE, SEND_YN, COUNT(*) FROM SCM_MGR.DM_MDF_VERSION
                WHERE CREATION_DATE > TRUNC(SYSDATE) GROUP BY VERSION_TYPE, SEND_YN""")
for r in cur.fetchall():
    print("  type=%-14s send=%s cnt=%s" % r)
con.close()
