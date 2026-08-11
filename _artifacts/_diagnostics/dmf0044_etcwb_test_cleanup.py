#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etcwb_test_cleanup.py — ETCWB 검증 테스트 행 잔여 정리 (2026-08-11)

검증 스크립트가 [D] 단계에서 예외로 중단되면 [E] DELETE·[F] 정리가 실행되지 않아
합성 테스트 행이 원장에 남는다. 이 스크립트로 잔여를 제거하고 총 행수를 보고한다.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MARK, ITEM = "ZZ_ETCWB_TEST", "ZZ_ETCWB"
ETC = "SCM_MGR.DM_PLN_SALES_ETC_REPORT_C"
PLAN = "SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C"


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for t, where, binds in (
            (ETC, "CELL_MODEL_INFO=:m OR ITEM_ID=:i", {"m": MARK, "i": ITEM}),
            (PLAN, "ITEM_ID=:i OR FORECAST_INFO_CELL_MODEL=:m", {"i": ITEM, "m": MARK}),
        ):
            cur.execute(f"SELECT COUNT(*) FROM {t} WHERE {where}", binds)
            n = cur.fetchone()[0]
            if n:
                cur.execute(f"DELETE FROM {t} WHERE {where}", binds)
                print("  %s 잔여 %d행 삭제" % (t, cur.rowcount))
            else:
                print("  %s 잔여 없음" % t)
        con.commit()
        for t in (ETC, PLAN):
            cur.execute(f"SELECT COUNT(*) FROM {t}")
            print("  %s 총 %d행" % (t, cur.fetchone()[0]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
