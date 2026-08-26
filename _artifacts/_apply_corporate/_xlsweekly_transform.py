# -*- coding: utf-8 -*-
"""[E20260820-XLSWEEKLY] DMF0082 Excel Form/Upload 기간 축 = 동적 주차(A안).
   입력: PKG_DMF0082_BODY_PRE_XLSWEEKLY_20260820.sql → 출력: PKG_DMF0082_BODY_XLSWEEKLY_20260820.sql"""
import re, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
body = open('PKG_DMF0082_BODY_PRE_XLSWEEKLY_20260820.sql', encoding='utf-8').read()
M = "[E20260820-XLSWEEKLY]"
MON = "TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')"
N = 26
cnt = {}

WEEK_UNIV = ("SELECT WK, ROW_NUMBER() OVER (ORDER BY WK) AS RN\n"
    "                 FROM (SELECT DISTINCT C.BASIS_START_DATE AS WK\n"
    "                         FROM SCM_MGR.SCM_SYS_CALENDAR_M C\n"
    "                        WHERE C.BASIS_YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, " + MON + ") AND p_to_yyyymmdd\n"
    "                          AND C.BASIS_START_DATE >= " + MON + ")")

# ===== A. FORM =====
old = "    n_key_cnt                   PLS_INTEGER := 0;"
assert body.count(old) == 1
body = body.replace(old, old + "\n    V_WEEK_LIST                 VARCHAR2(400 CHAR);   --" + M + " 주차 시작일 CSV (FE 동적 헤더 원천)")
cnt['A1'] = 1

pat = re.compile(r"[ ]+/\* \[E20260820-XLSFORM2\] 요구4[\s\S]*?\n      FROM WT_KEY K")
sel = "".join("         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W%02d) END AS W%02d\n" % (i, i) for i in range(1, N+1))
new = ("         /* " + M + " 기간 축 = 동적 주차 (A안 사용자 확정 2026-08-20) — 조회기간과 당주-이후의 교집합 주 시작일\n"
       "            (BASIS_START_DATE) 슬롯 W01~W26. 실제 주차 목록은 o_result_cursor.WEEK_LIST(CSV) 로 내려주고\n"
       "            FE 가 W 슬롯을 날짜 헤더(YYYYMMDD 원형 — BE FileServiceImpl 1단 날짜헤더 인식 규격)로 치환한다.\n"
       "            값 = 기존 LOC 원장 주차 대표값(XLSFORM2 승계 — 주차 단위 재배선). */\n"
       + sel.rstrip('\n') + "\n      FROM WT_KEY K")
body, n = pat.subn(new, body); assert n == 1, n
cnt['A2'] = 1

pat = re.compile(r"[ ]+/\* \[E20260820-XLSFORM2\] 기존 LOC 원장 월별 대표값[\s\S]*?AND LP\.CURRENCY     = K\.CURRENCY")
piv = "".join("               , MAX(CASE W.RN WHEN %d THEN B.PRICE END) AS W%02d\n" % (i, i) for i in range(1, N+1))
new = ("      /* " + M + " 기존 LOC 원장 주차별 대표값 (주 시작일 = 캘린더 BASIS_START_DATE, MAX 집계) */\n"
       "      LEFT OUTER JOIN (\n"
       "          SELECT B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.CURRENCY\n"
       + piv.rstrip('\n') + "\n"
       "          FROM  (SELECT P.PROJECT_CODE, P.SCM_SITE_ID, P.ITEM_ID, P.INCOTERMS, P.DOM_EXP, P.FCST_TYPE, P.CURRENCY\n"
       "                      , C.BASIS_START_DATE AS WK, MAX(P.PRICE) AS PRICE\n"
       "                 FROM   SCM_MGR.SCM_MST_FUTURE_PRICE P\n"
       "                 JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = P.YYYYMMDD\n"
       "                 WHERE  P.DIVISION_ID = p_division_id\n"
       "                 AND    P.MEASURE = 'LOC'\n"
       "                 AND    P.YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, " + MON + ") AND p_to_yyyymmdd\n"
       "                 GROUP BY P.PROJECT_CODE, P.SCM_SITE_ID, P.ITEM_ID, P.INCOTERMS, P.DOM_EXP, P.FCST_TYPE, P.CURRENCY\n"
       "                        , C.BASIS_START_DATE) B\n"
       "          JOIN  (" + WEEK_UNIV + ") W\n"
       "            ON  W.WK = B.WK AND W.RN <= 26\n"
       "          GROUP BY B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.CURRENCY\n"
       "      ) LP\n"
       "        ON  LP.PROJECT_CODE = K.END_CUSTOMER\n"
       "        AND LP.SCM_SITE_ID  = K.SCM_SITE_ID\n"
       "        AND LP.ITEM_ID      = K.ITEM_ID\n"
       "        AND LP.INCOTERMS    = K.INCOTERMS\n"
       "        AND LP.DOM_EXP      = K.DOM_EXP\n"
       "        AND LP.FCST_TYPE    = K.FCST_TYPE\n"
       "        AND LP.CURRENCY     = K.CURRENCY")
