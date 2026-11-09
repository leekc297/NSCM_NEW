# PKG_SCP0125 BODY 사내 적용 — FRESH-GATE(#152 §3.3) → CREATE OR REPLACE → VALID·ERRORS 0·LAST_DDL·적용본=DB 원문 확인
#   python -I apply.py            (적용)
#   python -I apply.py --rollback (ASIS 로 원복 — 같은 게이트: 현재 DB = TOBE 일 때만)
import os, sys, json
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
D = os.path.dirname(os.path.abspath(__file__))
nl = lambda t: t.replace('\r\n', '\n').replace('\r', '\n').rstrip()
ASIS = nl(open(os.path.join(D, 'PKG_SCP0125_BODY.ASIS.sql'), encoding='utf-8').read())
TOBE = nl(open(os.path.join(D, 'PKG_SCP0125_BODY.TOBE.sql'), encoding='utf-8').read())
rollback = '--rollback' in sys.argv
want_now, target = (TOBE, ASIS) if rollback else (ASIS, TOBE)
def fetch(c):
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0125' AND OBJECT_TYPE='PACKAGE BODY'")
    ddl, st = c.fetchone()
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0125' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return ddl, st, nl(''.join(r[0] for r in c.fetchall()))
with connect('tobe') as cx:
    c = cx.cursor()
    ddl0, st0, now = fetch(c)
    print('적용 전 LAST_DDL', ddl0, st0)
    if now != want_now:
        print('[FRESH-GATE 실패] 착수 후 DB 원문이 바뀌었다 — 중단·재조회·재병합'); sys.exit(3)
    print('[FRESH-GATE] DB 원문 = 기준본 일치')
    c.execute('ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR')
    c.execute('CREATE OR REPLACE ' + target)
    ddl1, st1, after = fetch(c)
    c.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0125' ORDER BY SEQUENCE")
    errs = c.fetchall()
    c.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME LIKE '%SCP0125%'")
    inval = c.fetchall()
    print('적용 후 LAST_DDL', ddl1, st1, '· ALL_ERRORS', len(errs), '· 적용본=DB 원문', after == target, '· INVALID(SCP0125)', inval)
    for e in errs[:10]: print('  ', e)
    json.dump({'mode': 'rollback' if rollback else 'apply', 'before_last_ddl': ddl0, 'after_last_ddl': ddl1, 'status': st1, 'errors': len(errs), 'same': after == target},
              open(os.path.join(D, 'apply_result.json' if not rollback else 'rollback_result.json'), 'w', encoding='utf-8'), ensure_ascii=False)
    sys.exit(0 if (st1 == 'VALID' and not errs and after == target) else 1)
