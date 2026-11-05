"""[E20261102-DMF0082HINT] P_DMF0082_GET_MAIN_DATA 힌트 6건 (사내 ZIOUI1) — 사용자 지정 튜닝 내역 적용(2026-11-02)

  python build_apply.py build [--alias CAL|CALL]   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성(고유 매칭 assert)
  python build_apply.py apply                      # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
  python build_apply.py restore                    # 00_BACKUP 으로 원복(FRESH-GATE: 현재 원문 == 01_BODY 일 때만)

줄 번호 대응(사용자 표 → 현 원문):
  885 → 885 · 1267 → 1267 · 1984 → 1984 · 2078 → 2078(교체)
  4706 → 4710 (10-27 이전 백업의 4706 = 같은 문장) · 5234 → 5281 최종 동적 SQL `SELECT [@V_COLUMN]` (10-27 이전 백업의 5234 = 같은 줄)
별칭: 표의 CALL 은 원문에 없는 별칭 — 실제 CAL. --alias CALL 은 표 그대로 시험할 때만.
"""
import sys, os, json, hashlib
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn

HERE = os.path.dirname(os.path.abspath(__file__))
PKG, TYP, OWNER = "PKG_DMF0082", "PACKAGE BODY", "SCM_MGR"
MARK = "[E20261102-DMF0082HINT]"
F_BAK, F_NEW, STATE = [os.path.join(HERE, x) for x in ("00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql", "_fresh_state.json")]
BOUND = "PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO"  # GET_MAIN_DATA 범위 끝


def reps(alias):
    M = f"/*{MARK}*/"
    return [
        # 사업부 82 표: 885 — TEMP_SITE_ITEM_ALL 적재(분기 없음 = 전 사업부 공통 문장)
        ("    )\n    SELECT F.DIVISION_ID\n         , F.PROJECT_CODE\n         , F.SCM_SITE_ID\n         , F.ITEM_ID\n         , F.ATTRIBUTE5 ",
         f"    )\n    SELECT /*+ FULL(F) */ {M} F.DIVISION_ID\n         , F.PROJECT_CODE\n         , F.SCM_SITE_ID\n         , F.ITEM_ID\n         , F.ATTRIBUTE5 "),
        # 사업부 81 표: 1267 — T_LAST_DATA_SETUP_FCST (81·82 분기)
        ("THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)\n    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST\n        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)\n    SELECT A.DIVISION_ID,",
         f"THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)\n    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST\n        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)\n    SELECT /*+ FULL(A) USE_HASH(A) */ {M} A.DIVISION_ID,"),
        # 사업부 81 표: 1984 — SCM_MST_FUTURE_PRICE 판가 1회 읽기 (81·82 분기)
        ("        FROM (\n        SELECT A.DIVISION_ID AS C01\n             , A.PROJECT_CODE AS C02\n             , A.PROJECT_CODE AS C03  --[DIV81]",
         f"        FROM (\n        SELECT /*+ LEADING(B A C) USE_HASH(A C D) FULL(A) FULL(B) FULL(C) FULL(D) NO_SWAP_JOIN_INPUTS(A) PARALLEL(4) */ {M} A.DIVISION_ID AS C01\n             , A.PROJECT_CODE AS C02\n             , A.PROJECT_CODE AS C03  --[DIV81]"),
        # 사업부 40 표: 2078 — 힌트 교체 (구 힌트는 주석으로 보존)
        ("        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ -- ④ [E20260815-PERF] 계획 고정.\n",
         f"        SELECT /*+ LEADING(B A) USE_HASH(A C) FULL(A) SWAP_JOIN_INPUTS(B) NO_SWAP_JOIN_INPUTS(A) SWAP_JOIN_INPUTS(C) */ /*{MARK} 구 힌트: LEADING(A) USE_HASH(B) USE_HASH(C)*/ -- ④ [E20260815-PERF] 계획 고정.\n"),
        # 사업부 40 표: 4706 → 4710 — MF_SP 적재(분기 없음 = 전 사업부 공통 문장)
        ("    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID\n         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID\n         , F.CELL_PROD_SITE_ID\n         , CAL.BUCKET_TYPE\n",
         f"    SELECT /*+ LEADING({alias} F VD) USE_HASH(F VD PVT) SWAP_JOIN_INPUTS({alias}) NO_SWAP_JOIN_INPUTS(F) PARALLEL(F 4) */ {M} F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID\n         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID\n         , F.CELL_PROD_SITE_ID\n         , CAL.BUCKET_TYPE\n"),
        # 사업부 82 표: 5234 → 5281 — 최종 동적 SQL, 82 일 때만 PARALLEL(8)
        ("    V_SQL := '\n    SELECT [@V_COLUMN]\n    , ([@V_QTY_SUM]) AS QTY\n",
         "    V_SQL := '\n    SELECT [@V_HINT82] [@V_COLUMN]\n    , ([@V_QTY_SUM]) AS QTY\n"),
        ("    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);\n",
         f"    V_SQL := REPLACE(V_SQL, '[@V_HINT82]', CASE WHEN p_division_id = '82' THEN '/*+ PARALLEL(8) */' END);  --{MARK} 82 일 때만 힌트\n    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);\n"),
    ]


