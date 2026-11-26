# -*- coding: utf-8 -*-
"""
DMF0082 Monthly 경계월 사업부별 분리 + 81 계열 당월 편집 허용(E20261124-DMF0082DIVCUTOFF-CURMON) 클라우드 이관 패키지 빌더
- 81, 81 JV(LIKE '81%') = 지난달(당월부터 입력) · 40, 82 = 오늘 월 + 3개월
- 범위 = PKG_DMF0082 PACKAGE BODY 의 P_DMF0082_GET_MAIN_DATA O_RC2 M3_CUTOFF_DATE 구간 1곳만
- 바꿀 구간(NEW)은 빌드 시점 사내 DB 원문(ALL_SOURCE)에서 직접 잘라 쓴다 (#152)
- FRESH-GATE: 빌드 시점 DB 원문 == 사내 적용본(05_PKG_DMF0082_BODY_DIV_CUTOFF_CURMON.sql) 일 때만 생성
- 클라우드 원문 3가지 대응: A = M+3 한 줄(GAP440 판) · B = POJ 판(81_UC NULL) · C = 81_UC 지난달 · D = 81 계열 지난달(11:36 판) · E = 81 계열 당월 임시판(11:40 판) · 다섯 다 아니면 중단(원문 무변경)
- 리허설: A·B·C 기준본에 같은 치환을 Python 으로 적용해 결과 확인 (C → 사내 원문과 일치해야 함)
사용: python -u build_cloud_pkg_div_cutoff.py
"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
TAG = 'E20261124-DMF0082DIVCUTOFF-CURMON'
ANCHOR = '                FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 따라 움직였다(과거 시작 = 확정월 편집 가능 / 늦은 시작 = 입력월 잠김). */\n'
TAIL = '        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A\n'
OLD_A = ANCHOR + "             , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE\n" + TAIL


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return meta, ''.join(r[0] for r in cur.fetchall())


def block(src):
    s = src.index(ANCHOR)
    e = src.index(TAIL, s) + len(TAIL)
    return src[s:e]


def body(path):
    t = open(path, encoding='utf-8', newline='').read()
    return t[len('CREATE OR REPLACE '):-len('\n/\n')]


def q(s):
    assert '~]' not in s and "]'" not in s
    return "q'[" + s + "]'"


def plsql_patch(old_a, old_b, old_c, old_d, old_e, new):
    return f"""DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- TRUE = 조립·검사만(원문 무변경)
    v_raw   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_case  VARCHAR2(10);
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION cnt(c CLOB, t CLOB) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; p PLS_INTEGER := 1;
    BEGIN
        LOOP
            p := DBMS_LOB.INSTR(c, t, p);
            EXIT WHEN NVL(p, 0) = 0;
            n := n + 1; p := p + DBMS_LOB.GETLENGTH(t);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_DMF0082 없음. 원문 무변경');
    END IF;
    v_new := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF cnt(v_new, '{TAG}') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_DMF0082 — 사업부별 경계월 변경 이미 있음 · 원문 무변경');
        RETURN;
    END IF;
    v_n := {q(new)};
    v_o := {q(old_a)};
    IF cnt(v_new, v_o) = 1 THEN
        v_case := 'A(M+3)';
    ELSE
        v_o := {q(old_b)};
        IF cnt(v_new, v_o) = 1 THEN
            v_case := 'B(POJ)';
        ELSE
            v_o := {q(old_c)};
            IF cnt(v_new, v_o) = 1 THEN
                v_case := 'C(81_UC)';
            ELSE
                v_o := {q(old_d)};
                IF cnt(v_new, v_o) = 1 THEN
                    v_case := 'D(81ALL)';
                ELSE
                    v_o := {q(old_e)};
                    IF cnt(v_new, v_o) = 1 THEN
                        v_case := 'E(81TEMP)';
                    ELSE
                        RAISE_APPLICATION_ERROR(-20011, '중단 — M3_CUTOFF_DATE 구간이 예상 원문(A: M+3 한 줄 / B: POJ 판 / C: 81_UC 지난달 / D: 81 계열 지난달 / E: 81 계열 당월 임시판)과 다름. 원문 무변경 · 구간 원문을 전달 바람');
                    END IF;
                END IF;
            END IF;
        END IF;
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, v_o);
    v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    IF cnt(v_new, '{TAG}') <> 2 OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(REPLACE(v_raw, CHR(13) || CHR(10), CHR(10))) - DBMS_LOB.GETLENGTH(v_o) + DBMS_LOB.GETLENGTH(v_n) THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — 조립 결과 검사 실패. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_DMF0082 — 기준 ' || v_case || ' · 패치 1개 구간 적용 가능');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE BODY PKG_DMF0082 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_DMF0082 — 기준 ' || v_case || ' · 81 계열 경계월 = 지난달(당월부터 입력), 40·82 = +3개월 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
