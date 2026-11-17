# [E20261109-ALLBUCKET] DMF0035 버킷 전체(일·주·월) 데이터 제공 + Sum 파라미터 구조 — 외과 치환 빌더
#   기준본 = fetch_fresh.py 가 사내 ZIOUI1 ALL_SOURCE 에서 방금 조회한 00_BACKUP_ASIS/*.ASIS.sql 만 (hook #152)
#   출력  = 01_TOBE/*.sql (CREATE OR REPLACE) · 적용은 apply_corp.py (FRESH-GATE 재조회 후)
import pathlib, sys

W = pathlib.Path(__file__).resolve().parent
ASIS, TOBE = W / "00_BACKUP_ASIS", W / "02_TOBE"  # 01_TOBE = Sum 파라미터 포함 1차본(철회·이력)
TOBE.mkdir(exist_ok=True)
M = "[E20261109-ALLBUCKET]"


def rep(src, old, new, n=1, tag=""):
    c = src.count(old)
    assert c == n, f"{tag}: 매칭 {c} != {n} — 원문이 바뀌었거나 이미 반영됨\n--- OLD ---\n{old}"
    return src.replace(old, new)


def ins_after_first(src, anchor, text, max_pos, tag=""):
    i = src.find(anchor)
    assert 0 <= i < max_pos, f"{tag}: 첫 앵커 위치 {i} (기대 < {max_pos})"
    return src[:i + len(anchor)] + text + src[i + len(anchor):]


def dbg(expr):
    # DBMS_OUTPUT 은 VARCHAR2(32767) 한 줄 — CLOB 전환 후 긴 값이 오면 ORA-06502/ORU-10028 → 앞 4000자만
    return f"DBMS_LOB.SUBSTR({expr}, 4000, 1)"


FUNC = f"""
    -- {M} 버킷 무관 일자(D_) 컬럼 제공 여부 — TITLE·메인 SP 공용 단일 규칙 (사용자 요청 2026-11-09)
    --   DAILY        = 'Y' (기존 동작 그대로)
    --   ONLY_WEEKLY  = 'N' (기존 동작 그대로 — 주 단위 단독 표시)
    --   WEEKLY/MONTHLY = 기간 컬럼(D+W+M) 수가 C_MAX_PERIOD_COLS 이하이면 'Y' — FE 가 조회 후 월→주→일 펼침 가능
    --                    초과하면 'N'(기존처럼 W·M 만) — Oracle SELECT 컬럼 상한 1000(ORA-01792) 보호.
    --                    고정 컬럼 최대 = SHEET_COLUMNS DMF0035 시트 71행(2026-11-09 사내 실측) → 900 + 71 + 강제축 < 1000
    C_MAX_PERIOD_COLS CONSTANT PLS_INTEGER := 900;

    FUNCTION F_DAILY_YN(P_BUCKET IN VARCHAR2, P_FROM_YYYYMMDD IN VARCHAR2, P_TO_YYYYMMDD IN VARCHAR2) RETURN VARCHAR2
    IS
        N_COLS PLS_INTEGER := 0;
    BEGIN
        IF P_BUCKET = 'DAILY' THEN RETURN 'Y'; END IF;
        IF P_BUCKET IS NULL OR P_BUCKET = 'ONLY_WEEKLY' THEN RETURN 'N'; END IF;
        SELECT COUNT(*)
             + COUNT(DISTINCT A.BASIS_YYYYMM || '|' || A.ISO_WEEK || '|' || A.BASIS_START_DATE)
             + COUNT(DISTINCT A.BASIS_YYYYMM)
          INTO N_COLS
          FROM SCM_MGR.SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD;
        RETURN CASE WHEN N_COLS <= C_MAX_PERIOD_COLS THEN 'Y' ELSE 'N' END;
    END F_DAILY_YN;
"""


