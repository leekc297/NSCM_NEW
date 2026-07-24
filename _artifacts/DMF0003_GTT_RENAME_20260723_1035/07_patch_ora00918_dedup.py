# -*- coding: utf-8 -*-
"""ORA-00918 올바른 패치 = 최종 컬럼목록 COLUMN_NAME dedup (ROW_NUMBER rn=1).
 branch blanket 제거(오답, 정상컬럼 손실) 대신, 중복 COLUMN_NAME 만 첫 행 채택.
 사내(중복0)=무영향 / 클라우드(MEASURE 중복)=교정. 앵커 exact-match."""
import io, os
BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, "_backup_PKG_DMF0003_body_LIVE_20260723.sql")
DST = os.path.join(BASE, "08_PKG_DMF0003_body_ora00918_dedup.sql")
with io.open(SRC,"r",encoding="utf-8") as f: body=f.read()

A1 = ("        SELECT U.COLUMN_NAME\n"
      "             , U.SORT_ORDER_NO\n"
      "        FROM  ( SELECT U.COLUMN_NAME\n")
N1 = ("        SELECT COLUMN_NAME, SORT_ORDER_NO FROM (   -- [DMF0003 ORA-00918 FIX 20260723] COLUMN_NAME 중복 dedup\n"
      "        SELECT U.COLUMN_NAME\n"
      "             , U.SORT_ORDER_NO\n"
      "             , ROW_NUMBER() OVER (PARTITION BY U.COLUMN_NAME ORDER BY TO_NUMBER(U.SORT_ORDER_NO)) AS RN918\n"
      "        FROM  ( SELECT U.COLUMN_NAME\n")

A2 = ("                  AND  C.VALID_YN     = 'Y' ) U\n"
      "        ORDER BY TO_NUMBER(U.SORT_ORDER_NO)\n")
N2 = ("                  AND  C.VALID_YN     = 'Y' ) U\n"
      "        )\n"
      "        WHERE RN918 = 1   -- [DMF0003 ORA-00918 FIX 20260723] 중복 COLUMN_NAME 첫 행만 (dedup)\n"
      "        ORDER BY TO_NUMBER(SORT_ORDER_NO)\n")

assert body.count(A1)==1, f"A1={body.count(A1)}"
assert body.count(A2)==1, f"A2={body.count(A2)}"
body = body.replace(A1,N1).replace(A2,N2)
assert body.count("[DMF0003 ORA-00918 FIX 20260723]")==2
with io.open(DST,"w",encoding="utf-8",newline="") as f: f.write(body)
print("written:", DST, "lines:", body.count("\n"))
