# -*- coding: utf-8 -*-
"""DMF0082_1104 클라우드 이관 패키지 생성기 (2026-11-09) — [E20261104-DMF0082ONEQUERY]

목적: 사내 ZIOUI1 의 PKG_DMF0082_1104(apply #26 · 조회 속도 개선 복제본)를 클라우드에 '새 객체'로 만들고,
      클라우드에서 원본 PKG_DMF0082 와 번갈아 호출해 속도·결과 동일 여부를 측정한다. 원본 PKG_DMF0082 는 건드리지 않는다.

  python -I build_package.py            # 생성 (FRESH-GATE → A_DB/*.sql · 00_README 사실값)
  python -I build_package.py --rehearse # 생성 + 사내 리허설(SCM_MGR · 객체명 PKG_DMF0082_1104R 로 바꿔 실행 · 끝에 삭제)
       --qa                             #   리허설 30 을 클라우드 QA 형 세션(_optim_peek_user_binds=FALSE · optimizer_adaptive_plans=FALSE)으로
       --runs N                         #   리허설 30 회차(기본 1)

FRESH-GATE: 1104 BODY LAST_DDL = EXPECT_BODY_DDL · VALID · ALL_ERRORS 0 — 다르면 중단(새 apply 가 있었으면 등가 재검증 후 기대값 갱신).
금지: 클라우드 접속 · 사내 PKG_DMF0082 / PKG_DMF0082_1104 변경(리허설은 별도 이름 1104R 만 만들고 지운다).
"""
import sys, os, re, json, datetime, argparse
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ADB = os.path.join(HERE, 'A_DB')
OWNER = 'SCM_MGR'
PKG = 'PKG_DMF0082_1104'
ORIG = 'PKG_DMF0082'
EXPECT_BODY_DDL = '2026-11-06 06:09:06'
EXPECT_ORIG_BODY_DDL = '2026-11-04 14:48:42'
MARK = 'E20261104-DMF0082ONEQUERY'
NORM = "RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13))"
GMD_START = r"^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)"
GMD_END = r"^\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)"   # Oracle 정규식은 \b 미지원

ap = argparse.ArgumentParser()
ap.add_argument('--rehearse', action='store_true'); ap.add_argument('--qa', action='store_true'); ap.add_argument('--runs', type=int, default=1)
A = ap.parse_args()

cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()


def q(sql, **b):
    c.execute(sql, **b); cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


NOW = q("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') N, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') S, SYS_CONTEXT('USERENV','DB_NAME') DB FROM DUAL")[0]
OBJ = {(r['OBJECT_NAME'], r['OBJECT_TYPE']): r for r in q(
    "SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LD FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME IN (:a,:b)", o=OWNER, a=PKG, b=ORIG)}
# ── FRESH-GATE
bd = OBJ.get((PKG, 'PACKAGE BODY')); sp = OBJ.get((PKG, 'PACKAGE')); od = OBJ.get((ORIG, 'PACKAGE BODY'))
assert bd and bd['LD'] == EXPECT_BODY_DDL and bd['STATUS'] == 'VALID', f'FRESH-GATE FAIL: {PKG} BODY {bd} (기대 {EXPECT_BODY_DDL} VALID)'
assert sp and sp['STATUS'] == 'VALID', f'FRESH-GATE FAIL: {PKG} SPEC {sp}'
nerr = q("SELECT COUNT(*) N FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n", o=OWNER, n=PKG)[0]['N']
assert nerr == 0, f'FRESH-GATE FAIL: {PKG} ALL_ERRORS {nerr}'
print(f"FRESH-GATE OK {NOW['S']} {PKG} SPEC {sp['LD']} BODY {bd['LD']} · 원본 BODY {od['LD']}{'' if od['LD'] == EXPECT_ORIG_BODY_DDL else ' (⚠ 원본 변경됨 — 1104 미반영 차이 확인 필요)'}")


def src(name, typ):
    return ''.join(r['TEXT'] or '' for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=name, t=typ))


SPEC, BODY = src(PKG, 'PACKAGE'), src(PKG, 'PACKAGE BODY')
for nm, s in (('SPEC', SPEC), ('BODY', BODY)):
    assert not any(l.strip() == '/' for l in s.split('\n')), f'{nm} 에 "/" 단독 줄 — 스크립트 분할 위험'
    assert re.match(r'\s*PACKAGE\s', s, re.I), f'{nm} 시작 형식 이상'
    assert ORIG + '.' not in s.replace(PKG + '.', ''), f'{nm} 이 원본 {ORIG} 를 호출함 — 확인 필요'


def fp(name, typ, rng=None):
    """정규화 지문 = (비어 있지 않은 줄 수, 길이 합, ORA_HASH 합) — 클라우드 00/90 과 같은 식"""
    where = ''
    if rng:
        where = f""" AND LINE >= (SELECT MIN(LINE) FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t AND REGEXP_LIKE(TEXT, '{GMD_START}'))
                     AND LINE <  (SELECT MIN(LINE) FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t AND REGEXP_LIKE(TEXT, '{GMD_END}'))"""
    r = q(f"SELECT COUNT(*) N, SUM(LENGTH({NORM})) L, SUM(ORA_HASH({NORM})) H FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t AND {NORM} IS NOT NULL{where}", o=OWNER, n=name, t=typ)[0]
    return int(r['N']), int(r['L'] or 0), int(r['H'] or 0)


FP_SPEC, FP_BODY = fp(PKG, 'PACKAGE'), fp(PKG, 'PACKAGE BODY')
FP_ORIG_GMD = fp(ORIG, 'PACKAGE BODY', rng=True)
NLINES = {t: q("SELECT COUNT(*) N FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t", o=OWNER, n=PKG, t=t)[0]['N'] for t in ('PACKAGE', 'PACKAGE BODY')}
print('지문', 'SPEC', FP_SPEC, 'BODY', FP_BODY, '원본 GET_MAIN_DATA', FP_ORIG_GMD, '줄수', NLINES)

# ── 의존 객체(ALL_DEPENDENCIES + 동적 SQL 문자열 안 식별자) · 열
deps = q("""SELECT DISTINCT REFERENCED_OWNER RO, REFERENCED_NAME RN, REFERENCED_TYPE RT FROM ALL_DEPENDENCIES
            WHERE OWNER=:o AND NAME=:n AND REFERENCED_OWNER NOT IN ('SYS','PUBLIC','SYSTEM','XDB','MDSYS','CTXSYS','ORDSYS')
              AND NOT (REFERENCED_OWNER=:o AND REFERENCED_NAME=:n) ORDER BY 1,2,3""", o=OWNER, n=PKG)
