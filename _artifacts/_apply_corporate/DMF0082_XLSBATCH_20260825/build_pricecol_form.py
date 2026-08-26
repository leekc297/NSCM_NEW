# -*- coding: utf-8 -*-
"""[E20260825-XLSPRICECOL] 폼 SP — 단가 테이블 컬럼 구성 전면 재작성 edits 생성"""
import io, json, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

i0 = src.find("PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA")
i1 = src.find("PROCEDURE P_DMF0082", i0 + 50)

# ---- edit1: n_key_cnt 블록 ----
a = src.find("    /* [E20260825-XLSMASTER] Excel Form", i0)
tail1 = "                              AND B.VALID_YN = 'Y'));"
b = src.find(tail1, i0)
assert i0 < a < b < i1, "anchor1"
old1 = src[a:b + len(tail1)]
assert src.count(old1) == 1, "old1 unique"

new1 = """    /* [E20260825-XLSPRICECOL] Excel Form 컬럼 = 단가 테이블(SCM_MST_FUTURE_PRICE) 컬럼 구성 (사용자 지시 2026-08-25).
       행 축 = 원장 키 그대로 (PLANT_SITE_ID 포함 — 구 접힘 폐지, 'Plant Site 축 미결' 해소).
       추출 기준 = 일괄입력 팝업 B2 동일(XLSBATCH 승계): 동적 구간 BETWEEN + SITE(SALES)/SITE_ITEM/ITEM_V 게이트.
       END_CUSTOMER 는 단가 테이블에 없는 컬럼 — 양식에서 제거 (업로드 토큰도 Project Code 로 교체, HEADER_CONTENT 동시 배포). */
    SELECT COUNT(*)
      INTO n_key_cnt
      FROM (SELECT DISTINCT F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                          , F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
              FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
             WHERE F.DIVISION_ID = p_division_id AND F.MEASURE = 'LOC'
               AND F.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
               AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                            WHERE B.DIVISION_ID = F.DIVISION_ID AND B.SCM_SITE_ID = F.SCM_SITE_ID
                              AND B.SITE_TYPE = 'SALES' AND B.VALID_YN = 'Y')
               AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM B
                            WHERE B.DIVISION_ID = F.DIVISION_ID AND B.PROJECT_CODE = F.PROJECT_CODE
                              AND B.SCM_SITE_ID = F.SCM_SITE_ID AND B.ITEM_ID = F.ITEM_ID
                              AND B.VALID_YN = 'Y'));"""

# ---- edit2: 커서 전체 교체 ----
c = src.find("    OPEN o_rc1 FOR\n    WITH WT_RAW AS (", i0)
tail2 = "            , K.INCOTERMS, K.DOM_EXP, K.CELL_PROD_SITE_ID, MSR.MEASURE_SORT;"
e = src.find(tail2, i0)
assert i0 < c < e < i1, "anchor2"
old2 = src[c:e + len(tail2)]
assert src.count(old2) == 1, "old2 unique"

W_OUT = "\n".join("         , TO_CHAR(LP.W%02d) AS W%02d" % (n, n) for n in range(1, 27))
W_AGG = "\n".join("               , MAX(CASE W.RN WHEN %d THEN B.PRICE END) AS W%02d" % (n, n) for n in range(1, 27))

