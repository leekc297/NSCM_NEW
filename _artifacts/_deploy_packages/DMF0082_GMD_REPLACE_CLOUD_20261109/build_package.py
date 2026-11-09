# -*- coding: utf-8 -*-
"""PKG_DMF0082.P_DMF0082_GET_MAIN_DATA ← PKG_DMF0082_1104 의 같은 구간으로 교체 — 클라우드 이관 패키지 생성기 (2026-11-09)
마커 [E20261104-DMF0082ONEQUERY]

방식(구간 교체): 실행 DB 자기 USER_SOURCE 에서
  새 BODY = PKG_DMF0082 의 GET_MAIN_DATA 앞 줄들 + PKG_DMF0082_1104 의 GET_MAIN_DATA 구간 + PKG_DMF0082 의 GET_MAIN_DATA 뒤 줄들
  구간 = 'PROCEDURE P_DMF0082_GET_MAIN_DATA' 줄 ~ 'PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO' 줄 직전 (각 1건이어야 함 · 아니면 중단)
  → 사내 원문 문자열을 싣지 않으므로 클라우드 PKG_DMF0082 의 다른 프로시저(세대가 다를 수 있음)는 그대로 남는다.
  전제: 클라우드에 PKG_DMF0082_1104 가 있고 그 GET_MAIN_DATA 구간 지문 = 사내 1104(apply #26) 지문 (00 이 확인).

  python -I build_package.py               # A_DB/*.sql 생성
  python -I build_package.py --rehearse    # + 사내 리허설(대상 = 원본 복제 PKG_DMF0082RH · 실패 복원 시험용 PKG_DMF0082RHX · 끝에 삭제)
금지: 클라우드 접속 · 사내 PKG_DMF0082 / PKG_DMF0082_1104 변경(리허설은 RH/RHX 사본만 만들고 지운다).
"""
import sys, os, re, json, datetime, argparse
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ADB = os.path.join(HERE, 'A_DB')
OWNER = 'SCM_MGR'
TGT, SRC = 'PKG_DMF0082', 'PKG_DMF0082_1104'
EXPECT_SRC_BODY_DDL = '2026-11-06 06:09:06'
MARK = 'E20261104-DMF0082ONEQUERY'
RS = r"^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)"
RE_ = r"^\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)"   # Oracle 정규식 \b 미지원
NORM = "RTRIM(TEXT, ' ' || CHR(9) || CHR(10) || CHR(13))"

ap = argparse.ArgumentParser(); ap.add_argument('--rehearse', action='store_true')
A = ap.parse_args()
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()


def q(sql, **b):
    c.execute(sql, **b); cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


NOW = q("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') N, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') S, SYS_CONTEXT('USERENV','DB_NAME') DB FROM DUAL")[0]
ob = {r['OBJECT_NAME']: r for r in q("SELECT OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LD FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME IN (:a,:b) AND OBJECT_TYPE='PACKAGE BODY'", o=OWNER, a=TGT, b=SRC)}
assert ob[SRC]['LD'] == EXPECT_SRC_BODY_DDL and ob[SRC]['STATUS'] == 'VALID', f'FRESH-GATE FAIL {SRC} {ob[SRC]}'


def lines(n):
    return [r['TEXT'] or '' for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=OWNER, n=n)]


def rng(L):
    s = [i for i, t in enumerate(L) if re.match(r'\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)', t)]
    e = [i for i, t in enumerate(L) if re.match(r'\s*PROCEDURE\s+P_DMF0082_POPUP_GET_FUTUREPRICE_INFO(\s|\(|$)', t)]
    assert len(s) == 1 and len(e) == 1 and s[0] < e[0], (s, e)
    return s[0], e[0]


def fp_py(L):
    """정규화 지문 — SQL 식과 같은 값이 나오는지 DB 로 계산(ORA_HASH 는 파이썬 재현 불가) → 범위 SQL 로 대체"""
    raise NotImplementedError


SL = lines(SRC); TL = lines(TGT)
ss, se = rng(SL); ts, te = rng(TL)
GMD_SRC = SL[ss:se]
assert not any(SRC in t for t in GMD_SRC), '1104 GET_MAIN_DATA 구간에 자기 이름 참조 — 이름 치환 필요'


def fp_sql(name, mode):
    """mode: GMD = 구간 · OUT = 구간 밖 — 클라우드 00/90 과 같은 식"""
    cond = ("S.LINE >= R.L1 AND S.LINE < R.L2" if mode == 'GMD' else "(S.LINE < R.L1 OR S.LINE >= R.L2)")
    return f"""WITH R AS (SELECT (SELECT MIN(LINE) FROM {{SRCV}} WHERE {{OWN}}NAME='{name}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{RS}')) L1,
                  (SELECT MIN(LINE) FROM {{SRCV}} WHERE {{OWN}}NAME='{name}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{RE_}')) L2 FROM DUAL)
SELECT COUNT(*) N, NVL(SUM(LENGTH({NORM})), 0) L, NVL(SUM(ORA_HASH({NORM})), 0) H FROM {{SRCV}} S, R
 WHERE S.{{OWN}}NAME='{name}' AND S.TYPE='PACKAGE BODY' AND {cond} AND {NORM} IS NOT NULL"""


