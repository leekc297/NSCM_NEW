"""DMF0020_SAVECLOB_CLOUD_20261021 패키지 생성기 — [E20261021-DMF0020SAVECLOB]

증상 (사용자 2026-10-21): 클라우드 DMF0020 Batch Price Input 모달에서 대량 저장 시 "SQL ERROR".
원인 (사내 ZIOUI1 실측 2026-10-21):
  ① 모달 저장 = 메인 SAVE 라우트 = PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL — IN 17종 VARCHAR2.
     '^' 페이로드 한 컬럼이 32,767B 를 넘으면 바인드/PL/SQL 한도에서 즉시 오류(행 × 주차 × 3 메저로 펼쳐 보내 1,700행 안팎이 천장).
  ② 그 아래 분할 블록이 REGEXP_SUBSTR … CONNECT BY LEVEL (LEVEL 마다 처음부터 재스캔, O(N^2)) — 300행 13초 · 1,700행 10분 초과(PGA 폭주).
  ③ 같은 family P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP(sheet 'priceBatch' = Range 팝업 재저장)도 IN 16종 VARCHAR2 + 홀더 VARCHAR2(32767) 동일 한도.
보완 (DB 객체만 · FE/BE 무변경 · 페이로드 키 동일):
  S1/B1  SPEC+BODY  _ALL IN 17종 · _POPUP IN 16종 VARCHAR2 → CLOB
  A2/A3  _ALL  분할 블록 → CLOB 선형 분할(F_SPLIT_CARET, 바이트 스캔) + FORALL 적재 (원문 식 그대로: TRIM · NVL '/' · ITEM 제어문자 제거 · 숫자 변환 기본 0)
  A4     _ALL  예외 진단 JSON_OBJECT → SQL RETURNING CLOB + 4000 절단 (hook #106 §3)
  P2~P4  _POPUP 홀더 15종 → 토큰 컬렉션 · WHILE/INSTR/SUBSTR 루프 → 인덱스 루프 (공백제거·INSERT 원문 유지, 도달불가 ELSE 분기 보존 주석)
  M1     SCM_ADM_PROC_M 두 PROC_NM IN 33행 DATA_TP_CD VARCHAR → CLOB (BE BaseService.makeProcedure L377 CLOB 바인딩)
  D1     의존 객체 재컴파일 (USER_DEPENDENCIES 동적)
방식: 각 DB 의 USER_SOURCE 를 읽어 ASCII 표지·앵커로 치환(한글 비교 0) → CREATE OR REPLACE SPEC → BODY. 원문 구간은 /*ORIG*/ 주석으로 보존해 원복이 자기 소스에서 복원.
     FRESH-GATE(#152) + Python 시뮬레이터(수정 전→적용 == 적용본, 적용본→원복 == 수정 전) + 사내 리허설(run_rehearsal.py).
"""
import os, sys, re, datetime, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
CORP = os.path.join(os.path.dirname(os.path.dirname(HERE)), "_apply_corporate", "DMF0020_SAVECLOB_20261021")
CLOUD = os.path.join(os.path.dirname(os.path.dirname(HERE)), "_cloud_to_corp", "DMF0020_SAVECLOB_20261021")   # 클라우드 원문(02_EXPORT 결과 복원본)
TAG = "E20261021-DMF0020SAVECLOB"
MARK = f"[{TAG}]"
PKG = "PKG_DMF0020"
PROC_ALL = "PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL"
PROC_POP = "PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP"
ALL_PARAMS = ["P_ACTIVE_FLAG", "P_DIVISION_ID", "P_PROJECT_CODE", "P_SCM_SITE_ID", "P_PLANT_SITE_ID", "P_ITEM_ID", "P_YYYYMMDD",
              "P_CURRENCY", "P_MEASURE", "P_DOM_EXP", "P_FCST_TYPE", "P_INCOTERMS", "P_PRICE", "P_CREATED_BY", "P_CREATION_DATE",
              "P_LAST_UPDATED_BY", "P_ROWNUM"]
POP_PARAMS = ["p_active_flag", "p_DIVISION_ID", "p_PROJECT_CODE", "p_SCM_SITE_ID", "p_PLANT_SITE_ID", "p_ITEM_ID", "p_YYYYMMDD",
              "p_CURRENCY", "p_MEASURE", "p_DOM_EXP", "p_FCST_TYPE", "p_INCOTERMS", "p_PRICE", "p_CREATED_BY", "p_CREATION_DATE",
              "p_LAST_UPDATED_BY"]
ALL_SPLIT = [p for p in ALL_PARAMS if p != "P_CREATION_DATE"]            # 원문이 분할하는 16종 (CREATION_DATE 는 SYSDATE)
POP_SPLIT = [p for p in POP_PARAMS if p != "p_CREATION_DATE"]            # 원문 홀더 15종
COLS = ["activeFlag", "divisionId", "projectCode", "scmSiteId", "plantSiteId", "itemId", "yyyymmdd", "currency", "measure", "domExp",
        "fcstType", "incoterms", "price", "createdByList", "creationDate", "lastUpdatedByList", "rownumKey"]

SEG = {  # 구간 앵커 (ASCII)
    "SPEC_ALL": ("PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL", ");"),
    "SPEC_POP": ("PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP", ");"),
    "BODY_ALL": ("PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL", "END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL;"),
    "BODY_POP": ("PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP", "END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP;"),
}

# ───────────────────────────── 새 코드 (삽입 텍스트 · 매칭에 쓰지 않음) ─────────────────────────────
SPLIT_FN = """    FUNCTION {fn}(P_SRC IN CLOB) RETURN {tt} IS
        --{M} CLOB '^' 선형 분할: 7,000자 조각(UTF-8 최대 28,000B)을 VARCHAR2 버퍼로 읽어 바이트 위치 이동(INSTRB/SUBSTRB)으로 토큰화.
        --  '^'(0x5E)는 UTF-8 다바이트 문자 안에 나타나지 않고 조각은 문자 단위로 잘라 분절이 없다. 토큰 수 = '^' 수 + 1 (빈값 보존), NULL → 1개(NULL).
        --  사내 실측 2026-10-21: 200,000 토큰(1.4MB) 0.1초 (문자 단위 INSTR 는 UTF-8 오프셋 재계산으로 24초).
        V_OUT   {tt} := {tt}();
        V_LEN   PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_SRC), 0);
        V_POS   PLS_INTEGER := 1;
        V_BUF   VARCHAR2(32767);
        V_P     PLS_INTEGER;
        V_I     PLS_INTEGER;
        V_CARRY VARCHAR2(32767);
        C_CHUNK CONSTANT PLS_INTEGER := 7000;
    BEGIN
        WHILE V_POS <= V_LEN LOOP
            V_BUF := V_CARRY || DBMS_LOB.SUBSTR(P_SRC, C_CHUNK, V_POS);
            V_POS := V_POS + C_CHUNK;
            V_P := 1;
            LOOP
                V_I := INSTRB(V_BUF, '^', V_P);
                EXIT WHEN V_I = 0;
                V_OUT.EXTEND;
                V_OUT(V_OUT.COUNT) := SUBSTRB(V_BUF, V_P, V_I - V_P);
                V_P := V_I + 1;
            END LOOP;
            V_CARRY := SUBSTRB(V_BUF, V_P);
        END LOOP;
        V_OUT.EXTEND;
        V_OUT(V_OUT.COUNT) := V_CARRY;
        RETURN V_OUT;
    END {fn};
    PROCEDURE {pad}(P_T IN OUT NOCOPY {tt}, P_N IN PLS_INTEGER) IS
    BEGIN
        WHILE P_T.COUNT < P_N LOOP P_T.EXTEND; END LOOP;   --{M} 토큰이 모자란 컬럼은 NULL (원문: LEVEL 초과 = NULL / INSTR = 0 → NULL)
    END {pad};
"""


def tvar(p):  # P_ACTIVE_FLAG → T_ACTIVE_FLAG / p_active_flag → t_active_flag
    return ("T" if p[0] == "P" else "t") + p[1:]


def a2_new():
    s = f"    --{MARK} BEGIN-NEW A2 : '^' 페이로드 선형 분할용 컬렉션·함수 (IN CLOB 수신 · 32,767B 한도 해제 · O(N^2) 분할 제거)\n"
    s += "    TYPE T_TOK IS TABLE OF VARCHAR2(4000);\n"
    for p in ALL_SPLIT:
        s += f"    {tvar(p):<19} T_TOK;\n"
    s += "    V_ROW_CNT         PLS_INTEGER := 0;\n"
    s += SPLIT_FN.format(fn="F_SPLIT_CARET", tt="T_TOK", pad="PAD_TOKENS", M=MARK)
    s += f"    --{MARK} END-NEW A2\n"
    return s