# ───────────────────────── PKG_DMF0035 (MKT) ─────────────────────────
def mkt_body(s):
    s = rep(s, 'PACKAGE BODY           "PKG_DMF0035" AS\n', 'PACKAGE BODY           "PKG_DMF0035" AS\n' + FUNC, tag="35 func")
    # 메인 SP 변수 — SQL 문자열 32767 한도(ORA-06502, 2026-11-09 실측: DAILY 1년 조회 실패) → CLOB
    s = rep(s,
            "    V_SQL_TEXT       VARCHAR2(32767 CHAR);\n    V_PV_LIST        VARCHAR2(32767 CHAR);\n    V_PV_COL_LIST    VARCHAR2(32767 CHAR);\n    V_PV_COL         VARCHAR2(32767 CHAR);\n",
            f"    V_SQL_TEXT       CLOB;               -- {M} VARCHAR2(32767) → CLOB (일자 컬럼 상시 포함 시 길이 초과 ORA-06502)\n"
            f"    V_PV_LIST        CLOB;               -- {M}\n"
            f"    V_PV_COL_LIST    CLOB;               -- {M}\n"
            f"    V_PV_COL         CLOB;               -- {M}\n"
            f"    V_DAILY_YN       VARCHAR2(1 CHAR) := 'N';  -- {M} F_DAILY_YN 결과 (C_BUCKET·T_WF_DATA·D_ 분기 공용)\n",
            tag="35 decl")
    s = rep(s,
            "        AND    P_BUCKET = 'DAILY'\n        UNION ALL\n        SELECT '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK",
            f"        AND    V_DAILY_YN = 'Y'   -- {M} 구: P_BUCKET = 'DAILY'\n        UNION ALL\n        SELECT '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK",
            tag="35 cursor D")
    s = rep(s,
            "    V_PV_LIST     := '';\n    V_PV_COL_LIST := '';\n    V_PV_COL      := '';\n",
            f"    V_DAILY_YN    := F_DAILY_YN(P_BUCKET, P_FROM_YYYYMMDD, P_TO_YYYYMMDD);  -- {M} C_BUCKET OPEN 전에 확정\n"
            "    V_PV_LIST     := '';\n    V_PV_COL_LIST := '';\n    V_PV_COL      := '';\n",
            tag="35 assign")
    s = rep(s,
            "' , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD ' ||",
            f"' , CASE WHEN ''' || V_DAILY_YN || ''' = ''Y'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD ' ||  -- {M} 구: P_BUCKET = DAILY",
            tag="35 wf yyyymmdd")
    s = rep(s,
            "    IF P_BUCKET = 'DAILY'\n    THEN\n        V_SQL_TEXT := V_SQL_TEXT ||\n            CHR(10) || ' SELECT ' || V_COL_LIST || ', ''D_'' || F.YYYYMMDD",
            f"    IF V_DAILY_YN = 'Y'   -- {M} 구: P_BUCKET = 'DAILY'\n    THEN\n        V_SQL_TEXT := V_SQL_TEXT ||\n            CHR(10) || ' SELECT ' || V_COL_LIST || ', ''D_'' || F.YYYYMMDD",
            tag="35 D branch")
    for v in ("V_PV_LIST", "V_PV_COL_LIST", "V_PV_COL"):
        s = rep(s, f"    DBMS_OUTPUT.PUT_LINE('{v} : '||{v} ||CHR(10)||CHR(10));\n",
                f"    DBMS_OUTPUT.PUT_LINE('{v} : '||{dbg(v)} ||CHR(10)||CHR(10));  -- {M}\n", tag=f"35 dbg {v}")
    # 클라우드 패키지 앵커는 ASCII 만 (클라이언트 인코딩 차이로 한글 앵커 불일치 방지)
    s = rep(s, "    DBMS_OUTPUT.PUT_LINE(v_sql_text);\n",
            f"    DBMS_OUTPUT.PUT_LINE({dbg('V_SQL_TEXT')});  -- {M}\n", tag="35 dbg sql")

    # TITLE SP
    s = rep(s,
            "    V_TITLESET_SHEET  VARCHAR2(50 CHAR) := 'Mkt Fcst Waterfall';",
            f"    V_DAILY_YN        VARCHAR2(1 CHAR) := 'N';  -- {M}\n    V_TITLESET_SHEET  VARCHAR2(50 CHAR) := 'Mkt Fcst Waterfall';",
            tag="35 title decl")
    s = rep(s,
            "    BEGIN\n        SELECT 1\n        INTO   V_USER_COL_CNT\n",
            f"    V_DAILY_YN := F_DAILY_YN(P_BUCKET, P_START_YYYYMMDD, P_END_YYYYMMDD);  -- {M} 메인 SP 와 같은 규칙\n\n"
            "    BEGIN\n        SELECT 1\n        INTO   V_USER_COL_CNT\n",
            tag="35 title assign")
    s = rep(s,
            "                   AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END\n",
            f"                   AND    1 = CASE WHEN V_DAILY_YN = 'Y' THEN 1 ELSE 2 END  -- {M} 구: P_BUCKET = 'DAILY'\n",
            n=2, tag="35 title D")
    return s


