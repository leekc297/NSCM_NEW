# -*- coding: utf-8 -*-
"""patchgen — PKG/코드 '수정분만' 클라우드 패치 생성 (cloud_pkg 1.4.0 · 2026-11-11)

수정본(delta)에서 PKG SPEC/BODY 를 사내 전체본으로 덮지 않고, 클라우드 자기 USER_SOURCE 를 읽어
바뀐 구간(hunk)만 치환한 뒤 CREATE OR REPLACE 한다 (2026-10-15 GAP452 DMF0082 수작업 패치 형식의 자동화).

  기준본(변경 전 원문) 찾기
    1) _cloud_state/<ID>/applied_src/<NAME>__<TYPE>.sql — 이관 완료 표시(--applied) 때 확정한 원문(클라우드 = 이 원문)
    2) _artifacts/_apply_corporate/** 의 사내 적용 백업(.ASIS·BACKUP_·00_BACKUP 등) 중 이 객체 원문이 든 가장 최근 파일
       (현재 사내 원문과 같은 파일은 건너뜀 — 적용 전 원문이 아니므로)
  hunk = difflib 그룹(앞뒤 3줄 문맥) · 기준본 안에서 1건만 나오도록 문맥을 넓힘(최대 20줄) · 파이썬에서 기준본에 순서대로 적용해
         현재 사내 원문과 정확히 같아지는지 확인한 것만 패치로 쓴다(아니면 전체본으로 대체).
  클라우드 실행 가드
    · 이미 사내와 같음(정규화 원문 해시·길이) → SKIP
    · 각 hunk 기준 문구가 클라우드 원문에 정확히 1건이 아니면 중단(원문 무변경) → 전체 메뉴 안내
    · 조립 결과 해시·길이가 사내 원문과 다르면 중단(원문 무변경)
    · 컴파일 오류(ORA-24344 포함) → 원문 자동 복원 후 오류 보고
  해시 = 1,000자 조각마다 DBMS_UTILITY.GET_HASH_VALUE(순번~조각) 합 — 기대값은 빌드 때 사내에서 같은 함수로 계산.
  줄바꿈 = CRLF → LF 정규화 후 비교·치환(사내 원문에 CRLF 가 섞여 있음).
"""
import os, re, glob, difflib

CTX = 3
MAX_CTX = 20
MAX_BLOCK = 20000   # DBMS_LOB.INSTR 패턴 한계(32767바이트) 안쪽 — 한글 3바이트 고려

HV_FUNC = """    FUNCTION hv(c CLOB) RETURN NUMBER IS
        n NUMBER := 0; p INTEGER := 1; i INTEGER := 0; l INTEGER := NVL(DBMS_LOB.GETLENGTH(c), 0);
    BEGIN
        WHILE p <= l LOOP
            i := i + 1;
            n := n + DBMS_UTILITY.GET_HASH_VALUE(i || '~' || DBMS_LOB.SUBSTR(c, 1000, p), 1, 1073741824);
            p := p + 1000;
        END LOOP;
        RETURN n;
    END;"""


def norm(s):
    return (s or '').replace('\r\n', '\n')


def _type_re(typ):
    if typ == 'PACKAGE':
        return r'PACKAGE(?!\s+BODY)'
    return r'\s+'.join(typ.split())


def extract_obj(text, name, typ):
    """파일 텍스트에서 CREATE OR REPLACE <typ> <name> … 다음 '/' 단독 줄 직전까지 = 원문(‘CREATE OR REPLACE ’ 뒤)"""
    rx = re.compile(r'CREATE\s+OR\s+REPLACE\s+(?:EDITIONABLE\s+|NONEDITIONABLE\s+)?(' + _type_re(typ) +
                    r'\s+(?:"?SCM_MGR"?\.)?"?' + re.escape(name) + r'"?(?=[\s(]))', re.I)
    m = rx.search(text)
    if not m:
        return None
    start = m.start(1)
    e = re.search(r'\r?\n/[ \t]*(\r?\n|$)', text[start:])
    if not e:
        return None
    return text[start:start + e.start()]


