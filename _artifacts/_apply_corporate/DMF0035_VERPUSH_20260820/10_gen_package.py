# -*- coding: utf-8 -*-
"""VERPUSH 적용본 → 클라우드 패키지 13_PKG_DMF0035_BODY.sql 재생성 (SQL*Plus 실행 가능 형식).

⚠ 재발방지(2026-08-20 실사고): 기존 파일에서 `"PACKAGE BODY"` 문자열 **첫 출현 위치**로 잘라 prefix 를
  만들었더니 그 문자열이 **헤더 주석 줄 안**에 있어 `CREATE OR REPLACE ...` 가 통째로 주석에 먹혔다.
  ⇒ 파일을 **새로 조립**한다: 헤더 주석 + SET + `CREATE OR REPLACE ` + 라이브 본문 + `/` + SHOW ERRORS.
  ⚠ `SET SQLBLANKLINES ON` 필수 — 본문 중간 빈 줄에서 SQL*Plus 가 문장을 끊는다.
  ⚠ `SET DEFINE OFF` 필수 — 본문의 `&` 가 치환 변수로 해석되는 것을 막는다.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

DIR = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB"
FNAME = "13_PKG_DMF0035_BODY.sql"
PKG = "PKG_DMF0035"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
               AND TYPE='PACKAGE BODY' ORDER BY LINE""", {"n": PKG})
body = "\n".join(r[0].rstrip("\n") for r in cur.fetchall()).strip()
assert body.upper().startswith("PACKAGE BODY"), body[:80]
assert "E20260820-DS2" in body, "DS2 마커 부재 — 중단"
assert body.count("E20260820-VERPUSH") == 6, f"VERPUSH 마커 {body.count('E20260820-VERPUSH')} (기대 6) — 중단"
assert body.count("VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)") == 6

text = (
    f"-- DMF0035_CLOUD_20260820 / {FNAME}\n"
    f"-- {PKG} PACKAGE BODY — MKT FCST Waterfall (사내 라이브 재덤프 2026-08-20)\n"
    f"--   [E20260820-DS2]      클라우드 optimizer_dynamic_sampling=2 방어 1줄\n"
    f"--   [E20260820-WFITEMPERF] 행별 상관 스칼라 → 선계산 LEFT JOIN 치환\n"
    f"--   [E20260820-VERPUSH]  GT_DM35_T_LAST_SETUP_C 적재문 2본 x 원천표 3분기 = 6곳\n"
    f"--        버전 술어를 UNION ALL 분기 안으로 push → PK 2번째 컬럼 VERSION_NO 를 access predicate 로 승격\n"
    f"--        (기존 outer JOIN GT_DM35_VERSION 과 동일 집합 — 결과 불변, 사내 5케이스 전행 일치 실증)\n"
    f"--   실행: SQL*Plus 에서 이 파일을 그대로 @실행 (말미 '/' 로 컴파일)\n"
    f"SET DEFINE OFF\n"
    f"SET SQLBLANKLINES ON\n"
    f"CREATE OR REPLACE {body}\n/\n"
    f"SHOW ERRORS\n"
)
open(f"{DIR}\\{FNAME}", "w", encoding="utf-8").write(text)

# ---- 자기검증: 주석/SET 제외 첫 실행 라인이 CREATE OR REPLACE PACKAGE BODY 여야 한다 ----
first = next(l for l in text.splitlines()
             if l.strip() and not l.strip().startswith("--") and not l.upper().startswith("SET "))
assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", first, re.I), f"첫 실행 라인: {first[:60]}"
assert text.rstrip().endswith("SHOW ERRORS")
assert text.count("E20260820-VERPUSH") == 6 + 1  # 본문 6 + 헤더 주석 1
print(f"[gen] {FNAME}: {len(text.splitlines())} lines / VERPUSH {body.count('E20260820-VERPUSH')} "
      f"/ DS2 {body.count('E20260820-DS2')} / 첫 실행 라인 OK")
print(f"      첫 실행 라인: {first[:70]}")
con.close()
