/*=============================================================================================
 * File         : 04_Package_PKG_DMF0007.sql
 * Description  : Package — PKG_DMF0007
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0007 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0007                                                                        */
/* Description : PKG_DMF0007                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.17  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0007_GET_CUST_FCST_DATA (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_DIVISION_ID     IN VARCHAR2
  --,P_DEPT_ID         IN VARCHAR2
  ,P_END_CUSTOMER    IN VARCHAR2
  ,P_SCM_SITE_ID     IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_VALID_YN        IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  --,P_USER_GROUP      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2
  
  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0007_GET_CUST_PSI_DATA (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_DIVISION_ID     IN VARCHAR2
  --,P_DEPT_ID         IN VARCHAR2
  ,P_END_CUSTOMER    IN VARCHAR2
  ,P_SCM_SITE_ID     IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_VALID_YN        IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  --,P_USER_GROUP      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2
  
  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0007_GET_SPREAD_TITLE (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2
  
  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0007_SAVE_CUST_FCST_DATA (
    P_ACTIVE_FLAG           IN VARCHAR2,
    P_DIVISION_ID           IN VARCHAR2,
    P_PLAN_WEEK             IN VARCHAR2,
    P_CUSTOMER_CODE         IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_MEASURE_GROUP         IN VARCHAR2,
    P_MEASURE               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_PSI          IN VARCHAR2,
    P_UPLOAD_UOM            IN VARCHAR2,
    P_UPLOAD_BUCKET_TYPE    IN VARCHAR2,
    P_SUMMARY_BUCKET_TYPE   IN VARCHAR2,
    P_SUMMARY_BUCKET_VALUE  IN VARCHAR2,
    P_SUMMARY_BUCKET_YN     IN VARCHAR2,     -- Y: valid_yn값
    P_EDI_FCST_YN           IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);

FUNCTION F_FN_REPLACE_CLOB(
    P_SOURCE      IN CLOB,
    P_SEARCH      IN VARCHAR2,
    P_REPLACEMENT IN CLOB
) RETURN CLOB;

PROCEDURE P_PR_PRINT_CLOB(
    P_TITLE IN VARCHAR2,
    P_TEXT  IN CLOB
);

END PKG_DMF0007;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0007 IS
/****************************************************************************************************/
/* PROGRAM ID  : PKG_DMF0006                                                                        */
/* DESCRIPTION : PKG_DMF0006                                                                        */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.17  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          UI 항목으로 PACKAGE로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0007_GET_CUST_FCST_DATA (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_DIVISION_ID     IN VARCHAR2
  --,P_DEPT_ID         IN VARCHAR2     2026.03.27 park.choyi 삭제
  ,P_END_CUSTOMER    IN VARCHAR2
  ,P_SCM_SITE_ID     IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_VALID_YN        IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  --,P_USER_GROUP      IN VARCHAR2     2026.03.27 park.choyi 삭제
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2
  
  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*============================================================================================================================
 * PROGRAM ID  : DMF0007_GET_CUST_FCST_DATA                                                               
 * DESCRIPTION  :  
 * PROGRAM HISTORY  
 *=============================================================================================================================
 *   DATE   IN CHARGE   DESCRIPTION  
 *=============================================================================================================================
 * 2017.10.25 SONGDH      INITIAL RELEASE [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
 * 2018.05.30 JYE       복수 팀 권한 관련  수정    
 * 2020.03.11 KHSONG      [C20200103-000586]_권한그룹을 LOOKUP관리  
 * 2022.10.24 ROSIA27     신규 작성  
 * 2023.02.28 CHANO0612   [E20230227-000456]소형사업부 RPA 업로드 시 GSCM FAIL 발생 -- EXCEL UPLOAD
 * 2025.03.27 JSSBAE      [E20250326-000842]_CUSTOMER FCST MASTER 조회 로직 수정
 *============================================================================================================================*/
 
    V_SQL_TEXT          CLOB;
    V_ITERATION         CLOB;
    V_SQL_CURSOR        PLS_INTEGER := NULL;
    V_EXECUTE_RET       PLS_INTEGER := 0;
    V_COLUMN_TEXT       VARCHAR2(4000  CHAR);
    V_COLUMN_NAME       VARCHAR2(20 CHAR);
    V_WEEKSTART_DATE    VARCHAR2(8 CHAR);
    V_PARAM_LIST        VARCHAR2(4000 CHAR);
    V_PLAN_WEEK         VARCHAR2(6 CHAR);
    V_START_WEEK        VARCHAR2(8 CHAR);
    V_END_WEEK          VARCHAR2(8 CHAR);
    V_START_YYYYMMDD    VARCHAR2(8 CHAR);
    V_END_YYYYMMDD      VARCHAR2(8 CHAR);
    V_BUCKET_TYPE       VARCHAR2(10 CHAR);
    V_GROUP_ID          VARCHAR2(50 CHAR) := '';
    
    V_ADMIN_CNT         PLS_INTEGER := 0;
    
    V_PROC_INPUT         VARCHAR2(4000 CHAR);
    V_BACKTRACE          VARCHAR2(4000 CHAR);
    V_SQL_CODE           VARCHAR2(100  CHAR);
    V_SQL_ERRMSG         VARCHAR2(1000 CHAR);
    n_log_count          PLS_INTEGER := 0;
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    
    DBMS_LOB.CREATETEMPORARY(V_ITERATION, TRUE);

    ---------------------------------------------------------------------------------  
    -- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)  
    ---------------------------------------------------------------------------------  
    BEGIN
        V_ADMIN_CNT := 0;

        SELECT COUNT(1)
          INTO V_ADMIN_CNT
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL  
         WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
           AND VALID_YN = 'Y'
           AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM PLANNER (W/S) 제외 / 주석처리인경우 DM PLANNER (W/S) 포함 
           -- AND SEGMENT1 = P_USER_GROUP 2026.03.27 park.choyi 삭제 및 권한 로직 수정
           AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID 
                             FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A 
                             WHERE  USER_ID = P_USER_ID
                             AND    UNIT_TP_CD = 'D'
                             AND    UNIT_ID = P_DIVISION_ID ) 
          ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_ADMIN_CNT := 0;
    END;
    
    IF V_ADMIN_CNT > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;

    ---------------------------------------------------------------------------------  
    -- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)  
    ---------------------------------------------------------------------------------  
    V_START_WEEK := '@#@#@#';  
    V_END_WEEK := '@#@#@#';  

    V_START_WEEK := P_PLAN_WEEK;  
    V_BUCKET_TYPE := P_BUCKET_TYPE;  

    SELECT C.ISO_YYYYWW  
      INTO V_PLAN_WEEK  
      FROM SCM_MGR.SCM_SYS_CALENDAR_M C   
     WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD');  

    --V_PLAN_WEEK := '202612'; --임시 TEST

    IF NVL(V_START_WEEK,'@#@#@#') = '@#@#@#' THEN  
        IF V_BUCKET_TYPE = 'DAILY' THEN
            SELECT MIN(C.BASIS_YYYYMMDD)   
                 , MIN(C.BASIS_YYYYMMDD)   
            INTO V_START_WEEK  
                 , V_START_YYYYMMDD  
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C    
            WHERE C.ISO_YYYYWW = (SELECT C.ISO_YYYYWW  
                                  FROM SCM_SYS_CALENDAR_M C    
                                  WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD'));  

        ELSIF V_BUCKET_TYPE = 'WEEKLY' THEN
            SELECT MIN(C.ISO_YYYYWW)  
                 , MIN(C.BASIS_YYYYMMDD)  
            INTO V_START_WEEK  
                 , V_START_YYYYMMDD  
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C    
            WHERE C.ISO_YYYYWW = (SELECT C.ISO_YYYYWW  
                                  FROM SCM_SYS_CALENDAR_M C   
                                  WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD'));  

        ELSIF V_BUCKET_TYPE = 'MONTHLY' THEN
            SELECT T.BASIS_YYYYMM  
                 , T.BASIS_YYYYMMDD  
            INTO   V_START_WEEK  
                 , V_START_YYYYMMDD  
            FROM ( SELECT MIN(C.BASIS_YYYYMM) AS BASIS_YYYYMM  
                        , MIN(C.BASIS_YYYYMMDD) AS BASIS_YYYYMMDD  
                   FROM SCM_MGR.SCM_SYS_CALENDAR_M C   
                   WHERE C.BASIS_YYYYMM = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMM')  
                  ) T;
        END IF;  
    ELSE  
        V_START_WEEK := P_PLAN_WEEK;
    END IF;
        
    IF V_BUCKET_TYPE = 'DAILY' THEN
        SELECT C.BASIS_YYYYMMDD  
              ,C.BASIS_YYYYMMDD  
          INTO V_END_WEEK
              ,V_END_YYYYMMDD
          FROM SCM_MGR.SCM_SYS_CALENDAR_M C 
         WHERE C.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 12), 'YYYYMMDD')
         ;  

    ELSIF V_BUCKET_TYPE = 'WEEKLY' THEN
        SELECT T.ISO_YYYYWW  
              ,T.BASIS_YYYYMMDD
          INTO V_END_WEEK
              ,V_END_YYYYMMDD
          FROM (SELECT MAX(ISO_YYYYWW)        AS ISO_YYYYWW  
                      ,MAX(C.BASIS_YYYYMMDD)  AS BASIS_YYYYMMDD  
                  FROM SCM_MGR.SCM_SYS_CALENDAR_M C 
                 WHERE C.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 30), 'YYYYMMDD')  
                ) T;

    ELSIF V_BUCKET_TYPE = 'MONTHLY' THEN
        SELECT T.BASIS_YYYYMM  
              ,T.BASIS_YYYYMMDD  
          INTO V_END_WEEK
              ,V_END_YYYYMMDD
          FROM (SELECT MAX(BASIS_YYYYMM)      AS BASIS_YYYYMM  
                     , MAX(C.BASIS_YYYYMMDD)  AS BASIS_YYYYMMDD  
                  FROM SCM_MGR.SCM_SYS_CALENDAR_M C 
                 WHERE C.BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 30), 'YYYYMM')  
               ) T;
    END IF;


    IF V_BUCKET_TYPE = 'DAILY' THEN
        FOR REC IN (SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME  
                            , A.BASIS_YYYYMMDD    AS BASIS_YYYYMMDD  
                    FROM SCM_MGR.SCM_SYS_CALENDAR_M A   
                    WHERE 1 = 1  
                    AND A.BASIS_YYYYMMDD >=  V_START_WEEK  
                    AND A.BASIS_YYYYMMDD <= V_END_WEEK) LOOP    
            V_COLUMN_TEXT := ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[V_WEEKSTART_DATE]'' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS [V_COLUMN_NAME] ';
			      V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT,'[V_WEEKSTART_DATE]', REC.BASIS_YYYYMMDD);  
			      V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT,'[V_COLUMN_NAME]', REC.COLUMN_NAME);  
            DBMS_LOB.WRITEAPPEND(V_ITERATION, LENGTH(V_COLUMN_TEXT), V_COLUMN_TEXT);
        END LOOP;
     
    ELSIF V_BUCKET_TYPE = 'WEEKLY' THEN
        FOR REC IN (SELECT 'D_' || MIN(A.BASIS_START_DATE)  AS COLUMN_NAME  
                            , MIN(A.BASIS_YYYYMMDD)   AS BASIS_YYYYMMDD  
                    FROM  SCM_MGR.SCM_SYS_CALENDAR_M A   
                    WHERE 1 = 1  
                    AND A.ISO_YYYYWW >=  V_START_WEEK  
                    AND A.ISO_YYYYWW <= V_END_WEEK       
                    GROUP BY A.ISO_YYYYWW) LOOP    
            V_COLUMN_TEXT := ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[V_WEEKSTART_DATE]'' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS [V_COLUMN_NAME] ';
			      V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT,'[V_WEEKSTART_DATE]', REC.BASIS_YYYYMMDD);  
			      V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT,'[V_COLUMN_NAME]', REC.COLUMN_NAME); 
            DBMS_LOB.WRITEAPPEND(V_ITERATION, LENGTH(V_COLUMN_TEXT), V_COLUMN_TEXT);
        END LOOP;

    ELSIF V_BUCKET_TYPE = 'MONTHLY' THEN
        FOR REC IN (SELECT 'D_' || MIN(A.BASIS_YYYYMMDD)    AS COLUMN_NAME  
                            , MIN(A.BASIS_YYYYMMDD)   AS BASIS_YYYYMMDD  
                    FROM SCM_MGR.SCM_SYS_CALENDAR_M A   
                    WHERE 1 = 1  
                    AND A.BASIS_YYYYMM >= V_START_WEEK  
                    AND A.BASIS_YYYYMM <= V_END_WEEK   
                    GROUP BY A.BASIS_YYYYMM) LOOP    
            V_COLUMN_TEXT := ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[V_WEEKSTART_DATE]'' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS [V_COLUMN_NAME] ';
			      V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT,'[V_WEEKSTART_DATE]', REC.BASIS_YYYYMMDD);  
			      V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT,'[V_COLUMN_NAME]', REC.COLUMN_NAME); 
            DBMS_LOB.WRITEAPPEND(V_ITERATION, LENGTH(V_COLUMN_TEXT), V_COLUMN_TEXT);
        END LOOP;
    END IF;

      
    --소형사업부 추가(END CUSTOMER 체크 안함)
    IF P_DIVISION_ID = '40' --E20230227-000456소형사업부 RPA 업로드 시 GSCM FAIL 발생 -- EXCEL UPLOAD
    THEN
        V_SQL_TEXT := '  
            WITH MASTER AS   
                    ( SELECT CF.PLAN_WEEK, CF.DIVISION_ID/*, S.DEPT_ID*/, CF.CUSTOMER_CODE, CF.SCM_SITE_ID        
                                , CF.SUMMARY_BUCKET_TYPE, CF.MEASURE_GROUP, CF.MEASURE, CF.EDI_FCST_YN, CF.CUSTOMER_PSI  
                                , CF.UPLOAD_UOM, CF.UPLOAD_BUCKET_TYPE  
                                /*--, CF.VALID_YN*/  
                                , CF.MASTER_VALID_YN, C.BASIS_YYYYMMDD AS SUMMARY_BUCKET_VALUE   
                        FROM (  SELECT T1.PLAN_WEEK, T1.DIVISION_ID, T1.CUSTOMER_CODE, T1.SCM_SITE_ID, T1.SUMMARY_BUCKET_TYPE  
                                        , T1.MEASURE_GROUP, T1.MEASURE, T1.EDI_FCST_YN, T1.CUSTOMER_PSI, T1.UPLOAD_UOM  
                                        , T1.UPLOAD_BUCKET_TYPE, T1.MASTER_VALID_YN, T2.VALID_YN, T2.SUMMARY_BUCKET_VALUE  
                                FROM ( SELECT PLAN_WEEK, DIVISION_ID , CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                            , MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI, UPLOAD_UOM  
                                            , UPLOAD_BUCKET_TYPE, MAX(VALID_YN) AS MASTER_VALID_YN              
                                       FROM SCM_MGR.DM_MST_CUSTOMER_FCST CF     
                                       WHERE 1 = 1  
                                       AND  MEASURE_GROUP = ''CUST_FCST''  
                                       AND  PLAN_WEEK     = ''[P_PLAN_WEEK]''   
                                       AND  SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''[V_END_YYYYMMDD]''  
                                       [P_DIVISION_ID]
                                       /*--[P_END_CUSTOMER]*/   
                                       [P_SCM_SITE_ID]
                                       /*--[P_BUCKET_TYPE]--E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/                     
                                       GROUP BY PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                              , MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI, UPLOAD_UOM  
                                              , UPLOAD_BUCKET_TYPE  
                                        ) T1  
                                LEFT JOIN SCM_MGR.DM_MST_CUSTOMER_FCST T2       
                                       ON  T1.PLAN_WEEK       = T2.PLAN_WEEK  
                                      AND T1.DIVISION_ID      = T2.DIVISION_ID   
                                      AND T1.CUSTOMER_CODE      = T2.CUSTOMER_CODE     
                                      AND T1.SCM_SITE_ID      = T2.SCM_SITE_ID        
                                      AND T1.SUMMARY_BUCKET_TYPE  = T2.SUMMARY_BUCKET_TYPE  
                                      AND T1.MEASURE_GROUP      = T2.MEASURE_GROUP  
                                      AND T1.MEASURE        = T2.MEASURE  
                                      AND T1.EDI_FCST_YN      = T2.EDI_FCST_YN  
                                      AND T1.CUSTOMER_PSI     = T2.CUSTOMER_PSI  
                                      AND T1.UPLOAD_UOM       = T2.UPLOAD_UOM  
                                      AND T1.UPLOAD_BUCKET_TYPE   = T2.UPLOAD_BUCKET_TYPE  
                                      AND T2.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]''         
                                WHERE  1 = 1  
                                ) CF    
                        LEFT JOIN SCM_MGR.SCM_SYS_CALENDAR_M C     
                               ON (C.BASIS_YYYYMMDD = CF.SUMMARY_BUCKET_VALUE    
                              AND C.BASIS_YYYYMMDD BETWEEN ''20000101'' AND ''[V_END_YYYYMMDD]'')       
                        ,(SELECT A.DIVISION_ID, A.SCM_SITE_ID/*, B.DEPT_ID*/, A.END_CUSTOMER
                            FROM SCM_MGR.SCM_MST_SITE A
                                 LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                                      ON A.DIVISION_ID = B.DIVISION_ID 
                                     AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                           WHERE A.VALID_YN = ''Y''
                           GROUP BY A.DIVISION_ID, A.SCM_SITE_ID/*, B.DEPT_ID*/, A.END_CUSTOMER
                          ) S 
                        WHERE  1 = 1  
                        AND CF.DIVISION_ID      = S.DIVISION_ID  
                        /*--AND CF.CUSTOMER_CODE  = S.END_CUSTOMER*/  
                        AND CF.SCM_SITE_ID      = S.SCM_SITE_ID  
                        /*--[P_DEPT_ID]*/     
                        AND CF.UPLOAD_BUCKET_TYPE = ''[V_BUCKET_TYPE]'' /*E20250326-000842_CUSTOMER FCST MASTER 조회 로직 수정*/         
                    )  
  
            SELECT M.PLAN_WEEK, M.DIVISION_ID/*, M.DEPT_ID*/, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                 , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                             WHEN ''WEEKLY'' THEN 2  
                                             WHEN ''MONTHLY'' THEN 3 END AS UPLOAD_ORDER  
                 , M.SUMMARY_BUCKET_TYPE, M.MEASURE_GROUP, M.MEASURE, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                 , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE 
                 /*-- , M.VALID_YN */ 
                 , M.MASTER_VALID_YN AS VALID_YN  
                 --, CASE WHEN ((FN_GET_DEPT_LIST(''[P_CREATED_BY]'', M.DEPT_ID) = ''Y'') OR ''[V_GROUP_ID]'' =''ADMIN'')   
                 --       THEN ''Y'' ELSE '''' END AS EDIT_FLAG  
                 [V_ITERATION]
                 ,EDY.EDIT_YN
            FROM MASTER M       
                 INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''[P_USER_ID]'', ''[P_MENU_ID]'')) EDY
                    ON EDY.UNIT_ID = M.DIVISION_ID
            LEFT OUTER JOIN SCM_MGR.DM_MST_CUSTOMER_FCST CF   
                         ON (M.PLAN_WEEK      = CF.PLAN_WEEK  
                        AND M.DIVISION_ID     = CF.DIVISION_ID  
                        AND M.CUSTOMER_CODE     = CF.CUSTOMER_CODE  
                        AND M.SCM_SITE_ID     = CF.SCM_SITE_ID  
                        AND M.SUMMARY_BUCKET_TYPE = CF.SUMMARY_BUCKET_TYPE  
                        AND M.MEASURE_GROUP     = CF.MEASURE_GROUP  
                        AND M.MEASURE       = CF.MEASURE  
                        AND M.SUMMARY_BUCKET_VALUE  = CF.SUMMARY_BUCKET_VALUE  
                        AND M.EDI_FCST_YN     = CF.EDI_FCST_YN  
                        AND M.CUSTOMER_PSI      = CF.CUSTOMER_PSI  
                        AND M.UPLOAD_UOM      = CF.UPLOAD_UOM  
                        AND M.UPLOAD_BUCKET_TYPE  = CF.UPLOAD_BUCKET_TYPE  
                        [P_DIVISION_ID]
                        /*--  [P_END_CUSTOMER]*/   
                        [P_SCM_SITE_ID]
                        /*--[P_BUCKET_TYPE] --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/        
                        /*-- AND CF.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]''*/  
                        )  
            WHERE  1 = 1  
            [P_VALID_YN]
            /*--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]''*/  
            GROUP BY M.PLAN_WEEK, M.DIVISION_ID/*, M.DEPT_ID*/, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                   , M.SUMMARY_BUCKET_TYPE, M.MEASURE, M.MEASURE_GROUP, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                   , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE  
                   /*-- , M.VALID_YN*/   
                   , M.MASTER_VALID_YN  
                   , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                               WHEN ''WEEKLY'' THEN 2  
                                               WHEN ''MONTHLY'' THEN 3 END  
                   ,EDY.EDIT_YN
            ORDER BY DIVISION_ID/*, DEPT_ID*/, CUSTOMER_CODE, SCM_SITE_ID, UPLOAD_ORDER, MEASURE_GROUP, MEASURE  
            ';
            
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_PLAN_WEEK]',       V_PLAN_WEEK);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_START_YYYYMMDD]',  V_START_YYYYMMDD);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_END_YYYYMMDD]',    V_END_YYYYMMDD);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_DIVISION_ID]',     FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID'     , 'IN', P_DIVISION_ID));  
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_DEPT_ID]',       FN_SCM_GET_WHERE_SQL('S.DEPT_ID'        , 'IN', P_DEPT_ID));  
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_END_CUSTOMER]',    FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE'     , 'IN', P_END_CUSTOMER));  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_SCM_SITE_ID]',     FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID'     , 'IN', P_SCM_SITE_ID));  
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_BUCKET_TYPE]',     FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE' , 'EQ', P_BUCKET_TYPE));  --[E20250326-000842]_조건은 UPLOAD BUCKET 기준으로 변경   
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_VALID_YN]',        FN_SCM_GET_WHERE_SQL('M.MASTER_VALID_YN'  , 'EQ', P_VALID_YN));  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_CREATED_BY]',      P_CREATED_BY);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_GROUP_ID]',        V_GROUP_ID); 
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_BUCKET_TYPE]',     V_BUCKET_TYPE);  /*[E20250326-000842]_CUSTOMER FCST MASTER 조회 로직 수정*/    
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_USER_ID]',    P_USER_ID);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_MENU_ID]',    P_MENU_ID);
        V_SQL_TEXT := PKG_DMF0007.F_FN_REPLACE_CLOB(V_SQL_TEXT,'[V_ITERATION]', V_ITERATION);  

    ELSE
        V_SQL_TEXT := '  
            WITH MASTER AS   
                    ( SELECT CF.PLAN_WEEK, CF.DIVISION_ID/*, S.DEPT_ID*/, CF.CUSTOMER_CODE, CF.SCM_SITE_ID        
                                , CF.SUMMARY_BUCKET_TYPE, CF.MEASURE_GROUP, CF.MEASURE, CF.EDI_FCST_YN, CF.CUSTOMER_PSI  
                                , CF.UPLOAD_UOM, CF.UPLOAD_BUCKET_TYPE  
                                /* --, CF.VALID_YN*/  
                                , CF.MASTER_VALID_YN, C.BASIS_YYYYMMDD AS SUMMARY_BUCKET_VALUE   
                        FROM (  SELECT T1.PLAN_WEEK, T1.DIVISION_ID, T1.CUSTOMER_CODE, T1.SCM_SITE_ID, T1.SUMMARY_BUCKET_TYPE  
                                        , T1.MEASURE_GROUP, T1.MEASURE, T1.EDI_FCST_YN, T1.CUSTOMER_PSI, T1.UPLOAD_UOM  
                                        , T1.UPLOAD_BUCKET_TYPE, T1.MASTER_VALID_YN, T2.VALID_YN, T2.SUMMARY_BUCKET_VALUE  
                                FROM ( SELECT PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                            , MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI, UPLOAD_UOM  
                                            , UPLOAD_BUCKET_TYPE , MAX(VALID_YN) AS MASTER_VALID_YN              
                                       FROM SCM_MGR.DM_MST_CUSTOMER_FCST CF     
                                       WHERE 1 = 1  
                                       AND MEASURE_GROUP = ''CUST_FCST''  
                                       AND PLAN_WEEK     = ''[P_PLAN_WEEK]''   
                                       AND SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''[V_END_YYYYMMDD]''  
                                       [P_DIVISION_ID]
                                       [P_END_CUSTOMER]
                                       [P_SCM_SITE_ID]
                                       /*--[P_BUCKET_TYPE] --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/                    
                                       GROUP BY PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                              , MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI , UPLOAD_UOM  
                                              , UPLOAD_BUCKET_TYPE  
                                    ) T1  
                                LEFT JOIN SCM_MGR.DM_MST_CUSTOMER_FCST T2       
                                       ON T1.PLAN_WEEK        = T2.PLAN_WEEK  
                                      AND T1.DIVISION_ID      = T2.DIVISION_ID   
                                      AND T1.CUSTOMER_CODE      = T2.CUSTOMER_CODE     
                                      AND T1.SCM_SITE_ID      = T2.SCM_SITE_ID        
                                      AND T1.SUMMARY_BUCKET_TYPE  = T2.SUMMARY_BUCKET_TYPE  
                                      AND T1.MEASURE_GROUP      = T2.MEASURE_GROUP  
                                      AND T1.MEASURE        = T2.MEASURE  
                                      AND T1.EDI_FCST_YN      = T2.EDI_FCST_YN  
                                      AND T1.CUSTOMER_PSI     = T2.CUSTOMER_PSI  
                                      AND T1.UPLOAD_UOM       = T2.UPLOAD_UOM  
                                      AND T1.UPLOAD_BUCKET_TYPE   = T2.UPLOAD_BUCKET_TYPE  
                                      AND T2.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]''         
                                WHERE  1 = 1  
                                ) CF    
                        LEFT JOIN SCM_MGR.SCM_SYS_CALENDAR_M C     
                               ON (C.BASIS_YYYYMMDD = CF.SUMMARY_BUCKET_VALUE    
                              AND C.BASIS_YYYYMMDD BETWEEN ''20000101'' AND ''[V_END_YYYYMMDD]'')       
                        ,(SELECT A.DIVISION_ID, A.SCM_SITE_ID/*, B.DEPT_ID*/, A.END_CUSTOMER
                            FROM SCM_MGR.SCM_MST_SITE A
                                 LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                                      ON A.DIVISION_ID = B.DIVISION_ID 
                                     AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                           WHERE A.VALID_YN = ''Y''
                           GROUP BY A.DIVISION_ID, A.SCM_SITE_ID/*, B.DEPT_ID*/, A.END_CUSTOMER
                          ) S 
                        WHERE  1 = 1  
                        AND CF.DIVISION_ID   = S.DIVISION_ID  
                        AND CF.CUSTOMER_CODE = S.END_CUSTOMER  
                        AND CF.SCM_SITE_ID   = S.SCM_SITE_ID  
                        /*[P_DEPT_ID] 2026.03.27 park.choyi 삭제*/
                        AND CF.UPLOAD_BUCKET_TYPE  = ''[V_BUCKET_TYPE]''/*E20250326-000842_CUSTOMER FCST MASTER 조회 로직 수정*/                    
                    )  
  
            SELECT M.PLAN_WEEK, M.DIVISION_ID/*, M.DEPT_ID*/, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                 , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                             WHEN ''WEEKLY'' THEN 2  
                                             WHEN ''MONTHLY'' THEN 3 END AS UPLOAD_ORDER  
                 , M.SUMMARY_BUCKET_TYPE, M.MEASURE_GROUP, M.MEASURE, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                 , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE  
                 /*-- , M.VALID_YN */ 
                 , M.MASTER_VALID_YN AS VALID_YN  
                 --, CASE WHEN ((FN_GET_DEPT_LIST(''[P_CREATED_BY]'', M.DEPT_ID) = ''Y'') OR ''[V_GROUP_ID]'' =''ADMIN'')   
                 --       THEN ''Y'' ELSE '''' END AS EDIT_FLAG  
                 [V_ITERATION]
                 ,EDY.EDIT_YN
            FROM MASTER M        
                 INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''[P_USER_ID]'', ''[P_MENU_ID]'')) EDY
                    ON EDY.UNIT_ID = M.DIVISION_ID
            LEFT OUTER JOIN SCM_MGR.DM_MST_CUSTOMER_FCST CF   
                         ON (M.PLAN_WEEK      = CF.PLAN_WEEK  
                        AND M.DIVISION_ID     = CF.DIVISION_ID  
                        AND M.CUSTOMER_CODE     = CF.CUSTOMER_CODE  
                        AND M.SCM_SITE_ID     = CF.SCM_SITE_ID  
                        AND M.SUMMARY_BUCKET_TYPE = CF.SUMMARY_BUCKET_TYPE  
                        AND M.MEASURE_GROUP     = CF.MEASURE_GROUP  
                        AND M.MEASURE       = CF.MEASURE  
                        AND M.SUMMARY_BUCKET_VALUE  = CF.SUMMARY_BUCKET_VALUE  
                        AND M.EDI_FCST_YN     = CF.EDI_FCST_YN  
                        AND M.CUSTOMER_PSI      = CF.CUSTOMER_PSI  
                        AND M.UPLOAD_UOM      = CF.UPLOAD_UOM  
                        AND M.UPLOAD_BUCKET_TYPE  = CF.UPLOAD_BUCKET_TYPE  
                        [P_DIVISION_ID]
                        [P_END_CUSTOMER]
                        [P_SCM_SITE_ID]
                        /*--[P_BUCKET_TYPE]'' --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/    
                        /*-- AND CF.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]'' */ 
                            )  
            WHERE  1 = 1  
            [P_VALID_YN]
            /*--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]'' */ 
            GROUP BY M.PLAN_WEEK, M.DIVISION_ID/*, M.DEPT_ID*/, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                   , M.SUMMARY_BUCKET_TYPE, M.MEASURE, M.MEASURE_GROUP, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                   , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE  
                   /*-- , M.VALID_YN  */
                   , M.MASTER_VALID_YN  
                   , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                               WHEN ''WEEKLY'' THEN 2  
                                               WHEN ''MONTHLY'' THEN 3 END  
                   ,EDY.EDIT_YN
            ORDER BY DIVISION_ID/*, DEPT_ID*/, CUSTOMER_CODE, SCM_SITE_ID, UPLOAD_ORDER, MEASURE_GROUP, MEASURE     
            ';
            
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_PLAN_WEEK]',       V_PLAN_WEEK);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_START_YYYYMMDD]',  V_START_YYYYMMDD);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_END_YYYYMMDD]',    V_END_YYYYMMDD);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_DIVISION_ID]',     FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID'     , 'IN', P_DIVISION_ID));  
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_DEPT_ID]',         FN_SCM_GET_WHERE_SQL('S.DEPT_ID'          , 'IN', P_DEPT_ID));  2026.03.27 park.choyi 삭제
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_END_CUSTOMER]',    FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE'   , 'IN', P_END_CUSTOMER));  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_SCM_SITE_ID]',     FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID'     , 'IN', P_SCM_SITE_ID));  
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_BUCKET_TYPE]',     FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE' , 'EQ', P_BUCKET_TYPE));  --[E20250326-000842]_조건은 UPLOAD BUCKET 기준으로 변경
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_VALID_YN]',        FN_SCM_GET_WHERE_SQL('M.MASTER_VALID_YN'  , 'EQ', P_VALID_YN));  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_CREATED_BY]',      P_CREATED_BY);  
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_GROUP_ID]',        V_GROUP_ID); 
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_BUCKET_TYPE]',     V_BUCKET_TYPE);  /*[E20250326-000842]_CUSTOMER FCST MASTER 조회 로직 수정*/    
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_USER_ID]',    P_USER_ID);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_MENU_ID]',    P_MENU_ID);
        V_SQL_TEXT := PKG_DMF0007.F_FN_REPLACE_CLOB(V_SQL_TEXT,'[V_ITERATION]', V_ITERATION);  
    
    END IF;

    --EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list,   
    --                              --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;  


    --EXECUTE IMMEDIATE v_sql_text;
    
    -- DBMS_OUTPUT.PUT_LINE('V_ITERATION LENGTH=' || DBMS_LOB.GETLENGTH(V_ITERATION));
    -- DBMS_OUTPUT.PUT_LINE('V_SQL_TEXT  LENGTH=' || DBMS_LOB.GETLENGTH(V_SQL_TEXT));
    PKG_DMF0007.P_PR_PRINT_CLOB('V_SQL_TEXT', V_SQL_TEXT);

    V_SQL_CURSOR := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(V_SQL_CURSOR, V_SQL_TEXT, DBMS_SQL.NATIVE);
    V_EXECUTE_RET := DBMS_SQL.EXECUTE(V_SQL_CURSOR);
    O_CURSOR := DBMS_SQL.TO_REFCURSOR(V_SQL_CURSOR);
    V_SQL_CURSOR := NULL;
    
    IF DBMS_LOB.ISTEMPORARY(V_SQL_TEXT) = 1 THEN
        DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);
    END IF;

    IF DBMS_LOB.ISTEMPORARY(V_ITERATION) = 1 THEN
        DBMS_LOB.FREETEMPORARY(V_ITERATION);
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(V_SQL_CURSOR) THEN
            DBMS_SQL.CLOSE_CURSOR(V_SQL_CURSOR);
        END IF;

        IF DBMS_LOB.ISTEMPORARY(V_SQL_TEXT) = 1 THEN
            DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);
        END IF;

        IF DBMS_LOB.ISTEMPORARY(V_ITERATION) = 1 THEN
            DBMS_LOB.FREETEMPORARY(V_ITERATION);
        END IF;
        
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_PLAN_WEEK'       VALUE P_PLAN_WEEK   
            ,'P_DIVISION_ID'     VALUE P_DIVISION_ID 
            --,'P_DEPT_ID'         VALUE P_DEPT_ID     2026.03.27 park.choyi 삭제
            ,'P_END_CUSTOMER'    VALUE P_END_CUSTOMER
            ,'P_SCM_SITE_ID'     VALUE P_SCM_SITE_ID 
            ,'P_BUCKET_TYPE'     VALUE P_BUCKET_TYPE 
            ,'P_VALID_YN'        VALUE P_VALID_YN    
            ,'P_CREATED_BY'      VALUE P_CREATED_BY  
            --,'P_USER_GROUP'      VALUE P_USER_GROUP   2026.03.27 park.choyi 삭제
            ,'P_USER_ID'         VALUE P_USER_ID
            ,'P_MENU_ID'         VALUE P_MENU_ID
        );

        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0007_GET_CUST_FCST_DATA;