"""


def main():
    t0 = time.time()
    with connect('tobe') as cx:
        cx.call_timeout = 60000
        cur = cx.cursor()
        meta, src = fetch(cur)
        fetched = time.strftime('%Y-%m-%d %H:%M')
        print(f'DB fetched {fetched} LAST_DDL={meta[0]} STATUS={meta[1]} ({time.time()-t0:.1f}s)')
    # FRESH-GATE: 빌드 시점 DB 원문 == 사내 적용본
    final = open(os.path.join(HERE, '05_PKG_DMF0082_BODY_DIV_CUTOFF_CURMON.sql'), encoding='utf-8', newline='').read()
    assert final == 'CREATE OR REPLACE ' + src + '\n/\n', 'FRESH-GATE 실패: 사내 원문이 적용본과 다름 — 재조회·재병합'
    print('FRESH-GATE 통과')
    UC = os.path.join(ROOT, '_artifacts', '_apply_corporate', 'DMF0082_UC_CUTOFF_20261124')
    poj = body(os.path.join(UC, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql'))
    ucv = body(os.path.join(HERE, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql'))
    gap = body(os.path.join(ROOT, '_artifacts', '_apply_corporate', 'DMF0082_RTF3ROW_20261123', '03_PKG_DMF0082_BODY_RTF3ROW_FINAL.sql'))
    std = body(os.path.join(HERE, '01_PKG_DMF0082_BODY_DIV_CUTOFF.sql'))
    tmp = body(os.path.join(HERE, '03_PKG_DMF0082_BODY_DIV_CUTOFF_TEMP.sql'))
    new, old_b, old_c, old_d, old_e = block(src), block(poj), block(ucv), block(std), block(tmp)
    assert new.count(TAG) == 2 and 'CAST(NULL AS VARCHAR2(8))   /*' in old_b and "CASE WHEN p_division_id = '81_UC'" in old_c
    assert len({new, old_b, old_c, old_d, old_e, OLD_A}) == 6 and old_d.count(TAG) == 0 and old_e.count(TAG) == 0 and 'DIVCUTOFF-TEMP' in old_e
    for k, base, old in (('A GAP440(11-23 적용본)', gap, OLD_A), ('B POJ 판', poj, old_b), ('C 81_UC 판', ucv, old_c), ('D 81 계열 표준판', std, old_d), ('E 81 계열 임시판', tmp, old_e)):
        assert base.count(old) == 1, k
        r = base.replace(old, new)
        assert r.count(TAG) == 2 and len(r) - len(base) == len(new) - len(old), k
        print(f'리허설 {k} → 1개 구간 치환 · 결과 == 사내 원문: {r == src}')
    assert tmp.replace(old_e, new) == src, '리허설 E 실패'
    stamp = time.strftime('%Y%m%d_%H%M')
    out = os.path.join(ROOT, '_artifacts', '_deploy_packages', f'DMF0082_DIV_CUTOFF_CURMON_CLOUD_{stamp}')
    os.makedirs(os.path.join(out, 'A_DB'), exist_ok=True)
    fresh = f'-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={meta[0]} FETCHED={fetched} DB=ZIOUI1\n'
    zb = 'ZB_DMF0082_DIVCUTC_20261124_SRC'
    files = {
        '05_BACKUP_CLOUD.sql': fresh + f"""/* 05_BACKUP_CLOUD — 적용 전 클라우드 PKG_DMF0082 PACKAGE BODY 원문 보관(표 {zb}). 이미 있으면 건너뜀(첫 백업 유지) */
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{zb}';
    IF n > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  {zb} 이미 있음(첫 백업 유지)');
    ELSE
        EXECUTE IMMEDIATE q'[CREATE TABLE {zb} AS SELECT NAME, TYPE, LINE, TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY']';
        DBMS_OUTPUT.PUT_LINE('> BACKUP {zb} 생성');
    END IF;
END;
/
SELECT COUNT(*) AS BACKUP_LINES FROM {zb};
""",
        '20_PKG_BODY_PKG_DMF0082_DIV_CUTOFF_CURMON.sql': fresh + f"""/* 20_PKG PKG_DMF0082 PACKAGE BODY — Monthly 입력 경계월 사업부별 분리 ({TAG})
 * 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC = 지난달(당월부터 입력) · 40, 82 = 오늘 월 + 3개월(종전)
 * 범위 = P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE 구간 1곳. 그 외 원문 무변경
 * 클라우드 원문 A(M+3 한 줄) · B(POJ 판, 81_UC NULL) · C(81_UC 지난달) · D(81 계열 지난달) · E(81 계열 당월 임시판) 중 하나를 찾아 치환 · 다섯 다 아니면 중단(원문 무변경) · 이미 있으면 SKIP
 * DMF0082_UC_CUTOFF_CLOUD_20261124_1037, DMF0082_DIV_CUTOFF_TEMP_CLOUD_20261124_1144 는 이 패키지로 대체함(먼저 실행할 필요 없음)
 * 컴파일 오류면 원문 자동 복원 · 실행 계정 SCM_MGR · 전체 F5 · 반복 실행 안전
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

""" + plsql_patch(OLD_A, old_b, old_c, old_d, old_e, new) + """
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' ORDER BY TYPE, SEQUENCE;
""",
        '90_VERIFY.sql': f"""/* 90_VERIFY — 읽기 전용. 기대: PACKAGE BODY VALID · 오류 0 · 표식 줄 2건({TAG} THEN 줄, 종전 주석 줄) */
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY 1;
SELECT COUNT(*) AS ERR_CNT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082';
SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND (TEXT LIKE '%{TAG}%' OR TEXT LIKE '%M3_CUTOFF_DATE%') ORDER BY LINE;
""",
        '99_ROLLBACK.sql': f"""/* 99_ROLLBACK — 문제 시에만. 05_BACKUP 의 {zb} 원문으로 PACKAGE BODY 복원 */
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v CLOB;
BEGIN
    FOR r IN (SELECT TEXT FROM {zb} WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP v := v || r.TEXT; END LOOP;
    IF v IS NULL THEN
        RAISE_APPLICATION_ERROR(-20020, '백업 없음 — 05_BACKUP 미실행. 복원 안 함');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
    DBMS_OUTPUT.PUT_LINE('> RESTORE PACKAGE BODY PKG_DMF0082 완료');
END;
/
SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY 1;
""",
    }
    for fn, b in files.items():
        open(os.path.join(out, 'A_DB', fn), 'w', encoding='utf-8', newline='').write(b)
    print('패키지', out)
    print(f'끝 ({time.time()-t0:.1f}s)')


if __name__ == '__main__':
    main()
