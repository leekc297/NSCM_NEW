# -*- coding: utf-8 -*-
"""e_validation / v_log_type 처리 패턴 + 잔존 테스트 버전 확인"""
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

print("== e_validation / v_log_type 사용처 (P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY 범위) ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND (INSTR(TEXT,'e_validation')>0 OR INSTR(TEXT,'v_log_type')>0)
                  AND LTRIM(TEXT) NOT LIKE '--%'
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("%6d| %s" % (ln, t[:130]))

print("\n== 7726~7740 원문 (COPY 진입부) ==")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' AND LINE BETWEEN 7726 AND 7742 ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("%6d| %r" % (ln, t))

print("\n== 오늘 생성 잔존 버전 ==")
cur.execute("""SELECT VERSION_NO, VERSION_DESCRIPTION, TO_CHAR(CREATION_DATE,'HH24:MI')
                 FROM SCM_MGR.DM_MDF_VERSION WHERE CREATION_DATE > TRUNC(SYSDATE) ORDER BY CREATION_DATE""")
rows = cur.fetchall()
for r in rows:
    print("  %-24s %-16s %s" % r)
if not rows:
    print("  (없음)")

print("\n== R_S_20260810_V002 정체 (환율 727행 보유) ==")
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_MDF_VERSION WHERE VERSION_NO='R_S_20260810_V002'""")
print("  DM_MDF_VERSION 헤더 =", cur.fetchone()[0])
for t in ("DM_PLN_SALES_PLAN_REPORT_C", "DM_PLN_SALES_ETC_REPORT_C", "DM_PLN_SALES_REPORT_EXCHANGE_C"):
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.%s WHERE VERSION_NO='R_S_20260810_V002'" % t)
    print("  %-32s %d" % (t, cur.fetchone()[0]))
con.close()
