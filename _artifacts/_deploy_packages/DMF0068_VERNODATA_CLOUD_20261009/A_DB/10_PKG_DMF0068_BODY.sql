-- 10 전체본 — 00_PRECHECK [H-LINES]=1476 · [H-LEN]=68313 · [H-APPLIED]=0 일 때만 실행. 다르면 12_CHANGE_BLOCK 수동 반영.
-- SOURCE-FRESH: SCM_MGR.PKG_DMF0068 PACKAGE BODY LAST_DDL=2026-10-09 14:37:46 FETCHED=2026-10-09 14:33 DB=ZIOUI1 (사내 적용본 md5 26854a305d223ae48b482d12a76ef328, 1483줄, 마커 3)
CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0068" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0068                                                                        */
/* Description : PKG_DMF0068                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.20  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0068_DEL_ORDERLIST
(
    P_DMF0068           IN T_DMF0068_TAB,

    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0068_DEL_ORDERLIST]
 * Description  : 소형 수주관리 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/10/16   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 소형 수주관리 삭제
 */
IS
    -- LOG 용 변수 설정
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     PLS_INTEGER     := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE            := SYSDATE;

    -- 예외처리 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    ROWCNT          PLS_INTEGER     := 0;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    DELETE FROM SCM_MGR.DM_PLN_ORDER_MGT
    WHERE ATTRIBUTE2 IN (
        SELECT ATTRIBUTE2
        FROM TABLE(P_DMF0068)
    ); --자기자신 뿐 아니라 쌍이 되는 다른 메져도 같이 지운다

    ROWCNT := SQL%ROWCOUNT;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    COMMIT;

    -- 결과코드, 결과 카운트 반환
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(ROWCNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT('P_DMF0068' VALUE 'T_DMF0068_TAB');
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
END P_DMF0068_DEL_ORDERLIST;

PROCEDURE P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP
(
    P_START_YYYYMMDD    IN  VARCHAR2,
    P_END_YYYYMMDD      IN VARCHAR2,
    --P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_VERSION_TYPE      IN VARCHAR2,
    --P_VERSION_NO      IN VARCHAR2,
    P_DESCRIPTION       IN VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/***************************************************************************************************
 Program ID  : DMF0068_GET_CONT_VIEW_VERSIONPOPUP
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

--------------------------------------------------------------------------------------------------
 Date        In Charge    Description
--------------------------------------------------------------------------------------------------
 2023/10/12	kjj			PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 신규생성
**************************************************************************************************/
IS
    -- 예외처리 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE        := SYSDATE;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    /*
       SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
         FROM [dbo].[DM_MST_VERSION]  WITH(NOLOCK)
       WHERE (YYYYMMDD >= @p_start_yyyymmdd and YYYYMMDD <= @p_end_yyyymmdd)
          AND DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id	,','))
          AND VERSION_TYPE IN (SELECT token FROM dbo.String_Split(@p_version_type	,','))
          AND Exists (Select * from dbo.UF_FX_String_Split (@p_version_no,',') as P Where [VERSION_NO] LIKE P.token +'%')
       GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
       ORDER BY CODE DESC, VERSION_NO DESC*/

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_RC1 FOR
        SELECT A.VERSION_NO AS CODE
             , A.VERSION_NO
             , A.VERSION_DESCRIPTION
             , A.VERSION_TYPE
             , A.VER_CRE_SEQ
             , A.YYYYMMDD
             , A.CREATED_BY
             , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD') AS CREATION_DATE
             , NVL(EDY.EDIT_YN, 'N') AS EDIT_YN
        FROM  SCM_MGR.DM_MDF_VERSION A
              LEFT OUTER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                   ON EDY.USER_ID = P_USER_ID
                  AND EDY.MNU_ID  = P_MENU_ID
                  AND EDY.UNIT_ID = A.DIVISION_ID
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND A.YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
          AND A.VERSION_TYPE = P_VERSION_TYPE
          AND A.VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'
          AND A.SEND_YN <> 'D'
          AND (A.ATTRIBUTE1 IS NULL OR A.ATTRIBUTE1 <> 'MOVE')   -- 2026-07-30 정정: NVL(x,'')<>'MOVE' 는 x가 NULL이면 항상 FALSE → 행 누락
        ORDER BY A.VERSION_NO DESC, A.VERSION_NO DESC;

    -- 결과코드 반환
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_DESCRIPTION'    VALUE P_DESCRIPTION,
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MENU_ID'        VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

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
END P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP;

PROCEDURE P_DMF0068_GET_LOOKUPPROJECT
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0068_DemandManager40]
 * Description  : 소형 수주관리 룩업프로젝트 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023-10-06   KJJ				PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 소형 수주관리 룩업프로젝트 조회

 * ex)
    EXEC DMF0068_GET_LOOKUPPROJECT @p_division_id='40',@P_VERSION_NO='R_S_20230911_V003'
 */
IS
    -- 예외처리 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE        := SYSDATE;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    /*
    DECLARE @V_ORI_VERSION_NO NVARCHAR(100)
    SET @V_ORI_VERSION_NO = (SELECT TOP 1 ORI_CUTOFF_VERSION_NO FROM DM_MDF_VERSION WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND  VERSION_NO = @p_version_no)

    IF SUBSTRING(@p_version_no, 1 ,3) = 'R_S'
    BEGIN
        SELECT SEGMENT2 CODE, SEGMENT3 'NAME' FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'
        AND SEGMENT2 IN (SELECT DISTINCT PROJECT_CODE FROM DM_PLN_SALES_PLAN_C WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @V_ORI_VERSION_NO)
        ORDER BY SEGMENT3
    END
    ELSE
    BEGIN
        SELECT SEGMENT2 CODE, SEGMENT3 'NAME' FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
        WHERE LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'
        AND SEGMENT2 IN (SELECT DISTINCT PROJECT_CODE FROM DM_PLN_BP_FCST_C WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @V_ORI_VERSION_NO)
        ORDER BY SEGMENT3
    END
    */

    /*
            SELECT
                D.SEGMENT1 CODE, D.SEGMENT1 'NAME'
                --D.SEGMENT1, P.PROJECT_CODE
            FROM SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
            INNER JOIN
            (
                SELECT * FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
                WHERE DIVISION_ID = '40'
                AND ISNULL(PROJECT_INFO, '') <> ''
            ) P
            ON D.SEGMENT1 = P.PROJECT_INFO
            WHERE D.LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'
            ORDER BY P.PROJECT_CODE, D.SEGMENT1
            */

    OPEN O_RC1 FOR
        SELECT D.SEGMENT1 AS CODE
             , D.SEGMENT1 AS NAME
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
        WHERE D.LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'
        ORDER BY SEGMENT1;

    -- 결과코드 반환
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_USER_ID'     VALUE P_USER_ID,
            'P_MENU_ID'     VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

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
END P_DMF0068_GET_LOOKUPPROJECT;

PROCEDURE P_DMF0068_GET_ORDERLIST
(
    P_DIVISION_ID       IN  VARCHAR2,
    P_VERSION_NO        IN  VARCHAR2,
    P_FROMDT            IN  VARCHAR2,
    P_TODT              IN  VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    P_MENU_ID           IN VARCHAR2,

    O_RC1               OUT SYS_REFCURSOR,
    O_RC2               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0068_DemandManager40]
 * Description  : 소형 수주관리 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2023-09-26   KJJ       PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 소형 수주관리 조회
 * 2024-04-17 JSSBAE      소형수주 로직 전체수정 요청으로 로직 전체수정진행
 * 2026-10-09   ZIONEX      [E20261009-VERNODATA] 버전 미존재 시 ORA-01403 → NULL (AS-IS SELECT TOP 1 동일, 클라우드 SQL ERROR 보완)
 *

