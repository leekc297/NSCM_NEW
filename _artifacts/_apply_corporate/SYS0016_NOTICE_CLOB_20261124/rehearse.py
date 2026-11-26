"""사내 리허설: 적용본 스냅샷 -> 99 -> 99(SKIP) -> 원복본 = 수정 전 원문 대조 -> 10 -> 10(SKIP) -> 90 -> 재적용본 = 적용본 대조"""
import os
import subprocess
import sys
import time

sys.stdout.reconfigure(encoding='utf-8')
D = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(D, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect  # noqa: E402

FAIL = 0


def chk(ok, msg):
    global FAIL
    print(('PASS ' if ok else 'FAIL ') + msg, flush=True)
    if not ok:
        FAIL += 1


def ddl():
    out = {}
    with connect('tobe') as cx:
        cx.call_timeout = 60000
        cur = cx.cursor()
        for typ, name in [('PROCEDURE', 'PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST'), ('TABLE', 'SCM_ADM_NOTICE_CONTENT_MASTER'),
                          ('TABLE', 'SCM_ADM_NOTICE_CONTENT_MASTER_H')]:
            cur.execute("select dbms_metadata.get_ddl(:t, :n, 'SCM_MGR') from dual", t=typ, n=name)
            out[name] = cur.fetchone()[0].read()
        cur.execute("select count(*), sum(dbms_lob.getlength(notice_content)) from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER")
        out['M_STAT'] = cur.fetchone()
        cur.execute("select count(*), sum(dbms_lob.getlength(notice_content)) from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_H")
        out['H_STAT'] = cur.fetchone()
    return out


def run(fn, expect_skip=None):
    t = time.time()
    p = subprocess.run([sys.executable, '-u', os.path.join(D, 'run_sql.py'), os.path.join(D, fn)],
                       capture_output=True, text=True, encoding='utf-8', timeout=300)
    print(p.stdout, end='')
    chk(p.returncode == 0, f'{fn} exit 0 ({time.time() - t:.1f}s)')
    if expect_skip is not None:
        n_skip = p.stdout.count('SKIP ') - p.stdout.count('BACKUP SKIP')
        chk(n_skip == expect_skip, f'{fn} SKIP count {n_skip} = {expect_skip}')


def norm(s):
    return '\n'.join(x.rstrip() for x in s.strip().splitlines())


orig_proc = norm(open(os.path.join(D, 'PR_HIST.ASIS.sql'), encoding='utf-8').read())
orig_m = norm(open(os.path.join(D, 'TBL_M.ASIS.sql'), encoding='utf-8').read())

applied = ddl()
print('applied stat', applied['M_STAT'], applied['H_STAT'])
run('99_ROLLBACK_NOTICE_CONTENT_CLOB.sql')
run('99_ROLLBACK_NOTICE_CONTENT_CLOB.sql', expect_skip=3)
rb = ddl()
chk(norm(rb['PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST']) == orig_proc, 'rollback proc DDL = original')
chk('"NOTICE_CONTENT" VARCHAR2(4000 CHAR)' in rb['SCM_ADM_NOTICE_CONTENT_MASTER'], 'rollback table M column VARCHAR2(4000 CHAR)')
chk('"NOTICE_CONTENT" VARCHAR2(4000 CHAR)' in rb['SCM_ADM_NOTICE_CONTENT_MASTER_H'], 'rollback table H column VARCHAR2(4000 CHAR)')
chk(rb['M_STAT'] == applied['M_STAT'] and rb['H_STAT'] == applied['H_STAT'], f'rollback row/len stat same {rb["M_STAT"]} {rb["H_STAT"]}')
print('INFO original table M column position preserved:', norm(rb['SCM_ADM_NOTICE_CONTENT_MASTER']) == orig_m)
run('10_APPLY_NOTICE_CONTENT_CLOB.sql')
run('10_APPLY_NOTICE_CONTENT_CLOB.sql', expect_skip=3)
run('90_VERIFY_NOTICE_CONTENT_CLOB.sql')
re = ddl()
chk(norm(re['PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST']) == norm(applied['PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST']), 'reapply proc DDL = applied')
chk(norm(re['SCM_ADM_NOTICE_CONTENT_MASTER']) == norm(applied['SCM_ADM_NOTICE_CONTENT_MASTER']), 'reapply table M DDL = applied')
chk(norm(re['SCM_ADM_NOTICE_CONTENT_MASTER_H']) == norm(applied['SCM_ADM_NOTICE_CONTENT_MASTER_H']), 'reapply table H DDL = applied')
chk(re['M_STAT'] == applied['M_STAT'] and re['H_STAT'] == applied['H_STAT'], f'reapply row/len stat same {re["M_STAT"]} {re["H_STAT"]}')
open(os.path.join(D, 'PR_HIST.APPLIED.sql'), 'w', encoding='utf-8', newline='\n').write(re['PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST'])
open(os.path.join(D, 'TBL_M.APPLIED.sql'), 'w', encoding='utf-8', newline='\n').write(re['SCM_ADM_NOTICE_CONTENT_MASTER'])
print('REHEARSE', 'OK' if FAIL == 0 else f'FAIL {FAIL}', time.strftime('%Y-%m-%d %H:%M:%S'))
sys.exit(1 if FAIL else 0)
