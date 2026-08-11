# -*- coding: utf-8 -*-
"""가설 검증: VERSION_DESCRIPTION 이 NULL 이면 목록 LIKE 필터에서 탈락하는가"""
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

print("== 오늘 생성분의 VERSION_DESCRIPTION NULL 여부 ==")
cur.execute("""SELECT VERSION_NO,
                      CASE WHEN VERSION_DESCRIPTION IS NULL THEN '<NULL>' ELSE VERSION_DESCRIPTION END,
                      LENGTH(VERSION_DESCRIPTION)
                 FROM SCM_MGR.DM_MDF_VERSION WHERE CREATION_DATE > TRUNC(SYSDATE) ORDER BY CREATION_DATE""")
for r in cur.fetchall():
    print("  %-24s desc=%-14s len=%s" % r)

print("\n== 현행 필터식 재현 (P_DESCRIPTION='') ==")
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID='40' AND VERSION_TYPE='REPORT_SP_W' AND SEND_YN <> 'D'
                  AND CREATION_DATE >= TRUNC(SYSDATE) AND CREATION_DATE < TRUNC(SYSDATE)+1
                  AND VERSION_DESCRIPTION LIKE '%' || '' || '%'""")
print("  현행 (VERSION_DESCRIPTION LIKE '%%') → %d 행" % cur.fetchone()[0])

cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID='40' AND VERSION_TYPE='REPORT_SP_W' AND SEND_YN <> 'D'
                  AND CREATION_DATE >= TRUNC(SYSDATE) AND CREATION_DATE < TRUNC(SYSDATE)+1
                  AND NVL(VERSION_DESCRIPTION,'-') LIKE '%' || '' || '%'""")
print("  정정 (NVL(...,'-') LIKE '%%')       → %d 행" % cur.fetchone()[0])

print("\n== 전체 원장에서 DESCRIPTION NULL 인 버전 수 (숨겨진 버전 규모) ==")
cur.execute("""SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.DM_MDF_VERSION
                WHERE VERSION_DESCRIPTION IS NULL AND SEND_YN <> 'D'
                GROUP BY DIVISION_ID ORDER BY 1""")
rows = cur.fetchall()
for r in rows:
    print("  div=%-6s %d건" % r)
if not rows:
    print("  (없음)")
con.close()
