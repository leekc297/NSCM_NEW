/*=============================================================================================
 * File         : 04_Package_PKG_DMF0006.sql
 * Description  : Package — PKG_DMF0006
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0006 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0006                                                                        */
/* Description : PKG_DMF0006                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.16  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA(
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_CUSTOMER_PROJECT_CODE   IN VARCHAR2
  ,P_CUSTOMER_MODEL          IN VARCHAR2
  ,P_VALID_YN                IN VARCHAR2
  ,P_CREATED_BY              IN VARCHAR2
  ,P_USERINFO                IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
);

PROCEDURE P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA
(
    -- Add the parameters for the stored procedure here
    P_ACTIVE_FLAG           IN VARCHAR2,
    P_DIVISION_ID           IN VARCHAR2,
    P_CUSTOMER_PROJECT_CODE IN VARCHAR2,
    P_CUSTOMER_MODEL        IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_PROJECT_CODE          IN VARCHAR2,
    P_ITEM_ID               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_MODEL_TYPE   IN VARCHAR2,
    P_CONVERT_QTY_PACK      IN VARCHAR2,
    P_CONVERT_QTY_MODULE    IN VARCHAR2,
    P_CONVERT_QTY_CELL      IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    /*P_CREATION_DATE         IN VARCHAR2,
    P_LAST_UPDATED_BY       IN VARCHAR2,
    P_LAST_UPDATE_DATE      IN VARCHAR2,*/
    /*
    P_ATTRIBUTE1            IN VARCHAR2,
    P_ATTRIBUTE2            IN VARCHAR2,
    P_ATTRIBUTE3            IN VARCHAR2,
    P_ATTRIBUTE4            IN VARCHAR2,
    P_ATTRIBUTE5            IN VARCHAR2,
    P_ATTRIBUTE6            IN VARCHAR2,
    P_ATTRIBUTE7            IN VARCHAR2,
    P_ATTRIBUTE8            IN VARCHAR2,
    P_ATTRIBUTE9            IN VARCHAR2,
    P_ATTRIBUTE10           IN VARCHAR2
    */
    --P_SUCCESS_YN          OUT VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);


