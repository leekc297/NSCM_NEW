#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_cutoff_planrange_measure_join_fix.py — Cutoff 계획구간 존재판정 MEASURE 조인 제거 (2026-08-11)

## 사고
Cutoff(Data Type=1) 셀 저장 → **ORA-00001 PK 위반**(`PK_DM_PLN_SALES_PLAN_REPORT_C`).
실측 재현: div40 / `R_S_20260810_V010_C` / `MPCCERT19C1E` / **MEASURE='LOC' / 202612(미래월)** 1행 'M' 저장.
데이터는 안전(예외 핸들러 ROLLBACK — 대상 행 QTY·버전 총 행수 불변).

## 발현 조건
`GT_0044_RESULTS_MST_C.PLAN_YN = 'Y'`(= `SUBSTR(YYYYMMDD,1,6) >= 현재월`, L4914) 일 때만
`IF V_PLAN_YN = 'Y'`(L5464) 계획구간 블록이 실행된다.
⇒ **과거월(실적구간) 저장은 정상**(사용자 실측 확인). AS-IS 편집 매트릭스상 `LOC` 는 **계획구간에서만
편집 가능**하므로 **LOC 편집 = 항상 이 결함 경로**다.

## 원인 (변환 시 조건 추가)
계획구간 존재판정이 UPDATE/INSERT 를 가르는데, 그 JOIN 에 **`AA.MEASURE = BB.MEASURE`** 가 들어가 있다.
바깥 `WHERE AA.MEASURE = '<리터럴>'` 와 겹쳐 **BB.MEASURE 도 그 리터럴이어야만 참** → 사용자가 다른
measure 를 저장하면 항상 `V_EXISTS=0` → **이미 있는 행에 INSERT** → PK 위반.

**AS-IS 원문에는 그 조인이 없다** (`AsIs_..._SP1_DDL.sql` L154617~154636, 계획구간 LOC 블록):
    JOIN #results_MST B
      ON A.VERSION_NO=B.VERSION_NO … AND A.COMPANY_ID=B.COMPANY_ID AND B.SEQ_RANK=@i
     WHERE A.MEASURE = 'SalesAmt_LOC'          ← MEASURE 조인 없음. WHERE 로만 고정.
⇒ 파리티 아님, **변환 결함**. 정정 = 해당 조인 조건 **삭제**(추가 아님).

## 대상 = 계획구간 3곳만
`AA.MEASURE = BB.MEASURE` 는 SP 전체에 7곳 있으나, 앞 4곳(L4983 LOC / L5186 SalesAmt_LOC /
L5291 SalesAmt_KRW / L5395 SalesAmt_USD)은 **바깥 게이트**
(`EXISTS(GT_0044_RESULTS_MST_C WHERE SEQ_RANK=V_I AND MEASURE='<리터럴>')` — L4951/5155/5262/5366)
**안에** 있어 BB.MEASURE 가 이미 그 리터럴로 고정된다 ⇒ 무해(AS-IS 5 게이트와 1:1). **미변경**.
계획구간 3곳(L5490 SalesAmt_LOC / L5590 SalesAmt_KRW / L5677 SalesAmt_USD)만 바깥 게이트가 없다.

사용:
  python dmf0044_cutoff_planrange_measure_join_fix.py --dump / --patch / --deploy
"""
import argparse
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate"
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_cfplan_20260811.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_CFPLAN_20260811.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1, "20260805 MERGE-ON 파리티 복원": 1, "PIVOTSEL 2026-08-10": 1,
    "TUNE-V": 2, "ETCWB": 8, "MSRSHEET": 1, "PLANINS": 1, "ETCNICK": 2,
}

# 계획구간 3블록의 존재판정 — 리터럴로 블록을 특정해 **그 블록의 조인 줄만** 치환한다.
#   (앞 4곳은 동일 문자열이지만 바깥 게이트 안이라 미변경 — 리터럴 앵커로 구분)
_JOIN = "                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID AND AA.MEASURE = BB.MEASURE\n"
_JOIN_FIXED = (
    "                             -- [CFPLAN 2026-08-11] MEASURE 조인(AA↔BB) 제거.\n"
    "                             --   바깥 WHERE 가 AA.MEASURE 를 리터럴로 고정하는데 조인까지 걸면\n"
    "                             --   BB.MEASURE 도 그 리터럴이어야만 참 → 다른 measure 저장 시 항상\n"
    "                             --   V_EXISTS=0 → 기존 행에 INSERT → ORA-00001.\n"
    "                             --   AS-IS(SP1_DDL L154617~154636)에는 이 조인이 없다(WHERE 로만 고정).\n"
    "                             AND AA.CURRENCY = BB.CURRENCY AND AA.COMPANY_ID = BB.COMPANY_ID\n"
)


def _blocks(text):
    """계획구간 3블록 = `IF V_PLAN_YN = 'Y' THEN` 이후 구간."""
    i = text.index("IF V_PLAN_YN = 'Y' THEN")
    return text[:i], text[i:]


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                       AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    for m, n in GUARD_MARKS.items():
        got = body.count(m)
        print("  선행 마커 '%s' = %d (기대 %d)%s" % (m, got, n, "" if got == n else "  ⚠"))
    head, tail = _blocks(body)
    print("  전체 `AA.MEASURE = BB.MEASURE` = %d곳 / 계획구간(IF V_PLAN_YN 이후) = %d곳"
          % (body.count("AA.MEASURE = BB.MEASURE"), tail.count("AA.MEASURE = BB.MEASURE")))
    print("  앵커(계획구간 조인줄) = %d건 (기대 3)" % tail.count(_JOIN))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if "CFPLAN" in text:
        sys.exit("[error] 이미 적용됨")
    head, tail = _blocks(text)
    n = tail.count(_JOIN)
    if n != 3:
        sys.exit("[error] 계획구간 앵커 %d건 (기대 3) — 손대지 않음" % n)
    before_all = text.count("AA.MEASURE = BB.MEASURE")
    tail = tail.replace(_JOIN, _JOIN_FIXED)
    text = head + tail
    after_all = text.count("AA.MEASURE = BB.MEASURE")
    if before_all - after_all != 3:
        sys.exit("[error] 제거 수 %d (기대 3) — 중단" % (before_all - after_all))
    for m, c in GUARD_MARKS.items():
        if text.count(m) != c:
            sys.exit("[error] 선행 마커 '%s' 소실" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  MEASURE 조인 제거 %d→%d (계획구간 3곳만) ✅ / 선행 마커 %d종 유지 ✅"
          % (before_all, after_all, len(GUARD_MARKS)))
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
        for m in list(GUARD_MARKS) + ["CFPLAN"]:
            cur.execute("SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                        "AND TYPE='PACKAGE BODY' AND INSTR(TEXT, :m) > 0", {"m": m})
            print("  마커 '%s' = %d" % (m, cur.fetchone()[0]))
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