def a3_new():
    s = f"    --{MARK} BEGIN-NEW A3 : '^' 페이로드 선형 분할 + FORALL 적재 (원문 REGEXP_SUBSTR … CONNECT BY LEVEL 블록은 아래 ORIG 주석에 보존)\n"
    s += "    --  사유: 원문은 LEVEL 마다 문자열 처음부터 재스캔(O(N^2)) + IN VARCHAR2 32,767B 한도 — 사내 실측 300행 13초 · 1,700행 10분 초과(PGA 폭주) · 3,000행 바인드 오류.\n"
    s += "    --  동치: 토큰 수 = '^' 수 + 1(빈값 보존) · 각 토큰 TRIM · 짧은 컬럼 NULL 패딩(원문 LEVEL 초과 = NULL) · P_DIVISION_ID NULL = 0행(원문 REGEXP_COUNT(NULL) = NULL) · 식은 원문 SELECT 그대로.\n"
    for p in ALL_SPLIT:
        s += f"    {tvar(p):<19} := F_SPLIT_CARET({p});\n"
    s += "    V_ROW_CNT := CASE WHEN P_DIVISION_ID IS NULL THEN 0 ELSE T_DIVISION_ID.COUNT END;\n"
    for p in ALL_SPLIT:
        if p != "P_DIVISION_ID":
            s += f"    PAD_TOKENS({tvar(p)}, V_ROW_CNT);\n"
    s += """    IF V_ROW_CNT > 0 THEN
        FORALL I IN 1 .. V_ROW_CNT
            INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST
            (
                 V_ACTIVE_FLAG
                ,V_DIVISION_ID
                ,V_PROJECT_CODE
                ,V_SCM_SITE_ID
                ,V_PLANT_SITE_ID
                ,V_ITEM_ID
                ,V_YYYYMMDD
                ,V_CURRENCY
                ,V_MEASURE
                ,V_DOM_EXP
                ,V_FCST_TYPE
                ,V_INCOTERMS
                ,V_PRICE
                ,V_CREATED_BY
                ,V_CREATION_DATE
                ,V_LAST_UPDATED_BY
                ,V_ROWNUM
            )
            VALUES
            (
                 TRIM(T_ACTIVE_FLAG(I))
                ,NVL(TRIM(T_DIVISION_ID(I)), '/')   -- 2026.10.13 POJ 빈값 대체값 '/' (원문 동일)
                ,NVL(TRIM(T_PROJECT_CODE(I)), '/')
                ,NVL(TRIM(T_SCM_SITE_ID(I)), '/')
                ,NVL(TRIM(T_PLANT_SITE_ID(I)), '/')
                -- [E20250522-001188] ITEM 제어문자(CR/LF/TAB/공백) 제거 (원문 동일)
                ,NVL(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(T_ITEM_ID(I)), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', ''), '/')
                ,NVL(TRIM(T_YYYYMMDD(I)), '/')
                ,NVL(TRIM(T_CURRENCY(I)), '/')
                ,NVL(TRIM(T_MEASURE(I)), '/')
                ,NVL(TRIM(T_DOM_EXP(I)), '/')
                ,NVL(TRIM(T_FCST_TYPE(I)), '/')
                ,NVL(TRIM(T_INCOTERMS(I)), '/')
                ,NVL(TO_NUMBER(TRIM(T_PRICE(I)) DEFAULT 0 ON CONVERSION ERROR), 0)   --*[2026-09-07] POJ 빈 값은 0 (원문 동일)
                ,TRIM(T_CREATED_BY(I))
                ,SYSDATE                                                          -- @v_CREATION_DATE 대신 GETDATE() (원문 동일)
                ,TRIM(T_LAST_UPDATED_BY(I))
                ,NVL(TO_NUMBER(TRIM(T_ROWNUM(I)) DEFAULT 0 ON CONVERSION ERROR), 0)   --[PJ20200138] RowNum (원문 동일)
            );
    END IF;
"""
    s += f"    --{MARK} END-NEW A3\n"
    return s


def a4_new():
    s = f"        --{MARK} BEGIN-NEW A4 : IN CLOB 진단 JSON = SQL 컨텍스트 RETURNING CLOB (PL/SQL 대입 JSON_OBJECT 는 VARCHAR2(4000) 반환이라 대량 시 ORA-40478 로 원래 오류가 가려짐) + 로그 VARCHAR2 한도 4000 절단 (hook #106 §3)\n"
    s += "        BEGIN\n            SELECT JSON_OBJECT(\n"
    for i, p in enumerate(ALL_PARAMS):
        s += f"                '{p}'{' ' * (18 - len(p))} VALUE {p}{',' if i < len(ALL_PARAMS) - 1 else ''}\n"
    s += """                RETURNING CLOB)
              INTO V_PROC_INPUT
              FROM DUAL;
            V_PROC_INPUT := DBMS_LOB.SUBSTR(V_PROC_INPUT, 4000, 1);
        EXCEPTION
            WHEN OTHERS THEN
                V_PROC_INPUT := '{"PARAMS":"(unavailable) ' || REPLACE(SUBSTR(SQLERRM, 1, 200), '"', '''') || '"}';
        END;
"""
    s += f"        --{MARK} END-NEW A4\n"
    return s


K9 = ["V_DIVISION_ID", "V_PROJECT_CODE", "V_SCM_SITE_ID", "V_PLANT_SITE_ID", "V_ITEM_ID", "V_YYYYMMDD", "V_DOM_EXP", "V_FCST_TYPE", "V_INCOTERMS"]


def merge_new(key, col, keys, what):
    on = "\n          AND ".join(f"B.{k} = A.{k}" for k in keys)
    return (f"    --{MARK} BEGIN-NEW {key} : {what} - 상관 UPDATE(행마다 GTT 전체 2회 스캔, 인덱스 없음 → O(N^2)) → LOC 기준 집계 1회 + MERGE.\n"
            f"    --  동치: 같은 키 LOC 행이 없거나 MAX 가 NULL/같으면 갱신 안 함(원문 NVL(MAX, 자기값) <> 자기값) · 키 비교 등호(NULL 불일치) 동일 · 사내 무작위 300/2,000/5,000행 상태 전수 일치.\n"
            f"    MERGE INTO SCM_MGR.GT_FCSV_RESULTS_MST A\n    USING ( SELECT {', '.join(keys)}, MAX({col}) AS MAX_VAL\n"
            f"              FROM SCM_MGR.GT_FCSV_RESULTS_MST\n             WHERE V_MEASURE = 'LOC'\n             GROUP BY {', '.join(keys)} ) B\n"
            f"       ON ( {on}\n          AND A.V_MEASURE <> 'LOC' )\n     WHEN MATCHED THEN UPDATE SET A.{col} = B.MAX_VAL\n      WHERE B.MAX_VAL <> A.{col};\n"
            f"    --{MARK} END-NEW {key}\n")


def ne_new(key, meas):
    s = (f"           --{MARK} BEGIN-NEW {key} : 보충 대상 판정 NOT EXISTS 의 키 비교 DECODE(x,y,1,0)=1(해시 불가 → O(N^2)) → NVL(x,CHR(0)) 등호(해시 안티조인).\n"
         f"           --  동치: 두 식 모두 NULL=NULL 을 같다고 본다 · 사내 무작위 300/2,000/5,000행 상태 전수 일치.\n"
         f"           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K\n                             WHERE K.V_MEASURE = '{meas}'\n")
    for c in ["V_DIVISION_ID", "V_PROJECT_CODE", "V_SCM_SITE_ID", "V_PLANT_SITE_ID", "V_ITEM_ID", "V_YYYYMMDD", "V_CURRENCY", "V_DOM_EXP", "V_FCST_TYPE", "V_INCOTERMS"]:
        s += f"                                AND NVL(K.{c}, CHR(0)) = NVL(L.{c}, CHR(0))\n"
    s = s.rstrip("\n") + " );\n" + f"           --{MARK} END-NEW {key}\n"
    return s


A5_S = "    UPDATE SCM_MGR.GT_FCSV_RESULTS_MST A\n       SET A.V_CURRENCY = ( SELECT MAX(B.V_CURRENCY)\n"
A5_E = "A.V_CURRENCY) <> A.V_CURRENCY;\n"
A6_S = "    UPDATE SCM_MGR.GT_FCSV_RESULTS_MST A\n       SET A.V_ACTIVE_FLAG = ( SELECT MAX(B.V_ACTIVE_FLAG)\n"
A6_E = "A.V_ACTIVE_FLAG) <> A.V_ACTIVE_FLAG;\n"
A7_S = "           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K\n                             WHERE K.V_MEASURE = 'KRW'\n"
A8_S = "           AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K\n                             WHERE K.V_MEASURE = 'USD'\n"
A78_E = "                                AND DECODE(K.V_INCOTERMS, L.V_INCOTERMS, 1, 0) = 1 );\n"
SB = [  # (key, start, end, newtext, ORIG 들여쓰기, 지문 토큰)
    ("A5", A5_S, A5_E, lambda: merge_new("A5", "V_CURRENCY", K9, "LOC 통화 맞추기(F-03)"), "    ", "MAX(B.V_CURRENCY)"),
    ("A6", A6_S, A6_E, lambda: merge_new("A6", "V_ACTIVE_FLAG", K9[:6] + ["V_CURRENCY"] + K9[6:], "LOC 기준 ACTIVE_FLAG 맞추기(F-02)"), "    ", "MAX(B.V_ACTIVE_FLAG)"),
    ("A7", A7_S, A78_E, lambda: ne_new("A7", "KRW"), "           ", "DECODE("),
    ("A8", A8_S, A78_E, lambda: ne_new("A8", "USD"), "           ", "DECODE("),
]


def p2_new():
    s = f"    --{MARK} BEGIN-NEW P2 : '^' 페이로드 홀더 VARCHAR2(32767) 15종 → 선형 분할 토큰 컬렉션 (IN CLOB 수신 · 32,767B 한도 해제)\n"
    s += "    TYPE t_tok IS TABLE OF VARCHAR2(4000);\n"
    for p in POP_SPLIT:
        s += f"    {tvar(p):<20} t_tok;\n"
    s += "    v_row_cnt            PLS_INTEGER := 0;\n"
    s += f"    --{MARK} END-NEW P2\n"
    return s


def p2b_new():
    s = f"    --{MARK} BEGIN-NEW P2B : CLOB '^' 선형 분할 함수 (지역 서브프로그램은 선언부 끝)\n"
    s += SPLIT_FN.format(fn="f_split_caret", tt="t_tok", pad="pad_tokens", M=MARK)
    s += f"    --{MARK} END-NEW P2B\n"
    return s


