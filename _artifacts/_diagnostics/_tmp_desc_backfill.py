# -*- coding: utf-8 -*-
"""금일 생성 VERSION 의 VERSION_DESCRIPTION NULL → 센티널 '-' 백필 (사용자 지시 2026-08-10)

- 대상: DM_MDF_VERSION 중 **오늘 생성 + DESCRIPTION IS NULL** (범위 최소화 — 과거분 미변경)
- 값: '-' (사용자 확정. hook #119 §1.5 센티널 표준)
- 감사컬럼: LAST_UPDATED_BY 는 원본 보존(메타가 아닌 업무 원장이라 'admin' 고정 대상 아님) —
  변경 사실은 LAST_UPDATE_DATE 로 남긴다.
"""
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

print("== BEFORE ==")
cur.execute("""SELECT DIVISION_ID, VERSION_NO,
                      CASE WHEN VERSION_DESCRIPTION IS NULL THEN '<NULL>' ELSE VERSION_DESCRIPTION END,
                      TO_CHAR(CREATION_DATE,'HH24:MI:SS')
                 FROM SCM_MGR.DM_MDF_VERSION WHERE CREATION_DATE > TRUNC(SYSDATE) ORDER BY CREATION_DATE""")
for r in cur.fetchall():
    print("  div=%s %-24s desc=%-14s %s" % r)

cur.execute("""UPDATE SCM_MGR.DM_MDF_VERSION
                  SET VERSION_DESCRIPTION = '-', LAST_UPDATE_DATE = SYSDATE
                WHERE CREATION_DATE > TRUNC(SYSDATE) AND VERSION_DESCRIPTION IS NULL""")
print("\n  UPDATE %d건" % cur.rowcount)
con.commit()

print("\n== AFTER ==")
cur.execute("""SELECT DIVISION_ID, VERSION_NO,
                      CASE WHEN VERSION_DESCRIPTION IS NULL THEN '<NULL>' ELSE VERSION_DESCRIPTION END,
                      TO_CHAR(CREATION_DATE,'HH24:MI:SS')
                 FROM SCM_MGR.DM_MDF_VERSION WHERE CREATION_DATE > TRUNC(SYSDATE) ORDER BY CREATION_DATE""")
for r in cur.fetchall():
    print("  div=%s %-24s desc=%-14s %s" % r)

cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_MDF_VERSION
                WHERE VERSION_DESCRIPTION IS NULL AND SEND_YN <> 'D'""")
print("\n  전 원장 잔존 NULL(비삭제) =", cur.fetchone()[0])
con.close()
