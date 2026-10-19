"""PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD — Excel Upload 검증 메시지 시인성 보완 [E20260923-DMF0014VALMSG]

사용자 지시 (2026-09-23):
  ① 각 컬럼별 문제 발생 시 정확히 문제 있는 컬럼을 지정 + 실제 입력값 기준으로 표기
  ② 동적(기간) 구간: 숫자 아닌 문자 → 'Invalid Numeric', 값 없음 → 'Please Input QTY' (컬럼별)
  ③ FE/BE 무변경 — DB 객체(PKG_DMF0014 BODY 메인 프로시저)만 수정. `_SM` 무변경(미배선).
메시지 규격 = '<규칙명> [<헤더 라벨>: <입력값>]' — 헤더 라벨은 사용자 파일의 헤더행(V_TITLE) 실측값, 빈값은 '(empty)'.
동일 원인의 연쇄 오류(예: Sales Site 오류 → Bucket/UOM/Measure 까지 4건)는 상위 검증 통과 행에만 하위 검증을 적용해
1행 = 근본 원인만 남긴다(반려 집합 불변).
usage: python apply_valmsg.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0014", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0014_BODY.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0014_BODY.sql"
SPLIT = "PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM"
TAG = "E20260923-DMF0014VALMSG"
BATCH = """PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE"""
STATUS_LINE = "AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')\n"


def val(col, alias=""):
    return f"NVL({alias}ATTRIBUTE{col},'(empty)')"


def msg(rule, *pairs, alias=""):
    """'<rule> [<hdr>: <val>, ...]' SQL 식 — pairs = (컬럼번호,) 또는 (컬럼번호, 값식)"""
    parts = []
    for p in pairs:
        col = p[0]; v = p[1] if len(p) > 1 else val(col, alias)
        parts.append(f"v_h{col}||': '||{v}")
    body = "||', '||".join(parts)
    return f"'{rule} ['||{body}||']'"


def set_clause(expr, alias=""):
    a = alias
    return (f"SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = SUBSTR(CASE WHEN {a}MESSAGE_TEXT IS NULL THEN {expr} "
            f"ELSE {a}MESSAGE_TEXT || ' / ' || {expr} END, 1, 4000)  /*[{TAG}]*/")


# ── 가드(상위 검증 통과 조건) ─────────────────────────────────────────────────────────────
DIV_OK = ("EXISTS (SELECT 1 FROM SCM_MST_DIVISION G WHERE G.VALID_YN = 'Y' "
          "AND (G.DIVISION_ID = {a}ATTRIBUTE1 OR G.DIVISION_NAME = {a}ATTRIBUTE1))")
SITE_OK = ("EXISTS (SELECT 1 FROM SCM_MST_SITE GS, SCM_MST_DIVISION GD WHERE GS.DIVISION_ID = GD.DIVISION_ID AND GS.VALID_YN = 'Y' "
           "AND GS.SCM_SITE_ID = {a}ATTRIBUTE2 AND (GD.DIVISION_ID = {a}ATTRIBUTE1 OR GD.DIVISION_NAME = {a}ATTRIBUTE1))")
FCST_OK = ("EXISTS (SELECT 1 FROM DM_MST_CUSTOMER_FCST GF, SCM_MST_DIVISION GD WHERE GF.VALID_YN = 'Y' AND GF.DIVISION_ID = GD.DIVISION_ID "
           "AND (GD.DIVISION_ID = {a}ATTRIBUTE1 OR GD.DIVISION_NAME = {a}ATTRIBUTE1) AND GF.SCM_SITE_ID = {a}ATTRIBUTE2 AND GF.MEASURE = {a}ATTRIBUTE10)")
UOM_LKP_OK = ("EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL GL WHERE GL.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE' AND GL.VALID_YN = 'Y' "
              "AND GL.SEGMENT1 = UPPER({a}ATTRIBUTE11))")
CPRJ_OK = ("EXISTS (SELECT 1 FROM DM_MST_CUSTOMER_MODEL GC, SCM_MST_DIVISION GD WHERE GC.DIVISION_ID = GD.DIVISION_ID AND GC.VALID_YN = 'Y' "
           "AND (GD.DIVISION_ID = {a}ATTRIBUTE1 OR GD.DIVISION_NAME = {a}ATTRIBUTE1) AND GC.SCM_SITE_ID = {a}ATTRIBUTE2 "
           "AND GC.CUSTOMER_PROJECT_CODE = {a}ATTRIBUTE4)")
SITEITEM_OK = ("EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM GI, SCM_MST_DIVISION GD WHERE GI.DIVISION_ID = GD.DIVISION_ID AND GI.VALID_YN = 'Y' "
               "AND (GD.DIVISION_ID = {a}ATTRIBUTE1 OR GD.DIVISION_NAME = {a}ATTRIBUTE1) AND GI.SCM_SITE_ID = {a}ATTRIBUTE2 "
               "AND GI.PROJECT_CODE = {a}ATTRIBUTE12 AND GI.ITEM_ID = {a}ATTRIBUTE13)")
CMDL_OK = ("EXISTS (SELECT 1 FROM DM_MST_CUSTOMER_MODEL GC, SCM_MST_DIVISION GD WHERE GC.DIVISION_ID = GD.DIVISION_ID AND GC.VALID_YN = 'Y' "
           "AND (GD.DIVISION_ID = {a}ATTRIBUTE1 OR GD.DIVISION_NAME = {a}ATTRIBUTE1) AND GC.SCM_SITE_ID = {a}ATTRIBUTE2 "
           "AND GC.CUSTOMER_PROJECT_CODE = {a}ATTRIBUTE4 AND GC.CUSTOMER_MODEL = {a}ATTRIBUTE5)")
CHECKED_ITEM = ("NVL((SELECT MAX(GC.ITEM_ID) FROM DM_MST_CUSTOMER_MODEL GC, SCM_MST_DIVISION GD WHERE GC.DIVISION_ID = GD.DIVISION_ID "
                "AND (GD.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR GD.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1) "
                "AND GC.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2 AND GC.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4 "
                "AND GC.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5), SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13)")

# ── 고정 컬럼 검증 14 블록: (현 메시지 앞머리, 규칙명, 컬럼 pairs, 별칭, 가드, 가드 사유) ──────────
FIXED = [
    ("'Duplication Key - ", "Duplication Key", [(2,), (4,), (5,)], "", [], ""),
    ("'Invalid Division - ", "Invalid Division", [(1,)], "", [], ""),
    ("'Invalid Measure Upload Bucket - ", "Invalid Measure Upload Bucket", [(10,)], "AEU.", [SITE_OK, FCST_OK],
     "Sales Site·(Site,Measure) 마스터 통과 행만 — 상위 오류가 Bucket 으로 중복 표기되지 않게"),
    ("'Invalid Measure Upload UOM - ", "Invalid Measure Upload UOM", [(11,)], "", [SITE_OK, FCST_OK, UOM_LKP_OK],
     "룩업 미등재 UOM 은 'Invalid Upload UOM' 이 담당 — 여기는 등록 UOM 과의 불일치만"),
    ("'Invalid Sales Site - ", "Invalid Sales Site", [(2,)], "", [DIV_OK], "Division 오류 행은 제외(근본 원인 1건만)"),
    ("'Invalid Plant Site - ", "Invalid Plant Site", [(3,)], "", [DIV_OK], "Division 오류 행은 제외"),
    ("'Invalid Customer Model - ", "Invalid Customer Model", [(5,)], "", [SITE_OK, CPRJ_OK],
     "Sales Site·Customer Project 통과 행만 — Project 오류는 위 'Invalid Customer Project' 가 담당"),
    ("'Invalid Model - ", "Invalid Model", [(13, CHECKED_ITEM)], "", [f"({CMDL_OK} OR {SITEITEM_OK})"],
     "Customer Model/품목경로 통과 행만 — 표기 값 = 실제 대조한 품목(Customer Model 품목, 없으면 [Model] 열)"),
    ("'Invalid Customs Handbook - ", "Invalid Customs Handbook", [(8,)], "", [], ""),
    ("'Invalid Incoterms - ", "Invalid Incoterms", [(6,)], "", [], ""),
    ("'Invalid FCST Type - ", "Invalid FCST Type", [(7,)], "", [], ""),
    ("'Invalid Measure Group - ", "Invalid Measure Group", [(9,)], "", [], ""),
    ("'Invalid Upload UOM - ", "Invalid Upload UOM", [(11,)], "", [], ""),
    ("'Invalid Upload UOM (Customer FCST) - ", "Invalid Measure", [(2,), (10,)], "", [SITE_OK],
     "(Division, Sales Site, Measure) 고객 FCST 마스터 미등재 — 종전 명칭 'Invalid Upload UOM (Customer FCST)' 는 UOM 오류로 오독돼 개명. Sales Site 오류 행은 제외"),
]

HDR_FETCH = f"""            /* [{TAG}] 검증 메시지용 헤더 라벨 = 사용자 파일 헤더행(V_TITLE) 실측값 — 메시지 '<규칙> [<헤더>: <입력값>]' 의 <헤더> */
            BEGIN
                SELECT NVL(ATTRIBUTE1,'Division*'), NVL(ATTRIBUTE2,'Sales Site*'), NVL(ATTRIBUTE3,'Plant Site*'), NVL(ATTRIBUTE4,'Customer Project*')
                      ,NVL(ATTRIBUTE5,'Customer Model*'), NVL(ATTRIBUTE6,'Incoterms*'), NVL(ATTRIBUTE7,'FCST Type*'), NVL(ATTRIBUTE8,'Customs Handbook*')
                      ,NVL(ATTRIBUTE9,'Measure Group*'), NVL(ATTRIBUTE10,'Measure*'), NVL(ATTRIBUTE11,'Upload UOM*'), NVL(ATTRIBUTE12,'Project'), NVL(ATTRIBUTE13,'Model')
                INTO   v_h1, v_h2, v_h3, v_h4, v_h5, v_h6, v_h7, v_h8, v_h9, v_h10, v_h11, v_h12, v_h13
                FROM   SCM_ADM_EXCEL_UPLOAD
                WHERE  {BATCH}
                AND    UPLOAD_STATUS_CODE = 'V_TITLE'
                AND    ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                v_h1 := 'Division*'; v_h2 := 'Sales Site*'; v_h3 := 'Plant Site*'; v_h4 := 'Customer Project*'; v_h5 := 'Customer Model*';
                v_h6 := 'Incoterms*'; v_h7 := 'FCST Type*'; v_h8 := 'Customs Handbook*'; v_h9 := 'Measure Group*'; v_h10 := 'Measure*';
                v_h11 := 'Upload UOM*'; v_h12 := 'Project'; v_h13 := 'Model';
            END;

