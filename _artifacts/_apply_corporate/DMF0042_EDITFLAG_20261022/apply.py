# DMF0042 편집 불가(노란 셀 0) — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 조회 컬럼 목록에서 EDIT_FLAG 누락
#   SHEET_COLUMNS 'Biz Plan' EDIT_FLAG = VISIBLE_FLAG 'N' · DEFAULT_FLAG 'N' (10-19 F-19 빈 값 일괄 'N' 변환)
#   개인 컬럼 설정 없음 분기(L2709) 는 10-19 KBJ 가 NVL(...,'N')='N' 으로 대응했으나
#   개인 컬럼 설정 있음 분기(L2740) 는 RTRIM(...) IS NULL 그대로 → 'N' 숨은 고정 칸 제외 → EDIT_FLAG 미반환 → FE R1 전행 잠금
#   L2740 을 L2709 와 같은 판정으로 (원본 줄은 주석 보존)
# 사용: python apply.py plan|apply      FRESH-GATE: 적용 직전 ALL_SOURCE + LAST_DDL_TIME 재조회 — 기준본과 다르면 중단
import sys, pathlib, hashlib, oracledb
sys.path.insert(0, '_artifacts/_diagnostics'); import ora

HERE = pathlib.Path(__file__).parent
OBJ = 'PKG_DMF0042'
TAG = '[E20261022-EDITFLAG]'
P_FROM = '  PROCEDURE P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA'
A_START = '                        SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE\n'
A_END = '                        ) WHERE ROWNUM <= 100\n'
OLD = ("                                AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL   --[E20260806-00979] 빈값 판정: "
       "공백(' ')과 '-' 동일 취급 (데이터 무수정 방침 — 클라우드 '-' 변형 흡수)\n")
NEW = ("                                --AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL   --[E20260806-00979] 빈값 판정: "
       "공백(' ')과 '-' 동일 취급 (데이터 무수정 방침 — 클라우드 '-' 변형 흡수)\n"
       "                                AND NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N'   -- 2026.10.22 " + TAG +
       " 개인 컬럼 설정 분기도 F-19 'N' 대응(위 기본 분기와 동일) — 누락 시 EDIT_FLAG 등 숨은 고정 칸 미반환\n")


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
    assert src.count(P_FROM) == 1, 'proc anchor'
    p0 = src.index(P_FROM)
    s = src.index(A_START, p0); e = src.index(A_END, s)
    assert src[s:e].count(OLD) == 1, 'OLD token count in titleset branch'
    assert src.count(OLD) == 1, 'OLD token count in body'
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
    bak = HERE / f'00_BACKUP_{OBJ}_BODY_{ldt[:10]}_{ldt[11:13]}{ldt[14:16]}.sql'
    if not bak.exists():
        bak.write_text(f'-- BACKUP {OBJ} BODY LAST_DDL={ldt} HOST={host}\nCREATE OR REPLACE ' + src.rstrip() + '\n/\n',
                       encoding='utf-8')
    (HERE / f'_new_{OBJ}_BODY.txt').write_text(new, encoding='utf-8')
    print('diff lines', len(new.splitlines()) - len(src.splitlines()), 'sha', hashlib.sha1(src.encode()).hexdigest()[:10])
    if mode != 'apply':
        return
    # FRESH-GATE: 적용 직전 재조회 — 기준본과 다르면 중단
    h2, ldt2, _, src2 = fetch_src(cur)
    assert (h2, ldt2, src2) == (host, ldt, src), f'FRESH-GATE FAIL: {ldt} -> {ldt2}'
    try:
        cur.execute('CREATE OR REPLACE ' + new)
    except oracledb.DatabaseError as ex:
        print('CREATE warn', ex)
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", n=OBJ)
    errs = cur.fetchall()
    _, ldt3, st3, src3 = fetch_src(cur)
    if st3 != 'VALID' or errs:
        # 컴파일 실패 — 착수 기준본으로 즉시 복원
        cur.execute('CREATE OR REPLACE ' + src)
        print('RESTORED — compile failed', errs[:10])
        return
    print('APPLIED', ldt3, st3, 'errors', errs, 'db==new', src3 == new)


if __name__ == '__main__':
    main()
