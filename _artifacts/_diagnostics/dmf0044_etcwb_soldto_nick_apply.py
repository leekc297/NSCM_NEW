#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etcwb_soldto_nick_apply.py — ETC 신규행 INSERT 시 SOLDTO_CODE / NICK_NAME 채움 (2026-08-11)

## 배경 (사용자 요청)
ETCWB 로 들어간 신규행이 `SOLDTO_CODE` = NULL / `NICK_NAME` = NULL 이었다.
FE payload 20키에 두 컬럼이 없어 INSERT 목록에서 빠져 있었기 때문(AS-IS DMF0044 SAVE 파라미터도 동일).

## ① SOLDTO_CODE = '-'  (센티널)
사내 실측: `DM_PLN_SALES_ETC_REPORT_C` 209,702행 중 **209,696행이 '-'**, NULL 은 이번 신규 6행뿐.
⇒ 이 원장의 확립된 규약은 '-' 다. hook #119 / PK 센티널 정규화 표준과도 일치.
   payload 에 값이 없으므로 `NVL(<없음>, '-')` = 상수 '-' 로 넣는다.

## ② NICK_NAME — AS-IS 규칙 이식 (신규 발명 0)
AS-IS `DMF0049_SAVE`(ETC_REPORT_C 의 주인) L168717:
    NICK_NAME = ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME)
  · LK3 = SCM_ADM_LOOKUP_MASTER_DETAIL, LOOKUP_TYPE='DM_SR_ETC_MODEL',
          SEGMENT1 = DIVISION_ID, SEGMENT2 = ITEM_ID   (L168752~168755)
  · C   = 품목 마스터(DM_MST_ITEM_SINGLE_V)의 NICK_NAME (ITEM_ID 조인)
TO-BE 교차검증:
  · 룩업에 (40,'ETC') → ATTRIBUTE1='기타매출' 존재 (16행 보유)
  · 기존 원장 ITEM_ID='ETC' 행 중 **36,274건이 실제로 NICK_NAME='기타매출'** — 규약 일치
  · 품목 마스터 fallback 은 SAVE 시점에 `GT_F044_DM_MST_ITEM_SINGLE_V`(GET 전용 GTT)가 비어 있으므로
    GET 의 적재 원천과 동일하게 `SCM_MST_ITEM_SN` 을 (DIVISION_ID, ITEM_ID) 로 집계해 쓴다.

## 적용 범위
**INSERT(WHEN NOT MATCHED) 에만** 적용한다. MATCHED(기존행 갱신)는 QTY·감사 컬럼만 건드리는 현행 유지 —
기존 행의 NICK_NAME 을 재계산해 덮으면 운영 데이터가 조용히 바뀐다.

사용:
  python dmf0044_etcwb_soldto_nick_apply.py --dump / --patch / --deploy
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
BACKUP = OUT / "BACKUP_PKG_DMF0044_BODY_pre_etcnick_20260811.sql"
PATCHED = OUT / "PKG_DMF0044_BODY_ETCNICK_20260811.sql"

GUARD_MARKS = {
    "AUTHUNION 2026-08-09": 1,
    "20260805 MERGE-ON 파리티 복원": 1,
    "PIVOTSEL 2026-08-10": 1,
    "TUNE-V": 2,
    "ETCWB": 8,
    "MSRSHEET": 1,
    "PLANINS": 1,
}

# ① USING 목록에 NICK_NAME 산출 추가
_H1_OLD = """             , NVL(E.KEEP_YMD, B.YYYYMMDD) AS TGT_YMD
        FROM   SCM_MGR.GT_0044_RESULTS_MST B
"""
_H1_NEW = """             , NVL(E.KEEP_YMD, B.YYYYMMDD) AS TGT_YMD
             -- [ETCNICK 2026-08-11] NICK_NAME = AS-IS DMF0049_SAVE L168717 규칙 이식
             --   `ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME)`
             --     LK3 = LOOKUP 'DM_SR_ETC_MODEL' (SEGMENT1=division, SEGMENT2=item) → ATTRIBUTE1
             --     C   = 품목 마스터 NICK_NAME. SAVE 시점엔 GET 전용 GTT 가 비어 있어
             --           GET 적재 원천과 동일한 SCM_MST_ITEM_SN 을 (DIVISION_ID, ITEM_ID) 집계로 쓴다.
             --   구동 집합이 payload 행(수십)이라 스칼라 서브쿼리 비용은 무시 가능.
             , NVL( (SELECT MAX(LK.ATTRIBUTE1)
                     FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LK
                     WHERE  LK.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'
                     AND    LK.SEGMENT1    = B.DIVISION_ID
                     AND    LK.SEGMENT2    = B.ITEM_ID)
                  , (SELECT MAX(SN.NICK_NAME)
                     FROM   SCM_MGR.SCM_MST_ITEM_SN SN
                     WHERE  SN.DIVISION_ID = B.DIVISION_ID
                     AND    SN.ITEM_ID     = B.ITEM_ID) ) AS TGT_NICK
        FROM   SCM_MGR.GT_0044_RESULTS_MST B
"""

# ② INSERT 컬럼 목록에 SOLDTO_CODE / NICK_NAME 추가
_H2_OLD = """            CELL_MODEL_INFO, ATTRIBUTE3, QTY,
"""
_H2_NEW = """            CELL_MODEL_INFO, ATTRIBUTE3, QTY,
            SOLDTO_CODE, NICK_NAME,
"""

# ③ VALUES 에 대응 값 추가
_H3_OLD = """            B2.CELL_MODEL_INFO, B2.CELL_MODEL, TO_NUMBER(B2.QTY),
"""
_H3_NEW = """            B2.CELL_MODEL_INFO, B2.CELL_MODEL, TO_NUMBER(B2.QTY),
            -- [ETCNICK 2026-08-11] SOLDTO_CODE 는 payload 에 없다. 이 원장의 확립된 규약은 '-'
            --   (사내 실측 209,696/209,702행이 '-'). hook #119 센티널 표준.
            '-', B2.TGT_NICK,
"""

HUNKS = [(_H1_OLD, _H1_NEW), (_H2_OLD, _H2_NEW), (_H3_OLD, _H3_NEW)]


def live_body():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE
                       WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                       ORDER BY LINE""")
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
    for i, (old, _new) in enumerate(HUNKS, 1):
        print("  hunk#%d 앵커 = %d건" % (i, body.count(old)))
    return 0


def cmd_patch():
    if not BACKUP.is_file():
        sys.exit("[error] 백업 부재 — --dump 선행")
    text = BACKUP.read_text(encoding="utf-8")
    if "ETCNICK" in text:
        sys.exit("[error] 이미 적용됨")
    for i, (old, new) in enumerate(HUNKS, 1):
        n = text.count(old)
        if n != 1:
            sys.exit("[error] hunk#%d 앵커 %d건 (기대 1) — 손대지 않음" % (i, n))
        text = text.replace(old, new)
    for m, c in GUARD_MARKS.items():
        if text.count(m) != c:
            sys.exit("[error] 선행 마커 '%s' 소실" % m)
    PATCHED.write_text(text, encoding="utf-8")
    print("[patch] %s (%d행)" % (PATCHED, len(text.splitlines())))
    print("  SOLDTO_CODE='-' + NICK_NAME(AS-IS 규칙) 적용 ✅ / 선행 마커 %d종 유지 ✅" % len(GUARD_MARKS))
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
        for m in list(GUARD_MARKS) + ["ETCNICK"]:
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
