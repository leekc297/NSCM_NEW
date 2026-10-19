#!/usr/bin/env python3
"""
GAP 413 클라우드 이관 패키지 생성기 — DMF0072 빈값(NULL/''/' '/'-'/'--'/'/') 통일 비교

방식: 클라우드 DB 는 Claude 가 접속 불가 → 클라우드 원문을 볼 수 없으므로 객체 전체 덮어쓰기 ⛔.
      01_APPLY 가 클라우드 DB 안에서 ALL_SOURCE 를 직접 읽고,
        ① 공백 제거 비교로 "사내 대상 라인과 같은 모양" 라인을 찾고
        ② 같은 모양이 대상 밖에도 있는 객체가 있으므로 "몇 번째 출현인지"로 대상을 지정
        ③ 대상 라인에만 사내 적용(build_apply.py)과 동일한 정규식 치환 (라인 내 공백·들여쓰기는 원문 보존)
        ④ 대상 수·같은 모양 총수가 사내와 같을 때만 CREATE OR REPLACE, 아니면 원문 무변경 중단
        ⑤ 컴파일 오류 시 같은 블록에서 원래 원문으로 재생성(자동 원복)

기준본: 사내 ZIOUI1 — FRESH-GATE(DB 현재 원문 == G413 적용본 PATCH_*.sql) 통과 시에만 생성.
검증: PL/SQL 치환 로직을 Python 으로 재현해 사내 ORIG→PATCH, PATCH→ORIG 바이트 일치 확인.
사용: python build_cloud_pkg.py
"""
import sys, re, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import ora  # noqa: E402
import oracledb  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
SRC = HERE.parents[1] / "_apply_corporate" / "G413_DMF0072_SENTINEL_20261015"
MARK = "  /* 2026.10.15 GAP413 센티널 통일 */"
SEP = ",\n        "

OBJS = [  # (name, type, file tag, kind)
    ("PKG_DMF0072", "PACKAGE BODY", "PKG_DMF0072_BODY", "AT"),
    ("PR_DM_CUST_MODEL_MAPPING", "PROCEDURE", "PR_DM_CUST_MODEL_MAPPING", "RT"),
    ("PR_DM_CUST_MODEL_MAPPING_IF", "PROCEDURE", "PR_DM_CUST_MODEL_MAPPING_IF", "RT"),
    ("PR_DM_DNM_EDI_CALLOFF_MKT_FCST", "PROCEDURE", "PR_DM_DNM_EDI_CALLOFF_MKT_FCST", "RT"),
    ("PR_DM_PLN_CUST_FCST_RECORD", "PROCEDURE", "PR_DM_PLN_CUST_FCST_RECORD", "RT"),
]

# Oracle 정규식 (POSIX ERE) — build_apply.py 의 RX_RTRIM / RX_AT 와 동일 의미
ORA_RX = {
    "RT": (r"NVL\(RTRIM\(LTRIM\(([A-Z0-9_.]+(\(\+\))?)\)\),[[:space:]]*'([ /])'\)",
           r"NVL(NULLIF(NULLIF(NULLIF(RTRIM(LTRIM(\1)),'-'),'--'),'/'), '\3')"),
    "AT": (r"NVL\(TRIM\(((A|REC)\.(UNLOADING_POINT|CUSTOMER_PLANT|CUSTOMER_ITEM_ID))\),[[:space:]]*'@#@#@#'\)",
           r"NVL(NULLIF(NULLIF(NULLIF(TRIM(\1),'-'),'--'),'/'), '@#@#@#')"),
}
ORA_RX_BACK = {  # 원복용 역치환
    "RT": (r"NVL\(NULLIF\(NULLIF\(NULLIF\(RTRIM\(LTRIM\(([A-Z0-9_.]+(\(\+\))?)\)\),'-'\),'--'\),'/'\), '([ /])'\)",
           r"NVL(RTRIM(LTRIM(\1)), '\3')"),
    "AT": (r"NVL\(NULLIF\(NULLIF\(NULLIF\(TRIM\(((A|REC)\.(UNLOADING_POINT|CUSTOMER_PLANT|CUSTOMER_ITEM_ID))\),'-'\),'--'\),'/'\), '@#@#@#'\)",
           r"NVL(TRIM(\1), '@#@#@#')"),
}
MARK_RX = r"  /\* 2026\.10\.15 GAP413[^*]*\*/"