have = {d['RN'] for d in deps}
# 동적 SQL 문자열 안의 참조만 — 주석(/* */ · --)은 제외 (11-09 리허설: 주석에만 있는 INVALID 프로시저 2개가 P4 에 오탐)
_nocom = re.sub(r"'(?:[^']|'')*'|/\*.*?\*/|--[^\n]*", lambda m: m.group(0) if m.group(0).startswith("'") else ' ', BODY, flags=re.S)
toks = sorted({t for t in re.findall(r'\b([A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+)\b', _nocom) if t not in have and len(t) >= 8 and t != PKG})
for i in range(0, len(toks), 500):
    part = toks[i:i + 500]
    for r in q("SELECT OBJECT_NAME RN, OBJECT_TYPE RT FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_TYPE IN ('TABLE','VIEW','PACKAGE','PROCEDURE','FUNCTION','TYPE','SEQUENCE','SYNONYM') AND OBJECT_NAME IN (" + ','.join("'" + x + "'" for x in part) + ")"):
        deps.append({'RO': OWNER, 'RN': r['RN'], 'RT': r['RT'], 'DYN': 'Y'})
DYNSET = {(d['RO'], d['RN'], d['RT']) for d in deps if d.get('DYN')}
DEPS = sorted({(d['RO'], d['RN'], d['RT']) for d in deps if d['RN'] not in (ORIG, PKG)})
COLS = []
for o_, n_, t_ in DEPS:
    if t_ in ('TABLE', 'VIEW'):
        COLS += [(o_, n_, r['COLUMN_NAME']) for r in q("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER=:o AND TABLE_NAME=:t ORDER BY COLUMN_ID", o=o_, t=n_)]
GRANTS = q("SELECT GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA=:o AND TABLE_NAME=:n ORDER BY 1,2", o=OWNER, n=PKG)
SYNS = q("SELECT OWNER, SYNONYM_NAME FROM ALL_SYNONYMS WHERE TABLE_OWNER=:o AND TABLE_NAME=:n ORDER BY 1,2", o=OWNER, n=PKG)
print(f'의존 {len(DEPS)}개(동적 {sum(1 for d in deps if d.get("DYN"))}) · 열 {len(COLS)} · 권한 {len(GRANTS)} · 시노님 {len(SYNS)}')


def lst_sql(items, col):
    """SYS.ODCIVARCHAR2LIST 묶음(400개씩) UNION ALL — SQL 함수 인자 999 제한 회피"""
    parts = []
    for i in range(0, len(items), 400):
        chunk = items[i:i + 400]
        lines = ',\n        '.join("'" + x.replace("'", "''") + "'" for x in chunk)
        parts.append(f"SELECT COLUMN_VALUE {col} FROM TABLE(SYS.ODCIVARCHAR2LIST(\n        {lines}))")
    return '\n    UNION ALL '.join(parts)


HDR = f"""/* =====================================================================================================
 * DMF0082_1104 클라우드 이관 · {{FILE}} — {{TITLE}}
 * 마커 [{MARK}] · 생성 {NOW['S']} (사내 {NOW['DB']}) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 대상 = 새 객체 {PKG} 만. 원본 {ORIG} 는 변경하지 않는다.
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
"""


def hdr(f, title):
    return HDR.replace('{FILE}', f).replace('{TITLE}', title)


FILES = {}
# ───────────────────────── 00 PRECHECK ─────────────────────────
dep_items = [f'{o}.{n}|{t}|{"DYN" if (o, n, t) in DYNSET else "STATIC"}' for o, n, t in DEPS]
col_items = [f'{o}.{n}.{cn}' for o, n, cn in COLS]
FILES['00_PRECHECK_CLOUD.sql'] = hdr('00_PRECHECK_CLOUD', '적용 전 점검 (조회 전용)') + f"""
-- P0 접속 · 버전
SELECT 'P0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, USER CUR_USER, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW_TIME FROM DUAL;
SELECT 'P0' CHK, PRODUCT, VERSION FROM PRODUCT_COMPONENT_VERSION;

-- P1 객체 상태 — 기대: {ORIG} PACKAGE/BODY VALID · {PKG} 0행(처음 이관). {PKG} 가 이미 있으면 20 이 그 원문을 백업한 뒤 덮어쓴다(99 로 복원 가능).
SELECT 'P1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME IN ('{ORIG}','{PKG}') ORDER BY OBJECT_NAME, OBJECT_TYPE;

-- P2 원본 조회 프로시저 인자 수 — 기대 22 (입력 16 + 출력 6). 다르면 30 측정 SQL 이 컴파일 오류로 멈춘다.
SELECT 'P2' CHK, COUNT(*) ARG_CNT, CASE WHEN COUNT(*) = 22 THEN 'OK' ELSE '확인 필요 — 회신' END JUDGE
  FROM USER_ARGUMENTS WHERE PACKAGE_NAME = '{ORIG}' AND OBJECT_NAME = 'P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL = 0;

-- P3 클라우드 원본 GET_MAIN_DATA 가 사내 원본(BODY {od['LD']})과 같은지 — 정규화 지문(줄 수 · 길이 합 · ORA_HASH 합)
--    SAME = 사내에서 확인한 '원본 = 1104 결과 동일'이 클라우드 원본에도 그대로 해당.
--    DIFF = 클라우드 원본이 사내 원본과 세대가 다르다 → 30/40 의 결과 비교가 판정 기준(다르면 회신).
WITH R AS (SELECT (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{ORIG}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{GMD_START}')) L1,
                  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{ORIG}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{GMD_END}')) L2 FROM DUAL)
SELECT 'P3' CHK, COUNT(*) N_LINES, SUM(LENGTH({NORM})) LEN_SUM, SUM(ORA_HASH({NORM})) HASH_SUM,
       {FP_ORIG_GMD[0]} CORP_N, {FP_ORIG_GMD[1]} CORP_LEN, {FP_ORIG_GMD[2]} CORP_HASH,
       CASE WHEN COUNT(*) = {FP_ORIG_GMD[0]} AND SUM(LENGTH({NORM})) = {FP_ORIG_GMD[1]} AND SUM(ORA_HASH({NORM})) = {FP_ORIG_GMD[2]} THEN 'SAME'
            WHEN COUNT(*) = {FP_ORIG_GMD[0]} AND SUM(LENGTH({NORM})) = {FP_ORIG_GMD[1]} THEN 'SAME? (줄·길이 같음 · 해시만 다름 — 버전 간 ORA_HASH 차이 가능)'
            ELSE 'DIFF' END JUDGE
  FROM USER_SOURCE S, R WHERE S.NAME='{ORIG}' AND S.TYPE='PACKAGE BODY' AND S.LINE >= R.L1 AND S.LINE < R.L2 AND {NORM} IS NOT NULL;

-- P4 {PKG} 가 참조하는 객체 {len(DEPS)}개(정적 {len(DEPS) - len(DYNSET & set(DEPS))} · 동적 SQL 문자열 {len(DYNSET & set(DEPS))}) 중 클라우드에 없거나 VALID 가 아닌 것 — 기대 0행
--    REF_KIND = STATIC 이 없으면 20 BODY 가 컴파일 오류 · DYN 이 없으면 컴파일은 되지만 그 동적 SQL 실행 시 오류 → 어느 쪽이든 회신
WITH E AS (
    {lst_sql(dep_items, 'K')}
), D AS (SELECT REGEXP_SUBSTR(K, '[^.]+', 1, 1) OWN, REGEXP_SUBSTR(SUBSTR(K, INSTR(K, '.') + 1), '[^|]+', 1, 1) NAM,
                REGEXP_SUBSTR(K, '[^|]+', 1, 2) TYP, REGEXP_SUBSTR(K, '[^|]+', 1, 3) REF_KIND FROM E)
SELECT 'P4' CHK, D.OWN, D.NAM, D.TYP, D.REF_KIND, MAX(O.STATUS) STATUS, CASE WHEN MAX(O.OBJECT_NAME) IS NULL THEN '없음' ELSE 'INVALID' END JUDGE
  FROM D LEFT JOIN ALL_OBJECTS O ON O.OWNER = D.OWN AND O.OBJECT_NAME = D.NAM AND O.OBJECT_TYPE IN (D.TYP, D.TYP || ' BODY')
 GROUP BY D.OWN, D.NAM, D.TYP, D.REF_KIND
HAVING MAX(O.OBJECT_NAME) IS NULL OR MIN(O.STATUS) <> 'VALID'
 ORDER BY 2, 3;

-- P5 참조 테이블·뷰의 열 {len(COLS)}개 중 클라우드에 없는 열 — 기대 0행 (있으면 20 컴파일 오류 가능 · 회신)
WITH E AS (
    {lst_sql(col_items, 'K')}
), D AS (SELECT REGEXP_SUBSTR(K, '[^.]+', 1, 1) OWN, REGEXP_SUBSTR(K, '[^.]+', 1, 2) TAB, REGEXP_SUBSTR(K, '[^.]+', 1, 3) COL FROM E)
SELECT 'P5' CHK, D.OWN, D.TAB, D.COL, '클라우드에 없음' JUDGE
  FROM D WHERE NOT EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS C WHERE C.OWNER = D.OWN AND C.TABLE_NAME = D.TAB AND C.COLUMN_NAME = D.COL)
 ORDER BY 2, 3;

-- P6 원본 {ORIG} 의 권한·시노님 — 20 이 {PKG} 에 같은 권한·시노님을 만든다 (사내 {PKG}: 권한 {', '.join(g['GRANTEE'] + ' ' + g['PRIVILEGE'] for g in GRANTS) or '없음'} · 시노님 {', '.join(s['OWNER'] + '.' + s['SYNONYM_NAME'] for s in SYNS) or '없음'})
SELECT 'P6' CHK, 'GRANT' KIND, GRANTEE WHO, PRIVILEGE WHAT FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = '{ORIG}'
UNION ALL
SELECT 'P6' CHK, 'SYNONYM' KIND, OWNER WHO, SYNONYM_NAME WHAT FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = '{ORIG}'
 ORDER BY 2, 3, 4;

-- P7 {ORIG}·{PKG} 실행 중 세션 (V$SESSION 권한이 없으면 '권한 없음' 출력 · 오류 아님) — 기대 0
DECLARE
    n PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE q'[SELECT COUNT(*) FROM V$SESSION S WHERE S.STATUS = 'ACTIVE' AND S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME IN ('{ORIG}','{PKG}') AND OBJECT_TYPE = 'PACKAGE')]' INTO n;
    DBMS_OUTPUT.PUT_LINE('P7 실행 중 세션 ' || n || CASE WHEN n = 0 THEN ' (기대)' ELSE ' — 끝난 뒤 20 실행' END);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('P7 V$SESSION 조회 권한 없음 — DMF0082 조회가 돌고 있지 않은 시간에 20 을 실행하세요 (' || SQLCODE || ')');
END;
/
"""

