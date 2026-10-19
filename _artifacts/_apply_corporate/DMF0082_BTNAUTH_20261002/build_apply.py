"""DMF0082 버튼 활성화 여부 조회 SP 신설 — PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH (사내 ZIOUI1)

사용자 지시(2026-10-02): "DMF0082 UI 에서 화면 오픈 후 DIVISION 초기값이나 DIVISION 을 변경했을 때, 버튼에 대한 권한체크를 해서
  버튼을 보여주도록 하고 싶어요. … DMF0082 의 경우에는 조회 시 버튼의 활성화 여부를 확인해서 보여주고 있습니다.
  버튼의 활성화 여부를 확인할 수 있도록 PKG 에 SP 를 추가해주세요." + "FE 는 별도 수정 예정 — DB 객체 작업만"

현행: 버튼 판정 근거(메저별 편집권한)가 P_DMF0082_GET_MAIN_DATA 의 O_RC4(FE drop3) 로만 내려와 조회 전에는 알 수 없다.
신설 [E20261002-BTNAUTH]: 조회 없이 (division, 사용자, 그룹) 만으로 같은 판정을 돌려주는 경량 SP.
  O_RC1 = 버튼 활성화 1행 / O_RC2 = 메저별 편집권한 (GET_MAIN_DATA O_RC4 와 동일 계약·동일 값)

권한 산출부는 새로 쓰지 않는다 — 빌드 시점 DB 의 P_DMF0082_GET_MAIN_DATA 본문에서 해당 블록을 **그대로 잘라** 넣는다
  (블록이 쓰는 식별자가 p_division_id / p_created_by / p_user_group / VA_PROGRAM_ID 4개뿐임을 assert).
  기존 프로시저는 한 글자도 바꾸지 않는다 (SPEC 선언 1건 + BODY 말미 프로시저 1건 추가).

사용:
  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP_* / 01_SPEC / 02_BODY 생성
  python build_apply.py apply   # FRESH-GATE(SPEC·BODY) 통과 시 SPEC → BODY 적용 + 컴파일 확인
  python build_apply.py meta    # 호출 등록 4종 MERGE (03_META.sql) — 대상 기준 사전 재조회 후 적용
"""
import sys, os, re, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0082"
SP = "P_DMF0082_GET_BUTTON_AUTH"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261002-BTNAUTH]"
FILES = {
    "PACKAGE": ("00_BACKUP_PKG_DMF0082_SPEC.sql", "01_PKG_DMF0082_SPEC.sql"),
    "PACKAGE BODY": ("00_BACKUP_PKG_DMF0082_BODY.sql", "02_PKG_DMF0082_BODY.sql"),
}
BLOCK_EDGE = "    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;\n"
ALLOWED_IDS = {"P_DIVISION_ID", "P_CREATED_BY", "P_USER_GROUP", "VA_PROGRAM_ID"}


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur, typ):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=typ)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=typ)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def strip_comments(sql):
    sql = re.sub(r"/\*.*?\*/", " ", sql, flags=re.S)
    return re.sub(r"--[^\n]*", " ", sql)


def auth_block(body, proc="P_DMF0082_GET_MAIN_DATA"):
    """proc 본문의 메저 편집권한 산출 블록(GTT_TEMP_INTO_GROUP_MEASURE 비움 ~ 다시 비움)을 원문 그대로 반환."""
    head = f"PROCEDURE {proc}\n"
    if body.count(head) != 1:
        sys.exit(f"ABORT: {proc} 시작 위치 특정 불가 ({body.count(head)})")
    s = body.index(head)
    e = body.index(f"END {proc};", s)
    seg = body[s:e]
    if seg.count(BLOCK_EDGE) != 2:
        sys.exit(f"ABORT: {proc} 권한 블록 경계 {seg.count(BLOCK_EDGE)}개 (2개여야 함)")
    i1 = seg.index(BLOCK_EDGE)
    i2 = seg.index(BLOCK_EDGE, i1 + 1) + len(BLOCK_EDGE)
    return seg[i1:i2]


def assert_block_self_contained(block):
    ids = {m.upper() for m in re.findall(r"\b(?:p_|va_|v_|n_|d_)\w+", strip_comments(block), flags=re.I)}
    extra = ids - ALLOWED_IDS
    if extra:
        sys.exit(f"ABORT: 권한 블록이 허용 밖 식별자를 참조 {sorted(extra)} — 그대로 이식 불가")
    if "COMMIT" in strip_comments(block).upper():
        sys.exit("ABORT: 권한 블록에 COMMIT 존재")