def compact(s):
    return re.sub(r"\s", "", s)


def py_rx(ora_pat):
    return ora_pat.replace("[[:space:]]", r"\s")


def py_rep(ora_rep):
    return re.sub(r"\\(\d)", r"\\g<\1>", ora_rep)


def sim_apply(lines, kind, occ):
    """01_APPLY PL/SQL 로직의 Python 재현. occ = {compact: set(대상 출현 순번)}."""
    pat, rep = ORA_RX[kind]
    out, hits, match, cnt = [], 0, 0, {}
    for t in lines:
        c = compact(t)
        hit = False
        if c in occ:
            match += 1
            cnt[c] = cnt.get(c, 0) + 1
            hit = cnt[c] in occ[c]
        if hit:
            nl = "\n" if t.endswith("\n") else ""
            body = t.rstrip("\n")
            assert re.search(py_rx(pat), body)
            body = re.sub(py_rx(pat), py_rep(rep), body)
            if " -- " not in body and not body.rstrip().endswith("*/"):
                body += MARK
            t = body + nl
            hits += 1
        out.append(t)
    return out, hits, match


def sim_back(lines, kind):
    pat, rep = ORA_RX_BACK[kind]
    out = []
    for t in lines:
        if "GAP413" in t:
            nl = "\n" if t.endswith("\n") else ""
            body = re.sub(MARK_RX, "", t.rstrip("\n"))
            t = re.sub(py_rx(pat), py_rep(rep), body) + nl
        out.append(t)
    return out


def body_lines(path):
    """PATCH_/ORIG_ 파일 → ALL_SOURCE 라인 목록."""
    t = path.read_text(encoding="utf-8").split("\n", 2)[2]
    assert t.startswith("CREATE OR REPLACE ")
    t = t[len("CREATE OR REPLACE "):]
    assert t.endswith("\n/\n")
    return t[:-len("/\n")].splitlines(keepends=True)


def q(s):
    """표준 작은따옴표 리터럴 (q-quote 는 클라이언트 문장 분리기가 내부 ';' 를 오인할 수 있어 사용 안 함)."""
    assert "\t" not in s, f"탭 금지: {s!r}"
    return "'" + s.replace("'", "''") + "'"