"""

DECL_OLD = "        v_err_kinds      NUMBER := 0;\n"
DECL_NEW = DECL_OLD + f"""        /* [{TAG}] 검증 메시지 헤더 라벨 (V_TITLE 행 ATTRIBUTE1~13) */
        v_h1  VARCHAR2(150 CHAR); v_h2  VARCHAR2(150 CHAR); v_h3  VARCHAR2(150 CHAR); v_h4  VARCHAR2(150 CHAR); v_h5  VARCHAR2(150 CHAR);
        v_h6  VARCHAR2(150 CHAR); v_h7  VARCHAR2(150 CHAR); v_h8  VARCHAR2(150 CHAR); v_h9  VARCHAR2(150 CHAR); v_h10 VARCHAR2(150 CHAR);
        v_h11 VARCHAR2(150 CHAR); v_h12 VARCHAR2(150 CHAR); v_h13 VARCHAR2(150 CHAR);
"""

CPRJ_BLOCK = f"""            IF V_DIVISION != '40' THEN
                /* [{TAG}] Customer Project 분리 검증 — 종전엔 Customer Model 조합 검증이 Project 오류까지
                   'Invalid Customer Model' 로 뭉뚱그렸다. 판정 = (Division, Sales Site, Customer Project) 가 고객모델 마스터에 없고
                   [Project]/[Model] 품목 경로(SITE_ITEM)로도 구제되지 않는 행. 반려 집합은 종전과 동일 — 메시지만 분리. */
                UPDATE SCM_ADM_EXCEL_UPLOAD
                {set_clause(msg('Invalid Customer Project', (4,)))}
                WHERE  {BATCH}
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    {SITE_OK.format(a='SCM_ADM_EXCEL_UPLOAD.')}  /*[{TAG}] 가드: Division/Sales Site 오류 행은 제외(근본 원인 1건만)*/
                AND    NOT {CPRJ_OK.format(a='SCM_ADM_EXCEL_UPLOAD.')}
                AND    NOT {SITEITEM_OK.format(a='SCM_ADM_EXCEL_UPLOAD.')};
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '61';
                    V_LOG_MESSAGE := '########## ERROR Invalid Customer Project. ##########';
                    V_DESCRIPTION := 'rows=' || TO_CHAR(v_err_cnt);
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                END IF;
            END IF;

