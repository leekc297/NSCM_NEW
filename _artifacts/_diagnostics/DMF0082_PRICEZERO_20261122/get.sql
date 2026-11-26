PACKAGE BODY         "PKG_DMF0082" IS
    --[E20260813-UPLOADSAVE]->[E20260901-STATELESS] Excel Upload 적재 경로 전용 플래그 - 구 패키지 전역변수를
    --   세션 GTT(GT_DMF0082_SAVE_FLAG, ON COMMIT PRESERVE ROWS) 1행으로 대체 (패키지 무상태화).
    --   전역변수가 패키지를 stateful 로 만들어 재배포마다 기존 커넥션이 ORA-04068 1회 실패(클라우드 실사고
    --   2026-09-01). 무상태화로 재배포 시 BE 재시작 불요. 플래그 의미·소비 규약(1회용)은 종전과 동일.


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
 * 2026.10.12       admin        [E20261012-DMF0082LATFIX] MF_SP INSERT 의 VD(SCM_MST_SITE 82 선집계) 인라인뷰 ON 절 바인드 조건을 뷰 안으로 이동 —
 *                               lateral(VW_LAT) 행별 MERGE JOIN OUTER 제거 (hook #129 1순위 · 6커서 전행 동일 검증)
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
--        AND    NVL(TRIM(C.DEFAULT_FLAG), '-') = '-'  -- [E20260907-DEFFLAG] 구 "= ' '" → **센티널 정규화**. AS-IS 원문은 DEFAULT_FLAG='' (=빈 값) 이고 ' '(클라우드) 와 '-'(ZIOUI1) 는 같은 센티널의 표기 변형이다(hook #119). 'N' 은 별개 실값이라 제외 — 이렇게 해야 양 DB 가 동일 컬럼셋(실측 10건)을 낸다. 구 조건은 ZIOUI1 에서 항상 0행이라 SORT_KEY 누락 → ORDER BY SORT_KEY 가 ORA-00904
--        AND    NVL(TRIM(C.DEFAULT_FLAG), '/') = '/'  -- [E20260907-DEFFLAG] 구 "= ' '" → **센티널 정규화**. AS-IS 원문은 DEFAULT_FLAG='' (=빈 값) 이고 ' '(클라우드) 와 '-'(ZIOUI1) 는 같은 센티널의 표기 변형이다(hook #119). 'N' 은 별개 실값이라 제외 — 이렇게 해야 양 DB 가 동일 컬럼셋(실측 10건)을 낸다. 구 조건은 ZIOUI1 에서 항상 0행이라 SORT_KEY 누락 → ORDER BY SORT_KEY 가 ORA-00904
        --[E20261013-DMF0082DEFFLAGN] 사용자 지시(2026-10-13): DEFAULT_FLAG 가 'N' 이어도 조회 오류가 나면 안 된다.
        --  시스템 컬럼 10종(AS-IS DEFAULT_FLAG='' 인 컬럼)은 DEFAULT_FLAG 값과 무관하게 항상 포함한다.
        --  빠지면 V_COLUMN 에 SORT_KEY 가 없어 'ORDER BY SORT_KEY' 가 ORA-00904 (10-13 11:48 실측, 10종이 'N' 으로 바뀜).
        --  그 외 'N' 컬럼(사용자 선택 컬럼)은 종전대로 제외 — 포함하면 GROUP BY 축이 늘어 행이 갈린다.
        AND    ( RTRIM(C.DEFAULT_FLAG, ' -/') IS NULL
              OR C.COLUMN_NAME IN ('GROUP_ID','VERSION_NO','MEASURE_GROUP','BUCKET','EDIT_FLAG','SORT_KEY','NEW_FLAG','ATTR1','VMI_STD_DIO','AS_YN') )
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


    -- [E20261104-DMF0082ONEQUERY] 2-A: Current 전용 3문장 경로 선택 플래그 (버전 조회는 원문 경로)
    V_ONEQ_CURRENT      BOOLEAN := FALSE;
    V_VERLOOP_CNT       PLS_INTEGER := 0;   -- [E20261105-DMF0082ONEQUERY-VERLOOP] S2-L FCST_C/PRICE_C 버전별 적재 루프 횟수
    V_DUP12             NUMBER;             -- [E20261105-DMF0082ONEQUERY-DUPSHORT] S2 직후 11키×일 중복 선검사(0 이면 59열 중복도 0 → L4220 검사·DELETE 생략 · S3 MSP 항등 판정 공유)
    V_TSI_CNT           PLS_INTEGER := 0;   -- [E20261106-DMF0082ONEQUERY-SZCLASS] S1 결과(TEMP_SITE_ITEM) 행수. GTT 무통계+세션 DS2 라 정적 S2 커서의 계획이 '처음 하드파싱한 세션의 GTT 행수'에 굳는다(11-06 실측: 834행 파싱→전체조회 18s · 377행→40s · 12,921행 이상→5s). 크기 구간별로 텍스트가 다른 커서(FLT_L/FLT_S)를 쓰게 해 소수 행 필터 파싱이 전체조회 계획을 오염시키지 않도록 한다. 주석은 PL/SQL 정적 SQL 에서 제거되므로 CTE 이름으로 구분.
    V_FNP_CNT           PLS_INTEGER := 0;   -- [E20261106-DMF0082ONEQUERY-SZCLASS] S2 적재 행수 → S3 동적 SQL 끝 토큰 주석(동적 SQL 은 주석 보존)
    C_SZ_TSI            CONSTANT PLS_INTEGER := 8192;   -- [SZCLASS] TEMP_SITE_ITEM 행수 경계(실측: 추정 2,687 → NL 고착 · 6,659 이상 → HASH)
    C_SZ_FNP            CONSTANT PLS_INTEGER := 50000;  -- [SZCLASS] TEMP_FCST_N_PRICE 행수 경계
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

    /* [E20261104-DMF0082ONEQUERY] S0 — 원문 L257~297 PARAM_TOKEN 분해 INSERT 10 문장 → 1 문장 (토큰 내용 동일 · 함수 호출 횟수 동일). */
    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','))
    UNION ALL
    SELECT 'p_project_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_project_code, ','))
    UNION ALL
    SELECT 'p_owner', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_owner, ','))
    UNION ALL
    SELECT 'p_sender_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_sender_code, ','))
    UNION ALL
    SELECT 'p_team_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_team_id, ','))
    UNION ALL
    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','))
    UNION ALL
    SELECT 'p_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_customer, ','))
    UNION ALL
    SELECT 'p_biz_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biz_type, ','))
    UNION ALL
    SELECT 'p_item_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_item_id, ','))
    UNION ALL
    /* [GAP439 2026-10-15] 버전 토큰은 첫 '(' 이후 절단 (원문 L289~297 그대로) */
    SELECT 'p_version_type'
         , CASE WHEN UPPER(COLUMN_VALUE) LIKE '%CURRENT%' THEN COLUMN_VALUE
                ELSE TRIM(REGEXP_REPLACE(COLUMN_VALUE, '\(.*$', ''))
           END
    FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));

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


    /* [E20261104-DMF0082ONEQUERY] 2-B — 전 경로 새 구조. 순수 Current 요청은 S2-CUR(사업부별) · 버전 포함 요청은 S2-ALL(사업부별 · Current+MF+SF+SP arm) */
    V_ONEQ_CURRENT := (p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%')
                      AND p_version_type NOT LIKE '%SP%' AND p_version_type NOT LIKE '%MF%' AND p_version_type NOT LIKE '%SF%';
    DELETE FROM SCM_MGR.GT_DMF0082_T_VERSION;

    IF p_version_type LIKE '%SP%' OR p_version_type LIKE '%MF%' OR p_version_type LIKE '%SF%' THEN
        --2025.03.14 Philsu Park: MF_W, SP_W Cutoff 버전에서 Amount 실적을 찾기위한 SP_VERSION_NO 추가.
        INSERT INTO SCM_MGR.GT_DMF0082_T_VERSION (VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD, SP_VERSION_NO)
        SELECT A.TOKEN      AS VERSION_NO
             , CASE WHEN D.DM_RTF_YN = 'N' THEN A.TOKEN || '(' || C.ISO_YYYYWW || ') (NO PLAN)'
                    ELSE A.TOKEN || '(' || C.ISO_YYYYWW || ')'
               END          AS VERSION_NO_W
             , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(B.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD') AS NOW_YYYYMMDD  --[GAP446 2026-10-15] AS-IS L256 = 버전일이 속한 주 월요일 (구: 버전일 - 7)
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
    /* [E20261104-DMF0082ONEQUERY] S1 — 원문 L611~1114 (ORI_V → A_V/B_V → _V → SITE_ITEM_ALL → TEMP_SITE_ITEM) 를 CTE 체인 1 INSERT 로.
       · 원문 L842 p_item_id 필터는 _V 단계(CTE V)에 두어 T2·T4(CELL_MODEL 닉네임 조회) 둘 다 필터본을 본다 (원문 동일).
       · 원문 L1002~1048 site/customer/biz/item 필터(NOT EXISTS DELETE) = 생존 조건 EXISTS 로 CTE ALLF 에 흡수 (의미 동일).
       · GTT 적재 시 묵시 변환 재현: _V.ENERGE NUMBER(20,4) · ALL.MIN_CAPACITY/CELL_QUANTITY/MODULE_PER_CAR NUMBER(20,10). */
    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM;  /*[E20261109-DMF0082TSICLEAR] S1 적재 전 비움 - 원본 L1064 동일 (세션 GTT 잔존 행 혼입 방지)*/
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
    WITH ORI AS (  /* L614~659 */
        SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME
             , T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
             , T1.ACTIVE_FLAG, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
             , T1.FORECAST_INFO_BIZ_TYPE, T1.FORECAST_INFO_PRODUCT_GROUP
             , T1.FORECAST_INFO_CELL_MODEL, T1.FORECAST_INFO_CELL_PACK_COUNT
             , T1.FORECAST_INFO_SPEC, T1.FORECAST_INFOR_VERSION, T1.CELL_TYPE
        FROM   SCM_MGR.SCM_ITEM_M_SN T1
        WHERE  T1.DIVISION_ID = p_division_id
          AND  T1.ACTIVE_FLAG = 'Y'
          AND  SUBSTR(T1.ITEM_ID,1,12) IN (
                 SELECT SUBSTR(S.ITEM_ID,1,12)
                   FROM SCM_MGR.SCM_MST_SITE_ITEM S
                  WHERE S.DIVISION_ID = p_division_id )
    ), AV AS (  /* L671~703 */
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
        FROM   ORI T1
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ), BV AS (  /* L715~732 */
        SELECT DIVISION_ID
             , SUBSTR(ITEM_ID, 1, 12)                           AS ITEM_ID
             , MAX(FORECAST_INFO_BIZ_TYPE)                      AS FORECAST_INFO_BIZ_TYPE
             , MAX(FORECAST_INFO_PRODUCT_GROUP)                 AS FORECAST_INFO_PRODUCT_GROUP
             , MAX(FORECAST_INFO_CELL_MODEL)                    AS FORECAST_INFO_CELL_MODEL
             , MAX(FORECAST_INFO_CELL_PACK_COUNT)               AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(FORECAST_INFO_SPEC)                          AS FORECAST_INFO_SPEC
             , MAX(FORECAST_INFOR_VERSION)                      AS FORECAST_INFOR_VERSION
             , MAX(CELL_TYPE)                                   AS CELL_TYPE
        FROM   ORI
        GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
    ), V0 AS (  /* L744~838 */
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
             , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
             , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
             , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
             , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , ACTIVE_FLAG, CELL_TYPE
             , CAST(CASE WHEN TO_NUMBER(ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL
                         THEN ROUND(TO_NUMBER(ENERGE) / 1000, 4)
                         ELSE NULL
                    END AS NUMBER(20,4))                        AS ENERGE  -- WH → KWH 환산 (GTT NUMBER(20,4) 재현)
             , CELL_QUANTITY, SCP_EXTRA_SPEC
        FROM (
            SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME
                 , T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
                 , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT
                 , T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                 , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
            FROM   AV T1
            INNER JOIN BV T2
                ON  T1.DIVISION_ID = T2.DIVISION_ID
                AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
            WHERE  T1.DIVISION_ID = p_division_id
        )
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
               , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
               , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
               , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    ), V AS (  /* L842~850 Item 필터 — NOT EXISTS DELETE 의 생존 조건 */
        SELECT F.*
        FROM   V0 F
        WHERE  p_item_id IS NULL
           OR  EXISTS (SELECT 1
                       FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                       WHERE  T.PARAM_NM = 'p_item_id'
                       AND    (F.ITEM_ID   LIKE '%' || T.TOKEN || '%'
                            OR F.NICK_NAME LIKE '%' || T.TOKEN || '%'))
    ), ALLX AS (  /* L864~998 */
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
                        FROM   (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) AS TOK
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
             , NVL(MP.PROJECT_NAME, F.PROJECT_CODE)             AS PROJECT_NAME
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
             , CAST(TO_NUMBER(T2.MIN_CAPACITY DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20,10)) AS MIN_CAPACITY
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
             , CAST(TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR)
               / CASE WHEN NVL(TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR), 0) = 0 THEN 1
                      ELSE TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR)
                 END AS NUMBER(20,10))                          AS MODULE_PER_CAR
             , CAST(NULL AS NUMBER(20,10))                      AS SORT_ORDER_NO
             , TO_CHAR(T2.ENERGE)                               AS ENERGE
             , CAST(TO_NUMBER(T2.CELL_QUANTITY DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20,10)) AS CELL_QUANTITY
             , '/'                                              AS PLANT_SITE_ID
             , F.VALID_YN                                       AS ITEM_VALID_YN
             , S.END_CUSTOMER
             , CAST(NULL AS VARCHAR2(200))                      AS PROJECT_S_OP_REPORT
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        INNER JOIN V T2
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
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
            ON  F.DIVISION_ID  = MP.DIVISION_ID
            AND F.PROJECT_CODE = MP.PROJECT_CODE
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = F.DEPT_ID
        LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
            ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                                 THEN F.OWNER
                                 ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                            END
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
            ON K.DEPT_ID = F.DEPT_ID
        LEFT JOIN (
            SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'CELL_TYPE'
        ) LOOK
            ON LOOK.CODE = T2.CELL_TYPE
        LEFT JOIN V T4
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
        WHERE  F.DIVISION_ID = p_division_id
    ), ALLF AS (  /* L1002~1048 조회조건 필터 4 (NOT EXISTS DELETE → 생존 EXISTS) */
        SELECT F.*
        FROM   ALLX F
        WHERE  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_customer IS NOT NULL AND p_customer <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_customer'
                           AND    T.TOKEN    = CASE WHEN p_division_id = '40' THEN F.PROJECT_CODE ELSE F.END_CUSTOMER END))
          AND  (   NOT (p_biz_type IS NOT NULL AND p_biz_type <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_biz_type' AND T.TOKEN = F.FORECAST_INFO_BIZ_TYPE))
          AND  (   p_item_id IS NULL
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_item_id'
                           AND    (F.ITEM_ID LIKE '%' || T.TOKEN || '%' OR F.NICK_NAME LIKE '%' || T.TOKEN || '%')))
    )
    /* L1060~1114 6키 GROUP BY MAX */
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL), MAX(DMS_SALES), MAX(DMS_CUSTOMER), MAX(OWNER)
         , MAX(DEPT_ID), MAX(DEPT_NAME_KO), MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(ITEM_TYPE), MAX(PROJECT_OWNER), MAX(BIZ_TYPE)
         , MAX(SOLDTO_CUSTOMER), MAX(COUNTRY_NAME), MAX(CITY_NAME), MAX(PROJECT_STATUS)
         , MAX(ITEM_NAME), MAX(VMI_YN), MAX(CUST_GROUP), MAX(CUST_GROUP_DTL), MAX(APPLICATION), MAX(ROUTE)
         , MAX(MDM_PROJECT_NAME), MAX(MIN_CAPACITY), MAX(FORECAST_INFO_BIZ_TYPE), MAX(CELL_TYPE)
         , MAX(FORECAST_INFO_ALL), MAX(FORECAST_INFO_SPEC), MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_MODEL_NICK_NAME), MAX(CELL_PER_CAR), MAX(CELL_PER_MODULE), MAX(MODULE_PER_CAR)
         , MAX(SORT_ORDER_NO), MAX(ENERGE), MAX(CELL_QUANTITY), MAX(PLANT_SITE_ID)
         , MAX(ITEM_VALID_YN), MAX(END_CUSTOMER), MAX(PROJECT_S_OP_REPORT)
    FROM   ALLF
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
    /* [E20261014-DMF0082RLXPRE] 조회조건 Project / Owner / Team 완화 선행축소 (사용자 승인 2026-10-14 "A. 사내에 적용")
       필터는 아래 L3692(Project) · L3699(Owner) · L3724(Team) 에서 적재 뒤 DELETE 로만 걸려, 81 Project 지정 시
       판가 18만 행을 적재했다가 91% 를 지웠다(클라우드 QA INSERT 2.1s + DELETE 1.4s).
       선택 조건을 만족하는 행이 하나라도 있는 (DIV, SCM_SITE_ID, ITEM_ID) 는 프로젝트가 달라도 전부 남기고 나머지만 지운다.
       - 프로젝트 단위로 줄이지 않는 이유: CURRENCY 3차 MERGE(키 DIV+SITE+ITEM+DOM_EXP+FCST_TYPE)가 다른 프로젝트의
         LOC 통화를 참조한다. 필터 전 계산의 최대 범위가 (DIV, SITE, ITEM) 이므로 그 단위로 남기면 생존 행 값이 같다.
       - 판정식 = 기존 필터 DELETE 의 생존 조건 그대로(NVL(x,' ') NOT IN 토큰 이 참이 아닌 행 = 토큰 일치 OR 토큰에 NULL).
         OWNER·DEPT_ID 는 적재 arm 이 C.OWNER·C.DEPT_ID 를 그대로 투영하므로 이 GTT 값으로 판정한다.
       - 아래 기존 필터 DELETE 는 그대로 둔다 → 최종 결과 동일, 적재·삭제량만 줄어든다. */
    IF (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
       OR (p_owner IS NOT NULL AND p_owner <> 'ALL')
       OR (p_team_id IS NOT NULL AND p_team_id <> 'ALL') THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        WHERE  (C.DIVISION_ID, C.SCM_SITE_ID, C.ITEM_ID) NOT IN (
                   SELECT K.DIVISION_ID, K.SCM_SITE_ID, K.ITEM_ID
                   FROM   SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM K
                   WHERE  K.DIVISION_ID IS NOT NULL
                   AND    K.SCM_SITE_ID IS NOT NULL
                   AND    K.ITEM_ID     IS NOT NULL
                   AND    (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                           OR EXISTS (SELECT 1
                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                                      WHERE  T.PARAM_NM = 'p_project_code'
                                      AND    (T.TOKEN = NVL(K.PROJECT_CODE, ' ') OR T.TOKEN IS NULL)))
                   AND    (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                           OR EXISTS (SELECT 1
                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                                      WHERE  T.PARAM_NM = 'p_owner'
                                      AND    (T.TOKEN = NVL(K.OWNER, ' ') OR T.TOKEN IS NULL)))
                   AND    (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                           OR EXISTS (SELECT 1
                                      FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                                      WHERE  T.PARAM_NM = 'p_team_id'
                                      AND    (T.TOKEN = NVL(K.DEPT_ID, ' ') OR T.TOKEN IS NULL))));
    END IF;
    /* [E20261104-DMF0082ONEQUERY] S2-L 룩업 GTT 적재 (WS · SELECT_MEASURE · LAST_DATA_SETUP · FCST_C · PRICE_C) — 10-09 SHARED 고정 통계를 쓰기 위해 CTE 대신 GTT 유지 · FCST_C/PRICE_C 는 T_VERSION 버전별 FOR 루프 적재(11-05 VERLOOP · T_VERSION 비면 0회 · 원문 L1344~1432 는 T_VERSION 조인 카티션 1행 추정→NL 457s) */
    DELETE FROM SCM_MGR.GT_DMF0082_T_WS_FCST;
    INSERT INTO SCM_MGR.GT_DMF0082_T_WS_FCST (FCST_TYPE)
/* L551~554 */
        SELECT DISTINCT A.SEGMENT1 AS FCST_TYPE
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
        WHERE  A.LOOKUP_TYPE = 'SALES_TYPE_CODE';
    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE;
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    WITH MEA1 AS (  /* L1170~1187 사용자 선택 메저 */
        SELECT U.COLUMN_NAME                          AS MEASURE
             , NVL(M.ATTRIBUTE5, U.COLUMN_NAME)       AS RESULT_MEASURE
             , U.COLUMN_NAME                          AS MEASURE_GROUP
             , CAST(U.SORT_ORDER_NO AS NUMBER(10,2))  AS SORT_ORDER_NO
             , U.USER_ID
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        INNER JOIN SCM_MGR.SCM_MST_SHEET_MEASURE M
            ON  M.PROGRAM_ID  = U.PROGRAM_ID
            AND M.SHEET_NAME  = U.SHEET_NAME
            AND M.COLUMN_NAME = U.COLUMN_NAME
            AND M.VALID_YN    = 'Y'
        WHERE  U.PROGRAM_ID = VA_PROGRAM_ID
        AND    U.SHEET_NAME = VA_SHEET_NAME
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND    U.USER_ID    = p_created_by
    ), MEA2 AS (  /* L1196~1223 CUST_FCST 종속 메저 (MEA1 에 없는 것) */
        SELECT S.MEASURE, S.MEASURE AS RESULT_MEASURE, 'CUST_FCST' AS MEASURE_GROUP
             , CAST(A.SORT_ORDER_NO + S.SORT_NO AS NUMBER(10,2)) AS SORT_ORDER_NO, A.USER_ID
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
        WHERE NOT EXISTS (SELECT 1 FROM MEA1 X WHERE X.MEASURE = S.MEASURE)
    ), MEA3 AS (  /* L1236~1246 강제 포함 8 (MEA1∪MEA2 에 없는 것) */
        SELECT M.COLUMN_NAME AS MEASURE, M.COLUMN_NAME AS RESULT_MEASURE, M.COLUMN_NAME AS MEASURE_GROUP
             , CAST(M.SORT_ORDER_NO AS NUMBER(10,2)) AS SORT_ORDER_NO, 'DM_ADMIN' AS USER_ID
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE M
        WHERE  M.PROGRAM_ID  = VA_PROGRAM_ID
        AND    M.SHEET_NAME  = VA_SHEET_NAME
        AND    M.COLUMN_NAME IN ('LOC', 'KRW', 'FCST_GAP', 'RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW', 'SCM_FCST', 'MKT_FCST')
        AND    NOT EXISTS (SELECT 1 FROM MEA1 X WHERE X.MEASURE = M.COLUMN_NAME)
        AND    NOT EXISTS (SELECT 1 FROM MEA2 X WHERE X.MEASURE = M.COLUMN_NAME)
    )
SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID FROM MEA1
        UNION ALL SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID FROM MEA2
        UNION ALL SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID FROM MEA3;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST;
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
/* L1258~1273 (81/82 DM_PLN_MKT_FCST) · L1559 INSERT ALL 의 LD 분기 (40 DM_PLN_CFM_MKT_DEMAND_PLAN) — 8키 1행 */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C;
    V_VERLOOP_CNT := 0;
    FOR VL IN (SELECT DISTINCT VERSION_NO FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO IS NOT NULL ORDER BY VERSION_NO) LOOP  -- [E20261105-DMF0082ONEQUERY-VERLOOP] T_VERSION 조인 → 버전별 바인드(카티션 1행 추정·NL 457s 제거) · 순수 Current 는 0회
    V_VERLOOP_CNT := V_VERLOOP_CNT + 1;
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY)
/* L1348~1388 FCST_C (9키 = 8키 + VERSION_NO) */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.VERSION_NO = VL.VERSION_NO
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        AND    A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = '00000000' THEN '19000101' ELSE V_CUTOFF_FROM END, 'YYYYMMDD') AND TO_DATE(CASE WHEN V_CUTOFF_TO = '99999999' THEN '99991231' ELSE V_CUTOFF_TO END, 'YYYYMMDD')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    A.DIVISION_ID = p_division_id
        AND    A.VERSION_NO = VL.VERSION_NO
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        AND    A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = '00000000' THEN '19000101' ELSE V_CUTOFF_FROM END, 'YYYYMMDD') AND TO_DATE(CASE WHEN V_CUTOFF_TO = '99999999' THEN '99991231' ELSE V_CUTOFF_TO END, 'YYYYMMDD')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO;
    END LOOP;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C;
    V_VERLOOP_CNT := 0;
    FOR VL IN (SELECT DISTINCT VERSION_NO FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO IS NOT NULL ORDER BY VERSION_NO) LOOP  -- [E20261105-DMF0082ONEQUERY-VERLOOP] T_VERSION 조인 → 버전별 바인드(카티션 1행 추정·NL 457s 제거) · 순수 Current 는 0회
    V_VERLOOP_CNT := V_VERLOOP_CNT + 1;
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
/* L1392~1431 PRICE_C (8키 · 버전 미구분 = 이상⑤ 재현) */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.VERSION_NO = VL.VERSION_NO
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    A.DIVISION_ID = p_division_id
        AND    A.VERSION_NO = VL.VERSION_NO
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        AND    A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = '00000000' THEN '19000101' ELSE V_CUTOFF_FROM END, 'YYYYMMDD') AND TO_DATE(CASE WHEN V_CUTOFF_TO = '99999999' THEN '99991231' ELSE V_CUTOFF_TO END, 'YYYYMMDD')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END LOOP;
    IF V_VERLOOP_CNT > 1 THEN  -- [E20261105-DMF0082ONEQUERY-VERLOOP] 복수 버전 → 원문(8키 버전 미구분 집계 · 이상⑤) 과 같게 재집계
        MERGE INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C T
        USING (SELECT MIN(ROWID) AS RID, MAX(CREATE_DATE) AS CD, MAX(LAST_UPDATED_BY) AS LU
               FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
               HAVING COUNT(*) > 1) S
        ON (T.ROWID = S.RID)
        WHEN MATCHED THEN UPDATE SET T.CREATE_DATE = S.CD, T.LAST_UPDATED_BY = S.LU;
        DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C T
        WHERE  T.ROWID NOT IN (SELECT MIN(ROWID) FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE);
    END IF;
    SELECT COUNT(*) INTO V_TSI_CNT FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM;  -- [E20261106-DMF0082ONEQUERY-SZCLASS] S2 커서 크기 구간 선택
    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;   -- L1441
    /* [E20261104-DMF0082ONEQUERY] S2 — 사업부별 정적 INSERT 1개만 실행 · 순수 Current = CUR 변형(2-A 와 동일) / 버전 포함 = ALL 변형(Current arm G_CUR 게이트 + MF/SF/SP arm VER GTT 조인) */
    IF V_ONEQ_CURRENT THEN
    IF p_division_id LIKE '81%' THEN
    IF V_TSI_CNT >= C_SZ_TSI THEN  /* [E20261106-DMF0082ONEQUERY-SZCLASS] S2-81 대형 구간 커서(FLT_L) */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_L=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_L → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-81 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH BASE AS (  /* L1446~2361 Current 8 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A5 L1816 MKT_AMT 81 (DM_PLN_SALES_PLAN 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
    ), FLT_L AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_L;
    ELSE  /* [SZCLASS] S2-81 소형 구간 커서(FLT_S) — 같은 문장 · CTE 이름만 다름 */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_S=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_S → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-81 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH BASE AS (  /* L1446~2361 Current 8 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A5 L1816 MKT_AMT 81 (DM_PLN_SALES_PLAN 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
    ), FLT_S AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_S;
    END IF;  -- SZCLASS S2-81
    V_FNP_CNT := SQL%ROWCOUNT;  -- [SZCLASS] S3 토큰용 (직전 INSERT 행수)
    ELSIF p_division_id = '82' THEN
    IF V_TSI_CNT >= C_SZ_TSI THEN  /* [E20261106-DMF0082ONEQUERY-SZCLASS] S2-82 대형 구간 커서(FLT_L) */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_L=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_L → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-82 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH BASE AS (  /* L1446~2361 Current 8 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
    ), FLT_L AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_L;
    ELSE  /* [SZCLASS] S2-82 소형 구간 커서(FLT_S) — 같은 문장 · CTE 이름만 다름 */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_S=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_S → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-82 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH BASE AS (  /* L1446~2361 Current 8 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
    ), FLT_S AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_S;
    END IF;  -- SZCLASS S2-82
    V_FNP_CNT := SQL%ROWCOUNT;  -- [SZCLASS] S3 토큰용 (직전 INSERT 행수)
    ELSE
    IF V_TSI_CNT >= C_SZ_TSI THEN  /* [E20261106-DMF0082ONEQUERY-SZCLASS] S2-40 대형 구간 커서(FLT_L) */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_L=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_L → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-40 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH BASE AS (  /* L1446~2361 Current 8 arm */
        /* ── A2 L1559+L1750 수요·MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A7 L2054 판가 40 (DM_PLN_CFM_SELLING_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_T_WS_FCST D WHERE D.FCST_TYPE = A.FCST_TYPE)
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
    ), FLT_L AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_L;
    ELSE  /* [SZCLASS] S2-40 소형 구간 커서(FLT_S) — 같은 문장 · CTE 이름만 다름 */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_S=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_S → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-40 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH BASE AS (  /* L1446~2361 Current 8 arm */
        /* ── A2 L1559+L1750 수요·MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A7 L2054 판가 40 (DM_PLN_CFM_SELLING_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_T_WS_FCST D WHERE D.FCST_TYPE = A.FCST_TYPE)
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
    ), FLT_S AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_S;
    END IF;  -- SZCLASS S2-40
    V_FNP_CNT := SQL%ROWCOUNT;  -- [SZCLASS] S3 토큰용 (직전 INSERT 행수)
    END IF;
    ELSE
    IF p_division_id LIKE '81%' THEN
    IF V_TSI_CNT >= C_SZ_TSI THEN  /* [E20261106-DMF0082ONEQUERY-SZCLASS] S2-ALL-81 대형 구간 커서(FLT_L) */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_L=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_L → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-81 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LDC
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A5 L1816 MKT_AMT 81 (DM_PLN_SALES_PLAN 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        UNION ALL
        /* ── MF1 L2372~2476 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── MFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.PROJECT_CODE ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SF1 L2952~3056 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── SFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SPP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
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
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , A.CELL_MODEL
             , A.NICK_NAME
             , A.DMS_SALES
             , A.DMS_CUSTOMER
             , A.OWNER
             , A.DEPT_ID
             , A.DEPT_NAME_KO
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.ITEM_TYPE
             , A.PROJECT_NAME
             , A.PROJECT_OWNER
             , A.BIZ_TYPE
             , A.SOLDTO_CUSTOMER
             , A.COUNTRY_NAME
             , A.CITY_NAME
             , A.PROJECT_STATUS
             , A.ITEM_NAME
             , A.VMI_YN
             , A.CUST_GROUP
             , A.CUST_GROUP_DTL
             , A.APPLICATION
             , A.ROUTE
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.CELL_TYPE
             , A.FORECAST_INFO_ALL
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.CELL_MODEL_NICK_NAME
             , A.CELL_PER_CAR
             , A.CELL_PER_MODULE
             , A.MODULE_PER_CAR
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
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
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE = C.PROJECT_CODE
                    AND A.SCM_SITE_ID = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                    AND A.ITEM_ID = C.ITEM_ID
                    AND A.INCOTERMS = C.INCOTERMS
                    AND A.DOM_EXP = C.DOM_EXP
                    AND A.FCST_TYPE = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = C.YYYYMMDD
                    AND A.QTY <> 0 )
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV2
    ), FLT_L AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))
          AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_L;
    ELSE  /* [SZCLASS] S2-ALL-81 소형 구간 커서(FLT_S) — 같은 문장 · CTE 이름만 다름 */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_S=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_S → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-81 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LDC
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A5 L1816 MKT_AMT 81 (DM_PLN_SALES_PLAN 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD ) A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        UNION ALL
        /* ── MF1 L2372~2476 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── MFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.PROJECT_CODE ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SF1 L2952~3056 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── SFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SPP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
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
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , A.CELL_MODEL
             , A.NICK_NAME
             , A.DMS_SALES
             , A.DMS_CUSTOMER
             , A.OWNER
             , A.DEPT_ID
             , A.DEPT_NAME_KO
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.ITEM_TYPE
             , A.PROJECT_NAME
             , A.PROJECT_OWNER
             , A.BIZ_TYPE
             , A.SOLDTO_CUSTOMER
             , A.COUNTRY_NAME
             , A.CITY_NAME
             , A.PROJECT_STATUS
             , A.ITEM_NAME
             , A.VMI_YN
             , A.CUST_GROUP
             , A.CUST_GROUP_DTL
             , A.APPLICATION
             , A.ROUTE
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.CELL_TYPE
             , A.FORECAST_INFO_ALL
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.CELL_MODEL_NICK_NAME
             , A.CELL_PER_CAR
             , A.CELL_PER_MODULE
             , A.MODULE_PER_CAR
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
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
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE = C.PROJECT_CODE
                    AND A.SCM_SITE_ID = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                    AND A.ITEM_ID = C.ITEM_ID
                    AND A.INCOTERMS = C.INCOTERMS
                    AND A.DOM_EXP = C.DOM_EXP
                    AND A.FCST_TYPE = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = C.YYYYMMDD
                    AND A.QTY <> 0 )
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV2
    ), FLT_S AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))
          AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_S;
    END IF;  -- SZCLASS S2-ALL-81
    V_FNP_CNT := SQL%ROWCOUNT;  -- [SZCLASS] S3 토큰용 (직전 INSERT 행수)
    ELSIF p_division_id = '82' THEN
    IF V_TSI_CNT >= C_SZ_TSI THEN  /* [E20261106-DMF0082ONEQUERY-SZCLASS] S2-ALL-82 대형 구간 커서(FLT_L) */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_L=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_L → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-82 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LDC
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        UNION ALL
        /* ── MF1 L2372~2476 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── MFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.PROJECT_CODE ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SF1 L2952~3056 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── SFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SPP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
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
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , A.CELL_MODEL
             , A.NICK_NAME
             , A.DMS_SALES
             , A.DMS_CUSTOMER
             , A.OWNER
             , A.DEPT_ID
             , A.DEPT_NAME_KO
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.ITEM_TYPE
             , A.PROJECT_NAME
             , A.PROJECT_OWNER
             , A.BIZ_TYPE
             , A.SOLDTO_CUSTOMER
             , A.COUNTRY_NAME
             , A.CITY_NAME
             , A.PROJECT_STATUS
             , A.ITEM_NAME
             , A.VMI_YN
             , A.CUST_GROUP
             , A.CUST_GROUP_DTL
             , A.APPLICATION
             , A.ROUTE
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.CELL_TYPE
             , A.FORECAST_INFO_ALL
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.CELL_MODEL_NICK_NAME
             , A.CELL_PER_CAR
             , A.CELL_PER_MODULE
             , A.MODULE_PER_CAR
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
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
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE = C.PROJECT_CODE
                    AND A.SCM_SITE_ID = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                    AND A.ITEM_ID = C.ITEM_ID
                    AND A.INCOTERMS = C.INCOTERMS
                    AND A.DOM_EXP = C.DOM_EXP
                    AND A.FCST_TYPE = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = C.YYYYMMDD
                    AND A.QTY <> 0 )
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV2
    ), FLT_L AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))
          AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_L;
    ELSE  /* [SZCLASS] S2-ALL-82 소형 구간 커서(FLT_S) — 같은 문장 · CTE 이름만 다름 */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_S=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_S → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-82 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LDC
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */
        /* ── A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT /*+ FULL(A) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS  /*[E20261109-DMF0082PRICEFULL] 81/82 판가 원장 전체 읽기 - 클라우드 11-09 실측 82 35.58s->2.36s · 81 1.48s->1.16s · 결과 동일 · 사용자 승인 11-09*/
             , A.MEASURE
             , A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id LIKE '81%' OR p_division_id = '82')
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        UNION ALL
        /* ── MF1 L2372~2476 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── MFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.PROJECT_CODE ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SF1 L2952~3056 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── SFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SPP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
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
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , A.CELL_MODEL
             , A.NICK_NAME
             , A.DMS_SALES
             , A.DMS_CUSTOMER
             , A.OWNER
             , A.DEPT_ID
             , A.DEPT_NAME_KO
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.ITEM_TYPE
             , A.PROJECT_NAME
             , A.PROJECT_OWNER
             , A.BIZ_TYPE
             , A.SOLDTO_CUSTOMER
             , A.COUNTRY_NAME
             , A.CITY_NAME
             , A.PROJECT_STATUS
             , A.ITEM_NAME
             , A.VMI_YN
             , A.CUST_GROUP
             , A.CUST_GROUP_DTL
             , A.APPLICATION
             , A.ROUTE
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.CELL_TYPE
             , A.FORECAST_INFO_ALL
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.CELL_MODEL_NICK_NAME
             , A.CELL_PER_CAR
             , A.CELL_PER_MODULE
             , A.MODULE_PER_CAR
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
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
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE = C.PROJECT_CODE
                    AND A.SCM_SITE_ID = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                    AND A.ITEM_ID = C.ITEM_ID
                    AND A.INCOTERMS = C.INCOTERMS
                    AND A.DOM_EXP = C.DOM_EXP
                    AND A.FCST_TYPE = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = C.YYYYMMDD
                    AND A.QTY <> 0 )
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV2
    ), FLT_S AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))
          AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_S;
    END IF;  -- SZCLASS S2-ALL-82
    V_FNP_CNT := SQL%ROWCOUNT;  -- [SZCLASS] S3 토큰용 (직전 INSERT 행수)
    ELSE
    IF V_TSI_CNT >= C_SZ_TSI THEN  /* [E20261106-DMF0082ONEQUERY-SZCLASS] S2-ALL-40 대형 구간 커서(FLT_L) */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_L=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_L → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-40 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LDC
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */
        /* ── A2 L1559+L1750 수요·MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A7 L2054 판가 40 (DM_PLN_CFM_SELLING_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_T_WS_FCST D WHERE D.FCST_TYPE = A.FCST_TYPE)
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        UNION ALL
        /* ── MF1 L2372~2476 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── MFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.PROJECT_CODE ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SF1 L2952~3056 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── SFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SPP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
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
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , A.CELL_MODEL
             , A.NICK_NAME
             , A.DMS_SALES
             , A.DMS_CUSTOMER
             , A.OWNER
             , A.DEPT_ID
             , A.DEPT_NAME_KO
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.ITEM_TYPE
             , A.PROJECT_NAME
             , A.PROJECT_OWNER
             , A.BIZ_TYPE
             , A.SOLDTO_CUSTOMER
             , A.COUNTRY_NAME
             , A.CITY_NAME
             , A.PROJECT_STATUS
             , A.ITEM_NAME
             , A.VMI_YN
             , A.CUST_GROUP
             , A.CUST_GROUP_DTL
             , A.APPLICATION
             , A.ROUTE
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.CELL_TYPE
             , A.FORECAST_INFO_ALL
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.CELL_MODEL_NICK_NAME
             , A.CELL_PER_CAR
             , A.CELL_PER_MODULE
             , A.MODULE_PER_CAR
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
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
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE = C.PROJECT_CODE
                    AND A.SCM_SITE_ID = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                    AND A.ITEM_ID = C.ITEM_ID
                    AND A.INCOTERMS = C.INCOTERMS
                    AND A.DOM_EXP = C.DOM_EXP
                    AND A.FCST_TYPE = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = C.YYYYMMDD
                    AND A.QTY <> 0 )
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV2
    ), FLT_L AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))
          AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_L;
    ELSE  /* [SZCLASS] S2-ALL-40 소형 구간 커서(FLT_S) — 같은 문장 · CTE 이름만 다름 */
    /* [E20261104-DMF0082ONEQUERY] S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT_S=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT_S → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-40 */
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION )
    WITH LDC8 AS (  /* 소비처(L2448 등) 8키 재집계: MAX(CREATE_DATE) · LAST_UPDATED_BY KEEP LAST BY CREATE_DATE — 버전 간 합침 */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
             , MAX(CREATE_DATE) AS CREATE_DATE
             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LDC
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm + L2368~3697 버전 arm */
        /* ── A2 L1559+L1750 수요·MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        UNION ALL
        /* ── A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , B.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
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
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT) ── */
        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , CAST(NULL AS DATE) AS CREATE_DATE
             , CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── A7 L2054 판가 40 (DM_PLN_CFM_SELLING_PRICE 1회 읽기) ── */
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
        FROM (
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS
             , X.MEASURE
             , X.PLANT_SITE_ID, X.CELL_PROD_SITE_ID, X.YYYYMMDD
             , X.QTY
             , X.MEASURE_GROUP
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
             , X.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , X.AS_FROM_SITE
             , X.CREATE_DATE
             , X.LAST_UPDATED_BY
             , X.SENDER_CODE, X.SENDER_NAME, C.PROJECT_S_OP_REPORT
             , X.CURRENCY
             , X.VERSION_NO
             , X.CUTOFF_YYYYMMDD
             , X.NOTATION
             , X.X_ONEREAD_YMD
        FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , B.SORT_ORDER_NO
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        WHERE  (NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') AND (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))
        AND    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_T_WS_FCST D WHERE D.FCST_TYPE = A.FCST_TYPE)
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        AND    ROWNUM > 0  /* [E20261106-DMF0082ONEQUERY-NOJPPD] 항상 참. C(SITE_ITEM) 조인 술어가 이 윈도 뷰 안으로 밀리는 것(JPPD)을 막는다 — GTT 소수 행 추정 시 C 행마다 WS×PK 부분키 RANGE SCAN 을 반복(11-06 실측 minyonglee1/40 TEMP_SITE_ITEM 223행 파싱 → 필터 호출 48.9s · 전체 439.9s). 힌트 아님 · 행 집합 동일 */
        ) X
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = X.DIVISION_ID
            AND C.PROJECT_CODE = X.PROJECT_CODE
            AND C.SCM_SITE_ID  = X.SCM_SITE_ID
            AND C.ITEM_ID      = X.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        UNION ALL
        /* ── MF1 L2372~2476 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── MF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── MFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.PROJECT_CODE ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── MFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SF1 L2952~3056 수요+MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF2 수요+MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN_C 1회) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = M.BM
        LEFT JOIN LDC8 LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0
        AND    (M.PP = 'Y' OR A.YYYYMMDD >= F.NOW_YYYYMMDD)
        UNION ALL
        /* ── SF5 MKT_AMT 81 (DM_PLN_SALES_PLAN_C 집계) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , A.CREATE_DATE AS CREATE_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , CAST(NULL AS VARCHAR2(10)) AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , 'POINT3' AS NOTATION
        FROM   ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                     , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
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
            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'

        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  p_division_id LIKE '81%'
        AND    A.QTY <> 0
        UNION ALL
        /* ── SFP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SFR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
        UNION ALL
        /* ── SPP1 판가 81/82 (SCM_MST_FUTURE_PRICE_C) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id LIKE '81%' OR p_division_id = '82') AND A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPP2 판가 40 (DM_PLN_CFM_SELLING_PRICE_C) EC=A.END_CUSTOMER ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
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
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  (p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82')) AND A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD
        UNION ALL
        /* ── SPR 실적 (DM_PLN_SALES_PLAN_RESULT_C · A.MEASURE) ── */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE AS MEASURE
             , A.PLANT_SITE_ID AS PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(A.QTY AS NUMBER(30,10)) AS QTY
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
             , C.ENERGE, C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , LD.CREATE_DATE AS CREATE_DATE
             , LD.LAST_UPDATED_BY AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY AS CURRENCY
             , F.VERSION_NO AS VERSION_NO
             , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LDC8 LD
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
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION VER WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0
    ), LOCB AS (  /* [E20261106-DMF0082ONEQUERY-LOCB] L3707~3829 통화 룩업 원천 — BASE 의 LOC·조회범위 행만 좁은 열로 1회 (LOC9/8/5 가 BASE 59열을 3회 재스캔하던 것을 대체 · 행 집합 동일) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
        FROM   LOCB
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(PROJECT_CODE, '/') AS PROJECT_CODE, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(PLANT_SITE_ID, '/') AS PLANT_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(INCOTERMS, '/') AS INCOTERMS, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(PROJECT_CODE, '/'), NVL(SCM_SITE_ID, '/'), NVL(PLANT_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(INCOTERMS, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT NVL(DIVISION_ID, '/') AS DIVISION_ID, NVL(SCM_SITE_ID, '/') AS SCM_SITE_ID, NVL(ITEM_ID, '/') AS ITEM_ID, NVL(DOM_EXP, '/') AS DOM_EXP, NVL(FCST_TYPE, '/') AS FCST_TYPE, MIN(CURRENCY) AS CURRENCY
        FROM   LOCB
        WHERE  CURRENCY IS NOT NULL
        GROUP BY NVL(DIVISION_ID, '/'), NVL(SCM_SITE_ID, '/'), NVL(ITEM_ID, '/'), NVL(DOM_EXP, '/'), NVL(FCST_TYPE, '/')
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY, B.MEASURE_GROUP, B.CELL_MODEL, B.NICK_NAME, B.DMS_SALES, B.DMS_CUSTOMER, B.OWNER, B.DEPT_ID, B.DEPT_NAME_KO, B.FORECAST_INFO_CELL_PACK_COUNT, B.ITEM_TYPE, B.PROJECT_NAME, B.PROJECT_OWNER, B.BIZ_TYPE, B.SOLDTO_CUSTOMER, B.COUNTRY_NAME, B.CITY_NAME, B.PROJECT_STATUS, B.ITEM_NAME, B.VMI_YN, B.CUST_GROUP, B.CUST_GROUP_DTL, B.APPLICATION, B.ROUTE, B.MDM_PROJECT_NAME, B.MIN_CAPACITY, B.FORECAST_INFO_BIZ_TYPE, B.CELL_TYPE, B.FORECAST_INFO_ALL, B.FORECAST_INFO_SPEC, B.FORECAST_INFOR_VERSION, B.CELL_MODEL_NICK_NAME, B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.SORT_ORDER_NO, B.ENERGE, B.CELL_QUANTITY, B.AS_FROM_SITE, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.PROJECT_S_OP_REPORT, B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.NOTATION
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON (B.DIVISION_ID = L9.DIVISION_ID AND B.PROJECT_CODE = L9.PROJECT_CODE AND B.SCM_SITE_ID = L9.SCM_SITE_ID AND B.PLANT_SITE_ID = L9.PLANT_SITE_ID AND B.ITEM_ID = L9.ITEM_ID AND B.INCOTERMS = L9.INCOTERMS AND B.DOM_EXP = L9.DOM_EXP AND B.FCST_TYPE = L9.FCST_TYPE AND B.CELL_PROD_SITE_ID = L9.CELL_PROD_SITE_ID)
        LEFT JOIN LOC8 L8 ON (NVL(B.DIVISION_ID, '/') = L8.DIVISION_ID AND NVL(B.PROJECT_CODE, '/') = L8.PROJECT_CODE AND NVL(B.SCM_SITE_ID, '/') = L8.SCM_SITE_ID AND NVL(B.PLANT_SITE_ID, '/') = L8.PLANT_SITE_ID AND NVL(B.ITEM_ID, '/') = L8.ITEM_ID AND NVL(B.INCOTERMS, '/') = L8.INCOTERMS AND NVL(B.DOM_EXP, '/') = L8.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L8.FCST_TYPE)
        LEFT JOIN LOC5 L5 ON (NVL(B.DIVISION_ID, '/') = L5.DIVISION_ID AND NVL(B.SCM_SITE_ID, '/') = L5.SCM_SITE_ID AND NVL(B.ITEM_ID, '/') = L5.ITEM_ID AND NVL(B.DOM_EXP, '/') = L5.DOM_EXP AND NVL(B.FCST_TYPE, '/') = L5.FCST_TYPE)
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
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
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
        WHERE  ((NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%') OR NVL(p_version_type,'~') LIKE '%MF%' OR NVL(p_version_type,'~') LIKE '%SF%')
        AND    A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    ), DRV2 AS (  /* L3939~4111 SP 전용 LOC/KRW — RTF(A) ⟕ MKT_AMT_LOC(B, 버전 포함) ⟕ MKT_AMT_KRW(C, 버전 미포함 = 원문) */
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
                   WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
               END AS QTY
             , D.MEASURE_GROUP
             , A.CELL_MODEL
             , A.NICK_NAME
             , A.DMS_SALES
             , A.DMS_CUSTOMER
             , A.OWNER
             , A.DEPT_ID
             , A.DEPT_NAME_KO
             , A.FORECAST_INFO_CELL_PACK_COUNT
             , A.ITEM_TYPE
             , A.PROJECT_NAME
             , A.PROJECT_OWNER
             , A.BIZ_TYPE
             , A.SOLDTO_CUSTOMER
             , A.COUNTRY_NAME
             , A.CITY_NAME
             , A.PROJECT_STATUS
             , A.ITEM_NAME
             , A.VMI_YN
             , A.CUST_GROUP
             , A.CUST_GROUP_DTL
             , A.APPLICATION
             , A.ROUTE
             , A.MDM_PROJECT_NAME
             , A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE
             , A.CELL_TYPE
             , A.FORECAST_INFO_ALL
             , A.FORECAST_INFO_SPEC
             , A.FORECAST_INFOR_VERSION
             , A.CELL_MODEL_NICK_NAME
             , A.CELL_PER_CAR
             , A.CELL_PER_MODULE
             , A.MODULE_PER_CAR
             , D.SORT_ORDER_NO
             , A.ENERGE, A.CELL_QUANTITY
             , NVL(CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END, ' ') AS AS_FROM_SITE
             , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
             , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
             , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
             , B.CURRENCY
             , A.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
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
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
        LEFT JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , NVL(MAX(A.AS_FROM_SITE), ' ')    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   CUR A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE = C.PROJECT_CODE
                    AND A.SCM_SITE_ID = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                    AND A.ITEM_ID = C.ITEM_ID
                    AND A.INCOTERMS = C.INCOTERMS
                    AND A.DOM_EXP = C.DOM_EXP
                    AND A.FCST_TYPE = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD = C.YYYYMMDD
                    AND A.QTY <> 0 )
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
        WHERE  NVL(p_version_type,'~') LIKE '%SP%'
        AND    (CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
                END) IS NOT NULL
    ), UNI AS (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM CUR
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV1
        UNION ALL
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CAST(QTY AS NUMBER(30,10)) AS QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION FROM DRV2
    ), FLT_S AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  (NVL(p_version_type,'~') NOT LIKE '%SP%' OR F.MEASURE IS NULL OR F.MEASURE NOT IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP'))
          AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
    FROM   FLT_S;
    END IF;  -- SZCLASS S2-ALL-40
    V_FNP_CNT := SQL%ROWCOUNT;  -- [SZCLASS] S3 토큰용 (직전 INSERT 행수)
    END IF;
    END IF;  -- V_ONEQ_CURRENT
        /* [E20260820-SENTINELDDL] 구 [E20260815-SENTINEL] PLANT_SITE_ID 변형 정규화 UPDATE 삭제 —
       원장 일괄 정규화('-')·중복 제거 + DEFAULT ON NULL '-' DDL + 변형 기록 배치 정규화 완료(사용자 확인
       2026-08-20)로 변형(' '/'-'/'--'/CHR(0))이 원천 소멸. 아래 중복 제거 DELETE 는 안전망으로 존치. */

        /* 정규화로 같아진 행 중 1건만 남긴다. 상관 서브쿼리 대신 ROW_NUMBER 로 set-based 처리
       (진단·정정 SQL 도 튜닝 품질 유지).
       ⭐ 남길 행 = **QTY 최대** (사용자 확정 B, 2026-08-15). 값이 같은 그룹은 어느 행이 남아도
         동일하고, 다른 그룹(실측 16,395)만 최대값이 채택된다.
       ⛔ SUM 은 채택하지 않았다 — 동일 복제본이 다수(88%)라 합산하면 그만큼 3배가 된다. */
        --[E20260930-DMF0082QRYPERF-DEDUPCHK] 중복 존재 시에만 안전망 DELETE (0행 삭제에 전량 윈도정렬 비용 제거)
        -- [E20261105-DMF0082ONEQUERY-DUPSHORT] 12키(11키×일) 중복 선검사 — 0 이면 59열 중복도 0 (59열 동일 ⟹ 12키 동일) → 아래 L4220 검사·DELETE 생략
        SELECT COUNT(*) INTO V_DUP12 FROM (
            SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
            GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
            HAVING COUNT(*) > 1) WHERE ROWNUM = 1;
        IF V_DUP12 > 0 THEN
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
        END IF;  -- V_DUP12


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

    --[E20261027-DMF0082LASTUPDORD] LAST UPDATED BY · LAST UPDATE DATE 는 참고값 — 정렬 키에서도 뺀다 (사용자 요청 2026-10-27).
    --  [E20261027-DMF0082LASTUPD] 로 줄 묶음에서 뺀 것과 같은 기준: 두 컬럼을 Column Set 에 넣어도 줄 순서는 키 컬럼으로만 정한다.
    --  V_ORDERBY 는 ' ORDER BY SORT_KEY, 컬럼, 컬럼…' 형태라 ', 컬럼' 토큰만 제거한다(두 컬럼이 없으면 원래 값 그대로).
    V_ORDERBY := RTRIM(REPLACE(REPLACE(V_ORDERBY || ',', ', LAST_UPDATED_BY,', ','), ', LAST_UPDATE_DATE,', ','), ',');

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

    --[E20261013-DMF0082MANDRET] 화면 필수 표시 컬럼은 Column Setting 과 무관하게 항상 반환한다 (사용자 신고 2026-10-13).
    --  화면은 필수 컬럼(메타 USER_SELECTABLE_FLAG='N' + VISIBLE_FLAG='Y')을 사용자 컬럼 저장 내역에 없어도 항상 표시한다.
    --  위 루프는 저장 키 12컬럼만 보장하므로, 그 밖의 필수 컬럼은 저장 내역에 없는 사용자에게 값이 내려가지 않았다
    --  (실측: AS_FROM_SITE 를 필수로 바꾼 뒤 컬럼은 보이고 값이 빈칸).
    --  판정식 = [E20261012-DMF0082MANDCOL] 과 같은 메타 · division 토큰 규칙. 최종 피벗 원천에 실제로 있는 컬럼만 넣는다
    --  (없는 컬럼이 필수로 등록돼도 ORA-00904 가 나지 않게). 이미 있으면 넣지 않는다(멱등).
    FOR K IN ( SELECT C.COLUMN_NAME AS C
                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE C.PROGRAM_ID  = VA_PROGRAM_ID
                  AND C.SHEET_NAME  = VA_SHEET_NAME
                  AND C.VALID_YN    = 'Y'
                  AND C.USER_SELECTABLE_FLAG = 'N'
                  AND C.VISIBLE_FLAG = 'Y'
                  AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0)
                  AND C.COLUMN_NAME IN ( SELECT T.COLUMN_NAME FROM USER_TAB_COLUMNS T WHERE T.TABLE_NAME = 'GT_DMF0082_MF_SP' )
                ORDER BY C.SORT_ORDER_NO, C.COLUMN_NAME ) LOOP
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
    /* [E20261104-DMF0082ONEQUERY] S3 — 편집권한·MF_SP·후처리·PIVOT 을 동적 SQL 1 문장으로. 원문 대응은 STEP_MAP.md. */
    DECLARE
        V_Q        CLOB;
        V_ADMQ     CLOB;                              -- INTOG/ADM0/ADM CTE (O_RC1 · O_RC4 공용)
        V_NEEDS    VARCHAR2(32767);                   -- ',COL,' 참조 토큰 (V_COLUMN ∪ V_GROUPBY ∪ V_ORDERBY ∪ LU 키)
        V_COLS     VARCHAR2(32767);                   -- 현재 단계 열 목록 (콤마, 공백 없음)
        V_MSPSEL   CLOB;
        V_GB       VARCHAR2(4000);
        V_PREV     VARCHAR2(30);
        V_HAS_AFS  BOOLEAN := FALSE;
        V_HAS_LU   BOOLEAN := FALSE;
        V_HIDE_CP  BOOLEAN := FALSE;
        V_HIDE_PL  BOOLEAN := FALSE;
        V_MSP_ID   BOOLEAN := FALSE;   -- MSP 집계가 항등(입력 그레인이 이미 11키×일 유일)인지 — 실행 시 실측 판정
        V_DUPK     NUMBER;
        V_DUPC     NUMBER;
        V_AS_YN    VARCHAR2(1) := 'N';
        V_CNT      NUMBER;
        V_LU_KEYS  VARCHAR2(4100 CHAR);
        V_DISPK    VARCHAR2(32767);
        -- [E20261105-DMF0082ONEQUERY-KIDPIVOT] 피벗 그룹 키(V_COLUMN + SORT_ORDER_NO) 를 정수 KID_ 로 압축 — 사용자 제안(2026-11-05 "pivot 전에 pivot 에 맞도록 group")
        V_PK       VARCHAR2(32767);   -- 피벗 그룹 키 열 목록(= V_COLUMN ∪ SORT_ORDER_NO · 중복 제거)
        V_GX       VARCHAR2(32767);   -- arm GROUP BY 에만 있고 PK 에 없는 열(V_GB − PK · 예: EDIT_FLAG)
        V_REST     VARCHAR2(32767);   -- DISPK 가 KID_ 외에 실을 열(GX ∪ NOTATION·MEASURE·YYYYMM·YYYYMMWW·WEEK_END_YN·MONTH_END_YN·BUCKET_KEY)
        V_KJOIN    VARCHAR2(32767);
        V_CPXF     CONSTANT VARCHAR2(400) := q'{CASE WHEN F.CELL_PROD_SITE_ID = '/' OR (F.CELL_PROD_SITE_ID IS NOT NULL AND TRIM(F.CELL_PROD_SITE_ID) IS NULL) THEN '-' ELSE F.CELL_PROD_SITE_ID END}';   -- [LKGTT] M1 치환식(F 별칭)   -- DISP↔KEYS NULL 안전 등가(SYS_OP_MAP_NONNULL · 해시 조인 가능 · NULL↔값 충돌 없음)
        V_QF       CONSTANT VARCHAR2(200) := q'{((X.MEASURE NOT IN ('SCM_FCST','FCST_GAP') AND X.QTY <> 0) OR X.MEASURE IN ('SCM_FCST','FCST_GAP'))}';
        V_K10      CONSTANT VARCHAR2(400) := q'{NVL(X.DIVISION_ID,'/'), NVL(X.PROJECT_CODE,'/'), NVL(X.END_CUSTOMER,'/'), NVL(X.SCM_SITE_ID,'/'), NVL(X.ITEM_ID,'/'), NVL(X.DOM_EXP,'/'), NVL(X.FCST_TYPE,'/'), NVL(X.INCOTERMS,'/'), NVL(X.PLANT_SITE_ID,'/'), NVL(X.CELL_PROD_SITE_ID,'/')}';
        V_K8T      CONSTANT VARCHAR2(400) := q'{NVL(X.DIVISION_ID,'~'), NVL(X.PROJECT_CODE,'~'), NVL(X.END_CUSTOMER,'~'), NVL(X.SCM_SITE_ID,'~'), NVL(X.ITEM_ID,'~'), NVL(X.DOM_EXP,'~'), NVL(X.FCST_TYPE,'~'), NVL(X.INCOTERMS,'~')}';
        V_K10A     CONSTANT VARCHAR2(800) := q'{NVL(X.DIVISION_ID,'/') AS K1, NVL(X.PROJECT_CODE,'/') AS K2, NVL(X.END_CUSTOMER,'/') AS K3, NVL(X.SCM_SITE_ID,'/') AS K4, NVL(X.ITEM_ID,'/') AS K5, NVL(X.DOM_EXP,'/') AS K6, NVL(X.FCST_TYPE,'/') AS K7, NVL(X.INCOTERMS,'/') AS K8, NVL(X.PLANT_SITE_ID,'/') AS K9, NVL(X.CELL_PROD_SITE_ID,'/') AS K10}';
        V_K10J     CONSTANT VARCHAR2(800) := q'{NVL(X.DIVISION_ID,'/') = R.K1 AND NVL(X.PROJECT_CODE,'/') = R.K2 AND NVL(X.END_CUSTOMER,'/') = R.K3 AND NVL(X.SCM_SITE_ID,'/') = R.K4 AND NVL(X.ITEM_ID,'/') = R.K5 AND NVL(X.DOM_EXP,'/') = R.K6 AND NVL(X.FCST_TYPE,'/') = R.K7 AND NVL(X.INCOTERMS,'/') = R.K8 AND NVL(X.PLANT_SITE_ID,'/') = R.K9 AND NVL(X.CELL_PROD_SITE_ID,'/') = R.K10}';
        V_K8A      CONSTANT VARCHAR2(600) := q'{NVL(X.DIVISION_ID,'~') AS K1, NVL(X.PROJECT_CODE,'~') AS K2, NVL(X.END_CUSTOMER,'~') AS K3, NVL(X.SCM_SITE_ID,'~') AS K4, NVL(X.ITEM_ID,'~') AS K5, NVL(X.DOM_EXP,'~') AS K6, NVL(X.FCST_TYPE,'~') AS K7, NVL(X.INCOTERMS,'~') AS K8}';
        V_K8J      CONSTANT VARCHAR2(600) := q'{NVL(X.DIVISION_ID,'~') = R.K1 AND NVL(X.PROJECT_CODE,'~') = R.K2 AND NVL(X.END_CUSTOMER,'~') = R.K3 AND NVL(X.SCM_SITE_ID,'~') = R.K4 AND NVL(X.ITEM_ID,'~') = R.K5 AND NVL(X.DOM_EXP,'~') = R.K6 AND NVL(X.FCST_TYPE,'~') = R.K7 AND NVL(X.INCOTERMS,'~') = R.K8}';

        FUNCTION LIT(p IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN RETURN '''' || REPLACE(p, '''', '''''') || ''''; END;

        FUNCTION NEED(p IN VARCHAR2) RETURN BOOLEAN IS
        BEGIN RETURN INSTR(V_NEEDS, ',' || p || ',') > 0; END;

        FUNCTION HASCOL(p IN VARCHAR2) RETURN BOOLEAN IS
        BEGIN RETURN INSTR(',' || V_COLS || ',', ',' || p || ',') > 0; END;

        -- 현재 열 목록을 X. 접두로 투영하되 최대 3개 열을 식으로 치환
        FUNCTION PROJ(p_n1 VARCHAR2 DEFAULT NULL, p_e1 VARCHAR2 DEFAULT NULL
                    , p_n2 VARCHAR2 DEFAULT NULL, p_e2 VARCHAR2 DEFAULT NULL
                    , p_n3 VARCHAR2 DEFAULT NULL, p_e3 VARCHAR2 DEFAULT NULL) RETURN CLOB IS
            v   CLOB; tok VARCHAR2(200); n PLS_INTEGER := REGEXP_COUNT(V_COLS, '[^,]+');
        BEGIN
            FOR i IN 1 .. n LOOP
                tok := REGEXP_SUBSTR(V_COLS, '[^,]+', 1, i);
                v := v || CASE WHEN i > 1 THEN ', ' END
                       || CASE WHEN tok = p_n1 THEN p_e1 || ' AS ' || tok
                               WHEN tok = p_n2 THEN p_e2 || ' AS ' || tok
                               WHEN tok = p_n3 THEN p_e3 || ' AS ' || tok
                               ELSE 'X.' || tok END;
            END LOOP;
            RETURN v;
        END;
    BEGIN
        -- 참조 열 토큰 (식별자 경계만 남긴다)
        V_NEEDS := ',' || REGEXP_REPLACE(UPPER(V_COLUMN || ',' || V_GROUPBY || ',' || V_ORDERBY), '[^A-Z0-9_]+', ',') || ',';
        IF NEED('TEAM_ID')                  THEN V_NEEDS := V_NEEDS || 'DEPT_ID,'; END IF;
        IF NEED('TEAM_NAME_KO')             THEN V_NEEDS := V_NEEDS || 'DEPT_NAME_KO,'; END IF;
        IF NEED('FORECAST_INFO_CELL_MODEL') THEN V_NEEDS := V_NEEDS || 'CELL_MODEL,'; END IF;
        IF NEED('LAST_UPDATE_DATE')         THEN V_NEEDS := V_NEEDS || 'CREATE_DATE,'; END IF;
        V_HAS_AFS := INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',AS_FROM_SITE,') > 0;                       -- L4992
        V_HAS_LU  := INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',LAST_UPDATED_BY,') > 0
                  OR INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',LAST_UPDATE_DATE,') > 0;                   -- L5235
        IF V_HAS_LU THEN V_NEEDS := V_NEEDS || 'CREATE_DATE,LAST_UPDATED_BY,'; END IF;

        -- L5076~5102 CELL_PROD_SITE_ID 숨김 판정 / L5161~5182 PLANT_SITE_ID 숨김 판정 (원문 그대로)
        SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = VA_PROGRAM_ID AND U.SHEET_NAME = VA_SHEET_NAME AND U.USER_ID = p_created_by
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';
        IF V_CNT = 0 THEN
            SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = VA_PROGRAM_ID AND C.SHEET_NAME = VA_SHEET_NAME AND C.COLUMN_NAME = 'CELL_PROD_SITE_ID'
               AND C.VALID_YN = 'Y' AND C.USER_SELECTABLE_FLAG = 'N' AND C.VISIBLE_FLAG = 'Y'
               AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0);
        END IF;
        V_HIDE_CP := (V_CNT = 0);
        SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = VA_PROGRAM_ID AND U.SHEET_NAME = VA_SHEET_NAME AND U.USER_ID = p_created_by
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' AND U.COLUMN_NAME = 'PLANT_SITE_ID';
        IF V_CNT = 0 THEN
            SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = VA_PROGRAM_ID AND C.SHEET_NAME = VA_SHEET_NAME AND C.COLUMN_NAME = 'PLANT_SITE_ID'
               AND C.VALID_YN = 'Y' AND C.USER_SELECTABLE_FLAG = 'N' AND C.VISIBLE_FLAG = 'Y'
               AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0);
        END IF;
        V_HIDE_PL := (V_CNT = 0);

        -- [E20261104-DMF0082ONEQUERY] MSP 항등 판정 — 원문 L4686 MF_SP INSERT 의 GROUP BY 키(11키+일+MEASURE_GROUP+SORT_ORDER_NO+달력·PVT 열)는
        --   (a) TEMP_FCST_N_PRICE 가 11키×YYYYMMDD 로 유일하고 (b) 달력이 일자당 1행이면 한 그룹 = 한 행이라 MAX/SUM 이 항등이다.
        --   (PVT·VD 는 GROUP BY 산출이라 구조적으로 키당 1행.) 두 조건을 매 실행 실측해 참일 때만 집계 없이 투영한다
        --   — 82 실측(11-04 19:00) 451,287행 → 451,287행(축소 0)인데 HASH GROUP BY 가 TEMP 1.0GB 를 썼다.
        -- [E20261105-DMF0082ONEQUERY-DUPSHORT] S2 직후 선검사 V_DUP12 가 0 이면 이후 DELETE(qty_yn·고아)는 행을 지울 뿐이라 중복이 생기지 않는다 → 재검사 생략
        IF V_DUP12 = 0 THEN
            V_DUPK := 0;
        ELSE
        SELECT COUNT(*) INTO V_DUPK FROM (
            SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
            GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
            HAVING COUNT(*) > 1) WHERE ROWNUM = 1;
        END IF;
        SELECT COUNT(*) INTO V_DUPC FROM (
            SELECT 1 FROM SCM_MGR.SCM_SYS_CALENDAR_M
            WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND V_EXP_YYYYMMDD
            GROUP BY BASIS_YYYYMMDD HAVING COUNT(*) > 1) WHERE ROWNUM = 1;
        V_MSP_ID := (V_DUPK = 0 AND V_DUPC = 0);

        -- L4760~4764 AS_YN (비상관 — 1회 판정)
        IF p_scm_site_id IS NULL OR p_scm_site_id = 'ALL' THEN
            V_AS_YN := 'N';
        ELSE
            SELECT CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END INTO V_AS_YN
              FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') SA
              JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL SB
                ON SA.TOKEN = SB.SEGMENT1 AND SB.LOOKUP_TYPE = 'AS_SITE_PLANT';
        END IF;

        -- L5238~5248 LU 키 (원문 그대로)
        IF V_HAS_LU THEN
            DECLARE
                V_LU_SRC  VARCHAR2(4100 CHAR) := REPLACE(V_COLUMN, ' ', '') || ',SORT_ORDER_NO';
                V_LU_COL  VARCHAR2(200 CHAR);
            BEGIN
                FOR I IN 1 .. REGEXP_COUNT(V_LU_SRC, '[^,]+') LOOP
                    V_LU_COL := REGEXP_SUBSTR(V_LU_SRC, '[^,]+', 1, I);
                    IF V_LU_COL NOT IN ('LAST_UPDATED_BY', 'LAST_UPDATE_DATE', 'CREATE_DATE')
                    AND INSTR(',' || V_LU_KEYS || ',', ',' || V_LU_COL || ',') = 0 THEN
                        V_LU_KEYS := CASE WHEN V_LU_KEYS IS NULL THEN V_LU_COL ELSE V_LU_KEYS || ', ' || V_LU_COL END;
                    END IF;
                END LOOP;
            END;
        END IF;

        -- ───────── ADM CTE (L4437~4647) ─────────
        V_ADMQ := q'{INTOG AS (
    SELECT B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, LM.TOKEN AS LIMIT_MEASURE
    FROM  (SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS MEASURE, DT.TOKEN AS DAYS
                , A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, A.ATTRIBUTE4 AS LIMIT_MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL) AS TOKEN
                               FROM   DUAL
                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(A.ATTRIBUTE1, ','), 0) + 1) DT
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND (A.SEGMENT1 = [UG]
             OR A.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN ([UG], [CB]) AND G.USE_YN = 'Y'))
           AND    A.SEGMENT2 = [PG]
           AND    A.SEGMENT3 = [DV]
          ) B
    CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL) AS TOKEN
                        FROM   DUAL
                        CONNECT BY LEVEL <= NVL(REGEXP_COUNT(B.LIMIT_MEASURE, ','), 0) + 1) LM
    WHERE (REPLACE(B.DAYS, ' ', '') IS NULL
           OR B.DAYS = TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'))
    AND   (REPLACE(B.FROM_TIME, ' ', '') IS NULL
           OR B.FROM_TIME <= TO_CHAR(SYSDATE, 'HH24MI'))
    AND   (REPLACE(B.TO_TIME, ' ', '') IS NULL
           OR B.TO_TIME >= TO_CHAR(SYSDATE, 'HH24MI'))
), ADM0 AS (
    SELECT A.SEGMENT4 AS MEASURE
         , CASE WHEN EXISTS (SELECT 1 FROM INTOG B WHERE B.MEASURE = A.SEGMENT4) THEN 'Y'
                WHEN EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
                    WHERE  T.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                    AND    T.VALID_YN = 'Y'
                    AND   (T.SEGMENT1 = [UG]
                           OR T.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                             WHERE G.USER_ID IN ([UG], [CB]) AND G.USE_YN = 'Y'))
                    AND    T.SEGMENT2 = [PG]
                    AND    T.SEGMENT3 = [DV]
                    AND    T.SEGMENT4 = A.SEGMENT4
                    AND    REPLACE(T.ATTRIBUTE1, ' ', '') IS NOT NULL
               ) THEN 'T'
                ELSE 'N' END AS EDIT_AUTH_YN
         , CASE WHEN A.ATTRIBUTE1 IS NOT NULL THEN 'Y' ELSE 'N' END AS TODAY_LIMIT_YN
         , A.ATTRIBUTE1 AS TODAY_DAY_LIST
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND    A.SEGMENT2    = [PG]
    GROUP BY A.SEGMENT4, A.ATTRIBUTE1
), ADM AS (
    SELECT A.MEASURE, A.TODAY_LIMIT_YN, A.TODAY_DAY_LIST
         , CASE WHEN A.E4 = 'Y'
                 AND EXISTS (SELECT 1 FROM INTOG B WHERE B.MEASURE = A.MEASURE)
                 AND NOT EXISTS (
                     SELECT 1
                     FROM   INTOG B
                     WHERE  B.MEASURE = A.MEASURE
                     AND    NOT EXISTS (
                              SELECT 1
                              FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                              WHERE  L2.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                              AND    L2.VALID_YN    = 'Y'
                              AND    L2.SEGMENT2    = [PG]
                              AND    L2.SEGMENT3    = [DV]
                              AND    L2.SEGMENT4    = B.MEASURE
                              AND    L2.SEGMENT1    = B.LIMIT_MEASURE
                              AND    REPLACE(L2.ATTRIBUTE1, ' ', '') IS NOT NULL
                              AND    INSTR(',' || REPLACE(L2.ATTRIBUTE1, ' ', '') || ',',
                                           ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0
                              AND    L2.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI')
                              AND    L2.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI')))
                THEN 'N' ELSE A.E4 END AS EDIT_AUTH_YN
    FROM (
        SELECT A.*
             , CASE WHEN EXISTS (SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                   CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(L.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS TOKEN
                                       FROM   DUAL
                                       CONNECT BY LEVEL <= NVL(REGEXP_COUNT(L.ATTRIBUTE4, ','), 0) + 1) LM
                   WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                   AND    L.VALID_YN    = 'Y'
                   AND    L.SEGMENT2    = [PG]
                   AND    L.SEGMENT3    = [DV]
                   AND    REPLACE(L.ATTRIBUTE4, ' ', '') IS NOT NULL
                   AND   (REPLACE(L.ATTRIBUTE1, ' ', '') IS NULL
                          OR INSTR(',' || REPLACE(L.ATTRIBUTE1, ' ', '') || ',',
                                   ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0)
                   AND   (REPLACE(L.ATTRIBUTE2, ' ', '') IS NULL
                          OR L.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI'))
                   AND   (REPLACE(L.ATTRIBUTE3, ' ', '') IS NULL
                          OR L.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI'))
                   AND    TRIM(LM.TOKEN) = A.MEASURE
                   AND    NOT EXISTS (SELECT 1
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L3
                                      WHERE  L3.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                                      AND    L3.VALID_YN    = 'Y'
                                      AND    L3.SEGMENT2    = [PG]
                                      AND    L3.SEGMENT3    = [DV]
                                      AND    L3.SEGMENT1    = TRIM(LM.TOKEN)))
                    THEN 'N' ELSE A.E3 END AS E4
        FROM (
            SELECT A.*
                 , CASE WHEN A.MEASURE = 'VMI_In_Req'
                        THEN CASE WHEN [DV] IN ('40', '82')
                                   AND NOT ( ( [UG] IN ('DM Viewer', 'SCP Planner')
                                               OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                          WHERE G.USER_ID IN ([UG], [CB])
                                                          AND   G.USER_GR_ID IN ('DM Viewer', 'SCP Planner') AND G.USE_YN = 'Y') )
                                             AND NOT EXISTS (SELECT 1 FROM INTOG B WHERE B.MEASURE = 'VMI_In_Req') )
                                  THEN 'Y' ELSE 'N' END
                        ELSE A.E2 END AS E3
            FROM (
                SELECT A.*
                     , CASE WHEN A.MEASURE = 'AS_In_Req'
                            THEN CASE WHEN ([DV] LIKE '81%' OR [DV] = '82')
                                       AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                   WHERE G.USER_ID IN ([UG], [CB])
                                                   AND   G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
                                      THEN 'Y' ELSE 'N' END
                            ELSE A.E1 END AS E2
                FROM (
                    SELECT A.*
                         , CASE WHEN A.MEASURE = 'LOC'
                                 AND ( NOT EXISTS (SELECT 1
                                                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                                   WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                                                   AND    L.VALID_YN    = 'Y'
                                                   AND    L.SEGMENT2    = [PG]
                                                   AND    L.SEGMENT3    = [DV])
                                       OR ( [DV] NOT LIKE '81%'
                                            AND NOT ( [UG] = 'SCP Planner'
                                                OR EXISTS (SELECT 1
                                                           FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                           WHERE  G.USER_ID    IN ([UG], [CB])
                                                           AND    G.USER_GR_ID = 'SCP Planner'
                                                           AND    G.USE_YN     = 'Y') )
                                            AND NOT ( [UG] = 'DM Viewer'
                                                OR EXISTS (SELECT 1
                                                           FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                           WHERE  G.USER_ID    IN ([UG], [CB])
                                                           AND    G.USER_GR_ID = 'DM Viewer'
                                                           AND    G.USE_YN     = 'Y') ) ) )
                                THEN 'Y' ELSE A.EDIT_AUTH_YN END AS E1
                    FROM ADM0 A
                ) A
            ) A
        ) A
    ) A
)}';
        V_ADMQ := REPLACE(V_ADMQ, '[UG]', LIT(p_user_group));
        V_ADMQ := REPLACE(V_ADMQ, '[CB]', LIT(p_created_by));
        V_ADMQ := REPLACE(V_ADMQ, '[PG]', LIT(VA_PROGRAM_ID));
        V_ADMQ := REPLACE(V_ADMQ, '[DV]', LIT(p_division_id));

        -- ───────── O_RC4 (L5372~5375) ─────────
        OPEN O_RC4 FOR 'WITH ' || V_ADMQ || ' SELECT MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST FROM ADM ORDER BY MEASURE';

        -- ───────── MSP (L4688~4828) — 참조 열만 MAX (G1) ─────────
        V_COLS := 'DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,BUCKET_TYPE,BUCKET_KEY,QTY,MEASURE_GROUP';
        V_MSPSEL := q'{F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID, F.CELL_PROD_SITE_ID
         , CAL.BUCKET_TYPE, CAL.BUCKET_KEY, }' || CASE WHEN V_MSP_ID THEN 'F.QTY' ELSE 'SUM(F.QTY)' END || q'{ AS QTY, F.MEASURE_GROUP}';
        FOR R IN (SELECT COLUMN_VALUE AS C FROM TABLE(SYS.ODCIVARCHAR2LIST(
                    'CELL_MODEL','NICK_NAME','DMS_SALES','DMS_CUSTOMER','OWNER','DEPT_ID','DEPT_NAME_KO'
                   ,'FORECAST_INFO_CELL_PACK_COUNT','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','BIZ_TYPE'
                   ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','PROJECT_STATUS','ITEM_NAME','VMI_YN'
                   ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                   ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_ALL','FORECAST_INFO_SPEC'
                   ,'FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME','CELL_PER_CAR','CELL_PER_MODULE','MODULE_PER_CAR'
                   ,'ENERGE','CELL_QUANTITY','CREATE_DATE','LAST_UPDATED_BY','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT'
                   ,'VERSION_NO','CUTOFF_YYYYMMDD'))) LOOP
            IF NEED(R.C) THEN
                -- 숫자 속성은 MF_SP 열 타입 NUMBER(20,10) 으로 CAST — 원문 커서가 GTT 열 타입(20,10)을 보고하던 것과 같게 (집계 결과는 타입이 NUMBER 로 풀려 클라이언트 표현이 달라짐 · 11-04 실측 20.0 vs 20)
                IF R.C IN ('FORECAST_INFO_CELL_PACK_COUNT', 'MIN_CAPACITY', 'CELL_PER_CAR', 'CELL_PER_MODULE', 'MODULE_PER_CAR', 'CELL_QUANTITY') THEN
                    V_MSPSEL := V_MSPSEL || CHR(10) || '         , CAST(' || CASE WHEN V_MSP_ID THEN 'F.' || R.C ELSE 'MAX(F.' || R.C || ')' END || ' AS NUMBER(20,10)) AS ' || R.C;
                ELSE
                    V_MSPSEL := V_MSPSEL || CHR(10) || '         , ' || CASE WHEN V_MSP_ID THEN 'F.' || R.C ELSE 'MAX(F.' || R.C || ')' END || ' AS ' || R.C;
                END IF;
                V_COLS   := V_COLS || ',' || R.C;
            END IF;
        END LOOP;
        V_MSPSEL := V_MSPSEL || q'{
         , F.SORT_ORDER_NO
         , NVL(}' || CASE WHEN V_MSP_ID THEN 'F.AS_FROM_SITE' ELSE 'MAX(F.AS_FROM_SITE)' END || q'{, ' ') AS AS_FROM_SITE
         , }' || CASE WHEN V_MSP_ID THEN 'F.CURRENCY' ELSE 'MAX(F.CURRENCY)' END || q'{ AS CURRENCY
         , }' || CASE WHEN V_MSP_ID THEN 'F.NOTATION' ELSE 'MAX(F.NOTATION)' END || q'{ AS NOTATION
         , CASE WHEN [DV] = '82' THEN 'N'
                WHEN [GRP] = 'ADMIN' THEN 'Y'
                WHEN EXISTS (
                    SELECT 1 FROM ADM MA
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
         , '999' AS SORT_KEY
         , CAST(NULL AS VARCHAR2(50)) AS GROUP_ID
         , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
         , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN}';
        V_COLS := V_COLS || ',SORT_ORDER_NO,AS_FROM_SITE,CURRENCY,NOTATION,EDIT_FLAG,SORT_KEY,GROUP_ID,SUN,MON,TUE,WED,THU,FRI,SAT,YYYYMM,YYYYMMWW,WEEK_END_YN,MONTH_END_YN';
        IF NEED('NEW_FLAG')    THEN V_MSPSEL := V_MSPSEL || q'{
         , 'N' AS NEW_FLAG}';                                   V_COLS := V_COLS || ',NEW_FLAG';    END IF;
        IF NEED('AS_YN')       THEN V_MSPSEL := V_MSPSEL || q'{
         , [ASYN] AS AS_YN}';                                   V_COLS := V_COLS || ',AS_YN';       END IF;
        IF NEED('VMI_STD_DIO') THEN V_MSPSEL := V_MSPSEL || CHR(10) || '         , '
            || CASE WHEN V_MSP_ID THEN 'VD.VMI_STD_DIO' ELSE 'MAX(VD.VMI_STD_DIO)' END || ' AS VMI_STD_DIO'; V_COLS := V_COLS || ',VMI_STD_DIO'; END IF;
        IF NEED('ATTR1')       THEN V_MSPSEL := V_MSPSEL || q'{
         , CAST(NULL AS VARCHAR2(4000)) AS ATTR1}';             V_COLS := V_COLS || ',ATTR1';       END IF;
        -- M7 용 행 식별자 (원문 L5257 MERGE 가 MF_SP.ROWID 로 갱신하던 것과 동형) — 두 열 표시 시에만 운반
        IF V_HAS_LU THEN V_MSPSEL := V_MSPSEL || CHR(10) || '         , '
            || CASE WHEN V_MSP_ID THEN 'F.ROWID' ELSE 'MIN(F.ROWID)' END || ' AS RID_'; V_COLS := V_COLS || ',RID_'; END IF;

        DBMS_LOB.CREATETEMPORARY(V_Q, TRUE);
        V_Q := 'WITH ' || V_ADMQ || q'{