PLSQL_HEAD = """DECLARE
    TYPE T_VC IS TABLE OF VARCHAR2(4000);
    PROCEDURE P_PATCH(P_NAME VARCHAR2, P_TYPE VARCHAR2, P_EXPECT NUMBER, P_TOTAL NUMBER,
                      P_PAT VARCHAR2, P_REP VARCHAR2, P_SCOPE T_VC, P_OCC T_VC) IS
        TYPE T_NUM IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        V_CNT    T_NUM;
        V_SRC    CLOB;
        V_ORIG   CLOB;
        V_LINE   VARCHAR2(4000);
        V_BODY   VARCHAR2(4000);
        V_CMP    VARCHAR2(4000);
        V_NL     VARCHAR2(1);
        V_HIT    BOOLEAN;
        V_HITS   NUMBER := 0;
        V_MATCH  NUMBER := 0;
        V_MARKED NUMBER;
        V_ERRS   NUMBER;
    BEGIN
        SELECT COUNT(*) INTO V_MARKED FROM ALL_SOURCE
         WHERE OWNER = 'SCM_MGR' AND NAME = P_NAME AND TYPE = P_TYPE AND INSTR(TEXT, 'GAP413') > 0;
        IF {SKIP_COND} THEN
            DBMS_OUTPUT.PUT_LINE('SKIP     ' || P_NAME || ' - {SKIP_MSG} (GAP413 marked lines=' || V_MARKED || ')');
            RETURN;
        END IF;
        DBMS_LOB.CREATETEMPORARY(V_SRC, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_ORIG, TRUE);
        DBMS_LOB.APPEND(V_SRC, 'CREATE OR REPLACE ');
        DBMS_LOB.APPEND(V_ORIG, 'CREATE OR REPLACE ');
        FOR R IN (SELECT TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = P_NAME AND TYPE = P_TYPE ORDER BY LINE) LOOP
            DBMS_LOB.APPEND(V_ORIG, R.TEXT);
            V_LINE := R.TEXT;
            V_NL   := CASE WHEN SUBSTR(R.TEXT, -1) = CHR(10) THEN CHR(10) END;
{LINE_LOGIC}
            DBMS_LOB.APPEND(V_SRC, V_LINE);
        END LOOP;
        IF V_HITS <> P_EXPECT OR V_MATCH <> P_TOTAL THEN
            RAISE_APPLICATION_ERROR(-20413, P_NAME || ' target lines ' || V_HITS || '/' || P_EXPECT
                || ', same-shape lines ' || V_MATCH || '/' || P_TOTAL
                || ' - cloud source differs from corporate. NOT applied (source unchanged). Send 00_PRECHECK result.');
        END IF;
        BEGIN
            EXECUTE IMMEDIATE V_SRC;
        EXCEPTION WHEN OTHERS THEN NULL;  -- compile error (ORA-24344) is judged by ALL_ERRORS below
        END;
        SELECT COUNT(*) INTO V_ERRS FROM ALL_ERRORS WHERE OWNER = 'SCM_MGR' AND NAME = P_NAME AND TYPE = P_TYPE;
        IF V_ERRS > 0 THEN
            EXECUTE IMMEDIATE V_ORIG;  -- auto restore
            RAISE_APPLICATION_ERROR(-20414, P_NAME || ' compile errors ' || V_ERRS || ' - restored original source');
        END IF;
        DBMS_OUTPUT.PUT_LINE('{DONE_MSG} ' || P_NAME || ' - lines ' || V_HITS);
    END P_PATCH;
BEGIN
"""

APPLY_LINE_LOGIC = """            V_CMP  := REGEXP_REPLACE(R.TEXT, '[[:space:]]', '');
            V_HIT  := FALSE;
            FOR I IN 1 .. P_SCOPE.COUNT LOOP
                IF V_CMP = P_SCOPE(I) THEN
                    V_MATCH  := V_MATCH + 1;
                    V_CNT(I) := CASE WHEN V_CNT.EXISTS(I) THEN V_CNT(I) ELSE 0 END + 1;
                    V_HIT    := INSTR(P_OCC(I), ',' || V_CNT(I) || ',') > 0;
                    EXIT;
                END IF;
            END LOOP;
            IF V_HIT THEN
                V_BODY := RTRIM(R.TEXT, CHR(10));
                IF REGEXP_COUNT(V_BODY, P_PAT) = 0 THEN
                    RAISE_APPLICATION_ERROR(-20415, P_NAME || ' target line has no pattern: ' || SUBSTR(V_BODY, 1, 200));
                END IF;
                V_BODY := REGEXP_REPLACE(V_BODY, P_PAT, P_REP);
                IF INSTR(V_BODY, ' -- ') = 0 AND SUBSTR(RTRIM(V_BODY), -2) <> '*/' THEN
                    V_BODY := V_BODY || '""" + MARK + """';
                END IF;
                V_LINE := V_BODY || V_NL;
                V_HITS := V_HITS + 1;
            END IF;"""

BACK_LINE_LOGIC = """            IF INSTR(R.TEXT, 'GAP413') > 0 THEN
                V_BODY := REGEXP_REPLACE(RTRIM(R.TEXT, CHR(10)), '""" + MARK_RX + """', '');
                V_LINE := REGEXP_REPLACE(V_BODY, P_PAT, P_REP) || V_NL;
                V_HITS := V_HITS + 1;
                V_MATCH := V_MATCH + 1;
            END IF;"""


