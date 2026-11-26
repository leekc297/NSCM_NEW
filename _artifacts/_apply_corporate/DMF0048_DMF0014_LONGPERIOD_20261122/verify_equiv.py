"""[E20261122-LONGPERIOD] 검증 — 1) 보완 전 원문 임시 사본(ZZLP_*_OLD) ↔ 적용본 결과 대조(이전에 되던 기간)
                              2) 이전에 실패하던 기간 재실행  3) 임시 사본 삭제
기준본 = make_patch.py 가 ALL_SOURCE 에서 새로 조회한 _base_*.txt (spec 은 지금 ALL_SOURCE 조회)
"""
import sys, os, hashlib, datetime
import oracledb
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

D = os.path.dirname(os.path.abspath(__file__))
c = dbconn.connect('tobe'); k = c.cursor()
OUT = []


def log(*a):
    s = ' '.join(str(x) for x in a); print(s); OUT.append(s)


def spec(name):
    k.execute("select text from all_source where owner='SCM_MGR' and name=:n and type='PACKAGE' order by line", n=name)
    return ''.join(r[0] for r in k)


def make_copy(name, tmp):
    s = spec(name); b = open(os.path.join(D, f'_base_{name}_BODY.txt'), encoding='utf-8').read()
    hs = s.split('\n', 1); hb = b.split('\n', 1)
    assert hs[0].upper().startswith('PACKAGE') and hb[0].upper().startswith('PACKAGE BODY')

    def rename_end(t):  # 끝의 'END PKG_x;' 식별자만 사본 이름으로
        i = t.rstrip().upper().rfind('END ' + name)
        assert i > 0, 'END 식별자 없음'
        return t[:i] + 'END ' + tmp + t[i + 4 + len(name):]
    k.execute('CREATE OR REPLACE PACKAGE ' + tmp + ' IS\n' + rename_end(hs[1]).rstrip())
    k.execute('CREATE OR REPLACE PACKAGE BODY ' + tmp + ' IS\n' + rename_end(hb[1]).rstrip())
    k.execute("select status from all_objects where owner='SCM_MGR' and object_name=:n and object_type='PACKAGE BODY'", n=tmp)
    log('사본', tmp, k.fetchone())


def run(pkg, proc, args, ncur):
    curs = [k.var(oracledb.CURSOR) for _ in range(ncur)]
    t0 = datetime.datetime.now()
    try:
        k.callproc(f'{pkg}.{proc}', list(args) + curs)
        rc = curs[0].getvalue()
        cols = [d[0] for d in rc.description]
        rows = rc.fetchall()
        norm = sorted(repr(tuple(x.read() if hasattr(x, 'read') else x for x in r)) for r in rows)
        h = hashlib.md5(('|'.join(cols) + '#' + '\n'.join(norm)).encode()).hexdigest()[:12]
        return f'OK 칸 {len(cols)} 행 {len(rows)} 해시 {h} ({(datetime.datetime.now()-t0).seconds}s)'
    except Exception as e:
        return 'ERR ' + str(e).split('\n')[0][:230]


# 입력값 = SCM_COM_SQL_LOG 실제 화면 호출(2026-11-22 10:32:47 DMF0048 · 12:27:16 DMF0014, Division 40 · qjastar)
def a48(f, t, b, div='40', user='qjastar'):
    return [div, 'ALL', 'ALL', 'ALL', None, None, 'ALL', f, '20261122', t, user, 'ALL', 'ALL', None, 'N', user, b, None, user, 'DMF0048']


def a14(f, t, b, div='40', user='qjastar'):
    return [div, 'ALL', 'ALL', 'ALL', 'ALL', None, None, f, t, b, 'ALL', user, user, user, 'DMF0014']


k.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); log('시작', k.fetchone()[0], 'DB=ZIOUI1')
# FRESH-GATE: 검증 대상 = 지금 DB 원문(ALL_SOURCE) == 적용본
for _n in ('PKG_DMF0048', 'PKG_DMF0014'):
    k.execute("select text from all_source where owner='SCM_MGR' and name=:n and type='PACKAGE BODY' order by line", n=_n)
    assert ''.join(r[0] for r in k).rstrip() == open(os.path.join(D, f'_fixed_{_n}_BODY.txt'), encoding='utf-8').read().rstrip(), f'FRESH-GATE 실패({_n})'
