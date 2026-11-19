"""[E20261119-DMF0082ROWGOAL] 사내 ZIOUI1 적용 — FRESH-GATE → BODY 컴파일 → 사후 확인"""
import sys, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
D = os.path.dirname(os.path.abspath(__file__))
BASE = open(os.path.join(D, '_base_body.txt'), encoding='utf-8').read()
FIXED = open(os.path.join(D, '_fixed_body.txt'), encoding='utf-8').read()
c = dbconn.connect('tobe'); k = c.cursor()
def src():
    k.execute("select text from all_source where owner='SCM_MGR' and name='PKG_DMF0082' and type='PACKAGE BODY' order by line")
    return ''.join(r[0] for r in k)
def meta():
    k.execute("select status, to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name='PKG_DMF0082' and object_type='PACKAGE BODY'")
    return k.fetchone()
print('before', meta())
# FRESH-GATE: 적용 직전 DB 원문 == 착수 기준본
assert src() == BASE, 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
k.execute("select count(*) from all_objects where owner='SCM_MGR' and status='INVALID'"); inv0 = k.fetchone()[0]
k.execute('CREATE OR REPLACE ' + FIXED.rstrip())
print('after', meta())
k.execute("select line, position, text from all_errors where owner='SCM_MGR' and name='PKG_DMF0082' and type='PACKAGE BODY'")
errs = k.fetchall(); print('errors', errs[:5])
now = src()
print('DB 원문 == 적용본', now.rstrip() == FIXED.rstrip(), '| 마커 수', now.count('[E20261119-DMF0082ROWGOAL]'))
k.execute("select count(*) from all_objects where owner='SCM_MGR' and status='INVALID'"); inv1 = k.fetchone()[0]
print('SCM_MGR INVALID 전/후', inv0, inv1)
