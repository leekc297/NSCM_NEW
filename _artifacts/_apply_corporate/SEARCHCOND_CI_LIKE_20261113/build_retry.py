# -*- coding: utf-8 -*-
"""
클라우드 적용 실패분 재시도 패치 생성기 (2026-11-13)
  python build_retry.py
  → _artifacts\\_deploy_packages\\SEARCHCOND_CI_LIKE_CLOUD_20261113\\11_PKG_PATCH_RETRY.sql

 · PKG_SCP0011 : 10_PKG_PATCH.sql 과 같은 구간 패치(진단 결과 지금 클라우드 원문과 8개 구간 모두 일치).
 · PKG_SCP0039 : 클라우드가 사내보다 이전 판(2026.10.27 변경 없음)이라 구간 문맥이 안 맞음 →
                 **바뀐 줄만** 줄 단위로 찾아 치환(앞 공백은 클라우드 것을 유지, '--' 주석 줄 제외). 문맥 줄에 의존하지 않는다.
구간·줄 쌍은 backup\\<PKG>.ASIS.sql(사내 수정 전, 착수 시 ALL_SOURCE 조회본) → tobe\\<PKG>.TOBE.sql(사내 적용본) 에서 만든다.
FRESH-GATE: 지금 사내 ALL_SOURCE 원문이 적용본과 같은지 확인하고 SOURCE-FRESH 스탬프를 남긴다. 클라우드 쪽은 컴파일 실패 시 원문 자동 복원.
"""
import sys, os, difflib, collections
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import build_cloud as bc
from build_cloud import patchgen, dbconn

OUT = os.path.join(bc.OUT, '11_PKG_PATCH_RETRY.sql')

LINE_BLOCK = r"""/* PACKAGE BODY @@NAME@@ — 바뀐 줄만 줄 단위 치환(문맥 무관) · 클라우드 원문의 다른 부분은 그대로
 * 대상 줄 @@NPAIR@@종. 같은 내용의 줄(앞뒤 공백 무시, '--' 주석 줄 제외)을 모두 수정 후 줄로 바꾼다. 앞 공백은 클라우드 원문 것을 유지.
 * 가드: 바꿀 줄이 없으면 SKIP · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- TRUE 로 바꾸면 적용하지 않고 가능 여부만 출력
    TYPE t_s IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    TYPE t_n IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    o       t_s;      -- 수정 전 줄(앞뒤 공백 제거)
    n       t_s;      -- 수정 후 줄(앞뒤 공백 제거)
    c_rep   t_n;      -- 치환 건수
    c_done  t_n;      -- 이미 수정 후 줄인 건수
    v_raw   CLOB;
    v_new   CLOB;
    v_t     VARCHAR2(4000);
    v_b     VARCHAR2(4000);
    v_tot   PLS_INTEGER := 0;
    v_hit   BOOLEAN;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION nrm(s VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(REPLACE(REPLACE(REPLACE(s, CHR(13)), CHR(10)), CHR(9), ' '));
    END;
BEGIN
@@PAIRS@@
    FOR k IN 1 .. o.COUNT LOOP c_rep(k) := 0; c_done(k) := 0; END LOOP;
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '@@NAME@@' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
        v_t := r.TEXT;
        v_b := nrm(r.TEXT);
        v_hit := FALSE;
        IF v_b IS NOT NULL AND SUBSTR(v_b, 1, 2) <> '--' THEN
            FOR k IN 1 .. o.COUNT LOOP
                IF v_b = o(k) THEN
                    -- 앞 공백(들여쓰기)은 클라우드 원문 그대로, 내용만 수정 후 줄로
                    v_t := SUBSTR(r.TEXT, 1, LENGTH(r.TEXT) - LENGTH(LTRIM(r.TEXT))) || n(k)
                           || CASE WHEN SUBSTR(r.TEXT, -1) = CHR(10) THEN CHR(10) END;
                    c_rep(k) := c_rep(k) + 1; v_tot := v_tot + 1; v_hit := TRUE;
                    EXIT;
                ELSIF v_b = n(k) THEN
                    c_done(k) := c_done(k) + 1;
                    EXIT;
                END IF;
            END LOOP;
        END IF;
        DBMS_LOB.WRITEAPPEND(v_new, LENGTH(v_t), v_t);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY @@NAME@@ 없음. 원문 무변경');
    END IF;
    FOR k IN 1 .. o.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('  줄 ' || LPAD(k, 2) || ' : 치환 ' || c_rep(k) || '건 · 이미 반영 ' || c_done(k) || '건 | ' || SUBSTR(o(k), 1, 150));
    END LOOP;
    IF v_tot = 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  @@NAME@@ — 바꿀 줄 없음(이미 반영됐거나 해당 줄이 클라우드에 없음) · 원문 무변경');
        RETURN;
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   @@NAME@@ — 적용 가능: 줄 ' || v_tot || '건 치환 예정');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '@@NAME@@' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '@@NAME@@' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '@@NAME@@' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20013, '@@NAME@@ 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY @@NAME@@ — 줄 ' || v_tot || '건 치환 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
"""


