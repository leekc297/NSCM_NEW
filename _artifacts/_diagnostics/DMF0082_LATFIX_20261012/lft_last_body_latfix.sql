CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0082_LFT IS
PROCEDURE P_DMF0082_GET_MAIN_DATA
(
    p_division_id    IN  VARCHAR2
  , p_team_id        IN  VARCHAR2
  , p_customer       IN  VARCHAR2
  , p_biz_type       IN  VARCHAR2
  , p_from_yyyymmdd  IN  VARCHAR2
  , p_to_yyyymmdd    IN  VARCHAR2
  , p_scm_site_id    IN  VARCHAR2
  , p_item_id        IN  VARCHAR2
  , p_version_type   IN  VARCHAR2
  , p_qty_yn         IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , p_plant_site_id  IN  VARCHAR2 DEFAULT 'ALL'  /* [PLANT_SITE 2026-08-04] 조회조건 Plant Site (81 전용 — FE 40/82 비활성 'ALL') */
  , p_project_code   IN  VARCHAR2 DEFAULT 'ALL'  /* [UICATEGORY 2026-08-07] 조회조건 Project (다중 콤마 토큰) */
  , p_owner          IN  VARCHAR2 DEFAULT 'ALL'  /* [UICATEGORY 2026-08-07] 조회조건 Owner (다중 콤마 토큰) */
  , p_sender_code    IN  VARCHAR2 DEFAULT 'ALL'  /* [UICATEGORY 2026-08-07 → E20260819-SENDERJOIN] 조회조건 Sender Code — 2026-08-19 사용자 재확정: 실적용(무값 행 제외) */
  , O_RC1            OUT SYS_REFCURSOR
  , O_RC2            OUT SYS_REFCURSOR
  , O_RC3            OUT SYS_REFCURSOR
  , O_RC4            OUT SYS_REFCURSOR
  , O_RC5            OUT SYS_REFCURSOR
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID  : P_DMF0082_GET_MAIN_DATA
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date             In Charge    Description
 *=====================================================================================================================================================
 * 2025.01.23       dsiol        Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2025.04.15       dsiol        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025.04.24       dsiol        [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_NAME 제거 CELL_PROD_SITE_ID 단독 사용
 * 2025.05.20       dsiol        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정
 * 2025.06.02       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 조회 시, 실적수량 Measure는 #TempSelectMeasure 의 RESULT_MEASURE 컬럼으로 매핑
 * 2025.06.09       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가
 * 2025.06.09       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가
 * 2025.06.09       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P])
 * 2025.06.27       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
 * 2025.07.07       KANG.H.J     [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.10       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
 * 2025.07.23       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
 * 2025.07.24       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 계획구간 LOC 데이터 SP버전-> MF, SF버전으로 변경
 * 2025.07.30       jssbae       [E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선
 * 2026.01.30       jssbae       [E20260130-001907]_FCST&PRICE MGMT Cutoff 버전 조회 대상 테이블 변경
 * 2026.09.30       admin        [E20260930-DMF0082QRYPERF] 조회 속도개선: FUTURE_PRICE IDX02 지정(82 풀스캔 제거) / SP 내 GTT 통계수집 13건 제거 /
 *                               82 후행 UPDATE 2건 INSERT 흡수 / 중복제거 안전망 조건부 실행 (결과 전행 동일 검증)
 * 2026.09.30       admin        [E20260930-DMF0082CLOUDPERF] 클라우드 병목 2문장 계획 고정 힌트 (CUST 종속 실적 arm L1943 · div40 LAST_DATA_FCST L1229)
 * 2026.10.02       admin        [E20261002-DMF0082-81MKTAMT] 81 계획구간 MKT FCST 금액(MKT_AMT_KRW/LOC) 표시 — 원천 DM_PLN_SALES_PLAN(_C)
 *                               (81 수요 원장 QTY NUMBER(20,10) 자릿수 한도로 금액 저장 불가 → Sales Plan 동기화 산출값 조회 · Current/MF/SF)
 *=====================================================================================================================================================*/
/****** 개체:  StoredProcedure [dbo].[P_DMF0082_GET_MAIN_DATA]    스크립트 날짜: 2026-04-22 오전 10:57:37 ******/
IS
    -- ===== 사용자 컬럼 및 메저 세팅 관련 변수 =====
    V_USER_COL_CNT      NUMBER := 0;
    V_USER_MEA_CNT      NUMBER := 0;
    VA_PROGRAM_ID       VARCHAR2(50 CHAR);
    VA_SHEET_NAME       VARCHAR2(50 CHAR);

    -- ===== BUCKET 관련 변수 =====
    V_EXP_YYYYMMDD      VARCHAR2(8 CHAR);
    V_PV_LIST           CLOB;
    V_PV_COL_LIST       CLOB;
    V_QTY_SUM           CLOB;
    V_PV_COLUMN_NAME    VARCHAR2(100 CHAR);
    V_PV_NAME           VARCHAR2(200 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(50 CHAR);

    -- ===== 날짜 범위 변수 =====
    V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_TO_RESULT         VARCHAR2(8 CHAR);
    V_FROM_RESULT       VARCHAR2(8 CHAR);  -- [DATE ROOT FIX 2026-07-12] AS-IS @V_FROM_RESULT 복원

    -- ===== C_TITLE 커서 변수 =====
    V_CUR_COLUMN_NAME   VARCHAR2(100 CHAR);
    V_CUR_PROGRAM_ID    VARCHAR2(10 CHAR);
    V_CUR_SHEET_NAME    VARCHAR2(100 CHAR);
    V_CUR_SORT_ORDER_NO VARCHAR2(50 CHAR);
    V_COLUMN            VARCHAR2(4000 CHAR);
    V_GROUPBY           VARCHAR2(4000 CHAR);
    V_ORDERBY           VARCHAR2(4000 CHAR);

    -- ===== 권한 그룹 변수 =====
    V_GROUP_ID          VARCHAR2(50 CHAR);
    V_LIMIT_CNT         NUMBER := 0;
    V_QPT_DUP_CNT       NUMBER := 0;  --[E20260930-DMF0082QRYPERF-DEDUPCHK] 전용 (타 변수 재사용 금지)            --[E20260819-LIMITMEAS] donor(CURRENT) 이식 변수

    -- ===== 동적 SQL 변수 =====
    V_SQL               CLOB;

    -- ===== 로그 변수 =====
    V_LOG_TYPE          VARCHAR2(10 CHAR) := 'I';
    N_LOG_COUNT         NUMBER(10)        := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE              := SYSDATE;
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);

    -- ===== C_BUCKET 커서 =====
    -- Oracle PIVOT IN 구문: 'literal_value' AS alias_name 형식 필수
    -- COLUMN_NAME = 외부 SELECT 의 PIVOT 결과 컬럼 alias 참조 (brackets 없음)
    -- PV_NAME     = PIVOT IN 절의 'value' AS alias (literal 필수)
    CURSOR C_BUCKET IS
        SELECT 'D_' || A.BASIS_YYYYMMDD                                                               AS COLUMN_NAME
              , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD                          AS PV_NAME
              , A.BASIS_YYYYMMDD || '_31'                                                             AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0')                                       AS COLUMN_NAME
              , '''W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0') || ''' AS W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0')  AS PV_NAME
              , A.BASIS_START_DATE || '_21'                                                           AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM                                                                 AS COLUMN_NAME
              , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM                              AS PV_NAME
              , MIN(A.BASIS_START_DATE) || '_01'                                                      AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY SORT_ORDER_NO;

    -- ===== C_TITLE 커서 =====
    CURSOR C_TITLE IS
        SELECT * FROM ( --[SORTFIX 2026-08-04] 인라인뷰 (UNION ORDER BY 식 제약 ORA-01785 회피)
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                    WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                    ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
             , SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = VA_PROGRAM_ID
        AND    U.SHEET_NAME  = VA_SHEET_NAME
        AND    U.USER_ID     = p_created_by
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        -- [UICATEGORY 2026-08-07] MF_SP 산출 whitelist — titleset 'C' 오염(미산출 컬럼) 유입 시 동적 SQL ORA-00904 차단
        --   (DMF0003 TITLESET IMMUNIZE 파리티. 목록 = GT_DMF0082_MF_SP 전 컬럼 ∪ SRC0 파생 alias — GT ALTER 시 동기 의무)
        AND    U.COLUMN_NAME IN (
                 'DIVISION_ID','PROJECT_CODE','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','DOM_EXP','FCST_TYPE','INCOTERMS'
                ,'MEASURE','PLANT_SITE_ID','CELL_PROD_SITE_ID','BUCKET_TYPE','BUCKET_KEY','QTY','MEASURE_GROUP'
                ,'CELL_MODEL','NICK_NAME','DMS_SALES','DMS_CUSTOMER','OWNER','DEPT_ID','DEPT_NAME_KO'
                ,'FORECAST_INFO_CELL_PACK_COUNT','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','BIZ_TYPE'
                ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','PROJECT_STATUS','ITEM_NAME','VMI_YN'
                ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_ALL','FORECAST_INFO_SPEC'
                ,'FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME','CELL_PER_CAR','CELL_PER_MODULE'
                ,'MODULE_PER_CAR','SORT_ORDER_NO','ENERGE','CELL_QUANTITY','AS_FROM_SITE'
                ,'CREATE_DATE','LAST_UPDATED_BY','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT'
                ,'CURRENCY','VERSION_NO','CUTOFF_YYYYMMDD','NOTATION','EDIT_FLAG','SORT_KEY','GROUP_ID'
                ,'SUN','MON','TUE','WED','THU','FRI','SAT','YYYYMM','YYYYMMWW','WEEK_END_YN','MONTH_END_YN'
                ,'AS_YN','ATTR1','VMI_STD_DIO','NEW_FLAG'
                ,'TEAM_ID','TEAM_NAME_KO','FORECAST_INFO_CELL_MODEL','LAST_UPDATE_DATE','BUCKET' )
        UNION ALL
        /* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID(Item은 Group 기준으로 정렬) 추가) */
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , TO_CHAR(CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO,85) - 0.5 ELSE C.SORT_ORDER_NO END) AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
            ON  U.PROGRAM_ID  = C.PROGRAM_ID
            AND U.SHEET_NAME  = C.SHEET_NAME
            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND U.COLUMN_NAME IN ('ITEM_ID')
            AND U.USER_ID = p_created_by
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        -- [E20260907-DEFFLAG] AS-IS: AND    C.DEFAULT_FLAG = ' ' -- [FIX 2026-07-12] AS-IS "DEFAULT_FLAG = ''"(비 default 컬럼만) 오변환('Y') → branch1 사용자 titleset 과 전 컬럼 중복 = ORA-00960
--        AND    NVL(TRIM(C.DEFAULT_FLAG), '-') = '-'  -- [E20260907-DEFFLAG] 구 "= ' '" → **센티널 정규화**. AS-IS 원문은 DEFAULT_FLAG='' (=빈 값) 이고 ' '(클라우드) 와 '-'(ZIOUI1) 는 같은 센티널의 표기 변형이다(hook #119). 'N' 은 별개 실값이라 제외 — 이렇게 해야 양 DB 가 동일 컬럼셋(실측 10건)을 낸다. 구 조건은 ZIOUI1 에서 항상 0행이라 SORT_KEY 누락 → ORDER BY SORT_KEY 가 ORA-00904    --  2026.10.11 AJS
        AND    NVL(TRIM(C.DEFAULT_FLAG), '/') = '/'  -- [E20260907-DEFFLAG] 구 "= ' '" → **센티널 정규화**. AS-IS 원문은 DEFAULT_FLAG='' (=빈 값) 이고 ' '(클라우드) 와 '-'(ZIOUI1) 는 같은 센티널의 표기 변형이다(hook #119). 'N' 은 별개 실값이라 제외 — 이렇게 해야 양 DB 가 동일 컬럼셋(실측 10건)을 낸다. 구 조건은 ZIOUI1 에서 항상 0행이라 SORT_KEY 누락 → ORDER BY SORT_KEY 가 ORA-00904    --  2026.10.11 AJS
        -- [E20260907-DEFFLAG] branch2 에도 branch1 과 **동일한** MF_SP 산출 whitelist 적용. 판정 완화로 비산출 컬럼(실측 DEPT_NAME)이 유입돼 ORA-00904 → branch1 비대칭 해소
        AND    C.COLUMN_NAME IN (
                 'DIVISION_ID','PROJECT_CODE','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','DOM_EXP','FCST_TYPE','INCOTERMS'
                ,'MEASURE','PLANT_SITE_ID','CELL_PROD_SITE_ID','BUCKET_TYPE','BUCKET_KEY','QTY','MEASURE_GROUP'
                ,'CELL_MODEL','NICK_NAME','DMS_SALES','DMS_CUSTOMER','OWNER','DEPT_ID','DEPT_NAME_KO'
                ,'FORECAST_INFO_CELL_PACK_COUNT','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','BIZ_TYPE'
                ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','PROJECT_STATUS','ITEM_NAME','VMI_YN'
                ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_ALL','FORECAST_INFO_SPEC'
                ,'FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME','CELL_PER_CAR','CELL_PER_MODULE'
                ,'MODULE_PER_CAR','SORT_ORDER_NO','ENERGE','CELL_QUANTITY','AS_FROM_SITE'
                ,'CREATE_DATE','LAST_UPDATED_BY','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT'
                ,'CURRENCY','VERSION_NO','CUTOFF_YYYYMMDD','NOTATION','EDIT_FLAG','SORT_KEY','GROUP_ID'
                ,'SUN','MON','TUE','WED','THU','FRI','SAT','YYYYMM','YYYYMMWW','WEEK_END_YN','MONTH_END_YN'
                ,'AS_YN','ATTR1','VMI_STD_DIO','NEW_FLAG'
                ,'TEAM_ID','TEAM_NAME_KO','FORECAST_INFO_CELL_MODEL','LAST_UPDATE_DATE','BUCKET' )
        AND    C.VALID_YN     = 'Y'
        -- [FIX 2026-07-13] branch2(비default 시트컬럼)에서 branch1(사용자 titleset 'C')과 중복 컬럼 제외.
        --   MEASURE 가 titleset 'C'(grid 표시용, 20260712 추가) + SHEET_COLUMNS 비default 양쪽 → V_COLUMN 중복 → PIVOT OPEN 시 ORA-00918 'MEASURE 모호'.
        AND    NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER U2
                   WHERE  U2.PROGRAM_ID  = C.PROGRAM_ID
                   AND    U2.SHEET_NAME  = C.SHEET_NAME
                   AND    U2.COLUMN_NAME = C.COLUMN_NAME
                   AND    U2.USER_ID     = p_created_by
                   AND    U2.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               )
        ) ORDER BY TO_NUMBER(SORT_ORDER_NO); --[SORTFIX 2026-08-04] UI Category Setup 순번 수치정렬 (TO_CHAR 문자정렬 결함 교정 — DMF0003 TO_NUMBER 원형 파리티)

    -- [2026-07-31 PARTITION PRUNING] SCM_MST_FUTURE_PRICE_C 는 CUTOFF_YYYYMMDD_DATE
    --   (가상컬럼 TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD')) 로 파티션되어 있다(클라우드).
    --   조회 SQL 에 CUTOFF 조건이 없어 PARTITION RANGE ALL 로 전 파티션을 스캔했다.
    --   선택된 버전의 CUTOFF 범위를 미리 구해 프루닝 조건으로 사용한다.
    V_CUTOFF_FROM       VARCHAR2(8 CHAR);
    V_CUTOFF_TO         VARCHAR2(8 CHAR);

BEGIN

    -- [E20260907-PERF2] GTT undo -> temp (redo 제거). 실측 redo 93.8MB -> 6.6MB / 12.3s -> 10.9s.
    --   이 SP 는 GT_DMF0082_TEMP_FCST_N_PRICE 에 12만행 규모를 적재/삭제하며, 최대 병목의 대기가
    --   `log buffer space` 였다. 결과·로직 불변 — 순수 I/O 비용 절감.
    --   ⚠ 트랜잭션 중 임시테이블을 이미 썼으면 변경 불가 → 그 경우 조용히 건너뛴다(최적화 힌트).
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET TEMP_UNDO_ENABLED = TRUE';
    EXCEPTION WHEN OTHERS THEN NULL;  -- 설정 실패는 성능만 영향, 결과 무영향
    END;

    /* ⭐ [E20260815-SPLIT2GTT] hook #129 §3.0 (2순위) — 테이블 함수 → GTT 선적재.

       `TABLE(UF_FX_String_SplitForIN(p_x,','))` 는 카디널리티 추정이 고정값으로 굳고,

       같은 파라미터를 여러 곳에서 쓰면 그때마다 PIPELINED 함수가 다시 돈다(패키지 내 19곳 실측).

       파라미터당 **1회만** 쪼개 GTT 에 넣고, 호출부는 GTT 를 읽는다.

       ⚠ 이 블록은 **어떤 IF 안에도 두지 않는다** — 조건 블록에 들어가면 일반 조회에서

         통째로 건너뛰어 토큰이 비고 조회가 전멸한다(2026-08-15 센티널 패치 실패 계보). */

    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_project_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_project_code, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_owner', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_owner, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_sender_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_sender_code, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_team_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_team_id, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','));
    /* [E20260819-MULTIJOIN] 인라인 REGEXP 분해 전환분 선적재 — p_customer/p_biz_type/p_item_id/p_version_type (2026-08-19 사용자 확장 지시) */
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_customer, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_biz_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biz_type, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_item_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_item_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_version_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));

    --[2026-07-31 클라우드 대응] GTT 동적샘플링 강제 — 클라우드 세션 기본값 0(GTT 무통계 파국계획, 사내 12초/클라우드 16분+ 실증) 방지.
    --  Oracle 기본값 2 복원. 트랜잭션 무관 세션 파라미터(ENABLE PARALLEL DML 계열 아님 — ORA-12841 리스크 없음).
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    V_PROC_INPUT := JSON_OBJECT('rows' VALUE REGEXP_COUNT(p_division_id, '\^') + 1,
        'p_division_id'   VALUE SUBSTR(p_division_id, 1, 50),
        'p_team_id'       VALUE SUBSTR(p_team_id, 1, 50),
        'p_customer'      VALUE SUBSTR(p_customer, 1, 50),
        'p_biz_type'      VALUE SUBSTR(p_biz_type, 1, 50),
        'p_from_yyyymmdd' VALUE SUBSTR(p_from_yyyymmdd, 1, 50),
        'p_to_yyyymmdd'   VALUE SUBSTR(p_to_yyyymmdd, 1, 50),
        'p_scm_site_id'   VALUE SUBSTR(p_scm_site_id, 1, 50),
        'p_item_id'       VALUE SUBSTR(p_item_id, 1, 50),
        'p_version_type'  VALUE SUBSTR(p_version_type, 1, 50),
        'p_qty_yn'        VALUE SUBSTR(p_qty_yn, 1, 50),
        'p_created_by'    VALUE SUBSTR(p_created_by, 1, 50),
        'p_user_group'    VALUE SUBSTR(p_user_group, 1, 50),
        'p_plant_site_id' VALUE SUBSTR(p_plant_site_id, 1, 50),
        'p_project_code'  VALUE SUBSTR(p_project_code, 1, 50),
        'p_owner'         VALUE SUBSTR(p_owner, 1, 50),
        'p_sender_code'   VALUE SUBSTR(p_sender_code, 1, 50));

    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, '시작', 'P_DMF0082_GET_MAIN_DATA START',
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

    -- [DEFECT_GUARD] p_from_yyyymmdd / p_to_yyyymmdd 형식 검증 (ORA-01841 방어)
    IF p_from_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_from_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_from_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_from_yyyymmdd: ' || NVL(p_from_yyyymmdd, '<NULL>'));
    END IF;
    IF p_to_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_to_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_to_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_to_yyyymmdd: ' || NVL(p_to_yyyymmdd, '<NULL>'));
    END IF;

    ----------------------------------------------------------------------------------------------------
    /* 사용자 컬럼 및 메저 세팅 관련 변수 */
    /* 사용자 컬럼 및 메저 세팅 시작 */
    /* 사용자 컬럼 및 메저 세팅 시작 */
    /* 사용자 컬럼 및 메저 세팅 시작 */
    -- ====================================================================================================
    -- 사용자 컬럼 및 메저 세팅
    -- ====================================================================================================

    VA_PROGRAM_ID := 'DMF0082';
    VA_SHEET_NAME := 'FcstNPrice';

    /* 사용자 컬럼 처리 */
    SELECT COUNT(*) INTO V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* 메저 처리 */
    SELECT COUNT(*) INTO V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , VA_SHEET_NAME -- [FIX 2026-07-12] seed INSERT 는 titleSet 표준명(fcstNPrice) — 카운트/적재 기준 정합
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME -- [FIX 2026-07-12] SHEET_MEASURE 명칭 통일(fcstNPrice) 후 원복
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* 사용자 컬럼 및 메저 세팅 종료 */
    /* 사용자 컬럼 및 메저 세팅 종료 */
    /* 사용자 컬럼 및 메저 세팅 종료 */
    ----------------------------------------------------------------------------------------------------
    /* BUCKET 관련 변수 */
    /* BUCKET 관련 세팅 시작 */
    /* BUCKET 관련 세팅 시작 */
    /* BUCKET 관련 세팅 시작 */
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가
    -- ====================================================================================================
    -- BUCKET 관련 세팅
    -- ====================================================================================================

    /* V_EXP_YYYYMMDD: p_from_yyyymmdd + 50 weeks */
    --[E20260908-GETRANGE] 52주 이후 조회/저장 개방 (사용자 지시 2026-09-08).
    --   구 구현은 D_(일자) 버킷만 'p_from + 50주' 로 잘렸다(W_/M_ 는 p_to_yyyymmdd 전 구간) →
    --   50주 이후는 **헤더는 생기는데 값이 안 내려오는** 상태가 되고, 그 구간에 LOC 를 입력하면
    --   일자 셀이 0 으로 남아 저장 SP 의 부분주 합계 판정이 ACTION='D' 로 뒤집혀
    --   검증 #18(Sales Price 삭제 시 52주 이후 FCST 확인)이 수정인데 발동, 저장이 막혔다.
    --   ⇒ D_ 상한을 조회종료일까지 넓힌다. GREATEST 로 구 하한(from+50주)을 보존해
    --     짧은 조회구간의 종전 동작은 그대로 둔다(비회귀). 52주 저장 RULE(#1/#10/#18)은 무변경.
    V_EXP_YYYYMMDD := GREATEST(TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD')
                             , p_to_yyyymmdd);

    DBMS_LOB.CREATETEMPORARY(V_PV_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_PV_COL_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_QTY_SUM, TRUE);

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;
        IF DBMS_LOB.GETLENGTH(V_PV_COL_LIST) = 0 THEN
            V_PV_COL_LIST := V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_NAME;
            V_QTY_SUM     := 'NVL(' || V_PV_COLUMN_NAME || ',0)';
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || V_PV_NAME;
            V_QTY_SUM     := V_QTY_SUM     || '+NVL(' || V_PV_COLUMN_NAME || ',0)';
        END IF;
    END LOOP;
    CLOSE C_BUCKET;

    /* BUCKET 관련 세팅 종료 */
    /* BUCKET 관련 세팅 종료 */
    /* BUCKET 관련 세팅 종료 */
    ----------------------------------------------------------------------------------------------------
    /* Version 관련 세팅 시작 */
    /* Version 관련 세팅 시작 */
    /* Version 관련 세팅 시작 */
    -- ====================================================================================================
    -- Version 관련 세팅
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_T_VERSION;

    IF p_version_type LIKE '%SP%' OR p_version_type LIKE '%MF%' OR p_version_type LIKE '%SF%' THEN
        --2025.03.14 Philsu Park: MF_W, SP_W Cutoff 버전에서 Amount 실적을 찾기위한 SP_VERSION_NO 추가.
        INSERT INTO SCM_MGR.GT_DMF0082_T_VERSION (VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD, SP_VERSION_NO)
        SELECT A.TOKEN      AS VERSION_NO
             , CASE WHEN D.DM_RTF_YN = 'N' THEN A.TOKEN || '(' || C.ISO_YYYYWW || ') (NO PLAN)'
                    ELSE A.TOKEN || '(' || C.ISO_YYYYWW || ')'
               END          AS VERSION_NO_W
             , TO_CHAR(TO_DATE(B.YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD') AS NOW_YYYYMMDD
             , (SELECT MAX(V2.VERSION_NO)
                FROM   SCM_MGR.DM_MST_VERSION V2
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M CM
                    ON  V2.YYYYMMDD = CM.BASIS_YYYYMMDD
                WHERE  V2.VERSION_TYPE LIKE 'SP%'
                AND    V2.DIVISION_ID  = B.DIVISION_ID
                AND    CM.ISO_YYYYWW   = C.ISO_YYYYWW) AS SP_VERSION_NO
        FROM   (SELECT TOKEN                             /* [E20260819-MULTIJOIN] 인라인 REGEXP 분해 → GTT 선적재 소비
                   (IF LIKE 게이트 기존 유지 — 'ALL' 개념 없는 버전 유니버스 해석 지점) */
                FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN
                WHERE  PARAM_NM = 'p_version_type') A
        INNER JOIN SCM_MGR.DM_MST_VERSION B
            ON  B.VERSION_NO  = A.TOKEN
            AND B.DIVISION_ID = p_division_id
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
            ON  C.BASIS_YYYYMMDD = B.YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN D
            ON  D.DIVISION_ID        = B.DIVISION_ID
            AND D.PLAN_START_YYYYMMDD = C.BASIS_START_DATE;
    END IF;

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_VERSION', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -- [2026-07-31 PARTITION PRUNING] 선택 버전의 CUTOFF 범위 산출
    --   근거: VERSION_NO ↔ CUTOFF_YYYYMMDD 는 1:1 (사내 전 division 87버전 실측, 불일치 0),
    --         DM_MST_VERSION.YYYYMMDD = SCM_MST_FUTURE_PRICE_C.CUTOFF_YYYYMMDD (81/81 일치).
    --   따라서 아래 범위 조건은 **행을 걸러내지 않고** 파티션 프루닝만 유도한다.
    SELECT NVL(MIN(B.YYYYMMDD),'00000000'), NVL(MAX(B.YYYYMMDD),'99999999')
      INTO V_CUTOFF_FROM, V_CUTOFF_TO
      FROM SCM_MGR.GT_DMF0082_T_VERSION V
      JOIN SCM_MGR.DM_MST_VERSION B
        ON B.VERSION_NO = V.VERSION_NO AND B.DIVISION_ID = p_division_id;


    /* Version 관련 세팅 종료 */
    /* Version 관련 세팅 종료 */
    /* Version 관련 세팅 종료 */
    ----------------------------------------------------------------------------------------------------
    /* #TempSiteItem 만들기 */
    /* 1. #TEMP_DM_MST_ITEM_SINGLE_V 만들기 위해서 ORI_V , A_V , B_V 3개 만들기 그 후 최종적으로 완성 */
    /* 2. #TempSiteItemAll에서 위에서 만든 #TEMP_DM_MST_ITEM_SINGLE_V 사용해서 만들기 */
    /* 3. #TempSiteItemAll를 만든뒤 최종적으로 #TempSiteItem 만들기 */
    -- ====================================================================================================
    -- WS FCST 타입 세팅
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_T_WS_FCST;

    INSERT INTO SCM_MGR.GT_DMF0082_T_WS_FCST (FCST_TYPE)
    SELECT DISTINCT A.SEGMENT1 AS FCST_TYPE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'SALES_TYPE_CODE';

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_WS_FCST', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -- ====================================================================================================
    -- 날짜 범위 계산
    -- ====================================================================================================

    -- [DATE ROOT FIX 2026-07-12] AS-IS L700~747 날짜경계(당주 월요일) 로직 충실 복원.
    --   구 변환분은 V_TO_RESULT 를 GT_..._T_VERSION 에서만 읽었으나 T_VERSION 은 Cutoff(SP/MF/SF)
    --   버전에서만 적재됨 → 'Current' 조회 시 V_TO_RESULT=NULL → 과거/계획 구간분리 붕괴 →
    --   SELLING_PRICE 가 계획구간이 아닌 전체범위(160K)로 적재되어 LOC/KRW/USD 68× 팬아웃.
    --   AS-IS 는 캘린더(SCM_SYS_CALENDAR_M)로 기준일을 산출한다. (오늘=SYSDATE, KST)
    V_FROM_YYYYMMDD := p_from_yyyymmdd;
    V_TO_YYYYMMDD   := p_to_yyyymmdd;

    -- @V_FROM_YYYYMMDD : 당주 월요일 (오늘 ISO 주의 시작일)
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD)
        INTO   V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.ISO_YYYYWW = (SELECT MIN(ISO_YYYYWW)
                               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD'));
    EXCEPTION WHEN OTHERS THEN V_FROM_YYYYMMDD := p_from_yyyymmdd;
    END;

    -- @V_FROM_RESULT : 조회 FROM 주 월요일
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = p_from_yyyymmdd;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_FROM_RESULT := p_from_yyyymmdd;
    END;

    -- @V_TO_RESULT : 조회 TO 주 월요일 (초기값 — 아래 분기에서 재조정)
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = p_to_yyyymmdd;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_TO_RESULT := p_to_yyyymmdd;
    END;

    -- AS-IS 4분기 (앞 2개만 유효 — > / <= 배타, 뒤 2개는 도달불가 dead)
    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN        -- 실적+계획 (조회구간이 당주 이전부터 시작)
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_TO_RESULT   := V_FROM_YYYYMMDD;          -- 실적/계획 경계 = 당주 월요일
    ELSE                                           -- 전부 미래 (실적 없음)
        V_TO_YYYYMMDD  := p_to_yyyymmdd;
        V_FROM_RESULT  := '19000101';
        V_TO_RESULT    := '19000101';
    END IF;

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_ORI_V — SCM_ITEM_M_SN 에서 23컬럼 로드
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V;

    -- #TEMP_DM_MST_ITEM_SINGLE_ORI_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , T1.ITEM_NAME
         , T1.ITEM_CLASS
         , T1.ITEM_CLASS_NAME
         , T1.NICK_NAME
         , T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME
         , T1.ITEM_UOM
         , T1.SPEC
         , T1.MDM_PROJECT_NAME
         , T1.MIN_CAPACITY
         , T1.ACTIVE_FLAG
         , T1.ENERGE
         , T1.CELL_QUANTITY
         , T1.SCP_EXTRA_SPEC
         , T1.FORECAST_INFO_BIZ_TYPE
         , T1.FORECAST_INFO_PRODUCT_GROUP
         , T1.FORECAST_INFO_CELL_MODEL
         , T1.FORECAST_INFO_CELL_PACK_COUNT
         , T1.FORECAST_INFO_SPEC
         , T1.FORECAST_INFOR_VERSION
         , T1.CELL_TYPE
    --FROM FP_MGR.SCM_ITEM_M T1   -- linked server 원본 [LGCE_FP_TR].[DBO].[SCM_ITEM_M]
    FROM   SCM_MGR.SCM_ITEM_M_SN T1
    WHERE  T1.DIVISION_ID = p_division_id
      AND  T1.ACTIVE_FLAG = 'Y'
    --[2026-07-31 항목1] 최초 데이터 생성 시 **필요한 데이터만 추출**
    --  site-item 에 존재하는 품목의 **12자리 접두 그룹**만 적재한다.
    --  ⚠ 접두 단위인 이유: 하위 _B_V 가 GROUP BY SUBSTR(ITEM_ID,1,12) 로 MAX() 6컬럼을
    --     집계하므로, ITEM_ID 정확 필터는 같은 접두를 공유하는 비소속 품목을 제거해
    --     MAX() 값을 바꾼다. 접두 단위로 자르면 그룹이 통째로 포함/제외되어 집계 불변.
    --  실측(div40): 98,346 -> 20,730 (-79%), _B_V MAX 6컬럼 차이 0건
    AND  SUBSTR(T1.ITEM_ID,1,12) IN (
           SELECT SUBSTR(S.ITEM_ID,1,12)
             FROM SCM_MGR.SCM_MST_SITE_ITEM S
            WHERE S.DIVISION_ID = p_division_id );
    -- #TEMP_DM_MST_ITEM_SINGLE_ORI_V 만들기 종료

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_ORI_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_A_V — ORI_V GROUP BY DIVISION_ID, ITEM_ID
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V;

    -- #TEMP_DM_MST_ITEM_SINGLE_A_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)                                AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)                               AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)                          AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)                                AS NICK_NAME
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R'
           END                                              AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME)                      AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)                                 AS ITEM_UOM
         , MAX(T1.SPEC)                                     AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)                         AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)                             AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)                              AS ACTIVE_FLAG
         , MAX(T1.ENERGE)                                   AS ENERGE
         , MAX(T1.CELL_QUANTITY)                            AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)                           AS SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V T1
    WHERE  1 = 1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
    -- #TEMP_DM_MST_ITEM_SINGLE_A_V 만들기 종료

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_A_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_B_V — ORI_V GROUP BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V;

    -- #TEMP_DM_MST_ITEM_SINGLE_B_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V
    (
        DIVISION_ID, ITEM_ID
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12)                           AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)                      AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)                 AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)                    AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)               AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)                          AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)                      AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                                   AS CELL_TYPE
    FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);
    -- #TEMP_DM_MST_ITEM_SINGLE_B_V 만들기 종료

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_B_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_V — A_V + B_V 조인, ENERGE WH→KWH, STRING_SPLIT 필터 (p_item_id)
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V;

    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    )
    SELECT DIVISION_ID
         , ITEM_ID
         , ITEM_NAME
         , ITEM_CLASS
         , ITEM_CLASS_NAME
         , NICK_NAME
         , ITEM_TYPE
         , MATERIAL_CLASS_NAME
         , ITEM_UOM
         , SPEC
         , MDM_PROJECT_NAME
         , MIN_CAPACITY
         , FORECAST_INFO_BIZ_TYPE
         , FORECAST_INFO_PRODUCT_GROUP
         , FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC
         , FORECAST_INFOR_VERSION
         , ACTIVE_FLAG
         , CELL_TYPE
         , CASE WHEN TO_NUMBER(ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL
                THEN ROUND(TO_NUMBER(ENERGE) / 1000, 4)
                ELSE NULL
           END                                              AS ENERGE  -- WH → KWH 환산
         , CELL_QUANTITY
         , SCP_EXTRA_SPEC
    FROM (
        SELECT T2X.DIVISION_ID
             , T2X.ITEM_ID
             , T2X.ITEM_NAME
             , T2X.ITEM_CLASS
             , T2X.ITEM_CLASS_NAME
             , T2X.NICK_NAME
             , T2X.ITEM_TYPE
             , T2X.MATERIAL_CLASS_NAME
             , T2X.ITEM_UOM
             , T2X.SPEC
             , T2X.MDM_PROJECT_NAME
             , T2X.MIN_CAPACITY
             , T2X.FORECAST_INFO_BIZ_TYPE
             , T2X.FORECAST_INFO_PRODUCT_GROUP
             , T2X.FORECAST_INFO_CELL_MODEL
             , T2X.FORECAST_INFO_CELL_PACK_COUNT
             , T2X.FORECAST_INFO_SPEC
             , T2X.FORECAST_INFOR_VERSION
             , T2X.ACTIVE_FLAG
             , T2X.CELL_TYPE
             , T2X.ENERGE
             , T2X.CELL_QUANTITY
             , T2X.SCP_EXTRA_SPEC
        FROM (
            SELECT T1.DIVISION_ID
                 , T1.ITEM_ID
                 , T1.ITEM_NAME
                 , T1.ITEM_CLASS
                 , T1.ITEM_CLASS_NAME
                 , T1.NICK_NAME
                 , T1.ITEM_TYPE
                 , T1.MATERIAL_CLASS_NAME
                 , T1.ITEM_UOM
                 , T1.SPEC
                 , T1.MDM_PROJECT_NAME
                 , T1.MIN_CAPACITY
                 , T2.FORECAST_INFO_BIZ_TYPE
                 , T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL
                 , T2.FORECAST_INFO_CELL_PACK_COUNT
                 , T2.FORECAST_INFO_SPEC
                 , T2.FORECAST_INFOR_VERSION
                 , T1.ACTIVE_FLAG
                 , T2.CELL_TYPE
                 , T1.ENERGE
                 , T1.CELL_QUANTITY
                 , T1.SCP_EXTRA_SPEC
            FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V T1
            INNER JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V T2
                ON  T1.DIVISION_ID = T2.DIVISION_ID
                AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
            WHERE 1 = 1
        ) T2X
        WHERE  T2X.DIVISION_ID = p_division_id
    )
    GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
           , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;
    /* [E20260819-MULTIJOIN] Item 필터 — 구 인라인 REGEXP 분해 '%토큰%' LIKE INNER JOIN 을 GTT 선적재+NOT EXISTS(LIKE) 로 전환.
       'ALL' 개념 없음(텍스트 검색) — NULL/'' 이면 미적용(구 코드의 NULL토큰='%%' 전건통과와 동일 의미).
       ITEM_ID/NICK_NAME 스테이징 1:1 실측 — LIKE OR 술어 원형 보존. */
    IF p_item_id IS NOT NULL THEN
        DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_item_id'
                   AND    (F.ITEM_ID   LIKE '%' || T.TOKEN || '%'
                        OR F.NICK_NAME LIKE '%' || T.TOKEN || '%'));
    END IF;
    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    ----------------------------------------------------------------------------------------------------
    /* #TempSiteItem 만들기 시작 */
    -- ====================================================================================================
    -- #TempSiteItemAll — SCM_MST_SITE_ITEM + _V + 마스터 8테이블 조인 (원본 47컬럼 → GTT 44컬럼 매핑)
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL;

    -- #TempSiteItemAll 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
      , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    SELECT F.DIVISION_ID
         , F.PROJECT_CODE
         , F.SCM_SITE_ID
         , F.ITEM_ID
         , F.ATTRIBUTE5                                     AS CELL_MODEL
         , T2.NICK_NAME
         , F.ATTRIBUTE1                                     AS DMS_SALES
         , F.ATTRIBUTE2                                     AS DMS_CUSTOMER
         , (SELECT LISTAGG(X.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY X.USER_NAME_EN)
            FROM   (SELECT DISTINCT ZA.USER_NAME_EN
                    FROM   (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) AS TOK  -- [PERF 2026-07-12] IN->JOIN uses PK_SCM_MST_SSO_USER_INFO
                            FROM   DUAL
                            CONNECT BY LEVEL <= REGEXP_COUNT(F.OWNER, ',') + 1) TK
                    JOIN   SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = TK.TOK) X
           )                                                AS OWNER
         , TEAM.DEPT_ID
         , TEAM.DEPT_NAME_KO
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                ELSE T2.FORECAST_INFO_CELL_PACK_COUNT
           END                                              AS FORECAST_INFO_CELL_PACK_COUNT
         , T2.ITEM_TYPE
         , NVL(MP.PROJECT_NAME, F.PROJECT_CODE) AS PROJECT_NAME  --[E20260819-PJTNAME]
         , J.USER_NAME_EN                                   AS PROJECT_OWNER
         , ''                                               AS BIZ_TYPE
         , S.SOLDTO_CUSTOMER
         , I.COUNTRY_NAME
         , H.CITY_NAME
         , ''                                               AS PROJECT_STATUS
         , T2.ITEM_NAME
         , S.VMI_YN
         , F.CUST_GROUP
         , F.CUST_GROUP_DTL
         , F.APPLICATION
         , F.ROUTE
         , T2.MDM_PROJECT_NAME
         , TO_NUMBER(T2.MIN_CAPACITY DEFAULT NULL ON CONVERSION ERROR) AS MIN_CAPACITY
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE
           END                                              AS FORECAST_INFO_BIZ_TYPE
         , LOOK.NAME                                        AS CELL_TYPE
         , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
         , T2.FORECAST_INFO_SPEC
         , T2.FORECAST_INFOR_VERSION
         , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME
         , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_CAR
         , TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_MODULE
         , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR)
           / CASE WHEN NVL(TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR), 0) = 0 THEN 1
                  ELSE TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR)
             END                                             AS MODULE_PER_CAR
         , NULL                                             AS SORT_ORDER_NO
         , TO_CHAR(T2.ENERGE)                               AS ENERGE
         , TO_NUMBER(T2.CELL_QUANTITY DEFAULT NULL ON CONVERSION ERROR) AS CELL_QUANTITY
         , '/'                                               AS PLANT_SITE_ID        -- 원본 GTT 에 없는 컬럼
         , F.VALID_YN                                       AS ITEM_VALID_YN
         , S.END_CUSTOMER
         , NULL                                              AS PROJECT_S_OP_REPORT  -- Case: 20260416 SCM_MST_SITE_ITEM.PROJECT_S_OP_REPORT 삭제
    FROM   SCM_MGR.SCM_MST_SITE_ITEM F
    INNER JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V T2
        ON  F.DIVISION_ID = T2.DIVISION_ID
        AND F.ITEM_ID     = T2.ITEM_ID
    INNER JOIN SCM_MGR.SCM_MST_SITE S
        ON  F.DIVISION_ID = S.DIVISION_ID
        AND F.SCM_SITE_ID = S.SCM_SITE_ID
        AND S.SITE_TYPE   = 'SALES'
    INNER JOIN SCM_MGR.SCM_MST_CITY H
        ON  S.CITY        = H.CITY
    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY     = I.COUNTRY
    --[E20260819-PJTNAME] Project 명 원천 — SCM_MST_PROJECT (미등재 코드=코드 폴백 LEFT)
    LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
        ON  F.DIVISION_ID  = MP.DIVISION_ID
        AND F.PROJECT_CODE = MP.PROJECT_CODE
    -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
        -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
        -- [hook#150 2026-09-06 AJS] AS-IS: FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
        -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
            -- [hook#150 2026-09-06 AJS] AS-IS: ON B2.DEPT_ID = C.DEPT_ID
    -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
        -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                                -- [hook#150 2026-09-06 AJS] AS-IS: THEN F.OWNER
                                -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                           -- [hook#150 2026-09-06 AJS] AS-IS: END
    -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
        ON TEAM.DEPT_ID = F.DEPT_ID
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                             THEN F.OWNER
                             ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                        END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
        -- [hook#150 2026-09-06 AJS] AS-IS: ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                             -- [hook#150 2026-09-06 AJS] AS-IS: ELSE F.DEPT_ID   -- Case 39: SCM_MST_SITE.DEPT_ID 삭제, SCM_MST_SITE_ITEM.DEPT_ID 사용
                        -- [hook#150 2026-09-06 AJS] AS-IS: END
        ON K.DEPT_ID = F.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: div40 은 J.DEPT_ID = OWNER 경유)
    LEFT JOIN (
        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
    ) LOOK
        ON LOOK.CODE = T2.CELL_TYPE
    LEFT JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V T4
        ON  T2.DIVISION_ID = T4.DIVISION_ID
        AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
    LEFT JOIN (
        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
        FROM (
            SELECT SEGMENT2 AS MODEL
                 , SEGMENT3 AS BIZ_TYPE
                 , SEGMENT4 AS CELL_PACK_COUNT
                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
              AND  SEGMENT1    = '40'
        ) A
        WHERE MODEL_RANK = 1
    ) LOOKA
        ON LOOKA.MODEL = F.ITEM_ID
    WHERE  F.DIVISION_ID = p_division_id;
    /* [E20260819-MULTIJOIN] 조회조건 SCM Site / Customer / Biz Type — 구 인라인 OR분기(REGEXP 분해)를 GTT 선적재+IF게이트+NOT EXISTS 로 전환.
       Biz Type 술어식(CASE WHEN F.ITEM_ID=LOOKA.MODEL...)은 FORECAST_INFO_BIZ_TYPE 컬럼으로 1:1 스테이징(실측) — 동일 값 필터.
       전 컬럼 ALL_TAB_COLUMNS 실측 NULLABLE='Y' → 양변 원문 비교(구 bare-IN 의미론 보존 — 무값 행은 값 지정 시 제외). */
    IF p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_scm_site_id'
                   AND    T.TOKEN    = F.SCM_SITE_ID);
    END IF;
    /* [E20260908-ENDCUST] End Customer 필터 축 정정 — 정본 = AS-IS DMF0003_GET_MKT_FCST_DATA (사용자 지시 2026-09-08).
         AS-IS 실측:
           · `where f.division_id <> '40'` 브랜치 (L1681) → `S.END_CUSTOMER`  (S = SCM_MST_SITE)
           · `where f.division_id  = '40'` 브랜치 (L1838) → `f.project_code`
         구 구현은 division 무관하게 PROJECT_CODE 하고만 대조해, 81 계열에서 EC 콤보가 주는
         **사이트 파생 고객명**(FilterEndCustomerByDivision 3번째 UNION = SCM_MST_SITE.END_CUSTOMER)이
         절대 일치하지 않아 스테이징이 전건 삭제 → 0행이 됐다 (신고: div 81 + BMW 선택 시 미조회).
         본 GTT 의 END_CUSTOMER 컬럼은 이미 `S.END_CUSTOMER`(SCM_MST_SITE) 로 적재된다(적재 SELECT 실측).
         ⚠ Project 조건은 별도 파라미터 `p_project_code` 가 독립 적용하므로(아래 3300행대)
           Project + End Customer **동시 입력**이 그대로 AND 로 걸린다. */
    IF p_customer IS NOT NULL AND p_customer <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_customer'
                   AND    T.TOKEN    = CASE WHEN p_division_id = '40' THEN F.PROJECT_CODE
                                            ELSE F.END_CUSTOMER END);
    END IF;
    IF p_biz_type IS NOT NULL AND p_biz_type <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_biz_type'
                   AND    T.TOKEN    = F.FORECAST_INFO_BIZ_TYPE);
    END IF;
    /* [E20260819-MULTIJOIN] Item 필터 — 구 인라인 REGEXP 분해 '%토큰%' LIKE INNER JOIN 을 GTT 선적재+NOT EXISTS(LIKE) 로 전환.
       'ALL' 개념 없음(텍스트 검색) — NULL/'' 이면 미적용(구 코드의 NULL토큰='%%' 전건통과와 동일 의미).
       ITEM_ID/NICK_NAME 스테이징 1:1 실측 — LIKE OR 술어 원형 보존. */
    IF p_item_id IS NOT NULL THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_item_id'
                   AND    (F.ITEM_ID   LIKE '%' || T.TOKEN || '%'
                        OR F.NICK_NAME LIKE '%' || T.TOKEN || '%'));
    END IF;
    -- #TempSiteItemAll 만들기 종료

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM_ALL', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- #TempSiteItem — TempSiteItemAll GROUP BY + MAX dedup
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM;

    -- #TempSiteItem 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
      , CELL_MODEL, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)                      AS CELL_MODEL
         , MAX(DMS_SALES)                       AS DMS_SALES
         , MAX(DMS_CUSTOMER)                    AS DMS_CUSTOMER
         , MAX(OWNER)                           AS OWNER
         , MAX(DEPT_ID)                         AS DEPT_ID
         , MAX(DEPT_NAME_KO)                    AS DEPT_NAME_KO
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)   AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(ITEM_TYPE)                       AS ITEM_TYPE
         , MAX(PROJECT_OWNER)                   AS PROJECT_OWNER
         , MAX(BIZ_TYPE)                        AS BIZ_TYPE
         , MAX(SOLDTO_CUSTOMER)                 AS SOLDTO_CUSTOMER
         , MAX(COUNTRY_NAME)                    AS COUNTRY_NAME
         , MAX(CITY_NAME)                       AS CITY_NAME
         , MAX(PROJECT_STATUS)                  AS PROJECT_STATUS
         , MAX(ITEM_NAME)                       AS ITEM_NAME
         , MAX(VMI_YN)                          AS VMI_YN
         , MAX(CUST_GROUP)                      AS CUST_GROUP
         , MAX(CUST_GROUP_DTL)                  AS CUST_GROUP_DTL
         , MAX(APPLICATION)                     AS APPLICATION
         , MAX(ROUTE)                           AS ROUTE
         , MAX(MDM_PROJECT_NAME)                AS MDM_PROJECT_NAME
         , MAX(MIN_CAPACITY)                    AS MIN_CAPACITY
         , MAX(FORECAST_INFO_BIZ_TYPE)          AS FORECAST_INFO_BIZ_TYPE
         , MAX(CELL_TYPE)                       AS CELL_TYPE
         , MAX(FORECAST_INFO_ALL)               AS FORECAST_INFO_ALL
         , MAX(FORECAST_INFO_SPEC)              AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)          AS FORECAST_INFOR_VERSION
         , MAX(CELL_MODEL_NICK_NAME)            AS CELL_MODEL_NICK_NAME
         , MAX(CELL_PER_CAR)                    AS CELL_PER_CAR
         , MAX(CELL_PER_MODULE)                 AS CELL_PER_MODULE
         , MAX(MODULE_PER_CAR)                  AS MODULE_PER_CAR
         , MAX(SORT_ORDER_NO)                   AS SORT_ORDER_NO
         , MAX(ENERGE)                          AS ENERGE
         , MAX(CELL_QUANTITY)                   AS CELL_QUANTITY
         , MAX(PLANT_SITE_ID)                   AS PLANT_SITE_ID
         , MAX(ITEM_VALID_YN)                   AS ITEM_VALID_YN
         , MAX(END_CUSTOMER)                    AS END_CUSTOMER
         , MAX(PROJECT_S_OP_REPORT)             AS PROJECT_S_OP_REPORT
    FROM   SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
    -- #TempSiteItem 만들기 종료

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    /* #TempSiteItem 만들기 종료 */
    ----------------------------------------------------------------------------------------------------
    /* 조회 할 때 쓸 MKT_FCST, SALE_PRICE 의 RAW DATA 는 #TempFcstNPrice 에 넣는다. */
    /* 최종적으로 #TempFcstNPrice 만듬 */
    -- #TempSelectMeasure 만들기 시작
    -- ====================================================================================================
    -- TempSelectMeasure — 사용자 선택 메저
    -- ====================================================================================================





    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE;

    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT U.COLUMN_NAME                          AS MEASURE
         , NVL(M.ATTRIBUTE5, U.COLUMN_NAME)       AS RESULT_MEASURE
         , U.COLUMN_NAME                          AS MEASURE_GROUP
         , U.SORT_ORDER_NO
         , U.USER_ID
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    INNER JOIN SCM_MGR.SCM_MST_SHEET_MEASURE M
        ON  M.PROGRAM_ID  = U.PROGRAM_ID
        AND M.SHEET_NAME  = U.SHEET_NAME
        AND M.COLUMN_NAME = U.COLUMN_NAME
        AND M.VALID_YN    = 'Y'
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    /* [E20260825-CUSTSUB] CUST_FCST 종속 메저 확장 (사용자 지시 2026-08-25).
       AS-IS DMF0003 CSR C20191031-000137 / E20241126-000426 계보 이식 — 정본 = PKG_DMF0003 L6498~6564.
       사용자가 CUST_FCST 를 선택하면:
         ① EDI 하위 고정 8종 (CUST_FCST_EDI 0.11 ~ Planning_Forecast 0.18)
         ② DM_MST_CUSTOMER_FCST 등재 메저 (데이터 기반, parent+0.10)
       를 하위 행으로 자동 확장한다. 원장(81) 실측: CUST_FCST_EDI 41,750행·Commercial_Agreement 41,137행.
       RESULT_MEASURE = 자기 이름(실적 매핑 없음 — AS-IS 동일). 중복 방어 = 이름 GROUP BY + NOT EXISTS. */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT S.MEASURE, S.MEASURE, 'CUST_FCST', A.SORT_ORDER_NO + S.SORT_NO, A.USER_ID
    FROM  (SELECT U.USER_ID, U.SORT_ORDER_NO
           FROM   SCM_MGR.SCM_MST_TITLESET_USER U
           WHERE  U.PROGRAM_ID = VA_PROGRAM_ID
             AND  U.SHEET_NAME = VA_SHEET_NAME
             AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
             AND  U.USER_ID    = p_created_by
             AND  U.COLUMN_NAME = 'CUST_FCST') A,
          (SELECT MEASURE, MIN(SORT_NO) AS SORT_NO
           FROM  (SELECT 'CUST_FCST_EDI'               AS MEASURE, 0.11 AS SORT_NO FROM DUAL UNION ALL
                  SELECT 'Backorder'                             , 0.12 FROM DUAL UNION ALL
                  SELECT 'Commercial_Agreement'                  , 0.13 FROM DUAL UNION ALL
                  SELECT 'Firm_Temp'                             , 0.14 FROM DUAL UNION ALL
                  SELECT 'Immidiate'                             , 0.15 FROM DUAL UNION ALL
                  SELECT 'Manumacturing_Material_Temp'           , 0.16 FROM DUAL UNION ALL
                  SELECT 'Material_Temp'                         , 0.17 FROM DUAL UNION ALL
                  SELECT 'Planning_Forecast'                     , 0.18 FROM DUAL
                  UNION ALL
                  SELECT C.MEASURE, 0.10
                  FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
                  WHERE  C.MEASURE_GROUP = 'CUST_FCST'
                    AND  NVL(C.MEASURE, '/') <> '/'
                    AND  C.VALID_YN = 'Y')
           GROUP BY MEASURE) S
    WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE X
                      WHERE X.MEASURE = S.MEASURE);




    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, 'ING', 'VA_PROGRAM_ID:' || VA_PROGRAM_ID || + ',VA_SHEET_NAME:' || VA_SHEET_NAME || ',p_created_by:' ||p_created_by,
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

    -- 강제 포함 메저: LOC, KRW, FCST_GAP (USER_ID = 'DM_ADMIN' 로 표식 — 최종 삭제 대상)
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT M.COLUMN_NAME, M.COLUMN_NAME, M.COLUMN_NAME, M.SORT_ORDER_NO, 'DM_ADMIN'
    FROM   SCM_MGR.SCM_MST_SHEET_MEASURE M
    WHERE  M.PROGRAM_ID  = VA_PROGRAM_ID
    AND    M.SHEET_NAME  = VA_SHEET_NAME
    AND    M.COLUMN_NAME IN ('LOC', 'KRW', 'FCST_GAP', 'RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW', 'SCM_FCST', 'MKT_FCST')
    AND    NOT EXISTS (
               SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE X
               WHERE X.MEASURE = M.COLUMN_NAME
           );

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SELECT_MEASURE', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -- ====================================================================================================
    -- T_LAST_DATA_SETUP_FCST / PRICE (Current 버전 최신 데이터 로드)
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE;

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT /*+ LEADING(A) USE_HASH(C) */ /*[E20260930-DMF0082CLOUDPERF] L1265 형제문장 동일 — TEMP_SITE_ITEM 1행 추정 NL 방지 (클라우드 9.4s) */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END IF;  --[DIV81]

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
    NULL;  --[E20260930-DMF0082ONEREAD] 81/82 T_LAST_DATA_SETUP_PRICE 적재 제거 — 소비처(판가 INSERT)가 원장 1회 읽기 윈도 MAX 로 대체 (타임아웃 3d2xnx839ksnt · IDX02 힌트 철회)