SPEC_DECL = f"""
    -- {MARK} 버튼 활성화 여부 조회 (화면 오픈·Division 변경 시 — 메인 조회 없이 판정)
    --   O_RC1 = 버튼 활성화 1행 / O_RC2 = 메저별 편집권한 (P_DMF0082_GET_MAIN_DATA O_RC4 와 동일 계약)
    PROCEDURE {SP}
    (
        p_division_id    IN  VARCHAR2
      , p_created_by     IN  VARCHAR2
      , p_user_group     IN  VARCHAR2
      , O_RC1            OUT SYS_REFCURSOR
      , O_RC2            OUT SYS_REFCURSOR
      , O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
"""


def body_proc(block):
    return f"""

-- ====================================================================================================
-- {MARK} DMF0082 버튼 활성화 여부 조회 SP 신설 (사용자 요청 2026-10-02)
--
--  목적: 화면 오픈 직후 Division 초기값 확정 시 / Division 변경 시, **메인 조회 없이** 버튼 노출 여부를 판정한다.
--        종전에는 판정 근거(메저별 편집권한)가 P_DMF0082_GET_MAIN_DATA 의 O_RC4 로만 내려와 조회 후에야 알 수 있었다.
--
--  IN  : p_division_id / p_created_by(세션 사용자) / p_user_group — P_DMF0082_GET_MAIN_DATA 와 동일 축·동일 명명.
--  OUT :
--   O_RC1 (1행) 버튼 활성화 — 현행 화면 판정식과 동일 규칙
--       EDIT_AUTH_YN    : 편집 가능 메저가 하나라도 있는가 (O_RC2 에 EDIT_AUTH_YN='Y' 존재)
--       SAVE_YN         : EDIT_AUTH_YN='Y' 이고 Division <> '82'  (82 = 조회 전용 — SAVE V82-00 가드와 동일)
--       DELETE_YN       : SAVE_YN 과 동일
--       INSERT_YN       : SAVE_YN='Y' 이고 MKT_FCST / LOC / VMI_In_Req 중 하나라도 'Y' (SCP Planner 단독 = 신규행 불가)
--       PRICE_BATCH_YN  : Division <> '82' 이고 LOC='Y'  (Price Batch Input)
--       EXCEL_FORM_YN   : Division 81 계열  (Excel Form — [E20260819-XLS81LOC])
--       EXCEL_UPLOAD_YN : Division 81 계열  (Excel Upload — 상동)
--   O_RC2 (메저별) MEASURE / EDIT_AUTH_YN('Y'·'N'·'T'=시간창 밖) / TODAY_LIMIT_YN / TODAY_DAY_LIST
--       = P_DMF0082_GET_MAIN_DATA O_RC4 와 **같은 컬럼·같은 값** (화면의 메저 편집권한 반영부를 그대로 쓸 수 있다)
--
--  ⚠ 이 SP 가 판정하지 않는 것 (화면에 그대로 남는 조건):
--     - 메뉴 버튼 권한(그룹×메뉴×버튼, SCM_ADM_USER_GR_MNU_BTN_MPG_M) — 화면이 별도로 받아 AND 한다.
--     - 조회 버전의 편집 가능 여부(과거 버전 = 조회 전용) — 조회 결과 행의 EDIT_FLAG 로 판정한다.
--  ⚠ 메저 편집권한 산출부는 P_DMF0082_GET_MAIN_DATA 의 해당 블록을 **원문 그대로** 옮긴 것이다(요일·시간창·LIMIT 포함).
--     그쪽 블록을 고치면 이 블록도 같이 고쳐야 조회 전/후 버튼 상태가 어긋나지 않는다.
-- ====================================================================================================
PROCEDURE {SP}
(
    p_division_id    IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR   /* 버튼 활성화 1행 */
  , O_RC2            OUT SYS_REFCURSOR   /* 메저별 편집권한 (= GET_MAIN_DATA O_RC4) */
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
IS
    VA_PROGRAM_ID       VARCHAR2(50 CHAR) := 'DMF0082';

    V_EDIT_AUTH_YN      VARCHAR2(1 CHAR) := 'N';
    V_MKT_FCST_YN       VARCHAR2(1 CHAR) := 'N';
    V_LOC_YN            VARCHAR2(1 CHAR) := 'N';
    V_VMI_YN            VARCHAR2(1 CHAR) := 'N';
    V_SAVE_YN           VARCHAR2(1 CHAR) := 'N';
    V_INSERT_YN         VARCHAR2(1 CHAR) := 'N';
    V_PRICE_BATCH_YN    VARCHAR2(1 CHAR) := 'N';
    V_EXCEL_YN          VARCHAR2(1 CHAR) := 'N';

    -- LOG 용 변수
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- ▼▼▼ P_DMF0082_GET_MAIN_DATA 메저 편집권한 산출 블록 — 원문 그대로 ({MARK}) ▼▼▼
{block}    -- ▲▲▲ P_DMF0082_GET_MAIN_DATA 메저 편집권한 산출 블록 끝 ▲▲▲

    -- Division 미확정(화면 오픈 직후 콤보 도착 전 호출) = 전 버튼 'N' · 메저 0행.
    --   위 블록의 LOC 강제 개방은 "룩업 미등록 division" 을 개방 대상으로 보므로 빈 division 이 열리지 않게 비운다.
    IF TRIM(p_division_id) IS NULL THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE;
    END IF;

    SELECT NVL(MAX(CASE WHEN EDIT_AUTH_YN = 'Y' THEN 'Y' END), 'N')
         , NVL(MAX(CASE WHEN MEASURE = 'MKT_FCST'   AND EDIT_AUTH_YN = 'Y' THEN 'Y' END), 'N')
         , NVL(MAX(CASE WHEN MEASURE = 'LOC'        AND EDIT_AUTH_YN = 'Y' THEN 'Y' END), 'N')
         , NVL(MAX(CASE WHEN MEASURE = 'VMI_In_Req' AND EDIT_AUTH_YN = 'Y' THEN 'Y' END), 'N')
    INTO   V_EDIT_AUTH_YN, V_MKT_FCST_YN, V_LOC_YN, V_VMI_YN
    FROM   SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE;

    -- 82 = 조회 전용 (SAVE V82-00 가드와 동일 판정식)
    IF V_EDIT_AUTH_YN = 'Y' AND p_division_id <> '82' THEN
        V_SAVE_YN := 'Y';
    END IF;
    -- 신규행 생성 자격 — SCP Planner 단독은 SCM_FCST 수정만 가능 (MKT_FCST·LOC·VMI_In_Req 전부 'N')
    IF V_SAVE_YN = 'Y' AND (V_MKT_FCST_YN = 'Y' OR V_LOC_YN = 'Y' OR V_VMI_YN = 'Y') THEN
        V_INSERT_YN := 'Y';
    END IF;
    IF V_LOC_YN = 'Y' AND p_division_id <> '82' THEN
        V_PRICE_BATCH_YN := 'Y';
    END IF;
    IF p_division_id LIKE '81%' THEN
        V_EXCEL_YN := 'Y';
    END IF;

    OPEN O_RC1 FOR
        SELECT p_division_id     AS DIVISION_ID
             , V_INSERT_YN       AS INSERT_YN
             , V_SAVE_YN         AS DELETE_YN
             , V_SAVE_YN         AS SAVE_YN
             , V_PRICE_BATCH_YN  AS PRICE_BATCH_YN
             , V_EXCEL_YN        AS EXCEL_FORM_YN
             , V_EXCEL_YN        AS EXCEL_UPLOAD_YN
             , V_EDIT_AUTH_YN    AS EDIT_AUTH_YN
        FROM   DUAL;

    OPEN O_RC2 FOR
        SELECT MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST
        FROM   SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
        ORDER BY MEASURE;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_created_by'  VALUE p_created_by,
            'p_user_group'  VALUE p_user_group
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END {SP};
"""