new2 = """    OPEN o_rc1 FOR
    WITH WT_RAW AS (
        /* [E20260825-XLSPRICECOL] 1단 — 원장을 원장 키 그대로(PLANT 포함) 접는다. 주차 값은 LP 에서. */
        SELECT /*+ MATERIALIZE */
               F.DIVISION_ID
             , F.PROJECT_CODE
             , F.SCM_SITE_ID
             , F.PLANT_SITE_ID
             , F.ITEM_ID
             , F.INCOTERMS
             , F.FCST_TYPE
             , F.DOM_EXP
             , F.CURRENCY
          FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
         WHERE F.DIVISION_ID = p_division_id
           AND F.MEASURE     = 'LOC'
           AND F.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd   --[E20260825-XLSBATCH] 동적 구간
           /* [E20260825-XLSMASTER perf3] 선택 필터는 최종 WHERE(키 단계)에서 — 바인드 OR 관용구 플랜 파괴 방지 */
         GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID
                , F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
    )
    , WT_ITEM AS (
        /* [E20260825-XLSBATCH2] ITEM_V 선실현 — PUSHED PREDICATE 행별 폭발 방지 (게이트 전용) */
        SELECT /*+ MATERIALIZE */ IV0.DIVISION_ID, IV0.ITEM_ID
          FROM SCM_MGR.DM_MST_ITEM_SINGLE_V IV0
         WHERE IV0.DIVISION_ID = p_division_id
    )
    , WT_KEY AS (
        /* [E20260825-XLSPRICECOL] 2단 — 게이트(일괄입력 동일: SITE SALES/SITE_ITEM/ITEM_V) + 프로젝트 명/오너 보강.
           출력 = 단가 테이블 컬럼 축 + PROJECT_NAME/OWNER(정보성). SITE_END_CUSTOMER 는 조회조건 EC 필터 전용
           (일괄입력 최종 취합의 81 EC 필터 = C.END_CUSTOMER 동일 축 — 화면 표시는 안 한다). */
        SELECT /*+ MATERIALIZE */
               R.DIVISION_ID
             , R.PROJECT_CODE
             , R.SCM_SITE_ID
             , R.PLANT_SITE_ID
             , R.ITEM_ID
             , R.INCOTERMS
             , R.FCST_TYPE
             , R.DOM_EXP
             , R.CURRENCY
             , PJ.PROJECT_NAME
             , PJ.PROJECT_OWNER
             , MS0.END_CUSTOMER                      AS SITE_END_CUSTOMER
          FROM WT_RAW R
         INNER JOIN SCM_MGR.SCM_MST_SITE MS0
            ON  MS0.DIVISION_ID = R.DIVISION_ID
            AND MS0.SCM_SITE_ID = R.SCM_SITE_ID
            AND MS0.SITE_TYPE   = 'SALES'
            AND MS0.VALID_YN    = 'Y'
         INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
            ON  SI.DIVISION_ID  = R.DIVISION_ID
            AND SI.PROJECT_CODE = R.PROJECT_CODE
            AND SI.SCM_SITE_ID  = R.SCM_SITE_ID
            AND SI.ITEM_ID      = R.ITEM_ID
            AND SI.VALID_YN     = 'Y'
         INNER JOIN WT_ITEM IV
            ON  IV.DIVISION_ID = R.DIVISION_ID
            AND IV.ITEM_ID     = R.ITEM_ID
          LEFT JOIN SCM_MGR.SCM_MST_PROJECT PJ  --[E20260825-XLSPRJ] (DIV,CODE) 유일 실측 — 행 불증식
            ON  PJ.DIVISION_ID  = R.DIVISION_ID
            AND PJ.PROJECT_CODE = R.PROJECT_CODE
    )
    -- 입력 가능 measure (화면 개인화 무관 — INSERT_YN='Y')
    , WT_MEASURE AS (
        SELECT L.SEGMENT2  AS DIVISION_ID
             , L.SEGMENT3  AS MEASURE_CODE
             , L.SEGMENT4  AS MEASURE_NAME
             , L.ATTRIBUTE3 AS VMI_COND
             , ROW_NUMBER() OVER (PARTITION BY L.SEGMENT2 ORDER BY L.SEGMENT3) AS MEASURE_SORT
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
         INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER M
            ON  M.LOOKUP_TYPE = L.LOOKUP_TYPE
            AND M.VALID_YN    = 'Y'
         WHERE L.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
           AND L.SEGMENT1    = 'DMF0082'
           AND L.SEGMENT2    = p_division_id
           AND L.VALID_YN    = 'Y'
           AND L.ATTRIBUTE1  = 'Y'          -- INSERT_YN (검증 SP 동일)
           AND L.SEGMENT3    = 'LOC'        /* [E20260819-XLS81LOC] 대상 measure LOC 한정 */
    )
    -- FCST Type 코드 -> 명칭 (검증 SP 역방향 — 업로드가 명칭 기대)
    , WT_FCST AS (
        SELECT SEGMENT1 AS FCST_CODE, MAX(SEGMENT2) AS FCST_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND VALID_YN = 'Y'
           AND NVL(ATTRIBUTE2, '-') <> 'Y'
         GROUP BY SEGMENT1
    )
    SELECT /*+ LEADING(K MSR) USE_HASH(LP) NO_MERGE(LP) */  --[E20260825-XLSMASTER perf4] 바인드 플랜 고정
           K.DIVISION_ID
         , K.PROJECT_CODE
         , K.SCM_SITE_ID
         , K.PLANT_SITE_ID
         , K.ITEM_ID
         , K.CURRENCY
         , MSR.MEASURE_NAME                      AS MEASURE
         , K.DOM_EXP
         , NVL(FT.FCST_NAME, K.FCST_TYPE)       AS FCST_TYPE
         , K.INCOTERMS
         , K.PROJECT_NAME
         , K.PROJECT_OWNER
         /* 업로드 불가 예고 — 검증 SP 역변환 실패 축 (FCST 명칭 미해소 / INCOTERMS lookup 부재) */
         , RTRIM(
             CASE WHEN FT.FCST_NAME IS NULL THEN 'FCST_TYPE,' ELSE '' END ||
             CASE WHEN NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LI
                                    WHERE LI.LOOKUP_TYPE = 'INCOTERMS' AND LI.VALID_YN = 'Y'
                                      AND LI.SEGMENT2 = K.INCOTERMS)
                  THEN 'INCOTERMS,' ELSE '' END
           , ',') AS FORM_WARN
         /* [E20260820-XLSWEEKLY] 동적 주차 W 슬롯 — 값 = 해당 원장 행(키 완전 일치·PLANT 포함)의 주차 대표값 */
""" + W_OUT + """
      FROM WT_KEY K
     INNER JOIN WT_MEASURE MSR
        ON MSR.DIVISION_ID = K.DIVISION_ID
      LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE MS
        ON  MS.DIVISION_ID = K.DIVISION_ID
        AND MS.SCM_SITE_ID = K.SCM_SITE_ID
      LEFT OUTER JOIN WT_FCST FT
        ON  FT.FCST_CODE   = K.FCST_TYPE
      /* 기존 LOC 원장 주차별 대표값 — 키 완전 일치(PLANT 포함) 프리필 */
      LEFT OUTER JOIN (
          SELECT B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.CURRENCY
""" + W_AGG + """
          FROM  (SELECT P.PROJECT_CODE, P.SCM_SITE_ID, P.PLANT_SITE_ID, P.ITEM_ID, P.INCOTERMS, P.DOM_EXP, P.FCST_TYPE, P.CURRENCY
                      , C.BASIS_START_DATE AS WK, MAX(P.PRICE) AS PRICE
                 FROM   SCM_MGR.SCM_MST_FUTURE_PRICE P
                 JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = P.YYYYMMDD
                 WHERE  P.DIVISION_ID = p_division_id
                 AND    P.MEASURE = 'LOC'
                 AND    P.YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')) AND p_to_yyyymmdd
                 GROUP BY P.PROJECT_CODE, P.SCM_SITE_ID, P.PLANT_SITE_ID, P.ITEM_ID, P.INCOTERMS, P.DOM_EXP, P.FCST_TYPE, P.CURRENCY
                        , C.BASIS_START_DATE) B
          JOIN  (SELECT WK, ROW_NUMBER() OVER (ORDER BY WK) AS RN
                 FROM (SELECT DISTINCT C.BASIS_START_DATE AS WK
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M C
                        WHERE C.BASIS_YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')) AND p_to_yyyymmdd
                          AND C.BASIS_START_DATE >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'))) W
            ON  W.WK = B.WK AND W.RN <= 26
          GROUP BY B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.CURRENCY
      ) LP
        ON  LP.PROJECT_CODE  = K.PROJECT_CODE
        AND LP.SCM_SITE_ID   = K.SCM_SITE_ID
        AND LP.PLANT_SITE_ID = K.PLANT_SITE_ID
        AND LP.ITEM_ID       = K.ITEM_ID
        AND LP.INCOTERMS     = K.INCOTERMS
        AND LP.DOM_EXP       = K.DOM_EXP
        AND LP.FCST_TYPE     = K.FCST_TYPE
        AND LP.CURRENCY      = K.CURRENCY
     -- VMI 조건 = 검증 SP 동일 술어
     WHERE ( ( NVL(MS.VMI_YN, 'N') = 'N' AND MSR.VMI_COND <> 'Y' )
             OR NVL(MS.VMI_YN, 'N') = 'Y' )
       --[E20260825-XLSMASTER perf3] 선택 필터 (키 단계 — 바인드여도 무해).
       -- EC 필터 축 = 사이트 파생 고객명 (일괄입력 최종 취합의 81 EC 필터 = C.END_CUSTOMER 동일)
       AND (NVL(p_sales_site,   'ALL') = 'ALL' OR INSTR(',' || p_sales_site   || ',', ',' || K.SCM_SITE_ID  || ',') > 0)
       AND (NVL(p_item_id,      'ALL') = 'ALL' OR INSTR(',' || p_item_id      || ',', ',' || K.ITEM_ID      || ',') > 0)
       AND (NVL(p_end_customer, 'ALL') = 'ALL' OR INSTR(',' || p_end_customer || ',', ',' || K.SITE_END_CUSTOMER || ',') > 0)
       AND (NVL(p_plant_site_id,'ALL') = 'ALL' OR INSTR(',' || p_plant_site_id|| ',', ',' || K.PLANT_SITE_ID || ',') > 0)
       AND (NVL(p_project_code, 'ALL') = 'ALL' OR INSTR(',' || p_project_code || ',', ',' || K.PROJECT_CODE || ',') > 0)
     ORDER BY K.PROJECT_CODE, K.SCM_SITE_ID, K.PLANT_SITE_ID, K.ITEM_ID, K.FCST_TYPE
            , K.INCOTERMS, K.DOM_EXP, K.CURRENCY, MSR.MEASURE_SORT;"""

edits = [{"old": old1, "new": new1}, {"old": old2, "new": new2}]
out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_pricecol_form.json")
out.write_text(json.dumps(edits, ensure_ascii=False, indent=1), encoding="utf-8")
print("edits 생성: old1=%d old2=%d" % (len(old1), len(old2)))