def fp_corp(name, mode):
    sql = fp_sql(name, mode).replace('{SRCV}', 'ALL_SOURCE').replace("{OWN}NAME", "OWNER='SCM_MGR' AND NAME").replace('S.{OWN}NAME', 'S.NAME')
    sql = sql.replace("S.OWNER='SCM_MGR' AND NAME", "S.OWNER='SCM_MGR' AND S.NAME")
    r = q(sql)[0]; return int(r['N']), int(r['L']), int(r['H'])


FP_SRC_GMD = fp_corp(SRC, 'GMD')
FP_TGT_GMD_CORP = fp_corp(TGT, 'GMD')
print(f"FRESH {NOW['S']} · {SRC} BODY {ob[SRC]['LD']} GMD {se - ss}줄 지문 {FP_SRC_GMD} · 사내 {TGT} BODY {ob[TGT]['LD']} GMD 지문 {FP_TGT_GMD_CORP}")


def fp_user(name, mode):
    return fp_sql(name, mode).replace('{SRCV}', 'USER_SOURCE').replace('{OWN}', '')


HDR = f"""/* =====================================================================================================
 * DMF0082 GET_MAIN_DATA 교체 · {{FILE}} — {{TITLE}}
 * 마커 [{MARK}] · 생성 {NOW['S']} (사내 {NOW['DB']}) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 교체 = {{TGT}} 의 P_DMF0082_GET_MAIN_DATA 구간 ← {{SRC}} 의 같은 구간 (이 DB 의 USER_SOURCE 끼리 · 나머지 프로시저 무변경)
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
"""