def rep1(src, old, new, what):
    n = src.count(old)
    if n != 1:
        sys.exit(f"ABORT: {what} 일치 {n}회 (1회여야 함) — 원문이 바뀌었거나 이미 반영됨")
    return src.replace(old, new)


def transform(spec, body):
    for name, s in (("SPEC", spec), ("BODY", body)):
        if MARK in s or SP in s:
            sys.exit(f"ABORT: {name} 에 {SP}/{MARK} 이미 존재 — 재적용 불필요")
        if "\r" in s:
            sys.exit(f"ABORT: {name} 원문에 CR 포함")
    block = auth_block(body)
    assert_block_self_contained(block)
    new_spec = rep1(spec, "\nEND PKG_DMF0082;", SPEC_DECL + "\nEND PKG_DMF0082;", "SPEC 말미")
    new_body = rep1(body, "\nEND PKG_DMF0082;", body_proc(block) + "\nEND PKG_DMF0082;", "BODY 말미")
    return new_spec, new_body, block


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = {t: read_source(cur, t) for t in FILES}
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    new_spec, new_body, block = transform(s["PACKAGE"]["src"], s["PACKAGE BODY"]["src"])
    new = {"PACKAGE": new_spec, "PACKAGE BODY": new_body}
    for t, (f_bak, f_new) in FILES.items():
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {t} LAST_DDL={s[t]['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
        open(os.path.join(HERE, f_bak), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s[t]["src"]) + "/\n")
        open(os.path.join(HERE, f_new), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new[t]) + "/\n")
        print(t, "LAST_DDL", s[t]["last_ddl"], "lines", s[t]["src"].count("\n"), "->", new[t].count("\n"))
    json.dump({t: {"last_ddl": s[t]["last_ddl"], "md5": s[t]["md5"]} for t in FILES} | {"fetched": fetched},
              open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, "권한 블록", block.count("\n"), "줄 이식 / 마커", new_spec.count(MARK), "+", new_body.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        # FRESH-GATE: 적용 직전 DB 원문(SPEC·BODY) 재조회 == build 시점 기준본
        for t in FILES:
            now = read_source(cur, t)
            if now["md5"] != st[t]["md5"] or now["last_ddl"] != st[t]["last_ddl"]:
                sys.exit(f"FRESH-GATE FAIL [{t}]: build {st[t]['last_ddl']} {st[t]['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS (SPEC·BODY)")
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        inv_before = cur.fetchone()[0]
        for t in ("PACKAGE", "PACKAGE BODY"):
            tobe = strip(open(os.path.join(HERE, FILES[t][1]), encoding="utf-8").read())
            cur.execute(tobe)
            after = read_source(cur, t)
            print("APPLIED", FILES[t][1], "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
                  "marker", after["src"].count(MARK))
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", inv_before, "->", cur.fetchone()[0])


def meta():
    target = f"{PKG}.{SP}"
    with connect() as con:
        cur = con.cursor()
        # 사전 확인 = 대상 기준 (내가 붙일 이름이 아니라 API_URL / MNU_ID 전 행) — 적용 직전 재조회
        cur.execute("SELECT api_id, api_tp_cd, api_url FROM scm_adm_api_m WHERE UPPER(api_url) = UPPER(:u) OR UPPER(api_id) LIKE '%BUTTON%AUTH%'", u=target)
        pre_api = cur.fetchall()
        cur.execute("SELECT proc_nm, COUNT(*) FROM scm_adm_proc_m WHERE UPPER(proc_nm) = UPPER(:u) GROUP BY proc_nm", u=target)
        pre_proc = cur.fetchall()
        cur.execute("SELECT sht_nm, mnu_btn_cd, api_id FROM scm_adm_mnu_btn_mpg_m WHERE mnu_id='DMF0082' AND (UPPER(sht_nm) LIKE '%AUTH%' OR UPPER(mnu_btn_cd) LIKE '%AUTH%')")
        pre_btn = cur.fetchall()
        print("PRE api", pre_api, "/ proc", pre_proc, "/ btn", pre_btn)
        if pre_api or pre_proc or pre_btn:
            sys.exit("ABORT: 같은 대상의 기존 등록 존재 — 내용 확인 후 재사용/정정 판단")
        sql = open(os.path.join(HERE, "03_META.sql"), encoding="utf-8").read()
        stmts = [s.strip() for s in re.split(r"\n/\s*\n", sql) if strip_comments(s).strip()]
        for s in stmts:
            body = "\n".join(l for l in s.split("\n") if not l.strip().startswith("--")).strip().rstrip(";")
            cur.execute(body)
            print("  rows", cur.rowcount, "|", body.split("\n")[0][:70])
        con.commit()
        print("COMMIT")
        cur.execute("SELECT api_id, api_tp_cd, api_msg_id, api_url, use_yn FROM scm_adm_api_m WHERE api_url = :u", u=target)
        print("API_M", cur.fetchall())
        cur.execute("SELECT col_nm, data_tp_cd, col_tp_cd, sort_ord FROM scm_adm_proc_m WHERE proc_nm = :u ORDER BY sort_ord", u=target)
        for r in cur:
            print("  PROC_M", r)
        cur.execute("SELECT sht_nm, mnu_btn_cd, api_id, use_yn FROM scm_adm_mnu_btn_mpg_m WHERE mnu_id='DMF0082' AND sht_nm='buttonAuth'")
        print("MNU_BTN", cur.fetchall())
        cur.execute("SELECT user_gr_id FROM scm_adm_user_gr_mnu_btn_mpg_m WHERE mnu_id='DMF0082' AND sht_nm='buttonAuth' ORDER BY 1")
        print("USER_GR", [r[0] for r in cur])


if __name__ == "__main__":
    {"build": build, "apply": apply, "meta": meta}[sys.argv[1]]()