PROCEDURE P_DMF0007_GET_CUST_PSI_DATA (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_DIVISION_ID     IN VARCHAR2
  --,P_DEPT_ID         IN VARCHAR2    2026.03.27 park.choyi 삭제
  ,P_END_CUSTOMER    IN VARCHAR2
  ,P_SCM_SITE_ID     IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_VALID_YN        IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  --,P_USER_GROUP      IN VARCHAR2    2026.03.27 park.choyi 삭제
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2
  
  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*============================================================================================================================
 * PROGRAM ID  : DMF0007_GET_CUST_PSI_DATA                                                             
 * DESCRIPTION  :
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2018/02/23  SONGDH       INITIAL RELEASE [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018/05/30  JYE			복수 팀 권한 관련  수정  
 * 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
 * 20221026 KDW2819	[C20221024-000507]CUST FCST UPLOAD 오류 수정
 *============================================================================================================================*/

    V_SQL_TEXT          VARCHAR2(32000 CHAR);
    V_ITERATION         VARCHAR2(32000 CHAR);
    V_COLUMN_TEXT       VARCHAR2(200 CHAR);
    V_COLUMN_NAME       VARCHAR2(20 CHAR);
    V_WEEKSTART_DATE    VARCHAR2(8 CHAR);
    P_PARAM_LIST        VARCHAR2(4000 CHAR);
    V_PLAN_WEEK         VARCHAR2(6 CHAR);
    V_START_WEEK        VARCHAR2(8 CHAR);
    V_END_WEEK          VARCHAR2(8 CHAR);
    V_START_YYYYMMDD    VARCHAR2(8 CHAR);
    V_END_YYYYMMDD      VARCHAR2(8 CHAR);
    V_BUCKET_TYPE       VARCHAR2(10 CHAR);
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
    --IF V_GROUP_ID = 'ADMIN' OR V_GROUP_ID = 'DM ADMIN'
    --    V_GROUP_ID := 'ADMIN'

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
           -- AND SEGMENT1 = P_USER_GROUP 2026.03.27 park.choyi 삭제 및 권한 로직 수정
           AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID 
                             FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A 
                             WHERE  USER_ID = P_USER_ID
                             AND    UNIT_TP_CD = 'D'
                             AND    UNIT_ID = P_DIVISION_ID ) 
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
  
    V_START_WEEK := '@#@#@#';
    V_END_WEEK := '@#@#@#';
    V_SQL_TEXT := '@#@#@#';

    V_START_WEEK := P_PLAN_WEEK;
    V_BUCKET_TYPE := P_BUCKET_TYPE;

    SELECT C.ISO_YYYYWW
    INTO V_PLAN_WEEK
    FROM SCM_MGR.SCM_SYS_CALENDAR_M C  
    WHERE C.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    V_SQL_TEXT := '
    SELECT CF.PLAN_WEEK
         , CF.DIVISION_ID 
         --, S.DEPT_ID   --미사용
         , CF.CUSTOMER_CODE   
         , CF.SCM_SITE_ID      
         , CF.SUMMARY_BUCKET_TYPE
         , CF.MEASURE_GROUP
         , CF.MEASURE
         , CF.EDI_FCST_YN
         , CF.CUSTOMER_PSI
         , CF.UPLOAD_UOM
         , CF.UPLOAD_BUCKET_TYPE
         , CF.VALID_YN   AS VALID_YN  
         , CF.LAST_UPDATED_BY
         , CF.LAST_UPDATE_DATE
         /*, CASE WHEN ((FN_GET_DEPT_LIST(''[P_CREATED_BY]'', S.DEPT_ID) = ''Y'') OR ''[V_GROUP_ID]'' =''ADMIN'') 
          THEN ''Y'' ELSE '''' END AS EDIT_FLAG*/
         , EDY.EDIT_YN
    FROM   SCM_MGR.DM_MST_CUSTOMER_FCST CF         
           INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''[P_USER_ID]'', ''[P_MENU_ID]'')) EDY
              ON EDY.UNIT_ID = CF.DIVISION_ID
          /*,(SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID, A.END_CUSTOMER
              FROM SCM_MGR.SCM_MST_SITE A
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                        ON A.DIVISION_ID = B.DIVISION_ID 
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID 
             WHERE A.VALID_YN = ''Y''  
             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID, A.END_CUSTOMER
            ) S */
    WHERE  1 = 1
    /*AND    CF.DIVISION_ID   = S.DIVISION_ID
    AND    CF.CUSTOMER_CODE = S.END_CUSTOMER
    AND    CF.SCM_SITE_ID   = S.SCM_SITE_ID*/
    AND    CF.MEASURE_GROUP = ''PSI''
    AND    CF.PLAN_WEEK     = ''[P_PLAN_WEEK]'' 
    --AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''[V_START_YYYYMMDD]'' AND ''[V_END_YYYYMMDD]''
	  [P_DIVISION_ID] 	
    [P_END_CUSTOMER]	
    [P_SCM_SITE_ID]
	  [P_BUCKET_TYPE]	
	  [P_VALID_YN]    
    ORDER BY CF.DIVISION_ID
         --, S.DEPT_ID
           , CF.CUSTOMER_CODE
           , CF.SCM_SITE_ID
       , CF.MEASURE_GROUP
       , CF.MEASURE
  '; 
  --DEPT_ID 미사용으로 제외함
    --SET V_SQL_TEXT = REPLACE(V_SQL_TEXT,'[V_ITERATION]'     , V_ITERATION     );
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_PLAN_WEEK]'     , V_PLAN_WEEK     );
    --SET V_SQL_TEXT = REPLACE(V_SQL_TEXT,'[V_START_YYYYMMDD]', V_START_YYYYMMDD);
    --SET V_SQL_TEXT = REPLACE(V_SQL_TEXT,'[V_END_YYYYMMDD]'  , V_END_YYYYMMDD  );
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_DIVISION_ID]'   , SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID'        , 'IN', P_DIVISION_ID ));
    --V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_DEPT_ID]'       , SCM_MGR.FN_SCM_GET_WHERE_SQL('S.DEPT_ID'             , 'IN', P_DEPT_ID     ));
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_END_CUSTOMER]'  , SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE'      , 'IN', P_END_CUSTOMER));
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_SCM_SITE_ID]'   , SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID'        , 'IN', P_SCM_SITE_ID ));
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_BUCKET_TYPE]'   , SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', P_BUCKET_TYPE ));
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_VALID_YN]'      , SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.VALID_YN'           , 'EQ', P_VALID_YN    ));
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_CREATED_BY]'    , P_CREATED_BY    );
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_GROUP_ID]'      , V_GROUP_ID    );
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_USER_ID]',    P_USER_ID);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_MENU_ID]',    P_MENU_ID);
  
    DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
    --EXECUTE IMMEDIATE v_sql_text;
    OPEN O_CURSOR FOR V_SQL_TEXT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_PLAN_WEEK'       VALUE P_PLAN_WEEK   
            ,'P_DIVISION_ID'     VALUE P_DIVISION_ID 
           -- ,'P_DEPT_ID'         VALUE P_DEPT_ID     2026.03.27 park.choyi 삭제
            ,'P_END_CUSTOMER'    VALUE P_END_CUSTOMER
            ,'P_SCM_SITE_ID'     VALUE P_SCM_SITE_ID 
            ,'P_BUCKET_TYPE'     VALUE P_BUCKET_TYPE 
            ,'P_VALID_YN'        VALUE P_VALID_YN    
            ,'P_CREATED_BY'      VALUE P_CREATED_BY  
            --,'P_USER_GROUP'      VALUE P_USER_GROUP   2026.03.27 park.choyi 삭제
            ,'P_USER_ID'         VALUE P_USER_ID
            ,'P_MENU_ID'         VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0007_GET_CUST_PSI_DATA;

