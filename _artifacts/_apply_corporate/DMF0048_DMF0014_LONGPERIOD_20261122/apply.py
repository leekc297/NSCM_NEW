"""[E20261122-LONGPERIOD] 사내 ZIOUI1 적용 — FRESH-GATE → BODY 컴파일 → 오류 시 원문 자동 복원 → 사후 확인
기준본 = make_patch.py 가 ALL_SOURCE 에서 새로 조회한 _base_*.txt
"""
import sys, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

D = os.path.dirname(os.path.abspath(__file__))
c = dbconn.connect('tobe'); k = c.cursor()


def src(name):
    k.execute("select text from all_source where owner='SCM_MGR' and name=:n and type='PACKAGE BODY' order by line", n=name)
    return ''.join(r[0] for r in k)


def meta(name):
    k.execute("select status, to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects "
              "where owner='SCM_MGR' and object_name=:n and object_type='PACKAGE BODY'", n=name)
    return k.fetchone()


def errs(name):
    k.execute("select line, position, text from all_errors where owner='SCM_MGR' and name=:n and type='PACKAGE BODY' order by sequence", n=name)
    return k.fetchall()


k.execute("select count(*) from all_objects where owner='SCM_MGR' and status='INVALID'"); inv0 = k.fetchone()[0]
for name in ('PKG_DMF0048', 'PKG_DMF0014'):
    base = open(os.path.join(D, f'_base_{name}_BODY.txt'), encoding='utf-8').read()
    fixed = open(os.path.join(D, f'_fixed_{name}_BODY.txt'), encoding='utf-8').read()
    print(name, 'before', meta(name))
    # FRESH-GATE: 적용 직전 DB 원문 == 착수 기준본
    assert src(name) == base, f'FRESH-GATE 실패({name}): 착수 후 DB 원문 변경 — 중단·재조회·재병합'
    k.execute('CREATE OR REPLACE ' + fixed.rstrip())
    e = errs(name)
    if e:
        print(name, 'COMPILE ERROR', e[:10])
        k.execute('CREATE OR REPLACE ' + base.rstrip())
        print(name, '원문 복원', meta(name), errs(name)[:3])
        sys.exit(2)
    now = src(name)
    print(name, 'after', meta(name), '| errors 0 | DB 원문 == 적용본', now.rstrip() == fixed.rstrip(),
          '| 마커', now.count('[E20261122-LONGPERIOD]'))
k.execute("select count(*) from all_objects where owner='SCM_MGR' and status='INVALID'"); inv1 = k.fetchone()[0]
print('SCM_MGR INVALID 전/후', inv0, inv1)