body, n = pat.subn(new, body); assert n == 1, n
cnt['A3'] = 1

old = "    OPEN o_rc1 FOR\n    WITH WT_KEY AS ("
assert body.count(old) == 1
body = body.replace(old,
    "    /* " + M + " 주차 목록 산출 — o_rc1 W 슬롯과 동일 산식 (FE 동적 헤더 = 이 목록) */\n"
    "    SELECT LISTAGG(WK, ',') WITHIN GROUP (ORDER BY WK)\n"
    "      INTO V_WEEK_LIST\n"
    "      FROM (" + WEEK_UNIV + ")\n"
    "     WHERE RN <= 26;\n\n" + old)
cnt['A4'] = 1

old = "        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(n_key_cnt) AS EVENT FROM DUAL;"
assert body.count(old) == 1
body = body.replace(old,
    "        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(n_key_cnt) AS EVENT\n"
    "             , V_WEEK_LIST AS WEEK_LIST   /* " + M + " */\n"
    "        FROM DUAL;")
old = "            SELECT '1' AS RESULT_CODE, 'MSG01014' AS RESULT_MSG, '0' AS EVENT FROM DUAL;"
assert body.count(old) == 1
body = body.replace(old,
    "            SELECT '1' AS RESULT_CODE, 'MSG01014' AS RESULT_MSG, '0' AS EVENT\n"
    "                 , CAST(NULL AS VARCHAR2(400)) AS WEEK_LIST FROM DUAL;")
cnt['A5'] = 2

# ===== B. UPLOAD =====
old = ("        /* #################################################### */\n"
       "        /* DIVISION  체크                                        */")
assert body.count(old) == 1
body = body.replace(old,
    "        /* " + M + " 1단 동적 주차 헤더 — 프레임워크 @TITLE 행(주 시작일 YYYYMMDD 헤더, BE 정규화 완료)을\n"
    "           V_TITLE 로 마킹 (DMF0014 정본 계보 동형). 데이터 행 검증('UPLOAD' 한정)과 자연 분리. */\n"
    "        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD\n"
    "        SET    UPLOAD_STATUS_CODE = 'V_TITLE'\n"
    "        WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by\n"
    "        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date\n"
    "        AND    UPLOAD_STATUS_CODE = '@TITLE';\n\n" + old)
cnt['B1'] = 1

lines = body.split('\n')
out = []; b2 = 0
pat23 = re.compile(r"^(\s*)\(ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION\(ATTRIBUTE23(.*?)\)(\s*)(--.*)?$")
for line in lines:
    m = pat23.match(line)
    if m:
        indent, core, cm = m.group(1), m.group(2), (m.group(4) or '')
        out.append(indent + "(ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23" + core + ") OR " + cm + " /* " + M + " 주차 슬롯 24~36 확장 */")
        for nn in range(24, 37):
            c2 = core.replace('ATTRIBUTE23', 'ATTRIBUTE%d' % nn)
            tail = ' OR' if nn < 36 else ''
            out.append(indent + "(ATTRIBUTE%d IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE%d%s)%s --W%d" % (nn, nn, c2, tail, nn - 10))
        b2 += 1
        continue
    out.append(line)
body = '\n'.join(out)
assert b2 == 3, b2
cnt['B2'] = b2

attr_list = ", ".join("ATTRIBUTE%d" % i for i in range(11, 37))
unpiv = ", ".join("ATTRIBUTE%d AS 'ATTRIBUTE%d'" % (i, i) for i in range(11, 37))
case_val = "CASE T.COLUMN_NAME " + " ".join("WHEN 'ATTRIBUTE%d' THEN U.ATTRIBUTE%d" % (i, i) for i in range(11, 37)) + " END"