BACKUP_NAME = re.compile(r'(ASIS|BACKUP|BEFORE|_BASE|PRE_|_OLD\b|ROLLBACK)', re.I)
NOT_BACKUP = re.compile(r'(TOBE|_NEW|PATCHED|AFTER|APPLY|FIXED|_CLOUD_)', re.I)


def find_base(root, state_root, ID, name, typ, cur_src, last_ddl=None):
    """(기준본 원문, 출처 설명) — 없으면 (None, 사유)
    사내 적용 백업 후보 = 파일명에 ASIS/BACKUP/BEFORE/PRE_ 등 '적용 전' 표지가 있고 TOBE/NEW/PATCHED/AFTER 가 없는 것,
    그리고 객체 LAST_DDL(+5분) 이전에 만든 것만 — 적용하지 않은 변경안(.TOBE)을 기준본으로 잡지 않는다."""
    cur_n = norm(cur_src).rstrip()
    p = os.path.join(state_root, ID, 'applied_src', f"{name}__{typ.replace(' ', '_')}.sql")
    if os.path.isfile(p):
        t = open(p, encoding='utf-8').read()
        if norm(t).rstrip() == cur_n:
            return None, '이관 완료 원문과 사내 원문이 같음(변경 없음)'
        return t, f"이관 완료 표시 원문 {os.path.relpath(p, root)}"
    cands = []
    for f in glob.glob(os.path.join(root, '_artifacts', '_apply_corporate', '**', '*.sql'), recursive=True):
        bn = os.path.basename(f)
        rel = os.path.relpath(f, root)
        if name.upper() not in bn.upper() or not BACKUP_NAME.search(rel) or NOT_BACKUP.search(bn):
            continue
        try:
            mt = os.path.getmtime(f)
        except OSError:
            continue
        if last_ddl is not None and mt > last_ddl + 300:
            continue
        cands.append((mt, f))
    for _, f in sorted(cands, reverse=True):
        try:
            t = open(f, encoding='utf-8', errors='replace').read()
        except OSError:
            continue
        src = extract_obj(t, name, typ)
        if not src or len(src) < 50:
            continue
        if norm(src).rstrip() == cur_n:
            continue
        return src, f"사내 적용 백업 {os.path.relpath(f, root)}"
    return None, '기준본(이관 완료 원문·사내 적용 백업) 없음'


def make_hunks(base, cur):
    """기준본 → 사내 원문 hunk 목록 [(old, new, desc)] · 검증 실패 시 (None, 사유)"""
    b = norm(base).splitlines(keepends=True)
    c = norm(cur).splitlines(keepends=True)
    btxt, ctxt = ''.join(b), ''.join(c)
    sm = difflib.SequenceMatcher(None, b, c, autojunk=False)
    hunks = []
    for g in sm.get_grouped_opcodes(CTX):
        i1, i2, j1, j2 = g[0][1], g[-1][2], g[0][3], g[-1][4]
        k = 0
        while True:
            old = ''.join(b[i1:i2])
            if old and btxt.count(old) == 1:
                break
            if k >= MAX_CTX or (i1 == 0 and i2 == len(b)):
                return None, f'변경 구간 기준 문구가 유일하지 않음(L{i1 + 1}~{i2})'
            if i1 > 0 and j1 > 0:
                i1 -= 1
                j1 -= 1
            if i2 < len(b) and j2 < len(c):
                i2 += 1
                j2 += 1
            k += 1
        new = ''.join(c[j1:j2])
        if len(old) > MAX_BLOCK or len(new) > MAX_BLOCK:
            return None, f'변경 구간이 큼(L{i1 + 1}~{i2} · {max(len(old), len(new))}자)'
        dels = sum(x[2] - x[1] for x in g if x[0] in ('replace', 'delete'))
        adds = sum(x[4] - x[3] for x in g if x[0] in ('replace', 'insert'))
        hunks.append((old, new, f'기준본 L{i1 + 1}~{i2} → 사내 L{j1 + 1}~{j2} (삭제 {dels}줄 · 추가 {adds}줄)'))
    t = btxt
    for old, new, d in hunks:
        if t.count(old) != 1:
            return None, f'순차 적용 검증 실패({d})'
        t = t.replace(old, new, 1)
    if t != ctxt:
        return None, '순차 적용 결과가 사내 원문과 다름'
    return hunks, f'{len(hunks)}개 구간'