def line_pairs(base, cur):
    b = patchgen.norm(base).split('\n'); c = patchgen.norm(cur).split('\n')
    pairs = collections.OrderedDict()
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, b, c, autojunk=False).get_opcodes():
        if tag == 'equal':
            continue
        assert tag == 'replace' and (i2 - i1) == (j2 - j1), (tag, i1, i2, j1, j2)
        for k in range(i2 - i1):
            o, n = ' '.join(b[i1 + k].replace('\t', ' ').split(' ')).strip(), c[j1 + k].replace('\t', ' ').strip()
            o = b[i1 + k].replace('\t', ' ').strip()
            pairs[(o, n)] = pairs.get((o, n), 0) + 1
    olds = [o for (o, n) in pairs]
    assert len(olds) == len(set(olds)), '같은 수정 전 줄이 서로 다른 수정 후 줄로 바뀜'
    return pairs


def main():
    con = dbconn.connect('tobe'); cur = con.cursor()
    cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); fetched = cur.fetchone()[0]
    L = ["/* 조회조건 대소문자 무시/LIKE 보완 — 클라우드 적용 실패분 재시도 (PKG_SCP0011 · PKG_SCP0039)\n"
         " * 생성 %s · 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)\n */\nSET DEFINE OFF\nSET SERVEROUTPUT ON SIZE UNLIMITED\n" % fetched]

    def fresh(name):
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=name)
        ld = cur.fetchone()[0]
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=name)
        now_src = ''.join(r[0] for r in cur.fetchall()).rstrip()
        base = bc.body_of(os.path.join(HERE, 'backup', name + '.ASIS.sql'))
        tobe = bc.body_of(os.path.join(HERE, 'tobe', name + '.TOBE.sql'))
        # FRESH-GATE: 지금 사내 원문 == 내가 적용한 원문
        assert patchgen.norm(now_src) == patchgen.norm(tobe), 'FRESH-GATE 실패: %s 사내 원문이 적용본과 다름(LAST_DDL %s)' % (name, ld)
        return base, now_src, ld

    # 1) PKG_SCP0011 — 구간 패치 그대로
    name = 'PKG_SCP0011'
    base, now_src, ld = fresh(name)
    hunks, why = patchgen.make_hunks(base, now_src)
    assert hunks, why
    h, l = patchgen.expect_hash(cur, patchgen.norm(now_src))
    L.append('-- SOURCE-FRESH: SCM_MGR.%s PACKAGE BODY LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (name, ld, fetched))
    L += bc.block(name, hunks, h, l, ld)
    print(name, '구간', len(hunks))

    # 2) PKG_SCP0039 — 줄 단위
    name = 'PKG_SCP0039'
    base, now_src, ld = fresh(name)
    pairs = line_pairs(base, now_src)
    P = []
    for k, ((o, n), c) in enumerate(pairs.items(), 1):
        P.append('    o(%d) := %s;   -- 사내 %d건' % (k, bc.qq(o), c))
        P.append('    n(%d) := %s;' % (k, bc.qq(n)))
    L.append('-- SOURCE-FRESH: SCM_MGR.%s PACKAGE BODY LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (name, ld, fetched))
    L.append(LINE_BLOCK.replace('@@NAME@@', name).replace('@@NPAIR@@', str(len(pairs))).replace('@@PAIRS@@', '\n'.join(P)))
    print(name, '줄 쌍', len(pairs), '사내 치환 줄 합', sum(pairs.values()))
    for (o, n), c in pairs.items():
        print('   %d건 | %s  →  %s' % (c, o[:70], n[:95]))
    open(OUT, 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n')
    print(OUT, os.path.getsize(OUT))


if __name__ == '__main__':
    main()