# ───────────────────────── 20 CREATE ─────────────────────────
grant_mirror = f"""-- 원본 {ORIG} 와 같은 권한·시노님을 {PKG} 에 만든다 (화면은 {PKG} 를 호출하지 않는다 · 측정은 SCM_MGR 로 하므로 실패해도 측정에는 영향 없음)
DECLARE
    n PLS_INTEGER := 0;
BEGIN
    FOR g IN (SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = '{ORIG}') LOOP
        BEGIN
            EXECUTE IMMEDIATE 'GRANT ' || g.PRIVILEGE || ' ON {PKG} TO ' || g.GRANTEE;
            DBMS_OUTPUT.PUT_LINE('GRANT   ' || g.PRIVILEGE || ' ON {PKG} TO ' || g.GRANTEE); n := n + 1;
        EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('GRANT 실패(측정 무관) ' || g.PRIVILEGE || ' TO ' || g.GRANTEE || ' — ' || SQLERRM);
        END;
    END LOOP;
    FOR s IN (SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = '{ORIG}' AND OWNER <> 'PUBLIC') LOOP
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || s.OWNER || '.{PKG} FOR ' || USER || '.{PKG}';
            DBMS_OUTPUT.PUT_LINE('SYNONYM ' || s.OWNER || '.{PKG}'); n := n + 1;
        EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('SYNONYM 실패(측정 무관) ' || s.OWNER || ' — ' || SQLERRM);
        END;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('권한·시노님 ' || n || '건');
END;
/
"""
backup_block = f"""-- ① 적용 전 백업 (반복 실행 안전 — 백업은 첫 실행 상태 1회만 남긴다)
--    {PKG} 가 없으면 'NONE' 표식 → 99 원복 = 삭제 / 있으면 그 원문 → 99 원복 = 그 원문으로 재생성
DECLARE
    n PLS_INTEGER;
    v CLOB;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_BAK';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ZB_DMF0082_1104_BAK (OBJ_TYPE VARCHAR2(30), SRC CLOB, SAVED_AT DATE)';
    END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_DMF0082_1104_BAK' INTO n;
    IF n > 0 THEN
        DBMS_OUTPUT.PUT_LINE('BACKUP  SKIP — 백업 이미 있음(첫 실행 상태 보존)');
        RETURN;
    END IF;
    SELECT COUNT(*) INTO n FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' AND OBJECT_TYPE = 'PACKAGE';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'INSERT INTO ZB_DMF0082_1104_BAK (OBJ_TYPE, SRC, SAVED_AT) VALUES (''NONE'', NULL, SYSDATE)';
        DBMS_OUTPUT.PUT_LINE('BACKUP  NONE — 적용 전 {PKG} 없음 (99 원복 = 삭제)');
    ELSE
        FOR t IN (SELECT DISTINCT TYPE FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE IN ('PACKAGE','PACKAGE BODY')) LOOP
            DBMS_LOB.CREATETEMPORARY(v, TRUE);
            FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE = t.TYPE ORDER BY LINE) LOOP
                DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
            END LOOP;
            EXECUTE IMMEDIATE 'INSERT INTO ZB_DMF0082_1104_BAK (OBJ_TYPE, SRC, SAVED_AT) VALUES (:1, :2, SYSDATE)' USING t.TYPE, v;
            DBMS_LOB.FREETEMPORARY(v);
            DBMS_OUTPUT.PUT_LINE('BACKUP  ' || t.TYPE || ' {PKG}');
        END LOOP;
    END IF;
    COMMIT;
END;
/
"""
FILES['20_CREATE_PKG_DMF0082_1104.sql'] = (
    f"-- SOURCE-FRESH: {OWNER}.{PKG} PACKAGE LAST_DDL={sp['LD']} FETCHED={NOW['N']} DB={NOW['DB']}\n"
    f"-- SOURCE-FRESH: {OWNER}.{PKG} PACKAGE BODY LAST_DDL={bd['LD']} FETCHED={NOW['N']} DB={NOW['DB']}\n"
    + hdr('20_CREATE_PKG_DMF0082_1104', f'{PKG} 생성 (사내 apply #26 원문 전체 · SPEC {NLINES["PACKAGE"]}줄 · BODY {NLINES["PACKAGE BODY"]}줄)')
    + "\n" + backup_block
    + "\n-- ② SPEC\nCREATE OR REPLACE " + SPEC.rstrip() + "\n/\n"
    + "\n-- ③ BODY (컴파일 오류가 나도 스크립트는 계속 — ⑤ 의 오류 목록을 회신. 새 객체라 다른 화면에는 영향 없음)\nCREATE OR REPLACE " + BODY.rstrip() + "\n/\n"
    + "\n-- ④ 권한·시노님\n" + grant_mirror
    + f"""
-- ⑤ 확인 — 기대: PACKAGE · PACKAGE BODY 모두 VALID · 오류 0행
SELECT 'C1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' ORDER BY OBJECT_TYPE;
SELECT 'C2' CHK, TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{PKG}' ORDER BY TYPE, SEQUENCE;
""")