old = "            SELECT COUNT(*) INTO v_chk_cnt"
assert body.count(old) == 1
guard = (
    "            /* " + M + " 과거 주 가드 — V_TITLE 주차(주 시작일) < 당주 월요일 슬롯에 값이 있는 행 = ERROR\n"
    "               (사용자 요구: 당주 이후만 등록 — Form 도 당주 이후만 생성하므로 정상 왕복에선 발생하지 않는 방어 가드) */\n"
    "            UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD U\n"
    "            SET    UPLOAD_STATUS_CODE = 'ERROR'\n"
    "                 , MESSAGE_TEXT       = MESSAGE_TEXT || ', Past Week Not Allowed'\n"
    "            WHERE  U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.CREATED_BY = p_created_by\n"
    "            AND    TO_CHAR(U.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date\n"
    "            AND    U.UPLOAD_STATUS_CODE = 'UPLOAD'\n"
    "            AND    EXISTS (\n"
    "                     SELECT 1\n"
    "                     FROM  (SELECT COLUMN_NAME, YYYYMMDD\n"
    "                            FROM  (SELECT " + attr_list + "\n"
    "                                   FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD\n"
    "                                   WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by\n"
    "                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date\n"
    "                                   AND    UPLOAD_STATUS_CODE = 'V_TITLE' AND ROWNUM = 1)\n"
    "                            UNPIVOT (YYYYMMDD FOR COLUMN_NAME IN (" + unpiv + "))) T\n"
    "                     WHERE REGEXP_LIKE(T.YYYYMMDD, '^[0-9]{8}$')\n"
    "                     AND   T.YYYYMMDD < " + MON + "\n"
    "                     AND   " + case_val + " IS NOT NULL);\n\n"
)
body = body.replace(old, guard + old)
cnt['B3'] = 1

def expansion(I):
    return (
I + "/* " + M + " 주차 값 -> 일 전개 (LOC 전용 — 검증이 LOC 만 SUCCESS 허용).\n" +
I + "   구 GET_EXCEL_UPLOAD_DATA(M4~M16 = 당월+4~+16 고정 산식) 호출 대체 — 주차는 V_TITLE(주 시작일 헤더) 실측 해석.\n" +
I + "   후속 VMI 특례 INSERT 는 UNPIVOT GTT 를 비워 자연 무효(LOC 한정 체제 — 원문 존치). */\n" +
I + "DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;\n" +
I + "DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;\n" +
I + "DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;\n" +
I + "INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY\n" +
I + "( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS\n" +
I + ", FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE\n" +
I + ", KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW\n" +
I + ", BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )\n" +
I + "SELECT U.ATTRIBUTE301, U.ATTRIBUTE302, U.ATTRIBUTE303, U.ATTRIBUTE304, U.ATTRIBUTE305\n" +
I + "     , U.ATTRIBUTE306, U.ATTRIBUTE307, U.ATTRIBUTE308, U.ATTRIBUTE309, U.ATTRIBUTE310\n" +
I + "     , NULL, SUBSTR(CM.BASIS_YYYYMMDD, 1, 6), CM.BASIS_YYYYMMDD, CM.ISO_YYYYWW\n" +
I + "     , NULL, NULL\n" +
I + "     , CAST(TO_NUMBER(" + case_val + ") AS NUMBER(23,2)), NULL\n" +
I + "     , CAST(TO_NUMBER(" + case_val + ") AS NUMBER(23,2))\n" +
I + "FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD U\n" +
I + "CROSS JOIN (SELECT COLUMN_NAME, YYYYMMDD\n" +
I + "            FROM  (SELECT " + attr_list + "\n" +
I + "                   FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD\n" +
I + "                   WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by\n" +
I + "                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date\n" +
I + "                   AND    UPLOAD_STATUS_CODE = 'V_TITLE' AND ROWNUM = 1)\n" +
I + "            UNPIVOT (YYYYMMDD FOR COLUMN_NAME IN (" + unpiv + "))) T\n" +
I + "JOIN   SCM_MGR.SCM_SYS_CALENDAR_M CM ON CM.BASIS_START_DATE = T.YYYYMMDD\n" +
I + "WHERE  U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.CREATED_BY = p_created_by\n" +
I + "AND    TO_CHAR(U.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date\n" +
I + "AND    U.UPLOAD_STATUS_CODE = 'SUCCESS'\n" +
I + "AND    REGEXP_LIKE(T.YYYYMMDD, '^[0-9]{8}$')\n" +
I + "AND    " + case_val + " IS NOT NULL;")

for I in ("                ", "        "):
    old = (I + "SCM_MGR.PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA(p_created_by, v_rc_a, v_rc_b, v_rc_c);\n" +
           I + "BEGIN IF v_rc_a IS NOT NULL THEN CLOSE v_rc_a; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;\n" +
           I + "BEGIN IF v_rc_b IS NOT NULL THEN CLOSE v_rc_b; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;\n" +
           I + "BEGIN IF v_rc_c IS NOT NULL THEN CLOSE v_rc_c; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;")
    assert body.count(old) == 1, (len(I), body.count(old))
    body = body.replace(old, expansion(I))
cnt['B4'] = 2

open('PKG_DMF0082_BODY_XLSWEEKLY_20260820.sql', 'w', encoding='utf-8', newline='').write(body)
print(cnt)
print('markers:', dict((k, body.count(k)) for k in
      ('E20260820-XLSWEEKLY', 'E20260820-XLSFORM2', 'E20260820-MEASRULE', 'E20260819-LIMITMEAS',
       'E20260819-XLS81LOC', 'E20260819-MULTIJOIN', 'E20260819-SENDERJOIN', 'E20260819-PJTNAME')))
