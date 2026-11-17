# [E20261109-ALLBUCKET] 전후 동등성·속도 실측 (조회 전용 · 사내 ZIOUI1)
#   사용: python measure.py <LABEL> <spec>...   spec = KIND:DIV:FROM:TO:BUCKET   KIND = MKT|SALES|MKT_T|SALES_T|BIZ_T
#   결과: results_<LABEL>.jsonl (행마다 실행 1회) — 비교는 compare.py
#   해시 = 행 순서 무관 · 열 이름 기준 · NON_D(일자 외 전 컬럼) / D(일자 컬럼) 분리 → 'W·M·고정 값 불변 + D 추가' 를 따로 판정
import sys, time, json, hashlib, datetime, pathlib, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics'); import ora

W = pathlib.Path(__file__).resolve().parent
label = sys.argv[1]
SUM = None if label == 'BEFORE' else ('Y' if label.endswith('_SUMY') else None)  # AFTER = FE 미전송(NULL) 상태 재현
TITLE_SUM = []  # 사용자 지시 18:23 — P_SUM_YN 철회 → TITLE 시그니처 원래대로
out = (W / f"results_{label}.jsonl").open("a", encoding="utf-8")
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
USER = 'minyonglee1'


def norm(v):
    if v is None: return ''
    if isinstance(v, float) and v == int(v): v = int(v)
    if isinstance(v, datetime.datetime): return v.isoformat()
    return str(v)


def hset(rows):
    h = hashlib.sha256()
    for r in sorted(rows): h.update(r.encode()); h.update(b'\n')
    return h.hexdigest()[:16]


def call(kind, div, frm, to, bucket):
    if kind == 'MKT':
        rc = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(4)]
        cur.callproc('PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL',
                     [div, 'ALL', 'ALL', 'ALL', '', '', 'ALL', frm, to, USER, 'ALL', 'ALL', '', 'CURRENT', bucket, '', '', 'N', 'ALL', USER, 'DMF0035'] + rc)
        return rc[0].getvalue(), rc[3].getvalue()
    if kind == 'SALES':
        rc = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(3)]
        cur.callproc('PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL',
                     [div, 'ALL', 'ALL', 'ALL', '', '', 'ALL', frm, '20261109', to, USER, 'ALL', 'ALL', '', 'N', 'N', 'CURRENT', bucket, '', '', USER, 'DMF0035'] + rc)
        return rc[0].getvalue(), rc[2].getvalue()
    rc = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(2)]
    if kind == 'MKT_T':
        cur.callproc('PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE', [frm, to, USER, div, bucket] + TITLE_SUM + rc)
    elif kind == 'SALES_T':
        cur.callproc('PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE', [frm, to, USER, div, bucket, USER, 'DMF0035'] + TITLE_SUM + rc)
    elif kind == 'BIZ_T':
        cur.callproc('PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE', [frm, to, USER, div, bucket, USER, 'DMF0035'] + TITLE_SUM + rc)
    return rc[0].getvalue(), rc[1].getvalue()


for spec in sys.argv[2:]:
    kind, div, frm, to, bucket = spec.split(':')
    rec = dict(label=label, kind=kind, div=div, frm=frm, to=to, bucket=bucket, at=f"{datetime.datetime.now():%H:%M:%S}")
    t = time.time()
    try:
        c1, cres = call(kind, div, frm, to, bucket)
        t_proc = time.time() - t
        cols = [x[0] for x in c1.description]; rows = c1.fetchall()
        res = cres.fetchall()
        rec.update(proc_sec=round(t_proc, 2), total_sec=round(time.time() - t, 2), rows=len(rows), cols=len(cols), res=str(res[:1]))
        if kind.endswith('_T'):
            ci = cols.index('COLUMN_NAME')
            names = [str(r[ci]) for r in rows]
            for k in 'DWMQY': rec[f"t{k}"] = sum(n.startswith(k + '_') for n in names)
            nd = [r for r in rows if not str(r[ci]).startswith('D_')]
            dd = [r for r in rows if str(r[ci]).startswith('D_')]
            rec['h_non_d'] = hset(['|'.join(f"{c}={norm(v)}" for c, v in zip(cols, r)) for r in nd])
            rec['h_d'] = hset(['|'.join(f"{c}={norm(v)}" for c, v in zip(cols, r)) for r in dd])
        else:
            for k in 'DWM': rec[k] = sum(c.startswith(k + '_') for c in cols)
            nd_idx = [i for i, c in enumerate(cols) if not c.startswith('D_')]
            d_idx = [i for i, c in enumerate(cols) if c.startswith('D_')]
            key_idx = [i for i, c in enumerate(cols) if c[:2] not in ('D_', 'W_', 'M_')]
            rec['h_non_d'] = hset(['|'.join(f"{cols[i]}={norm(r[i])}" for i in nd_idx) for r in rows])
            # 일자 값 = 키 + D_ 값 (D_ 0/NULL 은 같은 것으로 — PIVOT NULL vs NVL 0 차이 흡수)
            rec['h_d'] = hset(['|'.join(f"{cols[i]}={norm(r[i])}" for i in key_idx) + '#' +
                               '|'.join(f"{cols[i]}={norm(r[i]) if norm(r[i]) not in ('', '0') else '0'}" for i in d_idx) for r in rows])
            # D 합 = W 합 검증용 (월별 D 합계 vs M 값은 BALANCE 류 기말값 예외가 있으므로 참고치)
            rec['sumD'] = round(sum(float(r[i] or 0) for r in rows for i in d_idx), 3)
            rec['sumM'] = round(sum(float(r[i] or 0) for r in rows for i, c in enumerate(cols) if c.startswith('M_')), 3)
    except Exception as e:
        rec.update(total_sec=round(time.time() - t, 2), err=str(e).splitlines()[0][:300])
    con.rollback()
    out.write(json.dumps(rec, ensure_ascii=False) + "\n"); out.flush()
    print(json.dumps(rec, ensure_ascii=False), flush=True)