def mkt_spec(s):
    return rep(s,
               "  , P_BUCKET          IN VARCHAR2\n  , O_RC1             OUT SYS_REFCURSOR",
               f"  , P_BUCKET          IN VARCHAR2\n  , P_SUM_YN          IN VARCHAR2 DEFAULT 'N'  -- {M} Sum 체크 수신 구조\n  , O_RC1             OUT SYS_REFCURSOR",
               tag="35 spec")


# ───────────────────────── PKG_DMF0022 (SALES) ─────────────────────────
def sales_body(s):
    s = ins_after_first(s, "\nAS\n", FUNC, 3000, tag="22 func")
    s = rep(s, "    v_sql_text          VARCHAR2(32767 CHAR);\n",
            f"    v_sql_text          CLOB;  -- {M} VARCHAR2(32767) → CLOB (일자 컬럼 상시 포함 시 길이 초과 ORA-06502)\n", tag="22 decl sql")
    s = rep(s, "    V_PV_LIST           VARCHAR2(32767 CHAR);\n    V_PV_COL_LIST       VARCHAR2(32767 CHAR);\n",
            f"    V_PV_LIST           CLOB;  -- {M}\n    V_PV_COL_LIST       CLOB;  -- {M}\n"
            f"    V_DAILY_YN          VARCHAR2(1 CHAR) := 'N';  -- {M}\n", tag="22 decl pv")
    s = rep(s, "    V_PV_LIST     := '';\n    V_PV_COL_LIST := '';\n\n    FOR r IN (",
            f"    V_DAILY_YN    := F_DAILY_YN(P_BUCKET, P_FROM_YYYYMMDD, P_TO_YYYYMMDD);  -- {M}\n"
            "    V_PV_LIST     := '';\n    V_PV_COL_LIST := '';\n\n    FOR r IN (", tag="22 assign")
    s = rep(s, "                      AND P_BUCKET = 'DAILY'\n                   UNION ALL\n                   -- WEEKLY",
            f"                      AND V_DAILY_YN = 'Y'   -- {M} 구: P_BUCKET = 'DAILY'\n                   UNION ALL\n                   -- WEEKLY", tag="22 loop D")
    s = rep(s, "        , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD\n",
            "        , CASE WHEN ''' || V_DAILY_YN || ''' = ''Y'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD\n", tag="22 wf yyyymmdd")
    s = rep(s, "    IF P_BUCKET = 'DAILY' THEN\n        v_sql_text := v_sql_text\n",
            f"    IF V_DAILY_YN = 'Y' THEN   -- {M} 구: P_BUCKET = 'DAILY'\n        v_sql_text := v_sql_text\n", tag="22 D branch")
    s = rep(s, "    DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : '||V_PV_COL_LIST ||CHR(10)||CHR(10));\n",
            f"    DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : '||{dbg('V_PV_COL_LIST')} ||CHR(10)||CHR(10));  -- {M}\n", tag="22 dbg1")
    s = rep(s, "    DBMS_OUTPUT.PUT_LINE('v_PV_LIST : '||v_PV_LIST ||CHR(10)||CHR(10));\n",
            f"    DBMS_OUTPUT.PUT_LINE('v_PV_LIST : '||{dbg('v_PV_LIST')} ||CHR(10)||CHR(10));  -- {M}\n", tag="22 dbg2")
    s = rep(s, "    DBMS_OUTPUT.PUT_LINE(v_sql_text);\n",
            f"    DBMS_OUTPUT.PUT_LINE({dbg('v_sql_text')});  -- {M}\n", tag="22 dbg sql")
    # TITLE SP
    # private 함수는 SQL 안에서 호출 불가(PLS-00231) → 변수로 받는다
    s = rep(s,
            "    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;\n\nBEGIN\n\n    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN\n        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);\n    END IF;\n\n    SELECT COUNT(*)\n      INTO i_Count\n",
            "    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;\n"
            f"    V_DAILY_YN      VARCHAR2(1 CHAR) := 'N';  -- {M}\n\nBEGIN\n\n"
            "    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN\n        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);\n    END IF;\n\n"
            f"    V_DAILY_YN := F_DAILY_YN(P_BUCKET, P_START_YYYYMMDD, P_END_YYYYMMDD);  -- {M} 메인 SP 와 같은 규칙\n\n"
            "    SELECT COUNT(*)\n      INTO i_Count\n",
            tag="22 title assign")
    s = rep(s, "                          AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END\n",
            f"                          AND 1 = CASE WHEN V_DAILY_YN = 'Y' THEN 1 ELSE 2 END  -- {M} 구: P_BUCKET = 'DAILY'\n",
            n=2, tag="22 title D")
    return s


