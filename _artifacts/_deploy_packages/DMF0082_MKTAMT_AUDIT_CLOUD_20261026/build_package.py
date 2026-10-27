"""[E20261026-DMF0082-MKTAMTAUDIT] 클라우드 이관 패키지 빌더 — 패치형 (대상 DB USER_SOURCE 를 읽어 바뀐 줄만 치환)

치환 쌍 = 사내 적용 전 원문(_apply_corporate/DMF0082_MKTAMT_AUDIT_20261026/00_BACKUP_PKG_DMF0082.ASIS.sql)
          ↔ 사내 현재 DB 원문(USER_SOURCE, FRESH-GATE 조회) 의 diff 를 그대로 사용 — 손으로 쓴 치환 없음.
  각 쌍은 다음 줄 1줄을 문맥으로 붙여 고유화하고, 기준본에서의 출현 수를 기대값으로 기록한다.
  빌드 검증: 기준본에 모든 쌍을 적용한 결과 == 사내 현재 DB 원문 (바이트 동일) 이어야 패키지를 쓴다.

  python build_package.py build        # A_DB/*.sql 생성 (+ 빌드 검증)
  python build_package.py rehearse     # 사내에 PKG_DMF0082_RH(복제) 로 00→10→10(멱등)→90→99→00 실행·검증 후 DROP
"""
import sys, os, io, re, difflib, datetime, subprocess
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ADB = os.path.join(HERE, "A_DB")
ASIS = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_MKTAMT_AUDIT_20261026\00_BACKUP_PKG_DMF0082.ASIS.sql"
MARK = "E20261026-DMF0082-MKTAMTAUDIT"
TAG = "MKTAMTAUDIT"
OBJ = "PKG_DMF0082"
SQLPLUS = r"C:\oracle\instantclient_23_0\sqlplus.exe"


def connect():
    u, p, d = conn_info()
    cn = oracledb.connect(user=u, password=p, dsn=d)
    cn.call_timeout = 600000
    return cn


def db_body(cur, name=OBJ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=name)
    ld = cur.fetchone()[0]
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=name)
    return "".join(r[0] for r in cur.fetchall()).replace("\r\n", "\n"), ld


def asis_body():
    t = open(ASIS, encoding="utf-8").read().replace("\r\n", "\n")
    t = t[t.index("CREATE OR REPLACE ") + len("CREATE OR REPLACE "):]
    t = t[: t.rstrip().rfind("\n/")] if t.rstrip().endswith("/") else t
    return t


def pairs(base, new):
    """기준본 → 신본 diff 를 (old_block, new_block) 쌍으로. 다음 줄 1줄 문맥 포함·동일 쌍 병합."""
    a, b = base.split("\n"), new.split("\n")
    out = []
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes():
        if tag == "equal":
            continue
        if tag != "replace":
            raise SystemExit(f"ABORT: 예상 밖 diff 유형 {tag} at {i1}")
        ctx = a[i2] if i2 < len(a) else ""
        ob = "\n".join(a[i1:i2] + [ctx]) + "\n"
        nb = "\n".join(b[j1:j2] + [ctx]) + "\n"
        if (ob, nb) not in out:
            out.append((ob, nb))
    return out


def plsql_lit(s):
    if "~" in s:
        raise SystemExit("ABORT: 리터럴에 '~' 포함")
    parts = s.split("\n")
    return " || CHR(10) || ".join(f"q'~{p}~'" if p else "''" for p in parts)


COMMON_FN = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    FUNCTION load_src RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (토큰은 LF 기준)
    END;
"""


def gen_apply(prs, stamp, reverse=False):
    name = "99_ROLLBACK" if reverse else "10_APPLY"
    decl = []
    for k, (o, n) in enumerate(prs, 1):
        src, dst = (n, o) if reverse else (o, n)
        decl.append(f"    c_from{k} CONSTANT VARCHAR2(32767) := {plsql_lit(src)};")
        decl.append(f"    c_to{k}   CONSTANT VARCHAR2(32767) := {plsql_lit(dst)};")
    body = []
    for k, (o, n) in enumerate(prs, 1):
        exp = EXPECT[k - 1]
        body.append(f"""    IF cnt(v_src, c_from{k}) <> {exp} THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - anchor {k} match ' || cnt(v_src, c_from{k}) || ' (expected {exp}). run 00_PRECHECK and send result. source unchanged');
    END IF;
    v_src := REPLACE(v_src, c_from{k}, c_to{k});""")
    skip_cond = "cnt(v_src, c_tag) = 0" if reverse else "cnt(v_src, c_tag) > 0"
    skip_msg = "SKIP - not applied (no tag). source unchanged" if reverse else "SKIP - already applied (tag ' || cnt(v_src, c_tag) || '). source unchanged"
    after_tag = "0" if reverse else str(TAG_LINES)
    return f"""{stamp}