make_copy('PKG_DMF0048', 'ZZLP_DMF0048_OLD')
make_copy('PKG_DMF0014', 'ZZLP_DMF0014_OLD')
try:
    log('== 1) 보완 전 ↔ 보완 후 대조 (이전에 되던 기간) ==')
    P48 = 'P_DMF0048_GET_DM_PLN_SALES_MONITORING'; P14 = 'P_DMF0014_GET_CUST_FCST_UPLOAD_DATA'
    for f, t, b in (('20261101', '20270430', 'DAILY'), ('20261101', '20271103', 'WEEKLY'), ('20261101', '20271103', 'MONTHLY'), ('20251101', '20281031', 'WEEKLY')):
        o = run('ZZLP_DMF0048_OLD', P48, a48(f, t, b), 3); n = run('PKG_DMF0048', P48, a48(f, t, b), 3)
        log('DMF0048', f, t, b, '| 전', o, '| 후', n, '| 같음' if o.split('(')[0] == n.split('(')[0] else '| 다름')
    for f, t, b in (('20261116', '20271115', 'DAILY'), ('20261116', '20281115', 'WEEKLY'), ('20261116', '20281115', 'MONTHLY')):
        o = run('ZZLP_DMF0014_OLD', P14, a14(f, t, b), 2); n = run('PKG_DMF0014', P14, a14(f, t, b), 2)
        log('DMF0014', f, t, b, '| 전', o, '| 후', n, '| 같음' if o.split('(')[0] == n.split('(')[0] else '| 다름')
    # DMF0014 데이터가 있는 Division 81(DM_PLN_CUSTOMER_PSI CUST_FCST 2025-01-06~2027-08-30) · ohsun
    for f, t, b in (('20250106', '20260105', 'DAILY'), ('20250106', '20270105', 'WEEKLY'), ('20250106', '20270105', 'MONTHLY')):
        o = run('ZZLP_DMF0014_OLD', P14, a14(f, t, b, '81', 'ohsun'), 2); n = run('PKG_DMF0014', P14, a14(f, t, b, '81', 'ohsun'), 2)
        log('DMF0014 Div81', f, t, b, '| 전', o, '| 후', n, '| 같음' if o.split('(')[0] == n.split('(')[0] else '| 다름')
    log('== 2) 이전 실패 기간 재실행 (보완 후) ==')
    for f, t, b in (('20261101', '20271103', 'DAILY'), ('20261101', '20281101', 'DAILY'), ('20261101', '20291101', 'DAILY'), ('20261101', '20291101', 'WEEKLY'), ('20261101', '20291101', 'MONTHLY')):
        log('DMF0048', f, t, b, '|', run('PKG_DMF0048', P48, a48(f, t, b), 3))
    for f, t, b in (('20261116', '20281116', 'DAILY'), ('20261116', '20281116', 'WEEKLY')):
        log('DMF0014', f, t, b, '|', run('PKG_DMF0014', P14, a14(f, t, b), 2))
    for f, t, b in (('20250106', '20270105', 'DAILY'), ('20250701', '20270701', 'DAILY')):
        log('DMF0014 Div81', f, t, b, '| 전', run('ZZLP_DMF0014_OLD', P14, a14(f, t, b, '81', 'ohsun'), 2), '| 후', run('PKG_DMF0014', P14, a14(f, t, b, '81', 'ohsun'), 2))
finally:
    for tmp in ('ZZLP_DMF0048_OLD', 'ZZLP_DMF0014_OLD'):
        k.execute('DROP PACKAGE ' + tmp)
    k.execute("select count(*) from all_objects where owner='SCM_MGR' and object_name like 'ZZLP\\_%' escape '\\'"); log('임시 사본 삭제 후 잔여', k.fetchone()[0])
    k.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); log('끝', k.fetchone()[0])
    open(os.path.join(D, 'VERIFY_RESULT.txt'), 'w', encoding='utf-8').write('\n'.join(OUT) + '\n')
