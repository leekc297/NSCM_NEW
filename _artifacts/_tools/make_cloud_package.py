#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""클라우드 이관 폴더 1-커맨드 생성기 (PKG 정정 케이스 전용 = 가장 잦은 유형).

## 왜 만들었나 (사용자 지적 2026-08-23)
"이관 폴더 생성·대상 취합이 너무 오래 걸린다. 누락 없이, 더 빠르게."
PKG 본문만 고친 날의 이관은 사실 **BODY 1본 + 확인 SQL** 이 전부인데, 매번 손으로
①신선 덤프 ②직전 패키지 대비 delta 실측 ③PRECHECK/VERIFY 작성 ④파일목록을 반복했다.
그 4단계를 그대로 자동화한다 — 판단이 필요한 곳(정정 설명·선행 의존)만 사람이 채운다.

## 쓰는 법
    python make_cloud_package.py --menu DMF0014 --marker E20260823-GRAYZERO \
        --prev DMF0014_CLOUD_20260818 --title "회색 주차 값 0 적재"
    (옵션) --pkg PKG_DMF0014       패키지명 기본값 = PKG_<menu>
           --out  DMF0014_XXX_CLOUD_20260823   폴더명 기본값 = <menu>_CLOUD_<오늘>
           --extra-object PR_XXX   BODY 외 함께 실을 객체(프로시저/함수/뷰) — 반복 지정 가능

## 산출물 (누락 방지 체크리스트를 코드로 고정)
    00_CLOUD_PRECHECK.sql   객체상태 / 선행 패키지 의존(참조 객체 실측) / 현재 마커세대
    A_DB/01_<PKG>_BODY.sql  BODY 전체 (부분 패치 불가)
    A_DB/02_<PKG>_SPEC.sql  SPEC — **직전 패키지와 다를 때만** 생성
    A_DB/90_VERIFY.sql      마커·규모 단언
    _survey/delta_*.{diff,txt}  직전 패키지 대비 실측 (동봉 축 은폐 금지)
    _README.md (초안) / _FILELIST.md