END PKG_DMF0006;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0006 IS
/****************************************************************************************************/
/* PROGRAM ID  : PKG_DMF0006                                                                        */
/* DESCRIPTION : PKG_DMF0006                                                                        */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.16  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          UI 항목으로 PACKAGE로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA(
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_CUSTOMER_PROJECT_CODE   IN VARCHAR2
  ,P_CUSTOMER_MODEL          IN VARCHAR2
  ,P_VALID_YN                IN VARCHAR2
  ,P_CREATED_BY              IN VARCHAR2
  ,P_USERINFO                IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                 */
/* Description : Procedure 작성 가이드                                                                */
/* Usage       : Procedure 작성 시 참조하세요!                                                         */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/05/30  JYE			복수 팀 권한 관련  수정                                                        */
/* 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리                                              */
/* 2024/08/14	KJJ			[PJ2024-50461] Team Mapping                                                   */
/****************************************************************************************************/

    V_GROUP_ID          VARCHAR2(50 CHAR) := '';
    V_ADMIN_CNT         PLS_INTEGER := 0;
    
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    
    --IF P_USERINFO = 'ADMIN' OR P_USERINFO = 'DM ADMIN'
    --  V_GROUP_ID := 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        V_ADMIN_CNT := 0;

        SELECT COUNT(1)
          INTO V_ADMIN_CNT
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL  
         WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
           AND VALID_YN = 'Y'
           AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM PLANNER (W/S) 제외 / 주석처리인경우 DM PLANNER (W/S) 포함 
           AND SEGMENT1 = P_USERINFO
          ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_ADMIN_CNT := 0;
    END;
    
    IF V_ADMIN_CNT > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
    
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    --PJ2024-50461 TEAM MAPPING(전체 수정)

    OPEN O_CURSOR FOR
    SELECT A.DIVISION_ID
          ,B.DIVISION_NAME
          ,A.CUSTOMER_PROJECT_CODE
          ,A.CUSTOMER_MODEL
          ,A.SCM_SITE_ID
          ,C.SITE_DESCRIPTION
          ,DEPRTMENT.DEPT_ID        AS UPPER_DEPT_ID
          ,TEAM.DEPT_ID
          ,TEAM.DEPT_NAME_KO   
          ,CASE WHEN NVL(TEAM.DEPT_ID, '') = '' OR TEAM.DEPT_ID IS NULL OR INSTR(REVERSE(NVL(TEAM.DEPT_NAME_KO,'')), '.') = 0 THEN ''
                ELSE CASE WHEN NVL(TEAM.DEPT_NAME_KO,'') = '' OR TEAM.DEPT_NAME_KO IS NULL THEN ''
                          ELSE SUBSTR(NVL(TEAM.DEPT_NAME_KO, ''), LENGTH(NVL(TEAM.DEPT_NAME_KO, '')) - INSTR(REVERSE(NVL(TEAM.DEPT_NAME_KO, '')), '.') + 2) 
                     END
           END AS TEAM_INCARGE
          
          ,NVL(C.END_CUSTOMER,'') AS END_CUSTOMER
          ,A.PROJECT_CODE
          ,PJT.PROJECT_NAME
          ,A.ITEM_ID
          ,ITEM.ITEM_CLASS_NAME
          ,NVL(ITEM.ITEM_NAME,'') AS ITEM_NAME
          ,'0' AS CAPACITY 
          ,A.CONVERT_QTY_PACK
          ,A.CONVERT_QTY_MODULE
          ,A.CONVERT_QTY_CELL  
     
          ,A.VALID_YN
          ,A.LAST_UPDATED_BY
          ,A.LAST_UPDATE_DATE
          ,CASE WHEN ((FN_GET_DEPT_LIST(P_CREATED_BY, TEAM.DEPT_ID) = 'Y') OR V_GROUP_ID = 'ADMIN') THEN 'Y' ELSE '' END AS AUTHORITY_YN
          ,EDY.EDIT_YN
      FROM SCM_MGR.DM_MST_CUSTOMER_MODEL A 
           INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
               ON EDY.UNIT_ID = A.DIVISION_ID
           LEFT JOIN (SELECT *
                        FROM SCM_MGR.SCM_MST_DIVISION
                       WHERE VALID_YN = 'Y') B 
               ON A.DIVISION_ID = B.DIVISION_ID
           INNER JOIN (SELECT *
                         FROM SCM_MGR.SCM_MST_SITE
                        WHERE VALID_YN = 'Y') C 
                ON A.DIVISION_ID = C.DIVISION_ID
               AND A.SCM_SITE_ID = C.SCM_SITE_ID
               AND C.SITE_TYPE   = 'SALES'
           LEFT OUTER JOIN (SELECT --(SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(SS.OWNER, ',')) WHERE ROWNUM = 1) AS USER_ID
                                  SS.*
                              FROM SCM_MGR.SCM_MST_SITE_ITEM SS
                           ) SITE_ITEM
                ON A.DIVISION_ID  = SITE_ITEM.DIVISION_ID
               AND A.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
               AND A.SCM_SITE_ID  = SITE_ITEM.SCM_SITE_ID
               AND A.ITEM_ID      = SITE_ITEM.ITEM_ID
           LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
                ON TEAM.DEPT_ID = SITE_ITEM.DEPT_ID
               AND TEAM.VALID_YN = 'Y'
           /*LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
                        FROM SCM_MGR.SCM_MST_SSO_USER_INFO B
                             INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                                 ON C.DEPT_ID = B.DEPT_ID
                     ) TEAM
               --ON TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(SITE_ITEM.OWNER, ',')) WHERE ROWNUM = 1)-- TUNNING
               ON TEAM.USER_ID = SITE_ITEM.USER_ID*/

           LEFT JOIN (SELECT *
                        FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO
                       WHERE VALID_YN = 'Y') DEPRTMENT             
               ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
	         LEFT JOIN (SELECT *
                        FROM SCM_MGR.DM_MST_ITEM_SINGLE_V
                     ) ITEM 
                ON A.DIVISION_ID = ITEM.DIVISION_ID
               AND A.ITEM_ID     = ITEM.ITEM_ID
           LEFT JOIN (SELECT PJTS.DIVISION_ID, PJTS.PROJECT_CODE, PJTS.PROJECT_NAME, PJTS.PROJECT_VER_SEQ, PJTS.CAPACITY
                        FROM SCM_MGR.SCM_MST_PROJECT PJTS 
                             INNER JOIN (SELECT DIVISION_ID, PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS PROJECT_VER_SEQ
                                          FROM SCM_MGR.SCM_MST_PROJECT 
                                         GROUP BY DIVISION_ID, PROJECT_CODE
                                        ) PJTSG 
                                  ON PJTSG.DIVISION_ID      = PJTS.DIVISION_ID
                                 AND PJTSG.PROJECT_CODE    = PJTS.PROJECT_CODE
                                 AND PJTSG.PROJECT_VER_SEQ = PJTS.PROJECT_VER_SEQ
                     ) PJT 
                ON A.DIVISION_ID  = PJT.DIVISION_ID
               AND A.PROJECT_CODE = PJT.PROJECT_CODE
     WHERE  1=1        
       AND CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL'
                ELSE A.DIVISION_ID     
           END IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_STRING_SPLITFORIN(P_DIVISION_ID,',')) P
                    WHERE (CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.COLUMN_VALUE
                  )
       AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                ELSE TEAM.DEPT_ID      
           END IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_STRING_SPLITFORIN(P_DEPT_ID,',')) P
                    WHERE (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.COLUMN_VALUE
                  )
       AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                ELSE NVL(C.END_CUSTOMER,'')      
           END IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_STRING_SPLITFORIN(P_END_CUSTOMER,',')) P
                    WHERE (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER,'') END) = P.COLUMN_VALUE
                  )           
       AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                ELSE A.SCM_SITE_ID     
           END IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_STRING_SPLITFORIN(P_SCM_SITE_ID,',')) P
                    WHERE (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.COLUMN_VALUE
                  )  
       /*AND CASE WHEN P_PROJECT_CODE = '' OR P_PROJECT_CODE IS NULL THEN '@#@#@#'
                ELSE A.PROJECT_CODE      
           END IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_STRING_SPLITFORIN(P_PROJECT_CODE,',')) P
                    WHERE (CASE WHEN P_PROJECT_CODE = '' OR P_PROJECT_CODE IS NULL THEN '@#@#@#' ELSE A.PROJECT_CODE END) = P.COLUMN_VALUE
                  )*/
       --NULL 값 입력시 조회 되도록 변경
       AND ((P_PROJECT_CODE = '' OR P_PROJECT_CODE IS NULL)
             OR
            (P_PROJECT_CODE IS NOT NULL AND  
             CASE WHEN P_PROJECT_CODE = '' OR P_PROJECT_CODE IS NULL THEN '@#@#@#'
                  ELSE A.PROJECT_CODE      
             END IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_STRING_SPLITFORIN(P_PROJECT_CODE,',')) P
                      WHERE (CASE WHEN P_PROJECT_CODE = '' OR P_PROJECT_CODE IS NULL THEN '@#@#@#' ELSE A.PROJECT_CODE END) = P.COLUMN_VALUE
                    )
            )
           )
       AND CASE WHEN P_VALID_YN = 'ALL' THEN 'ALL'
                ELSE A.VALID_YN
           END = P_VALID_YN

       AND ((P_ITEM_ID = '' OR P_ITEM_ID IS NULL)
             OR
            (EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE A.ITEM_ID LIKE '%' || P.TOKEN ||'%'))
           )
       AND ((P_CUSTOMER_PROJECT_CODE = '' OR P_CUSTOMER_PROJECT_CODE IS NULL)
             OR
            (EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_CUSTOMER_PROJECT_CODE,',')) P WHERE A.CUSTOMER_PROJECT_CODE LIKE '%' || P.TOKEN ||'%'))
           )
       AND ((P_CUSTOMER_MODEL = '' OR P_CUSTOMER_MODEL IS NULL)
             OR
            (EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_CUSTOMER_MODEL,',')) P WHERE A.CUSTOMER_MODEL LIKE '%' || P.TOKEN ||'%'))
           )
     ORDER BY A.DIVISION_ID, DEPRTMENT.DEPT_ID, C.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE, A.CUSTOMER_PROJECT_CODE, A.CUSTOMER_MODEL, A.ITEM_ID, ITEM.ITEM_CLASS_NAME
    ;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_DIVISION_ID'             VALUE P_DIVISION_ID
            ,'P_DEPT_ID'                 VALUE P_DEPT_ID
            ,'P_END_CUSTOMER'            VALUE P_END_CUSTOMER
            ,'P_SCM_SITE_ID'             VALUE P_SCM_SITE_ID
            ,'P_PROJECT_CODE'            VALUE P_PROJECT_CODE
            ,'P_ITEM_ID'                 VALUE P_ITEM_ID
            ,'P_CUSTOMER_PROJECT_CODE'   VALUE P_CUSTOMER_PROJECT_CODE
            ,'P_CUSTOMER_MODEL'          VALUE P_CUSTOMER_MODEL
            ,'P_VALID_YN'                VALUE P_VALID_YN
            ,'P_CREATED_BY'              VALUE P_CREATED_BY
            ,'P_USERINFO'                VALUE P_USERINFO
            ,'P_USER_ID'                 VALUE P_USER_ID
            ,'P_MENU_ID'                 VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA;

