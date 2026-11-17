# -*- coding: utf-8 -*-
"""
클라우드 적용 실패 객체 원인 진단 스크립트 생성기 (2026-11-13)
  python build_diag.py PKG_SCP0011:2803 PKG_SCP0039 PKG_SCP0127 ...
  → _artifacts\\_deploy_packages\\SEARCHCOND_CI_LIKE_CLOUD_20261113\\30_DIAG_FAILED.sql  (읽기 전용 — DDL·DML 없음)

구간(hunk)은 10_PKG_PATCH.sql 과 같은 방법으로 backup\\<PKG>.ASIS.sql(수정 전) → tobe\\<PKG>.TOBE.sql(적용본) 에서 다시 만든다.
사내 최신 표식은 지금 사내 ALL_SOURCE 를 조회해 함께 적는다(클라우드 원문이 사내보다 이전 판인지 비교용).
"""
import sys, os, re
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import build_cloud as bc
from build_cloud import patchgen, dbconn

OUT = os.path.join(bc.OUT, '30_DIAG_FAILED.sql')

TEMPLATE = r"""
PROMPT ============================================================
PROMPT [@@NAME@@] 진단
PROMPT ============================================================
DECLARE
    TYPE t_l IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    g       t_l;                 -- 클라우드 원문(줄 단위)
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_all   BOOLEAN := TRUE;     -- 모든 구간이 그대로 맞는가
    v_st    VARCHAR2(30);
    v_ddl   VARCHAR2(30);
    v_mark  VARCHAR2(100);
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
    FUNCTION nrm(s VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(REPLACE(REPLACE(REPLACE(s, CHR(13)), CHR(10)), CHR(9), ' '));
    END;
    PROCEDURE show(a PLS_INTEGER, b PLS_INTEGER) IS
    BEGIN
        FOR i IN GREATEST(a, 1) .. LEAST(b, g.COUNT) LOOP
            DBMS_OUTPUT.PUT_LINE('      CLOUD L' || LPAD(i, 5) || ' | ' || SUBSTR(RTRIM(g(i), CHR(10) || CHR(13)), 1, 230));
        END LOOP;
    END;
    PROCEDURE show_clob(c CLOB, a PLS_INTEGER, b PLS_INTEGER) IS
        p PLS_INTEGER := 1; q PLS_INTEGER; i PLS_INTEGER := 0;
    BEGIN
        LOOP
            i := i + 1;
            q := DBMS_LOB.INSTR(c, CHR(10), p);
            IF i >= a THEN
                DBMS_OUTPUT.PUT_LINE('      가상 L' || LPAD(i, 5) || ' | ' || SUBSTR(DBMS_LOB.SUBSTR(c, CASE WHEN NVL(q, 0) = 0 THEN 4000 ELSE LEAST(q - p, 4000) END, p), 1, 230));
            END IF;
            EXIT WHEN NVL(q, 0) = 0 OR i >= b;
            p := q + 1;
        END LOOP;
    END;
    PROCEDURE linemap IS      -- 기준 문구를 줄로 나눠 클라우드에서 줄마다 찾는다
        p PLS_INTEGER := 1; q PLS_INTEGER; ln VARCHAR2(4000); m PLS_INTEGER; f VARCHAR2(200);
        lo PLS_INTEGER := NULL; hi PLS_INTEGER := NULL; k PLS_INTEGER := 0; miss PLS_INTEGER := 0;
    BEGIN
        LOOP
            q := DBMS_LOB.INSTR(v_o, CHR(10), p);
            ln := nrm(DBMS_LOB.SUBSTR(v_o, CASE WHEN NVL(q, 0) = 0 THEN 4000 ELSE LEAST(q - p, 4000) END, p));
            IF ln IS NOT NULL THEN
                k := k + 1; m := 0; f := NULL;
                FOR i IN 1 .. g.COUNT LOOP
                    IF nrm(g(i)) = ln THEN
                        m := m + 1;
                        IF m <= 6 THEN f := f || ' L' || i; END IF;
                        IF m = 1 THEN lo := LEAST(NVL(lo, i), i); hi := GREATEST(NVL(hi, i), i); END IF;
                    END IF;
                END LOOP;
                IF m = 0 THEN miss := miss + 1; END IF;
                DBMS_OUTPUT.PUT_LINE('      기준 줄 ' || LPAD(k, 2) || ' : 클라우드 ' || m || '건' || f || CASE WHEN m = 0 THEN '  <<< 없음' END || ' | ' || SUBSTR(ln, 1, 170));
            END IF;
            EXIT WHEN NVL(q, 0) = 0;
            p := q + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('      → 기준 ' || k || '줄 중 클라우드에 없는 줄 ' || miss || '개');
        IF lo IS NOT NULL AND hi - lo <= 120 THEN
            DBMS_OUTPUT.PUT_LINE('      클라우드의 해당 자리(L' || GREATEST(lo - 4, 1) || '~L' || (hi + 4) || '):');
            show(lo - 4, hi + 4);
        ELSIF lo IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('      (일치한 줄이 L' || lo || '~L' || hi || ' 로 흩어져 있어 주변 출력 생략 — 위 줄별 결과 참조)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('      (기준 줄이 하나도 없음 — 이 구간이 통째로 다른 판)');
        END IF;
    END;
    PROCEDURE probe(k PLS_INTEGER, e PLS_INTEGER, d VARCHAR2) IS
        co PLS_INTEGER; cn PLS_INTEGER; pos PLS_INTEGER; lno PLS_INTEGER; op PLS_INTEGER; cl PLS_INTEGER;
    BEGIN
        co := cnt(v_new, v_o); cn := cnt(v_new, v_n);
        DBMS_OUTPUT.PUT_LINE('  [구간 ' || k || '] ' || d || ' — 기준 문구 ' || co || '건(기대 ' || e || ') · 수정 후 문구 ' || cn || '건 → '
            || CASE WHEN co = e THEN '일치(치환 가능)' WHEN co = 0 AND cn >= 1 THEN '이미 반영됨' ELSE '불일치' END);
        IF co = e THEN
            pos := DBMS_LOB.INSTR(v_new, v_o);
            lno := cnt(SUBSTR(v_new, 1, pos), CHR(10)) + 1;
            op := cnt(SUBSTR(v_new, 1, pos), '/*'); cl := cnt(SUBSTR(v_new, 1, pos), '*/');
            DBMS_OUTPUT.PUT_LINE('      일치 위치 = 가상 적용본 L' || lno || ' 부근 · 그 앞의 주석 열기 /* ' || op || '개, 닫기 */ ' || cl || '개'
                || CASE WHEN op > cl THEN '  <<< 블록 주석 안에 있음(표시 주석이 주석을 먼저 닫아 컴파일 오류 가능)' END);
            IF e = 1 THEN
                v_new := SUBSTR(v_new, 1, pos - 1) || v_n || SUBSTR(v_new, pos + DBMS_LOB.GETLENGTH(v_o));
            ELSE
                v_new := REPLACE(v_new, v_o, v_n);
            END IF;
        ELSIF NOT (co = 0 AND cn >= 1) THEN
            v_all := FALSE;
            linemap;
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME = '@@NAME@@' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        g(r.LINE) := r.TEXT;
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF g.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  클라우드에 PACKAGE BODY @@NAME@@ 없음');
        RETURN;
    END IF;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));
    v_new := v_src;
    SELECT STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') INTO v_st, v_ddl FROM USER_OBJECTS WHERE OBJECT_NAME = '@@NAME@@' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT MAX(REGEXP_SUBSTR(TEXT, '20[0-9]{2}\.[0-9]{2}\.[0-9]{2}')) || ' / ' || MAX(REGEXP_SUBSTR(TEXT, 'AJS 20[0-9]{6}'))
      INTO v_mark FROM USER_SOURCE WHERE NAME = '@@NAME@@' AND TYPE = 'PACKAGE BODY';
    DBMS_OUTPUT.PUT_LINE('  클라우드: STATUS=' || v_st || ' · LAST_DDL=' || v_ddl || ' · ' || g.COUNT || '줄 · ' || DBMS_LOB.GETLENGTH(v_src) || '자 · 최신 변경 표식 ' || v_mark);
    DBMS_OUTPUT.PUT_LINE('  사내(수정 전): @@CORP@@');
    FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '@@NAME@@' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 5 ROWS ONLY) LOOP
        DBMS_OUTPUT.PUT_LINE('  현재 USER_ERRORS L' || e.LINE || ':' || e.POSITION || ' ' || SUBSTR(e.TEXT, 1, 200));
    END LOOP;
@@HUNKS@@
    IF v_all THEN
        DBMS_OUTPUT.PUT_LINE('  → 모든 구간이 클라우드 원문과 맞음. 가상 적용본 ' || (cnt(v_new, CHR(10)) + 1) || '줄');
@@ERRSHOW@@
    ELSE
        DBMS_OUTPUT.PUT_LINE('  → 맞지 않는 구간이 있음(위 "<<< 없음" 줄과 "클라우드의 해당 자리" 참조)');
    END IF;
END;
/
"""