def conn():
    cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True)
    return cx, cx.cursor()


def fetch(c):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=PKG, t=TYP)
    return ''.join(r[0] or '' for r in c.fetchall())


def info(c):
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=PKG, t=TYP)
    return c.fetchone()


def invalid(c):
    c.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID'", o=OWNER)
    return c.fetchone()[0]


def ddl(src):
    return 'CREATE OR REPLACE ' + src.rstrip() + '\n'


def compile_src(c, src):
    c.execute(ddl(src))
    c.execute("SELECT LINE,POSITION,TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", o=OWNER, n=PKG, t=TYP)
    return c.fetchall()


def main():
    mode = sys.argv[1]
    cx, c = conn()
    c.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'),SYS_CONTEXT('USERENV','DB_NAME'),TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    print('DB', c.fetchone(), 'BODY', info(c), 'INVALID', invalid(c))
    if mode == 'build':
        alias = sys.argv[sys.argv.index('--alias') + 1] if '--alias' in sys.argv else 'CAL'
        base = fetch(c)
        if MARK in base:
            sys.exit('이미 마커 있음 — 기준본 아님. restore 후 build')
        i = base.index(BOUND)
        head, tail = base[:i], base[i:]
        for k, (a, b) in enumerate(reps(alias), 1):
            n = head.count(a)
            assert n == 1, f'치환 {k} 매칭 {n} != 1: {a[:70]!r}'
            head = head.replace(a, b)
            print(f'  치환 {k} OK (GET_MAIN_DATA 범위 1건) · 범위 밖 동일 문장 {tail.count(a)}건 무변경')
        new = head + tail
        open(F_BAK, 'w', encoding='utf-8', newline='\n').write(base)
        open(F_NEW, 'w', encoding='utf-8', newline='\n').write(new)
        json.dump({'base_md5': hashlib.md5(base.encode()).hexdigest(), 'alias': alias, 'new_md5': hashlib.md5(new.encode()).hexdigest()}, open(STATE, 'w'))
        print('build', alias, 'base lines', base.count('\n'), 'new lines', new.count('\n'), 'hint/marker', new.count(MARK))
    elif mode == 'apply':
        st = json.load(open(STATE))
        now = fetch(c)
        assert hashlib.md5(now.encode()).hexdigest() == st['base_md5'], 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
        print('FRESH-GATE PASS')
        new = open(F_NEW, encoding='utf-8', newline='\n').read()
        errs = compile_src(c, new)
        print('적용', st['alias'], 'BODY', info(c), 'ERR', len(errs), errs[:10], 'INVALID', invalid(c))
        got = fetch(c)
        print('적용본 == DB 원문', got.rstrip() == new.rstrip())
        if errs:
            print('오류 → 원복')
            print(compile_src(c, open(F_BAK, encoding='utf-8', newline='\n').read()), info(c))
            sys.exit(1)
    elif mode == 'restore':
        st = json.load(open(STATE))
        now = fetch(c)
        assert hashlib.md5(now.rstrip().encode()).hexdigest() == hashlib.md5(open(F_NEW, encoding='utf-8', newline='\n').read().rstrip().encode()).hexdigest(), 'FRESH-GATE 실패: 적용본 이후 DB 변경 — 중단'
        errs = compile_src(c, open(F_BAK, encoding='utf-8', newline='\n').read())
        got = fetch(c)
        print('원복 BODY', info(c), 'ERR', len(errs), '원문 == 백업', got.rstrip() == open(F_BAK, encoding='utf-8', newline='\n').read().rstrip())


if __name__ == '__main__':
    main()
