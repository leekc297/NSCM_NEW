"""[E20261014-DMF0044GRPUPPER] DMF0044 조회 프로시저 직접 호출 (읽기 전용 — 조회 프로시저만 호출)

  python test_call.py

버전 2종(REPORT_SP_W · REPORT_BP_M) × Data Type 3종(0 = ALL · 1 = CUTOFF DATA · 2 = ETC).
적용 전: ALL · CUTOFF DATA = ORA-00979, ETC = 정상.  적용 후: 모두 정상이어야 한다.
추가 확인: ALL 의 행 수 = CUTOFF DATA + ETC,  Model Type 분포(CUTOFF DATA).
"""
import sys
from collections import Counter
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

CASES = [("40", "REPORT_SP_W", "R_S_20261002_V001_C"), ("40", "REPORT_BP_M", "R_B_20260814_V001")]
NAMES = {"0": "ALL", "1": "CUTOFF DATA", "2": "ETC"}


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    fail = 0
    for div, typ, ver in CASES:
        n = {}
        for dt in ("0", "1", "2"):
            o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
            try:
                cur.callproc("SCM_MGR.PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA",
                             [div, typ, "2026", ver, dt, "ADMIN", "minyonglee1", "minyonglee1", "DMF0044", o1, o2])
                c = o1.getvalue()
                cols = [x[0] for x in c.description]
                rows = c.fetchall()
                n[dt] = len(rows)
                mt = Counter(r[cols.index("MODEL_TYPE")] for r in rows) if "MODEL_TYPE" in cols else "컬럼 없음"
                print("OK  |", div, typ, ver, "|", NAMES[dt], "| rows", len(rows), "| cols", len(cols), "| Model Type", dict(mt) if dt == "1" else "")
            except oracledb.DatabaseError as e:
                fail += 1
                print("ERR |", div, typ, ver, "|", NAMES[dt], "|", str(e)[:170].replace("\n", " / "))
            con.rollback()
        if len(n) == 3:
            ok = n["0"] == n["1"] + n["2"]
            fail += (not ok)
            print("PASS" if ok else "FAIL", "| ALL 행 수 = CUTOFF DATA + ETC :", n["0"], "=", n["1"], "+", n["2"])
    print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
    sys.exit(0 if fail == 0 else 1)


if __name__ == "__main__":
    main()
