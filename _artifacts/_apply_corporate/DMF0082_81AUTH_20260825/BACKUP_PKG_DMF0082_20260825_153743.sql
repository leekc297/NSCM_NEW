CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0082" IS
    --[E20260813-UPLOADSAVE] Excel Upload 적재 경로 전용 플래그.
    --   P_DMF0082_SAVE_MAIN_DATA 의 '^' 파싱부를 건너뛰게 한다(본체는 무수정 재사용).
    --   시그니처를 바꾸지 않으므로 PROC_M/BE/FE 배선은 손댈 필요가 없다.
    g_skip_parse VARCHAR2(1 CHAR) := 'N';


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
    V_LIMIT_CNT         NUMBER := 0;            --[E20260819-LIMITMEAS] donor(CURRENT) 이식 변수

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
        AND    C.DEFAULT_FLAG = ' ' -- [FIX 2026-07-12] AS-IS "DEFAULT_FLAG = ''"(비 default 컬럼만) 오변환('Y') → branch1 사용자 titleset 과 전 컬럼 중복 = ORA-00960
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
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_ORI_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_A_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_B_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_V', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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
         , '-'                                               AS PLANT_SITE_ID        -- 원본 GTT 에 없는 컬럼
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
    LEFT JOIN (
        SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
        INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
            ON B2.DEPT_ID = C.DEPT_ID
    ) TEAM
        ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                                THEN F.OWNER
                                ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                           END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                             THEN F.OWNER
                             ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                        END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
        ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                             ELSE F.DEPT_ID   -- Case 39: SCM_MST_SITE.DEPT_ID 삭제, SCM_MST_SITE_ITEM.DEPT_ID 사용
                        END
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
    IF p_customer IS NOT NULL AND p_customer <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_customer'
                   AND    T.TOKEN    = F.PROJECT_CODE);
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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM_ALL', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
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
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST',  NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST_C',  NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재
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
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재
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
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
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
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
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
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재
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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */
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

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    WHERE EXISTS (
        SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
        WHERE  B.MEASURE  = A.MEASURE
        AND    B.USER_ID  = 'DM_ADMIN'
    );

    -- ====================================================================================================
    -- QTY 필터 (P_QTY_YN = 'Y' 이면 QTY=0 제거)
    -- ====================================================================================================

    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE QTY = 0;
    END IF;

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
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
         WHERE ROWID IN (SELECT RID
                     FROM  (SELECT ROWID AS RID,
                                   ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
                                                      ORDER BY QTY DESC NULLS LAST, ROWID) AS RN
                            FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE)
                     WHERE RN > 1);


    -- ====================================================================================================
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
               ) THEN 'Y' ELSE 'N' END AS EDIT_AUTH_YN
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
           OR NOT ( p_user_group = 'SCP Planner'
                    OR EXISTS (SELECT 1
                               FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                               WHERE  G.USER_ID    IN (p_user_group, p_created_by)
                               AND    G.USER_GR_ID = 'SCP Planner'
                               AND    G.USE_YN     = 'Y') )    -- SCP Planner 미보유 = 종전 개방 유지
         );

    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
    SET    EDIT_AUTH_YN = CASE WHEN (p_division_id LIKE '81%' OR p_division_id = '82')
                                AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                            WHERE G.USER_ID IN (p_user_group, p_created_by)
                                            AND   G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
                               THEN 'Y' ELSE 'N' END
    WHERE  MEASURE = 'AS_In_Req';

    UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
    SET    EDIT_AUTH_YN = CASE WHEN p_division_id IN ('40', '82') THEN 'Y' ELSE 'N' END
    WHERE  MEASURE = 'VMI_In_Req';

    --3). [E20260819-LIMITMEAS] LIMIT_MEASURE 존재 시 해당 메저 강제 'N' (donor 이식 — EDIT_FLAG→EDIT_AUTH_YN 컬럼명만 상이)
    SELECT COUNT(A.LIMIT_MEASURE)
    INTO   V_LIMIT_CNT
    FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE A
    WHERE  A.LIMIT_MEASURE IS NOT NULL;

    IF V_LIMIT_CNT >= 1 THEN
        UPDATE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE A
        SET    A.EDIT_AUTH_YN = 'N'
        WHERE  EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                       WHERE  A.MEASURE = B.LIMIT_MEASURE);
    END IF;


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
    , NEW_FLAG, AS_YN)  --[E20260812-PERF] 전행 UPDATE 2회(redo/log 대기 93샘플) INSERT 시점 흡수
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
         , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y'
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
    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
           , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
           , F.CELL_PROD_SITE_ID, CAL.BUCKET_TYPE, CAL.BUCKET_KEY, F.MEASURE_GROUP
           , F.SORT_ORDER_NO
           , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
           , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN;

    -- [UICATEGORY 2026-08-07] direct-path(APPEND) INSERT 직후 동일 테이블 DML = ORA-12838
    --   → 통계 수집(내부 COMMIT — GTT SYS$SESSION PRESERVE 실측)을 먼저 수행한 뒤 Tier3 적재
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MF_SP', NO_INVALIDATE => FALSE);  /* 2026.08.15 AJS 대형 GTT 통계 유지 — 미수집 시 MF_W 3.95→364초(92배) 실증 */

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
        UPDATE SCM_MGR.GT_DMF0082_MF_SP T
        SET    T.VMI_STD_DIO = (
                   SELECT MAX(A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),''))
                   FROM   SCM_MGR.SCM_MST_SITE A
                   WHERE  A.DIVISION_ID = '82'
                   AND    A.SCM_SITE_ID = T.SCM_SITE_ID);
    END IF;

    -- [UICATEGORY 2026-08-07] Division 82 = 조회 전용 (사용자 확정) — 편집 서버 권위 차단
    IF p_division_id = '82' THEN
        UPDATE SCM_MGR.GT_DMF0082_MF_SP SET EDIT_FLAG = 'N';
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


PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO
(
    P_START_YYYYMMDD   IN  VARCHAR2,
    P_END_YYYYMMDD     IN  VARCHAR2,
    P_USER_ID          IN VARCHAR2, -- For EditYn
    P_MNU_ID           IN VARCHAR2, -- For EditYn
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0020_GET_FUTUREPRICE_INFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT YYYYMMDD,
               SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM,
               t1.DIVISION_ID,
               CURRENCY,
               UNIT_CURRENCY,
               EXCHANGE_PRICE,
               NVL(T2.EDIT_YN,'N') AS EDIT_YN
          FROM SCM_MGR.DM_MST_EXCHANGE_RATE t1
              LEFT JOIN (SELECT * -- EDIT_YN  /* 2026.08.15 AJS 신뢰도검사 발견2 : 권한 미등록 사용자 전량 소실 방지 (SELECT 절 NVL 과 정합) */
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T1.DIVISION_ID = T2.UNIT_ID
                     WHERE YYYYMMDD >= P_START_YYYYMMDD
                       AND YYYYMMDD <= P_END_YYYYMMDD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE,
               'SUCCESS' AS MSG,
               CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT
          FROM DUAL;

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
                             'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                             'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                             'P_USER_ID'        VALUE P_USER_ID,
                             'P_MNU_ID'         VALUE P_MNU_ID
                         );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_FUTUREPRICE_INFO;


PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 */
IS
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

    OPEN O_RC1 FOR
    SELECT
    -- column_label_name as LOOKUP_CODE
    --,column_label_name as DESCRIPTION
     CASE WHEN COLUMN_NAME = 'RTF_SYS_RP' THEN 'RTF' ELSE COLUMN_NAME END AS LOOKUP_CODE
    ,CASE WHEN COLUMN_NAME = 'RTF_SYS_RP' THEN 'RTF' ELSE COLUMN_NAME END AS DESCRIPTION
    , 99 AS DISPLAY_ALL
    ,SORT_ORDER_NO AS DISPLAY_SEQ
    ,NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MGR.SCM_MST_SHEET_MEASURE T1
        LEFT JOIN (SELECT * -- EDIT_YN  /* 2026.08.15 AJS 신뢰도검사 발견2 : 권한 미등록 사용자 전량 소실 방지 (SELECT 절 NVL 과 정합) */
         FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
         WHERE USER_ID = P_USER_ID
         AND MNU_ID = P_MNU_ID
         AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
     )
    WHERE  PROGRAM_ID = 'DMF0082'
    AND SHEET_NAME = 'FcstNPrice' -- [FIX 2026-07-12] SHEET_MEASURE 명칭 통일(fcstNPrice)
    AND VALID_YN = 'Y'
    AND COLUMN_NAME IN ('RTF_SYS_RP','KRW','USD','LOC')
    ORDER BY SORT_ORDER_NO;
    /*
    SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL,DISPLAY_SEQ
    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE VALID_YN = 'Y'
    AND SEGMENT1 <> 'LOC'
    AND LOOKUP_TYPE = 'FUTUREMEASURE'
    UNION ALL
    SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL,DISPLAY_SEQ
    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE VALID_YN = 'Y'
    AND SEGMENT1 = 'LOC'
    AND LOOKUP_TYPE = 'FUTUREMEASURE'
    order by DISPLAY_SEQ
    */

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
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
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
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
END P_DMF0082_POPUP_GET_MEASURE_COUNTINFO;


PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
IS
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

    OPEN O_RC1 FOR
    SELECT DISTINCT
    --column_label_name as LOOKUP_CODE
    --,column_label_name as DESCRIPTION
    COLUMN_NAME AS LOOKUP_CODE
    ,COLUMN_NAME AS DESCRIPTION
    , 99 AS DISPLAY_ALL
    , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MGR.SCM_MST_SHEET_MEASURE T1
        LEFT JOIN (SELECT * -- EDIT_YN  /* 2026.08.15 AJS 신뢰도검사 발견2 : 권한 미등록 사용자 전량 소실 방지 (SELECT 절 NVL 과 정합) */
     FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
     WHERE USER_ID = P_USER_ID
     AND MNU_ID = P_MNU_ID
     AND UNIT_TP_CD = 'D') T2
     ON T2.UNIT_ID in (
         SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
         FROM   DUAL
         CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )

    WHERE  PROGRAM_ID = 'DMF0082'
    AND SHEET_NAME = 'FcstNPrice' -- [FIX 2026-07-12] SHEET_MEASURE 명칭 통일(fcstNPrice)
    AND VALID_YN = 'Y'
    AND COLUMN_NAME = 'LOC';
    ----SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL
    ----FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    ----WHERE VALID_YN = 'Y'
    ----AND SEGMENT1 <> 'LOC'
    ----AND LOOKUP_TYPE = 'FUTUREMEASURE'
    ----UNION ALL
    /*
     SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL
     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE VALID_YN = 'Y'
     AND SEGMENT1 = 'LOC'
     AND LOOKUP_TYPE = 'FUTUREMEASURE'
   */

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
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
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
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
END P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE;


PROCEDURE P_DMF0082_POPUP_GET_WEEKDATA
(
    P_YYYYMMDD          IN  VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_WEEKDATA
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
IS
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

    OPEN O_RC1 FOR
    SELECT BASIS_START_DATE, BASIS_YYYYMMDD
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD <= P_YYYYMMDD
    ORDER BY BASIS_YYYYMMDD DESC
    FETCH FIRST 7 ROWS ONLY;

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
            'P_YYYYMMDD' VALUE P_YYYYMMDD
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
END P_DMF0082_POPUP_GET_WEEKDATA;


PROCEDURE P_DMF0082_EXCEL_UPLOAD 
(
    p_mode           IN  NUMBER
  , p_created_by     IN  VARCHAR2
  , p_program_id     IN  VARCHAR2 DEFAULT 'DMF0082'   --[5ARG 2026-08-12] 공통 validProc 계약(Excel.xml CALL 5-arg — PLS-00306 정정)
  , p_sheet_name     IN  VARCHAR2 DEFAULT 'FcstNPrice'
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR   /* 표준 결과 커서 (RESULT_CODE/RESULT_MSG/EVENT) */
)
/*
 * Program ID   : [DMF0082_EXCEL_UPLOAD]
 * Description  : Fcst&Price MGMT 엑셀 업로드
 * Program History
 *==================================================================================================
 *   Date       In Charge        Description
 *==================================================================================================
 * 2025.05.xx   KJY              최초 작성 (MSSQL)
 * 2026-07-12   Claude           MSSQL dbo.DMF0082_EXCEL_UPLOAD → Oracle 19c 1:1 변환 (파일 산출물 — DB 미적용)
 *==================================================================================================
 * [변환 노트 — 부록 C 함정 처리]
 *  - @p_mode INT → P_MODE NUMBER (Excel Upload 2-Step 표준: mode=0 검증/분류, mode>0 저장 게이트)
 *  - O_RESULT_CURSOR 추가 (AS-IS 는 결과셋 없음 → TO-BE 2-Step 모달 표준: SUCCESS/ERROR 건수 반환)
 *  - CONVERT(NVARCHAR(40), CREATION_DATE, 121) → TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') 명시 마스크 (C-11)
 *  - ISNULL(x,'')=''  → x IS NULL (C-7: Oracle '' = NULL)
 *  - ISNULL(x,'')<>'' → x IS NOT NULL (C-7)
 *  - ISNULL(MESSAGE_TEXT,'') + ', xxx' → MESSAGE_TEXT || ', xxx' (Oracle 은 NULL || 'x' = 'x')
 *  - 중복 체크의 ISNULL(ATTRIBUTE9,'') 그룹/비교 → NVL(ATTRIBUTE9,'-') 양쪽 정렬
 *    (MSSQL 은 빈문자열('')로 정규화해 비교 — Oracle 에서 '' = NULL 이므로 '-' placeholder 로 동등화, C-7)
 *  - UPDATE ... FROM JOIN (코드 매핑 UPDATE 6종) → 상관 Scalar Subquery + EXISTS (룰 #30, ORA-01779 회피)
 *    매핑이 다중행일 때 MSSQL UPDATE JOIN 은 임의 1행 채택 → Oracle 은 MAX() 로 결정적 채택 (ORA-01427 방지)
 *  - ISNUMERIC(x) → VALIDATE_CONVERSION(x AS NUMBER) (12.2+, 소수/부호 허용 — 룰 44 의 정수 전용 REGEXP 보다 ISNUMERIC 에 근접)
 *  - CONVERT(FLOAT, x) → TO_NUMBER(x DEFAULT NULL ON CONVERSION ERROR)
 *  - EXEC PR_SCM_SYS_LOG_BATCH → SCM_MGR.PR_SCM_SYS_LOG_BATCH(...) (Oracle 시그니처 6 필수 + 4 default)
 *  - @@ROWCOUNT → SQL%ROWCOUNT (UPDATE 직후 즉시 캡처 — MSSQL 의 SET 문 rowcount 리셋 quirk 는 재현하지 않고 원의도 보존)
 *  - SYSDATETIME() → SYSDATE / PRINT → DBMS_OUTPUT.PUT_LINE / WITH(NOLOCK) 제거 / [bracket]·dbo. 제거 / TOP 1 → FETCH FIRST 1 ROWS ONLY
 *  - STRING_SPLIT 첫 token → INSTR/SUBSTR (룰 #5)
 *  - AS-IS 원문 889~1120 라인의 주석 처리된 MSSQL 테스트 블록(실행 코드 아님)은 본 파일에 미이관 —
 *    원문 보존본 = asis_DMF0082_EXCEL_UPLOAD.sql 참조 (로직 영향 0)
 *  - AS-IS 숫자/음수/0 체크가 ATTRIBUTE11~19(M4~M12)만 대상(M13~M16 미검증)인 것은 원문 그대로 보존 (임의 확장 금지)
 *  - MSSQL 은 문장별 자동 COMMIT → Oracle 은 검증 UPDATE 확정 위해 정상 종료 시 COMMIT, 예외 시 ROLLBACK
 */
 --EXEC [DMF0082_EXCEL_UPLOAD] '1', 'kjj0070'
IS
    v_program_id      VARCHAR2(40 CHAR)  := NVL(p_program_id, 'DMF0082');   --[5ARG] 파라미터 우선
    v_sheet_name      VARCHAR2(40 CHAR)  := NVL(p_sheet_name, 'FcstNPrice');
    v_creation_date   VARCHAR2(40 CHAR);
    v_count           NUMBER;
    v_start_yyyymmdd  VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 4), 'YYYYMM');   --당월 기준+4  (AS-IS: CONVERT(VARCHAR(6),...,112))
    v_end_yyyymmdd    VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM');  --당월 기준+12 (AS-IS: CONVERT(VARCHAR(6),...,112))
    v_division        VARCHAR2(10 CHAR);

    -- LOG 용 변수 설정
    v_log_type        VARCHAR2(30 CHAR);   -- START/END/ERROR/...
    n_log_count       NUMBER := 0;
    v_log_message     VARCHAR2(1000 CHAR);
    v_description     VARCHAR2(500 CHAR);
    d_event_date      DATE;

    -- 결과 카운트
    n_row_cnt         NUMBER := 0;
    n_success_cnt     NUMBER := 0;
    n_error_cnt       NUMBER := 0;
    --[E20260813-UPLOADSAVE] 원장 적재 분기 전용
    v_rc_a           SYS_REFCURSOR;
    v_rc_b           SYS_REFCURSOR;
    v_rc_c           SYS_REFCURSOR;
    v_rc_save        SYS_REFCURSOR;
    v_save_code      VARCHAR2(10  CHAR);
    v_save_msg       VARCHAR2(4000 CHAR);
    v_save_event     VARCHAR2(400 CHAR);
    n_save_cnt       PLS_INTEGER := 0;

    -- 표준 예외 변수
    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_SQL_CODE        VARCHAR2(20 CHAR);
    V_SQL_ERRMSG      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
BEGIN

/*
1. 40 사업부만 대상으로 한다.
2. Validation Step
    step1. 필수값 확인
    step2. 중복값 확인 (LOC인 경우 currency도 포함하여 중복체크)
    step3. 코드/네임 맵핑 확인
            - 메져 확인(Unit Price(LOC),MKT FCST[R+P])
            - FCST Type
            - Dom/Exp
*/

    V_PROC_INPUT := JSON_OBJECT('rows' VALUE REGEXP_COUNT(p_mode, '\^') + 1, 'p_mode' VALUE SUBSTR(p_mode, 1, 50), 'p_created_by' VALUE SUBSTR(p_created_by, 1, 50));

    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    --[E20260818-UPLOADBATCH] 2-Step NOT_SAVABLE 정정 — 배치 유도에서 상태 필터 제거.
    --  구 조건 `AND T.UPLOAD_STATUS_CODE = 'UPLOAD'` 는 [Upload](P_MODE=0)가 분류하며 상태를
    --  SUCCESS/ERROR 로 바꾼 뒤의 [OK](P_MODE=1)에서 배치를 못 찾아(v_creation_date=NULL)
    --  카운트가 0/0 → NOT_SAVABLE 이 났다(2026-08-18 실사고 — 18:36 배치 SUCCESS 14행 실측).
    --  정본 = PKG_DMF0074 L978~983 (상태 무관 최신 배치. 2-Step 26케이스 검증 2026-08-16).
    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by;

    IF v_creation_date IS NULL THEN
        v_log_type    := 'END';
        v_log_message := '########## END of procedure ##########';
        v_description := 'Data Not Found [' || NVL(SUBSTR(v_creation_date, 1, 19), '') || ']';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;

    /* SELECT TOP 1 @v_division = ATTRIBUTE1 ... */
    BEGIN
        SELECT ATTRIBUTE1
        INTO   v_division
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    ATTRIBUTE1 != 'Div'
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division := NULL;
    END;

    -- @p_mode = 0 이면 Validation
    IF NVL(p_mode, 0) = 0 THEN

        DBMS_OUTPUT.PUT_LINE(v_division);   /* AS-IS: PRINT @v_division */

        ------------------------------------------------------------------------
        -- RESET Status = UPLOAD
        ------------------------------------------------------------------------
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
        SET    T.UPLOAD_STATUS_CODE = 'UPLOAD'
             , T.MESSAGE_TEXT       = NULL
        WHERE  T.PROGRAM_ID = v_program_id
        AND    T.SHEET_NAME = v_sheet_name
        AND    T.CREATED_BY = p_created_by
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;
        --AND    NVL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD'

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := '1';
        v_log_message := '########## RESET Status = UPLOAD ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        ------------------------------------------------------------------------
        -- @TITLE Header Line
        ------------------------------------------------------------------------
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIV';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 2, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := '2';
        v_log_message := '########## TITLE Header Line ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        --본격적 VALIDATION 시작

        /* ####################################################
         필수 값 NULL 값 체크
        ATTRIBUTE1  Div*
        ATTRIBUTE2  End Customer*
        ATTRIBUTE3  Sales Site*
        ATTRIBUTE4  Model*
        ATTRIBUTE5  Incoterms*
        ATTRIBUTE6  FCST Type*
        ATTRIBUTE7  Customs Handbook*
        ATTRIBUTE8  Cell Prod Site*
        ATTRIBUTE9  Currency*
        ATTRIBUTE10 Measure*
         #################################################### */
        --Div   Team    End Customer    Project Code    Currency
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = CASE WHEN ATTRIBUTE1  IS NULL THEN 'NULL Div'
                                         WHEN ATTRIBUTE2  IS NULL THEN 'NULL End Customer'
                                         WHEN ATTRIBUTE3  IS NULL THEN 'NULL Sales Site'
                                         WHEN ATTRIBUTE4  IS NULL THEN 'NULL Model'
                                         WHEN ATTRIBUTE5  IS NULL THEN 'NULL Incoterms'
                                         WHEN ATTRIBUTE6  IS NULL THEN 'NULL FCST Type'
                                         WHEN ATTRIBUTE7  IS NULL THEN 'NULL Customs Handbook'
                                         WHEN ATTRIBUTE8  IS NULL THEN 'NULL Cell Prod Site'
                                         WHEN (ATTRIBUTE10 = 'Unit Price(LOC)' AND ATTRIBUTE9 IS NULL) THEN 'NULL Currency'  --MEAUSRE가 Unit Price(LOC) 때만 필수값
                                         WHEN ATTRIBUTE10 IS NULL THEN 'NULL Measure'
                                    END
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (   ATTRIBUTE1  IS NULL
                OR ATTRIBUTE2  IS NULL
                OR ATTRIBUTE3  IS NULL
                OR ATTRIBUTE4  IS NULL
                OR ATTRIBUTE5  IS NULL
                OR ATTRIBUTE6  IS NULL
                OR ATTRIBUTE7  IS NULL
                OR ATTRIBUTE8  IS NULL
                OR (ATTRIBUTE10 = 'Unit Price(LOC)' AND ATTRIBUTE9 IS NULL)
                OR ATTRIBUTE10 IS NULL
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## ERROR NULL Column Data ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* ####################################################
        Key기준 중복 체크
        ATTRIBUTE1  Div*        ~ ATTRIBUTE10 Measure*
        (C-7) MSSQL ISNULL(ATTRIBUTE9,'') 정규화 → Oracle NVL(ATTRIBUTE9,'-') 양쪽 정렬
        #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.UPLOAD_STATUS_CODE = 'ERROR'
             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Duplication Model.'
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    EXISTS (SELECT 1
                       FROM  (--Unit Price(LOC) 외 메저는 Currency NULL
                              SELECT X.ATTRIBUTE1           AS COL1   --Div
                                   , X.ATTRIBUTE2           AS COL2   --End Customer
                                   , X.ATTRIBUTE3           AS COL3   --Sales Site
                                   , X.ATTRIBUTE4           AS COL4   --Modele
                                   , X.ATTRIBUTE5           AS COL5   --Incoterms
                                   , X.ATTRIBUTE6           AS COL6   --FCST Type
                                   , X.ATTRIBUTE7           AS COL7   --Customs Handbook
                                   , X.ATTRIBUTE8           AS COL8   --Cell Prod Site
                                   , NVL(X.ATTRIBUTE9, '-') AS COL9   --Currency
                                   , X.ATTRIBUTE10          AS COL10  --Measure
                              FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
                              WHERE  X.PROGRAM_ID = v_program_id
                              AND    X.SHEET_NAME = v_sheet_name
                              AND    X.CREATED_BY = p_created_by
                              AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                              AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                              GROUP BY X.ATTRIBUTE1
                                     , X.ATTRIBUTE2
                                     , X.ATTRIBUTE3
                                     , X.ATTRIBUTE4
                                     , X.ATTRIBUTE5
                                     , X.ATTRIBUTE6
                                     , X.ATTRIBUTE7
                                     , X.ATTRIBUTE8
                                     , NVL(X.ATTRIBUTE9, '-')
                                     , X.ATTRIBUTE10
                              HAVING COUNT(*) > 1
                             ) T
                       WHERE 1 = 1
                       AND   T.COL1  = A.ATTRIBUTE1
                       AND   T.COL2  = A.ATTRIBUTE2
                       AND   T.COL3  = A.ATTRIBUTE3
                       AND   T.COL4  = A.ATTRIBUTE4
                       AND   T.COL5  = A.ATTRIBUTE5
                       AND   T.COL6  = A.ATTRIBUTE6
                       AND   T.COL7  = A.ATTRIBUTE7
                       AND   T.COL8  = A.ATTRIBUTE8
                       AND   T.COL9  = NVL(A.ATTRIBUTE9, '-')
                       AND   T.COL10 = A.ATTRIBUTE10
                      );

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := 'UPDATE';
        v_log_message := '########## ERROR Model Duplication ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* [E20260820-XLSWEEKLY] 1단 동적 주차 헤더 — 프레임워크 @TITLE 행(주 시작일 YYYYMMDD 헤더, BE 정규화 완료)을
           V_TITLE 로 마킹 (DMF0014 정본 계보 동형). 데이터 행 검증('UPLOAD' 한정)과 자연 분리. */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'V_TITLE'
        WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = '@TITLE';

        /* #################################################### */
        /* DIVISION  체크                                        */
        --사업부 40 만 대상으로 함
        -- ATTRIBUTE1   Div (검증전)
        -- ATTRIBUTE301 Div (검증후) - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE301 = A.ATTRIBUTE1
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE1 LIKE '81%';   /* [E20260819-XLS81LOC] Excel Upload = Division 81 계열 전용 (2026-08-19 사용자 지시 — 구 40 전용 역전) */

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ',Invalid Division(81 Only).'   /* [E20260819-XLS81LOC] */
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE301 IS NULL;

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
        ------------------------------------------------------------------------
        v_log_type    := 'UPDATE';
        v_log_message := '########## Invalid Division ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* END CUSTOMER 체크                                     */
        --ATTRIBUTE2    End Customer (Name)
        --ATTRIBUTE302  End Customer (Code) - SYSTEM UPDATE
        /* #################################################### */
        -- (룰 #30) MSSQL UPDATE JOIN → 상관 Scalar Subquery + EXISTS. 다중 매핑 시 MAX(CODE) 결정적 채택.
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE302 = (SELECT MAX(EC.CODE)
                                 FROM  (SELECT DISTINCT SI.PROJECT_CODE AS CODE
                                             , NVL(D.SEGMENT3, SI.PROJECT_CODE) AS NAME
                                             , SI.DIVISION_ID AS DIV   /* [E20260819-XLS81LOC] division 상관 승격 (스칼라 서브쿼리 상관 깊이 1 제약) */
                                        FROM   SCM_MGR.SCM_MST_SITE_ITEM SI
                                        INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO UI
                                            ON SI.OWNER = UI.USER_ID
                                        INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DI
                                            ON UI.DEPT_ID = DI.DEPT_ID
                                        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
                                            ON  SI.DIVISION_ID  = D.SEGMENT1
                                            AND SI.PROJECT_CODE = D.SEGMENT2
                                            AND D.LOOKUP_TYPE   = 'END_CUSTOMER'
                                            AND D.VALID_YN      = 'Y'
                                        /* (룰 #5) STRING_SPLIT 첫 token → INSTR/SUBSTR */
                                        WHERE  UI.USER_ID = CASE WHEN INSTR(SI.OWNER, ',') = 0 THEN SI.OWNER
                                                                 ELSE SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1) END
                                        AND    UI.DEPT_ID     = DI.DEPT_ID
                                        AND    SI.VALID_YN    = 'Y'   /* [E20260819-XLS81LOC] 구 SI.DIVISION_ID='40' 하드코딩 제거 — depth-1 EC.DIV 필터로 이동 */
                                        UNION
                                        SELECT SEGMENT2 AS CODE
                                             , SEGMENT3 AS NAME
                                             , SEGMENT1 AS DIV   /* [E20260819-XLS81LOC] */
                                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                        WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
                                        AND    SEGMENT2 <> '-'
                                        AND    VALID_YN = 'Y'
                                        ) EC   /* [E20260819-XLS81LOC] 구 SEGMENT1='40' 하드코딩 제거 */
                                 WHERE EC.NAME = A.ATTRIBUTE2
                                 AND   EC.DIV  = A.ATTRIBUTE301)   /* [E20260819-XLS81LOC] 행 division 상관 (81 계열 정합) */
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE2 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid End Customer'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE302 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* SALES SITE 체크                                       */
        --ATTRIBUTE3    Sales Site (Name)
        --ATTRIBUTE303  Sales Site (Code) - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE303 = (SELECT MAX(MS.SCM_SITE_ID)
                                 FROM   SCM_MGR.SCM_MST_SITE MS
                                 WHERE  MS.SITE_TYPE   = 'SALES'
                                 AND    MS.VALID_YN    = 'Y'
                                 AND    MS.DIVISION_ID = A.ATTRIBUTE301   /* [E20260819-XLS81LOC] 구 '40' 하드코딩 → 행 division */
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE3)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE3 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Sales Site'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE303 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* END CUSTOMER / SALES SITE Mapping 체크                */
        --ATTRIBUTE2    End Customer (Name)
        --ATTRIBUTE3    Sales Site   (Name)
        --ATTRIBUTE302  End Customer (Code) - SYSTEM UPDATE
        --ATTRIBUTE303  Sales Site   (Code) - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.UPLOAD_STATUS_CODE = 'ERROR'
             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Invalid End Customer/Sales Site.'
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.SCM_MST_SITE MS
                           LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
                               ON  MS.DIVISION_ID = SI.DIVISION_ID
                               AND MS.SCM_SITE_ID = SI.SCM_SITE_ID
                           WHERE  1 = 1
                           AND    MS.SITE_TYPE    = 'SALES'
                           AND    MS.VALID_YN     = 'Y'
                           AND    MS.DIVISION_ID  = A.ATTRIBUTE301   /* [E20260819-XLS81LOC] 구 '40' 하드코딩 → 행 division */
                           AND    SI.PROJECT_CODE = A.ATTRIBUTE302
                           AND    MS.SCM_SITE_ID  = A.ATTRIBUTE303
                          );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* MODEL 체크                                            */
        -- ATTRIBUTE4    Model*
        -- ATTRIBUTE304  Model* - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE304 = (SELECT MAX(MS.ITEM_ID)
                                 FROM   SCM_MGR.SCM_MST_SITE_ITEM MS
                                 INNER JOIN SCM_MGR.SCM_MST_ITEM_SN SN
                                     ON  MS.DIVISION_ID = SN.DIVISION_ID
                                     AND MS.ITEM_ID     = SN.ITEM_ID
                                     AND SN.ACTIVE_FLAG = 'Y'
                                 WHERE  MS.DIVISION_ID = A.ATTRIBUTE301  --Div
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE303  --Sales Site
                                 AND    MS.ITEM_ID     = A.ATTRIBUTE4    --Model
                                 AND    MS.VALID_YN    = 'Y')
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE4 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Model.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE304 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid MODEL ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* INCOTERMS 체크                                        */
        -- ATTRIBUTE5   Incoterms*
        -- ATTRIBUTE305 Incoterms*  - SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE305 = (SELECT MAX(L.SEGMENT2)          /* LV.NAME */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'INCOTERMS'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE5)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE5 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Incoterms.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE305 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid INCOTERMS ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* FCST TYPE 체크                                        */
        -- ATTRIBUTE6   Fcst Type (NAME)
        -- ATTRIBUTE306 Fcst Type (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE306 = (SELECT MAX(L.SEGMENT1)          /* LV.CODE */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                 AND    NVL(L.ATTRIBUTE2, '-') <> 'Y'    --AS전용여부 (C-7: ISNULL(x,'')<>'Y')
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE6)    --Fcst Type name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE6 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Fcst Type'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE306 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid FCST TYPE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* Customs Handbook 체크                                 */
        -- ATTRIBUTE7    Customs Handbook*
        -- ATTRIBUTE307  Customs Handbook* --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE307 = (SELECT MAX(L.SEGMENT1)          /* LV.CODE */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'DM_CUSTOMS_HANDBOOK_40'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE7)    --Fcst Type name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE7 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Customs Handbook'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE307 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid Customs Handbook ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* Cell Prod Site 체크                                   */
        -- ATTRIBUTE8    Cell Prod Site (NAME)
        -- ATTRIBUTE308  Cell Prod Site (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE308 = (SELECT MAX(M.SEGMENT1)
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
                                 WHERE  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
                                 AND    M.VALID_YN    = 'Y'
                                 AND    M.ATTRIBUTE1  = A.ATTRIBUTE8)    ---CELL PROD SITE
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE8 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Cell Prod Site'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE308 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid Cell Prod Site ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* MEASURE 체크                                          */
        -- ATTRIBUTE10   Measure
        --               LOC      : Unit Price(LOC)
        --               MKT_FCST : MKT FCST[R+P]
        -- ATTRIBUTE310  MEASURE  (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE310 = (SELECT MAX(L.SEGMENT3)
                                 FROM   SCM_MGR.SCM_MST_SITE MS
                                 INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                     ON  L.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
                                     AND L.SEGMENT1    = 'DMF0082'      -- PROGROM_ID
                                     AND L.VALID_YN    = 'Y'            -- 사용여부
                                     AND L.ATTRIBUTE1  = 'Y'            -- INSERT_YN 여부
                                     AND L.SEGMENT3    = 'LOC'          /* [E20260819-XLS81LOC] 대상 measure LOC 한정 (2026-08-19 사용자 지시 — 타 measure 명칭은 매핑 실패 → Invalid Measure ERROR 분류) */
                                     AND L.SEGMENT2    = MS.DIVISION_ID
                                     AND (
                                          ( NVL(MS.VMI_YN,'N') = 'N' AND L.ATTRIBUTE3 <> 'Y' )  -- SCM_MST_SITE에 데이터가 없으면서 VMI_YN이 Y가 아닌 경우.
                                          OR
                                          ( NVL(MS.VMI_YN,'N') = 'Y' )  -- SCM_MST_SITE에 데이터가 있을 경우.
                                          --두개 중에서 하나라도 걸린다면 가져온다.
                                         )
                                 WHERE  MS.DIVISION_ID = A.ATTRIBUTE301   --DIV
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE303   --Sales Site
                                 /* [FIX 2026-08-12] ANSI JOIN ON 절의 외부 상관참조(A.ATTRIBUTE10)가
                                    UPDATE SET 스칼라 서브쿼리에서 상관조건 유실 → 전 측정 매칭(MAX='VMI_In_Req' 오배정).
                                    상관조건을 WHERE 로 이동 (사내 실측 재현 UPLOAD_ID 2079575/76 → 수정문 MKT_FCST/LOC 검증) */
                                 AND    L.SEGMENT4     = A.ATTRIBUTE10)   --MEASURE Name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE10 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Measure(LOC Only)'   /* [E20260819-XLS81LOC] */
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE310 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid CURRENCY. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* CURRENCY 체크                                         */
        -- ATTRIBUTE9  Currency
        -- ATTRIBUTE10 Measure 가 Unit Price(LOC) 인 대상으로만 통화 체크
        --ATTRIBUTE310  MEASURE  (CODE) --SYSTEM UPDATE
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE309 = (SELECT MAX(L.SEGMENT1)          /* LV.CODE */
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'CURRENCY_LIST'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE9)    --Fcst Type name
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NVL(A.ATTRIBUTE310, '-') = 'LOC';   --MEASURE가 LOC인 대상으로만. (C-7)

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid CURRENCY.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NVL(ATTRIBUTE310, '-') = 'LOC'      --MEASURE가 LOC인 대상으로만. (C-7)
        AND    ATTRIBUTE309 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid CURRENCY. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* 숫자여부 체크                                         */
        -- (룰 44) ISNUMERIC(x)=0 → VALIDATE_CONVERSION(x AS NUMBER)=0
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid NUMERIC.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 0) OR --M4
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 0) OR --M5
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 0) OR --M6
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 0) OR --M7
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 0) OR --M8
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 0) OR --M9
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 0) OR --M10
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 0) OR --M11
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 0) OR --M12
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 0) OR --M13
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 0) OR --M14
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 0) OR --M15
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 0) OR --M16  --[E20260813-UPLOADSAVE] M13~M16 검증 확장 /* [E20260820-XLSWEEKLY] 주차 슬롯 24~36 확장 */
                   (ATTRIBUTE24 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE24 AS NUMBER) = 0) OR --W14
                   (ATTRIBUTE25 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE25 AS NUMBER) = 0) OR --W15
                   (ATTRIBUTE26 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE26 AS NUMBER) = 0) OR --W16
                   (ATTRIBUTE27 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE27 AS NUMBER) = 0) OR --W17
                   (ATTRIBUTE28 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE28 AS NUMBER) = 0) OR --W18
                   (ATTRIBUTE29 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE29 AS NUMBER) = 0) OR --W19
                   (ATTRIBUTE30 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE30 AS NUMBER) = 0) OR --W20
                   (ATTRIBUTE31 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE31 AS NUMBER) = 0) OR --W21
                   (ATTRIBUTE32 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE32 AS NUMBER) = 0) OR --W22
                   (ATTRIBUTE33 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE33 AS NUMBER) = 0) OR --W23
                   (ATTRIBUTE34 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE34 AS NUMBER) = 0) OR --W24
                   (ATTRIBUTE35 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE35 AS NUMBER) = 0) OR --W25
                   (ATTRIBUTE36 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE36 AS NUMBER) = 0) --W26
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid NUMERIC. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* 마이너스 여부 체크                                    */
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Negative Number.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE11 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M4
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE12 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M5
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE13 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M6
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE14 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M7
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE15 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M8
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE16 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M9
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE17 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M10
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE18 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M11
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M12
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE20 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M13
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE21 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M14
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE22 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M15
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE23 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --M16  --[E20260813-UPLOADSAVE] M13~M16 검증 확장 /* [E20260820-XLSWEEKLY] 주차 슬롯 24~36 확장 */
                   (ATTRIBUTE24 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE24 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE24 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W14
                   (ATTRIBUTE25 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE25 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE25 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W15
                   (ATTRIBUTE26 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE26 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE26 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W16
                   (ATTRIBUTE27 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE27 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE27 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W17
                   (ATTRIBUTE28 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE28 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE28 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W18
                   (ATTRIBUTE29 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE29 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE29 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W19
                   (ATTRIBUTE30 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE30 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE30 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W20
                   (ATTRIBUTE31 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE31 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE31 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W21
                   (ATTRIBUTE32 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE32 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE32 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W22
                   (ATTRIBUTE33 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE33 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE33 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W23
                   (ATTRIBUTE34 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE34 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE34 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W24
                   (ATTRIBUTE35 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE35 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE35 DEFAULT NULL ON CONVERSION ERROR) < 0) OR --W25
                   (ATTRIBUTE36 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE36 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE36 DEFAULT NULL ON CONVERSION ERROR) < 0) --W26
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Negative Number. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        /* #################################################### */
        /* 0 여부 체크                                           */
        /* #################################################### */
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Zero Number.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE11 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M4
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE12 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M5
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE13 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M6
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE14 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M7
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE15 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M8
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE16 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M9
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE17 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M10
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE18 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M11
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M12
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE20 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M13
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE21 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M14
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE22 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M15
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE23 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --M16  --[E20260813-UPLOADSAVE] M13~M16 검증 확장 /* [E20260820-XLSWEEKLY] 주차 슬롯 24~36 확장 */
                   (ATTRIBUTE24 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE24 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE24 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W14
                   (ATTRIBUTE25 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE25 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE25 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W15
                   (ATTRIBUTE26 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE26 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE26 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W16
                   (ATTRIBUTE27 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE27 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE27 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W17
                   (ATTRIBUTE28 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE28 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE28 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W18
                   (ATTRIBUTE29 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE29 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE29 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W19
                   (ATTRIBUTE30 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE30 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE30 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W20
                   (ATTRIBUTE31 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE31 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE31 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W21
                   (ATTRIBUTE32 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE32 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE32 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W22
                   (ATTRIBUTE33 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE33 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE33 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W23
                   (ATTRIBUTE34 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE34 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE34 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W24
                   (ATTRIBUTE35 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE35 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE35 DEFAULT NULL ON CONVERSION ERROR) = 0) OR --W25
                   (ATTRIBUTE36 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE36 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE36 DEFAULT NULL ON CONVERSION ERROR) = 0) --W26
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Zero Number. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 정상(SUCCESS) 처리
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';

        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        ----------------------------------------------------------------------------
        v_log_type    := '16';
        v_log_message := '########## SUCCESS ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        --================================================================================================
        -- [E20260818-PRICECHK1] 52주 판가(Unit Price) 검증을 1단계([Upload])로 전진 (사용자 요구).
        --   종전: 2단계([OK]) 적재부의 SAVE_MAIN_DATA 검증 10 에서야 전체 실패(Unit Price Not Found).
        --   본 블록: 같은 판정(정본 = SAVE 검증 1.2 판가 수집 + 10 판정, SENTINEL3 정규화 동일)을
        --   분류 단계에서 수행해 위반 키의 업로드 행을 ERROR + 상세 메시지로 표기한다.
        --   2단계 검증은 최종 방어선으로 유지. GTT 는 사용 전 DELETE (커넥션 풀 세션 잔존 방어).
        --================================================================================================
        DECLARE
            v_chk_cnt PLS_INTEGER := 0;
        BEGIN
            /* [E20260820-XLSWEEKLY] 과거 주 가드 — V_TITLE 주차(주 시작일) < 당주 월요일 슬롯에 값이 있는 행 = ERROR
               (사용자 요구: 당주 이후만 등록 — Form 도 당주 이후만 생성하므로 정상 왕복에선 발생하지 않는 방어 가드) */
            UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD U
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = MESSAGE_TEXT || ', Past Week Not Allowed'
            WHERE  U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.CREATED_BY = p_created_by
            AND    TO_CHAR(U.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    U.UPLOAD_STATUS_CODE IN ('UPLOAD', 'SUCCESS')   /* 분류 후 시점 — SUCCESS 도 대상 (실측 정정) */
            AND    EXISTS (
                     SELECT 1
                     FROM  (SELECT COLUMN_NAME, YYYYMMDD
                            FROM  (SELECT ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35, ATTRIBUTE36
                                   FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                                   WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                                   AND    UPLOAD_STATUS_CODE = 'V_TITLE' AND ROWNUM = 1)
                            UNPIVOT (YYYYMMDD FOR COLUMN_NAME IN (ATTRIBUTE11 AS 'ATTRIBUTE11', ATTRIBUTE12 AS 'ATTRIBUTE12', ATTRIBUTE13 AS 'ATTRIBUTE13', ATTRIBUTE14 AS 'ATTRIBUTE14', ATTRIBUTE15 AS 'ATTRIBUTE15', ATTRIBUTE16 AS 'ATTRIBUTE16', ATTRIBUTE17 AS 'ATTRIBUTE17', ATTRIBUTE18 AS 'ATTRIBUTE18', ATTRIBUTE19 AS 'ATTRIBUTE19', ATTRIBUTE20 AS 'ATTRIBUTE20', ATTRIBUTE21 AS 'ATTRIBUTE21', ATTRIBUTE22 AS 'ATTRIBUTE22', ATTRIBUTE23 AS 'ATTRIBUTE23', ATTRIBUTE24 AS 'ATTRIBUTE24', ATTRIBUTE25 AS 'ATTRIBUTE25', ATTRIBUTE26 AS 'ATTRIBUTE26', ATTRIBUTE27 AS 'ATTRIBUTE27', ATTRIBUTE28 AS 'ATTRIBUTE28', ATTRIBUTE29 AS 'ATTRIBUTE29', ATTRIBUTE30 AS 'ATTRIBUTE30', ATTRIBUTE31 AS 'ATTRIBUTE31', ATTRIBUTE32 AS 'ATTRIBUTE32', ATTRIBUTE33 AS 'ATTRIBUTE33', ATTRIBUTE34 AS 'ATTRIBUTE34', ATTRIBUTE35 AS 'ATTRIBUTE35', ATTRIBUTE36 AS 'ATTRIBUTE36'))) T
                     WHERE REGEXP_LIKE(T.YYYYMMDD, '^[0-9]{8}$')
                     AND   T.YYYYMMDD < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                     AND   CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END IS NOT NULL);

            SELECT COUNT(*) INTO v_chk_cnt
            FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = v_program_id
            AND    SHEET_NAME = v_sheet_name
            AND    CREATED_BY = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'SUCCESS';

            IF v_chk_cnt > 0 THEN
                -- (1) 업로드분 일 단위 전개 → GT_PRDM1_T_MAIN (2단계 적재부와 동일 경로 재사용)
                /* [E20260820-XLSWEEKLY] 주차 값 -> 일 전개 (LOC 전용 — 검증이 LOC 만 SUCCESS 허용).
                   구 GET_EXCEL_UPLOAD_DATA(M4~M16 = 당월+4~+16 고정 산식) 호출 대체 — 주차는 V_TITLE(주 시작일 헤더) 실측 해석.
                   후속 VMI 특례 INSERT 는 UNPIVOT GTT 를 비워 자연 무효(LOC 한정 체제 — 원문 존치). */
                DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;
                DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;
                DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;
                INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
                ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
                , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
                , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
                , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
                SELECT U.ATTRIBUTE301, U.ATTRIBUTE302, U.ATTRIBUTE303, U.ATTRIBUTE304, U.ATTRIBUTE305
                     , U.ATTRIBUTE306, U.ATTRIBUTE307, U.ATTRIBUTE308, U.ATTRIBUTE309, U.ATTRIBUTE310
                     , NULL, SUBSTR(CM.BASIS_YYYYMMDD, 1, 6), CM.BASIS_YYYYMMDD, CM.ISO_YYYYWW
                     , NULL, NULL
                     , CAST(TO_NUMBER(CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END) AS NUMBER(23,2)), NULL
                     , CAST(TO_NUMBER(CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END) AS NUMBER(23,2))
                FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD U
                CROSS JOIN (SELECT COLUMN_NAME, YYYYMMDD
                            FROM  (SELECT ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35, ATTRIBUTE36
                                   FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                                   WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                                   AND    UPLOAD_STATUS_CODE = 'V_TITLE' AND ROWNUM = 1)
                            UNPIVOT (YYYYMMDD FOR COLUMN_NAME IN (ATTRIBUTE11 AS 'ATTRIBUTE11', ATTRIBUTE12 AS 'ATTRIBUTE12', ATTRIBUTE13 AS 'ATTRIBUTE13', ATTRIBUTE14 AS 'ATTRIBUTE14', ATTRIBUTE15 AS 'ATTRIBUTE15', ATTRIBUTE16 AS 'ATTRIBUTE16', ATTRIBUTE17 AS 'ATTRIBUTE17', ATTRIBUTE18 AS 'ATTRIBUTE18', ATTRIBUTE19 AS 'ATTRIBUTE19', ATTRIBUTE20 AS 'ATTRIBUTE20', ATTRIBUTE21 AS 'ATTRIBUTE21', ATTRIBUTE22 AS 'ATTRIBUTE22', ATTRIBUTE23 AS 'ATTRIBUTE23', ATTRIBUTE24 AS 'ATTRIBUTE24', ATTRIBUTE25 AS 'ATTRIBUTE25', ATTRIBUTE26 AS 'ATTRIBUTE26', ATTRIBUTE27 AS 'ATTRIBUTE27', ATTRIBUTE28 AS 'ATTRIBUTE28', ATTRIBUTE29 AS 'ATTRIBUTE29', ATTRIBUTE30 AS 'ATTRIBUTE30', ATTRIBUTE31 AS 'ATTRIBUTE31', ATTRIBUTE32 AS 'ATTRIBUTE32', ATTRIBUTE33 AS 'ATTRIBUTE33', ATTRIBUTE34 AS 'ATTRIBUTE34', ATTRIBUTE35 AS 'ATTRIBUTE35', ATTRIBUTE36 AS 'ATTRIBUTE36'))) T
                JOIN   SCM_MGR.SCM_SYS_CALENDAR_M CM ON CM.BASIS_START_DATE = T.YYYYMMDD
                WHERE  U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.CREATED_BY = p_created_by
                AND    TO_CHAR(U.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                AND    U.UPLOAD_STATUS_CODE = 'SUCCESS'
                AND    REGEXP_LIKE(T.YYYYMMDD, '^[0-9]{8}$')
                AND    CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END IS NOT NULL;

                INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
                ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
                , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
                , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
                , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
                SELECT U.DIVISION_ID, U.END_CUSTOMER, U.SCM_SITE_ID, U.ITEM_ID, U.INCOTERMS
                     , U.FCST_TYPE, U.DOM_EXP, U.CELL_PROD_SITE, U.CURRENCY, U.MEASURE
                     , U.KEY_VALUE, U.YYYYMM, U.YYYYMM || '01', NULL
                     , 1, U.QTY, U.QTY, 'Y', U.QTY
                FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT U
                WHERE  U.MEASURE = 'VMI_In_Req'
                AND    NVL(U.QTY, 0) <> 0;

                DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
                INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
                ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
                , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
                , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
                SELECT 'M'
                     , D.DIVISION_ID
                     , D.END_CUSTOMER
                     , D.END_CUSTOMER
                     , D.SCM_SITE_ID
                     , D.ITEM_ID
                     , D.DOM_EXP
                     , D.FCST_TYPE
                     , D.INCOTERMS
                     , D.MEASURE
                     , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                               FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                              WHERE X.DIVISION_ID       = D.DIVISION_ID
                                AND X.PROJECT_CODE      = D.END_CUSTOMER
                                AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                                AND X.ITEM_ID           = D.ITEM_ID
                                AND X.DOM_EXP           = D.DOM_EXP
                                AND X.FCST_TYPE         = D.FCST_TYPE
                                AND X.INCOTERMS         = D.INCOTERMS
                                AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                          , NVL( (SELECT MAX(F.PLANT_SITE_ID)   /* [E20260820-XLSWEEKLY] 81 원장 역참조 — 40 참조(DM_PLN_CFM)는 81 에 항상 NULL
                                                                    → PLANT_SITE '-' 로 SAVE 필수검증 'F' (사내 실측 2026-08-20).
                                                                    기존 키('M' 갱신)는 원장 실키로 해소. 원장 무존재 신규 키는 '-' 유지 = Plant Site 축 미결. */
                                 FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
                                WHERE F.DIVISION_ID  = D.DIVISION_ID
                                  AND F.PROJECT_CODE = D.END_CUSTOMER
                                  AND F.SCM_SITE_ID  = D.SCM_SITE_ID
                                  AND F.ITEM_ID      = D.ITEM_ID
                                  AND F.DOM_EXP      = D.DOM_EXP
                                  AND F.FCST_TYPE    = D.FCST_TYPE
                                  AND F.INCOTERMS    = D.INCOTERMS
                                  AND F.MEASURE      = 'LOC')
                             , '-' ) )
                     , D.CELL_PROD_SITE
                     , D.BASIS_YYYYMMDD
                     , D.CURRENCY
                     , D.DAILY_QTY
                     , p_created_by
                     , '', '', '', '', '', '', '', '', '', '', '', ''
                FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY D
                /* [E20260819-XLS81LOC] LOC 적재 결함 정정 — LOC DAILY 행은 MONTHLY_QTY=NULL(값=DAILY_QTY)이라
                   구 필터 NVL(MONTHLY_QTY,0)<>0 이 LOC 전량 탈락 → T_MAIN 0행 = NO_TARGET_ROW (사내 실측 2026-08-19).
                   measure 별 값 컬럼으로 판정 (MKT_FCST 의미 불변 — 0값 행 제외 동일). */
                WHERE  (CASE WHEN D.MEASURE = 'LOC' THEN NVL(D.DAILY_QTY, 0)
                             ELSE NVL(D.MONTHLY_QTY, 0) END) <> 0;

                -- (2) 검증 대상 MEASURE / 제외 FCST_TYPE (SAVE 검증 10 동일 — lookup 단일 소스)
                DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1;
                INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2)
                SELECT MST.SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                AND    MST.SEGMENT1 = 'MEASURE' AND MST.VALID_YN = 'Y';

                DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;
                INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2)
                SELECT MST.SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                AND    MST.SEGMENT1 = 'FCST_TYPE' AND MST.VALID_YN = 'Y';

                -- (3) 판가 52주 수집 — 원장 LOC ∪ 업로드 LOC (SAVE 검증 1.2 의 40 경로 동일,
                --     SENTINEL3 변형 3형 정규화 비교 동일)
                DELETE FROM SCM_MGR.GT_PRDM1_T_PRICE;
                INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
                ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
                , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
                SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
                     , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
                FROM (
                    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID
                                  , B.CELL_PROD_SITE_ID, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
                                  , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
                      ON A.DIVISION_ID  = B.DIVISION_ID
                     AND A.PROJECT_CODE = B.PROJECT_CODE
                     AND A.END_CUSTOMER = B.END_CUSTOMER
                     AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                     --[E20260820-SENTINELDDL] 변형 동일 처리 삭제 — 데이터·기록 경로 정규화 완료로 단순 등호
                     AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                     AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                     AND A.ITEM_ID   = B.ITEM_ID
                     AND A.DOM_EXP   = B.DOM_EXP
                     AND A.FCST_TYPE = B.FCST_TYPE
                     AND A.INCOTERMS = B.INCOTERMS
                    WHERE B.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND B.YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND B.PRICE <> 0
                      AND B.MEASURE = 'LOC'
                    UNION
                    SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID
                                  , A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
                                  , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND A.YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND A.QTY_PRICE <> 0
                      AND A.MEASURE = 'LOC'
                ) AA
                GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
                       , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;

                -- (4) 위반 키별 업로드 행 ERROR 분류 (SAVE 검증 10 판정식 동일 — TOP1 대신 전 키)
                FOR v IN (
                    SELECT A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                         , A.CELL_PROD_SITE_ID AS CELL_KEY  --[E20260820-SENTINELDDL] 변형 동일 처리 삭제
                         , A.MEASURE
                         , MIN(M.BASIS_START_DATE) AS MISS_FROM
                         , MAX(M.BASIS_START_DATE) AS MISS_TO
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
                            ON A.DIVISION_ID  = Z.DIVISION_ID
                           AND A.PROJECT_CODE = Z.PROJECT_CODE
                           AND A.SCM_SITE_ID  = Z.SCM_SITE_ID
                           AND A.ITEM_ID      = Z.ITEM_ID
                           AND Z.VALID_YN     = 'Y'
                           AND (Z.SALES_PLAN_ADJUST_YN = 'Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
                    LEFT JOIN (
                        SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M
                        WHERE BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                          AND BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                        GROUP BY BASIS_START_DATE
                    ) M ON 1 = 1
                    LEFT JOIN SCM_MGR.GT_PRDM1_T_PRICE P
                           ON A.DIVISION_ID  = P.DIVISION_ID
                          AND A.PROJECT_CODE = P.PROJECT_CODE
                          AND A.END_CUSTOMER = P.END_CUSTOMER
                          AND A.SCM_SITE_ID  = P.SCM_SITE_ID
                          --[E20260820-SENTINELDDL] 변형 동일 처리 삭제 — 단순 등호
                          AND A.PLANT_SITE_ID     = P.PLANT_SITE_ID
                          AND A.CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
                          AND A.ITEM_ID   = P.ITEM_ID
                          AND A.DOM_EXP   = P.DOM_EXP
                          AND A.FCST_TYPE = P.FCST_TYPE
                          AND A.INCOTERMS = P.INCOTERMS
                          AND P.YYYYMMDD  = M.BASIS_START_DATE
                          AND P.PRICE     > 0
                    WHERE P.YYYYMMDD IS NULL
                      AND A.MEASURE IN (SELECT SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU1)
                      AND A.QTY_PRICE <> 0
                      --[E20260814-FCSTNAME] 코드·명칭 양쪽 제외 (SAVE 검증 10 동일)
                      AND A.FCST_TYPE NOT IN (
                              SELECT X.SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU2 X
                              UNION ALL
                              SELECT L.SEGMENT2
                              FROM   SCM_MGR.GT_PRDM1_MSHYCHU2 X
                              JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                     ON L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                    AND L.VALID_YN    = 'Y'
                                    AND L.SEGMENT1    = X.SEGMENT2 )
                    GROUP BY A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                           , A.CELL_PROD_SITE_ID  --[E20260820-SENTINELDDL] 변형 동일 처리 삭제
                           , A.MEASURE
                ) LOOP
                    UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD EU
                    SET    EU.UPLOAD_STATUS_CODE = 'ERROR'
                         , EU.MESSAGE_TEXT       = 'Unit Price Not Found ! 해당주차의 Sales Price 값을 입력하시기 바랍니다. '
                                                   || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다. '
                                                   || '(미입력: ' || v.MISS_FROM || ' ~ ' || v.MISS_TO || ')'
                    WHERE  EU.PROGRAM_ID = v_program_id
                    AND    EU.SHEET_NAME = v_sheet_name
                    AND    EU.CREATED_BY = p_created_by
                    AND    TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                    AND    EU.UPLOAD_STATUS_CODE = 'SUCCESS'
                    AND    EU.ATTRIBUTE302 = v.END_CUSTOMER
                    AND    EU.ATTRIBUTE303 = v.SCM_SITE_ID
                    AND    EU.ATTRIBUTE304 = v.ITEM_ID
                    AND    EU.ATTRIBUTE305 = v.INCOTERMS
                    AND    EU.ATTRIBUTE306 = v.FCST_TYPE
                    AND    EU.ATTRIBUTE307 = v.DOM_EXP
                    --[E20260820-SENTINELDDL] 변형 CASE 삭제 — 단, 스테이징(엑셀 원문)은 DDL 범위 밖이라
                    --  빈칸(NULL)=미지정('-') 만 NVL 로 유지 (81 양식엔 Cell Prod Site 열 자체가 없음)
                    AND    NVL(EU.ATTRIBUTE308, '-') = v.CELL_KEY
                    AND    EU.ATTRIBUTE310 = v.MEASURE;
                END LOOP;
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- 1단계 선검증 실패는 분류를 막지 않는다(2단계 검증이 최종 방어) — 단, 조용히 삼키지
                -- 않도록 로그는 남긴다.
                v_log_type    := 'PRICECHK1';
                v_log_message := '########## PRICECHK1 SKIPPED: ' || SUBSTR(SQLERRM, 1, 150) || ' ##########';
                v_description := '';
                d_event_date  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
                EXCEPTION WHEN OTHERS THEN NULL; END;
        END;

        /* [변환 노트] AS-IS 원문 889~1120 라인의 주석 처리된 MSSQL 테스트 블록
           (#FCST_PRICE_EXCEL/#FCST_PRICE_UNPIVOT/#FCST_PRICE_BUCKET/#FCST_PRICE_WEEKLY 데일리 분배 시험 쿼리)
           은 실행 코드가 아니므로 미이관 — 원문 = asis_DMF0082_EXCEL_UPLOAD.sql 보존. 실 로직은
           DMF0082_GET_EXCEL_UPLOAD_DATA (02 파일) 에 정식 구현되어 있음. */


    ELSE
        --================================================================================================
        -- [E20260813-UPLOADSAVE] p_mode > 0 : 검증 통과분을 **원장에 적재**한다.
        --   수신 원본에는 이 분기가 아예 없어 OK(2단계)가 원장에 아무것도 쓰지 않았다 (2026-08-13 실측).
        --   적재는 화면 저장과 **동일 경로**(P_DMF0082_SAVE_MAIN_DATA 본체)를 재사용한다 —
        --   MERGE 5종과 검증 게이트를 복제하지 않기 위해, 그 SP 의 '^' 파싱부만 건너뛰고(g_skip_parse)
        --   GT_PRDM1_T_MAIN 을 집합으로 채운 뒤 본체를 **1회** 호출한다.
        --   (행 단위 호출은 파싱 로컬이 VARCHAR2(4000) 이라 호출 폭증 — 사용자 확정: 본체 1회 호출)
        --================================================================================================
        SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
             , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
        INTO   n_success_cnt, n_error_cnt
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

        -- 전량 게이트 — 오류 1건이라도 남았거나 대상이 없으면 적재하지 않는다 (FE 전량 게이트와 이중 방어)
        IF n_error_cnt > 0 OR n_success_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NOT_SAVABLE (SUCCESS=' || TO_CHAR(n_success_cnt)
                       || ', ERROR=' || TO_CHAR(n_error_cnt) || ')' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;
        END IF;

        ------------------------------------------------------------------------
        -- 1) 월→일 배분 = 조회 SP 의 GTT 파이프라인 재사용 (배분 산식 복제 금지)
        ------------------------------------------------------------------------
        /* [E20260820-XLSWEEKLY] 주차 값 -> 일 전개 (LOC 전용 — 검증이 LOC 만 SUCCESS 허용).
           구 GET_EXCEL_UPLOAD_DATA(M4~M16 = 당월+4~+16 고정 산식) 호출 대체 — 주차는 V_TITLE(주 시작일 헤더) 실측 해석.
           후속 VMI 특례 INSERT 는 UNPIVOT GTT 를 비워 자연 무효(LOC 한정 체제 — 원문 존치). */
        DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;
        DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;
        DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;
        INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
        ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
        , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
        , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
        , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
        SELECT U.ATTRIBUTE301, U.ATTRIBUTE302, U.ATTRIBUTE303, U.ATTRIBUTE304, U.ATTRIBUTE305
             , U.ATTRIBUTE306, U.ATTRIBUTE307, U.ATTRIBUTE308, U.ATTRIBUTE309, U.ATTRIBUTE310
             , NULL, SUBSTR(CM.BASIS_YYYYMMDD, 1, 6), CM.BASIS_YYYYMMDD, CM.ISO_YYYYWW
             , NULL, NULL
             , CAST(TO_NUMBER(CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END) AS NUMBER(23,2)), NULL
             , CAST(TO_NUMBER(CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END) AS NUMBER(23,2))
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD U
        CROSS JOIN (SELECT COLUMN_NAME, YYYYMMDD
                    FROM  (SELECT ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35, ATTRIBUTE36
                           FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                           WHERE  PROGRAM_ID = v_program_id AND SHEET_NAME = v_sheet_name AND CREATED_BY = p_created_by
                           AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                           AND    UPLOAD_STATUS_CODE = 'V_TITLE' AND ROWNUM = 1)
                    UNPIVOT (YYYYMMDD FOR COLUMN_NAME IN (ATTRIBUTE11 AS 'ATTRIBUTE11', ATTRIBUTE12 AS 'ATTRIBUTE12', ATTRIBUTE13 AS 'ATTRIBUTE13', ATTRIBUTE14 AS 'ATTRIBUTE14', ATTRIBUTE15 AS 'ATTRIBUTE15', ATTRIBUTE16 AS 'ATTRIBUTE16', ATTRIBUTE17 AS 'ATTRIBUTE17', ATTRIBUTE18 AS 'ATTRIBUTE18', ATTRIBUTE19 AS 'ATTRIBUTE19', ATTRIBUTE20 AS 'ATTRIBUTE20', ATTRIBUTE21 AS 'ATTRIBUTE21', ATTRIBUTE22 AS 'ATTRIBUTE22', ATTRIBUTE23 AS 'ATTRIBUTE23', ATTRIBUTE24 AS 'ATTRIBUTE24', ATTRIBUTE25 AS 'ATTRIBUTE25', ATTRIBUTE26 AS 'ATTRIBUTE26', ATTRIBUTE27 AS 'ATTRIBUTE27', ATTRIBUTE28 AS 'ATTRIBUTE28', ATTRIBUTE29 AS 'ATTRIBUTE29', ATTRIBUTE30 AS 'ATTRIBUTE30', ATTRIBUTE31 AS 'ATTRIBUTE31', ATTRIBUTE32 AS 'ATTRIBUTE32', ATTRIBUTE33 AS 'ATTRIBUTE33', ATTRIBUTE34 AS 'ATTRIBUTE34', ATTRIBUTE35 AS 'ATTRIBUTE35', ATTRIBUTE36 AS 'ATTRIBUTE36'))) T
        JOIN   SCM_MGR.SCM_SYS_CALENDAR_M CM ON CM.BASIS_START_DATE = T.YYYYMMDD
        WHERE  U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.CREATED_BY = p_created_by
        AND    TO_CHAR(U.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    U.UPLOAD_STATUS_CODE = 'SUCCESS'
        AND    REGEXP_LIKE(T.YYYYMMDD, '^[0-9]{8}$')
        AND    CASE T.COLUMN_NAME WHEN 'ATTRIBUTE11' THEN U.ATTRIBUTE11 WHEN 'ATTRIBUTE12' THEN U.ATTRIBUTE12 WHEN 'ATTRIBUTE13' THEN U.ATTRIBUTE13 WHEN 'ATTRIBUTE14' THEN U.ATTRIBUTE14 WHEN 'ATTRIBUTE15' THEN U.ATTRIBUTE15 WHEN 'ATTRIBUTE16' THEN U.ATTRIBUTE16 WHEN 'ATTRIBUTE17' THEN U.ATTRIBUTE17 WHEN 'ATTRIBUTE18' THEN U.ATTRIBUTE18 WHEN 'ATTRIBUTE19' THEN U.ATTRIBUTE19 WHEN 'ATTRIBUTE20' THEN U.ATTRIBUTE20 WHEN 'ATTRIBUTE21' THEN U.ATTRIBUTE21 WHEN 'ATTRIBUTE22' THEN U.ATTRIBUTE22 WHEN 'ATTRIBUTE23' THEN U.ATTRIBUTE23 WHEN 'ATTRIBUTE24' THEN U.ATTRIBUTE24 WHEN 'ATTRIBUTE25' THEN U.ATTRIBUTE25 WHEN 'ATTRIBUTE26' THEN U.ATTRIBUTE26 WHEN 'ATTRIBUTE27' THEN U.ATTRIBUTE27 WHEN 'ATTRIBUTE28' THEN U.ATTRIBUTE28 WHEN 'ATTRIBUTE29' THEN U.ATTRIBUTE29 WHEN 'ATTRIBUTE30' THEN U.ATTRIBUTE30 WHEN 'ATTRIBUTE31' THEN U.ATTRIBUTE31 WHEN 'ATTRIBUTE32' THEN U.ATTRIBUTE32 WHEN 'ATTRIBUTE33' THEN U.ATTRIBUTE33 WHEN 'ATTRIBUTE34' THEN U.ATTRIBUTE34 WHEN 'ATTRIBUTE35' THEN U.ATTRIBUTE35 WHEN 'ATTRIBUTE36' THEN U.ATTRIBUTE36 END IS NOT NULL;

        ------------------------------------------------------------------------
        -- 2) VMI_In_Req = **배분 없이 월 1일에 전량** (사용자 확정 2026-08-13)
        --    배분 파이프라인은 MKT_FCST / LOC 만 처리하므로, 확장하지 않으면 VMI 는
        --    검증을 통과하고도 DAILY 0건이 되어 조용히 누락된다.
        ------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
        ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
        , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
        , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
        , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
        SELECT U.DIVISION_ID, U.END_CUSTOMER, U.SCM_SITE_ID, U.ITEM_ID, U.INCOTERMS
             , U.FCST_TYPE, U.DOM_EXP, U.CELL_PROD_SITE, U.CURRENCY, U.MEASURE
             , U.KEY_VALUE, U.YYYYMM, U.YYYYMM || '01', NULL
             , 1, U.QTY, U.QTY, 'Y', U.QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT U
        WHERE  U.MEASURE = 'VMI_In_Req'
        AND    NVL(U.QTY, 0) <> 0;

        ------------------------------------------------------------------------
        -- 3) COMMIT — 본체가 검증 실패로 ROLLBACK 하면 **GTT 적재분도 함께 사라진다**
        --    (ON COMMIT PRESERVE ROWS 는 "커밋해도 안 지운다"이지 롤백 면제가 아니다)
        ------------------------------------------------------------------------
        COMMIT;

        ------------------------------------------------------------------------
        -- 4) 저장 본체 입력 GTT 를 집합으로 1회 적재
        --    · 미입력(빈칸) 월 제외 = MONTHLY_QTY <> 0. 빈칸은 UNPIVOT INCLUDE NULLS+NVL 로 0 이 되고,
        --      0 입력은 검증이 거부하므로 "월 합계 0" == "그 달은 손대지 않았다" 가 성립한다.
        --      (DAILY_QTY <> 0 으로 거르면 배분 FLOOR 결과가 0인 정상 일자를 버려 총량이 깨진다)
        --    · PLANT_SITE_ID 는 양식 토큰에 없다(추가하면 중복키 검사가 전량 ERROR) → 원장 역참조.
        ------------------------------------------------------------------------
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;

        INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
        ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
        , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
        , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
        SELECT 'M'                                   -- 양식 행 = 기존 키의 값 갱신
             , D.DIVISION_ID
             , D.END_CUSTOMER                        -- 40 은 PROJECT_CODE = END_CUSTOMER
             , D.END_CUSTOMER
             , D.SCM_SITE_ID
             , D.ITEM_ID
             , D.DOM_EXP
             , D.FCST_TYPE
             , D.INCOTERMS
             , D.MEASURE
             , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                       FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                      WHERE X.DIVISION_ID       = D.DIVISION_ID
                        AND X.PROJECT_CODE      = D.END_CUSTOMER
                        AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                        AND X.ITEM_ID           = D.ITEM_ID
                        AND X.DOM_EXP           = D.DOM_EXP
                        AND X.FCST_TYPE         = D.FCST_TYPE
                        AND X.INCOTERMS         = D.INCOTERMS
                        AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                  , (SELECT MAX(F.PLANT_SITE_ID)   /* [E20260820-XLSWEEKLY] 81 원장 역참조 — 40 참조(DM_PLN_CFM)는 81 에 항상 NULL
                                                            → PLANT_SITE '-' 로 SAVE 필수검증 'F' (사내 실측 2026-08-20).
                                                            기존 키('M' 갱신)는 원장 실키로 해소. 원장 무존재 신규 키는 '-' 유지 = Plant Site 축 미결.
                                                            [E20260820-SENTINELDDL] 최종 '-' 폴백 NVL 제거 — NULL 이면 GTT DEFAULT ON NULL '-' 적용 */
                         FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
                        WHERE F.DIVISION_ID  = D.DIVISION_ID
                          AND F.PROJECT_CODE = D.END_CUSTOMER
                          AND F.SCM_SITE_ID  = D.SCM_SITE_ID
                          AND F.ITEM_ID      = D.ITEM_ID
                          AND F.DOM_EXP      = D.DOM_EXP
                          AND F.FCST_TYPE    = D.FCST_TYPE
                          AND F.INCOTERMS    = D.INCOTERMS
                          AND F.MEASURE      = 'LOC') )
             , D.CELL_PROD_SITE
             , D.BASIS_YYYYMMDD
             , D.CURRENCY
             , D.DAILY_QTY
             , p_created_by
             , '', '', '', '', '', '', '', '', '', '', '', ''
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY D
        /* [E20260819-XLS81LOC] LOC 적재 결함 정정(모드1 지점 — 모드0 지점과 동일) — LOC DAILY 행은
           MONTHLY_QTY=NULL(값=DAILY_QTY)이라 구 필터가 LOC 전량 탈락 = NO_TARGET_ROW (사내 실측 2026-08-19). */
        WHERE  (CASE WHEN D.MEASURE = 'LOC' THEN NVL(D.DAILY_QTY, 0)
                     ELSE NVL(D.MONTHLY_QTY, 0) END) <> 0;

        SELECT COUNT(*) INTO n_save_cnt FROM SCM_MGR.GT_PRDM1_T_MAIN;
        COMMIT;

        IF n_save_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NO_TARGET_ROW (입력된 값이 없습니다)' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;
        END IF;

        ------------------------------------------------------------------------
        -- 5) 저장 본체 1회 호출 (파싱부 skip — GT_PRDM1_T_MAIN 은 위에서 이미 적재)
        ------------------------------------------------------------------------
        g_skip_parse := 'Y';
        BEGIN
            SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(
                'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
              , NULL, NULL, NULL, NULL, NULL, p_created_by, NULL, v_rc_save);
        EXCEPTION
            WHEN OTHERS THEN
                g_skip_parse := 'N';
                RAISE;
        END;
        g_skip_parse := 'N';

        v_save_code := NULL; v_save_msg := NULL; v_save_event := NULL;
        BEGIN
            FETCH v_rc_save INTO v_save_code, v_save_msg, v_save_event;
            CLOSE v_rc_save;
        EXCEPTION WHEN OTHERS THEN NULL; END;

        -- 적재 성공분 마킹 — 재클릭 이중 적재 방지 (다음 mode>0 은 SUCCESS 0건이라 게이트에서 거부)
        IF NVL(v_save_code, 'F') = '0' THEN
            UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SAVED'
                 , LAST_UPDATED_BY    = p_created_by
                 , LAST_UPDATE_DATE   = SYSDATE
             WHERE PROGRAM_ID = v_program_id
             AND   SHEET_NAME = v_sheet_name
             AND   CREATED_BY = p_created_by
             AND   TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
             AND   UPLOAD_STATUS_CODE = 'SUCCESS';
            COMMIT;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT NVL(v_save_code, 'F') AS RESULT_CODE
                 , CASE WHEN NVL(v_save_code, 'F') = '0'
                        THEN 'SAVED=' || TO_CHAR(n_save_cnt)
                        ELSE NVL(v_save_msg, 'SAVE FAILED') END AS RESULT_MSG
                 , TO_CHAR(NVL(p_mode, 0)) AS EVENT
            FROM   DUAL;
        RETURN;

    END IF;

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    ----------------------------------------------------------------------------
    v_log_type    := '21';
    v_log_message := '########## INSERT DMF0028_EXCEL_UPLOAD END ##########';
    v_description := TO_CHAR(p_mode);   --CONVERT(CHAR(30), @v_creation_date, 121);
    d_event_date  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    ----------------------------------------------------------------------------
    -- 결과코드 반환 (TO-BE 2-Step 표준: 검증분류 결과 건수)
    ----------------------------------------------------------------------------
    SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
         , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
    INTO   n_success_cnt, n_error_cnt
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
    WHERE  PROGRAM_ID = v_program_id
    AND    SHEET_NAME = v_sheet_name
    AND    CREATED_BY = p_created_by
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT CASE WHEN n_error_cnt > 0 THEN '1' ELSE '0' END AS RESULT_CODE
             , 'SUCCESS=' || TO_CHAR(n_success_cnt) || ', ERROR=' || TO_CHAR(n_error_cnt) AS RESULT_MSG
             , TO_CHAR(NVL(p_mode, 0)) AS EVENT
        FROM   DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count
              , '########## FAIL END of procedure ##########', ''
              , SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_EXCEL_UPLOAD;


PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA 
(
    p_created_by     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR   /* 최종 일자별 수량 (RECORD 형식) */
  , O_RC2            OUT SYS_REFCURSOR   /* 최종 일자별 수량 (PIVOT 형식 — 동적 D 컬럼) */
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR   /* 표준 결과 커서 (RESULT_CODE/RESULT_MSG/EVENT) */
)
/*=====================================================================================================================================================
 * Program ID  : DMF0082_GET_EXCEL_UPLOAD_DATA
 * Description : Fcst&Price MGMT 화면에서 Excel Upload로 MKT FCST, LOC 메저를 월별로 업로드 한 후, Daily 로 풀어서 보여주는 프로시저
 *                추후 Main 화면을 저장하는 프로시저 (DMF0082_SAVE_MAIN_DATA)를 호출하여 저장함.
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date         In Charge    Description
 *=====================================================================================================================================================
 * 2025.05.xx   KJY          최초 작성 (MSSQL)
 * 2026-07-12   Claude       MSSQL dbo.DMF0082_GET_EXCEL_UPLOAD_DATA → Oracle 19c 1:1 변환 (파일 산출물 — DB 미적용)
 *=====================================================================================================================================================
 * [변환 노트 — 부록 C 함정 처리]
 *  - #temp 5종 → GTT 5종 (00_gtt_ddl.sql 신규: GT_DMF0082_FCST_PRICE_*). GTT 초기화 = DELETE FROM (C-2 TRUNCATE 금지 / C-5 INSERT 전 DELETE)
 *  - MSSQL 마지막 SELECT 2개(RECORD/PIVOT) → O_RC1/O_RC2, 표준 O_RESULT_CURSOR 추가 (DMF0082_SAVE_MAIN_DATA Oracle 표준 준수)
 *  - CONVERT(NVARCHAR(40), CREATION_DATE, 121) → TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS.FF3') 명시 마스크 (C-11 NLS)
 *  - FORMAT(DATEADD(MONTH,n,GETDATE()),'yyyyMM') → TO_CHAR(ADD_MONTHS(SYSDATE,n),'YYYYMM') 명시 마스크 (C-11)
 *  - UNPIVOT: MSSQL 은 ''(빈문자열) 행 유지 + IIF 로 0 처리 / Oracle 은 '' = NULL 이므로 UNPIVOT INCLUDE NULLS + NVL(QTY,'0') 로 동등화 (C-7)
 *  - IIF(ISNULL(QTY,'')='','0',QTY) → NVL(A.QTY,'0') (C-7)
 *  - CONVERT(NUMERIC(23,2), x) → CAST(TO_NUMBER(x) AS NUMBER(23,2)) — 변환 실패 시 MSSQL 과 동일하게 에러 발생(silent 무시 금지)
 *  - EOMONTH → LAST_DAY / FORMAT(...,'dd') → TO_CHAR(...,'DD') 명시 마스크
 *  - '' AS LAST_DAY_YN → NULL (C-7, Oracle 에서 '' = NULL)
 *  - 동적 PIVOT IN 리스트 = CLOB + 커서 LOOP(FETCH 직후 EXIT WHEN %NOTFOUND — C-10) (hook #106 CLOB)
 *  - SP_EXECUTESQL → OPEN O_RC2 FOR V_SQL(CLOB)
 *  - MSSQL PRINT → DBMS_OUTPUT.PUT_LINE (SQL 원문 4000자 분할 PRINT 루프 포함 1:1 유지)
 *  - WITH (NOLOCK) 제거 / [bracket] 제거 / dbo. 제거 / TOP 1 → FETCH FIRST 1 ROWS ONLY
 *  - #FCST_PRICE_DAILY 의 BC 서브쿼리 DIVISION_ID = '40' 하드코딩은 AS-IS 원문 그대로 보존 (임의 수정 금지)
 *===================================================================================================================================================*/
IS
    v_program_id     VARCHAR2(40 CHAR)  := 'DMF0082';
    v_sheet_name     VARCHAR2(40 CHAR)  := 'FcstNPrice';
    v_creation_date  VARCHAR2(40 CHAR);
    v_start_yyyymm   VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 4), 'YYYYMM');
    v_end_yyyymm     VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 16), 'YYYYMM');
    v_division       VARCHAR2(10 CHAR);
    v_defaultLocBucketDay VARCHAR2(10 CHAR);

    /* 동적 PIVOT 변수 (hook #106 — 대량 문자열 누적 = CLOB) */
    V_CONCAT_PIVOT   CLOB;              /* PIVOT IN 절: 'D20260101' AS D20260101, ... */
    V_SQL            CLOB;
    V_PIVOT_PIECE    VARCHAR2(100 CHAR);
    V_PRINT_POS      PLS_INTEGER;
    V_PRINT_LEN      PLS_INTEGER;

    /* 표준 예외/로그 변수 */
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(20 CHAR);
    V_SQL_ERRMSG     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);

    /* C_PIVOT : 조회구간 일자별 동적 PIVOT 컬럼 커서 */
    CURSOR C_PIVOT IS
        SELECT 'D' || A.BASIS_YYYYMMDD AS PV_KEY
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  1 = 1
        AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
        ORDER BY A.BASIS_YYYYMMDD;

BEGIN
        --[E20260812-DS2] GTT 무통계 클라우드 10배 지연 방어 표준
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';


    V_PROC_INPUT := JSON_OBJECT('rows' VALUE REGEXP_COUNT(p_created_by, '\^') + 1, 'p_created_by' VALUE SUBSTR(p_created_by, 1, 50));

    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by;

    IF v_creation_date IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('NO EXCEL DATA');   /* AS-IS: PRINT 'NO EXCEL DATA' (실행은 계속) */
    END IF;

    ----------------------------------------------------------------------------------------------------
    -- GTT 초기화 (AS-IS: IF OBJECT_ID ... DROP TABLE — Oracle: DELETE FROM, C-2/C-5)
    ----------------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;

    ----------------------------------------------------------------------------------------------------
    --Excel Data
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , END_CUSTOMER_NAME, SCM_SITE_ID_NAME, FCST_TYPE_NAME, CELL_PROD_SITE_NAME, MEASURE_NAME
    , M4, M5, M6, M7, M8, M9, M10, M11, M12, M13, M14, M15, M16)
    SELECT A.ATTRIBUTE301 AS DIVISION_ID
         , A.ATTRIBUTE302 AS END_CUSTOMER
         , A.ATTRIBUTE303 AS SCM_SITE_ID
         , A.ATTRIBUTE304 AS ITEM_ID
         , A.ATTRIBUTE305 AS INCOTERMS
         , A.ATTRIBUTE306 AS FCST_TYPE
         , A.ATTRIBUTE307 AS DOM_EXP
         , A.ATTRIBUTE308 AS CELL_PROD_SITE
         , A.ATTRIBUTE309 AS CURRENCY
         , A.ATTRIBUTE310 AS MEASURE
         , A.ATTRIBUTE2   AS END_CUSTOMER_NAME
         , A.ATTRIBUTE3   AS SCM_SITE_ID_NAME
         , A.ATTRIBUTE6   AS FCST_TYPE_NAME
         , A.ATTRIBUTE8   AS CELL_PROD_SITE_NAME
         , A.ATTRIBUTE10  AS MEASURE_NAME
         , A.ATTRIBUTE11  AS M4
         , A.ATTRIBUTE12  AS M5
         , A.ATTRIBUTE13  AS M6
         , A.ATTRIBUTE14  AS M7
         , A.ATTRIBUTE15  AS M8
         , A.ATTRIBUTE16  AS M9
         , A.ATTRIBUTE17  AS M10
         , A.ATTRIBUTE18  AS M11
         , A.ATTRIBUTE19  AS M12
         , A.ATTRIBUTE20  AS M13
         , A.ATTRIBUTE21  AS M14
         , A.ATTRIBUTE22  AS M15
         , A.ATTRIBUTE23  AS M16
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
    WHERE  1 = 1
    AND    A.PROGRAM_ID = v_program_id
    AND    A.SHEET_NAME = v_sheet_name
    AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    A.UPLOAD_STATUS_CODE = 'SUCCESS';

    /* SELECT TOP 1 @v_division = DIVISION_ID FROM #FCST_PRICE_EXCEL */
    BEGIN
        SELECT DIVISION_ID
        INTO   v_division
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division := NULL;
    END;

    --LOC메저 기본 버킷 요일
    v_defaultLocBucketDay := 'MON';

    ----------------------------------------------------------------------------------------------------
    --Unpivot
    -- (C-7) MSSQL UNPIVOT 은 ''(빈문자열) 셀 행을 유지하고 IIF 로 0 처리.
    --       Oracle 은 '' = NULL 이므로 INCLUDE NULLS + NVL(QTY,'0') 로 동일 결과 보장.
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , END_CUSTOMER_NAME, SCM_SITE_ID_NAME, FCST_TYPE_NAME, CELL_PROD_SITE_NAME, MEASURE_NAME
    , KEY_VALUE, YYYYMM, QTY)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.END_CUSTOMER_NAME
         , A.SCM_SITE_ID_NAME
         , A.FCST_TYPE_NAME
         , A.CELL_PROD_SITE_NAME
         , A.MEASURE_NAME
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM AS YYYYMM
         , A.QTY
    FROM  (SELECT A.DIVISION_ID
                , A.END_CUSTOMER
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.INCOTERMS
                , A.FCST_TYPE
                , A.DOM_EXP
                , A.CELL_PROD_SITE
                , A.CURRENCY
                , A.MEASURE
                , A.END_CUSTOMER_NAME
                , A.SCM_SITE_ID_NAME
                , A.FCST_TYPE_NAME
                , A.CELL_PROD_SITE_NAME
                , A.MEASURE_NAME
                , A.DIVISION_ID || A.END_CUSTOMER || A.SCM_SITE_ID || A.ITEM_ID || A.INCOTERMS
                  || A.FCST_TYPE || A.DOM_EXP || A.CELL_PROD_SITE || A.CURRENCY || A.MEASURE AS KEY_VALUE
                , A.YYYYMM
                /* CONVERT(NUMERIC(23,2), IIF(ISNULL(A.QTY,'')='', '0', A.QTY)) */
                , CAST(TO_NUMBER(NVL(A.QTY, '0')) AS NUMBER(23,2)) AS QTY
           /* Oracle UNPIVOT: 테이블과 UNPIVOT 사이 alias 불가 → alias 는 UNPIVOT 결과에 부여 */
           FROM  SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
           UNPIVOT INCLUDE NULLS (QTY FOR YYYYMM IN
                 ( M4  AS 'M4',  M5  AS 'M5',  M6  AS 'M6',  M7  AS 'M7'
                 , M8  AS 'M8',  M9  AS 'M9',  M10 AS 'M10', M11 AS 'M11'
                 , M12 AS 'M12', M13 AS 'M13', M14 AS 'M14', M15 AS 'M15', M16 AS 'M16')) A
          ) A
    JOIN  (SELECT DISTINCT A.BASIS_YYYYMM
                , 'M' || TO_CHAR(DENSE_RANK() OVER (ORDER BY A.BASIS_YYYYMM) + 3) AS RN
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm) CM
      ON  (CM.RN = A.YYYYMM);

    ----------------------------------------------------------------------------------------------------
    --[MKT_FCST]
    --BUCKET 이 포함된 주차(=월별 수량을 나눠야할 대상 주차)
    --SCM_SITE_ID/INCOTERMS별 BUCKET 이 정해진 대상우선 INSERT
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, BASIS_YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN  (SELECT BC.DIVISION_ID
                , BC.SCM_SITE_ID
                , BC.INCOTERMS
                , BC.BUCKET_PER
                , BC.YYYYMMDD
                , COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
           FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
           WHERE  1 = 1
           AND    BC.DIVISION_ID = v_division) BC
      ON  (BC.DIVISION_ID = A.DIVISION_ID
     AND   BC.SCM_SITE_ID = A.SCM_SITE_ID
     AND   BC.INCOTERMS   = A.INCOTERMS
     AND   BC.YYYYMMDD    = CM.DAYOFWEEK
     AND   BC.BUCKET_PER  = 'Y')
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'

    UNION ALL

    --DEFAULT BUCKET INSERT (SCM_SITE_ID/INCOTERMS별 BUCKET 이 없는 대상 기준)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN  (SELECT L.SEGMENT3 AS DAYOFWEEK
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
           WHERE  1 = 1
           AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
           AND    L.VALID_YN    = 'Y'
           AND    L.SEGMENT1    = v_division
           AND    L.SEGMENT2    = 'MONTHLY') BC
      ON  (BC.DAYOFWEEK = CM.DAYOFWEEK)
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION X
                       WHERE  1 = 1
                       AND    X.DIVISION_ID = A.DIVISION_ID
                       AND    X.SCM_SITE_ID = A.SCM_SITE_ID
                       AND    X.INCOTERMS   = A.INCOTERMS
                       AND    X.BUCKET_PER  = 'Y');

    ----------------------------------------------------------------------------------------------------
    --[MKT_FCST]
    --WEEK 별 수량 나누기
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, YYYYMM, ISO_YYYYWW, WEEK_DAY_CNT, MONTHLY_QTY, WEEKLY_QTY)
    WITH W_WEEKLY AS (
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.ISO_YYYYWW
             , CM.WEEK_DAY_CNT
             , A.QTY AS MONTHLY_QTY
             , FLOOR(A.QTY / CM.EOM * CM.WEEK_DAY_CNT) AS TEMP_WEEKLY_QTY
             , SUM(FLOOR(A.QTY / CM.EOM * CM.WEEK_DAY_CNT))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.YYYYMM, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_WEEK_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.ISO_YYYYWW
                    , COUNT(1) AS WEEK_DAY_CNT
                    /* CONVERT(INT, FORMAT(EOMONTH(MAX(A.BASIS_DATE)),'dd')) → 명시 마스크 (C-11) */
                    , TO_NUMBER(TO_CHAR(LAST_DAY(MAX(A.BASIS_DATE)), 'DD')) AS EOM
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
               GROUP BY A.BASIS_YYYYMM
                      , A.ISO_YYYYWW
              ) CM
          ON  (A.YYYYMM = CM.BASIS_YYYYMM)
        JOIN  (SELECT DISTINCT PB.KEY_VALUE
                    , PB.BASIS_YYYYMM
                    , PB.ISO_YYYYWW
               FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET PB) PB --버켓 요일이 있는 주차만 대상으로 함.
          ON  (A.KEY_VALUE  = PB.KEY_VALUE
         AND   A.YYYYMM     = PB.BASIS_YYYYMM
         AND   CM.ISO_YYYYWW = PB.ISO_YYYYWW)
        WHERE  1 = 1
        AND    A.MEASURE = 'MKT_FCST'
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , A.YYYYMM
         , A.ISO_YYYYWW
         , A.WEEK_DAY_CNT
         , A.MONTHLY_QTY
         , CASE WHEN A.LAST_WEEK_YN = 'Y' THEN A.MONTHLY_QTY - A.CUM_SUM
                ELSE A.TEMP_WEEKLY_QTY END AS WEEKLY_QTY
    FROM   W_WEEKLY A
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'
    ORDER BY A.KEY_VALUE, A.YYYYMM;

    ----------------------------------------------------------------------------------------------------
    --[MKT_FCST]
    --DAILY 별 수량 나누기
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
    , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY)
    WITH W_DAILY AS (
        --SCM_SITE_ID별 BUCKET
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.BASIS_YYYYMMDD
             , CM.ISO_YYYYWW
             , BC.BUCKET_CNT
             , A.MONTHLY_QTY
             , A.WEEKLY_QTY
             , FLOOR(A.WEEKLY_QTY / BC.BUCKET_CNT) AS TEMP_DAILY_QTY
             , SUM(FLOOR(A.WEEKLY_QTY / BC.BUCKET_CNT))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.ISO_YYYYWW, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
              ) CM
          ON  (A.YYYYMM     = CM.BASIS_YYYYMM
         AND   A.ISO_YYYYWW = CM.ISO_YYYYWW)
        JOIN  (SELECT BC.DIVISION_ID
                    , BC.SCM_SITE_ID
                    , BC.INCOTERMS
                    , BC.BUCKET_PER
                    , BC.YYYYMMDD
                    , COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
               FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
               WHERE  1 = 1
               AND    BC.DIVISION_ID = v_division) BC   /* [E20260819-XLS81LOC] 구 '40' 하드코딩 → v_division (형제 스테이지 동형 — 81 BUCKET_CONVERSION 491행 실존: '40' 유지 시 81 커스텀 버킷 행이 BC/DEFAULT 양 분기 모두 탈락) */
          ON  (BC.DIVISION_ID = A.DIVISION_ID
         AND   BC.SCM_SITE_ID = A.SCM_SITE_ID
         AND   BC.INCOTERMS   = A.INCOTERMS
         AND   BC.YYYYMMDD    = CM.DAYOFWEEK
         AND   BC.BUCKET_PER  = 'Y')

        UNION ALL

        --DEFAULT BUCKET
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.BASIS_YYYYMMDD
             , CM.ISO_YYYYWW
             , 1 AS BUCKET_CNT
             , A.MONTHLY_QTY
             , A.WEEKLY_QTY
             , FLOOR(A.WEEKLY_QTY) AS TEMP_DAILY_QTY
             , SUM(FLOOR(A.WEEKLY_QTY))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.ISO_YYYYWW, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
              ) CM
          ON  (A.YYYYMM     = CM.BASIS_YYYYMM
         AND   A.ISO_YYYYWW = CM.ISO_YYYYWW)
        JOIN  (SELECT L.SEGMENT3 AS DAYOFWEEK
               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
               WHERE  1 = 1
               AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
               AND    L.VALID_YN    = 'Y'
               AND    L.SEGMENT1    = v_division
               AND    L.SEGMENT2    = 'MONTHLY') BC
          ON  (BC.DAYOFWEEK = CM.DAYOFWEEK)
        WHERE  1 = 1
        AND    A.MEASURE = 'MKT_FCST'
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION X
                           WHERE  1 = 1
                           AND    X.DIVISION_ID = A.DIVISION_ID
                           AND    X.SCM_SITE_ID = A.SCM_SITE_ID
                           AND    X.INCOTERMS   = A.INCOTERMS
                           AND    X.BUCKET_PER  = 'Y')
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , A.YYYYMM
         , A.BASIS_YYYYMMDD
         , A.ISO_YYYYWW
         , A.BUCKET_CNT
         , A.MONTHLY_QTY
         , A.WEEKLY_QTY
         , A.LAST_DAY_YN
         , CASE WHEN A.LAST_DAY_YN = 'Y' THEN A.WEEKLY_QTY - NVL(A.CUM_SUM, 0)
                ELSE A.TEMP_DAILY_QTY END AS DAILY_QTY
    FROM   W_DAILY A
    WHERE  1 = 1
    ORDER BY A.KEY_VALUE, A.YYYYMM;

    ----------------------------------------------------------------------------------------------------
    --[LOC]
    --DAILY 별 PRICE생성
    ----------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
    ( DIVISION_ID
    , END_CUSTOMER
    , SCM_SITE_ID
    , ITEM_ID
    , INCOTERMS
    , FCST_TYPE
    , DOM_EXP
    , CELL_PROD_SITE
    , CURRENCY
    , MEASURE
    , KEY_VALUE
    , YYYYMM
    , BASIS_YYYYMMDD
    , ISO_YYYYWW
    , BUCKET_CNT
    , MONTHLY_QTY
    , WEEKLY_QTY
    , LAST_DAY_YN
    , DAILY_QTY
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM AS YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
         , NULL AS BUCKET_CNT
         , NULL AS MONTHLY_QTY
         , NULL AS WEEKLY_QTY
         , NULL AS LAST_DAY_YN     /* AS-IS: '' AS LAST_DAY_YN → Oracle '' = NULL (C-7) */
         , CAST(A.QTY AS NUMBER(23,2)) AS DAILY_QTY
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
           AND    (A.DAYOFWEEK = v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    WHERE  1 = 1
    AND    A.MEASURE = 'LOC';

    ----------------------------------------------------------------------------------------------------
    --최종 일자별 수량 Select (RECORD 형식)---------------------------
    ----------------------------------------------------------------------------------------------------
    OPEN O_RC1 FOR
        --MKT_FCST
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.BASIS_YYYYMMDD
             , CAST(A.DAILY_QTY AS NUMBER(23,2)) AS DAILY_QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY A
        UNION ALL
        --LOC
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , CM.BASIS_YYYYMMDD
             , CAST(A.QTY AS NUMBER(23,2)) AS DAILY_QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
               AND    (A.DAYOFWEEK = v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')
              ) CM
          ON  (A.YYYYMM = CM.BASIS_YYYYMM)
        WHERE  1 = 1
        AND    A.MEASURE = 'LOC'
        ORDER BY KEY_VALUE, BASIS_YYYYMMDD;
    --최종 일자별 Select (RECORD 형식) END ---------------------------

    ----------------------------------------------------------------------------------------------------
    --최종 일자별 Select (PIVOT 형식) START ---------------------------
    -- 동적 PIVOT IN 리스트 구성 (커서 LOOP — FETCH 직후 EXIT WHEN %NOTFOUND, C-10)
    ----------------------------------------------------------------------------------------------------
    DBMS_LOB.CREATETEMPORARY(V_CONCAT_PIVOT, TRUE);

    OPEN C_PIVOT;
    LOOP
        FETCH C_PIVOT INTO V_PIVOT_PIECE;
        EXIT WHEN C_PIVOT%NOTFOUND;
        IF DBMS_LOB.GETLENGTH(V_CONCAT_PIVOT) = 0 THEN
            V_CONCAT_PIVOT := '''' || V_PIVOT_PIECE || ''' AS ' || V_PIVOT_PIECE;
        ELSE
            V_CONCAT_PIVOT := V_CONCAT_PIVOT || ',''' || V_PIVOT_PIECE || ''' AS ' || V_PIVOT_PIECE;
        END IF;
    END LOOP;
    CLOSE C_PIVOT;

    /* [DEFECT_GUARD] 캘린더 미적재 등으로 PIVOT IN 리스트가 비면 ORA-00936 — 빈 커서 반환 */
    IF DBMS_LOB.GETLENGTH(V_CONCAT_PIVOT) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS RESULT_CODE, 'NO_CALENDAR_DATA' AS RESULT_MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

    /* Oracle PIVOT: 서브쿼리와 PIVOT 사이 alias 불가 / PIVOT 집계 안 alias 참조 불가 → 최종 alias A 로 이동 */
    V_SQL := '
    SELECT A.*
      FROM (
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , B.END_CUSTOMER_NAME
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , B.FCST_TYPE_NAME
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , B.CELL_PROD_SITE_NAME
         , A.CURRENCY
         , A.MEASURE
         , B.MEASURE_NAME
         , ''D'' || A.BASIS_YYYYMMDD AS BASIS_YYYYMMDD
         , A.DAILY_QTY
      FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY A
      JOIN SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT B
        ON (A.KEY_VALUE = B.KEY_VALUE))
      PIVOT (MAX(DAILY_QTY) FOR BASIS_YYYYMMDD IN (' || V_CONCAT_PIVOT || '
    )) A';

    OPEN O_RC2 FOR V_SQL;

    /* AS-IS: WHILE LEN(@V_SQL) > 0 ... PRINT LEFT(@V_SQL, 4000) — 4,000자씩 출력 (디버그 출력 1:1 유지) */
    V_PRINT_POS := 1;
    V_PRINT_LEN := NVL(DBMS_LOB.GETLENGTH(V_SQL), 0);
    WHILE V_PRINT_POS <= V_PRINT_LEN
    LOOP
        DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 4000, V_PRINT_POS));
        V_PRINT_POS := V_PRINT_POS + 4000;
    END LOOP;

    BEGIN DBMS_LOB.FREETEMPORARY(V_SQL);          EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
    --최종 일자별 Select (PIVOT 형식) END ---------------------------

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL);          EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', 0
              , '########## FAIL END of procedure ##########', ''
              , SYSDATE, p_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_EXCEL_UPLOAD_DATA;


PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT 
/* [DIV81] 2026-07-14 admin: Division 81(LIKE '81%') 시 GTT 스테이징 INSERT 만 81 테이블(DM_PLN_MKT_FCST(_C)/SCM_MST_FUTURE_PRICE(_C))로 분기. END_CUSTOMER/CELL_PROD_SITE_ID 는 '-' 리터럴 (컬럼 부재 — ALL_TAB_COLUMNS 실측). 하류(pivot/커서) 공통. 40 원문 무수정. */
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
  , O_RC1            OUT SYS_REFCURSOR   /* 1) 동적 PIVOT 메인 데이터 */
  , O_RC2            OUT SYS_REFCURSOR   /* 2) M+3 월 MONTH_NAME/ISO_WEEK (Monthly 입력제한 기준) */
  , O_RC3            OUT SYS_REFCURSOR   /* 3) 현재/전주 주차 정보 */
  , O_RC4            OUT SYS_REFCURSOR   /* 4) 메저별 EDIT_FLAG (GET_ADMIN_GROUP_MEASURE) */
  , O_RC5            OUT SYS_REFCURSOR   /* 5) 조회구간 캘린더 분배 정보 (M+4 월간 물량 배분용) */
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR   /* 표준 결과 커서 (RESULT_CODE/RESULT_MSG/EVENT) */
)
/*=====================================================================================================================================================
 * Program ID  : DMF0082_GET_MAIN_DATA_CURRENT
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date             In Charge    Description
 *=====================================================================================================================================================
 * 2026.01.09       park.choyi   Initial Release (MSSQL)
 * 2026-07-12       Claude       MSSQL dbo.DMF0082_GET_MAIN_DATA_CURRENT → Oracle 19c 1:1 변환 (파일 산출물 — DB 미적용)
 *
 * EXEC DMF0082_GET_MAIN_DATA_CURRENT '40','ALL','ALL','ALL','20260101','20260731','ALL','','Current','Y','park.choyi','ADMIN'
 *=====================================================================================================================================================
 * [변환 노트 — 부록 C 함정 처리 / GTT 재사용]
 *  - #temp 13종 → 기존 GTT_* family 13종 전량 재사용 (컬럼 1:1 실측 일치 — 00_gtt_ddl.sql 헤더 참조. 신규 GTT 불필요):
 *      #TEMP_DM_MST_ITEM_SINGLE_V → GTT_TEMP_DM_MST_ITEM_SINGLE_V / #TempSiteItemAll → GTT_TEMPSITEITEMALL / #TempSiteItem → GTT_TEMPSITEITEM
 *      #TempSelectMeasure → GTT_TEMPSELECTMEASURE / #T_LAST_DATA_SETUP_FCST → GTT_T_LAST_DATA_SETUP_FCST / #T_LAST_DATA_SETUP_PRICE → GTT_T_LAST_DATA_SETUP_PRICE
 *      #T_WS_FCST → GTT_T_WS_FCST / #TempFcstNPrice → GTT_TEMPFCSTNPRICE / #TEMP_INTO_GROUP_MEASURE → GTT_TEMP_INTO_GROUP_MEASURE
 *      #TEMP_ADMIN_GROUP_MEASURE → GTT_TEMP_ADMIN_GROUP_MEASURE / #CAL_MONTH_END_DATE → GTT_CAL_MONTH_END_DATE / #CAL_WEEK_END_DATE → GTT_CAL_WEEK_END_DATE
 *      #MF_SP → GTT_MF_SP
 *  - GTT 초기화 = DELETE FROM (C-2: TRUNCATE 금지 — mutex hang / C-5: INSERT 전 DELETE 의무)
 *  - @@FETCH_STATUS WHILE 루프 2개(C_BUCKET/C_TITLE) → LOOP + FETCH 직후 EXIT WHEN %NOTFOUND (C-10 — 무한루프 방지)
 *  - 동적 SQL/PIVOT 리스트 누적 = CLOB (hook #106) + [@...] placeholder REPLACE 방식은 AS-IS 그대로 유지.
 *    단, AS-IS 는 '[@v_PV_COL_LIST]' 를 @v_PV_LIST 로 치환(MSSQL 에선 두 형태 동일 문자열이라 무해) —
 *    Oracle 은 PIVOT IN 리스트('D_x' AS D_x)와 SELECT 컬럼 리스트(D_x)가 다르므로 각각 올바르게 치환 (원문 버그 교정, 결과 동일)
 *  - MSSQL PIVOT ([D_x],...) → Oracle PIVOT ('D_x' AS D_x, ...) / 서브쿼리·PIVOT 사이 alias 불가 → alias 는 PIVOT 뒤로 이동
 *  - OPTION (ORDER GROUP) MSSQL 힌트 제거
 *  - SUBSTRING(F.OWNER, 0, CHARINDEX...) 첫 토큰 추출 → CASE WHEN INSTR=0 THEN OWNER ELSE SUBSTR(OWNER,1,INSTR-1) END (C-1 SUBSTR-0 함정 회피)
 *  - STUFF(...FOR XML PATH(''))(OWNER 이름 결합) → LISTAGG / STRING_SPLIT → REGEXP_SUBSTR CONNECT BY (룰 4/5)
 *  - CASE WHEN @P = 'ALL' THEN @P ELSE col END IN (SPLIT(@P)) → (@P = 'ALL' OR col IN (SPLIT(@P))) 동치 변환
 *  - ISNULL(x,'')='' / <>'' → IS NULL / IS NOT NULL, ISNULL(x,'') 표시값 → x (Oracle '' = NULL, C-7)
 *  - '' AS CURRENCY / '' AS LAST_DAY_YN 류 → NULL (C-7)
 *  - ISNULL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID → T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID (''=NULL 은 어떤 값과도 불일치 — 결과 동일)
 *  - LIKE '%CURRENT%' (MSSQL 대소문자 무시 collation) → UPPER(p_version_type) LIKE '%CURRENT%'
 *  - DATEPART(WEEKDAY,GETDATE()) 1~7 → 요일 3문자 매핑 → TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH') (C-11: 세션 NLS 비의존)
 *  - CONVERT(CHAR(8),GETDATE(),24)/112, FORMAT(...,'yyyyMM'), DATEADD → TO_CHAR/ADD_MONTHS 명시 마스크 (C-11)
 *  - DATEADD(YY,-1,@p_from_yyyymmdd)(문자열 암묵 DATE 변환) → ADD_MONTHS(TO_DATE(p_from_yyyymmdd,'YYYYMMDD'),-12) 명시 (C-11)
 *  - DATEADD(WEEK,50,@p_from_yyyymmdd) → TO_DATE(p_from_yyyymmdd,'YYYYMMDD') + 50*7 명시 (C-11)
 *  - OUTER APPLY (SELECT TOP(1) ... ORDER BY) → LEFT JOIN LATERAL (... ORDER BY ... FETCH FIRST 1 ROWS ONLY) ON 1=1
 *  - UPDATE ... FROM JOIN (CURRENCY 일괄 UPDATE / ADMIN_GROUP EDIT_FLAG UPDATE) → MERGE(GROUP BY+MAX 로 ORA-30926 방지) / EXISTS (룰 #30)
 *  - MSSQL UPDATE JOIN 다중매치 임의채택 → MAX() 결정적 채택 (주석 명시)
 *  - AS-IS C_TITLE 2번째 UNION 의 C.DEFAULT_FLAG = '' → C.DEFAULT_FLAG IS NULL (C-7. 사내 실측: DEFAULT_FLAG NULL 11건 존재)
 *  - #FCST 일부 서브쿼리의 DIVISION_ID = '40' 하드코딩 (LOOKA/BC) 은 AS-IS 원문 그대로 보존 (임의 수정 금지)
 *  - #TempSiteItemAll 의 K(SSO_DEPT_INFO) 조인 ELSE 분기 S.DEPT_ID: 사내 SCM_MST_SITE.DEPT_ID 컬럼 삭제(Case 39)로
 *    기존 변환 표준(DMF0082_GET_MAIN_DATA)과 동일하게 F.DEPT_ID 사용. (K 는 SELECT 미참조 — 결과 영향 0)
 *  - MSSQL WHILE 커서 결과 PRINT 류 → DBMS_OUTPUT.PUT_LINE (A00x 진행 로그는 원문 유지 목적상 주석으로 보존)
 *  - EXEC PR_DM_SYS_LOG_BATCH 7-인자 → SCM_MGR.PR_DM_SYS_LOG_BATCH(...) 동일 7-인자 (8~11번째 default)
 *  - 표준 O_RESULT_CURSOR + WHEN OTHERS 핸들러 = DMF0082_SAVE_MAIN_DATA / DMF0082_GET_MAIN_DATA Oracle 표준 준수
 *===================================================================================================================================================*/
IS
    --=============================================================================================================================
    -- LOG 용 변수 설정 -- [E20250915-000105]_로그를 찍기위해서 LOG용 변수 추가
    --=============================================================================================================================
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    --=============================================================================================================================
    -- 사용자 컬럼 및 메저 세팅 관련 변수
    --=============================================================================================================================
    V_USER_COL_CNT      NUMBER := 0;
    V_USER_MEA_CNT      NUMBER := 0;
    VA_PROGRAM_ID       VARCHAR2(50 CHAR) := 'DMF0082';
    VA_SHEET_NAME       VARCHAR2(50 CHAR) := 'FcstNPrice';

    --=============================================================================================================================
    -- BUCKET 관련 변수 (hook #106 — PIVOT 리스트 누적 = CLOB)
    --=============================================================================================================================
    V_EXP_YYYYMMDD      VARCHAR2(8 CHAR);
    V_PV_LIST           CLOB;               /* PIVOT IN 절: 'D_20260101' AS D_20260101, ... */
    V_PV_COL_LIST       CLOB;               /* 외부 SELECT 컬럼 리스트: D_20260101, ...      */
    V_PV_COLUMN_NAME    VARCHAR2(200 CHAR);
    V_PV_NAME           VARCHAR2(200 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(50 CHAR);

    /* 조회 할 때 쓸 날짜 관련 변수 */
    V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_FROM_RESULT       VARCHAR2(8 CHAR);
    V_TO_RESULT         VARCHAR2(8 CHAR);
    V_USER_TIME_ZONE    VARCHAR2(50 CHAR);

    /* C_TITLE 커서에서만 사용 될 지역변수 */
    V_CUR_COLUMN_NAME   VARCHAR2(200 CHAR);
    V_CUR_PROGRAM_ID    VARCHAR2(50 CHAR);
    V_CUR_SHEET_NAME    VARCHAR2(100 CHAR);
    V_CUR_SORT_ORDER_NO VARCHAR2(50 CHAR);

    /* C_TITLE 커서에서 완성 된 후 동적쿼리에서 쓰여질 변수 */
    V_COLUMN            VARCHAR2(4000 CHAR);
    V_GROUPBY           VARCHAR2(4000 CHAR);
    V_ORDERBY           VARCHAR2(4000 CHAR);

    /* @v_group_id 권한 그룹 */
    V_GROUP_ID          VARCHAR2(50 CHAR) := '';
    V_ADMIN_CNT         NUMBER := 0;
    V_MEASURE_CNT       NUMBER := 0;
    V_LIMIT_CNT         NUMBER := 0;

    /* 최종적으로 실행하는 동적쿼리 */
    V_SQL_TEXT          CLOB;

    /* 표준 예외 변수 */
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);

    --=============================================================================================================================
    -- C_BUCKET : 선택한 bucket(D/W/M)의 동적 PIVOT 컬럼을 만드는 커서
    --  (MSSQL: '[D_x] AS D_x' / '[D_x]' → Oracle: 컬럼명 'D_x' / PIVOT IN piece '''D_x'' AS D_x')
    --  [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가 (Oracle 커서는 기본 local)
    --=============================================================================================================================
    CURSOR C_BUCKET IS
        SELECT 'D_' || A.BASIS_YYYYMMDD                                            AS COLUMN_NAME
             , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD        AS PV_NAME
             , A.BASIS_YYYYMMDD || '_31'                                           AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                                AS COLUMN_NAME
             , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS PV_NAME
             , A.BASIS_START_DATE || '_21'                                         AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM                                              AS COLUMN_NAME
             , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM            AS PV_NAME
             , MIN(A.BASIS_START_DATE) || '_01'                                    AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY SORT_ORDER_NO;

    --=============================================================================================================================
    -- C_TITLE : 선택한 bucket의 값인 MONTH 혹은 WEEK를 이용해서 동적인 컬럼을 만드는 커서
    --=============================================================================================================================
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
        -- [UICATEGORY 2026-08-07] GTT_MF_SP 산출 whitelist — titleset 'C' 오염(미산출 컬럼) 유입 시 동적 SQL ORA-00904 차단
        --   (DMF0003 TITLESET IMMUNIZE 파리티. 목록 = GTT_MF_SP 전 컬럼 — GTT ALTER 시 동기 의무)
        AND    U.COLUMN_NAME IN (
                 'DIVISION_ID','SCM_SITE_ID','PLANT_SITE_ID','PROJECT_CODE','ITEM_ID','INCOTERMS','FCST_TYPE','DOM_EXP'
                ,'MEASURE','END_CUSTOMER','NICK_NAME','DMS_SALES','DMS_CUSTOMER','YYYYMM','YYYYMMWW','YYYYMMDD','DAYOFWEEK'
                ,'FORECAST_INFO_CELL_MODEL','TEAM_ID','TEAM_NAME_KO','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','OWNER'
                ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','ITEM_NAME','VMI_YN','CELL_PROD_SITE_ID'
                ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_CELL_PACK_COUNT'
                ,'FORECAST_INFO_ALL','FORECAST_INFO_SPEC','FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME'
                ,'QTY','MONTH_END_YN','WEEK_END_YN','EDIT_FLAG','SORT_ORDER_NO','MEASURE_GROUP','NEW_FLAG','BUCKET','SORT_KEY'
                ,'LAST_UPDATE_DATE','LAST_UPDATED_BY','NOTATION','CURRENCY','VERSION_NO','CUTOFF_YYYYMMDD'
                ,'AS_YN','ATTR1','VMI_STD_DIO','BIZ_TYPE','PROJECT_STATUS','ENERGE','CELL_QUANTITY'
                ,'CELL_PER_CAR','CELL_PER_MODULE','MODULE_PER_CAR','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT','AS_FROM_SITE' )
        UNION ALL
        /* 2024/05/17   kcw3408     이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , TO_CHAR(CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO, 85) - 0.5
                            ELSE C.SORT_ORDER_NO END) AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
            ON  U.PROGRAM_ID  = C.PROGRAM_ID
            AND U.SHEET_NAME  = C.SHEET_NAME
            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND U.COLUMN_NAME IN ('ITEM_ID')
            AND U.USER_ID     = p_created_by
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = ' '  /* [UICATEGORY 2026-08-07 FIX] 구 "IS NULL" = 사문(DEFAULT_FLAG NOT NULL, 실값 ' ') → 고정컬럼(SORT_KEY 등) V_COLUMN 미포함
                                        → ORDER BY SORT_KEY 가 상시 ORA-00904 (Current 조회 전면 파손 — 2026-08-07 실측). GET 의 L162 [FIX 2026-07-12] 와 규약 통일 */
        AND    C.VALID_YN     = 'Y'
        -- [UICATEGORY 2026-08-07] branch1(사용자 titleset 'C') 중복 컬럼 제외 — GET 동형 (V_COLUMN 중복 = ORA-00918 방어)
        AND    NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER U2
                   WHERE  U2.PROGRAM_ID  = C.PROGRAM_ID
                   AND    U2.SHEET_NAME  = C.SHEET_NAME
                   AND    U2.COLUMN_NAME = C.COLUMN_NAME
                   AND    U2.USER_ID     = p_created_by
                   AND    U2.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               )
        ) ORDER BY TO_NUMBER(SORT_ORDER_NO); --[SORTFIX 2026-08-04] UI Category Setup 순번 수치정렬 (TO_CHAR 문자정렬 결함 교정 — DMF0003 TO_NUMBER 원형 파리티)

BEGIN

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
    /* [E20260819-MULTIJOIN] 인라인 REGEXP 분해 전환분 선적재 — p_scm_site_id/p_team_id/p_customer/p_biz_type/p_item_id (2026-08-19 사용자 확장 지시) */
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_team_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_team_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_customer, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_biz_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biz_type, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_item_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_item_id, ','));

    --[2026-07-31 클라우드 대응] GTT 동적샘플링 강제 — 클라우드 세션 기본값 0(GTT 무통계 파국계획, 사내 12초/클라우드 16분+ 실증) 방지.
    --  Oracle 기본값 2 복원. 트랜잭션 무관 세션 파라미터(ENABLE PARALLEL DML 계열 아님 — ORA-12841 리스크 없음).
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
    --PRINT @v_program_name + ' : A001--' ... 'DMF0082_GET_MAIN_DATA_CURRENT 조회쿼리 시작'
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

    --=============================================================================================================================
    -- 시작 LOG (START)  -- [E20250915-000105]_로그를 찍기위해서 LOG 추가
    --=============================================================================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, p_created_by);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    /* [DEFECT_GUARD] p_from_yyyymmdd / p_to_yyyymmdd 형식 검증 (ORA-01841 방어 — 기존 DMF0082_GET_MAIN_DATA 표준) */
    IF p_from_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_from_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_from_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_from_yyyymmdd: ' || NVL(p_from_yyyymmdd, '<NULL>'));
    END IF;
    IF p_to_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_to_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_to_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_to_yyyymmdd: ' || NVL(p_to_yyyymmdd, '<NULL>'));
    END IF;

    -------------------------------------------------------------------------------------------------------------------------------
    -- 사용자 컬럼 처리 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'C', C.COLUMN_NAME
             , C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;
    -------------------------------------------------------------------------------------------------------------------------------
    -- 사용자 컬럼 처리 (END) / 사용자 메저 처리 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
             , C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;
    -------------------------------------------------------------------------------------------------------------------------------
    -- 사용자 메저 처리 (END)
    -------------------------------------------------------------------------------------------------------------------------------

    --=============================================================================================================================
    -- BUCKET 관련 세팅 시작 (START)  — @V_PV_COL_LIST , @V_PV_LIST 만들기
    --=============================================================================================================================
    /* SET @V_EXP_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(WEEK, 50, @p_from_yyyymmdd), 112);  (C-11 명시 마스크) */
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

    DBMS_LOB.CREATETEMPORARY(V_PV_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_PV_COL_LIST, TRUE);

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;          /* C-10: FETCH 직후 종료 판정 의무 */
        IF DBMS_LOB.GETLENGTH(V_PV_COL_LIST) = 0 THEN
            V_PV_COL_LIST := V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_NAME;
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || V_PV_NAME;
        END IF;
    END LOOP;
    CLOSE C_BUCKET;
    --=============================================================================================================================
    -- BUCKET 관련 세팅 종료 (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- Version 관련 세팅 시작 (START)
    --=============================================================================================================================
    /* (AS-IS 원문 공란) */
    --=============================================================================================================================
    -- Version 관련 세팅 시작 (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- GTT 초기화 (AS-IS: IF OBJECT_ID ... DROP TABLE / CREATE TABLE — Oracle: DELETE FROM, C-2/C-5)
    --=============================================================================================================================
    DELETE FROM SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GTT_TEMPSITEITEMALL;
    DELETE FROM SCM_MGR.GTT_TEMPSITEITEM;
    DELETE FROM SCM_MGR.GTT_TEMPSELECTMEASURE;
    DELETE FROM SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST;
    DELETE FROM SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE;
    DELETE FROM SCM_MGR.GTT_T_WS_FCST;
    DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE;
    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;
    DELETE FROM SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE;
    DELETE FROM SCM_MGR.GTT_CAL_MONTH_END_DATE;
    DELETE FROM SCM_MGR.GTT_CAL_WEEK_END_DATE;
    DELETE FROM SCM_MGR.GTT_MF_SP;

    --=============================================================================================================================
    -- #TempSiteItem 만들기 시작 (START)
    --  1. #TEMP_DM_MST_ITEM_SINGLE_V 만들기 위해서 ORI_V , A_V , B_V 3개 만들기 그 후 최종적으로 완성
    --     → 2026.01.13 #TEMP_DM_MST_ITEM_SINGLE_V 는 DM_MST_ITEM_SINGLE_V 으로 대체 (AS-IS 원문의 ORI/A/B 블록은 주석 처리됨)
    --  2. #TempSiteItemAll에서 위에서 만든 #TEMP_DM_MST_ITEM_SINGLE_V 사용해서 만들기
    --  3. #TempSiteItemAll를 만든뒤 최종적으로 #TempSiteItem 만들기
    --=============================================================================================================================
    INSERT INTO SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
    , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE
    , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
         , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
         , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE
         , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V
    WHERE  DIVISION_ID = '40'
    AND    ACTIVE_FLAG = 'Y';

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMP_DM_MST_ITEM_SINGLE_V', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItem(All) 만들기 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    /* [E20260819-MULTIJOIN] 예외 존치(revert 2026-08-19) — 본 CURRENT GTT_TEMPSITEITEMALL 스테이징은
       GTT 전환(인라인 술어 제거+후행 DELETE) 적용 시 INSERT 계획 회귀로 단일문 38분+ 무종료
       (사내 실측: V$SESSION LAST_CALL_ET 2270s+, SQL_ID 0dh4m2dhduyqg — LISTAGG 상관 스칼라 ×
       1행 파생테이블 카디널리티 앵커 상실 추정, 원인 확정은 계획 실측 필요). hook #129 ⓿병목 실측 +
       지시 '전환이 성능을 악화시키면 되돌리고 보고' 적용 — 인라인 원형 존치. MAIN 동형 지점은 전환 유지(파리티 PASS). */
    INSERT INTO SCM_MGR.GTT_TEMPSITEITEMALL
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
    , CELL_MODEL, END_CUSTOMER, SOLDTO_CUSTOMER
    , COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
    , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME
    , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, VMI_YN, DMS_SALES, DMS_CUSTOMER, DEPT_ID, DEPT_NAME_KO
    , ITEM_VALID_YN )
    SELECT F.DIVISION_ID
         , F.PROJECT_CODE
         , F.SCM_SITE_ID
         , F.ITEM_ID
         , T2.NICK_NAME
         , NVL(MP.PROJECT_NAME, F.PROJECT_CODE) AS PROJECT_NAME  --[E20260819-PJTNAME]
         , F.ATTRIBUTE5                                     AS CELL_MODEL
         , S.END_CUSTOMER
         , S.SOLDTO_CUSTOMER
         , I.COUNTRY
         , I.COUNTRY_NAME
         , H.CITY
         , H.CITY_NAME
         /* STUFF( ... FOR XML PATH('') ) OWNER 다중 사용자 이름 결합 → LISTAGG (AS-IS 로직 동일) */
         , (SELECT LISTAGG(XA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY XA.USER_NAME_EN)
            FROM  (SELECT DISTINCT ZA.USER_NAME_EN
                   FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                   WHERE  ZA.USER_ID IN (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)
                                         FROM   DUAL
                                         CONNECT BY LEVEL <= NVL(REGEXP_COUNT(F.OWNER, ','), 0) + 1)) XA
           )                                                AS OWNER
         , J.USER_NAME_EN                                   AS PROJECT_OWNER
         , J.USER_ID
         , T2.ITEM_NAME
         , T2.ITEM_TYPE
         , F.CUST_GROUP
         , F.CUST_GROUP_DTL
         , F.APPLICATION
         , F.ROUTE
         , T2.MDM_PROJECT_NAME
         , T2.MIN_CAPACITY
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE END          AS FORECAST_INFO_BIZ_TYPE
         , T2.FORECAST_INFO_PRODUCT_GROUP
         , LOOK.NAME                                        AS CELL_TYPE
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END   AS FORECAST_INFO_CELL_PACK_COUNT
         , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
         , T2.FORECAST_INFO_SPEC                            AS FORECAST_INFO_SPEC
         , T2.FORECAST_INFOR_VERSION                        AS FORECAST_INFOR_VERSION
         , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME   /* ISNULL(T4.NICK_NAME,'') → '' = NULL (C-7) */
         , S.VMI_YN
         , F.ATTRIBUTE1                                     AS DMS_SALES              /* ISNULL(F.ATTRIBUTE1,'') → '' = NULL (C-7) */
         , F.ATTRIBUTE2                                     AS DMS_CUSTOMER           /* ISNULL(F.ATTRIBUTE2,'') → '' = NULL (C-7) */
         , TEAM.DEPT_ID
         , TEAM.DEPT_NAME_KO
         , F.VALID_YN                                       AS ITEM_VALID_YN
    FROM   SCM_MGR.SCM_MST_SITE_ITEM F
    INNER JOIN SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V T2
        ON  F.DIVISION_ID = T2.DIVISION_ID
        AND F.ITEM_ID     = T2.ITEM_ID
    INNER JOIN (SELECT DISTINCT '%' || TOKEN || '%' AS TST
                FROM  (SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
                       FROM   DUAL
                       CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_item_id, ','), 0) + 1)) B
        ON  (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
    INNER JOIN SCM_MGR.SCM_MST_SITE S
        ON  F.DIVISION_ID = S.DIVISION_ID
        AND F.SCM_SITE_ID = S.SCM_SITE_ID
        AND S.SITE_TYPE   = 'SALES'
    INNER JOIN SCM_MGR.SCM_MST_CITY H
        ON  S.CITY = H.CITY
    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY = I.COUNTRY
    --[E20260819-PJTNAME] Project 명 원천 — SCM_MST_PROJECT (미등재 코드=코드 폴백 LEFT)
    LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
        ON  F.DIVISION_ID  = MP.DIVISION_ID
        AND F.PROJECT_CODE = MP.PROJECT_CODE
    LEFT JOIN (SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
               FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
               INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                   ON B2.DEPT_ID = C.DEPT_ID) TEAM
        /* (룰 #5) TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM STRING_SPLIT(F.OWNER,',')) → 첫 토큰 비교 */
        ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0 THEN F.OWNER
                               ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1) END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
        /* (C-1) SUBSTRING(F.OWNER, 0, CHARINDEX...) 첫 토큰 → SUBSTR(s,1,INSTR-1) 보정 */
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0 THEN F.OWNER
                            ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1) END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
        /* AS-IS ELSE S.DEPT_ID — 사내 SCM_MST_SITE.DEPT_ID 삭제(Case 39) → F.DEPT_ID (K 는 SELECT 미참조) */
        ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID ELSE F.DEPT_ID END
    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE  LOOKUP_TYPE = 'CELL_TYPE') LOOK
        ON LOOK.CODE = T2.CELL_TYPE
    LEFT JOIN SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V T4
        /* ISNULL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID → 직접 비교 (C-7, 결과 동일) */
        ON  T2.DIVISION_ID = T4.DIVISION_ID
        AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
    LEFT JOIN (SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
               FROM  (SELECT SEGMENT2 AS MODEL
                           , SEGMENT3 AS BIZ_TYPE
                           , SEGMENT4 AS CELL_PACK_COUNT
                           , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                      WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
                      AND    SEGMENT1    = '40') A
               WHERE  A.MODEL_RANK = 1) LOOKA
        ON LOOKA.MODEL = F.ITEM_ID
    WHERE  F.DIVISION_ID = '40'                    /* AS-IS 원문 하드코딩('40') 그대로 보존 */
    /* CASE WHEN @P='ALL' THEN @P ELSE col END IN (SPLIT(@P)) → OR 동치 변환 */
    AND    (p_scm_site_id = 'ALL' OR F.SCM_SITE_ID IN (
                SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
    AND    (p_customer = 'ALL' OR F.PROJECT_CODE IN (
                SELECT REGEXP_SUBSTR(p_customer, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_customer, ','), 0) + 1))
    AND    (p_biz_type = 'ALL' OR
                CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                     ELSE T2.FORECAST_INFO_BIZ_TYPE END IN (
                SELECT REGEXP_SUBSTR(p_biz_type, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_biz_type, ','), 0) + 1));
    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItemAll 만들기 (END)
    -------------------------------------------------------------------------------------------------------------------------------
    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPSITEITEMALL', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItem 만들기 (START)
    -------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_TEMPSITEITEM
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
    , CELL_MODEL, END_CUSTOMER, SOLDTO_CUSTOMER
    , COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
    , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME
    , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, VMI_YN, DMS_SALES, DMS_CUSTOMER, DEPT_ID, DEPT_NAME_KO
    , ITEM_VALID_YN )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)                     AS CELL_MODEL
         , MAX(END_CUSTOMER)                   AS END_CUSTOMER
         , MAX(SOLDTO_CUSTOMER)                AS SOLDTO_CUSTOMER
         , MAX(COUNTRY)                        AS COUNTRY
         , MAX(COUNTRY_NAME)                   AS COUNTRY_NAME
         , MAX(CITY)                           AS CITY
         , MAX(CITY_NAME)                      AS CITY_NAME
         , MAX(OWNER)                          AS OWNER
         , MAX(PROJECT_OWNER)                  AS PROJECT_OWNER
         , MAX(USER_ID)                        AS USER_ID
         , MAX(ITEM_NAME)                      AS ITEM_NAME
         , MAX(ITEM_TYPE)                      AS ITEM_TYPE
         , MAX(CUST_GROUP)                     AS CUST_GROUP
         , MAX(CUST_GROUP_DTL)                 AS CUST_GROUP_DTL
         , MAX(APPLICATION)                    AS APPLICATION
         , MAX(ROUTE)                          AS ROUTE
         , MAX(MDM_PROJECT_NAME)               AS MDM_PROJECT_NAME
         , MAX(MIN_CAPACITY)                   AS MIN_CAPACITY
         , MAX(FORECAST_INFO_BIZ_TYPE)         AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)    AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(CELL_TYPE)                      AS CELL_TYPE
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)  AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_ALL)              AS FORECAST_INFO_ALL
         , MAX(FORECAST_INFO_SPEC)             AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)         AS FORECAST_INFOR_VERSION
         , MAX(CELL_MODEL_NICK_NAME)           AS CELL_MODEL_NICK_NAME
         , MAX(VMI_YN)                         AS VMI_YN
         , MAX(DMS_SALES)                      AS DMS_SALES
         , MAX(DMS_CUSTOMER)                   AS DMS_CUSTOMER
         , MAX(DEPT_ID)                        AS DEPT_ID
         , MAX(DEPT_NAME_KO)                   AS DEPT_NAME_KO
         , MAX(ITEM_VALID_YN)                  AS ITEM_VALID_YN
    FROM   SCM_MGR.GTT_TEMPSITEITEMALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
    -------------------------------------------------------------------------------------------------------------------------------
    -- #TempSiteItem 만들기 (END)  /  인덱스: GTT 기존 정의 재사용 (AS-IS CREATE INDEX 구간은 GTT DDL 에서 대체)
    -------------------------------------------------------------------------------------------------------------------------------
    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPSITEITEM', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)
    --=============================================================================================================================
    -- #TempSiteItem 만들기 시작 (END)
    --=============================================================================================================================

    /* 조회 할 때 쓸 날짜 변수 세팅 시작 */
    V_FROM_YYYYMMDD := '';  --MKT FCST PLAN FROM 주차 월요일
    V_TO_YYYYMMDD   := '';  --MKT FCST PLAN TO 주차 월요일
    V_FROM_RESULT   := '';  --MKT FCST RESULT FROM 주차 월요일
    V_TO_RESULT     := '';  --MKT FCST RESULT TO 주차 월요일
    V_USER_TIME_ZONE := '';

    BEGIN
        SELECT U.TIMEZONE
        INTO   V_USER_TIME_ZONE
        FROM   SCM_MGR.TB_FX_USER U
        WHERE  U.USERID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := NULL;
        WHEN TOO_MANY_ROWS THEN V_USER_TIME_ZONE := NULL;
    END;

    -- @V_FROM_YYYYMMDD : (USER 시차를 고려한) 당주 월요일
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD)
        INTO   V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
             , (SELECT DISTINCT ISO_YYYYWW
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  1 = 1
                /* CONVERT(CHAR(8), DBO.FN_MULTY_TIME(@V_USER_TIME_ZONE), 112) → 명시 마스크 (C-11) */
                AND    BASIS_YYYYMMDD = TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMMDD')
               ) T
        WHERE  1 = 1
        AND    C.ISO_YYYYWW = T.ISO_YYYYWW;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := NULL;
    END;

    -- FROM 실적 : FROM 조회 구간 월요일부터
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  1 = 1
        AND    C.BASIS_YYYYMMDD = p_from_yyyymmdd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := NULL;
    END;

    -- TO 실적 : TO 조회 구간 월요일 전까지
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  1 = 1
        AND    C.BASIS_YYYYMMDD = p_to_yyyymmdd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := NULL;
    END;

    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
        -- 실적 보여줌
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_TO_RESULT   := V_FROM_YYYYMMDD;   -- TO 실적 : 당주 월요일 전까지
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_FROM_RESULT := '19000101';        --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112);
        V_TO_RESULT   := '19000101';        --CONVERT(CHAR(8), DATEADD(MM, -6, CURRENT_TIMESTAMP), 112);
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
        -- 실적만 보여줌
        V_FROM_YYYYMMDD := '19000101';
        V_TO_YYYYMMDD   := '19000101';
        V_FROM_RESULT   := p_from_yyyymmdd; -- FROM 실적 : FROM 조회 구간부터
        V_TO_RESULT     := p_to_yyyymmdd;   -- TO 실적 : TO 조회 구간까지
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
        -- 실적 없음
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := p_from_yyyymmdd;
        V_TO_RESULT   := p_to_yyyymmdd;
    END IF;
    /* 조회 할 때 쓸 날짜 변수 세팅 종료 */

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TempSelectMeasure 만들기 시작
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
    SELECT DISTINCT U.PROGRAM_ID                        AS PROGRAM_ID
         , U.SHEET_NAME                                 AS SHEET_NAME
         , U.USER_ID                                    AS USER_ID
         , U.COLUMN_NAME                                AS MEASURE_GROUP
         , U.COLUMN_NAME                                AS MEASURE
         , NVL(SMSM.ATTRIBUTE5, U.COLUMN_NAME)          AS RESULT_MEASURE  -- 2025.03.13 RESULT_MEASURE 추가
         , TO_CHAR(U.SORT_ORDER_NO)                     AS SORT_ORDER_NO
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U              /* AS-IS INDEX(PK_SCM_MST_TITLESET_USER) 힌트 제거 */
    JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
        ON  U.PROGRAM_ID                    = SMSM.PROGRAM_ID
        AND U.SHEET_NAME                    = SMSM.SHEET_NAME
        AND U.COLUMN_NAME                   = SMSM.COLUMN_NAME
        AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND SMSM.VALID_YN                   = 'Y'
    WHERE  1 = 1
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.PROGRAM_ID = VA_PROGRAM_ID  --'DMF0082'
    AND    U.SHEET_NAME = VA_SHEET_NAME  --'FcstNPrice'
    AND    U.USER_ID    = p_created_by;

    ------------------------------------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT Fcst AMT/QTY)
    --실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 START
    ------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_MEASURE_CNT
    FROM   SCM_MGR.GTT_TEMPSELECTMEASURE A
    WHERE  1 = 1
    AND    A.MEASURE IN ('LOC', 'KRW', 'FCST_GAP');  --'FCST_GAP' 추가 [PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)

    IF V_MEASURE_CNT > 0 THEN
        INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
        ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
        WITH W_TARGET_MEASURE AS (
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'LOC' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_LOC')
            UNION ALL
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'KRW' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_KRW')
            -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  START -----
            UNION ALL
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'FCST_GAP' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('MKT_FCST', 'SCM_FCST')
            -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  END -----
        )
        SELECT DISTINCT
               W.PROGRAM_ID
             , W.SHEET_NAME
             , 'DM_ADMIN'       AS USER_ID  --USER_ID를 기준으로 단가 계산후 메저를 삭제함(사용자가 선택하지 않은 메저가 화면에 조회되면 안되므로)
             , W.MEASURE_GROUP
             , W.MEASURE
             , W.RESULT_MEASURE
             , W.SORT_ORDER_NO
        FROM   W_TARGET_MEASURE W
        JOIN   SCM_MGR.GTT_TEMPSELECTMEASURE T
            ON  (W.PROGRAM_ID     = T.PROGRAM_ID
           AND   W.SHEET_NAME     = T.SHEET_NAME
           AND   W.TARGET_MEASURE = T.MEASURE)
        WHERE  1 = 1
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.GTT_TEMPSELECTMEASURE X
                           WHERE  1 = 1
                           AND    X.MEASURE = W.MEASURE);
    END IF;
    ------------------------------------------------------------------------------------------------
    --실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 END
    ------------------------------------------------------------------------------------------------

    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START----------------------------------------------
    --LOC를 기준으로 CURRENCY를 일괄 업데이트 하기 때문에 무조건 해당 메저 INSERT
    --DM_PLN_CFM_SELLING_PRICE 테이블로 JOIN 해서 업데이트 하면 속도가 너무 느림
    INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
    SELECT A.PROGRAM_ID
         , A.SHEET_NAME
         , 'DM_ADMIN'
         , A.COLUMN_NAME AS MEASURE_GROUP
         , A.COLUMN_NAME AS MEASURE
         , A.COLUMN_NAME AS RESULT_MEASURE
         , TO_CHAR(A.SORT_ORDER_NO)
    FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
    WHERE  1 = 1
    AND    A.PROGRAM_ID  = VA_PROGRAM_ID
    AND    A.SHEET_NAME  = VA_SHEET_NAME
    AND    A.COLUMN_NAME = 'LOC'
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMPSELECTMEASURE X
                       WHERE  1 = 1
                       AND    X.MEASURE = A.COLUMN_NAME);
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END----------------------------------------------

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPSELECTMEASURE', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)
    -- #TempSelectMeasure 만들기 종료

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #T_LAST_DATA_SETUP_FCST / #T_LAST_DATA_SETUP_PRICE 만들기 (Current 버전)
    --------------------------------------------------------------------------------------------------------------------------------------------------
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN   /* AS-IS: @P_VERSION_TYPE LIKE '%CURRENT%' (MSSQL 대소문자 무시) */

        --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START ---------------------------------------------------------------------
        --기존 쿼리 주석 처리 후 일괄 변경
        --1.LAST_UPDATE_DATE 값을 가져올 때, CASE WHEN 에 소형사업부에서 사용하지 않는 메저들만 있어서 해당 로직 제거
        --2.가장 최근 데이터를 입력한 사용자ID가 아니라 MAX사용자ID로 가져와서 수정함
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE   /* CONVERT(NVARCHAR, ..., 112) — 명시 마스크 (C-11) */
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_MKT_FCST A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                                        WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                        ELSE B.MEASURE END)
               WHERE  A.DIVISION_ID = p_division_id
               /* DATEADD(YY,-1,@p_from_yyyymmdd) 문자열 암묵 DATE 변환 → 명시 변환 (C-11) */
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL     /* ISNULL(x,'')<>'' → IS NOT NULL (C-7) */
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        ELSE
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE   /* CONVERT(NVARCHAR, ..., 112) — 명시 마스크 (C-11) */
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                                        WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                        ELSE B.MEASURE END)
               WHERE  A.DIVISION_ID = p_division_id
               /* DATEADD(YY,-1,@p_from_yyyymmdd) 문자열 암묵 DATE 변환 → 명시 변환 (C-11) */
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL     /* ISNULL(x,'')<>'' → IS NOT NULL (C-7) */
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        END IF;  --[DIV81]
        -- #T_LAST_DATA_SETUP_FCST 만들기 종료

        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = B.MEASURE
               WHERE  A.DIVISION_ID = p_division_id
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        ELSE
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = B.MEASURE
               WHERE  A.DIVISION_ID = p_division_id
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
               --AND A.QTY <> 0
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        END IF;  --[DIV81]
        -- #T_LAST_DATA_SETUP_PRICE 만들기 종료

        --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_T_LAST_DATA_SETUP_FCST',  NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)
        --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_T_LAST_DATA_SETUP_PRICE', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)
    END IF;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #T_WS_FCST 만들기
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_T_WS_FCST ( FCST_TYPE )
    SELECT SEGMENT1
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'SALES_TYPE_CODE';

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_T_WS_FCST', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TempFcstNPrice 만들기 시작 - VERSION - CURRENT
    --------------------------------------------------------------------------------------------------------------------------------------------------
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN

        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )

        /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
        -- 기본적인 MEASURE 포함
        -- MKT_FCST [R+P]의 P부분 (기준일 이후)
        -- RTF [R+P] 의 P 부분 (기준일 이후)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             --[PJ2025-50188] 'MKT_AMT_LOC','MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                 WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
                            ELSE B.MEASURE END)
        /* OUTER APPLY (SELECT TOP(1) ... ORDER BY CREATE_DATE DESC) → LEFT JOIN LATERAL + FETCH FIRST */
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
        AND    (
                   (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
                   OR
                   (A.MEASURE = 'SCM_FCST')
               )
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = 'MKT_FCST'
            AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0

        UNION ALL

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
             , '-' AS CELL_PROD_SITE_ID /*[DIV81] 컬럼 부재*/
             , A.YYYYMMDD
             , NVL(A.PRICE, 0) AS QTY
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , A.CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD --계획구간만 : [PJ2025-50188] 실적 Unit Price 로직 변경
        --AND A.QTY <> 0

        UNION ALL

        /* DM_PLN_MKT_FCST_RESULT  테이블 기준 MEASURE */
        -- 2025.03.13 실적 (MKT_AMT_KRW,MKT_AMT_LOC Measure는 DM_PLN_SALES_PLAN_RESULT 테이블에서 가져옴) Start
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE AS MEASURE -- 확인필요
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재           -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             /* IIF(A.MEASURE LIKE 'VMI%', '', A.CURRENCY) → CASE + NULL (C-7) — 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188] */
             , CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A --DM_PLN_MKT_FCST_RESULT → 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188]
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.RESULT_MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )

        /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
        -- 기본적인 MEASURE 포함
        -- MKT_FCST [R+P]의 P부분 (기준일 이후)
        -- RTF [R+P] 의 P 부분 (기준일 이후)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             --[PJ2025-50188] 'MKT_AMT_LOC','MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                 WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
                            ELSE B.MEASURE END)
        /* OUTER APPLY (SELECT TOP(1) ... ORDER BY CREATE_DATE DESC) → LEFT JOIN LATERAL + FETCH FIRST */
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
        AND    (
                   (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
                   OR
                   (A.MEASURE = 'SCM_FCST')
               )
        --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY          /* AS-IS '' AS CURRENCY → NULL (C-7) */
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = 'MKT_FCST'
            AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0

        UNION ALL

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
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(A.PRICE, 0) AS QTY
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , A.CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD --계획구간만 : [PJ2025-50188] 실적 Unit Price 로직 변경
        --AND A.QTY <> 0

        UNION ALL

        /* DM_PLN_MKT_FCST_RESULT  테이블 기준 MEASURE */
        -- 2025.03.13 실적 (MKT_AMT_KRW,MKT_AMT_LOC Measure는 DM_PLN_SALES_PLAN_RESULT 테이블에서 가져옴) Start
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE AS MEASURE -- 확인필요
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID           -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
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
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
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
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             /* IIF(A.MEASURE LIKE 'VMI%', '', A.CURRENCY) → CASE + NULL (C-7) — 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188] */
             , CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A --DM_PLN_MKT_FCST_RESULT → 실적데이터도 통화를 보여주기 위해 테이블 변경 [PJ2025-50188]
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.RESULT_MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;
        END IF;  --[DIV81]

        --------------------------------------------------------------------------------------------------------------------------
        -- CURRENCY 일괄 UPDATE (MSSQL UPDATE ... FROM JOIN → MERGE. GROUP BY+MAX 로 ORA-30926 방지 — MSSQL 임의채택의 결정적 대체)
        --------------------------------------------------------------------------------------------------------------------------
        MERGE INTO SCM_MGR.GTT_TEMPFCSTNPRICE A
        USING (SELECT SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
                    , SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CELL_PROD_SITE_ID
                    , MAX(SP.CURRENCY) AS CURRENCY
               --FROM DBO.DM_PLN_CFM_SELLING_PRICE SP WITH(NOLOCK)
               FROM   SCM_MGR.GTT_TEMPFCSTNPRICE SP -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
               WHERE  1 = 1
               AND    SP.DIVISION_ID = p_division_id
               AND    SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               AND    SP.MEASURE = 'LOC'
               GROUP BY SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
                    , SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CELL_PROD_SITE_ID) SP
        ON (    A.DIVISION_ID       = SP.DIVISION_ID
            AND A.PROJECT_CODE      = SP.PROJECT_CODE
            AND A.SCM_SITE_ID       = SP.SCM_SITE_ID
            AND A.PLANT_SITE_ID     = SP.PLANT_SITE_ID
            AND A.ITEM_ID           = SP.ITEM_ID
            AND A.INCOTERMS         = SP.INCOTERMS
            AND A.DOM_EXP           = SP.DOM_EXP
            AND A.FCST_TYPE         = SP.FCST_TYPE
            AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID)
        WHEN MATCHED THEN UPDATE
            SET A.CURRENCY = SP.CURRENCY
            WHERE A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD -- [PJ2025-50188] 속도개선
            AND   A.CURRENCY IS NULL                                   /* ISNULL(A.CURRENCY,'')='' → IS NULL (C-7) */
            AND   A.MEASURE NOT LIKE 'VMI%';

        -----------------------------------------------------------------------------------------------------------
        -- #TempFcstNPrice 에 INSERT 한 메저들을 이용하여 판가 실적 계산
        -- LOC = MKT_AMT_LOC/RTF_SYS_RP
        -- KRW = MKT_AMT_KRW/RTF_SYS_RP
        -----------------------------------------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )
        --기존 소스 개선 및 FCST GAP 추가 [PJ2025-50188] : FCST Gap 메저 추가 (MKT FCST - SCM FCST) START -------------------
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
             , A.CELL_PROD_SITE_ID          -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
             , A.YYYYMMDD
             /* IIF → CASE (분모 0 방어 포함, AS-IS 동일) */
             , CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                                         THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                              / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                                         ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                                         THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                              / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
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
             , MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
             , MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
             , MAX(A.CITY_NAME) AS CITY_NAME
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
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO
             , MAX(A.CREATE_DATE) AS CREATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.CURRENCY) AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.GTT_TEMPFCSTNPRICE A
        JOIN   SCM_MGR.GTT_TEMPSELECTMEASURE D
            ON D.MEASURE IN ('LOC', 'KRW')
        WHERE  1 = 1
        AND    A.MEASURE IN ('RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD <  V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
               , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
               , A.CELL_PROD_SITE_ID          -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
               , A.CURRENCY, A.YYYYMMDD, D.MEASURE;
        -----------------------------------------------------------------------------------------------------------
        -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P])  END
        -----------------------------------------------------------------------------------------------------------
    END IF;
    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TempFcstNPrice 만들기 종료 - VERSION - CURRENT
    --------------------------------------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 START
    --Unit Price 계산 후 불필요 MEASURE 삭제 (삭제하지 않으면 화면에서 보임)
    -----------------------------------------------------------------------------------------------
    DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE A
    WHERE  EXISTS (SELECT 1
                   FROM   SCM_MGR.GTT_TEMPSELECTMEASURE B
                   WHERE  A.MEASURE = B.MEASURE
                   AND    B.USER_ID = 'DM_ADMIN');
    -----------------------------------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 END
    -----------------------------------------------------------------------------------------------

    /* [PLANT_SITE 2026-08-04] 조회조건 Plant Site 필터 (81 전용 — FE 40/82 비활성 = 'ALL') — GTT 단일 지점 */
        /* [E20260819-MULTIJOIN] 조회조건 SCM Site — 구 스테이징 INSERT 별 인라인 OR분기(REGEXP 분해 10지점(MERGE 포함))를
       PLANT_SITE 동형의 스테이징 후 단일 지점 GTT+NOT EXISTS 로 통합(그레인에 SCM_SITE_ID 포함 — 파생 메저 GROUP BY 실측, 최종 내용 동일). */
    IF p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_scm_site_id'
                   AND    T.TOKEN    = F.SCM_SITE_ID);
    END IF;

    IF p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE
        WHERE  PLANT_SITE_ID NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id'));
    END IF;

    /* [UICATEGORY 2026-08-07] 조회조건 Project / Owner 필터 (PLANT_SITE 동형 — GTT 단일 지점).
       Sender Code 는 본 스테이징에 SENDER_CODE 컬럼 원천 부재 → GTT_MF_SP 적재 후 지점에서 처리 ([E20260819-SENDERJOIN] 실적용 — 무값 행 제외) */
    IF p_project_code IS NOT NULL AND p_project_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE
        WHERE  NVL(PROJECT_CODE, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_project_code'));
    END IF;

    IF p_owner IS NOT NULL AND p_owner <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE
        WHERE  NVL(OWNER, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_owner'));
    END IF;

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_TEMPFCSTNPRICE', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* C_TITLE 커서 시작 — 동적쿼리에서 사용 할 동적 컬럼을 만드는 커서 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    V_COLUMN  := '';  --필수
    V_GROUPBY := '';
    V_ORDERBY := '';

    OPEN C_TITLE;
    LOOP
        FETCH C_TITLE INTO V_CUR_PROGRAM_ID, V_CUR_SHEET_NAME, V_CUR_COLUMN_NAME, V_CUR_SORT_ORDER_NO;
        EXIT WHEN C_TITLE%NOTFOUND;          /* C-10: FETCH 직후 종료 판정 의무 */
        IF V_COLUMN IS NULL THEN             /* AS-IS: IF @V_COLUMN = '' (Oracle '' = NULL, C-7) */
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

    --[E20240812-000094]_해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가 START
    V_COLUMN := CASE WHEN V_COLUMN IS NULL THEN 'NOTATION' ELSE V_COLUMN || ',NOTATION' END;   /* + ',[NOTATION]' */
    --[E20240812-000094] END

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

    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');   /* CAST ... NUMERIC(10,2) */
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
    /* C_TITLE 커서 종료 */

    ---------------------------------------------------------------------------------
    --            권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    V_GROUP_ID := '';

    SELECT COUNT(1)
    INTO   V_ADMIN_CNT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN = 'Y'
    AND (SEGMENT1 = p_user_group  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
             OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
    AND    SEGMENT2 = 'ALL';
    --AND SEGMENT3 = LEFT(@P_DIVISION_ID,2)

    IF NVL(V_ADMIN_CNT, 0) > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --           권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------------------------------------------
    --사용자의 요건: 소형사업부 계획수립 Timeline 단축으로 MKT FCST / SCM FCST가 월요일에 진행됨에 따라
    --MKT FCST 입력 제한을 시간 단위로 제한할 수 있도록 기능 개발 필요
    --[Timeline 단축에 따른 월요일 MKT FCST, SCM FCST 입력 시간 변경]
    --기존 월 24시 DM cutoff → 기존에는 화요일에 SCM_FCST만 입력 가능하도록 되어 있었으나,
    --변경 월 15시 DM Cutoff → 월 15시 30분 ~ 17시 30분 까지 SCM FCST 수정하고자 함
    --기존 룩업은 모든 메져에 날짜가 적혀있었는데, 의미없음. 실제 제한을 하는 메져만 일자를 두는것으로 룩업구성 변경함
    --룩업명: GET_ADMIN_GROUP_MEASURE
    -------------------------------------------------------------------------------------------------------------------------
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

    --2). 실제 관리하는 MEASURE와 권한이 가진 메져가 다른 경우가 있을수 있으므로, 해당 화면 기준으로 메져를 구한다음에 위에서 구한 메져로 EDIT_FLAG로 붙여준다
    INSERT INTO SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE ( MEASURE, EDIT_FLAG )
    SELECT A.MEASURE
         , CASE WHEN B.MEASURE IS NULL THEN 'N' ELSE 'Y' END AS EDIT_FLAG   /* ISNULL(B.MEASURE,'')='' → IS NULL (C-7) */
    FROM  (SELECT A.SEGMENT4 AS MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND    A.SEGMENT2 = VA_PROGRAM_ID  --'DMF0082'
           GROUP BY A.SEGMENT4 ) A
    LEFT OUTER JOIN (SELECT B.MEASURE
                     FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                     GROUP BY B.MEASURE ) B
        ON A.MEASURE = B.MEASURE;

    --3). #TEMP_INTO_GROUP_MEASURE 테이블에 적재한 데이터 중 LIMIT_MEASURE가 존재하는 경우 해당 메져의 FLAG는 N으로 변경해준다
    SELECT COUNT(A.LIMIT_MEASURE)
    INTO   V_LIMIT_CNT
    FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE A
    WHERE  A.LIMIT_MEASURE IS NOT NULL;   /* ISNULL(x,'') != '' → IS NOT NULL (C-7) */

    IF V_LIMIT_CNT >= 1 THEN
        /* MSSQL UPDATE ... FROM INNER JOIN → EXISTS (룰 #30) */
        UPDATE SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A
        SET    A.EDIT_FLAG = 'N'
        WHERE  EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                       WHERE  A.MEASURE = B.LIMIT_MEASURE);
    END IF;

    /* IF OBJECT_ID(#TEMP_INTO_GROUP_MEASURE) DROP → GTT 정리 (C-2: DELETE FROM) */

    /* [E20260825-81AUTH] LIMIT_AUTH(그룹 잠금) 해석 — AS-IS DMF0003 판 의미 이식 (사용자 확정 2026-08-25).
       81 계열 룩업 행의 ATTRIBUTE4 는 "메저명"이 아니라 **잠금 유발 권한그룹명**('SCP Planner')이다:
       그 그룹의 같은 (S2,S3,S4) 행이 지금 요일·시간창 안이면 내 메저는 편집 불가.
       (원형 = PKG_DMF0003 AUTHGATE L10270~10296. 40 의 LIMIT_MEASURE(메저 잠금)과 공존 —
        A4 값이 그룹 행(SEGMENT1)과 매칭될 때만 발동. 40 의 'MKT_FCST' 토큰은 그룹 미매칭 = 영향 0.)
       합집합(AUTHUNION) 보존 — 보유그룹 행 중 잠기지 않은 행이 하나라도 있으면 Y 유지.
       ⚠ 한계: A4 가 콤마 다중 그룹이면 토큰별 개별 판정(현 데이터 = 단일 'SCP Planner' 뿐). */
    UPDATE SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A
    SET    A.EDIT_FLAG = 'N'
    WHERE  A.EDIT_FLAG = 'Y'
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
    --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 END
    -------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------------------------------------------------------------------
    --#CAL_MONTH_END_DATE 만들기 시작
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_CAL_MONTH_END_DATE ( MONTH_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY BASIS_YYYYMM;

    --#CAL_WEEK_END_DATE 만들기 시작
    INSERT INTO SCM_MGR.GTT_CAL_WEEK_END_DATE ( WEEK_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 동적쿼리에서 사용될 MF_SP 임시테이블 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GTT_MF_SP
    ( DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, MEASURE
    , END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
    , YYYYMM, YYYYMMWW, YYYYMMDD, DAYOFWEEK
    , FORECAST_INFO_CELL_MODEL, TEAM_ID, TEAM_NAME_KO
    , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, ITEM_NAME, VMI_YN, CELL_PROD_SITE_ID
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
    , QTY, MONTH_END_YN, WEEK_END_YN, EDIT_FLAG
    , SORT_ORDER_NO, MEASURE_GROUP, NEW_FLAG, BUCKET, SORT_KEY
    , LAST_UPDATE_DATE, LAST_UPDATED_BY, NOTATION, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD
    /* [UICATEGORY 2026-08-07] 신규 컬럼 — 본 스테이징(GTT_TEMPFCSTNPRICE 49컬럼)에 원천 부재 → NULL 적재
       (AS-IS Current 도 미제공. ORA-00904 차단 목적 — 실값은 GET(버전 조회) 경로가 제공) */
    , AS_YN, ATTR1, VMI_STD_DIO, BIZ_TYPE, PROJECT_STATUS, ENERGE, CELL_QUANTITY
    , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, AS_FROM_SITE )
    SELECT A.DIVISION_ID
         , A.SCM_SITE_ID
         , A.PLANT_SITE_ID
         , A.PROJECT_CODE
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.MEASURE
         , A.END_CUSTOMER
         , A.NICK_NAME
         , A.DMS_SALES
         , A.DMS_CUSTOMER
         , C.BASIS_YYYYMM  AS YYYYMM
         , C.BASIS_YYYYMM || C.ISO_WEEK AS YYYYMMWW
         , C.BASIS_YYYYMMDD AS YYYYMMDD
         , C.DAYOFWEEK
         , A.CELL_MODEL   AS FORECAST_INFO_CELL_MODEL
         , A.DEPT_ID      AS TEAM_ID
         , A.DEPT_NAME_KO AS TEAM_NAME_KO
         , A.ITEM_TYPE
         , A.PROJECT_NAME
         , A.PROJECT_OWNER
         , A.OWNER
         , A.SOLDTO_CUSTOMER
         , A.COUNTRY_NAME
         , A.CITY_NAME
         , A.ITEM_NAME
         , A.VMI_YN
         , A.CELL_PROD_SITE_ID
         , A.CUST_GROUP
         , A.CUST_GROUP_DTL
         , A.APPLICATION
         , A.ROUTE
         , A.MDM_PROJECT_NAME
         , A.MIN_CAPACITY
         , A.FORECAST_INFO_BIZ_TYPE
         , A.CELL_TYPE
         , A.FORECAST_INFO_CELL_PACK_COUNT
         , A.FORECAST_INFO_ALL
         , A.FORECAST_INFO_SPEC
         , A.FORECAST_INFOR_VERSION
         , A.CELL_MODEL_NICK_NAME
         , CAST(A.QTY AS NUMBER(36,10)) AS QTY
         , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
         , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
         , CASE
               WHEN MA.DEPT_ID IS NOT NULL AND A.MEASURE_GROUP NOT IN ('CUST_FCST_2','CUST_FCST_3','TMM_FCST') AND A.MEASURE = M1.SEGMENT3  -- 같은부서+MktFcst등 (TMM 제외)
                   THEN 'Y'
               WHEN (V_GROUP_ID = 'ADMIN') AND A.MEASURE_GROUP <> 'TMM_FCST' AND A.MEASURE = M1.SEGMENT3  -- Admin권한자+MktFcst등 (TMM 제외)
                   THEN 'Y'
               ELSE 'N'
           END AS EDIT_FLAG
         , A.SORT_ORDER_NO  -- Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
         , A.MEASURE_GROUP  -- Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
         , 'N' AS NEW_FLAG
         , NVL(BK.BUCKET, '0000000') AS BUCKET
         , 999 AS SORT_KEY
         , CASE WHEN A.CREATE_DATE     IS NULL THEN ' ' ELSE A.CREATE_DATE END     AS LAST_UPDATE_DATE   /* ISNULL(x,'')='' → IS NULL (C-7) */
         , CASE WHEN A.LAST_UPDATED_BY IS NULL THEN ' ' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY
         , A.NOTATION
         , A.CURRENCY
         , A.VERSION_NO
         , A.CUTOFF_YYYYMMDD
         /* [UICATEGORY 2026-08-07] 신규 컬럼 NULL 적재 (스테이징 원천 부재 — 컬럼 목록 주석 참조) */
         , NULL, NULL, NULL, NULL, NULL, NULL, NULL
         , NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   SCM_MGR.GTT_TEMPFCSTNPRICE A
    INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
        ON C.BASIS_YYYYMMDD = A.YYYYMMDD
    --LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
    LEFT OUTER JOIN SCM_MGR.GTT_CAL_MONTH_END_DATE C2
        ON A.YYYYMMDD = C2.MONTH_END_DATE
    LEFT OUTER JOIN SCM_MGR.GTT_CAL_WEEK_END_DATE C3
        ON A.YYYYMMDD = C3.WEEK_END_DATE
    --LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL X ON A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = 'AS_SITE_PLANT'
    LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1   -- EDIT가 가능한 MEASURE (수정 해야 하는 MEASURE가 생기면 아래 룩업에 추가해야한다)
        ON  A.DIVISION_ID  = M1.SEGMENT2  -- DIVISION_ID       -- 그리고 수정 해야하는 새로운 MEASURE가 생겼을때 권한그룹별이나 요일별로 관리해야 한다면 필요시 GET_ADMIN_GROUP_MEASURE 에도 넣어야 한다.
        AND A.MEASURE      = M1.SEGMENT3  -- MEASURE
        AND M1.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
        AND M1.SEGMENT1    = 'DMF0082'
        AND M1.ATTRIBUTE2  = 'Y'          -- EDIT_YN 여부
        AND M1.VALID_YN    = 'Y'          -- VALID_YN 여부
    LEFT OUTER JOIN (
        /* MSSQL PIVOT ([SUN],[MON],...) → Oracle PIVOT ('SUN' AS SUN, ...) — CONCAT(ISNULL(x,0)...) → NVL || 결합 */
        SELECT PVT.DIVISION_ID, PVT.SCM_SITE_ID, PVT.INCOTERMS
             , TO_CHAR(NVL(PVT.SUN,0)) || TO_CHAR(NVL(PVT.MON,0)) || TO_CHAR(NVL(PVT.TUE,0)) || TO_CHAR(NVL(PVT.WED,0))
               || TO_CHAR(NVL(PVT.THU,0)) || TO_CHAR(NVL(PVT.FRI,0)) || TO_CHAR(NVL(PVT.SAT,0)) AS BUCKET
        FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD
                    , CASE WHEN BUCKET_PER = 'Y' THEN 1 ELSE 0 END AS BUCKET_PER
               FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION
               WHERE  DIVISION_ID = p_division_id)
        PIVOT ( MAX(BUCKET_PER) FOR YYYYMMDD IN ('SUN' AS SUN, 'MON' AS MON, 'TUE' AS TUE, 'WED' AS WED, 'THU' AS THU, 'FRI' AS FRI, 'SAT' AS SAT) ) PVT
    ) BK
        ON  A.DIVISION_ID = BK.DIVISION_ID
        AND A.SCM_SITE_ID = BK.SCM_SITE_ID
        AND A.INCOTERMS   = BK.INCOTERMS
    --부서 테이블 추가
    LEFT OUTER JOIN (
        SELECT LOOK.SEGMENT3 AS DEPT_ID
        FROM   SCM_MGR.TB_FX_USER USR
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
            ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' AND LOOK.VALID_YN = 'Y'
        WHERE  USR.USERID = p_created_by
        UNION -- 중복값 있으면 안됨
        SELECT DEPT_ID
        FROM   SCM_MGR.TB_FX_USER
        WHERE  USERID = p_created_by
    ) MA
        ON A.DEPT_ID = MA.DEPT_ID
    WHERE  1 = 1;
    --OPTION (HASH JOIN)  → MSSQL 힌트 제거

    /* [E20260819-MULTIJOIN] Team(deptId) 필터 — 구 인라인 (p_team_id='ALL' OR A.DEPT_ID IN REGEXP분해) 를 GTT 선적재+IF게이트+NOT EXISTS 로 전환
       (스테이징 컬럼 TEAM_ID = A.DEPT_ID 1:1 실측 · NULLABLE='Y' → 양변 원문 비교 = 구 bare-IN 의미론 보존). */
    IF p_team_id IS NOT NULL AND p_team_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_MF_SP F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_team_id'
                   AND    T.TOKEN    = F.TEAM_ID);
    END IF;

    /* [E20260819-SENDERJOIN] Sender Code 필터 = 실적용 (2026-08-19 사용자 재확정 — 구 2026-08-07 "무값 행 통과" 예외 폐기).
       본 스테이징(GTT_MF_SP)은 SENDER_CODE 원천 부재로 NULL 적재 — 신규 의미론상 sender 지정 시 무값 행 매칭 실패=전량 제외(0행)가 정합.
       SENDER_CODE 양변 원문 비교(ALL_TAB_COLUMNS 실측 NULLABLE='Y' — hook #119 §1.5 NVL 정규화는 NOT NULL 센티널 한정). */
    IF p_sender_code IS NOT NULL AND p_sender_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_MF_SP F
        WHERE  NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                   WHERE  T.PARAM_NM = 'p_sender_code'
                   AND    T.TOKEN    = F.SENDER_CODE);
    END IF;

    /* [UICATEGORY 2026-08-07] Division 82 = 조회 전용 (사용자 확정) — 편집 서버 권위 차단 */
    IF p_division_id = '82' THEN
        UPDATE SCM_MGR.GTT_MF_SP SET EDIT_FLAG = 'N';
    END IF;

    --[E20260812-PERF-NOSTATS] DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GTT_MF_SP', NO_INVALIDATE => FALSE);  -- hook #129: SP 내 통계수집 금지(ASH 병목 실측 — undo/COL$ 대기. DS2 dynamic sampling 이 대체)

    --2025.03.10 Philsu Park: MKT Fcst 수량 없는거 날리고 조회하는 구문 테스트.
    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GTT_MF_SP SP
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
                                  FROM   SCM_MGR.GTT_MF_SP
                                  WHERE  MEASURE IN ('MKT_FCST','SCM_FCST') --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : SCM_FCST - MEASURE 추가
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

    /* [E20260825-AFSBLANK] AS_FROM_SITE NULL -> ' ' 정규화 (사용자 지시 2026-08-25).
       증상: 81 조회에서 AS_FROM_SITE 컬럼을 켜면 같은 행이 실적/계획 2행으로 분리된다.
       원인: 최종 커서가 동적 GROUP BY 로 표시 컬럼 전체를 묶는데(OPEN O_RC1 FOR 동적 SQL),
             계획 arm 과 실적 arm 의 빈값 표현이 달라(공백 ' ' vs NULL) 같은 표시키가 서로 다른 그룹이 된다.
             실적 원장은 PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 이 ATTRIBUTE10 을 적재하지 않아 항상 NULL
             (INSERT 컬럼 목록에 ATTRIBUTE10 부재 — 실측).
       주의: 실적 arm 에만 NVL 을 걸면 '계획 NULL vs 실적 공백' 이 새로 갈라진다(사내 실측 81 양쪽 NULL 4,801키).
             그래서 두 arm 이 합류한 스테이징에서 한 번에 정규화한다 — 표현만 통일, 실제 사이트값은 불변.
       한계: 값이 실제로 다른 경우(계획 'WA00_81-W' vs 실적 NULL)는 NVL 대상이 아니다 — 별도 판단 필요. */
    UPDATE SCM_MGR.GTT_MF_SP
    SET    AS_FROM_SITE = ' '
    WHERE  AS_FROM_SITE IS NULL;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* [DEFECT_GUARD] PIVOT IN 리스트 비어있음 방어 — C_BUCKET 0행 시 빈 결과셋 조기 반환 (ORA-00936 회피) */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC3 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC4 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC5 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS RESULT_CODE, 'NO_BUCKET_DATA' AS RESULT_MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 최종적으로 실행하는 동적쿼리 (첫번째 DataTable) — AS-IS placeholder REPLACE 방식 유지 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    DBMS_LOB.CREATETEMPORARY(V_SQL_TEXT, TRUE);

    V_SQL_TEXT := '
    SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]
    FROM (      SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY
                FROM   SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) --[PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') ) --[PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD
                        , CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'' ) AND F.WEEK_END_YN = ''Y'' THEN  SUM (F.QTY)
                               ELSE SUM(F.QTY)
                            END AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188] 실적 Unit Price 로직 변경
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') )
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN, F.MEASURE

                -------------------------------------------------------------------------------
                -- [PJ2025-50188] 실적 Unit Price 로직 변경 : Weekly Sum 에서 LOC,KRW,USD 는 평균값으로 보이도록 소스 분리
                -------------------------------------------------------------------------------

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD
                        , AVG(QTY) AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE  IN  (''KRW'', ''USD'', ''LOC''  )
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD
                        , CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv''  ) AND F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)
                               ELSE SUM(F.QTY)
                            END AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188] 실적 Unit Price 로직 변경
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') )
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN, F.MEASURE

                -------------------------------------------------------------------------------
                -- [PJ2025-50188] 실적 Unit Price 로직 변경 : Monthly Sum 에서 LOC,KRW,USD 는 월 마지막 일자와 상관없이 일자 전체 평균값으로 보이도록 소스 분리
                -------------------------------------------------------------------------------

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD
                        , AVG(QTY) AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE IN  (''KRW'', ''USD'', ''LOC''  )
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM
        )
    PIVOT (SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )) PVT
    [@V_ORDERBY]
    ';
    /* AS-IS 말미의 OPTION ( ORDER GROUP ) MSSQL 힌트 제거 */

    /* AS-IS: REPLACE('[@v_PV_COL_LIST]', @v_PV_LIST) — MSSQL 은 두 리스트가 동일 문자열이라 무해.
       Oracle 은 PIVOT IN('D_x' AS D_x)과 SELECT(D_x) 형태가 다르므로 각각 올바른 리스트로 치환 (원문 버그 교정, 결과 동일) */
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]', V_PV_COL_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',     V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',      V_COLUMN);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',     V_ORDERBY);

    -- 개발중에는 텍스트만 확인하고 실행은 안한다.
    /* SELECT CONVERT(TEXT, @v_sql_text) FOR XML PATH('') */

    /* 첫번째 DataTable */
    OPEN O_RC1 FOR V_SQL_TEXT;

    BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 두번째 DataTable */
    ---------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가
    -- Monthly에서 M+4 부터 수정 가능하게 하기. ( ex) 현재 5월이면, 9월부터 수정가능)
    ---------------------------------------------------------------------------------------------------------------
    OPEN O_RC2 FOR
        SELECT MONTH_NAME, ISO_WEEK
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        /* FORMAT(DATEADD(MONTH,3,GETDATE()),'yyyyMM') → 명시 마스크 (C-11) */
        WHERE  BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(SYSDATE, 3), 'YYYYMM')
        ORDER BY BASIS_YYYYMMDD
        FETCH FIRST 1 ROWS ONLY;   /* SELECT TOP 1 */

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 세번째 DataTable — 현재 주차 */
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RC3 FOR
        SELECT 'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM
             , A.ISO_WEEK
        FROM  (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')          /* CONVERT(VARCHAR(8),GETDATE(),112) — C-11 */
              ) A
        JOIN  (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')      /* DATEADD(DAY,-7,GETDATE()) — C-11 */
              ) B ON 1 = 1;

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 네번째 DataTable — 메저별 EDIT_FLAG */
    --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 (START)
    --[PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 START
    --개발시점 기준 SCP Planner 만 SCM_FCST 에 대한 수정권한 부여. (실제적으로는 ADMIN , SCM PI ADMIN 도 같이 권한 추가 했음)
    --------------------------------------------------------------------------------------------------------------------------------------------------
    --[E20260814-CURMEASURE] 통합테스트 No.41 — Current 버전에서 전 measure 입력 불가 정정.
    --   FE(useForecastPriceStore.setMeasureAuth)는 이 커서의 **EDIT_AUTH_YN** 으로 measure 편집 게이트를
    --   만든다(일반 조회 GET_MAIN_DATA 의 O_RC4 규격). CURRENT 는 EDIT_FLAG 2컬럼만 내려
    --   전 measure 가 false 로 잠겼다 → 컬럼명·컬럼수를 GET 과 동일 규격으로 맞춘다(파리티).
    --   ⚠ GTT_TEMP_ADMIN_GROUP_MEASURE 는 2컬럼뿐이라 요일제한 2컬럼은 NULL 로 채운다
    --      (요일 제한은 PKG 가 행별 EDIT_FLAG 에 이미 종합 반영 — FE 도 게이트로만 쓴다).
    OPEN O_RC4 FOR
        SELECT A.MEASURE
             , A.EDIT_FLAG              AS EDIT_AUTH_YN
             , CAST(NULL AS VARCHAR2(1))   AS TODAY_LIMIT_YN
             , CAST(NULL AS VARCHAR2(100)) AS TODAY_DAY_LIST
        FROM   SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A
        ORDER BY A.MEASURE;
    --[PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 END
    --[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 (END)

    --------------------------------------------------------------------------------------------------------------------------------------------------
    /* 다섯번째 DataTable */
    --[PJ2025-50188] 고도화 - M+4 월부터 월간 물량 배분 로직 적용 (신규) - START
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RC5 FOR
        SELECT BASIS_YYYYMMDD                 -- UI에서 BASIS_YYYYMMDD 로 값을 가져 온다.
             , BASIS_YYYYMM                   -- UI에서 BASIS_YYYYMM 로 값을 가져 온다.
             /* RIGHT(BASIS_START_DATE,2) → SUBSTR(x,-2) */
             , CASE WHEN SUBSTR(BASIS_START_DATE, -2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG  -- 매월 1일이 포함된 주차를 구분하는 FLAG
             /* LEFT(CONVERT(VARCHAR(8),DATEADD(DAY,7,...),112),6) = LEFT(...,6) → SUBSTR + TO_CHAR/TO_DATE 명시 마스크 (C-11) */
             , CASE WHEN SUBSTR(TO_CHAR(TO_DATE(BASIS_START_DATE, 'YYYYMMDD') + 7, 'YYYYMMDD'), 1, 6)  -- 7일 뒤에도
                         =
                         SUBSTR(BASIS_START_DATE, 1, 6)                                                -- 같은 달이라면 N , 다른 달이되었다면 Y
                    THEN 'N' ELSE 'Y' END AS END_MONTH_FLAG   --월별 마지막 주차 FLAG (해당 주차에 해당하는 일은 모두 표시되있음)
             , COUNT(*) OVER (PARTITION BY BASIS_YYYYMM) AS MONTH_DAY_CNT                    -- 해당 월의 일개수 (이 값으로 나눠야함)
             , COUNT(*) OVER (PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT  -- 해당 주의 일개수 (이 값으로 곱해야함)
             , ISO_YYYYWW  --[20250616] KJIYOON
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY BASIS_YYYYMMDD;
    --[PJ2025-50188] 고도화 - M+4 월부터 월간 물량 배분 로직 적용 (신규) - END

    --------------------------------------------------------------------------------------------------------------------------------------------------
    -- O_RESULT_CURSOR: 성공 응답 (표준)
    --------------------------------------------------------------------------------------------------------------------------------------------------
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## SUCCESS END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, p_created_by);
    EXCEPTION WHEN OTHERS THEN NULL; END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);    EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT
              , '########## FAIL END of procedure ##########', V_DESCRIPTION
              , SYSDATE, p_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_MAIN_DATA_CURRENT;


PROCEDURE P_DMF0082_GET_SPREAD_TITLE 
(
    p_start_yyyymmdd  IN VARCHAR2,
    p_end_yyyymmdd    IN VARCHAR2,
	p_created_by	  IN VARCHAR2,
	p_division_id	  IN VARCHAR2,
	O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN




	v_program_id := 'DMF0082';
	v_sheet_name := 'FcstNPrice';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		OPEN O_RESULT_CURSOR FOR
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        -- TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, U.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		UNION ALL
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
				, v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, 90         AS COLUMN_WIDTH
				, T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				, ''         AS CELL_COMBO_DATA_TYPE
				, 3         AS DATA_SCALE_NUMBER -- 소수점 3자리 필요시 '3'
				, 0         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''			AS DIVISION_ID
		FROM  (
				SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					, A.DAYOFWEEK               AS DAY_CODE
					, CAST(A.BASIS_YYYYMMDD || '31' AS NUMBER(10,0)) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
				--UNION ALL
				--SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
				--	, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
				--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
				--		WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
				--		ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
				--	, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
				--	, ''                        AS DAY_CODE
				--	, A.BASIS_YYYYMMDD + TO_CHAR(32) AS SORT_ORDER_NO
				--	, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM   SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				UNION ALL
				SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
					, ''                   AS DAY_CODE
					, CAST(A.BASIS_START_DATE || '21' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK
						, A.WEEK_NAME
						, PARTIAL_WEEK_NAME	-- 20190610
						, A.MONTH_NAME
						, A.BASIS_START_DATE
				--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
				--UNION ALL
				--SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
				--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
				--		WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
				--		ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
				--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
				--		WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
				--		ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
				--	, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
				--	, ''                    AS DAY_CODE
				--	, A.BASIS_START_DATE + TO_CHAR(22) AS SORT_ORDER_NO
				--	, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM   SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--GROUP BY A.BASIS_YYYYMM
				--		, A.ISO_WEEK
				--		, A.WEEK_NAME
				--		, PARTIAL_WEEK_NAME	-- 20190610
				--		, A.MONTH_NAME
				--		, A.BASIS_START_DATE
				UNION ALL
				SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, CAST(MIN(A.BASIS_START_DATE) || '01' AS NUMBER(10, 0)) AS SORT_ORDER_NO
						, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
				--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
				--UNION ALL
				--SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
				--		, A.MONTH_NAME           AS COLUMN_LABEL
				--		, A.MONTH_NAME           AS SMALL_LABEL_NAME
				--		, A.MONTH_NAME           AS LARGE_LABEL_NAME
				--		, ''                     AS DAY_CODE
				--		, MIN(A.BASIS_START_DATE) + TO_CHAR(11) AS SORT_ORDER_NO
				--		, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM    SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--GROUP BY A.BASIS_YYYYMM
				--		, A.MONTH_NAME
				--ORDER BY sort_order_no
			) T
		  ORDER BY SORT_ORDER_NO   ;
	  ELSE
			OPEN O_RESULT_CURSOR FOR
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = 'N'
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT v_program_id   AS PROGRAM_ID
					, v_sheet_name AS SHEET_NAME
					, T.COLUMN_NAME
					, T.COLUMN_LABEL_NAME
					, T.SORT_ORDER_NO
					, ''         AS DATA_SORT_METHOD_CODE
					, T.SMALL_CLASS_LABEL_NAME
					, T.LARGE_CLASS_LABEL_NAME
					, T.DAY_CODE
					, ''         AS FIXED_FLAG
					, 90         AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, 0         AS DATA_SCALE_NUMBER
					, 0         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
			FROM  (
					SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
						, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
						, A.DAYOFWEEK               AS DAY_CODE
						, CAST(A.BASIS_YYYYMMDD || '31' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
					--UNION ALL
					--SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
					--	, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
					--	WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
					--	ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					--	, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					--	, ''                        AS DAY_CODE
					--	, A.BASIS_YYYYMMDD + TO_CHAR(32) AS SORT_ORDER_NO
					--FROM   SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					UNION ALL
					SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
						, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
						, ''                   AS DAY_CODE
						, CAST(A.BASIS_START_DATE || '21' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK
							, A.WEEK_NAME
							, PARTIAL_WEEK_NAME	-- 20190610
							, A.MONTH_NAME
							, A.BASIS_START_DATE
					--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
					--UNION ALL
					--SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
					--	WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
					--	ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
					--, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
					--	WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
					--	ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					--	, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
					--	, ''                    AS DAY_CODE
					--	, A.BASIS_START_DATE + TO_CHAR(22) AS SORT_ORDER_NO
					--FROM   SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--GROUP BY A.BASIS_YYYYMM
					--		, A.ISO_WEEK
					--		, A.WEEK_NAME
					--		, PARTIAL_WEEK_NAME	-- 20190610
					--		, A.MONTH_NAME
					--		, A.BASIS_START_DATE
					UNION ALL
					SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME          AS COLUMN_LABEL_NAME
							, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
							, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
							, ''                    AS DAY_CODE
							, CAST(MIN(A.BASIS_START_DATE) || '01' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					FROM    SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME
					--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
					--UNION ALL
					--SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
					--		, A.MONTH_NAME           AS COLUMN_LABEL
					--		, A.MONTH_NAME           AS SMALL_LABEL_NAME
					--		, A.MONTH_NAME           AS LARGE_LABEL_NAME
					--		, ''                     AS DAY_CODE
					--		, MIN(A.BASIS_START_DATE) + TO_CHAR(11) AS SORT_ORDER_NO
					--FROM    SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--GROUP BY A.BASIS_YYYYMM
					--		, A.MONTH_NAME
					--ORDER BY sort_order_no
				) T
			  ORDER BY SORT_ORDER_NO   ;
		  END IF;
END P_DMF0082_GET_SPREAD_TITLE;


PROCEDURE P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP 
/* [DIV81] 2026-07-14 admin: Division 81(LIKE '81%') 시 SCM_MST_FUTURE_PRICE 로 분기 (원본 MSSQL 테이블 복원 — 소스 내 주석 물증). CELL_PROD_SITE_ID 는 '-' 리터럴/조인 제거 (컬럼 부재). 40 원문 무수정. */
(
    p_division_id			IN	VARCHAR2,
	p_dept_id				IN	VARCHAR2,	--Department
    p_end_customer			IN	VARCHAR2,	--Endcustomer
	p_scm_site_id			IN	VARCHAR2,
	p_plant_site_id			IN	VARCHAR2,
    p_project_code			IN	VARCHAR2,
	p_item_id				IN	VARCHAR2,
	p_customer_project_code	IN	VARCHAR2,
	p_customer_model		IN	VARCHAR2,
	p_from_yyyymmdd			IN	VARCHAR2,
	p_to_yyyymmdd			IN	VARCHAR2,
	p_biztype				IN	VARCHAR2,
	p_created_by			IN	VARCHAR2,
	p_userinfo				IN	VARCHAR2,
	p_owner					IN	VARCHAR2,
	p_over_range	        IN  VARCHAR2,   -- PJ20200138범위 초과 Flag
	p_invalid_exec	        IN  VARCHAR2,   -- [C20200612-000174] ESS사업부 New Model Flag
	O_CURSOR                OUT SYS_REFCURSOR
)
AS
    v_group_id VARCHAR2(50 CHAR) := NULL;
    p_program_id VARCHAR2(4000 CHAR) := 'DMF0082';		-- 20180605 수정;
    p_valid_yn VARCHAR2(10 CHAR) := 'Y';  --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공;
    V_Prod VARCHAR2(32767);
    V_Prod_Cols VARCHAR2(32767); -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정
    v_nsql VARCHAR2(4000 CHAR);
    v_cnt_1 INTEGER := 0;
	v_to_yyyymmdd2 VARCHAR2(8 CHAR);                 -- PJ20200138 비교 날짜
BEGIN
    /* ⭐ [E20260815-SPLIT2GTT] hook #129 §3.0 (2순위) — 테이블 함수 → GTT 선적재.
       `TABLE(UF_FX_String_SplitForIN(p_x,','))` 는 카디널리티 추정이 고정값으로 굳고,
       같은 파라미터를 여러 곳에서 쓰면 그때마다 PIPELINED 함수가 다시 돈다(패키지 내 19곳 실측).
       파라미터당 **1회만** 쪼개 GTT 에 넣고, 호출부는 GTT 를 읽는다.
       ⚠ 이 블록은 **어떤 IF 안에도 두지 않는다** — 조건 블록에 들어가면 일반 조회에서
         통째로 건너뛰어 토큰이 비고 조회가 전멸한다(2026-08-15 센티널 패치 실패 계보). */
    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_division_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_division_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_dept_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_dept_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_end_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_end_customer, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_biztype', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biztype, ','));

        --[E20260812-DS2] GTT 무통계 클라우드 10배 지연 방어 표준
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

	--SELECT 'TEST01' AS DIVISION_ID , '1' AS SCM_SITE_ID , 'M1' AS MEASURE
	--UNION ALL
	--SELECT 'TEST02' AS DIVISION_ID , '2' AS SCM_SITE_ID , 'M2' AS MEASURE
    --  v_dept_id VARCHAR2(4000 CHAR) := NULL;;
	--	v_group_id := 'ADMIN'

	-- ------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	-- ------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
	AND (SEGMENT1 = p_userinfo  --[AUTHUNION 2026-08-04] 보유그룹 합집합 판정 (사용자 확정)
	     OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
	                     WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'));

	IF v_cnt_1 > 0 THEN
		v_group_id := 'ADMIN';

		--------------------------------------------------------------------------------
		--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
		--------------------------------------------------------------------------------
  		V_Prod := '';
		v_to_yyyymmdd2 := TO_CHAR(TO_DATE(p_to_yyyymmdd, 'YYYYMMDD') + 7, 'YYYYMMDD');


		-- 임시테이블 TRUNCATE 처리
		DELETE FROM SCM_MGR.GTT_OVER_RANGE;
		DELETE FROM SCM_MGR.GTT_OVER_RANGE_LIST;
		DELETE FROM SCM_MGR.GTT_DM_MST_ITEM_SINGLE_V;
		DELETE FROM SCM_MGR.GTT_PLAN_DATA;
		DELETE FROM SCM_MGR.GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE;
		DELETE FROM SCM_MGR.GTT_MST_FUTURE_PRICE_SAVE_PRICE;
		DELETE FROM SCM_MGR.GTT_SALES_SITE_MODEL;
		DELETE FROM SCM_MGR.GTT_SALES_SITE_MODEL_ALL;


		/* TODO:GTT:GTT_OVER_RANGE-->GTT_OVER_RANGE */
		IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] B1: 81 테이블 분기 (하단 ELSE=40 원문 무수정)
		INSERT INTO GTT_OVER_RANGE (
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			PLANT_SITE_ID,
			ITEM_ID,
			CURRENCY,
			MEASURE,
			DOM_EXP,
			FCST_TYPE,
			INCOTERMS,
			YYYYMMDD,
			CELL_PROD_SITE_ID
		)
		SELECT
			DISTINCT AA.DIVISION_ID,
			AA.PROJECT_CODE,
			AA.SCM_SITE_ID,
			AA.PLANT_SITE_ID,
			AA.ITEM_ID,
			AA.CURRENCY,
			AA.MEASURE,
			AA.DOM_EXP,
			AA.FCST_TYPE,
			AA.INCOTERMS,
			AA.YYYYMMDD,
			AA.CELL_PROD_SITE_ID
		FROM (
			-- 기준데이터
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID,
				CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				'-' AS CELL_PROD_SITE_ID, --[DIV81] 컬럼 부재
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS RN
			--FROM SCM_MST_FUTURE_PRICE  A
			FROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
		) AA
		LEFT OUTER JOIN (
			-- 비교용 데이터 ( 다음주 )
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID, CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				'-' AS CELL_PROD_SITE_ID, --[DIV81] 컬럼 부재
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS RN
			--FROM SCM_MST_FUTURE_PRICE  A
			FROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND v_to_yyyymmdd2
		) BB
			ON AA.DIVISION_ID = BB.DIVISION_ID
			AND AA.PROJECT_CODE = BB.PROJECT_CODE
			AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID
			AND AA.ITEM_ID = BB.ITEM_ID
			AND AA.CURRENCY = BB.CURRENCY
			AND AA.MEASURE = BB.MEASURE
			AND AA.DOM_EXP = BB.DOM_EXP
			AND AA.FCST_TYPE = BB.FCST_TYPE
			AND AA.INCOTERMS = BB.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = BB.CELL_PROD_SITE_ID
			AND AA.RN = BB.RN + 1
		LEFT JOIN (
			-- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
			SELECT
				A.DIVISION_ID,
				A.PROJECT_CODE,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.ITEM_ID,
				A.CURRENCY,
				A.MEASURE,
				A.DOM_EXP,
				A.FCST_TYPE,
				A.INCOTERMS,
				A.PRICE,
				A.YYYYMMDD,
				'-' AS CELL_PROD_SITE_ID --[DIV81]
			--FROM SCM_MST_FUTURE_PRICE  A
			FROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/
			JOIN (
				SELECT
					DIVISION_ID,
					PROJECT_CODE,
					SCM_SITE_ID,
					PLANT_SITE_ID,
					ITEM_ID,
					CURRENCY,
					MEASURE,
					DOM_EXP,
					FCST_TYPE,
					INCOTERMS,
					'-' AS CELL_PROD_SITE_ID, --[DIV81] 컬럼 부재
					MAX(YYYYMMDD) AS YMD
				--FROM SCM_MST_FUTURE_PRICE  A
				FROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/
				WHERE DIVISION_ID = p_division_id
				AND MEASURE = 'LOC'
				AND YYYYMMDD < p_from_yyyymmdd
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
			) B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.YYYYMMDD = B.YMD
		) CC
			ON AA.DIVISION_ID = CC.DIVISION_ID
			AND AA.PROJECT_CODE = CC.PROJECT_CODE
			AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID
			AND AA.ITEM_ID = CC.ITEM_ID
			AND AA.CURRENCY = CC.CURRENCY
			AND AA.MEASURE = CC.MEASURE
			AND AA.DOM_EXP = CC.DOM_EXP
			AND AA.FCST_TYPE = CC.FCST_TYPE
			AND AA.INCOTERMS = CC.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = CC.CELL_PROD_SITE_ID
			AND AA.RN = 1
		JOIN (
			SELECT
				SEGMENT1 AS DIVISION_ID,
				SEGMENT2 AS LIMIT
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE  VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE'
		) L
			ON AA.DIVISION_ID = L.DIVISION_ID
		WHERE
			CASE WHEN AA.RN = 1  AND (AA.PRICE * L.LIMIT) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
		       WHEN AA.RN <> 1 AND (BB.PRICE * L.LIMIT) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
			   ELSE 'N'
		    END = 'Y'
		;
		ELSE
		INSERT INTO GTT_OVER_RANGE (
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			PLANT_SITE_ID,
			ITEM_ID,
			CURRENCY,
			MEASURE,
			DOM_EXP,
			FCST_TYPE,
			INCOTERMS,
			YYYYMMDD,
			CELL_PROD_SITE_ID
		)
		SELECT
			DISTINCT AA.DIVISION_ID,
			AA.PROJECT_CODE,
			AA.SCM_SITE_ID,
			AA.PLANT_SITE_ID,
			AA.ITEM_ID,
			AA.CURRENCY,
			AA.MEASURE,
			AA.DOM_EXP,
			AA.FCST_TYPE,
			AA.INCOTERMS,
			AA.YYYYMMDD,
			AA.CELL_PROD_SITE_ID
		FROM (
			-- 기준데이터
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID,
				CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				CELL_PROD_SITE_ID,
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD) AS RN
			--FROM SCM_MST_FUTURE_PRICE  A
			FROM DM_PLN_CFM_SELLING_PRICE A
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
		) AA
		LEFT OUTER JOIN (
			-- 비교용 데이터 ( 다음주 )
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID, CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				CELL_PROD_SITE_ID,
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD) AS RN
			--FROM SCM_MST_FUTURE_PRICE  A
			FROM DM_PLN_CFM_SELLING_PRICE A
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND v_to_yyyymmdd2
		) BB
			ON AA.DIVISION_ID = BB.DIVISION_ID
			AND AA.PROJECT_CODE = BB.PROJECT_CODE
			AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID
			AND AA.ITEM_ID = BB.ITEM_ID
			AND AA.CURRENCY = BB.CURRENCY
			AND AA.MEASURE = BB.MEASURE
			AND AA.DOM_EXP = BB.DOM_EXP
			AND AA.FCST_TYPE = BB.FCST_TYPE
			AND AA.INCOTERMS = BB.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = BB.CELL_PROD_SITE_ID
			AND AA.RN = BB.RN + 1
		LEFT JOIN (
			-- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
			SELECT
				A.DIVISION_ID,
				A.PROJECT_CODE,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.ITEM_ID,
				A.CURRENCY,
				A.MEASURE,
				A.DOM_EXP,
				A.FCST_TYPE,
				A.INCOTERMS,
				A.PRICE,
				A.YYYYMMDD,
				A.CELL_PROD_SITE_ID
			--FROM SCM_MST_FUTURE_PRICE  A
			FROM DM_PLN_CFM_SELLING_PRICE A
			JOIN (
				SELECT
					DIVISION_ID,
					PROJECT_CODE,
					SCM_SITE_ID,
					PLANT_SITE_ID,
					ITEM_ID,
					CURRENCY,
					MEASURE,
					DOM_EXP,
					FCST_TYPE,
					INCOTERMS,
					CELL_PROD_SITE_ID,
					MAX(YYYYMMDD) AS YMD
				--FROM SCM_MST_FUTURE_PRICE  A
				FROM DM_PLN_CFM_SELLING_PRICE A
				WHERE DIVISION_ID = p_division_id
				AND MEASURE = 'LOC'
				AND YYYYMMDD < p_from_yyyymmdd
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID
			) B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				AND A.YYYYMMDD = B.YMD
		) CC
			ON AA.DIVISION_ID = CC.DIVISION_ID
			AND AA.PROJECT_CODE = CC.PROJECT_CODE
			AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID
			AND AA.ITEM_ID = CC.ITEM_ID
			AND AA.CURRENCY = CC.CURRENCY
			AND AA.MEASURE = CC.MEASURE
			AND AA.DOM_EXP = CC.DOM_EXP
			AND AA.FCST_TYPE = CC.FCST_TYPE
			AND AA.INCOTERMS = CC.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = CC.CELL_PROD_SITE_ID
			AND AA.RN = 1
		JOIN (
			SELECT
				SEGMENT1 AS DIVISION_ID,
				SEGMENT2 AS LIMIT
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE  VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE'
		) L
			ON AA.DIVISION_ID = L.DIVISION_ID
		WHERE
			CASE WHEN AA.RN = 1  AND (AA.PRICE * L.LIMIT) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
		       WHEN AA.RN <> 1 AND (BB.PRICE * L.LIMIT) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
			   ELSE 'N'
		    END = 'Y'
		;
		END IF;  --[DIV81] B1



		/* TODO:GTT:GTT_OVER_RANGE_LIST-->GTT_OVER_RANGE_LIST */
		INSERT INTO GTT_OVER_RANGE_LIST
		SELECT
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			PLANT_SITE_ID,
			ITEM_ID,
			CURRENCY,
			MEASURE,
			DOM_EXP,
			FCST_TYPE,
			INCOTERMS,
			CELL_PROD_SITE_ID,
			REPLACE(NVL(1, NULL),',','')  || NVL(2, NULL)  || NVL(3, NULL)  || NVL(4, NULL) || NVL(5, NULL) || NVL(6, NULL) || NVL(7, NULL) || NVL(8, NULL) || NVL(9, NULL) || NVL(10, NULL)
				 || NVL(11, NULL) || NVL(12, NULL) || NVL(13, NULL) || NVL(14, NULL) || NVL(15, NULL) || NVL(16, NULL) || NVL(17, NULL) || NVL(18, NULL) || NVL(19, NULL) || NVL(20, NULL)
				 || NVL(21, NULL) || NVL(22, NULL) || NVL(23, NULL) || NVL(24, NULL) || NVL(25, NULL) || NVL(26, NULL) || NVL(27, NULL) || NVL(28, NULL) || NVL(29, NULL) || NVL(30, NULL)
				 || NVL(31, NULL) || NVL(32, NULL) || NVL(33, NULL) || NVL(34, NULL) || NVL(35, NULL) || NVL(36, NULL) || NVL(37, NULL) || NVL(38, NULL) || NVL(39, NULL) || NVL(40, NULL)
				 || NVL(41, NULL) || NVL(42, NULL) || NVL(43, NULL) || NVL(44, NULL) || NVL(45, NULL) || NVL(46, NULL) || NVL(47, NULL) || NVL(48, NULL) || NVL(49, NULL) || NVL(50, NULL)
				 || NVL(51, NULL) || NVL(52, NULL) AS COL_LIST
		FROM (
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID,
				CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				CELL_PROD_SITE_ID,
				',W_' || YYYYMMDD AS YYYYMMDD,
				ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD) AS ROW_NUM
			FROM GTT_OVER_RANGE
		) A
		PIVOT (
			MAX(YYYYMMDD) AS UNPVT FOR ROW_NUM IN ( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52 )
		)
		;

	END IF;


	--[C20200506-000201] 속도개선 임시테이블 GTT_DM_MST_ITEM_SINGLE_V, GTT_PLAN_DATA 추가

	/* TODO:GTT:GTT_DM_MST_ITEM_SINGLE_V-->GTT_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GTT_DM_MST_ITEM_SINGLE_V
	SELECT *
	FROM DM_MST_ITEM_SINGLE_V
	WHERE DIVISION_ID = p_division_id;

	/* TODO:GTT:GTT_PLAN_DATA-->GTT_PLAN_DATA */
	IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] B2: 81 테이블 분기 (하단 ELSE=40 원문 무수정)
	INSERT INTO GTT_PLAN_DATA (
		DIVISION_ID,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		PROJECT_CODE,
		ITEM_ID,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		CELL_PROD_SITE_ID
	)
	SELECT
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		'-' AS CELL_PROD_SITE_ID --[DIV81] 컬럼 부재
	FROM SCM_MST_FUTURE_PRICE A /*[DIV81] 원본 주석 테이블 복원*/
	WHERE 1 = 1
	AND A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
	AND CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_division_id') P
		WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.TOKEN
	)
	AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') P
		WHERE (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.TOKEN
	)
	AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id') P
		WHERE (CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.TOKEN
	)
	-- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (START)
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE B
		WHERE A.DIVISION_ID = B.DIVISION_ID
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND B.VALID_YN = 'Y'
	)
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE_ITEM B
		WHERE A.DIVISION_ID	= B.DIVISION_ID
		AND A.PROJECT_CODE = B.PROJECT_CODE
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND A.ITEM_ID = B.ITEM_ID
		AND B.VALID_YN = 'Y' -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (END)
	)
	GROUP BY
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP --[DIV81] CELL_PROD 그룹 제거
	;
	ELSE
	INSERT INTO GTT_PLAN_DATA (
		DIVISION_ID,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		PROJECT_CODE,
		ITEM_ID,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		CELL_PROD_SITE_ID
	)
	SELECT
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		A.CELL_PROD_SITE_ID
	FROM DM_PLN_CFM_SELLING_PRICE A
	WHERE 1 = 1
	AND A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
	AND CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_division_id') P
		WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.TOKEN
	)
	AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') P
		WHERE (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.TOKEN
	)
	AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id') P
		WHERE (CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.TOKEN
	)
	-- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (START)
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE B
		WHERE A.DIVISION_ID = B.DIVISION_ID
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND B.VALID_YN = 'Y'
	)
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE_ITEM B
		WHERE A.DIVISION_ID	= B.DIVISION_ID
		AND A.PROJECT_CODE = B.PROJECT_CODE
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND A.ITEM_ID = B.ITEM_ID
		AND B.VALID_YN = 'Y' -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (END)
	)
	GROUP BY
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		A.CELL_PROD_SITE_ID
	;
	END IF;  --[DIV81] B2

	--SELECT * FROM GTT_PLAN_DATA WHERE DIVISION_ID = '81' AND SCM_SITE_ID = 'Porsche_DE_AAH' AND PROJECT_CODE = 'A15PE4001' AND ITEM_ID = 'ACEH1072I-A1' RETURN;

	-- [2026-07-13 멀티선택 룰] PROJECT/OWNER 멀티선택 값을 사전 GTT 적재.
	--   ALL/빈값 = 미적재 → 아래 조인에서 조건 skip(match-all). 값 존재 = INNER JOIN LIKE. (단일 param split → 1회, 저비용)
	DELETE FROM SCM_MGR.GT_DMF0082_SP_FILTER;
	INSERT INTO SCM_MGR.GT_DMF0082_SP_FILTER (FILTER_TYPE, FILTER_VALUE)
		SELECT 'PROJECT', TOKEN FROM TABLE(fn_string_split(p_project_code, ','))
		WHERE p_project_code IS NOT NULL AND p_project_code <> 'ALL';
	INSERT INTO SCM_MGR.GT_DMF0082_SP_FILTER (FILTER_TYPE, FILTER_VALUE)
		SELECT 'OWNER', TOKEN FROM TABLE(fn_string_split(p_owner, ','))
		WHERE p_owner IS NOT NULL AND p_owner <> 'ALL';

	-- [2026-07-13] PJT 원본을 물리 GTT에 1회 실현 (인라인 subquery/CTE = 옵티마이저가 OUTER APPLY decorrelate → 184M 카테시안 폭발.
	--   물리 GTT + 실 stats → 정상 hash join). division 필터로 최소화. 분기2 OWNER split = OUTER APPLY(안티패턴#51, 격리 실행 0.2s).
	DELETE FROM SCM_MGR.GT_DMF0082_PJT;
	INSERT INTO SCM_MGR.GT_DMF0082_PJT (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS, BIZ_TYPE, SCM_SITE_ID, ITEM_ID, DEPT_ID, DEPT_NAME_KO, USER_ID, USER_NAME, USER_NAME_EN)
	SELECT B.DIVISION_ID, B.PROJECT_CODE, B.PROJECT_NAME, B.PROJECT_OWNER, B.PROJECT_STATUS, B.BIZ_TYPE, '', '', '', '', SU.USER_ID, SU.USER_NAME, SU.USER_NAME_EN
	FROM SCM_MST_PROJECT B, SCM_MST_SSO_USER_INFO SU
	WHERE B.DIVISION_ID <> '40' AND B.DIVISION_ID = p_division_id AND UPPER(TRIM(B.PROJECT_OWNER)) = UPPER(TRIM(SU.USER_ID)) /* 2026.08.14 AJS MSSQL CI collation 대응 */
	UNION
	SELECT SI.DIVISION_ID, SI.PROJECT_CODE, '', SUBSTR(SI.OWNER,1,20), '', '', SI.SCM_SITE_ID, SI.ITEM_ID, SU.DEPT_ID, TM.DEPT_NAME_KO, SU.USER_ID, SU.USER_NAME, SU.USER_NAME_EN
	FROM SCM_MST_SITE_ITEM SI
		OUTER APPLY (SELECT TOKEN FROM TABLE(fn_string_split(SI.OWNER, ',')) WHERE ROWNUM = 1) OT  /* 2026.08.15 AJS 신뢰도검사 발견4 : MSSQL 원본 390행 top 1 등가 */
		LEFT JOIN SCM_MST_SSO_USER_INFO SU ON UPPER(TRIM(SU.USER_ID)) = UPPER(TRIM(OT.TOKEN)) /* 2026.08.14 AJS 동일 사유 */
		LEFT JOIN SCM_MST_SSO_DEPT_INFO TM ON SU.DEPT_ID = TM.DEPT_ID
	WHERE SI.DIVISION_ID = '40' AND p_division_id = '40';
	-- (물리 GTT = Oracle 자동 dynamic sampling으로 실 cardinality 추정 → 카테시안 오추정 회피. DBMS_STATS는 내부 COMMIT로 타 GTT wipe 위험이라 미사용)

	/* TODO:GTT:GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE-->GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE */
	INSERT INTO GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE (
		DIVISION_ID,
		DIVISION_NAME,
		UPPER_DEPT_ID,
		DEPT_ID,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		SITE_DESCRIPTION,
		END_CUSTOMER,
		-- [2026-07-13] INSERT 컬럼목록↔SELECT 순서 어긋남(변환버그): SELECT 9~13=A.PROJECT_CODE/PJT.PROJECT_NAME/BIZ_TYPE/PROJECT_STATUS/PROJECT_OWNER
		--   → 컬럼명 의미에 맞게 재정렬(PROJECT_OWNER를 PROJECT_STATUS 뒤로). 구 순서=PROJECT_CODE(22자)가 PROJECT_OWNER(20자) 유입→ORA-12899.
		PROJECT_CODE,
		PROJECT_NAME,
		BIZ_TYPE_NAME,
		PROJECT_STATUS,
		PROJECT_OWNER,
		ITEM_ID,
		ITEM_CLASS_NAME,
		ITEM_NAME,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		AUTHORITY_YN,
		NICK_NAME,
		CELL_PROD_SITE_ID
	)
	SELECT
		A.DIVISION_ID,
		B.DIVISION_NAME,
   DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
   --TEAM.DEPT_ID,			--20180625
   CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END DEPT_ID,
   --CASE WHEN NVL(TEAM.DEPT_NAME_KO, NULL) IS NULL THEN '' ELSE RIGHT(NVL(TEAM.DEPT_NAME_KO, NULL), INSTR(REVERSE(NVL(TEAM.DEPT_NAME_KO,'', '.'))) -1) END AS TEAM_INCHARGE,
   A.SCM_SITE_ID,
   A.PLANT_SITE_ID,
   C.SITE_DESCRIPTION,
   NVL(C.END_CUSTOMER, NULL) AS END_CUSTOMER,
   A.PROJECT_CODE,
   PJT.PROJECT_NAME,
   PJT.BIZ_TYPE as BIZ_TYPE_NAME,
   --PJT.BIZ_TYPE_NAME,
   PJT.PROJECT_STATUS,
   PJT.PROJECT_OWNER,
   A.ITEM_ID,
   ITEM.ITEM_CLASS_NAME,
   NVL(ITEM.ITEM_NAME, NULL)AS ITEM_NAME,
   A.INCOTERMS,
   --SITE_ITEM.CURRENCY,
   A.CURRENCY,
   A.FCST_TYPE,
   A.DOM_EXP,
   --MEASURE.LOOKUP_CODE AS MEASURE,
   --MEASURE.DISPLAY_SEQ,
   --CASE WHEN (RTRIM(TEAM.DEPT_ID) = RTRIM(v_dept_id) OR v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
   CASE WHEN ((FN_GET_DEPT_LIST(p_created_by,
		--TEAM.DEPT_ID
		CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
		) = 'Y') OR v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
   --,A.YYYYMMDD
   ,ITEM.NICK_NAME --20180711
   --,A.PRICE
   ,A.CELL_PROD_SITE_ID
FROM GTT_PLAN_DATA A
	INNER JOIN SCM_MST_DIVISION B
		ON A.DIVISION_ID = B.DIVISION_ID
		AND B.VALID_YN = 'Y'

	INNER JOIN SCM_MST_SITE C
		ON	A.DIVISION_ID = C.DIVISION_ID
		AND A.SCM_SITE_ID = C.SCM_SITE_ID
		AND C.SITE_TYPE = 'SALES'
		AND C.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SITE D
		ON	A.DIVISION_ID = D.DIVISION_ID
		AND A.SCM_SITE_ID = D.SCM_SITE_ID
		AND C.SITE_TYPE = 'PLANT'
		AND D.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
--		ON C.DEPT_ID = TEAM.DEPT_ID  2026-05-20 전병주 SCM_MST_SITE 테이블에 DEPT_ID 없어서 일단 주석처리
		-- [2026-07-13] 조인키 부재('일단 주석처리') → 전체 유효부서(2만+)와 카테시안 → GROUP BY TEAM.DEPT_ID로 출력 2만배 뻥튀기+112M행 폭발.
		--   div40은 DEPT_ID=PJT.DEPT_ID 사용(TEAM 미사용) → div40만 TEAM 조인 차단(카테시안 제거). 비40은 기존 동작 그대로 유지(무회귀).
		ON C.DEPT_ID = TEAM.DEPT_ID AND TEAM.VALID_YN = 'Y' /* 2026.08.14 AJS 조인키 복원 */

	LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT
		ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
		AND DEPRTMENT.VALID_YN = 'Y'

	INNER JOIN GTT_DM_MST_ITEM_SINGLE_V ITEM
		ON	A.DIVISION_ID = ITEM.DIVISION_ID
		AND A.ITEM_ID  = ITEM.ITEM_ID
	-- [2026-07-13] PJT = 물리 GTT(GT_DMF0082_PJT)에 1회 사전 실현 후 hash join (구: 인라인 subquery/CTE → 옵티마이저 decorrelate 184M 카테시안 폭발)
	LEFT JOIN GT_DMF0082_PJT PJT
		ON	A.DIVISION_ID = PJT.DIVISION_ID
		AND A.PROJECT_CODE = PJT.PROJECT_CODE
		AND CASE WHEN p_division_id = '40' THEN PJT.SCM_SITE_ID ELSE A.SCM_SITE_ID END =  A.SCM_SITE_ID    -- modified by ytchoi 180802
		AND CASE WHEN p_division_id = '40' THEN PJT.ITEM_ID ELSE A.ITEM_ID END = A.ITEM_ID

	LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM  WHERE VALID_YN = 'Y') SITE_ITEM
		ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID
		AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
		AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID
		AND SITE_ITEM.ITEM_ID = A.ITEM_ID

	LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO	--20180724
		ON SITE_ITEM.OWNER = USER_INFO.USER_ID
		-------------------------- Project --------------2018/07/30  Son Young Suk---------------------
			-- [2026-07-13 멀티선택 룰] ALL/빈값=조건 skip(match-all) / 값존재=GTT LIKE INNER JOIN. GROUP BY dedup.
			INNER JOIN ( SELECT '%' || FILTER_VALUE || '%' tst FROM SCM_MGR.GT_DMF0082_SP_FILTER WHERE FILTER_TYPE = 'PROJECT'
			             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_project_code IS NULL OR p_project_code = 'ALL') ) b1
			ON      (p_project_code IS NULL OR p_project_code = 'ALL')
			OR      PJT.PROJECT_CODE  like  b1.tst
			OR      PJT.PROJECT_NAME  like  b1.tst
		-- --------------------------------------------------------------------------------------------
	------------  20180806  -------------------------------------------------------------------
	-- [2026-07-13 멀티선택 룰] ALL/빈값=조건 skip(match-all) / 값존재=GTT owner LIKE INNER JOIN.
	--   Oracle ''=NULL 버그(구: p_owner=''/p_owner<>'' → UNKNOWN → 항상 0행) 교정. 미사용 LEFT JOIN UI 제거.
	INNER JOIN (
		SELECT
			DISTINCT X.OWNER
		FROM SCM_MST_SITE_ITEM X
		INNER JOIN (
			SELECT '%' || FILTER_VALUE || '%' tst FROM SCM_MGR.GT_DMF0082_SP_FILTER WHERE FILTER_TYPE = 'OWNER'
		) C
			ON (
					FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') LIKE C.tst
					OR
					X.OWNER LIKE C.tst
					OR
					FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') LIKE  C.tst
			)
		WHERE X.DIVISION_ID = p_division_id
		AND NOT (p_owner IS NULL OR p_owner = 'ALL')

		UNION ALL

		SELECT '11' FROM dual
		WHERE (p_owner IS NULL OR p_owner = 'ALL')
	) X
		ON  (p_owner IS NULL OR p_owner = 'ALL')
		OR  NVL(SITE_ITEM.OWNER,'xxxx') = X.owner
	-- --------------------------------------------------------------------------------------------
	/*CROSS JOIN
	(
	SELECT  COLUMN_NAME AS LOOKUP_CODE,
			COLUMN_LABEL_NAME AS DESCRIPTION,
			SORT_ORDER_NO AS DISPLAY_SEQ
	FROM     SCM_MST_SHEET_MEASURE
		WHERE  (PROGRAM_ID = p_program_id AND SHEET_NAME = 'Sales Price')
				AND COLUMN_NAME <> 'LOC'

	UNION

	SELECT  COLUMN_NAME AS LOOKUP_CODE,
			COLUMN_LABEL_NAME AS DESCRIPTION,
			SORT_ORDER_NO AS DISPLAY_SEQ
	FROM     SCM_MST_SHEET_MEASURE
		WHERE  (PROGRAM_ID = p_program_id AND SHEET_NAME = 'Sales Price')
				AND COLUMN_NAME = 'LOC'
	) AS MEASURE*/

	WHERE CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		ELSE
			CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID
			ELSE TEAM.DEPT_ID END
		END IN (
			SELECT
				*
			FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_dept_id') P
			WHERE (
				CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
				ELSE
					CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID
					ELSE TEAM.DEPT_ID END
				END
			) = P.TOKEN
		)
		AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
			ELSE NVL(CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END, NULL)
			END IN (
				SELECT
					*
				FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_end_customer') P
				WHERE CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END, NULL) END = P.TOKEN
			)
		AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'  --20180822
			ELSE CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
			END IN (
					SELECT
						*
					FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_biztype') P
					WHERE CASE WHEN p_biztype = 'ALL' THEN 'ALL'
						ELSE CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
						END = P.TOKEN
           )
		GROUP BY
			A.DIVISION_ID,
			B.DIVISION_NAME,
			DEPRTMENT.DEPT_ID,
			TEAM.DEPT_ID,
			PJT.DEPT_ID,
			A.SCM_SITE_ID,
			A.PLANT_SITE_ID,
			C.SITE_DESCRIPTION,
			NVL(C.END_CUSTOMER, NULL),
			A.PROJECT_CODE,
			PJT.PROJECT_NAME,
			PJT.BIZ_TYPE,
			PJT.PROJECT_STATUS,
			PJT.PROJECT_OWNER,
			A.ITEM_ID,
			ITEM.ITEM_CLASS_NAME,
			NVL(ITEM.ITEM_NAME, NULL),
			A.INCOTERMS,
			A.FCST_TYPE,
			A.DOM_EXP,
			A.CURRENCY,
			--MEASURE.LOOKUP_CODE,
			--MEASURE.DISPLAY_SEQ,
			--CASE WHEN RTRIM(TEAM.DEPT_ID) = RTRIM(v_dept_id) THEN 'Y' ELSE 'N' END  --20200312 KHSONG v_dept_id 값이 셋팅되는 곳이 없어서 필요없는 조건으로 주석처리
			--A.YYYYMMDD,
			ITEM.NICK_NAME,
			A.CELL_PROD_SITE_ID
		;
		--SELECT * FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE WHERE DIVISION_ID = '81' AND SCM_SITE_ID = 'Porsche_DE_AAH' AND PROJECT_CODE = 'A15PE4001' AND ITEM_ID = 'ACEH1072I-A1' RETURN;


		-- 1. 실데이타와 조인

		-- PJ20200138 범위 초과 대상
		IF (p_over_range = 'Y') THEN
		    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] B3: 81 테이블 분기 (하단 ELSE=40 원문 무수정)
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, C.COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			INNER JOIN SCM_MST_FUTURE_PRICE B /*[DIV81]*/
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
			    --AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				--AND A.YYYYMMDD = B.YYYYMMDD
			INNER JOIN GTT_OVER_RANGE_LIST C
				ON A.DIVISION_ID = C.DIVISION_ID
				AND A.PROJECT_CODE = C.PROJECT_CODE
				AND A.SCM_SITE_ID = C.SCM_SITE_ID
				AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
				AND A.ITEM_ID = C.ITEM_ID
				AND A.CURRENCY = C.CURRENCY
				--AND A.MEASURE = C.MEASURE
				AND A.DOM_EXP = C.DOM_EXP
				AND A.FCST_TYPE = C.FCST_TYPE
				AND A.INCOTERMS = C.INCOTERMS
				AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
				--AND A.YYYYMMDD = C.YYYYMMDD
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			-- [2026-07-13 멀티선택 룰] ALL/빈값=조건 skip(match-all) / 값존재=split LIKE INNER JOIN. (구: NULL LIKE + split('')=0행 → 0행 버그)
			INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE  b2.tst
				OR A.NICK_NAME  LIKE  b2.tst
				-- --------------------------------------------------------------------------------------------
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
			ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
			; --PJ20200138 속도개선
		    ELSE
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, C.COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			INNER JOIN DM_PLN_CFM_SELLING_PRICE B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
			    --AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				--AND A.YYYYMMDD = B.YYYYMMDD
			INNER JOIN GTT_OVER_RANGE_LIST C
				ON A.DIVISION_ID = C.DIVISION_ID
				AND A.PROJECT_CODE = C.PROJECT_CODE
				AND A.SCM_SITE_ID = C.SCM_SITE_ID
				AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
				AND A.ITEM_ID = C.ITEM_ID
				AND A.CURRENCY = C.CURRENCY
				--AND A.MEASURE = C.MEASURE
				AND A.DOM_EXP = C.DOM_EXP
				AND A.FCST_TYPE = C.FCST_TYPE
				AND A.INCOTERMS = C.INCOTERMS
				AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
				--AND A.YYYYMMDD = C.YYYYMMDD
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			-- [2026-07-13 멀티선택 룰] ALL/빈값=조건 skip(match-all) / 값존재=split LIKE INNER JOIN. (구: NULL LIKE + split('')=0행 → 0행 버그)
			INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE  b2.tst
				OR A.NICK_NAME  LIKE  b2.tst
				-- --------------------------------------------------------------------------------------------
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
			ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
			; --PJ20200138 속도개선
		    END IF;  --[DIV81] B3
		ELSE
		    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] B4: 81 테이블 분기 (하단 ELSE=40 원문 무수정)
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, '' AS COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			--JOIN SCM_MST_FUTURE_PRICE B
			INNER JOIN SCM_MST_FUTURE_PRICE B /*[DIV81]*/
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				--AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				--AND A.YYYYMMDD = B.YYYYMMDD
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			-- [2026-07-13 멀티선택 룰] ALL/빈값=조건 skip(match-all) / 값존재=split LIKE INNER JOIN. (구: NULL LIKE + split('')=0행 → 0행 버그)
			INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			            UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE b2.tst
				OR A.NICK_NAME  LIKE b2.tst
				-- --------------------------------------------------------------------------------------------
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
				ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd; --PJ20200138 속도개선
		    ELSE
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, '' AS COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			--JOIN SCM_MST_FUTURE_PRICE B
			INNER JOIN DM_PLN_CFM_SELLING_PRICE B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				--AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				--AND A.YYYYMMDD = B.YYYYMMDD
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			-- [2026-07-13 멀티선택 룰] ALL/빈값=조건 skip(match-all) / 값존재=split LIKE INNER JOIN. (구: NULL LIKE + split('')=0행 → 0행 버그)
			INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			            UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE b2.tst
				OR A.NICK_NAME  LIKE b2.tst
				-- --------------------------------------------------------------------------------------------
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
				ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd; --PJ20200138 속도개선
		    END IF;  --[DIV81] B4
		END IF;

		-- --------------------------------------------------------------------------------------------
		------ 월 데이터 평균 값 산정
		----INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
		----SELECT
		----		A.DIVISION_ID,
		----		A.DIVISION_NAME,
		----		A.UPPER_DEPT_ID,
		----		A.DEPT_ID	,
		----		A.SCM_SITE_ID,
		----		A.PLANT_SITE_ID,
		----		A.SITE_DESCRIPTION,
		----		A.END_CUSTOMER,
		----		A.PROJECT_CODE AS END_CUSTOMER40,
		----		A.PROJECT_CODE,
		----		A.PROJECT_NAME,
		----		A.BIZ_TYPE_NAME,
		----		A.PROJECT_STATUS,
		----		A.ITEM_ID,
		----		A.ITEM_CLASS_NAME,
		----		A.ITEM_NAME,
		----		A.INCOTERMS,
		----		A.CURRENCY,
		----		A.FCST_TYPE,
		----		A.DOM_EXP,
		----		A.MEASURE,
		----		A.DISPLAY_SEQ,
		----		A.AUTHORITY_YN,
		----		'M_' + SUBSTR(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6) + '01' AS YYYYMMDD,
		----		--MIN(NVL(PRICE, 0)) AS PRICE
		----		SUM(NVL(PRICE, 0)) / COUNT(YYYYMMDD) AS PRICE
		----		, A.NICK_NAME
		----		, A.COL_LIST --PJ20200138 범위를 초과하는 YYYYMMDD List
		----FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE A
		----group by A.DIVISION_ID,
		----		A.DIVISION_ID,
		----		A.DIVISION_NAME,
		----		A.UPPER_DEPT_ID,
		----		A.DEPT_ID	,
		----		A.SCM_SITE_ID,
		----		A.PLANT_SITE_ID,
		----		A.SITE_DESCRIPTION,
		----		A.END_CUSTOMER,
		----		A.END_CUSTOMER40,
		----		A.PROJECT_CODE,
		----		A.PROJECT_NAME,
		----		A.BIZ_TYPE_NAME,
		----		A.PROJECT_STATUS,
		----		A.ITEM_ID,
		----		A.ITEM_CLASS_NAME,
		----		A.ITEM_NAME,
		----		A.INCOTERMS,
		----		A.CURRENCY,
		----		A.FCST_TYPE,
		----		A.DOM_EXP,
		----		A.MEASURE,
		----		A.DISPLAY_SEQ,
		----		A.AUTHORITY_YN,
		----		A.NICK_NAME,
		----		A.COL_LIST, --PJ20200138 범위를 초과하는 YYYYMMDD List
		----		SUBSTR(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6)

	/* tmpPlanData 에 대한 처리들  */
	-- @Prod에 기존 값이 비어있거나(NULL) 처음 시작하는 경우의 오라클 전환 쿼리

	SELECT LISTAGG('''' || A.YYYYMMDD || ''' AS "' || A.YYYYMMDD || '"', ',') WITHIN GROUP (ORDER BY YYYYMMDD) -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정
	     , LISTAGG('"' || A.YYYYMMDD || '"', ',') WITHIN GROUP (ORDER BY YYYYMMDD)
	INTO V_Prod, V_Prod_Cols
	FROM (
	    SELECT DISTINCT YYYYMMDD FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE
	) A;

	-- 만약 조회된 데이터가 없어서 V_Prod가 완전히 비어있다면 대치값 할당
	IF V_Prod IS NULL THEN
	    V_Prod := '''D_99999999'' AS "D_99999999"'; V_Prod_Cols := '"D_99999999"'; -- [FIX 2026-07-12] MSSQL bracket PIVOT / '+' concat 잔재 교정
	END IF;


	--Start [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
	IF p_division_id = '82' AND p_invalid_exec = 'N' THEN

		/* TODO:GTT:GTT_SALES_SITE_MODEL_ALL-->GTT_SALES_SITE_MODEL_ALL */
		INSERT INTO GTT_SALES_SITE_MODEL_ALL -- 2026.08.13 AJS 컬럼목록 명시(테이블 순서와 SELECT 순서 불일치 -> 값 밀림)
		( DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40
		, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, SALES_PLAN_ADJUST_YN
		, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY )
		SELECT
			SITE_PROJECT.DIVISION_ID,
			TEAM.DEPT_ID, -- 2026.08.14 AJS 빈값('')=NULL 이라 최종 LEFT JOIN a.dept_id=b.dept_id 전부 불일치 -> 실제 부서 복원
			SITE.END_CUSTOMER,
			SITE.END_CUSTOMER AS END_CUSTOMER40,
			SITE_PROJECT.SCM_SITE_ID,
			SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
			SITE_PROJECT.PROJECT_CODE,
			PJT.PROJECT_NAME,
			PJT.PROJECT_STATUS,
			SITE_ITEM.SALES_PLAN_ADJUST_YN,
			SITE_ITEM.ITEM_CLASS_NAME,
			SITE_ITEM.ITEM_ID,
			SITE_ITEM.ITEM_NAME,
			SITE_ITEM.NICK_NAME,
			SITE_ITEM.CURRENCY
		FROM (
			SELECT
				DISTINCT A.DIVISION_ID,
				SCM_SITE_ID,
				PROJECT_CODE,
				NVL(MAX(VALID_YN),'Y') AS VALID_YN
			FROM SCM_MST_SITE_ITEM A
			INNER JOIN SCM_MST_ITEM_SN B
				ON A.ITEM_ID = B.ITEM_ID
			GROUP BY A.DIVISION_ID, SCM_SITE_ID, PROJECT_CODE
		) SITE_PROJECT
		LEFT JOIN SCM_MST_PROJECT PJT
			ON SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
			AND	SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
		LEFT JOIN SCM_MST_SITE SITE
			ON SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
			AND	SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
		LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM -- 2026.08.14 AJS 조인 복원
			ON SITE.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
			SELECT
				T1.DIVISION_ID,
				T1.SCM_SITE_ID,
				T1.PROJECT_CODE,
				T1.ITEM_ID,
				T2.ITEM_NAME,
				T2.ITEM_TYPE,
				T2.ITEM_CLASS_NAME,
				T1.SALES_PLAN_ADJUST_YN,
				T2.NICK_NAME,
				T1.CURRENCY,
				T1.VALID_YN,
				T1.OWNER,
				T1.PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			FROM SCM_MST_SITE_ITEM		T1
			INNER JOIN DM_MST_ITEM_SINGLE_V	T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
				AND	T1.ITEM_ID = T2.ITEM_ID
			WHERE (T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
				OR T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END
			)
		) SITE_ITEM
			ON SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
			AND	SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
			AND	SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
		LEFT JOIN SCM_MST_SITE_CUSTOMER SITE_CUST
			ON SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
			AND SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
			AND	SITE_CUST.REP_YN      = 'Y'
		LEFT JOIN SCM_MST_CUSTOMER CUST
			ON SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
			AND SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
			AND	SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
		LEFT JOIN (
			SELECT
				DIVISION_ID,
				MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
				SCM_SITE_ID,
				PROJECT_CODE,
				ITEM_ID
			FROM DM_MST_CUSTOMER_MODEL
			WHERE  VALID_YN = 'Y'
			GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
		) CUST_ITEM
			ON SITE_ITEM.ITEM_ID = CUST_ITEM.ITEM_ID
			AND	SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
			AND	SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
			AND SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID
		LEFT JOIN SCM_MST_SSO_USER_INFO SU
			ON SITE_ITEM.owner = SU.USER_ID
		INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
				UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL')) b -- 2026.08.13 AJS 빈값=전체통과
			ON (p_item_id IS NULL OR p_item_id = 'ALL') -- 2026.08.13 AJS
			OR SITE_ITEM.ITEM_ID   LIKE b.tst
			OR SITE_ITEM.NICK_NAME LIKE b.tst
		INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_project_code,','))
				UNION ALL SELECT '%' tst FROM DUAL WHERE (p_project_code IS NULL OR p_project_code = 'ALL')) b1 -- 2026.08.13 AJS 빈값=전체통과
			ON (p_project_code IS NULL OR p_project_code = 'ALL') -- 2026.08.13 AJS
			OR PJT.PROJECT_CODE LIKE b1.tst
			OR PJT.PROJECT_NAME LIKE b1.tst
		INNER JOIN (
			SELECT
				DISTINCT X.OWNER
			FROM SCM_MST_SITE_ITEM X
			LEFT JOIN SCM_MST_SSO_USER_INFO UI
				ON X.PROJECT_CODE = UI.USER_ID
			INNER JOIN ( SELECT '%' || token || '%' /* 2026.08.13 AJS */ tst FROM TABLE(fn_string_split(p_owner,',')) ) c
				ON (CASE WHEN p_owner IS NULL THEN p_owner ELSE FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') END like  c.tst
				OR CASE WHEN p_owner IS NULL THEN p_owner ELSE X.OWNER END like  c.tst
				OR CASE WHEN p_owner IS NULL THEN p_owner ELSE FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') END like  c.tst
			)
			WHERE X.DIVISION_ID = p_division_id
			AND p_owner IS NOT NULL AND p_owner <> 'ALL' -- 2026.08.13 AJS ''비교는 Oracle 에서 항상 UNKNOWN
			UNION all
			SELECT '11' FROM dual WHERE (p_owner IS NULL OR p_owner = 'ALL') -- 2026.08.13 AJS
		) X
			ON NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN p_owner IS NULL THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
		WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
		AND CASE WHEN p_division_id = 'ALL' THEN p_division_id
			ELSE SITE_PROJECT.DIVISION_ID
 			END IN (SELECT token FROM TABLE(fn_string_split(p_division_id,',')))
		AND CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
--			ELSE TEAM.DEPT_ID     2026.05.19 전병주 SCM_MST_SITE 에 DEPT_ID 컬럼이 없어서 주석처리
 			END IN ( SELECT token FROM TABLE(fn_string_split(p_dept_id,',')) )
		AND CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
			ELSE SITE.END_CUSTOMER
 			END IN ( SELECT token FROM TABLE(fn_string_split(p_end_customer,',')) )
		AND CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
			ELSE SITE_PROJECT.SCM_SITE_ID  -- 20181220 KHSONG modify SITE_ITEM.SCM_SITE_ID -> SITE_PROJECT.SCM_SITE_ID
 			END IN ( SELECT token FROM TABLE(fn_string_split(p_scm_site_id,',')) )
		AND SITE.SITE_TYPE <> 'PLANT'
		;


		/* TODO:GTT:GTT_SALES_SITE_MODEL-->GTT_SALES_SITE_MODEL */
		INSERT INTO GTT_SALES_SITE_MODEL
		SELECT
			DIVISION_ID,
			DEPT_ID,
			END_CUSTOMER,
			END_CUSTOMER40,
			SCM_SITE_ID,
			SCM_SITE_ID40,
			PROJECT_CODE,
			PROJECT_NAME,
			PROJECT_STATUS,
			SALES_PLAN_ADJUST_YN,
			ITEM_CLASS_NAME,
			ITEM_ID,
			ITEM_NAME,
			NICK_NAME,
			CURRENCY,
			B.MEASURE,
			B.DISPLAY_SEQ
		FROM GTT_SALES_SITE_MODEL_ALL a
		CROSS JOIN (
			SELECT
				COLUMN_NAME AS MEASURE,
				COLUMN_LABEL_NAME AS DESCRIPTION,
				SORT_ORDER_NO AS DISPLAY_SEQ
			FROM SCM_MST_SHEET_MEASURE
			WHERE PROGRAM_ID = 'DMF0082'
			AND SHEET_NAME = 'FcstNPrice'
		) b
		;

		v_nsql := '
			SELECT * FROM (   /* 2026.08.13 AJS 인라인뷰 개시 누락 복원 */
			SELECT a.DIVISION_ID,
				b.DIVISION_NAME,
				b.UPPER_DEPT_ID,
				a.DEPT_ID	,
				a.SCM_SITE_ID,
				b.PLANT_SITE_ID,
				b.SITE_DESCRIPTION,
				a.END_CUSTOMER,
				b.END_CUSTOMER40,
				a.PROJECT_CODE,
				a.PROJECT_NAME,
				b.BIZ_TYPE_NAME,
				a.PROJECT_STATUS,
				a.ITEM_ID,
				a.ITEM_CLASS_NAME,
				a.ITEM_NAME,
				b.INCOTERMS,
				(CASE WHEN division_name is null THEN a.CURRENCY
					  ELSE b.CURRENCY
				 END) AS CURRENCY, --[C20200702-000136] ESS사업부 조회 구간 Currency 변경
				b.FCST_TYPE,
				b.DOM_EXP,
				(CASE WHEN division_name is null THEN (
					CASE WHEN ((FN_GET_DEPT_LIST( '''|| p_created_by ||''', a.DEPT_ID ) = ''Y'')  OR '''|| v_group_id ||''' =''ADMIN'') THEN ''Y''
					ELSE ''N''
					END)
				ELSE b.AUTHORITY_YN
				END) AS AUTHORITY_YN,
				a.DISPLAY_SEQ,
				a.NICK_NAME,
				b.CELL_PROD_SITE_ID, /* 2026.08.14 AJS 콤마 누락 */
				b.COL_LIST,
				(CASE WHEN division_name is null THEN ''Y'' ELSE ''N'' END) AS NEW_FLAG,
				a.MEASURE,
				b.PRICE,
				b.YYYYMMDD
			FROM GTT_SALES_SITE_MODEL A
			LEFT JOIN GTT_MST_FUTURE_PRICE_SAVE_PRICE B
				ON ( a.division_id =  b.division_id
					AND a.dept_id = b.dept_id
					AND a.scm_site_id = b.scm_site_id
					AND a.item_id = b.item_id
					AND a.project_code = b.project_code
					AND a.measure = b.measure
				)
			WHERE A.MEASURE = ''LOC''
			) T
			PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod || ')
			)
			ORDER BY
				DIVISION_ID,
				division_name,
				DEPT_ID,
				END_CUSTOMER,
				SCM_SITE_ID,
				PROJECT_CODE,
				PROJECT_STATUS,
				BIZ_TYPE_NAME,
				ITEM_ID,
				ITEM_CLASS_NAME,
				ITEM_NAME,
				INCOTERMS,
				FCST_TYPE,
				DOM_EXP,
				CURRENCY,
				PLANT_SITE_ID,
				CELL_PROD_SITE_ID,
				DISPLAY_SEQ,
				MEASURE,
				COL_LIST --PJ20200138 범위를 초과하는 YYYYMMDD List
		'
		;
		--End [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
	ELSE

		v_nsql := '
			SELECT
				DIVISION_ID,
				DIVISION_NAME,
				UPPER_DEPT_ID,
				DEPT_ID	,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				SITE_DESCRIPTION,
				END_CUSTOMER,
				END_CUSTOMER40,
				PROJECT_CODE,
				PROJECT_NAME,
				BIZ_TYPE_NAME,
				PROJECT_STATUS,
				ITEM_ID,
				ITEM_CLASS_NAME,
				ITEM_NAME,
				INCOTERMS,
				CURRENCY,
				FCST_TYPE,
				DOM_EXP,
				AUTHORITY_YN,
				DISPLAY_SEQ,
				NICK_NAME,
				CELL_PROD_SITE_ID,
				COL_LIST, --PJ20200138 범위를 초과하는 YYYYMMDD List
				''N'' AS NEW_FLAG,
				MEASURE,
				' || V_Prod_Cols || '
			FROM(
				SELECT
					*
				FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE
				WHERE MEASURE = ''LOC''
			) T
			PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod || '))
			ORDER BY
				DIVISION_ID,
				DEPT_ID,
				END_CUSTOMER,
				SCM_SITE_ID,
				PROJECT_CODE,
				PROJECT_STATUS,
				BIZ_TYPE_NAME,
				ITEM_ID,
				ITEM_CLASS_NAME,
				ITEM_NAME,
				INCOTERMS,
				FCST_TYPE,
				DOM_EXP,
				CURRENCY,
				PLANT_SITE_ID,
				CELL_PROD_SITE_ID,
				DISPLAY_SEQ,
				MEASURE,
				COL_LIST --PJ20200138 범위를 초과하는 YYYYMMDD List
			'
			;
	END IF;

--PRINT V_NSQL
	OPEN O_CURSOR FOR V_NSQL;



--SELECT CAST(V_NSQL AS TEXT)
--FOR XML PATH('')--,ROOT('x')



END P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP;


PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE 
(
 p_start_dt      IN VARCHAR2,
 p_end_dt        IN VARCHAR2,
 p_created_by    IN VARCHAR2,
 p_division_id   IN VARCHAR2,
 O_RESULT_CURSOR OUT SYS_REFCURSOR
/****************************************************************************************************/
)
AS
    p_program_id VARCHAR2(50 CHAR) := 'DMF0082';
    p_sheet_name VARCHAR2(50 CHAR) := 'Sales Price Save All';
    i_Count INTEGER := 0;
BEGIN
        --[E20260812-DS2] GTT 무통계 클라우드 10배 지연 방어 표준
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';



    SELECT  Count(*)
  INTO i_Count
    FROM   SCM_MST_TITLESET_USER U
    --     , SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = p_program_id
    AND    U.SHEET_NAME  = p_sheet_name
    AND    U.USER_ID     = p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

 -- 2.
 --IF i_Count = 0
 BEGIN
  -- 일반 데이터 칼럼
  OPEN O_RESULT_CURSOR FOR
  SELECT
     C.PROGRAM_ID
         , C.SHEET_NAME
         , C.COLUMN_NAME
         , C.COLUMN_LABEL_NAME
         , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO       --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
         , C.DATA_SORT_METHOD_CODE
         , C.SMALL_CLASS_LABEL_NAME
         , C.LARGE_CLASS_LABEL_NAME
   , '' AS DAY_CODE
         , C.FIXED_FLAG
         , C.COLUMN_WIDTH
         , C.CELL_CONTROL_OBJECT_TYPE_CODE
         , C.CELL_COMBO_DATA_TYPE
         , TO_CHAR(C.DATA_SCALE_NUMBER)
         , TO_CHAR(C.DATA_MAX_LENGTH)
         , C.HORIZONTAL_ALIGN_CODE
         , C.UPPERCASE_APPLY_FLAG
         , C.VISIBLE_FLAG
         , C.DEFAULT_FLAG
         , C.USER_SELECTABLE_FLAG
         , C.VALID_YN
   --, CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가
   --  CASE FN_GET_DIVISION_YN(C.DIVISION_ID, p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
   -- ELSE C.VALID_YN END VALID_YN
   , '0' AS SEQ
   --INTO GT_DMF0_TitleO
   FROM SCM_MST_SHEET_COLUMNS C
   WHERE 1 = 1
    AND    C.PROGRAM_ID  = p_program_id
    AND    C.SHEET_NAME  = p_sheet_name
    AND    ( C.DEFAULT_FLAG = 'Y' OR
     (    C.VISIBLE_FLAG = 'N'
     AND    C.DEFAULT_FLAG IS NULL
     AND    C.VALID_YN     = 'Y'
     )
     )
    AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )  -- 20180604 division 추가
  -- 날짜 데이터 칼럼
  UNION ALL
  SELECT
   p_program_id   AS PROGRAM_ID
   , p_sheet_name AS SHEET_NAME
   , MA.COLUMN_NAME
   , MA.COLUMN_LABEL_NAME
   , MA.SORT_ORDER_NO
   , ''         AS DATA_SORT_METHOD_CODE
   , MA.SMALL_CLASS_LABEL_NAME
   , MA.LARGE_CLASS_LABEL_NAME
   , MA.DAY_CODE
   , ''         AS FIXED_FLAG
   , 120         AS COLUMN_WIDTH
   , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
   , ''         AS CELL_COMBO_DATA_TYPE
   --, '2'         AS DATA_SCALE_NUMBER
   , '3'         AS DATA_SCALE_NUMBER -- 20181029
   , ''         AS DATA_MAX_LENGTH
   , 'R'        AS HORIZONTAL_ALIGN_CODE
   , 'Y'        AS UPPERCASE_APPLY_FLAG
   , 'Y'        AS VISIBLE_FLAG
   , ''         AS DEFAULT_FLAG
   , ''         AS USER_SELECTABLE_FLAG
   , ''         AS VALID_YN
   , ''   AS DIVISION_ID
  FROM  (
   SELECT
    'W_'  ||  MIN(BASIS_START_DATE)    AS COLUMN_NAME
    , SUBSTR(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME
    , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
    , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
    , ''             AS DAY_CODE
    , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
    , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
   FROM SCM_SYS_CALENDAR_M
   WHERE  BASIS_YYYYMMDD >= p_start_dt
    AND    BASIS_YYYYMMDD <= p_end_dt
   GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

   UNION ALL

   SELECT
    'M_'  ||  MIN(BASIS_START_DATE)    AS COLUMN_NAME
    , SUBSTR(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME
    , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
    , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
    , ''             AS DAY_CODE
    , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
    , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
   FROM SCM_SYS_CALENDAR_M
   WHERE  BASIS_YYYYMMDD >= p_start_dt
    AND BASIS_YYYYMMDD <= p_end_dt
    AND CALENDAR_DAY = '01'
   GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

  ) MA
  ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;

--  ORDER BY SEQ, SORT_ORDER_NO

 END;
 --ELSE --IF i_Count <> 0
 --BEGIN
 -- -- 일반 데이터 칼럼
 -- SELECT U.PROGRAM_ID
 --   , U.SHEET_NAME
 --   , U.COLUMN_NAME
 --   , C.COLUMN_LABEL_NAME
 --   , U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
 --   , U.DATA_SORT_METHOD_CODE
 --   , C.SMALL_CLASS_LABEL_NAME
 --   , C.LARGE_CLASS_LABEL_NAME
 --   , '' AS DAY_CODE
 --   , C.FIXED_FLAG
 --   , C.COLUMN_WIDTH
 --   , C.CELL_CONTROL_OBJECT_TYPE_CODE
 --   , C.CELL_COMBO_DATA_TYPE
 --   , C.DATA_SCALE_NUMBER
 --   , C.DATA_MAX_LENGTH
 --   , C.HORIZONTAL_ALIGN_CODE
 --   , C.UPPERCASE_APPLY_FLAG
 --   , C.VISIBLE_FLAG
 --   , C.DEFAULT_FLAG
 --   , C.USER_SELECTABLE_FLAG
 --   --, C.VALID_YN
 --   , CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가
 --    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
 --   ELSE C.VALID_YN END VALID_YN
 --   , 1 AS SEQ
 -- FROM   SCM_MST_TITLESET_USER U
 --   , SCM_MST_SHEET_COLUMNS C
 -- WHERE  1 = 1
 -- AND    U.PROGRAM_ID  = C.PROGRAM_ID
 -- AND    U.SHEET_NAME  = C.SHEET_NAME
 -- AND    U.COLUMN_NAME = C.COLUMN_NAME
 -- AND    U.PROGRAM_ID  = p_program_id
 -- AND    U.SHEET_NAME  = p_sheet_name
 -- AND    U.USER_ID     = p_created_by
 -- AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
 -- AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )  -- 20180604 division 추가
 -- UNION ALL
 -- SELECT C.PROGRAM_ID
 --   , C.SHEET_NAME
 --   , C.COLUMN_NAME
 --   , C.COLUMN_LABEL_NAME
 --   , C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
 --   , C.DATA_SORT_METHOD_CODE
 --   , C.SMALL_CLASS_LABEL_NAME
 --   , C.LARGE_CLASS_LABEL_NAME
 --   , '' AS DAY_CODE
 --   , C.FIXED_FLAG
 --   , C.COLUMN_WIDTH
 --   , C.CELL_CONTROL_OBJECT_TYPE_CODE
 --   , C.CELL_COMBO_DATA_TYPE
 --   , C.DATA_SCALE_NUMBER
 --   , C.DATA_MAX_LENGTH
 --   , C.HORIZONTAL_ALIGN_CODE
 --   , C.UPPERCASE_APPLY_FLAG
 --   , C.VISIBLE_FLAG
 --   , C.DEFAULT_FLAG
 --   , C.USER_SELECTABLE_FLAG
 --   , C.VALID_YN
 --   , 2 AS SEQ
 -- FROM   SCM_MST_SHEET_COLUMNS C
 -- WHERE  1 = 1
 -- AND    C.PROGRAM_ID  = p_program_id
 -- AND    C.SHEET_NAME  = p_sheet_name
 -- AND    C.VISIBLE_FLAG = 'N'
 -- AND    C.DEFAULT_FLAG IS NULL
 -- AND    C.VALID_YN     = 'Y'
 -- AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )  -- 20180604 division 추가
 -- --ORDER BY SEQ, SORT_ORDER_NO
 -- -- 날짜 데이터 칼럼
 -- UNION ALL
 -- SELECT
 --  p_program_id   AS PROGRAM_ID
 --  , p_sheet_name AS SHEET_NAME
 --  , MA.COLUMN_NAME
 --  , MA.COLUMN_LABEL_NAME
 --  , MA.SORT_ORDER_NO
 --  , ''         AS DATA_SORT_METHOD_CODE
 --  , MA.SMALL_CLASS_LABEL_NAME
 --  , MA.LARGE_CLASS_LABEL_NAME
 --  , MA.DAY_CODE
 --  , ''         AS FIXED_FLAG
 --  , 120         AS COLUMN_WIDTH
 --  , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
 --  , ''         AS CELL_COMBO_DATA_TYPE
 --  --, '2'         AS DATA_SCALE_NUMBER
 --  , '3'         AS DATA_SCALE_NUMBER -- 20181029
 --  , ''         AS DATA_MAX_LENGTH
 --  , 'R'        AS HORIZONTAL_ALIGN_CODE
 --  , 'Y'        AS UPPERCASE_APPLY_FLAG
 --  , 'Y'        AS VISIBLE_FLAG
 --  , ''         AS DEFAULT_FLAG
 --  , ''         AS USER_SELECTABLE_FLAG
 --  , ''         AS VALID_YN
 --  , ''   AS DIVISION_ID
 -- FROM  (
 --  SELECT
 --   'W_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME
 --   , SUBSTR(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME
 --   , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
 --   , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
 --   , ''             AS DAY_CODE
 --   , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
 --   , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
 --  FROM SCM_SYS_CALENDAR_M
 --  WHERE  BASIS_YYYYMMDD >= p_start_dt
 --   AND    BASIS_YYYYMMDD <= p_end_dt
 --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

 --  UNION ALL

 --  SELECT
 --   'M_' + MIN(BASIS_START_DATE)    AS COLUMN_NAME
 --   , SUBSTR(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME
 --   , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
 --   , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
 --   , ''             AS DAY_CODE
 --   , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
 --   , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
 --  FROM SCM_SYS_CALENDAR_M
 --  WHERE  BASIS_YYYYMMDD >= p_start_dt
 --   AND BASIS_YYYYMMDD <= p_end_dt
 --   AND CALENDAR_DAY = '01'
 --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

 -- ) MA
 -- ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME
 --END

END P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE;


PROCEDURE P_DMF0082_SAVE_MAIN_DATA 
(   p_active_flag         IN VARCHAR2
  , p_division_id         IN VARCHAR2
  , p_project_code        IN VARCHAR2
  , p_end_customer        IN VARCHAR2
  , p_scm_site_id         IN VARCHAR2
  , p_item_id             IN VARCHAR2
  , p_dom_exp             IN VARCHAR2
  , p_fcst_type           IN VARCHAR2
  , p_incoterms           IN VARCHAR2
  , p_measure             IN VARCHAR2
  , p_plant_site_id       IN VARCHAR2
  , p_cell_prod_site_id   IN VARCHAR2
  , p_yyyymmdd            IN VARCHAR2
  , p_currency            IN VARCHAR2
  , p_qty                 IN VARCHAR2
  , p_created_by          IN VARCHAR2
  , p_as_from_site        IN VARCHAR2 DEFAULT NULL  --[E20260805-AFS] AS FROM SITE(ATTRIBUTE10) — W/S AS 계열 저장 지원
  , O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/****** 개체: StoredProcedure [dbo].[DMF0082_SAVE_MAIN_DATA] 스크립트 날짜: 2026-04-22 오전 10:58:18 ******/

/*============================================================================================================================
 * Program ID  : [DMF0082_SAVE_MAIN_DATA]
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=============================================================================================================================
 * Date        In Charge    Description
 *=============================================================================================================================
 * 2025.01.23	dsiol		Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2025.04.15	dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025.04.26	dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
 * 2025.05.21	dsiol		[PJ2025-50188]LGES SCM DM 소형사업부 매출계획 동기화 개선 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다.
 * 2025.06.19	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CELL_PROD_SITE_ID 검증 로직 보완
 * 2025.06.19	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : BIZ TYPE 검증 로직 보완
 * 2025.07.15	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025.07.18	JSSBAE		[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청
 * 2025.07.22	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 저장 속도 개선
 * 2025.08.26	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2025.09.12	JSSBAE		[E20250912-001720]_40사업부 MKT FCST 입력제한 기능 보완
 * 2025.09.15	JSSBAE		[E20250915-000105]_GSCM 시스템 DP 입력 오류
 * 2025.09.30	JSSBAE		[E20250919-001699]_Incoterms 데이터 처리 VALID 처리
 * 2025.10.27	JSSBAE		[E20251021-000634]_FCST&PRICE MGMT SALES PLAN 데이터 동기화 속도개선
 * 2025.12.09	JSSBAE		[E20251208-000309]_FCST&PRICE MGMT MKT FCST AMT 메저 로직 개선
 * 2025.12.10	JSSBAE		[E20251209-000712]_40사업부 RTF 간편조정 후 CUTOFF 데이터 미반영 현상 확인 요청
 * 2026.01.21	JSSBAE		[E20260107-001651]_BPS 전송 데이터 From_Site_ID 생성 로직 개선
 * 2026.03.10	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
 * 2026.07.14	admin		[DIV81] Division 81(LIKE '81%') 분기 — 81 테이블(DM_PLN_MKT_FCST/SCM_MST_FUTURE_PRICE) 직접 DML
 *                          + 81 전용 Validation(V81-00~11, 정본 DMF0003/DMF0020) + PR_DM_PLN_CFM_TO_MKT_FCST 게이트. 40 경로 원문 무수정.
 * 2026.08.05	admin		[E20260805-AFS] p_as_from_site 신설(DEFAULT NULL) — AS 계열(W/S) AS FROM SITE(ATTRIBUTE10) 실제 저장.
 *                          V81-11 신규 차단 가드 완화(AS FROM SITE 전달 시 허용) + 81 MERGE UPDATE 에 ATTRIBUTE10 조건부 갱신.
 *============================================================================================================================*/
IS
    --=================================================================================================================================
    -- LOG 용 변수 설정
    --=================================================================================================================================
    e_validation_error  EXCEPTION;
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER          := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE;
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250915-000105]_변수 추가 (START)
    -----------------------------------------------------------------------------------------------------------------------------------
    v_created_by        VARCHAR2(500 CHAR);  --로그저장시 사용자ID
    n_update_cnt        NUMBER          := 0;  --변경이 발생하는 Row Count
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250915-000105]_변수 추가 (END)
    -----------------------------------------------------------------------------------------------------------------------------------
    --=================================================================================================================================
    -- 예외처리 변수 설정
    --=================================================================================================================================
    v_err_code          NUMBER;
    v_err_message       VARCHAR2(4000 CHAR) := '';

    V_DIVISION_ID       VARCHAR2(10 CHAR)   := '40';
    v_valid_item_id     VARCHAR2(4000 CHAR);
    v_plan_start_yyyymmdd VARCHAR2(8 CHAR);  -- 20180611 KHSONG ADDED
    v_valid_shipto      VARCHAR2(4000 CHAR);
    V_EDIT_CNT          NUMBER;

    --[DIV81] Division 81 분기 변수 (2026-07-14)
    v_is_81             VARCHAR2(1 CHAR) := 'N';
    v_div_cnt           NUMBER := 0;
    V_VALID_PROJECT_CODE VARCHAR2(200 CHAR);
    V_VALID_TYPE        VARCHAR2(100 CHAR);
    V_DESC_81           VARCHAR2(4000 CHAR);

    -- 파라미터 파싱용 로컬 변수
    v_p_active_flag     VARCHAR2(4000 CHAR);
    v_p_division_id     VARCHAR2(4000 CHAR);
    v_p_project_code    VARCHAR2(4000 CHAR);
    v_p_end_customer    VARCHAR2(4000 CHAR);
    v_p_scm_site_id     VARCHAR2(4000 CHAR);
    v_p_item_id         VARCHAR2(4000 CHAR);
    v_p_dom_exp         VARCHAR2(4000 CHAR);
    v_p_fcst_type       VARCHAR2(4000 CHAR);
    v_p_incoterms       VARCHAR2(4000 CHAR);
    v_p_measure         VARCHAR2(4000 CHAR);
    v_p_plant_site_id   VARCHAR2(4000 CHAR);
    v_p_cell_prod_site_id VARCHAR2(4000 CHAR);
    v_p_yyyymmdd        VARCHAR2(4000 CHAR);
    v_p_currency        VARCHAR2(4000 CHAR);
    v_p_qty             VARCHAR2(4000 CHAR);
    v_p_created_by_raw  VARCHAR2(4000 CHAR);
    v_p_as_from_site_raw VARCHAR2(4000 CHAR);  --[E20260805-AFS]
    --[E20260813-UPLOADSAVE] '^' 파싱부 skip 여부 (Excel Upload 적재 경로가 GT_PRDM1_T_MAIN 을 직접 적재)
    v_skip_parse        VARCHAR2(1 CHAR);

    -- 루프용 행별 변수
    v_active_flag       VARCHAR2(4000 CHAR);
    v_p_division_id_val VARCHAR2(4000 CHAR);
    v_project_code      VARCHAR2(4000 CHAR);
    v_end_customer      VARCHAR2(4000 CHAR);
    v_scm_site_id       VARCHAR2(4000 CHAR);
    v_item_id           VARCHAR2(4000 CHAR);
    v_dom_exp           VARCHAR2(4000 CHAR);
    v_fcst_type         VARCHAR2(4000 CHAR);
    v_incoterms         VARCHAR2(4000 CHAR);
    v_measure           VARCHAR2(4000 CHAR);
    v_plant_site_id     VARCHAR2(4000 CHAR);
    v_cell_prod_site_id VARCHAR2(4000 CHAR);
    v_yyyymmdd          VARCHAR2(4000 CHAR);
    v_currency          VARCHAR2(4000 CHAR);
    v_qty_str           VARCHAR2(4000 CHAR);
    v_p_created_by_val  VARCHAR2(4000 CHAR);
    v_as_from_site      VARCHAR2(4000 CHAR);  --[E20260805-AFS]

    -- 내부 프로시저 호출용 커서 변수
    v_inner_result_cursor   SYS_REFCURSOR;

    -- 인덱스 변수
    v_index_active_flag     NUMBER;
    v_index_division_id     NUMBER;
    v_index_project_code    NUMBER;
    v_index_end_customer    NUMBER;
    v_index_scm_site_id     NUMBER;
    v_index_item_id         NUMBER;
    v_index_dom_exp         NUMBER;
    v_index_fcst_type       NUMBER;
    v_index_incoterms       NUMBER;
    v_index_measure         NUMBER;
    v_index_plant_site_id   NUMBER;
    v_index_cell_prod_site_id NUMBER;
    v_index_yyyymmdd        NUMBER;
    v_index_currency        NUMBER;
    v_index_qty             NUMBER;
    v_index_created_by      NUMBER;
    v_index_as_from_site    NUMBER;  --[E20260805-AFS]

    i_count             NUMBER  := 0;
    v_idx               NUMBER  := 1;

    --==========================================================================================================================
    -- 각종 validation 변수
    --==========================================================================================================================
    V_TARGET_DATE       VARCHAR2(10 CHAR);
    V_MEASURE_VAR       VARCHAR2(100 CHAR);
    V_FROM_TIME         VARCHAR2(4 CHAR);
    V_TO_TIME           VARCHAR2(4 CHAR);
    V_MIN_DATE          CHAR(8 CHAR);
    V_MAX_DATE          CHAR(8 CHAR);
    V_FROM_DATE         CHAR(8 CHAR);
    V_TO_DATE           CHAR(8 CHAR);
    s_BLOCK_Model       VARCHAR2(4000 CHAR);
    v_BIZ_TYPE_CHECK    VARCHAR2(500 CHAR);
    V_ROWCNT            NUMBER;
    V_I                 NUMBER;
    V_CNT               NUMBER;
    V_EXCEPTION_DIVISION_ID VARCHAR2(8 CHAR);
    V_EXCEPTION_ITEM_ID     VARCHAR2(50 CHAR);
    V_EXCEPTION_ITEM_TYPE   VARCHAR2(8 CHAR);
    V_EXCEPTION_COUNT       NUMBER  := 0;
    v_CELL_TYPE_CHECK   VARCHAR2(500 CHAR);
    s_cell_prod_valid   VARCHAR2(1000 CHAR);
    s_unit_price_valid  VARCHAR2(4000 CHAR);
    v_valid_bom         VARCHAR2(4000 CHAR);
    v_invalid_Site      VARCHAR2(200 CHAR);
    n_Dflag_chk         NUMBER  := 0;
    n_EE_chk            NUMBER  := 0;
    V_GETDATE           DATE;

    -- validation용 카운트
    v_cnt_check         NUMBER;

BEGIN
        --[E20260812-DS2] GTT 무통계 클라우드 10배 지연 방어 표준
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=================================================================================================================================
    -- PROC_INPUT 설정
    --=================================================================================================================================
    V_PROC_INPUT := JSON_OBJECT('rows' VALUE REGEXP_COUNT(p_active_flag, '\^') + 1, 
        'p_active_flag'       VALUE SUBSTR(p_active_flag, 1, 50),
        'p_division_id'       VALUE SUBSTR(p_division_id, 1, 50),
        'p_project_code'      VALUE SUBSTR(p_project_code, 1, 50),
        'p_end_customer'      VALUE SUBSTR(p_end_customer, 1, 50),
        'p_scm_site_id'       VALUE SUBSTR(p_scm_site_id, 1, 50),
        'p_item_id'           VALUE SUBSTR(p_item_id, 1, 50),
        'p_dom_exp'           VALUE SUBSTR(p_dom_exp, 1, 50),
        'p_fcst_type'         VALUE SUBSTR(p_fcst_type, 1, 50),
        'p_incoterms'         VALUE SUBSTR(p_incoterms, 1, 50),
        'p_measure'           VALUE SUBSTR(p_measure, 1, 50),
        'p_plant_site_id'     VALUE SUBSTR(p_plant_site_id, 1, 50),
        'p_cell_prod_site_id' VALUE SUBSTR(p_cell_prod_site_id, 1, 50),
        'p_yyyymmdd'          VALUE SUBSTR(p_yyyymmdd, 1, 50),
        'p_currency'          VALUE SUBSTR(p_currency, 1, 50),
        'p_qty'               VALUE SUBSTR(p_qty, 1, 50),
        'p_created_by'        VALUE SUBSTR(p_created_by, 1, 50));

    --=================================================================================================================================
    -- LOG 용 변수 설정
    --=================================================================================================================================
    -- [E20250915-000105]_변수 추가 (START)
    v_created_by := SUBSTR(p_created_by, 1,
                        CASE WHEN INSTR(p_created_by, '^') > 1
                             THEN INSTR(p_created_by, '^') - 1
                             ELSE 100 END);
    -- [E20250915-000105]_변수 추가 (END)

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'START', N_LOG_COUNT,
        '########## Start of procedure ##########', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A001--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --=============================================================================================================================
    -- [E20251021-000634]_TEMP TABLE DROP -> CREATE (START) 가장 상단에서 진행하도록 수정 (START)
    --=============================================================================================================================
    -- GTT 초기화 (TRUNCATE로 기존 데이터 제거)
    --[E20260813-UPLOADSAVE] 패키지 전역 플래그를 **1회용으로 소비**한다 (세션 누수 방지).
    --   화면 저장 경로는 g_skip_parse 를 세팅하지 않으므로 항상 'N' = 종전과 완전히 동일하게 동작.
    v_skip_parse := NVL(g_skip_parse, 'N');
    g_skip_parse := 'N';

    IF v_skip_parse = 'N' THEN
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;
    DELETE FROM SCM_MGR.GT_PRDM1_T_PRICE;
    DELETE FROM SCM_MGR.GT_PRDM1_T_FCST;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCH;
    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1;
    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;
    --=============================================================================================================================
    -- [E20251021-000634]_TEMP TABLE DROP -> CREATE (START) 가장 사단에서 진행하도록 수정 (END)
    --=============================================================================================================================

    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    --1. 화면에서 전달받은 데이터 -> temp 테이블로 insert
    --■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A00B--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_skip_parse = 'N' THEN   --[E20260813-UPLOADSAVE] 파싱부 시작
    -- 마지막 데이터 처리를 위한 구분자 추가
    v_p_active_flag       := RTRIM(p_active_flag)       || '^';
    v_p_division_id       := RTRIM(p_division_id)       || '^';
    v_p_project_code      := RTRIM(p_project_code)      || '^';
    v_p_end_customer      := RTRIM(p_end_customer)      || '^';
    v_p_scm_site_id       := RTRIM(p_scm_site_id)       || '^';
    v_p_item_id           := RTRIM(p_item_id)           || '^';
    v_p_dom_exp           := RTRIM(p_dom_exp)           || '^';
    v_p_fcst_type         := RTRIM(p_fcst_type)         || '^';
    v_p_incoterms         := RTRIM(p_incoterms)         || '^';
    v_p_measure           := RTRIM(p_measure)           || '^';
    v_p_plant_site_id     := RTRIM(p_plant_site_id)     || '^';
    v_p_cell_prod_site_id := RTRIM(p_cell_prod_site_id) || '^';
    v_p_yyyymmdd          := RTRIM(p_yyyymmdd)          || '^';
    v_p_currency          := RTRIM(p_currency)          || '^';
    v_p_qty               := RTRIM(p_qty)               || '^';
    v_p_created_by_raw    := RTRIM(p_created_by)        || '^';
    v_p_as_from_site_raw  := RTRIM(NVL(p_as_from_site, '')) || '^';  --[E20260805-AFS] 미전달(NULL)=전 행 공백 토큰

    -- COUNT를 구한다. 하나라도 들어오면 수치가 1이 된다.
    i_count := LENGTH(RTRIM(v_p_division_id)) - LENGTH(REPLACE(RTRIM(v_p_division_id), '^', ''));

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A00C--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(i_count), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF i_count > 0 THEN

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
            '■ : A00D--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(i_count), '', SYSDATE,
            v_created_by,
            V_PROC_INPUT, NULL, NULL, NULL); END;

        WHILE v_idx <= i_count LOOP
            v_idx := v_idx + 1;

            v_index_active_flag       := INSTR(v_p_active_flag,       '^');
            v_index_division_id       := INSTR(v_p_division_id,       '^');
            v_index_project_code      := INSTR(v_p_project_code,      '^');
            v_index_end_customer      := INSTR(v_p_end_customer,      '^');
            v_index_scm_site_id       := INSTR(v_p_scm_site_id,       '^');
            v_index_item_id           := INSTR(v_p_item_id,           '^');
            v_index_dom_exp           := INSTR(v_p_dom_exp,           '^');
            v_index_fcst_type         := INSTR(v_p_fcst_type,         '^');
            v_index_incoterms         := INSTR(v_p_incoterms,         '^');
            v_index_measure           := INSTR(v_p_measure,           '^');
            v_index_plant_site_id     := INSTR(v_p_plant_site_id,     '^');
            v_index_cell_prod_site_id := INSTR(v_p_cell_prod_site_id, '^');
            v_index_yyyymmdd          := INSTR(v_p_yyyymmdd,          '^');
            v_index_currency          := INSTR(v_p_currency,          '^');
            v_index_qty               := INSTR(v_p_qty,               '^');
            v_index_created_by        := INSTR(v_p_created_by_raw,    '^');
            v_index_as_from_site      := INSTR(v_p_as_from_site_raw,  '^');  --[E20260805-AFS]

            v_active_flag       := SUBSTR(v_p_active_flag,       1, v_index_active_flag       - 1);
            v_p_division_id_val := SUBSTR(v_p_division_id,       1, v_index_division_id       - 1);
            v_project_code      := SUBSTR(v_p_project_code,      1, v_index_project_code      - 1);
            v_end_customer      := SUBSTR(v_p_end_customer,      1, v_index_end_customer      - 1);
            v_scm_site_id       := SUBSTR(v_p_scm_site_id,       1, v_index_scm_site_id       - 1);
            v_item_id           := SUBSTR(v_p_item_id,           1, v_index_item_id           - 1);
            v_dom_exp           := SUBSTR(v_p_dom_exp,           1, v_index_dom_exp           - 1);
            v_fcst_type         := SUBSTR(v_p_fcst_type,         1, v_index_fcst_type         - 1);
            v_incoterms         := SUBSTR(v_p_incoterms,         1, v_index_incoterms         - 1);
            v_measure           := SUBSTR(v_p_measure,           1, v_index_measure           - 1);
            v_plant_site_id     := SUBSTR(v_p_plant_site_id,     1, v_index_plant_site_id     - 1);
            v_cell_prod_site_id := SUBSTR(v_p_cell_prod_site_id, 1, v_index_cell_prod_site_id - 1);
            v_yyyymmdd          := SUBSTR(v_p_yyyymmdd,          1, v_index_yyyymmdd          - 1);
            v_currency          := SUBSTR(v_p_currency,          1, v_index_currency          - 1);
            v_qty_str           := SUBSTR(v_p_qty,               1, v_index_qty               - 1);
            v_p_created_by_val  := SUBSTR(v_p_created_by_raw,   1, v_index_created_by        - 1);
            v_as_from_site      := SUBSTR(v_p_as_from_site_raw, 1, v_index_as_from_site      - 1);  --[E20260805-AFS] 토큰 소진 후엔 ''

            -- 나머지 문자열 갱신
            v_p_active_flag       := SUBSTR(v_p_active_flag,       LENGTH(RTRIM(v_active_flag)             || '^') + 1, LENGTH(RTRIM(v_p_active_flag)));
            v_p_division_id       := SUBSTR(v_p_division_id,       LENGTH(RTRIM(v_p_division_id_val)       || '^') + 1, LENGTH(RTRIM(v_p_division_id)));
            v_p_project_code      := SUBSTR(v_p_project_code,      LENGTH(RTRIM(v_project_code)            || '^') + 1, LENGTH(RTRIM(v_p_project_code)));
            v_p_end_customer      := SUBSTR(v_p_end_customer,      LENGTH(RTRIM(v_end_customer)            || '^') + 1, LENGTH(RTRIM(v_p_end_customer)));
            v_p_scm_site_id       := SUBSTR(v_p_scm_site_id,       LENGTH(RTRIM(v_scm_site_id)             || '^') + 1, LENGTH(RTRIM(v_p_scm_site_id)));
            v_p_item_id           := SUBSTR(v_p_item_id,           LENGTH(RTRIM(v_item_id)                 || '^') + 1, LENGTH(RTRIM(v_p_item_id)));
            v_p_dom_exp           := SUBSTR(v_p_dom_exp,           LENGTH(RTRIM(v_dom_exp)                 || '^') + 1, LENGTH(RTRIM(v_p_dom_exp)));
            v_p_fcst_type         := SUBSTR(v_p_fcst_type,         LENGTH(RTRIM(v_fcst_type)               || '^') + 1, LENGTH(RTRIM(v_p_fcst_type)));
            v_p_incoterms         := SUBSTR(v_p_incoterms,         LENGTH(RTRIM(v_incoterms)               || '^') + 1, LENGTH(RTRIM(v_p_incoterms)));
            v_p_measure           := SUBSTR(v_p_measure,           LENGTH(RTRIM(v_measure)                 || '^') + 1, LENGTH(RTRIM(v_p_measure)));
            v_p_plant_site_id     := SUBSTR(v_p_plant_site_id,     LENGTH(RTRIM(v_plant_site_id)           || '^') + 1, LENGTH(RTRIM(v_p_plant_site_id)));
            v_p_cell_prod_site_id := SUBSTR(v_p_cell_prod_site_id, LENGTH(RTRIM(v_cell_prod_site_id)       || '^') + 1, LENGTH(RTRIM(v_p_cell_prod_site_id)));
            v_p_yyyymmdd          := SUBSTR(v_p_yyyymmdd,          LENGTH(RTRIM(v_yyyymmdd)                || '^') + 1, LENGTH(RTRIM(v_p_yyyymmdd)));
            v_p_currency          := SUBSTR(v_p_currency,          LENGTH(RTRIM(v_currency)                || '^') + 1, LENGTH(RTRIM(v_p_currency)));
            v_p_qty               := SUBSTR(v_p_qty,               LENGTH(RTRIM(v_qty_str)                 || '^') + 1, LENGTH(RTRIM(v_p_qty)));
            v_p_created_by_raw    := SUBSTR(v_p_created_by_raw,    LENGTH(RTRIM(v_p_created_by_val)        || '^') + 1, LENGTH(RTRIM(v_p_created_by_raw)));
            v_p_as_from_site_raw  := SUBSTR(v_p_as_from_site_raw,  LENGTH(RTRIM(v_as_from_site)            || '^') + 1, LENGTH(RTRIM(v_p_as_from_site_raw)));  --[E20260805-AFS]

            -- [E20250522-001188]_해당 화면에서도 TRIM처리가 전혀 안되어 있어서 TRIM 처리 (START)
            v_active_flag       := TRIM(v_active_flag);
            v_p_division_id_val := TRIM(v_p_division_id_val);
            v_project_code      := TRIM(v_project_code);
            v_end_customer      := TRIM(v_end_customer);
            v_scm_site_id       := TRIM(v_scm_site_id);
            --1).CHAR(13): Carriage return / 2).CHAR(10): Line feed / 3).CHAR(9): TAB / 4).' ' 공백 '' 처리
            v_item_id           := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(v_item_id), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', '');
            v_dom_exp           := TRIM(v_dom_exp);
            v_fcst_type         := TRIM(v_fcst_type);
            v_incoterms         := TRIM(v_incoterms);
            v_measure           := TRIM(v_measure);
            v_plant_site_id     := TRIM(v_plant_site_id);
            v_cell_prod_site_id := TRIM(v_cell_prod_site_id);
            v_yyyymmdd          := TRIM(v_yyyymmdd);
            v_qty_str           := TRIM(v_qty_str);
            v_currency          := TRIM(v_currency);
            v_p_created_by_val  := TRIM(v_p_created_by_val);
            v_as_from_site      := TRIM(v_as_from_site);  --[E20260805-AFS]
            -- [E20250522-001188]_TRIM 처리 (END)

            BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
                '■ : A00E--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(v_idx), '', SYSDATE,
                v_created_by,
                V_PROC_INPUT, NULL, NULL, NULL); END;

            INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
            ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
            , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
            , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
            VALUES
            ( v_active_flag, v_p_division_id_val, v_project_code, v_end_customer, v_scm_site_id, v_item_id
            , v_dom_exp, v_fcst_type, v_incoterms, v_measure
            , v_plant_site_id, v_cell_prod_site_id, v_yyyymmdd, v_currency
            , TO_NUMBER(NVL(v_qty_str, '0') DEFAULT 0 ON CONVERSION ERROR)
            , v_p_created_by_val
            --[E20260805-AFS] V_ATTRIBUTE10(10번째) = AS FROM SITE
            , '', '', '', '', '', '', '', '', '', v_as_from_site, '', '' );

        END LOOP;

    END IF;
    END IF;   --[E20260813-UPLOADSAVE] 파싱부 끝

    BEGIN
        SELECT COUNT(1) INTO V_EDIT_CNT FROM SCM_MGR.GT_PRDM1_T_MAIN;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_EDIT_CNT := 0;
    END;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    --==========================================================================================================================
    --[DIV81] 0. Division 판정 + 혼합 유입 차단(V81-00) + 81 placeholder 정규화 (START)
    --  단일 Division 전제(사용자 확정 2026-07-14). LIKE '81%' = 81 계열(81/81_HD/81_HG/81_HM/81_ST/81_UC 실측).
    --  40 흐름은 V_DIVISION_ID 재할당 결과가 '40' 이므로 기존 동작 불변.
    --==========================================================================================================================
    SELECT COUNT(DISTINCT DIVISION_ID) INTO v_div_cnt FROM SCM_MGR.GT_PRDM1_T_MAIN;

    IF v_div_cnt > 1 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '복수 Division 데이터는 동시에 저장할 수 없습니다. 단일 Division 으로 저장하세요.';
        RAISE e_validation_error;
    END IF;

    IF v_div_cnt = 1 THEN
        SELECT MIN(DIVISION_ID) INTO V_DIVISION_ID FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;

    --==========================================================================================================================
    -- [UICATEGORY 2026-08-07 V82-00] Division 82 = 조회 전용 (사용자 확정 2026-08-07) — 저장 전면 차단
    --   (2026-07-30 "82=81 동일 경로" 저장 구현을 본 게이트가 상위에서 차단 — 하류 로직 무수정 보존)
    --==========================================================================================================================
    IF V_DIVISION_ID = '82' THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '82 사업부는 조회 전용입니다. 저장할 수 없습니다.';
        RAISE e_validation_error;
    END IF;

    IF (V_DIVISION_ID LIKE '81%' OR V_DIVISION_ID = '82') THEN
        v_is_81 := 'Y';
        -- 81 테이블에는 END_CUSTOMER / CELL_PROD_SITE_ID 컬럼이 없다 (ALL_TAB_COLUMNS 실측 2026-07-14).
        -- GET 커서의 '-' 리터럴과 동일하게 T_MAIN 도 '-' 로 정규화하여 하류 join 키를 일관시킨다.
        UPDATE SCM_MGR.GT_PRDM1_T_MAIN
        SET END_CUSTOMER = '-', CELL_PROD_SITE_ID = '-';
    END IF;
    --==========================================================================================================================
    --[DIV81] 0. Division 판정 (END)
    --==========================================================================================================================

    --=============================================================================================================================
    -- PARAMETER => TABLE 적재 LOG (START)
    --=============================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 1. PARAMETER TO #T_MAIN IMPORT';
    N_LOG_COUNT   := i_count;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --=============================================================================================================================
    -- PARAMETER => TABLE 적재 LOG (END)
    --=============================================================================================================================

    n_update_cnt := 0; -- [E20250915-000105]_ROW_COUNT 확인
    --==========================================================================================================================
    -- VALIDATION 시작 (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 2. VALIDATION CHECK START';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- VALIDATION 시작 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- Validaion Check (START)
    --==========================================================================================================================
    --==========================================================================================================================
    -- 1. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (START)
    --==========================================================================================================================
    ----------------------------------------------------------------------------------------------------------------------------
    -- [E20250912-001720]_수정 저장 VALIDATION 추가 (START)
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_DAYINFO (DAYOFWEEKS)
    SELECT DAYOFWEEK
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_DAYINFO');

    BEGIN
        SELECT A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
        INTO   V_TARGET_DATE, V_FROM_TIME, V_TO_TIME, V_MEASURE_VAR
        FROM (
            SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, ATTRIBUTE4
            FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT2 = 'DMF0082'
            AND B.ATTRIBUTE4 IS NOT NULL
            AND (B.ATTRIBUTE1 = 'ALL' OR B.ATTRIBUTE1 IN (SELECT DAYOFWEEKS FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO))
            AND TRUNC(TO_NUMBER(REPLACE(SUBSTR(TO_CHAR(SYSDATE, 'HH24:MI:SS'), 1, 5), ':', '')))
                BETWEEN TRUNC(TO_NUMBER(B.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR))
                    AND TRUNC(TO_NUMBER(B.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR))
            AND B.SEGMENT3 = V_DIVISION_ID
        ) A
        GROUP BY A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, ATTRIBUTE4;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TARGET_DATE := NULL; V_FROM_TIME := NULL; V_TO_TIME := NULL; V_MEASURE_VAR := NULL;
        WHEN TOO_MANY_ROWS THEN
            V_TARGET_DATE := NULL; V_FROM_TIME := NULL; V_TO_TIME := NULL; V_MEASURE_VAR := NULL;
    END;

    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN A
    INNER JOIN (
        SELECT A.SEGMENT3 AS DIVISION_ID, A.ATTRIBUTE1 AS TARGET_DATE, A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME
             , REGEXP_SUBSTR(A.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS MEASURE
        FROM (
            SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4
            FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT2 = 'DMF0082'
            AND B.ATTRIBUTE4 IS NOT NULL
        ) A
        CONNECT BY LEVEL <= REGEXP_COUNT(A.ATTRIBUTE4, ',') + 1
             AND PRIOR A.SEGMENT3 = A.SEGMENT3 AND PRIOR A.ATTRIBUTE1 = A.ATTRIBUTE1
             AND PRIOR SYS_GUID() IS NOT NULL
    ) C ON A.DIVISION_ID = C.DIVISION_ID
          AND A.MEASURE  = C.MEASURE
    WHERE A.QTY_PRICE <> 0
    AND (C.TARGET_DATE = 'ALL' OR C.TARGET_DATE IN (SELECT DAYOFWEEKS FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO))
    AND TRUNC(TO_NUMBER(REPLACE(SUBSTR(TO_CHAR(SYSDATE, 'HH24:MI:SS'), 1, 5), ':', '')))
        BETWEEN TRUNC(TO_NUMBER(C.FROM_TIME DEFAULT NULL ON CONVERSION ERROR))
            AND TRUNC(TO_NUMBER(C.TO_TIME   DEFAULT NULL ON CONVERSION ERROR));

    IF v_cnt_check > 1 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := V_MEASURE_VAR || ' 메져는 "' || V_TARGET_DATE || '" 요일의 '
                      || SUBSTR(V_FROM_TIME, 1, 2) || ':' || SUBSTR(V_FROM_TIME, 3, 2)
                      || ' ~ ' || SUBSTR(V_TO_TIME, 1, 2) || ':' || SUBSTR(V_TO_TIME, 3, 2)
                      || ' 시간에는 수정 불가능합니다.';
        RAISE e_validation_error;
    END IF;
    ----------------------------------------------------------------------------------------------------------------------------
    -- [E20250912-001720]_수정 저장 VALIDATION 추가 (END)
    ----------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.1). SALES PRICE 미리 수집
    ----------------------------------------------------------------------------------------------------------------------------
    BEGIN
        SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
        INTO   V_MIN_DATE, V_MAX_DATE
        FROM SCM_MGR.SCM_SYS_CALENDAR_M M
        -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
        WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  --당주 월요일부터
        AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD');  -- 52주후 월요일까지
        -- [E20250825-000297]_52주구간 (END)
    EXCEPTION WHEN NO_DATA_FOUND THEN V_MIN_DATE := NULL; V_MAX_DATE := NULL;
    END;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A003--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.2). Sales Price 52주 구간 데이터 TEMP 테이블 INSERT (START)
    -- Sales Price 52주 구간 확인을 할 때는 UI에서 입력한 값이든, 이미 DB에 있던 값이든 상관없이 데이터가 있다면 상관없다.
    ----------------------------------------------------------------------------------------------------------------------------
    IF v_is_81 = 'N' THEN  --[DIV81] 판가 52주 수집 분기
    INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
    , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
         , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
    FROM (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
             , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
        FROM (
            -- DB에 있는 원래 데이터
            SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.ITEM_ID
                          , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
              ON A.DIVISION_ID       = B.DIVISION_ID
             AND A.PROJECT_CODE      = B.PROJECT_CODE
             AND A.END_CUSTOMER      = B.END_CUSTOMER
             AND A.SCM_SITE_ID       = B.SCM_SITE_ID
             --[E20260820-SENTINELDDL] 구 SENTINEL3 변형 동일 처리 삭제 — 원장 정규화·DDL·배치 정정 완료로 단순 등호
             AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
             AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
             AND A.ITEM_ID           = B.ITEM_ID
             AND A.DOM_EXP           = B.DOM_EXP
             AND A.FCST_TYPE         = B.FCST_TYPE
             AND A.INCOTERMS         = B.INCOTERMS
            WHERE B.DIVISION_ID  = A.DIVISION_ID
              AND B.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND B.PRICE <> 0
              AND B.MEASURE = 'LOC'
            UNION
            ----------------------------------------------------------------------------------------------------------------------------
            -- UI에서 입력한 신규 데이터 혹은 기존 DB 값을 UI에서 수정한 데이터
            -- MKT Fcst 와 같이 입력되는 Price의 경우 Validation에 포함 (UI에서 MKT_FCST MEASURE랑 LOC MEASURE를 동시에 입력하는 경우를 말함)
            ----------------------------------------------------------------------------------------------------------------------------
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID
                          , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE A.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND A.QTY_PRICE <> 0
              AND A.MEASURE = 'LOC'
        ) A
        GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
               , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
    ) AA;
    ELSE
        --[DIV81] 1.2-81). Sales Price 52주 구간 수집 — SCM_MST_FUTURE_PRICE (정본 DMF0003 L619 이식)
        --  81 조인키 8종 (END_CUSTOMER/CELL_PROD_SITE_ID 제외, PLANT_SITE_ID 조인 포함 — 81 정본 규약)
        INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
        , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
             , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
        FROM (
            -- DB에 있는 원래 데이터 (81: SCM_MST_FUTURE_PRICE, placeholder '-' 부여)
            SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, '-' AS END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID
                          , '-' AS CELL_PROD_SITE_ID, B.ITEM_ID
                          , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            JOIN SCM_MGR.SCM_MST_FUTURE_PRICE B
              ON A.DIVISION_ID   = B.DIVISION_ID
             AND A.PROJECT_CODE  = B.PROJECT_CODE
             AND A.SCM_SITE_ID   = B.SCM_SITE_ID
             AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
             AND A.ITEM_ID       = B.ITEM_ID
             AND A.DOM_EXP       = B.DOM_EXP
             AND A.FCST_TYPE     = B.FCST_TYPE
             AND A.INCOTERMS     = B.INCOTERMS
            WHERE B.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND B.PRICE <> 0
              AND B.MEASURE = 'LOC'
            UNION
            -- UI에서 입력한 신규/수정 데이터 ('-' 정규화 값 그대로)
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID
                          , A.CELL_PROD_SITE_ID, A.ITEM_ID
                          , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE A.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND A.QTY_PRICE <> 0
              AND A.MEASURE = 'LOC'
        ) AA81
        GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
               , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;
    END IF;  --[DIV81] 판가 52주 수집 분기

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_PRICE');
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.2). Sales Price 52주 구간 데이터 TEMP 테이블 INSERT (END)
    ----------------------------------------------------------------------------------------------------------------------------

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A004--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.3). 입력된 데이터의 기존 셀 생산지 데이터 수집 (START)
    -- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가
    ----------------------------------------------------------------------------------------------------------------------------
    IF v_is_81 = 'N' THEN  --[DIV81] 1.3 은 CELL_PROD 검증(#8) 전용 — 81 제외
    INSERT INTO SCM_MGR.GT_PRDM1_T_FCST
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID
    , ITEM_ID, YYYYMMDD, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS )
    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID
                  , B.ITEM_ID, B.YYYYMMDD, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
    FROM SCM_MGR.GT_PRDM1_T_MAIN A
    JOIN SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN B
      ON A.DIVISION_ID  = B.DIVISION_ID
     AND A.PROJECT_CODE = B.PROJECT_CODE
     AND A.END_CUSTOMER = B.END_CUSTOMER
     AND A.SCM_SITE_ID  = B.SCM_SITE_ID
     AND A.PLANT_SITE_ID= B.PLANT_SITE_ID
     --AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
     AND A.ITEM_ID      = B.ITEM_ID
     AND A.DOM_EXP      = B.DOM_EXP
     AND A.FCST_TYPE    = B.FCST_TYPE
     AND A.INCOTERMS    = B.INCOTERMS
     AND A.YYYYMMDD     = B.YYYYMMDD
     AND A.MEASURE      = B.MEASURE
    WHERE B.DIVISION_ID = A.DIVISION_ID
      AND B.QTY <> 0
      --AND B.CELL_PROD_SITE_ID = '-'
      AND A.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'SCM_FCST'); --[PJ2025-50188] SCM_FCST - MEASURE 추가

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_FCST');
    END IF;  --[DIV81] 1.3 게이트
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1.3). 입력된 데이터의 기존 셀 생산지 데이터 수집 (END)
    --==========================================================================================================================
    -- 1. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A005--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 2. 40 Validation 필요 대상 : VMI Site 여부 확인 (START)
    --==========================================================================================================================
    ----------------------------------------------------------------------------------------------------------------------------
    -- 2.1). #T_MAIN 테이블의 VMI_YN UPDATE
    ----------------------------------------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET A.V_VMI_YN = (SELECT CASE WHEN B.VMI_YN = 'Y' THEN 'Y' ELSE 'N' END
                      FROM SCM_MGR.SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID
                      FETCH FIRST 1 ROWS ONLY)
    WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID);

    ----------------------------------------------------------------------------------------------------------------------------
    -- 2.2).AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
    ----------------------------------------------------------------------------------------------------------------------------
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET V_ATTRIBUTE10 = NULL
    WHERE SCM_SITE_ID = V_ATTRIBUTE10;

    --==========================================================================================================================
    -- 2. 40 Validation 필요 대상 : VMI Site 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A006--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 3. 40 Validation 필요 대상 : 중장기 구간 확인 (START)
    --==========================================================================================================================
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD), MAX(C.BASIS_YYYYMMDD)
        INTO   V_FROM_DATE, V_TO_DATE
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
          ON C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
        WHERE L.LOOKUP_TYPE = 'DM_LONG_PLAN' AND L.SEGMENT1 = '40' AND L.SEGMENT2 = 'MKT FCST' AND L.VALID_YN = 'Y';
    EXCEPTION WHEN NO_DATA_FOUND THEN V_FROM_DATE := NULL; V_TO_DATE := NULL;
    END;

    ---------------------------------------------------------------------------------------------------------------------------
    -- 소형일 경우 중장기계획 관련 2022년 입력 마감여부 확인
    -- 소형이고 2022년이 마감되어있는데, 2022년 데이터가 들어있으면 에러처리
    ---------------------------------------------------------------------------------------------------------------------------
    IF V_DIVISION_ID = '40' THEN
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.YYYYMMDD < V_FROM_DATE OR R.YYYYMMDD > V_TO_DATE;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := V_FROM_DATE || ' ~ ' || V_TO_DATE || ' 구간 내의 데이터만 수정할 수 있습니다.';
            RAISE e_validation_error;
        END IF;
    END IF;
    --==========================================================================================================================
    -- 3. 40 Validation 필요 대상 : 중장기 구간 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A007--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 3-1. [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
    --==========================================================================================================================
    IF V_DIVISION_ID = '40' OR v_is_81 = 'Y' THEN  --[DIV81] 구코드 INCOTERMS 검증 81 확장 (DMF0003 L758 동일)
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.INCOTERMS IN (
            SELECT OLD_VALUE1 FROM SCM_MGR.NERP_CONV_MASTER
            WHERE CODETYPE = 'INCOTERMS_ID'
            GROUP BY OLD_VALUE1
        );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '구코드 INCOTERMS는 저장할 수 없습니다.';
            RAISE e_validation_error;
        END IF;
    END IF;
    --==========================================================================================================================
    -- 3-1. [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- 4. 40 Validation 필요 대상 : MKT Fcst Exception Model 대상 확인 (START)
    --==========================================================================================================================
    s_BLOCK_Model := '';
    BEGIN
        SELECT ITEM_ID INTO s_BLOCK_Model
        FROM (
            SELECT A.ITEM_ID
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE (
                SELECT COUNT(1) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE = 'FCST_EXCEPT_MODEL' AND SEGMENT1 = '40' AND VALID_YN = 'Y' AND SEGMENT2 = A.ITEM_ID
            ) > 0
            AND A.QTY_PRICE <> 0
            FETCH FIRST 1 ROWS ONLY
        );
    EXCEPTION WHEN NO_DATA_FOUND THEN s_BLOCK_Model := '';
    END;

    IF s_BLOCK_Model IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := 'Model : ' || s_BLOCK_Model || CHR(10) || 'FCST INPUT BLOCK Model. contact 영업관리팀';
        RAISE e_validation_error;
    END IF;
    --==========================================================================================================================
    -- 4. 40 Validation 필요 대상 : MKT Fcst Exception Model 대상 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A008--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (START)
    --==========================================================================================================================
    BEGIN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE NOT EXISTS (
                SELECT ITEM.DIVISION_ID
                FROM SCM_MGR.SCM_MST_SITE_ITEM ITEM
                   , SCM_MGR.SCM_MST_ITEM_SN SN
                WHERE ITEM.DIVISION_ID = A.DIVISION_ID
                  AND ITEM.SCM_SITE_ID = A.SCM_SITE_ID
                  AND ITEM.ITEM_ID     = A.ITEM_ID
                  AND ITEM.DIVISION_ID = SN.DIVISION_ID
                  AND ITEM.ITEM_ID     = SN.ITEM_ID
                  AND SN.ACTIVE_FLAG   = 'Y'
                  AND ITEM.VALID_YN    = 'Y'
            )
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Site Item ID !';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A009--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 6. 40 Validation 필요 대상 : BIZ_TYPE 존재여부 확인 (START)
    --==========================================================================================================================
    v_BIZ_TYPE_CHECK := NULL;
    --[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청 (STRAT)

    IF v_is_81 = 'N' THEN  --[DIV81] BIZ_TYPE 검증(#6)은 40 전용 (81 정본 DMF0003 에 없음)
    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.1). 룩업: EXCEPTION_BIZ_TYPE 데이터를 #TEMP_EXCEPTION_BIZ_TYPE에 담는다.
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE
    ( DIVISION_ID, ITEM_ID, ITEM_TYPE, SEQ )
    SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS ITEM_ID, SEGMENT3 AS ITEM_TYPE
         , ROW_NUMBER() OVER (ORDER BY ROWNUM) AS SEQ
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE = 'EXCEPTION_BIZ_TYPE'
    AND VALID_YN = 'Y'
    AND SEGMENT1 = V_DIVISION_ID;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE');

    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.2). 룩업에 저장된 데이터가 1건 이상인 경우가 존재할 수 있으므로, LOOP 실행하여,
    --       한건씩 매핑된 데이터로 #TEMP_EXCEPTION_ITEM_LIST에 데이터 적재
    --       ITEM_ID 일부로 시작하는 것으로 요청했으므로 뒷쪽만 LIKE 처리하여 데이터 처리
    ----------------------------------------------------------------------------------------------------------------------------
    V_ROWCNT := SQL%ROWCOUNT;

    BEGIN
        SELECT 1, COUNT(*) INTO V_I, V_CNT
        FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_I := 1; V_CNT := 0;
    END;

    V_EXCEPTION_COUNT := 0;

    WHILE V_I <= V_CNT LOOP
        BEGIN
            SELECT A.DIVISION_ID, A.ITEM_ID, A.ITEM_TYPE
            INTO V_EXCEPTION_DIVISION_ID, V_EXCEPTION_ITEM_ID, V_EXCEPTION_ITEM_TYPE
            FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE A
            WHERE SEQ = V_I;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;

        INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST
        ( DIVISION_ID, ITEM_ID, ITEM_TYPE )
        SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, V_EXCEPTION_ITEM_TYPE AS ITEM_TYPE
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        WHERE A.DIVISION_ID = V_EXCEPTION_DIVISION_ID
        AND   A.ITEM_ID LIKE '' || V_EXCEPTION_ITEM_ID || '%';

        V_I := V_I + 1;
    END LOOP;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST');

    ----------------------------------------------------------------------------------------------------------------------------
    -- 6.3).  #TEMP_EXCEPTION_ITEM_LIST에 존재하는 데이터는 NOT EXISTS 체크하여 VALIDATION 체크한다.
    ----------------------------------------------------------------------------------------------------------------------------
    BEGIN
        v_BIZ_TYPE_CHECK := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_BIZ_TYPE_CHECK
            FROM (
                SELECT T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
                FROM SCM_MGR.GT_PRDM1_T_MAIN T1
                LEFT JOIN LATERAL (
                    SELECT T2.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
                    FROM SCM_MGR.SCM_ITEM_M_SN T2
                    WHERE T1.DIVISION_ID = T2.DIVISION_ID
                      AND T1.ITEM_ID     = T2.ITEM_ID
                      AND T2.ACTIVE_FLAG = 'Y'
                ) T2 ON 1=1
                WHERE T1.ACTION = 'I'
                AND T2.FORECAST_INFO_BIZ_TYPE IS NULL
                GROUP BY T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
            ) A
            WHERE NOT EXISTS (
                SELECT B.ITEM_ID
                FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST B
                WHERE A.DIVISION_ID = B.DIVISION_ID
                  AND A.ITEM_ID     = B.ITEM_ID
                  AND A.ITEM_TYPE   = B.ITEM_TYPE
            )
            GROUP BY A.ITEM_ID
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_BIZ_TYPE_CHECK := NULL;
        END;

        --[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청 (END)
        IF v_BIZ_TYPE_CHECK IS NOT NULL THEN
            --BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
            V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK || '는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #6 게이트
    --==========================================================================================================================
    -- 6. 40 Validation 필요 대상 : BIZ_TYPE 존재여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A010--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 7. 40 Validation 필요 대상 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다 (START)
    --==========================================================================================================================
    v_CELL_TYPE_CHECK := NULL;

    IF v_is_81 = 'N' THEN  --[DIV81] CELL_PROD_SITE_ID 검증(#7)은 40 전용 (81 은 컬럼 부재 — '-' 정규화)
    BEGIN
        v_CELL_TYPE_CHECK := NULL;
        BEGIN
            SELECT LISTAGG(A.ITEM_ID, ',') WITHIN GROUP (ORDER BY A.ITEM_ID)
            INTO v_CELL_TYPE_CHECK
            FROM (
                SELECT T1.ITEM_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN T1
                LEFT JOIN SCM_MGR.SCM_ITEM_M_SN T2
                  ON T1.DIVISION_ID = T2.DIVISION_ID AND T1.ITEM_ID = T2.ITEM_ID
                WHERE (T2.FORECAST_INFO_BIZ_TYPE = 'CELL' OR T1.ITEM_ID LIKE 'MC%')
                  AND T1.CELL_PROD_SITE_ID = '-'
                  AND T2.ACTIVE_FLAG = 'Y'
                  AND NVL(T1.QTY_PRICE, 0) <> 0
                  AND (T1.ACTION = 'I'
                    OR NOT EXISTS (
                        SELECT 1 FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                        WHERE T1.DIVISION_ID       = X.DIVISION_ID
                          AND T1.PROJECT_CODE      = X.PROJECT_CODE
                          AND T1.END_CUSTOMER      = X.END_CUSTOMER
                          AND T1.SCM_SITE_ID       = X.SCM_SITE_ID
                          AND T1.PLANT_SITE_ID     = X.PLANT_SITE_ID
                          AND T1.CELL_PROD_SITE_ID = X.CELL_PROD_SITE_ID
                          AND T1.ITEM_ID           = X.ITEM_ID
                          AND T1.DOM_EXP           = X.DOM_EXP
                          AND T1.FCST_TYPE         = X.FCST_TYPE
                          AND T1.INCOTERMS         = X.INCOTERMS
                          AND X.MEASURE            = 'MKT_FCST'
                          AND X.YYYYMMDD           >= v_plan_start_yyyymmdd
                          AND X.QTY                <> 0
                    ))
                GROUP BY T1.ITEM_ID
                FETCH FIRST 10 ROWS ONLY
            ) A;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_CELL_TYPE_CHECK := NULL;
        END;

        IF v_CELL_TYPE_CHECK IS NOT NULL THEN
            V_DESCRIPTION := 'Model*: ' || v_CELL_TYPE_CHECK || '는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #7 게이트
    --==========================================================================================================================
    -- 7. 40 Validation 필요 대상 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A011--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (START)
    --==========================================================================================================================
    s_cell_prod_valid := NULL;

    IF v_is_81 = 'N' THEN  --[DIV81] CELL_PROD 검증(#8)은 40 전용
    BEGIN
        BEGIN
            SELECT A.ITEM_ID INTO s_cell_prod_valid
            FROM (
                SELECT P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID, P.ITEM_ID, P.YYYYMMDD
                     , P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID AS CELL_PROD_SITE_FCST, T.CELL_PROD_SITE_ID AS CELL_PROD_SITE_MAIN
                FROM SCM_MGR.GT_PRDM1_T_FCST P
                INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN T
                  ON T.DIVISION_ID      = P.DIVISION_ID
                 AND T.PROJECT_CODE     = P.PROJECT_CODE
                 AND T.END_CUSTOMER     = P.END_CUSTOMER
                 AND T.SCM_SITE_ID      = P.SCM_SITE_ID
                 AND T.PLANT_SITE_ID    = P.PLANT_SITE_ID
                 AND T.ITEM_ID          = P.ITEM_ID
                 AND T.YYYYMMDD         = P.YYYYMMDD
                 AND T.MEASURE          = P.MEASURE
                 AND T.DOM_EXP          = P.DOM_EXP
                 AND T.FCST_TYPE        = P.FCST_TYPE
                 AND T.INCOTERMS        = P.INCOTERMS
                 AND T.CELL_PROD_SITE_ID <> P.CELL_PROD_SITE_ID
                WHERE T.ACTION = 'I'
                GROUP BY P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID
                       , P.ITEM_ID, P.YYYYMMDD, P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID, T.CELL_PROD_SITE_ID
                HAVING P.CELL_PROD_SITE_ID = '-' OR T.CELL_PROD_SITE_ID = '-'
            ) A
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN s_cell_prod_valid := NULL;
        END;

        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #8 게이트
    --==========================================================================================================================
    -- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A012--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (START)
    -- Common 식별을 위해 Common의 Dash 값은 XX로 치환하고 XX 를 포함 두개 이상의 Cell Prod Site가 입력되었는지를 확인.
    --==========================================================================================================================
    s_cell_prod_valid := NULL;

    IF v_is_81 = 'N' THEN  --[DIV81] CELL_PROD 검증(#9)은 40 전용
    BEGIN
        BEGIN
            SELECT 'N' INTO s_cell_prod_valid
            FROM (
                SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
                     , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
                     , LISTAGG(CASE WHEN T.CELL_PROD_SITE_ID = '-' THEN 'XX' ELSE T.CELL_PROD_SITE_ID END, ', ')
                        WITHIN GROUP (ORDER BY T.CELL_PROD_SITE_ID) AS CELL_PROD_ALL
                FROM SCM_MGR.GT_PRDM1_T_MAIN T
                WHERE T.ACTION = 'I'
                GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
                       , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
                HAVING COUNT(*) > 1
            ) A
            WHERE INSTR(A.CELL_PROD_ALL, 'XX') > 0
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN s_cell_prod_valid := NULL;
        END;

        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;  --[DIV81] #9 게이트

    --==========================================================================================================================
    -- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A013--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 10. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (START)
    --==========================================================================================================================
    /* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨)  */
    INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2)
    SELECT MST.SEGMENT2
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST  -- SCM_FCST - MEASURE 추가, 아래의 룩업에 SCM_FCST 정보를 추가했습니다.
    WHERE MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND MST.SEGMENT1      = 'MEASURE'
    AND MST.VALID_YN      = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_MSHYCHU1');

    INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2)
    SELECT MST.SEGMENT2
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND MST.SEGMENT1      = 'FCST_TYPE'
    AND MST.VALID_YN      = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_MSHYCHU2');

    s_unit_price_valid := NULL;
    BEGIN
        SELECT 'End Customer________ : '   || NVL(A.END_CUSTOMER,  '')
            || CHR(10) || 'Sales site_____________ : ' || NVL(A.SCM_SITE_ID,   '')
            || CHR(10) || 'Model________________ : '   || NVL(A.ITEM_ID,       '')
            || CHR(10) || 'Customs Handbook__ : '      || NVL(A.DOM_EXP,       '')
            || CHR(10) || 'Fcst Type_____________ : '  || NVL((
                SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = A.FCST_TYPE
                FETCH FIRST 1 ROWS ONLY), '')
            || CHR(10) || 'Incoterms____________ : '   || NVL(A.INCOTERMS,     '')
            || CHR(10) || 'Plant Site___________ : '   || NVL(A.PLANT_SITE_ID, '')
            || CHR(10) || 'Cell Prod Site___________ : '|| NVL(A.CELL_PROD_SITE_ID, '')
            || CHR(10) || 'YYYYMMDD_________ : '       || NVL(MIN(M.BASIS_START_DATE), '') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE), '')
            || CHR(10) || CHR(10)
        INTO s_unit_price_valid
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
                ON A.DIVISION_ID = Z.DIVISION_ID
               AND A.PROJECT_CODE          = Z.PROJECT_CODE
               AND A.SCM_SITE_ID           = Z.SCM_SITE_ID
               AND A.ITEM_ID               = Z.ITEM_ID
               AND Z.VALID_YN              = 'Y'
               AND (Z.SALES_PLAN_ADJUST_YN = 'Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
        LEFT JOIN (
            SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M M
            -----------------------------------------------------------------------------------------------------------------------------------
            -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
            WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')  --당주 월요일부터
            AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')  -- 52주후 월요일까지
            -- [E20250825-000297]_52주구간 (END)
            -----------------------------------------------------------------------------------------------------------------------------------
            GROUP BY BASIS_START_DATE
        ) M ON 1=1
        LEFT JOIN SCM_MGR.GT_PRDM1_T_PRICE P
               ON A.DIVISION_ID       = P.DIVISION_ID
              AND A.PROJECT_CODE      = P.PROJECT_CODE
              AND A.END_CUSTOMER      = P.END_CUSTOMER
              AND A.SCM_SITE_ID       = P.SCM_SITE_ID
              --[E20260820-SENTINELDDL] 구 SENTINEL3 변형 동일 처리 삭제 — 단순 등호
              AND A.PLANT_SITE_ID     = P.PLANT_SITE_ID
              AND A.CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
              AND A.ITEM_ID           = P.ITEM_ID
              AND A.DOM_EXP           = P.DOM_EXP
              AND A.FCST_TYPE         = P.FCST_TYPE
              AND A.INCOTERMS         = P.INCOTERMS
              AND P.YYYYMMDD          = M.BASIS_START_DATE
              AND P.PRICE             > 0
        WHERE P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
          AND A.MEASURE IN (SELECT SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU1)
          AND A.QTY_PRICE <> 0
          --[E20260814-FCSTNAME] 통합테스트 No.49 — "수량·판가를 입력했는데 판가 미입력 팝업" 오탐 정정.
          --   제외 목록(MKT_FCST_VALIDATION_PRICE / SEGMENT1='FCST_TYPE')은 **코드**(ASF·SDF·SMF·SPF·
          --   TST·WSF)로만 적재되는데, FCST_TYPE 이 **명칭**('Spare Parts(FREE)' 등)으로 들어온 행은
          --   NOT IN 을 그대로 통과해 52주 판가 게이트에 걸렸다.
          --   실측(2026-08-14 게이트 시뮬): 같은 데이터셋이 'SPF' → 위반 0건(정상 제외) /
          --                                'Spare Parts(FREE)' → 위반 62주(오탐 차단).
          --   명칭 유입은 가정이 아니라 원장 실재다 — DM_PLN_CFM_SELLING_PRICE(div 40)에
          --   FCST_TYPE='Mass' 585행(AS-IS 원장에도 105행) 존재. 즉 AS-IS 부터의 혼재이므로
          --   입력측 교정만으로는 기존 행을 구제하지 못한다 ⇒ 판정측에서 코드·명칭 양쪽을 제외한다.
          AND A.FCST_TYPE NOT IN (
                  SELECT X.SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU2 X          /* 코드 (원 조건) */
                  UNION ALL
                  SELECT L.SEGMENT2                                            /* 그 코드의 명칭 */
                  FROM   SCM_MGR.GT_PRDM1_MSHYCHU2 X
                  JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                         ON L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND L.VALID_YN    = 'Y'
                        AND L.SEGMENT1    = X.SEGMENT2 )
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
               , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD
        ORDER BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
               , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION WHEN NO_DATA_FOUND THEN s_unit_price_valid := NULL;
    END;

    IF s_unit_price_valid IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := s_unit_price_valid || 'Unit Price Not Found !' || CHR(10)
                      || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                      || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
        RAISE e_validation_error;
    END IF;

    --==========================================================================================================================
    -- 10. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A014--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 11. 40 Validation 필요 대상 : RMA 음수 Validation은 MKT_FCST, SCM_FCST Measure에 한정 필요 (START)
    --==========================================================================================================================
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE FCST_TYPE = 'RMA'
      AND MEASURE IN ('MKT_FCST', 'SCM_FCST')
      AND NVL(CAST(QTY_PRICE AS NUMBER(30,10)), 0) > 0;

    IF v_cnt_check > 0 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '반품수량(RMA)은 음수값만 입력가능합니다 !';
        RAISE e_validation_error;
    END IF;
    --==========================================================================================================================
    -- 11. 40 Validation 필요 대상 : RMA 음수 Validation은 MKT_FCST, SCM_FCST Measure에 한정 필요 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A015--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 12. 40 Validation 필요 대상 : RMA 이외 정수값 확인 (START)
    --==========================================================================================================================
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE FCST_TYPE <> 'RMA'
      AND NVL(CAST(QTY_PRICE AS NUMBER(30,10)), 0) < 0;

    IF v_cnt_check > 0 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '정수값만 입력가능합니다 !';
        RAISE e_validation_error;
    END IF;
    --==========================================================================================================================
    -- 12. 40 Validation 필요 대상 : RMA 이외 정수값 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A016--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 13. 40 Validation 필요 대상 :  BOM Valid 여부 확인 (START)
    -- 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함
    --==========================================================================================================================
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET V_BOM_YN = 'N'
    WHERE EXISTS (
        SELECT 1
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
        JOIN SCM_MGR.SCM_MST_ITEM_SN C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
        JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D ON D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS' AND D.VALID_YN = 'Y' AND C.EVAL_CLASS = D.SEGMENT1
        WHERE B.LOOKUP_TYPE = 'AS_SITE_PLANT'
          AND B.SEGMENT3    = V_DIVISION_ID
          AND B.VALID_YN    = 'Y'
          AND A.V_ATTRIBUTE10 = B.SEGMENT2
    )
    AND A.DIVISION_ID = V_DIVISION_ID
    AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST'); --SCM_FCST - MEASURE 추가

    SELECT COUNT(*) INTO v_cnt_check FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE V_BOM_YN IS NULL;

    IF v_cnt_check > 0 THEN
        -- 저장전 변수 초기화
        v_valid_bom  := NULL;
        v_valid_shipto := NULL;

        BEGIN
            SELECT A.ITEM_ID INTO v_valid_bom
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V C
                    ON A.ITEM_ID       = C.ITEM_ID
                   AND A.DIVISION_ID   = C.DIVISION_ID
                   AND C.ITEM_TYPE IN ('P', 'H')
                   AND C.ACTIVE_FLAG   = 'Y'
            LEFT JOIN SCM_MGR.SCM_MST_BOM_ENG_SN X
                   ON A.DIVISION_ID = X.DIVISION_ID AND A.ITEM_ID = X.PARENT_ITEM_ID
            LEFT JOIN (
                SELECT DIVISION_ID
                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END FROM_SITE  /* 2026.08.15 AJS 하이픈통일 02 작업지시 1순위 4자리 + MSSQL 원본 1305/1308/1348/1351 등가('82' 누락 정정) */
                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                FROM SCM_MGR.SCP_MST_BOD_V
                WHERE PRIORITY = 1
                GROUP BY DIVISION_ID
                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END  /* 2026.08.15 AJS 하이픈통일 02 작업지시 1순위 4자리 + MSSQL 원본 1305/1308/1348/1351 등가('82' 누락 정정) */
                       , TO_SITE, INCOTERMS
            ) BOD ON A.DIVISION_ID  = BOD.DIVISION_ID
                 AND A.PLANT_SITE_ID = BOD.FROM_SITE
                 AND A.SCM_SITE_ID   = BOD.TO_SITE
                 AND A.INCOTERMS     = BOD.INCOTERMS
            WHERE A.MEASURE IN ('MKT_FCST', 'Vmi_In_Req', 'SCM_FCST') --SCM_FCST - MEASURE 추가
              AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND A.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') + NVL(BOD.LT_TOTAL, 0) + 7 * 10, 'YYYYMMDD')   -- 당주 월요일 + 11주 까지
              AND A.QTY_PRICE > 0
              AND X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
              AND A.ITEM_ID NOT IN ('ECE0074N5-01')
              AND A.ITEM_ID NOT IN ('MCCH120022B2-K', 'MCCH120022B2-GD')
              AND A.V_BOM_YN IS NULL
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_bom := NULL;
        END;

        IF v_valid_bom IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_bom || '] BOM does not exist !';
            RAISE e_validation_error;
        END IF;
    END IF;

    --==========================================================================================================================
    -- 14. 40 Validation 필요 대상 :  BOM Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A017--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 15. 40 Validation 필요 대상 :  ShipTo Valid 여부 확인 (START)
    -- 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함
    --==========================================================================================================================
    BEGIN
        v_valid_shipto := NULL;
        BEGIN
            SELECT A.SCM_SITE_ID INTO v_valid_shipto
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER X
                   ON A.DIVISION_ID = X.DIVISION_ID
                  AND A.SCM_SITE_ID = X.SCM_SITE_ID
                  AND X.VALID_YN    = 'Y'
                  AND X.REP_YN      = 'Y'
            LEFT JOIN (
                SELECT DIVISION_ID
                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END FROM_SITE  /* 2026.08.15 AJS 하이픈통일 02 작업지시 1순위 4자리 + MSSQL 원본 1305/1308/1348/1351 등가('82' 누락 정정) */
                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                FROM SCM_MGR.SCP_MST_BOD_V
                WHERE PRIORITY = 1
                GROUP BY DIVISION_ID
                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END  /* 2026.08.15 AJS 하이픈통일 02 작업지시 1순위 4자리 + MSSQL 원본 1305/1308/1348/1351 등가('82' 누락 정정) */
                       , TO_SITE, INCOTERMS
            ) BOD ON A.DIVISION_ID  = BOD.DIVISION_ID
                 AND A.PLANT_SITE_ID = BOD.FROM_SITE
                 AND A.SCM_SITE_ID   = BOD.TO_SITE
                 AND A.INCOTERMS     = BOD.INCOTERMS
            WHERE A.MEASURE IN ('MKT_FCST', 'Vmi_In_Req', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
              AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')   -- 당주 월요일부터
              AND A.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') + NVL(BOD.LT_TOTAL, 0) + 7 * 3, 'YYYYMMDD')   -- BOD LT + 4W
              AND A.QTY_PRICE > 0
              AND X.SHIPTO_CODE IS NULL
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_shipto := NULL;
        END;

        IF v_valid_shipto IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_shipto || '] SITE SHIP-TO does not exist !';
            RAISE e_validation_error;
        END IF;
    END;
    --==========================================================================================================================
    -- 15. 40 Validation 필요 대상 :  ShipTo Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A018--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (START)
    --==========================================================================================================================
    v_plan_start_yyyymmdd := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  -- 월요일 변수설정

    IF v_is_81 = 'N' THEN  --[DIV81] RMA→RTF 생성(#16)은 40 전용 (40 테이블 DML)
    --[E20260820-SENTINELDDL] 구 [PK-NN] N1 정규화 UPDATE 삭제 — GT_PRDM1_T_MAIN 키 13컬럼이
    --  DEFAULT ON NULL '-' NOT NULL 로 승격되어(2026-08-20 DDL) NULL 이 스키마에서 원천 차단됨.
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE = 'RTF_SYS_RP'
      AND A.YYYYMMDD >= v_plan_start_yyyymmdd -- 당주 월요일이후
      AND EXISTS (
            SELECT RSLT.DIVISION_ID
            FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
               , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
            WHERE RSLT.DIVISION_ID         = ITEM.DIVISION_ID
              AND RSLT.ITEM_ID             = ITEM.ITEM_ID
              AND A.DIVISION_ID            = RSLT.DIVISION_ID
              AND A.PROJECT_CODE           = RSLT.PROJECT_CODE
              AND A.END_CUSTOMER           = RSLT.END_CUSTOMER
              AND A.SCM_SITE_ID            = RSLT.SCM_SITE_ID
              AND A.ITEM_ID                = RSLT.ITEM_ID
              AND A.DOM_EXP                = RSLT.DOM_EXP
              AND A.FCST_TYPE              = RSLT.FCST_TYPE
              AND A.INCOTERMS              = RSLT.INCOTERMS
              AND A.PLANT_SITE_ID          = RSLT.PLANT_SITE_ID
              AND A.CELL_PROD_SITE_ID      = RSLT.CELL_PROD_SITE_ID
              AND ITEM.ACTIVE_FLAG         = 'Y'
              AND RSLT.FCST_TYPE           = 'RMA'
      );

    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    , PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
    , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
    SELECT RSLT.DIVISION_ID, RSLT.PROJECT_CODE, RSLT.END_CUSTOMER, RSLT.SCM_SITE_ID, RSLT.ITEM_ID
         , RSLT.DOM_EXP, RSLT.FCST_TYPE, RSLT.INCOTERMS, 'RTF_SYS_RP' AS MEASURE
         , RSLT.PLANT_SITE_ID, RSLT.YYYYMMDD
         --[E20260309-000271]_ISNULL처리 추가 (START)
         , NVL(RSLT.QTY_PRICE, 0) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
         --[E20260309-000271]_ISNULL처리 추가 (END)
         , 'SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
         , RSLT.V_ATTRIBUTE1, RSLT.V_ATTRIBUTE2, RSLT.V_ATTRIBUTE3, RSLT.V_ATTRIBUTE4, RSLT.V_ATTRIBUTE5
         , RSLT.V_ATTRIBUTE6, RSLT.V_ATTRIBUTE7, RSLT.V_ATTRIBUTE8, RSLT.V_ATTRIBUTE9, RSLT.V_ATTRIBUTE10
         , RSLT.CELL_PROD_SITE_ID
    FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
    INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
            ON RSLT.DIVISION_ID  = ITEM.DIVISION_ID
           AND RSLT.ITEM_ID      = ITEM.ITEM_ID
           AND ITEM.ACTIVE_FLAG  = 'Y'
           AND RSLT.FCST_TYPE    = 'RMA'
    WHERE RSLT.MEASURE IN ('MKT_FCST', 'SCM_FCST') -- SCM_FCST - MEASURE 추가
      AND RSLT.YYYYMMDD >= v_plan_start_yyyymmdd; -- 당주 월요일이후
    END IF;  --[DIV81] #16 게이트

    --==========================================================================================================================
    -- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A018_cont--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 17. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (START)
    -- DM_PLN_CFM_SELLING_PRICE Validation Check
    --==========================================================================================================================
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE (DIVISION_ID LIKE '81%' OR DIVISION_ID = '82' OR DIVISION_ID = '40');

    IF v_cnt_check > 0 THEN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITEM
                         ON ITEM.DIVISION_ID = A.DIVISION_ID
                        AND ITEM.SCM_SITE_ID = A.SCM_SITE_ID
                        AND ITEM.ITEM_ID     = A.ITEM_ID
                        AND ITEM.VALID_YN    = 'Y'
            LEFT OUTER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SN
                         ON ITEM.DIVISION_ID = SN.DIVISION_ID
                        AND ITEM.ITEM_ID     = SN.ITEM_ID
                        AND SN.ACTIVE_FLAG   = 'Y'
            WHERE A.QTY_PRICE <> 0
              AND (ITEM.ITEM_ID IS NULL OR SN.ITEM_ID IS NULL)
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Site Item ID !';
            RAISE e_validation_error;
        END IF;
    END IF;

    --==========================================================================================================================
    -- 17. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A019--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- Measure가 LOC이면서 , 같은 월의 같은 주차의 합이 0이라면 D로 업데이트 한다. 그 외는 M으로 업데이트 한다. (START)
    --==========================================================================================================================
    --[E20260822-LOCWEEKSUM] 주차 합계가 '일 합계' 로 축소된 변환 결함 정정 (2026-08-22).
    --   구 구현은 바깥 행 날짜에 맞추는 상관 조건을 **서브쿼리 안**에 두어, 윈도우 함수가 돌기 전에
    --   행이 그 날짜 1건으로 좁혀졌다 → PARTITION BY 주차가 무의미해지고 **하루치 합계**로 판정됐다.
    --   실사고: FE 가 주 단가를 (월=5301, 화~일=0) 로 보내면 0 인 6일이 각각 ACTION='D' 가 되어
    --   검증 #18(SALES PRICE 삭제 시 52주 FCST 확인)이 **수정인데** 발동, 저장이 막혔다.
    --   AS-IS(MSSQL)는 파생테이블에서 전체 LOC 행에 파티션 합계를 먼저 구하고 **바깥에서** 날짜로 조인한다:
    --       UPDATE #T_MAIN SET [ACTION] = DD.[ACTION]
    --       FROM ( SELECT CASE WHEN SUM(A.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW + D.PARTIAL_WEEK_NAME) = 0
    --                          THEN 'D' ELSE 'M' END AS [ACTION], D.BASIS_YYYYMMDD
    --              FROM #T_MAIN A JOIN SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
    --              WHERE A.MEASURE='LOC' AND A.[ACTION] <> 'I' ) DD
    --       WHERE YYYYMMDD = DD.BASIS_YYYYMMDD AND MEASURE='LOC'
    --   그 구조를 그대로 살린다. MAX(ACT) 는 중복 제거용 — 같은 날짜는 같은 주차라 ACT 가 행마다 동일하다.
    --   `A.ACTION <> 'I'` 는 ON 이 아니라 UPDATE 의 WHERE 에 둔다(Oracle 은 ON 절 컬럼을 갱신 못 함).
    MERGE INTO SCM_MGR.GT_PRDM1_T_MAIN A
    USING (
        SELECT BASIS_YYYYMMDD, MAX(ACT) AS ACT
        FROM (
            SELECT D.BASIS_YYYYMMDD
                 , CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW || D.PARTIAL_WEEK_NAME) = 0
                        THEN 'D' ELSE 'M' END AS ACT
            FROM SCM_MGR.GT_PRDM1_T_MAIN B
            JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
            WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
        )
        GROUP BY BASIS_YYYYMMDD
    ) S
    ON (A.YYYYMMDD = S.BASIS_YYYYMMDD AND A.MEASURE = 'LOC')
    WHEN MATCHED THEN UPDATE SET A.ACTION = S.ACT WHERE A.ACTION <> 'I';
    --==========================================================================================================================
    -- Measure가 LOC이면서 , 같은 월의 같은 주차의 합이 0이라면 D로 업데이트 한다. 그 외는 M으로 업데이트 한다.(END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A020--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 18. 40 Validation 필요 대상 : SALES PRICE를 삭제하는 경우 52주간 MKT FCST or RTF 데이터 확인 (START)
    --==========================================================================================================================
    v_invalid_Site := NULL;
    n_Dflag_chk    := 0;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- ACTIVE_FLAG가 한건이라도 D인경우에만 처리한다.
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO n_Dflag_chk
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE = 'LOC' AND ACTION = 'D';  -- Delete 가능 - UI에서 MKT_FCST를 D로 보내는 경우가 있어서 작성함.

    IF n_Dflag_chk > 0 THEN
      IF v_is_81 = 'N' THEN  --[DIV81] #18 분기: 40=DM_PLN_CFM_MKT_DEMAND_PLAN / 81=DM_PLN_MKT_FCST(하단 ELSE)
        -----------------------------------------------------------------------------------------------------------------------------------
        -- 52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.
        -----------------------------------------------------------------------------------------------------------------------------------
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req', 'SCM_FCST') -- SCM_FCST - MEASURE 추가
                      AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                      -----------------------------------------------------------------------------------------------------------------------------------
                      -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (START)
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      -- [E20250825-000297]_(END)
                      -----------------------------------------------------------------------------------------------------------------------------------
                      AND B.ISO_YYYYWW = D.ISO_YYYYWW
                      AND F.QTY <> 0  -- 제로값은 제외함
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )  -- 무상제공인경우는 Validation 에서 제외
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;

        -----------------------------------------------------------------------------------------------------------------------------------
        -- 52주 이내의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.
        -----------------------------------------------------------------------------------------------------------------------------------
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req', 'SCM_FCST')  -- SCM_FCST - MEASURE 추가
                      AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                      -----------------------------------------------------------------------------------------------------------------------------------
                      -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') -- 당주 월요일 이후건만 확인
                      AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD') -- 52주후 월요일까지
                      -- [E20250825-000297]_(END)
                      -----------------------------------------------------------------------------------------------------------------------------------
                      AND F.QTY <> 0  -- 제로값은 제외함
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )  -- 무상제공인경우는 Validation 에서 제외
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
      ELSE
        --[DIV81] 18-81). Price 삭제 시 52주 FCST 확인 — DM_PLN_MKT_FCST 기준 (정본 DMF0020 L545~670 이식)
        --  키 8종 (END_CUSTOMER/CELL_PROD 제외), 대상 MEASURE = MKT_FCST/RTF_SCP/AS_In_Req (81 정본 — SCM_FCST 없음)
        -- (a) 52주 이후 동일 주차 존재 확인
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req')
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND B.ISO_YYYYWW = D.ISO_YYYYWW
                      AND F.QTY <> 0
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;

        -- (b) 52주 이내 존재 확인
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req')
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND F.QTY <> 0
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
      END IF;  --[DIV81] #18 분기
    END IF;

    --==========================================================================================================================
    -- 18. 40 Validation 필요 대상 : SALES PRICE를 삭제하는 경우 52주간 MKT FCST or RTF 데이터 확인 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A021--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    --[DIV81] 19. 81 전용 Validation (V81-01 ~ V81-11) — 정본: DMF0003_SAVE_MKT_FCST / DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (START)
    --==========================================================================================================================
    IF v_is_81 = 'Y' THEN

        -- V81-01. 필수 컬럼 + PLANT_SITE_ID 필수 (DMF0003 L566 이식 + plant site 요구사항 2026-07-14)
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        --[E20260820-SENTINELDDL] NVL 언랩 — GTT 키 컬럼 DEFAULT ON NULL '-' NOT NULL 승격으로 NULL 불가
        WHERE A.DIVISION_ID   = '-'
           OR A.PROJECT_CODE  = '-'
           OR A.SCM_SITE_ID   = '-'
           OR A.ITEM_ID       = '-'
           OR A.DOM_EXP       = '-'
           OR A.FCST_TYPE     = '-'
           OR A.INCOTERMS     = '-'
           OR A.MEASURE       = '-'
           OR A.PLANT_SITE_ID = '-';

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook or Plant Site ) !';
            RAISE e_validation_error;
        END IF;

        -- V81-02. AS PLANT 로 가는 DP 의 INCOTERMS 제한 (DMF0003 L731 이식 — C 조인 무필터 포함 정본 그대로)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.DIVISION_ID  = B.SEGMENT3
         AND   A.SCM_SITE_ID  = B.SEGMENT1
         AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT'
         AND   B.VALID_YN     = 'Y'
        LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.DIVISION_ID  = C.SEGMENT1
         AND   A.INCOTERMS    = C.SEGMENT2
         AND   C.VALID_YN     = 'Y'
        WHERE  C.SEGMENT1 IS NULL;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.';
            RAISE e_validation_error;
        END IF;

        -- V81-03. Invalid Project Code (DMF0003 L847 ≡ DMF0020 L280 이식)
        V_VALID_PROJECT_CODE := NULL;
        BEGIN
            SELECT A.PROJECT_CODE INTO V_VALID_PROJECT_CODE
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE  NOT EXISTS (
                       SELECT C.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_PROJECT C
                       WHERE  A.DIVISION_ID  = C.DIVISION_ID
                         AND  A.PROJECT_CODE = C.PROJECT_CODE
                         AND  C.DIVISION_ID <> '40'
                   )
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN V_VALID_PROJECT_CODE := NULL;
        END;

        IF V_VALID_PROJECT_CODE IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_PROJECT_CODE || '] Invalid Project Code !';
            RAISE e_validation_error;
        END IF;

        -- V81-04. Cell/Module/Pack 인데 CELL_PER_CAR 미등록 (DMF0003 L1123 이식 — 스테이징 GTT 대신 뷰 직조인)
        --   [E20260820-XLSSAVEPERF] DM_MST_ITEM_SINGLE_V 직조인 폐지 — 소비 컬럼(ITEM_CLASS_NAME)은
        --   뷰의 T1 축(SCM_MST_ITEM_SN GROUP BY DIVISION_ID, ITEM_ID 의 MAX)에서만 오므로 뷰 내부
        --   T2(SUBSTR 셀프조인)가 불필요. 뷰 직조인은 JPPD 시 키별 PK SKIP SCAN(15키 407s),
        --   NO_MERGE 힌트 시 뷰 전체 실체화(30.6s) — 둘 다 병목 (ASH 실측 2026-08-20).
        --   행 존재성 동치 근거: 뷰의 T2 는 동일 테이블 셀프집계 INNER JOIN 이라 T1 행이 있으면 항상 매칭.
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
              ON   A.DIVISION_ID  = F.DIVISION_ID
             AND   A.ITEM_ID      = F.ITEM_ID
             AND   A.PROJECT_CODE = F.PROJECT_CODE
             AND   A.SCM_SITE_ID  = F.SCM_SITE_ID
            JOIN   (SELECT SN.DIVISION_ID, SN.ITEM_ID, MAX(SN.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
                    FROM   SCM_MGR.SCM_MST_ITEM_SN SN
                    GROUP  BY SN.DIVISION_ID, SN.ITEM_ID) X
              ON   A.DIVISION_ID = X.DIVISION_ID
             AND   A.ITEM_ID     = X.ITEM_ID
            WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        ELSE 0
                   END = 1
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            BEGIN
                SELECT CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 THEN 'Cell/Car or Cell/Module'
                            ELSE 'Cell/Car' END
                INTO   V_VALID_TYPE
                FROM   (SELECT MAX(SN.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME  --[E20260820-XLSSAVEPERF] 뷰 대체(T1 축 동치)
                        FROM   SCM_MGR.SCM_MST_ITEM_SN SN
                        WHERE  SN.ITEM_ID = v_valid_item_id
                        GROUP  BY SN.DIVISION_ID) X
                WHERE  ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN V_VALID_TYPE := '-';
            END;
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] ' || V_VALID_TYPE || ' does not exist !';
            RAISE e_validation_error;
        END IF;

        -- V81-05. Kwh/Cell(ATTRIBUTE8) / CELL_TYPE(ATTRIBUTE10) / CELL_PER_CAR 필수 (DMF0003 L1170 이식)
        V_DESC_81 := NULL;
        BEGIN
            SELECT V_DESCRIPTION_81 INTO V_DESC_81
            FROM (
                SELECT '[' || RTRIM(A.ITEM_ID) || '] '
                    || CASE WHEN (NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                                  OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0)
                            THEN 'Kwh/Cell does not exist !'
                            WHEN B.ATTRIBUTE10 NOT IN (
                                     SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND (SEGMENT1 LIKE '81%' OR SEGMENT1 = '82') AND VALID_YN = 'Y'
                                 )
                            THEN 'CELL_TYPE does not exist !'
                            WHEN NVL(B.CELL_PER_CAR,0) <= 0
                            THEN 'Cell/Car does not exist !'
                       END
                    || CHR(10) || 'Sales Site Project Model 에서 해당 항목을 채워주세요.' AS V_DESCRIPTION_81
                FROM SCM_MGR.GT_PRDM1_T_MAIN A
                JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                  ON A.DIVISION_ID  = B.DIVISION_ID
                 AND A.PROJECT_CODE = B.PROJECT_CODE
                 AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                 AND A.ITEM_ID      = B.ITEM_ID
                JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V C
                  ON A.DIVISION_ID  = C.DIVISION_ID
                 AND A.ITEM_ID      = C.ITEM_ID
                 AND C.ITEM_TYPE    = 'P'
                WHERE (
                        ( NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                          OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0 )
                        OR B.ATTRIBUTE10 NOT IN (
                               SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND (SEGMENT1 LIKE '81%' OR SEGMENT1 = '82') AND VALID_YN = 'Y'
                           )
                        OR NVL(B.CELL_PER_CAR,0) <= 0
                      )
                ORDER BY A.ITEM_ID
                FETCH FIRST 1 ROW ONLY
            );
        EXCEPTION WHEN NO_DATA_FOUND THEN V_DESC_81 := NULL;
        END;

        IF V_DESC_81 IS NOT NULL THEN
            V_DESCRIPTION := V_DESC_81;
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;

        -- V81-06. Invalid Item ID (DMF0020 L324 이식 — ITEM_SN 존재)
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I WHERE I.ITEM_ID = A.ITEM_ID)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Item ID !';
            RAISE e_validation_error;
        END IF;

        -- V81-07. Invalid Sales Site (DMF0020 L365 [V20260708] 이식 — 조회 JOIN 정합. price 행 한정 + 삭제행 제외)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE  R.ACTION <> 'D'
          AND  R.MEASURE = 'LOC'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                   WHERE  S.DIVISION_ID = R.DIVISION_ID
                     AND  S.SCM_SITE_ID = R.SCM_SITE_ID
                     AND  S.SITE_TYPE   = 'SALES'
                     AND  S.VALID_YN    = 'Y'
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'Invalid Sales Site ! (Sales Site 마스터 미등록/무효 - Sales Price 는 저장해도 조회되지 않아 저장 차단)';
            RAISE e_validation_error;
        END IF;

        -- V81-08. Invalid Item for Division (DMF0020 L421 이식 — 사업부 Item 마스터. 삭제행 제외)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE  R.ACTION <> 'D'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                   WHERE  I.DIVISION_ID = R.DIVISION_ID
                     AND  I.ITEM_ID     = R.ITEM_ID
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'Invalid Item for Division ! (해당 사업부 Item 마스터 미등록 - 저장 차단)';
            RAISE e_validation_error;
        END IF;

        -- V81-09. 동일 기간 Currency 중복 (DMF0020 L675 이식 — KRW/USD 파생 전이므로 LOC 기준)
        SELECT COUNT(1) INTO v_cnt_check
        FROM (
            SELECT 1 AS DUP
            FROM SCM_MGR.GT_PRDM1_T_MAIN
            WHERE MEASURE = 'LOC' AND NVL(QTY_PRICE, 0) <> 0
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            HAVING COUNT(CURRENCY) > 1
        );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
            RAISE e_validation_error;
        END IF;

        -- V81-10. 신규(I) Price 행이 SCM_MST_FUTURE_PRICE 에 기존재 (DMF0020 L710 이식)
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN R
                   WHERE  S.DIVISION_ID   = R.DIVISION_ID
                     AND  S.PROJECT_CODE  = R.PROJECT_CODE
                     AND  S.SCM_SITE_ID   = R.SCM_SITE_ID
                     AND  S.PLANT_SITE_ID = R.PLANT_SITE_ID
                     AND  S.ITEM_ID       = R.ITEM_ID
                     AND  S.YYYYMMDD      = R.YYYYMMDD
                     AND  S.MEASURE       = R.MEASURE
                     AND  S.DOM_EXP       = R.DOM_EXP
                     AND  S.FCST_TYPE     = R.FCST_TYPE
                     AND  S.INCOTERMS     = R.INCOTERMS
                     AND  R.ACTION        = 'I'
                     AND  R.MEASURE       = 'LOC'
               )
          AND  ROWNUM = 1;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
            RAISE e_validation_error;
        END IF;

        -- V81-11. AS 계열 FCST TYPE 신규(I) — AS FROM SITE 미전달 행만 차단([E20260805-AFS] p_as_from_site 신설로 완화).
        --  고객향 사이트(AS_SITE_PLANT 미등재) + AS 계열 + V_ATTRIBUTE10 공백 = 불완전 저장 차단 (DMF0003 MSG00476 계보).
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.FCST_TYPE   = C.SEGMENT1
         AND   C.LOOKUP_TYPE = 'SALES_TYPE_CODE'
         AND   C.ATTRIBUTE2  = 'Y'
        WHERE  A.ACTION = 'I'
          AND  (A.V_ATTRIBUTE10 IS NULL OR TRIM(A.V_ATTRIBUTE10) = '')  --[E20260805-AFS] AS FROM SITE 전달 시 신규 허용
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                   WHERE  A.SCM_SITE_ID = B.SEGMENT1
                     AND  B.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND  B.SEGMENT3    = A.DIVISION_ID
                     AND  B.VALID_YN    = 'Y'
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS 관련 FCST TYPE 의 신규 입력은 AS FROM SITE 지정이 필요합니다.';  --[E20260805-AFS]
            RAISE e_validation_error;
        END IF;

    END IF;
    --==========================================================================================================================
    --[DIV81] 19. 81 전용 Validation (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- Validaion Check (END)
    --==========================================================================================================================
    --==========================================================================================================================
    -- VALIDATION 종료 (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 3. VALIDATION CHECK END';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- VALIDATION 종료 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- #T_MAIN 테이블에 메져를 추가한다. (START)
    -- DM_PLN_CFM_SELLING_PRICE 테이블 기준 MEASURE
    -- 'KRW','USD','LOC'
    --  KRW , USD 2개를 만드는 로직 추가해야함
    --==========================================================================================================================
    ----------------------------------------------------------------------------------------------------------------------------
    -- 1. 환율정보 가져옴.
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCH
    ( DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE )
    SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
    FROM SCM_MGR.DM_MST_EXCHANGE_RATE A
    JOIN SCM_MGR.GT_PRDM1_T_MAIN B
      ON A.DIVISION_ID = B.DIVISION_ID
     AND A.YYYYMMDD   = SUBSTR(B.YYYYMMDD, 1, 6) || '01'
     AND A.CURRENCY   = 'KRW'
    WHERE B.MEASURE = 'LOC';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCH');

    ----------------------------------------------------------------------------------------------------------------------------
    -- 2. KRW, USD 메져 환율정보로 계산하여 추가
    ----------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY
    , QTY_PRICE, CREATED_BY
    , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5, V_ATTRIBUTE6
    , V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
    SELECT T.ACTION, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
         , 'KRW' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
         --[E20260309-000271]_ISNULL처리 추가 (START)
         , ROUND(NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
         --[E20260309-000271]_ISNULL처리 추가 (END)
         , T.CREATED_BY, '', '', '', '', '', '', '', '', '', '', '', ''
    FROM SCM_MGR.GT_PRDM1_T_MAIN T
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH EX
                 ON EX.DIVISION_ID   = T.DIVISION_ID
                AND EX.UNIT_CURRENCY = T.CURRENCY
                AND EX.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
                AND EX.CURRENCY      = 'KRW'
    WHERE T.MEASURE = 'LOC'
    UNION ALL
    SELECT T.ACTION, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
         , 'USD' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
         --[E20260309-000271]_ISNULL처리 추가 (START)
         , ROUND(ROUND((NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END), 3) / USD.EXCHANGE_PRICE, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
         --[E20260309-000271]_ISNULL처리 추가 (END)
         , T.CREATED_BY, '', '', '', '', '', '', '', '', '', '', '', ''
    FROM SCM_MGR.GT_PRDM1_T_MAIN T
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH EX
                 ON EX.DIVISION_ID   = T.DIVISION_ID
                AND EX.UNIT_CURRENCY = T.CURRENCY
                AND EX.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH USD
                 ON USD.DIVISION_ID   = T.DIVISION_ID
                AND USD.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
                AND USD.CURRENCY      = 'KRW'
                AND USD.UNIT_CURRENCY = 'USD'
    WHERE T.MEASURE = 'LOC';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A022--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------
    -- 3. MKT_AMT_KRW, MKT_AMT_LOC 메져 환율정보로 계산하여 추가
    ----------------------------------------------------------------------------------------------------------------------------
    IF v_is_81 = 'N' THEN  --[DIV81] 81 은 MKT_AMT 메져 미사용 (2026-07-14 실측: 81 measure 인벤토리 부재)
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY
    , QTY_PRICE, CREATED_BY
    , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5, V_ATTRIBUTE6
    , V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
    SELECT AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID, AMT.DOM_EXP, AMT.FCST_TYPE
         , AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD, MAX(AMT.CURRENCY) AS CURRENCY
         , SUM(AMT.QTY) AS QTY
         , MAX(AMT.CREATED_BY) AS CREATED_BY, MAX(AMT.V_ATTRIBUTE1) AS V_ATTRIBUTE1, MAX(AMT.V_ATTRIBUTE2) AS V_ATTRIBUTE2
         , MAX(AMT.V_ATTRIBUTE3) AS V_ATTRIBUTE3, MAX(AMT.V_ATTRIBUTE4) AS V_ATTRIBUTE4, MAX(AMT.V_ATTRIBUTE5) AS V_ATTRIBUTE5
         , MAX(AMT.V_ATTRIBUTE6) AS V_ATTRIBUTE6, MAX(AMT.V_ATTRIBUTE7) AS V_ATTRIBUTE7, MAX(AMT.V_ATTRIBUTE8) AS V_ATTRIBUTE8
         , MAX(AMT.V_ATTRIBUTE9) AS V_ATTRIBUTE9, MAX(AMT.V_ATTRIBUTE10) AS V_ATTRIBUTE10
         , MAX(AMT.V_BOM_YN) AS V_BOM_YN, MAX(AMT.V_VMI_YN) AS V_VMI_YN
    FROM (
        SELECT W.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN W
        INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
        UNION ALL
        SELECT W.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN W
        INNER JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W2
                          WHERE W2.DIVISION_ID       = W.DIVISION_ID
                            AND W2.PROJECT_CODE      = W.PROJECT_CODE
                            AND W2.END_CUSTOMER      = W.END_CUSTOMER
                            AND W2.SCM_SITE_ID       = W.SCM_SITE_ID
                            AND W2.ITEM_ID           = W.ITEM_ID
                            AND W2.DOM_EXP           = W.DOM_EXP
                            AND W2.FCST_TYPE         = W.FCST_TYPE
                            AND W2.INCOTERMS         = W.INCOTERMS
                            AND W2.PLANT_SITE_ID     = W.PLANT_SITE_ID
                            AND W2.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                            AND W2.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
                            AND W2.MEASURE IN ('LOC', 'KRW'))
        UNION ALL
        SELECT SP.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , SP.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN W
        INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W2
                          WHERE W2.DIVISION_ID       = W.DIVISION_ID
                            AND W2.PROJECT_CODE      = W.PROJECT_CODE
                            AND W2.END_CUSTOMER      = W.END_CUSTOMER
                            AND W2.SCM_SITE_ID       = W.SCM_SITE_ID
                            AND W2.ITEM_ID           = W.ITEM_ID
                            AND W2.DOM_EXP           = W.DOM_EXP
                            AND W2.FCST_TYPE         = W.FCST_TYPE
                            AND W2.INCOTERMS         = W.INCOTERMS
                            AND W2.PLANT_SITE_ID     = W.PLANT_SITE_ID
                            AND W2.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                            AND W2.YYYYMMDD          = W.YYYYMMDD
                            AND W2.MEASURE           = W.MEASURE)
        --[E20251208-000309]_0인 경우를 처리하는 로직이 존재하지 않아서, 0인 경우에 MKT FCST AMT 생성하도록 추가 (START)
        UNION ALL
        SELECT T.ACTION AS ACT, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID
             , T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, B.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
             --[E20260309-000271]_ISNULL처리 추가 (START)
             , NVL(T.QTY_PRICE, 0) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
             --[E20260309-000271]_ISNULL처리 추가 (END)
             , T.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM (SELECT * FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE QTY_PRICE = 0 AND MEASURE = 'MKT_FCST') T,
        (SELECT 'MKT_AMT_KRW' MEASURE FROM DUAL
         UNION
         SELECT 'MKT_AMT_LOC' MEASURE FROM DUAL
        ) B
        --[E20251208-000309]_0인 경우를 처리하는 로직이 존재하지 않아서, 0인 경우에 MKT FCST AMT 생성하도록 추가 (END)
    ) AMT
    GROUP BY AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID
           , AMT.DOM_EXP, AMT.FCST_TYPE, AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD;

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인
    ELSE
        n_update_cnt := 0;
    END IF;  --[DIV81] MKT_AMT 파생 게이트

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    --==========================================================================================================================
    -- #T_MAIN 테이블에 메져를 추가한다. (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A023--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- 환율정보로 계산 (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 4. MKT_AMT_KRW, MKT_AMT_LOC, LOC, KRW #T_MAIN IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- 환율정보로 계산 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 데이터 작업 시작 (START)
    --==========================================================================================================================
    --[E20260820-SENTINELDDL] 구 [PK-NN] N2 정규화 UPDATE 삭제 — GT_PRDM1_T_MAIN 키 13컬럼이
    --  DEFAULT ON NULL '-' NOT NULL 로 승격되어(2026-08-20 DDL) NULL 이 스키마에서 원천 차단됨.
    V_GETDATE := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_SELLING_PRICE START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_is_81 = 'N' THEN  --[DIV81] 판가 DML 분기: 40=DM_PLN_CFM_SELLING_PRICE / 81=SCM_MST_FUTURE_PRICE(하단 ELSE)
    -- Phase 1: DELETE existing rows where new QTY_PRICE = 0
    DELETE FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    WHERE EXISTS (
        SELECT 1 FROM (
            SELECT M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER, M.SCM_SITE_ID, M.PLANT_SITE_ID
                 , M.CELL_PROD_SITE_ID, M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.QTY_PRICE
                 , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                  , M.SCM_SITE_ID, M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID
                                                  , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                  , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')
        ) B
        WHERE RN = 1
          AND B.QTY_PRICE = 0
          AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.END_CUSTOMER = A.END_CUSTOMER
          AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
          AND B.ITEM_ID = A.ITEM_ID AND B.YYYYMMDD = A.YYYYMMDD AND B.MEASURE = A.MEASURE
          AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS
    );

    -- Phase 2: MERGE non-zero rows (UPDATE matched / INSERT unmatched)
    MERGE INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    USING (SELECT * FROM (
               SELECT M.*
                    , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                     , M.SCM_SITE_ID, M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID
                                                     , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                     , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
               FROM SCM_MGR.GT_PRDM1_T_MAIN M
               WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)
           WHERE RN = 1) B
    ON (A.DIVISION_ID       = B.DIVISION_ID
    AND A.PROJECT_CODE      = B.PROJECT_CODE
    AND A.END_CUSTOMER      = B.END_CUSTOMER
    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    AND A.ITEM_ID           = B.ITEM_ID
    AND A.YYYYMMDD          = B.YYYYMMDD
    AND A.MEASURE           = B.MEASURE
    AND A.DOM_EXP           = B.DOM_EXP
    AND A.FCST_TYPE         = B.FCST_TYPE
    AND A.INCOTERMS         = B.INCOTERMS)
    WHEN MATCHED THEN
    UPDATE
    SET A.CURRENCY         = B.CURRENCY
      , A.PRICE            = B.QTY_PRICE
      , A.LAST_UPDATED_BY  = B.CREATED_BY
      , A.LAST_UPDATE_DATE = V_GETDATE
    WHEN NOT MATCHED THEN
    INSERT
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES
    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.CURRENCY, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    ELSE
        --[DIV81] Phase 1-81: DELETE SCM_MST_FUTURE_PRICE (QTY_PRICE=0) — 키 10종 (END_CUSTOMER/CELL_PROD 제외)
        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
        WHERE EXISTS (
            SELECT 1 FROM (
                SELECT M.DIVISION_ID, M.PROJECT_CODE, M.SCM_SITE_ID, M.PLANT_SITE_ID
                     , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.QTY_PRICE
                     , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                      , M.SCM_SITE_ID, M.PLANT_SITE_ID
                                                      , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                      , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
                FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')
            ) B
            WHERE RN = 1
              AND B.QTY_PRICE = 0
              AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE
              AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
              AND B.ITEM_ID = A.ITEM_ID AND B.YYYYMMDD = A.YYYYMMDD AND B.MEASURE = A.MEASURE
              AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS
        );

        --[DIV81] Phase 2-81: MERGE SCM_MST_FUTURE_PRICE — INSERT 명시 16컬럼 (정본 DMF0020 L840), PRICE=CAST NUMBER(20,10)
        MERGE INTO SCM_MGR.SCM_MST_FUTURE_PRICE A
        USING (SELECT * FROM (
                   SELECT M.*
                        , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                         , M.SCM_SITE_ID, M.PLANT_SITE_ID
                                                         , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                         , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
                   FROM SCM_MGR.GT_PRDM1_T_MAIN M
                   WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)
               WHERE RN = 1) B
        ON (A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.YYYYMMDD          = B.YYYYMMDD
        AND A.MEASURE           = B.MEASURE
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.INCOTERMS         = B.INCOTERMS)
        WHEN MATCHED THEN
        UPDATE
        SET A.CURRENCY         = B.CURRENCY
          , A.PRICE            = CAST(B.QTY_PRICE AS NUMBER(20,10))
          , A.LAST_UPDATED_BY  = B.CREATED_BY
          , A.LAST_UPDATE_DATE = V_GETDATE
        WHEN NOT MATCHED THEN
        INSERT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE
        , DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        VALUES
        ( B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
        , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, CAST(B.QTY_PRICE AS NUMBER(20,10)), B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    END IF;  --[DIV81] 판가 DML 분기

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_SELLING_PRICE END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A024--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 5. DM_PLN_CFM_SELLING_PRICE IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE 테이블 IMPORT (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 작업 시작 (START)
    /* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
    -- 수정 및 INSERT가 가능한 'MKT_FCST','VMI_In_Req'만 해당 된다.
    -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 , UI에서 막음. )
    --==========================================================================================================================
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    -- 행 Delete 가능 - 편집 가능, 삭제 불가 행의 경우 값 일괄 업데이트 - D로 들어올 경우도 존재 한다.
    -- Phase 1: DELETE rows where new QTY = 0 (MKT_AMT + 수요 3종 = MERGE 소스와 동일 집합)
    IF v_is_81 = 'N' THEN  --[DIV81] MKT_AMT DELETE 는 40 전용
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'MKT_FCST', 'VMI_In_Req', 'SCM_FCST')
      AND EXISTS (
        SELECT 1 FROM (
            SELECT M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER, M.SCM_SITE_ID
                 , M.ITEM_ID, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                 , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD, M.QTY_PRICE
                 , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                  , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                  , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                  , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'MKT_FCST', 'VMI_In_Req', 'SCM_FCST')
        ) B
        WHERE RN = 1
          AND B.QTY_PRICE = 0
          AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.END_CUSTOMER = A.END_CUSTOMER
          AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOM_EXP = A.DOM_EXP
          AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS AND B.MEASURE = A.MEASURE
          AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID AND B.YYYYMMDD = A.YYYYMMDD
    );
    END IF;  --[DIV81] MKT_AMT DELETE 게이트

    --[DIV81] 81-VMI 자동복제 — VMI_YN='Y' 사이트의 MKT_FCST 를 VMI_In_Req 로 동반 저장 (정본 DMF0003 L1588~1614 이식)
    IF v_is_81 = 'Y' THEN
        INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
        ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
        , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
        , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
        SELECT A.ACTION, A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'VMI_In_Req' AS MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.QTY_PRICE, A.CREATED_BY
             , A.V_ATTRIBUTE1, A.V_ATTRIBUTE2, A.V_ATTRIBUTE3, A.V_ATTRIBUTE4
             , A.V_ATTRIBUTE5, A.V_ATTRIBUTE6, A.V_ATTRIBUTE7, A.V_ATTRIBUTE8, A.V_ATTRIBUTE9, A.V_ATTRIBUTE10, A.V_BOM_YN, A.V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN SCM_MGR.SCM_MST_SITE B
          ON A.SCM_SITE_ID = B.SCM_SITE_ID
         AND A.DIVISION_ID = B.DIVISION_ID
         AND B.VMI_YN      = 'Y'
        WHERE A.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W
                WHERE W.DIVISION_ID   = A.DIVISION_ID
                  AND W.PROJECT_CODE  = A.PROJECT_CODE
                  AND W.SCM_SITE_ID   = A.SCM_SITE_ID
                  AND W.ITEM_ID       = A.ITEM_ID
                  AND W.DOM_EXP       = A.DOM_EXP
                  AND W.FCST_TYPE     = A.FCST_TYPE
                  AND W.INCOTERMS     = A.INCOTERMS
                  AND W.PLANT_SITE_ID = A.PLANT_SITE_ID
                  AND W.YYYYMMDD      = A.YYYYMMDD
                  AND W.MEASURE       = 'VMI_In_Req'
          );
    END IF;

    -- Phase 2: MERGE non-zero rows (UPDATE matched / INSERT unmatched for MKT_FCST,VMI_In_Req only)
    -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 )
    IF v_is_81 = 'N' THEN  --[DIV81] 수요 DML 분기: 40=DM_PLN_CFM_MKT_DEMAND_PLAN / 81=DM_PLN_MKT_FCST(하단 ELSE)
    MERGE INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    USING (SELECT * FROM (
               SELECT M.*
                    , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                     , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                     , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                     , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
               FROM SCM_MGR.GT_PRDM1_T_MAIN M
               WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST') -- SCM_FCST - MEASURE 추가
                 AND M.QTY_PRICE <> 0)
           WHERE RN = 1) B
    ON (A.DIVISION_ID       = B.DIVISION_ID
    AND A.PROJECT_CODE      = B.PROJECT_CODE
    AND A.END_CUSTOMER      = B.END_CUSTOMER
    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
    AND A.ITEM_ID           = B.ITEM_ID
    AND A.DOM_EXP           = B.DOM_EXP
    AND A.FCST_TYPE         = B.FCST_TYPE
    AND A.INCOTERMS         = B.INCOTERMS
    AND A.MEASURE           = B.MEASURE
    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    AND A.YYYYMMDD          = B.YYYYMMDD)
    WHEN MATCHED THEN
    UPDATE
    SET A.QTY              = B.QTY_PRICE
      , A.LAST_UPDATED_BY  = B.CREATED_BY
      , A.LAST_UPDATE_DATE = V_GETDATE
    WHEN NOT MATCHED THEN
    INSERT
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES
    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    ELSE
        --[DIV81] 수요 DML 81: MERGE DM_PLN_MKT_FCST — ON 키 10종. MERGE 채택 사유: DMF0003 정본은 DELETE+INSERT 이나
        --  기존 ATTRIBUTE(CONFIRM 계열) 보존을 위해 UPDATE 는 QTY/감사컬럼만 갱신. DMF0003 과 동일하게 QTY=0 행도 물리 저장.
        --[E20260822-DIV81DEL] 81 수요 행 삭제 — TO-BE 는 81 편집 권한이 있어 실삭제가 필요하다(사용자 지시 2026-08-22).
        --  40 처럼 'QTY=0 → 삭제' 를 쓸 수 없다: 81 은 QTY=0 행을 물리 저장하는 설계(바로 위 주석)라
        --  값을 0 으로 고친 것까지 지워져 DMF0003 정본과 어긋난다.
        --  그래서 FE 행 삭제 플래그를 기준으로 한다 — GT_PRDM1_T_MAIN.ACTION = p_active_flag (L11592).
        --  키 10종 = 아래 MERGE ON 절과 동일 (DM_PLN_MKT_FCST 에는 END_CUSTOMER·CELL_PROD_SITE_ID 없음).
        DELETE FROM SCM_MGR.DM_PLN_MKT_FCST A
        WHERE A.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
          AND EXISTS (
              SELECT 1
              FROM SCM_MGR.GT_PRDM1_T_MAIN B
              WHERE B.ACTION = 'D'
                AND B.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
                AND B.DIVISION_ID   = A.DIVISION_ID
                AND B.PROJECT_CODE  = A.PROJECT_CODE
                AND B.SCM_SITE_ID   = A.SCM_SITE_ID
                AND B.ITEM_ID       = A.ITEM_ID
                AND B.DOM_EXP       = A.DOM_EXP
                AND B.FCST_TYPE     = A.FCST_TYPE
                AND B.INCOTERMS     = A.INCOTERMS
                AND B.MEASURE       = A.MEASURE
                AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                AND B.YYYYMMDD      = A.YYYYMMDD
          );

        MERGE INTO SCM_MGR.DM_PLN_MKT_FCST A
        USING (SELECT * FROM (
                   SELECT M.*
                        , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                         , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                         , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                         , M.PLANT_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
                   FROM SCM_MGR.GT_PRDM1_T_MAIN M
                   WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req')
                     AND NVL(M.ACTION, 'X') <> 'D')   --[E20260822-DIV81DEL] 삭제행은 MERGE 대상에서 제외 (안 하면 지운 행이 QTY=0 으로 되살아난다)
               WHERE RN = 1) B
        ON (A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.INCOTERMS         = B.INCOTERMS
        AND A.MEASURE           = B.MEASURE
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.YYYYMMDD          = B.YYYYMMDD)
        WHEN MATCHED THEN
        UPDATE
        SET A.QTY              = NVL(B.QTY_PRICE, 0)
          , A.LAST_UPDATED_BY  = B.CREATED_BY
          , A.LAST_UPDATE_DATE = V_GETDATE
          , A.ATTRIBUTE10      = B.V_ATTRIBUTE10  --[E20260820-AFSNULL] NVL 보존 처리 폐지 — 전달값 그대로(빈값=NULL, 사용자 지시)
        WHEN NOT MATCHED THEN
        INSERT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
        , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        VALUES
        ( B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.YYYYMMDD
        , NVL(B.QTY_PRICE, 0), B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE
        , NULL, NULL, NULL, NULL, NULL
        , NULL, NULL, NULL, NULL, B.V_ATTRIBUTE10 );  --[E20260820-AFSNULL] 빈값=NULL 그대로
    END IF;  --[DIV81] 수요 DML 분기

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A025--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 6. DM_PLN_CFM_MKT_DEMAND_PLAN IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A025_EE--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --[E20251209-000712]_전극의 경우 SCP RTF를 받아오지 않도록 처리했기때문에, MKT FCST 수정시 -> MKT FCST 메져로 RTF 생성 / SCM FCST 수정시 -> SCM FCST 메져로 RTF 생성하도록 수정 (START)
    --==========================================================================================================================
    -- 전극인 경우에는 RTF를 생성해준다 (SCP RTF를 반영하지 않기때문에) (START)
    --==========================================================================================================================
    n_EE_chk := 0;
    IF v_is_81 = 'N' THEN  --[DIV81] 전극 RTF 생성은 40 전용 (40 테이블 DML)
    SELECT COUNT(*) INTO n_EE_chk
    FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
       , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
    WHERE RSLT.DIVISION_ID = ITEM.DIVISION_ID
      AND RSLT.ITEM_ID     = ITEM.ITEM_ID
      AND ITEM.ACTIVE_FLAG = 'Y'
      --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
      AND RSLT.ITEM_ID IN (
            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
            WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
      );

    IF n_EE_chk > 0 THEN
        DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.MEASURE  = 'RTF_SYS_RP'
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd -- 당주 월요일이후
          AND EXISTS (
                SELECT RSLT.DIVISION_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
                   , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                WHERE RSLT.DIVISION_ID         = ITEM.DIVISION_ID
                  AND RSLT.ITEM_ID             = ITEM.ITEM_ID
                  AND A.DIVISION_ID            = RSLT.DIVISION_ID
                  AND A.PROJECT_CODE           = RSLT.PROJECT_CODE
                  AND A.END_CUSTOMER           = RSLT.END_CUSTOMER
                  AND A.SCM_SITE_ID            = RSLT.SCM_SITE_ID
                  AND A.ITEM_ID                = RSLT.ITEM_ID
                  AND A.DOM_EXP                = RSLT.DOM_EXP
                  AND A.FCST_TYPE              = RSLT.FCST_TYPE
                  AND A.INCOTERMS              = RSLT.INCOTERMS
                  AND A.PLANT_SITE_ID          = RSLT.PLANT_SITE_ID
                  AND A.CELL_PROD_SITE_ID      = RSLT.CELL_PROD_SITE_ID
                  AND ITEM.ACTIVE_FLAG         = 'Y'
                  --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                  AND RSLT.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                  )  --20180720 ACTIVE_FLAG 조건추가
          );

        INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
        , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'RTF_SYS_RP' AS MEASURE
             , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, 'DMF0082_SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE
             , 'DMF0082_SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
             , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.CELL_PROD_SITE_ID
        FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.MEASURE = (SELECT MEASURE FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE MEASURE IN ('SCM_FCST', 'MKT_FCST') GROUP BY MEASURE FETCH FIRST 1 ROWS ONLY)
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd -- 당주 월요일이후
          AND EXISTS (
                SELECT RSLT.DIVISION_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
                   , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                WHERE RSLT.DIVISION_ID    = ITEM.DIVISION_ID
                  AND RSLT.ITEM_ID        = ITEM.ITEM_ID
                  AND A.DIVISION_ID       = RSLT.DIVISION_ID
                  AND A.PROJECT_CODE      = RSLT.PROJECT_CODE
                  AND A.END_CUSTOMER      = RSLT.END_CUSTOMER
                  AND A.SCM_SITE_ID       = RSLT.SCM_SITE_ID
                  AND A.ITEM_ID           = RSLT.ITEM_ID
                  AND A.DOM_EXP           = RSLT.DOM_EXP
                  AND A.FCST_TYPE         = RSLT.FCST_TYPE
                  AND A.INCOTERMS         = RSLT.INCOTERMS
                  AND A.PLANT_SITE_ID     = RSLT.PLANT_SITE_ID
                  AND A.CELL_PROD_SITE_ID = RSLT.CELL_PROD_SITE_ID
                  AND ITEM.ACTIVE_FLAG    = 'Y'
                  --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
                  AND RSLT.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                  )  --20180720 ACTIVE_FLAG 조건추가
          );

        --[E20260107-001651]_룩업에 설정된 값으로 ATTRIBUTE2 UPDATE (BPS I/F시 FROM_SITE_ID 전송하기 위함) START
        UPDATE SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        SET A.ATTRIBUTE2 = (SELECT LOOK.SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                             WHERE LOOK.LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID' AND LOOK.VALID_YN = 'Y'
                               AND A.DIVISION_ID = LOOK.SEGMENT1 AND ROWNUM = 1)
        WHERE A.MEASURE  = 'RTF_SYS_RP'
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd
          AND EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                WHERE LOOK.LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID' AND LOOK.VALID_YN = 'Y'
                  AND A.DIVISION_ID = LOOK.SEGMENT1
                  AND A.ITEM_ID LIKE '' || NVL(LOOK.ATTRIBUTE1, A.ITEM_ID) || '%'
                  AND A.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = LOOK.SEGMENT2 AND K.ACTIVE_FLAG = 'Y'
                  )
          );
        --[E20260107-001651]_룩업에 설정된 값으로 ATTRIBUTE2 UPDATE (BPS I/F시 FROM_SITE_ID 전송하기 위함) END

        n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

        --==========================================================================================================================
        -- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (START)
        --==========================================================================================================================
        V_LOG_TYPE    := 'ING';
        V_LOG_MESSAGE := '■ 6_EE. DM_PLN_CFM_MKT_DEMAND_PLAN_EE IMPORT';
        N_LOG_COUNT   := n_update_cnt;
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
            D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
        --==========================================================================================================================
        -- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (END)
        --==========================================================================================================================
    END IF;
    END IF;  --[DIV81] EE 게이트
    --==========================================================================================================================
    -- 전극인 경우에는 RTF를 생성해준다 (SCP RTF를 반영하지 않기때문에) (END)
    --==========================================================================================================================
    --[E20251209-000712]_전극의 경우 SCP RTF를 받아오지 않도록 처리했기때문에, MKT FCST 수정시 -> MKT FCST 메져로 RTF 생성 / SCM FCST 수정시 -> SCM FCST 메져로 RTF 생성하도록 수정 (END)
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE_H 데이터 작업 시작 (START)
    --==========================================================================================================================
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_is_81 = 'N' THEN  --[DIV81] 판가 이력 분기
    INSERT INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE )
    SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_CFM_SELLING_PRICE_H.NEXTVAL, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
         , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE
         , CREATED_BY, V_GETDATE, SYSDATE
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정
    ELSE
        --[DIV81] SCM_MST_FUTURE_PRICE_H — 명시 17컬럼 (정본 DMF0020 L902)
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE_H
        ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
        , CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT DIVISION_ID, SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
             , CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE
             , CREATED_BY, V_GETDATE
        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    END IF;  --[DIV81] 판가 이력 분기

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE_H 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A026--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_SELLING_PRICE_H 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 7. DM_PLN_CFM_SELLING_PRICE_H IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 데이터 작업 시작 (START)
    --==========================================================================================================================
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_is_81 = 'N' THEN  --[DIV81] 수요 이력 분기
    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
    SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_CFM_MKT_DEMAND_PLAN_H.NEXTVAL, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
         , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY_PRICE, CREATED_BY, V_GETDATE
         , CREATED_BY, V_GETDATE
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST');
    --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정
    ELSE
        --[DIV81] DM_PLN_MKT_FCST_H — 명시 26컬럼 의무 (CTAS 사고 쓰레기 컬럼 20여개 실측 — 컬럼 생략/SELECT * 절대 금지), 정본 DMF0003 L1758
        INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_H
        ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
        , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
        , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
             , YYYYMMDD, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE, CREATED_BY
             , V_GETDATE, NULL, NULL, NULL, NULL, NULL
             , NULL, NULL, NULL, NULL, V_ATTRIBUTE10  --[E20260820-AFSNULL] 빈값=NULL 그대로
        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req');
    END IF;  --[DIV81] 수요 이력 분기

    n_update_cnt := SQL%ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 데이터 작업 시작 (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A027--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 테이블 IMPORT (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 8. DM_PLN_CFM_MKT_DEMAND_PLAN_H IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- DM_PLN_CFM_MKT_DEMAND_PLAN_H 테이블 IMPORT (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 START (START)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 9. PR_DM_PLN_CFM_TO_MKT_FCST START';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 START (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- MKT FCST 데이터 생성 프로시저 호출 시작 (START)
    --==========================================================================================================================
    --[DIV81] 81 은 DM_PLN_MKT_FCST 에 직접 기록하므로 CFM→MKT_FCST 전파 프로시저 skip (게이트 — 2026-07-14 소스 실측 근거)
    --  1) PR 내부 V_DIVISION_ID='40' 하드코딩 — 동기화 자체는 40 한정.
    --  2) 단, GT_PRDM_SEND_TARGET_DATA 적재에 division 필터가 없어 81 행 유입 시 40 BALANCE 재생성이 불필요 실행됨.
    --  3) 참고: PR 은 GT_PRDM_T_MAIN(무 '1')을 읽으나 본 SP 는 GT_PRDM1_T_MAIN 에 적재 — 별개 GTT (잠재 이슈,
    --     40 동작 불변 원칙에 따라 본 패치에서는 미수정. 상세: work_report 2026-07-14 DMF0082 div81).
    IF v_is_81 = 'N' THEN
        SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);
    END IF;
    --==========================================================================================================================
    -- MKT FCST 데이터 생성 프로시저 호출 시작 (END)
    --==========================================================================================================================

    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 END (END)
    --==========================================================================================================================
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 10. PR_DM_PLN_CFM_TO_MKT_FCST END';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    --==========================================================================================================================
    -- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 END (END)
    --==========================================================================================================================

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A028--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    --=============================================================================================================================
    -- 종료 LOG (START)
    --=============================================================================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## SUCCESS END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    -- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (START)
    --EXEC PR_SCM_SYS_LOG_BATCH $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
    -- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (END)
    --=============================================================================================================================
    -- 종료 LOG (END)
    --=============================================================================================================================

    --=============================================================================================================================
    -- 결과코드, 결과 카운트 반환
    --=============================================================================================================================
    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN e_validation_error THEN
        ROLLBACK;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', N_LOG_COUNT,
            '########## FAIL-2 END of procedure ##########', V_DESCRIPTION,
            SYSDATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;

        -- 결과코드, 결과 카운트 반환
        OPEN O_RESULT_CURSOR FOR
            SELECT 'F' AS RESULT_CODE, V_DESCRIPTION AS RESULT_MSG, 'Validation Check' AS ERR_EVENT FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := '########## FAIL-1 END of procedure ##########';
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE   := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
            D_EVENT_DATE, v_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
        ); END;
        RAISE_APPLICATION_ERROR(-20001, V_SQL_ERRMSG || ' ' || V_BACKTRACE);

END P_DMF0082_SAVE_MAIN_DATA;


-- ============================================================================
-- [E20260813-EXCELFORM] DMF0082 Excel Form 조회 SP 신설 — BODY 구현부
--
--  ⭐ 설계 요지 (근거)
--   1) 조회조건 필터는 **MAIN GET 을 그대로 호출**해 재사용한다. MAIN 이 스테이징하는
--      GT_DMF0082_TEMP_FCST_N_PRICE 가 키 10 + 정보성 컬럼 전량을 이미 보유하므로,
--      필터 로직을 복제하지 않고도 "MAIN 조회조건에 맞는 데이터 전체"가 정의상 보장된다.
--      (사내 실측 2026-08-13: div40 3개월 = GET 6.9s / GTT 938,540행 / DISTINCT 키 2,559)
--   2) measure 는 화면 개인화(titleset)와 **무관**하게 LOOKUP 'DM_UI_EDITABLE_MEASURE'
--      (SEGMENT1='DMF0082', ATTRIBUTE1='Y' = INSERT_YN)로 CROSS JOIN 한다 — 사용자 요구
--      "입력 가능 메저 전체 대상". VMI 조건(ATTRIBUTE3)은 검증 SP L4711~4716 과 동일 술어를 쓴다.
--   3) 각 컬럼 값은 **검증 SP 가 기대하는 표기**로 내린다 (검증 SP 원문 실측):
--        Div              = 코드 그대로                              (L4330)
--        End Customer     = END_CUSTOMER lookup SEGMENT3(명칭)        (L4394 EC.NAME = ATTRIBUTE2)
--        Sales Site       = SCM_SITE_ID 코드 그대로                   (L4433)
--        Model            = ITEM_ID 코드 그대로                       (L4513)
--        Incoterms        = INCOTERMS lookup SEGMENT2(=SEGMENT1)      (L4552)
--        FCST Type        = SALES_TYPE_CODE lookup SEGMENT2(명칭)     (L4591)
--        Customs Handbook = DM_CUSTOMS_HANDBOOK_40 SEGMENT2(=SEG1)    (L4629)
--        Cell Prod Site   = SP_CELL_PROD_SITE ATTRIBUTE1(명칭)        (L4667)
--        Currency         = CURRENCY_LIST SEGMENT2(=SEGMENT1)         (L4761, LOC 행만 검증)
--        Measure          = DM_UI_EDITABLE_MEASURE SEGMENT4(표시명)   (L4722)
--      → 본 SP 는 검증 SP 의 역함수. 양식→업로드 왕복이 구조적으로 보장된다.
--   4) 정보성 컬럼은 키별 MAX() 로 축약한다. DISTINCT 에 넣으면 정보성 값 변형 1건이
--      키를 쪼개 행이 불어난다(중복 양식 행 = 업로드 중복키 ERROR 유발).
-- ============================================================================
PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA (
    p_division_id               IN  VARCHAR2
  , p_dept_id                   IN  VARCHAR2
  , p_end_customer              IN  VARCHAR2
  , p_biz_type                  IN  VARCHAR2
  , p_from_yyyymmdd             IN  VARCHAR2
  , p_to_yyyymmdd               IN  VARCHAR2
  , p_sales_site                IN  VARCHAR2
  , p_item_id                   IN  VARCHAR2
  , p_version_type              IN  VARCHAR2
  , p_qty_yn                    IN  VARCHAR2
  , p_ses_user_id               IN  VARCHAR2
  , p_user_group                IN  VARCHAR2
  , p_plant_site_id             IN  VARCHAR2 DEFAULT 'ALL'
  , p_project_code              IN  VARCHAR2 DEFAULT 'ALL'
  , p_owner                     IN  VARCHAR2 DEFAULT 'ALL'
  , p_sender_code               IN  VARCHAR2 DEFAULT 'ALL'
  , o_rc1                       OUT SYS_REFCURSOR
  , o_result_cursor             OUT SYS_REFCURSOR
)
AS
    v_rc_main                   SYS_REFCURSOR;
    v_rc_d1                     SYS_REFCURSOR;
    v_rc_d2                     SYS_REFCURSOR;
    v_rc_d3                     SYS_REFCURSOR;
    v_rc_d4                     SYS_REFCURSOR;
    v_rc_res                    SYS_REFCURSOR;
    n_key_cnt                   PLS_INTEGER := 0;
    V_WEEK_LIST                 VARCHAR2(400 CHAR);   --[E20260820-XLSWEEKLY] 주차 시작일 CSV (FE 동적 헤더 원천)

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    /* [E20260819-XLS81LOC] Excel Form = Division 81 계열 전용 (2026-08-19 사용자 지시 — 구 40 전용 역전).
       비대상 division 은 처리 없이 결과커서 CODE '1' + MSG01014(신규 채번 3언어 — 기존 MSG00702 는 '40 only' 화면용이라 재사용 불가 실측).
       FE 는 81 외 버튼 비노출 — 본 가드는 서버 권위(직호출 방어). */
    IF p_division_id IS NULL OR p_division_id NOT LIKE '81%' THEN
        OPEN o_rc1 FOR SELECT CAST(NULL AS VARCHAR2(10)) AS DIVISION_ID FROM DUAL WHERE 1 = 0;
        OPEN o_result_cursor FOR
            SELECT '1' AS RESULT_CODE, 'MSG01014' AS RESULT_MSG, '0' AS EVENT
                 , CAST(NULL AS VARCHAR2(400)) AS WEEK_LIST FROM DUAL;
        RETURN;
    END IF;

    ------------------------------------------------------------------------
    -- 1) MAIN 조회 파이프라인 재사용 → GT_DMF0082_TEMP_FCST_N_PRICE 적재
    --    (커서는 쓰지 않고 즉시 닫는다 — 필터 로직 복제 방지가 목적)
    ------------------------------------------------------------------------
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id, p_dept_id, p_end_customer, p_biz_type
      , p_from_yyyymmdd, p_to_yyyymmdd, p_sales_site, p_item_id
      , p_version_type, p_qty_yn, p_ses_user_id, p_user_group
      , p_plant_site_id, p_project_code, p_owner, p_sender_code
      , v_rc_main, v_rc_d1, v_rc_d2, v_rc_d3, v_rc_d4, v_rc_res
    );
    BEGIN IF v_rc_main IS NOT NULL THEN CLOSE v_rc_main; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d1   IS NOT NULL THEN CLOSE v_rc_d1;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d2   IS NOT NULL THEN CLOSE v_rc_d2;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d3   IS NOT NULL THEN CLOSE v_rc_d3;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d4   IS NOT NULL THEN CLOSE v_rc_d4;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_res  IS NOT NULL THEN CLOSE v_rc_res;  END IF; EXCEPTION WHEN OTHERS THEN NULL; END;

    SELECT COUNT(*) INTO n_key_cnt FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;

    ------------------------------------------------------------------------
    -- 2) 양식 행 = 키(DISTINCT) × 입력 가능 measure, 값은 검증 기대 표기
    ------------------------------------------------------------------------
    /* [E20260820-XLSWEEKLY] 주차 목록 산출 — o_rc1 W 슬롯과 동일 산식 (FE 동적 헤더 = 이 목록) */
    SELECT LISTAGG(WK, ',') WITHIN GROUP (ORDER BY WK)
      INTO V_WEEK_LIST
      FROM (SELECT WK, ROW_NUMBER() OVER (ORDER BY WK) AS RN
                 FROM (SELECT DISTINCT C.BASIS_START_DATE AS WK
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M C
                        WHERE C.BASIS_YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')) AND p_to_yyyymmdd
                          AND C.BASIS_START_DATE >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')))
     WHERE RN <= 26;

    OPEN o_rc1 FOR
    WITH WT_KEY AS (
        SELECT G.DIVISION_ID
             , G.END_CUSTOMER
             , G.SCM_SITE_ID
             , G.ITEM_ID
             , G.INCOTERMS
             , G.FCST_TYPE
             , G.DOM_EXP
             , G.CELL_PROD_SITE_ID
             -- LOC 행의 통화가 정본(단가 통화). 없으면 키의 대표 통화
             , NVL(MAX(CASE WHEN G.MEASURE = 'LOC' THEN G.CURRENCY END), MAX(G.CURRENCY)) AS CURRENCY
             -- 정보성 컬럼 (키별 MAX 축약 — DISTINCT 에 넣으면 키가 쪼개진다)
             , MAX(G.DEPT_ID)                        AS TEAM_ID
             , MAX(G.DEPT_NAME_KO)                   AS TEAM_NAME_KO
             , MAX(G.SOLDTO_CUSTOMER)                AS SOLDTO_CUSTOMER
             , MAX(G.COUNTRY_NAME)                   AS COUNTRY_NAME
             , MAX(G.CITY_NAME)                      AS CITY_NAME
             , MAX(G.ITEM_NAME)                      AS ITEM_NAME
             , MAX(G.NICK_NAME)                      AS NICK_NAME
             , MAX(G.ITEM_TYPE)                      AS ITEM_TYPE
             , MAX(G.CUST_GROUP)                     AS CUST_GROUP
             , MAX(G.CUST_GROUP_DTL)                 AS CUST_GROUP_DTL
             , MAX(G.OWNER)                          AS OWNER
             , MAX(G.APPLICATION)                    AS APPLICATION
             , MAX(G.ROUTE)                          AS ROUTE
             , MAX(G.MDM_PROJECT_NAME)               AS MDM_PROJECT_NAME
             , MAX(G.MIN_CAPACITY)                   AS MIN_CAPACITY
             , MAX(G.FORECAST_INFO_BIZ_TYPE)         AS FORECAST_INFO_BIZ_TYPE
             , MAX(G.CELL_TYPE)                      AS CELL_TYPE
             , MAX(G.CELL_MODEL)                     AS FORECAST_INFO_CELL_MODEL
             , MAX(G.FORECAST_INFO_CELL_PACK_COUNT)  AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(G.FORECAST_INFO_ALL)              AS FORECAST_INFO_ALL
             , MAX(G.FORECAST_INFO_SPEC)             AS FORECAST_INFO_SPEC
             , MAX(G.FORECAST_INFOR_VERSION)         AS FORECAST_INFOR_VERSION
             , MAX(G.CELL_MODEL_NICK_NAME)           AS CELL_MODEL_NICK_NAME
             , MAX(G.VMI_YN)                         AS VMI_YN
             , MAX(G.DMS_SALES)                      AS DMS_SALES
             , MAX(G.DMS_CUSTOMER)                   AS DMS_CUSTOMER
             , NVL(MAX(G.AS_FROM_SITE), ' ')                   AS AS_FROM_SITE
             , MAX(G.LAST_UPDATED_BY)                AS LAST_UPDATED_BY
             , MAX(G.SENDER_NAME)                    AS SENDER_NAME
          FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE G
         GROUP BY G.DIVISION_ID, G.END_CUSTOMER, G.SCM_SITE_ID, G.ITEM_ID
                , G.INCOTERMS, G.FCST_TYPE, G.DOM_EXP, G.CELL_PROD_SITE_ID
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
           AND L.VALID_YN    = 'Y'
           AND L.ATTRIBUTE1  = 'Y'          -- INSERT_YN (검증 SP L4709 동일)
           AND L.SEGMENT3    = 'LOC'        /* [E20260819-XLS81LOC] 대상 measure LOC 한정 (2026-08-19 사용자 지시) */
    )
    -- End Customer 코드 → 명칭 (검증 SP L4387~4393 역방향)
    , WT_EC AS (
        SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS EC_CODE, MAX(SEGMENT3) AS EC_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'END_CUSTOMER' AND VALID_YN = 'Y' AND SEGMENT2 <> '-'
         GROUP BY SEGMENT1, SEGMENT2
    )
    -- FCST Type 코드 → 명칭 (검증 SP L4586~4591 역방향)
    , WT_FCST AS (
        SELECT SEGMENT1 AS FCST_CODE, MAX(SEGMENT2) AS FCST_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND VALID_YN = 'Y'
           AND NVL(ATTRIBUTE2, '-') <> 'Y'
         GROUP BY SEGMENT1
    )
    -- Cell Prod Site 코드 → 명칭 (검증 SP L4663~4667 역방향)
    , WT_CPS AS (
        SELECT SEGMENT1 AS CPS_CODE, MAX(ATTRIBUTE1) AS CPS_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND VALID_YN = 'Y'
         GROUP BY SEGMENT1
    )
    SELECT K.DIVISION_ID
         , NVL(EC.EC_NAME, K.END_CUSTOMER)      AS END_CUSTOMER
         , K.SCM_SITE_ID
         , K.ITEM_ID
         , K.INCOTERMS
         , NVL(FT.FCST_NAME, K.FCST_TYPE)       AS FCST_TYPE
         , K.DOM_EXP
         , NVL(CP.CPS_NAME, K.CELL_PROD_SITE_ID) AS CELL_PROD_SITE_ID
         , K.CURRENCY
         , MSR.MEASURE_NAME                      AS MEASURE
         --
         , K.TEAM_ID, K.TEAM_NAME_KO, K.SOLDTO_CUSTOMER, K.COUNTRY_NAME, K.CITY_NAME
         , K.ITEM_NAME, K.NICK_NAME, K.ITEM_TYPE, K.CUST_GROUP, K.CUST_GROUP_DTL
         , K.OWNER, K.APPLICATION, K.ROUTE, K.MDM_PROJECT_NAME, K.MIN_CAPACITY
         , K.FORECAST_INFO_BIZ_TYPE, K.CELL_TYPE, K.FORECAST_INFO_CELL_MODEL
         , K.FORECAST_INFO_CELL_PACK_COUNT, K.FORECAST_INFO_ALL, K.FORECAST_INFO_SPEC
         , K.FORECAST_INFOR_VERSION, K.CELL_MODEL_NICK_NAME, K.VMI_YN
         , K.DMS_SALES, K.DMS_CUSTOMER, K.AS_FROM_SITE, K.LAST_UPDATED_BY, K.SENDER_NAME
         -- ⭐ 업로드 불가 예고 플래그 — 마스터 결핍으로 **검증 SP 역변환이 실패할 행**을 미리 표시한다.
         --    (사내 실측 2026-08-13 div40 3개월: EC 1종 'SUZUKI' / CellProdSite 2종 EG00-A·AZ00-A / Incoterms 1종)
         --    양식에 실어 보내고 업로드에서야 ERROR 로 알려주면 사용자가 원인을 못 찾는다.
         , RTRIM(
             CASE WHEN EC.EC_NAME IS NULL AND K.END_CUSTOMER NOT IN (
                       SELECT SI.PROJECT_CODE FROM SCM_MGR.SCM_MST_SITE_ITEM SI
                        WHERE SI.DIVISION_ID = K.DIVISION_ID AND SI.VALID_YN = 'Y')
                  THEN 'EC,' ELSE '' END ||
             CASE WHEN CP.CPS_NAME IS NULL THEN 'CELL_PROD_SITE,' ELSE '' END ||
             CASE WHEN NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LI
                                    WHERE LI.LOOKUP_TYPE = 'INCOTERMS' AND LI.VALID_YN = 'Y'
                                      AND LI.SEGMENT2 = K.INCOTERMS)
                  THEN 'INCOTERMS,' ELSE '' END
           , ',') AS FORM_WARN
         /* [E20260820-XLSWEEKLY] 기간 축 = 동적 주차 (A안 사용자 확정 2026-08-20) — 조회기간과 당주-이후의 교집합 주 시작일
            (BASIS_START_DATE) 슬롯 W01~W26. 실제 주차 목록은 o_result_cursor.WEEK_LIST(CSV) 로 내려주고
            FE 가 W 슬롯을 날짜 헤더(YYYYMMDD 원형 — BE FileServiceImpl 1단 날짜헤더 인식 규격)로 치환한다.
            값 = 기존 LOC 원장 주차 대표값(XLSFORM2 승계 — 주차 단위 재배선). */
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W01) END AS W01
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W02) END AS W02
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W03) END AS W03
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W04) END AS W04
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W05) END AS W05
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W06) END AS W06
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W07) END AS W07
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W08) END AS W08
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W09) END AS W09
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W10) END AS W10
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W11) END AS W11
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W12) END AS W12
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W13) END AS W13
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W14) END AS W14
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W15) END AS W15
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W16) END AS W16
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W17) END AS W17
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W18) END AS W18
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W19) END AS W19
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W20) END AS W20
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W21) END AS W21
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W22) END AS W22
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W23) END AS W23
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W24) END AS W24
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W25) END AS W25
         , CASE WHEN MSR.MEASURE_CODE = 'LOC' THEN TO_CHAR(LP.W26) END AS W26
      FROM WT_KEY K
     INNER JOIN WT_MEASURE MSR
        ON MSR.DIVISION_ID = K.DIVISION_ID
      LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE MS
        ON  MS.DIVISION_ID = K.DIVISION_ID
        AND MS.SCM_SITE_ID = K.SCM_SITE_ID
      LEFT OUTER JOIN WT_EC EC
        ON  EC.DIVISION_ID = K.DIVISION_ID
        AND EC.EC_CODE     = K.END_CUSTOMER
      LEFT OUTER JOIN WT_FCST FT
        ON  FT.FCST_CODE   = K.FCST_TYPE
      LEFT OUTER JOIN WT_CPS CP
        ON  CP.CPS_CODE    = K.CELL_PROD_SITE_ID
      /* [E20260820-XLSWEEKLY] 기존 LOC 원장 주차별 대표값 (주 시작일 = 캘린더 BASIS_START_DATE, MAX 집계) */
      LEFT OUTER JOIN (
          SELECT B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.CURRENCY
               , MAX(CASE W.RN WHEN 1 THEN B.PRICE END) AS W01
               , MAX(CASE W.RN WHEN 2 THEN B.PRICE END) AS W02
               , MAX(CASE W.RN WHEN 3 THEN B.PRICE END) AS W03
               , MAX(CASE W.RN WHEN 4 THEN B.PRICE END) AS W04
               , MAX(CASE W.RN WHEN 5 THEN B.PRICE END) AS W05
               , MAX(CASE W.RN WHEN 6 THEN B.PRICE END) AS W06
               , MAX(CASE W.RN WHEN 7 THEN B.PRICE END) AS W07
               , MAX(CASE W.RN WHEN 8 THEN B.PRICE END) AS W08
               , MAX(CASE W.RN WHEN 9 THEN B.PRICE END) AS W09
               , MAX(CASE W.RN WHEN 10 THEN B.PRICE END) AS W10
               , MAX(CASE W.RN WHEN 11 THEN B.PRICE END) AS W11
               , MAX(CASE W.RN WHEN 12 THEN B.PRICE END) AS W12
               , MAX(CASE W.RN WHEN 13 THEN B.PRICE END) AS W13
               , MAX(CASE W.RN WHEN 14 THEN B.PRICE END) AS W14
               , MAX(CASE W.RN WHEN 15 THEN B.PRICE END) AS W15
               , MAX(CASE W.RN WHEN 16 THEN B.PRICE END) AS W16
               , MAX(CASE W.RN WHEN 17 THEN B.PRICE END) AS W17
               , MAX(CASE W.RN WHEN 18 THEN B.PRICE END) AS W18
               , MAX(CASE W.RN WHEN 19 THEN B.PRICE END) AS W19
               , MAX(CASE W.RN WHEN 20 THEN B.PRICE END) AS W20
               , MAX(CASE W.RN WHEN 21 THEN B.PRICE END) AS W21
               , MAX(CASE W.RN WHEN 22 THEN B.PRICE END) AS W22
               , MAX(CASE W.RN WHEN 23 THEN B.PRICE END) AS W23
               , MAX(CASE W.RN WHEN 24 THEN B.PRICE END) AS W24
               , MAX(CASE W.RN WHEN 25 THEN B.PRICE END) AS W25
               , MAX(CASE W.RN WHEN 26 THEN B.PRICE END) AS W26
          FROM  (SELECT P.PROJECT_CODE, P.SCM_SITE_ID, P.ITEM_ID, P.INCOTERMS, P.DOM_EXP, P.FCST_TYPE, P.CURRENCY
                      , C.BASIS_START_DATE AS WK, MAX(P.PRICE) AS PRICE
                 FROM   SCM_MGR.SCM_MST_FUTURE_PRICE P
                 JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = P.YYYYMMDD
                 WHERE  P.DIVISION_ID = p_division_id
                 AND    P.MEASURE = 'LOC'
                 AND    P.YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')) AND p_to_yyyymmdd
                 GROUP BY P.PROJECT_CODE, P.SCM_SITE_ID, P.ITEM_ID, P.INCOTERMS, P.DOM_EXP, P.FCST_TYPE, P.CURRENCY
                        , C.BASIS_START_DATE) B
          JOIN  (SELECT WK, ROW_NUMBER() OVER (ORDER BY WK) AS RN
                 FROM (SELECT DISTINCT C.BASIS_START_DATE AS WK
                         FROM SCM_MGR.SCM_SYS_CALENDAR_M C
                        WHERE C.BASIS_YYYYMMDD BETWEEN GREATEST(p_from_yyyymmdd, TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')) AND p_to_yyyymmdd
                          AND C.BASIS_START_DATE >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'))) W
            ON  W.WK = B.WK AND W.RN <= 26
          GROUP BY B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.CURRENCY
      ) LP
        ON  LP.PROJECT_CODE = K.END_CUSTOMER
        AND LP.SCM_SITE_ID  = K.SCM_SITE_ID
        AND LP.ITEM_ID      = K.ITEM_ID
        AND LP.INCOTERMS    = K.INCOTERMS
        AND LP.DOM_EXP      = K.DOM_EXP
        AND LP.FCST_TYPE    = K.FCST_TYPE
        AND LP.CURRENCY     = K.CURRENCY
     -- VMI 조건 = 검증 SP L4711~4716 동일 술어 (양식에 넣어놓고 업로드에서 거부되는 일이 없도록)
     WHERE ( ( NVL(MS.VMI_YN, 'N') = 'N' AND MSR.VMI_COND <> 'Y' )
             OR NVL(MS.VMI_YN, 'N') = 'Y' )
     ORDER BY K.END_CUSTOMER, K.SCM_SITE_ID, K.ITEM_ID, K.FCST_TYPE
            , K.INCOTERMS, K.DOM_EXP, K.CELL_PROD_SITE_ID, MSR.MEASURE_SORT;

    OPEN o_result_cursor FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(n_key_cnt) AS EVENT
             , V_WEEK_LIST AS WEEK_LIST   /* [E20260820-XLSWEEKLY] */
        FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT('rows' VALUE REGEXP_COUNT(p_division_id, '\^') + 1, 
            'p_division_id'    VALUE SUBSTR(p_division_id, 1, 50), 'p_dept_id'        VALUE SUBSTR(p_dept_id, 1, 50), 'p_end_customer'   VALUE SUBSTR(p_end_customer, 1, 200)
          , 'p_from_yyyymmdd'  VALUE SUBSTR(p_from_yyyymmdd, 1, 50), 'p_to_yyyymmdd'    VALUE SUBSTR(p_to_yyyymmdd, 1, 50), 'p_sales_site'     VALUE SUBSTR(p_sales_site, 1, 200)
          , 'p_item_id'        VALUE SUBSTR(p_item_id, 1, 200)
          , 'p_version_type'   VALUE SUBSTR(p_version_type, 1, 50), 'p_ses_user_id'    VALUE SUBSTR(p_ses_user_id, 1, 50));
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0082_GET_EXCEL_FORM_DATA;


-- ====================================================================================================
-- [2026.08.15 AJS 신뢰도검사 발견1] MSSQL DMF0082_POPUP_GET_SPREAD_TITLE_DATE (원본 34~50행) 이관.
--   기존에는 SCM_MGR 에 대응 객체가 없고 SCMC(전환 테스트용 스키마)에만 남아 있었다.
--   본문은 MSSQL 원본과 동일하며, 표준 예외 처리와 결과 커서만 패키지 규약에 맞춘다.
-- ====================================================================================================
PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE
(
    p_start_yyyymmdd  IN  VARCHAR2
  , p_end_yyyymmdd    IN  VARCHAR2
  , p_created_by      IN  VARCHAR2
  , O_RC1             OUT SYS_REFCURSOR
  , O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0082_POPUP_GET_SPREAD_TITLE_DATE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.08.15   AJS       신뢰도 검사 — MSSQL 원본 미이관분 이관
 */
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT MIN(BASIS_START_DATE)         AS BASIS_START_DATE
             , BASIS_YYYYMM
             , WEEK_NAME
             , SUBSTR(BASIS_START_DATE, 5, 4) AS DATE_SHORT1_NAME
          FROM SCM_MGR.SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD >= p_start_yyyymmdd
           AND BASIS_YYYYMMDD <= p_end_yyyymmdd
         GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4)
         ORDER BY BASIS_START_DATE;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE,
               'SUCCESS' AS MSG,
               CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT
          FROM DUAL;

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
                             'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
                             'p_end_yyyymmdd'   VALUE p_end_yyyymmdd,
                             'p_created_by'     VALUE p_created_by
                         );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); EXCEPTION WHEN OTHERS THEN NULL; END;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE;

END PKG_DMF0082;
/