def main():
    u, p, d = ora.conn_info()
    cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
    print("DB =", cur.fetchone())
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    specs, stamps = [], []
    for name, typ, tag, kind in OBJS:
        orig = body_lines(SRC / f"ORIG_{tag}.sql")
        patch = body_lines(SRC / f"PATCH_{tag}.sql")
        # FRESH-GATE: 사내 DB 현재 원문(ALL_SOURCE) == 적용본
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
        db = "".join(r[0] for r in cur.fetchall()).rstrip()
        assert db == "".join(patch).rstrip(), f"FRESH-GATE 실패: {name} 사내 원문 ≠ G413 적용본 — 중단"
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        stamps.append(f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={cur.fetchone()[0]} FETCHED={now} DB=ZIOUI1")
        assert len(orig) == len(patch)
        changed_c = {compact(o) for o, n in zip(orig, patch) if o != n}
        occ, cnt = {}, {}
        for o, n in zip(orig, patch):
            c = compact(o)
            if c in changed_c:
                cnt[c] = cnt.get(c, 0) + 1
                if o != n:
                    occ.setdefault(c, set()).add(cnt[c])
        olds = sorted(occ)
        exp = sum(len(v) for v in occ.values())
        total = sum(cnt.values())
        sim, hits, match = sim_apply(orig, kind, occ)
        assert hits == exp and match == total and sim == patch, f"{name}: 적용 재현 ≠ PATCH"
        assert sim_back(patch, kind) == orig, f"{name}: 원복 재현 ≠ ORIG"
        occs = ["," + ",".join(map(str, sorted(occ[k]))) + "," for k in olds]
        specs.append((name, typ, kind, olds, exp, total, occs))
        print(f"{name}: 대상 {exp} / 같은 모양 총 {total} (고유 {len(olds)}) — 적용·원복 재현 바이트 일치")

    hdr = "\n".join(stamps)

    # ---------- 00_PRECHECK (조회 전용) ----------
    rows = []
    for name, typ, kind, olds, exp, total, occs in specs:
        rows.append(
            f"SELECT '{name}' AS OBJ, '{typ}' AS OBJ_TYPE, {total} AS EXPECT_MATCH, {exp} AS EXPECT_TARGET,\n"
            f"       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME='{name}' AND S.TYPE='{typ}'\n"
            f"           AND REGEXP_REPLACE(S.TEXT,'[[:space:]]','') IN (\n        {SEP.join(q(k) for k in olds)})) AS MATCH_LINES,\n"
            f"       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME='{name}' AND S.TYPE='{typ}'\n"
            f"           AND INSTR(S.TEXT,'GAP413')>0) AS ALREADY_MARKED,\n"
            f"       (SELECT STATUS||' / '||TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O\n"
            f"         WHERE O.OWNER='SCM_MGR' AND O.OBJECT_NAME='{name}' AND O.OBJECT_TYPE='{typ}') AS STATUS_LAST_DDL\n"
            f"  FROM DUAL")
    pre = (
        "-- =====================================================================================\n"
        "-- 00_PRECHECK.sql  GAP413 DMF0072 빈값 통일 비교 / 클라우드 적용 전 판정 (조회 전용, 전체 F5 안전)\n"
        "-- 판정(5행 각각):\n"
        "--   MATCH_LINES = EXPECT_MATCH 이고 ALREADY_MARKED = 0  -> 01_APPLY 실행 가능\n"
        "--   ALREADY_MARKED = EXPECT_TARGET                       -> 이미 적용됨 (01_APPLY 실행해도 SKIP)\n"
        "--   그 외                                               -> 클라우드 원문이 사내와 다름. 적용하지 말고 결과 회신\n"
        "-- (EXPECT_MATCH = 같은 모양 라인 총수 / EXPECT_TARGET = 그중 치환 대상 수)\n"
        "-- =====================================================================================\n"
        + hdr + "\n\n" + "\nUNION ALL\n".join(rows) + ";\n")

    def block(skip_cond, skip_msg, done_msg, line_logic, rx, is_apply):
        head = (PLSQL_HEAD.replace("{SKIP_COND}", skip_cond).replace("{SKIP_MSG}", skip_msg)
                .replace("{DONE_MSG}", done_msg).replace("{LINE_LOGIC}", line_logic))
        calls = ""
        for name, typ, kind, olds, exp, total, occs in specs:
            pat, rep = rx[kind]
            sc = SEP.join(q(k) for k in olds) if is_apply else "'-'"
            oc = SEP.join(q(o) for o in occs) if is_apply else "'-'"
            calls += (f"    P_PATCH('{name}', '{typ}', {exp}, {total if is_apply else exp},\n"
                      f"      {q(pat)},\n      {q(rep)},\n"
                      f"      T_VC(\n        {sc}),\n      T_VC(\n        {oc}));\n")
        return head + calls + "END;\n/\n"

    def verify(expect_marked):
        return "\nUNION ALL\n".join(
            f"SELECT '{name}' AS OBJ, {exp if expect_marked else 0} AS EXPECT_MARKED,\n"
            f"       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME='{name}' AND S.TYPE='{typ}' AND INSTR(S.TEXT,'GAP413')>0) AS MARKED_LINES,\n"
            f"       (SELECT STATUS FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR' AND O.OBJECT_NAME='{name}' AND O.OBJECT_TYPE='{typ}') AS STATUS,\n"
            f"       (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER='SCM_MGR' AND E.NAME='{name}' AND E.TYPE='{typ}') AS ERRORS\n"
            f"  FROM DUAL" for name, typ, _, _, exp, _, _ in specs) + ";\n"

    apply = (
        "-- =====================================================================================\n"
        "-- 01_APPLY.sql  GAP413 DMF0072 빈값(NULL/''/' '/'-'/'--'/'/') 통일 비교 / 클라우드 적용\n"
        "-- 실행: 파일 전체 F5 (PL/SQL 익명블록 1개 + 확인 SELECT 1개)\n"
        "-- 동작: 객체마다 클라우드 현재 원문(ALL_SOURCE)을 읽어 대상 라인의 비교식만 치환 후 재컴파일\n"
        "--       (라인 내 공백·들여쓰기는 클라우드 원문 그대로 보존 / 결과는 사내 적용본과 동일)\n"
        "--   * 대상 라인 수·같은 모양 총수가 사내와 다르면 그 객체는 적용하지 않고 ORA-20413 (원문 무변경)\n"
        "--   * 이미 GAP413 표식이 있으면 SKIP (재실행 멱등)\n"
        "--   * 컴파일 오류 시 같은 블록에서 원래 원문으로 재생성 후 ORA-20414 (자동 원복)\n"
        "--   * 5개 객체는 서로 독립. 중간에 중단되면 뒤 객체는 실행되지 않음 (원인 해결 후 재실행 시 앞 객체는 SKIP)\n"
        "-- 마지막 SELECT 기대값(5행): MARKED_LINES = EXPECT_MARKED / STATUS = VALID / ERRORS = 0\n"
        "-- =====================================================================================\n"
        + hdr + "\n\n"
        + block("V_MARKED > 0", "already applied", "APPLIED ", APPLY_LINE_LOGIC, ORA_RX, True)
        + "\n-- 적용 확인\n" + verify(True))

    rollback = (
        "-- =====================================================================================\n"
        "-- 99_ROLLBACK.sql  GAP413 원복 (필요 시에만 실행) — GAP413 표식 라인만 원래 비교식으로 역치환\n"
        "-- 마지막 SELECT 기대값(5행): MARKED_LINES = 0 / STATUS = VALID / ERRORS = 0\n"
        "-- =====================================================================================\n"
        + hdr + "\n\n"
        + block("V_MARKED = 0", "not applied", "RESTORED", BACK_LINE_LOGIC, ORA_RX_BACK, False)
        + "\n-- 원복 확인\n" + verify(False))

    for f, t in (("00_PRECHECK.sql", pre), ("01_APPLY.sql", apply), ("99_ROLLBACK.sql", rollback)):
        assert "\t" not in t and "&" not in t, f"{f}: 탭/& 금지"
        (HERE / f).write_text(t, encoding="utf-8")
        print(f, len(t.splitlines()), "lines")


if __name__ == "__main__":
    main()
