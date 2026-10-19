# GAP 257 — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST "키 업데이트용 데이터 처리" 블록 정정
#   ① 빈값 검사  A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL  (NOT NULL+DEFAULT ON NULL '/' 컬럼이라 항상 거짓)
#      → A.FCST_TYPE IN ('-','/') OR A.INCOTERMS IN ('-','/')   (과도기: 이관 빈값 '-' · 신규 빈값 '/' 공존 — 사용자 2026-10-15)
#   ② 40 조건 누락  → IF V_CNT_1 > 0 AND V_DIVISION_ID = '40'   (AS-IS DMF0042_SAVE_DM_PLN_BP_FCST: ... ) AND @v_DIVISION_ID = '40')
#   ③ 11키 조인의 센티널 키(DEPT_ID·END_CUSTOMER·BIZ_TYPE·ITEM_USE) '-'/'/' 동치
#      (40 원장 = '-' 1,186,444행 전부 · GT 정규화 L4341~4350 = '/' → raw 비교 시 영구 미매칭)
# 사용: python apply.py plan|apply
# FRESH-GATE: 적용 직전 ALL_SOURCE + LAST_DDL_TIME 재조회 — 기준본과 다르면 중단
import sys, re, pathlib, hashlib, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora

HERE = pathlib.Path(__file__).parent
OBJ = 'PKG_DMF0042'
TAG = '[E20261015-GAP257]'

def conn():
    u, p, d = ora.conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)

def fetch_src(cur):
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
    host = cur.fetchone()[0]
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
    ldt, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
    src = ''.join(r[0] for r in cur.fetchall())
    return host, ldt, st, src

def one(pat, repl, text, expect, flags=0):
    new, n = re.subn(pat, repl, text, flags=flags)
    assert n == expect, f'pattern {pat!r}: {n} matches (expected {expect})'
    return new

def transform(src):
    head = '-- 2021.7.23 키 업데이트용으로 들어온 데이터 처리 (START)'
    assert src.count(head) == 1, 'region head not unique'
    s = src.index(head)
    e = src.index('GOTO END_PKUPDATE;', s)
    reg = src[s:e]
    assert TAG not in reg, 'already applied'

    # ② 40 조건 (AS-IS 1:1)
    reg = one(r'IF V_CNT_1 > 0 THEN',
              "/* 2026.10.15 GAP257 " + TAG + " AS-IS 의 40 조건 복원 */\n"
              "            /* 원본 : IF V_CNT_1 > 0 THEN (AS-IS = IF EXISTS(...) AND @v_DIVISION_ID = '40') */\n"
              "            IF V_CNT_1 > 0 AND V_DIVISION_ID = '40' THEN", reg, 1)

    # ① 빈값 검사 — 과도기 '-'(이관 빈값)·'/'(신규 빈값) 둘 다
    reg = one(r"WHERE  A\.FCST_TYPE IS NULL\n(\s+)OR     A\.INCOTERMS IS NULL;",
              "/* 2026.10.15 GAP257 " + TAG + " 빈값 = 이관 '-' · 신규 '/' 공존(과도기) */\n"
              "            /* 원본 : WHERE A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL (NOT NULL+DEFAULT ON NULL '/' 라 항상 거짓 → 블록 미동작) */\n"
              "            WHERE  A.FCST_TYPE IN ('-', '/')\n\\1OR     A.INCOTERMS IN ('-', '/');", reg, 1)

    # ③ GT 측 센티널 키 '/' 정규화 (count·MERGE USING 2곳) — 같은 키의 '-'/'/' 혼재로 MERGE 원천 중복(ORA-30926) 방지
    gt_norm = ("FROM   (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, UNIT_ENERGY, CELL_PROD_SITE, MEASURE, FCST_TYPE, INCOTERMS\n"
               "                                  , DECODE(DEPT_ID, '-', '/', DEPT_ID) DEPT_ID, DECODE(END_CUSTOMER, '-', '/', END_CUSTOMER) END_CUSTOMER\n"
               "                                  , DECODE(BIZ_TYPE, '-', '/', BIZ_TYPE) BIZ_TYPE, DECODE(ITEM_USE, '-', '/', ITEM_USE) ITEM_USE\n"
               "                            FROM   GT_SDPB2_BP_FCST_4) /* 2026.10.15 GAP257 " + TAG + " 원본 : FROM GT_SDPB2_BP_FCST_4 */\\1WHERE  MEASURE = 'Business_Plan'")
    reg = one(r"FROM   GT_SDPB2_BP_FCST_4(\s+)WHERE  MEASURE = 'Business_Plan'", gt_norm, reg, 2)

    # ③ 원장 측 센티널 키 '-' → '/' 동치 (count ON·MERGE ON 2곳씩)
    for c in ('DEPT_ID', 'END_CUSTOMER', 'BIZ_TYPE', 'ITEM_USE'):
        reg = one(rf'A\.{c} = B\.{c}\b', f"DECODE(A.{c}, '-', '/', A.{c}) = B.{c}", reg, 2)
    reg = one(r'(\n\s+)(MERGE INTO DM_PLN_BP_FCST A)',
              r"\1/* 2026.10.15 GAP257 " + TAG + r" ON 센티널 키 4종 '-'/'/' 동치 — 원본 : A.DEPT_ID = B.DEPT_ID ... (raw 비교) */\1\2", reg, 1)
    return src[:s] + reg + src[e:]

def main():
    mode = sys.argv[1]
    cn = conn(); cur = cn.cursor()
    host, ldt, st, src = fetch_src(cur)
    print('HOST', host, 'LAST_DDL', ldt, st, 'lines', len(src.splitlines()))
    new = transform(src)
    (HERE / f'00_BACKUP_{OBJ}_BODY_{ldt[:10]}.sql').write_text(f'-- BACKUP {OBJ} BODY LAST_DDL={ldt} HOST={host}\nCREATE OR REPLACE ' + src.rstrip() + '\n/\n', encoding='utf-8')
    (HERE / f'_new_{OBJ}_BODY.txt').write_text(new, encoding='utf-8')
    print('diff lines', len(new.splitlines()) - len(src.splitlines()), 'sha', hashlib.sha1(src.encode()).hexdigest()[:10])
    if mode != 'apply':
        return
    # FRESH-GATE: 적용 직전 재조회 — 기준본과 다르면 중단
    h2, ldt2, st2, src2 = fetch_src(cur)
    assert (h2, ldt2, src2) == (host, ldt, src), f'FRESH-GATE FAIL: {ldt} -> {ldt2}'
    cur.execute('CREATE OR REPLACE ' + new)
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", n=OBJ)
    errs = cur.fetchall()
    h3, ldt3, st3, _ = fetch_src(cur)
    print('APPLIED', ldt3, st3, 'errors', errs[:10])

if __name__ == '__main__':
    main()