PROCEDURE P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA
(
    -- Add the parameters for the stored procedure here
    P_ACTIVE_FLAG           IN VARCHAR2,
    P_DIVISION_ID           IN VARCHAR2,
    P_CUSTOMER_PROJECT_CODE IN VARCHAR2,
    P_CUSTOMER_MODEL        IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_PROJECT_CODE          IN VARCHAR2,
    P_ITEM_ID               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_MODEL_TYPE   IN VARCHAR2,
    P_CONVERT_QTY_PACK      IN VARCHAR2,
    P_CONVERT_QTY_MODULE    IN VARCHAR2,
    P_CONVERT_QTY_CELL      IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    /*P_CREATION_DATE         IN VARCHAR2,
    P_LAST_UPDATED_BY       IN VARCHAR2,
    P_LAST_UPDATE_DATE      IN VARCHAR2,*/
    /*
    P_ATTRIBUTE1            IN VARCHAR2,
    P_ATTRIBUTE2            IN VARCHAR2,
    P_ATTRIBUTE3            IN VARCHAR2,
    P_ATTRIBUTE4            IN VARCHAR2,
    P_ATTRIBUTE5            IN VARCHAR2,
    P_ATTRIBUTE6            IN VARCHAR2,
    P_ATTRIBUTE7            IN VARCHAR2,
    P_ATTRIBUTE8            IN VARCHAR2,
    P_ATTRIBUTE9            IN VARCHAR2,
    P_ATTRIBUTE10           IN VARCHAR2
    */
    --P_SUCCESS_YN          OUT VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*===================================================================================================
 * Program ID   : PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA
 * Description  : CUSTOMER MODEL MAPPING DATA INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 15    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 *===================================================================================================*/
AS

    recv_active_flag        VARCHAR2(4000 CHAR);

    -- recv init
    v_active_flag           VARCHAR2(4000 CHAR);
    V_DIVISION_ID           VARCHAR2(4000 CHAR);
    V_CUSTOMER_PROJECT_CODE VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL        VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE          VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_VALID_YN              VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL_TYPE   VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_PACK      VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_MODULE    VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_CELL      VARCHAR2(4000 CHAR);
    V_CREATED_BY            VARCHAR2(4000 CHAR);
    V_CREATION_DATE         VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY       VARCHAR2(4000 CHAR);
    V_LAST_UPDATE_DATE      VARCHAR2(4000 CHAR);
    V_ATTRIBUTE1            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE2            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE3            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE4            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE5            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE6            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE7            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE8            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE9            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE10           VARCHAR2(4000 CHAR);

    v_delimiter             VARCHAR2(1 CHAR);
    max_loop_cnt            PLS_INTEGER := 0;
    mst_loop_cnt            PLS_INTEGER := 0;

    -- LOG 용 변수 설정
    v_log_type              VARCHAR2(30 CHAR);  -- START/END/ERROR/...
    n_log_count             PLS_INTEGER := 0;
    v_log_message           VARCHAR2(1000 CHAR);
    v_description           VARCHAR2(500 CHAR);
    d_event_date            DATE;

    -- EXCEPTION 처리용 변수
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100 CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);

