# -*- coding: utf-8 -*-
"""DS2 적용본 → 클라우드 패키지 BODY 파일 재생성 (SQL*Plus 실행 가능 형식).

⚠ 직전 실패 원인(2026-08-20): 기존 파일에서 `"PACKAGE BODY"` 문자열을 **처음 나오는 위치**로 잘라
  prefix 를 만들었는데, 그 문자열이 **헤더 주석 줄 안**에 있어서 `CREATE OR REPLACE ...` 가
  통째로 주석(`--`) 안에 들어가 버렸다 → SQL*Plus 가 본문을 최상위 명령으로 읽어 ORA-00928/00904 다발.
  ⇒ 이제 **파일을 새로 조립**한다: 헤더 주석 + SET + `CREATE OR REPLACE ` + 라이브 본문 + `/`.
  ⚠ `SET SQLBLANKLINES ON` 필수 — 본문 중간의 빈 줄에서 SQL*Plus 가 문장을 끊는다.
  ⚠ `SET DEFINE OFF` 필수 — 본문의 `&` 가 치환 변수로 해석되는 것을 막는다.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

PKG_DST = {
    "PKG_DMF0035": ("13_PKG_DMF0035_BODY.sql", "MKT FCST Waterfall"),
    "PKG_DMF0022": ("15_PKG_DMF0022_BODY.sql", "Sales Plan Waterfall"),
    "PKG_DMF0051": ("17_PKG_DMF0051_BODY.sql", "Biz Plan Waterfall"),
}
DIR = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
for pkg, (fname, desc) in PKG_DST.items():
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                   AND TYPE='PACKAGE BODY' ORDER BY LINE""", {"n": pkg})
    body = "\n".join(r[0].rstrip("\n") for r in cur.fetchall()).strip()
    assert body.upper().startswith("PACKAGE BODY"), body[:80]
    assert "E20260820-DS2" in body, f"{pkg}: DS2 마커 부재 — 중단"

    text = (
        f"-- DMF0035_CLOUD_20260820 / {fname}\n"
        f"-- {pkg} PACKAGE BODY — {desc} (사내 라이브 재덤프 2026-08-20)\n"
        f"--   [E20260820-DS2] 클라우드 optimizer_dynamic_sampling=0 방어 1줄 포함\n"
        f"--   실행: SQL*Plus 에서 이 파일을 그대로 @실행 (말미 '/' 로 컴파일)\n"
        f"SET DEFINE OFF\n"
        f"SET SQLBLANKLINES ON\n"
        f"CREATE OR REPLACE {body}\n/\n"
        f"SHOW ERRORS\n"
    )
    open(f"{DIR}\\{fname}", "w", encoding="utf-8").write(text)

    # 자기검증: 주석/SET 을 제외한 첫 실행 라인이 CREATE OR REPLACE PACKAGE BODY 여야 한다
    first = next(l for l in text.splitlines()
                 if l.strip() and not l.strip().startswith("--") and not l.upper().startswith("SET "))
    assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", first, re.I), f"{fname} 첫 실행 라인: {first[:60]}"
    assert text.rstrip().endswith("SHOW ERRORS")
    print(f"[gen] {fname}: {len(text.splitlines())} lines / DS2 {body.count('E20260820-DS2')} / 첫 실행 라인 OK")
con.close()
print("[OK] 3본 재생성 완료")