"""

CMDL_IF = ("            IF V_DIVISION != '40' THEN\n                UPDATE SCM_ADM_EXCEL_UPLOAD\n"
           "                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Customer Model - ")


def attr_list():
    return ", ".join(f"ATTRIBUTE{i}" for i in range(14, 201))


def unpivot_in():
    return ", ".join(f"ATTRIBUTE{i} AS {i}" for i in range(14, 201))


QTY_BLOCK = f"""            /* ==========================================================================
               [{TAG}] 동적(기간) 구간 = 셀 단위 검증 (사용자 지시 2026-09-23)
                 종전 = UNPIVOT 집계 후 행 단위 'Invalid Quantity' 1건 — 어느 기간 칸이 문제인지 알 수 없었다.
                 헤더행(V_TITLE)에 기간 값이 있는 칸(ATTRIBUTE14~200)마다, 기간 순서로 ' / ' 누적:
                   ① 숫자 아닌 값          → 'Invalid Numeric [YYYYMMDD: 값]'
                   ② 소수점(정수만 허용)    → 'Invalid Decimal [YYYYMMDD: 값]'   (E20230119-000186 정수 정책 유지)
                   ③ 빈값                  → 'Please Input QTY [YYYYMMDD]'      (사용자 지정 문구)
                      - 회색(입력불가) 주차 = Customer Fcst Master VALID_YN='Y' 밖 → GRAYZERO 정책상 0 적재이므로 빈값 검사 제외
                      - 판정식은 적재부 GRAYZERO CASE 와 동일 술어 (기준이 갈라지면 화면 색과 어긋난다)
                 한 행에 31칸 이상이면 30칸까지 표기 + ' ... (+N more)' (MESSAGE_TEXT 4000 보호, 12c 호환 — ON OVERFLOW 미사용)
               ========================================================================== */
            BEGIN
                MERGE INTO SCM_ADM_EXCEL_UPLOAD A
                USING (SELECT Q.UPLOAD_ID
                             ,LISTAGG(CASE WHEN Q.RN <= 30 THEN Q.MSG END, ' / ') WITHIN GROUP (ORDER BY Q.COL_IDX)
                              || CASE WHEN MAX(Q.CNT) > 30 THEN ' ... (+' || TO_CHAR(MAX(Q.CNT) - 30) || ' more)' END AS MSGS
                       FROM  (SELECT P.UPLOAD_ID, P.COL_IDX, P.MSG
                                    ,ROW_NUMBER() OVER (PARTITION BY P.UPLOAD_ID ORDER BY P.COL_IDX) RN
                                    ,COUNT(*)     OVER (PARTITION BY P.UPLOAD_ID) CNT
                              FROM  (SELECT V.UPLOAD_ID, V.COL_IDX
                                           ,CASE WHEN TRIM(V.VALUE) IS NULL
                                                 THEN CASE WHEN EXISTS (SELECT 1
                                                                        FROM   DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                                                                        WHERE  M.VALID_YN = 'Y'
                                                                        AND    M.DIVISION_ID = MD.DIVISION_ID
                                                                        AND    (MD.DIVISION_ID = V.ATTRIBUTE1 OR MD.DIVISION_NAME = V.ATTRIBUTE1)
                                                                        AND    M.SCM_SITE_ID = V.ATTRIBUTE2
                                                                        AND    M.MEASURE     = V.ATTRIBUTE10
                                                                        AND    M.SUMMARY_BUCKET_VALUE =
                                                                               CASE WHEN REGEXP_LIKE(TRIM(H.HDR), '^[0-9.eE+-]+$')
                                                                                    THEN TO_CHAR(TO_NUMBER(TRIM(H.HDR)), 'FM99999999')
                                                                                    ELSE TRIM(H.HDR) END)
                                                           THEN 'Please Input QTY [' || TRIM(H.HDR) || ']' END
                                                 WHEN NOT REGEXP_LIKE(TRIM(V.VALUE), '^-?[0-9]*\\.?[0-9]+$')
                                                 THEN 'Invalid Numeric [' || TRIM(H.HDR) || ': ' || V.VALUE || ']'
                                                 WHEN ROUND(TO_NUMBER(TRIM(V.VALUE)), 10) - FLOOR(ROUND(TO_NUMBER(TRIM(V.VALUE)), 10)) <> 0
                                                 THEN 'Invalid Decimal [' || TRIM(H.HDR) || ': ' || V.VALUE || ']'
                                            END AS MSG
                                     FROM  (SELECT UPLOAD_ID, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE10, COL_IDX, VALUE
                                            FROM  (SELECT UPLOAD_ID, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE10, {attr_list()}
                                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                                   WHERE  {BATCH}
                                                   AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR'))
                                            UNPIVOT INCLUDE NULLS (VALUE FOR COL_IDX IN ({unpivot_in()}))) V
                                          ,(SELECT COL_IDX, HDR
                                            FROM  (SELECT {attr_list()}
                                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                                   WHERE  {BATCH}
                                                   AND    UPLOAD_STATUS_CODE = 'V_TITLE'
                                                   AND    ROWNUM = 1)
                                            UNPIVOT (HDR FOR COL_IDX IN ({unpivot_in()}))) H
                                     WHERE  H.COL_IDX = V.COL_IDX
                                     AND    TRIM(H.HDR) IS NOT NULL) P
                              WHERE  P.MSG IS NOT NULL) Q
                       GROUP BY Q.UPLOAD_ID) X
                ON (A.UPLOAD_ID = X.UPLOAD_ID)
                WHEN MATCHED THEN UPDATE
                SET    A.UPLOAD_STATUS_CODE = 'ERROR'
                      ,A.MESSAGE_TEXT       = SUBSTR(CASE WHEN A.MESSAGE_TEXT IS NULL THEN X.MSGS ELSE A.MESSAGE_TEXT || ' / ' || X.MSGS END, 1, 4000);

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '140';
                    V_LOG_MESSAGE := '########## ERROR Period cells: Invalid Numeric / Invalid Decimal / Please Input QTY ##########';
                    V_DESCRIPTION := 'rows=' || TO_CHAR(v_err_cnt);
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정 (전 검증 계속 수행 — E20260911-DMF0014MULTI)
                END IF;
            END;

"""

QTY_START = "            --문자열 체크\n"
QTY_END_MARK = "########## ERROR This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';"


def fetch(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    head = re.sub(r'(?i)^\s*PACKAGE\s+BODY\s+"?\w+"?', f'CREATE OR REPLACE PACKAGE BODY SCM_MGR."{NAME}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def patch(main):
    """메인 프로시저 구간 문자열에 전 패치 적용 — 각 앵커는 정확히 1회 존재해야 한다."""
    n = 0
    assert main.count(DECL_OLD) == 1; main = main.replace(DECL_OLD, DECL_NEW); n += 1
    dup_anchor = ("            BEGIN\n                UPDATE SCM_ADM_EXCEL_UPLOAD\n"
                  "                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Duplication Key - ")
    assert main.count(dup_anchor) == 1; main = main.replace(dup_anchor, HDR_FETCH + dup_anchor); n += 1
    assert main.count(CMDL_IF) == 1; main = main.replace(CMDL_IF, CPRJ_BLOCK + CMDL_IF); n += 1
    for head, rule, pairs, alias, guards, note in FIXED:
        i = main.find(head); assert i > 0, head
        ls = main.rfind("\n", 0, i) + 1; le = main.find("\n", i)
        # 같은 줄(CASE 양쪽) 반복은 허용 — 다른 줄에 또 있으면 앵커 모호 → 중단
        assert main.find(head, le) < 0, ("앵커 2회 이상", head)
        line = main[ls:le]
        assert line.strip().startswith("SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN"), line[:80]
        indent = line[:len(line) - len(line.lstrip())]
        main = main[:ls] + indent + set_clause(msg(rule, *pairs, alias=alias), alias=alias) + main[le:]
        if guards:
            a = alias if alias else "SCM_ADM_EXCEL_UPLOAD."
            j = main.find(STATUS_LINE, ls); assert 0 < j < ls + 2000, (rule, j)
            gtxt = "".join(indent + "AND    " + g.format(a=a) + f"  /*[{TAG}] 가드: {note}*/\n" for g in guards)
            main = main[:j + len(STATUS_LINE)] + gtxt + main[j + len(STATUS_LINE):]
        n += 1
    s = main.find(QTY_START); assert s > 0 and main.find(QTY_START, s + 1) < 0
    e = main.find(QTY_END_MARK, s); assert e > s
    e = main.find("            END;\n", e); assert e > s; e += len("            END;\n")
    main = main[:s] + QTY_BLOCK + main[e:]; n += 1
    return main, n


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        i = src.index(SPLIT)
        patched, n = patch(src[:i])
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\nSET DEFINE OFF\n"
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched + src[i:]).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print(f"backup ok — patches applied: {n}, main proc lines {src[:i].count(chr(10))} -> {patched.count(chr(10))}")
    elif mode == "apply":
        assert ddl(fetch(cur)).rstrip() == body_of(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단"
        cur.execute(body_of(TOBE))
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        print("status", cur.fetchone())
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
        errs = cur.fetchall(); print("errors", len(errs))
        for e in errs[:20]: print("  ", e)
        print("applied == TOBE", ddl(fetch(cur)).rstrip() == body_of(TOBE))
        cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID'"); print("INVALID total", cur.fetchone()[0])
    elif mode == "restore":
        cur.execute(body_of(ASIS))
        cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP); print("restored", cur.fetchone())


if __name__ == "__main__":
    main()