, CAL AS (  /* L4768~4797 (주 달력 GTT 조인 WE 는 결과 무영향 — 제거) */
    SELECT D.BASIS_YYYYMMDD
         , TO_CHAR(D.BASIS_YYYYMMDD) AS BUCKET_KEY
         , 'D' AS BUCKET_TYPE
         , D.BASIS_YYYYMM AS YYYYMM
         , D.BASIS_YYYYMM || LPAD(TRIM(D.ISO_WEEK), 2, '0') AS YYYYMMWW
         , CASE WHEN WE2.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
         , CASE WHEN ME.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M D
    LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD BETWEEN [FROM] AND [TO]
               GROUP BY BASIS_YYYYMM, ISO_WEEK) WE2
        ON  WE2.WEEK_END_DATE = D.BASIS_YYYYMMDD
    LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD BETWEEN [FROM] AND [TO]
               GROUP BY BASIS_YYYYMM) ME
        ON  ME.MONTH_END_DATE = D.BASIS_YYYYMMDD
    WHERE  D.BASIS_YYYYMMDD BETWEEN [FROM] AND [EXP]
), PVT AS (  /* L4802~4815 */
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
)}';
        IF NEED('VMI_STD_DIO') THEN
            V_Q := V_Q || q'{
, VD AS (  /* L4816~4822 */
    SELECT S.SCM_SITE_ID, MAX(S.VMI_YN || '^' || NVL(TO_CHAR(S.ATTRIBUTE5),'')) AS VMI_STD_DIO
    FROM   SCM_MGR.SCM_MST_SITE S
    WHERE  S.DIVISION_ID = '82'
    AND    [DV] = '82'
    GROUP BY S.SCM_SITE_ID
)}';
        END IF;
        V_Q := V_Q || q'{
