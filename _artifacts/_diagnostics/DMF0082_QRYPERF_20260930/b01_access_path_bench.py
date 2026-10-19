# -*- coding: utf-8 -*-
"""SCM_MST_FUTURE_PRICE 접근 경로 실측 (읽기 전용) — L1243/L1671 병목(div82 풀스캔 73~83s) 대안 비교.

L1243 이 소비하는 컬럼(DIVISION/PROJECT/SITE/ITEM/DOM_EXP/FCST_TYPE/INCOTERMS/MEASURE/CREATION_DATE/LAST_UPDATED_BY)을
같은 술어(DIVISION_ID=:d AND YYYYMMDD BETWEEN :f AND :t)로 읽어 경로별 elapsed / physical reads / logical reads 를 잰다.
각 경로 2회 (cold/warm 구분 — 1회차에 캐시가 데워진다). V$MYSTAT 델타 = 내 세션 한정.
사용: python b01_access_path_bench.py <div> <from> <to>
"""
import io, pathlib, sys, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV, FRM, TO = sys.argv[1], sys.argv[2], sys.argv[3]
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 900000
cur = cn.cursor()
STATS = ("physical reads", "session logical reads", "physical reads direct")


def mystat():
    cur.execute("SELECT N.NAME, S.VALUE FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC# = S.STATISTIC# "
                "WHERE N.NAME IN ('physical reads','session logical reads','physical reads direct')")
    return dict(cur.fetchall())


BODY = ("SELECT COUNT(*), COUNT(DISTINCT A.PROJECT_CODE||A.SCM_SITE_ID||A.ITEM_ID||A.DOM_EXP||A.FCST_TYPE||A.INCOTERMS||A.MEASURE),"
        " MAX(A.CREATION_DATE), MAX(A.LAST_UPDATED_BY)"
        " FROM SCM_MGR.SCM_MST_FUTURE_PRICE A WHERE A.DIVISION_ID = :d AND A.YYYYMMDD BETWEEN :f AND :t")
VARIANTS = [
    ("FULL", "/*+ FULL(A) */"),
    ("PK", "/*+ INDEX(A PK_SCM_MST_FUTURE_PRICE) */"),
    ("IDX02", "/*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */"),
]
for name, hint in VARIANTS:
    sql = BODY.replace("SELECT ", f"SELECT {hint} ", 1)
    for rep in (1, 2):
        a = mystat()
        t0 = time.time()
        cur.execute(sql, d=DIV, f=FRM, t=TO)
        r = cur.fetchone()
        el = time.time() - t0
        b = mystat()
        print(f"{name:6} run{rep}: {el:7.2f}s  rows={r[0]:,} keys={r[1]:,}  "
              + "  ".join(f"{k.replace('physical reads', 'PR').replace('session logical reads', 'LIO')}={b[k] - a[k]:,}" for k in STATS))
cn.close()