def p3_new():
    s = f"\t--{MARK} BEGIN-NEW P3 : 홀더 복사(RTRIM(p_X) || '^') → 선형 분할. 행 수 = p_DIVISION_ID 토큰 수('^' 수 + 1 · NULL 도 1행 — 원문 동일) · 짧은 컬럼 NULL 패딩(원문 INSTR = 0 → NULL 동일) · 공백은 아래 rtrim(ltrim()) 원문이 제거\n"
    for p in POP_SPLIT:
        s += f"\t{tvar(p):<20} := f_split_caret({p});\n"
    s += "\tv_row_cnt := t_DIVISION_ID.COUNT;\n"
    for p in POP_SPLIT:
        if p != "p_DIVISION_ID":
            s += f"\tpad_tokens({tvar(p)}, v_row_cnt);\n"
    s += f"\t--{MARK} END-NEW P3\n"
    return s


def p4_head():
    s = f"--{MARK} BEGIN-NEW P4 : WHILE/INSTR/SUBSTR 토큰 소비 루프(홀더 재할당 O(N^2)) → 컬렉션 인덱스 루프. 추출 뒤 공백제거·INSERT 는 원문 그대로.\n"
    s += "--  원문 ELSE 분기(마지막 토큰 전용)는 도달 불가(홀더 끝에 '^' 를 붙여 루프 안에서 INSTR 가 항상 > 0)라 제거 — 아래 ORIG 주석에 보존.\n"
    s += "FOR v_i IN 1 .. v_row_cnt LOOP\n"
    for p in POP_SPLIT:
        v = "v" + p[1:]
        s += f"\t\t\t{v:<18} := {tvar(p)}(v_i);\n"
    return s


# ───────────────────────────── 앵커 (전부 ASCII) ─────────────────────────────
A3_S = "    INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST\n    (\n         V_ACTIVE_FLAG\n"
A3_E = "    FROM   SPLIT_DATA;\n"
A2_ANCHOR = "    N_DFLAG_CHK       NUMBER(10) := 0;\nBEGIN\n"
A4_S = "        V_PROC_INPUT  := JSON_OBJECT(\n            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,\n"
A4_E = "            'P_ROWNUM'          VALUE P_ROWNUM\n        );\n"
P2_S = "    l_active_flag        VARCHAR2(32767);\n"
P2_E = "    l_LAST_UPDATED_BY    VARCHAR2(32767);\n"
P2B_ANCHOR = "    e_invalid_data EXCEPTION;\n"   # 빈 줄 비의존 — 클라우드 원문은 빈 줄이 제거된 판(10-21 확인)
P3_S = "\tl_active_flag      := RTRIM(p_active_flag     ) || '^';\n"
P3_E = "\tl_LAST_UPDATED_BY  := RTRIM(p_LAST_UPDATED_BY ) || '^';\n"
P4_S = "WHILE LENGTH(l_DIVISION_ID) > 0\nLOOP\n"
P4_E = "    END IF;\nEND LOOP;\n"
P4_X = "\t\t\tl_LAST_UPDATED_BY := SUBSTR(l_LAST_UPDATED_BY, LENGTH(v_LAST_UPDATED_BY || '^') + 1, LENGTH(l_LAST_UPDATED_BY));\n"
P4_ELSE = "\n    ELSE\n"
FP = {"A3": ("REGEXP_SUBSTR", None), "P4": ("NVL(rtrim(ltrim(", None)}   # 구간 지문 (글자수 + 토큰 수) — 생성 시 사내 값으로 채움


def orig_wrap(key, orig, ind):
    return f"{ind}/*{MARK} BEGIN-ORIG {key}\n{orig}{ind}{MARK} END-ORIG {key} */\n"


def region_apply(seg, key, s_anc, e_anc, new_text, ind, fp=None):
    assert seg.count(s_anc) == 1, f"{key} 시작 앵커 {seg.count(s_anc)}회"
    a = seg.index(s_anc)
    b = seg.index(e_anc, a) + len(e_anc)
    region = seg[a:b]
    if fp:
        assert (len(region), region.count(fp[0])) in fp[1], f"{key} 지문 불일치 {(len(region), region.count(fp[0]))} not in {fp[1]}"
    return seg[:a] + new_text + orig_wrap(key, region, ind) + seg[b:]


def region_rollback(seg, key, ind, new_first_line_prefix):
    s = seg.index(new_first_line_prefix)
    o1 = f"{ind}/*{MARK} BEGIN-ORIG {key}\n"
    o2 = f"{ind}{MARK} END-ORIG {key} */\n"
    a = seg.index(o1, s) + len(o1)
    b = seg.index(o2, a)
    orig = seg[a:b]
    return seg[:s] + orig + seg[b + len(o2):]


def hdr_lines(seg, params):
    """세그먼트 안에서 'P_X   IN  VARCHAR2,' 정확 문자열(앞 공백·이름·IN·VARCHAR2,) 추출 — 1개씩."""
    out = []
    for p in params:
        m = re.findall(rf"^([ \t]*{re.escape(p)}[ \t]+IN[ \t]+)VARCHAR2,", seg, re.M)
        assert len(m) == 1, f"{p} 선언 {len(m)}회"
        out.append((f"{m[0]}VARCHAR2,", f"{m[0]}CLOB,"))
    return out


def seg_split(src, key):
    s_anc, e_anc = SEG[key]
    assert src.count(s_anc) == 1, f"{key} 시작 앵커 {src.count(s_anc)}회"
    a = src.index(s_anc)
    b = src.index(e_anc, a) + len(e_anc)
    return a, b


def one(seg, old, new, what):
    n = seg.count(old)
    assert n == 1, f"{what} {n}회 (기대 1)"
    return seg.replace(old, new)


# ───────────────────────────── 시뮬레이터 (Python) ─────────────────────────────
def sim_apply_spec(src):
    for key, params in (("SPEC_ALL", ALL_PARAMS), ("SPEC_POP", POP_PARAMS)):
        a, b = seg_split(src, key)
        seg = src[a:b]
        for old, new in hdr_lines(seg, params):
            seg = one(seg, old, new, old)
        src = src[:a] + seg + src[b:]
    return src


def sim_rollback_spec(src):
    for key, params in (("SPEC_ALL", ALL_PARAMS), ("SPEC_POP", POP_PARAMS)):
        a, b = seg_split(src, key)
        seg = src[a:b]
        for p in params:
            m = re.findall(rf"^([ \t]*{re.escape(p)}[ \t]+IN[ \t]+)CLOB,", seg, re.M)
            assert len(m) == 1
            seg = one(seg, f"{m[0]}CLOB,", f"{m[0]}VARCHAR2,", p)
        src = src[:a] + seg + src[b:]
    return src


def sim_apply_body(src, fp):
    # _ALL
    a, b = seg_split(src, "BODY_ALL"); seg = src[a:b]
    for old, new in hdr_lines(seg, ALL_PARAMS):
        seg = one(seg, old, new, old)
    seg = one(seg, A2_ANCHOR, "    N_DFLAG_CHK       NUMBER(10) := 0;\n" + a2_new() + "BEGIN\n", "A2")
    seg = region_apply(seg, "A3", A3_S, A3_E, a3_new(), "    ", ("REGEXP_SUBSTR", fp["A3"]))
    seg = region_apply(seg, "A4", A4_S, A4_E, a4_new(), "        ")
    for key, s_, e_, nf, ind, tok in SB:
        seg = region_apply(seg, key, s_, e_, nf(), ind, (tok, fp[key]))
    src = src[:a] + seg + src[b:]
    # _POPUP
    a, b = seg_split(src, "BODY_POP"); seg = src[a:b]
    for old, new in hdr_lines(seg, POP_PARAMS):
        seg = one(seg, old, new, old)
    seg = region_apply(seg, "P2", P2_S, P2_E, p2_new(), "    ")
    seg = one(seg, P2B_ANCHOR, P2B_ANCHOR + p2b_new(), "P2B")
    seg = region_apply(seg, "P3", P3_S, P3_E, p3_new(), "\t")
    # P4: 루프 전체 구간 — 새 루프 = 머리 + (원문 IF 분기 본문: 추출 마지막 줄 다음 ~ ELSE 직전) + END LOOP
    assert seg.count(P4_S) == 1
    ra = seg.index(P4_S); rb = seg.index(P4_E, ra) + len(P4_E); region = seg[ra:rb]
    assert (len(region), region.count("NVL(rtrim(ltrim(")) in fp["P4"], f"P4 지문 {(len(region), region.count('NVL(rtrim(ltrim('))}"
    assert region.count(P4_X) == 1 and region.count(P4_ELSE) == 1
    body_if = region[region.index(P4_X) + len(P4_X):region.index(P4_ELSE) + 1]   # 앞 '\n' 포함(빈 줄) ~ ELSE 직전 '\n' 포함
    new_loop = p4_head() + body_if + "END LOOP;\n" + f"--{MARK} END-NEW P4\n"
    seg = seg[:ra] + new_loop + orig_wrap("P4", region, "") + seg[rb:]
    return src[:a] + seg + src[b:]


def sim_rollback_body(src):
    a, b = seg_split(src, "BODY_ALL"); seg = src[a:b]
    for p in ALL_PARAMS:
        m = re.findall(rf"^([ \t]*{re.escape(p)}[ \t]+IN[ \t]+)CLOB,", seg, re.M); assert len(m) == 1
        seg = one(seg, f"{m[0]}CLOB,", f"{m[0]}VARCHAR2,", p)
    seg = one(seg, a2_new(), "", "A2 제거")
    seg = region_rollback(seg, "A3", "    ", f"    --{MARK} BEGIN-NEW A3")
    seg = region_rollback(seg, "A4", "        ", f"        --{MARK} BEGIN-NEW A4")
    for key, s_, e_, nf, ind, tok in SB:
        seg = region_rollback(seg, key, ind, f"{ind}--{MARK} BEGIN-NEW {key} ")
    src = src[:a] + seg + src[b:]
    a, b = seg_split(src, "BODY_POP"); seg = src[a:b]
    for p in POP_PARAMS:
        m = re.findall(rf"^([ \t]*{re.escape(p)}[ \t]+IN[ \t]+)CLOB,", seg, re.M); assert len(m) == 1
        seg = one(seg, f"{m[0]}CLOB,", f"{m[0]}VARCHAR2,", p)
    seg = region_rollback(seg, "P2", "    ", f"    --{MARK} BEGIN-NEW P2 ")
    seg = one(seg, p2b_new(), "", "P2B 제거")
    seg = region_rollback(seg, "P3", "\t", f"\t--{MARK} BEGIN-NEW P3")
    seg = region_rollback(seg, "P4", "", f"--{MARK} BEGIN-NEW P4")
    return src[:a] + seg + src[b:]


