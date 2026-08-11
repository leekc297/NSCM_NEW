#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_etc_double_locate.py — DMF0044 ETC/Cutoff 조회 2배 표시의 발생 단계 특정 (2026-08-11)

GET 은 ① 원장 → GT_F044_T 적재(집계 INSERT SELECT) ② 동적 PIVOT 최종 SELECT 2단계다.
같은 세션에서 GET 호출 직후 GTT 를 직접 들여다보면 증식 지점을 가를 수 있다.

  · GT_F044_T 가 이미 2행 → 적재 단계의 조인 fan-out (룩업 중복 × 집계 전 조인)
  · GT_F044_T 는 1행인데 결과가 2배 → 최종 PIVOT/조인 단계

읽기 전용 — 원장 무변경.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DIV, VER, CUT, YYYY = "40", "R_S_20260128_V002_C", "REPORT_SP_W", "2025"
DEPT, TEAM, ITEM, MSR, YM = "50030981", "58099468", "ETC", "SalesAmt_KRW", "202503"
# titleset(measure GTT) 적재 키 — 인자로 교체 가능
READER = sys.argv[1] if len(sys.argv) > 1 else "minyonglee1"
ETC = "SCM_MGR.DM_PLN_SALES_ETC_REPORT_C"


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        cur.execute(f"""SELECT COUNT(*), SUM(QTY) FROM {ETC}
            WHERE DIVISION_ID=:d AND VERSION_NO=:v AND CUTOFF_TYPE=:c
              AND DEPARTMENT_ID=:dept AND DEPT_ID=:team AND ITEM_ID=:i
              AND MEASURE=:m AND SUBSTR(YYYYMMDD,1,6)=:ym""",
                    {"d": DIV, "v": VER, "c": CUT, "dept": DEPT, "team": TEAM,
                     "i": ITEM, "m": MSR, "ym": YM})
        lcnt, lsum = cur.fetchone()
        print("[원장] %d행 / SUM(QTY)=%s" % (lcnt, lsum))

        rc = cur.var(oracledb.DB_TYPE_CURSOR)
        res = cur.var(oracledb.DB_TYPE_CURSOR)
        cur.callproc("SCM_MGR.PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA", keywordParameters=dict(
            P_DIVISION_ID=DIV, P_MDF_TYPE=CUT, P_YYYY=YYYY, P_SP_VERSION_NO=VER,
            P_DATA_TYPE="2", P_USER_GROUP="ADMIN", P_CREATED_BY=READER,
            P_USER_ID="minyonglee1", P_MNU_ID="DMF0044", O_RC1=rc, O_RESULT_CURSOR=res))
        g = rc.getvalue()
        cols = [c[0] for c in g.description]
        rows = g.fetchall()

        def gi(c):
            return cols.index(c)

        hits = [r for r in rows
                if str(r[gi("DEPARTMENT_ID")]) == DEPT and str(r[gi("DEPT_ID")]) == TEAM
                and str(r[gi("ITEM_ID")]) == ITEM and str(r[gi("MEASURE")]) == MSR]
        mcol = "M_" + YM
        print("[GET ] 매칭 그리드행 %d개 / %s = %s"
              % (len(hits), mcol, [h[gi(mcol)] for h in hits] if mcol in cols else "(컬럼없음)"))

        # 같은 세션 — GTT 내용 직접 확인
        cur.execute("""SELECT COUNT(*), SUM(QTY) FROM SCM_MGR.GT_F044_T
            WHERE DEPARTMENT_ID=:dept AND DEPT_ID=:team AND ITEM_ID=:i
              AND MEASURE=:m AND YYYYMM=:ym""",
                    {"dept": DEPT, "team": TEAM, "i": ITEM, "m": MSR, "ym": "M_" + YM})
        gcnt, gsum = cur.fetchone()
        print("[GTT ] GT_F044_T %d행 / SUM(QTY)=%s" % (gcnt, gsum))

        cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_F044_T")
        print("[GTT ] GT_F044_T 총 %d행" % cur.fetchone()[0])

        # 최종 쿼리의 fan-out 후보 — GT_F044_SELECT_MEASURE 조인 (A.MEASURE = B.MEASURE)
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_F044_SELECT_MEASURE")
        tot = cur.fetchone()[0]
        cur.execute("SELECT COUNT(DISTINCT MEASURE) FROM SCM_MGR.GT_F044_SELECT_MEASURE")
        dis = cur.fetchone()[0]
        print("[GTT ] GT_F044_SELECT_MEASURE %d행 / DISTINCT MEASURE %d개" % (tot, dis))
        cur.execute("""SELECT MEASURE, COUNT(*) FROM SCM_MGR.GT_F044_SELECT_MEASURE
                       GROUP BY MEASURE HAVING COUNT(*) > 1 ORDER BY 2 DESC""")
        dups = cur.fetchall()
        print("[GTT ] 중복 MEASURE %d종 %s" % (len(dups), dups[:8]))
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_F044_SELECT_MEASURE WHERE MEASURE=:m", {"m": MSR})
        print("[GTT ] '%s' 행수 = %d" % (MSR, cur.fetchone()[0]))

        print("\n=== 판정 ===")
        if gcnt and lcnt and gcnt > lcnt:
            print("  ⇒ **적재 단계** 증식 (GT_F044_T 가 이미 %d행, 원장 %d행)" % (gcnt, lcnt))
        elif gcnt and gsum and lsum and abs(float(gsum) - float(lsum)) > 0.001:
            print("  ⇒ **적재 단계** 금액 증식 (GTT %s vs 원장 %s)" % (gsum, lsum))
        else:
            print("  ⇒ 적재는 정상 — **최종 PIVOT/조인 단계** 증식 의심")
        return 0


if __name__ == "__main__":
    sys.exit(main())
