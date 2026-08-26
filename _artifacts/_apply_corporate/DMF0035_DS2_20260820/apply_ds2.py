# -*- coding: utf-8 -*-
"""[E20260820-DS2] PKG_DMF0035/0022/0051 — 클라우드 optimizer_dynamic_sampling=0 방어 표준 적용.

[근거 — 클라우드 실측 2026-08-20]
  · 병목 문장 SQL_ID cbxpxq839ydqs = `INSERT INTO GT_DM35_T_LAST_SETUP_C SELECT ...`
    2회 실행 2,604초(**1,302초/회**), buffer_gets 6.78M, 대기 `cell single block read request`
    = 대용량 표를 **행 단위 인덱스 조회(NL)** 로 훑는 전형적 플랜 붕괴 신호
  · `V$PARAMETER optimizer_dynamic_sampling = 0` (ISDEFAULT=FALSE — 명시 설정)
  · 그 문장은 `GT_DM35_SEL_MEASURE` / `GT_DM35_VERSION` 두 GTT 와 조인하는데, 이 SP 가 통계를 수집하는
    GTT 11종 목록에 **두 GTT 가 없다** → 통계 없음 + ODS=0 ⇒ 카디널리티 1 추정 ⇒ NL 로 51M 표를 훑는다.
  · 인덱스·통계(원장)는 사내와 동일함을 확인(P4/P5) — 인덱스 부재 가설은 기각됐다.

[적용]
  프로젝트 표준 `[E20260812-DS2]`(DMF0044/0049 에 2026-08-12 일괄 적용된 것)와 **동일한 1줄**을
  각 GET 프로시저 진입부에 넣는다: `ALTER SESSION SET optimizer_dynamic_sampling = 2`.
  ⇒ 통계 없는 GTT 를 옵티마이저가 **샘플링**해 실제 카디널리티를 잡고, NL 대신 HASH JOIN 을 택한다.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_DS2_20260820"
MARK = "E20260820-DS2"
DS2 = [
    "    --[{}] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어".format(MARK),
    "    --  통계 없는 GTT 가 카디널리티 1 로 추정되어 NL 이 선택되면 대용량 표를 행 단위로 훑는다",
    "    --  (클라우드 실측: GT_DM35_T_LAST_SETUP_C 적재문 1,302초/회, cell single block read).",
    "    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';",
]
# PKG → 진입부에 넣을 대상 프로시저
TARGETS = {
    "PKG_DMF0035": ["P_DMF0035_GET_MKT_FCST_WATERFALL"],
    "PKG_DMF0022": ["P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL"],
    "PKG_DMF0051": ["P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL"],
}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")

for pkg, procs in TARGETS.items():
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                   AND TYPE='PACKAGE BODY' ORDER BY LINE""", {"n": pkg})
    lines = [r[0].rstrip("\n") for r in cur.fetchall()]
    assert lines, f"{pkg} BODY 소스 없음"
    open(f"{BASE}\\00_BACKUP_{pkg}_BODY.sql", "w", encoding="utf-8").write("\n".join(lines) + "\n")
    if any(MARK in l for l in lines):
        print(f"[{pkg}] 이미 적용됨 — skip")
        continue

    inserted = 0
    for proc in procs:
        # 프로시저 선언 위치 → 이후 첫 단독 BEGIN 라인 뒤에 삽입
        pi = next((i for i, l in enumerate(lines)
                   if re.match(rf"\s*PROCEDURE\s+{proc}\b", l, re.I)), None)
        assert pi is not None, f"{pkg}: {proc} 선언 미발견"
        bi = next((i for i in range(pi, len(lines))
                   if lines[i].strip().upper() == "BEGIN"), None)
        assert bi is not None, f"{pkg}: {proc} 의 BEGIN 미발견"
        lines[bi + 1:bi + 1] = DS2
        inserted += 1
        print(f"[{pkg}] {proc}: L{pi+1} 선언 → L{bi+1} BEGIN 뒤 삽입")
    assert inserted == len(procs)

    body = "\n".join(lines)
    assert body.count(MARK) == len(procs)
    open(f"{BASE}\\01_PATCHED_{pkg}_BODY.sql", "w", encoding="utf-8").write(body + "\n")
    stmt = body.strip()
    if not re.search(r"CREATE OR REPLACE\s+(EDITIONABLE\s+)?PACKAGE BODY", stmt[:500].upper()):
        assert stmt.upper().startswith("PACKAGE BODY"), stmt[:100]
        stmt = "CREATE OR REPLACE " + stmt
    cur.execute(stmt)
    cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n",
                {"n": pkg})
    sts = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", {"n": pkg})
    errs = cur.fetchone()[0]
    print(f"[{pkg}] apply → {sts} / ERRORS {errs}")
    assert errs == 0 and all(s == "VALID" for _, s in sts), f"{pkg} 적용 실패"

con.close()
print("[OK] DS2 적용 완료")
