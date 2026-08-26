# -*- coding: utf-8 -*-
"""클라우드 이관 파일 13_PKG_DMF0035_BODY.sql 재생성 (SQL*Plus 실행 가능 형식).

⚠ 2026-08-20 실사고 재발 방지: 기존 파일에서 "PACKAGE BODY" 문자열로 잘라 prefix 를 만들면
  그 문자열이 **헤더 주석 줄 안**에 있어 CREATE OR REPLACE 가 통째로 주석에 먹힌다.
  ⇒ 파일을 **새로 조립**한다: 헤더 주석 + SET + `CREATE OR REPLACE ` + 라이브 본문 + `/` + SHOW ERRORS.
  ⚠ SET SQLBLANKLINES ON 필수 (본문 중간 빈 줄에서 SQL*Plus 가 문장을 끊음)
  ⚠ SET DEFINE OFF 필수 (본문의 '&' 가 치환 변수로 해석되는 것 방지)
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

DST = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB\13_PKG_DMF0035_BODY.sql"
MARKS = {"E20260820-DS2": 1, "E20260820-WFITEMPERF": 2, "E20260820-VERPUSH]": 6,
         "E20260820-RAWSCALAR": 2, "E20260820-VERPUSH2": 5}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "\n".join(r[0].rstrip("\n") for r in cur.fetchall()).strip()
con.close()
assert body.upper().startswith("PACKAGE BODY"), body[:80]
for mk, k in MARKS.items():
    c = body.count(mk)
    assert c == k, f"{mk} {c}개 (기대 {k}) — 라이브 본문 이상, 중단"
print(f"[live] {len(body.splitlines())} lines / 마커 {MARKS}")

text = (
    "-- DMF0035_CLOUD_20260820 / 13_PKG_DMF0035_BODY.sql\n"
    "-- PKG_DMF0035 PACKAGE BODY — MKT FCST Waterfall (사내 라이브 재덤프 2026-08-20)\n"
    "--   [E20260820-DS2]        클라우드 optimizer_dynamic_sampling=0 방어 1줄\n"
    "--   [E20260820-WFITEMPERF] SCP_ITEM_INFO 상관 스칼라 → 선계산 조인 (129.35 → 0.075 s/exec)\n"
    "--   [E20260820-VERPUSH]    T_LAST_SETUP_C 버전 술어 push (1차)\n"
    "--   [E20260820-RAWSCALAR]  RAW_DATA 적재 상관 스칼라 10개 → 선계산 LEFT JOIN 3본 (hook #129 ①)\n"
    "--   [E20260820-VERPUSH2]   원장 _C 구동 5지점 버전 술어 push = 선행축소 (hook #129 ②/④)\n"
    "--   실행: SQL*Plus 에서 이 파일을 그대로 @실행 (말미 '/' 로 컴파일)\n"
    "SET DEFINE OFF\n"
    "SET SQLBLANKLINES ON\n"
    f"CREATE OR REPLACE {body}\n/\n"
    "SHOW ERRORS\n"
)
open(DST, "w", encoding="utf-8").write(text)

# ---------- 자기검증: 주석·SET 제외 첫 실행 라인이 CREATE OR REPLACE PACKAGE BODY 인가 ----------
first = next(l for l in text.splitlines()
             if l.strip() and not l.strip().startswith("--") and not l.upper().startswith("SET "))
assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", first, re.I), f"첫 실행 라인 이상: {first[:80]}"
assert text.rstrip().endswith("SHOW ERRORS")
assert "\nSET DEFINE OFF\n" in text and "\nSET SQLBLANKLINES ON\n" in text
for mk, k in MARKS.items():
    assert text.count(mk) >= k, f"{mk} 이관 파일 누락"
print(f"[gen] 13_PKG_DMF0035_BODY.sql — {len(text.splitlines())} lines")
print(f"      첫 실행 라인 = {first[:60]}...  ✔")