/*
 -- 중요 로직 --
 1. 신규, 수정, 삭제는 2개의 쌍으로 이루어져야한다.
 2. 버전번호와 상관없이 등록, 수정, 조회 가능해야한다.
 3. 프로젝트 코드가 아닌 SSPM에 등록한 PROJECT_INFO 단위로 데이터가 표시 되어야한다.
 4. R_S 로 시작하면 SALES PLAN
    실적: DM_PLN_SALES_PLAN_RESULT
  계획: DM_PLN_SALES_PLAN_C
 5. R_B로 시작하면 BIZ PLAN
  실적: DM_PLN_SALES_PLAN_RESULT
  계획: DM_PLN_BP_FCST_C

 ex)
 --R_B_20230824_V001  BP_M_20230818_V001
 --R_S_20230911_V003  SP_W_20230831_V001

    EXEC DMF0068_GET_ORDERLIST @p_division_id='40',@P_VERSION_NO='R_B_20230824_V001', @P_FROMDT = '202201', @P_TODT = '202412'
 */
IS
    V_SQL_TEXT          VARCHAR2(32000 CHAR);
    V_ORI_VERSION_NO    VARCHAR2(100   CHAR);
    V_PV_LIST           VARCHAR2(8000  CHAR);
    V_PV_COL_LIST       VARCHAR2(8000  CHAR);
    V_PV_IN_LIST        VARCHAR2(8000  CHAR);   -- PIVOT IN 절(값 AS "별칭") — 2026-07-29 정정
    V_SORT_ORDER_NO     VARCHAR2(50    CHAR);
    V_PV_COLUMN_NAME    VARCHAR2(100   CHAR);
    V_PV_NAME           VARCHAR2(50    CHAR);
    V_NOW_YYYYMM        VARCHAR2(6     CHAR);   --당월에 대한 데이터를 구하기 위함
    V_LAST_YYYYMM       VARCHAR2(6     CHAR);   --전월에 대한 데이터를 구하기 위함

    -- CURSOR 변수 (월별 PIVOT 컬럼 생성용)
    CURSOR C_BUCKET IS
        SELECT 'NVL("' || A.BASIS_YYYYMM || '", 0) AS M' || TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMM)) AS COLUMN_NAME
             , '"' || A.BASIS_YYYYMM || '"' AS PV_NAME
             , '''' || A.BASIS_YYYYMM || ''' AS "' || A.BASIS_YYYYMM || '"' AS PV_IN_NAME
             , MIN(A.BASIS_START_DATE) || '_1' AS SORT_ORDER_NO
        FROM SCM_SYS_CALENDAR_M A
        WHERE A.BASIS_YYYYMM >= P_FROMDT
          AND A.BASIS_YYYYMM <= P_TODT
        GROUP BY A.BASIS_YYYYMM
        ORDER BY MIN(A.BASIS_START_DATE) || '_1';

    -- 예외처리 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE        := SYSDATE;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    /* [E20261009-VERNODATA] AS-IS `SET @V_ORI_VERSION_NO = (SELECT TOP 1 ...)` 는 버전이 없으면 NULL 로 넘어갔으나 Oracle SELECT INTO 는 ORA-01403 → 화면 SQL ERROR.
       F6 저장조건 복원 등으로 DM_MDF_VERSION 에 없는 버전이 오면 NULL 로 두어 계획(PLAN) 구간만 0건 (AS-IS 동일 결과) */
    BEGIN
    SELECT ORI_CUTOFF_VERSION_NO
    INTO V_ORI_VERSION_NO
    FROM (
        SELECT ORI_CUTOFF_VERSION_NO
        FROM SCM_MGR.DM_MDF_VERSION
        WHERE DIVISION_ID = P_DIVISION_ID
          AND VERSION_NO  = P_VERSION_NO
        FETCH FIRST 1 ROWS ONLY
    );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL;   /* [E20261009-VERNODATA] */
    END;

    DBMS_OUTPUT.PUT_LINE(V_ORI_VERSION_NO);

    --전월까지는 실적, 당월부터는 계획으로 잡는다
    --당월을 구한다.
    V_NOW_YYYYMM  := TO_CHAR(SYSDATE, 'YYYYMM');
    --전월을 구한다.
    V_LAST_YYYYMM := TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMM');

    DBMS_OUTPUT.PUT_LINE('A--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    --월데이터별로 데이터를 만들기 위해서 해당 작업을 진행한다.
    V_PV_LIST     := '';
    V_PV_COL_LIST := '';
    V_PV_IN_LIST  := '';

    FOR R IN C_BUCKET LOOP
        IF V_PV_COL_LIST IS NOT NULL AND LENGTH(V_PV_COL_LIST) > 0 THEN
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || R.COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || R.PV_NAME;
            V_PV_IN_LIST  := V_PV_IN_LIST  || ',' || R.PV_IN_NAME;
        ELSE
            V_PV_COL_LIST := R.COLUMN_NAME;
            V_PV_LIST     := R.PV_NAME;
            V_PV_IN_LIST  := R.PV_IN_NAME;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('B--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -- GTT 초기화 (이전에 일반 테이블 DML 없음 → TRUNCATE 허용)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM68_ORD_ITEM_SINGLE_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM68_ORD_CELL_PACK_COUNT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM68_ORD_PJTIFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM68_ORD_SRESULT_SPLAN';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM68_ORD_BRESULT_BPLAN';

    --MASTER성 데이터이므로 SALES PLAN이나 BIZ PLAN 여부와 관계없이 무조건 필요한 데이터
    ---------------------------------------------------------------------------------------------------------------------------------
    --[E20240208-001446]_[영업마케팅 PI팀] 소형 수주관리레포트(Demand Manager)화면 수량정보 수정
    --'RTF(R+P)', 'Business Plan' 메저값에 Business Plan 화면의 'Cell/Pack Count' 수량에 곱한 값을 표출 (셀Biz, 팩 Biz, 정상입력된 모듈 Biz)
    --Business Plan화면의 Cell Pack Count값 = DM_MST_ITEM_SINGLE_V.FORECAST_INFO_CELL_PACK_COUNT
    --ITEM_TYPE = SEMI-PRODUCT -> ITEM_TYPE: H
    ---------------------------------------------------------------------------------------------------------------------------------
    --1.Business Plan화면 Cell Pack Count값 추출을 위해 해당 부분 임시 테이블에 데이터 보관
    INSERT INTO SCM_MGR.GT_DM68_ORD_ITEM_SINGLE_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE,
        MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP,
        FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC,
        FORECAST_INFOR_VERSION, CELL_TYPE, ENERGE, CELL_QUANTITY
    )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE,
           MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP,
           FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC,
           FORECAST_INFOR_VERSION, CELL_TYPE, ENERGE, CELL_QUANTITY
    FROM
    (
        SELECT T1.DIVISION_ID,
               T1.ITEM_ID,
               MAX(T1.ITEM_NAME)                        AS ITEM_NAME,              --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
               MAX(T1.ITEM_CLASS)                       AS ITEM_CLASS,             --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
               MAX(T1.ITEM_CLASS_NAME)                  AS ITEM_CLASS_NAME,        --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
               MAX(T1.NICK_NAME)                        AS NICK_NAME,              --닉네임이 NULL인 경우가 있으므로 하나로 통일
               CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1   --타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
                             WHEN T1.ITEM_TYPE = 'H' THEN 2   --또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                             WHEN T1.ITEM_TYPE = 'Q' THEN 3
                             ELSE 4 END)
                   WHEN 1 THEN 'P'
                   WHEN 2 THEN 'H'
                   WHEN 3 THEN 'Q'
                   ELSE 'R' END                         AS ITEM_TYPE,
               MAX(T1.MATERIAL_CLASS_NAME)              AS MATERIAL_CLASS_NAME,
               MAX(T1.ITEM_UOM)                         AS ITEM_UOM,
               MAX(T1.SPEC)                             AS SPEC,
               MAX(T1.MDM_PROJECT_NAME)                 AS MDM_PROJECT_NAME,
               MAX(T1.MIN_CAPACITY)                     AS MIN_CAPACITY,
               MAX(T2.FORECAST_INFO_BIZ_TYPE)           AS FORECAST_INFO_BIZ_TYPE,
               MAX(T2.FORECAST_INFO_PRODUCT_GROUP)      AS FORECAST_INFO_PRODUCT_GROUP,
               MAX(T2.FORECAST_INFO_CELL_MODEL)         AS FORECAST_INFO_CELL_MODEL,
               MAX(T2.FORECAST_INFO_CELL_PACK_COUNT)    AS FORECAST_INFO_CELL_PACK_COUNT,
               MAX(T2.FORECAST_INFO_SPEC)               AS FORECAST_INFO_SPEC,
               MAX(T2.FORECAST_INFOR_VERSION)           AS FORECAST_INFOR_VERSION,
               MAX(T1.ACTIVE_FLAG)                      AS ACTIVE_FLAG,     -- 20180720 ADD 'Y'대상중 1건 추출
               MAX(T2.CELL_TYPE)                        AS CELL_TYPE,       -- 20180911 ADD cell_type
               MAX(T1.ENERGE)                           AS ENERGE,          -- 20200116 khsong ADD ENERGE
               MAX(T1.CELL_QUANTITY)                    AS CELL_QUANTITY,   -- 20200116 khsong ADD CELL_QUANTITY
               MAX(T1.SCP_EXTRA_SPEC)                   AS SCP_EXTRA_SPEC   -- [20210428 SJHAN / CSR ID:C20210323-000420]
        FROM SCM_MGR.SCM_MST_ITEM_SN T1
        INNER JOIN (
                       SELECT DIVISION_ID
                            , SUBSTR(ITEM_ID, 1, 12)                    AS ITEM_ID
                            , MAX(FORECAST_INFO_BIZ_TYPE)               AS FORECAST_INFO_BIZ_TYPE
                            , MAX(FORECAST_INFO_PRODUCT_GROUP)          AS FORECAST_INFO_PRODUCT_GROUP
                            , MAX(FORECAST_INFO_CELL_MODEL)             AS FORECAST_INFO_CELL_MODEL
                            , MAX(FORECAST_INFO_CELL_PACK_COUNT)        AS FORECAST_INFO_CELL_PACK_COUNT
                            , MAX(FORECAST_INFO_SPEC)                   AS FORECAST_INFO_SPEC
                            , MAX(FORECAST_INFOR_VERSION)               AS FORECAST_INFOR_VERSION
                            , MAX(CELL_TYPE)                            AS CELL_TYPE
                       FROM SCM_MGR.SCM_MST_ITEM_SN T2
                       GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
                   ) T2
               ON T1.DIVISION_ID = T2.DIVISION_ID
              AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
        WHERE T1.DIVISION_ID = P_DIVISION_ID
          AND T1.ACTIVE_FLAG = 'Y'
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ) T2
    WHERE DIVISION_ID = P_DIVISION_ID
    GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE,
             MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP,
             FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC,
             FORECAST_INFOR_VERSION, CELL_TYPE, ENERGE, CELL_QUANTITY;

    DBMS_OUTPUT.PUT_LINE('C--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -- GTT JOIN에 사용되므로 통계수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM68_ORD_ITEM_SINGLE_V', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DM68_ORD_ITEM_SINGLE_V',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --2.'Cell/Pack Count' 수량 없을 시 DM_BIZ_TYPE_40 룩업에서 동일한 모델코드의 'CELL_PACK_COUNT'의 수량 곱한 값을 표출(모듈 Biz 中 별도 룩업관리 건)
    INSERT INTO SCM_MGR.GT_DM68_ORD_CELL_PACK_COUNT
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE,
        MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP,
        FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC,
        FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT F.DIVISION_ID, F.ITEM_ID, F.ITEM_NAME, F.ITEM_CLASS, F.ITEM_CLASS_NAME, F.NICK_NAME, F.ITEM_TYPE,
           F.MDM_PROJECT_NAME, F.MIN_CAPACITY, F.FORECAST_INFO_BIZ_TYPE, F.FORECAST_INFO_PRODUCT_GROUP,
           F.FORECAST_INFO_CELL_MODEL,
           CASE WHEN F.ITEM_ID = LOOKA.MODEL AND F.FORECAST_INFO_CELL_PACK_COUNT = 0
                THEN LOOKA.CELL_PACK_COUNT
                ELSE F.FORECAST_INFO_CELL_PACK_COUNT
           END AS FORECAST_INFO_CELL_PACK_COUNT,
           F.FORECAST_INFO_SPEC, F.FORECAST_INFOR_VERSION, F.CELL_TYPE
    FROM SCM_MGR.GT_DM68_ORD_ITEM_SINGLE_V F
    LEFT JOIN (
                  SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
                  FROM (
                           SELECT SEGMENT2 AS MODEL
                                , SEGMENT3 AS BIZ_TYPE
                                , TO_NUMBER(SEGMENT4) AS CELL_PACK_COUNT
                                , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                           FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                           WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
                             AND SEGMENT1 = '40'
                       ) A
                  WHERE MODEL_RANK = 1
              ) LOOKA
           ON LOOKA.MODEL = F.ITEM_ID;

    DBMS_OUTPUT.PUT_LINE('D--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    -- GTT JOIN에 사용되므로 통계수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM68_ORD_CELL_PACK_COUNT', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DM68_ORD_CELL_PACK_COUNT',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --3. Business Plan 화면의 'Cell/Pack Count' 수량이 0 이면 'RTF(R+P)', 'Business Plan' 값을 0으로 표출 (상품 매출)
    --4. 3번의 'Cell/Pack Count'수량이 0이이지만 Item Type= Semi-Product라면, 'RTF(R+P)','Business Plan'값을 그대로 표출 (전극 Biz)
    INSERT INTO SCM_MGR.GT_DM68_ORD_PJTIFO
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, PROJECT_INFO, ITEM_TYPE, CELL_QTY
    )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_INFO, B.ITEM_TYPE
         , CASE WHEN B.ITEM_TYPE = 'H' AND B.FORECAST_INFO_CELL_PACK_COUNT = 0 THEN 1
                ELSE B.FORECAST_INFO_CELL_PACK_COUNT
           END AS CELL_QTY
    FROM SCM_MGR.SCM_MST_SITE_ITEM A
    LEFT OUTER JOIN SCM_MGR.GT_DM68_ORD_CELL_PACK_COUNT B
                 ON A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.ITEM_ID
    WHERE A.PROJECT_INFO IS NOT NULL   -- 2026-07-29 정정: Oracle 은 '' = NULL 이라 원식은 항상 FALSE
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_INFO,
             B.ITEM_TYPE, B.FORECAST_INFO_CELL_PACK_COUNT;
    ---------------------------------------------------------------------------------------------------------------------------------

    -- GTT JOIN에 사용되므로 통계수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM68_ORD_PJTIFO', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DM68_ORD_PJTIFO',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --REPORT TYPE: R_S
    IF SUBSTR(P_VERSION_NO, 1, 3) = 'R_S' THEN

        DBMS_OUTPUT.PUT_LINE('E--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        --구분: SALES_PLAN
        --해당조건으로 데이터를 구하는 이유는, 소형수주 수주기간외의 데이터는 표출하지 않기때문에, 해당 조건으로 데이터를 표출한다.
        --SRESULT: 소형수주 수주기간내 전체 SUM / SPLAN: 소형수주 수주기간내 전체 PLAN
        --계획구간: DM_PLN_SALES_PLAN_C / 실적구간: DM_PLN_SALES_PLAN_RESULT
        INSERT INTO SCM_MGR.GT_DM68_ORD_SRESULT_SPLAN
        (
            DIVISION_ID, PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, MEASURE, YYYYMM, GUBUN, SRESULT, SPLAN, QTY
        )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.YYYYMM_FROM, A.YYYYMM_TO, A.MEASURE, T.YYYYMM
             , T.GUBUN, SUM(T.SRESULT) AS SRESULT, SUM(T.SPLAN) AS SPLAN, SUM(T.QTY) AS QTY
        FROM
        (
            SELECT B.DIVISION_ID, B.PROJECT_CODE, B.YYYYMM_FROM, B.YYYYMM_TO
                 , CASE WHEN B.MEASURE = 'MEA_1' THEN 'RTF_SYS_RP' ELSE B.MEASURE END AS MEASURE
            FROM SCM_MGR.DM_PLN_ORDER_MGT B
        ) A
        LEFT OUTER JOIN (
                            --수주기간별 데이터 추출 목적
                            SELECT 'PLAN' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, B.MEASURE, SUBSTR(B.YYYYMMDD, 1, 6) AS YYYYMM
                                 , 0 AS SRESULT
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS SPLAN
                                 , 0 AS QTY
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_C B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW')
                              AND B.VERSION_NO = V_ORI_VERSION_NO
                            UNION ALL
                            --월별 데이터 추출 목적
                            SELECT 'PLAN' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, B.MEASURE, SUBSTR(B.YYYYMMDD, 1, 6) AS YYYYMM
                                 , 0 AS SRESULT
                                 , 0 AS SPLAN
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS QTY
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_C B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW')
                              AND B.VERSION_NO = V_ORI_VERSION_NO
                              AND SUBSTR(B.YYYYMMDD, 1, 6) BETWEEN V_NOW_YYYYMM AND P_TODT
                            UNION ALL
                            --수주기간별 데이터 추출 목적
                            SELECT 'RESULT' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, B.MEASURE, SUBSTR(B.YYYYMMDD, 1, 6) AS YYYYMM
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS SRESULT
                                 , 0 AS SPLAN
                                 , 0 AS QTY
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW')
                            UNION ALL
                            --월별 데이터 추출 목적
                            SELECT 'RESULT' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, B.MEASURE, SUBSTR(B.YYYYMMDD, 1, 6) AS YYYYMM
                                 , 0 AS SRESULT
                                 , 0 AS SPLAN
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS QTY
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW')
                              AND SUBSTR(B.YYYYMMDD, 1, 6) BETWEEN P_FROMDT AND V_LAST_YYYYMM
                        ) T
                     ON A.DIVISION_ID   = T.DIVISION_ID
                    AND A.MEASURE       = T.MEASURE
                    AND A.PROJECT_CODE  = T.PROJECT_INFO
                    AND T.YYYYMM       >= A.YYYYMM_FROM
                    AND T.YYYYMM       <= A.YYYYMM_TO
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.YYYYMM_FROM, A.YYYYMM_TO, A.MEASURE, T.YYYYMM, T.GUBUN
        ORDER BY A.DIVISION_ID, A.PROJECT_CODE, A.YYYYMM_FROM, A.YYYYMM_TO, A.MEASURE, T.YYYYMM;

        DBMS_OUTPUT.PUT_LINE('F--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        -- GTT PIVOT 소스로 사용되므로 통계수집
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM68_ORD_SRESULT_SPLAN', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_DM68_ORD_SRESULT_SPLAN',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        -- Oracle PIVOT은 정적 컬럼만 지원하므로 Dynamic SQL로 처리
        -- MSSQL PIVOT([V_PV_LIST]) → Oracle XML PIVOT 또는 Dynamic SQL 동일 방식 적용
        V_SQL_TEXT :=
            'SELECT B.PROJECT_NAME                  --Project' || CHR(10) ||
            '     , CASE WHEN B.MEASURE = ''RTF_SYS_RP'' THEN ''QTY(Cell)'' ELSE ''Sales Amt.(KRW)'' END AS MEASURE  --MEASURE' || CHR(10) ||
            '     , B.ORDERSTART                    --수주기간(시작)' || CHR(10) ||
            '     , B.ORDEREND                      --수주기간(종료)' || CHR(10) ||
            '     , B.ORDERAPPROVAL                 --수주(품의)' || CHR(10) ||
            '     , B.ORDERNOW                      --수주(현재)' || CHR(10) ||
            '     , B.SRESULT                       --실적' || CHR(10) ||
            '     , B.SPLAN                         --계획' || CHR(10) ||
            '     , B.ORDERNOW - B.SRESULT AS STOCK          --잔고(실적기준)' || CHR(10) ||
            '     , B.ORDERNOW - B.SRESULT - B.SPLAN AS STOCK2  --잔고(실적+계획 기준)' || CHR(10) ||
            '     , B.ATTRIBUTE1  AS KEYVALUE' || CHR(10) ||
            '     , B.ATTRIBUTE2  AS KEYVALUE2' || CHR(10) ||
            '     , B.MEASURE2' || CHR(10) ||
            '     , B.EDIT_YN' || CHR(10) ||
            '     , ' || V_PV_COL_LIST || CHR(10) ||
            'FROM' || CHR(10) ||
            '(' || CHR(10) ||
            '    SELECT A.PROJECT_CODE, A.PROJECT_CODE AS PROJECT_NAME, A.YYYYMM_FROM AS ORDERSTART, A.YYYYMM_TO AS ORDEREND' || CHR(10) ||
            '         , NVL(A.ORDER_APPROVAL, 0) AS ORDERAPPROVAL, NVL(A.ORDER_NOW, 0) AS ORDERNOW' || CHR(10) ||
            '         , A.MEASURE, A.MEASURE2, NVL(T.SRESULT, 0) AS SRESULT, NVL(T.SPLAN, 0) AS SPLAN' || CHR(10) ||
            '         , A.ATTRIBUTE1' || CHR(10) ||
            '         , A.ATTRIBUTE2' || CHR(10) ||
            '         , A.EDIT_YN' || CHR(10) ||
            '         , ' || V_PV_LIST || CHR(10) ||
            '    FROM' || CHR(10) ||
            '    (' || CHR(10) ||
            '        SELECT A.PROJECT_CODE, A.PROJECT_CODE AS PROJECT_NAME, A.YYYYMM_FROM, A.YYYYMM_TO, A.ORDER_APPROVAL, A.ORDER_NOW' || CHR(10) ||
            '             , CASE WHEN A.MEASURE = ''MEA_1'' THEN ''RTF_SYS_RP'' ELSE A.MEASURE END AS MEASURE' || CHR(10) ||
            '             , CASE WHEN A.MEASURE = ''MEA_1'' THEN ''RTF_SYS_RP'' ELSE A.MEASURE END AS MEASURE2' || CHR(10) ||
            '             , A.ATTRIBUTE1' || CHR(10) ||
            '             , A.ATTRIBUTE2' || CHR(10) ||
            '             , NVL(EDY.EDIT_YN, ''N'') AS EDIT_YN' || CHR(10) ||
            '        FROM SCM_MGR.DM_PLN_ORDER_MGT A' || CHR(10) ||
            '             LEFT OUTER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY' || CHR(10) ||
            '                  ON EDY.USER_ID = ''' || P_USER_ID || '''' || CHR(10) ||
            '                 AND EDY.MNU_ID  = ''' ||P_MENU_ID || '''' || CHR(10) ||
            '                 AND EDY.UNIT_ID = A.DIVISION_ID ' || CHR(10) ||
            '    ) A' || CHR(10) ||
            '    LEFT OUTER JOIN (' || CHR(10) ||
            '        SELECT PROJECT_CODE, MEASURE, ' || V_PV_LIST || CHR(10) ||
            '        FROM (' || CHR(10) ||
            '            SELECT PROJECT_CODE, MEASURE, YYYYMM, SUM(NVL(QTY, 0)) AS QTY' || CHR(10) ||
            '            FROM SCM_MGR.GT_DM68_ORD_SRESULT_SPLAN' || CHR(10) ||
            '            GROUP BY PROJECT_CODE, MEASURE, YYYYMM' || CHR(10) ||
            '        ) A' || CHR(10) ||
            '        PIVOT (SUM(QTY) FOR YYYYMM IN (' || V_PV_IN_LIST || '))' || CHR(10) ||
            '    ) RESULT ON A.MEASURE = RESULT.MEASURE AND A.PROJECT_CODE = RESULT.PROJECT_CODE' || CHR(10) ||
            '    LEFT OUTER JOIN (' || CHR(10) ||
            '        SELECT PROJECT_CODE, MEASURE, SUM(SRESULT) AS SRESULT, SUM(SPLAN) AS SPLAN' || CHR(10) ||
            '        FROM SCM_MGR.GT_DM68_ORD_SRESULT_SPLAN' || CHR(10) ||
            '        GROUP BY PROJECT_CODE, MEASURE' || CHR(10) ||
            '    ) T ON A.MEASURE = T.MEASURE AND A.PROJECT_CODE = T.PROJECT_CODE' || CHR(10) ||
            ') B' || CHR(10) ||
            'ORDER BY B.PROJECT_NAME, NVL(ORDERSTART, ''999999''), B.MEASURE';

    ELSE

        DBMS_OUTPUT.PUT_LINE('G--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        --구분: BIZ_PLAN
        --해당조건으로 데이터를 구하는 이유는, 소형수주 수주기간외의 데이터는 표출하지 않기때문에, 해당 조건으로 데이터를 표출한다.
        --SRESULT: 소형수주 수주기간내 전체 SUM / SPLAN: 소형수주 수주기간내 전체 PLAN
        --계획구간: DM_PLN_BP_FCST_C / 실적구간: DM_PLN_SALES_PLAN_RESULT
        INSERT INTO SCM_MGR.GT_DM68_ORD_BRESULT_BPLAN
        (
            DIVISION_ID, PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, MEASURE, YYYYMM, GUBUN, SRESULT, SPLAN, QTY
        )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.YYYYMM_FROM, A.YYYYMM_TO, A.MEASURE, T.YYYYMM
             , T.GUBUN, SUM(T.SRESULT) AS SRESULT, SUM(T.SPLAN) AS SPLAN, SUM(T.QTY) AS QTY
        FROM
        (
            SELECT B.DIVISION_ID, B.PROJECT_CODE, B.YYYYMM_FROM, B.YYYYMM_TO
                 , CASE WHEN B.MEASURE = 'MEA_1' THEN 'Business_Plan' ELSE B.MEASURE END AS MEASURE
            FROM SCM_MGR.DM_PLN_ORDER_MGT B
        ) A
        LEFT OUTER JOIN (
                            --수주기간별 데이터 추출 목적
                            SELECT 'PLAN' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, '' AS ORG_MEASURE, B.YYYYMM
                                 , 0 AS SRESULT
                                 , CASE WHEN B.MEASURE = 'Business_Plan' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS SPLAN
                                 , 0 AS QTY
                                 , B.MEASURE
                            FROM SCM_MGR.DM_PLN_BP_FCST_C B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('Business_Plan', 'SalesAmt_KRW')
                              AND B.VERSION_NO = V_ORI_VERSION_NO
                            UNION ALL
                            --월별 데이터 추출 목적
                            SELECT 'PLAN' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, '' AS ORG_MEASURE, B.YYYYMM
                                 , 0 AS SRESULT
                                 , 0 AS SPLAN
                                 , CASE WHEN B.MEASURE = 'Business_Plan' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS QTY
                                 , B.MEASURE
                            FROM SCM_MGR.DM_PLN_BP_FCST_C B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('Business_Plan', 'SalesAmt_KRW')
                              AND B.VERSION_NO = V_ORI_VERSION_NO
                              AND B.YYYYMM BETWEEN V_NOW_YYYYMM AND P_TODT
                            UNION ALL
                            --수주기간별 데이터 추출 목적
                            SELECT 'RESULT' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, B.MEASURE AS ORG_MEASURE, SUBSTR(B.YYYYMMDD, 1, 6) AS YYYYMM
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS SRESULT
                                 , 0 AS SPLAN
                                 , 0 AS QTY
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN 'Business_Plan' ELSE 'SalesAmt_KRW' END AS MEASURE
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW')
                            UNION ALL
                            --월별 데이터 추출 목적
                            SELECT 'RESULT' AS GUBUN, B.DIVISION_ID, B.PROJECT_CODE, PJT_IFO.PROJECT_INFO, B.SCM_SITE_ID, B.ITEM_ID, B.MEASURE AS ORG_MEASURE, SUBSTR(B.YYYYMMDD, 1, 6) AS YYYYMM
                                 , 0 AS SRESULT
                                 , 0 AS SPLAN
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN B.QTY * PJT_IFO.CELL_QTY ELSE B.QTY END AS QTY
                                 , CASE WHEN B.MEASURE = 'RTF_SYS_RP' THEN 'Business_Plan' ELSE 'SalesAmt_KRW' END AS MEASURE
                            FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT B
                            INNER JOIN SCM_MGR.GT_DM68_ORD_PJTIFO PJT_IFO
                                    ON B.PROJECT_CODE = PJT_IFO.PROJECT_CODE
                                   AND B.ITEM_ID      = PJT_IFO.ITEM_ID
                                   AND B.SCM_SITE_ID  = PJT_IFO.SCM_SITE_ID
                            WHERE B.DIVISION_ID = P_DIVISION_ID
                              AND B.MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW')
                              AND SUBSTR(B.YYYYMMDD, 1, 6) BETWEEN P_FROMDT AND V_LAST_YYYYMM
                        ) T
                     ON A.DIVISION_ID   = T.DIVISION_ID
                    AND A.MEASURE       = T.MEASURE
                    AND A.PROJECT_CODE  = T.PROJECT_INFO
                    AND T.YYYYMM       >= A.YYYYMM_FROM
                    AND T.YYYYMM       <= A.YYYYMM_TO
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.YYYYMM_FROM, A.YYYYMM_TO, A.MEASURE, T.YYYYMM, T.GUBUN
        ORDER BY A.DIVISION_ID, A.PROJECT_CODE, A.YYYYMM_FROM, A.YYYYMM_TO, A.MEASURE, T.YYYYMM;

        DBMS_OUTPUT.PUT_LINE('F--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        -- GTT PIVOT 소스로 사용되므로 통계수집
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM68_ORD_BRESULT_BPLAN', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR',
            tabname          => 'GT_DM68_ORD_BRESULT_BPLAN',
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        V_SQL_TEXT :=
            'SELECT B.PROJECT_NAME                  --Project' || CHR(10) ||
            '     , CASE WHEN B.MEASURE = ''Business_Plan'' THEN ''QTY(Cell)'' ELSE ''Sales Amt.(KRW)'' END AS MEASURE' || CHR(10) ||
            '     , B.ORDERSTART                    --수주기간(시작)' || CHR(10) ||
            '     , B.ORDEREND                      --수주기간(종료)' || CHR(10) ||
            '     , B.ORDERAPPROVAL                 --수주(품의)' || CHR(10) ||
            '     , B.ORDERNOW                      --수주(현재)' || CHR(10) ||
            '     , B.SRESULT                       --실적' || CHR(10) ||
            '     , B.SPLAN                         --계획' || CHR(10) ||
            '     , B.ORDERNOW - B.SRESULT AS STOCK          --잔고(실적기준)' || CHR(10) ||
            '     , B.ORDERNOW - B.SRESULT - B.SPLAN AS STOCK2  --잔고(실적+계획 기준)' || CHR(10) ||
            '     , B.ATTRIBUTE1 AS KEYVALUE' || CHR(10) ||
            '     , B.ATTRIBUTE2 AS KEYVALUE2' || CHR(10) ||
            '     , B.MEASURE2' || CHR(10) ||
            '     , B.EDIT_YN' || CHR(10) ||
            '     , ' || V_PV_COL_LIST || CHR(10) ||
            'FROM' || CHR(10) ||
            '(' || CHR(10) ||
            '    SELECT A.PROJECT_CODE, A.PROJECT_CODE AS PROJECT_NAME, A.YYYYMM_FROM AS ORDERSTART, A.YYYYMM_TO AS ORDEREND' || CHR(10) ||
            '         , A.ORDER_APPROVAL AS ORDERAPPROVAL, A.ORDER_NOW AS ORDERNOW' || CHR(10) ||
            '         , A.MEASURE, A.MEASURE2, NVL(T.SRESULT, 0) AS SRESULT, NVL(T.SPLAN, 0) AS SPLAN' || CHR(10) ||
            '         , A.ATTRIBUTE1' || CHR(10) ||
            '         , A.ATTRIBUTE2' || CHR(10) ||
            '         , A.EDIT_YN' || CHR(10) ||
            '         , ' || V_PV_LIST || CHR(10) ||
            '    FROM' || CHR(10) ||
            '    (' || CHR(10) ||
            '        SELECT A.PROJECT_CODE, A.PROJECT_CODE AS PROJECT_NAME, A.YYYYMM_FROM, A.YYYYMM_TO, A.ORDER_APPROVAL, A.ORDER_NOW' || CHR(10) ||
            '             , CASE WHEN A.MEASURE = ''MEA_1'' THEN ''Business_Plan'' ELSE A.MEASURE END AS MEASURE' || CHR(10) ||
            '             , CASE WHEN A.MEASURE = ''MEA_1'' THEN ''RTF_SYS_RP'' ELSE A.MEASURE END AS MEASURE2' || CHR(10) ||
            '             , A.ATTRIBUTE1' || CHR(10) ||
            '             , A.ATTRIBUTE2' || CHR(10) ||
            '             , NVL(EDY.EDIT_YN, ''N'') AS EDIT_YN' || CHR(10) ||
            '        FROM SCM_MGR.DM_PLN_ORDER_MGT A' || CHR(10) ||
            '             LEFT OUTER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY ' || CHR(10) ||
            '                  ON EDY.USER_ID = ''' || P_USER_ID || '''' || CHR(10) ||
            '                 AND EDY.MNU_ID  = ''' ||P_MENU_ID || '''' || CHR(10) ||
            '                 AND EDY.UNIT_ID = A.DIVISION_ID ' || CHR(10) ||
            '    ) A' || CHR(10) ||
            '    LEFT OUTER JOIN (' || CHR(10) ||
            '        SELECT PROJECT_CODE, MEASURE, ' || V_PV_LIST || CHR(10) ||
            '        FROM (' || CHR(10) ||
            '            SELECT PROJECT_CODE, MEASURE, YYYYMM, SUM(QTY) AS QTY' || CHR(10) ||
            '            FROM SCM_MGR.GT_DM68_ORD_BRESULT_BPLAN' || CHR(10) ||
            '            GROUP BY PROJECT_CODE, MEASURE, YYYYMM' || CHR(10) ||
            '        ) A' || CHR(10) ||
            '        PIVOT (SUM(QTY) FOR YYYYMM IN (' || V_PV_IN_LIST || '))' || CHR(10) ||
            '    ) RESULT ON A.MEASURE = RESULT.MEASURE AND A.PROJECT_CODE = RESULT.PROJECT_CODE' || CHR(10) ||
            '    LEFT OUTER JOIN (' || CHR(10) ||
            '        SELECT PROJECT_CODE, MEASURE, SUM(SRESULT) AS SRESULT, SUM(SPLAN) AS SPLAN' || CHR(10) ||
            '        FROM SCM_MGR.GT_DM68_ORD_BRESULT_BPLAN' || CHR(10) ||
            '        GROUP BY PROJECT_CODE, MEASURE' || CHR(10) ||
            '    ) T ON A.MEASURE = T.MEASURE AND A.PROJECT_CODE = T.PROJECT_CODE' || CHR(10) ||
            ') B' || CHR(10) ||
            'ORDER BY B.PROJECT_NAME, NVL(ORDERSTART, ''999999''), B.MEASURE';

    END IF;

    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.PUT_LINE('======================================');
    DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);

    -- Dynamic SQL 결과를 O_RC1으로 반환
    OPEN O_RC1 FOR V_SQL_TEXT;

    -- Dynamic SQL 텍스트를 O_RC2로 반환 (MSSQL의 SELECT CONVERT(TEXT,...) FOR XML PATH 대체)
    OPEN O_RC2 FOR
        SELECT V_SQL_TEXT AS SQL_TEXT FROM DUAL;

    -- 결과코드 반환
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
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_VERSION_NO'  VALUE P_VERSION_NO,
            'P_FROMDT'      VALUE P_FROMDT,
            'P_TODT'        VALUE P_TODT,
            'P_USER_ID'     VALUE P_USER_ID,
            'P_MENU_ID'     VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

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
END P_DMF0068_GET_ORDERLIST;

PROCEDURE P_DMF0068_SAVE_ORDERLIST
(
    P_DMF0068         IN  T_DMF0068_TAB,
    P_USER_ID         IN  VARCHAR2,
    P_DIVISION_ID     IN  VARCHAR2,
    P_VERSION_NO      IN  VARCHAR2,

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0068_SAVE_ORDERLIST]
 * Description  : 소형 수주관리 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/010/03   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 소형 수주관리 수정
 */
IS
    -- LOG 용 변수 설정
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     PLS_INTEGER     := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE            := SYSDATE;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    -- 예외처리 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);

    ROWCNT              PLS_INTEGER := 0;

    -- CURSOR 변수 (Validation / ATTRIBUTE2 처리)
    CUR_PROJECT_CODE    VARCHAR2(4000 CHAR);
    CUR_MEASURE         VARCHAR2(4000 CHAR);
    CUR_FROM            VARCHAR2(4000 CHAR);
    CUR_TO              VARCHAR2(4000 CHAR);
    CUR_ATTRIBUTE1      VARCHAR2(4000 CHAR);
    CUR_FROM2           VARCHAR2(4000 CHAR);
    CUR_TO2             VARCHAR2(4000 CHAR);
    CUR_ATTRIBUTE2      VARCHAR2(4000 CHAR);

    V_DUP               VARCHAR2(4000 CHAR) := '';
    V_EXISTS            PLS_INTEGER;
    V_ATTRIBUTE2_VAL    VARCHAR2(100 CHAR);

    -- CURSOR 선언
    CURSOR CUR IS
        SELECT PROJECT_CODE, MEASURE, YYYYMM_FROM, YYYYMM_TO, ATTRIBUTE1
        FROM TABLE(P_DMF0068);

    CURSOR CUR2 IS
        SELECT PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, ATTRIBUTE1
        FROM SCM_MGR.DM_PLN_ORDER_MGT
        WHERE NVL(ATTRIBUTE2, '@#@#@#') = '@#@#@#';

    CURSOR CUR3 IS
        SELECT YYYYMM_FROM, YYYYMM_TO, ATTRIBUTE1, ATTRIBUTE2
        FROM SCM_MGR.DM_PLN_ORDER_MGT
        WHERE ATTRIBUTE3 IS NOT NULL
          AND ATTRIBUTE4 IS NOT NULL
          AND (YYYYMM_FROM <> ATTRIBUTE3 OR YYYYMM_TO <> ATTRIBUTE4); --날짜가 변경됐는지 여부

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    ------------------------------------------------------------------------------------------------------------------
    /*
    입력 기간 validation 체크
    -날짜가 겹치면 안됨
    1.수주종료일이 시작일 보다 같거나 크면 리턴
    2.수주시작일이 종료일보다 같거나 작으면 리턴
    */
    ------------------------------------------------------------------------------------------------------------------

    V_DUP := '';

    OPEN CUR;
    LOOP
        FETCH CUR INTO CUR_PROJECT_CODE, CUR_MEASURE, CUR_FROM, CUR_TO, CUR_ATTRIBUTE1;
        EXIT WHEN CUR%NOTFOUND;

        -- DB 기존 데이터와 기간 중복 여부 확인
        BEGIN
            SELECT 1
            INTO   V_EXISTS
            FROM   DUAL
            WHERE  EXISTS (
                       SELECT 1
                       FROM   SCM_MGR.DM_PLN_ORDER_MGT
                       WHERE  DIVISION_ID    = P_DIVISION_ID
                              --AND VERSION_NO = P_VERSION_NO : --필수값에서 제거..필드 삭제할까?
                          AND PROJECT_CODE   = CUR_PROJECT_CODE
                          AND MEASURE        = CUR_MEASURE
                          AND ATTRIBUTE1     <> CUR_ATTRIBUTE1  -- 자기자신의 날짜는 제외
                          AND CUR_TO        >= YYYYMM_FROM
                          AND CUR_FROM      <= YYYYMM_TO
                   );
            V_DUP := 'DUPLICATE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

        -- @DMF0068 자체에서도 중복 잇나 확인
        -- 로직 검증 필요
        BEGIN
            SELECT 1
            INTO   V_EXISTS
            FROM   DUAL
            WHERE  EXISTS (
                       SELECT 1
                       FROM   TABLE(P_DMF0068)
                       WHERE  PROJECT_CODE = CUR_PROJECT_CODE
                          AND MEASURE      = CUR_MEASURE
                          AND ATTRIBUTE1  <> CUR_ATTRIBUTE1  -- 자기자신의 날짜는 제외
                          AND CUR_TO      >= YYYYMM_FROM
                          AND CUR_FROM    <= YYYYMM_TO
                   );
            V_DUP := 'DUPLICATE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

    END LOOP;
    CLOSE CUR;

    IF V_DUP = 'DUPLICATE' THEN

        --SET @v_log_type = 'END';
        --SET @v_log_message = '########## END of procedure ##########';
        --SET @v_description = '';
        --SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        OPEN O_RESULT_CURSOR FOR
            SELECT 'DUPLICATE' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, 'DATE DUPLICATE' AS EVENT FROM DUAL;
        RETURN;

    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -------------------------------------------------

    MERGE INTO SCM_MGR.DM_PLN_ORDER_MGT A
    USING (SELECT * FROM TABLE(P_DMF0068)) B
       ON (A.ATTRIBUTE1 = B.ATTRIBUTE1)
     WHEN MATCHED THEN
         UPDATE SET
             A.ATTRIBUTE3        = A.YYYYMM_FROM  --날짜 변경했나 여부 확인 위해 변경전 날짜 저장
           , A.ATTRIBUTE4        = A.YYYYMM_TO
           , A.YYYYMM_FROM       = B.YYYYMM_FROM
           , A.YYYYMM_TO         = B.YYYYMM_TO
           , A.ORDER_APPROVAL    = B.ORDER_APPROVAL
           , A.ORDER_NOW         = B.ORDER_NOW
           , A.LAST_UPDATED_BY   = P_USER_ID
           , A.LAST_UPDATE_DATE  = SYSDATE
     WHEN NOT MATCHED THEN
         INSERT (
             DIVISION_ID
           --,VERSION_NO
           , PROJECT_CODE
           , YYYYMM_FROM
           , YYYYMM_TO
           , MEASURE
           , ORDER_APPROVAL
           , ORDER_NOW
           , CREATED_BY
           , CREATION_DATE
           , LAST_UPDATED_BY
           , LAST_UPDATE_DATE
           , ATTRIBUTE1
           , ATTRIBUTE2
         )
         VALUES (
             P_DIVISION_ID
           --,P_VERSION_NO
           , B.PROJECT_CODE
           , B.YYYYMM_FROM
           , B.YYYYMM_TO
           , B.MEASURE
           , B.ORDER_APPROVAL
           , B.ORDER_NOW
           , P_USER_ID
           , SYSDATE
           , P_USER_ID
           , SYSDATE
           , SYS_GUID()                    --자기자신 고유값
           , B.ATTRIBUTE2                  --소속된 메저그룹 고유값
           /* ,CASE WHEN NVL(B.ATTRIBUTE2, '') <> '' THEN B.ATTRIBUTE2
               ELSE
                   CASE WHEN (SELECT COUNT(*) FROM DM_PLN_ORDER_MGT
                           WHERE DIVISION_ID = P_DIVISION_ID
                           AND VERSION_NO = P_VERSION_NO
                           AND PROJECT_CODE = B.PROJECT_CODE
                           AND YYYYMM_FROM = B.YYYYMM_FROM
                           AND YYYYMM_TO = B.YYYYMM_TO) > 0
                       THEN
                           (
                               SELECT CASE WHEN NVL(ATTRIBUTE2, '') = '' THEN RAWTOHEX(SYS_GUID()) ELSE ATTRIBUTE2 END
                               FROM   (
                                          SELECT ATTRIBUTE2, ROWNUM AS RN
                                          FROM DM_PLN_ORDER_MGT
                                          WHERE DIVISION_ID = P_DIVISION_ID
                                          AND VERSION_NO = P_VERSION_NO
                                          AND PROJECT_CODE = B.PROJECT_CODE
                                          AND YYYYMM_FROM = B.YYYYMM_FROM
                                          AND YYYYMM_TO = B.YYYYMM_TO
                                          AND ROWNUM = 1
                                      )
                           )
                       ELSE RAWTOHEX(SYS_GUID())
                   END
               END
           */
         );

    ROWCNT := SQL%ROWCOUNT;

    --------------------------------------------------------------------------------------------------------------------------------------------
    /*
    수정모드(M)이나 실제로는 신규일 경우 ATTRIBUTE2(2쌍의 메저별 고유 값) 이 없음
    따라서 ATTRIBUTE2 값이 없는 데이터 조회하여
        DIVISION_ID . VERSION_NO, PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO
    가 같은 게 있으면 그 데이터의 ATTRIBUTE2로 저장
    없으면 newid 생성
    =>단일 쿼리로 안되어 커서로 처리
    */
    --------------------------------------------------------------------------------------------------------------------------------------------

    OPEN CUR2;
    LOOP
        FETCH CUR2 INTO CUR_PROJECT_CODE, CUR_FROM, CUR_TO, CUR_ATTRIBUTE1;
        EXIT WHEN CUR2%NOTFOUND;

        BEGIN
            SELECT 1
            INTO   V_EXISTS
            FROM   DUAL
            WHERE  EXISTS (
                       SELECT 1
                       FROM   SCM_MGR.DM_PLN_ORDER_MGT
                       WHERE  DIVISION_ID    = P_DIVISION_ID
                              --AND VERSION_NO = P_VERSION_NO
                          AND PROJECT_CODE   = CUR_PROJECT_CODE
                          AND YYYYMM_FROM    = CUR_FROM
                          AND YYYYMM_TO      = CUR_TO
                   );

            -- 동일 프로젝트/기간 데이터가 존재하면 해당 ATTRIBUTE2 공유
            SELECT CASE WHEN NVL(ATTRIBUTE2, '@#@#@#') = '@#@#@#' THEN RAWTOHEX(SYS_GUID()) ELSE ATTRIBUTE2 END
            INTO   V_ATTRIBUTE2_VAL
            FROM   (
                       SELECT ATTRIBUTE2, ROWNUM AS RN
                       FROM   SCM_MGR.DM_PLN_ORDER_MGT
                       WHERE  DIVISION_ID    = P_DIVISION_ID
                              --AND VERSION_NO = P_VERSION_NO
                          AND PROJECT_CODE   = CUR_PROJECT_CODE
                          AND YYYYMM_FROM    = CUR_FROM
                          AND YYYYMM_TO      = CUR_TO
                          AND ROWNUM         = 1
                   );

            UPDATE SCM_MGR.DM_PLN_ORDER_MGT
            SET    ATTRIBUTE2 = V_ATTRIBUTE2_VAL
            WHERE  ATTRIBUTE1 = CUR_ATTRIBUTE1;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- 없으면 새 GUID 생성
                UPDATE DM_PLN_ORDER_MGT
                SET    ATTRIBUTE2 = RAWTOHEX(SYS_GUID())
                WHERE  ATTRIBUTE1 = CUR_ATTRIBUTE1;
        END;

    END LOOP;
    CLOSE CUR2;

    -----------------------------------------------------------------------------------

    --------------------------------------------------------------------------
    --수주기간 변경된 것들 있으면 쌍이되는 메저의 수주기간도 같이 변경한다
    --------------------------------------------------------------------------
    OPEN CUR3;
    LOOP
        FETCH CUR3 INTO CUR_FROM2, CUR_TO2, CUR_ATTRIBUTE1, CUR_ATTRIBUTE2;
        EXIT WHEN CUR3%NOTFOUND;

        UPDATE SCM_MGR.DM_PLN_ORDER_MGT
        SET    YYYYMM_FROM = CUR_FROM2
             , YYYYMM_TO   = CUR_TO2
        WHERE  ATTRIBUTE2  = CUR_ATTRIBUTE2   -- 같은 그룹
          AND  ATTRIBUTE1 <> CUR_ATTRIBUTE1;  --자기자신은 제외

    END LOOP;
    CLOSE CUR3;

    --중복처리 방지 위해 null 처리
    UPDATE DM_PLN_ORDER_MGT
    SET    ATTRIBUTE3 = NULL
         , ATTRIBUTE4 = NULL
    WHERE  ATTRIBUTE3 IS NOT NULL
      AND  ATTRIBUTE4 IS NOT NULL;

    -----------------------------------------------------------------------

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    COMMIT;

    -- 결과코드, 결과 카운트 반환
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(ROWCNT) AS EVENT FROM DUAL;

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
            'P_DMF0068'      VALUE F_COLLECTION_TO_JSON(P_DMF0068),
            'P_USER_ID'      VALUE P_USER_ID,
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_VERSION_NO'   VALUE P_VERSION_NO
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

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
END P_DMF0068_SAVE_ORDERLIST;

FUNCTION F_COLLECTION_TO_JSON(P_COLLECTION IN T_DMF0068_TAB)
RETURN VARCHAR2 IS
    l_json CLOB := '[]';
    l_elem_idx NUMBER;
BEGIN
    IF p_collection.COUNT > 0 THEN
        l_json := '[';
        FOR i IN 1 .. p_collection.COUNT LOOP
            IF i > 1 THEN
                l_json := l_json || ',';
            END IF;
            l_json := l_json || JSON_OBJECT(
                'DIVISION_ID'    VALUE p_collection(i).DIVISION_ID,
                'PROJECT_CODE'   VALUE p_collection(i).PROJECT_CODE,
                'YYYYMM_FROM'    VALUE p_collection(i).YYYYMM_FROM,
                'YYYYMM_TO'      VALUE p_collection(i).YYYYMM_TO,
                'MEASURE'        VALUE p_collection(i).MEASURE,
                'ORDER_APPROVAL' VALUE TO_CHAR(p_collection(i).ORDER_APPROVAL),
                'ORDER_NOW'      VALUE TO_CHAR(p_collection(i).ORDER_NOW),
                'ATTRIBUTE1'     VALUE p_collection(i).ATTRIBUTE1,
                'ATTRIBUTE2'     VALUE p_collection(i).ATTRIBUTE2
            );
        END LOOP;

        l_json := l_json || ']';
    END IF;
    RETURN l_json;
END F_COLLECTION_TO_JSON;


--------------------------------------------------------------------------------
-- 2026-07-29 신설 : CLOB(JSON) → T_DMF0068_TAB 변환 후 기존 멤버 위임
--------------------------------------------------------------------------------
FUNCTION F_JSON_TO_COLLECTION(P_DATA IN CLOB, P_DIVISION_ID IN VARCHAR2 DEFAULT NULL)
RETURN T_DMF0068_TAB IS
    V_TAB T_DMF0068_TAB := T_DMF0068_TAB();
BEGIN
    IF P_DATA IS NULL OR DBMS_LOB.GETLENGTH(P_DATA) = 0 THEN
        RETURN V_TAB;
    END IF;

    FOR R IN (
        SELECT DIVISION_ID, PROJECT_CODE, YYYYMM_FROM, YYYYMM_TO, MEASURE,
               ORDER_APPROVAL, ORDER_NOW, ATTRIBUTE1, ATTRIBUTE2
        FROM   JSON_TABLE(P_DATA, '$[*]'
                   COLUMNS (
                       DIVISION_ID    VARCHAR2(10)  PATH '$.DIVISION_ID',
                       PROJECT_CODE   VARCHAR2(200) PATH '$.PROJECT_CODE',
                       YYYYMM_FROM    VARCHAR2(6)   PATH '$.YYYYMM_FROM',
                       YYYYMM_TO      VARCHAR2(6)   PATH '$.YYYYMM_TO',
                       MEASURE        VARCHAR2(100) PATH '$.MEASURE',
                       ORDER_APPROVAL VARCHAR2(50)  PATH '$.ORDER_APPROVAL',
                       ORDER_NOW      VARCHAR2(50)  PATH '$.ORDER_NOW',
                       ATTRIBUTE1     VARCHAR2(100) PATH '$.ATTRIBUTE1',
                       ATTRIBUTE2     VARCHAR2(100) PATH '$.ATTRIBUTE2'
                   ))
    ) LOOP
        V_TAB.EXTEND;
        V_TAB(V_TAB.COUNT) := T_DMF0068_ROW(
            NVL(R.DIVISION_ID, P_DIVISION_ID),
            R.PROJECT_CODE,
            R.YYYYMM_FROM,
            R.YYYYMM_TO,
            R.MEASURE,
            TO_NUMBER(REPLACE(NVL(R.ORDER_APPROVAL, '0'), ',', '')),
            TO_NUMBER(REPLACE(NVL(R.ORDER_NOW, '0'), ',', '')),
            R.ATTRIBUTE1,
            R.ATTRIBUTE2
        );
    END LOOP;

    RETURN V_TAB;
END F_JSON_TO_COLLECTION;

PROCEDURE P_DMF0068_SAVE_ORDERLIST_JSON
(
    P_DATA            IN  CLOB,
    P_USER_ID         IN  VARCHAR2,
    P_DIVISION_ID     IN  VARCHAR2,
    P_VERSION_NO      IN  VARCHAR2,

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
IS
    V_TAB T_DMF0068_TAB;
BEGIN
    V_TAB := F_JSON_TO_COLLECTION(P_DATA, P_DIVISION_ID);

    IF V_TAB.COUNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    P_DMF0068_SAVE_ORDERLIST(V_TAB, P_USER_ID, P_DIVISION_ID, P_VERSION_NO, O_RESULT_CURSOR);
END P_DMF0068_SAVE_ORDERLIST_JSON;

PROCEDURE P_DMF0068_DEL_ORDERLIST_JSON
(
    P_DATA            IN  CLOB,

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
IS
    V_TAB T_DMF0068_TAB;
BEGIN
    V_TAB := F_JSON_TO_COLLECTION(P_DATA);

    IF V_TAB.COUNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    P_DMF0068_DEL_ORDERLIST(V_TAB, O_RESULT_CURSOR);
END P_DMF0068_DEL_ORDERLIST_JSON;

END PKG_DMF0068;
/