def expect_hash(cur_db, text):
    """사내 DB 에서 클라우드와 같은 함수로 정규화 원문 해시·길이 계산"""
    import oracledb
    out_h = cur_db.var(oracledb.NUMBER)
    out_l = cur_db.var(oracledb.NUMBER)
    v = cur_db.var(oracledb.DB_TYPE_CLOB)
    v.setvalue(0, text)
    cur_db.execute("DECLARE\n" + HV_FUNC + "\nBEGIN\n    :h := hv(:c);\n    :l := NVL(DBMS_LOB.GETLENGTH(:c), 0);\nEND;", h=out_h, l=out_l, c=v)
    return int(out_h.getvalue()), int(out_l.getvalue())


def plsql_patch(name, typ, hunks, h, l, base_label, clob_assign):
    L = [f"""/* {typ} {name} — 수정분만 패치 · 기준본 = {base_label}
 * 변경 {len(hunks)}개 구간: """ + ' / '.join(d for _, _, d in hunks).replace('*/', '* /') + """
 * 가드: 이미 사내와 같으면 SKIP · 구간 기준 문구가 1건이 아니면 중단(원문 무변경) · 조립 결과 ≠ 사내 원문이면 중단 · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_cnt   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
""" + HV_FUNC + f"""
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
    PROCEDURE hunk(k PLS_INTEGER) IS
    BEGIN
        v_cnt := cnt(v_new, v_o);
        IF v_cnt <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — {typ} {name} 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{name}' AND TYPE = '{typ}' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 {typ} {name} 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = {h} AND DBMS_LOB.GETLENGTH(v_src) = {l} THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  {typ} {name} — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;
"""]
    for k, (old, new, d) in enumerate(hunks, 1):
        L.append(f"    -- 변경 {k}: {d}")
        L += clob_assign('v_o', old)
        L += clob_assign('v_n', new)
        L.append(f"    hunk({k});")
    L.append(f"""    IF hv(v_new) <> {h} OR DBMS_LOB.GETLENGTH(v_new) <> {l} THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — {typ} {name} 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   {typ} {name} — 패치 {len(hunks)}개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{name}' AND OBJECT_TYPE = '{typ}';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{name}' AND TYPE = '{typ}';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{name}' AND TYPE = '{typ}' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, '{typ} {name} 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY {typ} {name} — 패치 {len(hunks)}개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
""")
    return L


def plsql_check_same(name, typ, h, l, base_label):
    """기준본과 사내가 같은 타입(예: SPEC 무변경) — 적용 없이 클라우드가 사내와 같은지만 알린다"""
    return [f"""/* {typ} {name} — 변경 없음(기준본 = {base_label}) · 적용하지 않고 클라우드 원문이 사내와 같은지만 확인 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_src   CLOB;
""" + HV_FUNC + f"""
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{name}' AND TYPE = '{typ}' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));
    IF hv(v_src) = {h} AND NVL(DBMS_LOB.GETLENGTH(v_src), 0) = {l} THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  {typ} {name} — 변경 없음 · 클라우드 원문 = 사내');
    ELSE
        DBMS_OUTPUT.PUT_LINE('> WARN  {typ} {name} — 변경 없음이지만 클라우드 원문이 사내와 다름(적용 안 함 · 필요하면 전체 메뉴 패키지)');
    END IF;
END;
/
"""]
