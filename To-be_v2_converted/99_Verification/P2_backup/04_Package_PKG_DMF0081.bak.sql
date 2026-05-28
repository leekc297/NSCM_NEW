/*=============================================================================================
 * File         : 04_Package_PKG_DMF0081.sql
 * Description  : Package — PKG_DMF0081
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0081 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0081                                                                        */
/* Description : PKG_DMF0081                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.24  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0081_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD
(
    P_MODE          IN PLS_INTEGER
   ,P_CREATED_BY    IN VARCHAR2
   ,P_PROGRAM_ID    IN VARCHAR2 -- 3/26 추가 결정
   ,P_SHEET_NAME    IN VARCHAR2 -- 3/26 추가 결정
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP
(
    P_DIVISION_ID   IN VARCHAR2
   ,P_END_CUSTOMER  IN VARCHAR2
   ,P_PROJECT_CODE  IN VARCHAR2
   ,P_MEASURE       IN VARCHAR2
   ,P_YYYYMM        IN VARCHAR2
   ,P_CREATED_BY    IN VARCHAR2
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD
(
    P_EV_TP_CD      IN VARCHAR2
   ,P_CUST_CO_CD    IN VARCHAR2
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RC2           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0081_GET_DM_ANL_MKT_PSI_DATA
(
    P_DIVISION_ID   IN VARCHAR2
   ,P_END_CUSTOMER  IN VARCHAR2
   ,P_PROJECT_CODE  IN VARCHAR2
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS
(
    P_EV_TP_CD      IN VARCHAR2--TYPE
   ,P_CUST_CO_CD    IN VARCHAR2--제조사
   ,P_CAR_MDL_ID    IN VARCHAR2--모델명
   ,P_FROM_YYYYMM   IN VARCHAR2--Period from
   ,P_TO_YYYYMM     IN VARCHAR2--Period to
   ,P_MARKETSHARE   IN VARCHAR2--당사 M/S(%)
   ,P_BIZPERCAR     IN VARCHAR2--BIZ수량 PER CAR
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RC2           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP
(
    P_DIVISION_ID     IN VARCHAR
   ,P_END_CUSTOMER    IN VARCHAR
   ,P_PROJECT_CODE    IN VARCHAR
   ,P_MEASURE         IN VARCHAR
   ,P_YYYYMM          IN VARCHAR
   ,P_REQ_RSN_CD      IN VARCHAR DEFAULT NULL
   ,P_DIF_ANLS_TP_CD  IN VARCHAR DEFAULT NULL
   ,P_ANLS_DIF_RSN_CD IN VARCHAR DEFAULT NULL
   ,P_REQ_RSN_DTL_CTN IN VARCHAR2 DEFAULT NULL
   ,P_QTY             IN NUMBER DEFAULT 0
   ,P_CREATED_BY      IN VARCHAR2 DEFAULT NULL
   ,P_PROCEDURE_TYPE  IN VARCHAR2
   ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

END PKG_DMF0081;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0081 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0081                                                                        */
/* Description : PKG_DMF0081                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.24  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0081_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD
(
      P_MODE          IN PLS_INTEGER
     ,P_CREATED_BY    IN VARCHAR2
     ,P_PROGRAM_ID    IN VARCHAR2 -- 3/26 추가 결정
     ,P_SHEET_NAME    IN VARCHAR2 -- 3/26 추가 결정
     ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*===========================================================================================================
* Program ID   : DMF0081_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD
* Description  : DMF0081_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD
* Program History 
*===========================================================================================================
*   Date       In Charge      DescriptionYYYYQQ
*===========================================================================================================
* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선
==>SCM_ADM_EXCEL_UPLOAD시 필드 2개 추가사용 : ATTRIBUTE5, ATTRIBUTE6
==>해당값을 DM_ANL_CAR_FCST_REF에 저장시 ATTRIBUTE1, ATTRIBUTE2 사용
*=========================================================================================================*/
AS
    
    V_PROGRAM_ID     VARCHAR2(40 CHAR) := P_PROGRAM_ID; --'DMF0081'
    V_SHEET_NAME     VARCHAR2(40 CHAR) := P_SHEET_NAME; --'Car Fcst'
    V_SQL_TEXT       VARCHAR2(32767 CHAR);
    V_CREATION_DATE  DATE;
    V_COUNT          PLS_INTEGER;
    V_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_END_YYYYMMDD   VARCHAR2(8 CHAR);
    V_DIVISION       VARCHAR2(10 CHAR);
    
    -- LOG 용 변수 설정
    V_LOG_TYPE     VARCHAR2(30 CHAR); -- START/END/ERROR/...
    N_LOG_COUNT    PLS_INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
    -- UI Validation 용 변수
    V_VALIDATION_CHECK_RESULT VARCHAR2(200 CHAR) := '';
    V_MSG1                    VARCHAR2(200 CHAR) := '';
    
    -- Column Size 검증 용 변수
    VEV_TP_CD_SIZE   PLS_INTEGER;
    VCUST_GR_ID_SIZE PLS_INTEGER;
    VCUST_CO_CD_SIZE PLS_INTEGER;
    VCAR_MDL_ID_SIZE PLS_INTEGER;
    VMEASURE_SIZE    PLS_INTEGER;
    --DECLARE @vPLAN_YYYYMM_SIZE AS INT = (SELECT SIZE  FROM #TEMP_COLUMN_SIZE A WITH(NOLOCK) WHERE A.COLUMN_NAME = 'PLAN_YYYYMM') --PLAN_YYYYMM쪽에 들어가는건 실제로는 QTY기 때문에 검증에서 패스..
    V_MSG2 VARCHAR2(100 CHAR) := ' Over of Column Size';
    
    -- 숫자 검증 용 변수
    V_MSG3 VARCHAR2(100 CHAR) := 'The quantity value contains non-numeric data.';
    
    -- 임시테이블 STATUS 구분
    VTEMPTABLE_TYPE VARCHAR2(10 CHAR);
    
    -- EXCEPTION 처리 용 변수 (Case 24)
    V_PROC_INPUT VARCHAR2(4000 CHAR);
    V_BACKTRACE  VARCHAR2(4000 CHAR);
    V_SQL_CODE   VARCHAR2(100 CHAR);
    V_SQL_ERRMSG VARCHAR2(1000 CHAR);
    
BEGIN
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    
    -- GTT 초기화 : 이전에 일반 테이블 DML이 없으므로 TRUNCATE 사용 가능
    -- (단, 아래 DML 전이므로 안전하게 프로시저 진입 시 정리)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM81_DM_YEARLY_MKT_DMD_ANALYSIS';
    
    -- CREATION_DATE 최대값 조회 (SELECT 변수 = 테이블컬럼 → INTO 변환)
    --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
    SELECT MAX(T.CREATION_DATE)
    INTO   V_CREATION_DATE
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = V_PROGRAM_ID
    AND    T.SHEET_NAME = V_SHEET_NAME
    AND    T.CREATED_BY = P_CREATED_BY;
    
    IF V_CREATION_DATE IS NULL THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'Data Not Found [' || TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') || ']';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_DESCRIPTION AS MSG, NULL AS EVENT FROM DUAL;
        RETURN;
    END IF;
    
    -- @p_mode = 0 이면 Validation Check (1. UPLOAD_STATUS_CODE 정의)
    IF NVL(P_MODE, 0) = 0 THEN
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        --EXCEL 업로드시 Validation Check 할 동안 임시적으로 UPLOAD로 UPDATE한다.
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
        SET    T.UPLOAD_STATUS_CODE = 'UPLOAD', T.MESSAGE_TEXT = NULL
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY
        AND    T.CREATION_DATE = V_CREATION_DATE
        AND    NVL(T.UPLOAD_STATUS_CODE, 'X') NOT IN ('UPLOAD');
        
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
        V_LOG_TYPE    := '1';
        V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        --EXCEL에서 값이 입력되지 않은 것은 SKIP 하는건데 기준은 ATTRIBUTE1이 비었으면 실행한다. (TOTAL 일단 무시..)
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID = V_PROGRAM_ID
        AND    SHEET_NAME = V_SHEET_NAME
        AND    CREATED_BY = P_CREATED_BY
        AND    CREATION_DATE = V_CREATION_DATE
        AND    (ATTRIBUTE1 IS NULL OR UPPER(ATTRIBUTE1) = 'TOTAL');
        
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
        V_LOG_TYPE    := '2';
        V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        --EXCEL에서 첫 행 (HEADER 정보를 가져오기 위함 =UPLOAD_STATUS_CODE 값이 @TITLE 인것)
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID = V_PROGRAM_ID
        AND    SHEET_NAME = V_SHEET_NAME
        AND    CREATED_BY = P_CREATED_BY
        AND    CREATION_DATE = V_CREATION_DATE
        AND    UPPER(ATTRIBUTE1) = 'TYPE*'; -- EXCEL기준 A1 에 해당하는 값이 Division인 행을 @TITLE로 업데이트 함.  
        
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
        V_LOG_TYPE    := '3';
        V_LOG_MESSAGE := '########## TITLE Header Line ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
    END IF;
    
    IF NVL(P_MODE, 0) = 0 THEN
        
        -- UI Validation
        -- 1-1. 업로드 Header 의 컬럼 정합성 검증 - 업로드 구간이 60개월인지 확인
        V_MSG1 := '60개월 구간의 데이터가 입력되어야 합니다.';
        
        SELECT CASE
                   WHEN COUNT(*) = 60 THEN
                    'SUCCESS'
                   ELSE
                    V_MSG1
               END
        INTO   V_VALIDATION_CHECK_RESULT
        FROM   (SELECT ATTRIBUTE1        AS EV_TP_CD
                      ,ATTRIBUTE2        AS CUST_GR_ID
                      ,ATTRIBUTE3        AS CUST_CO_CD
                      ,ATTRIBUTE4        AS CAR_MDL_ID
                      ,ATTRIBUTE5        AS MEASURE
                      ,UNPVT.PLAN_YYYYMM
                      ,UNPVT.YYYYMM
                      ,CREATION_DATE
                FROM   (SELECT X.ATTRIBUTE1
                              ,X.ATTRIBUTE2
                              ,X.ATTRIBUTE3
                              ,X.ATTRIBUTE4
                              ,X.ATTRIBUTE5 --Type* OEM Group* Brand* Vehicle* 구분*
                              ,X.ATTRIBUTE6
                              ,X.ATTRIBUTE7
                              ,X.ATTRIBUTE8
                              ,X.ATTRIBUTE9
                              ,X.ATTRIBUTE10
                              ,X.ATTRIBUTE11 --PLAN_YYYYMM
                              ,X.ATTRIBUTE12
                              ,X.ATTRIBUTE13
                              ,X.ATTRIBUTE14
                              ,X.ATTRIBUTE15
                              ,X.ATTRIBUTE16
                              ,X.ATTRIBUTE17 --PLAN_YYYYMM
                              ,X.ATTRIBUTE18
                              ,X.ATTRIBUTE19
                              ,X.ATTRIBUTE20
                              ,X.ATTRIBUTE21
                              ,X.ATTRIBUTE22
                              ,X.ATTRIBUTE23 --PLAN_YYYYMM
                              ,X.ATTRIBUTE24
                              ,X.ATTRIBUTE25
                              ,X.ATTRIBUTE26
                              ,X.ATTRIBUTE27
                              ,X.ATTRIBUTE28
                              ,X.ATTRIBUTE29 --PLAN_YYYYMM
                              ,X.ATTRIBUTE30
                              ,X.ATTRIBUTE31
                              ,X.ATTRIBUTE32
                              ,X.ATTRIBUTE33
                              ,X.ATTRIBUTE34
                              ,X.ATTRIBUTE35 --PLAN_YYYYMM
                              ,X.ATTRIBUTE36
                              ,X.ATTRIBUTE37
                              ,X.ATTRIBUTE38
                              ,X.ATTRIBUTE39
                              ,X.ATTRIBUTE40
                              ,X.ATTRIBUTE41 --PLAN_YYYYMM
                              ,X.ATTRIBUTE42
                              ,X.ATTRIBUTE43
                              ,X.ATTRIBUTE44
                              ,X.ATTRIBUTE45
                              ,X.ATTRIBUTE46
                              ,X.ATTRIBUTE47 --PLAN_YYYYMM
                              ,X.ATTRIBUTE48
                              ,X.ATTRIBUTE49
                              ,X.ATTRIBUTE50
                              ,X.ATTRIBUTE51
                              ,X.ATTRIBUTE52
                              ,X.ATTRIBUTE53 --PLAN_YYYYMM
                              ,X.ATTRIBUTE54
                              ,X.ATTRIBUTE55
                              ,X.ATTRIBUTE56
                              ,X.ATTRIBUTE57
                              ,X.ATTRIBUTE58
                              ,X.ATTRIBUTE59 --PLAN_YYYYMM
                              ,X.ATTRIBUTE60
                              ,X.ATTRIBUTE61
                              ,X.ATTRIBUTE62
                              ,X.ATTRIBUTE63
                              ,X.ATTRIBUTE64
                              ,X.ATTRIBUTE65 --혹시나 개월이 추가되거나 하면 여기랑 
                              ,X.CREATION_DATE
                        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
                        WHERE  X.PROGRAM_ID = V_PROGRAM_ID -- 'DMF0081' 
                        AND    X.SHEET_NAME = V_SHEET_NAME -- 'Car Fcst' 
                        AND    X.CREATED_BY = P_CREATED_BY -- 'dsiol'
                        AND    X.CREATION_DATE = V_CREATION_DATE -- '2024-11-15 13:17:16.000' 
                        AND    X.UPLOAD_STATUS_CODE = '@TITLE') T UNPIVOT(YYYYMM FOR PLAN_YYYYMM IN(ATTRIBUTE6
                                                                                                   ,ATTRIBUTE7
                                                                                                   ,ATTRIBUTE8
                                                                                                   ,ATTRIBUTE9
                                                                                                   ,ATTRIBUTE10
                                                                                                   ,ATTRIBUTE11 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE12
                                                                                                   ,ATTRIBUTE13
                                                                                                   ,ATTRIBUTE14
                                                                                                   ,ATTRIBUTE15
                                                                                                   ,ATTRIBUTE16
                                                                                                   ,ATTRIBUTE17 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE18
                                                                                                   ,ATTRIBUTE19
                                                                                                   ,ATTRIBUTE20
                                                                                                   ,ATTRIBUTE21
                                                                                                   ,ATTRIBUTE22
                                                                                                   ,ATTRIBUTE23 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE24
                                                                                                   ,ATTRIBUTE25
                                                                                                   ,ATTRIBUTE26
                                                                                                   ,ATTRIBUTE27
                                                                                                   ,ATTRIBUTE28
                                                                                                   ,ATTRIBUTE29 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE30
                                                                                                   ,ATTRIBUTE31
                                                                                                   ,ATTRIBUTE32
                                                                                                   ,ATTRIBUTE33
                                                                                                   ,ATTRIBUTE34
                                                                                                   ,ATTRIBUTE35 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE36
                                                                                                   ,ATTRIBUTE37
                                                                                                   ,ATTRIBUTE38
                                                                                                   ,ATTRIBUTE39
                                                                                                   ,ATTRIBUTE40
                                                                                                   ,ATTRIBUTE41 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE42
                                                                                                   ,ATTRIBUTE43
                                                                                                   ,ATTRIBUTE44
                                                                                                   ,ATTRIBUTE45
                                                                                                   ,ATTRIBUTE46
                                                                                                   ,ATTRIBUTE47 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE48
                                                                                                   ,ATTRIBUTE49
                                                                                                   ,ATTRIBUTE50
                                                                                                   ,ATTRIBUTE51
                                                                                                   ,ATTRIBUTE52
                                                                                                   ,ATTRIBUTE53 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE54
                                                                                                   ,ATTRIBUTE55
                                                                                                   ,ATTRIBUTE56
                                                                                                   ,ATTRIBUTE57
                                                                                                   ,ATTRIBUTE58
                                                                                                   ,ATTRIBUTE59 --PLAN_YYYYMM
                                                                                                   ,ATTRIBUTE60
                                                                                                   ,ATTRIBUTE61
                                                                                                   ,ATTRIBUTE62
                                                                                                   ,ATTRIBUTE63
                                                                                                   ,ATTRIBUTE64
                                                                                                   ,ATTRIBUTE65 --여기 추가 하면 됨 
                                                                                                    )) UNPVT
                GROUP  BY CREATION_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, PLAN_YYYYMM, UNPVT.YYYYMM
                HAVING LENGTH(NVL(YYYYMM, 'FAIL')) = 6) A;
        
        IF V_VALIDATION_CHECK_RESULT <> 'SUCCESS' THEN
            -- UI에 Error Msg 를 보여준다.
            -- 프로시저를 종료 한다.
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := V_VALIDATION_CHECK_RESULT;
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;
            
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_VALIDATION_CHECK_RESULT AS MSG, NULL AS EVENT FROM DUAL;
            RETURN;
        END IF;
        
        -- 1-2. 업로드 Header 의 컬럼 정합성 검증 - 날짜 타입이 맞는지 확인.
        -- (ex: 필수컬럼 누락 여부, YYYYMM 형태에 부합하지 않는 Header 등이 있는 경우, UI에서 메시지 주고 리턴 필요)
        V_MSG1 := ' 는 올바른 날짜타입이 아닙니다.' || CHR(10) || '해당 헤더를 ex) 202411 ← 으로 해주세요.'; -- CHR(10)는 ENTER (개행)
        
        SELECT CASE
                   WHEN NVL(X.ATTRIBUTE1, 'FAIL') <> 'Type*' THEN
                    '첫번째 헤더는 Type* 으로 입력해주세요.'
                   WHEN NVL(X.ATTRIBUTE2, 'FAIL') <> 'OEM Group*' THEN
                    '두번째 헤더는 OEM Group* 으로 입력해주세요.'
                   WHEN NVL(X.ATTRIBUTE3, 'FAIL') <> 'Brand*' THEN
                    '세번째 헤더는 Brand* 으로 입력해주세요.'
                   WHEN NVL(X.ATTRIBUTE4, 'FAIL') <> 'Vehicle*' THEN
                    '네번째 헤더는 Vehicle* 으로 입력해주세요.'
                   WHEN NVL(X.ATTRIBUTE5, 'FAIL') <> '구분*' THEN
                    '다섯번째 헤더는 구분* 으로 입력해주세요.'
                   
                   WHEN LENGTH(NVL(X.ATTRIBUTE6, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE6, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE6 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE7, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE7, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE7 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE8, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE8, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE8 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE9, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE9, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE9 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE10, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE10, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE10 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE11, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE11, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE11 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE12, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE12, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE12 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE13, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE13, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE13 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE14, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE14, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE14 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE15, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE15, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE15 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE16, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE16, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE16 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE17, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE17, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE17 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE18, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE18, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE18 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE19, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE19, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE19 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE20, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE20, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE20 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE21, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE21, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE21 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE22, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE22, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE22 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE23, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE23, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE23 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE24, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE24, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE24 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE25, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE25, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE25 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE26, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE26, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE26 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE27, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE27, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE27 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE28, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE28, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE28 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE29, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE29, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE29 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE30, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE30, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE30 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE31, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE31, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE31 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE32, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE32, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE32 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE33, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE33, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE33 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE34, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE34, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE34 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE35, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE35, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE35 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE36, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE36, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE36 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE37, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE37, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE37 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE38, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE38, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE38 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE39, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE39, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE39 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE40, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE40, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE40 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE41, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE41, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE41 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE42, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE42, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE42 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE43, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE43, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE43 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE44, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE44, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE44 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE45, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE45, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE45 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE46, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE46, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE46 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE47, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE47, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE47 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE48, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE48, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE48 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE49, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE49, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE49 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE50, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE50, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE50 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE51, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE51, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE51 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE52, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE52, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE52 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE53, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE53, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE53 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE54, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE54, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE54 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE55, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE55, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE55 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE56, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE56, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE56 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE57, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE57, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE57 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE58, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE58, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE58 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE59, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE59, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE59 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE60, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE60, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE60 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE61, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE61, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE61 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE62, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE62, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE62 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE63, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE63, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE63 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE64, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE64, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE64 || V_MSG1
                   WHEN LENGTH(NVL(X.ATTRIBUTE65, 'FAIL')) <> 6 OR VALIDATE_CONVERSION(SUBSTR(X.ATTRIBUTE65, 1, 6) AS DATE, 'YYYYMM') = 0 THEN
                    X.ATTRIBUTE65 || V_MSG1
                   ELSE
                    'SUCCESS'
               END
        INTO   V_VALIDATION_CHECK_RESULT
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
        WHERE  X.PROGRAM_ID = V_PROGRAM_ID -- 'DMF0081' 
        AND    X.SHEET_NAME = V_SHEET_NAME -- 'Car Fcst' 
        AND    X.CREATED_BY = P_CREATED_BY -- 'dsiol'
        AND    X.CREATION_DATE = V_CREATION_DATE -- '2024-11-15 13:17:16.000' 
        AND    X.UPLOAD_STATUS_CODE = '@TITLE';
        
        IF V_VALIDATION_CHECK_RESULT <> 'SUCCESS' THEN
            -- UI에 Error Msg 를 보여준다.
            -- 프로시저를 종료 한다.
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := V_VALIDATION_CHECK_RESULT;
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;
            
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : ' || V_VALIDATION_CHECK_RESULT AS MSG, NULL AS EVENT FROM DUAL;
            RETURN;
        END IF;
        
        -- DB Validation
        -- 2.1 업로드한 데이터의 Key값 중복여부 검증(Type, Brand, Vehicle, Measure)
        -- 2.2 업로드한 데이터의 컬럼 최대사이즈 초과여부 검증(Type, Brand, Vehicle, Measure)
        -- 2.3 업로드한 데이터의 월별 수량 값에 숫자가 아닌 데이터가 존재하는지 검증
        -- 2.4 Validation 결과가 전부 Success 인 경우, 적재 테이블에 데이터 반영
        
        -- 2.1 업로드한 데이터의 Key값 중복여부 검증(Type, Brand, Vehicle, Measure, OEM Group)
        -- Validation Check - Duplication Key
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Duplication Key.'
        WHERE  PROGRAM_ID = V_PROGRAM_ID
        AND    SHEET_NAME = V_SHEET_NAME
        AND    CREATED_BY = P_CREATED_BY
        AND    CREATION_DATE = V_CREATION_DATE
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    EXISTS (SELECT 1
                FROM   (SELECT X.ATTRIBUTE1 AS COL1, X.ATTRIBUTE2 AS COL2, X.ATTRIBUTE3 AS COL3, X.ATTRIBUTE4 AS COL4, X.ATTRIBUTE5 AS COL5
                        FROM   SCM_ADM_EXCEL_UPLOAD X
                        WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                        AND    X.SHEET_NAME = V_SHEET_NAME
                        AND    X.CREATED_BY = P_CREATED_BY
                        AND    X.CREATION_DATE = V_CREATION_DATE
                        AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                        GROUP  BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE5
                        HAVING COUNT(*) > 1) T
                WHERE  1 = 1
                AND    T.COL1 = ATTRIBUTE1
                AND    T.COL2 = ATTRIBUTE2
                AND    T.COL3 = ATTRIBUTE3
                AND    T.COL4 = ATTRIBUTE4
                AND    T.COL5 = ATTRIBUTE5);
        
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        
        -- 2.2 업로드한 데이터의 컬럼 최대사이즈 초과여부 검증(Type, Brand, Vehicle, Measure)
        -- #TEMP_COLUMN_SIZE 대체: INFORMATION_SCHEMA → Oracle USER_TAB_COLUMNS 인라인 조회
        SELECT MAX(CASE
                       WHEN COLUMN_NAME = 'EV_TP_CD' THEN
                        CHAR_LENGTH
                   END)
              ,MAX(CASE
                       WHEN COLUMN_NAME = 'CUST_GR_ID' THEN
                        CHAR_LENGTH
                   END)
              ,MAX(CASE
                       WHEN COLUMN_NAME = 'CUST_CO_CD' THEN
                        CHAR_LENGTH
                   END)
              ,MAX(CASE
                       WHEN COLUMN_NAME = 'CAR_MDL_ID' THEN
                        CHAR_LENGTH
                   END)
              ,MAX(CASE
                       WHEN COLUMN_NAME = 'MEASURE' THEN
                        CHAR_LENGTH
                   END)
        INTO   VEV_TP_CD_SIZE, VCUST_GR_ID_SIZE, VCUST_CO_CD_SIZE, VCAR_MDL_ID_SIZE, VMEASURE_SIZE
        FROM   USER_TAB_COLUMNS
        WHERE  TABLE_NAME = 'DM_YEARLY_MKT_DMD_ANALYSIS'
        AND    COLUMN_NAME IN ('EV_TP_CD', 'CUST_GR_ID', 'CUST_CO_CD', 'CAR_MDL_ID', 'MEASURE');
        
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
              ,MESSAGE_TEXT = CASE
                                  WHEN LENGTHB(ATTRIBUTE1) > VEV_TP_CD_SIZE THEN
                                   ATTRIBUTE1 || ' ' || TO_CHAR(LENGTHB(ATTRIBUTE1)) || ' > ' || TO_CHAR(VEV_TP_CD_SIZE) || V_MSG2
                                  WHEN LENGTHB(ATTRIBUTE2) > VCUST_GR_ID_SIZE THEN
                                   ATTRIBUTE2 || ' ' || TO_CHAR(LENGTHB(ATTRIBUTE2)) || ' > ' || TO_CHAR(VCUST_GR_ID_SIZE) || V_MSG2
                                  WHEN LENGTHB(ATTRIBUTE3) > VCUST_CO_CD_SIZE THEN
                                   ATTRIBUTE3 || ' ' || TO_CHAR(LENGTHB(ATTRIBUTE3)) || ' > ' || TO_CHAR(VCUST_CO_CD_SIZE) || V_MSG2
                                  WHEN LENGTHB(ATTRIBUTE4) > VCAR_MDL_ID_SIZE THEN
                                   ATTRIBUTE4 || ' ' || TO_CHAR(LENGTHB(ATTRIBUTE4)) || ' > ' || TO_CHAR(VCAR_MDL_ID_SIZE) || V_MSG2
                                  WHEN LENGTHB(ATTRIBUTE5) > VMEASURE_SIZE THEN
                                   ATTRIBUTE5 || ' ' || TO_CHAR(LENGTHB(ATTRIBUTE5)) || ' > ' || TO_CHAR(VMEASURE_SIZE) || V_MSG2
                              END
        WHERE  PROGRAM_ID = V_PROGRAM_ID
        AND    SHEET_NAME = V_SHEET_NAME
        AND    CREATED_BY = P_CREATED_BY
        AND    CREATION_DATE = V_CREATION_DATE
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (LENGTHB(ATTRIBUTE1) > VEV_TP_CD_SIZE OR LENGTHB(ATTRIBUTE2) > VCUST_GR_ID_SIZE OR LENGTHB(ATTRIBUTE3) > VCUST_CO_CD_SIZE OR
              LENGTHB(ATTRIBUTE4) > VCAR_MDL_ID_SIZE OR LENGTHB(ATTRIBUTE5) > VMEASURE_SIZE);
        
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR Over of Column Size ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        
        -- 2.3 업로드한 데이터의 월별 수량 값에 숫자가 아닌 데이터가 존재하는지 검증
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
              ,MESSAGE_TEXT = CASE
                                  WHEN (ATTRIBUTE6 IS NOT NULL AND LENGTH(ATTRIBUTE6) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE6, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE6 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE7 IS NOT NULL AND LENGTH(ATTRIBUTE7) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE7, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE7 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE8 IS NOT NULL AND LENGTH(ATTRIBUTE8) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE8, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE8 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE9 IS NOT NULL AND LENGTH(ATTRIBUTE9) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE9, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE9 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE10 IS NOT NULL AND LENGTH(ATTRIBUTE10) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE10, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE10 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE11 IS NOT NULL AND LENGTH(ATTRIBUTE11) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE11, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE11 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE12 IS NOT NULL AND LENGTH(ATTRIBUTE12) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE12, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE12 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE13 IS NOT NULL AND LENGTH(ATTRIBUTE13) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE13, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE13 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE14 IS NOT NULL AND LENGTH(ATTRIBUTE14) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE14, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE14 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE15 IS NOT NULL AND LENGTH(ATTRIBUTE15) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE15, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE15 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE16 IS NOT NULL AND LENGTH(ATTRIBUTE16) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE16, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE16 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE17 IS NOT NULL AND LENGTH(ATTRIBUTE17) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE17, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE17 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE18 IS NOT NULL AND LENGTH(ATTRIBUTE18) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE18, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE18 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE19 IS NOT NULL AND LENGTH(ATTRIBUTE19) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE19, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE19 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE20 IS NOT NULL AND LENGTH(ATTRIBUTE20) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE20, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE20 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE21 IS NOT NULL AND LENGTH(ATTRIBUTE21) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE21, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE21 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE22 IS NOT NULL AND LENGTH(ATTRIBUTE22) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE22, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE22 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE23 IS NOT NULL AND LENGTH(ATTRIBUTE23) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE23, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE23 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE24 IS NOT NULL AND LENGTH(ATTRIBUTE24) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE24, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE24 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE25 IS NOT NULL AND LENGTH(ATTRIBUTE25) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE25, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE25 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE26 IS NOT NULL AND LENGTH(ATTRIBUTE26) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE26, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE26 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE27 IS NOT NULL AND LENGTH(ATTRIBUTE27) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE27, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE27 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE28 IS NOT NULL AND LENGTH(ATTRIBUTE28) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE28, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE28 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE29 IS NOT NULL AND LENGTH(ATTRIBUTE29) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE29, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE29 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE30 IS NOT NULL AND LENGTH(ATTRIBUTE30) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE30, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE30 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE31 IS NOT NULL AND LENGTH(ATTRIBUTE31) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE31, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE31 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE32 IS NOT NULL AND LENGTH(ATTRIBUTE32) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE32, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE32 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE33 IS NOT NULL AND LENGTH(ATTRIBUTE33) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE33, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE33 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE34 IS NOT NULL AND LENGTH(ATTRIBUTE34) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE34, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE34 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE35 IS NOT NULL AND LENGTH(ATTRIBUTE35) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE35, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE35 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE36 IS NOT NULL AND LENGTH(ATTRIBUTE36) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE36, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE36 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE37 IS NOT NULL AND LENGTH(ATTRIBUTE37) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE37, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE37 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE38 IS NOT NULL AND LENGTH(ATTRIBUTE38) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE38, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE38 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE39 IS NOT NULL AND LENGTH(ATTRIBUTE39) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE39, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE39 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE40 IS NOT NULL AND LENGTH(ATTRIBUTE40) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE40, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE40 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE41 IS NOT NULL AND LENGTH(ATTRIBUTE41) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE41, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE41 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE42 IS NOT NULL AND LENGTH(ATTRIBUTE42) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE42, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE42 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE43 IS NOT NULL AND LENGTH(ATTRIBUTE43) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE43, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE43 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE44 IS NOT NULL AND LENGTH(ATTRIBUTE44) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE44, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE44 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE45 IS NOT NULL AND LENGTH(ATTRIBUTE45) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE45, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE45 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE46 IS NOT NULL AND LENGTH(ATTRIBUTE46) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE46, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE46 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE47 IS NOT NULL AND LENGTH(ATTRIBUTE47) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE47, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE47 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE48 IS NOT NULL AND LENGTH(ATTRIBUTE48) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE48, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE48 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE49 IS NOT NULL AND LENGTH(ATTRIBUTE49) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE49, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE49 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE50 IS NOT NULL AND LENGTH(ATTRIBUTE50) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE50, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE50 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE51 IS NOT NULL AND LENGTH(ATTRIBUTE51) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE51, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE51 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE52 IS NOT NULL AND LENGTH(ATTRIBUTE52) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE52, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE52 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE53 IS NOT NULL AND LENGTH(ATTRIBUTE53) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE53, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE53 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE54 IS NOT NULL AND LENGTH(ATTRIBUTE54) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE54, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE54 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE55 IS NOT NULL AND LENGTH(ATTRIBUTE55) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE55, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE55 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE56 IS NOT NULL AND LENGTH(ATTRIBUTE56) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE56, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE56 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE57 IS NOT NULL AND LENGTH(ATTRIBUTE57) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE57, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE57 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE58 IS NOT NULL AND LENGTH(ATTRIBUTE58) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE58, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE58 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE59 IS NOT NULL AND LENGTH(ATTRIBUTE59) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE59, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE59 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE60 IS NOT NULL AND LENGTH(ATTRIBUTE60) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE60, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE60 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE61 IS NOT NULL AND LENGTH(ATTRIBUTE61) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE61, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE61 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE62 IS NOT NULL AND LENGTH(ATTRIBUTE62) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE62, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE62 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE63 IS NOT NULL AND LENGTH(ATTRIBUTE63) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE63, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE63 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE64 IS NOT NULL AND LENGTH(ATTRIBUTE64) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE64, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE64 || ' = ' || V_MSG3
                                  WHEN (ATTRIBUTE65 IS NOT NULL AND LENGTH(ATTRIBUTE65) > 0) AND
                                       TO_NUMBER(NVL(ATTRIBUTE65, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL THEN
                                   ATTRIBUTE65 || ' = ' || V_MSG3
                              END
        WHERE  PROGRAM_ID = V_PROGRAM_ID
        AND    SHEET_NAME = V_SHEET_NAME
        AND    CREATED_BY = P_CREATED_BY
        AND    CREATION_DATE = V_CREATION_DATE
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ((ATTRIBUTE6 IS NOT NULL AND LENGTH(ATTRIBUTE6) > 0) AND TO_NUMBER(NVL(ATTRIBUTE6, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE7 IS NOT NULL AND LENGTH(ATTRIBUTE7) > 0) AND TO_NUMBER(NVL(ATTRIBUTE7, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE8 IS NOT NULL AND LENGTH(ATTRIBUTE8) > 0) AND TO_NUMBER(NVL(ATTRIBUTE8, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE9 IS NOT NULL AND LENGTH(ATTRIBUTE9) > 0) AND TO_NUMBER(NVL(ATTRIBUTE9, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE10 IS NOT NULL AND LENGTH(ATTRIBUTE10) > 0) AND TO_NUMBER(NVL(ATTRIBUTE10, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE11 IS NOT NULL AND LENGTH(ATTRIBUTE11) > 0) AND TO_NUMBER(NVL(ATTRIBUTE11, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE12 IS NOT NULL AND LENGTH(ATTRIBUTE12) > 0) AND TO_NUMBER(NVL(ATTRIBUTE12, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE13 IS NOT NULL AND LENGTH(ATTRIBUTE13) > 0) AND TO_NUMBER(NVL(ATTRIBUTE13, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE14 IS NOT NULL AND LENGTH(ATTRIBUTE14) > 0) AND TO_NUMBER(NVL(ATTRIBUTE14, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE15 IS NOT NULL AND LENGTH(ATTRIBUTE15) > 0) AND TO_NUMBER(NVL(ATTRIBUTE15, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE16 IS NOT NULL AND LENGTH(ATTRIBUTE16) > 0) AND TO_NUMBER(NVL(ATTRIBUTE16, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE17 IS NOT NULL AND LENGTH(ATTRIBUTE17) > 0) AND TO_NUMBER(NVL(ATTRIBUTE17, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE18 IS NOT NULL AND LENGTH(ATTRIBUTE18) > 0) AND TO_NUMBER(NVL(ATTRIBUTE18, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE19 IS NOT NULL AND LENGTH(ATTRIBUTE19) > 0) AND TO_NUMBER(NVL(ATTRIBUTE19, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE20 IS NOT NULL AND LENGTH(ATTRIBUTE20) > 0) AND TO_NUMBER(NVL(ATTRIBUTE20, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE21 IS NOT NULL AND LENGTH(ATTRIBUTE21) > 0) AND TO_NUMBER(NVL(ATTRIBUTE21, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE22 IS NOT NULL AND LENGTH(ATTRIBUTE22) > 0) AND TO_NUMBER(NVL(ATTRIBUTE22, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE23 IS NOT NULL AND LENGTH(ATTRIBUTE23) > 0) AND TO_NUMBER(NVL(ATTRIBUTE23, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE24 IS NOT NULL AND LENGTH(ATTRIBUTE24) > 0) AND TO_NUMBER(NVL(ATTRIBUTE24, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE25 IS NOT NULL AND LENGTH(ATTRIBUTE25) > 0) AND TO_NUMBER(NVL(ATTRIBUTE25, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE26 IS NOT NULL AND LENGTH(ATTRIBUTE26) > 0) AND TO_NUMBER(NVL(ATTRIBUTE26, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE27 IS NOT NULL AND LENGTH(ATTRIBUTE27) > 0) AND TO_NUMBER(NVL(ATTRIBUTE27, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE28 IS NOT NULL AND LENGTH(ATTRIBUTE28) > 0) AND TO_NUMBER(NVL(ATTRIBUTE28, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE29 IS NOT NULL AND LENGTH(ATTRIBUTE29) > 0) AND TO_NUMBER(NVL(ATTRIBUTE29, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE30 IS NOT NULL AND LENGTH(ATTRIBUTE30) > 0) AND TO_NUMBER(NVL(ATTRIBUTE30, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE31 IS NOT NULL AND LENGTH(ATTRIBUTE31) > 0) AND TO_NUMBER(NVL(ATTRIBUTE31, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE32 IS NOT NULL AND LENGTH(ATTRIBUTE32) > 0) AND TO_NUMBER(NVL(ATTRIBUTE32, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE33 IS NOT NULL AND LENGTH(ATTRIBUTE33) > 0) AND TO_NUMBER(NVL(ATTRIBUTE33, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE34 IS NOT NULL AND LENGTH(ATTRIBUTE34) > 0) AND TO_NUMBER(NVL(ATTRIBUTE34, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE35 IS NOT NULL AND LENGTH(ATTRIBUTE35) > 0) AND TO_NUMBER(NVL(ATTRIBUTE35, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE36 IS NOT NULL AND LENGTH(ATTRIBUTE36) > 0) AND TO_NUMBER(NVL(ATTRIBUTE36, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE37 IS NOT NULL AND LENGTH(ATTRIBUTE37) > 0) AND TO_NUMBER(NVL(ATTRIBUTE37, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE38 IS NOT NULL AND LENGTH(ATTRIBUTE38) > 0) AND TO_NUMBER(NVL(ATTRIBUTE38, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE39 IS NOT NULL AND LENGTH(ATTRIBUTE39) > 0) AND TO_NUMBER(NVL(ATTRIBUTE39, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE40 IS NOT NULL AND LENGTH(ATTRIBUTE40) > 0) AND TO_NUMBER(NVL(ATTRIBUTE40, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE41 IS NOT NULL AND LENGTH(ATTRIBUTE41) > 0) AND TO_NUMBER(NVL(ATTRIBUTE41, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE42 IS NOT NULL AND LENGTH(ATTRIBUTE42) > 0) AND TO_NUMBER(NVL(ATTRIBUTE42, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE43 IS NOT NULL AND LENGTH(ATTRIBUTE43) > 0) AND TO_NUMBER(NVL(ATTRIBUTE43, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE44 IS NOT NULL AND LENGTH(ATTRIBUTE44) > 0) AND TO_NUMBER(NVL(ATTRIBUTE44, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE45 IS NOT NULL AND LENGTH(ATTRIBUTE45) > 0) AND TO_NUMBER(NVL(ATTRIBUTE45, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE46 IS NOT NULL AND LENGTH(ATTRIBUTE46) > 0) AND TO_NUMBER(NVL(ATTRIBUTE46, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE47 IS NOT NULL AND LENGTH(ATTRIBUTE47) > 0) AND TO_NUMBER(NVL(ATTRIBUTE47, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE48 IS NOT NULL AND LENGTH(ATTRIBUTE48) > 0) AND TO_NUMBER(NVL(ATTRIBUTE48, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE49 IS NOT NULL AND LENGTH(ATTRIBUTE49) > 0) AND TO_NUMBER(NVL(ATTRIBUTE49, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE50 IS NOT NULL AND LENGTH(ATTRIBUTE50) > 0) AND TO_NUMBER(NVL(ATTRIBUTE50, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE51 IS NOT NULL AND LENGTH(ATTRIBUTE51) > 0) AND TO_NUMBER(NVL(ATTRIBUTE51, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE52 IS NOT NULL AND LENGTH(ATTRIBUTE52) > 0) AND TO_NUMBER(NVL(ATTRIBUTE52, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE53 IS NOT NULL AND LENGTH(ATTRIBUTE53) > 0) AND TO_NUMBER(NVL(ATTRIBUTE53, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE54 IS NOT NULL AND LENGTH(ATTRIBUTE54) > 0) AND TO_NUMBER(NVL(ATTRIBUTE54, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE55 IS NOT NULL AND LENGTH(ATTRIBUTE55) > 0) AND TO_NUMBER(NVL(ATTRIBUTE55, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE56 IS NOT NULL AND LENGTH(ATTRIBUTE56) > 0) AND TO_NUMBER(NVL(ATTRIBUTE56, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE57 IS NOT NULL AND LENGTH(ATTRIBUTE57) > 0) AND TO_NUMBER(NVL(ATTRIBUTE57, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE58 IS NOT NULL AND LENGTH(ATTRIBUTE58) > 0) AND TO_NUMBER(NVL(ATTRIBUTE58, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE59 IS NOT NULL AND LENGTH(ATTRIBUTE59) > 0) AND TO_NUMBER(NVL(ATTRIBUTE59, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE60 IS NOT NULL AND LENGTH(ATTRIBUTE60) > 0) AND TO_NUMBER(NVL(ATTRIBUTE60, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE61 IS NOT NULL AND LENGTH(ATTRIBUTE61) > 0) AND TO_NUMBER(NVL(ATTRIBUTE61, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE62 IS NOT NULL AND LENGTH(ATTRIBUTE62) > 0) AND TO_NUMBER(NVL(ATTRIBUTE62, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE63 IS NOT NULL AND LENGTH(ATTRIBUTE63) > 0) AND TO_NUMBER(NVL(ATTRIBUTE63, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE64 IS NOT NULL AND LENGTH(ATTRIBUTE64) > 0) AND TO_NUMBER(NVL(ATTRIBUTE64, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL OR
              (ATTRIBUTE65 IS NOT NULL AND LENGTH(ATTRIBUTE65) > 0) AND TO_NUMBER(NVL(ATTRIBUTE65, '0') DEFAULT NULL ON CONVERSION ERROR) IS NULL);
        
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR The quantity value contains non-numeric data. ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID = V_PROGRAM_ID
        AND    SHEET_NAME = V_SHEET_NAME
        AND    CREATED_BY = P_CREATED_BY
        AND    CREATION_DATE = V_CREATION_DATE
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';
        
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '16';
        V_LOG_MESSAGE := '########## SUCCESS ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
    END IF;
    
    --Validation Check 결과 ERROR가 있었는지 마지막으로 확인
    SELECT COUNT(1)
    INTO   V_COUNT
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = V_PROGRAM_ID
    AND    T.SHEET_NAME = V_SHEET_NAME
    AND    T.CREATED_BY = P_CREATED_BY
    AND    T.CREATION_DATE = V_CREATION_DATE
    AND    T.UPLOAD_STATUS_CODE = 'ERROR';
    
    IF P_MODE > 0 AND V_COUNT = 0 THEN
        
        -------------------------------------------------------------임시테이블 생성 시작-------------------------------------------------------------
        --  @p_mode = 0 이거나 @p_mode = 1 일 때 모두 사용하기 위하여 여기에 넣었음.
        -------------------------------------------------------------임시테이블 생성 시작-------------------------------------------------------------
        VTEMPTABLE_TYPE := CASE
                               WHEN NVL(P_MODE, 0) = 0 THEN
                                'UPLOAD'
                               ELSE
                                'SUCCESS'
                           END;
        
        INSERT INTO SCM_MGR.GT_DM81_DM_YEARLY_MKT_DMD_ANALYSIS
            (EV_TP_CD, CUST_CO_CD, CAR_MDL_ID, MEASURE, PLAN_YYYYMM, CUST_GR_ID, QTY, CREATION_DATE, UPLOAD_STATUS_CODE, MESSAGE_TEXT)
            SELECT TEMP_TABLE.EV_TP_CD
                  ,TEMP_TABLE.CUST_CO_CD
                  ,TEMP_TABLE.CAR_MDL_ID
                  ,TEMP_TABLE.MEASURE
                  ,TEMP_TABLE.PLAN_YYYYMM
                  ,TEMP_TABLE.CUST_GR_ID
                  ,TEMP_TABLE.QTY
                  ,TEMP_TABLE.CREATION_DATE
                  ,TEMP_TABLE.UPLOAD_STATUS_CODE
                  ,TEMP_TABLE.MESSAGE_TEXT
            FROM   (SELECT A.EV_TP_CD
                          ,A.CUST_CO_CD
                          ,A.CAR_MDL_ID
                          ,A.MEASURE
                          ,CASE A.PLAN_YYYYMM
                               WHEN 'ATTRIBUTE6' THEN
                                B.ATTRIBUTE6
                               WHEN 'ATTRIBUTE7' THEN
                                B.ATTRIBUTE7
                               WHEN 'ATTRIBUTE8' THEN
                                B.ATTRIBUTE8
                               WHEN 'ATTRIBUTE9' THEN
                                B.ATTRIBUTE9
                               WHEN 'ATTRIBUTE10' THEN
                                B.ATTRIBUTE10
                               WHEN 'ATTRIBUTE11' THEN
                                B.ATTRIBUTE11
                               WHEN 'ATTRIBUTE12' THEN
                                B.ATTRIBUTE12
                               WHEN 'ATTRIBUTE13' THEN
                                B.ATTRIBUTE13
                               WHEN 'ATTRIBUTE14' THEN
                                B.ATTRIBUTE14
                               WHEN 'ATTRIBUTE15' THEN
                                B.ATTRIBUTE15
                               WHEN 'ATTRIBUTE16' THEN
                                B.ATTRIBUTE16
                               WHEN 'ATTRIBUTE17' THEN
                                B.ATTRIBUTE17
                               WHEN 'ATTRIBUTE18' THEN
                                B.ATTRIBUTE18
                               WHEN 'ATTRIBUTE19' THEN
                                B.ATTRIBUTE19
                               WHEN 'ATTRIBUTE20' THEN
                                B.ATTRIBUTE20
                               WHEN 'ATTRIBUTE21' THEN
                                B.ATTRIBUTE21
                               WHEN 'ATTRIBUTE22' THEN
                                B.ATTRIBUTE22
                               WHEN 'ATTRIBUTE23' THEN
                                B.ATTRIBUTE23
                               WHEN 'ATTRIBUTE24' THEN
                                B.ATTRIBUTE24
                               WHEN 'ATTRIBUTE25' THEN
                                B.ATTRIBUTE25
                               WHEN 'ATTRIBUTE26' THEN
                                B.ATTRIBUTE26
                               WHEN 'ATTRIBUTE27' THEN
                                B.ATTRIBUTE27
                               WHEN 'ATTRIBUTE28' THEN
                                B.ATTRIBUTE28
                               WHEN 'ATTRIBUTE29' THEN
                                B.ATTRIBUTE29
                               WHEN 'ATTRIBUTE30' THEN
                                B.ATTRIBUTE30
                               WHEN 'ATTRIBUTE31' THEN
                                B.ATTRIBUTE31
                               WHEN 'ATTRIBUTE32' THEN
                                B.ATTRIBUTE32
                               WHEN 'ATTRIBUTE33' THEN
                                B.ATTRIBUTE33
                               WHEN 'ATTRIBUTE34' THEN
                                B.ATTRIBUTE34
                               WHEN 'ATTRIBUTE35' THEN
                                B.ATTRIBUTE35
                               WHEN 'ATTRIBUTE36' THEN
                                B.ATTRIBUTE36
                               WHEN 'ATTRIBUTE37' THEN
                                B.ATTRIBUTE37
                               WHEN 'ATTRIBUTE38' THEN
                                B.ATTRIBUTE38
                               WHEN 'ATTRIBUTE39' THEN
                                B.ATTRIBUTE39
                               WHEN 'ATTRIBUTE40' THEN
                                B.ATTRIBUTE40
                               WHEN 'ATTRIBUTE41' THEN
                                B.ATTRIBUTE41
                               WHEN 'ATTRIBUTE42' THEN
                                B.ATTRIBUTE42
                               WHEN 'ATTRIBUTE43' THEN
                                B.ATTRIBUTE43
                               WHEN 'ATTRIBUTE44' THEN
                                B.ATTRIBUTE44
                               WHEN 'ATTRIBUTE45' THEN
                                B.ATTRIBUTE45
                               WHEN 'ATTRIBUTE46' THEN
                                B.ATTRIBUTE46
                               WHEN 'ATTRIBUTE47' THEN
                                B.ATTRIBUTE47
                               WHEN 'ATTRIBUTE48' THEN
                                B.ATTRIBUTE48
                               WHEN 'ATTRIBUTE49' THEN
                                B.ATTRIBUTE49
                               WHEN 'ATTRIBUTE50' THEN
                                B.ATTRIBUTE50
                               WHEN 'ATTRIBUTE51' THEN
                                B.ATTRIBUTE51
                               WHEN 'ATTRIBUTE52' THEN
                                B.ATTRIBUTE52
                               WHEN 'ATTRIBUTE53' THEN
                                B.ATTRIBUTE53
                               WHEN 'ATTRIBUTE54' THEN
                                B.ATTRIBUTE54
                               WHEN 'ATTRIBUTE55' THEN
                                B.ATTRIBUTE55
                               WHEN 'ATTRIBUTE56' THEN
                                B.ATTRIBUTE56
                               WHEN 'ATTRIBUTE57' THEN
                                B.ATTRIBUTE57
                               WHEN 'ATTRIBUTE58' THEN
                                B.ATTRIBUTE58
                               WHEN 'ATTRIBUTE59' THEN
                                B.ATTRIBUTE59
                               WHEN 'ATTRIBUTE60' THEN
                                B.ATTRIBUTE60
                               WHEN 'ATTRIBUTE61' THEN
                                B.ATTRIBUTE61
                               WHEN 'ATTRIBUTE62' THEN
                                B.ATTRIBUTE62
                               WHEN 'ATTRIBUTE63' THEN
                                B.ATTRIBUTE63
                               WHEN 'ATTRIBUTE64' THEN
                                B.ATTRIBUTE64
                               WHEN 'ATTRIBUTE65' THEN
                                B.ATTRIBUTE65
                           END AS PLAN_YYYYMM
                          ,A.CUST_GR_ID
                          ,A.QTY
                          ,A.CREATION_DATE
                          ,VTEMPTABLE_TYPE AS UPLOAD_STATUS_CODE
                          ,'' AS MESSAGE_TEXT
                    FROM   (SELECT ATTRIBUTE1 AS EV_TP_CD
                                  ,ATTRIBUTE3 AS CUST_CO_CD
                                  ,ATTRIBUTE4 AS CAR_MDL_ID
                                  ,ATTRIBUTE5 AS MEASURE
                                  ,UNPVT.PLAN_YYYYMM
                                  ,ATTRIBUTE2 AS CUST_GR_ID
                                  ,SUM(TO_NUMBER(NVL(QTY, '0'))) AS QTY
                                  ,CREATION_DATE
                            FROM   (SELECT X.ATTRIBUTE1
                                          ,X.ATTRIBUTE2
                                          ,X.ATTRIBUTE3
                                          ,X.ATTRIBUTE4
                                          ,X.ATTRIBUTE5 -- Type* OEM Group* Brand* Vehicle* 구분*
                                          ,X.ATTRIBUTE6
                                          ,X.ATTRIBUTE7
                                          ,X.ATTRIBUTE8
                                          ,X.ATTRIBUTE9
                                          ,X.ATTRIBUTE10
                                          ,X.ATTRIBUTE11 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE12
                                          ,X.ATTRIBUTE13
                                          ,X.ATTRIBUTE14
                                          ,X.ATTRIBUTE15
                                          ,X.ATTRIBUTE16
                                          ,X.ATTRIBUTE17 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE18
                                          ,X.ATTRIBUTE19
                                          ,X.ATTRIBUTE20
                                          ,X.ATTRIBUTE21
                                          ,X.ATTRIBUTE22
                                          ,X.ATTRIBUTE23 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE24
                                          ,X.ATTRIBUTE25
                                          ,X.ATTRIBUTE26
                                          ,X.ATTRIBUTE27
                                          ,X.ATTRIBUTE28
                                          ,X.ATTRIBUTE29 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE30
                                          ,X.ATTRIBUTE31
                                          ,X.ATTRIBUTE32
                                          ,X.ATTRIBUTE33
                                          ,X.ATTRIBUTE34
                                          ,X.ATTRIBUTE35 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE36
                                          ,X.ATTRIBUTE37
                                          ,X.ATTRIBUTE38
                                          ,X.ATTRIBUTE39
                                          ,X.ATTRIBUTE40
                                          ,X.ATTRIBUTE41 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE42
                                          ,X.ATTRIBUTE43
                                          ,X.ATTRIBUTE44
                                          ,X.ATTRIBUTE45
                                          ,X.ATTRIBUTE46
                                          ,X.ATTRIBUTE47 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE48
                                          ,X.ATTRIBUTE49
                                          ,X.ATTRIBUTE50
                                          ,X.ATTRIBUTE51
                                          ,X.ATTRIBUTE52
                                          ,X.ATTRIBUTE53 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE54
                                          ,X.ATTRIBUTE55
                                          ,X.ATTRIBUTE56
                                          ,X.ATTRIBUTE57
                                          ,X.ATTRIBUTE58
                                          ,X.ATTRIBUTE59 --PLAN_YYYYMM
                                          ,X.ATTRIBUTE60
                                          ,X.ATTRIBUTE61
                                          ,X.ATTRIBUTE62
                                          ,X.ATTRIBUTE63
                                          ,X.ATTRIBUTE64
                                          ,X.ATTRIBUTE65 --PLAN_YYYYMM
                                          ,X.CREATION_DATE
                                    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
                                    WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                                    AND    X.SHEET_NAME = V_SHEET_NAME
                                    AND    X.CREATED_BY = P_CREATED_BY
                                    AND    X.CREATION_DATE = V_CREATION_DATE
                                    AND    X.UPLOAD_STATUS_CODE = VTEMPTABLE_TYPE) T UNPIVOT(QTY FOR PLAN_YYYYMM IN(ATTRIBUTE6
                                                                                                                   ,ATTRIBUTE7
                                                                                                                   ,ATTRIBUTE8
                                                                                                                   ,ATTRIBUTE9
                                                                                                                   ,ATTRIBUTE10
                                                                                                                   ,ATTRIBUTE11 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE12
                                                                                                                   ,ATTRIBUTE13
                                                                                                                   ,ATTRIBUTE14
                                                                                                                   ,ATTRIBUTE15
                                                                                                                   ,ATTRIBUTE16
                                                                                                                   ,ATTRIBUTE17 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE18
                                                                                                                   ,ATTRIBUTE19
                                                                                                                   ,ATTRIBUTE20
                                                                                                                   ,ATTRIBUTE21
                                                                                                                   ,ATTRIBUTE22
                                                                                                                   ,ATTRIBUTE23 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE24
                                                                                                                   ,ATTRIBUTE25
                                                                                                                   ,ATTRIBUTE26
                                                                                                                   ,ATTRIBUTE27
                                                                                                                   ,ATTRIBUTE28
                                                                                                                   ,ATTRIBUTE29 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE30
                                                                                                                   ,ATTRIBUTE31
                                                                                                                   ,ATTRIBUTE32
                                                                                                                   ,ATTRIBUTE33
                                                                                                                   ,ATTRIBUTE34
                                                                                                                   ,ATTRIBUTE35 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE36
                                                                                                                   ,ATTRIBUTE37
                                                                                                                   ,ATTRIBUTE38
                                                                                                                   ,ATTRIBUTE39
                                                                                                                   ,ATTRIBUTE40
                                                                                                                   ,ATTRIBUTE41 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE42
                                                                                                                   ,ATTRIBUTE43
                                                                                                                   ,ATTRIBUTE44
                                                                                                                   ,ATTRIBUTE45
                                                                                                                   ,ATTRIBUTE46
                                                                                                                   ,ATTRIBUTE47 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE48
                                                                                                                   ,ATTRIBUTE49
                                                                                                                   ,ATTRIBUTE50
                                                                                                                   ,ATTRIBUTE51
                                                                                                                   ,ATTRIBUTE52
                                                                                                                   ,ATTRIBUTE53 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE54
                                                                                                                   ,ATTRIBUTE55
                                                                                                                   ,ATTRIBUTE56
                                                                                                                   ,ATTRIBUTE57
                                                                                                                   ,ATTRIBUTE58
                                                                                                                   ,ATTRIBUTE59 --PLAN_YYYYMM
                                                                                                                   ,ATTRIBUTE60
                                                                                                                   ,ATTRIBUTE61
                                                                                                                   ,ATTRIBUTE62
                                                                                                                   ,ATTRIBUTE63
                                                                                                                   ,ATTRIBUTE64
                                                                                                                   ,ATTRIBUTE65 --PLAN_YYYYMM
                                                                                                                    )) UNPVT
                            GROUP  BY CREATION_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, PLAN_YYYYMM) A
                    INNER  JOIN (SELECT *
                                FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
                                WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                                AND    X.SHEET_NAME = V_SHEET_NAME
                                AND    X.CREATED_BY = P_CREATED_BY
                                AND    X.CREATION_DATE = V_CREATION_DATE
                                AND    X.UPLOAD_STATUS_CODE = '@TITLE') B
                    ON     A.CREATION_DATE = B.CREATION_DATE) TEMP_TABLE
            ORDER  BY TEMP_TABLE.EV_TP_CD, TEMP_TABLE.CUST_CO_CD, TEMP_TABLE.CAR_MDL_ID, TEMP_TABLE.PLAN_YYYYMM, TEMP_TABLE.MEASURE;
        -------------------------------------------------------------임시테이블 생성 종료-------------------------------------------------------------
        -------------------------------------------------------------임시테이블 생성 종료-------------------------------------------------------------
        
        -- GTT를 DM_YEARLY_MKT_DMD_ANALYSIS와 JOIN/DELETE에 사용하므로 통계 수집
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM81_DM_YEARLY_MKT_DMD_ANALYSIS', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'SCM_MGR'
                                     ,TABNAME          => 'GT_DM81_DM_YEARLY_MKT_DMD_ANALYSIS'
                                     ,ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
                                     ,METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1');
        
        -- @p_mode = 0 이면 Validation Check (2. 임시테이블 이용하여 Validation Check 수행)
        -- Update Mode and No Errors - 기존 데이터가 있다면 DELETE 후 INSERT
        
        ----------------------------------------------------------------------------
        V_LOG_TYPE    := '17';
        V_LOG_MESSAGE := '########## INSERT DATA START ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
        V_START_YYYYMMDD := '';
        V_END_YYYYMMDD   := '';
        
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '18';
        V_LOG_MESSAGE := '########## DELETE DATE START ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
        --기존 데이터 범위를 파악하기 위한 쿼리
        SELECT D.MIN_YYYYMM, D.MAX_YYYYMM
        INTO   V_START_YYYYMMDD, V_END_YYYYMMDD
        FROM   (SELECT MIN(YYYYMM) AS MIN_YYYYMM, MAX(YYYYMM) AS MAX_YYYYMM
                FROM   (SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,ATTRIBUTE14
                              ,ATTRIBUTE15
                              ,ATTRIBUTE16
                              ,ATTRIBUTE17
                              ,ATTRIBUTE18
                              ,ATTRIBUTE19
                              ,ATTRIBUTE20
                              ,ATTRIBUTE21
                              ,ATTRIBUTE22
                              ,ATTRIBUTE23
                              ,ATTRIBUTE24
                              ,ATTRIBUTE25
                              ,ATTRIBUTE26
                              ,ATTRIBUTE27
                              ,ATTRIBUTE28
                              ,ATTRIBUTE29
                              ,ATTRIBUTE30
                              ,ATTRIBUTE31
                              ,ATTRIBUTE32
                              ,ATTRIBUTE33
                              ,ATTRIBUTE34
                              ,ATTRIBUTE35
                              ,ATTRIBUTE36
                              ,ATTRIBUTE37
                              ,ATTRIBUTE38
                              ,ATTRIBUTE39
                              ,ATTRIBUTE40
                              ,ATTRIBUTE41
                              ,ATTRIBUTE42
                              ,ATTRIBUTE43
                              ,ATTRIBUTE44
                              ,ATTRIBUTE45
                              ,ATTRIBUTE46
                              ,ATTRIBUTE47
                              ,ATTRIBUTE48
                              ,ATTRIBUTE49
                              ,ATTRIBUTE50
                              ,ATTRIBUTE51
                              ,ATTRIBUTE52
                              ,ATTRIBUTE53
                              ,ATTRIBUTE54
                              ,ATTRIBUTE55
                              ,ATTRIBUTE56
                              ,ATTRIBUTE57
                              ,ATTRIBUTE58
                              ,ATTRIBUTE59
                              ,ATTRIBUTE60
                              ,ATTRIBUTE61
                              ,ATTRIBUTE62
                              ,ATTRIBUTE63
                              ,ATTRIBUTE64
                              ,ATTRIBUTE65
                        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                        WHERE  1 = 1
                        AND    PROGRAM_ID = V_PROGRAM_ID
                        AND    SHEET_NAME = V_SHEET_NAME
                        AND    CREATED_BY = P_CREATED_BY
                        AND    CREATION_DATE = V_CREATION_DATE
                        AND    UPLOAD_STATUS_CODE = '@TITLE') T UNPIVOT(YYYYMM FOR COLUMN_NAME IN(
                                                                                                  --구분 이후에 있는 60개월 데이터 (월별 데이터 yyyymm)
                                                                                                  ATTRIBUTE6
                                                                                                 ,ATTRIBUTE7
                                                                                                 ,ATTRIBUTE8
                                                                                                 ,ATTRIBUTE9
                                                                                                 ,ATTRIBUTE10
                                                                                                 ,ATTRIBUTE11
                                                                                                 ,ATTRIBUTE12
                                                                                                 ,ATTRIBUTE13
                                                                                                 ,ATTRIBUTE14
                                                                                                 ,ATTRIBUTE15
                                                                                                 ,ATTRIBUTE16
                                                                                                 ,ATTRIBUTE17
                                                                                                 ,ATTRIBUTE18
                                                                                                 ,ATTRIBUTE19
                                                                                                 ,ATTRIBUTE20
                                                                                                 ,ATTRIBUTE21
                                                                                                 ,ATTRIBUTE22
                                                                                                 ,ATTRIBUTE23
                                                                                                 ,ATTRIBUTE24
                                                                                                 ,ATTRIBUTE25
                                                                                                 ,ATTRIBUTE26
                                                                                                 ,ATTRIBUTE27
                                                                                                 ,ATTRIBUTE28
                                                                                                 ,ATTRIBUTE29
                                                                                                 ,ATTRIBUTE30
                                                                                                 ,ATTRIBUTE31
                                                                                                 ,ATTRIBUTE32
                                                                                                 ,ATTRIBUTE33
                                                                                                 ,ATTRIBUTE34
                                                                                                 ,ATTRIBUTE35
                                                                                                 ,ATTRIBUTE36
                                                                                                 ,ATTRIBUTE37
                                                                                                 ,ATTRIBUTE38
                                                                                                 ,ATTRIBUTE39
                                                                                                 ,ATTRIBUTE40
                                                                                                 ,ATTRIBUTE41
                                                                                                 ,ATTRIBUTE42
                                                                                                 ,ATTRIBUTE43
                                                                                                 ,ATTRIBUTE44
                                                                                                 ,ATTRIBUTE45
                                                                                                 ,ATTRIBUTE46
                                                                                                 ,ATTRIBUTE47
                                                                                                 ,ATTRIBUTE48
                                                                                                 ,ATTRIBUTE49
                                                                                                 ,ATTRIBUTE50
                                                                                                 ,ATTRIBUTE51
                                                                                                 ,ATTRIBUTE52
                                                                                                 ,ATTRIBUTE53
                                                                                                 ,ATTRIBUTE54
                                                                                                 ,ATTRIBUTE55
                                                                                                 ,ATTRIBUTE56
                                                                                                 ,ATTRIBUTE57
                                                                                                 ,ATTRIBUTE58
                                                                                                 ,ATTRIBUTE59
                                                                                                 ,ATTRIBUTE60
                                                                                                 ,ATTRIBUTE61
                                                                                                 ,ATTRIBUTE62
                                                                                                 ,ATTRIBUTE63
                                                                                                 ,ATTRIBUTE64
                                                                                                 ,ATTRIBUTE65)) X
                WHERE  X.YYYYMM != '') D;
        
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '19-1';
        V_LOG_MESSAGE := '########## DELETE DATE END ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '20-1';
        V_LOG_MESSAGE := '########## DELETE DM_YEARLY_MKT_DMD_ANALYSIS DATE END ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
        --기존 데이터 삭제
        -- delete 주석
        -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
        DELETE SCM_MGR.DM_YEARLY_MKT_DMD_ANALYSIS M
        WHERE  EXISTS (SELECT 1
                FROM   SCM_MGR.GT_DM81_DM_YEARLY_MKT_DMD_ANALYSIS T
                WHERE  T.CREATION_DATE = V_CREATION_DATE
                AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
                AND    M.EV_TP_CD = T.EV_TP_CD
                AND    M.CUST_CO_CD = T.CUST_CO_CD
                AND    M.CAR_MDL_ID = T.CAR_MDL_ID
                AND    M.MEASURE = T.MEASURE
                AND    M.PLAN_YYYYMM = T.PLAN_YYYYMM)
        AND    M.PLAN_YYYYMM BETWEEN V_START_YYYYMMDD AND V_END_YYYYMMDD;
        
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '20';
        V_LOG_MESSAGE := '########## DELETE DM_ANL_CAR_FCST_REF DATE END ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
        --신규 데이터 INSERT
        INSERT INTO SCM_MGR.DM_YEARLY_MKT_DMD_ANALYSIS
            (EV_TP_CD, CUST_CO_CD, CAR_MDL_ID, MEASURE, PLAN_YYYYMM, CUST_GR_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
            SELECT T.EV_TP_CD
                  ,T.CUST_CO_CD
                  ,T.CAR_MDL_ID
                  ,T.MEASURE
                  ,T.PLAN_YYYYMM
                  ,T.CUST_GR_ID
                  ,T.QTY
                  ,P_CREATED_BY
                  ,V_CREATION_DATE
                  ,P_CREATED_BY
                  ,V_CREATION_DATE
            FROM   SCM_MGR.GT_DM81_DM_YEARLY_MKT_DMD_ANALYSIS T
            WHERE  T.UPLOAD_STATUS_CODE = 'SUCCESS'
            ORDER  BY T.EV_TP_CD, T.CUST_CO_CD, T.CAR_MDL_ID, T.MEASURE, T.PLAN_YYYYMM;
        
        N_LOG_COUNT := SQL%ROWCOUNT;
        
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '21';
        V_LOG_MESSAGE := '########## INSERT DM_YEARLY_MKT_DMD_ANALYSIS DATE END ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
        ----------------------------------------------------------------------------
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## INSERT DATA END ##########';
        V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;
        ----------------------------------------------------------------------------
        
    END IF;
    
    -- COMMIT은 프로시저 종료 직전에 1회만 수행
    COMMIT;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_MODE' VALUE P_MODE, 'P_CREATED_BY' VALUE P_CREATED_BY);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                        ,V_LOG_TYPE
                                        ,N_LOG_COUNT
                                        ,V_LOG_MESSAGE
                                        ,V_DESCRIPTION
                                        ,D_EVENT_DATE
                                        ,V_PROC_INPUT
                                        ,V_SQL_CODE
                                        ,V_SQL_ERRMSG
                                        ,V_BACKTRACE);
        END;
        
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        
END P_DMF0081_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD;

PROCEDURE P_DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP
(
    P_DIVISION_ID   IN VARCHAR2
   ,P_END_CUSTOMER  IN VARCHAR2
   ,P_PROJECT_CODE  IN VARCHAR2
   ,P_MEASURE       IN VARCHAR2
   ,P_YYYYMM        IN VARCHAR2
   ,P_CREATED_BY    IN VARCHAR2
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*===================================================================================================
* Program ID  : [DMF0081_GET_CUST_DEMAND_ANL_DETAIL]
* Author:    <Author,,Name>
* Create date: <Create Date,,>
* Description  : 고객수요증감 팝업 조회
* Program History
*===================================================================================================
*   Date       In Charge      Description
*===================================================================================================
* 2024.11.05   dsiol      1개의 ROW씩 INSERT 한다. (여러번 실행 되는 프로시저)
* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
*===================================================================================================*/
AS
    -- LOG 변수
    V_LOG_TYPE     VARCHAR2(100 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_DESCRIPTION  VARCHAR2(4000 CHAR);
    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    -- EXCEPTION 변수
    V_PROC_INPUT VARCHAR2(4000 CHAR);
    V_BACKTRACE  VARCHAR2(4000 CHAR);
    V_SQL_CODE   VARCHAR2(100 CHAR);
    V_SQL_ERRMSG VARCHAR2(1000 CHAR);
BEGIN
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    
    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    
    OPEN O_RC1 FOR
        SELECT DTL.DIVISION_ID -- Visible False
              ,DTL.END_CUSTOMER -- Visible False
              ,DTL.PROJECT_CODE -- Visible False
              ,DTL.MEASURE -- Visible False
              ,DTL.PLAN_YYYYMM -- Visible False
              ,0 AS EDI_QTY
              ,DTL.QTY AS CHANGE_QTY
              ,(SELECT DISTINCT LK.ATTRIBUTE1
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LK
                WHERE  LK.LOOKUP_TYPE = 'DM_DEMAND_GAP_ANL_CD'
                AND    LK.VALID_YN = 'Y'
                AND    LK.SEGMENT1 = DTL.REQ_RSN_CD) AS REQ_RSN_CD
              ,(SELECT DISTINCT LK.ATTRIBUTE2
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LK
                WHERE  LK.LOOKUP_TYPE = 'DM_DEMAND_GAP_ANL_CD'
                AND    LK.VALID_YN = 'Y'
                AND    LK.SEGMENT2 = DTL.DIF_ANLS_TP_CD) AS DIF_ANLS_TP_CD
              ,(SELECT DISTINCT LK.ATTRIBUTE3
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LK
                WHERE  LK.LOOKUP_TYPE = 'DM_DEMAND_GAP_ANL_CD'
                AND    LK.VALID_YN = 'Y'
                AND    LK.SEGMENT3 = DTL.ANLS_DIF_RSN_CD) AS ANLS_DIF_RSN_CD
              ,DTL.REQ_RSN_DTL_CTN
              ,0 AS RESULT
              ,0 AS MKT_DP
              ,0 AS GAP
              ,EDY.EDIT_YN
        FROM   SCM_MGR.DM_CUST_DEMAND_ANL_DETAIL DTL
        INNER  JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
        ON     EDY.USER_ID = P_USER_ID
        AND    EDY.MNU_ID = P_MENU_ID
        AND    EDY.UNIT_ID = DTL.DIVISION_ID
        WHERE  DTL.DIVISION_ID = P_DIVISION_ID
        AND    DTL.END_CUSTOMER = P_END_CUSTOMER
        AND    DTL.PROJECT_CODE = P_PROJECT_CODE
        AND    DTL.MEASURE = P_MEASURE
        AND    DTL.PLAN_YYYYMM = P_YYYYMM
        ORDER  BY DTL.CREATION_DATE;
    --ORDER BY DTL.REQ_RSN_CD,DTL.DIF_ANLS_TP_CD,DTL.ANLS_DIF_RSN_CD
    
    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_DIVISION_ID' VALUE P_DIVISION_ID
                                    ,'P_END_CUSTOMER' VALUE P_END_CUSTOMER
                                    ,'P_PROJECT_CODE' VALUE P_PROJECT_CODE
                                    ,'P_MEASURE' VALUE P_MEASURE
                                    ,'P_YYYYMM' VALUE P_YYYYMM
                                    ,'P_CREATED_BY' VALUE P_CREATED_BY);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                        ,V_LOG_TYPE
                                        ,N_LOG_COUNT
                                        ,V_LOG_MESSAGE
                                        ,V_DESCRIPTION
                                        ,D_EVENT_DATE
                                        ,V_PROC_INPUT
                                        ,V_SQL_CODE
                                        ,V_SQL_ERRMSG
                                        ,V_BACKTRACE);
        END;
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        RAISE;
        
END P_DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP;

PROCEDURE P_DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD
(
    P_EV_TP_CD      IN VARCHAR2
   ,P_CUST_CO_CD    IN VARCHAR2
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RC2           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
-- =============================================
-- Author:    <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- EXEC [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD] '', ''     -- 최초 컨트롤 초기화
-- EXEC [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD] 'PHEV', '' -- Type가 선택 되었을 때
-- EXEC [dbo].[DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD] 'PHEV', 'BMW' -- Type 와 제조사가 둘다 선택 되었을 때
/* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 */
-- =============================================
AS
    -- LOG 변수
    V_LOG_TYPE     VARCHAR2(100 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_DESCRIPTION  VARCHAR2(4000 CHAR);
    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
    -- EXCEPTION 변수
    V_PROC_INPUT VARCHAR2(4000 CHAR);
    V_BACKTRACE  VARCHAR2(4000 CHAR);
    V_SQL_CODE   VARCHAR2(100 CHAR);
    V_SQL_ERRMSG VARCHAR2(1000 CHAR);
BEGIN
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    
    -- 최초 컨트롤 초기화
    IF LENGTH(TRIM(P_EV_TP_CD)) = 0 OR TRIM(P_EV_TP_CD) IS NULL THEN
        
        -- TYPE
        OPEN O_RC1 FOR
            SELECT DISTINCT EV_TP_CD AS CODE, EV_TP_CD AS NAME FROM DM_YEARLY_MKT_DMD_ANALYSIS ORDER BY EV_TP_CD;
        
        -- BIZ TYPE
        OPEN O_RC2 FOR
            SELECT 'CELL' AS CODE, 'CELL' AS NAME
            FROM   DUAL
            UNION ALL
            SELECT 'MODULE' AS CODE, 'MODULE' AS NAME
            FROM   DUAL
            UNION ALL
            SELECT 'PACK' AS CODE, 'PACK' AS NAME
            FROM   DUAL;
        
        -- Type가 선택 되었을 때
    ELSIF LENGTH(TRIM(P_EV_TP_CD)) > 0 AND (LENGTH(TRIM(P_CUST_CO_CD)) = 0 OR TRIM(P_CUST_CO_CD) IS NULL) THEN
        
        -- 제조사
        OPEN O_RC1 FOR
            SELECT DISTINCT CUST_CO_CD AS CODE, CUST_CO_CD AS NAME FROM DM_YEARLY_MKT_DMD_ANALYSIS WHERE EV_TP_CD = P_EV_TP_CD ORDER BY CUST_CO_CD;
        
        -- 모델명
        OPEN O_RC2 FOR
            SELECT DISTINCT CAR_MDL_ID AS CODE, CAR_MDL_ID AS NAME
            FROM   DM_YEARLY_MKT_DMD_ANALYSIS
            WHERE  EV_TP_CD = P_EV_TP_CD
            AND    CUST_CO_CD = (SELECT CUST_CO_CD
                                 FROM   (SELECT CUST_CO_CD FROM DM_YEARLY_MKT_DMD_ANALYSIS WHERE EV_TP_CD = P_EV_TP_CD ORDER BY CUST_CO_CD)
                                 WHERE  ROWNUM = 1) --제조사의 제일 위 데이터를 자동으로 선택한다.
            ORDER  BY CAR_MDL_ID;
        
        -- Type 와 제조사가 둘다 선택 되었을 때
    ELSIF LENGTH(TRIM(P_EV_TP_CD)) > 0 AND LENGTH(TRIM(P_CUST_CO_CD)) > 0 THEN
        
        -- 모델명
        OPEN O_RC1 FOR
            SELECT DISTINCT CAR_MDL_ID AS CODE, CAR_MDL_ID AS NAME
            FROM   DM_YEARLY_MKT_DMD_ANALYSIS
            WHERE  EV_TP_CD = P_EV_TP_CD
            AND    CUST_CO_CD = P_CUST_CO_CD
            ORDER  BY CAR_MDL_ID;
        
    END IF;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_EV_TP_CD' VALUE P_EV_TP_CD, 'P_CUST_CO_CD' VALUE P_CUST_CO_CD);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                        ,V_LOG_TYPE
                                        ,N_LOG_COUNT
                                        ,V_LOG_MESSAGE
                                        ,V_DESCRIPTION
                                        ,D_EVENT_DATE
                                        ,V_PROC_INPUT
                                        ,V_SQL_CODE
                                        ,V_SQL_ERRMSG
                                        ,V_BACKTRACE);
        END;
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        
END P_DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD;

PROCEDURE P_DMF0081_GET_DM_ANL_MKT_PSI_DATA
(
    P_DIVISION_ID   IN VARCHAR2
   ,P_END_CUSTOMER  IN VARCHAR2
   ,P_PROJECT_CODE  IN VARCHAR2
   ,P_USER_ID       IN VARCHAR2
   ,P_MENU_ID       IN VARCHAR2
   ,O_RC1           OUT SYS_REFCURSOR
   ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*===================================================================================================
* Program ID  : [DMF0081_GET_DM_ANL_MKT_PSI_DATA]
* Description  : 고객수요증감분석 PSI 조회
* Program History
*===================================================================================================
*   Date       In Charge      Description
*===================================================================================================
* 2024.10.21     dsiol       
* 2024.11.29     Philsu Park    Simulation Impact 계산 시 반올림 조건 추가. Cust.Fcst * ROUND(Avg.Impact, 5)
* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선  
* EXEC DMF0081_GET_DM_ANL_MKT_PSI_DATA '81','Ampere Electricity','A16RT4003'
*===================================================================================================*/
AS
    -- 날짜 변수
    V_YYYYMM1 VARCHAR2(6 CHAR); -- ex) 202212 --24개월전
    V_YYYYMM2 VARCHAR2(6 CHAR); -- ex) 202412 --이번달
    V_YYYYMM3 VARCHAR2(6 CHAR); -- ex) 202411 --직전달
    V_YYYYMM4 VARCHAR2(6 CHAR); -- ex) 202312 --12개월전
    
    -- EXCEPTION 처리용 변수
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_BACKTRACE    VARCHAR2(4000 CHAR);
    V_SQL_CODE     VARCHAR2(100 CHAR);
    V_SQL_ERRMSG   VARCHAR2(1000 CHAR);
    V_LOG_TYPE     VARCHAR2(100 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_DESCRIPTION  VARCHAR2(4000 CHAR);
    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
BEGIN
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    
    -- 날짜 초기화
    -- ex) 202212 --24개월전
    V_YYYYMM1 := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -24), 'YYYYMM');
    -- ex) 202412 --이번달
    V_YYYYMM2 := TO_CHAR(SYSDATE, 'YYYYMM');
    -- ex) 202411 --직전달
    V_YYYYMM3 := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMM');
    -- ex) 202312 --12개월전
    V_YYYYMM4 := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12), 'YYYYMM');
    
    -- GTT 초기화 (이전 일반 테이블 DML 없음 → TRUNCATE 허용)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM81_PSI_T1_RAW';
    
    -- 테이블중복제거 후 GTT 적재
    INSERT INTO GT_DM81_PSI_T1_RAW
        SELECT S.DIVISION_ID
              ,S.END_CUSTOMER
              ,S.PROJECT_NAME
              ,S.PROJECT_CODE
              ,S.MEASURE
              ,S.PLAN_YYYYMM
              ,MAX(NVL(S.CUST_FCST_QTY, 0)) AS CUST_FCST_QTY
              ,MAX(NVL(S.MKT_FCST_QTY, 0)) AS MKT_FCST_QTY
              ,MAX(NVL(S.M1_CUST_FCST_QTY, 0)) AS M1_CUST_FCST_QTY
              ,MAX(NVL(S.M1_MKT_FCST_QTY, 0)) AS M1_MKT_FCST_QTY
              ,MAX(NVL(S.M2_CUST_FCST_QTY, 0)) AS M2_CUST_FCST_QTY
              ,MAX(NVL(S.M2_MKT_FCST_QTY, 0)) AS M2_MKT_FCST_QTY
              ,MAX(NVL(S.M3_CUST_FCST_QTY, 0)) AS M3_CUST_FCST_QTY
              ,MAX(NVL(S.M3_MKT_FCST_QTY, 0)) AS M3_MKT_FCST_QTY
              ,SUM(FLOOR(NVL(DTL.QTY, 0))) AS TOTAL_QTY
              ,SUM(CASE
                       WHEN DTL.ANLS_DIF_RSN_CD = 'CAR_PROD' THEN
                        FLOOR(DTL.QTY)
                       ELSE
                        0
                   END) AS CAR_PROD_DTL_QTY
              ,SUM(CASE
                       WHEN DTL.ANLS_DIF_RSN_CD = 'CAR_SALES' THEN
                        FLOOR(DTL.QTY)
                       ELSE
                        0
                   END) AS CAR_SALES_DTL_QTY
              ,SUM(CASE
                       WHEN DTL.ANLS_DIF_RSN_CD = 'DELIVERY' THEN
                        FLOOR(DTL.QTY)
                       ELSE
                        0
                   END) AS DELIVERY_DTL_QTY
              ,SUM(CASE
                       WHEN DTL.ANLS_DIF_RSN_CD = 'SALES_ALLOC' THEN
                        FLOOR(DTL.QTY)
                       ELSE
                        0
                   END) AS SALES_ALLOC_DTL_QTY
              ,SUM(CASE
                       WHEN DTL.ANLS_DIF_RSN_CD = 'MODEL_MIX' THEN
                        FLOOR(DTL.QTY)
                       ELSE
                        0
                   END) AS MODEL_MIX_DTL_QTY
              ,SUM(CASE
                       WHEN DTL.ANLS_DIF_RSN_CD = 'SUPPLY' THEN
                        FLOOR(DTL.QTY)
                       ELSE
                        0
                   END) AS SUPPLY_DTL_QTY
              ,(SELECT SUM(NVL(SS.CUST_FCST_QTY, 0))
                FROM   DM_CUST_DEMAND_ANL_SUMMARY SS
                WHERE  SS.DIVISION_ID = S.DIVISION_ID
                AND    SS.END_CUSTOMER = S.END_CUSTOMER
                AND    SS.PROJECT_CODE = S.PROJECT_CODE
                AND    SS.MEASURE = S.MEASURE
                AND    SS.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                       TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) AS MON_03_CUST_FCST_ACCUM_QTY
              ,(SELECT SUM(NVL(SS.MKT_FCST_QTY, 0))
                FROM   DM_CUST_DEMAND_ANL_SUMMARY SS
                WHERE  SS.DIVISION_ID = S.DIVISION_ID
                AND    SS.END_CUSTOMER = S.END_CUSTOMER
                AND    SS.PROJECT_CODE = S.PROJECT_CODE
                AND    SS.MEASURE = S.MEASURE
                AND    SS.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                       TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) AS MON_03_MKT_FCST_ACCUM_QTY
              ,(SELECT SUM(NVL(SS.CUST_FCST_QTY, 0))
                FROM   DM_CUST_DEMAND_ANL_SUMMARY SS
                WHERE  SS.DIVISION_ID = S.DIVISION_ID
                AND    SS.END_CUSTOMER = S.END_CUSTOMER
                AND    SS.PROJECT_CODE = S.PROJECT_CODE
                AND    SS.MEASURE = S.MEASURE
                AND    SS.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                       TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) AS MON_06_CUST_FCST_ACCUM_QTY
              ,(SELECT SUM(NVL(SS.MKT_FCST_QTY, 0))
                FROM   DM_CUST_DEMAND_ANL_SUMMARY SS
                WHERE  SS.DIVISION_ID = S.DIVISION_ID
                AND    SS.END_CUSTOMER = S.END_CUSTOMER
                AND    SS.PROJECT_CODE = S.PROJECT_CODE
                AND    SS.MEASURE = S.MEASURE
                AND    SS.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                       TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) AS MON_06_MKT_FCST_ACCUM_QTY
              ,(SELECT SUM(NVL(SS.CUST_FCST_QTY, 0))
                FROM   DM_CUST_DEMAND_ANL_SUMMARY SS
                WHERE  SS.DIVISION_ID = S.DIVISION_ID
                AND    SS.END_CUSTOMER = S.END_CUSTOMER
                AND    SS.PROJECT_CODE = S.PROJECT_CODE
                AND    SS.MEASURE = S.MEASURE
                AND    SS.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                       TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) AS MON_12_CUST_FCST_ACCUM_QTY
              ,(SELECT SUM(NVL(SS.MKT_FCST_QTY, 0))
                FROM   DM_CUST_DEMAND_ANL_SUMMARY SS
                WHERE  SS.DIVISION_ID = S.DIVISION_ID
                AND    SS.END_CUSTOMER = S.END_CUSTOMER
                AND    SS.PROJECT_CODE = S.PROJECT_CODE
                AND    SS.MEASURE = S.MEASURE
                AND    SS.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                       TO_CHAR(ADD_MONTHS(TO_DATE(S.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) AS MON_12_MKT_FCST_ACCUM_QTY
              ,ROW_NUMBER() OVER(PARTITION BY S.DIVISION_ID, S.END_CUSTOMER, S.PROJECT_CODE, S.MEASURE ORDER BY S.PLAN_YYYYMM DESC) AS PLAN_YYYYMM_RANK
        FROM   DM_CUST_DEMAND_ANL_SUMMARY S
        LEFT   OUTER JOIN DM_CUST_DEMAND_ANL_DETAIL DTL
        ON     S.DIVISION_ID = DTL.DIVISION_ID
        AND    S.END_CUSTOMER = DTL.END_CUSTOMER
        AND    S.PROJECT_CODE = DTL.PROJECT_CODE
        AND    S.MEASURE = DTL.MEASURE
        AND    S.PLAN_YYYYMM = DTL.PLAN_YYYYMM
        --[운영]
        WHERE  S.DIVISION_ID = P_DIVISION_ID
        AND    S.END_CUSTOMER = P_END_CUSTOMER
        AND    S.PROJECT_CODE = P_PROJECT_CODE
        AND    S.PLAN_YYYYMM BETWEEN V_YYYYMM1 AND V_YYYYMM2
        GROUP  BY S.DIVISION_ID, S.END_CUSTOMER, S.PROJECT_NAME, S.PROJECT_CODE, S.MEASURE, S.PLAN_YYYYMM;
    
    -- GTT를 JOIN에 사용하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM81_PSI_T1_RAW', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'SCM_MGR'
                                 ,TABNAME          => 'GT_DM81_PSI_T1_RAW'
                                 ,ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
                                 ,METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1');
    
    -- 최종 결과 반환
    OPEN O_RC1 FOR
        WITH W_T1 AS
         (SELECT 1 AS SEQ
                ,'NOTTHING' AS POPUP_STATUS
                ,T1.DIVISION_ID
                ,T1.END_CUSTOMER
                ,T1.PROJECT_NAME
                ,T1.PROJECT_CODE
                ,T1.PLAN_YYYYMM
                ,T1.CUST_FCST_QTY AS EDI_QTY
                ,'Average Impact(%)' AS MEASURE
                ,M1_CUST_FCST_QTY AS M1_CUST_FCST_QTY
                ,M1_MKT_FCST_QTY AS M1_MKT_FCST_QTY
                ,M2_CUST_FCST_QTY AS M2_CUST_FCST_QTY
                ,M2_MKT_FCST_QTY AS M2_MKT_FCST_QTY
                ,M3_CUST_FCST_QTY AS M3_CUST_FCST_QTY
                ,M3_MKT_FCST_QTY AS M3_MKT_FCST_QTY
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((T1.MON_03_MKT_FCST_ACCUM_QTY / T1.MON_03_CUST_FCST_ACCUM_QTY) - 1) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_SUM
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((T1.MON_06_MKT_FCST_ACCUM_QTY / T1.MON_06_CUST_FCST_ACCUM_QTY) - 1) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_SUM
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((T1.MON_12_MKT_FCST_ACCUM_QTY / T1.MON_12_CUST_FCST_ACCUM_QTY) - 1) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_SUM
                ,NULL AS SIMULATION_03_SUM
                ,NULL AS SIMULATION_06_SUM
                ,NULL AS SIMULATION_12_SUM
                ,NULL AS DEMAND_SUM
                 -----
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.CAR_PROD_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_03_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_CUSTOMER_DEMAND_CAR_PROD
                 -----
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.CAR_PROD_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_06_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_CUSTOMER_DEMAND_CAR_PROD
                 -----
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.CAR_PROD_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_12_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD
                 -----
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.CAR_SALES_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_03_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_CUSTOMER_DEMAND_CAR_SALES
                 -----
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.CAR_SALES_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_06_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_CUSTOMER_DEMAND_CAR_SALES
                 -----
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.CAR_SALES_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_12_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES
                 -----
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.DELIVERY_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_03_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_CUSTOMER_DEMAND_DELIVERY
                 -----
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.DELIVERY_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_06_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_CUSTOMER_DEMAND_DELIVERY
                 -----
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.DELIVERY_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_12_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_CUSTOMER_DEMAND_DELIVERY
                 -----
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.MODEL_MIX_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_03_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_CUSTOMER_LGES_OPERATION_MODEL_MIX
                 -----
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.MODEL_MIX_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_06_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_CUSTOMER_LGES_OPERATION_MODEL_MIX
                 -----
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.MODEL_MIX_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_12_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX
                 -----
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.SALES_ALLOC_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_03_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                 -----
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.SALES_ALLOC_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_06_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                 -----
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.SALES_ALLOC_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_12_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                 -----
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.SUPPLY_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -3), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_03_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_03_CUSTOMER_LGES_SUPPLY_SUPPLY
                 -----
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.SUPPLY_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -6), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_06_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_06_CUSTOMER_LGES_SUPPLY_SUPPLY
                 -----
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      ((SELECT SUM(T1_SUB.SUPPLY_DTL_QTY)
                        FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1_SUB
                        WHERE  T1_SUB.PLAN_YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -12), 'YYYYMM') AND
                               TO_CHAR(ADD_MONTHS(TO_DATE(T1.PLAN_YYYYMM, 'YYYYMM'), -1), 'YYYYMM')) / T1.MON_12_CUST_FCST_ACCUM_QTY) * 100
                     ELSE
                      0
                 END AS AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY
                 -----
                ,NULL                AS SIMULATION_03_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_06_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_12_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_03_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_06_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_12_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_03_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_06_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_12_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_03_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_06_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_12_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_03_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_06_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_12_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_03_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_06_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS SIMULATION_12_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS RESULT
                ,NULL                AS MKT_DP
                ,NULL                AS GAP
                ,T1.PLAN_YYYYMM_RANK
          FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1
          WHERE  T1.MEASURE = 'MKT_FCST_FNL'),
        W_T2 AS
         (SELECT 2 AS SEQ
                ,'NOTTHING' AS POPUP_STATUS
                ,T1.DIVISION_ID
                ,T1.END_CUSTOMER
                ,T1.PROJECT_NAME
                ,T1.PROJECT_CODE
                ,T1.PLAN_YYYYMM
                ,T1.CUST_FCST_QTY AS EDI_QTY
                ,'Simulation Impact' AS MEASURE
                ,M1_CUST_FCST_QTY AS M1_CUST_FCST_QTY
                ,M1_MKT_FCST_QTY AS M1_MKT_FCST_QTY
                ,M2_CUST_FCST_QTY AS M2_CUST_FCST_QTY
                ,M2_MKT_FCST_QTY AS M2_MKT_FCST_QTY
                ,M3_CUST_FCST_QTY AS M3_CUST_FCST_QTY
                ,M3_MKT_FCST_QTY AS M3_MKT_FCST_QTY
                ,NULL AS AVERAGE_03_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,CASE
                     WHEN T1.MON_03_CUST_FCST_ACCUM_QTY > 0 THEN
                      T1.CUST_FCST_QTY * ((T1.MON_03_MKT_FCST_ACCUM_QTY / T1.MON_03_CUST_FCST_ACCUM_QTY) - 1)
                     ELSE
                      0
                 END AS SIMULATION_03_SUM
                ,CASE
                     WHEN T1.MON_06_CUST_FCST_ACCUM_QTY > 0 THEN
                      T1.CUST_FCST_QTY * ((T1.MON_06_MKT_FCST_ACCUM_QTY / T1.MON_06_CUST_FCST_ACCUM_QTY) - 1)
                     ELSE
                      0
                 END AS SIMULATION_06_SUM
                ,CASE
                     WHEN T1.MON_12_CUST_FCST_ACCUM_QTY > 0 THEN
                      T1.CUST_FCST_QTY * ((T1.MON_12_MKT_FCST_ACCUM_QTY / T1.MON_12_CUST_FCST_ACCUM_QTY) - 1)
                     ELSE
                      0
                 END AS SIMULATION_12_SUM
                ,NULL AS DEMAND_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_03_CUSTOMER_DEMAND_CAR_PROD / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_03_CUSTOMER_DEMAND_CAR_PROD
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_06_CUSTOMER_DEMAND_CAR_PROD / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_06_CUSTOMER_DEMAND_CAR_PROD
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_12_CUSTOMER_DEMAND_CAR_PROD
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_03_CUSTOMER_DEMAND_CAR_SALES / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_03_CUSTOMER_DEMAND_CAR_SALES
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_06_CUSTOMER_DEMAND_CAR_SALES / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_06_CUSTOMER_DEMAND_CAR_SALES
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_12_CUSTOMER_DEMAND_CAR_SALES
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_03_CUSTOMER_DEMAND_DELIVERY / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_03_CUSTOMER_DEMAND_DELIVERY
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_06_CUSTOMER_DEMAND_DELIVERY / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_06_CUSTOMER_DEMAND_DELIVERY
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_12_CUSTOMER_DEMAND_DELIVERY / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_12_CUSTOMER_DEMAND_DELIVERY
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_03_CUSTOMER_LGES_OPERATION_SALES_ALLOC / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_03_LGES_OPERATION_SALES_ALLOC
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_06_CUSTOMER_LGES_OPERATION_SALES_ALLOC / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_06_LGES_OPERATION_SALES_ALLOC
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_12_LGES_OPERATION_SALES_ALLOC
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_03_CUSTOMER_LGES_OPERATION_MODEL_MIX / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_03_LGES_OPERATION_MODEL_MIX
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_06_CUSTOMER_LGES_OPERATION_MODEL_MIX / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_06_LGES_OPERATION_MODEL_MIX
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_12_LGES_OPERATION_MODEL_MIX
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_03_CUSTOMER_LGES_SUPPLY_SUPPLY / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_03_LGES_SUPPLY_SUPPLY
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_06_CUSTOMER_LGES_SUPPLY_SUPPLY / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_06_LGES_SUPPLY_SUPPLY
                 ----
                ,(SELECT T1.CUST_FCST_QTY * ROUND((T1_SUB.AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY / 100), 5)
                  FROM   W_T1 T1_SUB
                  WHERE  T1_SUB.PLAN_YYYYMM = T1.PLAN_YYYYMM) AS SIMULATION_12_LGES_SUPPLY_SUPPLY
                 ----
                ,NULL                AS DEMAND_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS DEMAND_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL                AS RESULT
                ,NULL                AS MKT_DP
                ,NULL                AS GAP
                ,T1.PLAN_YYYYMM_RANK
          FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1
          WHERE  T1.MEASURE = 'MKT_FCST_FNL'),
        W_T3 AS
         (SELECT CASE
                     WHEN T1.MEASURE = 'MKT_FCST_FST' THEN
                      3
                     WHEN T1.MEASURE = 'MKT_FCST_FNL' THEN
                      4
                 END AS SEQ
                 --,CASE WHEN T1.PLAN_YYYYMM = @YYYYMM2 AND T1.MEASURE = 'MKT_FCST_FST' THEN 'MODIFY' --ex)202412 이번달이면서 1st   이라면 [팝업 조회,수정 가능]
                 --    WHEN T1.PLAN_YYYYMM = @YYYYMM3 AND T1.MEASURE = 'MKT_FCST_FNL' THEN 'MODIFY' --ex)202411 직전달이면서 final 이라면 [팝업 조회,수정 가능]
                 --    WHEN T1.PLAN_YYYYMM = @YYYYMM2 AND T1.MEASURE = 'MKT_FCST_FNL' THEN 'READ_NONE' --ex)202412 이번달이면서 final 이라면 [팝업 조회,수정 불가능]
                 --    ELSE 'READ_OK' END AS POPUP_STATUS -- [팝업 조회 가능, 수정 불가능]
                ,CASE
                     WHEN T1.PLAN_YYYYMM_RANK = 1 AND T1.MEASURE = 'MKT_FCST_FST' THEN
                      'MODIFY' --ex)202412 이번달이면서 1st   이라면 [팝업 조회,수정 가능]
                     WHEN T1.PLAN_YYYYMM_RANK = 2 AND T1.MEASURE = 'MKT_FCST_FNL' THEN
                      'MODIFY' --ex)202411 직전달이면서 final 이라면 [팝업 조회,수정 가능]
                     WHEN T1.PLAN_YYYYMM_RANK = 1 AND T1.MEASURE = 'MKT_FCST_FNL' THEN
                      'READ_NONE' --ex)202412 이번달이면서 final 이라면 [팝업 조회,수정 불가능]
                     ELSE
                      'READ_OK'
                 END AS POPUP_STATUS -- [팝업 조회 가능, 수정 불가능]
                ,T1.DIVISION_ID
                ,T1.END_CUSTOMER
                ,T1.PROJECT_NAME
                ,T1.PROJECT_CODE
                ,T1.PLAN_YYYYMM
                ,T1.CUST_FCST_QTY AS EDI_QTY
                ,CASE
                     WHEN T1.MEASURE = 'MKT_FCST_FST' THEN
                      'Demand Plan (1st)'
                     WHEN T1.MEASURE = 'MKT_FCST_FNL' THEN
                      'Demand Plan (Final)'
                 END AS MEASURE
                ,M1_CUST_FCST_QTY AS M1_CUST_FCST_QTY
                ,M1_MKT_FCST_QTY AS M1_MKT_FCST_QTY
                ,M2_CUST_FCST_QTY AS M2_CUST_FCST_QTY
                ,M2_MKT_FCST_QTY AS M2_MKT_FCST_QTY
                ,M3_CUST_FCST_QTY AS M3_CUST_FCST_QTY
                ,M3_MKT_FCST_QTY AS M3_MKT_FCST_QTY
                ,NULL AS AVERAGE_03_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_SUM --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,T1.TOTAL_QTY AS DEMAND_SUM
                ,NULL AS AVERAGE_03_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_03_CUSTOMER_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_06_CUSTOMER_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_CUSTOMER_DEMAND_CAR_PROD --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_CUSTOMER_DEMAND_CAR_SALES --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_CUSTOMER_DEMAND_DELIVERY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_LGES_OPERATION_SALES_ALLOC --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_LGES_OPERATION_MODEL_MIX --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_03_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_06_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,NULL AS SIMULATION_12_LGES_SUPPLY_SUPPLY --항상 NULL로 해야 COALESCE 에서 정상적으로 가져감
                ,T1.CAR_PROD_DTL_QTY AS DEMAND_CUSTOMER_DEMAND_CAR_PROD
                ,T1.CAR_SALES_DTL_QTY AS DEMAND_CUSTOMER_DEMAND_CAR_SALES
                ,T1.DELIVERY_DTL_QTY AS DEMAND_CUSTOMER_DEMAND_DELIVERY
                ,T1.MODEL_MIX_DTL_QTY AS DEMAND_LGES_OPERATION_MODEL_MIX
                ,T1.SALES_ALLOC_DTL_QTY AS DEMAND_LGES_OPERATION_SALES_ALLOC
                ,T1.SUPPLY_DTL_QTY AS DEMAND_LGES_SUPPLY_SUPPLY
                ,ROUND((T1.CUST_FCST_QTY + T1.TOTAL_QTY), 0) AS RESULT
                ,ROUND(T1.MKT_FCST_QTY, 0) AS MKT_DP
                ,(ROUND((T1.CUST_FCST_QTY + T1.TOTAL_QTY), 0) - ROUND(T1.MKT_FCST_QTY, 0)) AS GAP
                 -- ,(T1.CUST_FCST_QTY + T1.TOTAL_QTY) AS RESULT
                 -- ,T1.MKT_FCST_QTY AS MKT_DP
                 -- ,((T1.CUST_FCST_QTY + T1.TOTAL_QTY) - T1.MKT_FCST_QTY) AS GAP
                ,T1.PLAN_YYYYMM_RANK
          FROM   SCM_MGR.GT_DM81_PSI_T1_RAW T1),
        W_T4 AS
         (SELECT * FROM W_T1 UNION ALL SELECT * FROM W_T2 UNION ALL SELECT * FROM W_T3)
        SELECT T.DIVISION_ID
              ,T.END_CUSTOMER
              ,T.PROJECT_NAME
              ,T.PROJECT_CODE
              ,SUBSTR(T.PLAN_YYYYMM, 1, 4) || '-' || SUBSTR(T.PLAN_YYYYMM, 5, 2) AS PLAN_YYYYMM
              ,RTRIM(TO_CHAR(NVL(T.M3_CUST_FCST_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS M3_CUST_FCST_QTY
              ,RTRIM(TO_CHAR(NVL(T.M3_MKT_FCST_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS M3_MKT_FCST_QTY
              ,RTRIM(TO_CHAR(NVL(T.M2_CUST_FCST_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS M2_CUST_FCST_QTY
              ,RTRIM(TO_CHAR(NVL(T.M2_MKT_FCST_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS M2_MKT_FCST_QTY
              ,RTRIM(TO_CHAR(NVL(T.M1_CUST_FCST_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS M1_CUST_FCST_QTY
              ,RTRIM(TO_CHAR(NVL(T.M1_MKT_FCST_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS M1_MKT_FCST_QTY
              ,RTRIM(TO_CHAR(NVL(T.EDI_QTY, 0), 'FM9,999,999,999,990.99'), '.') AS EDI_QTY
              ,T.MEASURE
               -- 컬럼명은 SUM_03 , SUM_06으로 되어있긴 하지만 이번달만 해당되고 나머지달은 모두 SUM_12에 해당되는 값으로 바인딩 해야한다.
               -- CASE WHEN @YYYYMM2 = T.PLAN_YYYYMM -> T.PLAN_YYYYMM_RANK = 1 으로 변경
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_SUM, T.SIMULATION_03_SUM, T.DEMAND_SUM), 'FM9,999,999,999,990.99'), '.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_SUM, T.SIMULATION_12_SUM, T.DEMAND_SUM), 'FM9,999,999,999,990.99'), '.')
               END AS SUM_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_SUM, T.SIMULATION_06_SUM, T.DEMAND_SUM), 'FM9,999,999,999,990.99'), '.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_SUM, T.SIMULATION_12_SUM, T.DEMAND_SUM), 'FM9,999,999,999,990.99'), '.')
               END AS SUM_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_SUM, T.SIMULATION_12_SUM, T.DEMAND_SUM), 'FM9,999,999,999,990.99'), '.') AS SUM_12
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.SIMULATION_03_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_PROD)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.SIMULATION_12_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_PROD)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS PRODUCT_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.SIMULATION_06_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_PROD)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.SIMULATION_12_CUSTOMER_DEMAND_CAR_PROD
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_PROD)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS PRODUCT_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_CAR_PROD, T.SIMULATION_12_CUSTOMER_DEMAND_CAR_PROD, T.DEMAND_CUSTOMER_DEMAND_CAR_PROD)
                            ,'FM9,999,999,999,990.99')
                    ,'.') AS PRODUCT_12
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.SIMULATION_03_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_SALES)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.SIMULATION_12_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_SALES)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS SALE_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.SIMULATION_06_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_SALES)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.SIMULATION_12_CUSTOMER_DEMAND_CAR_SALES
                                          ,T.DEMAND_CUSTOMER_DEMAND_CAR_SALES)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS SALE_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_CAR_SALES
                                     ,T.SIMULATION_12_CUSTOMER_DEMAND_CAR_SALES
                                     ,T.DEMAND_CUSTOMER_DEMAND_CAR_SALES)
                            ,'FM9,999,999,999,990.99')
                    ,'.') AS SALE_12
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_CUSTOMER_DEMAND_DELIVERY
                                          ,T.SIMULATION_03_CUSTOMER_DEMAND_DELIVERY
                                          ,T.DEMAND_CUSTOMER_DEMAND_DELIVERY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_DELIVERY
                                          ,T.SIMULATION_12_CUSTOMER_DEMAND_DELIVERY
                                          ,T.DEMAND_CUSTOMER_DEMAND_DELIVERY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS INVENTORY_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_CUSTOMER_DEMAND_DELIVERY
                                          ,T.SIMULATION_06_CUSTOMER_DEMAND_DELIVERY
                                          ,T.DEMAND_CUSTOMER_DEMAND_DELIVERY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_DELIVERY
                                          ,T.SIMULATION_12_CUSTOMER_DEMAND_DELIVERY
                                          ,T.DEMAND_CUSTOMER_DEMAND_DELIVERY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS INVENTORY_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_DEMAND_DELIVERY, T.SIMULATION_12_CUSTOMER_DEMAND_DELIVERY, T.DEMAND_CUSTOMER_DEMAND_DELIVERY)
                            ,'FM9,999,999,999,990.99')
                    ,'.') AS INVENTORY_12
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                                          ,T.SIMULATION_03_LGES_OPERATION_SALES_ALLOC
                                          ,T.DEMAND_LGES_OPERATION_SALES_ALLOC)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                                          ,T.SIMULATION_12_LGES_OPERATION_SALES_ALLOC
                                          ,T.DEMAND_LGES_OPERATION_SALES_ALLOC)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS TIME_ADJUST_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                                          ,T.SIMULATION_06_LGES_OPERATION_SALES_ALLOC
                                          ,T.DEMAND_LGES_OPERATION_SALES_ALLOC)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                                          ,T.SIMULATION_12_LGES_OPERATION_SALES_ALLOC
                                          ,T.DEMAND_LGES_OPERATION_SALES_ALLOC)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS TIME_ADJUST_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_OPERATION_SALES_ALLOC
                                     ,T.SIMULATION_12_LGES_OPERATION_SALES_ALLOC
                                     ,T.DEMAND_LGES_OPERATION_SALES_ALLOC)
                            ,'FM9,999,999,999,990.99')
                    ,'.') AS TIME_ADJUST_12
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_CUSTOMER_LGES_OPERATION_MODEL_MIX
                                          ,T.SIMULATION_03_LGES_OPERATION_MODEL_MIX
                                          ,T.DEMAND_LGES_OPERATION_MODEL_MIX)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX
                                          ,T.SIMULATION_12_LGES_OPERATION_MODEL_MIX
                                          ,T.DEMAND_LGES_OPERATION_MODEL_MIX)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS MODEL_MIX_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_CUSTOMER_LGES_OPERATION_MODEL_MIX
                                          ,T.SIMULATION_06_LGES_OPERATION_MODEL_MIX
                                          ,T.DEMAND_LGES_OPERATION_MODEL_MIX)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX
                                          ,T.SIMULATION_12_LGES_OPERATION_MODEL_MIX
                                          ,T.DEMAND_LGES_OPERATION_MODEL_MIX)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS MODEL_MIX_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_OPERATION_MODEL_MIX
                                     ,T.SIMULATION_12_LGES_OPERATION_MODEL_MIX
                                     ,T.DEMAND_LGES_OPERATION_MODEL_MIX)
                            ,'FM9,999,999,999,990.99')
                    ,'.') AS MODEL_MIX_12
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_03_CUSTOMER_LGES_SUPPLY_SUPPLY, T.SIMULATION_03_LGES_SUPPLY_SUPPLY, T.DEMAND_LGES_SUPPLY_SUPPLY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY, T.SIMULATION_12_LGES_SUPPLY_SUPPLY, T.DEMAND_LGES_SUPPLY_SUPPLY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS SUPPLY_ISSUE_03
              ,CASE
                   WHEN T.PLAN_YYYYMM_RANK = 1 THEN
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_06_CUSTOMER_LGES_SUPPLY_SUPPLY, T.SIMULATION_06_LGES_SUPPLY_SUPPLY, T.DEMAND_LGES_SUPPLY_SUPPLY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
                   ELSE
                    RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY, T.SIMULATION_12_LGES_SUPPLY_SUPPLY, T.DEMAND_LGES_SUPPLY_SUPPLY)
                                 ,'FM9,999,999,999,990.99')
                         ,'.')
               END AS SUPPLY_ISSUE_06
              ,RTRIM(TO_CHAR(COALESCE(T.AVERAGE_12_CUSTOMER_LGES_SUPPLY_SUPPLY, T.SIMULATION_12_LGES_SUPPLY_SUPPLY, T.DEMAND_LGES_SUPPLY_SUPPLY)
                            ,'FM9,999,999,999,990.99')
                    ,'.') AS SUPPLY_ISSUE_12
              ,RTRIM(TO_CHAR(RESULT, 'FM9,999,999,999,990.99'), '.') AS RESULT
              ,RTRIM(TO_CHAR(MKT_DP, 'FM9,999,999,999,990.99'), '.') AS MKT_DP
              ,RTRIM(TO_CHAR(GAP, 'FM9,999,999,999,990.99'), '.') AS GAP -- △ 특수문자 때문에 숫자로 바인딩하면 UI단에서 에러 난다.
              ,T.SEQ
              ,T.POPUP_STATUS
              ,EDY.EDIT_YN
        FROM   W_T4 T
        INNER  JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
        ON     EDY.USER_ID = P_USER_ID
        AND    EDY.MNU_ID = P_MENU_ID
        AND    EDY.UNIT_ID = T.DIVISION_ID
        WHERE  T.PLAN_YYYYMM BETWEEN V_YYYYMM4 AND V_YYYYMM2
        ORDER  BY PLAN_YYYYMM, SEQ;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_DIVISION_ID' VALUE P_DIVISION_ID, 'P_END_CUSTOMER' VALUE P_END_CUSTOMER, 'P_PROJECT_CODE' VALUE P_PROJECT_CODE);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                        ,V_LOG_TYPE
                                        ,N_LOG_COUNT
                                        ,V_LOG_MESSAGE
                                        ,V_DESCRIPTION
                                        ,D_EVENT_DATE
                                        ,V_PROC_INPUT
                                        ,V_SQL_CODE
                                        ,V_SQL_ERRMSG
                                        ,V_BACKTRACE);
        END;
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        RAISE;
        
END P_DMF0081_GET_DM_ANL_MKT_PSI_DATA;

PROCEDURE P_DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS
(
      P_EV_TP_CD      IN VARCHAR2--TYPE
     ,P_CUST_CO_CD    IN VARCHAR2--제조사
     ,P_CAR_MDL_ID    IN VARCHAR2--모델명
     ,P_FROM_YYYYMM   IN VARCHAR2--Period from
     ,P_TO_YYYYMM     IN VARCHAR2--Period to
     ,P_MARKETSHARE   IN VARCHAR2--당사 M/S(%)
     ,P_BIZPERCAR     IN VARCHAR2--BIZ수량 PER CAR
     ,P_USER_ID       IN VARCHAR2
     ,P_MENU_ID       IN VARCHAR2
     ,O_RC1           OUT SYS_REFCURSOR
     ,O_RC2           OUT SYS_REFCURSOR
     ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*===================================================================================================
* Program ID   : DMF0003_GET_DM_ANL_CAR_REF
* Description  :
* Program History
*===================================================================================================
*   Date       In Charge      Description
*===================================================================================================
* 2024.11.14   dsiol     엑셀 업로드시에 저장된 부가정보 조회 추가
* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선
* 2025-01-21 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
* EXEC DMF0003_GET_DM_ANL_CAR_REF '20210301', '20230701', 'BMW', ''
* EXEC DMF0003_GET_DM_ANL_CAR_REF '20230701', '20240630', 'FORD', 'Ford Mustang Mach-E BEV'
* EXEC DMF0003_GET_DM_ANL_CAR_REF '20230701', '20240630', 'FORD', 'Ford Mustang Mach-E BEV'
        
* EXEC DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS 'PHEV','BMW','2ER(225Xe Active Tourer)','202003','202502','NODATA','NODATA'
* EXEC DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS 'PHEV','BMW','2ER(225Xe Active Tourer)','202003','202502','50','1'
* EXEC DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS 'PHEV','BMW','2ER(225Xe Active Tourer)','202003','202504','250','10'
* EXEC DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS 'BEV','Audi','500e','202411','202502','100','1'
* EXEC DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS 'BEV','JMC-Ford', 'Territory (?界) EV','202003','202502','100','10'
* EXEC DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS 'BEV','Audi','E-Tron EV','202001','202506','NODATA','NODATA'
*===================================================================================================*/
AS
    --UI 에서
    --txtMarketShare.Text / txtBizPerCar.Text 둘다 빈칸일 경우 진짜로 빈칸으로 보여주기
    --txtMarketShare.Text 는 빈칸 txtBizPerCar.Text 는 값이 있을 경우 txtMarketShare.Text에는 100을 입력    -> @p_MARKETSHARE만 빈칸일 때는 100으로 파라미터가 들어오고
    --txtMarketShare.Text 는 값이 있고 txtBizPerCar.Text 는 빈칸이 있을 경우 txtBizPerCar.Text에는 1을 입력 -> @p_BIZPERCAR만 빈칸일 때는 1으로 파라미터가 들어온다.
    --@COLUMNS2 에서 0000가 사실상 NULL이라고 보면 됨. 숫자를 안넣으면 ERROR 발생.
    V_IMARKETSHARE VARCHAR2(100 CHAR);
    V_IBIZPERCAR   VARCHAR2(100 CHAR);
    V_SQTY_STRING  VARCHAR2(100 CHAR);
    V_COLUMNS      VARCHAR2(32000 CHAR); -- PLAN_YYYYMM 리스트
    V_COLUMNS2     VARCHAR2(32000 CHAR); -- PLAN_YYYYMM 리스트 에 소수점 없애기 위하여 추가, 최종 조회때 사용.
    V_SQL0         VARCHAR2(32000 CHAR);
    V_SQL1         VARCHAR2(32000 CHAR);
    V_SQL2         VARCHAR2(32000 CHAR);
    V_SQL3         VARCHAR2(32000 CHAR);
    V_SQL4         VARCHAR2(32000 CHAR);
    V_SQL5         VARCHAR2(32000 CHAR);
    
    -- EXCEPTION 처리용 변수
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_BACKTRACE    VARCHAR2(4000 CHAR);
    V_SQL_CODE     VARCHAR2(100 CHAR);
    V_SQL_ERRMSG   VARCHAR2(1000 CHAR);
    V_LOG_TYPE     VARCHAR2(100 CHAR);
    V_LOG_MESSAGE  VARCHAR2(4000 CHAR);
    V_DESCRIPTION  VARCHAR2(4000 CHAR);
    N_LOG_COUNT    PLS_INTEGER := 0;
    D_EVENT_DATE   DATE := SYSDATE;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
BEGIN
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    
    -- V_IMARKETSHARE 초기화
    IF P_MARKETSHARE = 'NODATA' AND P_BIZPERCAR = 'NODATA' THEN
        V_IMARKETSHARE := '';
    ELSE
        V_IMARKETSHARE := RTRIM(TO_CHAR(TO_NUMBER(P_MARKETSHARE) * 0.01, 'FM99990.99'), '.');
    END IF;
    
    -- V_IBIZPERCAR 초기화
    IF P_MARKETSHARE = 'NODATA' AND P_BIZPERCAR = 'NODATA' THEN
        V_IBIZPERCAR := '';
    ELSE
        V_IBIZPERCAR := RTRIM(TO_CHAR(TO_NUMBER(P_BIZPERCAR), 'FM99990.99'), '.');
    END IF;
    
    -- V_SQTY_STRING 초기화
    IF P_MARKETSHARE = 'NODATA' AND P_BIZPERCAR = 'NODATA' THEN
        V_SQTY_STRING := '0000';
    ELSE
        V_SQTY_STRING := 'SUM(CASE WHEN LENGTH(QTY) > 0 THEN QTY ELSE 0 END) * ' || V_IMARKETSHARE || ' * ' || V_IBIZPERCAR;
    END IF;
    
    --UI에서 HEADER를 만들 때 사용 할 쿼리
    OPEN O_RC1 FOR
        SELECT DISTINCT BASIS_YYYYMM AS PLAN_YYYYMM
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMM BETWEEN P_FROM_YYYYMM AND P_TO_YYYYMM
        ORDER  BY BASIS_YYYYMM;
    
    --V_COLUMNS 작성 시작
    V_COLUMNS := '';
    FOR R IN (SELECT DISTINCT BASIS_YYYYMM AS PLAN_YYYYMM
              FROM   SCM_MGR.SCM_SYS_CALENDAR_M
              WHERE  BASIS_YYYYMM BETWEEN P_FROM_YYYYMM AND P_TO_YYYYMM
              ORDER  BY BASIS_YYYYMM ASC) LOOP
        V_COLUMNS := V_COLUMNS || '"' || R.PLAN_YYYYMM || '",';
    END LOOP;
    V_COLUMNS := SUBSTR(V_COLUMNS, 1, LENGTH(V_COLUMNS) - 1);
    --V_COLUMNS 작성 종료
    
    --V_COLUMNS2 작성 시작
    V_COLUMNS2 := '';
    FOR R IN (SELECT DISTINCT BASIS_YYYYMM AS PLAN_YYYYMM
              FROM   SCM_MGR.SCM_SYS_CALENDAR_M
              WHERE  BASIS_YYYYMM BETWEEN P_FROM_YYYYMM AND P_TO_YYYYMM
              ORDER  BY BASIS_YYYYMM ASC) LOOP
        V_COLUMNS2 := V_COLUMNS2 || CHR(10) || 'MAX(CASE WHEN PLAN_YYYYMM = ''' || R.PLAN_YYYYMM || '''' || CHR(10) ||
                      ' THEN CASE WHEN QTY = 0 THEN NULL ELSE RTRIM(TO_CHAR(QTY, ''FM9,999,999,999,990.99''),''.'') END END) AS "' || R.PLAN_YYYYMM || '",';
    END LOOP;
    V_COLUMNS2 := SUBSTR(V_COLUMNS2, 1, LENGTH(V_COLUMNS2) - 1);
    --V_COLUMNS2 작성 종료
    
    --원래는 @SQL 하나로 할 수 있으나... NVARCHAR가 어느정도 바이트가 늘어나면 한글이 깨지는 현상이 있어서 
    --나눠서 쿼리를 저장했음... @SQL0~@SQL7 등등.. 아래는 참고용..
    
    V_SQL0 := 'SELECT X.MAJOR_CAT, X.MINOR_CAT,'
             --|| CHR(10) || 'EDIT_YN,'
              || CHR(10) || ' ' || V_COLUMNS2 || ' FROM (';
    
    V_SQL1 := '  SELECT EV_TP_CD, CUST_CO_CD, CAR_MDL_ID, MEASURE' || CHR(10) || ', ''차량대수별'' AS MAJOR_CAT' || CHR(10) ||
              ', COLUMN_LABEL_NAME AS MINOR_CAT' || CHR(10) || ', PLAN_YYYYMM' || CHR(10) || ', QTY'
             --|| CHR(10) || ', EDIT_YN'
              || CHR(10) || '  FROM (' || CHR(10) || '    SELECT A.EV_TP_CD, A.CUST_CO_CD, A.CAR_MDL_ID, A.MEASURE, A.PLAN_YYYYMM' || CHR(10) ||
              '          ,SUM(A.QTY) AS QTY' || CHR(10) || '          ,(SELECT B2.COLUMN_LABEL_NAME FROM SCM_MST_SHEET_MEASURE B2' || CHR(10) ||
              '            WHERE B2.PROGRAM_ID = ''DMF0081'' AND B2.SHEET_NAME = ''carFcst'' AND A.MEASURE = B2.COLUMN_NAME) AS COLUMN_LABEL_NAME'
             --|| CHR(10) || '          ,EDY.EDIT_YN'
              || CHR(10) || '    FROM SCM_MGR.DM_YEARLY_MKT_DMD_ANALYSIS A' || CHR(10) || '    LEFT JOIN SCM_MGR.SCM_MST_SHEET_MEASURE B' || CHR(10) ||
              '         ON A.MEASURE = B.COLUMN_NAME' || CHR(10) || '        AND B.PROGRAM_ID = ''DMF0081''' || CHR(10) ||
              '        AND B.SHEET_NAME = ''carFcst''' || CHR(10) || '        AND A.PLAN_YYYYMM BETWEEN ''' || P_FROM_YYYYMM || ''' AND ''' || P_TO_YYYYMM || ''''
             --|| CHR(10) || '    INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V EDY'
             --|| CHR(10) || '         ON EDY.USER_ID = ''' || P_USER_ID || ''''
             --|| CHR(10) || '        AND EDY.MNU_ID  = ''' || P_MENU_ID || ''''
             --|| CHR(10) || '        AND EDY.UNIT_ID = B.DIVISION_ID'
              || CHR(10) || '    WHERE A.EV_TP_CD  = ''' || P_EV_TP_CD || '''' || CHR(10) || '    AND   A.CUST_CO_CD = ''' || P_CUST_CO_CD || '''' ||
              CHR(10) || '    AND   A.CAR_MDL_ID = ''' || P_CAR_MDL_ID || '''' || CHR(10) || '    AND   A.MEASURE    = ''S''' || CHR(10) ||
              '    GROUP BY A.EV_TP_CD, A.CUST_CO_CD, A.CAR_MDL_ID, A.MEASURE, A.PLAN_YYYYMM'
             --|| CHR(10) || '            ,EDY.EDIT_YN'
              || CHR(10) || '  )';
    
    V_SQL2 := ''; -- Oracle에서는 PIVOT 대신 인라인뷰 집계 사용 (V_SQL1 에 통합)
    
    V_SQL3 := '  UNION ALL' || CHR(10) || '  SELECT EV_TP_CD, CUST_CO_CD, CAR_MDL_ID, MEASURE' || CHR(10) || ', ''BIZ단위환산'' AS MAJOR_CAT' || CHR(10) ||
              ', COLUMN_LABEL_NAME AS MINOR_CAT' || CHR(10) || ', PLAN_YYYYMM' || CHR(10) || ', QTY'
    --|| CHR(10) || ', EDIT_YN'
     ;
    
    V_SQL4 := '  FROM (' || CHR(10) || '    SELECT A.EV_TP_CD, A.CUST_CO_CD, A.CAR_MDL_ID, A.MEASURE, A.PLAN_YYYYMM' || CHR(10) || '          ,' ||
              V_SQTY_STRING || ' AS QTY' || CHR(10) || '          ,(SELECT B2.COLUMN_LABEL_NAME FROM SCM_MST_SHEET_MEASURE B2' || CHR(10) ||
              '            WHERE B2.PROGRAM_ID = ''DMF0081'' AND B2.SHEET_NAME = ''carFcst'' AND A.MEASURE = B2.COLUMN_NAME) AS COLUMN_LABEL_NAME'
             --|| CHR(10) || '          ,EDY.EDIT_YN'
              || CHR(10) || '    FROM SCM_MGR.DM_YEARLY_MKT_DMD_ANALYSIS A' || CHR(10) || '    LEFT JOIN SCM_MGR.SCM_MST_SHEET_MEASURE B' || CHR(10) ||
              '         ON A.MEASURE = B.COLUMN_NAME' || CHR(10) || '        AND B.PROGRAM_ID = ''DMF0081''' || CHR(10) ||
              '        AND B.SHEET_NAME = ''carFcst''' || CHR(10) || '        AND A.PLAN_YYYYMM BETWEEN ''' || P_FROM_YYYYMM || ''' AND ''' || P_TO_YYYYMM || ''''
             --|| CHR(10) || '    INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V EDY'
             --|| CHR(10) || '         ON EDY.USER_ID = ''' || P_USER_ID || ''''
             --|| CHR(10) || '        AND EDY.MNU_ID  = ''' || P_MENU_ID || ''''
             --|| CHR(10) || '        AND EDY.UNIT_ID = B.DIVISION_ID'
              || CHR(10) || '    WHERE A.EV_TP_CD   = ''' || P_EV_TP_CD || '''' || CHR(10) || '    AND   A.CUST_CO_CD = ''' || P_CUST_CO_CD || '''' ||
              CHR(10) || '    AND   A.CAR_MDL_ID = ''' || P_CAR_MDL_ID || '''' || CHR(10) || '    AND   A.MEASURE    = ''S''' || CHR(10) ||
              '    GROUP BY A.EV_TP_CD, A.CUST_CO_CD, A.CAR_MDL_ID, A.MEASURE, A.PLAN_YYYYMM'
             --|| CHR(10) || '         ,EDY.EDIT_YN'
              || CHR(10) || '  )';
    
    V_SQL5 := ') X' || CHR(10) || ' GROUP BY X.EV_TP_CD, X.CUST_CO_CD, X.CAR_MDL_ID, X.MAJOR_CAT, X.MINOR_CAT, X.MEASURE'
             --|| CHR(10) || ' ,X.EDIT_YN'
              || CHR(10) || ' ORDER BY X.EV_TP_CD, X.CUST_CO_CD, X.CAR_MDL_ID' || CHR(10) || ', CASE WHEN X.MAJOR_CAT = ''차량대수별'' THEN 0 ELSE 1 END ASC' ||
              CHR(10) || ', CASE WHEN X.MEASURE = ''P'' THEN 0 WHEN X.MEASURE = ''S'' THEN 1 ELSE 2 END ASC';
    
    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.PUT_LINE(V_SQL0 || V_SQL1 || V_SQL2 || V_SQL3 || V_SQL4 || V_SQL5);
    
    --최종 조회 쿼리 실행
    OPEN O_RC2 FOR V_SQL0 || V_SQL1 || V_SQL2 || V_SQL3 || V_SQL4 || V_SQL5;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;
    
    --나눠진 쿼리를 합쳐서 확인하고 싶다면 아래 쿼리를 실행하면 된다.
    --SELECT (@SQL0+@SQL1+@SQL2+@SQL3+@SQL4+@SQL5)
    --SELECT DATALENGTH(@SQL0),DATALENGTH(@SQL1),DATALENGTH(@SQL2),DATALENGTH(@SQL3),DATALENGTH(@SQL4),DATALENGTH(@SQL5)
    --혹시나 위의 방법으로 글자가 깨질 경우 (한글이 ???? 물음표로 깨져서 출력 될 수 있다.)
    --SELECT @SQL0,@SQL1,@SQL2,@SQL3,@SQL4,@SQL5
    --를 실행 한뒤 나오는 결과를 합친뒤에 실행해야 한다.
    --SELECT @SQL
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_EV_TP_CD' VALUE P_EV_TP_CD
                                    ,'P_CUST_CO_CD' VALUE P_CUST_CO_CD
                                    ,'P_CAR_MDL_ID' VALUE P_CAR_MDL_ID
                                    ,'P_FROM_YYYYMM' VALUE P_FROM_YYYYMM
                                    ,'P_TO_YYYYMM' VALUE P_TO_YYYYMM
                                    ,'P_MARKETSHARE' VALUE P_MARKETSHARE
                                    ,'P_BIZPERCAR' VALUE P_BIZPERCAR);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                        ,V_LOG_TYPE
                                        ,N_LOG_COUNT
                                        ,V_LOG_MESSAGE
                                        ,V_DESCRIPTION
                                        ,D_EVENT_DATE
                                        ,V_PROC_INPUT
                                        ,V_SQL_CODE
                                        ,V_SQL_ERRMSG
                                        ,V_BACKTRACE);
        END;
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        
END P_DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS;

PROCEDURE P_DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP
(
    P_DIVISION_ID     IN VARCHAR
   ,P_END_CUSTOMER    IN VARCHAR
   ,P_PROJECT_CODE    IN VARCHAR
   ,P_MEASURE         IN VARCHAR
   ,P_YYYYMM          IN VARCHAR
   ,P_REQ_RSN_CD      IN VARCHAR DEFAULT NULL
   ,P_DIF_ANLS_TP_CD  IN VARCHAR DEFAULT NULL
   ,P_ANLS_DIF_RSN_CD IN VARCHAR DEFAULT NULL
   ,P_REQ_RSN_DTL_CTN IN VARCHAR2 DEFAULT NULL
   ,P_QTY             IN NUMBER DEFAULT 0
   ,P_CREATED_BY      IN VARCHAR2 DEFAULT NULL
   ,P_PROCEDURE_TYPE  IN VARCHAR2
   ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*===================================================================================================
* Program ID  : [DMF0081_GET_CUST_DEMAND_ANL_DETAIL]
* Author:    <Author,,Name>
* Create date: <Create Date,,>
* Description  : 고객수요증감 팝업 조회
* Program History
*===================================================================================================
*   Date       In Charge      Description
*===================================================================================================
* 2024.11.05   dsiol     팝업에서 입력한 데이터를 1 ROW씩 INSERT 한다. (ROW 만큼 실행되는 프로시저)
* 2024-12-10  dsiol    [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선
* 2026.03.24  김준규    [PJ20264226] NextSCM Pilot 설계 및 개발
*===================================================================================================*/
 AS
    -- LOG 변수
    V_LOG_TYPE    VARCHAR2(100 CHAR);
    V_LOG_MESSAGE VARCHAR2(4000 CHAR);
    V_DESCRIPTION VARCHAR2(4000 CHAR);
    N_LOG_COUNT   PLS_INTEGER := 0;
    D_EVENT_DATE  DATE := SYSDATE;
    
    -- EXCEPTION 변수
    V_PROC_INPUT   VARCHAR2(4000 CHAR);
    V_BACKTRACE    VARCHAR2(4000 CHAR);
    V_SQL_CODE     VARCHAR2(100 CHAR);
    V_SQL_ERRMSG   VARCHAR2(1000 CHAR);
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    
    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    
    IF P_PROCEDURE_TYPE = 'DELETE' THEN
        
        DELETE FROM SCM_MGR.DM_CUST_DEMAND_ANL_DETAIL
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    END_CUSTOMER = P_END_CUSTOMER
        AND    PROJECT_CODE = P_PROJECT_CODE
        AND    MEASURE = P_MEASURE
        AND    PLAN_YYYYMM = P_YYYYMM;
        
        N_LOG_COUNT := SQL%ROWCOUNT;
        
    ELSIF P_PROCEDURE_TYPE = 'INSERT' THEN
        
        INSERT INTO SCM_MGR.DM_CUST_DEMAND_ANL_DETAIL
            (DIVISION_ID
            ,END_CUSTOMER
            ,PROJECT_CODE
            ,MEASURE
            ,PLAN_YYYYMM
            ,REQ_RSN_CD
            ,DIF_ANLS_TP_CD
            ,ANLS_DIF_RSN_CD
            ,REQ_RSN_DTL_CTN
            ,QTY
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE)
        VALUES
            (P_DIVISION_ID
            ,P_END_CUSTOMER
            ,P_PROJECT_CODE
            ,P_MEASURE
            ,P_YYYYMM
            ,P_REQ_RSN_CD
            ,P_DIF_ANLS_TP_CD
            ,P_ANLS_DIF_RSN_CD
            ,P_REQ_RSN_DTL_CTN
            ,P_QTY
            ,P_CREATED_BY
            ,SYSDATE
            ,P_CREATED_BY
            ,SYSDATE);
        
        N_LOG_COUNT := SQL%ROWCOUNT;
        
    END IF;
    
    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    
    COMMIT;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_DIVISION_ID' VALUE P_DIVISION_ID
                                    ,'P_END_CUSTOMER' VALUE P_END_CUSTOMER
                                    ,'P_PROJECT_CODE' VALUE P_PROJECT_CODE
                                    ,'P_MEASURE' VALUE P_MEASURE
                                    ,'P_YYYYMM' VALUE P_YYYYMM
                                    ,'P_REQ_RSN_CD' VALUE P_REQ_RSN_CD
                                    ,'P_DIF_ANLS_TP_CD' VALUE P_DIF_ANLS_TP_CD
                                    ,'P_ANLS_DIF_RSN_CD' VALUE P_ANLS_DIF_RSN_CD
                                    ,'P_REQ_RSN_DTL_CTN' VALUE P_REQ_RSN_DTL_CTN
                                    ,'P_QTY' VALUE TO_CHAR(P_QTY)
                                    ,'P_CREATED_BY' VALUE P_CREATED_BY
                                    ,'P_PROCEDURE_TYPE' VALUE P_PROCEDURE_TYPE);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                        ,V_LOG_TYPE
                                        ,N_LOG_COUNT
                                        ,V_LOG_MESSAGE
                                        ,V_DESCRIPTION
                                        ,D_EVENT_DATE
                                        ,V_PROC_INPUT
                                        ,V_SQL_CODE
                                        ,V_SQL_ERRMSG
                                        ,V_BACKTRACE);
        END;
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_SQL_ERRMSG || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_PROC_INPUT);
        
END P_DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP;

END PKG_DMF0081;
/