def sales_spec(s):
    return rep(s,
               "    P_MENU_ID           IN VARCHAR2,\n\n    O_RC1               OUT SYS_REFCURSOR,\n    O_RESULT_CURSOR     OUT SYS_REFCURSOR\n);",
               f"    P_MENU_ID           IN VARCHAR2,\n    P_SUM_YN            IN VARCHAR2 DEFAULT 'N',  -- {M} Sum 체크 수신 구조\n\n"
               "    O_RC1               OUT SYS_REFCURSOR,\n    O_RESULT_CURSOR     OUT SYS_REFCURSOR\n);",
               tag="22 spec")


# ───────────────────────── PKG_DMF0051 (BIZ) — 데이터는 이미 M/Q/Y 전체 · Sum 파라미터 구조만 ─────────────────────────
def biz_body(s):
    s = rep(s,
            "       ,P_MENU_ID        VARCHAR2\n       ,O_RC1            OUT SYS_REFCURSOR\n       ,O_RESULT_CURSOR OUT SYS_REFCURSOR\n    )\n    /*\n        * Program ID   : DMF0051_GET_SPREAD_TITLE",
            f"       ,P_MENU_ID        VARCHAR2\n       ,P_SUM_YN         VARCHAR2 DEFAULT 'N'  -- {M} Sum 체크(Y/N) 수신 구조 — 합계 컬럼 표시는 FE 담당\n"
            "       ,O_RC1            OUT SYS_REFCURSOR\n       ,O_RESULT_CURSOR OUT SYS_REFCURSOR\n    )\n    /*\n        * Program ID   : DMF0051_GET_SPREAD_TITLE",
            tag="51 title sig")
    s = rep(s, "                                     ,'p_bucket' VALUE P_BUCKET);",
            f"                                     ,'p_bucket' VALUE P_BUCKET\n                                     ,'p_sum_yn' VALUE P_SUM_YN);  -- {M}",
            tag="51 json")
    return s


def biz_spec(s):
    return rep(s,
               "       ,P_MENU_ID        VARCHAR2\n       ,O_RC1            OUT SYS_REFCURSOR\n       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR\n    );\n",
               f"       ,P_MENU_ID        VARCHAR2\n       ,P_SUM_YN         VARCHAR2 DEFAULT 'N'  -- {M} Sum 체크 수신 구조\n"
               "       ,O_RC1            OUT SYS_REFCURSOR\n       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR\n    );\n",
               n=1, tag="51 spec")


# 사용자 지시 2026-11-09 18:23: "SUM 은 이미 존재 — 3개 BUCKET 데이터만 다 나오도록" → P_SUM_YN(스펙·TITLE·PROC_M) 미적용 · BIZ(PKG_DMF0051) 무변경
#   mkt_spec / sales_spec / biz_* 는 정의만 남김(호출 안 함)
JOBS = [
    ("PKG_DMF0035", "PACKAGE_BODY", mkt_body),
    ("PKG_DMF0022", "PACKAGE_BODY", sales_body),
]

if __name__ == "__main__":
    for name, typ, fn in JOBS:
        src = (ASIS / f"{name}.{typ}.ASIS.sql").read_text(encoding="utf-8")
        out = fn(src)
        (TOBE / f"{name}.{typ}.TOBE.sql").write_text(out, encoding="utf-8", newline="")
        print(f"OK {name} {typ}: {src.count(chr(10))} → {out.count(chr(10))} lines")
