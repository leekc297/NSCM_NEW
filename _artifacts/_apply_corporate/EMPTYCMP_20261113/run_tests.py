# -*- coding: utf-8 -*-
"""빈 문자열 비교 보완 — 수정 전/후 시험 실행 (조회 프로시저만 · 끝에 ROLLBACK)
  python run_tests.py before | after | compare
저장·배치 프로시저(PKG_DMF0003*.…SAVE_MKT_FCST_PK_DATA_UPDATE · PR_SCM_DNM_DELIVERY_TRACKING)는 데이터를 바꾸므로 실행하지 않는다.
"""
import sys, os, time, pickle, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn, oracledb

A35 = dict(P_DIVISION_ID='81', P_DEPT_ID='ALL', P_END_CUSTOMER='ALL', P_SCM_SITE_ID='ALL', P_PROJECT_CODE=None, P_ITEM_ID=None, P_ITEM_TYPE='ALL',
           P_FROM_YYYYMMDD='20261101', P_TO_YYYYMMDD='20270131', P_CREATED_BY='minyonglee1', P_PLANT_SITE_ID='ALL', P_BIZ_TYPE='ALL', P_OWNER=None,
           P_VERSION_NO='CURRENT', P_BUCKET='MONTHLY', P_USER_DEPT_ID=None, P_GROUP_ID=None, P_CELL_YN='N', P_SENDER_CODE='ALL', P_USER_ID='minyonglee1', P_MENU_ID='DMF0035')
A45 = dict(P_DIVISION_ID='81', P_TEAM_ID='ALL', P_CUSTOMER='ALL', P_SCM_SITE_ID=None, P_PLANT_SITE_ID='ALL', P_PROJECT_CODE=None, P_ITEM_ID=None,
           P_FROM_YYYYMMDD='20261113', P_TO_YYYYMMDD='20261231', P_CREATED_BY='minyonglee1')
A72 = dict(P_DIVISION_ID='81', P_DEPT_ID='ALL', P_END_CUSTOMER='ALL', P_PROJECT_CODE='%', P_SCM_SITE_ID='ALL', P_ITEM_ID='%')
TESTS = [
    ('DMF0035 81 MONTHLY', 'PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL', A35, ['O_RC1', 'O_RC2', 'O_RC3', 'O_RESULT_CURSOR'], 'O_RC1'),
    ('DMF0045 Cell Biz 81', 'PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST', dict(A45, P_SHEET_NAME='Cell Biz'), ['O_RC1', 'O_RESULT_CURSOR'], 'O_RC1'),
    ('DMF0045 Pack Biz 81', 'PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST', dict(A45, P_SHEET_NAME='Pack Biz'), ['O_RC1', 'O_RESULT_CURSOR'], 'O_RC1'),
    ('DMF0072 81 SW=NULL', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_MDM_ACTIVE_SW=None), ['O_RC1'], 'O_RC1'),
    ('DMF0072 81 SW=Y', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_MDM_ACTIVE_SW='Y'), ['O_RC1'], 'O_RC1'),
    ('DMF0072 81_UC SW=NULL', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_DIVISION_ID='81_UC', P_MDM_ACTIVE_SW=None), ['O_RC1'], 'O_RC1'),
    ('DMF0072 81_UC SW=Y', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_DIVISION_ID='81_UC', P_MDM_ACTIVE_SW='Y'), ['O_RC1'], 'O_RC1'),
    ('DMF0072 82 SW=NULL', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_DIVISION_ID='82', P_MDM_ACTIVE_SW=None), ['O_RC1'], 'O_RC1'),
    ('DMF0072 82 SW=Y', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_DIVISION_ID='82', P_MDM_ACTIVE_SW='Y'), ['O_RC1'], 'O_RC1'),
    ('DMF0072 40 SW=NULL', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_DIVISION_ID='40', P_MDM_ACTIVE_SW=None), ['O_RC1'], 'O_RC1'),
    ('DMF0072 40 SW=Y', 'DMF0072_GET_ITEM_POPUP_LIST', dict(A72, P_DIVISION_ID='40', P_MDM_ACTIVE_SW='Y'), ['O_RC1'], 'O_RC1'),
]


def run(tag):
    con = dbconn.connect('tobe'); con.call_timeout = 280000
    cur = con.cursor(); res = {}
    for label, proc, args, outs, main in TESTS:
        kw = dict(args); ov = {}
        for o in outs:
            ov[o] = cur.var(oracledb.DB_TYPE_CURSOR); kw[o] = ov[o]
        t0 = time.time()
        try:
            cur.callproc(proc, keyword_parameters=kw)
            rc = ov[main].getvalue()
            cols = [d[0] for d in rc.description]
            rows = [tuple(v.read() if hasattr(v, 'read') else v for v in r) for r in rc.fetchall()]
            msg = None
            if 'O_RESULT_CURSOR' in ov and main != 'O_RESULT_CURSOR':
                try: msg = ov['O_RESULT_CURSOR'].getvalue().fetchall()[:2]
                except Exception as e: msg = 'result cursor: ' + str(e)[:80]
            res[label] = dict(cols=cols, rows=rows, sec=round(time.time() - t0, 1), err=None, msg=msg)
        except Exception as e:
            res[label] = dict(cols=[], rows=[], sec=round(time.time() - t0, 1), err=dbconn.mask(str(e))[:300], msg=None)
        con.rollback()
        r = res[label]
        print('  [%s] %-24s %6d행 %5.1fs %s %s' % (tag, label, len(r['rows']), r['sec'], r['err'] or '', (str(r['msg'])[:120] if r['msg'] else '')), flush=True)
    pickle.dump(res, open(os.path.join(HERE, 'logs', 'tests.%s.pkl' % tag), 'wb'))
    con.close()


def compare():
    b = pickle.load(open(os.path.join(HERE, 'logs', 'tests.before.pkl'), 'rb'))
    a = pickle.load(open(os.path.join(HERE, 'logs', 'tests.after.pkl'), 'rb'))
    for label in a:
        rb, ra = b[label], a[label]
        if rb['err'] or ra['err']:
            print('  %-24s ERROR 전=%s 후=%s' % (label, rb['err'], ra['err'])); continue
        cols = ra['cols']
        note = []
        if rb['cols'] != cols: note.append('컬럼 구성 다름')
        kw = [i for i, c in enumerate(cols) if c.upper() in ('KWH_MODULE', 'KWH_PACK')]
        oth = [i for i in range(len(cols)) if i not in kw]
        pb = sorted(repr(tuple(r[i] for i in oth)) for r in rb['rows']); pa = sorted(repr(tuple(r[i] for i in oth)) for r in ra['rows'])
        sb, sa = set(pb), set(pa)
        note.append('행 %d → %d' % (len(rb['rows']), len(ra['rows'])))
        note.append('KWH 외 컬럼 %s' % ('같음' if pb == pa else '다름(전에만 %d · 후에만 %d)' % (len(sb - sa), len(sa - sb))))
        for i in kw:
            note.append('%s 값 있는 행 %d → %d' % (cols[i], sum(1 for r in rb['rows'] if r[i] is not None), sum(1 for r in ra['rows'] if r[i] is not None)))
        print('  %-24s %s' % (label, ' · '.join(note)))


if __name__ == '__main__':
    print('[%s] %s' % (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), sys.argv[1]))
    compare() if sys.argv[1] == 'compare' else run(sys.argv[1])
