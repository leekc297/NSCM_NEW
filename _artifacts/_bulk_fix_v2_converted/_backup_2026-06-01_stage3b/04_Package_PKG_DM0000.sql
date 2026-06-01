/*=============================================================================================
 * File         : 04_Package_PKG_DM0000.sql
 * Description  : Package — PKG_DM0000
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
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DM0000 IS
    /*
    * Program ID   : PKG_DM0000
    * Description  : PKG_DM0000
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DM0000_GET_COMMON_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_PROGRAM_ID     VARCHAR2
       ,P_SHEET_NAME     VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

END PKG_DM0000;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DM0000 IS

    PROCEDURE P_DM0000_GET_COMMON_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_PROGRAM_ID     VARCHAR2
       ,P_SHEET_NAME     VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    /*****************************************************************************************************
         ※ 작성 Rule
           1. 대문자, 소문자
              - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
           2. Naming Rule - Prefix
              - 파라메터 : p_
              - 변수 : 데이타 타입에 따라 v_(문자), n_(숫자), d_(날짜)
           3. 들여쓰기 : 2 space
           4. 기타
              - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
              - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
        ******************************************************************************************************/
     AS
    
        I_COUNT        INTEGER := 0;
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_program_id' VALUE P_PROGRAM_ID
                                     ,'p_sheet_name' VALUE P_SHEET_NAME);
    
        SELECT COUNT(*)
        INTO   I_COUNT
        FROM   SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID = C.PROGRAM_ID
        AND    U.SHEET_NAME = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID = P_PROGRAM_ID
        AND    U.SHEET_NAME = P_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
    
        IF I_COUNT = 0 THEN
        
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,0 SEQ
                      ,'Y' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = P_PROGRAM_ID
                AND    C.SHEET_NAME = P_SHEET_NAME
                ORDER  BY SEQ, SORT_ORDER_NO;
        
        ELSE
            --IF i_Count <> 0
        
            /* TODO:EDIT_YN:수동확인필요 */
            OPEN O_RC1 FOR
                SELECT U.PROGRAM_ID
                      ,U.SHEET_NAME
                      ,U.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,U.SORT_ORDER_NO --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                      ,U.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,1 SEQ
                      ,'Y' AS EDIT_YN
                FROM   SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    U.PROGRAM_ID = C.PROGRAM_ID
                AND    U.SHEET_NAME = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID = P_PROGRAM_ID
                AND    U.SHEET_NAME = P_SHEET_NAME
                AND    U.USER_ID = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                UNION ALL
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,2 SEQ
                      ,'Y' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = P_PROGRAM_ID
                AND    C.SHEET_NAME = P_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                ORDER  BY SEQ, SORT_ORDER_NO;
        
        END IF;
    
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS RESULT_CODE
                  ,CASE
                       WHEN 1 = 2 THEN
                        '-'
                       ELSE
                        NULL
                   END AS RESULT_MSG
                  ,'SUCCESS' AS ERR_EVENT
            FROM   DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DM0000_GET_COMMON_SPREAD_TITLE;

END PKG_DM0000;
/