PROCEDURE P_DMF0007_GET_SPREAD_TITLE (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2
  
  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*============================================================================================================================
 * Program ID   : DMF0007_GET_SPREAD_TITLE     
 * Description  :
 * Program History
 *============================================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================================
 * 2017/12/18  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022/10/26  KDW2819		  [C20221024-000507]CUST FCST Upload 오류 수정
 *
 *============================================================================================================================*/
    V_SQL_TEXT            VARCHAR2(32000 CHAR);
    V_ITERATION           VARCHAR2(32000 CHAR);
    V_START_WEEK          VARCHAR2(8 CHAR);
    V_END_WEEK            VARCHAR2(8 CHAR);
    V_BUCKET_TYPE         VARCHAR2(10 CHAR);
    V_USER_COL_CNT        NUMBER(10);
    V_USER_TIME_ZONE      VARCHAR2(10 CHAR);
    V_USER_TIME           VARCHAR2(8 CHAR);
    
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100  CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);
    n_log_count           PLS_INTEGER := 0;
    V_PROGRAM_NAME        VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    V_START_WEEK := P_PLAN_WEEK;
    V_BUCKET_TYPE := P_BUCKET_TYPE;
    V_USER_TIME_ZONE := '';

    SELECT U.TMZ_CD
    INTO   V_USER_TIME_ZONE
    FROM   SCM_MGR.SCM_ADM_USER_M U
    WHERE  U.USER_ID = P_CREATED_BY;


    IF NVL(V_START_WEEK,'@#@@#@#') = '@#@@#@#' THEN
        IF V_BUCKET_TYPE = 'DAILY' THEN
            SELECT MIN(C.BASIS_YYYYMMDD)
            INTO V_START_WEEK
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMMDD');
        ELSIF V_BUCKET_TYPE = 'WEEKLY' THEN
            SELECT C.ISO_YYYYWW
            INTO V_START_WEEK
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMMDD');
        ELSIF V_BUCKET_TYPE = 'MONTHLY' THEN
            SELECT C.BASIS_YYYYMM
            INTO V_START_WEEK
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMM = TO_CHAR(FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMM');
        END IF;
    ELSE
        V_START_WEEK := P_PLAN_WEEK;
    END IF;

    BEGIN
        IF V_BUCKET_TYPE = 'DAILY' THEN
            SELECT C.BASIS_YYYYMMDD
            INTO V_END_WEEK
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(V_USER_TIME_ZONE), 12), 'YYYYMMDD');
        ELSIF V_BUCKET_TYPE = 'WEEKLY' THEN
            SELECT ISO_YYYYWW
            INTO V_END_WEEK
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(V_USER_TIME_ZONE), 30), 'YYYYMMDD');
        ELSIF V_BUCKET_TYPE = 'MONTHLY' THEN
            SELECT BASIS_YYYYMM
            INTO V_END_WEEK
            FROM SCM_MGR.SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(V_USER_TIME_ZONE), 30), 'YYYYMM');
        END IF;
    END;

    -- COMMENTED OUT ORIGINAL USAGE OF @V_PROGRAM_NAME
    -- @V_PROGRAM_NAME := $$PLSQL_UNIT;

    IF V_BUCKET_TYPE = 'DAILY' THEN
        V_ITERATION := '
            SELECT ''D_'' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                 , A.DAYOFWEEK                  AS SMALL_CLASS_LABEL_NAME  
                 , A.BASIS_YYYYMMDD             AS BASIS_YYYYMMDD
            FROM   SCM_MGR.SCM_SYS_CALENDAR_M A 
            WHERE  1 = 1
            AND    A.BASIS_YYYYMMDD >= [V_START_WEEK]
            AND    A.BASIS_YYYYMMDD <= [V_END_WEEK]
            ';
    ELSIF V_BUCKET_TYPE = 'WEEKLY' THEN
        V_ITERATION := '
            SELECT ''D_'' || MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
                 , A.ISO_YYYYWW                       AS SMALL_CLASS_LABEL_NAME  
                 , MIN(A.BASIS_YYYYMMDD)              AS BASIS_YYYYMMDD
            FROM   SCM_MGR.SCM_SYS_CALENDAR_M A 
            WHERE  1 = 1
            AND    A.ISO_YYYYWW >=  [V_START_WEEK]
            AND    A.ISO_YYYYWW <=  [V_END_WEEK]
            GROUP BY A.ISO_YYYYWW
            ';
    ELSIF V_BUCKET_TYPE = 'MONTHLY' THEN
        V_ITERATION := '
            SELECT ''D_'' || MIN(A.BASIS_YYYYMMDD)  AS COLUMN_NAME
                 , A.MONTH_NAME                     AS SMALL_CLASS_LABEL_NAME  
                 , MIN(A.BASIS_YYYYMMDD)            AS BASIS_YYYYMMDD
            FROM   SCM_MGR.SCM_SYS_CALENDAR_M A 
            WHERE  1 = 1
            AND    A.BASIS_YYYYMM >= [V_START_WEEK]
            AND    A.BASIS_YYYYMM <= [V_END_WEEK]
            GROUP BY A.MONTH_NAME
            ';
    END IF;

    IF V_USER_COL_CNT > 0 THEN
        -- USER TITLE 이 존재
        V_SQL_TEXT := '
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE         
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.VALID_YN
                 , C.DEFAULT_FLAG
                 , EDY.EDIT_YN
            FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C     
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''[P_USER_ID]'', ''[P_MENU_ID]'')) EDY
                       ON EDY.UNIT_ID = C.DIVISION_ID
            WHERE  1 = 1            
            AND    C.PROGRAM_ID = ''DMF0007''
            AND    C.SHEET_NAME = ''Customer FCST''
            AND    C.VALID_YN   = ''Y''

            UNION ALL

            SELECT ''DMF0007''         AS PROGRAM_ID
                 , ''Customer FCST''  AS SHEET_NAME
                 , T.COLUMN_NAME
                 , C.DATE_SHORT1_NAME AS COLUMN_LABEL_NAME
                 , ROW_NUMBER() OVER (ORDER BY T.BASIS_YYYYMMDD) AS SORT_ORDER_NO
                 , ''''               AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , ''''               AS LARGE_CLASS_LABEL_NAME
                 , ''''               AS FIXED_FLAG
                 , 50                 AS COLUMN_WIDTH
                 , ''FPComboBox''     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''YesOrNo''        AS CELL_COMBO_DATA_TYPE
                 , NULL               AS DATA_SCALE_NUMBER
                 , NULL               AS DATA_MAX_LENGTH
                 , ''C''              AS HORIZONTAL_ALIGN_CODE
                 , ''Y''              AS UPPERCASE_APPLY_FLAG
                 , ''Y''              AS VISIBLE_FLAG
                 , ''Y''              AS VALID_YN
                 , ''''               AS DEFAULT_FLAG
                 , ''''              AS EDIT_YN
            FROM   (     
                    [V_ITERATION]
                   ) T
                 , SCM_MGR.SCM_SYS_CALENDAR_M C 
            WHERE  T.BASIS_YYYYMMDD = C.BASIS_YYYYMMDD  
            ORDER BY SORT_ORDER_NO 
        ';
    ELSE
        -- USER TITLE 이 존재
        V_SQL_TEXT := '
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE         
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.VALID_YN
                 , C.DEFAULT_FLAG
                 , EDY.EDIT_YN
            FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C     
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''[P_USER_ID]'', ''[P_MENU_ID]'')) EDY
                       ON EDY.UNIT_ID = C.DIVISION_ID
            WHERE  1 = 1
            AND    C.PROGRAM_ID = ''DMF0007''
            AND    C.SHEET_NAME = ''Customer FCST''
            AND    C.VALID_YN   = ''Y''
                
            UNION ALL

            SELECT ''DMF0007''         AS PROGRAM_ID
                 , ''Customer FCST''  AS SHEET_NAME
                 , T.COLUMN_NAME
                 , C.DATE_SHORT1_NAME AS COLUMN_LABEL_NAME
                 , ROW_NUMBER() OVER (ORDER BY T.BASIS_YYYYMMDD) AS SORT_ORDER_NO
                 , ''''               AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , ''''               AS LARGE_CLASS_LABEL_NAME
                 , ''''               AS FIXED_FLAG
                 , 50                 AS COLUMN_WIDTH
                 , ''FPComboBox''     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''YesOrNo''        AS CELL_COMBO_DATA_TYPE
                 , NULL               AS DATA_SCALE_NUMBER
                 , NULL               AS DATA_MAX_LENGTH
                 , ''C''              AS HORIZONTAL_ALIGN_CODE
                 , ''Y''              AS UPPERCASE_APPLY_FLAG
                 , ''Y''              AS VISIBLE_FLAG
                 , ''Y''              AS VALID_YN
                 , ''''               AS DEFAULT_FLAG
                 , ''''              AS EDIT_YN
            FROM   (     
                    [V_ITERATION]
                   ) T
                 , SCM_MGR.SCM_SYS_CALENDAR_M C  
            WHERE  T.BASIS_YYYYMMDD = C.BASIS_YYYYMMDD  
            ORDER BY SORT_ORDER_NO 
        ';
    END IF;

    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_ITERATION]' , V_ITERATION );
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_START_WEEK]', V_START_WEEK);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[V_END_WEEK]',   V_END_WEEK);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_CREATED_BY]', P_CREATED_BY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_USER_ID]',    P_USER_ID);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT,'[P_MENU_ID]',    P_MENU_ID);
    
    DBMS_OUTPUT.PUT_LINE(V_SQL_TEXT);
    OPEN O_CURSOR FOR V_SQL_TEXT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_PLAN_WEEK'      VALUE P_PLAN_WEEK
            ,'P_BUCKET_TYPE'    VALUE P_BUCKET_TYPE
            ,'P_CREATED_BY'     VALUE P_CREATED_BY
            ,'P_USER_ID'        VALUE P_USER_ID
            ,'P_MENU_ID'        VALUE P_MENU_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0007_GET_SPREAD_TITLE;


