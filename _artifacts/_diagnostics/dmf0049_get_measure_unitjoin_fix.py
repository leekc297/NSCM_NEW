#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_get_measure_unitjoin_fix.py — DMF0049 Insert 행수 결함 정정 (2026-08-11)

## 사고 (사용자 보고)
"DMF0049 INSERT 시 AS-IS 에서는 선택된 메저가 3개이면 3개의 ROW 가 추가된다" — TO-BE 는 안 된다.

## 실측
`P_DMF0049_GET_MEASURE` 반환: **div40 = 1행(RTF_SYS_RP) / div81 = 0행 / div82 = 0행**
FE(`EtcSalesReports.tsx` handleInsert)는 이 결과 수만큼 행을 넣으므로 40 은 1행만,
81·82 는 `measures.length === 0` 게이트에 걸려 **삽입 자체가 차단**된다.
(AS-IS `iMeasureCnt` = 40:3 / 81계열:2 / 82:1 — `.cs` L934~939)

## 원인 — 콤마 목록 컬럼에 등호 조인
```
INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
   ON  TEI.UNIT_ID = A.DIVISION_ID          ⛔ A.DIVISION_ID 는 콤마 목록
AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0   ← 바로 아래 줄은 올바른 '포함' 판정
```
`SCM_MST_SHEET_MEASURE`(DMF0049/'MDF Reports') 실측:
  SalesAmt_LOC = `40,81,81_UC,81_HM,81_ST,81_HD,81_HG` / SalesAmt_KRW = `40,82,81,...` / RTF_SYS_RP = `40`
⇒ 등호 조인은 **DIVISION_ID 가 단일값인 행만** 매칭 → div40 은 RTF_SYS_RP 1건, 81·82 는 0건.

## 조치
TEI 조인을 **요청 division** 으로 바꾼다. 역할 분리가 명확해진다 —
  · TEI 조인 = **권한(EDIT_YN) 획득** (권한 없는 division 이면 0행 → 정상 차단 유지)
  · division 필터 = 기존 `INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0` 라인이 담당
`PR_SCM_EDIT_YN` 은 UNIT_ID 당 1행(실측 8단위) → 중복 증식 없음.

기대 결과 = **AS-IS `iMeasureCnt` 와 일치**:
  div40 → KRW·LOC·RTF_SYS_RP = 3 / div81 → KRW·LOC = 2 / div82 → KRW = 1

⚠ IF(40) / ELSE(비40) **양 분기 모두** 같은 조인이 있으므로 2곳을 함께 고친다.

사용:
  python dmf0049_get_measure_unitjoin_fix.py --dump / --patch / --deploy / --verify
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
BACKUP = OUT / "BACKUP_PKG_DMF0049_BODY_pre_msrunit_20260811.sql"
PATCHED = OUT / "PKG_DMF0049_BODY_MSRUNIT_20260811.sql"

_OLD = "                ON     TEI.UNIT_ID = A.DIVISION_ID\n"
_NEW = (
    "                -- [MSRUNIT 2026-08-11] 조인 대상을 A.DIVISION_ID(콤마 목록) → 요청 division 으로.\n"
    "                --   등호 비교라 목록형 행이 전부 탈락해 div40=1행 / div81·82=0행이었다(삽입 차단).\n"
    "                --   TEI 조인은 권한(EDIT_YN) 획득용이고, division 필터는 아래 INSTR 라인이 담당한다.\n"
    "                ON     TEI.UNIT_ID = P_DIVISION_ID\n"
)


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049'
                       AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    return "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()


def probe(cur, oracledb):
    out = []
    for div in ("40", "81", "82"):
        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        res = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc("SCM_MGR.PKG_DMF0049.P_DMF0049_GET_MEASURE", keywordParameters=dict(
            P_DIVISION_ID=div, P_USER_ID="minyonglee1", P_MENU_ID="DMF0049",
            O_RC1=rc, O_RESULT_CURSOR=res))
        g = rc.getvalue()
        cols = [c[0] for c in g.description]
        rows = g.fetchall()
        out.append((div, len(rows), [r[cols.index("CODE")] for r in rows]))
    return out


def cmd_dump():
    OUT.mkdir(parents=True, exist_ok=True)
    body = live_body()
    BACKUP.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (BACKUP, len(body.splitlines())))
    print("  앵커 = %d건 (기대 2 — IF/ELSE 양 분기)" % body.count(_OLD))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if "MSRUNIT" in text:
        sys.exit("[error] 이미 적용됨")
    n = text.count(_OLD)
    if n != 2:
        sys.exit("[error] 앵커 %d건 (기대 2) — 손대지 않음" % n)
    text = text.replace(_OLD, _NEW)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행) — 2곳 치환 ✅" % (PATCHED, len(text.splitlines())))
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
                    "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049' ORDER BY 1")
        for r in cur.fetchall():
            print("  %-14s %s" % (r[0], r[1]))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS "
                    "WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' ORDER BY SEQUENCE")
        errs = cur.fetchall()
        for e in errs:
            print("  ⛔ L%s:%s %s" % (e[0], e[1], e[2]))
        if not errs:
            print("\n[검증] GET_MEASURE 반환 (기대 40=3 / 81=2 / 82=1)")
            for div, cnt, codes in probe(cur, oracledb):
                exp = {"40": 3, "81": 2, "82": 1}[div]
                print("  div=%-3s %d행 %-45s %s" % (div, cnt, str(codes),
                                                    "PASS" if cnt == exp else "FAIL(기대 %d)" % exp))
    return 1 if errs else 0


def cmd_verify():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        for div, cnt, codes in probe(con.cursor(), oracledb):
            print("  div=%-3s %d행 %s" % (div, cnt, codes))
    return 0


def main():
    ap = argparse.ArgumentParser()
    for f in ("dump", "patch", "deploy", "verify"):
        ap.add_argument("--" + f, action="store_true")
    a = ap.parse_args()
    for f in ("dump", "patch", "deploy", "verify"):
        if getattr(a, f):
            sys.exit(globals()["cmd_" + f]())
    ap.error("--dump / --patch / --deploy / --verify 중 하나 필요")


if __name__ == "__main__":
    main()