# ───────────────────────── 30 SPEED RUN ─────────────────────────
FILES['30_SPEED_RUN.sql'] = hdr('30_SPEED_RUN', f'속도·결과 측정 — 원본 {ORIG} ↔ {PKG} 번갈아 호출') + f"""
-- 사업부 40 · 81 · 82 마다 c_runs 회 반복. 회차마다 두 패키지를 번갈아 부른다(홀수 회차 = 원본 먼저 · 짝수 회차 = 1104 먼저).
-- 기록 = 프로시저 실행 시간 · 6개 커서 fetch 시간 · 커서별 행 수 · 커서별 결과 해시(행 순서 무관 · 전 열 값) → ZB_DMF0082_1104_SPEED
--   커서3 TODAY_TIME(= SYSDATE 시분)은 호출 시각이라 해시에서 뺀다(두 패키지 같은 식 · 사내 확인).
-- 조건 = 화면 기본값과 같은 값: 기간 당월 1일 ~ +6개월-1일 · 미선택 조회조건 'ALL' · 품목 NULL · 'Current' · qtyYn 'N'
--   사용자 = c_user 가 NULL 이면 DMF0082 FcstNPrice 개인 컬럼 설정 행이 가장 많은 사용자 · 사용자 그룹 = c_group
-- 원장 변경 없음(호출마다 ROLLBACK · 기록표만 COMMIT). 다시 돌리면 기록을 지우고 새로 남긴다.
-- DB 안 시간이다(BE 왕복·JSON 변환 제외). 원본 사업부 40 은 사내에서 1회 63~84초였다(11-06·11-09 실측).
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_SPEED';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ZB_DMF0082_1104_SPEED (PKG VARCHAR2(30), DIV VARCHAR2(10), RUN_NO NUMBER, SEQ_IN_RUN NUMBER, USER_ID VARCHAR2(100), USER_GROUP VARCHAR2(100), FROM_YMD VARCHAR2(8), TO_YMD VARCHAR2(8),'
            || ' PROC_SEC NUMBER, FETCH_SEC NUMBER, TOTAL_SEC NUMBER, R1 NUMBER, R2 NUMBER, R3 NUMBER, R4 NUMBER, R5 NUMBER, R6 NUMBER, C1 NUMBER,'
            || ' H1 NUMBER, H2 NUMBER, H3 NUMBER, H4 NUMBER, H5 NUMBER, H6 NUMBER, ERR VARCHAR2(1000), BODY_DDL VARCHAR2(20), RUN_AT DATE)';
        DBMS_OUTPUT.PUT_LINE('기록표 생성 ZB_DMF0082_1104_SPEED');
    END IF;
END;
/
DECLARE
    c_runs  CONSTANT PLS_INTEGER := 3;
    c_user  CONSTANT VARCHAR2(100) := NULL;
    c_group CONSTANT VARCHAR2(100) := 'ADMIN';
    TYPE t_div IS TABLE OF VARCHAR2(10);
    v_divs  t_div := t_div('40', '81', '82');
    v_user  VARCHAR2(100);
    v_from  VARCHAR2(8);
    v_to    VARCHAR2(8);

    PROCEDURE cur_hash(p_rc IN OUT SYS_REFCURSOR, p_skip VARCHAR2, o_rows OUT NUMBER, o_cols OUT NUMBER, o_hash OUT NUMBER) IS
        c    INTEGER;
        ncol INTEGER;
        dsc  DBMS_SQL.DESC_TAB2;
        val  VARCHAR2(4000);
        cv   CLOB;
        rw   VARCHAR2(32767);
        r_h  NUMBER;
        h    NUMBER := 0;
        k    NUMBER := 0;
    BEGIN
        c := DBMS_SQL.TO_CURSOR_NUMBER(p_rc);
        DBMS_SQL.DESCRIBE_COLUMNS2(c, ncol, dsc);
        FOR i IN 1 .. ncol LOOP
            IF dsc(i).col_type = 112 THEN DBMS_SQL.DEFINE_COLUMN(c, i, cv); ELSE DBMS_SQL.DEFINE_COLUMN(c, i, val, 4000); END IF;
        END LOOP;
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            k := k + 1; rw := NULL; r_h := 0;
            FOR i IN 1 .. ncol LOOP
                IF dsc(i).col_name = p_skip THEN
                    val := '#';
                ELSIF dsc(i).col_type = 112 THEN
                    DBMS_SQL.COLUMN_VALUE(c, i, cv);
                    val := DBMS_LOB.SUBSTR(cv, 1000, 1) || '#' || DBMS_LOB.GETLENGTH(cv);
                ELSE
                    DBMS_SQL.COLUMN_VALUE(c, i, val);
                END IF;
                IF NVL(LENGTHB(rw), 0) + NVL(LENGTHB(val), 0) + 1 > 30000 THEN
                    r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(rw, 1, 1073741824), 1000000007); rw := NULL;
                END IF;
                rw := rw || '|' || val;
            END LOOP;
            r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(NVL(rw, '~'), 1, 1073741824), 1000000007);
            h := MOD(h + r_h, 281474976710656);
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        o_rows := k; o_cols := ncol; o_hash := h;
    END;

    PROCEDURE one_call(p_pkg VARCHAR2, p_div VARCHAR2, p_run PLS_INTEGER, p_seq PLS_INTEGER) IS
        rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rc6 SYS_REFCURSOR;
        t0 PLS_INTEGER; t1 PLS_INTEGER; t2 PLS_INTEGER;
        r1 NUMBER; r2 NUMBER; r3 NUMBER; r4 NUMBER; r5 NUMBER; r6 NUMBER;
        c1 NUMBER; cx NUMBER;
        h1 NUMBER; h2 NUMBER; h3 NUMBER; h4 NUMBER; h5 NUMBER; h6 NUMBER;
        v_err VARCHAR2(1000); v_ddl VARCHAR2(20);
    BEGIN
        SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') INTO v_ddl FROM USER_OBJECTS WHERE OBJECT_NAME = p_pkg AND OBJECT_TYPE = 'PACKAGE BODY';
        t0 := DBMS_UTILITY.GET_TIME;
        IF p_pkg = '{ORIG}' THEN
            {ORIG}.P_DMF0082_GET_MAIN_DATA(p_div, 'ALL', 'ALL', 'ALL', v_from, v_to, 'ALL', NULL, 'Current', 'N', v_user, c_group, 'ALL', 'ALL', 'ALL', 'ALL', rc1, rc2, rc3, rc4, rc5, rc6);
        ELSE
            {PKG}.P_DMF0082_GET_MAIN_DATA(p_div, 'ALL', 'ALL', 'ALL', v_from, v_to, 'ALL', NULL, 'Current', 'N', v_user, c_group, 'ALL', 'ALL', 'ALL', 'ALL', rc1, rc2, rc3, rc4, rc5, rc6);
        END IF;
        t1 := DBMS_UTILITY.GET_TIME;
        cur_hash(rc1, '-', r1, c1, h1);
        cur_hash(rc2, '-', r2, cx, h2);
        cur_hash(rc3, 'TODAY_TIME', r3, cx, h3);
        cur_hash(rc4, '-', r4, cx, h4);
        cur_hash(rc5, '-', r5, cx, h5);
        cur_hash(rc6, '-', r6, cx, h6);
        t2 := DBMS_UTILITY.GET_TIME;
        ROLLBACK;
        INSERT INTO ZB_DMF0082_1104_SPEED (PKG, DIV, RUN_NO, SEQ_IN_RUN, USER_ID, USER_GROUP, FROM_YMD, TO_YMD, PROC_SEC, FETCH_SEC, TOTAL_SEC,
                                           R1, R2, R3, R4, R5, R6, C1, H1, H2, H3, H4, H5, H6, ERR, BODY_DDL, RUN_AT)
        VALUES (p_pkg, p_div, p_run, p_seq, v_user, c_group, v_from, v_to, (t1 - t0) / 100, (t2 - t1) / 100, (t2 - t0) / 100,
                r1, r2, r3, r4, r5, r6, c1, h1, h2, h3, h4, h5, h6, CASE WHEN r1 = 0 THEN 'ZERO_ROWS' END, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS') || ' ' || RPAD(p_pkg, 17) || ' div' || p_div || ' #' || p_run || ' proc ' || (t1 - t0) / 100 || 's fetch ' || (t2 - t1) / 100 || 's rows=' || r1);
    EXCEPTION WHEN OTHERS THEN
        v_err := SUBSTR(SQLERRM, 1, 1000);
        ROLLBACK;
        INSERT INTO ZB_DMF0082_1104_SPEED (PKG, DIV, RUN_NO, SEQ_IN_RUN, USER_ID, USER_GROUP, FROM_YMD, TO_YMD, ERR, BODY_DDL, RUN_AT)
        VALUES (p_pkg, p_div, p_run, p_seq, v_user, c_group, v_from, v_to, v_err, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS') || ' ' || RPAD(p_pkg, 17) || ' div' || p_div || ' #' || p_run || ' ERROR ' || v_err);
    END;
BEGIN
    v_from := TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD');
    v_to   := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 6) - 1, 'YYYYMMDD');
    v_user := c_user;
    IF v_user IS NULL THEN
        SELECT MAX(USER_ID) KEEP (DENSE_RANK FIRST ORDER BY CNT DESC, USER_ID) INTO v_user
          FROM (SELECT USER_ID, COUNT(*) CNT FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' GROUP BY USER_ID);
    END IF;
    IF v_user IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, '중단 — DMF0082 FcstNPrice 개인 컬럼 설정 사용자 없음. c_user 에 사용자 ID 를 넣고 다시 실행');
    END IF;
    EXECUTE IMMEDIATE 'DELETE FROM ZB_DMF0082_1104_SPEED';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('시작 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' · user=' || v_user || ' · group=' || c_group || ' · ' || v_from || '~' || v_to || ' · 회차 ' || c_runs);
    FOR d IN 1 .. v_divs.COUNT LOOP
        FOR r IN 1 .. c_runs LOOP
            IF MOD(r, 2) = 1 THEN
                one_call('{ORIG}', v_divs(d), r, 1); one_call('{PKG}', v_divs(d), r, 2);
            ELSE
                one_call('{PKG}', v_divs(d), r, 1); one_call('{ORIG}', v_divs(d), r, 2);
            END IF;
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('끝 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' — 40_SPEED_COMPARE 로 결과 확인');
END;
/
SELECT PKG, DIV, RUN_NO, SEQ_IN_RUN, PROC_SEC, FETCH_SEC, TOTAL_SEC, R1, C1, ERR FROM ZB_DMF0082_1104_SPEED ORDER BY DIV, RUN_NO, SEQ_IN_RUN;
"""

