# -*- coding: utf-8 -*-
"""(b) 정리 — 수정 전/후 시험: 조회 프로시저 2종 + 술어 등가 SELECT (끝에 ROLLBACK)
  python run_tests.py before | after | compare
저장 프로시저(PKG_SDM*, PKG_SCM0002 SET_TITLESET)와 배치(PR_SCP_OPT_ENG_*)는 데이터를 바꾸므로 실행하지 않는다."""
import sys, os, time, pickle, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn, oracledb
B = dict(P_SCM_SITE_ID='ALL', P_PLANT_SITE_ID='ALL', P_TEAM_ID='ALL', P_CUSTOMER='ALL', P_BIZ_TYPE='ALL', P_PROJECT_CODE=None, P_ITEM_ID='ALL',
         P_FROM_YYYYMMDD='20261101', P_TO_YYYYMMDD='20261231', P_CREATED_BY='minyonglee1', P_USER_GROUP='ADMIN', P_ITEM_TYPE='ALL', P_OWNER=None,
         P_QTY_YN='N', P_CELL_YN='N', P_INVALID_EXEC='N', P_AS_YN='N', P_USER_DEPT_ID=None, P_SENDER_CODE='ALL', P_USER_ID='minyonglee1', P_MENU_ID='DMF0003')
OUTS = ['O_RC1', 'O_RC2', 'O_RC3', 'O_RESULT_CURSOR']
TESTS = [(d, p) for p in ('PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA', 'PKG_DMF0003_01.P_DMF0003_01_GET_MKT_FCST_DATA') for d in ('81', '82', '40')]
SQLS = [
    ("DM_PLN_MKT_FCST MKT_FCST 수정 전 술어", "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST A WHERE A.MEASURE='MKT_FCST' AND ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')"),
    ("DM_PLN_MKT_FCST MKT_FCST 수정 후 술어", "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST A WHERE A.MEASURE='MKT_FCST' AND ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL)"),
    ("DUAL NVL(V,'') != '' OR V IS NOT NULL  (V 값 있음 / NULL)", "SELECT (SELECT COUNT(*) FROM DUAL WHERE ( NVL('X','') != '' OR 'X' IS NOT NULL )), (SELECT COUNT(*) FROM DUAL WHERE ( 'X' IS NOT NULL )), (SELECT COUNT(*) FROM DUAL WHERE ( NVL(CAST(NULL AS VARCHAR2(10)),'') != '' OR CAST(NULL AS VARCHAR2(10)) IS NOT NULL )), (SELECT COUNT(*) FROM DUAL WHERE ( CAST(NULL AS VARCHAR2(10)) IS NOT NULL )) FROM DUAL"),
    ("DUAL V IS NOT NULL OR V != ''  (V 값 있음 / NULL)", "SELECT (SELECT COUNT(*) FROM DUAL WHERE ( 'X' IS NOT NULL OR 'X' != '' )), (SELECT COUNT(*) FROM DUAL WHERE ( 'X' IS NOT NULL )), (SELECT COUNT(*) FROM DUAL WHERE ( CAST(NULL AS VARCHAR2(10)) IS NOT NULL OR CAST(NULL AS VARCHAR2(10)) != '' )), (SELECT COUNT(*) FROM DUAL WHERE ( CAST(NULL AS VARCHAR2(10)) IS NOT NULL )) FROM DUAL"),
]


def run(tag):
    con = dbconn.connect('tobe'); con.call_timeout = 280000
    cur = con.cursor(); res = {}
    for div, proc in TESTS:
        label = '%s %s' % (proc.split('.')[0], div)
        kw = dict(B, P_DIVISION_ID=div); ov = {}
        for o in OUTS:
            ov[o] = cur.var(oracledb.DB_TYPE_CURSOR); kw[o] = ov[o]
        t0 = time.time(); r = {}
        try:
            cur.callproc(proc, keyword_parameters=kw)
            for o in OUTS:
                try:
                    rc = ov[o].getvalue()
                    r[o] = ([d[0] for d in rc.description], [tuple(v.read() if hasattr(v, 'read') else v for v in x) for x in rc.fetchall()])
                except Exception as e:
                    r[o] = ([], [('ERR', str(e)[:80])])
            res[label] = dict(cur=r, sec=round(time.time() - t0, 1), err=None)
        except Exception as e:
            res[label] = dict(cur={}, sec=round(time.time() - t0, 1), err=dbconn.mask(str(e))[:300])
        con.rollback()
        x = res[label]
        print('  [%s] %-20s %5.1fs %s %s' % (tag, label, x['sec'], ' '.join('%s=%d행' % (o, len(x['cur'][o][1])) for o in x['cur']), x['err'] or ''), flush=True)
    for label, q in SQLS:
        cur.execute(q); v = cur.fetchall(); res['SQL ' + label] = v
        print('  [%s] %s => %s' % (tag, label, v), flush=True)
    pickle.dump(res, open(os.path.join(HERE, 'logs', 'tests.%s.pkl' % tag), 'wb'))
    con.close()


def compare():
    b = pickle.load(open(os.path.join(HERE, 'logs', 'tests.before.pkl'), 'rb'))
    a = pickle.load(open(os.path.join(HERE, 'logs', 'tests.after.pkl'), 'rb'))
    for k in a:
        if k.startswith('SQL '):
            continue
        if a[k]['err'] or b[k]['err']:
            print('  %-20s ERROR 전=%s 후=%s' % (k, b[k]['err'], a[k]['err'])); continue
        out = []
        for o in OUTS:
            cb, rb = b[k]['cur'][o]; ca, ra = a[k]['cur'][o]
            if o == 'O_RESULT_CURSOR':
                out.append('%s 전 %s 후 %s' % (o, rb[:1], ra[:1])); continue
            same = cb == ca and sorted(map(repr, rb)) == sorted(map(repr, ra))
            out.append('%s %d → %d행 %s' % (o, len(rb), len(ra), '같음' if same else '다름'))
        print('  %-20s %s' % (k, ' · '.join(out)))


if __name__ == '__main__':
    print('[%s] %s' % (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), sys.argv[1]))
    compare() if sys.argv[1] == 'compare' else run(sys.argv[1])