def files(tgt, src, zb):
    """tgt/src/zb 를 인자로 받아 리허설(사본 이름)에도 같은 생성식을 쓴다"""
    B = f'{zb}_BAK'; F = f'{zb}_FP'
    H = lambda f, t: HDR.replace('{FILE}', f).replace('{TITLE}', t).replace('{TGT}', tgt).replace('{SRC}', src)
    anchor_fn = f"""    FUNCTION anc(p_name VARCHAR2, p_re VARCHAR2) RETURN PLS_INTEGER IS
        r PLS_INTEGER; k PLS_INTEGER;
    BEGIN
        SELECT MIN(LINE), COUNT(*) INTO r, k FROM USER_SOURCE WHERE NAME = p_name AND TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(TEXT, p_re);
        IF k <> 1 THEN
            RAISE_APPLICATION_ERROR(-20031, '중단 — ' || p_name || ' 구간 경계 ' || k || '건(1건이어야 함) · 원문 무변경 · 회신: ' || p_re);
        END IF;
        RETURN r;
    END;
"""
    F_ = {}
    F_['00_PRECHECK_CLOUD.sql'] = H('00_PRECHECK_CLOUD', '교체 전 점검 (조회 전용)') + f"""
-- G0 접속
SELECT 'G0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, USER CUR_USER, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW_TIME FROM DUAL;
-- G1 객체 상태 — 기대: {tgt} · {src} PACKAGE/BODY 모두 VALID ({src} 는 앞 패키지 DMF0082_1104_CLOUD_20261109 의 20 으로 만든 것)
SELECT 'G1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME IN ('{tgt}','{src}') ORDER BY 1, 2;
-- G2 구간 경계 — 기대: 4행 모두 N = 1
SELECT 'G2' CHK, '{tgt}' PKG, 'START' EDGE, COUNT(*) N, MIN(LINE) LINE_NO FROM USER_SOURCE WHERE NAME='{tgt}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{RS}')
UNION ALL SELECT 'G2', '{tgt}', 'END', COUNT(*), MIN(LINE) FROM USER_SOURCE WHERE NAME='{tgt}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{RE_}')
UNION ALL SELECT 'G2', '{src}', 'START', COUNT(*), MIN(LINE) FROM USER_SOURCE WHERE NAME='{src}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{RS}')
UNION ALL SELECT 'G2', '{src}', 'END', COUNT(*), MIN(LINE) FROM USER_SOURCE WHERE NAME='{src}' AND TYPE='PACKAGE BODY' AND REGEXP_LIKE(TEXT, '{RE_}');
-- G3 {src} 의 GET_MAIN_DATA 구간이 사내 검증본(apply #26)과 같은지 — 기대 SAME (사내 지문 줄 {FP_SRC_GMD[0]} · 길이 {FP_SRC_GMD[1]} · 해시합 {FP_SRC_GMD[2]})
SELECT 'G3' CHK, X.N, X.L, X.H, CASE WHEN X.N = {FP_SRC_GMD[0]} AND X.L = {FP_SRC_GMD[1]} AND X.H = {FP_SRC_GMD[2]} THEN 'SAME'
            WHEN X.N = {FP_SRC_GMD[0]} AND X.L = {FP_SRC_GMD[1]} THEN 'SAME? (줄·길이 같음 · 해시만 다름)' ELSE 'DIFF — 중단 · 회신' END JUDGE
  FROM ({fp_user(src, 'GMD')}) X;
-- G4 {tgt} 현재 GET_MAIN_DATA 구간 — 참고: 사내 원본(교체 전) 지문 줄 {FP_TGT_GMD_CORP[0]} · 길이 {FP_TGT_GMD_CORP[1]} · 해시합 {FP_TGT_GMD_CORP[2]}
--    ALREADY = 이미 교체됨(20 은 SKIP) · ORIG_SAME_AS_CORP = 사내 원본과 같음 · ORIG_DIFF = 클라우드 원본이 사내와 다른 세대(교체는 그대로 가능 — 이 구간 전체가 1104 로 바뀜)
SELECT 'G4' CHK, X.N, X.L, X.H,
       CASE WHEN X.N = {FP_SRC_GMD[0]} AND X.L = {FP_SRC_GMD[1]} AND X.H = {FP_SRC_GMD[2]} THEN 'ALREADY'
            WHEN X.N = {FP_TGT_GMD_CORP[0]} AND X.L = {FP_TGT_GMD_CORP[1]} AND X.H = {FP_TGT_GMD_CORP[2]} THEN 'ORIG_SAME_AS_CORP' ELSE 'ORIG_DIFF' END JUDGE
  FROM ({fp_user(tgt, 'GMD')}) X;
-- G5 {tgt} 실행 중 세션 (V$SESSION 권한 없으면 안내만 출력) — 기대 0. 0 이 아니면 화면 조회가 끝난 뒤 20 실행
DECLARE
    n PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE q'[SELECT COUNT(*) FROM V$SESSION S WHERE S.STATUS = 'ACTIVE' AND S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' AND OBJECT_TYPE = 'PACKAGE')]' INTO n;
    DBMS_OUTPUT.PUT_LINE('G5 {tgt} 실행 중 세션 ' || n || CASE WHEN n = 0 THEN ' (기대)' ELSE ' — 끝난 뒤 20 실행' END);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('G5 V$SESSION 조회 권한 없음 — DMF0082 조회·저장이 돌지 않는 시간에 20 실행 (' || SQLCODE || ')');
END;
/
"""
    F_['10_BACKUP_PKG_DMF0082.sql'] = H('10_BACKUP_PKG_DMF0082', f'{tgt} 백업 (SPEC·BODY 원문 + 지문) — 반복 실행 안전 · 첫 실행 상태만 보존') + f"""
DECLARE
    n   PLS_INTEGER;
    v   CLOB;
    l1  PLS_INTEGER;
    l2  PLS_INTEGER;
    xn  NUMBER; xl NUMBER; xh NUMBER;
{anchor_fn}BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{B}';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {B} (OBJ_TYPE VARCHAR2(30), SRC CLOB, LAST_DDL VARCHAR2(20), SAVED_AT DATE)';
        EXECUTE IMMEDIATE 'CREATE TABLE {F} (KIND VARCHAR2(30), N NUMBER, L NUMBER, H NUMBER, INFO VARCHAR2(200), SAVED_AT DATE)';
    END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM {B}' INTO n;
    IF n > 0 THEN
        DBMS_OUTPUT.PUT_LINE('BACKUP  SKIP — 백업 이미 있음(첫 실행 상태 보존)');
        RETURN;
    END IF;
    l1 := anc('{tgt}', '{RS}'); l2 := anc('{tgt}', '{RE_}');
    FOR t IN (SELECT 'PACKAGE' TP FROM DUAL UNION ALL SELECT 'PACKAGE BODY' FROM DUAL) LOOP
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{tgt}' AND TYPE = t.TP ORDER BY LINE) LOOP
            IF r.TEXT IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT); END IF;
        END LOOP;
        EXECUTE IMMEDIATE 'INSERT INTO {B} (OBJ_TYPE, SRC, LAST_DDL, SAVED_AT) SELECT :1, :2, TO_CHAR(LAST_DDL_TIME, ''YYYY-MM-DD HH24:MI:SS''), SYSDATE FROM USER_OBJECTS WHERE OBJECT_NAME = :3 AND OBJECT_TYPE = :4'
            USING t.TP, v, '{tgt}', t.TP;
        DBMS_OUTPUT.PUT_LINE('BACKUP  ' || t.TP || ' {tgt} (' || DBMS_LOB.GETLENGTH(v) || '자)');
        DBMS_LOB.FREETEMPORARY(v);
    END LOOP;
    -- 지문: 구간(GMD_OLD) · 구간 밖(OUT) — 90 이 '구간 밖 무변경'을 이 값으로 확인
    SELECT COUNT(*), NVL(SUM(LENGTH({NORM})), 0), NVL(SUM(ORA_HASH({NORM})), 0) INTO xn, xl, xh FROM USER_SOURCE
     WHERE NAME = '{tgt}' AND TYPE = 'PACKAGE BODY' AND LINE >= l1 AND LINE < l2 AND {NORM} IS NOT NULL;
    EXECUTE IMMEDIATE 'INSERT INTO {F} VALUES (''GMD_OLD'', :1, :2, :3, :4, SYSDATE)' USING xn, xl, xh, l1 || '~' || (l2 - 1);
    SELECT COUNT(*), NVL(SUM(LENGTH({NORM})), 0), NVL(SUM(ORA_HASH({NORM})), 0) INTO xn, xl, xh FROM USER_SOURCE
     WHERE NAME = '{tgt}' AND TYPE = 'PACKAGE BODY' AND (LINE < l1 OR LINE >= l2) AND {NORM} IS NOT NULL;
    EXECUTE IMMEDIATE 'INSERT INTO {F} VALUES (''OUT'', :1, :2, :3, NULL, SYSDATE)' USING xn, xl, xh;
    SELECT COUNT(*) INTO n FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = '{tgt}';
    EXECUTE IMMEDIATE 'INSERT INTO {F} VALUES (''GRANTS'', :1, NULL, NULL, NULL, SYSDATE)' USING n;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('BACKUP  지문 저장 · 구간 ' || l1 || '~' || (l2 - 1) || ' · 권한 ' || n || '건');
END;
/
SELECT 'B1' CHK, OBJ_TYPE, DBMS_LOB.GETLENGTH(SRC) SRC_LEN, LAST_DDL, TO_CHAR(SAVED_AT, 'YYYY-MM-DD HH24:MI:SS') SAVED_AT FROM {B} ORDER BY 2;
SELECT 'B2' CHK, KIND, N, L, H, INFO FROM {F} ORDER BY 2;
"""
    F_['20_APPLY_GMD_REPLACE.sql'] = H('20_APPLY_GMD_REPLACE', f'{tgt}.P_DMF0082_GET_MAIN_DATA ← {src} 구간 (컴파일 실패 시 백업 원문 자동 복원)') + f"""
-- 반복 실행 안전: 이미 교체됐으면 SKIP. 10 백업이 없으면 중단(원문 무변경).
-- 컴파일 오류(ORA-24344)면 오류 목록을 출력하고 백업 원문으로 즉시 복원한다. 그 밖의 오류(예: 실행 중 세션 잠금 ORA-04021)는 생성 자체가 안 된 것이므로 원문 그대로 중단.
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- 리허설용(TRUE = 조립·판정만 · 변경 없음)
    t1 PLS_INTEGER; t2 PLS_INTEGER; s1 PLS_INTEGER; s2 PLS_INTEGER;
    n  PLS_INTEGER;
    v  CLOB;
    bk CLOB;
    v_code NUMBER;
    v_st   VARCHAR2(30);
    an NUMBER; al NUMBER; ah NUMBER; bn NUMBER; bl NUMBER; bh NUMBER;
{anchor_fn}    PROCEDURE app(p_name VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) IS
    BEGIN
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_name AND TYPE = 'PACKAGE BODY' AND LINE >= p_from AND LINE <= p_to ORDER BY LINE) LOOP
            IF r.TEXT IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT); END IF;
        END LOOP;
    END;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{B}';
    IF n = 0 THEN RAISE_APPLICATION_ERROR(-20030, '중단 — 백업표 {B} 없음 · 10_BACKUP 먼저 실행 · 원문 무변경'); END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM {B} WHERE OBJ_TYPE = ''PACKAGE BODY''' INTO n;
    IF n <> 1 THEN RAISE_APPLICATION_ERROR(-20030, '중단 — 백업표에 BODY 원문 없음 · 원문 무변경'); END IF;
    t1 := anc('{tgt}', '{RS}'); t2 := anc('{tgt}', '{RE_}');
    s1 := anc('{src}', '{RS}'); s2 := anc('{src}', '{RE_}');
    -- 이미 교체됐는지: {tgt} 구간 지문 = {src} 구간 지문
    SELECT COUNT(*), NVL(SUM(LENGTH({NORM})), 0), NVL(SUM(ORA_HASH({NORM})), 0) INTO an, al, ah FROM USER_SOURCE
     WHERE NAME = '{tgt}' AND TYPE = 'PACKAGE BODY' AND LINE >= t1 AND LINE < t2 AND {NORM} IS NOT NULL;
    SELECT COUNT(*), NVL(SUM(LENGTH({NORM})), 0), NVL(SUM(ORA_HASH({NORM})), 0) INTO bn, bl, bh FROM USER_SOURCE
     WHERE NAME = '{src}' AND TYPE = 'PACKAGE BODY' AND LINE >= s1 AND LINE < s2 AND {NORM} IS NOT NULL;
    IF an = bn AND al = bl AND ah = bh THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 교체됨 ({tgt} GET_MAIN_DATA = {src} 구간 · ' || an || '줄)');
        RETURN;
    END IF;
    IF bn <> {FP_SRC_GMD[0]} OR bl <> {FP_SRC_GMD[1]} THEN
        RAISE_APPLICATION_ERROR(-20033, '중단 — {src} 구간이 사내 검증본과 다름(줄 ' || bn || ' · 길이 ' || bl || ' / 기대 {FP_SRC_GMD[0]} · {FP_SRC_GMD[1]}) · 원문 무변경');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    app('{tgt}', 1, t1 - 1);
    app('{src}', s1, s2 - 1);
    app('{tgt}', t2, 999999999);
    DBMS_OUTPUT.PUT_LINE('조립 — {tgt} 1~' || (t1 - 1) || ' + {src} ' || s1 || '~' || (s2 - 1) || ' + {tgt} ' || t2 || '~끝 = ' || DBMS_LOB.GETLENGTH(v) || '자');
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('DRY     변경 없음');
        RETURN;
    END IF;
    v_code := 0;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20034, '중단 — 생성 미실행 SQLCODE ' || v_code || ' (실행 중 세션 잠금 등) · 원문 그대로 · 세션 확인 후 재실행');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' AND OBJECT_TYPE = 'PACKAGE BODY';
    IF v_st = 'VALID' THEN
        DBMS_OUTPUT.PUT_LINE('APPLIED — {tgt} BODY VALID · GET_MAIN_DATA 교체 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('컴파일 오류 — 아래 오류를 회신해 주세요 (원문으로 자동 복원합니다)');
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{tgt}' AND TYPE = 'PACKAGE BODY' AND ROWNUM <= 30 ORDER BY SEQUENCE) LOOP
            DBMS_OUTPUT.PUT_LINE('  L' || e.LINE || ':' || e.POSITION || ' ' || SUBSTR(e.TEXT, 1, 300));
        END LOOP;
        EXECUTE IMMEDIATE 'SELECT SRC FROM {B} WHERE OBJ_TYPE = ''PACKAGE BODY''' INTO bk;
        v_code := 0;
        BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || bk; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' AND OBJECT_TYPE = 'PACKAGE BODY';
        DBMS_OUTPUT.PUT_LINE('RESTORED — 백업 원문으로 복원 · ' || v_st || ' (SQLCODE ' || v_code || ')');
        RAISE_APPLICATION_ERROR(-20035, '교체 실패 · 원문 복원 ' || v_st || ' — 위 오류 회신');
    END IF;
END;
/
SELECT 'A1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' ORDER BY OBJECT_TYPE;
SELECT 'A2' CHK, TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{tgt}' ORDER BY TYPE, SEQUENCE;
"""
    F_['90_VERIFY.sql'] = H('90_VERIFY', '교체 확인 (조회 전용)') + f"""
-- V1 상태 — 기대 PACKAGE · PACKAGE BODY VALID
SELECT 'V1' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' ORDER BY OBJECT_TYPE;
-- V2 오류 — 기대 0
SELECT 'V2' CHK, COUNT(*) ERR_CNT, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END JUDGE FROM USER_ERRORS WHERE NAME = '{tgt}';
-- V3 GET_MAIN_DATA 구간 = 사내 검증본(apply #26) — 기대 PASS
SELECT 'V3' CHK, X.N, X.L, X.H, CASE WHEN X.N = {FP_SRC_GMD[0]} AND X.L = {FP_SRC_GMD[1]} AND X.H = {FP_SRC_GMD[2]} THEN 'PASS'
            WHEN X.N = {FP_SRC_GMD[0]} AND X.L = {FP_SRC_GMD[1]} THEN 'PASS? (해시만 다름)' ELSE 'FAIL' END JUDGE
  FROM ({fp_user(tgt, 'GMD')}) X;
-- V4 구간 밖(다른 프로시저) 무변경 — 10 백업 때 지문과 같아야 PASS
SELECT 'V4' CHK, X.N, X.L, X.H, B.N BAK_N, B.L BAK_L, B.H BAK_H, CASE WHEN X.N = B.N AND X.L = B.L AND X.H = B.H THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM ({fp_user(tgt, 'OUT')}) X, {F} B WHERE B.KIND = 'OUT';
-- V5 SPEC 무변경 · 권한 수 유지
SELECT 'V5' CHK, 'SPEC LAST_DDL' ITEM, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') NOW_VAL, B.LAST_DDL BAK_VAL,
       CASE WHEN TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') = B.LAST_DDL THEN 'PASS' ELSE 'FAIL' END JUDGE
  FROM USER_OBJECTS O, {B} B WHERE O.OBJECT_NAME = '{tgt}' AND O.OBJECT_TYPE = 'PACKAGE' AND B.OBJ_TYPE = 'PACKAGE'
UNION ALL
SELECT 'V5', 'GRANTS', TO_CHAR((SELECT COUNT(*) FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = '{tgt}')), TO_CHAR(F.N),
       CASE WHEN (SELECT COUNT(*) FROM USER_TAB_PRIVS_MADE WHERE TABLE_NAME = '{tgt}') = F.N THEN 'PASS' ELSE 'FAIL' END
  FROM {F} F WHERE F.KIND = 'GRANTS';
"""
    F_['98_CLEANUP_BACKUP.sql'] = H('98_CLEANUP_BACKUP', '백업표 삭제 — 화면 확인까지 끝나고 원복 가능성이 없을 때만') + f"""
-- 이 파일을 실행하면 99 원복을 할 수 없다. 화면 조회·저장 확인 후 실행한다.
DECLARE
    n PLS_INTEGER;
BEGIN
    FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME IN ('{B}', '{F}')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED ' || t.TABLE_NAME);
    END LOOP;
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME IN ('{B}', '{F}');
    IF n = 0 THEN DBMS_OUTPUT.PUT_LINE('백업표 없음'); END IF;
END;
/
"""
    F_['99_ROLLBACK.sql'] = H('99_ROLLBACK', f'{tgt} BODY 를 10 백업 원문으로 되돌림') + f"""
-- 반복 실행 안전: 이미 백업 원문과 같으면 SKIP. SPEC 은 이 패키지가 바꾸지 않으므로 BODY 만 되돌린다.
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- 리허설용(TRUE = 판정만)
    n  PLS_INTEGER;
    bk CLOB;
    v_code NUMBER;
    v_st   VARCHAR2(30);
    xn NUMBER; xl NUMBER; xh NUMBER;
    gn NUMBER; gl NUMBER; gh NUMBER;
    t1 PLS_INTEGER; t2 PLS_INTEGER;
{anchor_fn}BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{B}';
    IF n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 백업표 {B} 없음 (교체 전이거나 98 로 정리됨)');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'SELECT N, L, H FROM {F} WHERE KIND = ''GMD_OLD''' INTO gn, gl, gh;
    t1 := anc('{tgt}', '{RS}'); t2 := anc('{tgt}', '{RE_}');
    SELECT COUNT(*), NVL(SUM(LENGTH({NORM})), 0), NVL(SUM(ORA_HASH({NORM})), 0) INTO xn, xl, xh FROM USER_SOURCE
     WHERE NAME = '{tgt}' AND TYPE = 'PACKAGE BODY' AND LINE >= t1 AND LINE < t2 AND {NORM} IS NOT NULL;
    IF xn = gn AND xl = gl AND xh = gh THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — {tgt} GET_MAIN_DATA 가 이미 백업 원문과 같음');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'SELECT SRC FROM {B} WHERE OBJ_TYPE = ''PACKAGE BODY''' INTO bk;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('DRY     백업 BODY ' || DBMS_LOB.GETLENGTH(bk) || '자로 되돌릴 예정');
        RETURN;
    END IF;
    v_code := 0;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || bk; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20036, '중단 — 원복 생성 미실행 SQLCODE ' || v_code || ' · 실행 중 세션 확인 후 재실행');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' AND OBJECT_TYPE = 'PACKAGE BODY';
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {tgt} BODY 백업 원문 · ' || v_st);
END;
/
SELECT 'R1' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = '{tgt}' ORDER BY 1;
-- R2 GET_MAIN_DATA 구간이 백업 원문과 같은지 (백업표가 없으면 안내만 출력)
DECLARE
    n PLS_INTEGER;
    xn NUMBER; xl NUMBER; xh NUMBER; gn NUMBER; gl NUMBER; gh NUMBER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{F}';
    IF n = 0 THEN DBMS_OUTPUT.PUT_LINE('R2 백업표 없음 — 비교 생략'); RETURN; END IF;
    SELECT N, L, H INTO xn, xl, xh FROM ({fp_user(tgt, 'GMD')});
    EXECUTE IMMEDIATE 'SELECT N, L, H FROM {F} WHERE KIND = ''GMD_OLD''' INTO gn, gl, gh;
    DBMS_OUTPUT.PUT_LINE('R2 GET_MAIN_DATA 구간 ' || xn || '줄 · 백업 ' || gn || '줄 → '
        || CASE WHEN xn = gn AND xl = gl AND xh = gh THEN 'PASS — 백업 원문과 같음' ELSE '백업 원문과 다름(교체 상태)' END);
END;
/
"""
    return F_


