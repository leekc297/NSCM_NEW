# -*- coding: utf-8 -*-
"""PERF2 패키지 패치판 : 클라우드 원문 위에 보완 3곳만 바꿈(전체 교체 아님) + 원문 차이 진단 스크립트
- 보완 위치 = 기준본 A(BATCH_PERF 적용본) → 사내 최종본 차이(difflib). 위치마다 원문 A 안에서 한 번만 나오는 앞뒤 줄을 붙여 찾음
- 위치마다 표식이 이미 있으면 그 위치는 SKIP. 찾는 문장이 0건 또는 2건 이상이면 전체 중단(-20011, 원문 무변경)
FRESH-GATE : 사내 DB 원문(ALL_SOURCE 새로 조회) == 사내 최종본
  python build_patch_perf2.py <패키지 폴더>
"""
import sys, os, io, difflib, re
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
from build_package_perf2 import BASE_A, BASE_B, FINAL, N, HS, MARKS, rd, mark_cols

W = os.path.dirname(os.path.abspath(__file__))


def fetch_src(c):
    """작업 기준 원문 = 실행 때 DB 에서 새로 조회(ALL_SOURCE)"""
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = :1 AND TYPE = 'PROCEDURE' ORDER BY LINE", [N])
    return ''.join(r[0] for r in c.fetchall())


def hunks(A, F):
    a, f = A.split('\n'), F.split('\n')
    out = []
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, f, autojunk=False).get_opcodes():
        if tag == 'equal':
            continue
        before, after = 1, 1
        while True:
            old = '\n'.join(a[i1 - before:i2 + after]) + '\n'
            new = '\n'.join(a[i1 - before:i1] + f[j1:j2] + a[i2:i2 + after]) + '\n'
            if A.count(old) == 1:
                break
            before += 1; after += 1
        mk = [m for m in MARKS if m in '\n'.join(f[j1:j2])]
        assert len(mk) == 1, mk
        assert F.count(new) == 1
        out.append(dict(line=i1 + 1, old=old, new=new, mark=mk[0]))
    return out


def lit(s):
    assert "~'" not in s and len(s.encode('utf-8')) < 30000
    return "q'~" + s + "~'"


def patch_sql(hs):
    decl = '\n'.join("    o%d CONSTANT VARCHAR2(32767) := %s;\n    n%d CONSTANT VARCHAR2(32767) := %s;" % (k, lit(h['old']), k, lit(h['new'])) for k, h in enumerate(hs, 1))
    chk = '\n'.join('''    IF DBMS_LOB.INSTR(v_src, '%(m)s') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  위치 %(k)d (%(m)s, 원 %(ln)d줄) 이미 반영');
    ELSIF DBMS_LOB.INSTR(v_src, o%(k)d, 1, 1) = 0 OR DBMS_LOB.INSTR(v_src, o%(k)d, 1, 2) > 0 THEN
        RAISE_APPLICATION_ERROR(-20011, c_name || ' : 위치 %(k)d (%(m)s, 원 %(ln)d줄) 바꿀 문장을 한 곳에서 찾지 못함. 원문 무변경. 15_DIFF_SOURCE 결과 회신');
    ELSE
        v_src := REPLACE(v_src, o%(k)d, n%(k)d);
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('> PATCH 위치 %(k)d (%(m)s, 원 %(ln)d줄)');
    END IF;''' % dict(k=k, m=h['mark'], ln=h['line']) for k, h in enumerate(hs, 1))
    return '''/* %(n)s : 클라우드 원문 위에 보완 3곳만 바꿈 (E20261126-OWMSMAX 1-1, E20261126-AGINGCUT 1-6, E20261126-WHSTKHD 2-14)
 * 위치마다 표식이 이미 있으면 SKIP. 바꿀 문장을 한 곳에서 찾지 못하면 전체 중단(-20011, 원문 무변경)
 * 그 밖의 줄은 클라우드 원문 그대로 둠. 컴파일 실패면 원문 복원(-20012)
 * SCM_MGR 접속, 전체 실행(F5). Output 창 문구 확인 */
SET SERVEROUTPUT ON SIZE UNLIMITED
%(hs)s
DECLARE
    c_name CONSTANT VARCHAR2(128) := '%(n)s';
%(decl)s
    v_src  CLOB;
    v_old  CLOB;
    v_cnt  NUMBER := 0;
    v_st   VARCHAR2(30);
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_old, TRUE);
    ap(v_old, 'CREATE OR REPLACE ');
    FOR r IN (SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = c_name AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        ap(v_src, r.TEXT);
        ap(v_old, r.TEXT);
    END LOOP;
%(chk)s
    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  ' || c_name || ' 3곳 모두 이미 반영');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
    EXCEPTION
        WHEN OTHERS THEN NULL;   /* ORA-24344 컴파일 오류는 아래 STATUS 로 판정 */
    END;
    SELECT STATUS INTO v_st FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = c_name AND OBJECT_TYPE = 'PROCEDURE';
    IF v_st <> 'VALID' THEN
        BEGIN EXECUTE IMMEDIATE v_old; EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20012, c_name || ' : 컴파일 실패로 원문 복원함. ALL_ERRORS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY ' || c_name || ' · ' || v_st || ' · 바꾼 위치 ' || v_cnt);
END;
/
''' % dict(n=N, hs=HS, decl=decl, chk=chk)


