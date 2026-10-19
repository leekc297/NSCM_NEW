# GAP 261 — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF 컷오프→원장 INSERT 의 INCOTERMS 빈값 보정
#   DM_PLN_BP_FCST_C.INCOTERMS = NULL 허용 / DM_PLN_BP_FCST.INCOTERMS = NOT NULL(PK)
#   → 원장에 DEFAULT ON NULL 이 없는 환경(클라우드 — 10-08 SLASHDEF 미적용)에서 NULL 행이 있으면 ORA-01400 → Replace 전체 실패
#   SELECT 목록 INCOTERMS → NVL(NULLIF(RTRIM(INCOTERMS),''), '/')  (이관·적재 빈값 규칙 '/' 와 동일)
# 사용: python apply.py plan|apply      FRESH-GATE: 적용 직전 ALL_SOURCE + LAST_DDL_TIME 재조회 — 기준본과 다르면 중단
import sys, pathlib, hashlib, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora

HERE = pathlib.Path(__file__).parent
OBJ = 'PKG_DMF0042'
TAG = '[E20261015-GAP261]'
P_FROM = '  PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF'
A_START = '          SELECT\n            DIVISION_ID,\n            PROJECT_CODE,'
A_END = '          FROM DM_PLN_BP_FCST_C\n          WHERE VERSION_NO = p_version_no'
OLD = '            INCOTERMS,\n'
NEW = ("            NVL(NULLIF(RTRIM(INCOTERMS), ''), '/'), /* 2026.10.15 GAP261 " + TAG +
       " 컷오프 INCOTERMS 는 NULL 허용, 원장은 NOT NULL(PK) — 빈값은 '/' (원본 : INCOTERMS,) */\n")


def fetch_src(cur):
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
    host = cur.fetchone()[0]
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
    ldt, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
    return host, ldt, st, ''.join(r[0] for r in cur.fetchall())


def transform(src):
    assert TAG not in src, 'already applied'
    assert src.count(P_FROM) == 1 and src.count(A_START) == 1 and src.count(A_END) == 1
    p0 = src.index(P_FROM); s = src.index(A_START, p0); e = src.index(A_END, s)
    assert src[s:e].count(OLD) == 1, 'INCOTERMS token count'
    pos = src.index(OLD, s)
    return src[:pos] + NEW + src[pos + len(OLD):]


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cur = cn.cursor()
    host, ldt, st, src = fetch_src(cur)
    print('HOST', host, 'LAST_DDL', ldt, st, 'lines', len(src.splitlines()))
    new = transform(src)
    (HERE / f'00_BACKUP_{OBJ}_BODY_{ldt[:10]}_{ldt[11:13]}{ldt[14:16]}.sql').write_text(
        f'-- BACKUP {OBJ} BODY LAST_DDL={ldt} HOST={host}\nCREATE OR REPLACE ' + src.rstrip() + '\n/\n', encoding='utf-8')
    (HERE / f'_new_{OBJ}_BODY.txt').write_text(new, encoding='utf-8')
    print('diff lines', len(new.splitlines()) - len(src.splitlines()), 'sha', hashlib.sha1(src.encode()).hexdigest()[:10])
    if mode != 'apply':
        return
    # FRESH-GATE: 적용 직전 재조회 — 기준본과 다르면 중단
    h2, ldt2, _, src2 = fetch_src(cur)
    assert (h2, ldt2, src2) == (host, ldt, src), f'FRESH-GATE FAIL: {ldt} -> {ldt2}'
    cur.execute('CREATE OR REPLACE ' + new)
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", n=OBJ)
    errs = cur.fetchall()
    _, ldt3, st3, _ = fetch_src(cur)
    print('APPLIED', ldt3, st3, 'errors', errs[:10])


if __name__ == '__main__':
    main()