-- {name} — [{MARK}] PKG_DMF0082 BODY {'원복' if reverse else '패치'} (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회의 MKT FCST 금액 메저(MKT_AMT_KRW / MKT_AMT_LOC) 행 LAST UPDATE DATE · LAST UPDATED BY 공란 보완.
--       금액 arm 4곳(GET_MAIN_DATA Current·MF·SF / GET_MAIN_DATA_CURRENT)이 NULL 고정 → 원천(DM_PLN_SALES_PLAN·_C) 행의
--       MAX(CREATION_DATE) · 그 시점 LAST_UPDATED_BY 로 채움 (다른 수요 메저와 같은 규칙).
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 바뀐 줄만 치환 후 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 프로시저·다른 줄 무변경).
--       치환 쌍은 사내 적용 전/후 원문 diff 에서 자동 생성 (build_package.py).
-- 가드: 표식 {'없으면' if reverse else '있으면'} 무동작 · 앵커 수가 기대와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON
DECLARE
    c_obj   CONSTANT VARCHAR2(30) := 'PKG_DMF0082';
    c_tag   CONSTANT VARCHAR2(30) := '{TAG}';
{chr(10).join(decl)}
    v_src   CLOB;
    v_org   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_code  PLS_INTEGER := 0;
    v_msg   VARCHAR2(400);
    v_chk   PLS_INTEGER;
{COMMON_FN}BEGIN
    v_src := load_src;
    v_org := v_src;
    IF {skip_cond} THEN
        DBMS_OUTPUT.PUT_LINE('{skip_msg}');
        RETURN;
    END IF;
{chr(10).join(body)}
    IF cnt(v_src, c_tag) <> {after_tag} THEN
        RAISE_APPLICATION_ERROR(-20004, 'STOP - assembled tag ' || cnt(v_src, c_tag) || ' (expected {after_tag}). source unchanged');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SUBSTR(SQLERRM, 1, 400);   -- ORA-24344(컴파일 오류 동반 생성)만 아래 STATUS 판정으로 진행
    END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20006, 'STOP - CREATE not executed: ' || v_msg || ' (package in use? retry later). source unchanged');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = c_obj AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_org;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = c_obj AND OBJECT_TYPE = 'PACKAGE BODY';
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAILED -> original restored (now ' || v_st || '). run 90_VERIFY');
    END IF;
    SELECT COUNT(*) INTO v_chk FROM USER_SOURCE WHERE NAME = c_obj AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, c_tag) > 0;
    IF v_chk <> {after_tag} THEN
        RAISE_APPLICATION_ERROR(-20007, 'STOP - after CREATE, tag lines in USER_SOURCE = ' || v_chk || ' (expected {after_tag}). run 90_VERIFY');
    END IF;
    DBMS_OUTPUT.PUT_LINE('{'ROLLED BACK' if reverse else 'APPLIED'} - ' || c_obj || ' BODY ' || v_st || ' / {TAG} tag lines ' || v_chk || ' / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
"""


def gen_precheck(prs, stamp):
    decl = [f"    c_from{k} CONSTANT VARCHAR2(32767) := {plsql_lit(o)};" for k, (o, n) in enumerate(prs, 1)]
    checks = [f"    DBMS_OUTPUT.PUT_LINE('P1 anchor {k} = ' || cnt(v_src, c_from{k}) || ' (expected {EXPECT[k-1]})' || CASE WHEN cnt(v_src, c_from{k}) = {EXPECT[k-1]} THEN ' PASS' ELSE ' FAIL' END);"
              for k in range(1, len(prs) + 1)]
    return f"""{stamp}
-- 00_PRECHECK — 조회 전용 (전체 F5). [{MARK}] 적용 가능 여부
--   P0 대상 DB · PKG_DMF0082 BODY 상태 / P1 표식 · 앵커별 매칭 수 (전부 PASS 여야 10 적용 가능, 표식 > 0 이면 이미 적용)
--   P2 원천 데이터 — 금액 메저 행의 수정 정보 공란 수 (0 이어야 적용 후 화면에 값이 나온다)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON
SELECT 'P0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
DECLARE
    c_obj   CONSTANT VARCHAR2(30) := 'PKG_DMF0082';
    c_tag   CONSTANT VARCHAR2(30) := '{TAG}';
{chr(10).join(decl)}
    v_src   CLOB;
{COMMON_FN}BEGIN
    v_src := load_src;
    DBMS_OUTPUT.PUT_LINE('P1 tag {TAG} = ' || cnt(v_src, c_tag) || CASE WHEN cnt(v_src, c_tag) > 0 THEN ' (이미 적용 — 10 은 무동작)' ELSE ' (미적용)' END);
    IF cnt(v_src, c_tag) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('P1 anchor 검사 생략 — 이미 적용된 원문이라 적용 전 문구가 없는 것이 정상. 90_VERIFY 로 확인');
        RETURN;
    END IF;
{chr(10).join(checks)}
END;
/
SELECT 'P2' CHK, 'DM_PLN_SALES_PLAN' TBL, MEASURE, COUNT(*) N
     , SUM(CASE WHEN CREATION_DATE IS NULL OR LAST_UPDATED_BY IS NULL THEN 1 ELSE 0 END) N_AUDIT_NULL
  FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID LIKE '81%' AND MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC') GROUP BY MEASURE
UNION ALL
SELECT 'P2', 'DM_PLN_SALES_PLAN_C', MEASURE, COUNT(*)
     , SUM(CASE WHEN CREATION_DATE IS NULL OR LAST_UPDATED_BY IS NULL THEN 1 ELSE 0 END)
  FROM SCM_MGR.DM_PLN_SALES_PLAN_C WHERE DIVISION_ID LIKE '81%' AND MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC')
   AND YYYYMMDD >= TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMMDD') GROUP BY MEASURE;
"""


def gen_verify(stamp):
    return f"""{stamp}
-- 90_VERIFY — 조회 전용 (전체 F5). [{MARK}] 적용 결과
--   V1 BODY VALID · 오류 0 / V2 표식 줄 수 = {TAG_LINES} / V3 금액 arm 4곳에 NULL 고정 잔존 0
SELECT 'V1' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
     , (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) N_ERR
  FROM USER_OBJECTS O WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT 'V2' CHK, COUNT(*) TAG_LINES, CASE WHEN COUNT(*) = {TAG_LINES} THEN 'PASS' ELSE 'FAIL (기대 {TAG_LINES})' END JUDGE
  FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, '{TAG}') > 0;