def line_hashes(c, text):
    parts = re.findall(r'[^\n]*\n|[^\n]+$', text)
    hs = []
    for i in range(0, len(parts), 500):
        grp = parts[i:i + 500]
        sql = ' UNION ALL '.join('SELECT %d AS K, ORA_HASH(:%d) AS H FROM DUAL' % (k, k + 1) for k in range(len(grp)))
        c.execute('SELECT H FROM (' + sql + ') ORDER BY K', grp)
        hs += [r[0] for r in c.fetchall()]
    return hs


def diff_sql(name, hs):
    s = ','.join(str(h) for h in hs)
    chunks, cur = [], ''
    for tok in s.split(','):
        if len(cur) + len(tok) + 1 > 30000:
            chunks.append(cur); cur = ''
        cur += tok + ','
    chunks.append(cur)
    body = '\n'.join("    v := v || '%s';" % ch for ch in chunks)
    return '''/* 진단 (조회만) : 클라우드 %(n)s 원문과 사내 기준본 %(nm)s(줄 %(l)d)의 줄 단위 비교
 * 같은 줄 번호끼리 ORA_HASH(TEXT) 를 비교해 다른 줄의 번호와 클라우드 원문을 출력(최대 200줄). Output 창 전체를 회신
 * SCM_MGR 접속, 전체 실행(F5) */
SET SERVEROUTPUT ON SIZE UNLIMITED
%(hs)s
DECLARE
    v     CLOB;
    p     PLS_INTEGER := 1;
    q     PLS_INTEGER;
    k     PLS_INTEGER := 0;
    n     PLS_INTEGER := 0;
    TYPE t_h IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    h     t_h;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
%(body)s
    LOOP
        q := DBMS_LOB.INSTR(v, ',', p);
        EXIT WHEN q = 0 OR q IS NULL;
        k := k + 1;
        h(k) := TO_NUMBER(DBMS_LOB.SUBSTR(v, q - p, p));
        p := q + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[DIFF] 기준본 %(nm)s 줄 ' || k);
    FOR r IN (SELECT LINE, TEXT, ORA_HASH(TEXT) AS H FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = '%(n)s' AND TYPE = 'PROCEDURE' ORDER BY LINE) LOOP
        IF NOT h.EXISTS(r.LINE) OR h(r.LINE) <> r.H THEN
            n := n + 1;
            IF n <= 200 THEN
                DBMS_OUTPUT.PUT_LINE('[DIFF] ' || r.LINE || ' : ' || RTRIM(SUBSTR(r.TEXT, 1, 3000), CHR(10) || CHR(13)));
            END IF;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[DIFF] 다른 줄 ' || n);
END;
/
''' % dict(n=N, nm=name, l=len(hs), hs=HS, body=body)


def main(out):
    cx = dbconn.connect('tobe'); c = cx.cursor()
    A, B, F = rd(BASE_A), rd(BASE_B), rd(FINAL)
    assert fetch_src(c) == F, 'FRESH-GATE 실패 : 사내 원문이 사내 최종본과 다름'
    hs = hunks(A, F)
    for h in hs:
        print('hunk', h['line'], h['mark'], 'old lines', h['old'].count('\n'), 'in B', B.count(h['old']))
    # 자체 시험 : A, B 에 패치를 적용하면 사내 최종본과 같아야 함
    for nm, src in (('A', A), ('B', B)):
        x = src
        for h in hs:
            if h['mark'] in x:
                continue
            assert x.count(h['old']) == 1, (nm, h['line'])
            x = x.replace(h['old'], h['new'])
        assert x == F, nm
        print('self-test', nm, '-> FINAL OK')
    d = os.path.join(out, 'A_DB')
    old20 = os.path.join(d, '20_REPLACE_%s.sql' % N)
    if os.path.exists(old20):
        os.remove(old20); print('removed', old20)
    c.execute("SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') FROM DUAL"); at = c.fetchone()[0]
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = :1 AND OBJECT_TYPE = 'PROCEDURE'", [N])
    st = '-- SOURCE-FRESH: SCM_MGR.%s PROCEDURE LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (N, c.fetchone()[0], at)
    files = {
        '15_DIFF_SOURCE.sql': diff_sql('B', line_hashes(c, B)),
        '20_PATCH_%s.sql' % N: st + '\n' + patch_sql(hs),
    }
    for fn, t in files.items():
        io.open(os.path.join(d, fn), 'w', encoding='utf-8', newline='\n').write(t)
        print('[OUT]', fn, len(t))


if __name__ == '__main__':
    main(sys.argv[1])
