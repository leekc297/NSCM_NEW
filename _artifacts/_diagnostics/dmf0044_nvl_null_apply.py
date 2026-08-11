#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_nvl_null_apply.py — `NVL(x, NULL)` 오변환 정리 (2026-08-10)

## 결함 (사용자 신고 "TYPE SP-W 선택 후 VERSION CREATE 시 SQL ERROR" — 재현 완료)
`PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY` 실행 시:

    ORA-00979: "A"."CURRENCY" 은(는) GROUP BY 절에 나타나거나 집계 함수에서 사용되어야 합니다.
    BACKTRACE=ORA-06512: "SCM_MGR.PKG_DMF0044", 7354행

SELECT(L7360) `NVL(A.CURRENCY, NULL) AS CURRENCY` ↔ GROUP BY(L7387) `NVL(A.CURRENCY, NULL)` 로
**텍스트는 같은데** Oracle 이 `NVL(expr, NULL)` 을 상수 폴딩하면서 두 자리의 표현식 동일성 판정이
깨져 ORA-00979 가 난다.

## 근본원인 = MSSQL `ISNULL(x, '')` 오변환 계보
메모리 `feedback_isnull_to_nvl_null_handling` 이 명시한 **"잘못된 Oracle = `NVL(x, NULL)`"** 그 패턴이다.
`NVL(x, NULL)` 은 의미상 **`x` 와 완전히 동일**하다(두 번째 인자가 NULL 이므로 아무것도 대체하지 않음).
⇒ 정정 (**hook #127 · 사용자 지시 2026-08-10**):
  · **표현식**(SELECT/GROUP BY/INSERT/CASE 결과) → `NVL(x, '-')`  — 빈값 센티널 표준(hook #119 §1.5)
  · **술어**(`NVL(x,NULL) IS [NOT] NULL`) → `x IS [NOT] NULL` (**NVL 제거**)
    ⚠ 술어를 `'-'` 로 바꾸면 **항상 참**이 되어 조건이 사라지고, DATE/NUMBER 변수면 타입 오류까지 난다.
      실측: `AND NVL(d_Result_Date, NULL) IS NOT NULL` 7곳 — `d_Result_Date` 는 DATE 변수.

## 범위
`PKG_DMF0044` BODY 의 **컬럼/변수 참조형** `NVL(<식별자 or a.b>, NULL)` 전량.
⚠ 숫자 리터럴형(`NVL(1, NULL)` — PKG_DMF0082/0048 에 존재)은 **대상 아님**(동적 SQL 조립용으로 의미가 다를 수 있다).
⚠ 다른 패키지(전사 26건)는 **본 스크립트 범위 밖** — 별도 판단 필요(리포트에 목록 동봉).

사용:
  python dmf0044_nvl_null_apply.py --dump / --patch / --deploy
"""
import argparse
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_nvlnull_20260810.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_NVL_NULL_20260810.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "PRODUCTDETAIL 2026-08-10": 2,
}

# 컬럼/변수 참조형만 — 숫자 리터럴은 제외 (`NVL(1, NULL)` 류)
PAT = re.compile(r"NVL\s*\(\s*([A-Za-z_][\w$#]*(?:\s*\.\s*[A-Za-z_][\w$#]*)?)\s*,\s*NULL\s*\)",
                 re.IGNORECASE)


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' ORDER BY LINE"""
        )
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음: PKG_DMF0044")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")

    # 주석 줄은 건드리지 않는다(원문 이력 보존)
    counts = {"expr": 0, "pred": 0}

    def _sub_factory(line):
        def _sub(m):
            # ⭐ hook #127 §3 — 매치 직후가 `IS [NOT] NULL` 이면 **술어**(NVL 제거),
            #   아니면 **표현식**(빈값 센티널 `'-'`). 술어를 '-' 로 바꾸면 항상 참이 되고
            #   DATE/NUMBER 변수면 타입 오류까지 난다(사용자 확정 2026-08-10).
            tail = line[m.end():m.end() + 24].upper()
            if re.match(r"\s*IS\s+(NOT\s+)?NULL", tail):
                counts["pred"] += 1
                return m.group(1)
            counts["expr"] += 1
            return "NVL(%s, '-')" % m.group(1)
        return _sub

    out_lines = []
    for line in text.split("\n"):
        if line.lstrip().startswith("--"):
            out_lines.append(line)
            continue
        out_lines.append(PAT.sub(_sub_factory(line), line))
    text2 = "\n".join(out_lines)

    if counts["expr"] + counts["pred"] == 0:
        print("  치환 0건 — 이미 적용됨(멱등)")
    else:
        print("  치환 — 표현식 %d건 → NVL(x, '-')  /  술어 %d건 → NVL 제거(x IS [NOT] NULL)"
              % (counts["expr"], counts["pred"]))

    # 잔존 확인 — 주석 밖 컬럼참조형 0 이어야 한다
    leftover = [
        (i + 1, ln.strip())
        for i, ln in enumerate(text2.split("\n"))
        if not ln.lstrip().startswith("--") and PAT.search(ln)
    ]
    if leftover:
        for i, ln in leftover[:5]:
            print("  ⛔ 잔존 L%d: %s" % (i, ln[:110]))
        sys.exit("[error] 컬럼참조형 NVL(x,NULL) 잔존 %d건 — 중단" % len(leftover))

    for m, n in GUARD_MARKS.items():
        if text2.count(m) != n:
            sys.exit("[error] 선행 마커 '%s' 소실 — 중단" % m)

    PATCHED.write_text(text2, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text2.splitlines())))
    print("  잔존 0 ✅ / 선행 마커 4종 유지 ✅ / 행 수 불변 %s"
          % ("✅" if len(text2.splitlines()) == len(text.splitlines()) else "⚠"))
    return 0


def cmd_deploy():
    import oracledb

    if not PATCHED.is_file():
        sys.exit("[error] 배포본 부재 — --patch 선행")
    sql = PATCHED.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(sql)
        cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS "
                    "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS "
                    "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        for m, n in GUARD_MARKS.items():
            cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                        "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0", {"m": m})
            got = cur.fetchone()[0]
            print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⛔ 회귀"))
    return 1 if errs else 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    if a.dump:
        sys.exit(cmd_dump())
    if a.patch:
        sys.exit(cmd_patch())
    if a.deploy:
        sys.exit(cmd_deploy())
    ap.error("--dump / --patch / --deploy 중 하나 필요")


if __name__ == "__main__":
    main()