BEGIN

    recv_active_flag := NULL;
    recv_active_flag := P_ACTIVE_FLAG;

    -- recv init
    v_active_flag           := NULL;
    V_DIVISION_ID           := NULL;
    V_CUSTOMER_PROJECT_CODE := NULL;
    V_CUSTOMER_MODEL        := NULL;
    V_SCM_SITE_ID           := NULL;
    V_PROJECT_CODE          := NULL;
    V_ITEM_ID               := NULL;
    V_VALID_YN              := NULL;
    V_CUSTOMER_MODEL_TYPE   := NULL;
    V_CONVERT_QTY_PACK      := NULL;
    V_CONVERT_QTY_MODULE    := NULL;
    V_CONVERT_QTY_CELL      := NULL;
    V_CREATED_BY            := NULL;
    V_CREATION_DATE         := NULL;
    V_LAST_UPDATED_BY       := NULL;
    V_LAST_UPDATE_DATE      := NULL;
    V_ATTRIBUTE1            := NULL;
    V_ATTRIBUTE2            := NULL;
    V_ATTRIBUTE3            := NULL;
    V_ATTRIBUTE4            := NULL;
    V_ATTRIBUTE5            := NULL;
    V_ATTRIBUTE6            := NULL;
    V_ATTRIBUTE7            := NULL;
    V_ATTRIBUTE8            := NULL;
    V_ATTRIBUTE9            := NULL;
    V_ATTRIBUTE10           := NULL;

    v_delimiter := '^';  -- 데이터 구분자

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    --------------------------------------------------------------------------------------------
    -- 프로시저 LOOP 길이를 판단
    max_loop_cnt := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, v_delimiter);

    --	WHILE LEN(@p_active_flag) > 0
    WHILE LENGTH(recv_active_flag) > 0 AND mst_loop_cnt < max_loop_cnt
    -- (0)
    LOOP

        -- mst_loop_cnt 1증가
        mst_loop_cnt := mst_loop_cnt + 1;

        -- DISPLAY
        --DBMS_OUTPUT.PUT_LINE(mst_loop_cnt || ' mst_loop_cnt');

        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        BEGIN

            v_active_flag           := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,           v_delimiter, mst_loop_cnt);
            V_DIVISION_ID           := SCM_ARR_SPL_VAL(P_DIVISION_ID,           v_delimiter, mst_loop_cnt);
            V_CUSTOMER_PROJECT_CODE := SCM_ARR_SPL_VAL(P_CUSTOMER_PROJECT_CODE, v_delimiter, mst_loop_cnt);
            V_CUSTOMER_MODEL        := SCM_ARR_SPL_VAL(P_CUSTOMER_MODEL,        v_delimiter, mst_loop_cnt);
            V_SCM_SITE_ID           := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,           v_delimiter, mst_loop_cnt);
            V_PROJECT_CODE          := SCM_ARR_SPL_VAL(P_PROJECT_CODE,          v_delimiter, mst_loop_cnt);
            V_ITEM_ID               := SCM_ARR_SPL_VAL(P_ITEM_ID,               v_delimiter, mst_loop_cnt);
            V_VALID_YN              := SCM_ARR_SPL_VAL(P_VALID_YN,              v_delimiter, mst_loop_cnt);
            V_CUSTOMER_MODEL_TYPE   := SCM_ARR_SPL_VAL(P_CUSTOMER_MODEL_TYPE,   v_delimiter, mst_loop_cnt);
            V_CONVERT_QTY_PACK      := SCM_ARR_SPL_VAL(P_CONVERT_QTY_PACK,      v_delimiter, mst_loop_cnt);
            V_CONVERT_QTY_MODULE    := SCM_ARR_SPL_VAL(P_CONVERT_QTY_MODULE,    v_delimiter, mst_loop_cnt);
            V_CONVERT_QTY_CELL      := SCM_ARR_SPL_VAL(P_CONVERT_QTY_CELL,      v_delimiter, mst_loop_cnt);
            V_CREATED_BY            := SCM_ARR_SPL_VAL(P_CREATED_BY,            v_delimiter, mst_loop_cnt);
            --V_LAST_UPDATED_BY       := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY,       v_delimiter, mst_loop_cnt);

            /*-- 확인용 변수값 DISPLAY
            DBMS_OUTPUT.PUT_LINE('v_active_flag='           || v_active_flag);
            DBMS_OUTPUT.PUT_LINE('V_DIVISION_ID='           || V_DIVISION_ID);
            DBMS_OUTPUT.PUT_LINE('V_CUSTOMER_PROJECT_CODE=' || V_CUSTOMER_PROJECT_CODE);
            DBMS_OUTPUT.PUT_LINE('V_CUSTOMER_MODEL='        || V_CUSTOMER_MODEL);
            DBMS_OUTPUT.PUT_LINE('V_SCM_SITE_ID='           || V_SCM_SITE_ID);
            DBMS_OUTPUT.PUT_LINE('V_PROJECT_CODE='          || V_PROJECT_CODE);
            DBMS_OUTPUT.PUT_LINE('V_ITEM_ID='               || V_ITEM_ID);
            DBMS_OUTPUT.PUT_LINE('V_VALID_YN='              || V_VALID_YN);
            DBMS_OUTPUT.PUT_LINE('V_CUSTOMER_MODEL_TYPE='   || V_CUSTOMER_MODEL_TYPE);
            DBMS_OUTPUT.PUT_LINE('V_CONVERT_QTY_PACK='      || V_CONVERT_QTY_PACK);
            DBMS_OUTPUT.PUT_LINE('V_CONVERT_QTY_MODULE='    || V_CONVERT_QTY_MODULE);
            DBMS_OUTPUT.PUT_LINE('V_CONVERT_QTY_CELL='      || V_CONVERT_QTY_CELL);
            DBMS_OUTPUT.PUT_LINE('V_CREATED_BY='            || V_CREATED_BY);
            DBMS_OUTPUT.PUT_LINE('V_LAST_UPDATED_BY='       || V_LAST_UPDATED_BY);
            */

        END;

        /*--------- MULTI & SINGLE ROW START --------*/

        -- (1)
        /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
        IF mst_loop_cnt <= max_loop_cnt THEN

            -- (2)
            /* INSERT */
            IF v_active_flag = 'I' THEN

                -- INSERT 전 PK값 DELETE
                DELETE
                FROM SCM_MGR.DM_MST_CUSTOMER_MODEL
                WHERE
                      DIVISION_ID           = V_DIVISION_ID
                  AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                  AND CUSTOMER_MODEL        = V_CUSTOMER_MODEL
                  AND SCM_SITE_ID           = V_SCM_SITE_ID;

                -- INSERT 수행
                INSERT INTO SCM_MGR.DM_MST_CUSTOMER_MODEL
                   (
                     DIVISION_ID
                    ,CUSTOMER_PROJECT_CODE
                    ,CUSTOMER_MODEL
                    ,SCM_SITE_ID
                    ,PROJECT_CODE
                    ,ITEM_ID
                    ,VALID_YN
                    ,CUSTOMER_MODEL_TYPE
                    ,CONVERT_QTY_PACK
                    ,CONVERT_QTY_MODULE
                    ,CONVERT_QTY_CELL
                    ,CREATED_BY
                    ,CREATION_DATE
                    ,LAST_UPDATED_BY
                    ,LAST_UPDATE_DATE
                    ,ATTRIBUTE1
                    ,ATTRIBUTE2
                    ,ATTRIBUTE3
                    ,ATTRIBUTE4
                    ,ATTRIBUTE5
                    ,ATTRIBUTE6
                    ,ATTRIBUTE7
                    ,ATTRIBUTE8
                    ,ATTRIBUTE9
                    ,ATTRIBUTE10
                   )
                VALUES
                   (
                     V_DIVISION_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_SCM_SITE_ID
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_VALID_YN
                    ,V_CUSTOMER_MODEL_TYPE
                    ,V_CONVERT_QTY_PACK
                    ,V_CONVERT_QTY_MODULE
                    ,V_CONVERT_QTY_CELL
                    ,V_CREATED_BY
                    ,SYSDATE
                    ,V_CREATED_BY     -- V_LAST_UPDATED_BY
                    ,SYSDATE
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                    ,NULL
                   );

            END IF;
            -- (2)

            -- (3)
            /* UPDATE */
            IF v_active_flag = 'M' THEN

                UPDATE SCM_MGR.DM_MST_CUSTOMER_MODEL
                SET
                     PROJECT_CODE          = V_PROJECT_CODE
                    ,ITEM_ID               = V_ITEM_ID
                    ,VALID_YN              = V_VALID_YN
                    ,CUSTOMER_MODEL_TYPE   = V_CUSTOMER_MODEL_TYPE
                    ,CONVERT_QTY_PACK      = V_CONVERT_QTY_PACK
                    ,CONVERT_QTY_MODULE    = V_CONVERT_QTY_MODULE
                    ,CONVERT_QTY_CELL      = V_CONVERT_QTY_CELL
                    ,LAST_UPDATED_BY       = V_CREATED_BY
                    ,LAST_UPDATE_DATE      = SYSDATE
                    ,ATTRIBUTE1            = NULL
                    ,ATTRIBUTE2            = NULL
                    ,ATTRIBUTE3            = NULL
                    ,ATTRIBUTE4            = NULL
                    ,ATTRIBUTE5            = NULL
                    ,ATTRIBUTE6            = NULL
                    ,ATTRIBUTE7            = NULL
                    ,ATTRIBUTE8            = NULL
                    ,ATTRIBUTE9            = NULL
                    ,ATTRIBUTE10           = NULL
                WHERE
                      DIVISION_ID           = V_DIVISION_ID
                  AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                  AND CUSTOMER_MODEL        = V_CUSTOMER_MODEL
                  AND SCM_SITE_ID           = V_SCM_SITE_ID;

            END IF;
            -- (3)

            -- (4)
            /* DELETE */
            IF v_active_flag = 'D' THEN

                DELETE
                FROM SCM_MGR.DM_MST_CUSTOMER_MODEL
                WHERE
                      DIVISION_ID           = V_DIVISION_ID
                  AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                  AND CUSTOMER_MODEL        = V_CUSTOMER_MODEL
                  AND SCM_SITE_ID           = V_SCM_SITE_ID;

            END IF;
            -- (4)

            -- HISTORY INSERT
            BEGIN
                SCM_MGR.PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST(
                     V_DIVISION_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_SCM_SITE_ID
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_VALID_YN
                    ,V_CUSTOMER_MODEL_TYPE
                    ,V_CONVERT_QTY_PACK
                    ,V_CONVERT_QTY_MODULE
                    ,V_CONVERT_QTY_CELL
                    ,V_CREATED_BY
                );
            END;

        END IF;
        -- (1)

    END LOOP;
    -- (0)

    -- IF @@TRANCOUNT > 0
    -- 트랜잭션 (COMMIT)
    COMMIT;

    --------------------------------------------------------------------------------------------

    -- 수행결과 성공여부 DISPLAY
    IF v_log_message IS NULL THEN
        n_log_count := SQL%ROWCOUNT;
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;
    END IF;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        v_log_message := 'EXCEPTION';
        v_description := '';
        d_event_date  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'           VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'           VALUE P_DIVISION_ID,
            'P_CUSTOMER_PROJECT_CODE' VALUE P_CUSTOMER_PROJECT_CODE,
            'P_CUSTOMER_MODEL'        VALUE P_CUSTOMER_MODEL,
            'P_SCM_SITE_ID'           VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE'          VALUE P_PROJECT_CODE,
            'P_ITEM_ID'               VALUE P_ITEM_ID,
            'P_VALID_YN'              VALUE P_VALID_YN,
            'P_CUSTOMER_MODEL_TYPE'   VALUE P_CUSTOMER_MODEL_TYPE,
            'P_CONVERT_QTY_PACK'      VALUE P_CONVERT_QTY_PACK,
            'P_CONVERT_QTY_MODULE'    VALUE P_CONVERT_QTY_MODULE,
            'P_CONVERT_QTY_CELL'      VALUE P_CONVERT_QTY_CELL,
            'P_CREATED_BY'            VALUE P_CREATED_BY/*,
            'P_CREATION_DATE'         VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY'       VALUE P_LAST_UPDATED_BY,
            'P_LAST_UPDATE_DATE'      VALUE P_LAST_UPDATE_DATE*/
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        -- ERROR LOG
        -- SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, n_log_count, v_log_message,
                v_description, d_event_date, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA;

END PKG_DMF0006;
/
