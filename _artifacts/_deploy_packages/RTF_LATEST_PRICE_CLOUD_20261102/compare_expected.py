# -*- coding: utf-8 -*-
"""DB 원문 vs 기대값(_expected_*: ASIS + 블록) / ASIS 대조. 사용: python compare_expected.py expected|asis"""
import sys, os, re
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
sys.stdout.reconfigure(encoding='utf-8')
import dbconn
HERE = os.path.dirname(os.path.abspath(__file__))
SRC = r'C:\Projects\NSCM\_artifacts\_apply_corporate\RTF_LATEST_PRICE_20261102'
OBJS = [('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PROCEDURE'), ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE', 'PROCEDURE'), ('PKG_DMF0020', 'PACKAGE BODY'), ('PKG_DMF0003', 'PACKAGE BODY')]
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
c.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); print('at', c.fetchone()[0])


def norm(t):
    h, _, r = t.partition('\n')
    return re.sub(r'[\s"]+', ' ', h).strip() + '\n' + r.rstrip()


for n, t in OBJS:
    c.execute("select text from all_source where owner='SCM_MGR' and name=:n and type=:t order by line", n=n, t=t)
    db = ''.join(r[0] for r in c.fetchall())
    p = os.path.join(HERE, f'_expected_{n}.txt') if sys.argv[1] == 'expected' else os.path.join(SRC, f'{n}.ASIS.txt')
    want = open(p, encoding='utf-8', newline='').read()
    c.execute("select status, to_char(last_ddl_time,'HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name=:n and object_type=:t", n=n, t=t)
    print(n, c.fetchone(), sys.argv[1], 'same', norm(db) == norm(want), 'exact', db.rstrip() == want.rstrip())