"""
import argparse
import difflib
import hashlib
import io
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

PKGROOT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages")


def strip_sql(text: str) -> str:
    t = text.replace("\r\n", "\n").strip()
    while t.startswith("--"):
        t = t.split("\n", 1)[1] if "\n" in t else ""
    return t.replace("CREATE OR REPLACE ", "", 1).rstrip("/").strip()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--menu", required=True)
    ap.add_argument("--marker", required=True, help="이번 정정 마커 (예: E20260823-GRAYZERO)")
    ap.add_argument("--prev", help="직전 클라우드 패키지 폴더명 (delta 실측 기준)")
    ap.add_argument("--pkg")
    ap.add_argument("--out")
    ap.add_argument("--title", default="")
    ap.add_argument("--extra-object", action="append", default=[])
    a = ap.parse_args()

    pkg = a.pkg or f"PKG_{a.menu}"
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    today = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD') FROM DUAL").fetchone()[0]
    out = PKGROOT / (a.out or f"{a.menu}_CLOUD_{today}")
    (out / "A_DB").mkdir(parents=True, exist_ok=True)
    (out / "_survey").mkdir(exist_ok=True)

    def source(kind):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t "
                    "ORDER BY LINE", {"n": pkg, "t": kind})
        return "".join(t for (t,) in cur if t is not None)

    body, spec = source("PACKAGE BODY"), source("PACKAGE")
    if not body:
        sys.exit(f"⛔ {pkg} BODY 덤프 실패 — 이름 확인")
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""",
                {"n": pkg})
    status, ddl = cur.fetchone()
    body_lines = body.count("\n") + 1
    print(f"[1] {pkg} BODY {body_lines}줄 / {status} / LAST_DDL {ddl}")
    if status != "VALID":
        print("    ⚠ 사내가 INVALID 다 — 이 상태로 이관하면 클라우드도 INVALID")

    # ── 마커 실측 ────────────────────────────────────────────────
    def cnt(needle):
        cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                        AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :s) > 0""", {"n": pkg, "s": needle})
        return cur.fetchone()[0]

    mk = cnt(a.marker)
    print(f"[2] 마커 {a.marker} = {mk}행" + ("  ⚠ 0행 = 사내에 미적용?" if mk == 0 else ""))

    # ── 직전 패키지 대비 delta ───────────────────────────────────
    delta_txt, spec_same = "", None
    if a.prev:
        pdir = PKGROOT / a.prev / "A_DB"
        pb = next((f for f in pdir.glob("*BODY*.sql")), None)
        ps = next((f for f in pdir.glob("*SPEC*.sql")), None)
        if pb:
            diff = list(difflib.unified_diff(strip_sql(pb.read_text(encoding="utf-8")).split("\n"),
                                             body.replace("\r\n", "\n").strip().split("\n"),
                                             lineterm="", n=0))
            adds = [l for l in diff if l.startswith("+") and not l.startswith("+++")]
            dels = [l for l in diff if l.startswith("-") and not l.startswith("---")]
            marks = sorted(set(re.findall(r"E2026\d{4}-[A-Z0-9]+", "\n".join(adds))))
            delta_txt = (f"직전 패키지 {a.prev} 대비: +{len(adds)}행 / -{len(dels)}행\n"
                         f"추가분 마커: {marks}\n")
            (out / "_survey" / f"delta_vs_{a.prev}.diff").write_text("\n".join(diff), encoding="utf-8")
            print(f"[3] delta +{len(adds)}/-{len(dels)}줄 / 추가 마커 {marks}")
            if a.marker not in marks:
                print(f"    ⚠ 이번 마커가 delta 에 없다 — 직전 패키지가 이미 담고 있거나 기준 폴더가 틀렸다")
        if ps:
            spec_same = strip_sql(ps.read_text(encoding="utf-8")) == spec.replace("\r\n", "\n").strip()
            print(f"[4] SPEC 직전과 동일: {spec_same} → {'미동봉' if spec_same else '동봉'}")

    # ── 산출물 ──────────────────────────────────────────────────
    hdr = f"-- {out.name} / {pkg} %s (사내 ALL_SOURCE 신선 덤프 {today})\n"
    (out / "A_DB" / f"01_{pkg}_BODY.sql").write_text(
        hdr % "BODY" + f"--   담긴 정정 = [{a.marker}] {a.title}\n"
        "--   ⚠ PL/SQL 패키지는 부분 패치 불가 — BODY 전체 교체다. delta 는 _survey/ 참조.\n"
        + "CREATE OR REPLACE " + body + "\n/\n", encoding="utf-8")
    if spec_same is False or (a.prev is None):
        (out / "A_DB" / f"02_{pkg}_SPEC.sql").write_text(
            hdr % "SPEC" + "CREATE OR REPLACE " + spec + "\n/\n", encoding="utf-8")

    refs = []
    for obj in a.extra_object:
        cur.execute("""SELECT OBJECT_TYPE FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND ROWNUM=1""", {"n": obj})
        r = cur.fetchone()
        refs.append((obj, r[0] if r else "MISSING"))

    # BODY 가 참조하는 GTT — 선행 패키지 의존 판정용 (이름 스캔, 실존 확인)
    gtts = sorted(set(re.findall(r"\bGT_[A-Z0-9_]{3,}", body)))
    live_gtt = []
    for g in gtts:
        cur.execute("""SELECT TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:n""",
                    {"n": g})
        r = cur.fetchone()
        if r:
            live_gtt.append(g)
    print(f"[5] BODY 참조 GTT {len(live_gtt)}종 (PRECHECK 존재확인 목록에 포함)")

    def rows(items):
        return " UNION ALL\n  ".join(f"SELECT '{i}' G FROM DUAL" for i in items) or "SELECT NULL G FROM DUAL"

    (out / "00_CLOUD_PRECHECK.sql").write_text(f"""-- {out.name} / 적용 전 확인 (QA·DEV 각각) — read-only
-- 이관 대상 = {pkg} BODY {'+ SPEC' if spec_same is False else '1본 (SPEC 은 직전과 동일 → 미동봉)'}

PROMPT ===== C1. 대상 객체 상태 =====
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') LAST_DDL
FROM   ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='{pkg}' ORDER BY OBJECT_TYPE;

PROMPT ===== C2. 현재 BODY 세대 (마커) — 적용 전 '{a.marker}' 0건이 정상 =====
SELECT REGEXP_SUBSTR(TEXT,'E2026[0-9]{{4}}-[A-Z0-9]+') MARKER, COUNT(*) CNT
FROM   ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='{pkg}' AND TYPE='PACKAGE BODY'
AND    REGEXP_LIKE(TEXT,'E2026[0-9]{{4}}-')
GROUP  BY REGEXP_SUBSTR(TEXT,'E2026[0-9]{{4}}-[A-Z0-9]+') ORDER BY 1;

PROMPT ===== C3. ⛔ BODY 참조 GTT 존재 (없으면 선행 패키지의 GTT DDL 먼저) =====
WITH need (G) AS (
  {rows(live_gtt)})
SELECT N.G, CASE WHEN T.TABLE_NAME IS NULL THEN 'MISSING ⛔' ELSE 'OK' END STATUS
FROM   need N LEFT JOIN ALL_TABLES T ON T.OWNER='SCM_MGR' AND T.TABLE_NAME=N.G
ORDER  BY 2 DESC, 1;