# ───────────────────────── 40 COMPARE ─────────────────────────
FILES['40_SPEED_COMPARE.sql'] = hdr('40_SPEED_COMPARE', '속도·결과 비교 (조회 전용)') + f"""
-- 기록 = ZB_DMF0082_1104_SPEED (30 이 남김). 시간 = 회차 중앙값(초). 1회차는 하드파싱이 섞이므로 C2 회차별 값도 함께 본다.
-- NOTE 가 'OK' 가 아니면 시간보다 그 내용을 먼저 회신한다:
--   오류 · 0행 · 결과 다름(커서 n · 같은 회차 원본 ↔ 1104 의 행 수 또는 결과 해시가 다름) · 회차 간 변동(같은 패키지 해시가 회차마다 다름 = 측정 중 데이터 변경 가능)
WITH B AS (
    SELECT DIV, RUN_NO,
           MAX(CASE WHEN PKG = '{ORIG}' THEN TOTAL_SEC END) O_T, MAX(CASE WHEN PKG = '{PKG}' THEN TOTAL_SEC END) N_T,
           MAX(CASE WHEN PKG = '{ORIG}' THEN PROC_SEC END)  O_P, MAX(CASE WHEN PKG = '{PKG}' THEN PROC_SEC END)  N_P,
           MAX(CASE WHEN PKG = '{ORIG}' THEN FETCH_SEC END) O_F, MAX(CASE WHEN PKG = '{PKG}' THEN FETCH_SEC END) N_F,
           MAX(CASE WHEN PKG = '{ORIG}' THEN R1 END) O_R1, MAX(CASE WHEN PKG = '{PKG}' THEN R1 END) N_R1,
           COUNT(ERR) ERRS,
           SUM(CASE WHEN PKG = '{ORIG}' THEN 1 ELSE 0 END) O_N, SUM(CASE WHEN PKG = '{PKG}' THEN 1 ELSE 0 END) N_N,
           CASE WHEN COUNT(DISTINCT R1||'/'||H1) = 1 AND COUNT(*) = 2 THEN 0 ELSE 1 END D1,
           CASE WHEN COUNT(DISTINCT R2||'/'||H2) = 1 AND COUNT(*) = 2 THEN 0 ELSE 1 END D2,
           CASE WHEN COUNT(DISTINCT R3||'/'||H3) = 1 AND COUNT(*) = 2 THEN 0 ELSE 1 END D3,
           CASE WHEN COUNT(DISTINCT R4||'/'||H4) = 1 AND COUNT(*) = 2 THEN 0 ELSE 1 END D4,
           CASE WHEN COUNT(DISTINCT R5||'/'||H5) = 1 AND COUNT(*) = 2 THEN 0 ELSE 1 END D5,
           CASE WHEN COUNT(DISTINCT R6||'/'||H6) = 1 AND COUNT(*) = 2 THEN 0 ELSE 1 END D6
      FROM ZB_DMF0082_1104_SPEED GROUP BY DIV, RUN_NO
), V AS (
    SELECT DIV, PKG, COUNT(DISTINCT R1||'/'||H1||'/'||H2||'/'||H3||'/'||H4||'/'||H5||'/'||H6) HN FROM ZB_DMF0082_1104_SPEED WHERE ERR IS NULL GROUP BY DIV, PKG
), VM AS (
    SELECT DIV, MAX(HN) HN FROM V GROUP BY DIV
)
SELECT 'C1' CHK, B.DIV, COUNT(*) RUNS,
       MEDIAN(B.O_T) ORIG_TOTAL, MEDIAN(B.N_T) NEW_TOTAL, ROUND(MEDIAN(B.N_T) / NULLIF(MEDIAN(B.O_T), 0), 2) RATIO,
       MEDIAN(B.O_P) ORIG_PROC, MEDIAN(B.N_P) NEW_PROC, MEDIAN(B.O_F) ORIG_FETCH, MEDIAN(B.N_F) NEW_FETCH,
       MIN(B.O_T) || '~' || MAX(B.O_T) ORIG_RANGE, MIN(B.N_T) || '~' || MAX(B.N_T) NEW_RANGE, MAX(B.O_R1) ORIG_ROWS, MAX(B.N_R1) NEW_ROWS,
       CASE WHEN SUM(B.ERRS) > 0 THEN '오류 또는 0행 — C2 확인'
            WHEN MIN(B.O_N) <> 1 OR MIN(B.N_N) <> 1 OR MAX(B.O_N) <> 1 OR MAX(B.N_N) <> 1 THEN '회차 짝 불완전 — C2 확인'
            WHEN SUM(B.D1 + B.D2 + B.D3 + B.D4 + B.D5 + B.D6) > 0 THEN
                 '결과 다름 — 커서' || CASE WHEN SUM(B.D1) > 0 THEN ' 1' END || CASE WHEN SUM(B.D2) > 0 THEN ' 2' END || CASE WHEN SUM(B.D3) > 0 THEN ' 3' END
                                     || CASE WHEN SUM(B.D4) > 0 THEN ' 4' END || CASE WHEN SUM(B.D5) > 0 THEN ' 5' END || CASE WHEN SUM(B.D6) > 0 THEN ' 6' END || ' (C3 확인 · 회신)'
            WHEN MAX(VM.HN) > 1 THEN 'OK (단, 회차 간 결과 변동 — 측정 중 데이터 변경 가능)'
            ELSE 'OK' END NOTE
  FROM B LEFT JOIN VM ON VM.DIV = B.DIV GROUP BY B.DIV ORDER BY B.DIV;

SELECT 'C2' CHK, DIV, RUN_NO, SEQ_IN_RUN, PKG, PROC_SEC, FETCH_SEC, TOTAL_SEC, R1, R2, R3, R4, R5, R6, C1, USER_ID, USER_GROUP, FROM_YMD, TO_YMD, BODY_DDL, TO_CHAR(RUN_AT, 'HH24:MI:SS') AT_TIME, ERR
  FROM ZB_DMF0082_1104_SPEED ORDER BY DIV, RUN_NO, SEQ_IN_RUN;

SELECT 'C3' CHK, O.DIV, O.RUN_NO,
       CASE WHEN O.R1 = N.R1 AND O.H1 = N.H1 THEN 'SAME' ELSE 'DIFF' END CUR1, CASE WHEN O.R2 = N.R2 AND O.H2 = N.H2 THEN 'SAME' ELSE 'DIFF' END CUR2,
       CASE WHEN O.R3 = N.R3 AND O.H3 = N.H3 THEN 'SAME' ELSE 'DIFF' END CUR3, CASE WHEN O.R4 = N.R4 AND O.H4 = N.H4 THEN 'SAME' ELSE 'DIFF' END CUR4,
       CASE WHEN O.R5 = N.R5 AND O.H5 = N.H5 THEN 'SAME' ELSE 'DIFF' END CUR5, CASE WHEN O.R6 = N.R6 AND O.H6 = N.H6 THEN 'SAME' ELSE 'DIFF' END CUR6,
       O.R1 ORIG_R1, N.R1 NEW_R1, O.C1 ORIG_COLS, N.C1 NEW_COLS
  FROM ZB_DMF0082_1104_SPEED O JOIN ZB_DMF0082_1104_SPEED N ON N.DIV = O.DIV AND N.RUN_NO = O.RUN_NO AND N.PKG = '{PKG}'
 WHERE O.PKG = '{ORIG}' ORDER BY O.DIV, O.RUN_NO;
"""

