# -*- coding: utf-8 -*-
"""
PKG_SSP0046 2b (2026-11-26) : 2단계 프로시저 중 사이트 대표 부서 산출을 스칼라 서브쿼리(#150 정본 a)로 교체
- 원인 : GROUP BY 인라인 뷰(IM) 조인을 옵티마이저가 풀어 SSO_DEPT_INFO x SITE 카테시안(64M) -> 26억 행 계획
- 기준본 = 사내 ZIOUI1 SCM_MGR.PKG_SSP0046 BODY (ALL_SOURCE 실행 시점 재조회, hook #152)
- phase2_body.sql 의 프로시저 블록으로 DB 원문 같은 이름 블록을 교체 (블록 매칭 1건 assert, 그 외 무변경 assert)
- 단계 : (기본) PKG_SSP0046_CHK 컴파일 후 남겨 둠 -> 시험은 smoke_phase2.py CHK
         --apply : FRESH-GATE 통과 후 PKG_SSP0046 BODY 교체, CHK DROP
"""
import oracledb, sys, os, datetime, re

NAME, CHK = 'PKG_SSP0046', 'PKG_SSP0046_CHK'
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'out')
CRLF, LF = chr(13) + chr(10), chr(10)
env = dict(l.strip().split('=', 1) for l in open(r'c:\Projects\NSCM\.env.asis', encoding='utf-8')
           if '=' in l and not l.startswith('#'))
con = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                       dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")


def fetch(name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
    return meta, ''.join(r[0] for r in cur.fetchall())


def errors(name):
    cur.execute("SELECT TYPE, LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE", n=name)
    return cur.fetchall()


def blocks(src):
    """프로시저 블록(앞 주석 머리 포함) 위치 : 이름 -> (시작, 끝)"""
    res = {}
    for m in re.finditer(r'(?m)^PROCEDURE\s+(P_SSP0046_\w+)', src):
        nm = m.group(1)
        e = re.search(r'(?m)^END\s+' + nm + r'\s*;\n', src[m.start():])
        st = m.start()
        head = src[:st]
        hm = re.search(r'(/\*\*+/\n(?:/\*.*\*/\n)*)$', head)  # 바로 앞 주석 머리
        if hm:
            st = hm.start()
        res[nm] = (st, m.start() + e.end())
    return res


FETCHED = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
sm, spec = fetch(NAME, 'PACKAGE')
bm, body = fetch(NAME, 'PACKAGE BODY')
assert bm[1] == 'VALID', bm
b0 = body.replace(CRLF, LF)
s0 = spec.replace(CRLF, LF)
pb = open(os.path.join(HERE, 'phase2_body.sql'), encoding='utf-8').read()
newb = blocks(pb)
cur_b = blocks(b0)
targets = ['P_SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP', 'P_SSP0046_GET_ITEM_BY_DIVISION_POPUPEX',
           'P_SSP0046_GET_CUSTOMER_BY_DIVISION', 'P_SSP0046_GET_SITE_BY_DIVISION', 'P_SSP0046_GET_TEAM_BY_DIVISION']
b1 = b0
for nm in sorted(targets, key=lambda k: -cur_b[k][0]):  # 뒤에서부터 교체
    s, e = cur_b[nm]
    ns, ne = newb[nm]
    old = b1[s:e]
    assert b0.count(old) == 1, f'{nm} 블록 매칭 != 1'
    b1 = b1[:s] + pb[ns:ne] + b1[e:]
# 교체 대상 외 블록 무변경 확인
after = blocks(b1)
for nm, (s, e) in cur_b.items():
    if nm not in targets:
        a, z = after[nm]
        assert b1[a:z] == b0[s:e], f'{nm} 의도치 않은 변경'
HIST_OLD = "/* 2026.11.26  ZIONEX       [SSP0046] AS-IS 팝업·콤보 SP 9종 추가 (BOD·품목·프로젝트·머리글 등)     */\n"
HIST_NEW = HIST_OLD + \
    "/* 2026.11.26  ZIONEX       [SSP0046] 사이트 대표 부서 산출 = 스칼라 서브쿼리 (카테시안 계획 제거)   */\n"
assert b1.count(HIST_OLD) == 1 and s0.count(HIST_OLD) == 1
b1 = b1.replace(HIST_OLD, HIST_NEW)
open(os.path.join(OUT, '06_PKG_SSP0046_BODY_PHASE2B.sql'), 'w', encoding='utf-8', newline='').write(
    f"-- SOURCE-FRESH: SCM_MGR.{NAME} PACKAGE BODY LAST_DDL={bm[0]} FETCHED={FETCHED} DB=ZIOUI1\n\n"
    "CREATE OR REPLACE " + b1.rstrip() + "\n/\n")
print('FETCHED', FETCHED, 'BASE', sm, bm, 'replaced', len(targets))

if '--apply' not in sys.argv:
    cs = re.sub(r'^PACKAGE\s+PKG_SSP0046', 'PACKAGE ' + CHK, s0, count=1).replace('END PKG_SSP0046;', f'END {CHK};')
    cb = re.sub(r'^PACKAGE BODY\s+PKG_SSP0046', 'PACKAGE BODY ' + CHK, b1, count=1).replace('END PKG_SSP0046;', f'END {CHK};')
    for ddl in (cs, cb):
        try:
            cur.execute("CREATE OR REPLACE " + ddl.rstrip())
        except oracledb.DatabaseError as e:
            if 'ORA-24344' not in str(e):
                raise
    print('CHK COMPILE ERRORS', errors(CHK))
else:
    sm2, spec2 = fetch(NAME, 'PACKAGE')
    bm2, body2 = fetch(NAME, 'PACKAGE BODY')
    assert body2 == body and bm2 == bm and spec2 == spec, 'FRESH-GATE 실패: 착수 후 원문 변경 - 중단'
    cur.execute("CREATE OR REPLACE " + b1.rstrip())
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n", n=NAME)
    print('APPLIED', cur.fetchall(), 'ERRORS', errors(NAME))
    try:
        cur.execute(f"DROP PACKAGE {CHK}")
        print('CHK DROPPED')
    except oracledb.DatabaseError as e:
        print('CHK DROP', str(e)[:80])
