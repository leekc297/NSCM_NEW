"""SCP0100 — 사내 ZIOUI1 PKG_SCP0100 최신 원문 + 메타 배선 + SCM_MST_PLAN 구조 (읽기 전용, #152 fresh source)"""
import sys, os, datetime
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import dbconn

D = os.path.dirname(__file__)
t = dbconn.connect('tobe')
cur = t.cursor()
log = []

cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0100'")
for r in cur.fetchall():
    log.append('OBJ %s %s LAST_DDL=%s' % r)
log.append('FETCHED=' + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
for typ, fn in (('PACKAGE', 'pkg_spec.sql'), ('PACKAGE BODY', 'pkg_body.sql')):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0100' AND TYPE=:t ORDER BY LINE", t=typ)
    txt = ''.join(r[0] for r in cur.fetchall())
    open(os.path.join(D, 'scp0100_' + fn), 'w', encoding='utf-8').write(txt)
    log.append('%s lines=%d' % (typ, txt.count('\n')))

def dump(title, sql, **kw):
    log.append('=== ' + title + ' ===')
    try:
        cur.execute(sql, **kw)
        cols = [d[0] for d in cur.description]
        log.append(' | '.join(cols))
        for r in cur.fetchall():
            log.append(' | '.join('' if v is None else str(v) for v in r))
    except Exception as e:
        log.append('ERROR ' + dbconn.mask(str(e)))

dump('SCM_MST_PLAN cols', "SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_PLAN' ORDER BY COLUMN_ID")
dump('API_M SCP0100', "SELECT * FROM SCM_ADM_API_M WHERE UPPER(API_URL) LIKE '%SCP0100%' OR UPPER(API_ID) LIKE '%SCP0100%'")
dump('MNU_BTN_MPG SCP0100', "SELECT * FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0100'")
dump('PROC_M SCP0100', "SELECT * FROM SCM_ADM_PROC_M WHERE UPPER(PROC_NM) LIKE '%SCP0100%' ORDER BY PROC_NM, SORT_ORD")
dump('ARGS PLAN_DATE', "SELECT OBJECT_NAME, ARGUMENT_NAME, POSITION, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_SCP0100' ORDER BY OBJECT_NAME, POSITION")
dump('PLAN sample 81 WEEKLY', "SELECT * FROM (SELECT DIVISION_ID, PLAN_NAME, PLAN_CYCLE, HORIZON_START_DATE, HORIZON_END_DATE FROM SCM_MST_PLAN WHERE DIVISION_ID='81' AND PLAN_CYCLE='WEEKLY' ORDER BY PLAN_NAME DESC) WHERE ROWNUM<=8")
dump('PLAN dup check', "SELECT DIVISION_ID, PLAN_NAME, PLAN_CYCLE, COUNT(*) CNT FROM SCM_MST_PLAN GROUP BY DIVISION_ID, PLAN_NAME, PLAN_CYCLE HAVING COUNT(*)>1 AND ROWNUM<=5")
dump('PK SCM_MST_PLAN', "SELECT c.CONSTRAINT_NAME, c.CONSTRAINT_TYPE, cc.COLUMN_NAME, cc.POSITION FROM ALL_CONSTRAINTS c JOIN ALL_CONS_COLUMNS cc ON cc.OWNER=c.OWNER AND cc.CONSTRAINT_NAME=c.CONSTRAINT_NAME WHERE c.OWNER='SCM_MGR' AND c.TABLE_NAME='SCM_MST_PLAN' AND c.CONSTRAINT_TYPE IN ('P','U') ORDER BY 1,4")

open(os.path.join(D, 'scp0100_pkg_fetch.out.txt'), 'w', encoding='utf-8').write('\n'.join(log))
print('ok')