# ───────────────────────── 90 VERIFY ─────────────────────────
FILES['90_VERIFY.sql'] = hdr('90_VERIFY', '적용 확인 (조회 전용)') + f"""
-- V1 상태 — 기대: PACKAGE · PACKAGE BODY 모두 VALID
SELECT 'V1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' ORDER BY OBJECT_TYPE;
-- V2 컴파일 오류 — 기대: ERR_CNT 0
SELECT 'V2' CHK, COUNT(*) ERR_CNT, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL — 20 의 C2 오류 목록 회신' END JUDGE FROM USER_ERRORS WHERE NAME = '{PKG}';
-- V3 원문이 사내 apply #26 과 같은지 — 정규화 지문(줄 수 · 길이 합 · ORA_HASH 합) · 사내 값 = 생성 시 측정({NOW['S']})
SELECT 'V3' CHK, TYPE, COUNT(*) N_LINES, SUM(LENGTH({NORM})) LEN_SUM, SUM(ORA_HASH({NORM})) HASH_SUM,
       DECODE(TYPE, 'PACKAGE', {FP_SPEC[0]}, {FP_BODY[0]}) CORP_N, DECODE(TYPE, 'PACKAGE', {FP_SPEC[1]}, {FP_BODY[1]}) CORP_LEN, DECODE(TYPE, 'PACKAGE', {FP_SPEC[2]}, {FP_BODY[2]}) CORP_HASH,
       CASE WHEN COUNT(*) = DECODE(TYPE, 'PACKAGE', {FP_SPEC[0]}, {FP_BODY[0]}) AND SUM(LENGTH({NORM})) = DECODE(TYPE, 'PACKAGE', {FP_SPEC[1]}, {FP_BODY[1]})
                 AND SUM(ORA_HASH({NORM})) = DECODE(TYPE, 'PACKAGE', {FP_SPEC[2]}, {FP_BODY[2]}) THEN 'PASS'
            WHEN COUNT(*) = DECODE(TYPE, 'PACKAGE', {FP_SPEC[0]}, {FP_BODY[0]}) AND SUM(LENGTH({NORM})) = DECODE(TYPE, 'PACKAGE', {FP_SPEC[1]}, {FP_BODY[1]}) THEN 'PASS? (줄·길이 같음 · 해시만 다름)'
            ELSE 'FAIL — 파일 일부만 실행됐거나 다른 원문' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE IN ('PACKAGE','PACKAGE BODY') AND {NORM} IS NOT NULL GROUP BY TYPE ORDER BY TYPE;
-- V4 권한 — 원본 {ORIG} 에 있는데 {PKG} 에 없는 권한 (기대 0행 · 측정에는 무관)
SELECT 'V4' CHK, O.GRANTEE, O.PRIVILEGE, '1104 에 없음' JUDGE FROM USER_TAB_PRIVS_MADE O
 WHERE O.TABLE_NAME = '{ORIG}' AND NOT EXISTS (SELECT 1 FROM USER_TAB_PRIVS_MADE N WHERE N.TABLE_NAME = '{PKG}' AND N.GRANTEE = O.GRANTEE AND N.PRIVILEGE = O.PRIVILEGE);
-- V5 시노님 — 원본에 있는데 1104 에 없는 시노님 (기대 0행 · 측정에는 무관)
SELECT 'V5' CHK, O.OWNER, '1104 시노님 없음' JUDGE FROM ALL_SYNONYMS O
 WHERE O.TABLE_OWNER = USER AND O.TABLE_NAME = '{ORIG}' AND O.OWNER <> 'PUBLIC'
   AND NOT EXISTS (SELECT 1 FROM ALL_SYNONYMS N WHERE N.OWNER = O.OWNER AND N.TABLE_OWNER = USER AND N.TABLE_NAME = '{PKG}');
-- V6 원본 {ORIG} 무변경 — LAST_DDL 이 00 P1 때와 같아야 한다
SELECT 'V6' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = '{ORIG}' ORDER BY OBJECT_TYPE;
"""

