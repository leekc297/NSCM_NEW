# -*- coding: utf-8 -*-
"""
PKG_SSP0046 2단계 (2026-11-26) : AS-IS SSP0046 팝업·콤보 SP 9종 추가
- 기준본 = 사내 ZIOUI1 SCM_MGR.PKG_SSP0046 (ALL_SOURCE 실행 시점 재조회, hook #152)
- phase2_spec.sql / phase2_body.sql 을 'END PKG_SSP0046;' 앞에 덧붙임 (기존 3개 프로시저 무변경 assert)
- 사전 검사 : 같은 원문을 PKG_SSP0046_CHK 로 컴파일해 오류 0 확인 후 DROP
- --apply : FRESH-GATE(착수 기준본 == 적용 직전 원문) 통과 후 적용, PROC_M 등록(ALL_ARGUMENTS 순서)
"""
import oracledb, sys, os, datetime, re

NAME = 'PKG_SSP0046'
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


FETCHED = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
sm, spec = fetch(NAME, 'PACKAGE')
bm, body = fetch(NAME, 'PACKAGE BODY')
assert spec and body and sm[1] == 'VALID' and bm[1] == 'VALID', f'기준본 상태 이상 {sm} {bm}'
s0, b0 = spec.replace(CRLF, LF), body.replace(CRLF, LF)
assert 'P_SSP0046_GET_BUCKET_TYPE_CODE' not in s0 + b0, '이미 반영됨'

HIST_OLD = "/* 2026.11.26  ZIONEX       [SSP0046] PKG_DMF0045 기준 신규 + AS-IS SSP0046 차이 반영               */\n"
HIST_NEW = HIST_OLD + \
    "/* 2026.11.26  ZIONEX       [SSP0046] AS-IS 팝업·콤보 SP 9종 추가 (BOD·품목·프로젝트·머리글 등)     */\n"

ps = open(os.path.join(HERE, 'phase2_spec.sql'), encoding='utf-8').read()
pb = open(os.path.join(HERE, 'phase2_body.sql'), encoding='utf-8').read()


def append(src, add, label):
    assert src.count(HIST_OLD) == 1, f'[{label}] 이력 줄 매칭 실패'
    src = src.replace(HIST_OLD, HIST_NEW)
    m = list(re.finditer(r'\nEND\s+PKG_SSP0046\s*;\s*$', src))
    assert len(m) == 1, f'[{label}] END 매칭 실패'
    return src[:m[0].start()] + '\n' + add.rstrip() + '\n' + src[m[0].start():]


s1 = append(s0, ps, 'spec')
b1 = append(b0, pb, 'body')
# 기존 본문 무변경 확인 : 추가분과 이력 줄을 빼면 원문과 같아야 함
assert s1.replace(HIST_NEW, HIST_OLD).replace('\n' + ps.rstrip() + '\n', '', 1) == s0
assert b1.replace(HIST_NEW, HIST_OLD).replace('\n' + pb.rstrip() + '\n', '', 1) == b0

stamp = (f"-- SOURCE-FRESH: SCM_MGR.{NAME} PACKAGE LAST_DDL={sm[0]} / PACKAGE BODY LAST_DDL={bm[0]} FETCHED={FETCHED} DB=ZIOUI1\n"
         "-- 2단계 : AS-IS SSP0046 팝업·콤보 SP 9종 추가\n\n")
open(os.path.join(OUT, '05_PKG_SSP0046_PHASE2.sql'), 'w', encoding='utf-8', newline='').write(
    stamp + "CREATE OR REPLACE " + s1.rstrip() + "\n/\n\nCREATE OR REPLACE " + b1.rstrip() + "\n/\n")

# ---------------------------------------------------------------- 사전 컴파일 검사 (임시 이름)
CHK = 'PKG_SSP0046_CHK'
cs = re.sub(r'^PACKAGE\s+PKG_SSP0046', 'PACKAGE ' + CHK, s1, count=1).replace('END PKG_SSP0046;', f'END {CHK};')
cb = re.sub(r'^PACKAGE BODY\s+PKG_SSP0046', 'PACKAGE BODY ' + CHK, b1, count=1).replace('END PKG_SSP0046;', f'END {CHK};')
chk_err = None
try:
    for ddl in (cs, cb):
        try:
            cur.execute("CREATE OR REPLACE " + ddl.rstrip())
        except oracledb.DatabaseError as e:
            if 'ORA-24344' not in str(e):
                raise
    chk_err = errors(CHK)
finally:
    try:
        cur.execute(f"DROP PACKAGE {CHK}")
    except oracledb.DatabaseError:
        pass
print('FETCHED', FETCHED, 'BASE', sm, bm)
print('CHECK COMPILE ERRORS', len(chk_err))
for e in chk_err[:30]:
    print(' ', e)
if chk_err:
    sys.exit(1)

# ---------------------------------------------------------------- 적용
if '--apply' in sys.argv:
    sm2, spec2 = fetch(NAME, 'PACKAGE')
    bm2, body2 = fetch(NAME, 'PACKAGE BODY')
    assert spec2 == spec and body2 == body and sm2 == sm and bm2 == bm, 'FRESH-GATE 실패: 착수 후 원문 변경 - 중단'
    cur.execute("CREATE OR REPLACE " + s1.rstrip())
    cur.execute("CREATE OR REPLACE " + b1.rstrip())
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n", n=NAME)
    print('APPLIED', cur.fetchall(), 'ERRORS', errors(NAME))

    # PROC_M : ALL_ARGUMENTS 위치 순서 그대로 (proc-meta-signature-match)
    procs = re.findall(r'PROCEDURE\s+(P_SSP0046_\w+)', ps)

    def colnm(arg):
        if arg == 'P_CREATED_BY':
            return 'sesUserId'
        if arg.startswith('O_'):
            return arg.lower()
        w = arg[2:].lower().split('_')
        return w[0] + ''.join(x.capitalize() for x in w[1:])

    n_ins = 0
    for p in procs:
        cur.execute("SELECT ARGUMENT_NAME, POSITION, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' "
                    "AND PACKAGE_NAME=:k AND OBJECT_NAME=:p AND DATA_LEVEL=0 ORDER BY POSITION", k=NAME, p=p)
        for a, pos, io, dt in cur.fetchall():
            tp = 'PROC_RESULT' if a == 'O_RESULT_CURSOR' else ('CURSOR' if dt == 'REF CURSOR' else ('CLOB' if dt == 'CLOB' else 'VARCHAR'))
            ct = 'OUT' if io == 'OUT' else 'IN'
            cur.execute("INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) "
                        "SELECT :pn, :cn, :dt, :ct, :so, 'ZIONEX', SYSDATE, 'ZIONEX', SYSDATE FROM DUAL "
                        "WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_PROC_M WHERE PROC_NM = :pn AND COL_NM = :cn)",
                        pn=f'{NAME}.{p}', cn=colnm(a), dt=tp, ct=ct, so=pos)
            n_ins += cur.rowcount
    con.commit()
    print('PROC_M inserted', n_ins)
