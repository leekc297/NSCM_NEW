# -*- coding: utf-8 -*-
"""
SCP0104 사용자의견 DB 보완 — 클라우드 이관 패키지(수정 구간만) 생성기 (2026-11-17, SEARCHCOND_CI_LIKE 빌더 복사)

  python build_cloud.py
  → _artifacts\\_deploy_packages\\SEARCHCOND_CI_LIKE_CLOUD_20261113\\ (10_PKG_PATCH.sql · 20_CMBO_PATCH.sql · 90_VERIFY.sql · README.md)

기준본(수정 전) = backup\\<PKG>.ASIS.sql (착수 시 사내 ALL_SOURCE 조회본)
수정본(수정 후) = 지금 사내 ALL_SOURCE 를 다시 조회한 원문.
FRESH-GATE: 지금 사내 원문 == tobe\\<PKG>.TOBE.sql(내가 적용한 원문) 인지 확인. 다르면 그 뒤 다른 변경이 얹힌 것 → 그 객체는 패치에서 빼고 보고.
패치 = 변경 구간(hunk)만 치환. 클라우드 원문이 사내와 다른 곳이 있어도 이번 수정 구간만 반영한다.
  · 구간 기준 문구가 클라우드에 1건 → 치환 / 0건이고 수정 후 문구가 이미 있으면 그 구간은 반영된 것으로 건너뜀 / 그 밖 = 중단(원문 무변경)
  · 컴파일 오류(ORA-24344 포함) → 원문 자동 복원
"""
import sys, os, re, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'CloudPkg'))
import dbconn, patchgen

OUT = os.path.join(ROOT, '_artifacts', '_deploy_packages', 'SCP0104_USERFIX_CLOUD_20261117')
TYP = 'PACKAGE BODY'
PFX = 'CREATE OR REPLACE '


def qq(text):
    for o, c in (('~', '~'), ('!', '!'), ('#', '#'), ('^', '^'), ('|', '|'), ('[', ']'), ('{', '}'), ('<', '>')):
        if (c + "'") not in text and not text.endswith(c):
            return "q'%s%s%s'" % (o, text, c)
    raise ValueError('q-quote 구분자 없음')


def clob_assign(var, text, indent='    '):
    lines = ['%s%s := NULL;' % (indent, var)]
    for i in range(0, len(text), 8000):
        lines.append('%s%s := %s || %s;' % (indent, var, var, qq(text[i:i + 8000])))
    return lines


def body_of(path):
    s = open(path, encoding='utf-8', newline='').read()
    s = '\n'.join(l for l in s.split('\n') if not l.startswith('-- SOURCE-FRESH:'))
    s = s.lstrip('\n')
    assert s.startswith(PFX), path
    s = s[len(PFX):].rstrip()
    if s.endswith('\n/'):
        s = s[:-2].rstrip()
    return s


def make_line_hunks(base, cur):
    """같은 줄이 여러 번 반복돼 구간 문구가 유일하지 않을 때 — 바뀐 줄을 (수정 전 줄 → 수정 후 줄, 건수) 로 묶어 모두 치환.
    수정 전 줄이 기준본에서 바뀐 건수만큼만 나올 때에만 쓴다(일부만 바뀐 줄이 있으면 실패)."""
    import difflib, collections
    b = patchgen.norm(base).split('\n')
    c = patchgen.norm(cur).split('\n')
    sm = difflib.SequenceMatcher(None, b, c, autojunk=False)
    pairs = collections.OrderedDict()
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal':
            continue
        if tag != 'replace' or (i2 - i1) != (j2 - j1):
            return None, '줄 수가 달라지는 변경이 있음(L%d)' % (i1 + 1)
        for k in range(i2 - i1):
            pairs[(b[i1 + k], c[j1 + k])] = pairs.get((b[i1 + k], c[j1 + k]), 0) + 1
    hunks = []
    t = '\n' + '\n'.join(b) + '\n'
    for (o, n), k in pairs.items():
        old, new = '\n' + o + '\n', '\n' + n + '\n'
        if t.count(old) != k:
            return None, '같은 줄이 기준본에 %d건인데 바뀐 것은 %d건' % (t.count(old), k)
        t = t.replace(old, new)
        hunks.append((old, new, '같은 줄 %d건 모두 치환' % k, k))
    if t != '\n' + '\n'.join(c) + '\n':
        return None, '줄 단위 치환 결과가 사내 원문과 다름'
    return hunks, '%d종 %d줄' % (len(hunks), sum(x[3] for x in hunks))