PROCEDURE P_DMF0007_SAVE_CUST_FCST_DATA
(
    P_ACTIVE_FLAG           IN VARCHAR2,
    P_DIVISION_ID           IN VARCHAR2,
    P_PLAN_WEEK             IN VARCHAR2,
    P_CUSTOMER_CODE         IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_MEASURE_GROUP         IN VARCHAR2,
    P_MEASURE               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_PSI          IN VARCHAR2,
    P_UPLOAD_UOM            IN VARCHAR2,
    P_UPLOAD_BUCKET_TYPE    IN VARCHAR2,
    P_SUMMARY_BUCKET_TYPE   IN VARCHAR2,
    P_SUMMARY_BUCKET_VALUE  IN VARCHAR2,
    P_SUMMARY_BUCKET_YN     IN VARCHAR2,     -- Y: valid_yn값
    P_EDI_FCST_YN           IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*===================================================================================================
 * Program ID   : DMF0007_SAVE_CUST_FCST_DATA
 * Description  : DM_MST_CUSTOMER_FCST DATA SAVE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 20    DWOK     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 03. 22    SONGKH Modify
 * 20180806 KHSONG INVALID LOG 생성로직 추가
 * 20191210 KHSONG EDI예약어 MEASURE 등록시 '*' 추가
 * 20221026 KDW2819	[C20221024-000507]CUST FCST Upload 오류 수정
 *=================================================================================================*/
AS
    -- 멀티처리 변수선언
    v_active_flag           VARCHAR2(4000 CHAR);
    v_division_id           VARCHAR2(4000 CHAR);
    v_plan_week             VARCHAR2(4000 CHAR);
    v_customer_code         VARCHAR2(4000 CHAR);
    v_scm_site_id           VARCHAR2(4000 CHAR);
    v_measure_group         VARCHAR2(4000 CHAR);
    v_measure               VARCHAR2(4000 CHAR);
    v_valid_yn              VARCHAR2(4000 CHAR);
    v_customer_psi          VARCHAR2(4000 CHAR);
    v_upload_uom            VARCHAR2(4000 CHAR);
    v_upload_bucket_type    VARCHAR2(4000 CHAR);
    v_summary_bucket_type   VARCHAR2(4000 CHAR);
    v_summary_bucket_value  VARCHAR2(4000 CHAR);
    v_summary_bucket_yn     VARCHAR2(4000 CHAR);
    v_edi_fcst_yn           VARCHAR2(4000 CHAR);
    v_created_by            VARCHAR2(4000 CHAR);
    v_dup_flag              PLS_INTEGER := 0;
    n_existence_flag        PLS_INTEGER := 0;
    n_existence_value       VARCHAR2(4000 CHAR);

    v_delimiter             VARCHAR2(1 CHAR) := '^';
    max_loop_cnt            PLS_INTEGER := 0;
    mst_loop_cnt            PLS_INTEGER := 0;
    
    V_DUP_CNT               PLS_INTEGER := 0;

    -- LOG 용 변수 설정
    v_log_type              VARCHAR2(100  CHAR);   -- START/END/ERROR/...
    n_log_count             PLS_INTEGER := 0;
    v_log_message           VARCHAR2(4000 CHAR);
    v_description           VARCHAR2(4000 CHAR);
    d_event_date            DATE;

    --VALIDATION용 변수 설정
    SUMMARY_FLAG            PLS_INTEGER := 0;

    -- EXCEPTION 처리용
    V_PROC_INPUT            VARCHAR2(4000 CHAR);
    V_BACKTRACE             VARCHAR2(4000 CHAR);
    V_SQL_CODE              VARCHAR2(100  CHAR);
    V_SQL_ERRMSG            VARCHAR2(1000 CHAR);
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    -- GTT 세션 통계 설정
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF7_RESULTS',     'GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF7_SITE_CUST_MAP','GLOBAL_TEMP_TABLE_STATS','SESSION');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF7_DELETE_TARGET','GLOBAL_TEMP_TABLE_STATS','SESSION');

    -- GTT TRUNCATE (ON COMMIT PRESERVE ROWS GTT는 시작 시 명시적 TRUNCATE 필수)
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF7_RESULTS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF7_SITE_CUST_MAP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF7_DELETE_TARGET';

    -- 초기화
    v_active_flag           := NULL;
    v_division_id           := NULL;
    v_plan_week             := NULL;
    v_customer_code         := NULL;
    v_scm_site_id           := NULL;
    v_measure_group         := NULL;
    v_measure               := NULL;
    v_valid_yn              := NULL;
    v_customer_psi          := NULL;
    v_upload_uom            := NULL;
    v_upload_bucket_type    := NULL;
    v_summary_bucket_type   := NULL;
    v_summary_bucket_value  := NULL;
    v_summary_bucket_yn     := NULL;
    v_edi_fcst_yn           := NULL;
    v_created_by            := NULL;
    v_dup_flag              := 0;

    -- 시작 LOG
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    --------------------------------------------------------------------- 프로시저 LOOP 길이를 판단
    max_loop_cnt := SCM_MGR.SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, v_delimiter);

    --------------------------------------------------------------------- WHILE loop START
    WHILE LENGTH(P_ACTIVE_FLAG) > 0 AND mst_loop_cnt < max_loop_cnt
    LOOP

    --------------------------------------------------------------------- mst_loop_cnt 1증가
        mst_loop_cnt := mst_loop_cnt + 1;

    --------------------------------------------------------------------- 각 컬럼들에 대한 split (start)
        v_active_flag          := SCM_MGR.SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         v_delimiter, mst_loop_cnt);
        v_division_id          := SCM_MGR.SCM_ARR_SPL_VAL(P_DIVISION_ID,         v_delimiter, mst_loop_cnt);
        v_plan_week            := SCM_MGR.SCM_ARR_SPL_VAL(P_PLAN_WEEK,           v_delimiter, mst_loop_cnt);

        IF v_active_flag = 'I' THEN
            SELECT a.ISO_YYYYWW
              INTO v_plan_week
              FROM SCM_MGR.SCM_SYS_CALENDAR_M a
             WHERE a.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
        END IF;

        v_customer_code        := SCM_MGR.SCM_ARR_SPL_VAL(P_CUSTOMER_CODE,       v_delimiter, mst_loop_cnt);
        v_scm_site_id          := SCM_MGR.SCM_ARR_SPL_VAL(P_SCM_SITE_ID,         v_delimiter, mst_loop_cnt);
        v_measure_group        := SCM_MGR.SCM_ARR_SPL_VAL(P_MEASURE_GROUP,       v_delimiter, mst_loop_cnt);
        v_measure              := SCM_MGR.SCM_ARR_SPL_VAL(P_MEASURE,             v_delimiter, mst_loop_cnt);

        -- 20191210 KHSONG EDI예약어 MEASURE 등록시 '*' 추가
        v_measure := CASE
                         WHEN v_measure = 'Immidiate'             THEN 'Immidiate*'
                         WHEN v_measure = 'Planning_Forecast'     THEN 'Planning_Forecast*'
                         WHEN v_measure = 'Commercial_Agreement'  THEN 'Commercial_Agreement*'
                         ELSE v_measure
                     END;

        v_valid_yn             := SCM_MGR.SCM_ARR_SPL_VAL(P_VALID_YN,            v_delimiter, mst_loop_cnt);
        v_customer_psi         := NVL(SCM_MGR.SCM_ARR_SPL_VAL(P_CUSTOMER_PSI,    v_delimiter, mst_loop_cnt),'-');
        v_upload_uom           := SCM_MGR.SCM_ARR_SPL_VAL(P_UPLOAD_UOM,          v_delimiter, mst_loop_cnt);
        v_upload_bucket_type   := SCM_MGR.SCM_ARR_SPL_VAL(P_UPLOAD_BUCKET_TYPE,  v_delimiter, mst_loop_cnt);
        v_summary_bucket_type  := SCM_MGR.SCM_ARR_SPL_VAL(P_SUMMARY_BUCKET_TYPE, v_delimiter, mst_loop_cnt);
        v_summary_bucket_value := SCM_MGR.SCM_ARR_SPL_VAL(P_SUMMARY_BUCKET_VALUE,v_delimiter, mst_loop_cnt);
        v_edi_fcst_yn          := SCM_MGR.SCM_ARR_SPL_VAL(P_EDI_FCST_YN,         v_delimiter, mst_loop_cnt);
        v_summary_bucket_yn    := SCM_MGR.SCM_ARR_SPL_VAL(P_SUMMARY_BUCKET_YN,   v_delimiter, mst_loop_cnt);
        v_created_by           := SCM_MGR.SCM_ARR_SPL_VAL(P_CREATED_BY,          v_delimiter, mst_loop_cnt);
    --------------------------------------------------------------------- 각 컬럼들에 대한 split (end)


    v_log_type    := 'ING';
    v_log_message := '';
    v_description := 'v_division_id : ' || v_division_id ||', v_plan_week : ' || v_plan_week ||', v_customer_code :  ' || v_customer_code ||', v_scm_site_id : ' || v_scm_site_id 
                 ||',v_summary_bucket_value : ' || v_summary_bucket_value  ||', v_measure_group : ' || v_measure_group ||', v_customer_psi : ' || v_customer_psi  ||', v_measure : ' || v_measure ;
                 
    d_event_date  := SYSDATE;
    BEGIN PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    
    ---------------------------------------------------------------------- input data를 temp table 에 저장하여 비교값으로 사용  songkh modify (start)
        INSERT INTO SCM_MGR.GT_DMF7_RESULTS
            ( N_DIVISION_ID, N_PLAN_WEEK, N_CUSTOMER_CODE, N_SCM_SITE_ID, N_SUMMARY_BUCKET_VALUE
            , N_MEASURE_GROUP, N_MEASURE, N_CUSTOMER_PSI, N_VALID_YN )
        VALUES
            ( v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_summary_bucket_value
            , v_measure_group, v_measure, v_customer_psi, v_summary_bucket_yn );

        -- ON COMMIT PRESERVE ROWS GTT DML 후 COMMIT
        --COMMIT;

        v_dup_flag := 0;

        IF v_summary_bucket_yn = '' --v_valid_yn = '' / v_summary_bucket_yn
        THEN
            SELECT COUNT(*)
              INTO v_dup_flag
              FROM SCM_MGR.DM_MST_CUSTOMER_FCST
             WHERE DIVISION_ID         = v_division_id
               AND PLAN_WEEK           = v_plan_week
               AND SCM_SITE_ID         = v_scm_site_id
               AND SUMMARY_BUCKET_VALUE = v_summary_bucket_value
               AND MEASURE_GROUP       = v_measure_group
               AND VALID_YN            = 'Y'
               AND CUSTOMER_PSI        = v_customer_psi
               AND MEASURE             <> v_measure
            ;
            
            SELECT COUNT(1)
              INTO V_DUP_CNT
              FROM SCM_MGR.GT_DMF7_RESULTS
             WHERE N_DIVISION_ID         = v_division_id
               AND N_PLAN_WEEK           = v_plan_week
               AND N_SCM_SITE_ID         = v_scm_site_id
               AND N_SUMMARY_BUCKET_VALUE = v_summary_bucket_value
               AND N_VALID_YN            = 'Y'
               AND N_MEASURE_GROUP       = v_measure_group
               AND N_CUSTOMER_PSI        = v_customer_psi
               AND N_MEASURE             <> v_measure
            ;

            v_dup_flag := v_dup_flag + V_DUP_CNT;
        END IF;

        --------------------------------------------------------------하나의 SCM_SITE_ID 당 하나의 SUMMARY BUCKET TYPE 존재 여부 체크
        SUMMARY_FLAG := 0;

        SELECT COUNT(*)
          INTO SUMMARY_FLAG
          FROM (
                  SELECT DIVISION_ID, SCM_SITE_ID, COUNT(SUMMARY_BUCKET_TYPE) AS COUNT_BUCKET
                    FROM (
                            SELECT DIVISION_ID, SCM_SITE_ID, SUMMARY_BUCKET_TYPE
                              FROM (
                                      SELECT
                                              DIVISION_ID,
                                              PLAN_WEEK,
                                              CUSTOMER_CODE,
                                              SCM_SITE_ID,
                                              MEASURE_GROUP,
                                              MEASURE,
                                              VALID_YN,
                                              CUSTOMER_PSI,
                                              UPLOAD_UOM,
                                              UPLOAD_BUCKET_TYPE,
                                              SUMMARY_BUCKET_TYPE,
                                              SUMMARY_BUCKET_VALUE,
                                              EDI_FCST_YN,
                                              UPLOAD_USER_ID,
                                              CREATED_BY,
                                              CREATION_DATE,
                                              LAST_UPDATED_BY,
                                              LAST_UPDATE_DATE
                                        FROM SCM_MGR.DM_MST_CUSTOMER_FCST
                                       UNION ALL
                                      SELECT
                                              v_division_id,
                                              v_plan_week,
                                              v_customer_code,
                                              v_scm_site_id,
                                              v_measure_group,
                                              v_measure,
                                              v_summary_bucket_yn,
                                              v_customer_psi,
                                              v_upload_uom,
                                              v_upload_bucket_type,
                                              v_summary_bucket_type,
                                              v_summary_bucket_value,
                                              v_edi_fcst_yn,
                                              v_created_by,
                                              v_created_by,
                                              SYSDATE,
                                              v_created_by,
                                              SYSDATE
                                        FROM DUAL
                                   ) T1
                             WHERE VALID_YN     = 'Y'
                               AND SCM_SITE_ID  = v_scm_site_id
                               AND DIVISION_ID  = v_division_id
                               AND MEASURE_GROUP = v_measure_group
                             GROUP BY DIVISION_ID, SCM_SITE_ID, SUMMARY_BUCKET_TYPE
                         ) T1
                   GROUP BY DIVISION_ID, SCM_SITE_ID
                  HAVING COUNT(SUMMARY_BUCKET_TYPE) > 1
               ) T1;

        --SELECT SUMMARY_FLAG AS 'SUMMARY_FLAG'

        IF SUMMARY_FLAG > 0 THEN
            -- 'MSG00166'
            --하나의 SITE에는 두가지 이상의 SUMMARY BUCKET TYPE(DAILY, WEEKLY, MONTHLY)이 설정 될 수 없습니다.
            --기존에 입력된 SUMMARY BUCKET TYPE에 대해 각 날짜별 N으로 저장하여 주십시오.
            ROLLBACK;
            v_log_type    := 'INVALID';
            v_log_message := '########## END of procedure ##########';
            v_description := 'ERR_RTN: INVALID - MSG00166';
            d_event_date  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END'     , n_log_count, v_log_message, v_description, d_event_date); END;

            EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, v_description AS EVENT FROM DUAL;
            RETURN;
        END IF;

    --------------------------------------------------------------------- input data를 temp table 에 저장하여 비교값으로 사용 songkh modify (end)

    --------------------------------------------------------------------- 데이터 기준값 DAY:20000101 , WEEK : 20000102, MONTH: 20000103 설정하여 MASTER 값으로 사용함
        n_existence_flag := 0;
        n_existence_value := '';

        n_existence_value :=
            CASE
                WHEN v_summary_bucket_type = 'DAILY'   THEN '20000101'
                WHEN v_summary_bucket_type = 'WEEKLY'  THEN '20000102'
                WHEN v_summary_bucket_type = 'MONTHLY' THEN '20000103'
            END;

        ---------------------------------------------------- summary_bucket_type 기준으로 이미 존재하는 데이터를 확인함
        SELECT NVL(COUNT(1), 0)
          INTO n_existence_flag
          FROM SCM_MGR.DM_MST_CUSTOMER_FCST
         WHERE division_id           = v_division_id
           AND plan_week             = v_plan_week
           AND customer_code         = v_customer_code
           AND scm_site_id           = v_scm_site_id
           AND summary_bucket_value  = n_existence_value
           AND measure_group         = v_measure_group
           AND customer_psi          = v_customer_psi
           --AND summary_bucket_value  = v_summary_bucket_value
           AND summary_bucket_type   = v_summary_bucket_type
           AND MEASURE               = v_measure;
        --select n_existence_flag as 'n_existence_flag2'
        --select n_existence_value as 'n_existence_value2'

        ---------------------------------------------------- MASTER 값 INSERT
        IF n_existence_flag = 0 THEN
            --INSERT /*+ APPEND PARALLEL(4) */ INTO DM_MST_CUSTOMER_FCST
            INSERT INTO SCM_MGR.DM_MST_CUSTOMER_FCST
            (  division_id, plan_week, customer_code, scm_site_id, measure_group, measure
            , valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type
            , summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date )
            VALUES
            (   v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_measure_group, v_measure
            , '', v_customer_psi, v_upload_uom, v_upload_bucket_type, v_summary_bucket_type, n_existence_value
            , v_edi_fcst_yn, v_created_by, v_created_by, SYSDATE, v_created_by, SYSDATE );
        END IF;

        --select * from DM_MST_CUSTOMER_FCST where PLAN_WEEK = '201814' and scm_site_id = 'Ford_US_RDF' order by LAST_UPDATE_DATE

        IF v_dup_flag = 0 THEN
            -- INPUT 데이터 INSERT전 DELETE처리
            DELETE FROM SCM_MGR.DM_MST_CUSTOMER_FCST
             WHERE division_id           = v_division_id
               AND plan_week             = v_plan_week
               AND customer_code         = v_customer_code
               AND scm_site_id           = v_scm_site_id
               AND summary_bucket_value  = v_summary_bucket_value
               AND measure_group         = v_measure_group
               AND customer_psi          = v_customer_psi;

    --------------------------------------------------------------------- INPUT 데이터 INSERT
            --INSERT /*+ APPEND PARALLEL(4) */ INTO DM_MST_CUSTOMER_FCST
            INSERT INTO SCM_MGR.DM_MST_CUSTOMER_FCST
            (  division_id, plan_week, customer_code, scm_site_id, measure_group, measure
            , valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type
            , summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date )
            VALUES
            (   v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_measure_group, v_measure
            , v_summary_bucket_yn, v_customer_psi, v_upload_uom, v_upload_bucket_type, v_summary_bucket_type, v_summary_bucket_value
            , v_edi_fcst_yn, v_created_by, v_created_by, SYSDATE, v_created_by, SYSDATE );

    --------------------------------------------------------------------- history insert
            SCM_MGR.PR_DM_MST_CUSTOMER_FCST_HIST(
                v_division_id,
                v_plan_week,
                v_customer_code,
                v_scm_site_id,
                v_summary_bucket_value,
                v_measure_group,
                v_measure,
                v_summary_bucket_yn,    -- valid_yn
                v_customer_psi,
                v_upload_uom,
                v_upload_bucket_type,
                v_summary_bucket_type,
                v_edi_fcst_yn,
                v_created_by,
                v_created_by,
                v_created_by
            );
        END IF;

    END LOOP;
    --------------------------------------------------------------------- WHILE loop END

    --GT_DMF7_RESULTS 통계 수집 (루프 후 JOIN에서 사용하므로 수집 필요)
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DMF7_RESULTS',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1',
        no_invalidate    => FALSE
    );

    -- GT_DMF7_RESULTS
    --INSERT /*+ APPEND PARALLEL(4) */ INTO GT_DMF7_SITE_CUST_MAP
    INSERT /*+ NO_PARALLEL */ INTO GT_DMF7_SITE_CUST_MAP
        (DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY)
    SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
      FROM (
                SELECT a.DIVISION_ID, a.SCM_SITE_ID, a.MEASURE,
                       a.SUMMARY_BUCKET_VALUE AS START_DAY,
                       CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY'
                            THEN TO_CHAR(FN_NEXT_DAY(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD'), 'SUN'), 'YYYYMMDD')
                            ELSE a.SUMMARY_BUCKET_VALUE
                       END AS END_DAY
                  FROM SCM_MGR.DM_MST_CUSTOMER_FCST a
                 INNER JOIN (SELECT DISTINCT N_DIVISION_ID, N_SCM_SITE_ID FROM SCM_MGR.GT_DMF7_RESULTS) rslt
                         ON a.DIVISION_ID = rslt.N_DIVISION_ID
                        AND a.SCM_SITE_ID  = rslt.N_SCM_SITE_ID
                 WHERE VALID_YN           = 'Y'
                   AND a.MEASURE_GROUP    = 'CUST_FCST'
                   AND a.PLAN_WEEK        = (SELECT MAX(PLAN_WEEK) FROM DM_MST_CUSTOMER_FCST)
                   -- 당주 월요일 이후데이터만
                   AND a.SUMMARY_BUCKET_VALUE >= TO_CHAR(FN_NEXT_DAY(SYSDATE - 7, 'MON'), 'YYYYMMDD')
                   AND SUMMARY_BUCKET_TYPE IN ('DAILY', 'WEEKLY')

               UNION

               SELECT a.DIVISION_ID, a.SCM_SITE_ID, a.MEASURE,
                      CASE WHEN SUMMARY_BUCKET_VALUE =
                                    TO_CHAR(TRUNC(SYSDATE, 'MM') + 1 - 1, 'YYYYMMDD')
                                -- 해당월 1일 ((DATEADD(DAY,-DATEPART(DD,getdate()) + (1),getdate())) 상당)
                                -- Oracle: TRUNC(SYSDATE,'MM') = 월의 첫날
                           THEN TO_CHAR(FN_NEXT_DAY(SYSDATE - 7, 'MON'), 'YYYYMMDD')
                           ELSE SUMMARY_BUCKET_VALUE
                      END AS START_DAY,
                      -- 해당월 말일: DATEADD(day,-DATEPART(DD,ADD_MONTHS(value, 1)),ADD_MONTHS(value, 1))
                      TO_CHAR(LAST_DAY(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD')), 'YYYYMMDD') AS END_DAY
                 FROM SCM_MGR.DM_MST_CUSTOMER_FCST a
                INNER JOIN (SELECT DISTINCT N_DIVISION_ID, N_SCM_SITE_ID FROM SCM_MGR.GT_DMF7_RESULTS) rslt
                        ON a.DIVISION_ID = rslt.N_DIVISION_ID
                       AND a.SCM_SITE_ID  = rslt.N_SCM_SITE_ID
                WHERE VALID_YN           = 'Y'
                  AND a.MEASURE_GROUP    = 'CUST_FCST'
                  AND a.PLAN_WEEK        = (SELECT MAX(PLAN_WEEK) FROM DM_MST_CUSTOMER_FCST)
                  AND a.SUMMARY_BUCKET_VALUE >= TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')
                  AND SUMMARY_BUCKET_TYPE IN ('MONTHLY')
           ) z;

    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DMF7_SITE_CUST_MAP',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1',
        no_invalidate    => FALSE
    );

    /*현재 고치는 CUSTOMER FCST MASTER의 MEASURE로 입력 MARKETING FCST 값이 있는지 VALIDATION */
    --INSERT /*+ APPEND PARALLEL(4) */ INTO GT_DMF7_DELETE_TARGET
    INSERT /*+ NO_PARALLEL */ INTO GT_DMF7_DELETE_TARGET
        (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID)
    SELECT T1.DIVISION_ID,
           T1.SCM_SITE_ID,
           T1.PROJECT_CODE,
           T1.ITEM_ID,
           T1.DOM_EXP,
           T1.FCST_TYPE,
           T1.INCOTERMS,
           T1.PLANT_SITE_ID
      FROM (
                SELECT T1.DIVISION_ID,
                       T1.SCM_SITE_ID,
                       T1.PROJECT_CODE,
                       T1.ITEM_ID,
                       T1.DOM_EXP,
                       T1.FCST_TYPE,
                       T1.INCOTERMS,
                       T1.MEASURE,
                       T1.PLANT_SITE_ID
                  FROM SCM_MGR.DM_PLN_MKT_FCST T1
                 INNER JOIN SCM_MGR.DM_MST_CUSTOMER_FCST T2
                         ON T1.DIVISION_ID = T2.DIVISION_ID
                        AND T1.SCM_SITE_ID  = T2.SCM_SITE_ID
                        AND (T1.MEASURE = T2.MEASURE OR T1.MEASURE = 'CUST_FCST')
                 GROUP BY
                       T1.DIVISION_ID,
                       T1.SCM_SITE_ID,
                       T1.PROJECT_CODE,
                       T1.ITEM_ID,
                       T1.DOM_EXP,
                       T1.FCST_TYPE,
                       T1.INCOTERMS,
                       T1.MEASURE,
                       T1.PLANT_SITE_ID
           ) T1
     INNER JOIN (SELECT DISTINCT N_DIVISION_ID, N_SCM_SITE_ID FROM GT_DMF7_RESULTS) T2
             ON T1.DIVISION_ID = T2.N_DIVISION_ID
            AND T1.SCM_SITE_ID  = T2.N_SCM_SITE_ID
     GROUP BY T1.DIVISION_ID,
              T1.SCM_SITE_ID,
              T1.PROJECT_CODE,
              T1.ITEM_ID,
              T1.DOM_EXP,
              T1.FCST_TYPE,
              T1.INCOTERMS,
              T1.PLANT_SITE_ID
    HAVING COUNT(MEASURE) > 1;

    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DMF7_DELETE_TARGET',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1',
        no_invalidate    => FALSE
    );

    DELETE FROM SCM_MGR.DM_PLN_MKT_FCST T1
     WHERE T1.MEASURE = 'CUST_FCST'
       AND EXISTS (
               SELECT 1
                 FROM SCM_MGR.GT_DMF7_DELETE_TARGET T2
                WHERE T1.DIVISION_ID   = T2.DIVISION_ID
                  AND T1.SCM_SITE_ID   = T2.SCM_SITE_ID
                  AND T1.PROJECT_CODE  = T2.PROJECT_CODE
                  AND T1.ITEM_ID       = T2.ITEM_ID
                  AND T1.DOM_EXP       = T2.DOM_EXP
                  AND T1.FCST_TYPE     = T2.FCST_TYPE
                  AND T1.INCOTERMS     = T2.INCOTERMS
                  AND T1.PLANT_SITE_ID = T2.PLANT_SITE_ID
           );

    --INSERT /*+ APPEND PARALLEL(4) */ INTO DM_PLN_MKT_FCST
    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    SELECT  a.DIVISION_ID,
            a.PROJECT_CODE,
            a.SCM_SITE_ID,
            a.ITEM_ID,
            a.DOM_EXP,
            a.FCST_TYPE,
            a.INCOTERMS,
            'CUST_FCST',
            a.PLANT_SITE_ID,
            a.YYYYMMDD,
            a.QTY,
            a.CREATED_BY,
            a.CREATION_DATE,
            a.LAST_UPDATED_BY,
            a.LAST_UPDATE_DATE,
            a.ATTRIBUTE1,
            a.ATTRIBUTE2,
            a.ATTRIBUTE3,
            a.ATTRIBUTE4,
            a.ATTRIBUTE5,
            a.ATTRIBUTE6,
            a.ATTRIBUTE7,
            a.ATTRIBUTE8,
            a.ATTRIBUTE9,
            a.ATTRIBUTE10
      FROM DM_PLN_MKT_FCST a
     INNER JOIN (SELECT DISTINCT N_DIVISION_ID, N_SCM_SITE_ID FROM SCM_MGR.GT_DMF7_RESULTS) rslt
             ON a.DIVISION_ID = rslt.N_DIVISION_ID
            AND a.SCM_SITE_ID  = rslt.N_SCM_SITE_ID
     INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
                   FROM SCM_MGR.GT_DMF7_SITE_CUST_MAP
                  GROUP BY DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY) map
             ON a.DIVISION_ID  = map.DIVISION_ID
            AND a.SCM_SITE_ID  = map.SCM_SITE_ID
            AND a.MEASURE      = map.MEASURE
     WHERE a.YYYYMMDD BETWEEN map.START_DAY AND map.END_DAY
       AND a.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE - 7, 'MON'), 'YYYYMMDD');

    n_log_count := SQL%ROWCOUNT;

    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_log_count) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        v_log_type    := 'ERROR';
        v_log_message := 'EXCEPTION';
        v_description := '';
        d_event_date  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'          VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'          VALUE P_DIVISION_ID,
            'P_PLAN_WEEK'            VALUE P_PLAN_WEEK,
            'P_CUSTOMER_CODE'        VALUE P_CUSTOMER_CODE,
            'P_SCM_SITE_ID'          VALUE P_SCM_SITE_ID,
            'P_MEASURE_GROUP'        VALUE P_MEASURE_GROUP,
            'P_MEASURE'              VALUE P_MEASURE,
            'P_VALID_YN'             VALUE P_VALID_YN,
            'P_CUSTOMER_PSI'         VALUE P_CUSTOMER_PSI,
            'P_UPLOAD_UOM'           VALUE P_UPLOAD_UOM,
            'P_UPLOAD_BUCKET_TYPE'   VALUE P_UPLOAD_BUCKET_TYPE,
            'P_SUMMARY_BUCKET_TYPE'  VALUE P_SUMMARY_BUCKET_TYPE,
            'P_SUMMARY_BUCKET_VALUE' VALUE P_SUMMARY_BUCKET_VALUE,
            'P_SUMMARY_BUCKET_YN'    VALUE P_SUMMARY_BUCKET_YN,
            'P_EDI_FCST_YN'          VALUE P_EDI_FCST_YN,
            'P_CREATED_BY'           VALUE P_CREATED_BY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message,
                v_description, d_event_date, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_DMF0007_SAVE_CUST_FCST_DATA;

