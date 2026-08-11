#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etc_read_ratio.py — DMF0044 ETC 조회값 ÷ 원장 합계 배수 실측 (2026-08-11)

ETCWB 검증 [D] 에서 원장 1행/QTY=222 인데 GET 이 444(정확히 2배)를 반환했다.
그 2배가 **실데이터 전반**의 문제인지, 합성 행(마스터 미매칭)만의 문제인지 가른다.

방법: GET(P_DATA_TYPE='2') 결과 각 행의 M_yyyymm 값 ↔ 같은 FE 키로 집계한 원장 SUM(QTY) 를 1:1 대조.
읽기 전용 — 원장 무변경.
"""
import collections
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DIV, VER, CUT, YYYY = "40", "R_S_20260128_V002_C", "REPORT_SP_W", "2025"
ETC = "SCM_MGR.DM_PLN_SALES_ETC_REPORT_C"

KEYCOLS = ["DEPARTMENT_ID", "DEPT_ID", "END_CUST_REPORT", "CUST_REPORT", "PRODUCT_GROUP",
           "ITEM_ID", "MEASURE", "CURRENCY", "COMPANY_ID", "CELL_MODEL_INFO"]


def norm(v):
    s = "" if v is None else str(v).strip()
    return s if s else "-"


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        # ── 원장 집계 (FE 키 + 월 → SUM(QTY), 행수) ────────────────────────────────────
        cur.execute(f"""
            SELECT {', '.join(KEYCOLS)}, SUBSTR(YYYYMMDD,1,6) AS YM,
                   SUM(QTY) AS S, COUNT(*) AS C
            FROM   {ETC}
            WHERE  DIVISION_ID=:d AND VERSION_NO=:v AND CUTOFF_TYPE=:c
            AND    SUBSTR(YYYYMMDD,1,4)=:y
            GROUP BY {', '.join(KEYCOLS)}, SUBSTR(YYYYMMDD,1,6)
        """, {"d": DIV, "v": VER, "c": CUT, "y": YYYY})
        ledger = {}
        for r in cur.fetchall():
            k = tuple(norm(x) for x in r[:len(KEYCOLS)]) + (r[len(KEYCOLS)],)
            ledger[k] = (float(r[-2] or 0), r[-1])
        print("[원장] FE키×월 그룹 %d개" % len(ledger))

        # ── GET(ETC) 실행 ──────────────────────────────────────────────────────────────
        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        res = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc("SCM_MGR.PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA", keywordParameters=dict(
            P_DIVISION_ID=DIV, P_MDF_TYPE=CUT, P_YYYY=YYYY, P_SP_VERSION_NO=VER,
            P_DATA_TYPE="2", P_USER_GROUP="ADMIN", P_CREATED_BY="minyonglee1",
            P_USER_ID="minyonglee1", P_MNU_ID="DMF0044", O_RC1=rc, O_RESULT_CURSOR=res))
        g = rc.getvalue()
        cols = [c[0] for c in g.description]
        rows = g.fetchall()
        idx = {c: cols.index(c) for c in KEYCOLS if c in cols}
        months = [c for c in cols if c.startswith("M_") and c[2:].isdigit()]
        print("[GET ] %d행 / 월컬럼 %d개 (%s …)" % (len(rows), len(months), months[:3]))
        missing = [c for c in KEYCOLS if c not in idx]
        if missing:
            sys.exit("[error] GET 결과에 키 컬럼 없음: %s" % missing)

        # ── 1:1 대조 ───────────────────────────────────────────────────────────────────
        ratios = collections.Counter()
        unmatched = 0
        samples = []
        for r in rows:
            base = tuple(norm(r[idx[c]]) for c in KEYCOLS)
            for m in months:
                gv = r[cols.index(m)]
                if gv is None:
                    continue
                gv = float(gv)
                led = ledger.get(base + (m[2:],))
                if led is None:
                    unmatched += 1
                    continue
                lv, cnt = led
                if lv == 0:
                    ratios["원장0"] += 1
                    continue
                ratio = round(gv / lv, 6)
                ratios[ratio] += 1
                if ratio != 1.0 and len(samples) < 5:
                    samples.append((base[:3], m, "원장 %.4f×%d행 → 화면 %.4f" % (lv, cnt, gv)))

        print("\n[배수 분포] (화면값 ÷ 원장합계)")
        for k, v in sorted(ratios.items(), key=lambda x: -x[1]):
            print("  %-10s %d 셀" % (k, v))
        print("  원장 미매칭 셀 %d개" % unmatched)
        if samples:
            print("\n[불일치 샘플]")
            for s in samples:
                print("  %s %s  %s" % s)
        return 0


if __name__ == "__main__":
    sys.exit(main())