def block(name, hunks, h, l, last_ddl):
    L = ["""/* %s %s — SCP0104 사용자의견 보완 · 수정 구간만 패치 (사내 적용본 LAST_DDL %s)
 * 변경 %d개 구간. 클라우드 원문의 다른 부분은 건드리지 않는다.
 * 가드: 이미 사내와 같으면 SKIP · 구간별 기준 문구 1건이면 치환, 0건+수정 후 문구 존재면 반영된 구간으로 건너뜀, 그 밖은 중단(원문 무변경) · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- TRUE 로 바꾸면 적용하지 않고 가능 여부만 출력
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_co    PLS_INTEGER;
    v_cn    PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_done  PLS_INTEGER := 0;
    v_skip  PLS_INTEGER := 0;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
""" % (TYP, name, last_ddl, len(hunks)) + patchgen.HV_FUNC + """
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
    PROCEDURE hunk(k PLS_INTEGER, e PLS_INTEGER DEFAULT 1) IS
    BEGIN
        v_co := cnt(v_new, v_o);
        v_cn := cnt(v_new, v_n);
        IF v_co = e AND e = 1 THEN
            v_pos := DBMS_LOB.INSTR(v_new, v_o);
            v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
            v_done := v_done + 1;
        ELSIF v_co = e THEN
            v_new := REPLACE(v_new, v_o, v_n);   -- 같은 줄 e건 모두 치환
            v_done := v_done + 1;
        ELSIF v_co = 0 AND v_cn >= 1 THEN
            v_skip := v_skip + 1;   -- 이미 반영된 구간
        ELSE
            RAISE_APPLICATION_ERROR(-20011, '중단 — %(n)s 변경 ' || k || ' 기준 문구 ' || v_co || '건 · 수정 후 문구 ' || v_cn || '건. 클라우드 원문의 이 구간이 사내 수정 전과 다름 → 이 객체는 수동 확인. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '%(n)s' AND TYPE = '%(t)s' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 %(t)s %(n)s 없음. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));
    IF hv(v_src) = %(h)d AND DBMS_LOB.GETLENGTH(v_src) = %(l)d THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  %(n)s — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;
""" % dict(n=name, t=TYP, h=h, l=l)]
    for k, hk in enumerate(hunks, 1):
        old, new, d = hk[0], hk[1], hk[2]
        e = hk[3] if len(hk) > 3 else 1
        L.append('    -- 변경 %d: %s' % (k, d))
        L += clob_assign('v_o', old)
        L += clob_assign('v_n', new)
        L.append('    hunk(%d, %d);' % (k, e))
    L.append("""    IF v_done = 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  %(n)s — 변경 구간 ' || v_skip || '개가 모두 이미 반영됨 · 원문 무변경');
        RETURN;
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   %(n)s — 적용 가능: 치환 ' || v_done || '개 구간 · 이미 반영 ' || v_skip || '개 구간');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '%(n)s' AND OBJECT_TYPE = '%(t)s';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '%(n)s' AND TYPE = '%(t)s';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '%(n)s' AND TYPE = '%(t)s' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20013, '%(n)s 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY %(n)s — 치환 ' || v_done || '개 구간 · 이미 반영 ' || v_skip || '개 · ' || v_st
        || CASE WHEN hv(v_new) = %(h)d AND DBMS_LOB.GETLENGTH(v_new) = %(l)d THEN ' · 결과 = 사내 원문' ELSE ' · 수정 구간만 반영(그 밖의 클라우드↔사내 차이는 그대로)' END
        || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
""" % dict(n=name, t=TYP, h=h, l=l))
    return L