-- V3 대상 패턴만: 금액 arm 의 NULL 고정 줄(단일줄 'NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY' 3곳 + 두줄형의 'NULL AS LAST_UPDATED_BY' 1곳)
--    ※ 고객 FCST arm 의 단독 ', NULL AS CREATE_DATE' 줄은 이번 수정 대상이 아님 (수정자를 다른 식으로 채우는 기존 동작)
SELECT 'V3' CHK, COUNT(*) NULL_AUDIT_LINES_LEFT, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END JUDGE
  FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY'
   AND (   REGEXP_LIKE(TEXT, '^\\s*, NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY\\s*$')
        OR REGEXP_LIKE(TEXT, '^\\s*, NULL AS LAST_UPDATED_BY\\s*$'));
"""


EXPECT, TAG_LINES = [], 0


def build():
    global EXPECT, TAG_LINES
    cn = connect(); cur = cn.cursor()
    new, ld = db_body(cur)            # 사내 현재 DB 원문 (USER_SOURCE 재조회)
    base = asis_body()
    if TAG in base or TAG not in new:
        raise SystemExit("ABORT: 기준본에 표식 있음 또는 신본에 표식 없음")
    prs = pairs(base, new)
    EXPECT = [base.count(o) for o, _ in prs]
    t = base
    for o, n in prs:
        t = t.replace(o, n)
    if t != new:
        raise SystemExit("ABORT: 빌드 검증 실패 — 기준본+치환쌍 != 사내 현재 원문")
    TAG_LINES = sum(1 for l in new.split("\n") if TAG in l)
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={ld} FETCHED={fetched} DB=ZIOUI1 (치환쌍 기준 = 사내 적용 전/후 diff)"
    os.makedirs(ADB, exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": gen_precheck(prs, stamp),
             "10_APPLY_MKTAMTAUDIT_PATCH.sql": gen_apply(prs, stamp),
             "90_VERIFY.sql": gen_verify(stamp),
             "99_ROLLBACK_MKTAMTAUDIT_PATCH.sql": gen_apply(prs, stamp, reverse=True)}
    for f, c in files.items():
        open(os.path.join(ADB, f), "w", encoding="utf-8", newline="\n").write(c)
    print(f"BUILD OK — 치환쌍 {len(prs)} · 기대 출현 {EXPECT} · 표식 줄 {TAG_LINES} · 기준 LAST_DDL {ld} · 빌드검증(기준본+쌍==사내 원문) PASS")
    for k, (o, n) in enumerate(prs, 1):
        print(f"  쌍{k} ×{EXPECT[k-1]}: - {o.splitlines()[0].strip()[:90]}")
    cn.close()


def run_sql(path, out):
    kv = {}
    for line in open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8", errors="ignore"):
        if "=" in line and line.startswith("TOBE_DB_"):
            k, v = line.strip().split("=", 1); kv[k] = v
    conn = f"{kv['TOBE_DB_USER']}/\"{kv['TOBE_DB_PASS']}\"@//{kv['TOBE_DB_HOST']}:{kv['TOBE_DB_PORT']}/{kv['TOBE_DB_PDB']}"
    runner = os.path.join(HERE, "_rehearsal_out", "_runner.sql")
    open(runner, "w", encoding="utf-8", newline="\n").write(f'SPOOL "{out}"\n@"{path}"\nSPOOL OFF\nEXIT\n')
    env = dict(os.environ, NLS_LANG="KOREAN_KOREA.AL32UTF8")
    subprocess.run([SQLPLUS, "-S", "-L", conn, "@" + runner], env=env, capture_output=True)
    os.remove(runner)
    return open(out, encoding="utf-8", errors="replace").read()


def rehearse():
    """사내에 PKG_DMF0082_RH(스펙·바디 복제, 바디 = 적용 전 기준본)를 만들어 패키지 SQL 을 그대로 돌린다."""
    rh = "PKG_DMF0082_RH"
    od = os.path.join(HERE, "_rehearsal_out"); os.makedirs(od, exist_ok=True)
    cn = connect(); cur = cn.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE' ORDER BY LINE")
    spec = "".join(r[0] for r in cur.fetchall())
    base = asis_body()
    new_live, _ = db_body(cur)
    def core(s):  # 비교용 — 첫 줄(PACKAGE BODY 이름)과 맨 끝 END 라벨 줄 제외, 끝 공백 정리
        ls = s.rstrip().split("\n")
        return "\n".join(ls[1:-1])

    def ren(s):   # 머리 PACKAGE [BODY] 이름 + 맨 끝 END 라벨만 RH 로 (본문 중간 문자열 무변경)
        s = re.sub(r'^(PACKAGE(\s+BODY)?\s+)"?PKG_DMF0082"?', r"\1" + rh, s, count=1, flags=re.I)
        return re.sub(r'END\s+"?PKG_DMF0082"?\s*;(\s*)$', f"END {rh};\\1", s, count=1, flags=re.I)
    cur.execute("CREATE OR REPLACE " + ren(spec))
    cur.execute("CREATE OR REPLACE " + ren(base))
    print("RH 생성:", cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=rh).fetchone())
    steps = [("01_00_PRECHECK", "00_PRECHECK_CLOUD.sql"), ("02_10_APPLY", "10_APPLY_MKTAMTAUDIT_PATCH.sql"),
             ("03_10_APPLY_again", "10_APPLY_MKTAMTAUDIT_PATCH.sql"), ("04_90_VERIFY", "90_VERIFY.sql"),
             ("05_99_ROLLBACK", "99_ROLLBACK_MKTAMTAUDIT_PATCH.sql"), ("06_99_ROLLBACK_again", "99_ROLLBACK_MKTAMTAUDIT_PATCH.sql"),
             ("07_10_APPLY_reapply", "10_APPLY_MKTAMTAUDIT_PATCH.sql")]
    results = {}
    try:
        for tag, f in steps:
            src = open(os.path.join(ADB, f), encoding="utf-8").read()
            src = src.replace("'PKG_DMF0082'", f"'{rh}'")      # 대상 객체만 RH 로 (본문 내 다른 문자열 무변경)
            tmp = os.path.join(od, f"_{tag}.sql")
            open(tmp, "w", encoding="utf-8", newline="\n").write(src)
            txt = run_sql(tmp, os.path.join(od, f"{tag}.out.txt"))
            os.remove(tmp)
            key = [l.strip() for l in txt.splitlines() if re.search(r"APPLIED|ROLLED BACK|SKIP|STOP|FAIL|PASS|ORA-|PLS-|SP2-|^V\d|P1 ", l)]
            results[tag] = key
            print(f"== {tag}"); [print("   ", k[:160]) for k in key]
            if tag in ("02_10_APPLY", "07_10_APPLY_reapply"):
                rhb, _ = db_body(cur, rh)
                print(f"    RH 적용본 == 사내 PKG_DMF0082 현재본(머리줄·END 라벨 제외): {core(rhb) == core(new_live)}")
            if tag == "05_99_ROLLBACK":
                rhb, _ = db_body(cur, rh)
                print(f"    RH 원복본 == 적용 전 기준본(머리줄·END 라벨 제외): {core(rhb) == core(base)}")
    finally:
        for t in ("PACKAGE", ):
            try: cur.execute(f"DROP PACKAGE {rh}")
            except Exception as e: print("DROP 실패:", e)
        print("RH DROP:", cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=rh).fetchone()[0] == 0)
        cn.close()


if __name__ == "__main__":
    {"build": build, "rehearse": lambda: (build(), rehearse())}[sys.argv[1] if len(sys.argv) > 1 else "build"]()