FUNCTION F_FN_REPLACE_CLOB(
    P_SOURCE      IN CLOB,
    P_SEARCH      IN VARCHAR2,
    P_REPLACEMENT IN CLOB
) RETURN CLOB
/****************************************************************************************************/
/* PROGRAM ID  : F_FN_REPLACE_CLOB                                                                  */
/* DESCRIPTION : F_FN_REPLACE_CLOB                                                                  */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.27  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          CLOB 내에 문자 바꾸기                                                      */
/****************************************************************************************************/
IS
    V_RESULT       CLOB;
    V_SOURCE_LEN   PLS_INTEGER;
    V_SEARCH_LEN   PLS_INTEGER := LENGTH(P_SEARCH);
    V_POS          PLS_INTEGER := 1;
    V_FOUND        PLS_INTEGER;
    V_DEST_OFFSET  PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_RESULT, TRUE);

    IF P_SOURCE IS NULL OR P_SEARCH IS NULL THEN
        IF P_SOURCE IS NOT NULL THEN
            DBMS_LOB.APPEND(V_RESULT, P_SOURCE);
        END IF;
        RETURN V_RESULT;
    END IF;

    V_SOURCE_LEN := DBMS_LOB.GETLENGTH(P_SOURCE);
    V_FOUND := DBMS_LOB.INSTR(P_SOURCE, P_SEARCH, 1, 1);

    IF V_FOUND = 0 THEN
        DBMS_LOB.APPEND(V_RESULT, P_SOURCE);
        RETURN V_RESULT;
    END IF;

    WHILE V_FOUND > 0 LOOP
        IF V_FOUND > V_POS THEN
            V_DEST_OFFSET := DBMS_LOB.GETLENGTH(V_RESULT) + 1;
            DBMS_LOB.COPY(V_RESULT, P_SOURCE, V_FOUND - V_POS, V_DEST_OFFSET, V_POS);
        END IF;

        IF P_REPLACEMENT IS NOT NULL THEN
            DBMS_LOB.APPEND(V_RESULT, P_REPLACEMENT);
        END IF;

        V_POS := V_FOUND + V_SEARCH_LEN;
        V_FOUND := DBMS_LOB.INSTR(P_SOURCE, P_SEARCH, V_POS, 1);
    END LOOP;

    IF V_POS <= V_SOURCE_LEN THEN
        V_DEST_OFFSET := DBMS_LOB.GETLENGTH(V_RESULT) + 1;
        DBMS_LOB.COPY(V_RESULT, P_SOURCE, V_SOURCE_LEN - V_POS + 1, V_DEST_OFFSET, V_POS);
    END IF;

    RETURN V_RESULT;
END F_FN_REPLACE_CLOB;

PROCEDURE P_PR_PRINT_CLOB(
    P_TITLE IN VARCHAR2,
    P_TEXT  IN CLOB
)
/****************************************************************************************************/
/* PROGRAM ID  : P_PR_PRINT_CLOB                                                                    */
/* DESCRIPTION : P_PR_PRINT_CLOB                                                                    */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.27  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          CLOB SQL 확인용                                                          */
/****************************************************************************************************/
IS
    V_POS    PLS_INTEGER := 1;
    V_LEN    PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_TEXT), 0);
    V_CHUNK  VARCHAR2(8000 CHAR);
BEGIN
    DBMS_OUTPUT.PUT_LINE('[' || P_TITLE || '] LENGTH=' || V_LEN);

    WHILE V_POS <= V_LEN LOOP
        V_CHUNK := DBMS_LOB.SUBSTR(P_TEXT, 8000, V_POS);
        DBMS_OUTPUT.PUT_LINE(V_CHUNK);
        V_POS := V_POS + LENGTH(V_CHUNK);
    END LOOP;
END P_PR_PRINT_CLOB;

END PKG_DMF0007;
/