def main():
    con = dbconn.connect('tobe'); cur = con.cursor()
    cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); fetched = cur.fetchone()[0]
    L = ["/* 조회조건 대소문자 무시/LIKE 보완 — 클라우드 적용 실패 객체 원인 진단 (읽기 전용 · DDL/DML 없음)\n"
         " * 생성 %s · 실행 계정 = SCM_MGR · 전체 실행(F5) 후 출력 전체를 그대로 회신\n"
         " * 구간마다: 기준 문구 건수 → 불일치면 기준 문구를 줄 단위로 클라우드에서 찾아 없는 줄(<<< 없음)과 그 자리의 클라우드 원문을 출력\n"
         " * 구간이 모두 맞는 객체는 메모리에서만 가상 적용해 컴파일 오류 줄 주변을 출력(실제 적용 안 함) */\n"
         "SET DEFINE OFF\nSET SERVEROUTPUT ON SIZE UNLIMITED\nSET LINESIZE 300\n" % fetched]
    for arg in sys.argv[1:]:
        name, _, errline = arg.partition(':')
        base = bc.body_of(os.path.join(HERE, 'backup', name + '.ASIS.sql'))
        tobe = bc.body_of(os.path.join(HERE, 'tobe', name + '.TOBE.sql'))
        hunks, why = patchgen.make_hunks(base, tobe)
        if not hunks:
            hunks, why = bc.make_line_hunks(base, tobe)
        assert hunks, (name, why)
        H = []
        for k, hk in enumerate(hunks, 1):
            e = hk[3] if len(hk) > 3 else 1
            H += bc.clob_assign('v_o', hk[0])
            H += bc.clob_assign('v_n', hk[1])
            H.append("    probe(%d, %d, %s);" % (k, e, bc.qq(hk[2])))
        meta_ddl = open(os.path.join(HERE, 'backup', name + '.meta.json'), encoding='utf-8').read()
        ld = re.search(r'"last_ddl": "([^"]+)"', meta_ddl).group(1)
        marks = sorted(set(re.findall(r'20\d\d\.\d\d\.\d\d', base)))
        m2 = sorted(set(re.findall(r'AJS 20\d{6}', base)))
        corp = 'LAST_DDL=%s · %d줄 · %d자 · 최신 변경 표식 %s / %s' % (ld, len(patchgen.norm(base).split('\n')), len(patchgen.norm(base)), marks[-1] if marks else '-', m2[-1] if m2 else '-')
        if errline:
            n = int(errline)
            show = ("        DBMS_OUTPUT.PUT_LINE('  가상 적용본의 오류 줄 주변(L%d~L%d) — 적용 때 컴파일 오류가 L%d 에서 났음:');\n"
                    "        show_clob(v_new, %d, %d);") % (n - 14, n + 6, n, n - 14, n + 6)
        else:
            show = "        NULL;"
        L.append(TEMPLATE.replace('@@NAME@@', name).replace('@@CORP@@', corp.replace("'", "''")).replace('@@HUNKS@@', '\n'.join(H)).replace('@@ERRSHOW@@', show))
        print(name, '구간', len(hunks), '|', corp)
    open(OUT, 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n')
    print(OUT, os.path.getsize(OUT))


if __name__ == '__main__':
    main()