FILES['98_CLEANUP_SPEED_LOG.sql'] = hdr('98_CLEANUP_SPEED_LOG', '측정 기록표 삭제 (40 결과를 보관한 뒤 실행)') + """
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_SPEED';
    IF n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — ZB_DMF0082_1104_SPEED 없음');
    ELSE
        EXECUTE IMMEDIATE 'DROP TABLE ZB_DMF0082_1104_SPEED PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED ZB_DMF0082_1104_SPEED');
    END IF;
END;
/
"""

FILES['99_ROLLBACK.sql'] = hdr('99_ROLLBACK', f'{PKG} 원복 — 적용 전 없었으면 삭제 · 있었으면 백업 원문으로 재생성') + f"""
-- 원본 {ORIG} 는 이 패키지가 바꾸지 않으므로 원복 대상이 아니다. 반복 실행 안전(이미 원복이면 SKIP).
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- 리허설용(TRUE = 판정만 · 변경 없음)
    n       PLS_INTEGER;
    v_none  PLS_INTEGER;
    v_obj   PLS_INTEGER;
    v_code  NUMBER;
    v       CLOB;
    v_st    VARCHAR2(30);
BEGIN
    SELECT COUNT(*) INTO v_obj FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' AND OBJECT_TYPE = 'PACKAGE';
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_BAK';
    IF n = 0 THEN
        IF v_obj = 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP — {PKG} 없음 · 백업표 없음 (이미 원복 또는 미적용)');
            RETURN;
        END IF;
        RAISE_APPLICATION_ERROR(-20021, '중단 — 백업표 ZB_DMF0082_1104_BAK 가 없어 적용 전 상태를 모름. {PKG} 를 그대로 둠 — 회신');
    END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_DMF0082_1104_BAK WHERE OBJ_TYPE = ''NONE''' INTO v_none;
    IF v_none > 0 THEN
        -- 적용 전에 없던 객체 → 시노님 · 패키지 삭제 (권한은 객체와 함께 사라진다)
        FOR s IN (SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = '{PKG}' AND OWNER <> 'PUBLIC') LOOP
            IF c_dry THEN DBMS_OUTPUT.PUT_LINE('DRY     DROP SYNONYM ' || s.OWNER || '.{PKG}');
            ELSE
                BEGIN EXECUTE IMMEDIATE 'DROP SYNONYM ' || s.OWNER || '.{PKG}'; DBMS_OUTPUT.PUT_LINE('DROPPED SYNONYM ' || s.OWNER || '.{PKG}');
                EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('SYNONYM 삭제 실패 ' || s.OWNER || ' — ' || SQLERRM); END;
            END IF;
        END LOOP;
        IF v_obj = 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP — {PKG} 이미 없음');
        ELSIF c_dry THEN
            DBMS_OUTPUT.PUT_LINE('DRY     DROP PACKAGE {PKG}');
        ELSE
            EXECUTE IMMEDIATE 'DROP PACKAGE {PKG}';
            DBMS_OUTPUT.PUT_LINE('ROLLED BACK — DROP PACKAGE {PKG} (적용 전 없던 객체)');
        END IF;
    ELSE
        -- 적용 전에 있던 원문으로 재생성 (SPEC → BODY) · 컴파일 오류(ORA-24344)는 계속 진행해 상태로 판정, 그 밖의 오류는 중단
        FOR t IN (SELECT 'PACKAGE' TP, 1 ORD FROM DUAL UNION ALL SELECT 'PACKAGE BODY', 2 FROM DUAL ORDER BY 2) LOOP
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_DMF0082_1104_BAK WHERE OBJ_TYPE = :1' INTO n USING t.TP;
            IF n = 1 THEN
                EXECUTE IMMEDIATE 'SELECT SRC FROM ZB_DMF0082_1104_BAK WHERE OBJ_TYPE = :1' INTO v USING t.TP;
                IF c_dry THEN DBMS_OUTPUT.PUT_LINE('DRY     RECREATE ' || t.TP || ' {PKG} (' || DBMS_LOB.GETLENGTH(v) || '자)');
                ELSE
                    v_code := 0;
                    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
                    IF v_code NOT IN (0, -24344) THEN
                        RAISE_APPLICATION_ERROR(-20022, '중단 — ' || t.TP || ' 재생성 실패 SQLCODE ' || v_code || ' (실행 중 세션 확인 후 재실행)');
                    END IF;
                    SELECT MAX(STATUS) INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' AND OBJECT_TYPE = t.TP;
                    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — ' || t.TP || ' {PKG} 백업 원문으로 재생성 · ' || v_st);
                END IF;
            END IF;
        END LOOP;
    END IF;
    IF NOT c_dry THEN
        EXECUTE IMMEDIATE 'DROP TABLE ZB_DMF0082_1104_BAK PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED ZB_DMF0082_1104_BAK');
    END IF;
END;
/
SELECT 'R1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME IN ('{ORIG}','{PKG}') ORDER BY 1, 2;
"""