PROMPT ===== C4. 참조 프로시저/함수 존재 =====
WITH need (N) AS (
  {rows([o for o, _ in refs]) if refs else "SELECT NULL N FROM DUAL"})
SELECT need.N, NVL(O.OBJECT_TYPE,'MISSING ⛔') OBJ FROM need
LEFT JOIN ALL_OBJECTS O ON O.OWNER='SCM_MGR' AND O.OBJECT_NAME=need.N
WHERE need.N IS NOT NULL ORDER BY 2 DESC, 1;
""", encoding="utf-8")

    (out / "A_DB" / "90_VERIFY.sql").write_text(f"""-- {out.name} / 적용 후 검증 — 기대값 단언

PROMPT ===== V1. 컴파일 (기대 VALID) =====
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
WHERE  OWNER='SCM_MGR' AND OBJECT_NAME='{pkg}' ORDER BY OBJECT_TYPE;

PROMPT ===== V2. 마커 단언 (사내 실측 = {mk}행) =====
SELECT {mk} EXPECTED, COUNT(*) ACTUAL,
       CASE WHEN COUNT(*) = {mk} THEN 'PASS' ELSE 'FAIL ⛔' END RESULT
FROM   ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='{pkg}' AND TYPE='PACKAGE BODY'
AND    INSTR(TEXT,'{a.marker}') > 0;

PROMPT ===== V3. BODY 규모 (사내 {body_lines}줄) =====
SELECT COUNT(*) BODY_LINES, {body_lines} EXPECTED FROM ALL_SOURCE
WHERE  OWNER='SCM_MGR' AND NAME='{pkg}' AND TYPE='PACKAGE BODY';

PROMPT ===== V4. 런타임 스모크 (수기 — 화면에서 확인) =====
-- TODO: 이번 정정의 재현 시나리오를 적는다 (무엇을 눌러 무엇이 달라지는지).
""", encoding="utf-8")

    (out / "_survey" / "delta_summary.txt").write_text(
        f"{pkg} BODY {body_lines}줄 / STATUS {status} / LAST_DDL {ddl}\n"
        f"마커 {a.marker} = {mk}행\n" + delta_txt +
        f"SPEC 직전과 동일: {spec_same}\nBODY 참조 GTT {len(live_gtt)}종\n", encoding="utf-8")

    if not (out / "_README.md").exists():
        (out / "_README.md").write_text(f"""# {a.menu} 클라우드 이관 — {a.title or a.marker} ({today} 취합)

> **상태: 취합 완료 / 클라우드 미적용.** 사내 {ddl} 적용·{status}.
> **이관 대상 = `{pkg}` BODY {'+ SPEC' if spec_same is False else '1본'}.** (자동 생성 초안 — 아래 TODO 를 채울 것)

## 담긴 정정
| 마커 | 내용 |
|---|---|
| `[{a.marker}]` | {a.title or 'TODO'} |

## 직전 패키지 대비 실측
{delta_txt or 'TODO: --prev 를 주면 자동 기입'}
SPEC 직전과 동일: {spec_same} → {'동봉' if spec_same is False else '미동봉'}

## 적용 순서
1. `00_CLOUD_PRECHECK.sql` (QA·DEV 각각) — C3/C4 에 MISSING 이 있으면 선행 패키지 먼저
2. `A_DB/01_{pkg}_BODY.sql`{'  → A_DB/02_' + pkg + '_SPEC.sql' if spec_same is False else ''}
3. `A_DB/90_VERIFY.sql`
4. 런타임 스모크 — TODO

## 범위 밖
TODO: FE/메타/권한 변경 없음 여부를 명시
""", encoding="utf-8")

    files = [(str(f.relative_to(out)).replace("\\", "/"), f.stat().st_size,
              hashlib.md5(f.read_bytes()).hexdigest()[:10])
             for f in sorted(out.rglob("*")) if f.is_file() and f.name != "_FILELIST.md"]
    (out / "_FILELIST.md").write_text(
        f"# {out.name} — 파일 목록 (기계 산출 {today})\n\n총 {len(files)} 파일 / "
        f"{sum(x[1] for x in files):,} bytes\n\n| 경로 | bytes | md5(10) |\n|---|---:|---|\n"
        + "\n".join(f"| `{p}` | {b:,} | `{h}` |" for p, b, h in files) + "\n", encoding="utf-8")
    con.close()
    print(f"[6] 생성 완료 → {out}  ({len(files)} 파일)")
    print("    남은 일: _README.md 의 TODO(정정 설명·스모크·범위 밖) 와 90_VERIFY V4 를 채운다")
    return 0


if __name__ == "__main__":
    sys.exit(main())