--    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
--        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
--    SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
--         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
--         , MAX(A.CREATION_DATE) AS CREATE_DATE
--         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
--    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
--    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
--        ON  C.DIVISION_ID  = A.DIVISION_ID
--        AND C.PROJECT_CODE = A.PROJECT_CODE
--        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
--        AND C.ITEM_ID      = A.ITEM_ID
--    WHERE  A.DIVISION_ID = p_division_id
--    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
--    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
--           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT /*+ LEADING(A) USE_HASH(C) */ -- ④ [E20260815-PERF2] 계획 고정 (hook #129 ④)
               -- GTT C(TEMP_SITE_ITEM) 는 세션 데이터라 통계가 없어 추정 1행으로 굳는다(실제 14,879).
               -- 그 결과 NESTED LOOPS 로 대형표 A(div40 103만행)를 **행별 인덱스 조회** 했다
               -- (실측: ASH 14s/45.2% · buffer_gets 19,989,169 · PLAN LINE 7 INDEX RANGE SCAN).
               -- ①함수/스칼라서브쿼리 없음 ②이미 SARGable ③PK 존재(인덱스 부재 아님) ⇒ ④ 적용.
           A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END IF;  --[DIV81]

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST',  NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */
    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- T_LAST_DATA_SETUP_FCST_C / PRICE_C (Cutoff 버전 최신 데이터 로드)
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C;

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO;
    END IF;  --[DIV81]

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO  --[2026-07-31] 파티션 프루닝
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END IF;  --[DIV81]

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST_C',  NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */
    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- TempFcstNPrice 구성 시작
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;

    -- ============================================================
    -- Current 버전 데이터 INSERT
    -- ============================================================
    IF p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%' THEN

        -- 계획구간 수요 (DM_PLN_CFM_MKT_DEMAND_PLAN)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END  /*[E20260930-DMF0082CUSTEXCEL] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1 — 'Customer FCST' 원장 행은 수정자 robot 여부로 RPA/EXCEL 표기 (콤보 'Measure' 가 ' └ EXCEL' 로 표시). UPPER = MSSQL 대소문자 무시 등가*/
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재    -- MS 원본이 '-'    --  2026.10.12 AJS
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY  /*[E20260930-DMF0082CUSTEXCEL] AS-IS 동일 — 수정자 접미사*/
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END  /*[E20260930-DMF0082CUSTEXCEL] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1 — 'Customer FCST' 원장 행은 수정자 robot 여부로 RPA/EXCEL 표기 (콤보 'Measure' 가 ' └ EXCEL' 로 표시). UPPER = MSSQL 대소문자 무시 등가*/
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY  /*[E20260930-DMF0082CUSTEXCEL] AS-IS 동일 — 수정자 접미사*/
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        END IF;  --[DIV81]

        --[E20261002-DMF0082-81MKTAMT] 81 계획구간 MKT FCST 금액(MKT_AMT_KRW / MKT_AMT_LOC) — 원천 DM_PLN_SALES_PLAN (사용자 지시 2026-10-02).
        --  40 은 저장 SP 가 금액을 수요 원장(DM_PLN_CFM_MKT_DEMAND_PLAN, QTY NUMBER(25,10))에 저장하지만, 81 수요 원장
        --  DM_PLN_MKT_FCST 는 QTY NUMBER(20,10) 이라 금액(사내 실측 최대 13자리)을 담지 못한다 (ORA-01438).
        --  81 금액은 Sales Plan 동기화(PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE — DMF0082·DMF0003 저장 직후)와
        --  야간 배치가 DM_PLN_SALES_PLAN 에 MKT_FCST × 판가로 생성하므로 그 값을 읽는다.
        --  기간·SITE_ITEM·WS FCST_TYPE 게이트 = 위 81 수요 arm 동일. 셀생산지는 81 규약 '-' 로 합산.
        --  CURRENCY 는 수요 arm 과 같이 비워 두고 하단 "CURRENCY 업데이트" 가 LOC 통화로 채운다.
        IF p_division_id LIKE '81%' THEN
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID  --[DIV81] 81 수요 arm 과 같은 축 ('-')    -- MS 원본이 '-'    --  2026.10.12 AJS
             , A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE
             , NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, 'Current' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM  ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'   -- 강제 포함분(실적 Unit Price 계산 전용)은 계획구간 적재 제외
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.QTY <> 0;
        END IF;  --[E20261002-DMF0082-81MKTAMT]

        -- 판가 (DM_PLN_CFM_SELLING_PRICE)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        --[E20260930-DMF0082ONEREAD] 구본 (IDX02 힌트 + T_LAST_DATA_SETUP_PRICE LD 조인) — 아래 신 SELECT 로 대체
--        SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ A.DIVISION_ID
--             , A.PROJECT_CODE
--             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
--             , A.SCM_SITE_ID
--             , A.ITEM_ID
--             , A.DOM_EXP
--             , A.FCST_TYPE
--             , A.INCOTERMS
--             , A.MEASURE
--             , A.PLANT_SITE_ID
--             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재
--             , A.YYYYMMDD
--             , NVL(A.PRICE, 0)
--             , B.MEASURE_GROUP
--             , C.CELL_MODEL
--             , C.NICK_NAME
--             , C.DMS_SALES
--             , C.DMS_CUSTOMER
--             , C.OWNER
--             , C.DEPT_ID
--             , C.DEPT_NAME_KO
--             , C.FORECAST_INFO_CELL_PACK_COUNT
--             , C.ITEM_TYPE
--             , C.PROJECT_NAME
--             , C.PROJECT_OWNER
--             , C.BIZ_TYPE
--             , C.SOLDTO_CUSTOMER
--             , C.COUNTRY_NAME
--             , C.CITY_NAME
--             , C.PROJECT_STATUS
--             , C.ITEM_NAME
--             , C.VMI_YN
--             , C.CUST_GROUP
--             , C.CUST_GROUP_DTL
--             , C.APPLICATION
--             , C.ROUTE
--             , C.MDM_PROJECT_NAME
--             , C.MIN_CAPACITY
--             , C.FORECAST_INFO_BIZ_TYPE
--             , C.CELL_TYPE
--             , C.FORECAST_INFO_ALL
--             , C.FORECAST_INFO_SPEC
--             , C.FORECAST_INFOR_VERSION
--             , C.CELL_MODEL_NICK_NAME
--             , C.CELL_PER_CAR
--             , C.CELL_PER_MODULE
--             , C.MODULE_PER_CAR
--             , B.SORT_ORDER_NO
--             , C.ENERGE
--             , C.CELL_QUANTITY
--             , ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
--             , LD.CREATE_DATE
--             , LD.LAST_UPDATED_BY
--             , '' AS SENDER_CODE
--             , '' AS SENDER_NAME
--             , C.PROJECT_S_OP_REPORT
--             , A.CURRENCY
--             , 'Current' AS VERSION_NO
--             , NULL AS CUTOFF_YYYYMMDD
--             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
--        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
--        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
--            ON  B.MEASURE = A.MEASURE
--        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
--                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
--                     , MAX(CREATE_DATE) AS CREATE_DATE
--                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
--                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
--                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
--            ) LD
--                ON  LD.DIVISION_ID  = A.DIVISION_ID
--                AND LD.PROJECT_CODE = A.PROJECT_CODE
--                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
--                AND LD.ITEM_ID      = A.ITEM_ID
--                AND LD.DOM_EXP      = A.DOM_EXP
--                AND LD.FCST_TYPE    = A.FCST_TYPE
--                AND LD.INCOTERMS    = A.INCOTERMS
--                AND LD.MEASURE      = A.MEASURE
--        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
--            ON  C.DIVISION_ID  = A.DIVISION_ID
--            AND C.PROJECT_CODE = A.PROJECT_CODE
--            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
--            AND C.ITEM_ID      = A.ITEM_ID
--            AND C.ITEM_VALID_YN = 'Y'
--        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
--            ON  D.FCST_TYPE = A.FCST_TYPE
--        WHERE  1 = 1
--        AND    A.DIVISION_ID = p_division_id
--        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)
        /*[E20260930-DMF0082ONEREAD] 판가 원장 1회 읽기 — 구 L1249(T_LAST_DATA_SETUP_PRICE 적재) 제거분의 최신 수정일자·수정자를
           키 8개 PARTITION 윈도 MAX 로 여기서 계산 (구 LD 조인과 등가 · IDX02 힌트 철회). 출력 범위는 바깥 WHERE (구 조건 그대로)*/
        SELECT C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, C26, C27, C28, C29, C30, C31, C32, C33, C34, C35, C36, C37, C38, C39, C40, C41, C42, C43, C44, C45, C46, C47, C48, C49, C50, C51, C52, C53, C54, C55, C56, C57, C58, C59, C60
        FROM (
        SELECT A.DIVISION_ID AS C01
             , A.PROJECT_CODE AS C02
             , A.PROJECT_CODE AS C03  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID AS C04
             , A.ITEM_ID AS C05
             , A.DOM_EXP AS C06
             , A.FCST_TYPE AS C07
             , A.INCOTERMS AS C08
             , A.MEASURE AS C09
             , A.PLANT_SITE_ID AS C10
             , '-' AS C11  --[DIV81] 컬럼 부재
             , A.YYYYMMDD AS C12
             , NVL(A.PRICE, 0) AS C13
             , B.MEASURE_GROUP AS C14
             , C.CELL_MODEL AS C15
             , C.NICK_NAME AS C16
             , C.DMS_SALES AS C17
             , C.DMS_CUSTOMER AS C18
             , C.OWNER AS C19
             , C.DEPT_ID AS C20
             , C.DEPT_NAME_KO AS C21
             , C.FORECAST_INFO_CELL_PACK_COUNT AS C22
             , C.ITEM_TYPE AS C23
             , C.PROJECT_NAME AS C24
             , C.PROJECT_OWNER AS C25
             , C.BIZ_TYPE AS C26
             , C.SOLDTO_CUSTOMER AS C27
             , C.COUNTRY_NAME AS C28
             , C.CITY_NAME AS C29
             , C.PROJECT_STATUS AS C30
             , C.ITEM_NAME AS C31
             , C.VMI_YN AS C32
             , C.CUST_GROUP AS C33
             , C.CUST_GROUP_DTL AS C34
             , C.APPLICATION AS C35
             , C.ROUTE AS C36
             , C.MDM_PROJECT_NAME AS C37
             , C.MIN_CAPACITY AS C38
             , C.FORECAST_INFO_BIZ_TYPE AS C39
             , C.CELL_TYPE AS C40
             , C.FORECAST_INFO_ALL AS C41
             , C.FORECAST_INFO_SPEC AS C42
             , C.FORECAST_INFOR_VERSION AS C43
             , C.CELL_MODEL_NICK_NAME AS C44
             , C.CELL_PER_CAR AS C45
             , C.CELL_PER_MODULE AS C46
             , C.MODULE_PER_CAR AS C47
             , B.SORT_ORDER_NO AS C48
             , C.ENERGE AS C49
             , C.CELL_QUANTITY AS C50
             , ' ' AS C51  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS C52
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS C53
             , '' AS C54
             , '' AS C55
             , C.PROJECT_S_OP_REPORT AS C56
             , A.CURRENCY AS C57
             , 'Current' AS C58
             , NULL AS C59
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS C60
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413) — 구 조건 그대로
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ -- ④ [E20260815-PERF] 계획 고정.
                   -- GTT 는 세션 데이터라 통계가 없어 추정 카디널리티가 1 로 굳는다. 그 결과
                   -- GTT 3개를 MERGE JOIN CARTESIAN 으로 묶어 대형 테이블을 행별 NL 조회했다
                   -- (실측: buffer_gets 5,364만 / 결과 0행 / LINE18 인덱스스캔이 170초 점유).
                   -- A 를 DIVISION_ID+YYYYMMDD 로 먼저 좁히고 GTT 를 해시로 붙인다.
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(A.PRICE, 0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        WHERE  1 = 1
        /* ② [E20260815-PERF] 곱집합 배수 제거 — D 는 FCST_TYPE 등가 1개뿐이라 조인이 아니라 필터다.
           GT_DMF0082_T_WS_FCST 적재가 `SELECT DISTINCT SEGMENT1` 이라 FCST_TYPE 이 유일하므로
           EXISTS 로 바꿔도 **행수가 변하지 않는다**(의미 동일 — 적재문 실측 확인).
           조인으로 두면 드라이빙 곱집합에 14배로 곱해져 NL 반복을 그만큼 늘린다. */
        AND    EXISTS (SELECT 1
                       FROM   SCM_MGR.GT_DMF0082_T_WS_FCST D
                       WHERE  D.FCST_TYPE = A.FCST_TYPE)
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)
        END IF;  --[DIV81]

        -- 실적 수량 (DM_PLN_SALES_PLAN_RESULT)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE  -- [FCST HIST FIX 2026-07-12] AS-IS L1296 `B.MEASURE AS MEASURE` 정합. A.MEASURE(실적=RTF_SYS_RP) → B.MEASURE(표시=MKT_FCST/SCM_FCST/RTF_SYS_RP). RESULT_MEASURE 매핑 반영
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            -- [FCST HIST FIX 2026-07-12] AS-IS L1362 `A.MEASURE = B.RESULT_MEASURE` 정합.
            --   구 변환 오류: 허위 self-비교 `B.MEASURE = B.RESULT_MEASURE` 추가 → MEASURE<>RESULT_MEASURE
            --   매핑 측정(MKT_FCST/SCM_FCST의 RESULT_MEASURE=RTF_SYS_RP) 배제 → 실적구간 FCST 336×2 소실.
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

        /* [E20260826-CUSTSUBR] CUST 종속 메저(EDI/Commercial_Agreement 등) 실적 축 배선 (사용자 지시 2026-08-26).
           결손 실증(파일 대사 14행): 종속 값이 실적 구간(과거)에만 있는 키(BMW 5키/Volvo WA 2키)는
           Current 실적 arm 원천(DM_PLN_SALES_PLAN_RESULT)에 종속 메저가 없어 행이 통째로 빠졌다.
           AS-IS 실적 원장 = DM_PLN_MKT_FCST_RESULT (BMW 키 CUST_FCST_EDI 9행 실측 — 정확히 결손 값).
           본 arm = 종속 메저 전용 (모 CUST_FCST 는 기존 arm 이 담당 — MEASURE<>MEASURE_GROUP 게이트로 중복 0).
           기간/게이트 = 위 실적 arm 동일 (from~V_TO_RESULT, QTY<>0, SITE_ITEM VALID, WS FCST_TYPE).
           CURRENCY = '' (계획 arm 파리티 — 수량 축), CELL_PROD '-' [DIV81]. */
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ /*[E20260930-DMF0082CLOUDPERF] 종속메저 0행 파싱 계획(CARTESIAN→PK 행별) 고정 방지 — k0101 28.4s→0.03s */ A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END  /*[E20260930-DMF0082CUSTEXCEL] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1 — 'Customer FCST' 원장 행은 수정자 robot 여부로 RPA/EXCEL 표기 (콤보 'Measure' 가 ' └ EXCEL' 로 표시). UPPER = MSSQL 대소문자 무시 등가*/
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재 규약    -- MS 원본이 '-'    --  2026.10.12 AJS
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , NULL AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY  /*[E20260930-DMF0082CUSTEXCEL] AS-IS 동일 — 수정자 접미사*/
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'   -- 모행은 기존 실적 arm(SALES_PLAN_RESULT) 담당 — 중복 0
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- Current 버전

    -- ============================================================
    -- MF 버전 데이터 INSERT
    -- ============================================================
    IF p_version_type LIKE '%MF%' THEN

        -- 계획구간 수요 (Cutoff)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재    -- MS 원본이 '-'    --  2026.10.12 AJS
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , F.VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , F.VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        END IF;  --[DIV81]

        --[E20261002-DMF0082-81MKTAMT] 81 계획구간 MKT FCST 금액 MF — 원천 DM_PLN_SALES_PLAN_C (Current 블록 주석 참조).
        --  버전 매핑 = 같은 블록 실적 금액 arm(DM_PLN_SALES_PLAN_RESULT_C)과 동일: 선택 MF 버전과 같은 주의 SP 버전(SP_VERSION_NO).
        IF p_division_id LIKE '81%' THEN
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID  --[DIV81] 81 수요 arm 과 같은 축 ('-')    -- MS 원본이 '-'    --  2026.10.12 AJS
             , A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE
             , NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM  ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.VERSION_NO IN (SELECT V.SP_VERSION_NO FROM SCM_MGR.GT_DMF0082_T_VERSION V WHERE V.VERSION_NO LIKE 'MF%')
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                       , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'   -- 강제 포함분(실적 Unit Price 계산 전용)은 계획구간 적재 제외
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.QTY <> 0;
        END IF;  --[E20261002-DMF0082-81MKTAMT]

        -- 판가 MF (DM_PLN_CFM_SELLING_PRICE_C)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , '-' /*[DIV81]*/, A.YYYYMMDD, NVL(A.PRICE,0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO  --[2026-07-31] 파티션 프루닝
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)
        END IF;  --[DIV81]

        -- 실적 수량 MF (DM_PLN_SALES_PLAN_RESULT_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- MF 버전

    -- ============================================================
    -- SF 버전 데이터 INSERT
    -- ============================================================
    IF p_version_type LIKE '%SF%' THEN

        -- 계획구간 수요 (SF Cutoff)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

        -- MKT_FCST_PP SF 계획구간 (DM_PLN_CFM_MKT_DEMAND_PLAN_C)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE /*[DIV81] END_CUSTOMER=PROJECT_CODE*/, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID, '-' /*[DIV81]*/, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        END IF;  --[DIV81]

        --[E20261002-DMF0082-81MKTAMT] 81 계획구간 MKT FCST 금액 SF — 원천 DM_PLN_SALES_PLAN_C (Current 블록 주석 참조).
        --  버전 매핑 = 같은 블록 실적 금액 arm(DM_PLN_SALES_PLAN_RESULT_C)과 동일: 선택 SF 버전과 같은 주의 SP 버전(SP_VERSION_NO).
        IF p_division_id LIKE '81%' THEN
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID  --[DIV81] 81 수요 arm 과 같은 축 ('-')    -- MS 원본이 '-'    --  2026.10.12 AJS
             , A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE
             , NULL AS CREATE_DATE, NULL AS LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM  ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.VERSION_NO IN (SELECT V.SP_VERSION_NO FROM SCM_MGR.GT_DMF0082_T_VERSION V WHERE V.VERSION_NO LIKE 'SF%')
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                       , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'   -- 강제 포함분(실적 Unit Price 계산 전용)은 계획구간 적재 제외
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.QTY <> 0;
        END IF;  --[E20261002-DMF0082-81MKTAMT]

        -- 실적 수량 SF (DM_PLN_SALES_PLAN_RESULT_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

        -- 판가 SF 계획구간 (DM_PLN_CFM_SELLING_PRICE_C)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE /*[DIV81] END_CUSTOMER=PROJECT_CODE*/, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , '-' /*[DIV81]*/, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO  --[2026-07-31] 파티션 프루닝
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        END IF;  --[DIV81]

    END IF; -- SF 버전

    -- ====================================================================================================
    -- SP 버전 데이터 INSERT (SP 버전별 판가 + 실적 수량)
    -- ====================================================================================================
    IF p_version_type LIKE '%SP%' THEN

        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        -- 계획구간 판가 SP
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE /*[DIV81] END_CUSTOMER=PROJECT_CODE*/, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , '-' /*[DIV81]*/, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO  --[2026-07-31] 파티션 프루닝
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        -- 계획구간 판가 SP
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        END IF;  --[DIV81]

        -- 실적 수량 SP
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- SP 버전

    -- ====================================================================================================
    -- CURRENCY 업데이트 (계획구간 통화코드 보완)
    -- ====================================================================================================

    -- [FIX 2026-07-13] 상관 서브쿼리 UPDATE(행별 GTT 재스캔 O(n^2), 넓은 조회범위서 PGA 폭증→"Free private memory to OS" hang)
    --   → MERGE 사전집계(키별 MAX(LOC CURRENCY) 1회 GROUP BY) + hash join 으로 O(n). 결과 동일(키별 MAX, 미매칭=NULL 유지).
    MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    --[2026-07-31 항목5] hash build 를 소형 집계뷰(B, ~6K행)로 고정 — 355K 와이드행 build 로 인한 TEMP 159MB spill 제거 (조인 입력 순서만 변경, 결과 불변)
    USING (
               SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
           ) B
    ON (    A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.INCOTERMS         = B.INCOTERMS
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID )
    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;

    -- ====================================================================================================
    -- [E20260918-CURRCELLPROD] CURRENCY 2차 보완 — CELL_PROD_SITE_ID 제외 8키 폴백
    --
    --   위 1차 MERGE 는 CELL_PROD_SITE_ID 를 조인키에 포함한다(AS-IS 동일). 그런데 GTT 적재 arm 별로
    --   이 컬럼의 채움 규약이 다르다 — 단가 원천 SCM_MST_FUTURE_PRICE 에는 컬럼 자체가 없어 '-' 를
    --   고정 삽입하고, 수요/실적 원천은 실제값(NJ01-A 등)을 그대로 쓴다. DM_PLN_CFM_SELLING_PRICE 도
    --   '-' 와 실제값이 섞여 있다(40 실측 '-' 950,621 / 실제값 600,783).
    --   그 결과 같은 사업 키인데 이 한 컬럼만 엇갈려 1차가 매칭되지 않고,
    --   단가(Unit Price)에는 통화가 보이는데 RTF/MKT FCST/SCM FCST 는 CURRENCY 가 빈다.
    --   (ZIOUI1 실증 2026-09-18 — 40 Current: MIF489266C11/NT_CN_SZX 등 3키, 수요 NJ01-A vs 단가 '-')
    --
    --   통화는 판매가의 속성이라 생산 셀 사이트와 무관하다. 다만 1차는 원문 그대로 두고,
    --   **1차 후에도 비어 있는 행만** 8키로 메운다(비파괴 — 이미 채워진 값은 건드리지 않음).
    --   HAVING COUNT(DISTINCT CURRENCY) = 1 : 8키 안에서 통화가 갈리는 키는 제외해 오배정을 차단한다.
    -- ====================================================================================================
    MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    USING (
               -- [E20260918-CURRNULLKEY] 조인키 NULL 정규화 — 원장별로 센티널이 NULL / '-' 로 갈린다
               --   (클라우드 실증: 수요·실적 PLANT_SITE_ID = NULL, 단가 = '-')
               --   MERGE ON 은 NULL 이면 UNKNOWN 이라 매칭 자체가 불가하므로 USING 과 ON 을 함께 정규화한다.
               SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID
                    , NVL(PROJECT_CODE, '/') AS PROJECT_CODE
                    , NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID
                    , NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID
                    , NVL(ITEM_ID, '/') AS ITEM_ID
                    , NVL(INCOTERMS, '/') AS INCOTERMS
                    , NVL(DOM_EXP, '/') AS DOM_EXP
                    , NVL(FCST_TYPE, '/') AS FCST_TYPE
                    , MIN(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    CURRENCY IS NOT NULL
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY NVL(DIVISION_ID, '/')
                    , NVL(PROJECT_CODE, '/')
                    , NVL(SCM_SITE_ID, '/')
                    , NVL(PLANT_SITE_ID, '/')
                    , NVL(ITEM_ID, '/')
                    , NVL(INCOTERMS, '/')
                    , NVL(DOM_EXP, '/')
                    , NVL(FCST_TYPE, '/')
               HAVING COUNT(DISTINCT CURRENCY) = 1
           ) B
    ON (    NVL(A.DIVISION_ID, '/') = B.DIVISION_ID
        AND NVL(A.PROJECT_CODE, '/') = B.PROJECT_CODE
        AND NVL(A.SCM_SITE_ID, '/') = B.SCM_SITE_ID
        AND NVL(A.PLANT_SITE_ID, '/') = B.PLANT_SITE_ID
        AND NVL(A.ITEM_ID, '/') = B.ITEM_ID
        AND NVL(A.INCOTERMS, '/') = B.INCOTERMS
        AND NVL(A.DOM_EXP, '/') = B.DOM_EXP
        AND NVL(A.FCST_TYPE, '/') = B.FCST_TYPE )
    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;

    -- ====================================================================================================
    -- [E20260918-CURRSITEITEM] CURRENCY 3차 보완 — DIV+SITE+ITEM+DOM_EXP+FCST_TYPE 폴백
    --
    --   2차(8키)로도 못 메우는 케이스가 있다. 수요 원장과 단가 원장 사이에서 어긋나는 컬럼이
    --   CELL_PROD_SITE_ID 하나가 아니라 INCOTERMS·PROJECT_CODE·PLANT_SITE_ID 로도 갈리기 때문이다.
    --   실증(ZIOUI1 2026-09-18) 40 / Varta RO_RO_OTP / MCCM131012A1 —
    --     수요 INCOTERMS=CIF·PROJECT=Varta 인데 단가는 CIP(Varta) / CIF(VARTA(Vacuum)) 뿐.
    --     그럼에도 이 ITEM+SITE 의 단가는 전부 USD 단일이다.
    --
    --   실측(DIV 40 LOC): 통화가 2종 이상인 축 비율 = 8키 0.3% / 본 축 1.5% / DIV+SITE 10.0%.
    --   본 축까지만 완화하고, 갈리는 키는 HAVING 으로 제외해 오배정을 차단한다.
    --   1·2차 후에도 비어 있는 행만 채운다(비파괴).
    -- ====================================================================================================
    MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    USING (
               -- [E20260918-CURRNULLKEY] 조인키 NULL 정규화 (2차와 동일 사유)
               SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID
                    , NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID
                    , NVL(ITEM_ID, '/') AS ITEM_ID
                    , NVL(DOM_EXP, '/') AS DOM_EXP
                    , NVL(FCST_TYPE, '/') AS FCST_TYPE
                    , MIN(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    CURRENCY IS NOT NULL
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY NVL(DIVISION_ID, '/')
                    , NVL(SCM_SITE_ID, '/')
                    , NVL(ITEM_ID, '/')
                    , NVL(DOM_EXP, '/')
                    , NVL(FCST_TYPE, '/')
               HAVING COUNT(DISTINCT CURRENCY) = 1
           ) B
    ON (    NVL(A.DIVISION_ID, '/') = B.DIVISION_ID
        AND NVL(A.SCM_SITE_ID, '/') = B.SCM_SITE_ID
        AND NVL(A.ITEM_ID, '/') = B.ITEM_ID
        AND NVL(A.DOM_EXP, '/') = B.DOM_EXP
        AND NVL(A.FCST_TYPE, '/') = B.FCST_TYPE )
    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- LOC/KRW Unit Price 계산 — MKT_AMT / RTF_SYS_RP
    -- ====================================================================================================

    /* 2026.08.15 AJS 신뢰도검사 발견3 — MSSQL 원본은 이 계산을 버전 분기(CURRENT/MF/SP/SF) 안에서 수행한다.
       CURRENT/MF/SF 세 블록은 아래 공통형과 동일하므로 묶어서 유지하고, 구조가 다른 SP 는 뒤에서 따로 계산한다. */
    IF p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%'
       OR p_version_type LIKE '%MF%' OR p_version_type LIKE '%SF%' THEN
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
    -- LOC/KRW Unit Price
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
         , CASE D.MEASURE
               WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                    THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                       / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                    ELSE 0 END
               WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                    THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                       / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                    ELSE 0 END
           END AS QTY
         , MAX(D.MEASURE_GROUP)
         , MAX(A.CELL_MODEL), MAX(A.NICK_NAME), MAX(A.DMS_SALES), MAX(A.DMS_CUSTOMER)
         , MAX(A.OWNER), MAX(A.DEPT_ID), MAX(A.DEPT_NAME_KO)
         , MAX(A.FORECAST_INFO_CELL_PACK_COUNT), MAX(A.ITEM_TYPE)
         , MAX(A.PROJECT_NAME), MAX(A.PROJECT_OWNER), MAX(A.BIZ_TYPE)
         , MAX(A.SOLDTO_CUSTOMER), MAX(A.COUNTRY_NAME), MAX(A.CITY_NAME)
         , MAX(A.PROJECT_STATUS), MAX(A.ITEM_NAME), MAX(A.VMI_YN)
         , MAX(A.CUST_GROUP), MAX(A.CUST_GROUP_DTL), MAX(A.APPLICATION)
         , MAX(A.ROUTE), MAX(A.MDM_PROJECT_NAME), MAX(A.MIN_CAPACITY)
         , MAX(A.FORECAST_INFO_BIZ_TYPE), MAX(A.CELL_TYPE)
         , MAX(A.FORECAST_INFO_ALL), MAX(A.FORECAST_INFO_SPEC)
         , MAX(A.FORECAST_INFOR_VERSION), MAX(A.CELL_MODEL_NICK_NAME)
         , MAX(A.CELL_PER_CAR), MAX(A.CELL_PER_MODULE), MAX(A.MODULE_PER_CAR)
         , MAX(D.SORT_ORDER_NO), MAX(A.ENERGE), MAX(A.CELL_QUANTITY)
         , NVL(MAX(A.AS_FROM_SITE), ' '), MAX(A.CREATE_DATE), MAX(A.LAST_UPDATED_BY)
         , MAX(A.SENDER_CODE), MAX(A.SENDER_NAME), MAX(A.PROJECT_S_OP_REPORT)
         , MAX(A.CURRENCY), A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    JOIN   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
    WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
    AND    A.YYYYMMDD >= p_from_yyyymmdd
    AND    A.YYYYMMDD < V_TO_RESULT
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    UNION ALL
    -- FCST_GAP = MKT_FCST - SCM_FCST
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
         , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
         , MAX(D.MEASURE_GROUP)
         , MAX(A.CELL_MODEL), MAX(A.NICK_NAME), MAX(A.DMS_SALES), MAX(A.DMS_CUSTOMER)
         , MAX(A.OWNER), MAX(A.DEPT_ID), MAX(A.DEPT_NAME_KO)
         , MAX(A.FORECAST_INFO_CELL_PACK_COUNT), MAX(A.ITEM_TYPE)
         , MAX(A.PROJECT_NAME), MAX(A.PROJECT_OWNER), MAX(A.BIZ_TYPE)
         , MAX(A.SOLDTO_CUSTOMER), MAX(A.COUNTRY_NAME), MAX(A.CITY_NAME)
         , MAX(A.PROJECT_STATUS), MAX(A.ITEM_NAME), MAX(A.VMI_YN)
         , MAX(A.CUST_GROUP), MAX(A.CUST_GROUP_DTL), MAX(A.APPLICATION)
         , MAX(A.ROUTE), MAX(A.MDM_PROJECT_NAME), MAX(A.MIN_CAPACITY)
         , MAX(A.FORECAST_INFO_BIZ_TYPE), MAX(A.CELL_TYPE)
         , MAX(A.FORECAST_INFO_ALL), MAX(A.FORECAST_INFO_SPEC)
         , MAX(A.FORECAST_INFOR_VERSION), MAX(A.CELL_MODEL_NICK_NAME)
         , MAX(A.CELL_PER_CAR), MAX(A.CELL_PER_MODULE), MAX(A.MODULE_PER_CAR)
         , MAX(D.SORT_ORDER_NO), MAX(A.ENERGE), MAX(A.CELL_QUANTITY)
         , NVL(MAX(A.AS_FROM_SITE), ' '), MAX(A.CREATE_DATE), MAX(A.LAST_UPDATED_BY)
         , MAX(A.SENDER_CODE), MAX(A.SENDER_NAME), MAX(A.PROJECT_S_OP_REPORT)
         , MAX(A.CURRENCY), A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , 'INTEGER' AS NOTATION
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    JOIN   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
    WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD;

    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */
    END IF;

    IF p_version_type LIKE '%SP%' THEN

    /* 2026.08.15 AJS 신뢰도검사 발견3 — SP 버전 전용 Unit Price 계산 (MSSQL 원본 4029~4241 등가).
       원본은 버전 분기마다 2차 파생 INSERT 를 두었고 CURRENT/MF/SF 세 블록은 위 공통형과 동일하나
       SP 블록만 RTF_SYS_RP 집계(A) 에 MKT_AMT_LOC(B)/MKT_AMT_KRW(C) 를 LEFT JOIN 하는 구조이며
       FCST_GAP UNION ALL 이 없다. 통합 1회 수행하던 것을 원본대로 분리한다.
       ※ C 조인에 VERSION_NO/CUTOFF_YYYYMMDD 가 없는 것은 원본(4218~4229) 그대로임. */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
    SELECT A.DIVISION_ID
         , A.PROJECT_CODE
         , A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.DOM_EXP
         , A.FCST_TYPE
         , A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID
         , A.CELL_PROD_SITE_ID
         , A.YYYYMMDD
         , CASE D.MEASURE
               WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END  /* B.QTY = MKT_AMT_LOC, A.QTY = RTF_SYS_RP */
               WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END  /* C.QTY = MKT_AMT_KRW, A.QTY = RTF_SYS_RP */
           END AS QTY
         , D.MEASURE_GROUP
         , A.CELL_MODEL, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
         , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.BIZ_TYPE
         , A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN
         , A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY
         , A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC
         , A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE
         , A.MODULE_PER_CAR
         , D.SORT_ORDER_NO
         , A.ENERGE, A.CELL_QUANTITY
         --[E20260825-AFSNVL] 조회 전 투영 AS_FROM_SITE = NVL(x,' ') 통일 (사용자 지시 2026-08-25)
         , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
         , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
         , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
         , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
         , B.CURRENCY
         , A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
    FROM   ( SELECT
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , MAX(A.CELL_MODEL) AS CELL_MODEL
                     , MAX(A.NICK_NAME) AS NICK_NAME
                     , MAX(A.DMS_SALES) AS DMS_SALES
                     , MAX(A.DMS_CUSTOMER) AS DMS_CUSTOMER
                     , MAX(A.OWNER) AS OWNER
                     , MAX(A.DEPT_ID) AS DEPT_ID
                     , MAX(A.DEPT_NAME_KO) AS DEPT_NAME_KO
                     , MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                     , MAX(A.ITEM_TYPE) AS ITEM_TYPE
                     , MAX(A.PROJECT_NAME) AS PROJECT_NAME
                     , MAX(A.PROJECT_OWNER) AS PROJECT_OWNER
                     , MAX(A.BIZ_TYPE) AS BIZ_TYPE
                     , MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
                     , MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
                     , MAX(A.CITY_NAME) AS CITY_NAME
                     , MAX(A.PROJECT_STATUS) AS PROJECT_STATUS
                     , MAX(A.ITEM_NAME) AS ITEM_NAME
                     , MAX(A.VMI_YN) AS VMI_YN
                     , MAX(A.CUST_GROUP) AS CUST_GROUP
                     , MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL
                     , MAX(A.APPLICATION) AS APPLICATION
                     , MAX(A.ROUTE) AS ROUTE
                     , MAX(A.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
                     , MAX(A.MIN_CAPACITY) AS MIN_CAPACITY
                     , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
                     , MAX(A.CELL_TYPE) AS CELL_TYPE
                     , MAX(A.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
                     , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
                     , MAX(A.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
                     , MAX(A.CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME
                     , MAX(A.CELL_PER_CAR) AS CELL_PER_CAR
                     , MAX(A.CELL_PER_MODULE) AS CELL_PER_MODULE
                     , MAX(A.MODULE_PER_CAR) AS MODULE_PER_CAR
                     , MAX(A.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , MAX(A.ENERGE) AS ENERGE
                     , MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
                     , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE) AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                     , MAX(A.SENDER_CODE) AS SENDER_CODE
                     , MAX(A.SENDER_NAME) AS SENDER_NAME
                     , MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
                FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
    LEFT JOIN ( SELECT
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE      = B.PROJECT_CODE
                    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                    AND A.ITEM_ID           = B.ITEM_ID
                    AND A.INCOTERMS         = B.INCOTERMS
                    AND A.DOM_EXP           = B.DOM_EXP
                    AND A.FCST_TYPE         = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD          = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
    LEFT JOIN ( SELECT
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE      = C.PROJECT_CODE
                    AND A.SCM_SITE_ID       = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID     = C.PLANT_SITE_ID
                    AND A.ITEM_ID           = C.ITEM_ID
                    AND A.INCOTERMS         = C.INCOTERMS
                    AND A.DOM_EXP           = C.DOM_EXP
                    AND A.FCST_TYPE         = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD          = C.YYYYMMDD
                    AND A.QTY <> 0 )
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
    WHERE  (CASE D.MEASURE
                WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
            END) IS NOT NULL;

    END IF;

    -- ====================================================================================================
    -- [PJ2025-50188] Unit Price 계산에 사용된 보조 메저 삭제
    -- ====================================================================================================

    -- [E20260907-PERF1] 구 EXISTS 상관 서브쿼리 → IN 리스트(비상관) 재작성 (사용자 지시 2026-09-07).
    --   등가: MEASURE 동등비교라 NULL 매칭이 양쪽 다 없다 → 결과 동일.
    --   [hook#150 2026-09-06 AJS] AS-IS:
    --     DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    --     WHERE EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
    --                    WHERE B.MEASURE = A.MEASURE AND B.USER_ID = 'DM_ADMIN' );
    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    WHERE  A.MEASURE IN (
               SELECT B.MEASURE
               FROM   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
               WHERE  B.USER_ID = 'DM_ADMIN'
           );

        -- ====================================================================================================
    -- [E20260831-QTYKEY] QTY 필터 이설 — 구 `DELETE WHERE QTY = 0`(셀 단위)은 결함:
    --   키의 타 메저 행이 남아 그리드 행이 그대로 조회됨(통합테스트 40 실측 — 체크해도 건수 동일).
    --   AS-IS 1:1 9축 키 필터로 교체, 위치 = 조회조건 필터·중복 제거 이후(CUSTSUBORPH 직전) 참조.
    -- ====================================================================================================
    -- ====================================================================================================
    -- [PLANT_SITE 2026-08-04] 조회조건 Plant Site 필터 (81 전용 — FE 40/82 비활성 = 'ALL')
    --   스테이징 완료 후 GTT 단일 지점 필터 (measure 분기별 술어 살포 대신 — 누락 0 보장, DMF0082 SAVE 팝업 동일 split 함수)
    -- ====================================================================================================

        /* [E20260819-MULTIJOIN] 조회조건 SCM Site — 구 스테이징 INSERT 별 인라인 OR분기(REGEXP 분해 20지점)를
       PLANT_SITE 동형의 스테이징 후 단일 지점 GTT+NOT EXISTS 로 통합(그레인에 SCM_SITE_ID 포함 — 파생 메저 GROUP BY 실측, 최종 내용 동일). */
    IF p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_scm_site_id'
                   AND    T.TOKEN    = F.SCM_SITE_ID);
    END IF;

    IF p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  PLANT_SITE_ID NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id'));
    END IF;

    -- ====================================================================================================
    -- [UICATEGORY 2026-08-07] 조회조건 Project / Owner / Sender Code 필터 (PLANT_SITE 동형 — 스테이징 후 단일 지점)
    -- ====================================================================================================

    IF p_project_code IS NOT NULL AND p_project_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(PROJECT_CODE, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_project_code'));
    END IF;

    IF p_owner IS NOT NULL AND p_owner <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(OWNER, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_owner'));
    END IF;

    /* [E20260819-SENDERJOIN] Sender Code 필터 = 실적용 (2026-08-19 사용자 재확정 — 구 2026-08-07 "무값 행 통과" 예외 폐기).
       p_sender_code 지정 시 선택 코드 보유 행만 잔존: GTT 선적재 토큰([E20260815-SPLIT2GTT])과 NOT EXISTS 세트 연산.
       SENDER_CODE 는 양변 원문 비교 — ALL_TAB_COLUMNS 실측 NULLABLE='Y'(2026-08-19, 센티널 '-' 관례 아님)이고
       무값(NULL) 행은 매칭 실패=삭제가 의도. hook #119 §1.5 NVL('-') 양변 정규화는 NOT NULL 센티널 컬럼 한정이라 미적용. */
    IF p_sender_code IS NOT NULL AND p_sender_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_sender_code'
                   AND    T.TOKEN    = F.SENDER_CODE);
    END IF;

    -- ====================================================================================================
    -- [TEAMFILTER 2026-08-11] 조회조건 Team(deptId) 필터 — 통합테스트 1st No.37 (+실측 N-1)
    --   p_team_id 가 로그에만 쓰이고 필터 지점이 없어 팀 지정이 무시되던 결함. PLANT_SITE 동형.
    -- ====================================================================================================

    IF p_team_id IS NOT NULL AND p_team_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(DEPT_ID, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_team_id'));



    END IF;

        /* [E20260820-SENTINELDDL] 구 [E20260815-SENTINEL] PLANT_SITE_ID 변형 정규화 UPDATE 삭제 —
       원장 일괄 정규화('-')·중복 제거 + DEFAULT ON NULL '-' DDL + 변형 기록 배치 정규화 완료(사용자 확인
       2026-08-20)로 변형(' '/'-'/'--'/CHR(0))이 원천 소멸. 아래 중복 제거 DELETE 는 안전망으로 존치. */

        /* 정규화로 같아진 행 중 1건만 남긴다. 상관 서브쿼리 대신 ROW_NUMBER 로 set-based 처리
       (진단·정정 SQL 도 튜닝 품질 유지).
       ⭐ 남길 행 = **QTY 최대** (사용자 확정 B, 2026-08-15). 값이 같은 그룹은 어느 행이 남아도
         동일하고, 다른 그룹(실측 16,395)만 최대값이 채택된다.
       ⛔ SUM 은 채택하지 않았다 — 동일 복제본이 다수(88%)라 합산하면 그만큼 3배가 된다. */
        --[E20260930-DMF0082QRYPERF-DEDUPCHK] 중복 존재 시에만 안전망 DELETE (0행 삭제에 전량 윈도정렬 비용 제거)
        SELECT COUNT(*) INTO V_QPT_DUP_CNT FROM (
            SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
            GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
            HAVING COUNT(*) > 1) WHERE ROWNUM = 1;
        IF V_QPT_DUP_CNT > 0 THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
         WHERE ROWID IN (SELECT RID
                     FROM  (SELECT ROWID AS RID,
                                   ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
                                                      ORDER BY QTY DESC NULLS LAST, ROWID) AS RN
                            FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE)
                     WHERE RN > 1);
        END IF;


    -- ====================================================================================================

    -- ====================================================================================================
    /* [E20260831-QTYKEY] Qty >= 0 체크(p_qty_yn='Y') = AS-IS DMF0082_GET_MAIN_DATA L5890~ 1:1.
       구 구현(셀 단위 QTY=0 DELETE)은 키의 타 메저 행이 남아 필터가 무효였다(통합테스트 40: 7,668건 불변).
       정본 의미 = **9축 키 단위**: MEASURE IN ('MKT_FCST','SCM_FCST') 의 SUM(QTY) <> 0 인 키만 잔존
       (그 키의 전 메저 행 유지 — AS-IS #MF_SP DELETE NOT EXISTS 동형).
       동형 정본 = 본 PKG P_DMF0082_GET_MAIN_DATA_CURRENT 의 p_qty_yn 블록(변환 시 이 proc 만 단순화된 결함).
       위치 = 조회조건 필터·중복 제거 이후(AS-IS 는 전 필터 완료된 #MF_SP 최종 단계) — CUSTSUBORPH 앞
       (모행이 여기서 잘린 CUST 종속 메저는 아래 안전망이 함께 제거). 등호 비교 = AS-IS 파리티. */
    -- ====================================================================================================
    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE SP
        WHERE  NOT EXISTS (SELECT 1
                           FROM  (SELECT DIVISION_ID
                                       , SCM_SITE_ID
                                       , PROJECT_CODE
                                       , ITEM_ID
                                       , INCOTERMS
                                       , FCST_TYPE
                                       , DOM_EXP
                                       , END_CUSTOMER
                                       , CELL_PROD_SITE_ID
                                  FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                                  WHERE  MEASURE IN ('MKT_FCST','SCM_FCST')
                                  GROUP BY DIVISION_ID
                                       , SCM_SITE_ID
                                       , PROJECT_CODE
                                       , ITEM_ID
                                       , INCOTERMS
                                       , FCST_TYPE
                                       , DOM_EXP
                                       , END_CUSTOMER
                                       , CELL_PROD_SITE_ID
                                  HAVING SUM(QTY) <> 0
                                 ) TT
                           WHERE  1 = 1
                           AND    TT.DIVISION_ID       = SP.DIVISION_ID
                           AND    TT.SCM_SITE_ID       = SP.SCM_SITE_ID
                           AND    TT.PROJECT_CODE      = SP.PROJECT_CODE
                           AND    TT.ITEM_ID           = SP.ITEM_ID
                           AND    TT.INCOTERMS         = SP.INCOTERMS
                           AND    TT.FCST_TYPE         = SP.FCST_TYPE
                           AND    TT.DOM_EXP           = SP.DOM_EXP
                           AND    TT.END_CUSTOMER      = SP.END_CUSTOMER
                           AND    TT.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
                          );
    END IF;

    /* [E20260826-CUSTSUBORPH] CUST 종속 메저 고아 행 제외 (사용자 지시 2026-08-26 — 클라우드 실측).
       증상: 모 CUST_FCST 행이 없는 그리드 키에 └ 종속 메저(EDI/Commercial_Agreement 등)만 조회.
       원인: [E20260826-CUSTSUBR] 실적 arm(DM_PLN_MKT_FCST_RESULT)이 모행 없는 키의 종속 실적까지 적재
       (클라우드 원장에만 해당 조합 존재 — 사내 실측 고아 0·클라우드 적용 직후 발현).
       AS-IS 파리티 실측(FcstPrice_20260826_102207_ASIS.xlsx): 종속 키 81 = 모행 키 81, 고아 0.
       위치 = 조회조건 필터·중복 제거 이후(최종 pivot 직전) — 필터로 모행만 잘린 케이스도 동일 규칙.
       키 = 그리드 행 식별 축(파일 대사 키와 동일 10축). 양변 NVL 정규화(hook #119 §1.5). arm 불문 안전망. */
    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
    WHERE  F.MEASURE_GROUP = 'CUST_FCST'
    AND    F.MEASURE      <> 'CUST_FCST'
    AND    NOT EXISTS (
               SELECT 1
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE P
               WHERE  P.MEASURE = 'CUST_FCST'
               AND    NVL(P.DIVISION_ID,  ' ') = NVL(F.DIVISION_ID,  ' ')
               AND    NVL(P.PROJECT_CODE, ' ') = NVL(F.PROJECT_CODE, ' ')
               AND    NVL(P.END_CUSTOMER, ' ') = NVL(F.END_CUSTOMER, ' ')
               AND    NVL(P.SCM_SITE_ID,  ' ') = NVL(F.SCM_SITE_ID,  ' ')
               AND    NVL(P.ITEM_ID,      ' ') = NVL(F.ITEM_ID,      ' ')
               AND    NVL(P.DOM_EXP,      ' ') = NVL(F.DOM_EXP,      ' ')
               AND    NVL(P.FCST_TYPE,    ' ') = NVL(F.FCST_TYPE,    ' ')
               AND    NVL(P.INCOTERMS,    ' ') = NVL(F.INCOTERMS,    ' ')
               AND    NVL(P.PLANT_SITE_ID,'/') = NVL(F.PLANT_SITE_ID,'/')
               AND    NVL(P.AS_FROM_SITE, ' ') = NVL(F.AS_FROM_SITE, ' '));

    -- C_TITLE 커서 — 동적 컬럼 목록 생성
    -- ====================================================================================================

    V_COLUMN  := '';
    V_GROUPBY := '';
    V_ORDERBY := '';

    OPEN C_TITLE;
    LOOP
        FETCH C_TITLE INTO V_CUR_PROGRAM_ID, V_CUR_SHEET_NAME, V_CUR_COLUMN_NAME, V_CUR_SORT_ORDER_NO;
        EXIT WHEN C_TITLE%NOTFOUND;
        IF V_COLUMN IS NULL THEN
            V_COLUMN  := V_CUR_COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, ' || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN V_CUR_COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || V_CUR_COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := V_ORDERBY || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' || V_CUR_COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;
    CLOSE C_TITLE;

    --[E20240812-000094] NOTATION 컬럼 추가
    -- C_TITLE 0행일 때 V_COLUMN NULL 방어 (leading comma 방지로 ORA-00936 회피)
    V_COLUMN  := CASE WHEN V_COLUMN  IS NULL THEN 'NOTATION'              ELSE V_COLUMN  || ', NOTATION' END;
    V_GROUPBY := CASE WHEN V_GROUPBY IS NULL THEN ' GROUP BY EDIT_FLAG, SORT_ORDER_NO' ELSE V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO' END;

    --[E20260822-KEYCOL] 저장 키 컬럼은 Column Setting 과 무관하게 항상 반환한다 (사용자 승인 A안, 2026-08-22).
    --  C_TITLE 는 SCM_MST_TITLESET_USER('C') 를 읽으므로 사용자가 키 컬럼을 숨기면 GET 이 값을 안 준다.
    --  그러면 FE 가 '' 를 보내 ①검증이 Common 으로 오판(수정 차단) ②MERGE ON 키 불일치(중복행) 가 난다.
    --  실측: CELL_PROD_SITE_ID 를 숨긴 계정에서 기존 행 M 저장이
    --        'Cell Prod Site* 를 Common으로 등록 할 수 없습니다' 로 차단됨.
    --  키 목록 = SAVE MERGE ON 절 + FE save.ts keyOf. 이미 있으면 넣지 않는다(멱등).
    --  ⚠ V_GROUPBY 에도 넣어야 한다 — SELECT 목록에만 넣으면 ORA-00979.
    FOR K IN (SELECT REGEXP_SUBSTR('DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,CURRENCY', '[^,]+', 1, LEVEL) AS C
                FROM DUAL
             CONNECT BY REGEXP_SUBSTR('DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,CURRENCY', '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
        IF INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',' || K.C || ',') = 0 THEN
            V_COLUMN  := V_COLUMN  || ', ' || K.C;
            V_GROUPBY := V_GROUPBY || ', ' || K.C;
        END IF;
    END LOOP;

    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

    --[E20260901-MEASORDER] 메저 표시 순서 = MEASURE MODAL 선택 순서 보장 (사용자 지시 2026-09-01).
    --   결함: 위 두 REPLACE 는 사용자 컬럼목록(titleset 'C')에 MEASURE_GROUP 이 있을 때만 정렬키가 남는다.
    --   실측(사내·AS-IS 양쪽) C 목록에 MEASURE_GROUP 부재 → 치환 무발생 + ', MEASURE' 제거만 실행되어
    --   ORDER BY 에서 **메저 정렬 기준이 소실**(표시 순서 비결정 = 사용자 신고 '순서 혼합').
    --   정정: 정렬키 부재 시 titleset 'M' 순번(SORT_ORDER_NO — 모달 선택 순서 그대로 저장됨)을 말미에 추가.
    --   SORT_ORDER_NO 는 PIVOT 소스 SELECT 에 실재(L4062/4073)하므로 PIVOT 이후 ORDER BY 사용 가능.
    IF INSTR(UPPER(NVL(V_ORDERBY, ' ')), 'SORT_ORDER_NO') = 0 THEN
        IF V_ORDERBY IS NULL OR LENGTH(TRIM(V_ORDERBY)) = 0 THEN
            V_ORDERBY := ' ORDER BY CAST(SORT_ORDER_NO AS NUMBER(10,2))';
        ELSE
            V_ORDERBY := V_ORDERBY || ', CAST(SORT_ORDER_NO AS NUMBER(10,2))';
        END IF;
    END IF;

    -- ====================================================================================================
    -- 권한 그룹 조회
    -- ====================================================================================================

    V_GROUP_ID := '';

    DECLARE
        V_ADMIN_CNT NUMBER;
    BEGIN
        SELECT COUNT(1) INTO V_ADMIN_CNT
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN    = 'Y'
        AND (SEGMENT1 = p_user_group  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
             OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
        AND    SEGMENT2    = 'ALL';

        IF V_ADMIN_CNT > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    END;

    -- ====================================================================================================
    -- TEMP_INTO_GROUP_MEASURE / TEMP_ADMIN_GROUP_MEASURE — 메저별 수정권한
    -- [E20260819-LIMITMEAS] 사용자 승인(2026-08-19): SCM_FCST↔MKT_FCST 동시편집 제약 —
    --   CURRENT(P_DMF0082_GET_MAIN_DATA_CURRENT) 적재부 완전 이식본으로 교체·통일:
    --   ①요일 토큰 전개+당일 요일 필터 ②시간창(ATTRIBUTE2/3) ③LIMIT_MEASURE(ATTRIBUTE4) 강제 'N'.
    --   INTO 스테이징 = CURRENT GTT(GTT_TEMP_INTO_GROUP_MEASURE, 7컬럼 실측) 재사용·사용 후 정리(donor 동일).
    --   구 MAIN 2컬럼 GTT(GT_DMF0082_TEMP_INTO_GROUP_MEASURE) 적재는 소비처가 본 블록 EXISTS 1곳뿐(실측)이라 대체.
    --   O_RC4 계약(MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST)·후속 EDIT_FLAG 판정은 원형 유지 —
    --   EDIT_AUTH_YN 원천만 요일/시간창 반영 INTO 로 교체 + LIMIT 강제 'N' UPDATE 추가.
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;

    --1). GET_ADMIN_GROUP_MEASURE 룩업에서 데이터를 TEMP로 담는다
    --    (CROSS APPLY STRING_SPLIT × 2 → CROSS JOIN LATERAL REGEXP_SUBSTR CONNECT BY)
    --    (C-11) DATEPART(WEEKDAY)/CONVERT(...,24) → TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH') / TO_CHAR(SYSDATE,'HH24MI')
    --    (C-7)  ISNULL(REPLACE(x,' ',''),'')='' 빈값 판정 → REPLACE(x,' ','') IS NULL (빈값 = 제한 없음 = 행 유지)
    INSERT INTO SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE
    ( USER_GROUP, DIVISION_ID, MEASURE, DAYS, FROM_TIME, TO_TIME, LIMIT_MEASURE )
    SELECT B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, LM.TOKEN AS LIMIT_MEASURE
    FROM  (SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS MEASURE, DT.TOKEN AS DAYS
                , A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, A.ATTRIBUTE4 AS LIMIT_MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL) AS TOKEN
                               FROM   DUAL
                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(A.ATTRIBUTE1, ','), 0) + 1) DT
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND (A.SEGMENT1 = p_user_group  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
             OR A.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
           AND    A.SEGMENT2 = VA_PROGRAM_ID
           AND    A.SEGMENT3 = p_division_id
          ) B
    CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL) AS TOKEN
                        FROM   DUAL
                        CONNECT BY LEVEL <= NVL(REGEXP_COUNT(B.LIMIT_MEASURE, ','), 0) + 1) LM
    WHERE (REPLACE(B.DAYS, ' ', '') IS NULL
           OR B.DAYS = TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'))   --일~토 = SUN~SAT
    AND   (REPLACE(B.FROM_TIME, ' ', '') IS NULL
           OR B.FROM_TIME <= TO_CHAR(SYSDATE, 'HH24MI'))
    AND   (REPLACE(B.TO_TIME, ' ', '') IS NULL
           OR B.TO_TIME >= TO_CHAR(SYSDATE, 'HH24MI'));

    -- ====================================================================================================
    -- TEMP_ADMIN_GROUP_MEASURE — 메저별 당일 수정권한 ([E20260819-LIMITMEAS] EDIT_AUTH_YN 원천 = 요일/시간창 반영 INTO)
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE;

    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE (MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST)
    SELECT A.SEGMENT4 AS MEASURE
         , CASE WHEN EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                    WHERE  B.MEASURE = A.SEGMENT4
               ) THEN 'Y'
                --[E20260826-AUTHVIEW] 시간창 因 잠금 구분값 'T' — 보유그룹의 시간창 정의 행(A1 요일)이 있으나
                --  지금이 창 밖이라 INTO 에서 탈락한 경우. FE 는 'Y' 비교라 'T'=잠금 유지, MSG00477 표기에만 사용.
                --  (그룹 미보유 因 잠금 'N' 과 구분 — DM Viewer 등에 시간 메시지 오표기 방지)
                WHEN EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
                    WHERE  T.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                    AND    T.VALID_YN = 'Y'
                    AND   (T.SEGMENT1 = p_user_group
                           OR T.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
                    AND    T.SEGMENT2 = VA_PROGRAM_ID
                    AND    T.SEGMENT3 = p_division_id
                    AND    T.SEGMENT4 = A.SEGMENT4
                    AND    REPLACE(T.ATTRIBUTE1, ' ', '') IS NOT NULL
               ) THEN 'T'
                ELSE 'N' END AS EDIT_AUTH_YN
         , CASE WHEN A.ATTRIBUTE1 IS NOT NULL THEN 'Y' ELSE 'N' END AS TODAY_LIMIT_YN
         , A.ATTRIBUTE1 AS TODAY_DAY_LIST
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND    A.SEGMENT2    = VA_PROGRAM_ID
    GROUP BY A.SEGMENT4, A.ATTRIBUTE1;

    /* [E20260820-MEASRULE] measure 별 입력 게이트 명세 반영 (2026-08-20 PI 테스트 시트 — 사용자 확인 요청):
       - LOC        : 항상 입력 가능 (룩업 그룹 통제 제외 — "Unit Price(LOC) 입력 가능해야 함")
       - AS_In_Req  : 81 계열('81%')·82 + DM Planner (W/S) 소속일 때만 (AUTHUNION 동형 판정)
       - VMI_In_Req : 40·82 + 권한 무관. 행 단위 "Sales Site VMI_YN='Y'" 조건은 행별 후보 콤보
                      FcstPriceEditMeasure + DM_UI_EDITABLE_MEASURE VMI_COND 가 담당(실측 기구현) — 메저 게이트만 개방.
       - MKT_FCST/SCM_FCST : 종전대로 GET_ADMIN_GROUP_MEASURE 룩업 통제(요일/시간창/LIMIT — E20260819-LIMITMEAS).
       신규 division(81_JV 등)은 패턴으로 자동 커버. 근거 실측(2026-08-20): 81_JV 는 룩업·SITE·SITE_ITEM 전부 0행
       (division 프로비저닝 미완) + 순수 W/S 계정은 40 룩업 행 부재로 전 메저 'N' — LIMITMEAS 회귀 아님(구 코드 동일 필터). */
    /* [E20260825-SCPPLOC] SCP Planner = LOC 편집 불가 정정 (사용자 지적 2026-08-25).
       AS-IS 파리티: DMF0082_FcstNPrice_Mgmt.cs L9172 은 bEDIT_AUTH_LOC 을 GET_ADMIN_GROUP_MEASURE
       룽업 결과(Tables[3] MEASURE='LOC' 의 EDIT_FLAG) 그대로 읽고, L9229 case "LOC" 에서
       권한이 없으면 언락하지 않아 셀이 잠긴다. 룽업상 SCP Planner 행은 SCM_FCST(MON 1500~1830) 1건뿐이라
       AS-IS 에서 SCP Planner 는 LOC 를 못 고친다. 위 2026-08-20 measure 게이트 명세의 무조건 개방이 그 통제를
       벗겨 SCP Planner 까지 편집 가능해졌다.
       ⚠ 개방을 통째로 걷어내면 룽업 미프로비저닝 division(81/81_JV/82 = 룽업 0행)까지 잠겨
       원장 REQ:1ST-41-1 / REQ:1ST-63-3 (81 에서 LOC 입력) 이 깨진다 → 두 조건을 모두 만족할 때만 제외한다:
         (1) 해당 division 에 GET_ADMIN_GROUP_MEASURE 룽업이 존재(현재 40) 그리고
         (2) 세션 보유그룹에 'SCP Planner' 포함(AUTHUNION 동형 판정 — 타 그룹 겸유 시는 룽업이 이미 'Y' 부여).
       다른 그룹·다른 메저·다른 division 은 문장 불변(회귀 0). */
    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
    SET    EDIT_AUTH_YN = 'Y'
    WHERE  MEASURE = 'LOC'
    AND  ( NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                       WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                       AND    L.VALID_YN    = 'Y'
                       AND    L.SEGMENT2    = VA_PROGRAM_ID
                       AND    L.SEGMENT3    = p_division_id)   -- 룽업 미프로비저닝 division = 종전 개방 유지
           --[E20260825-81AUTH] 81 계열은 룩업 전권 — 강제 개방 분기에서 제외 (LOC = 룩업 4그룹 통제, W/S 제외).
           --  40 은 현행 유지(비 SCP 강제 개방 — REQ:1ST-36-1 계보).
           OR ( p_division_id NOT LIKE '81%'
                AND NOT ( p_user_group = 'SCP Planner'
                    OR EXISTS (SELECT 1
                               FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                               WHERE  G.USER_ID    IN (p_user_group, p_created_by)
                               AND    G.USER_GR_ID = 'SCP Planner'
                               AND    G.USE_YN     = 'Y') )    -- SCP Planner 미보유 = 종전 개방 유지
                --[E20260826-AUTHVIEW] DM Viewer = 편집 전면 불가 (사용자 지시 2026-08-26) — 강제 개방에서 제외.
                --  AS-IS 파리티: 40 룩업 LOC 4그룹(ADMIN/DM ADMIN/DM Planner/SCM PI Admin)에 Viewer 없음 = bEDIT_AUTH_LOC false.
                --  겸유자(Viewer+편집그룹)는 룩업 INTO 경유 기본 'Y' 라 회귀 없음.
                AND NOT ( p_user_group = 'DM Viewer'
                    OR EXISTS (SELECT 1
                               FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                               WHERE  G.USER_ID    IN (p_user_group, p_created_by)
                               AND    G.USER_GR_ID = 'DM Viewer'
                               AND    G.USE_YN     = 'Y') ) )
         );

    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
    SET    EDIT_AUTH_YN = CASE WHEN (p_division_id LIKE '81%' OR p_division_id = '82')
                                AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                            WHERE G.USER_ID IN (p_user_group, p_created_by)
                                            AND   G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
                               THEN 'Y' ELSE 'N' END
    WHERE  MEASURE = 'AS_In_Req';

    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
    SET    EDIT_AUTH_YN = CASE WHEN p_division_id IN ('40', '82')
                                --[E20260826-AUTHVIEW] DM Viewer 단독(편집그룹 룩업 행 INTO 부재) = VMI 차단 (사용자 지시 2026-08-26).
                                --  겸유자(Viewer+편집그룹)는 INTO 에 그 그룹의 VMI 행이 있어 개방 유지 — 회귀 없음.
                                --[E20260826-SCPVMI] SCP Planner 도 제외 (사용자 지시 2026-08-26 "시간 밖 = 수정·INSERT/DELETE 전면 불가").
                                --  AS-IS 파리티: 40 VMI 룩업 4그룹(ADMIN/DM ADMIN/DM Planner/SCM PI Admin)에 SCP 없음 = bEDIT_AUTH_VMI false.
                                --  겸유자(편집그룹 겸유)는 INTO 에 그 그룹 VMI 행이 있어 개방 유지 — 회귀 없음.
                                AND NOT ( ( p_user_group IN ('DM Viewer', 'SCP Planner')
                                            OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                       WHERE G.USER_ID IN (p_user_group, p_created_by)
                                                       AND   G.USER_GR_ID IN ('DM Viewer', 'SCP Planner') AND G.USE_YN = 'Y') )
                                          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                                                          WHERE B.MEASURE = 'VMI_In_Req') )
                               THEN 'Y' ELSE 'N' END
    WHERE  MEASURE = 'VMI_In_Req';

    --3). [E20260819-LIMITMEAS] LIMIT_MEASURE 존재 시 해당 메저 강제 'N' (donor 이식 — EDIT_FLAG→EDIT_AUTH_YN 컬럼명만 상이)
    /* [E20260907-LIMITMEAS-DIV] LIMIT_MEASURE 잠금 판정 = **division 범위** (사용자 지시 2026-09-07).
       요건 원문 = 본 블록 말미 [E20250729-000433] "월요일 SCM FCST 입력 시 MKT FCST 수정 불가".
       ⛔ 구 판정의 결함: 잠금 근거를 GTT_TEMP_INTO_GROUP_MEASURE(= **내 보유그룹 행만**)에서 찾았다.
          40 의 SCM_FCST(MON 1000~1900, A4=MKT_FCST) 행은 ADMIN/SCM PI Admin/SCP Planner 3그룹에만
          있어서, 그 그룹이 아닌 DM Planner 로 로그인하면 INTO 에 LIMIT_MEASURE 행이 0건 →
          V_LIMIT_CNT=0 → 강제 'N' 이 아예 발동하지 않고 MKT_FCST 가 열린 채 남았다
          (실증 2026-09-07 MON 16:35 · eunah.koo(DM Planner)/40 · INTO 3행 전부 A4 NULL).
       ⭐ 잠금의 주체는 '내 그룹'이 아니라 '이 division 의 SCM_FCST 입력 시간창'이므로
          SEGMENT1(그룹) 조건을 빼고 (SEGMENT2, SEGMENT3) 범위로 판정한다. 요일·시간창 판정식은
          위 INTO 적재분과 **동일**(빈값 = 제한 없음)이라 그룹 축만 넓힌 변경이다.
       ⚠ 81 계열의 ATTRIBUTE4 는 '메저명'이 아니라 잠금 유발 **그룹명**('SCP Planner')이다
          ([E20260825-81AUTH], 아래 블록 담당) → 토큰이 같은 division 의 SEGMENT1(그룹명)과
          일치하면 이 해석에서 제외한다. 두 해석은 상호배타.
       실측(2026-09-07): DMF0082 의 A4 보유행은 전 division 이 SCM_FCST→'MKT_FCST' 21행뿐이고
          그룹명 토큰은 0건이라, 이 정정의 실효 = "SCM_FCST 시간창 동안 MKT_FCST 전원 잠금". */
    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE A
    SET    A.EDIT_AUTH_YN = 'N'
    WHERE  EXISTS (SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                   CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(L.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS TOKEN
                                       FROM   DUAL
                                       CONNECT BY LEVEL <= NVL(REGEXP_COUNT(L.ATTRIBUTE4, ','), 0) + 1) LM
                   WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                   AND    L.VALID_YN    = 'Y'
                   AND    L.SEGMENT2    = VA_PROGRAM_ID
                   AND    L.SEGMENT3    = p_division_id
                   AND    REPLACE(L.ATTRIBUTE4, ' ', '') IS NOT NULL
                   AND   (REPLACE(L.ATTRIBUTE1, ' ', '') IS NULL          -- 요일 미지정 = 상시
                          OR INSTR(',' || REPLACE(L.ATTRIBUTE1, ' ', '') || ',',
                                   ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0)
                   AND   (REPLACE(L.ATTRIBUTE2, ' ', '') IS NULL
                          OR L.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI'))
                   AND   (REPLACE(L.ATTRIBUTE3, ' ', '') IS NULL
                          OR L.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI'))
                   AND    TRIM(LM.TOKEN) = A.MEASURE
                   AND    NOT EXISTS (SELECT 1                            -- 토큰=그룹명 → 81AUTH 해석
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L3
                                      WHERE  L3.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                                      AND    L3.VALID_YN    = 'Y'
                                      AND    L3.SEGMENT2    = VA_PROGRAM_ID
                                      AND    L3.SEGMENT3    = p_division_id
                                      AND    L3.SEGMENT1    = TRIM(LM.TOKEN)));


    /* [E20260825-81AUTH] LIMIT_AUTH(그룹 잠금) 해석 — AS-IS DMF0003 판 의미 이식 (사용자 확정 2026-08-25).
       81 계열 룩업 행의 ATTRIBUTE4 는 "메저명"이 아니라 **잠금 유발 권한그룹명**('SCP Planner')이다:
       그 그룹의 같은 (S2,S3,S4) 행이 지금 요일·시간창 안이면 내 메저는 편집 불가.
       (원형 = PKG_DMF0003 AUTHGATE L10270~10296. 40 의 LIMIT_MEASURE(메저 잠금)과 공존 —
        A4 값이 그룹 행(SEGMENT1)과 매칭될 때만 발동. 40 의 'MKT_FCST' 토큰은 그룹 미매칭 = 영향 0.)
       합집합(AUTHUNION) 보존 — 보유그룹 행 중 잠기지 않은 행이 하나라도 있으면 Y 유지.
       ⚠ 한계: A4 가 콤마 다중 그룹이면 토큰별 개별 판정(현 데이터 = 단일 'SCP Planner' 뿐). */
    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE A
    SET    A.EDIT_AUTH_YN = 'N'
    WHERE  A.EDIT_AUTH_YN = 'Y'
    AND    EXISTS (SELECT 1 FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B WHERE B.MEASURE = A.MEASURE)
    AND    NOT EXISTS (
             SELECT 1
             FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
             WHERE  B.MEASURE = A.MEASURE
             AND    NOT EXISTS (
                      SELECT 1
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                      WHERE  L2.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                      AND    L2.VALID_YN    = 'Y'
                      AND    L2.SEGMENT2    = VA_PROGRAM_ID
                      AND    L2.SEGMENT3    = p_division_id
                      AND    L2.SEGMENT4    = B.MEASURE
                      AND    L2.SEGMENT1    = B.LIMIT_MEASURE   -- LIMIT 토큰 = 그룹명일 때만 발동
                      AND    REPLACE(L2.ATTRIBUTE1, ' ', '') IS NOT NULL  -- 시간창 정의 행만
                      AND    INSTR(',' || REPLACE(L2.ATTRIBUTE1, ' ', '') || ',',
                                   ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0
                      AND    L2.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI')
                      AND    L2.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI')));

    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -- ====================================================================================================
    -- CAL_MONTH_END_DATE / CAL_WEEK_END_DATE
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_CAL_MONTH_END_DATE;
    DELETE FROM SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE;

    INSERT INTO SCM_MGR.GT_DMF0082_CAL_MONTH_END_DATE (BASIS_YYYYMM, MONTH_END_DATE, M3_CUTOFF_DATE)
    SELECT A.BASIS_YYYYMM
         , MAX(A.BASIS_YYYYMMDD) AS MONTH_END_DATE
         , TO_CHAR(ADD_MONTHS(TO_DATE(MIN(A.BASIS_YYYYMMDD),'YYYYMMDD'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE (ISO_WEEK, BASIS_YYYYMM, WEEK_END_DATE, M3_CUTOFF_DATE)
    SELECT A.ISO_WEEK
         , A.BASIS_YYYYMM
         , MAX(A.BASIS_YYYYMMDD) AS WEEK_END_DATE
         , TO_CHAR(ADD_MONTHS(TO_DATE(MIN(A.BASIS_YYYYMMDD),'YYYYMMDD'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.ISO_WEEK, A.BASIS_YYYYMM;

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_CAL_MONTH_END_DATE', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)
    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_CAL_WEEK_END_DATE',  NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -- ====================================================================================================
    -- MF_SP — 동적 PIVOT 대상 기본 데이터 구성
    -- BUCKET_CONVERSION PIVOT: MSSQL PIVOT(MAX(BUCKET_PER) FOR YYYYMMDD IN (SUN,MON,...))
    --   → Oracle PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD IN ('SUN' AS SUN,'MON' AS MON,...))
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_MF_SP;

    INSERT /*[E20260812-PERF] APPEND PARALLEL 제거 — GTT 직로드가 enq:KO 체크포인트 대기 유발(ASH 50샘플)*/ INTO SCM_MGR.GT_DMF0082_MF_SP
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, BUCKET_TYPE, BUCKET_KEY, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION, EDIT_FLAG, SORT_KEY, GROUP_ID
    , SUN, MON, TUE, WED, THU, FRI, SAT
    , YYYYMM, YYYYMMWW, WEEK_END_YN, MONTH_END_YN
    , NEW_FLAG, AS_YN, VMI_STD_DIO)  --[E20260930-DMF0082QRYPERF-VMI82FOLD] VMI_STD_DIO INSERT 흡수 / --[E20260812-PERF] 전행 UPDATE 2회(redo/log 대기 93샘플) INSERT 시점 흡수
    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
         , F.CELL_PROD_SITE_ID
         , CAL.BUCKET_TYPE
         , CAL.BUCKET_KEY
         , SUM(F.QTY) AS QTY
         , MAX(F.MEASURE_GROUP)
         , MAX(F.CELL_MODEL), MAX(F.NICK_NAME), MAX(F.DMS_SALES), MAX(F.DMS_CUSTOMER)
         , MAX(F.OWNER), MAX(F.DEPT_ID), MAX(F.DEPT_NAME_KO)
         , MAX(F.FORECAST_INFO_CELL_PACK_COUNT), MAX(F.ITEM_TYPE)
         , MAX(F.PROJECT_NAME), MAX(F.PROJECT_OWNER), MAX(F.BIZ_TYPE)
         , MAX(F.SOLDTO_CUSTOMER), MAX(F.COUNTRY_NAME), MAX(F.CITY_NAME)
         , MAX(F.PROJECT_STATUS), MAX(F.ITEM_NAME), MAX(F.VMI_YN)
         , MAX(F.CUST_GROUP), MAX(F.CUST_GROUP_DTL), MAX(F.APPLICATION)
         , MAX(F.ROUTE), MAX(F.MDM_PROJECT_NAME), MAX(F.MIN_CAPACITY)
         , MAX(F.FORECAST_INFO_BIZ_TYPE), MAX(F.CELL_TYPE)
         , MAX(F.FORECAST_INFO_ALL), MAX(F.FORECAST_INFO_SPEC)
         , MAX(F.FORECAST_INFOR_VERSION), MAX(F.CELL_MODEL_NICK_NAME)
         , MAX(F.CELL_PER_CAR), MAX(F.CELL_PER_MODULE), MAX(F.MODULE_PER_CAR)
         , MAX(F.SORT_ORDER_NO), MAX(F.ENERGE), MAX(F.CELL_QUANTITY)
         , NVL(MAX(F.AS_FROM_SITE), ' '), MAX(F.CREATE_DATE), MAX(F.LAST_UPDATED_BY)
         , MAX(F.SENDER_CODE), MAX(F.SENDER_NAME), MAX(F.PROJECT_S_OP_REPORT)
         , MAX(F.CURRENCY), MAX(F.VERSION_NO), MAX(F.CUTOFF_YYYYMMDD)
         , MAX(F.NOTATION)
         /* EDIT_FLAG: 수정권한 — MA.EDIT_AUTH_YN 기반 */
         , CASE WHEN p_division_id = '82' THEN 'N'  --[E20260930-DMF0082QRYPERF-VMI82FOLD] 구 후행 UPDATE EDIT_FLAG='N'(82 조회전용) 흡수
                WHEN V_GROUP_ID = 'ADMIN' THEN 'Y'
                WHEN EXISTS (
                    SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE MA
                    WHERE  MA.MEASURE = F.MEASURE
                    AND    MA.EDIT_AUTH_YN = 'Y'
                    AND   (MA.TODAY_LIMIT_YN = 'N'
                           OR (MA.TODAY_LIMIT_YN = 'Y'
                               AND INSTR(
                                       REPLACE(TRIM(MA.TODAY_DAY_LIST),' ',''),
                                       CASE TO_NUMBER(TO_CHAR(SYSDATE,'D'))
                                           WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON'
                                           WHEN 3 THEN 'TUE' WHEN 4 THEN 'WED'
                                           WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                                           WHEN 7 THEN 'SAT'
                                       END) > 0))
                ) THEN 'Y'
                ELSE 'N'
           END AS EDIT_FLAG
         /* SORT_KEY — [FIX 2026-07-22] AS-IS L5865 파리티: 상수 999.
            구 변환(MEASURE_GROUP||SORT_ORDER_NO)은 ORDER BY 선두 SORT_KEY 를 measure 별 상이값으로
            만들어 measure-major 정렬(ITEM별 메저 인접 파괴)을 유발 — 사용자 실증 2026-07-22 */
         , 999 AS SORT_KEY
         /* GROUP_ID from user profile (DM_MST_USER or SCM_MST_USER) */
         , NULL AS GROUP_ID
         /* BUCKET PIVOT 컬럼: SUN~SAT */
         , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
         /* [FIX 2026-07-22] W/M 버킷 집계 분기용 파생 — AS-IS #MF_SP L5812~5846 파리티 */
         , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN
         /* [E20260812-PERF] 구 후행 UPDATE 흡수 — NEW_FLAG='N' 고정(원 주석 정책 동일) /
            AS_YN = p_scm_site_id 기반 비상관 판정(원 DECLARE 블록 등가 — MAX 는 GROUP BY 문법용) */
         , MAX('N') AS NEW_FLAG
         , MAX(CASE WHEN p_scm_site_id IS NULL OR p_scm_site_id = 'ALL' THEN 'N'
                    WHEN EXISTS (SELECT 1 FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') SA
                                 JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                   ON SA.TOKEN = SB.SEGMENT1 AND SB.LOOKUP_TYPE = 'AS_SITE_PLANT')
                    THEN 'Y' ELSE 'N' END) AS AS_YN
         , MAX(VD.VMI_STD_DIO) AS VMI_STD_DIO  --[E20260930-DMF0082QRYPERF-VMI82FOLD] 82 외 = NULL(조인 미성립)
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
    INNER JOIN (
        /* Daily bucket → date key */
        SELECT D.BASIS_YYYYMMDD
             , D.BASIS_YYYYMM || D.ISO_WEEK AS WEEK_KEY
             , CASE WHEN D.BASIS_YYYYMM || D.ISO_WEEK = WE.ISO_WEEK || WE.BASIS_YYYYMM
                    THEN WE.WEEK_END_DATE ELSE D.BASIS_YYYYMMDD END AS BUCKET_TYPE_KEY
             , TO_CHAR(D.BASIS_YYYYMMDD) AS BUCKET_KEY
             , 'D' AS BUCKET_TYPE
             /* [FIX 2026-07-22] W/M 분기 파생 — AS-IS L5812(YYYYMM/YYYYMMWW)·L5845~5846(월말/주말 플래그) 파리티.
                YYYYMMWW 는 C_BUCKET 컬럼키와 동일 포맷(LPAD 2) 의무 — 불일치 시 W_ 셀 전량 공백 */
             , D.BASIS_YYYYMM AS YYYYMM
             , D.BASIS_YYYYMM || LPAD(TRIM(D.ISO_WEEK), 2, '0') AS YYYYMMWW
             , CASE WHEN WE2.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
             , CASE WHEN ME.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M D
        LEFT JOIN SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE WE
            ON  WE.ISO_WEEK     = D.ISO_WEEK
            AND WE.BASIS_YYYYMM = D.BASIS_YYYYMM
        /* AS-IS #CAL_WEEK_END_DATE: 조회범위 내 (월,ISO주) 별 마지막 일자 */
        LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
                   FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                   WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
                   GROUP BY BASIS_YYYYMM, ISO_WEEK) WE2
            ON  WE2.WEEK_END_DATE = D.BASIS_YYYYMMDD
        /* AS-IS #CAL_MONTH_END_DATE: 조회범위 내 월별 마지막 일자 */
        LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
                   FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                   WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
                   GROUP BY BASIS_YYYYMM) ME
            ON  ME.MONTH_END_DATE = D.BASIS_YYYYMMDD
        WHERE  D.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND V_EXP_YYYYMMDD
    ) CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD
    /* BUCKET_PER PIVOT: DM_MST_BUCKET_CONVERSION (DIVISION+SCM_SITE+INCOTERMS 기준)
       [E20260812-PERF] LATERAL(행별 PIVOT 재실행 — ASH direct path temp 156샘플 병목) → 조합별 선계산 후
       일반 LEFT JOIN. PIVOT MAX ≡ MAX(CASE …) — 요일 행 부재 시 NULL 동일(등가) */
    LEFT JOIN (
        SELECT BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS
             , MAX(CASE WHEN BC.YYYYMMDD = 'SUN' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS SUN
             , MAX(CASE WHEN BC.YYYYMMDD = 'MON' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS MON
             , MAX(CASE WHEN BC.YYYYMMDD = 'TUE' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS TUE
             , MAX(CASE WHEN BC.YYYYMMDD = 'WED' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS WED
             , MAX(CASE WHEN BC.YYYYMMDD = 'THU' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS THU
             , MAX(CASE WHEN BC.YYYYMMDD = 'FRI' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS FRI
             , MAX(CASE WHEN BC.YYYYMMDD = 'SAT' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS SAT
        FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
        GROUP BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS
    ) PVT ON  PVT.DIVISION_ID = F.DIVISION_ID
          AND PVT.SCM_SITE_ID = F.SCM_SITE_ID
          AND PVT.INCOTERMS   = F.INCOTERMS
    LEFT JOIN ( --[E20260930-DMF0082QRYPERF-VMI82FOLD] 구 L4155 상관 스칼라 서브쿼리 → SCM_SITE_ID 별 선집계 (1회)
        SELECT S.SCM_SITE_ID, MAX(S.VMI_YN || '^' || NVL(TO_CHAR(S.ATTRIBUTE5),'')) AS VMI_STD_DIO
        FROM   SCM_MGR.SCM_MST_SITE S
        WHERE  S.DIVISION_ID = '82'
        AND    p_division_id = '82'  --[E20261012-DMF0082LATFIX] 구 ON 절 바인드 상수조건 → 뷰 안으로. ON 절에 두면 집계 뷰가 lateral(VW_LAT)로 전개되어 F 행마다 MERGE JOIN OUTER+BUFFER SORT 재평가(hook #129 1순위). 비82 = 뷰 0행 → LEFT JOIN NULL 동일
        GROUP BY S.SCM_SITE_ID
    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID
    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
           , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
           , F.CELL_PROD_SITE_ID, CAL.BUCKET_TYPE, CAL.BUCKET_KEY, F.MEASURE_GROUP
           , F.SORT_ORDER_NO
           , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
           , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN;

    -- [UICATEGORY 2026-08-07] direct-path(APPEND) INSERT 직후 동일 테이블 DML = ORA-12838
    --   → 통계 수집(내부 COMMIT — GTT SYS$SESSION PRESERVE 실측)을 먼저 수행한 뒤 Tier3 적재
    NULL; --[E20260930-DMF0082QRYPERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MF_SP', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

    -- ====================================================================================================
    -- [UICATEGORY 2026-08-07] Tier3 파리티 컬럼 적재 (DMF0003 MF_BASE 파생 이식 — 값 정책은 work report 참조)
    --   NEW_FLAG    : DMF0003 파생(수요/판가 FULL OUTER JOIN 신규 판정)은 본 SP 스테이징 구조에 부재 → 'N' 고정 (한계 명시)
    --   AS_YN       : DMF0003 LP_AS_YN 파리티 — 조회 Sales Site 가 AS_SITE_PLANT 룩업 포함 시 전행 'Y'
    --   ATTR1       : 40=DM_PLN_MKT_FCST(MKT_FCST) 일자 동기화 마커 PIVOT / 82=DM_PLN_PR_DETAIL — 81 은 DMF0003 원문 미정의(NULL)
    --   VMI_STD_DIO : 82=SCM_MST_SITE(VMI_YN^ATTRIBUTE5) — 40 은 DMF0003 원문 조인키 사문(KEY=ITEM↔조인=SITE)으로 미적재
    -- ====================================================================================================

    --[E20260812-PERF] NEW_FLAG 전행 UPDATE 제거 — INSERT 시점 흡수 (ASH log 대기 84샘플)
    -- UPDATE SCM_MGR.GT_DMF0082_MF_SP SET NEW_FLAG = 'N';

    --[E20260812-PERF] AS_YN 전행 UPDATE 블록 제거 — INSERT 시점 비상관 CASE 로 흡수(등가)
    NULL;

    IF p_division_id = '40' THEN
        -- ATTR1 (40) — DMF0003 GT_DMF0003_T_SSP_SYNC 적재 로직 이식 (DM_PLN_MKT_FCST MKT_FCST 일자 P/A 마커 31 PIVOT)
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
                || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
                || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
                || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
                || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
                || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
                || '^' || NVL(A31,'') AS ATTR1
            FROM (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
                     , YYYYMMDD || '/'
                       || CASE
                              WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                               AND A.QTY >
                                   CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                                        THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
                                 + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
                                        THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
                              THEN 'P'
                              ELSE 'A'
                          END AS SYNC_YN
                     , 'A' || TO_CHAR(
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                            DOM_EXP, A.FCST_TYPE, INCOTERMS
                               ORDER BY YYYYMMDD
                           )) AS ROW_NUM
                FROM   SCM_MGR.DM_PLN_MKT_FCST A
                WHERE  A.DIVISION_ID = p_division_id
                  AND  A.MEASURE     = 'MKT_FCST'
                  AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL )
                  AND  A.QTY <> 0
            ) A
            PIVOT (
                MAX(SYNC_YN) FOR ROW_NUM IN (
                    'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                    'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                    'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                    'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                    'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                    'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                    'A31' A31
                )
            )
        ) S
        ON (    T.DIVISION_ID  = S.DIVISION_ID
            AND T.PROJECT_CODE = S.PROJECT_CODE
            AND T.SCM_SITE_ID  = S.SCM_SITE_ID
            AND T.ITEM_ID      = S.ITEM_ID
            AND T.DOM_EXP      = S.DOM_EXP
            AND T.FCST_TYPE    = S.FCST_TYPE
            AND T.INCOTERMS    = S.INCOTERMS)
        WHEN MATCHED THEN UPDATE SET T.ATTR1 = S.ATTR1;

    ELSIF p_division_id = '82' THEN
        -- ATTR1 (82) — DMF0003 GT_DMF0003_T_BNP 적재 로직 이식 (DM_PLN_PR_DETAIL 일자 A 마커 31 PIVOT)
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
                || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
                || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
                || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
                || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
                || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
                || '^' || NVL(A31,'') AS ATTR1
            FROM (
                SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                DOM_EXP, FCST_TYPE, INCOTERMS
                     , YYYYMMDD || '/A' AS SYNC_YN
                     , 'A' || TO_CHAR(
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                            DOM_EXP, FCST_TYPE, INCOTERMS
                               ORDER BY YYYYMMDD
                           )) AS ROW_NUM
                FROM   SCM_MGR.DM_PLN_PR_DETAIL A
                WHERE  A.DIVISION_ID = p_division_id
                  AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
            ) A
            PIVOT (
                MAX(SYNC_YN) FOR ROW_NUM IN (
                    'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                    'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                    'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                    'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                    'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                    'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                    'A31' A31
                )
            )
        ) S
        ON (    T.DIVISION_ID  = S.DIVISION_ID
            AND T.PROJECT_CODE = S.PROJECT_CODE
            AND T.SCM_SITE_ID  = S.SCM_SITE_ID
            AND T.ITEM_ID      = S.ITEM_ID
            AND T.DOM_EXP      = S.DOM_EXP
            AND T.FCST_TYPE    = S.FCST_TYPE
            AND T.INCOTERMS    = S.INCOTERMS)
        WHEN MATCHED THEN UPDATE SET T.ATTR1 = S.ATTR1;

        -- VMI_STD_DIO (82) — DMF0003 GT_DMF0003_VMI_DIO 82 분기 이식 (SCM_MST_SITE VMI_YN^ATTRIBUTE5, SCM_SITE_ID 키)
        NULL;  --[E20260930-DMF0082QRYPERF-VMI82FOLD] VMI_STD_DIO 후행 UPDATE → MF_SP INSERT 흡수
    END IF;

    -- [UICATEGORY 2026-08-07] Division 82 = 조회 전용 (사용자 확정) — 편집 서버 권위 차단
    IF p_division_id = '82' THEN
        NULL;  --[E20260930-DMF0082QRYPERF-VMI82FOLD] EDIT_FLAG='N' 전행 UPDATE → MF_SP INSERT CASE 흡수
    END IF;

    /* [E20260825-AFSBLANK] AS_FROM_SITE NULL -> ' ' 정규화 (사용자 지시 2026-08-25).
       증상: 81 조회에서 AS_FROM_SITE 컬럼을 켜면 같은 행이 실적/계획 2행으로 분리된다.
       원인: 최종 커서가 동적 GROUP BY 로 표시 컬럼 전체를 묶는데(OPEN O_RC1 FOR 동적 SQL),
             계획 arm 과 실적 arm 의 빈값 표현이 달라(공백 ' ' vs NULL) 같은 표시키가 서로 다른 그룹이 된다.
             실적 원장은 PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 이 ATTRIBUTE10 을 적재하지 않아 항상 NULL
             (INSERT 컬럼 목록에 ATTRIBUTE10 부재 — 실측).
       주의: 실적 arm 에만 NVL 을 걸면 '계획 NULL vs 실적 공백' 이 새로 갈라진다(사내 실측 81 양쪽 NULL 4,801키).
             그래서 두 arm 이 합류한 스테이징에서 한 번에 정규화한다 — 표현만 통일, 실제 사이트값은 불변.
       한계: 값이 실제로 다른 경우(계획 'WA00_81-W' vs 실적 NULL)는 NVL 대상이 아니다 — 별도 판단 필요. */
    UPDATE SCM_MGR.GT_DMF0082_MF_SP
    SET    AS_FROM_SITE = ' '
    WHERE  AS_FROM_SITE IS NULL;

    /* [E20260825-CURRNORM] 수량 메저 행의 CURRENCY 표시키 통일 (사용자 신고 2026-08-25).
       증상: CUST_FCST 계열 실적 행의 CURRENCY 가 '-'(센티널)·KRW/USD(실값)인데 계획 arm 은 ''(NULL)
       → 같은 논리행이 CURRENCY 차이로 실적/계획 2행 분리 (AS_FROM_SITE 건과 동일 가족).
       원인: 계획 원장(DM_PLN_MKT_FCST/_C)에는 CURRENCY 컴럼 자체가 없고(실측 ORA-904),
       실적 원장(DM_PLN_SALES_PLAN_RESULT/_C)만 실컴럼 보유('-' 12,278행 포함 실측).
       정정: 판가 메저(CURRENCY 가 실차원인 행)만 제외하고 수량 메저는 전행 ' ' 로 통일. */
    UPDATE SCM_MGR.GT_DMF0082_MF_SP
    SET    CURRENCY = ' '
    WHERE  MEASURE NOT IN ('LOC', 'KRW', 'USD', 'MKT_AMT_LOC', 'MKT_AMT_KRW')
    --[E20260901-CURRKEEP] 사용자 신고 2026-09-01: 수량 메저에도 '자신의 단가 CURRENCY' 표기 (AS-IS 동등).
    --   구 조건 `CURRENCY IS NULL OR CURRENCY <> ' '` 은 **전 수량행을 무조건 공백으로 덮어써** 앞선 백필
    --   MERGE(LOC 기준 8키, AS-IS L2284 동등)로 채운 실통화를 소실시켰다(GTT 양성테스트 실측).
    --   정정: 실값 보존, NULL/공백/센티널('-')만 ' ' 통일 → CURRNORM 본래 목적(행 분리 방지) 유지.
    --   VMI 계열은 AS-IS(IIF(MEASURE LIKE 'VMI%','',CURRENCY) · 백필 제외)와 동일하게 항상 공백.
    AND    (   MEASURE LIKE 'VMI%'
            OR CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = '/');

    -- ====================================================================================================
    -- [DEFECT_GUARD] PIVOT IN 리스트 비어있음 방어 — C_BUCKET 이 0행 반환 시 빈 결과셋 조기 반환
    -- (SCM_SYS_CALENDAR_M 에 요청 날짜 범위의 데이터가 없으면 V_PV_LIST 공백 → ORA-00936)
    -- ====================================================================================================
    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_QTY_SUM);     EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC3 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC4 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC5 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS RESULT_CODE, 'NO_BUCKET_DATA' AS MESSAGE, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    -- ====================================================================================================
    -- 동적 SQL 구성 및 실행 (Case 86: CLOB 승격)
    -- ====================================================================================================

    DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

    -- ====================================================================================================
    -- [E20260918-KEYCOLGRAIN] 숨긴 저장키 컬럼이 행을 가르지 않게 대표값 통일
    --
    --   최종 커서는 PIVOT 이라 V_COLUMN 에 남은 모든 컬럼이 행 그레인이 된다.
    --     AS-IS : @V_COLUMN = C_TITLE + NOTATION           → 숨긴 컬럼은 그레인 아님
    --     TO-BE : + [E20260822-KEYCOL] 저장 키 12컬럼 강제 추가
    --   그래서 Column Setting 에서 숨긴 컬럼이어도 TO-BE 만 행이 갈린다(AS-IS 부재 회귀).
    --   실측(ZIOUI1 2026-09-18, Cell Prod Site 를 숨긴 계정 / DIV 40):
    --     KRW·LOC·MKT_FCST·SCM_FCST 각 12 업무키, RTF_SYS_RP 11 업무키가 CELL_PROD_SITE_ID 로 2줄.
    --   반대로 그 컬럼을 **표시**하는 계정은 AS-IS 도 2줄이므로 건드리면 안 된다
    --     (클라우드 실측: 40/Huapu_CN_CGU/MCSS22531-B3 — NJ01-A 61행 + HQ06-A 1행(20260531) = AS-IS 파리티).
    --
    --   따라서 **C_TITLE 에 없을 때만** 업무키 단위 대표값으로 통일한다.
    --   대표값 = 계획 구간 우선·최신 (편집·저장 대상이 계획 구간이므로 저장 키로도 이 값이 맞다).
    -- ====================================================================================================
    SELECT COUNT(*)
      INTO V_USER_COL_CNT
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = VA_PROGRAM_ID
       AND U.SHEET_NAME = VA_SHEET_NAME
       AND U.USER_ID    = p_created_by
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';

    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
                   SELECT NVL(DIVISION_ID, '~') AS DIVISION_ID
                        , NVL(PROJECT_CODE, '~') AS PROJECT_CODE
                        , NVL(END_CUSTOMER, '~') AS END_CUSTOMER
                        , NVL(SCM_SITE_ID, '~') AS SCM_SITE_ID
                        , NVL(ITEM_ID, '~') AS ITEM_ID
                        , NVL(DOM_EXP, '~') AS DOM_EXP
                        , NVL(FCST_TYPE, '~') AS FCST_TYPE
                        , NVL(INCOTERMS, '~') AS INCOTERMS
                        , NVL(PLANT_SITE_ID, '~') AS PLANT_SITE_ID
                        , NVL(MEASURE, '~') AS MEASURE
                        , MAX(CELL_PROD_SITE_ID) KEEP (DENSE_RANK LAST
                              ORDER BY CASE WHEN BUCKET_KEY >= V_TO_RESULT THEN 1 ELSE 0 END
                                     , BUCKET_KEY) AS REP_CELL_PROD
                   FROM   SCM_MGR.GT_DMF0082_MF_SP
                   WHERE  CELL_PROD_SITE_ID IS NOT NULL
                   GROUP BY NVL(DIVISION_ID, '~')
                        , NVL(PROJECT_CODE, '~')
                        , NVL(END_CUSTOMER, '~')
                        , NVL(SCM_SITE_ID, '~')
                        , NVL(ITEM_ID, '~')
                        , NVL(DOM_EXP, '~')
                        , NVL(FCST_TYPE, '~')
                        , NVL(INCOTERMS, '~')
                        , NVL(PLANT_SITE_ID, '~')
                        , NVL(MEASURE, '~')
                   HAVING COUNT(DISTINCT CELL_PROD_SITE_ID) > 1
               ) S
        ON ( NVL(T.DIVISION_ID, '~') = S.DIVISION_ID
         AND NVL(T.PROJECT_CODE, '~') = S.PROJECT_CODE
         AND NVL(T.END_CUSTOMER, '~') = S.END_CUSTOMER
         AND NVL(T.SCM_SITE_ID, '~') = S.SCM_SITE_ID
         AND NVL(T.ITEM_ID, '~') = S.ITEM_ID
         AND NVL(T.DOM_EXP, '~') = S.DOM_EXP
         AND NVL(T.FCST_TYPE, '~') = S.FCST_TYPE
         AND NVL(T.INCOTERMS, '~') = S.INCOTERMS
         AND NVL(T.PLANT_SITE_ID, '~') = S.PLANT_SITE_ID
         AND NVL(T.MEASURE, '~') = S.MEASURE )
        WHEN MATCHED THEN UPDATE SET T.CELL_PROD_SITE_ID = S.REP_CELL_PROD
        WHERE  NVL(T.CELL_PROD_SITE_ID, '~') <> S.REP_CELL_PROD;
    END IF;

    -- ====================================================================================================
    -- [E20260918-KEYCOLGRAIN2] 숨긴 PLANT_SITE_ID 가 행을 가르지 않게 대표값 통일
    --
    --   [E20260918-KEYCOLGRAIN](CELL_PROD_SITE_ID) 과 같은 사유. PLANT_SITE_ID 도
    --   KEYCOL 로 그레인에 강제 포함되므로, 화면에서 숨긴 계정은 AS-IS 에 없는 행분리가 난다.
    --
    --   클라우드 실측(2026-09-18, minyonglee1): 보이는 컬럼 13개에 PLANT_SITE_ID 가 없는데
    --     수요·실적 행 PLANT_SITE_ID = NULL / 단가 행 = '-'
    --   → 값이 갈리는데 화면에는 안 보여 **똑같아 보이는 2줄**이 된다.
    --   사내 ZIOUI1 은 DIV 40 이 전 행 '-' (NULL 0건)라 재현되지 않는다.
    --
    --   표시 중인 계정은 손대지 않는다(AS-IS 파리티). 대표값 = 계획 구간 우선·최신.
    -- ====================================================================================================
    SELECT COUNT(*)
      INTO V_USER_COL_CNT
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = VA_PROGRAM_ID
       AND U.SHEET_NAME = VA_SHEET_NAME
       AND U.USER_ID    = p_created_by
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.COLUMN_NAME = 'PLANT_SITE_ID';

    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
                   SELECT NVL(DIVISION_ID, '~') AS DIVISION_ID
                        , NVL(PROJECT_CODE, '~') AS PROJECT_CODE
                        , NVL(END_CUSTOMER, '~') AS END_CUSTOMER
                        , NVL(SCM_SITE_ID, '~') AS SCM_SITE_ID
                        , NVL(ITEM_ID, '~') AS ITEM_ID
                        , NVL(DOM_EXP, '~') AS DOM_EXP
                        , NVL(FCST_TYPE, '~') AS FCST_TYPE
                        , NVL(INCOTERMS, '~') AS INCOTERMS
                        , NVL(CELL_PROD_SITE_ID, '~') AS CELL_PROD_SITE_ID
                        , NVL(MEASURE, '~') AS MEASURE
                        , MAX(PLANT_SITE_ID) KEEP (DENSE_RANK LAST
                              ORDER BY CASE WHEN BUCKET_KEY >= V_TO_RESULT THEN 1 ELSE 0 END
                                     , BUCKET_KEY) AS REP_PLANT_SITE
                   FROM   SCM_MGR.GT_DMF0082_MF_SP
                   WHERE  PLANT_SITE_ID IS NOT NULL
                   GROUP BY NVL(DIVISION_ID, '~')
                        , NVL(PROJECT_CODE, '~')
                        , NVL(END_CUSTOMER, '~')
                        , NVL(SCM_SITE_ID, '~')
                        , NVL(ITEM_ID, '~')
                        , NVL(DOM_EXP, '~')
                        , NVL(FCST_TYPE, '~')
                        , NVL(INCOTERMS, '~')
                        , NVL(CELL_PROD_SITE_ID, '~')
                        , NVL(MEASURE, '~')
                   HAVING COUNT(DISTINCT NVL(PLANT_SITE_ID, '~')) >= 1
               ) S
        ON ( NVL(T.DIVISION_ID, '~') = S.DIVISION_ID
         AND NVL(T.PROJECT_CODE, '~') = S.PROJECT_CODE
         AND NVL(T.END_CUSTOMER, '~') = S.END_CUSTOMER
         AND NVL(T.SCM_SITE_ID, '~') = S.SCM_SITE_ID
         AND NVL(T.ITEM_ID, '~') = S.ITEM_ID
         AND NVL(T.DOM_EXP, '~') = S.DOM_EXP
         AND NVL(T.FCST_TYPE, '~') = S.FCST_TYPE
         AND NVL(T.INCOTERMS, '~') = S.INCOTERMS
         AND NVL(T.CELL_PROD_SITE_ID, '~') = S.CELL_PROD_SITE_ID
         AND NVL(T.MEASURE, '~') = S.MEASURE )
        WHEN MATCHED THEN UPDATE SET T.PLANT_SITE_ID = S.REP_PLANT_SITE
        WHERE  NVL(T.PLANT_SITE_ID, '~') <> S.REP_PLANT_SITE;
    END IF;

    -- ====================================================================================================
    -- [FIX 2026-07-22] 최종 동적 SQL — AS-IS(L5965~6085) 5분기 파리티 복원
    --   구 변환분: MF_SP 단일 소스 + PIVOT_BUCKET CASE(D/W/M) 구조였으나 MF_SP 적재가 전행
    --   BUCKET_TYPE='D' 라 W_/M_ 동적컬럼이 항상 공백(주/월 집계 분기 미승계 — 클라우드 실증 2026-07-22).
    --   ① D_ 행단위  ② W_ SUM(BALANCE/VMI_Inv/AS_Inv=주말일만, 그 외 합계)  ③ W_ AVG(KRW/USD/LOC)
    --   ④ M_ SUM(월말일 규칙 동일)  ⑤ M_ AVG(KRW/USD/LOC)  — QTY<>0 예외(SCM_FCST/FCST_GAP) AS-IS 동일.
    --   placeholder REPLACE 방식 = DMF0082_GET_MAIN_DATA_CURRENT(정상 변환 선례) 동형.
    --   (QTY 합계 보조컬럼은 기존 변환 유지 — FE 미사용 확인 2026-07-22)
    -- ====================================================================================================
    V_SQL := '
    SELECT [@V_COLUMN]
    , ([@V_QTY_SUM]) AS QTY
    , [@V_PV_COL_LIST]
    FROM (
        SELECT [@V_COLUMN], SORT_ORDER_NO, ''D_'' || BUCKET_KEY AS PIVOT_BUCKET, QTY
        FROM ( [@SRC0] ) F
        WHERE ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''W_'' || YYYYMMWW AS PIVOT_BUCKET
             , CASE WHEN MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')
                    THEN CASE WHEN WEEK_END_YN = ''Y'' THEN SUM(QTY) ELSE 0 END
                    ELSE SUM(QTY) END AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE NOT IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMMWW, WEEK_END_YN, MEASURE

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''W_'' || YYYYMMWW AS PIVOT_BUCKET, AVG(QTY) AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMMWW

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''M_'' || YYYYMM AS PIVOT_BUCKET
             , CASE WHEN MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')
                    THEN CASE WHEN MONTH_END_YN = ''Y'' THEN SUM(QTY) ELSE 0 END
                    ELSE SUM(QTY) END AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE NOT IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMM, MONTH_END_YN, MEASURE

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''M_'' || YYYYMM AS PIVOT_BUCKET, AVG(QTY) AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMM
    ) SRC
    PIVOT (SUM(QTY) FOR PIVOT_BUCKET IN ( [@V_PV_LIST] ))
    [@V_ORDERBY]';

    -- SRC0 = MF_SP alias 투영 (TEAM_ID/FORECAST_INFO_CELL_MODEL/LAST_UPDATE_DATE/BUCKET — 기존 wrapper 동일)
    V_SQL := REPLACE(V_SQL, '[@SRC0]', 'SELECT MSP.*, MSP.DEPT_ID AS TEAM_ID, MSP.DEPT_NAME_KO AS TEAM_NAME_KO /*[UICATEGORY 2026-08-07]*/, MSP.CELL_MODEL AS FORECAST_INFO_CELL_MODEL, NVL(TO_CHAR(MSP.CREATE_DATE, ''YYYY-MM-DD HH24:MI:SS''), '' '') AS LAST_UPDATE_DATE, NVL(TO_CHAR(MSP.SUN),''0'')||NVL(TO_CHAR(MSP.MON),''0'')||NVL(TO_CHAR(MSP.TUE),''0'')||NVL(TO_CHAR(MSP.WED),''0'')||NVL(TO_CHAR(MSP.THU),''0'')||NVL(TO_CHAR(MSP.FRI),''0'')||NVL(TO_CHAR(MSP.SAT),''0'') AS BUCKET FROM SCM_MGR.GT_DMF0082_MF_SP MSP');
    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);
    V_SQL := REPLACE(V_SQL, '[@V_PV_COL_LIST]', V_PV_COL_LIST);
    V_SQL := REPLACE(V_SQL, '[@V_PV_LIST]',     V_PV_LIST);
    V_SQL := REPLACE(V_SQL, '[@V_GROUPBY]',     V_GROUPBY);
    V_SQL := REPLACE(V_SQL, '[@V_COLUMN]',      V_COLUMN);
    V_SQL := REPLACE(V_SQL, '[@V_ORDERBY]',     V_ORDERBY);

    OPEN O_RC1 FOR V_SQL;

    DBMS_LOB.FREETEMPORARY(V_SQL);
    DBMS_LOB.FREETEMPORARY(V_PV_LIST);
    DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST);
    DBMS_LOB.FREETEMPORARY(V_QTY_SUM);

    -- ====================================================================================================
    -- Result Set 2: M+3 까지의 Monthly 캘린더 정보
    -- ====================================================================================================

    OPEN O_RC2 FOR
        SELECT A.BASIS_YYYYMM
             , MAX(A.BASIS_YYYYMMDD) AS MONTH_END_DATE
             , TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(MIN(A.BASIS_YYYYMMDD), 'YYYYMMDD'), 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY A.BASIS_YYYYMM;

    -- ====================================================================================================
    -- Result Set 3: 현재 주차 / 오늘 시각 정보
    -- ====================================================================================================

    OPEN O_RC3 FOR
        SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS TODAY_DATE
             , CASE TO_NUMBER(TO_CHAR(SYSDATE, 'D'))
                   WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON' WHEN 3 THEN 'TUE'
                   WHEN 4 THEN 'WED' WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                   WHEN 7 THEN 'SAT'
               END AS TODAY_DAY
             , SUBSTR(REPLACE(TO_CHAR(SYSDATE, 'HH24:MI:SS'), ':', ''), 1, 4) AS TODAY_TIME
        FROM   DUAL;

    -- ====================================================================================================
    -- Result Set 4: 메저별 수정권한 (ADMIN GROUP MEASURE)
    -- ====================================================================================================

    OPEN O_RC4 FOR
        SELECT MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST
        FROM   SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
        ORDER BY MEASURE;

    -- ====================================================================================================
    -- Result Set 5: 캘린더 주간 분포 (BUCKET CONVERSION)
    -- ====================================================================================================

    -- Result Set 5: 캘린더 주간 배분 정보 (M+4 월간 물량 배분용)
    OPEN O_RC5 FOR
        SELECT A.BASIS_YYYYMMDD
             , A.BASIS_YYYYMM
             , CASE WHEN SUBSTR(A.BASIS_START_DATE, -2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG
             , CASE WHEN SUBSTR(TO_CHAR(TO_DATE(A.BASIS_START_DATE,'YYYYMMDD')+7,'YYYYMMDD'),1,6)
                         = SUBSTR(A.BASIS_START_DATE,1,6)
                    THEN 'N' ELSE 'Y' END AS END_MONTH_FLAG
             , COUNT(*) OVER (PARTITION BY A.BASIS_YYYYMM) AS MONTH_DAY_CNT
             , COUNT(*) OVER (PARTITION BY A.ISO_WEEK) AS WEEK_DAY_CNT
             , A.ISO_WEEK
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY A.BASIS_YYYYMMDD;

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- 소스 주석 보존 (legacy comment preservation)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 시작
    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료
    /* #TEMP_DM_MST_ITEM_SINGLE_V 만들기 시작 */
    /* #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료 */
    /* 조회 할 때 쓸 날짜 변수 세팅 시작 */
    /* 조회 할 때 쓸 날짜 변수 세팅 종료 */
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START ---------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END ---------------------------------------------------------------------
    --기존 쿼리 주석 처리 후 일괄 변경
    --1.LAST_UPDATE_DATE 값을 가져올 때, CASE WHEN 에 소형사업부에서 사용하지 않는 메저들만 있어서 해당 로직 제거
    --2.가장 최근 데이터를 입력한 사용자ID가 아니라 MAX사용자ID로 가져와서 수정함
    --AND A.QTY <> 0
    -- #TempFcstNPrice 만들기
    -- #TempFcstNPrice 에 INSERT 한 메저들을 이용하여 판가 실적 계산
    -- 기본적인 MEASURE 포함
    -- MKT_FCST [R+P]의 P부분 (기준일 이후)
    -- MKT_FCST [P+P]의 P부분 (기준일 이전)
    -- MKT_FCST [P+P]의 P부분 (기준일 이후)
    -- RTF [R+P]의 R부분 (기준일 이전)
    -- LOC = MKT_AMT_LOC/RTF_SYS_RP
    -- KRW = MKT_AMT_KRW/RTF_SYS_RP
    -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
    -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START---------
    -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END---------
    -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
    -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
    -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P]) START
    -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 조회 시, 실적수량 Measure는 #TempSelectMeasure 의 RESULT_MEASURE 컬럼으로 매핑
    --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
    --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
    -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
    --AND A.QTY <> 0 -- 0인 수량은 CREATE_DATE, LAST_UPDATED_BY가 NULL이 되어 PIVOT 에서 동일 KEY 인데 분리되는 현상 발생되어 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화
    --AND A.MEASURE IN ('') -- 필요한 경우 추가
    --AND A.MEASURE NOT IN ('') -- 필요한 경우 추가
    --AND A.PRICE <> 0) AS CREATE_DATE
    --AND QTY <> 0) AS CREATE_DATE
    --AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
    --AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE) AS LAST_UPDATED_BY
    --WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID
    -- WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID
    --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
    --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
    --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_PRICE WITH(NOLOCK)
    --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_PRICE WITH(NOLOCK)
    --, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_CODE
    --, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_NAME
    --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (주석처리)
    --ON  A.MEASURE = 'RTF_SYS_RP'
    --SELECT A.DIVISION_ID
    --    , A.PROJECT_CODE
    --    , A.PROJECT_CODE AS END_CUSTOMER
    --    , A.SCM_SITE_ID
    --    , A.ITEM_ID
    --    , A.DOM_EXP
    --    , A.FCST_TYPE
    --    , A.INCOTERMS
    --    , A.PLANT_SITE_ID
    --    , '-' AS CELL_PROD_SITE_ID
    --    , A.YYYYMMDD
    --    , A.QTY
    --    , B.MEASURE_GROUP
    --    , C.CELL_MODEL
    --    , C.NICK_NAME
    --    , C.DMS_SALES
    --    , C.DMS_CUSTOMER
    --    , C.[OWNER]
    --    , C.DEPT_ID
    --    , C.DEPT_NAME_KO
    --    , C.FORECAST_INFO_CELL_PACK_COUNT
    --    , C.ITEM_TYPE
    --    , C.PROJECT_NAME
    --    , C.PROJECT_OWNER
    --    , C.BIZ_TYPE
    --    , C.SOLDTO_CUSTOMER
    --    , C.COUNTRY_NAME
    --    , C.CITY_NAME
    --    , C.PROJECT_STATUS
    --    , C.ITEM_NAME
    --    , C.VMI_YN
    --    , C.CUST_GROUP
    --    , C.CUST_GROUP_DTL
    --    , C.[APPLICATION]
    --    , C.[ROUTE]
    --    , C.MDM_PROJECT_NAME
    --    , C.MIN_CAPACITY
    --    , C.FORECAST_INFO_BIZ_TYPE
    --    , C.CELL_TYPE
    --    , C.WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID
    --SELECT '#TempFcstNPrice',* FROM #TempFcstNPrice -- 테스트
    /* DM_PLN_MKT_FCST_RESULT 테이블 기준 MEASURE */
    /* DM_PLN_CFM_MKT_DEMAND_PLAN_C 테이블 기준 MEASURE */
    /* DM_PLN_MKT_FCST_RESULT_C 테이블 기준 MEASURE */
    -----------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- ====================================================================================================
    -- O_RESULT_CURSOR: 성공 응답
    -- ====================================================================================================

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG FROM DUAL;

    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, '정상종료', 'P_DMF0082_GET_MAIN_DATA END',
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_QTY_SUM); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'E', 0
              , 'ERROR: ' || V_SQL_ERRMSG
              , 'P_DMF0082_GET_MAIN_DATA ERROR'
              , SYSDATE
              , V_PROC_INPUT
              , V_SQL_CODE
              , V_SQL_ERRMSG
              , V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001, '['|| $$PLSQL_UNIT ||'] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_MAIN_DATA;
END PKG_DMF0082_LFT;