, MSP AS (
    SELECT }' || V_MSPSEL || q'{
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
    INNER JOIN CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD
    LEFT JOIN PVT ON  PVT.DIVISION_ID = F.DIVISION_ID
                  AND PVT.SCM_SITE_ID = F.SCM_SITE_ID
                  AND PVT.INCOTERMS   = F.INCOTERMS}'
            || CASE WHEN NEED('VMI_STD_DIO') THEN q'{
    LEFT JOIN VD ON VD.SCM_SITE_ID = F.SCM_SITE_ID}' END
            || CASE WHEN V_MSP_ID THEN q'{
    /* MSP 항등 경로: 11키×일 유일 실측 — GROUP BY 생략 */}' ELSE q'{
    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
           , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
           , F.CELL_PROD_SITE_ID, CAL.BUCKET_TYPE, CAL.BUCKET_KEY, F.MEASURE_GROUP
           , F.SORT_ORDER_NO
           , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
           , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN}' END || q'{
)}';
        V_PREV := 'MSP';

        -- M1 (L4972~4983): AS_FROM_SITE 는 이미 NVL ' ' · CELL_PROD '/'·공백 → '-'
        V_Q := V_Q || CHR(10) || ', M1 AS (SELECT ' || PROJ('CELL_PROD_SITE_ID',
                 q'{CASE WHEN X.CELL_PROD_SITE_ID = '/' OR (X.CELL_PROD_SITE_ID IS NOT NULL AND TRIM(X.CELL_PROD_SITE_ID) IS NULL) THEN '-' ELSE X.CELL_PROD_SITE_ID END}')
              || ' FROM ' || V_PREV || ' X)';
        V_PREV := 'M1';

        -- M2 (L4848~4952): ATTR1 — 결과 열에 있을 때만 (40 / 82)
        IF NEED('ATTR1') AND p_division_id IN ('40', '82') THEN
            V_Q := V_Q || CHR(10) || ', ATTR1S AS (' ||
              CASE WHEN p_division_id = '40' THEN q'{
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
                WHERE  A.DIVISION_ID = [DV]
                  AND  A.MEASURE     = 'MKT_FCST'
                  AND  A.YYYYMMDD   BETWEEN [VFROM] AND [TO]
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
            ))}' ELSE q'{
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
                WHERE  A.DIVISION_ID = [DV]
                  AND  A.YYYYMMDD   BETWEEN [VFROM] AND [TO]
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
            ))}' END;
            V_Q := V_Q || CHR(10) || ', M2 AS (SELECT ' || PROJ('ATTR1', 'S.ATTR1') || ' FROM ' || V_PREV || q'{ X
            LEFT JOIN ATTR1S S
              ON (    X.DIVISION_ID  = S.DIVISION_ID
                  AND X.PROJECT_CODE = S.PROJECT_CODE
                  AND X.SCM_SITE_ID  = S.SCM_SITE_ID
                  AND X.ITEM_ID      = S.ITEM_ID
                  AND X.DOM_EXP      = S.DOM_EXP
                  AND X.FCST_TYPE    = S.FCST_TYPE
                  AND X.INCOTERMS    = S.INCOTERMS))}';
            V_PREV := 'M2';
        END IF;

        -- (11-05 23:11 apply #21 MREF 실험·폐기) M3R·M5R 원천을 MSP 로 옮겨 M2·M4 임시 적재를 없애면(−0.5s) MSP 물질화로 KEYS 추정이 37,375 vs SRCA 431,688 로 갈라져
        --   CBO 가 DISPK 조인을 SRCA 빌드(TEMP 294MB 스필 5.5s)로 고정 — #20 형태(동률 추정 → KEYS 빌드 1.2s)가 2/2 · 8회 파싱 모두 안정하므로 #20 유지 (_s3var_minyonglee1_82_r9/r10.out).
        -- M3 (L4992~5017): MKT_FCST 의 AS_FROM_SITE 를 같은 10키 타 메저 빈 행에 복사 (결과 열에 AS_FROM_SITE 있을 때만)
        --   원문 MERGE 동형: 10키(NVL '/') 좁은 집계(HAVING COUNT(DISTINCT)=1) + LEFT JOIN (윈도판은 넓은 행 전량 WINDOW SORT · apply #7)
        IF V_HAS_AFS THEN
            -- [E20261105-DMF0082ONEQUERY-LKGTT] apply #23: 항등 경로(V_MSP_ID · MSP 행 = GTT⋈CAL 행, PVT·VD 는 키당 1행)에서는 M3R·M5R 의 원천을 M2/M4 대신
            --   GTT⋈CAL 인라인 서브쿼리(M1 치환식 · NVL(AS_FROM_SITE,' ') 동일 식)로 둔다 → M2·M4 가 한 번만 참조되어 44만 넓은 행 임시 적재 2회(11-05 prof22 1.28s+1.25s)가 사라진다.
            --   11-05 23:21 실측(_s3var_minyonglee1_82_r11.out · 같은 세션 2회): S3 12.7/12.9s → 11.0/11.2s · DISPK 빌드 KEYS 유지(추정 동률 428,889) · digest 동일.
            --   집계 경로(V_MSP_ID=FALSE)는 MSP 가 그룹 행이라 원천 행 기준 COUNT(DISTINCT)·KEEP 결과가 달라질 수 있어 원문 형태(V_PREV) 유지.
            V_Q := V_Q || CHR(10) || ', M3R AS (SELECT ' || V_K10A
                || ', MAX(X.AS_FROM_SITE) AS AFS_MX_'
                || ' FROM ' || CASE WHEN V_MSP_ID THEN '(SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.PLANT_SITE_ID, '
                       || V_CPXF || q'{ AS CELL_PROD_SITE_ID, NVL(F.AS_FROM_SITE, ' ') AS AS_FROM_SITE, F.MEASURE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F INNER JOIN CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD)}'
                       ELSE V_PREV END
                || q'{ X WHERE X.MEASURE = 'MKT_FCST' AND RTRIM(X.AS_FROM_SITE, ' -/') IS NOT NULL}'
                || ' GROUP BY ' || V_K10 || ' HAVING COUNT(DISTINCT X.AS_FROM_SITE) = 1)';
            V_Q := V_Q || CHR(10) || ', M3 AS (SELECT ' || PROJ('AS_FROM_SITE',
                 q'{CASE WHEN X.MEASURE <> 'MKT_FCST' AND RTRIM(X.AS_FROM_SITE, ' -/') IS NULL AND R.AFS_MX_ IS NOT NULL THEN R.AFS_MX_ ELSE X.AS_FROM_SITE END}')
                || ' FROM ' || V_PREV || ' X LEFT JOIN M3R R ON (' || V_K10J || '))';
            V_PREV := 'M3';
        END IF;

        -- M4 (L5025~5036): 수량 메저 CURRENCY 빈값 → ' '
        V_Q := V_Q || CHR(10) || ', M4 AS (SELECT ' || PROJ('CURRENCY',
             q'{CASE WHEN X.MEASURE NOT IN ('LOC', 'KRW', 'USD', 'MKT_AMT_LOC', 'MKT_AMT_KRW') AND (X.CURRENCY IS NULL OR TRIM(X.CURRENCY) IS NULL OR TRIM(X.CURRENCY) = '/') THEN ' ' ELSE X.CURRENCY END}')
            || ' FROM ' || V_PREV || ' X)';
        V_PREV := 'M4';

        -- M5 (L5104~5146): 숨긴 CELL_PROD_SITE_ID 대표값 (10키 NVL '~' · 계획구간 우선 최신 · 2종 이상일 때만)
        --   원문 MERGE 와 같은 형태: 10키(NVL '~') 좁은 집계(HAVING) → LEFT JOIN 으로 대표값 적용.
        --   (윈도 함수판은 넓은 행 전부를 WINDOW SORT 로 TEMP 재기록 — 82 실측 11-04 19:00 각 35,307·33,994 블록, 약 5s 씩)
        IF V_HIDE_CP THEN
            V_Q := V_Q || CHR(10) || ', M5R AS (SELECT ' || V_K8A
                || q'{, NVL(X.PLANT_SITE_ID,'~') AS K9, NVL(X.MEASURE,'~') AS K10}'
                || q'{, MAX(X.CELL_PROD_SITE_ID) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN X.BUCKET_KEY >= [TOR] THEN 1 ELSE 0 END, X.BUCKET_KEY) AS CP_REP_}'
                || ' FROM ' || CASE WHEN V_MSP_ID THEN '(SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.PLANT_SITE_ID, F.MEASURE, '
                       || V_CPXF || ' AS CELL_PROD_SITE_ID, CAL.BUCKET_KEY FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F INNER JOIN CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD)'   -- [LKGTT]
                       ELSE V_PREV END
                || ' X WHERE X.CELL_PROD_SITE_ID IS NOT NULL'
                || ' GROUP BY ' || V_K8T || q'{, NVL(X.PLANT_SITE_ID,'~'), NVL(X.MEASURE,'~')}'
                || ' HAVING COUNT(DISTINCT X.CELL_PROD_SITE_ID) > 1)';
            V_Q := V_Q || CHR(10) || ', M5 AS (SELECT ' || PROJ('CELL_PROD_SITE_ID', 'CASE WHEN R.CP_REP_ IS NOT NULL THEN R.CP_REP_ ELSE X.CELL_PROD_SITE_ID END')
                || ' FROM ' || V_PREV || ' X LEFT JOIN M5R R ON (' || V_K8J
                || q'{ AND NVL(X.PLANT_SITE_ID,'~') = R.K9 AND NVL(X.MEASURE,'~') = R.K10))}';
            V_PREV := 'M5';
        END IF;

        -- M6 (L5184~5226): 숨긴 PLANT_SITE_ID 대표값 (10키 NVL '~' · 비NULL 1건 이상이면 전 행 대표값) — M5 와 같은 집계+LEFT JOIN 형태
        IF V_HIDE_PL THEN
            V_Q := V_Q || CHR(10) || ', M6R AS (SELECT ' || V_K8A
                || q'{, NVL(X.CELL_PROD_SITE_ID,'~') AS K9, NVL(X.MEASURE,'~') AS K10}'
                || q'{, MAX(X.PLANT_SITE_ID) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN X.BUCKET_KEY >= [TOR] THEN 1 ELSE 0 END, X.BUCKET_KEY) AS PL_REP_}'
                || ' FROM ' || V_PREV || ' X WHERE X.PLANT_SITE_ID IS NOT NULL'
                || ' GROUP BY ' || V_K8T || q'{, NVL(X.CELL_PROD_SITE_ID,'~'), NVL(X.MEASURE,'~')}'
                || q'{ HAVING COUNT(DISTINCT NVL(X.PLANT_SITE_ID,'~')) >= 1)}';
            V_Q := V_Q || CHR(10) || ', M6 AS (SELECT ' || PROJ('PLANT_SITE_ID', 'CASE WHEN R.PL_REP_ IS NOT NULL THEN R.PL_REP_ ELSE X.PLANT_SITE_ID END')
                || ' FROM ' || V_PREV || ' X LEFT JOIN M6R R ON (' || V_K8J
                || q'{ AND NVL(X.CELL_PROD_SITE_ID,'~') = R.K9 AND NVL(X.MEASURE,'~') = R.K10))}';
            V_PREV := 'M6';
        END IF;

        -- SRCA (L5324 SRC0 별칭 투영)
        V_Q := V_Q || CHR(10) || ', SRCA AS (SELECT X.*'
            || CASE WHEN HASCOL('DEPT_ID')      THEN ', X.DEPT_ID AS TEAM_ID' END
            || CASE WHEN HASCOL('DEPT_NAME_KO') THEN ', X.DEPT_NAME_KO AS TEAM_NAME_KO' END
            || CASE WHEN HASCOL('CELL_MODEL')   THEN ', X.CELL_MODEL AS FORECAST_INFO_CELL_MODEL' END
            || CASE WHEN HASCOL('CREATE_DATE')  THEN q'{, NVL(TO_CHAR(X.CREATE_DATE, 'YYYY-MM-DD HH24:MI:SS'), ' ') AS LAST_UPDATE_DATE}' END
            || q'{, NVL(TO_CHAR(X.SUN),'0')||NVL(TO_CHAR(X.MON),'0')||NVL(TO_CHAR(X.TUE),'0')||NVL(TO_CHAR(X.WED),'0')||NVL(TO_CHAR(X.THU),'0')||NVL(TO_CHAR(X.FRI),'0')||NVL(TO_CHAR(X.SAT),'0') AS BUCKET}'
            || ' FROM ' || V_PREV || ' X)';
        IF HASCOL('DEPT_ID')      THEN V_COLS := V_COLS || ',TEAM_ID'; END IF;
        IF HASCOL('DEPT_NAME_KO') THEN V_COLS := V_COLS || ',TEAM_NAME_KO'; END IF;
        IF HASCOL('CELL_MODEL')   THEN V_COLS := V_COLS || ',FORECAST_INFO_CELL_MODEL'; END IF;
        IF HASCOL('CREATE_DATE')  THEN V_COLS := V_COLS || ',LAST_UPDATE_DATE'; END IF;
        V_COLS := V_COLS || ',BUCKET';
        V_PREV := 'SRCA';

        -- M7 (L5235~5262): LAST_UPDATED_BY · LAST_UPDATE_DATE — 행 키(V_LU_KEYS)마다 최신 1쌍 (피벗 대상 행만)
        --   apply #8: 원문 L5257 MERGE 와 동형 — 피벗 대상 행만의 좁은 투영(RID_ · 행 키 · CREATE_DATE · LAST_UPDATED_BY) 위에서
        --   원문과 같은 윈도(PARTITION BY 행 키 원시 열 = NULL 끼리 같은 그룹)를 계산하고 RID_ 단일 키로 되돌려 붙인다.
        --   (apply #7 의 키마다 2식 NULL-안전 등가 조인은 minyonglee1/82 실측 HASH JOIN 450s(쓰기 0) 로 폐기 · 넓은 행 윈도판은 TEMP 300MB)
        -- [E20261105-DMF0082ONEQUERY-KEYSGRP] apply #20: LUW 윈도(M7)·SRC0·DISP 를 없애고 KEYS 를 SRCA 위 GROUP BY 한 번으로 만든다 (DISPK = SRCA ⋈ KEYS).
        --   11-05 실측(minyonglee1/82 · _s3var_minyonglee1_82_r5/r6.out): LUW WINDOW SORT 6.3~7.7s(TEMP 156MB) + DISP 넓은 HASH GROUP BY + KEYS HASH UNIQUE
        --   → SRCA 43열 HASH GROUP BY(16,253 그룹 · 메모리) 1회로 대체 — S3 문장 22s → 13.2s (행수·digest 동일).
        --   등가: (1) 원문 L5257 MERGE(apply #8 의 LUW) 는 QF 행을 V_LU_KEYS(= V_PK − {LAST_UPDATED_BY, LAST_UPDATE_DATE, CREATE_DATE}) 로 파티션해 MAX(CREATE_DATE)·KEEP LAST(LAST_UPDATED_BY) 를
        --       그 파티션 전 행에 쓴다 → GROUP BY V_LU_KEYS 의 같은 집계와 동일 값. (2) DISP 는 QF 행만 집계하므로 LU 파생 열은 그룹마다 상수 →
        --       (V_PK ∪ GX ∪ 버킷) 그룹 = (V_LU_KEYS ∪ GX ∪ 버킷) 그룹 = (KID_ ∪ GX ∪ 버킷) 그룹. (3) LU 미표시면 KEYS = GROUP BY V_PK (DISTINCT 와 동일 집합).
        --   조인은 SYS_OP_MAP_NONNULL NULL 안전 등가(해시 조인). 해시 키(ORA_HASH·MD5) 변형은 조인 3.0~3.3s 로 정밀 조인(1.3~2.4s)보다 느려 채택 안 함.
        --   (11-05 apply #16/#17: 44열 PARTITION 을 SHA-256 으로 바꾼 실험은 해시 CPU 8s 로 폐기 · apply #19 KIDPIVOT: 피벗 그룹 키 KID_ 압축은 유지)
        V_GB := LTRIM(REPLACE(V_GROUPBY, ' GROUP BY ', ''));
        DECLARE
            tok VARCHAR2(200); src VARCHAR2(32767); v_jk VARCHAR2(32767); v_ksel VARCHAR2(32767);