# ───────────────────────────── PL/SQL 문자열 인코딩 ─────────────────────────────
def q(t):
    """PL/SQL 리터럴 식: ' → '' · 개행 → CHR(10) · 탭 → CHR(9) (멀티라인 리터럴·탭 보존 의존 없음)"""
    parts = []
    for i, line in enumerate(t.split("\n")):
        seg = line.replace("'", "''").replace("\t", "' || CHR(9) || '")
        parts.append(f"'{seg}'")
    return " || CHR(10) ||\n        ".join(parts)


def plsql_assign(var, text):
    """VARCHAR2(32767) 변수 대입 — 32K 초과 시 여러 문장으로 분할"""
    assert len(text.encode("utf-8")) < 30000, f"{var} 너무 큼 {len(text.encode('utf-8'))}B"
    return f"    {var} := {q(text)};\n"


# ───────────────────────────── 메인 ─────────────────────────────
def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME'), USER FROM DUAL"); con_name, usr = cur.fetchone()
    assert con_name.upper() == "ZIOUI1" and usr == "SCM_MGR", f"대상 DB/계정 아님 {con_name}/{usr}"

    def fetch(typ):
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=PKG, t=typ)
        return "".join(r[0] for r in cur.fetchall()).replace("\r\n", "\n")

    def last_ddl(typ):
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=PKG, t=typ)
        return cur.fetchone()

    spec_pre, body_pre = fetch("PACKAGE"), fetch("PACKAGE BODY")
    st_spec, st_body = last_ddl("PACKAGE"), last_ddl("PACKAGE BODY")
    fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    mode = sys.argv[1] if len(sys.argv) > 1 else "pre"
    if mode == "pre":
        assert MARK not in spec_pre and MARK not in body_pre, "이미 적용된 원문 — pre 모드 불가 (post 모드로 재생성)"
    else:  # post: DB 가 적용본 → 백업본(수정 전)은 00_BACKUP_ASIS 에서 읽는다
        spec_applied, body_applied = spec_pre, body_pre
        spec_pre = open(os.path.join(CORP, "00_BACKUP_ASIS", f"{PKG}_SPEC.PRE_SAVECLOB.src.sql"), encoding="utf-8").read()
        body_pre = open(os.path.join(CORP, "00_BACKUP_ASIS", f"{PKG}_BODY.PRE_SAVECLOB.src.sql"), encoding="utf-8").read()

    # 지문 (사내 수정 전 원문 · 클라우드 원문 둘 다 — 클라우드판은 빈 줄만 제거된 같은 코드)
    def fps(body_src):
        a, b = seg_split(body_src, "BODY_ALL"); seg = body_src[a:b]
        r = seg[seg.index(A3_S):seg.index(A3_E, seg.index(A3_S)) + len(A3_E)]
        f = {"A3": (len(r), r.count("REGEXP_SUBSTR"))}
        for key, s_, e_, nf, ind, tok in SB:
            i = seg.index(s_); rr = seg[i:seg.index(e_, i) + len(e_)]
            assert seg.count(s_) == 1 and "/*" not in rr and "*/" not in rr, key
            f[key] = (len(rr), rr.count(tok))
        a, b = seg_split(body_src, "BODY_POP"); seg = body_src[a:b]
        r = seg[seg.index(P4_S):seg.index(P4_E, seg.index(P4_S)) + len(P4_E)]
        f["P4"] = (len(r), r.count("NVL(rtrim(ltrim("))
        assert "/*" not in r and "*/" not in r
        return f
    nb = lambda t: [l for l in t.split("\n") if l.strip() != ""]
    cloud_spec = open(os.path.join(CLOUD, "PKG_DMF0020_SPEC.CLOUD.src.sql"), encoding="utf-8").read()
    cloud_body = open(os.path.join(CLOUD, "PKG_DMF0020_BODY.CLOUD.src.sql"), encoding="utf-8").read()
    assert cloud_spec == spec_pre, "클라우드 SPEC ≠ 사내 SPEC"
    assert nb(cloud_body) == nb(body_pre), "클라우드 BODY 가 빈 줄 외에도 사내와 다름 — 재검토 필요"
    f1, f2 = fps(body_pre), fps(cloud_body)
    fp = {k: tuple(dict.fromkeys([f1[k], f2[k]])) for k in f1}
    print("fingerprints corp", f1); print("fingerprints cloud", f2)

    def FP4(k):
        a1 = fp[k][0]; a2 = fp[k][-1]
        return f"{a1[0]}, {a1[1]}, {a2[0]}, {a2[1]}"

    spec_tobe = sim_apply_spec(spec_pre)
    body_tobe = sim_apply_body(body_pre, fp)
    assert sim_rollback_spec(spec_tobe) == spec_pre, "시뮬레이터: SPEC 원복 ≠ 수정 전"
    assert sim_rollback_body(body_tobe) == body_pre, "시뮬레이터: BODY 원복 ≠ 수정 전"
    assert sim_apply_spec(spec_pre) == spec_tobe and sim_apply_body(body_pre, fp) == body_tobe
    if mode == "post":
        assert spec_applied == spec_tobe and body_applied == body_tobe, "post: DB 적용본 ≠ 시뮬레이터 적용본"
    cloud_tobe = sim_apply_body(cloud_body, fp)
    assert sim_rollback_body(cloud_tobe) == cloud_body, "시뮬레이터: 클라우드 BODY 원복 ≠ 클라우드 원문"
    assert nb(cloud_tobe) == nb(body_tobe), "시뮬레이터: 클라우드 적용본이 사내 적용본과 빈 줄 외 다름"
    assert cloud_tobe.count(MARK) == body_tobe.count(MARK)
    open(os.path.join(CLOUD, "PKG_DMF0020_BODY.CLOUD.SAVECLOB.sim.sql"), "w", encoding="utf-8", newline="\n").write(cloud_tobe)
    print("simulator CLOUD OK (적용 == 사내 적용본 빈 줄 무시 · 원복 == 클라우드 원문)")
    n_mark = spec_tobe.count(MARK) + body_tobe.count(MARK)
    print("simulator OK  markers", n_mark, "spec", spec_tobe.count(MARK), "body", body_tobe.count(MARK))

    # 사내 백업/적용본 파일
    for sub in ("00_BACKUP_ASIS", "01_APPLY"):
        os.makedirs(os.path.join(CORP, sub), exist_ok=True)
    os.makedirs(OUT, exist_ok=True)
    stamp_s = f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE LAST_DDL={st_spec[1]} FETCHED={fetched} DB=ZIOUI1\n"
    stamp_b = f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={st_body[1]} FETCHED={fetched} DB=ZIOUI1\n"
    if mode == "pre":
        for nm, txt, st in (("SPEC", spec_pre, stamp_s), ("BODY", body_pre, stamp_b)):
            open(os.path.join(CORP, "00_BACKUP_ASIS", f"{PKG}_{nm}.PRE_SAVECLOB.src.sql"), "w", encoding="utf-8", newline="\n").write(txt)
            open(os.path.join(CORP, "00_BACKUP_ASIS", f"{PKG}_{nm}.PRE_SAVECLOB.sql"), "w", encoding="utf-8", newline="\n").write(
                st + f"-- [{TAG}] 수정 전 원문 (CREATE OR REPLACE 형식 · 원복용)\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + txt.rstrip() + "\n/\n")
        cur.execute("SELECT PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM IN (:a,:b) ORDER BY PROC_NM, SORT_ORD", a=PROC_ALL, b=PROC_POP)
        rows = cur.fetchall()
        open(os.path.join(CORP, "00_BACKUP_ASIS", "SCM_ADM_PROC_M.PRE_SAVECLOB.txt"), "w", encoding="utf-8").write("\n".join("\t".join(map(str, r)) for r in rows) + "\n")
    for nm, txt, st in (("SPEC", spec_tobe, stamp_s), ("BODY", body_tobe, stamp_b)):
        open(os.path.join(CORP, "01_APPLY", f"{PKG}_{nm}.SAVECLOB.sql"), "w", encoding="utf-8", newline="\n").write(
            st + f"-- [{TAG}] 시뮬레이터 적용본 (참조용 · 실제 적용은 A_DB/10 스크립트가 각 DB 의 USER_SOURCE 를 패치)\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + txt.rstrip() + "\n/\n")

    # ───────── PL/SQL 공통 선언 ─────────
    cols_in = ", ".join(repr(c) for c in COLS)
    PROCM_UPD = (f"UPDATE SCM_MGR.SCM_ADM_PROC_M SET DATA_TP_CD = 'CLOB', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE "
                 f"WHERE PROC_NM IN ('{PROC_ALL}', '{PROC_POP}') AND COL_TP_CD = 'IN' AND DATA_TP_CD = 'VARCHAR' AND COL_NM IN ({cols_in})")
    PROCM_RB = PROCM_UPD.replace("SET DATA_TP_CD = 'CLOB'", "SET DATA_TP_CD = 'VARCHAR'").replace("AND DATA_TP_CD = 'VARCHAR'", "AND DATA_TP_CD = 'CLOB'")

    def hdr_consts(key, params, src, pre=True):
        a, b = seg_split(src, key); seg = src[a:b]
        return hdr_lines(seg, params)

    all_hdr = hdr_consts("BODY_ALL", ALL_PARAMS, body_pre)
    pop_hdr = hdr_consts("BODY_POP", POP_PARAMS, body_pre)
    all_hdr_s = hdr_consts("SPEC_ALL", ALL_PARAMS, spec_pre)
    pop_hdr_s = hdr_consts("SPEC_POP", POP_PARAMS, spec_pre)

    def hdr_plsql(pairs, var):  # 컬렉션 초기화 문장
        s = ""
        for i, (old, new) in enumerate(pairs, 1):
            s += f"    {var}_O({i}) := {q(old)};\n    {var}_N({i}) := {q(new)};\n"
        return s

    DECL = f"""    TYPE t_arr IS TABLE OF VARCHAR2(400) INDEX BY PLS_INTEGER;
    v_spec    CLOB;  v_body    CLOB;      -- 원문
    v_spec_n  CLOB;  v_body_n  CLOB;      -- 결과
    v_seg     CLOB;  v_a PLS_INTEGER;  v_b PLS_INTEGER;
    v_st      VARCHAR2(30);  v_err PLS_INTEGER;  v_n PLS_INTEGER;
    v_fail    VARCHAR2(4000);
    c_mark    CONSTANT VARCHAR2(40) := '{MARK}';
    ha_o t_arr; ha_n t_arr; hp_o t_arr; hp_n t_arr; sa_o t_arr; sa_n t_arr; sp_o t_arr; sp_n t_arr;
    v_a2 VARCHAR2(32767); v_a3 VARCHAR2(32767); v_a4 VARCHAR2(32767);
    v_p2 VARCHAR2(32767); v_p2b VARCHAR2(32767); v_p3 VARCHAR2(32767); v_p4 VARCHAR2(32767);
    v_a5 VARCHAR2(32767); v_a6 VARCHAR2(32767); v_a7 VARCHAR2(32767); v_a8 VARCHAR2(32767);
    c_a5_s CONSTANT VARCHAR2(200) := {q(A5_S)};
    c_a5_e CONSTANT VARCHAR2(200) := {q(A5_E)};
    c_a6_s CONSTANT VARCHAR2(200) := {q(A6_S)};
    c_a6_e CONSTANT VARCHAR2(200) := {q(A6_E)};
    c_a7_s CONSTANT VARCHAR2(300) := {q(A7_S)};
    c_a8_s CONSTANT VARCHAR2(300) := {q(A8_S)};
    c_a78_e CONSTANT VARCHAR2(200) := {q(A78_E)};
    c_a2_anchor CONSTANT VARCHAR2(200) := {q(A2_ANCHOR)};
    c_a3_s CONSTANT VARCHAR2(200) := {q(A3_S)};
    c_a3_e CONSTANT VARCHAR2(200) := {q(A3_E)};
    c_a4_s CONSTANT VARCHAR2(200) := {q(A4_S)};
    c_a4_e CONSTANT VARCHAR2(200) := {q(A4_E)};
    c_p2_s CONSTANT VARCHAR2(200) := {q(P2_S)};
    c_p2_e CONSTANT VARCHAR2(200) := {q(P2_E)};
    c_p2b_anchor CONSTANT VARCHAR2(200) := {q(P2B_ANCHOR)};
    c_p3_s CONSTANT VARCHAR2(200) := {q(P3_S)};
    c_p3_e CONSTANT VARCHAR2(200) := {q(P3_E)};
    c_p4_s CONSTANT VARCHAR2(200) := {q(P4_S)};
    c_p4_e CONSTANT VARCHAR2(200) := {q(P4_E)};
    c_p4_x CONSTANT VARCHAR2(400) := {q(P4_X)};
    c_p4_else CONSTANT VARCHAR2(200) := {q(P4_ELSE)};
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        IF p_src IS NULL OR p_tok IS NULL THEN RETURN 0; END IF;
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, 'ABORT - ' || p_name || ' ' || p_got || ' (expected ' || p_exp || '). source unchanged. send 00_PRECHECK output');
        END IF;
    END;
    FUNCTION load(p_type VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE = p_type ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));
    END;
    -- 세그먼트 분리/결합 (p_end 가 ');' 처럼 짧으면 시작 이후 첫 출현)
    PROCEDURE split_seg(p_src CLOB, p_s VARCHAR2, p_e VARCHAR2) IS
    BEGIN
        expect('segment start ' || p_s, cnt(p_src, p_s), 1);
        v_a := DBMS_LOB.INSTR(p_src, p_s);
        v_b := DBMS_LOB.INSTR(p_src, p_e, v_a);
        IF v_b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - segment end not found ' || p_s); END IF;
        v_b := v_b + LENGTH(p_e);
        v_seg := SUBSTR(p_src, v_a, v_b - v_a);
    END;
    FUNCTION join_seg(p_src CLOB) RETURN CLOB IS
    BEGIN
        RETURN SUBSTR(p_src, 1, v_a - 1) || v_seg || SUBSTR(p_src, v_b);
    END;
    PROCEDURE rep1(p_old VARCHAR2, p_new VARCHAR2) IS   -- 세그먼트 안 정확 1회 치환
    BEGIN
        expect('anchor ' || SUBSTR(REPLACE(p_old, CHR(10), '\\n'), 1, 60), cnt(v_seg, p_old), 1);
        v_seg := REPLACE(v_seg, p_old, p_new);
    END;
    FUNCTION orig_wrap(p_key VARCHAR2, p_orig CLOB, p_ind VARCHAR2) RETURN CLOB IS
    BEGIN
        RETURN p_ind || '/*' || c_mark || ' BEGIN-ORIG ' || p_key || CHR(10) || p_orig || p_ind || c_mark || ' END-ORIG ' || p_key || ' */' || CHR(10);
    END;
    -- 구간 치환: [시작앵커 .. 끝앵커] 를 새 텍스트 + ORIG 주석으로 (지문 검사 포함)
    PROCEDURE region_apply(p_key VARCHAR2, p_s VARCHAR2, p_e VARCHAR2, p_new CLOB, p_ind VARCHAR2, p_fp_tok VARCHAR2 DEFAULT NULL, p_fp_len PLS_INTEGER DEFAULT NULL, p_fp_cnt PLS_INTEGER DEFAULT NULL, p_fp_len2 PLS_INTEGER DEFAULT NULL, p_fp_cnt2 PLS_INTEGER DEFAULT NULL) IS
        a PLS_INTEGER; b PLS_INTEGER; r CLOB;
    BEGIN
        expect(p_key || ' start anchor', cnt(v_seg, p_s), 1);
        a := DBMS_LOB.INSTR(v_seg, p_s);
        b := DBMS_LOB.INSTR(v_seg, p_e, a);
        IF b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - ' || p_key || ' end anchor not found. source unchanged'); END IF;
        b := b + LENGTH(p_e);
        r := SUBSTR(v_seg, a, b - a);
        IF p_fp_tok IS NOT NULL THEN
            IF NOT ((LENGTH(r) = p_fp_len AND cnt(r, p_fp_tok) = p_fp_cnt) OR (LENGTH(r) = NVL(p_fp_len2, -1) AND cnt(r, p_fp_tok) = p_fp_cnt2)) THEN
                RAISE_APPLICATION_ERROR(-20003, 'ABORT - ' || p_key || ' fingerprint mismatch: len=' || LENGTH(r) || ' tok=' || cnt(r, p_fp_tok) || ' (expected ' || p_fp_len || '/' || p_fp_cnt || ' or ' || p_fp_len2 || '/' || p_fp_cnt2 || '). this DB source differs - send 00_PRECHECK output. source unchanged');
            END IF;
        END IF;
        IF DBMS_LOB.INSTR(r, '/*') > 0 OR DBMS_LOB.INSTR(r, '*/') > 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'ABORT - ' || p_key || ' region contains block comment. source unchanged');
        END IF;
        v_seg := SUBSTR(v_seg, 1, a - 1) || p_new || orig_wrap(p_key, r, p_ind) || SUBSTR(v_seg, b);
    END;
    -- 구간 원복: [NEW 첫 줄 .. END-ORIG 줄] 을 ORIG 본문으로
    PROCEDURE region_rollback(p_key VARCHAR2, p_ind VARCHAR2, p_new_first VARCHAR2) IS
        s PLS_INTEGER; a PLS_INTEGER; b PLS_INTEGER; o1 VARCHAR2(200); o2 VARCHAR2(200);
    BEGIN
        expect(p_key || ' NEW marker', cnt(v_seg, p_new_first), 1);
        s := DBMS_LOB.INSTR(v_seg, p_new_first);
        o1 := p_ind || '/*' || c_mark || ' BEGIN-ORIG ' || p_key || CHR(10);
        o2 := p_ind || c_mark || ' END-ORIG ' || p_key || ' */' || CHR(10);
        a := DBMS_LOB.INSTR(v_seg, o1, s);
        b := DBMS_LOB.INSTR(v_seg, o2, s);
        IF a = 0 OR b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - ' || p_key || ' ORIG markers not found. source unchanged'); END IF;
        a := a + LENGTH(o1);
        v_seg := SUBSTR(v_seg, 1, s - 1) || SUBSTR(v_seg, a, b - a) || SUBSTR(v_seg, b + LENGTH(o2));
    END;
    PROCEDURE remove_block(p_key VARCHAR2, p_first VARCHAR2, p_last VARCHAR2) IS   -- 삽입 전용 구간 제거 (A2/P2B)
        a PLS_INTEGER; b PLS_INTEGER;
    BEGIN
        expect(p_key || ' NEW marker', cnt(v_seg, p_first), 1);
        a := DBMS_LOB.INSTR(v_seg, p_first);
        b := DBMS_LOB.INSTR(v_seg, p_last, a);
        IF b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - ' || p_key || ' END marker not found'); END IF;
        v_seg := SUBSTR(v_seg, 1, a - 1) || SUBSTR(v_seg, b + LENGTH(p_last));
    END;
    PROCEDURE compile_obj(p_src CLOB, p_type VARCHAR2) IS
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_src;
        EXCEPTION WHEN OTHERS THEN
            NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정 (2026-10-15 GAP452 리허설 정정)
        END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' AND OBJECT_TYPE = p_type;
        SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{PKG}' AND TYPE = p_type AND ATTRIBUTE = 'ERROR';
        IF v_st <> 'VALID' OR v_err > 0 THEN
            FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{PKG}' AND TYPE = p_type AND ATTRIBUTE = 'ERROR' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
                DBMS_OUTPUT.PUT_LINE('  ERR ' || p_type || ' L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
            END LOOP;
            v_fail := p_type || ' ' || v_st || ' errors=' || v_err;
        END IF;
    END;
    PROCEDURE recompile_dependents IS
    BEGIN
        FOR r IN (SELECT DISTINCT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = '{PKG}' AND REFERENCED_TYPE = 'PACKAGE' AND NAME <> '{PKG}') LOOP
            BEGIN
                IF r.TYPE = 'PACKAGE BODY' THEN EXECUTE IMMEDIATE 'ALTER PACKAGE ' || r.NAME || ' COMPILE BODY';
                ELSIF r.TYPE = 'PACKAGE' THEN EXECUTE IMMEDIATE 'ALTER PACKAGE ' || r.NAME || ' COMPILE';
                ELSE EXECUTE IMMEDIATE 'ALTER ' || r.TYPE || ' ' || r.NAME || ' COMPILE';
                END IF;
            EXCEPTION WHEN OTHERS THEN NULL;
            END;
            SELECT MAX(STATUS) INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = r.NAME AND OBJECT_TYPE = r.TYPE;
            DBMS_OUTPUT.PUT_LINE('  dependent ' || RPAD(r.TYPE, 13) || ' ' || RPAD(r.NAME, 45) || ' -> ' || v_st);
        END LOOP;
    END;
"""
    INIT = hdr_plsql(all_hdr, "ha") + hdr_plsql(pop_hdr, "hp") + hdr_plsql(all_hdr_s, "sa") + hdr_plsql(pop_hdr_s, "sp")
    INIT += plsql_assign("v_a2", a2_new()) + plsql_assign("v_a3", a3_new()) + plsql_assign("v_a4", a4_new())
    INIT += "".join(plsql_assign(f"v_{k.lower()}", nf()) for k, _s, _e, nf, _i, _t in SB)
    INIT += plsql_assign("v_p2", p2_new()) + plsql_assign("v_p2b", p2b_new()) + plsql_assign("v_p3", p3_new()) + plsql_assign("v_p4", p4_head())

    APPLY_SPEC = f"""    -- ── SPEC ──
    split_seg(v_spec_n, '{SEG["SPEC_ALL"][0]}', ');');
    FOR i IN 1 .. {len(ALL_PARAMS)} LOOP rep1(sa_o(i), sa_n(i)); END LOOP;
    v_spec_n := join_seg(v_spec_n);
    split_seg(v_spec_n, '{SEG["SPEC_POP"][0]}', ');');
    FOR i IN 1 .. {len(POP_PARAMS)} LOOP rep1(sp_o(i), sp_n(i)); END LOOP;
    v_spec_n := join_seg(v_spec_n);
"""
    APPLY_BODY = f"""    -- ── BODY _ALL ──
    split_seg(v_body_n, '{SEG["BODY_ALL"][0]}', '{SEG["BODY_ALL"][1]}');
    FOR i IN 1 .. {len(ALL_PARAMS)} LOOP rep1(ha_o(i), ha_n(i)); END LOOP;
    rep1(c_a2_anchor, {q("    N_DFLAG_CHK       NUMBER(10) := 0;" + chr(10))} || v_a2 || 'BEGIN' || CHR(10));
    region_apply('A3', c_a3_s, c_a3_e, v_a3, '    ', 'REGEXP_SUBSTR', {FP4("A3")});
    region_apply('A4', c_a4_s, c_a4_e, v_a4, '        ');
    region_apply('A5', c_a5_s, c_a5_e, v_a5, '    ', 'MAX(B.V_CURRENCY)', {FP4("A5")});
    region_apply('A6', c_a6_s, c_a6_e, v_a6, '    ', 'MAX(B.V_ACTIVE_FLAG)', {FP4("A6")});
    region_apply('A7', c_a7_s, c_a78_e, v_a7, '           ', 'DECODE(', {FP4("A7")});
    region_apply('A8', c_a8_s, c_a78_e, v_a8, '           ', 'DECODE(', {FP4("A8")});
    v_body_n := join_seg(v_body_n);
    -- ── BODY _POPUP ──
    split_seg(v_body_n, '{SEG["BODY_POP"][0]}', '{SEG["BODY_POP"][1]}');
    FOR i IN 1 .. {len(POP_PARAMS)} LOOP rep1(hp_o(i), hp_n(i)); END LOOP;
    region_apply('P2', c_p2_s, c_p2_e, v_p2, '    ');
    rep1(c_p2b_anchor, c_p2b_anchor || v_p2b);
    region_apply('P3', c_p3_s, c_p3_e, v_p3, CHR(9));
    DECLARE a PLS_INTEGER; b PLS_INTEGER; r CLOB; x PLS_INTEGER; e PLS_INTEGER; body_if CLOB;
    BEGIN
        expect('P4 start anchor', cnt(v_seg, c_p4_s), 1);
        a := DBMS_LOB.INSTR(v_seg, c_p4_s);
        b := DBMS_LOB.INSTR(v_seg, c_p4_e, a);
        IF b = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'ABORT - P4 end anchor not found. source unchanged'); END IF;
        b := b + LENGTH(c_p4_e);
        r := SUBSTR(v_seg, a, b - a);
        IF NOT ((LENGTH(r) = {fp["P4"][0][0]} AND cnt(r, 'NVL(rtrim(ltrim(') = {fp["P4"][0][1]}) OR (LENGTH(r) = {fp["P4"][-1][0]} AND cnt(r, 'NVL(rtrim(ltrim(') = {fp["P4"][-1][1]})) THEN
            RAISE_APPLICATION_ERROR(-20003, 'ABORT - P4 fingerprint mismatch: len=' || LENGTH(r) || ' tok=' || cnt(r, 'NVL(rtrim(ltrim(') || ' (expected {fp["P4"]}). this DB source differs - send 00_PRECHECK output. source unchanged');
        END IF;
        expect('P4 extract tail', cnt(r, c_p4_x), 1);
        expect('P4 ELSE', cnt(r, c_p4_else), 1);
        IF DBMS_LOB.INSTR(r, '/*') > 0 OR DBMS_LOB.INSTR(r, '*/') > 0 THEN RAISE_APPLICATION_ERROR(-20003, 'ABORT - P4 region contains block comment'); END IF;
        x := DBMS_LOB.INSTR(r, c_p4_x) + LENGTH(c_p4_x);
        e := DBMS_LOB.INSTR(r, c_p4_else) + 1;
        body_if := SUBSTR(r, x, e - x);
        v_seg := SUBSTR(v_seg, 1, a - 1) || v_p4 || body_if || 'END LOOP;' || CHR(10) || '--' || c_mark || ' END-NEW P4' || CHR(10) || orig_wrap('P4', r, '') || SUBSTR(v_seg, b);
    END;
    v_body_n := join_seg(v_body_n);
"""
    ROLL_SPEC = f"""    split_seg(v_spec_n, '{SEG["SPEC_ALL"][0]}', ');');
    FOR i IN 1 .. {len(ALL_PARAMS)} LOOP rep1(sa_n(i), sa_o(i)); END LOOP;
    v_spec_n := join_seg(v_spec_n);
    split_seg(v_spec_n, '{SEG["SPEC_POP"][0]}', ');');
    FOR i IN 1 .. {len(POP_PARAMS)} LOOP rep1(sp_n(i), sp_o(i)); END LOOP;
    v_spec_n := join_seg(v_spec_n);
"""
    ROLL_BODY = f"""    split_seg(v_body_n, '{SEG["BODY_ALL"][0]}', '{SEG["BODY_ALL"][1]}');
    FOR i IN 1 .. {len(ALL_PARAMS)} LOOP rep1(ha_n(i), ha_o(i)); END LOOP;
    remove_block('A2', '    --' || c_mark || ' BEGIN-NEW A2', '    --' || c_mark || ' END-NEW A2' || CHR(10));
    region_rollback('A3', '    ', '    --' || c_mark || ' BEGIN-NEW A3');
    region_rollback('A4', '        ', '        --' || c_mark || ' BEGIN-NEW A4');
    region_rollback('A5', '    ', '    --' || c_mark || ' BEGIN-NEW A5 ');
    region_rollback('A6', '    ', '    --' || c_mark || ' BEGIN-NEW A6 ');
    region_rollback('A7', '           ', '           --' || c_mark || ' BEGIN-NEW A7 ');
    region_rollback('A8', '           ', '           --' || c_mark || ' BEGIN-NEW A8 ');
    v_body_n := join_seg(v_body_n);
    split_seg(v_body_n, '{SEG["BODY_POP"][0]}', '{SEG["BODY_POP"][1]}');
    FOR i IN 1 .. {len(POP_PARAMS)} LOOP rep1(hp_n(i), hp_o(i)); END LOOP;
    region_rollback('P2', '    ', '    --' || c_mark || ' BEGIN-NEW P2 ');
    remove_block('P2B', '    --' || c_mark || ' BEGIN-NEW P2B', '    --' || c_mark || ' END-NEW P2B' || CHR(10));
    region_rollback('P3', CHR(9), CHR(9) || '--' || c_mark || ' BEGIN-NEW P3');
    region_rollback('P4', '', '--' || c_mark || ' BEGIN-NEW P4');
    v_body_n := join_seg(v_body_n);
"""
    COMPILE_BOTH = f"""    -- ── 컴파일: SPEC → BODY · 실패 시 둘 다 원문 복원 ──
    compile_obj(v_spec_n, 'PACKAGE');
    IF v_fail IS NULL THEN compile_obj(v_body_n, 'PACKAGE BODY'); END IF;
    IF v_fail IS NOT NULL THEN
        compile_obj(v_body, 'PACKAGE BODY'); compile_obj(v_spec, 'PACKAGE'); compile_obj(v_body, 'PACKAGE BODY');
        recompile_dependents;
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAILED (' || v_fail || ') -> original SPEC/BODY restored. check 90_VERIFY');
    END IF;
"""
    STAMP = (f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE LAST_DDL={st_spec[1]} / PACKAGE BODY LAST_DDL={st_body[1]} FETCHED={fetched} DB=ZIOUI1 "
             f"(사내 수정 전 원문으로 앵커·지문 산출 · 클라우드는 자기 USER_SOURCE 를 패치)")
    POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' ORDER BY OBJECT_TYPE;"

    APPLY = f"""{STAMP}
-- 10_APPLY — {MARK} DMF0020 저장 SP 대량 한도 해제 (전체 F5, 값 입력 없음, 멱등) — 실행 계정 SCM_MGR
-- 증상: Batch Price Input 모달 대량 저장 "SQL ERROR" (클라우드 2026-10-21)
-- 원인: 모달 저장 = 메인 SAVE = P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL — IN 17종 VARCHAR2(32,767B 한도) + REGEXP_SUBSTR … CONNECT BY LEVEL 분할(O(N^2): 300행 13초 · 1,700행 10분 초과)
-- 내용: S1/B1 _ALL IN 17 · _POPUP IN 16 VARCHAR2→CLOB / A2·A3 선형 분할+FORALL / A4 진단 JSON RETURNING CLOB / A5·A6 상관 UPDATE→MERGE / A7·A8 보충 NOT EXISTS 해시화 / P2~P4 _POPUP 홀더→컬렉션 루프 / M1 PROC_M 33행 CLOB / D1 의존 재컴파일
-- 범위: PKG_DMF0020 SPEC+BODY 두 프로시저 + SCM_ADM_PROC_M 두 PROC_NM. FE·BE·원장·메타(그 외)·권한·GTT 무변경. BE 재기동 불필요(PROC_M 은 호출마다 조회).
-- 방식: 이 DB 의 USER_SOURCE 를 ASCII 앵커로 치환(한글 비교 없음) → CREATE OR REPLACE SPEC → BODY. 원문 구간은 /*ORIG*/ 주석으로 보존(원복이 자기 소스에서 복원).
-- 가드: 마커 존재 시 무동작 · 앵커 건수/구간 지문(글자수·토큰수) 불일치 시 중단(원문 무변경) · 컴파일 실패 시 SPEC/BODY 원문 자동 복원 · 성공 후에만 PROC_M 갱신+COMMIT
-- 사내 ZIOUI1 적용·리허설 완료 — 00_README.md 참조. 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
    IF USER <> 'SCM_MGR' THEN RAISE_APPLICATION_ERROR(-20000, 'ABORT - run as SCM_MGR (current ' || USER || ')'); END IF;
{INIT}
    v_spec := load('PACKAGE'); v_body := load('PACKAGE BODY');
    IF DBMS_LOB.INSTR(v_spec, c_mark) > 0 OR DBMS_LOB.INSTR(v_body, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied (marker present). source unchanged');
        RETURN;
    END IF;
    v_spec_n := v_spec; v_body_n := v_body;
{APPLY_SPEC}{APPLY_BODY}
    expect('marker count (spec+body)', cnt(v_spec_n, c_mark) + cnt(v_body_n, c_mark), {n_mark});
{COMPILE_BOTH}
    recompile_dependents;
    {PROCM_UPD};
    v_n := SQL%ROWCOUNT;
    SELECT COUNT(*) INTO v_err FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ('{PROC_ALL}', '{PROC_POP}') AND COL_TP_CD = 'IN' AND DATA_TP_CD = 'CLOB';
    IF v_err <> {len(COLS) + len(COLS) - 1} THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, 'PROC_M CLOB rows ' || v_err || ' (expected {len(COLS) + len(COLS) - 1}) -> PROC_M rolled back (package stays applied; CLOB param accepts VARCHAR bind). send 90_VERIFY output');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('APPLIED - {PKG} SPEC/BODY VALID · markers {n_mark} · PROC_M updated ' || v_n || ' (CLOB rows ' || v_err || ') · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""
    ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — {MARK} 원복 (전체 F5, 값 입력 없음, 멱등) — ORIG 주석에서 원문 구간 복원 + IN CLOB→VARCHAR2 + PROC_M VARCHAR 복귀 + 의존 재컴파일
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
    IF USER <> 'SCM_MGR' THEN RAISE_APPLICATION_ERROR(-20000, 'ABORT - run as SCM_MGR (current ' || USER || ')'); END IF;
{INIT}
    v_spec := load('PACKAGE'); v_body := load('PACKAGE BODY');
    IF DBMS_LOB.INSTR(v_spec, c_mark) = 0 AND DBMS_LOB.INSTR(v_body, c_mark) = 0 THEN
        {PROCM_RB};
        v_n := SQL%ROWCOUNT; COMMIT;
        DBMS_OUTPUT.PUT_LINE('SKIP - marker absent (not applied). source unchanged. PROC_M VARCHAR restored rows=' || v_n);
        RETURN;
    END IF;
    v_spec_n := v_spec; v_body_n := v_body;
{ROLL_SPEC}{ROLL_BODY}
    expect('marker remaining', cnt(v_spec_n, c_mark) + cnt(v_body_n, c_mark), 0);
    -- 컴파일: SPEC → BODY · 실패 시 적용본으로 되돌림
    compile_obj(v_spec_n, 'PACKAGE');
    IF v_fail IS NULL THEN compile_obj(v_body_n, 'PACKAGE BODY'); END IF;
    IF v_fail IS NOT NULL THEN
        compile_obj(v_body, 'PACKAGE BODY'); compile_obj(v_spec, 'PACKAGE'); compile_obj(v_body, 'PACKAGE BODY');
        recompile_dependents;
        RAISE_APPLICATION_ERROR(-20005, 'ROLLBACK COMPILE FAILED (' || v_fail || ') -> applied SPEC/BODY restored. check 90_VERIFY');
    END IF;
    recompile_dependents;
    {PROCM_RB};
    v_n := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - {PKG} SPEC/BODY VALID · markers 0 · PROC_M VARCHAR restored ' || v_n || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""
    # ───────── 00 PRECHECK (조회 전용) ─────────
    def chk_lines(pairs, label):
        s = ""
        for i, (old, _n) in enumerate(pairs, 1):
            s += f"    DBMS_OUTPUT.PUT_LINE('L1 ' || RPAD('{label}', 10) || RPAD({q(old.strip()[:50])}, 52) || ' ' || cnt(v_seg, {q(old)}) || CASE WHEN cnt(v_seg, {q(old)}) = 1 THEN ' PASS' ELSE ' FAIL' END);\n"
        return s

    PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). {MARK} 적용 전 상태 판정 — 실행 계정 SCM_MGR
-- * [L0] 접속 DB · PKG_DMF0020 상태·LAST_DDL · 줄수
-- * [L1] 앵커 건수 — SPEC/BODY IN 선언 33줄(각 1) · A2/A4/P2/P2B/P3 앵커(각 1) · A3·A5~A8·P4 구간 지문(글자수·토큰수 — 사내판 또는 빈 줄 제거된 클라우드판 {fp["A3"]} / {fp["P4"]})  → 전부 PASS 기대. FAIL 이면 10 실행 금지·결과 회신
-- * [L2] 마커 — 적용 전 0
-- * [L3] SCM_ADM_PROC_M 두 PROC_NM IN 33행 DATA_TP_CD (VARCHAR 기대)
-- * [L4] PKG_DMF0020 의존 객체(적용 후 재컴파일 대상) · [L5] 지금 PKG_DMF0020 실행 중 세션(있으면 끝난 뒤 10 실행)
-- * [L6] 배선 — DMF0020 main/priceBatch SAVE → 두 프로시저 (사내 동일 기대)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, USER USR, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
DECLARE
{DECL}    PROCEDURE fp(p_key VARCHAR2, p_s VARCHAR2, p_e VARCHAR2, p_tok VARCHAR2, p_len PLS_INTEGER, p_cnt PLS_INTEGER, p_len2 PLS_INTEGER, p_cnt2 PLS_INTEGER) IS
        a PLS_INTEGER; b PLS_INTEGER; r CLOB;
    BEGIN
        IF cnt(v_seg, p_s) <> 1 THEN DBMS_OUTPUT.PUT_LINE('L1 ' || p_key || ' start anchor ' || cnt(v_seg, p_s) || ' FAIL'); RETURN; END IF;
        a := DBMS_LOB.INSTR(v_seg, p_s); b := DBMS_LOB.INSTR(v_seg, p_e, a);
        IF b = 0 THEN DBMS_OUTPUT.PUT_LINE('L1 ' || p_key || ' end anchor not found FAIL'); RETURN; END IF;
        r := SUBSTR(v_seg, a, b + LENGTH(p_e) - a);
        DBMS_OUTPUT.PUT_LINE('L1 ' || p_key || ' region len=' || LENGTH(r) || ' tok=' || cnt(r, p_tok) || ' (expected ' || p_len || '/' || p_cnt || ' or ' || p_len2 || '/' || p_cnt2 || ')' ||
            CASE WHEN (LENGTH(r) = p_len AND cnt(r, p_tok) = p_cnt) OR (LENGTH(r) = p_len2 AND cnt(r, p_tok) = p_cnt2) THEN ' PASS' ELSE ' FAIL - source differs (send this output)' END);
    END;
BEGIN
{INIT}
    v_spec := load('PACKAGE'); v_body := load('PACKAGE BODY');
    DBMS_OUTPUT.PUT_LINE('L2 marker count spec=' || cnt(v_spec, c_mark) || ' body=' || cnt(v_body, c_mark) || CASE WHEN cnt(v_spec, c_mark) + cnt(v_body, c_mark) = 0 THEN ' (not applied - expected)' ELSE ' (already applied - 10 is a no-op)' END);
    split_seg(v_spec, '{SEG["SPEC_ALL"][0]}', ');');
{chk_lines(all_hdr_s, "SPEC_ALL")}    split_seg(v_spec, '{SEG["SPEC_POP"][0]}', ');');
{chk_lines(pop_hdr_s, "SPEC_POP")}    split_seg(v_body, '{SEG["BODY_ALL"][0]}', '{SEG["BODY_ALL"][1]}');
{chk_lines(all_hdr, "BODY_ALL")}    DBMS_OUTPUT.PUT_LINE('L1 A2 anchor ' || cnt(v_seg, c_a2_anchor) || CASE WHEN cnt(v_seg, c_a2_anchor) = 1 THEN ' PASS' ELSE ' FAIL' END);
    fp('A3', c_a3_s, c_a3_e, 'REGEXP_SUBSTR', {FP4("A3")});
    fp('A5', c_a5_s, c_a5_e, 'MAX(B.V_CURRENCY)', {FP4("A5")});
    fp('A6', c_a6_s, c_a6_e, 'MAX(B.V_ACTIVE_FLAG)', {FP4("A6")});
    fp('A7', c_a7_s, c_a78_e, 'DECODE(', {FP4("A7")});
    fp('A8', c_a8_s, c_a78_e, 'DECODE(', {FP4("A8")});
    DBMS_OUTPUT.PUT_LINE('L1 A4 start ' || cnt(v_seg, c_a4_s) || ' end ' || cnt(v_seg, c_a4_e) || CASE WHEN cnt(v_seg, c_a4_s) = 1 AND cnt(v_seg, c_a4_e) = 1 THEN ' PASS' ELSE ' FAIL' END);
    split_seg(v_body, '{SEG["BODY_POP"][0]}', '{SEG["BODY_POP"][1]}');
{chk_lines(pop_hdr, "BODY_POP")}    DBMS_OUTPUT.PUT_LINE('L1 P2 start ' || cnt(v_seg, c_p2_s) || ' end ' || cnt(v_seg, c_p2_e) || CASE WHEN cnt(v_seg, c_p2_s) = 1 AND cnt(v_seg, c_p2_e) = 1 THEN ' PASS' ELSE ' FAIL' END);
    DBMS_OUTPUT.PUT_LINE('L1 P2B anchor ' || cnt(v_seg, c_p2b_anchor) || CASE WHEN cnt(v_seg, c_p2b_anchor) = 1 THEN ' PASS' ELSE ' FAIL' END);
    DBMS_OUTPUT.PUT_LINE('L1 P3 start ' || cnt(v_seg, c_p3_s) || ' end ' || cnt(v_seg, c_p3_e) || CASE WHEN cnt(v_seg, c_p3_s) = 1 AND cnt(v_seg, c_p3_e) = 1 THEN ' PASS' ELSE ' FAIL' END);
    fp('P4', c_p4_s, c_p4_e, 'NVL(rtrim(ltrim(', {FP4("P4")});
    DBMS_OUTPUT.PUT_LINE('L1 P4 extract-tail ' || cnt(v_seg, c_p4_x) || ' ELSE ' || cnt(v_seg, c_p4_else) || CASE WHEN cnt(v_seg, c_p4_x) = 1 AND cnt(v_seg, c_p4_else) = 1 THEN ' PASS' ELSE ' FAIL' END);
END;
/
SELECT 'L3 PROC_M' CHK, PROC_NM, DATA_TP_CD, COL_TP_CD, COUNT(*) N, CASE WHEN COL_TP_CD='IN' AND DATA_TP_CD='VARCHAR' THEN 'VARCHAR (expected before apply)' WHEN COL_TP_CD='IN' AND DATA_TP_CD='CLOB' THEN 'CLOB (already applied)' ELSE '' END JUDGE
  FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ('{PROC_ALL}', '{PROC_POP}') GROUP BY PROC_NM, DATA_TP_CD, COL_TP_CD ORDER BY 2, 4, 3;
SELECT 'L4 dependents' CHK, NAME, TYPE, (SELECT MAX(STATUS) FROM USER_OBJECTS O WHERE O.OBJECT_NAME = D.NAME AND O.OBJECT_TYPE = D.TYPE) STATUS
  FROM (SELECT DISTINCT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = '{PKG}' AND REFERENCED_TYPE = 'PACKAGE' AND NAME <> '{PKG}') D ORDER BY 2, 3;
SELECT 'L5 running' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='PACKAGE');
SELECT 'L6 wiring' CHK, M.MNU_ID, M.SHT_NM, M.MNU_BTN_CD, A.API_URL, M.USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M M JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = M.API_ID
 WHERE M.MNU_ID = 'DMF0020' AND M.MNU_BTN_CD = 'SAVE' AND M.SHT_NM IN ('main', 'priceBatch') ORDER BY M.SHT_NM;
"""
    VERIFY = f"""-- 90_VERIFY — {MARK} 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 {n_mark} PASS · V2 SPEC/BODY VALID · 오류 0 · 의존 INVALID 0 · V3 ALL_ARGUMENTS IN 33 CLOB · V4 PROC_M IN 33 CLOB · V5 의존 객체 전부 VALID
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 marker' CHK, TYPE, COUNT(*) N FROM USER_SOURCE WHERE NAME='{PKG}' AND TEXT LIKE '%{MARK}%' GROUP BY TYPE
UNION ALL SELECT 'V1 marker', 'TOTAL', COUNT(*) FROM USER_SOURCE WHERE NAME='{PKG}' AND TEXT LIKE '%{MARK}%' ORDER BY 2;
SELECT 'V1 judge' CHK, CASE WHEN COUNT(*) = {n_mark} THEN 'PASS' ELSE 'FAIL (expected {n_mark})' END JUDGE FROM USER_SOURCE WHERE NAME='{PKG}' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 status' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE AND E.ATTRIBUTE='ERROR') ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{PKG}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 args' CHK, OBJECT_NAME, DATA_TYPE, COUNT(*) N, CASE WHEN DATA_TYPE = 'CLOB' AND COUNT(*) = CASE OBJECT_NAME WHEN 'P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL' THEN 17 ELSE 16 END THEN 'PASS' ELSE 'CHECK' END JUDGE
  FROM USER_ARGUMENTS WHERE PACKAGE_NAME='{PKG}' AND OBJECT_NAME IN ('P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL','P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP') AND IN_OUT='IN'
 GROUP BY OBJECT_NAME, DATA_TYPE ORDER BY 2, 3;
SELECT 'V4 PROC_M' CHK, PROC_NM, DATA_TP_CD, COUNT(*) N, CASE WHEN DATA_TP_CD='CLOB' AND COUNT(*) = CASE PROC_NM WHEN '{PROC_ALL}' THEN 17 ELSE 16 END THEN 'PASS' ELSE 'FAIL' END JUDGE
  FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ('{PROC_ALL}', '{PROC_POP}') AND COL_TP_CD='IN' GROUP BY PROC_NM, DATA_TP_CD ORDER BY 2, 3;
SELECT 'V5 dependents' CHK, NAME, TYPE, (SELECT MAX(STATUS) FROM USER_OBJECTS O WHERE O.OBJECT_NAME = D.NAME AND O.OBJECT_TYPE = D.TYPE) STATUS
  FROM (SELECT DISTINCT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME = '{PKG}' AND REFERENCED_TYPE = 'PACKAGE' AND NAME <> '{PKG}') D ORDER BY 2, 3;
SELECT 'V6 residue' CHK, K.KIND, COUNT(S.LINE) N, CASE WHEN COUNT(S.LINE) = 0 THEN 'PASS' ELSE 'FAIL' END JUDGE
  FROM (SELECT 'active REGEXP_SUBSTR in _ALL (outside ORIG comment)' KIND FROM DUAL) K
  LEFT JOIN USER_SOURCE S ON S.NAME = '{PKG}' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%,TRIM(REGEXP_SUBSTR(P_%'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK} BEGIN-ORIG A3%')
 GROUP BY K.KIND;
"""
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_SAVECLOB_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_SAVECLOB_PATCH.sql": ROLLBACK}
    for name, body in files.items():
        open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
        print("wrote", name, len(body.splitlines()), "lines", len(body.encode("utf-8")), "bytes")
    meta = {"tag": TAG, "mark": MARK, "n_mark": n_mark, "fp": fp, "last_ddl": {"spec": st_spec[1], "body": st_body[1]}, "fetched": fetched,
            "md5_pre": {"spec": hashlib.md5(spec_pre.encode()).hexdigest(), "body": hashlib.md5(body_pre.encode()).hexdigest()},
            "md5_tobe": {"spec": hashlib.md5(spec_tobe.encode()).hexdigest(), "body": hashlib.md5(body_tobe.encode()).hexdigest()}}
    open(os.path.join(HERE, "_build_meta.json"), "w", encoding="utf-8").write(json.dumps(meta, ensure_ascii=False, indent=1))
    print("meta", meta)


if __name__ == "__main__":
    main()
