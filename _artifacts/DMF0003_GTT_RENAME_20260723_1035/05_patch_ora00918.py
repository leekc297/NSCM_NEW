# -*- coding: utf-8 -*-
"""ORA-00918 (MEASURE ambiguously specified) 근본 패치.
동적 PIVOT SELECT 목록 V_COLUMN 조립부(branch① titleset 'C')에서
branch②(SHEET_COLUMNS 고정컬럼 DEFAULT_FLAG '-'/' '/'')와 겹치는 컬럼을 제외 → 중복 원천 차단.
앵커 exact-match 1회. 라이브(리네임 반영) body 기준."""
import io, os, oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, "_backup_PKG_DMF0003_body_LIVE_20260723.sql")
DST = os.path.join(BASE, "06_PKG_DMF0003_body_ora00918fix.sql")

with io.open(SRC, "r", encoding="utf-8") as f:
    body = f.read()

ANCHOR = """                  AND  U.USER_ID     = P_CREATED_BY
                  AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                UNION ALL"""
NEW = """                  AND  U.USER_ID     = P_CREATED_BY
                  AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                  -- [DMF0003 ORA-00918 FIX 20260723] titleset(C) 컬럼 중 SHEET_COLUMNS 고정컬럼(branch② DEFAULT_FLAG '-'/' '/'') 과
                  -- 겹치는 것은 SELECT 목록 2회 유입 -> 인라인뷰 컬럼 ambiguous(ORA-00918). branch① 에서 제외.
                  AND  NVL(C.DEFAULT_FLAG, 'X') NOT IN ('-', ' ', '')
                UNION ALL"""

assert body.count(ANCHOR) == 1, f"anchor count={body.count(ANCHOR)}"
body = body.replace(ANCHOR, NEW)
assert body.count("[DMF0003 ORA-00918 FIX 20260723]") == 1

with io.open(DST, "w", encoding="utf-8", newline="") as f:
    f.write(body)
print("written:", DST, "lines:", body.count("\n"))

# 배포
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT=280")
cur.execute(body)
cur.execute("SELECT object_type, status FROM user_objects WHERE object_name='PKG_DMF0003'")
for r in cur.fetchall(): print("status:", r)
cur.execute("SELECT COUNT(*) FROM user_errors WHERE name='PKG_DMF0003'")
print("errors:", cur.fetchone()[0])
cur.execute("SELECT COUNT(*) FROM user_source WHERE name='PKG_DMF0003' AND type='PACKAGE BODY' AND text LIKE '%[DMF0003 ORA-00918 FIX 20260723]%'")
print("marker:", cur.fetchone()[0])
