# -*- coding: utf-8 -*-
"""
DMF0045 W/H BOH 82 사업부 부분 재고 뷰 1회 읽기 보완 (사내 ZIOUI1)
  1) ALL_SOURCE 에서 PKG_DMF0045 PACKAGE BODY 새로 조회(기준본) + ASIS 백업
  2) 수정 전 조회 결과 지문(6개 조건)
  3) 기준본 위 외과 치환(매칭 1건 assert)
  4) FRESH-GATE: 적용 직전 재조회 == 기준본
  5) CREATE OR REPLACE · VALID · ALL_ERRORS 0
  6) 수정 후 조회 결과 지문 비교
"""
import sys, os, time, hashlib, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora

OUT = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0045', 'PACKAGE BODY'

OLD = (
"              FROM SSP_DNM_ESS_PACKER_STOCK_V A\r\n"
"                 , SCM_MST_SITE B\r\n"
"                 , SCP_MST_FINAL_ITEM C\r\n"
"                 , (SELECT DIVISION_ID\r\n"
"                         , SITE_ID\r\n"
"                         , MAX(CUTOFF_DATE)                                 AS MAX_CUTOFF_DATE\r\n"
"                      FROM SSP_DNM_ESS_PACKER_STOCK_V\r\n"
"                     WHERE DIVISION_ID  = V_DIVISION_ID\r\n"
)
OLD_TAIL = (
"                     GROUP BY DIVISION_ID\r\n"
"                            , SITE_ID\r\n"
"                   ) XA\r\n"
"             WHERE A.DIVISION_ID      = XA.DIVISION_ID\r\n"
"               AND A.SITE_ID          = XA.SITE_ID\r\n"
"               AND A.CUTOFF_DATE      = XA.MAX_CUTOFF_DATE\r\n"
"               AND A.CUTOFF_DATE      > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')\r\n"
)
NEW_HEAD = (
"              /* [E20261125-BOHONCE] 재고 뷰를 1번만 읽고 사이트별 최근 재고 일자는 같은 읽기에서 구함 */\r\n"
"              /* (종전 : 같은 뷰를 2번 읽어 클라우드 1회 960초)                                         */\r\n"
"              FROM (SELECT V.DIVISION_ID\r\n"
"                         , V.SITE_ID\r\n"
"                         , V.SCM_SITE_ID\r\n"
"                         , V.ITEM_ID\r\n"
"                         , V.SSP_QTY\r\n"
"                         , V.CUTOFF_DATE\r\n"
"                         , MAX(V.CUTOFF_DATE) OVER (PARTITION BY V.DIVISION_ID, V.SITE_ID) AS MAX_CUTOFF_DATE\r\n"
"                      FROM SSP_DNM_ESS_PACKER_STOCK_V V\r\n"
"                     WHERE V.DIVISION_ID  = V_DIVISION_ID\r\n"
)
NEW_TAIL = (
"                       AND V_DIVISION_ID  = '82'\r\n"
"                   ) A\r\n"
"                 , SCM_MST_SITE B\r\n"
"                 , SCP_MST_FINAL_ITEM C\r\n"
"             WHERE A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE\r\n"
)

SCEN = [(s, d) for d in ('82', '81', '40') for s in ('Pack Biz', 'Cell Biz')]
FROM_, TO_, USER = '20261123', '20270131', 'jaeuk.shin'


def log(*a):
    print(time.strftime('%H:%M:%S'), *a, flush=True)


def conn():
    u, p, d = ora.conn_info()
    c = oracledb.connect(user=u, password=p, dsn=d)
    c.call_timeout = 600000
    c.cursor().execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
    return c


def fetch_src(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE",
                o=OWNER, n=NAME, t=TYP)
    return meta, ''.join(r[0] for r in cur.fetchall())


def run_all(cx, tag):
    res = {}
    for s, d in SCEN:
        cur = cx.cursor()
        rc1 = cur.var(oracledb.DB_TYPE_CURSOR); rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
        t = time.time()
        cur.callproc('PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST',
                     [s, d, 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', FROM_, TO_, USER, rc1, rc2])
        t1 = time.time()
        rows = rc1.getvalue().fetchall()
        t2 = time.time()
        cur.execute("SELECT COUNT(*) FROM GT_DMF0045_BOH"); boh = cur.fetchone()[0]
        h = hashlib.md5(repr(rows).encode('utf-8')).hexdigest()
        cx.rollback()
        res[(s, d)] = (len(rows), h, boh)
        log(f'{tag} {s}/{d} proc={t1-t:.2f}s fetch={t2-t1:.2f}s rows={len(rows)} boh={boh} md5={h}')
    return res


def main():
    cx = conn(); cur = cx.cursor()
    cur.execute("select sys_context('USERENV','DB_NAME'), sys_context('USERENV','SERVER_HOST') from dual")
    log('DB', cur.fetchone())
    meta, base = fetch_src(cur)
    log('BASE', meta, 'chars', len(base))
    open(os.path.join(OUT, 'PKG_DMF0045_BODY.ASIS.sql'), 'w', encoding='utf-8', newline='').write(
        f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0045 PACKAGE BODY LAST_DDL={meta[0]} FETCHED={time.strftime('%Y-%m-%d %H:%M')} DB=ZIOUI1\r\n"
        "CREATE OR REPLACE " + base + "\r\n/\r\n")

    i = base.find(OLD); assert base.count(OLD) == 1, 'OLD 매칭 != 1'
    j = base.find(OLD_TAIL, i); assert base.count(OLD_TAIL) == 1 and j > i, 'OLD_TAIL 매칭 != 1'
    mid = base[i + len(OLD): j]          # 범위 조건 2줄 (그대로 둠)
    mid_new = mid.replace("AND CUTOFF_DATE", "AND V.CUTOFF_DATE")
    assert mid_new.count("V.CUTOFF_DATE") == 2, 'mid 범위 조건 2줄 아님'
    tobe = base[:i] + NEW_HEAD + mid_new + NEW_TAIL + base[j + len(OLD_TAIL):]
    open(os.path.join(OUT, 'PKG_DMF0045_BODY.TOBE.sql'), 'w', encoding='utf-8', newline='').write(
        f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0045 PACKAGE BODY LAST_DDL={meta[0]} FETCHED={time.strftime('%Y-%m-%d %H:%M')} DB=ZIOUI1\r\n"
        "CREATE OR REPLACE " + tobe + "\r\n/\r\n")

    before = run_all(cx, 'BEFORE')

    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    meta2, now = fetch_src(cur)
    assert now == base and meta2[0] == meta[0], 'FRESH-GATE 실패: 착수 후 DB 원문 변경'
    log('FRESH-GATE OK', meta2)
    cur.execute("CREATE OR REPLACE " + tobe)
    meta3, after_src = fetch_src(cur)
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n", o=OWNER, n=NAME)
    errs = cur.fetchone()[0]
    log('APPLIED', meta3, 'errors', errs, 'src==tobe', after_src == tobe)
    assert errs == 0 and meta3[1] == 'VALID'

    after = run_all(cx, 'AFTER')
    diff = [k for k in SCEN if before[k] != after[k]]
    log('COMPARE', 'same' if not diff else f'DIFF {diff}')


if __name__ == '__main__':
    main()