os.makedirs(ADB, exist_ok=True)
for f, t in FILES.items():
    assert '\t' not in t.replace(SPEC, '').replace(BODY, ''), f'{f}: 생성 SQL 에 탭 문자'
    assert '&' not in re.sub(r"'(?:[^']|'')*'", "''", t.replace(SPEC, '').replace(BODY, '')), f'{f}: & 치환 변수'
    open(os.path.join(ADB, f), 'w', encoding='utf-8', newline='\n').write(t)
    print('wrote', f, len(t))
FACTS = {'generated': NOW['S'], 'db': NOW['DB'], 'spec_ddl': sp['LD'], 'body_ddl': bd['LD'], 'orig_body_ddl': od['LD'], 'lines': NLINES,
         'fp_spec': FP_SPEC, 'fp_body': FP_BODY, 'fp_orig_gmd': FP_ORIG_GMD, 'deps': len(DEPS), 'deps_dyn': sum(1 for d in deps if d.get('DYN')),
         'cols': len(COLS), 'grants': GRANTS, 'syns': SYNS}
json.dump(FACTS, open(os.path.join(HERE, '_facts.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


# ───────────────────────── 사내 리허설 ─────────────────────────
def rehearse():
    import run_sql
    R = PKG + 'R'
    r = dbconn.resolve('tobe', dbconn.load_cfg())
    ocx = oracledb.connect(user=OWNER, password=r['password'], dsn=f"{r['host']}:{r['port']}/{r['service']}")
    oc = ocx.cursor(); oc.execute('SELECT USER FROM DUAL'); assert oc.fetchone()[0] == OWNER
    if A.qa:
        oc.execute('ALTER SESSION SET "_optim_peek_user_binds" = FALSE'); oc.execute('ALTER SESSION SET optimizer_adaptive_plans = FALSE')
    log = open(os.path.join(HERE, f"_rehearsal_{'qa_' if A.qa else ''}{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"), 'w', encoding='utf-8')

    def L(s):
        print(s, flush=True); log.write(s + '\n'); log.flush()

    def tf(t, dry=False):
        t = t.replace(PKG, R).replace('ZB_DMF0082_1104_', 'ZB_DMF0082_1104R_')
        t = t.replace('c_runs  CONSTANT PLS_INTEGER := 3;', f'c_runs  CONSTANT PLS_INTEGER := {A.runs};')
        if dry: t = t.replace('c_dry   CONSTANT BOOLEAN := FALSE', 'c_dry   CONSTANT BOOLEAN := TRUE')
        return t

    def run(f, dry=False):
        text = tf(open(os.path.join(ADB, f), encoding='utf-8').read(), dry)
        stmts = run_sql.split_script(text, {})
        oc.callproc('DBMS_OUTPUT.ENABLE', [None])
        fails = 0
        L(f"── {f}{' (DRY)' if dry else ''} · 문장 {len(stmts)} · {datetime.datetime.now().strftime('%H:%M:%S')}")
        for kind, st in stmts:
            sql = st.strip().rstrip(';') if kind != 'block' else st.strip()
            if not sql: continue
            try:
                oc.execute(sql)
                if re.match(r'^\s*(WITH|SELECT)', sql, re.I):
                    rows = oc.fetchall(); cols = [d[0] for d in oc.description]
                    L(f"   SELECT {len(rows)}행 {cols[:12]}")
                    for rw in rows[:12]: L(f"     {tuple(str(x)[:60] for x in rw[:16])}")
                elif re.match(r'^\s*CREATE', sql, re.I):
                    L(f"   {' '.join(sql.split()[:5])} 실행")
            except Exception as e:
                one = ' '.join(sql.split())[:120]
                fails += 1; L(f"   FAIL {str(e).splitlines()[0][:200]} :: {one}")
            lv, stv = oc.var(str), oc.var(int)
            while True:
                oc.callproc('DBMS_OUTPUT.GET_LINE', (lv, stv))
                if stv.getvalue() != 0: break
                L('   > ' + (lv.getvalue() or ''))
        ocx.commit()
        L(f"   → 실패 {fails}")
        return fails

    seq = [('99_ROLLBACK.sql', False), ('00_PRECHECK_CLOUD.sql', False), ('20_CREATE_PKG_DMF0082_1104.sql', False),
           ('20_CREATE_PKG_DMF0082_1104.sql', False), ('90_VERIFY.sql', False), ('30_SPEED_RUN.sql', False), ('40_SPEED_COMPARE.sql', False),
           ('98_CLEANUP_SPEED_LOG.sql', False), ('98_CLEANUP_SPEED_LOG.sql', False), ('99_ROLLBACK.sql', True), ('99_ROLLBACK.sql', False), ('99_ROLLBACK.sql', False)]
    tot = 0
    for k, (f, dry) in enumerate(seq):
        tot += run(f, dry)
        if f.startswith('20_') and k == 2:
            # 리허설 객체 원문 == 사내 1104 원문(이름만 1104R) 글자 단위 대조 — V3 지문은 이름 1글자 차이로 리허설에선 FAIL 이 정상
            for typ, want in (('PACKAGE', SPEC), ('PACKAGE BODY', BODY)):
                oc.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME = :n AND TYPE = :t ORDER BY LINE", n=R, t=typ)
                got = ''.join(r[0] or '' for r in oc.fetchall())
                exp = want.replace(PKG, R)
                same = got.rstrip() == exp.rstrip()
                L(f"   원문 대조 {typ}: {'동일' if same else '불일치'} (리허설 {len(got)}자 · 사내 1104 치환본 {len(exp)}자)")
                if not same: tot += 1
    oc.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE OBJECT_NAME = :n", n=R); left = oc.fetchone()[0]
    oc.execute("SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB\\_DMF0082\\_1104R\\_%' ESCAPE '\\'"); zb = oc.fetchone()[0]
    L(f"== 리허설 끝 · 문장 실패 합계 {tot} · 남은 {R} 객체 {zb and ''}{left} · 남은 ZB 표 {zb}")
    ocx.close()


if A.rehearse:
    rehearse()
