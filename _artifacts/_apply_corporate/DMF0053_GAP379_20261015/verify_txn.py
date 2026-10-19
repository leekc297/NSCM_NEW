# GAP 379 트랜잭션 검증 — 10_APPLY INSERT 를 커밋 없이 실행 → 이관 사용자로 실제 GET 2종 호출 → ROLLBACK
#   파라미터 = FE 실전송값(SCM_COM_SQL_LOG 2026-10-15 19:24:26 bpark416 조회) 에서 사용자만 교체 (hook #153 G153-4)
#   판정: 오류 0 · 결과코드 '0' · 칸 제목(O_RC1) 칸 목록 = 그 사용자의 이관 칸 집합 · 정렬식(O_RC3) 의 칸 = 이관 칸
#   GET 은 Measure 설정이 없는 사용자에게 기본 'M' 행을 만든다 → 같은 트랜잭션이라 ROLLBACK 으로 함께 사라짐
import sys, json, pathlib, re, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora

HERE = pathlib.Path(__file__).parent
APPLY = pathlib.Path(r'C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0053_GAP379_TITLESET_CLOUD_20261015\A_DB\10_APPLY_GAP379_TITLESET.sql').read_text(encoding='utf-8')
ins = APPLY[APPLY.index('INSERT INTO SCM_MST_TITLESET_USER'):APPLY.index(';\nCOMMIT;')]
rows = [r for r in json.loads((HERE / 'asis_rows.json').read_text(encoding='utf-8'))['rows'] if r['_JUDGE'] == 'MIGRATE']
FE = {'itemType': 'ALL', 'bizType': 'ALL', 'scmSiteId': 'ALL', 'groupId': '', 'userDeptId': '', 'projectCode': '', 'versionNo': '',
      'toCreatedate': '20260831', 'endCustomer': 'ALL', 'divisionId': '81', 'toYyyymmdd': '20270228', 'owner': '', 'plantSiteId': 'ALL',
      'fromYyyymmdd': '20260901', 'fromCreatedate': '20260801', 'deptId': 'ALL', 'bucket': 'ONLY_WEEKLY', 'itemId': '', 'mnuId': 'DMF0053'}

u, p, d = ora.conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print('HOST', cur.fetchone()[0])
cur.execute("SELECT COUNT(*) FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0053'"); before = cur.fetchone()[0]


def rc():
    return cur.var(oracledb.DB_TYPE_CURSOR)


def fetch(v):
    c = v.getvalue()
    if c is None:
        return None, []
    cols = [x[0] for x in c.description]
    return cols, c.fetchall()


def title(user):
    r1, rr = rc(), rc()
    cur.callproc('PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE', [FE['fromYyyymmdd'], FE['toYyyymmdd'], user, FE['divisionId'], FE['bucket'], user, 'DMF0053', r1, rr])
    cols, data = fetch(r1); _, res = fetch(rr)
    ci = cols.index('COLUMN_NAME')
    return [x[ci] for x in data], res


def main_get(user):
    r1, r2, r3, rr = rc(), rc(), rc(), rc()
    cur.callproc('PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL', [
        FE['divisionId'], FE['deptId'], FE['endCustomer'], FE['scmSiteId'], FE['projectCode'], FE['itemId'], FE['itemType'],
        FE['fromYyyymmdd'], FE['toYyyymmdd'], user, FE['plantSiteId'], FE['bizType'], FE['owner'], FE['bucket'], FE['userDeptId'],
        FE['groupId'], FE['versionNo'], FE['fromCreatedate'], FE['toCreatedate'], user, 'DMF0053', r1, r2, r3, rr])
    c1, d1 = fetch(r1); _, d3 = fetch(r3); _, res = fetch(rr)
    o = d3[0][0] if d3 else None
    return (c1 or []), len(d1), (o.read() if hasattr(o, 'read') else o), res


users_c = sorted({r['USER_ID'] for r in rows if r['USER_INQUIRY_COLUMN_TYPE_CODE'] == 'C'})
users_m_only = sorted({r['USER_ID'] for r in rows} - set(users_c))[:3]
targets = users_c + users_m_only
base = {}
for usr in [users_c[0]]:                      # 이관 전 기준(기본 칸) 1명
    base[usr] = title(usr)[0]
try:
    cur.execute(ins)
    print('INSERT rows', cur.rowcount, '(expected', len(rows), ')')
    fails = 0
    for usr in targets:
        mine = [r for r in sorted(rows, key=lambda r: (r['SORT_ORDER_NO'] is None, r['SORT_ORDER_NO'])) if r['USER_ID'] == usr and r['USER_INQUIRY_COLUMN_TYPE_CODE'] == 'C']
        try:
            tcols, tres = title(usr)
            c1, n1, order, res = main_get(usr)
            exp = {r['COLUMN_NAME'] for r in mine}
            t_ok = (not mine) or exp.issubset(set(tcols))
            body = (order or '').removesuffix('CREATE_DATE DESC, SORT_ORDER_NO')   # SP 고정 접미(L1191)만 제거
            o_list = [re.sub(r'\s+(ASC|DESC)$', '', x.strip(), flags=re.I) for x in body.split(',') if x.strip()]
            o_cols = set(o_list)
            o_ok_seq = (not mine) or o_list == [r['COLUMN_NAME'] for r in mine]
            o_ok = ((not mine) or o_cols == exp) and o_ok_seq
            code = res[0][0] if res else None
            ok = t_ok and o_ok and str(code) == '0'
            fails += 0 if ok else 1
            print(f"  {'PASS' if ok else 'FAIL'} {usr:14s} C이관 {len(mine):2d} | 제목칸 {len(tcols):2d} 포함={t_ok} | 정렬칸={o_ok} | 조회행 {n1} 결과코드 {code}")
            if not o_ok and '--debug' in sys.argv:
                print('     ORDER =', repr(order)[:600])
                print('     이관칸 =', [(r['SORT_ORDER_NO'], r['COLUMN_NAME'], r['DATA_SORT_METHOD_CODE']) for r in mine])
                print('     차이  = 정렬식에만', sorted(o_cols - exp), '/ 이관에만', sorted(exp - o_cols))
        except oracledb.DatabaseError as e:
            fails += 1
            print(f"  ERROR {usr}: {str(e)[:300]}")
    print('기준(이관 전)', users_c[0], '제목칸', len(base[users_c[0]]), '→ 이관 후는 위 행 참조')
    print('RESULT', 'ALL PASS' if fails == 0 else f'FAIL {fails}')
finally:
    cn.rollback()
    cur.execute("SELECT COUNT(*) FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0053'")
    print('ROLLBACK — DMF0053 titleset', cur.fetchone()[0], 'before', before)