def main():
    os.makedirs(OUT, exist_ok=True)
    con = dbconn.connect('tobe')
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    svc, fetched = cur.fetchone()
    names = ['PKG_SCP0104']
    head = ("/* SCP0104 사용자의견 DB 보완 : 클라우드 이관(수정 구간만)\n"
            " * 생성 %s · 사내 DB=%s 기준 · 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)\n"
            " * 객체마다 독립 블록 — 한 객체가 중단돼도 그 객체 원문은 무변경이고 나머지는 계속 진행된다.\n */\n"
            "SET DEFINE OFF\nSET SERVEROUTPUT ON SIZE UNLIMITED\n\n") % (fetched, svc.upper())
    L = [head]
    rows, skipped = [], []
    for n in names:
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=n, t=TYP)
        last_ddl, st = cur.fetchone()
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=n, t=TYP)
        now_src = ''.join(r[0] for r in cur.fetchall()).rstrip()
        base = body_of(os.path.join(HERE, 'backup', n + '.ASIS.sql'))
        tobe = body_of(os.path.join(HERE, 'r2', 'tobe', n + '.TOBE.sql'))   # 1차(09:44)+2차(09:47) 적용본
        # FRESH-GATE: 지금 사내 원문이 내가 적용한 원문과 같은지
        if patchgen.norm(now_src) != patchgen.norm(tobe):
            skipped.append((n, last_ddl, '사내 원문이 적용본과 다름(적용 후 다른 변경) — 패치에서 제외'))
            continue
        hunks, why = patchgen.make_hunks(base, now_src)
        if not hunks:
            hunks, why2 = make_line_hunks(base, now_src)
            why = '%s / 줄 단위: %s' % (why, why2)
        if not hunks:
            skipped.append((n, last_ddl, '구간 패치 생성 실패: %s' % why))
            continue
        h, l = patchgen.expect_hash(cur, patchgen.norm(now_src))
        L.append('-- SOURCE-FRESH: SCM_MGR.%s %s LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (n, TYP, last_ddl, fetched))
        L += block(n, hunks, h, l, last_ddl)
        rows.append((n, len(hunks), last_ddl, st))
    open(os.path.join(OUT, '10_PKG_PATCH.sql'), 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n')

    cm = [head.replace('수정 구간만', '메뉴 권한·컬럼 메타')]
    cm.append("""/* ① 상위 메뉴 Capa Plan 폴더 권한 — 하위 화면(SCP0104~0108·0114) 권한이 있는 그룹 중 폴더 권한이 없는 그룹만 추가(멱등) */
DECLARE
    n PLS_INTEGER;
BEGIN
    INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT DISTINCT C.USER_GR_ID, 'Capa Plan', 'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
      FROM SCM_ADM_USER_GR_MNU_MPG_M C
     WHERE C.USE_YN = 'Y'
       AND C.MNU_ID IN (SELECT MNU_ID FROM SCM_ADM_MNU_M WHERE UPPR_MNU_ID = 'Capa Plan')
       AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M F WHERE F.USER_GR_ID = C.USER_GR_ID AND F.MNU_ID = 'Capa Plan');
    n := SQL%%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CASE WHEN n > 0 THEN '> APPLY ' ELSE '> SKIP  ' END || 'Capa Plan 폴더 권한 ' || n || '행 추가');
END;
/
/* ② SOP 그리드 컬럼 정렬 번호 = AS-IS (현재 200 인 행만) */
DECLARE
    n PLS_INTEGER := 0;
BEGIN
    UPDATE SCM_MST_SHEET_COLUMNS SET SORT_ORDER_NO = 150, LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE
     WHERE PROGRAM_ID = 'SCP0104' AND SHEET_NAME = 'SOP_ASSEMBLY' AND COLUMN_NAME = 'ELTR_LN_TP_CD' AND SORT_ORDER_NO = 200;
    n := n + SQL%%ROWCOUNT;
    UPDATE SCM_MST_SHEET_COLUMNS SET SORT_ORDER_NO = 190, LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE
     WHERE PROGRAM_ID = 'SCP0104' AND SHEET_NAME = 'SOP_ASSEMBLY' AND COLUMN_NAME = 'SOP_DT' AND SORT_ORDER_NO = 200;
    n := n + SQL%%ROWCOUNT;
    UPDATE SCM_MST_SHEET_COLUMNS SET SORT_ORDER_NO = 170, LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE
     WHERE PROGRAM_ID = 'SCP0104' AND SHEET_NAME = 'SOP_ELTR' AND COLUMN_NAME = 'SOP_DT' AND SORT_ORDER_NO = 200;
    n := n + SQL%%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CASE WHEN n > 0 THEN '> APPLY ' ELSE '> SKIP  ' END || 'SCP0104 SOP 컬럼 정렬 번호 ' || n || '행 수정');
END;
/
""".replace('%%', '%'))
    open(os.path.join(OUT, '20_DATA_PATCH.sql'), 'w', encoding='utf-8', newline='\n').write('\n'.join(cm) + '\n')

    inl = ', '.join("'%s'" % r[0] for r in rows)
    ver = ("SET LINESIZE 200\nSET PAGESIZE 100\n"
           "SELECT OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PACKAGE BODY' AND OBJECT_NAME IN (%s) ORDER BY 1;\n"
           "SELECT NAME, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME IN (%s) ORDER BY 1, 2;\n"
           "SELECT NAME, COUNT(*) MARK_LINES FROM USER_SOURCE WHERE TYPE = 'PACKAGE BODY' AND NAME IN (%s) AND TEXT LIKE '%%2026.11.17 SCP0104 보완%%' GROUP BY NAME ORDER BY 1;\n"
           "SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'Capa Plan' ORDER BY 1;\n"
           "SELECT SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'SCP0104' AND SHEET_NAME IN ('SOP_ASSEMBLY','SOP_ELTR') AND COLUMN_NAME IN ('ELTR_LN_TP_CD','SOP_DT') ORDER BY 1, 2;\n") % (inl, inl, inl)
    open(os.path.join(OUT, '90_VERIFY.sql'), 'w', encoding='utf-8', newline='\n').write(ver)

    md = ['# SCP0104 사용자의견 DB 보완 · 클라우드 이관 패키지 (수정 구간만)', '',
          '- 생성: %s · 기준 = 사내 Oracle ZIOUI1 (SCM_MGR)' % fetched,
          '- 실행 계정: SCM_MGR · 순서: `10_PKG_PATCH.sql` → `20_DATA_PATCH.sql` → `90_VERIFY.sql` (각각 전체 실행, 반복 실행 안전)',
          '', '## 보완 내용',
          '- PKG_SCP0104: ① Loss Plan 2곳 V_VERSION NULL 이면 날짜 변환 생략(ORA-01840) ② Dummy 이름 비교 대소문자 무시 2곳 ③ ELTR Material 비교 NICK_NAME → ITEM_ID 2곳 ④ SOP 조회 ORDER BY 에 OPERATION_ID·ELTR_LN_TP_CD 추가 2곳 ⑤ P_SCP0104_SPLIT_CLOB 빈 값·끝 구분자도 1행(AS-IS dbo.String_Split 등가) 2곳',
          '- 데이터: Capa Plan 폴더 권한(하위 화면 권한 그룹 중 없는 그룹만 추가) · SCP0104 SOP 컬럼 SORT_ORDER_NO 3행(AS-IS 값)',
          '- 먼저 가능 여부만 보려면 `10_PKG_PATCH.sql` 의 `c_dry CONSTANT BOOLEAN := FALSE` 를 TRUE 로 일괄 바꿔 실행한다(적용 안 함).',
          '', '## 동작',
          '- 패키지마다 클라우드 자신의 원문을 읽어 **이번 수정 구간만** 치환한다. 그 밖의 클라우드↔사내 차이는 건드리지 않는다.',
          '- 출력: `> APPLY`(적용) / `> SKIP`(이미 반영) / `ORA-20011 중단`(그 구간이 사내 수정 전과 달라 자동 반영 불가 — 그 객체 원문은 무변경, 나머지는 계속 진행).',
          '- 컴파일 오류가 나면 그 객체는 실행 전 원문으로 자동 복원된다.',
          '', '## 대상 패키지 (%d개) + 데이터 2종' % len(rows), '', '| 패키지 | 변경 구간 | 사내 적용 시각 |', '|---|---|---|']
    md += ['| %s | %d | %s |' % (r[0], r[1], r[2]) for r in rows]
    md += ['| SCM_ADM_USER_GR_MNU_MPG_M Capa Plan 7행 · SCM_MST_SHEET_COLUMNS 3행 | - | 2026-11-17 09:47 |']
    if skipped:
        md += ['', '## 패치에서 제외된 객체', ''] + ['- %s (LAST_DDL %s): %s' % s for s in skipped]
    md += ['', '## 되돌리기', '- 사내 수정 전 원문: `_artifacts/_apply_corporate/SCP0104_USERFIX_20261117/backup/PKG_SCP0104.ASIS.sql` · 데이터 수정 전 값 `logs/data_before.json`',
           '- 클라우드는 실행 전 원문을 별도로 받아 두었다가 필요 시 재실행한다(이 패키지는 클라우드 백업 파일을 만들지 않는다).', '']
    open(os.path.join(OUT, 'README.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(md))
    print('패키지', len(rows), '구간 합', sum(r[1] for r in rows), '제외', skipped)
    print(OUT)


if __name__ == '__main__':
    main()