FILES = files(TGT, SRC, 'ZB_DMF0082_GMD')
os.makedirs(ADB, exist_ok=True)
for f, t in FILES.items():
    assert '\t' not in t, f'{f}: 탭'
    assert '&' not in re.sub(r"'(?:[^']|'')*'", "''", t), f'{f}: &'
    open(os.path.join(ADB, f), 'w', encoding='utf-8', newline='\n').write(t)
    print('wrote', f, len(t))
json.dump({'generated': NOW['S'], 'src_body_ddl': ob[SRC]['LD'], 'tgt_body_ddl_corp': ob[TGT]['LD'], 'fp_src_gmd': FP_SRC_GMD, 'fp_tgt_gmd_corp': FP_TGT_GMD_CORP,
           'src_gmd_lines': [ss + 1, se], 'tgt_gmd_lines_corp': [ts + 1, te]}, open(os.path.join(HERE, '_facts.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


# ───────────────────────── 사내 리허설 ─────────────────────────
def rehearse():
    import run_sql
    RH, RHX = 'PKG_DMF0082RH', 'PKG_DMF0082RHX'
    r = dbconn.resolve('tobe', dbconn.load_cfg())
    ocx = oracledb.connect(user=OWNER, password=r['password'], dsn=f"{r['host']}:{r['port']}/{r['service']}")
    oc = ocx.cursor(); oc.execute('SELECT USER FROM DUAL'); assert oc.fetchone()[0] == OWNER
    log = open(os.path.join(HERE, f"_rehearsal_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.log"), 'w', encoding='utf-8')
    fails = [0]

    def L(s):
        print(s, flush=True); log.write(s + '\n'); log.flush()

    def src_of(name, typ):
        oc.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME = :n AND TYPE = :t ORDER BY LINE", n=name, t=typ)
        return ''.join(x[0] or '' for x in oc.fetchall())

    def mk(name, spec, body, expect_err=False):
        for s in (spec, body):
            try:
                oc.execute('CREATE OR REPLACE ' + s)
            except Exception as e:
                if not expect_err: raise
                L(f'   (의도한 컴파일 오류) {str(e).splitlines()[0][:100]}')
        oc.execute("SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = :n ORDER BY 1", n=name)
        L(f'   사본 {name} {oc.fetchall()}')

    def run(fset, f, dry=False):
        text = fset[f]
        if dry: text = text.replace('c_dry   CONSTANT BOOLEAN := FALSE', 'c_dry   CONSTANT BOOLEAN := TRUE')
        oc.callproc('DBMS_OUTPUT.ENABLE', [None])
        st = run_sql.split_script(text, {})
        L(f"── {f}{' (DRY)' if dry else ''} · 문장 {len(st)} · {datetime.datetime.now().strftime('%H:%M:%S')}")
        nf = 0
        for kind, s in st:
            sql = s.strip() if kind == 'block' else s.strip().rstrip(';')
            if not sql: continue
            try:
                oc.execute(sql)
                if re.match(r'^\s*(WITH|SELECT)', sql, re.I):
                    rows = oc.fetchall()
                    L(f"   SELECT {len(rows)}행 {[d[0] for d in oc.description][:9]}")
                    for rw in rows[:8]: L(f"     {tuple(str(x)[:44] for x in rw[:9])}")
            except Exception as e:
                nf += 1; L(f"   FAIL {str(e).splitlines()[0][:220]}")
            lv, sv = oc.var(str), oc.var(int)
            while True:
                oc.callproc('DBMS_OUTPUT.GET_LINE', (lv, sv))
                if sv.getvalue() != 0: break
                L('   > ' + (lv.getvalue() or ''))
        ocx.commit()
        return nf

    def expect(n, want, what):
        ok = (n == want)
        L(f"   ⇒ {what}: 실패 문장 {n} (기대 {want}) {'OK' if ok else '✗'}")
        if not ok: fails[0] += 1

    orig_spec, orig_body = src_of(TGT, 'PACKAGE'), src_of(TGT, 'PACKAGE BODY')
    src_body = src_of(SRC, 'PACKAGE BODY')
    ren = lambda s, a: re.sub(r'\bPKG_DMF0082\b', a, s)
    # 대상 사본 RH = 사내 원본(이름만 RH)
    for nm in (RH, RHX):
        oc.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE OBJECT_NAME = :n", n=nm)
        if oc.fetchone()[0]: oc.execute(f'DROP PACKAGE {nm}')
    for t in ('ZB_DMF0082RH_BAK', 'ZB_DMF0082RH_FP'):
        oc.execute("SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME = :t", t=t)
        if oc.fetchone()[0]: oc.execute(f'DROP TABLE {t} PURGE')
    L(f"== 리허설 시작 {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    mk(RH, ren(orig_spec, RH), ren(orig_body, RH))
    FR = files(RH, SRC, 'ZB_DMF0082RH')
    expect(run(FR, '99_ROLLBACK.sql'), 0, '99 백업 없음 SKIP')
    expect(run(FR, '00_PRECHECK_CLOUD.sql'), 0, '00')
    expect(run(FR, '20_APPLY_GMD_REPLACE.sql'), 1, '20 백업 없이 실행 → -20030 중단(의도)')
    expect(run(FR, '10_BACKUP_PKG_DMF0082.sql'), 0, '10 백업')
    expect(run(FR, '10_BACKUP_PKG_DMF0082.sql'), 0, '10 재실행 SKIP')
    expect(run(FR, '20_APPLY_GMD_REPLACE.sql', dry=True), 0, '20 DRY')
    if src_of(RH, 'PACKAGE BODY') != ren(orig_body, RH): fails[0] += 1; L('   ✗ DRY 인데 원문 변경됨')
    expect(run(FR, '20_APPLY_GMD_REPLACE.sql'), 0, '20 교체')
    # 기대 원문 = 원본 구간 밖 + 1104 구간 (이름 RH)
    OL = ren(orig_body, RH).splitlines(keepends=True)
    os_, oe_ = rng(OL); NL = src_body.splitlines(keepends=True); ns_, ne_ = rng(NL)
    want = ''.join(OL[:os_] + NL[ns_:ne_] + OL[oe_:])
    got = src_of(RH, 'PACKAGE BODY')
    same = got.rstrip() == want.rstrip()
    L(f"   원문 대조(교체본 = 원본 구간 밖 + 1104 구간): {'동일' if same else '불일치'} ({len(got)}자 / 기대 {len(want)}자)")
    if not same: fails[0] += 1
    # 1104 본체와도 같아야 함(사내는 구간 밖이 원본과 동일하므로)
    same2 = got.rstrip() == re.sub(r'\bPKG_DMF0082_1104\b', RH, src_body).rstrip()
    L(f"   원문 대조(교체본 = 사내 1104 전체 · 이름만 다름): {'동일' if same2 else '불일치'}")
    if not same2: fails[0] += 1
    expect(run(FR, '20_APPLY_GMD_REPLACE.sql'), 0, '20 재실행 SKIP')
    expect(run(FR, '90_VERIFY.sql'), 0, '90')
    expect(run(FR, '99_ROLLBACK.sql', dry=True), 0, '99 DRY')
    expect(run(FR, '99_ROLLBACK.sql'), 0, '99 원복')
    back = src_of(RH, 'PACKAGE BODY').rstrip() == ren(orig_body, RH).rstrip()
    L(f"   원문 대조(원복본 = 교체 전 원문): {'동일' if back else '불일치'}")
    if not back: fails[0] += 1
    expect(run(FR, '99_ROLLBACK.sql'), 0, '99 재실행 SKIP')
    expect(run(FR, '20_APPLY_GMD_REPLACE.sql'), 0, '20 재교체')
    expect(run(FR, '90_VERIFY.sql'), 0, '90 재확인')
    # 컴파일 실패 → 자동 복원 경로: SRC 를 구간에 문법 오류를 넣은 RHX 로
    expect(run(FR, '99_ROLLBACK.sql'), 0, '99 원복(복원 시험 준비)')
    bad = re.sub(r'\bPKG_DMF0082_1104\b', RHX, src_body)
    bl = bad.splitlines(keepends=True); bs, be = rng(bl)
    bl.insert(bs + 3, '    THIS_IS_A_SYNTAX_ERROR_FOR_RESTORE_TEST ;\n')
    bad = ''.join(bl)
    mk(RHX, re.sub(r'\bPKG_DMF0082_1104\b', RHX, src_of(SRC, 'PACKAGE')), bad, expect_err=True)
    FX = files(RH, RHX, 'ZB_DMF0082RH')
    # RHX 구간 지문은 사내 검증본과 다르므로 -20033 으로 막혀야 한다(가드 시험)
    expect(run(FX, '20_APPLY_GMD_REPLACE.sql'), 1, '20 다른 구간(RHX) → -20033 중단(의도)')
    # 가드를 우회해 실제 컴파일 실패 → 자동 복원 경로 시험
    guard = f"IF bn <> {FP_SRC_GMD[0]} OR bl <> {FP_SRC_GMD[1]} THEN"
    assert FX['20_APPLY_GMD_REPLACE.sql'].count(guard) == 1, '가드 문자열 미발견'
    FX2 = dict(FX); FX2['20_APPLY_GMD_REPLACE.sql'] = FX['20_APPLY_GMD_REPLACE.sql'].replace(guard, 'IF FALSE THEN')
    expect(run(FX2, '20_APPLY_GMD_REPLACE.sql'), 1, '20 컴파일 실패 → 자동 복원 후 -20035(의도)')
    oc.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = :n AND OBJECT_TYPE = 'PACKAGE BODY'", n=RH)
    st = oc.fetchone()[0]
    rest = src_of(RH, 'PACKAGE BODY').rstrip() == ren(orig_body, RH).rstrip()
    L(f"   자동 복원 결과: {st} · 원문 = 교체 전 원문 {'동일' if rest else '불일치'}")
    if not (st == 'VALID' and rest): fails[0] += 1
    expect(run(FR, '98_CLEANUP_BACKUP.sql'), 0, '98')
    expect(run(FR, '99_ROLLBACK.sql'), 0, '99 백업 없음 SKIP')
    for nm in (RH, RHX):
        oc.execute(f'DROP PACKAGE {nm}')
    oc.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE OBJECT_NAME IN (:a, :b)", a=RH, b=RHX); left = oc.fetchone()[0]
    oc.execute("SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME LIKE 'ZB_DMF0082RH%'"); zb = oc.fetchone()[0]
    oc.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME IN (:a, :b) AND OBJECT_TYPE='PACKAGE BODY' ORDER BY OBJECT_NAME", a=TGT, b=SRC)
    L(f"== 리허설 끝 {datetime.datetime.now().strftime('%H:%M:%S')} · 판정 실패 {fails[0]} · 남은 사본 {left} · 남은 ZB {zb} · 사내 {TGT}/{SRC} BODY LAST_DDL {oc.fetchall()}")
    ocx.close()


if A.rehearse:
    rehearse()
