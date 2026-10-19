# -*- coding: utf-8 -*-
"""NULL 정규화 조인이 실제로 매칭되는지 — 모의 행으로 논리 증명 (영구 데이터 무변경)"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()
SQL = """
WITH DEMAND AS (   -- 수요 행: PLANT_SITE_ID = NULL (클라우드 실측)
  SELECT 'NT' PROJECT_CODE, CAST(NULL AS VARCHAR2(50)) PLANT_SITE_ID FROM DUAL
), PRICE AS (      -- 단가 행: PLANT_SITE_ID = '-' (클라우드 실측)
  SELECT 'NT' PROJECT_CODE, '-' PLANT_SITE_ID, 'USD' CURRENCY FROM DUAL
)
SELECT '구 조인 (A.col = B.col)' AS 방식,
       (SELECT COUNT(*) FROM DEMAND D JOIN PRICE P
          ON P.PROJECT_CODE = D.PROJECT_CODE AND P.PLANT_SITE_ID = D.PLANT_SITE_ID) AS 매칭행수
  FROM DUAL
UNION ALL
SELECT '신 조인 (NVL 정규화)',
       (SELECT COUNT(*) FROM DEMAND D JOIN PRICE P
          ON NVL(P.PROJECT_CODE,'-') = NVL(D.PROJECT_CODE,'-')
         AND NVL(P.PLANT_SITE_ID,'-') = NVL(D.PLANT_SITE_ID,'-'))
  FROM DUAL
UNION ALL
SELECT '신 조인 (양쪽 모두 NULL)',
       (SELECT COUNT(*) FROM (SELECT CAST(NULL AS VARCHAR2(50)) C FROM DUAL) X
          JOIN (SELECT CAST(NULL AS VARCHAR2(50)) C FROM DUAL) Y
            ON NVL(X.C,'-') = NVL(Y.C,'-'))
  FROM DUAL
UNION ALL
SELECT '구 조인 (양쪽 모두 NULL)',
       (SELECT COUNT(*) FROM (SELECT CAST(NULL AS VARCHAR2(50)) C FROM DUAL) X
          JOIN (SELECT CAST(NULL AS VARCHAR2(50)) C FROM DUAL) Y ON X.C = Y.C)
  FROM DUAL"""
cur.execute(SQL)
print("MERGE ON 의 NULL 거동 증명")
for r in cur:
    print("   {:28s} 매칭 {}행   {}".format(r[0], r[1], "OK" if r[1] else "매칭 실패"))
