#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etc_backfill_soldto_nick.py — 신규 등록분 SOLDTO_CODE / NICK_NAME 백필 (2026-08-11)

## 대상
ETCNICK 규칙 적용 **이전**에 화면에서 저장돼 두 컬럼이 NULL 로 남은 신규행.
실측 시점 기준 = `DM_PLN_SALES_ETC_REPORT_C` 에서 `SOLDTO_CODE IS NULL` 인 행
(사내 전수 209,702행 중 6행 — VERSION_NO='R_S_20260810_V010_C' / DATA_SEQ=237 / 2026-08-11 10:31 저장분).

## 채우는 값 — SP(ETCNICK)와 **동일 산출식** 사용 (하드코딩 금지)
  · SOLDTO_CODE = '-'                       (원장 209,696/209,702행이 '-' 인 확립 규약)
  · NICK_NAME   = NVL( LOOKUP 'DM_SR_ETC_MODEL'(SEGMENT1=DIVISION_ID, SEGMENT2=ITEM_ID).ATTRIBUTE1
                     , SCM_MST_ITEM_SN 집계 NICK_NAME )
    = AS-IS `DMF0049_SAVE` L168717 `ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME)` 이식

⚠ NICK_NAME 은 **산출값이 있을 때만** 채운다(NULL 이면 건드리지 않음) — 근거 없는 값 주입 금지.

사용:
  python dmf0044_etc_backfill_soldto_nick.py            # dry-run (대상·적용예정값)
  python dmf0044_etc_backfill_soldto_nick.py --apply    # 원복 SQL 생성 후 UPDATE
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

T = "SCM_MGR.DM_PLN_SALES_ETC_REPORT_C"
OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
BACKUP = OUT / "BACKUP_DMF0044_ETC_BACKFILL_SOLDTO_NICK_20260811.sql"

# SP(ETCNICK)와 동일한 NICK_NAME 산출식
NICK_EXPR = """NVL( (SELECT MAX(LK.ATTRIBUTE1)
                     FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LK
                     WHERE  LK.LOOKUP_TYPE = 'DM_SR_ETC_MODEL'
                     AND    LK.SEGMENT1    = A.DIVISION_ID
                     AND    LK.SEGMENT2    = A.ITEM_ID)
                  , (SELECT MAX(SN.NICK_NAME)
                     FROM   SCM_MGR.SCM_MST_ITEM_SN SN
                     WHERE  SN.DIVISION_ID = A.DIVISION_ID
                     AND    SN.ITEM_ID     = A.ITEM_ID) )"""

WHERE = "A.SOLDTO_CODE IS NULL"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()

    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(f"""SELECT A.VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, A.MEASURE, A.YYYYMMDD,
                               A.ITEM_ID, NVL(A.NICK_NAME,'(null)') AS CUR_NICK,
                               NVL({NICK_EXPR},'(산출불가)') AS NEW_NICK
                        FROM   {T} A
                        WHERE  {WHERE}
                        ORDER BY A.DATA_SEQ, A.MEASURE, A.YYYYMMDD""")
        rows = cur.fetchall()
        print("[대상] SOLDTO_CODE IS NULL — %d행" % len(rows))
        for r in rows:
            print("  %s / seq=%s / %-12s / %s / ITEM=%-8s  NICK: %s → %s"
                  % (r[0], r[2], r[3], r[4], r[5], r[6], r[7]))
        if not rows:
            print("  (백필 대상 없음)")
            return 0

        if not a.apply:
            print("\n(dry-run — --apply 로 실행)")
            return 0

        # ── 원복 SQL (행 단위 PK 지정) ────────────────────────────────────────────────
        OUT.mkdir(parents=True, exist_ok=True)
        cur.execute(f"""SELECT A.VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, A.MEASURE, A.YYYYMMDD,
                               A.SOLDTO_CODE, A.NICK_NAME
                        FROM   {T} A WHERE {WHERE}""")
        lines = ["-- 원복 SQL — DMF0044 ETC 신규분 SOLDTO_CODE/NICK_NAME 백필 직전 값 (2026-08-11)", ""]
        for v, dv, seq, ms, ymd, sc, nk in cur.fetchall():
            lines.append(
                "UPDATE %s SET SOLDTO_CODE = %s, NICK_NAME = %s\n"
                " WHERE VERSION_NO='%s' AND DIVISION_ID='%s' AND DATA_SEQ=%s"
                " AND MEASURE='%s' AND YYYYMMDD='%s';"
                % (T, "NULL" if sc is None else "'%s'" % sc,
                   "NULL" if nk is None else "'%s'" % nk, v, dv, seq, ms, ymd))
        lines.append("COMMIT;")
        BACKUP.write_text("\n".join(lines), encoding="utf-8")
        print("\n[backup] %s (%d행)" % (BACKUP, len(rows)))

        # ── UPDATE ───────────────────────────────────────────────────────────────────
        cur.execute(f"""UPDATE {T} A
                        SET    A.SOLDTO_CODE     = '-',
                               A.NICK_NAME       = NVL({NICK_EXPR}, A.NICK_NAME),
                               A.LAST_UPDATED_BY = 'admin',
                               A.LAST_UPDATE_DATE = SYSDATE
                        WHERE  {WHERE}""")
        n = cur.rowcount
        con.commit()
        print("[apply] %d행 UPDATE + COMMIT" % n)

        # ── 검증 ─────────────────────────────────────────────────────────────────────
        cur.execute(f"SELECT COUNT(*) FROM {T} A WHERE A.SOLDTO_CODE IS NULL")
        left = cur.fetchone()[0]
        cur.execute(f"""SELECT A.DATA_SEQ, A.MEASURE, A.YYYYMMDD, A.SOLDTO_CODE,
                               NVL(A.NICK_NAME,'(null)')
                        FROM   {T} A
                        WHERE  A.LAST_UPDATE_DATE > SYSDATE - 1/1440
                        AND    A.LAST_UPDATED_BY = 'admin'
                        ORDER BY A.DATA_SEQ, A.MEASURE, A.YYYYMMDD""")
        after = cur.fetchall()
        print("[검증] SOLDTO_CODE IS NULL 잔여 = %d행 %s" % (left, "PASS" if left == 0 else "⛔"))
        for r in after:
            print("  seq=%s / %-12s / %s → SOLDTO=%s / NICK=%s" % r)
    return 0


if __name__ == "__main__":
    sys.exit(main())
