/*=============================================================================================
 * File         : 04_Package_PKG_DMF0008.sql
 * Description  : Package — PKG_DMF0008
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0008 IS
    /*
    * Program ID   : PKG_DMF0008
    * Description  : PKG_DMF0008
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR
    (
        P_DIVISION_ID   	IN VARCHAR2
       ,P_SENDER_NAME   	IN VARCHAR2
       ,P_FLAG          	IN VARCHAR2
       ,P_USER_ID       	IN VARCHAR2
       ,P_MENU_ID       	IN VARCHAR2
       ,O_RC1           	OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR 	OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY
    (
        P_DIVISION_ID   	IN VARCHAR2 --쓰임
       ,P_USER_ID       	IN VARCHAR2
       ,P_MENU_ID       	IN VARCHAR2
       ,O_RC1           	OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR 	OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0008_GET_SALES_SITE
    (
        P_DIVISION_ID   	IN VARCHAR2
       ,P_SOLDTO        	IN VARCHAR2
       ,P_SHIPTO        	IN VARCHAR2
       ,P_SCM_SITE_ID   	IN VARCHAR2
       ,P_USER_ID       	IN VARCHAR2
       ,P_MENU_ID       	IN VARCHAR2
       ,O_RC1           	OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR 	OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0008_GET_SALES_SITE_PROJECT_MODEL
    (
        P_DIVISION_ID   	IN VARCHAR2
       ,P_ITEM_ID       	IN VARCHAR2
       ,P_SCM_SITE_ID    	IN VARCHAR2
       ,P_USER_ID       	IN VARCHAR2
       ,P_MENU_ID       	IN VARCHAR2
       ,O_RC1           	OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR 	OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR
    (
        P_DATA			  	IN CLOB
       ,P_USER_ID	      	IN VARCHAR2
       ,O_RESULT_CURSOR		OUT SYS_REFCURSOR
    );

   
    PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR
    (
        P_DATA				IN CLOB
       ,P_USER_ID 			IN VARCHAR2
       ,O_RESULT_CURSOR    	OUT SYS_REFCURSOR
    );
   
   	PROCEDURE P_DMF0008_DNM_EDI_CALLOFF_STATUS;
   
END PKG_DMF0008;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0008 IS

    PROCEDURE P_DMF0008_GET_EDI_MST_REPAIR
    (
    	-- P_FROM_YYYYMMDD VARCHAR2
    	-- P_TO_YYYYMMDD VARCHAR2
        P_DIVISION_ID   VARCHAR2
       ,P_SENDER_NAME   VARCHAR2
       ,P_FLAG          VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0008_GET_EDI_MST_REPAIR
         * Description  :
         * Program History
         *===================================================================================================
         *   Date    In Charge      Description
         *===================================================================================================
        * 2023.04.05 kdmcc14        []  ERP, EDI MASTER DATA 정비 SUMMARY
        * 2023.09.20 chutoc730      []  제외 ITEM_ID 적용(DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE)
        * 2023.11.30 KJJ            []  제외 필드 추가 : EXCEPTION_FLAG, EXCEPTION_DATE
        * 2024.04.18 HMIN       [E20240405-001867]_[공급 SCM PI팀] ERP EDI Master화면 '예외 처리' 칼럼 추가 및 조회 로직 개선
        * 2024.07.03 JSSBAE         [E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
        * 2024-12-31 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
        * 2025-01-21 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
        * 2026-03-15 김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
        * 2026-04-22 강민재			기존 코드 주석 삭제 및 필요없는 param 주석처리
         DMF0008_GET_EDI_MST_REPAIR('81', '20230401', '20230931', 'BMW', '5');
         DMF0008_GET_EDI_MST_REPAIR('81', '20230401', '20230931', 'AUDI/VW');
         DMF0008_GET_EDI_MST_REPAIR('81', '20230401', '20230931', 'VOLVO');
         */
        -- -------------------------------------------------------------------------------------------------------------------------------
     AS
    
        V_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
        V_TO_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_IN_PARA_DATA  VARCHAR2(4000);
        V_LOG_TYPE      VARCHAR2(20) := NULL;
        N_LOG_COUNT     NUMBER := 0;
        V_LOG_MESSAGE   VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION   VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE    DATE := SYSDATE;
        V_PROC_INPUT    CLOB := NULL;
        V_SQL_CODE      VARCHAR2(100) := NULL;
        V_SQL_ERRMSG    VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE     VARCHAR2(4000 CHAR) := NULL;
        $$PLSQL_UNIT  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT('p_DIVISION_ID' VALUE P_DIVISION_ID
                                     ,'p_Sender_Name' VALUE P_SENDER_NAME
                                     ,'p_Flag' VALUE P_FLAG);
    
        /* --2024-12-31 변경
        
        --오늘 기준 전전월(M-2 월의 1일)부터 현재까지 데이터 조회
        --v_FROM_YYYYMMDD := '20230101'
        v_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'YYYYMMDD') || '01';
        */
        --현재시점으로 과거 52주 구간의 가장 최신인 EDI 데이터를 가져 온다.
        --v_FROM_YYYYMMDD := TO_CHAR(SYSDATE + (-52)*7, 'YYYYMMDD'); -- 현재 요일 기준 52주 구하기
        V_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - 52 * 7, 'YYYYMMDD'); -- 52주전의 월요일 구하기
    
        OPEN O_RC1 FOR
            SELECT TF.DIVISION_ID
                  ,TF.EDI_SENDER_CODE
                  ,TF.EDI_SENDER_NAME
                  ,TF.CUST_UNLOADING_POINT
                  ,TF.CUST_PLANT
                  ,TF.CUST_ITEM_ID 
                  ,TF.ERP_SHIPTO
                  ,TF.ERP_SOLDTO
                  ,TF.ERP_ITEM_ID
                  ,TF.SCM_SITE_ID
                  ,TF.STATUS_CODE
                  ,TF.SSPM_STATUS
                  ,TF.EDI_INCOTERMS
                  ,TF.PROJECT_CODE
                  ,TF.END_CUSTOMER
                  ,TF.GSCM_SALES_SITE_ID
                  ,TF.ACTIVE_SS
                  ,TF.GSCM_SSPM
                  ,TF.GSCM_SSPM_INCOTERMS
                  ,TF.ACTIVE_SSPM
                  ,TF.PROJECT_STATUS
                  ,TF.PLANT_SITE_STATUS
                  ,TF."EXCEPTION"
                   ,TF.EXCEPTION_DATE
                   ,TF.EXCEPTION_FLAG
                   ,TF.CNT
                   ,TF.SALES_PLANT_SITE_STATUS
                   ,TF.ERP_STATUS
                   ,TF.INPUT_DATE
                   ,TF.LAST_UPDATE_DATE
                   /* SUMMARY 확인용 */
                   -- , TF.ERP_MASTER_DATA
                   ,TF.GSCM_MASTER_DATA
                   ,TF.SUCCESS
                   ,TF.TTT
                   ,TF.STATUS_CODE_
                   ,TEI.EDIT_YN
            FROM   (SELECT A.DIVISION_ID
                          ,A.SENDER_CODE EDI_SENDER_CODE
                          ,A.SENDER_NAME EDI_SENDER_NAME
                          ,A.UNLOADING_POINT CUST_UNLOADING_POINT
                          ,A.CUSTOMER_PLANT CUST_PLANT
                          ,A.CUST_MATERIAL_CODE CUST_ITEM_ID
                          ,A.SHIPTO_CODE ERP_SHIPTO
                          ,A.SOLDTO_CODE ERP_SOLDTO
                          ,A.ITEM_ID ERP_ITEM_ID
                          ,A.SCM_SITE_ID
                          ,A.STATUS_CODE
                          ,A.SSPM_STATUS
                          ,A.EDI_INCOTERMS --, CREATE_DATE
                          ,A.PROJECT_CODE
                          ,B.END_CUSTOMER
                          ,A.SALES_PLANT_SITE_STATUS
                          ,A.ERP_STATUS
                          ,CASE
                               WHEN A.STATUS_CODE IN ('U', 'E') AND A.EXCEPTION_FLAG != 'Y' THEN
                                1
                               ELSE
                                0
                           END AS GSCM_MASTER_DATA
                          ,CASE
                               WHEN A.STATUS_CODE = 'S' AND A.EXCEPTION_FLAG != 'Y' THEN
                                1
                               ELSE
                                0
                           END AS SUCCESS
                           /* SUMMARY 비교용 */
                           --, CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP'  AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS ERP_MASTER_DATA
                           -- , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                           -- , CASE WHEN A.STATUS_CODE = 'S'       AND A.ERP_STATUS IS NULL          AND NVL(A.EXCEPTION_fLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                          ,CASE
                               WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'E' AND A.EXCEPTION_FLAG != 'Y' THEN
                                1
                               ELSE
                                0
                           END AS TTT
                           /* -------------*/
                          ,CASE
                               WHEN A.SCM_SITE_ID IS NOT NULL THEN
                                A.SCM_SITE_ID
                               ELSE
                                '확인필요'
                           END AS GSCM_SALES_SITE_ID
                          ,CASE
                               WHEN A.SALES_SITE_STATUS = 'S' THEN
                                'Y'
                               ELSE
                                '확인필요'
                           END AS ACTIVE_SS
                          ,CASE
                               WHEN A.SSPM_STATUS = 'S' THEN
                                'Y'
                               ELSE
                                '확인필요'
                           END AS GSCM_SSPM
                          ,CASE
                               WHEN A.INCOTERMS_STATUS = 'S' THEN
                                A.EDI_INCOTERMS
                               ELSE
                                '확인필요'
                           END AS GSCM_SSPM_INCOTERMS
                          ,CASE
                               WHEN A.SSPM_STATUS = 'S' THEN
                                'Y'
                               ELSE
                                '확인필요'
                           END AS ACTIVE_SSPM
                           /* , CASE WHEN NVL((SELECT VALID_YN FROM SCM_MST_PROJECT_ITEM
                           WHERE DIVISION_ID = p_DIVISION_ID
                           AND PROJECT_CODE  = A.PROJECT_CODE
                           AND ITEM_ID = A.ITEM_ID), '') = 'Y' THEN '' ELSE '확인필요' END AS ACTIVE_SSPM */
                           --, CASE WHEN A.PROJECT_STATUS  = 'S'        THEN NULL ELSE '확인필요' END AS PROJECT_STATUS
                           --, CASE WHEN A.SALES_PLANT_SITE_STATUS  = 'S' THEN NULL ELSE '확인필요' END AS PLANT_SITE_STATUS
                          ,CASE
                               WHEN A.PROJECT_STATUS = 'S' THEN
                                A.PROJECT_CODE
                               ELSE
                                '확인필요'
                           END AS PROJECT_STATUS
                          ,CASE
                               WHEN A.SALES_PLANT_SITE_STATUS = 'S' THEN
                                A.SALES_PLANT_SITE_ID
                               ELSE
                                '확인필요'
                           END AS PLANT_SITE_STATUS
                          ,CASE
                               WHEN A.EXCEPTION_FLAG = 'Y' THEN
                                1
                               ELSE
                                0
                           END AS "EXCEPTION"
                           ,NVL(TO_CHAR(MAX(A.EXCEPTION_DATE), 'YYYYMMDD'), '') EXCEPTION_DATE
                           ,A.EXCEPTION_FLAG EXCEPTION_FLAG
                           ,COUNT(1) CNT
                           ,MAX(CREATE_DATE) INPUT_DATE
                           ,TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYYMMDD') LAST_UPDATE_DATE
                           ,SUM(CASE
                                   WHEN STATUS_CODE IN ('U', 'E') AND A.EXCEPTION_FLAG != 'Y' THEN
                                    1
                                   ELSE
                                    0
                               END) STATUS_CODE_
                           ,SUM(CASE
                                   WHEN A.EXCEPTION_FLAG = 'Y' THEN
                                    1
                                   ELSE
                                    0
                               END) STATUS_CODE_EXCEP
                    FROM   DM_DNM_EDI_CALLOFF_ITEM A
                    LEFT   OUTER JOIN SCM_MST_SITE B
                    ON     A.DIVISION_ID = B.DIVISION_ID
                    AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND    B.SITE_TYPE = 'SALES'
                    AND    B.VALID_YN = 'Y'
                    WHERE  A.CREATE_DATE >= V_FROM_YYYYMMDD
                    AND    A.DIVISION_ID = P_DIVISION_ID
                    AND    A.SENDER_NAME = P_SENDER_NAME
                    AND    A.ERP_STATUS = 'S' -- RDD가 이상하게 들어오면 버림
                    AND    LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444') /* 20240422 추가 YYYYMMDD = '444444' 인 데이터가 들어오고있는데...이 데이터는 날짜형태가 부적합 하기 때문에 사용이 불가;
                                                                                                                                                                                                                                                                                                                                                                        따라서 정비 필요 모수에서 제외하는게 적절해 보인다로 내부의견을 전달 드립니다. */
                    /* ----------------------------------------------------------------------------------------------------- */
                    --AND A.SENDER_NAME   <> 'LUCID'
                    --AND A.ERP_STATUS    <> 'E' -- RDD가 이상하게 들어오면 버림
                    --AND A.STATUS_CODE   <> 'X' -- 어디서 업뎃했는지 모르겠는데, 지금 사용불가
                    /* ----------------------------------------------------------------------------------------------------- */
                    GROUP  BY A.DIVISION_ID
                             ,A.SENDER_CODE
                             ,A.SENDER_NAME
                             ,A.UNLOADING_POINT
                             ,A.CUSTOMER_PLANT
                             ,A.CUST_MATERIAL_CODE
                             ,A.SHIPTO_CODE
                             ,A.SOLDTO_CODE
                             ,A.ITEM_ID
                             ,A.SCM_SITE_ID
                             ,A.STATUS_CODE
                             ,A.SSPM_STATUS
                             ,A.EDI_INCOTERMS
                             ,A.PROJECT_CODE
                             ,B.END_CUSTOMER
                             ,A.SALES_PLANT_SITE_STATUS
                             ,A.ERP_STATUS
                             ,A.EXCEPTION_FLAG
                             ,A.SALES_SITE_STATUS
                             ,A.INCOTERMS_STATUS
                             ,A.PROJECT_STATUS
                             ,A.SALES_PLANT_SITE_ID
                    
                    ) TF
            INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
            ON     TEI.UNIT_ID = TF.DIVISION_ID
            WHERE  1 = 1
                  /* Flag별 조회조건
                  =======================================================
                  sFlag(sFlag)  설명                          columnindex
                  =======================================================
                  ING_ERP       ERP Master Data  정비필요             <-- 사용안함 현재는 Column Index 가 3이면 EDI Sender Name 컬럼. (2면 Div)
                  ING_GSCM      GSCM Master Data 정비필요         4
                  S             정상                              5
                  EXCEPTION     예외처리                          6
                  =======================================================   */
			AND    (
			        NVL(P_FLAG, '0') = '0'
			        OR (P_FLAG = '4' AND TF.STATUS_CODE <> 'S' AND NVL(TF.EXCEPTION_FLAG, '') <> 'Y') -- AND TF.EXCEPTION_FLAG <> 'Y' AND TF.STATUS_CODE_EXCEP > 0)
			        OR (P_FLAG = '5' AND TF.STATUS_CODE = 'S' AND NVL(TF.STATUS_CODE_EXCEP, 0) = 0)
			        OR (P_FLAG = '6' AND NVL(TF.EXCEPTION_FLAG, '') = 'Y' AND TF.STATUS_CODE_EXCEP > 0)
			       )
			-- 강민재 수정
--            AND    CASE
--                      WHEN NVL(P_FLAG, '0') > '0' THEN
--                       (CASE
--                           WHEN NVL(P_FLAG, '0') = '6' THEN
--                            TF.EXCEPTION_FLAG
--                           ELSE
--                            CASE
--                                WHEN TF.STATUS_CODE = 'S' THEN
--                                 'S'
--                                ELSE
--                                 'U'
--                            END
--                       END)
--                      ELSE
--                       'ZZ'
--                  END = CASE
--                       WHEN P_FLAG = '4' THEN
--                        'U'
--                       WHEN P_FLAG = '5' THEN
--                        'S'
--                       WHEN P_FLAG = '6' THEN
--                        'Y'
--                       ELSE
--                        'ZZ'
--                   END
--            AND    CASE
--                      WHEN P_FLAG = '5' /*정상*/
--                       THEN --9999
--                       (CASE
--                           WHEN NVL(TF.STATUS_CODE_EXCEP, 0) > 0 THEN
--                            0
--                           ELSE
--                            1
--                       END)
--                      ELSE
--                       CASE
--                           WHEN P_FLAG = '6' THEN
--                            TF. STATUS_CODE_EXCEP
--                           ELSE
--                            TF.STATUS_CODE_
--                       END
--                  END > 0
            ORDER  BY TF.EDI_SENDER_CODE, TF.LAST_UPDATE_DATE;
           
    
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
    END P_DMF0008_GET_EDI_MST_REPAIR;

    PROCEDURE P_DMF0008_GET_EDI_MST_SUMMARY
    (
        -- P_FROM_YYYYMMDD VARCHAR2
        -- P_TO_YYYYMMDD   VARCHAR2
        P_DIVISION_ID   VARCHAR2 --쓰임
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0008_GET_EDI_MST_SUMMARY
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        2023.04.05      kdmcc14        []  ERP, EDI MASTER DATA 정비 SUMMARY
        2023.09.20      chutoc730  []  제외 ITEM_ID 적용(DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE)
        2024.04.18    HMIN         [E20240405-001867]_[공급 SCM PI팀] ERP EDI Master화면 '예외 처리' 칼럼 추가 및 조회 로직 개선
        2024.07.03      JSSBAE     [E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
        2024-12-31    dsiol        [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
        2025-01-21 dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
        2026-03-15 김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
        2026-04-22 강민재		   예전 코드 및 안 쓰이는 param 주석 처리
        DMF0008_GET_EDI_MST_SUMMARY('', '', '81');
        DMF0008_GET_EDI_MST_SUMMARY('', '', '81_UC');
        */
        -- -------------------------------------------------------------------------------------------------------------------------------
     AS
    
        V_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
        V_TO_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_IN_PARA_DATA  VARCHAR2(4000);
        V_LOG_TYPE      VARCHAR2(20) := NULL;
        N_LOG_COUNT     NUMBER := 0;
        V_LOG_MESSAGE   VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION   VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE    DATE := SYSDATE;
        V_PROC_INPUT    CLOB := NULL;
        V_SQL_CODE      VARCHAR2(100) := NULL;
        V_SQL_ERRMSG    VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE     VARCHAR2(4000 CHAR) := NULL;
        $$PLSQL_UNIT  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    BEGIN
    
        V_IN_PARA_DATA := JSON_OBJECT(
       								  -- 'p_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD, 'p_TO_YYYYMMDD' VALUE P_TO_YYYYMMDD, 
       								 'p_DIVISION_ID' VALUE P_DIVISION_ID);
    
        /* --2024-12-31 변경
        
        --오늘 기준 전전월(M-2 월의 1일)부터 현재까지 데이터 조회
        --v_FROM_YYYYMMDD := '20230101'
        v_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, -2), 'YYYYMMDD') || '01';
        */
        --현재시점으로 과거 52주 구간의 가장 최신인 EDI 데이터를 가져 온다.
        --v_FROM_YYYYMMDD := TO_CHAR(SYSDATE + (-52)*7, 'YYYYMMDD'); -- 현재 요일 기준 52주 구하기
        V_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');
       	DBMS_OUTPUT.PUT_LINE(V_FROM_YYYYMMDD);
    
        BEGIN
        
            OPEN O_RC1 FOR
                SELECT T.DIVISION_ID AS DIVISION_ID
                      ,T.SENDER_NAME EDI_SENDER_NAME
                      ,SUM(GSCM_MASTER_DATA) GSCM_MASTER_DATA
                       --, SUM(ERP_MASTER_DATA) ERP_MASTER_DATA
                      ,SUM(SUCCESS) SUCCESS
                      ,SUM("EXCEPTION") EXCEPTION_DATA
                       ,COUNT(1) CNT
                       ,TEI.EDIT_YN
                FROM   (SELECT A.DIVISION_ID
                              ,A.SENDER_CODE
                              ,A.SENDER_NAME
                              ,A.UNLOADING_POINT
                              ,A.CUSTOMER_PLANT
                              ,A.CUST_MATERIAL_CODE
                              ,A.SHIPTO_CODE
                              ,A.SOLDTO_CODE
                              ,A.ITEM_ID
                              ,A.SCM_SITE_ID
                              ,A.STATUS_CODE
                              ,A.SSPM_STATUS
                              ,A.EDI_INCOTERMS --, CREATE_DATE
                              ,A.PROJECT_CODE
                              ,B.END_CUSTOMER
                              ,A.SALES_PLANT_SITE_STATUS
                              ,A.ERP_STATUS
                               -- FROM DUAL;
                               /* 2025.01.10 Philsu Park 수정 */
                              ,CASE
                                   WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, '') != 'Y' THEN
                                    1
                                   ELSE
                                    0
                               END AS GSCM_MASTER_DATA
                              ,CASE
                                   WHEN A.STATUS_CODE = 'S' AND NVL(A.EXCEPTION_FLAG, '') != 'Y' THEN
                                    1
                                   ELSE
                                    0
                               END AS SUCCESS
--                               , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_ERP'  AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS ERP_MASTER_DATA
--                               , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'ING_GSCM' AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
--                               , CASE WHEN A.STATUS_CODE = 'S'          AND A.ERP_STATUS IS NULL          AND NVL(A.EXCEPTION_fLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS SUCCESS
--                               , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND A.ERP_STATUS = 'E'     AND NVL(A.EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END AS TTT
                              ,CASE
                                   WHEN A.EXCEPTION_FLAG = 'Y' THEN
                                    1
                                   ELSE
                                    0
                               END AS "EXCEPTION"
                        FROM   DM_DNM_EDI_CALLOFF_ITEM A
                        LEFT   OUTER JOIN SCM_MST_SITE B
                        ON     A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                        AND    B.SITE_TYPE = 'SALES'
                        AND    B.VALID_YN = 'Y'
                        WHERE  A.CREATE_DATE >= V_FROM_YYYYMMDD
                        AND    A.DIVISION_ID = P_DIVISION_ID
                        AND    A.ERP_STATUS = 'S' -- ERP Status 정상인 대상만 Count.
                        AND    LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444') /* 20240422 추가 YYYYMMDD = '444444' 인 데이터가 들어오고있는데...이 데이터는 날짜형태가 부적합 하기 때문에 사용이 불가;
                                                                                                                                                                                                                                                                                                                                                                                                                                       따라서 정비 필요 모수에서 제외하는게 적절해 보인다로 내부의견을 전달 드립니다. */
                        /*----------------------------------------------------------------------*/
                        --AND A.SENDER_NAME   <> 'LUCID'
                        --AND A.ERP_STATUS    <> 'E' -- RDD가 이상하게 들어오면 버림
                        --AND A.STATUS_CODE   <> 'X' -- 어디서 업뎃했는지 모르겠는데, 지금 사용불가
                        /*----------------------------------------------------------------------*/
                        GROUP  BY A.DIVISION_ID
                                 ,A.SENDER_CODE
                                 ,A.SENDER_NAME
                                 ,A.UNLOADING_POINT
                                 ,A.CUSTOMER_PLANT
                                 ,A.CUST_MATERIAL_CODE
                                 ,A.SHIPTO_CODE
                                 ,A.SOLDTO_CODE
                                 ,A.ITEM_ID
                                 ,A.SCM_SITE_ID
                                 ,A.STATUS_CODE
                                 ,A.SSPM_STATUS
                                 ,A.EDI_INCOTERMS
                                 ,A.PROJECT_CODE
                                 ,B.END_CUSTOMER
                                 ,A.SALES_PLANT_SITE_STATUS
                                 ,A.ERP_STATUS
                                 ,A.EXCEPTION_FLAG) T
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = T.DIVISION_ID
                GROUP  BY T.DIVISION_ID, T.SENDER_NAME, TEI.EDIT_YN
                ORDER  BY T.SENDER_NAME; 
        END;
    
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
    END P_DMF0008_GET_EDI_MST_SUMMARY;

    PROCEDURE P_DMF0008_GET_SALES_SITE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_SOLDTO        VARCHAR2
       ,P_SHIPTO        VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0008_GET_SALES_SITE
         * Description  :
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         2023.04.05      kdmcc14          []  ERP, EDI MASTER DATA 정비 SALES_SITE
         2024.12.31    dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선
         2025.01.21    dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
         2026.03.26   김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        --DE000161  DEH000086
        
        DMF0008_GET_SALES_SITE('81', 'DE000161', 'DEH000086');
        DMF0008_GET_SALES_SITE('81','A009SV 01', 'ITH000059', 'Porsche AS_DE_SSN');
        DMF0008_GET_SALES_SITE('81','DE000206', 'DEH000430', 'Porsche_DE_SHM');
         */
        -- -------------------------------------------------------------------------------------------------------------------------------
     AS
    
        $$PLSQL_UNIT VARCHAR2(200) := $$PLSQL_UNIT;
        V_CNT_1        INTEGER := 0;
        V_IN_PARA_DATA VARCHAR2(4000);
        V_STEP         VARCHAR2(4000 CHAR) := NULL;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GSSI_DMF0008_RESULT_TABLE_1';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GSSI_DMF0008_RESULT_TABLE_2';
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_soldto' VALUE P_SOLDTO
                                     ,'p_shipto' VALUE P_SHIPTO
                                     ,'p_scm_site_id' VALUE P_SCM_SITE_ID);
    
        IF UTL_CALL_STACK.SUBPROGRAM(1) (1) IS NOT NULL THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        -- 테이블중복제거
        -- 임시확인용테이블 중복제거
        -- 테이블중복제거
        -- 임시확인용테이블 중복제거
        --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선
        --Division, Sold to, Ship to, Sales Site 가 이미 있다면 아래조건으로 조회
        BEGIN
            INSERT /*+ NO_PARALLEL */
            INTO GT_GSSI_DMF0008_RESULT_TABLE_1
                SELECT TEMP.*
                FROM   (SELECT S.DIVISION_ID
                              ,CASE
                                   WHEN S.DIVISION_ID = '40' THEN
                                    'XXX'
                                   ELSE
                                    T.DEPT_ID
                               END AS TEAM_ID
                              ,CASE
                                   WHEN S.DIVISION_ID = '40' THEN
                                    'XXX'
                                   ELSE
                                    T.DEPT_NAME_KO
                               END AS TEAM_NAME
                              ,CASE
                                   WHEN S.DIVISION_ID = '40' THEN
                                    'acer'
                                   ELSE
                                    S.END_CUSTOMER
                               END AS END_CUSTOMER
                              ,S.SOLDTO_CUSTOMER SOLDTO_CUSTOMER
                              ,C.SOLDTO_CODE REP_SOLDTO_CODE
                              ,C.SHIPTO_CODE REP_SHIPTO_CODE
                              ,S.COUNTRY
                              ,CO.COUNTRY_NAME
                              ,S.CITY
                              ,CT.CITY_NAME
                              ,S.SCM_SITE_ID SSCM_SITE_ID
                              ,S.COMPANY_ID
                              ,S.SITE_DESCRIPTION
                              ,S.ATTRIBUTE3 DISTRIBUTION_CHANNEL
                              ,S.VMI_YN
                              ,S.VALID_YN SITE_VALID_YN
                              ,C.VALID_YN CUSTOMER_VALID_YN
                              ,C.REP_YN REP_YN
                              ,S.LAST_UPDATED_BY
                              ,S.LAST_UPDATE_DATE
                              ,S.ATTRIBUTE2 SHIP_PLAN_AUTO
                              ,CASE
                                   WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST('p_created_by', T.DEPT_ID) = 'Y') OR 'v_group_id' = 'ADMIN') THEN
                                    'Y'
                                   WHEN S.DIVISION_ID = '40' AND
                                        ((FN_GET_DEPT_LIST2('p_created_by', S.SCM_SITE_ID) = 'Y') OR 'v_group_id' = 'ADMIN' OR 'p_created_by' = S.LAST_UPDATED_BY) THEN
                                    'Y'
                                   ELSE
                                    ''
                               END AS EDIT_FLAG
                              ,(SELECT NVL(MAX(LU.VALID_YN), '')
                                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LU
                                WHERE  LU.LOOKUP_TYPE = 'SALES_MGMT_TEAM'
                                AND    LU.VALID_YN = 'Y'
                                AND    (LU.SEGMENT1 = (SELECT MAX(DEPT_ID) FROM SCM_ADM_USER_M WHERE USER_ID = 'p_created_by') OR LU.SEGMENT1 = 'p_userinfo')
                                AND    'v_group_id' = 'ADMIN') TEAM_EDIT_FLAG
                              ,S.ATTRIBUTE5
                        FROM   SCM_MST_SITE S
                        LEFT   OUTER JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') T
                        ON     S.ATTRIBUTE4 = T.DEPT_ID
                        LEFT   OUTER JOIN SCM_MST_SITE_CUSTOMER C
                        ON     S.DIVISION_ID = C.DIVISION_ID
                        AND    S.SCM_SITE_ID = C.SCM_SITE_ID
                        LEFT   OUTER JOIN SCM_MST_COUNTRY CO
                        ON     S.COUNTRY = CO.COUNTRY
                        LEFT   OUTER JOIN SCM_MST_CITY CT
                        ON     S.COUNTRY = CT.COUNTRY
                        AND    S.CITY = CT.CITY
                        WHERE  1 = 1
                        AND    S.DIVISION_ID = P_DIVISION_ID
                        AND    S.SCM_SITE_ID = P_SCM_SITE_ID
                        AND    C.SOLDTO_CODE = P_SOLDTO
                        AND    C.SHIPTO_CODE = P_SHIPTO) TEMP;
        END;
    
        --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선
        --Division, Sold to, Ship to, Sales Site 으로 조회 했을 때 데이터가 없다면
        --기존대로 Division, Sold to, Ship to 으로 조회
        IF (SQL%ROWCOUNT = 0) THEN
            INSERT /*+ NO_PARALLEL */
            INTO GT_GSSI_DMF0008_RESULT_TABLE_2
                SELECT TEMP.*
                FROM   (SELECT S.DIVISION_ID
                              ,CASE
                                   WHEN S.DIVISION_ID = '40' THEN
                                    'XXX'
                                   ELSE
                                    T.DEPT_ID
                               END AS TEAM_ID
                              ,CASE
                                   WHEN S.DIVISION_ID = '40' THEN
                                    'XXX'
                                   ELSE
                                    T.DEPT_NAME_KO
                               END AS TEAM_NAME
                              ,CASE
                                   WHEN S.DIVISION_ID = '40' THEN
                                    'acer'
                                   ELSE
                                    S.END_CUSTOMER
                               END AS END_CUSTOMER
                              ,S.SOLDTO_CUSTOMER SOLDTO_CUSTOMER
                              ,C.SOLDTO_CODE REP_SOLDTO_CODE
                              ,C.SHIPTO_CODE REP_SHIPTO_CODE
                              ,S.COUNTRY
                              ,CO.COUNTRY_NAME
                              ,S.CITY
                              ,CT.CITY_NAME
                              ,S.SCM_SITE_ID SSCM_SITE_ID
                              ,S.COMPANY_ID
                              ,S.SITE_DESCRIPTION
                              ,S.ATTRIBUTE3 DISTRIBUTION_CHANNEL
                              ,S.VMI_YN
                              ,S.VALID_YN SITE_VALID_YN
                              ,C.VALID_YN CUSTOMER_VALID_YN
                              ,C.REP_YN REP_YN
                              ,S.LAST_UPDATED_BY
                              ,S.LAST_UPDATE_DATE
                              ,S.ATTRIBUTE2 SHIP_PLAN_AUTO
                              ,CASE
                                   WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST('p_created_by', T.DEPT_ID) = 'Y') OR 'v_group_id' = 'ADMIN') THEN
                                    'Y'
                                   WHEN S.DIVISION_ID = '40' AND
                                        ((FN_GET_DEPT_LIST2('p_created_by', S.SCM_SITE_ID) = 'Y') OR 'v_group_id' = 'ADMIN' OR 'p_created_by' = S.LAST_UPDATED_BY) THEN
                                    'Y'
                                   ELSE
                                    ''
                               END AS EDIT_FLAG
                              ,(SELECT NVL(MAX(LU.VALID_YN), '')
                                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LU
                                WHERE  LU.LOOKUP_TYPE = 'SALES_MGMT_TEAM'
                                AND    LU.VALID_YN = 'Y'
                                AND    (LU.SEGMENT1 = (SELECT MAX(DEPT_ID) FROM SCM_ADM_USER_M WHERE USER_ID = 'p_created_by') OR LU.SEGMENT1 = 'p_userinfo')
                                AND    'v_group_id' = 'ADMIN') TEAM_EDIT_FLAG
                              ,S.ATTRIBUTE5
                        FROM   SCM_MST_SITE S
                        LEFT   OUTER JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') T
                        ON     S.ATTRIBUTE4 = T.DEPT_ID
                        LEFT   OUTER JOIN SCM_MST_SITE_CUSTOMER C
                        ON     S.DIVISION_ID = C.DIVISION_ID
                        AND    S.SCM_SITE_ID = C.SCM_SITE_ID
                        LEFT   OUTER JOIN SCM_MST_COUNTRY CO
                        ON     S.COUNTRY = CO.COUNTRY
                        LEFT   OUTER JOIN SCM_MST_CITY CT
                        ON     S.COUNTRY = CT.COUNTRY
                        AND    S.CITY = CT.CITY
                        WHERE  1 = 1
                        AND    S.DIVISION_ID = P_DIVISION_ID
                        AND    C.SOLDTO_CODE = P_SOLDTO
                        AND    C.SHIPTO_CODE = P_SHIPTO) TEMP;
        END IF;
    
        SELECT COUNT(1) INTO V_CNT_1 FROM GT_GSSI_DMF0008_RESULT_TABLE_1;
        IF V_CNT_1 > 0 THEN
            OPEN O_RC1 FOR
                SELECT T.*, TEI.EDIT_YN
                FROM   GT_GSSI_DMF0008_RESULT_TABLE_1 T
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = T.DIVISION_ID;
        ELSE
            OPEN O_RC1 FOR
                SELECT T.*, TEI.EDIT_YN
                FROM   GT_GSSI_DMF0008_RESULT_TABLE_2 T
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = T.DIVISION_ID;
        END IF;
        COMMIT;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
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
    END P_DMF0008_GET_SALES_SITE;

    PROCEDURE P_DMF0008_GET_SALES_SITE_PROJECT_MODEL
    (
        P_DIVISION_ID   VARCHAR2
       ,P_ITEM_ID       VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0008_GET_SALES_SITE_PROJECT_MODEL
         * Description  :
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         2023.04.05      kdmcc14          []  ERP, EDI MASTER DATA 정비 SAELS_SITE_PROJECT_MODEL
         2024.08.14     KJJ             [PJ2024-50461] Team Mapping
         2024.12.12     KJJ             [PJ2024-50611] DEPT_ID에 부서명이 아닌 부서코드를 바인딩하게 수정
         2026.03.26     김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        
        DMF0008_GET_SALES_SITE_PROJECT_MODEL('81', 'APFMCCX48-A1', 'Ford AS_DE_QKL');
         */
        -- -------------------------------------------------------------------------------------------------------------------------------
     AS
    
        $$PLSQL_UNIT VARCHAR2(200) := $$PLSQL_UNIT;
        V_GROUP_ID     VARCHAR2(50 CHAR) := NULL;
        V_CNT_1        INTEGER := 0;
        V_IN_PARA_DATA VARCHAR2(4000);
        V_STEP         VARCHAR2(4000 CHAR) := NULL;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_item_id' VALUE P_ITEM_ID, 'p_scm_site_id' VALUE P_SCM_SITE_ID);
    
        SELECT COUNT(1)
        INTO   V_CNT_1
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN = 'Y'
        AND    SEGMENT2 = 'ALL'; -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
        --AND SEGMENT1 = p_userinfo
        IF V_CNT_1 > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GSSP_SINGLE';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_GSSP_SCM_MST_SITE_ITEM';
    
        INSERT /*+ NO_PARALLEL */
        INTO GT_GSSP_SINGLE
            (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_CLASS_NAME, NICK_NAME)
            SELECT T1.DIVISION_ID
                  ,T1.ITEM_ID
                  ,MAX(T1.ITEM_NAME) ITEM_NAME
                  ,DECODE(MIN(DECODE(T1.ITEM_TYPE, 'P',1, 'H',2, 'Q',3, 4)), 1,'P', 2,'H', 3,'Q', 'R') AS ITEM_TYPE
--                  ,CASE MIN(CASE
--                            WHEN T1.ITEM_TYPE = 'P' THEN
--                             1
--                            WHEN T1.ITEM_TYPE = 'H' THEN
--                             2
--                            WHEN T1.ITEM_TYPE = 'Q' THEN
--                             3
--                            ELSE
--                             4
--                        END)
--                       WHEN 1 THEN
--                        'P'
--                       WHEN 2 THEN
--                        'H'
--                       WHEN 3 THEN
--                        'Q'
--                       ELSE
--                        'R'
--                   END AS ITEM_TYPE
                  ,MAX(T1.ITEM_CLASS_NAME) ITEM_CLASS_NAME
                  ,MAX(T1.NICK_NAME) NICK_NAME
            FROM   SCM_MST_ITEM_SN T1
            WHERE  1 = 1
            AND    T1.DIVISION_ID = P_DIVISION_ID
            AND    T1.ITEM_ID = P_ITEM_ID
            AND    T1.ITEM_TYPE IN ('H', 'P') --AND T1.ITEM_TYPE IN ( 'H', 'P' )
            GROUP  BY T1.DIVISION_ID, T1.ITEM_ID;
    
        INSERT /*+ NO_PARALLEL */
        INTO GT_GSSP_SCM_MST_SITE_ITEM
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, CNT)
            SELECT A.DIVISION_ID
                  ,A.SCM_SITE_ID
                  ,A.PROJECT_CODE
                  ,SUM(CASE
                           WHEN B.ITEM_TYPE IN ('H', 'P') THEN
                            1
                           ELSE
                            0
                       END)
            FROM   SCM_MST_SITE_ITEM A
            LEFT   OUTER JOIN GT_GSSP_SINGLE B
            ON     A.DIVISION_ID = B.DIVISION_ID
            AND    A.ITEM_ID = B.ITEM_ID
            WHERE  A.DIVISION_ID = P_DIVISION_ID
            GROUP  BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE;
    
        --DMF0008_GET_SALES_SITE_PROJECT_MODEL('81', 'EMCV00143AB');
        --SELECT * FROM GT_GSSP_SCM_MST_SITE_ITEM
    
        OPEN O_RC1 FOR
            SELECT T1.*, TEI.EDIT_YN
            FROM   (SELECT SITE_PROJECT.DIVISION_ID
                           --,TEAM.DEPT_ID --2026-04-01 김준규 SCM_MST_SITE_ITEM 의 DEPT_ID 사용하기로 함
                          ,SITE_ITEM.DEPT_ID --2026-04-01 김준규 SCM_MST_SITE_ITEM 의 DEPT_ID 사용하기로 함
                          , -- 주석제거 : [PJ2024-50611] DEPT_ID에 부서명이 아닌 부서코드를 바인딩하게 수정
                           --TEAM.DEPT_ID AS DEPT_ID2,
                           --TEAM.DEPT_NAME_KO AS DEPT_ID, --주석처리 : [PJ2024-50611] DEPT_ID에 부서명이 아닌 부서코드를 바인딩하게 수정
                           TEAM.DEPT_NAME_KO              AS DEPT_ID2
                          ,TEAM.DEPT_NAME_KO              TEAM_NAME_KO
                          ,SITE.END_CUSTOMER              END_CUSTOMER
                          ,SITE.END_CUSTOMER              END_CUSTOMER40
                          ,SITE_CUST.SOLDTO_CODE
                          ,CUST.SOLDTO_DESCRIPTION
                          , --화면상에서는 일단 숨김처리
                           SITE_CUST.SHIPTO_CODE
                          ,CUST.SHIPTO_DESCRIPTION
                          , --화면상에서는 일단 숨김처리
                           SITE_PROJECT.SCM_SITE_ID
                          ,SITE_PROJECT.SCM_SITE_ID       SCM_SITE_ID40
                          ,SITE_PROJECT.PROJECT_CODE
                          ,PJT.PROJECT_NAME
                          ,PJT.PROJECT_STATUS
                          ,PJT.PROJECT_OWNER
                          , -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
                           SITE_PROJECT.OWNER             AS USER_ID
                          , --20180806
                           SITE_ITEM.SALES_PLAN_ADJUST_YN
                          ,SITE_ITEM.ITEM_TYPE
                          ,
                           --G.ITEM_TYPE,
                           SITE_ITEM.ITEM_CLASS_NAME
                          ,SITE_ITEM.ITEM_ID
                          ,SITE_ITEM.ITEM_NAME
                          ,SITE_ITEM.CELL_PER_CAR
                          ,SITE_ITEM.CELL_PER_MODULE
                          ,CASE
                               WHEN TO_NUMBER(SITE_ITEM.CELL_PER_MODULE) = 0 THEN
                                1
                               ELSE
                                TO_NUMBER(SITE_ITEM.CELL_PER_CAR) / TO_NUMBER(SITE_ITEM.CELL_PER_MODULE)
                           END AS MODULE_PER_CAR
                          ,CUST_ITEM.CUSTOMER_MODEL
                          ,SITE_ITEM.NICK_NAME
                          ,SITE_ITEM.SALES_COMPANY
                          ,SITE_ITEM.SALES_PLANT
                          ,SITE_ITEM.BPMS_EXIST
                          , --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
                           SITE_ITEM.LIABILITY_PERIOD
                          ,SITE_ITEM.CURRENCY
                          ,CASE
                               WHEN SITE_ITEM.ITEM_ID IS NULL THEN
                                NVL(SITE_PROJECT.VALID_YN, SITE_ITEM.VALID_YN)
                               ELSE
                                SITE_ITEM.VALID_YN
                           END AS VALID_YN
                          ,SITE_ITEM.LAST_UPDATE_DATE
                          ,SITE_ITEM.LAST_UPDATED_BY
                          ,SITE_ITEM.CUST_GROUP
                          ,SITE_ITEM.CUST_GROUP_DTL
                          ,FN_GET_MULTI_OWNER_NAME(SITE_ITEM.OWNER, ',', '1') OWNER -- 20180803
                          ,SITE_ITEM.APPLICATION
                          ,SITE_ITEM.ROUTE
                          ,SITE_ITEM.EDI -- C20200827-000257 테슬라 EDI
                          ,SITE_ITEM.EDI_LT -- C20200827-000257 테슬라 EDI
                          ,SITE_ITEM.ATTRIBUTE1
                          ,SITE_ITEM.ATTRIBUTE2
                          ,SITE_ITEM.ATTRIBUTE4 --20180726
                          ,SITE_ITEM.ATTRIBUTE5 --[C20211112-000213]
                          ,SITE_ITEM.ATTRIBUTE9 PRODUCTION_PROCESS --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
                           -- -----------------------------
                          ,SITE.SOLDTO_CUSTOMER
                           /*,REPORT_GROUP1
                           ,REPORT_GROUP2
                           ,REPORT_GROUP3
                           ,REPORT_GROUP4
                           ,REPORT_GROUP6
                           ,REPORT_GROUP7
                           ,REPORT_GROUP8*/
                          ,SITE_ITEM.CELL_TYPE -- 20190919
                          ,NVL(SITE_PROJECT.VMI_LT, 0) VMI_LT
                    FROM   (SELECT DISTINCT A.DIVISION_ID
                                           ,SCM_SITE_ID
                                           ,PROJECT_CODE
                                           ,NVL(MAX(VALID_YN), 'Y') VALID_YN
                                           ,A.OWNER --,'' owner
                                           ,A.ITEM_ID --,'' ITEM_ID
                                            /*,REPORT_GROUP1
                                            ,REPORT_GROUP2
                                            ,REPORT_GROUP3
                                            ,REPORT_GROUP4
                                            ,REPORT_GROUP6
                                            ,REPORT_GROUP7
                                            ,REPORT_GROUP8*/
                                           ,MAX(A.SCP_VMI_LT) VMI_LT
                            FROM   SCM_MST_SITE_ITEM A, SCM_MST_ITEM_SN B
                            WHERE  A.ITEM_ID = P_ITEM_ID
                            AND    A.DIVISION_ID <> '40'
                            AND    A.SCM_SITE_ID = P_SCM_SITE_ID
                            GROUP  BY A.DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.OWNER, A.ITEM_ID
                            /*,REPORT_GROUP1
                            ,REPORT_GROUP2
                            ,REPORT_GROUP3
                            ,REPORT_GROUP4
                            ,REPORT_GROUP6
                            ,REPORT_GROUP7
                            ,REPORT_GROUP8*/
                            UNION
                            SELECT DISTINCT A.DIVISION_ID
                                           ,SCM_SITE_ID
                                           ,PROJECT_CODE
                                           ,VALID_YN
                                           ,A.OWNER
                                           ,ITEM_ID
                                            /*,REPORT_GROUP1
                                            ,REPORT_GROUP2
                                            ,REPORT_GROUP3
                                            ,REPORT_GROUP4
                                            ,REPORT_GROUP6
                                            ,REPORT_GROUP7
                                            ,REPORT_GROUP8*/
                                           ,A.SCP_VMI_LT
                            FROM   SCM_MST_SITE_ITEM A
                            WHERE  A.DIVISION_ID = '40'
                            AND    A.SCM_SITE_ID = P_SCM_SITE_ID) SITE_PROJECT
                    LEFT   JOIN SCM_MST_PROJECT PJT
                    ON     SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
                    AND    SITE_PROJECT.DIVISION_ID = PJT.DIVISION_ID
                    LEFT   JOIN SCM_MST_SITE SITE
                    ON     SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
                    AND    SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
                    AND    SITE.SITE_TYPE = 'SALES'
                    LEFT   JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                                FROM   SCM_MST_SSO_USER_INFO B
                                INNER  JOIN SCM_MST_SSO_DEPT_INFO C
                                ON     B.DEPT_ID = C.DEPT_ID) TEAM
                    ON     TEAM.USER_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(SITE_PROJECT.OWNER, ',')))
                    LEFT   JOIN (SELECT T1.DIVISION_ID
                                      ,T1.SCM_SITE_ID
                                      ,T1.DEPT_ID
                                      ,T1.PROJECT_CODE
                                      ,T1.ITEM_ID
                                      ,T1.CELL_PER_CAR
                                      ,T1.CELL_PER_MODULE
                                      ,T2.ITEM_NAME
                                      ,T2.ITEM_TYPE
                                      ,T2.ITEM_CLASS_NAME
                                      ,T1.SALES_PLAN_ADJUST_YN
                                      ,T2.NICK_NAME
                                      ,T1.BPMS_EXIST
                                      , --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
                                       T1.LIABILITY_PERIOD
                                      ,T1.CURRENCY
                                      ,T1.VALID_YN
                                      ,T1.LAST_UPDATE_DATE
                                      ,T1.LAST_UPDATED_BY
                                       --20180601, LSH---------
                                      ,T1.CUST_GROUP
                                      ,T1.CUST_GROUP_DTL
                                      ,T1.OWNER
                                      ,T1.APPLICATION
                                      ,T1.ROUTE
                                      ,T1.ATTRIBUTE6 EDI --  C20200827-000257 테슬라 EDI
                                      ,T1.EDI_LT --  C20200827-000257 테슬라 EDI
                                      ,T1.ATTRIBUTE1
                                      ,T1.ATTRIBUTE2
                                      ,T1.ATTRIBUTE5 --  [C20211112-000213]
                                       --,T1.ATTRIBUTE4  --20180726  -> [CSR ID:3997942] 20190612 주석처리
                                      ,CO.COUNTRY_NAME ATTRIBUTE4 -- [CSR ID:3997942] 20190612 추가
                                      ,T1.ATTRIBUTE9 --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
                                      ,(SELECT LMD.SEGMENT2 AS NAME
                                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LMD
                                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                                        AND    T2.CELL_TYPE = LMD.SEGMENT1) CELL_TYPE -- 20190919                                       
                                      ,T1.SALES_COMPANY
                                      ,T1.SALES_PLANT
                                -- --------------------
                                FROM   SCM_MST_SITE_ITEM T1
                                JOIN   DM_MST_ITEM_SINGLE_V T2
                                ON     T1.DIVISION_ID = T2.DIVISION_ID
                                AND    T1.ITEM_ID = T2.ITEM_ID
                                INNER  JOIN SCM_MST_SITE T3
                                ON     T1.DIVISION_ID = T3.DIVISION_ID
                                AND    T1.SCM_SITE_ID = T3.SCM_SITE_ID
                                LEFT   JOIN SCM_MST_COUNTRY CO
                                ON     T3.COUNTRY = CO.COUNTRY
                                WHERE  (T1.ITEM_ID = P_ITEM_ID AND T1.SCM_SITE_ID = P_SCM_SITE_ID)
                                --WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'H' END
                                --OR   T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'P' END)
                                ) SITE_ITEM
                    ON     SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
                    AND    SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
                    AND    SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
                          ----[PJ2024-50461] Team Mapping
                          --AND             CASE WHEN SITE_PROJECT.DIVISION_ID = '40' THEN SITE_PROJECT.ITEM_ID ELSE  SITE_ITEM.ITEM_ID END = SITE_ITEM.ITEM_ID
                    AND    SITE_PROJECT.ITEM_ID = SITE_ITEM.ITEM_ID
                    LEFT   JOIN SCM_MST_SITE_CUSTOMER SITE_CUST
                    ON     SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
                    AND    SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
                    AND    SITE_CUST.REP_YN = 'Y'
                    LEFT   JOIN SCM_MST_CUSTOMER CUST
                    ON     SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
                    AND    SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
                    AND    SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
                    --LEFT OUTER JOIN GT_GSSP_SINGLE G  ON SITE_ITEM.DIVISION_ID = G.DIVISION_ID AND SITE_ITEM.ITEM_ID = G.ITEM_ID
                    LEFT   JOIN (SELECT DIVISION_ID, MAX(CUSTOMER_MODEL) CUSTOMER_MODEL, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
                                FROM   DM_MST_CUSTOMER_MODEL
                                WHERE  VALID_YN = 'Y'
                                GROUP  BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID) CUST_ITEM
                    ON     SITE_ITEM.ITEM_ID = CUST_ITEM.ITEM_ID
                    AND    SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
                    AND    SITE_ITEM.DIVISION_ID = CUST_ITEM.DIVISION_ID
                    AND    SITE_ITEM.SCM_SITE_ID = CUST_ITEM.SCM_SITE_ID
                    WHERE  1 = 1
                    AND    SUBSTR(SITE_ITEM.SCM_SITE_ID, -3) <> '-AS') T1
            INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
            ON     TEI.UNIT_ID = T1.DIVISION_ID
            WHERE  1 = 1
            AND    T1.DIVISION_ID = P_DIVISION_ID
            AND    T1.ITEM_ID = P_ITEM_ID
            AND    T1.SCM_SITE_ID = P_SCM_SITE_ID
            ORDER  BY DIVISION_ID
                     ,TEAM_NAME_KO
                     ,END_CUSTOMER
                     ,END_CUSTOMER40
                     ,SOLDTO_CODE
                     ,SHIPTO_CODE
                     ,SCM_SITE_ID
                     ,SCM_SITE_ID40
                     ,PROJECT_CODE
                     ,PROJECT_NAME
                     ,PROJECT_STATUS
                     ,PROJECT_OWNER
                     , -- 'SYSTEM' AS PROJECT_OWNER, --PJT.PROJECT_OWNWER      현재 컬럼이 없음.
                      SALES_PLAN_ADJUST_YN
                     ,ITEM_TYPE
                     ,ITEM_CLASS_NAME
                     ,ITEM_ID
                     ,ITEM_NAME
                     ,CUSTOMER_MODEL
                     ,
                      --[C20200513-000276] Sales_Company, Sales_Plant 컬럼 추가
                      SALES_COMPANY
                     ,SALES_PLANT
                     ,NICK_NAME
                     ,BPMS_EXIST
                     , --SITE_ITEM.BPMS_EXIST   현재 컬럼이 없음.
                      LIABILITY_PERIOD
                     ,CURRENCY
            -- 20190402
            --  ,REPORT_GROUP1
            --  ,REPORT_GROUP2
            --  ,REPORT_GROUP3
            --  ,REPORT_GROUP4
            --  --,REPORT_GROUP5
            --  ,REPORT_GROUP6
            --  ,REPORT_GROUP7
            --  ,REPORT_GROUP8
            ;
        COMMIT;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,'ERROR'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0008_GET_SALES_SITE_PROJECT_MODEL;


	PROCEDURE P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR (
	    P_DATA          IN  CLOB
	  , P_USER_ID       IN  VARCHAR2
	  , O_RESULT_CURSOR OUT SYS_REFCURSOR
	) IS
	    EX_BIZ_EX        EXCEPTION;
	    V_ERR_MSG        VARCHAR2(4000);
	    V_ROW_CNT        NUMBER := 0;
	    V_SQL_CODE       VARCHAR2(100 CHAR);
	    $$PLSQL_UNIT   VARCHAR2(200) := $$PLSQL_UNIT;
	    V_IN_PARA_DATA   VARCHAR2(4000);
	    V_LOG_TYPE       VARCHAR2(20);
	    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
	    V_DESCRIPTION    VARCHAR2(4000 CHAR);
	    D_EVENT_DATE     DATE;
	    N_LOG_COUNT      NUMBER := 0;
	
	    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
	    BEGIN
	        V_ERR_MSG := P_MSG;
	        RAISE EX_BIZ_EX;
	    END;
	BEGIN
	
	    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
	        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
	    END IF;
	
	    V_IN_PARA_DATA := DBMS_LOB.SUBSTR(P_DATA, 4000, 1);
	    V_LOG_TYPE    := 'START';
	    V_LOG_MESSAGE := '########## Start of procedure ##########';
	    D_EVENT_DATE  := SYSTIMESTAMP;
	    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, NULL, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
	
	    FOR R IN (
	        SELECT TRIM(JT.DIVISION_ID)             AS DIVISION_ID
	             , TRIM(JT.END_CUSTOMER)            AS END_CUSTOMER
	             , TRIM(JT.SOLDTO_CUSTOMER)         AS SOLDTO_CUSTOMER
	             , TRIM(JT.COMPANY_ID)              AS COMPANY_ID
	             , TRIM(JT.SCM_SITE_ID)             AS SCM_SITE_ID
	             , TRIM(JT.SOLDTO_CODE)             AS SOLDTO_CODE
	             , TRIM(JT.SHIPTO_CODE)             AS SHIPTO_CODE
	             , TRIM(JT.VMI_YN)                  AS VMI_YN
	             , TRIM(JT.VALID_YN)                AS VALID_YN
	             , TRIM(JT.CUST_VALID_YN)           AS CUST_VALID_YN
	             , TRIM(JT.REP_YN)                  AS REP_YN
	             , TRIM(JT.COUNTRY)                 AS COUNTRY
	             , TRIM(JT.CITY)                    AS CITY
	             , TRIM(JT.SHIP_PLAN_AUTO)          AS SHIP_PLAN_AUTO
	             , TRIM(JT.DEPT_ID)                 AS DEPT_ID
	             , P_USER_ID                        AS CREATED_BY
	        FROM JSON_TABLE(
	            P_DATA,
	            '$[*]'
	            COLUMNS (
	                DIVISION_ID      VARCHAR2(30)   PATH '$."DIVISION_ID"'
	              , END_CUSTOMER     VARCHAR2(50)  	PATH '$."END_CUSTOMER"'
	              , SOLDTO_CUSTOMER  VARCHAR2(50)  	PATH '$."SOLDTO_CUSTOMER"'
	              , COMPANY_ID       VARCHAR2(30)  	PATH '$."COMPANY_ID"'
	              , SCM_SITE_ID      VARCHAR2(60)  	PATH '$."SCM_SITE_ID"'
	              , SOLDTO_CODE      VARCHAR2(50)  	PATH '$."SOLDTO_CODE"'
	              , SHIPTO_CODE      VARCHAR2(50)  	PATH '$."SHIPTO_CODE"'
	              , VMI_YN           VARCHAR2(1)    PATH '$."VMI_YN"'
	              , VALID_YN         VARCHAR2(1)    PATH '$."VALID_YN"'
	              , CUST_VALID_YN    VARCHAR2(1)    PATH '$."CUST_VALID_YN"'
	              , REP_YN           VARCHAR2(1)    PATH '$."REP_YN"'
	              , COUNTRY          VARCHAR2(3)   	PATH '$."COUNTRY"'
	              , CITY             VARCHAR2(5)  	PATH '$."CITY"'
	              , SHIP_PLAN_AUTO   VARCHAR2(1)    PATH '$."SHIP_PLAN_AUTO"'
	              , DEPT_ID          VARCHAR2(50)   PATH '$."DEPT_ID"'
	            )
	        ) JT
	    ) LOOP
	        -- 필수값 검증
	        IF 	   R.VALID_YN IS NULL 
	        	OR R.DIVISION_ID IS NULL
	        	OR R.SCM_SITE_ID IS NULL
	        	OR R.SOLDTO_CODE IS NULL
	        	OR R.SHIPTO_CODE IS NULL
	        	OR R.CUST_VALID_YN IS NULL
	        THEN
	            RAISE_INVALID('필수 입력값을 확인하세요.');
	        END IF;
	
	        --SCM_MST_SITE_HIST History 생성
	        BEGIN
	            INSERT INTO SCM_MST_SITE_H
	                (HISTORY_SEQ
	                ,DIVISION_ID
	                ,SCM_SITE_ID
	                ,PLANT_ID
	                ,OPERATION_GROUP
	                ,SITE_DESCRIPTION
	                ,SITE_TYPE
	                ,CITY
	                ,COUNTRY
	                ,DEPT_ID
	                ,VMI_YN
	                ,VALID_YN
	                ,NEW_YN
	                ,SITE_HRCY_ID
	                ,OSP_YN
	                ,SHIP_FROZEN
	                ,PROD_FROZEN
	                ,END_CUSTOMER
	                ,SOLDTO_CUSTOMER
	                ,FP_PLAN_PERIOD
	                ,BUILD_AHEAD
	                ,LOGISTIC_PLANT_ID
	                ,PACKER_ITEM_ID_SUFFIX
	                ,HQ_VENDOR_CODE
	                ,COMPANY_ID
	                ,SITE_ID
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
	                ,HISTORY_CREATION_DATE)
	                SELECT SEQ1_SCM_MST_SITE_H.NEXTVAL
	                      ,DIVISION_ID
	                      ,SCM_SITE_ID
	                      ,PLANT_ID
	                      ,OPERATION_GROUP
	                      ,SITE_DESCRIPTION
	                      ,SITE_TYPE
	                      ,R.CITY
	                      ,R.COUNTRY
	                      ,NVL(R.DEPT_ID, '-')
	                      ,R.VMI_YN
	                      ,R.VALID_YN
	                      ,NEW_YN
	                      ,SITE_HRCY_ID
	                      ,OSP_YN
	                      ,SHIP_FROZEN
	                      ,PROD_FROZEN
	                      ,R.END_CUSTOMER
	                      ,R.SOLDTO_CUSTOMER
	                      ,FP_PLAN_PERIOD
	                      ,BUILD_AHEAD
	                      ,LOGISTIC_PLANT_ID
	                      ,PACKER_ITEM_ID_SUFFIX
	                      ,HQ_VENDOR_CODE
	                      ,R.COMPANY_ID
	                      ,SITE_ID
	                      ,R.CREATED_BY
	                      ,SYSTIMESTAMP
	                      ,R.CREATED_BY
	                      ,SYSTIMESTAMP
	                      ,ATTRIBUTE1
	                      ,R.SHIP_PLAN_AUTO
	                      ,ATTRIBUTE3
	                      ,ATTRIBUTE4
	                      ,ATTRIBUTE5
	                      ,ATTRIBUTE6
	                      ,ATTRIBUTE7
	                      ,ATTRIBUTE8
	                      ,ATTRIBUTE9
	                      ,ATTRIBUTE10
	                      ,SYSTIMESTAMP
	                FROM   SCM_MST_SITE
	                WHERE  DIVISION_ID = R.DIVISION_ID
	                AND    SCM_SITE_ID = R.SCM_SITE_ID;
	        END;
	
	        --SCM_MST_SITE_CUSTOMER History 생성
	        BEGIN
	            PR_DM_MST_SITE_CUSTOMER_HIST(R.DIVISION_ID, R.SCM_SITE_ID, R.SOLDTO_CODE, R.SHIPTO_CODE, R.REP_YN, R.CREATED_BY, R.CUST_VALID_YN);
	        END;
	
	        DECLARE
	            V_CUST_EXISTS NUMBER := 0;
	            V_SITE_EXISTS NUMBER := 0;
	        BEGIN
	            -- 사전 존재 여부 확인 (디버그용)
	            SELECT COUNT(1) INTO V_CUST_EXISTS
	            FROM SCM_MST_SITE_CUSTOMER
	            WHERE DIVISION_ID = R.DIVISION_ID AND SCM_SITE_ID = R.SCM_SITE_ID
	              AND SOLDTO_CODE = R.SOLDTO_CODE AND SHIPTO_CODE = R.SHIPTO_CODE;
	
	            SELECT COUNT(1) INTO V_SITE_EXISTS
	            FROM SCM_MST_SITE
	            WHERE DIVISION_ID = R.DIVISION_ID AND SCM_SITE_ID = R.SCM_SITE_ID;
	           
	        -- BEGIN
	            --SCM_MST_SITE_CUSTOMER
	            MERGE INTO SCM_MST_SITE_CUSTOMER A
	            USING (SELECT R.DIVISION_ID DIVISION_ID, R.SCM_SITE_ID SITE_ID, R.SOLDTO_CODE SOLDTO_CODE, R.SHIPTO_CODE SHIPTO_CODE FROM DUAL) B
	            ON (A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SITE_ID AND A.SOLDTO_CODE = B.SOLDTO_CODE AND A.SHIPTO_CODE = B.SHIPTO_CODE)
	            WHEN MATCHED THEN
	                UPDATE
	                SET    REP_YN           = NVL(R.REP_YN, '')
	                      ,VALID_YN         = NVL(R.CUST_VALID_YN, '')
	                      ,LAST_UPDATED_BY  = R.CREATED_BY
	                      ,LAST_UPDATE_DATE = SYSTIMESTAMP
	
	            WHEN NOT MATCHED THEN
	                INSERT
	                    (DIVISION_ID
	                    ,SCM_SITE_ID
	                    ,SOLDTO_CODE
	                    ,SHIPTO_CODE
	                    ,REP_YN
	                    ,VALID_YN
	                    ,CREATED_BY
	                    ,CREATION_DATE
	                    ,LAST_UPDATED_BY
	                    ,LAST_UPDATE_DATE)
	                VALUES
	                    (R.DIVISION_ID
	                    ,R.SCM_SITE_ID
	                    ,R.SOLDTO_CODE
	                    ,R.SHIPTO_CODE
	                    ,NVL(R.REP_YN, '')
	                    ,NVL(R.CUST_VALID_YN, '')
	                    ,R.CREATED_BY
	                    ,SYSTIMESTAMP
	                    ,R.CREATED_BY
	                    ,SYSTIMESTAMP);
	
	            MERGE INTO SCM_MST_SITE A
	            USING (SELECT R.DIVISION_ID DIVISION_ID, R.SCM_SITE_ID SITE_ID FROM DUAL) B
	            ON (A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SITE_ID)
	            WHEN MATCHED THEN
	                UPDATE
	                SET    CITY             = R.CITY
	                      ,COUNTRY          = R.COUNTRY
	                      ,VMI_YN           = NVL(R.VMI_YN, '')
	                      ,VALID_YN         = R.VALID_YN
	                      ,END_CUSTOMER     = R.END_CUSTOMER
	                      ,SOLDTO_CUSTOMER  = R.SOLDTO_CUSTOMER
	                      ,COMPANY_ID       = R.COMPANY_ID
	                      ,ATTRIBUTE2       = R.SHIP_PLAN_AUTO
	                      ,LAST_UPDATED_BY  = R.CREATED_BY
	                      ,LAST_UPDATE_DATE = SYSTIMESTAMP
	
	            WHEN NOT MATCHED THEN
	                INSERT
	                    (DIVISION_ID
	                    ,SCM_SITE_ID
	                    ,SITE_DESCRIPTION
	                    ,SITE_TYPE
	                    ,END_CUSTOMER
	                    ,SOLDTO_CUSTOMER
	                    ,CITY
	                    ,COUNTRY
	                    ,VMI_YN
	                    ,VALID_YN
	                    ,NEW_YN
	                    ,COMPANY_ID
	                    ,CREATED_BY
	                    ,CREATION_DATE
	                    ,LAST_UPDATED_BY
	                    ,LAST_UPDATE_DATE
	                    ,ATTRIBUTE2)
	                VALUES
	                    (R.DIVISION_ID
	                    ,R.SCM_SITE_ID
	                    ,R.SCM_SITE_ID
	                    ,'SALES'
	                    ,R.END_CUSTOMER
	                    ,R.SOLDTO_CUSTOMER
	                    ,R.CITY
	                    ,R.COUNTRY
	                    ,NVL(R.VMI_YN, '')
	                    ,R.VALID_YN
	                    ,'Y'
	                    ,R.COMPANY_ID
	                    ,R.CREATED_BY
	                    ,SYSTIMESTAMP
	                    ,R.CREATED_BY
	                    ,SYSTIMESTAMP
	                    ,R.SHIP_PLAN_AUTO);
	

            -- 디버그 로그
            DBMS_OUTPUT.PUT_LINE('[SITE_CUSTOMER] DIV=' || R.DIVISION_ID || ', SITE=' || R.SCM_SITE_ID
                || ', SOLDTO=' || R.SOLDTO_CODE || ', SHIPTO=' || R.SHIPTO_CODE
                || ' → ' || CASE WHEN V_CUST_EXISTS > 0 THEN 'MATCHED (UPDATE)' ELSE 'NOT MATCHED (INSERT)' END);
            DBMS_OUTPUT.PUT_LINE('[SITE] DIV=' || R.DIVISION_ID || ', SITE=' || R.SCM_SITE_ID
                || ' → ' || CASE WHEN V_SITE_EXISTS > 0 THEN 'MATCHED (UPDATE)' ELSE 'NOT MATCHED (INSERT)' END);
               
	        END;
	        V_ROW_CNT := V_ROW_CNT + 1;
	    END LOOP;
	
	    COMMIT;
	   
	
	    OPEN O_RESULT_CURSOR FOR
	        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
	
	EXCEPTION
	    WHEN EX_BIZ_EX THEN
	        ROLLBACK;
	
	        OPEN O_RESULT_CURSOR FOR
	            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
	
	    WHEN OTHERS THEN
	        ROLLBACK;
	
	        V_SQL_CODE    := TO_CHAR(SQLCODE);
	        V_ERR_MSG     := SQLERRM;
	
	        V_LOG_TYPE    := 'ERROR';
	        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
	        D_EVENT_DATE  := SYSTIMESTAMP;
	
	        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
	                            ,V_LOG_TYPE
	                            ,N_LOG_COUNT
	                            ,V_LOG_MESSAGE
	                            ,NULL
	                            ,D_EVENT_DATE
	                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
	                            ,P_SQL_ERR_CODE  => SQLCODE
	                            ,P_SQL_ERR_MSG   => SQLERRM
	                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
	
	        RAISE_APPLICATION_ERROR(-20001,
	            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
	            ' / SQLERRM=' || V_ERR_MSG ||
	            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	            ' / PARAMS=' || V_IN_PARA_DATA);
	
	END P_DMF0008_SAVE_SALES_SITE_EDI_REPAIR;
   
    PROCEDURE P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR 
    (
      P_DATA          IN  CLOB
    , P_USER_ID       IN  VARCHAR2
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
    * Program ID  : DMF0008_SAVE_EDI_MST_REPAIR
    * Description  : EDI GSCM MASTER DATA 정비
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    2023.04.05    kdmcc14       []  EDI GSCM MASTER DATA 정비
    2026.03.15    김준규         [PJ20264226] NextSCM Pilot 설계 및 개발
    2026.04.23    강민재         CLOB으로 PARAM 변경
    */
    IS
      EX_BIZ_EX         EXCEPTION;
      V_ERR_MSG         VARCHAR2(4000);
      V_ROW_CNT         NUMBER := 0;
      V_SQL_CODE        VARCHAR2(100 CHAR);

      V_DUP_SCM_SITE_ID VARCHAR2(200);

      $$PLSQL_UNIT    VARCHAR2(200) := $$PLSQL_UNIT;
      V_IN_PARA_DATA    VARCHAR2(4000);
      V_LOG_TYPE        VARCHAR2(20);
      V_LOG_MESSAGE     VARCHAR2(4000 CHAR);
      V_DESCRIPTION     VARCHAR2(4000 CHAR);
      D_EVENT_DATE      DATE;
      N_LOG_COUNT       NUMBER := 0;

      PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
      BEGIN
          V_ERR_MSG := P_MSG;
          RAISE EX_BIZ_EX;
      END;
    BEGIN

    V_IN_PARA_DATA := DBMS_LOB.SUBSTR(P_DATA, 4000, 1);
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, NULL, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);

    FOR R IN (
        SELECT TRIM(JT.DIVISION_ID)             AS DIVISION_ID
             , TRIM(JT.PROJECT_CODE)            AS PROJECT_CODE
             , TRIM(JT.SCM_SITE_ID)             AS SCM_SITE_ID
             , TRIM(JT.ITEM_ID)                 AS ITEM_ID
             , TRIM(JT.CURRENCY)                AS CURRENCY
             , TRIM(JT.KWH)                     AS KWH
             , TRIM(JT.CELL_PER_CAR)            AS CELL_PER_CAR
             , TRIM(JT.CELL_PER_MODULE)         AS CELL_PER_MODULE
             , TRIM(JT.LIABILITY_PERIOD)        AS LIABILITY_PERIOD
             , TRIM(JT.VALID_YN)                AS VALID_YN
             , TRIM(JT.BPMS_EXIST)              AS BPMS_EXIST
             , TRIM(JT.SALES_COMPANY)           AS SALES_COMPANY
             , TRIM(JT.SALES_PLANT)             AS SALES_PLANT
             , TRIM(JT.MODULE_VARIANT)          AS MODULE_VARIANT
             , TRIM(JT.INCOTERMS)               AS INCOTERMS
             , P_USER_ID                        AS CREATED_BY
        FROM JSON_TABLE(
            P_DATA,
            '$[*]'
            COLUMNS (
                DIVISION_ID      VARCHAR2(30)   PATH '$."DIVISION_ID"'
              , PROJECT_CODE     VARCHAR2(50)  PATH '$."PROJECT_CODE"'
              , SCM_SITE_ID      VARCHAR2(100)  PATH '$."SCM_SITE_ID"'
              , ITEM_ID          VARCHAR2(50)  PATH '$."ITEM_ID"'
              , CURRENCY         VARCHAR2(10)   PATH '$."CURRENCY"'
              , KWH              VARCHAR2(50)   PATH '$."KWH"'
              , CELL_PER_CAR     VARCHAR2(50)   PATH '$."CELL_PER_CAR"'
              , CELL_PER_MODULE  VARCHAR2(50)   PATH '$."CELL_PER_MODULE"'
              , LIABILITY_PERIOD VARCHAR2(50)   PATH '$."LIABILITY_PERIOD"'
              , VALID_YN         VARCHAR2(1)    PATH '$."VALID_YN"'
              , BPMS_EXIST       VARCHAR2(1)    PATH '$."BPMS_EXIST"'
              , SALES_COMPANY    VARCHAR2(100)  PATH '$."SALES_COMPANY"'
              , SALES_PLANT      VARCHAR2(100)  PATH '$."SALES_PLANT"'
              , MODULE_VARIANT   VARCHAR2(50)  PATH '$."MODULE_VARIANT"'
              , INCOTERMS        VARCHAR2(50)   PATH '$."INCOTERMS"'
            )
        ) JT
    ) 
    LOOP
        -- 필수컬럼값 null 검증 start -----------------------------------------------
        IF R.VALID_YN IS NULL THEN
            RAISE_INVALID('필수 입력값을 확인하세요.');
        END IF;

        IF R.DIVISION_ID IS NULL THEN
            RAISE_INVALID('Div 입력값을 확인하세요.');
        END IF;

        IF R.PROJECT_CODE IS NULL THEN
            RAISE_INVALID('Project Code 입력값을 확인하세요.');
        END IF;

        IF R.SCM_SITE_ID IS NULL THEN
            RAISE_INVALID('Sales Site 입력값을 확인하세요.');
        END IF;

        IF R.ITEM_ID IS NULL THEN
            RAISE_INVALID('Model 입력값을 확인하세요.');
        END IF;
        -- 필수컬럼값 null 검증 end -----------------------------------------------

        --SCM_MST_SITE_ITEM_H History 생성
        BEGIN
            INSERT INTO SCM_MST_SITE_ITEM_H
                (DIVISION_ID
                ,HISTORY_SEQ
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,ITEM_ID
                ,CURRENCY
                ,CELL_PER_CAR
                ,CELL_PER_MODULE
                ,LIABILITY_PERIOD
                ,SALES_PLAN_ADJUST_YN
                ,ITEM_HRCY_ID
                ,VALID_YN
                ,BPMS_EXIST
                ,CUST_GROUP
                ,CUST_GROUP_DTL
                ,OWNER
                ,APPLICATION
                ,ROUTE
                ,SALES_COMPANY
                ,SALES_PLANT
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
                ,EDI_LT
                ,SCP_VMI_LT
                ,PARTIAL_PLAN_YN)
                SELECT DIVISION_ID
                      ,SEQ1_SCM_MST_SITE_ITEM_H.NEXTVAL
                      ,PROJECT_CODE
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,R.CURRENCY
                      ,R.CELL_PER_CAR
                      ,R.CELL_PER_MODULE
                      ,R.LIABILITY_PERIOD
                      ,SALES_PLAN_ADJUST_YN
                      ,ITEM_HRCY_ID
                      ,R.VALID_YN
                      ,R.BPMS_EXIST
                      ,CUST_GROUP
                      ,CUST_GROUP_DTL
                      ,OWNER
                      ,APPLICATION
                      ,ROUTE
                      ,R.SALES_COMPANY
                      ,R.SALES_PLANT
                      ,R.CREATED_BY
                      ,SYSTIMESTAMP
                      ,R.CREATED_BY
                      ,SYSTIMESTAMP
                      ,ATTRIBUTE1
                      ,R.MODULE_VARIANT
                      ,ATTRIBUTE3
                      ,ATTRIBUTE4
                      ,ATTRIBUTE5
                      ,R.INCOTERMS
                      ,ATTRIBUTE7
                      ,R.KWH
                      ,ATTRIBUTE9
                      ,ATTRIBUTE10
                      ,EDI_LT
                      ,SCP_VMI_LT
                      ,PARTIAL_PLAN_YN
                FROM   SCM_MST_SITE_ITEM
                WHERE  DIVISION_ID  = R.DIVISION_ID
                AND    PROJECT_CODE = R.PROJECT_CODE
                AND    SCM_SITE_ID  = R.SCM_SITE_ID
                AND    ITEM_ID      = R.ITEM_ID;
        END;

        --SCM_MST_SITE_ITEM
        BEGIN
            MERGE INTO SCM_MST_SITE_ITEM A
            USING (SELECT R.DIVISION_ID DIVISION_ID, R.PROJECT_CODE PROJECT_CODE, R.SCM_SITE_ID SCM_SITE_ID, R.ITEM_ID ITEM_ID FROM DUAL) B
            ON (A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID)
            WHEN MATCHED THEN
                UPDATE
                SET    CURRENCY         = R.CURRENCY
                      ,CELL_PER_CAR     = CASE WHEN R.CELL_PER_CAR IS NULL OR R.CELL_PER_CAR = '0' THEN NULL ELSE R.CELL_PER_CAR END
                      ,CELL_PER_MODULE  = CASE WHEN R.CELL_PER_MODULE IS NULL OR R.CELL_PER_MODULE = '0' THEN NULL ELSE R.CELL_PER_MODULE END
                      ,LIABILITY_PERIOD = R.LIABILITY_PERIOD
                      ,VALID_YN         = R.VALID_YN
                      ,BPMS_EXIST       = R.BPMS_EXIST
                      ,SALES_COMPANY    = R.SALES_COMPANY
                      ,SALES_PLANT      = R.SALES_PLANT
                      ,ATTRIBUTE2       = R.MODULE_VARIANT
                      ,ATTRIBUTE6       = R.INCOTERMS
                      ,ATTRIBUTE8       = R.KWH
                      ,LAST_UPDATED_BY  = R.CREATED_BY
                      ,LAST_UPDATE_DATE = SYSTIMESTAMP

            WHEN NOT MATCHED THEN
                INSERT
                    (DIVISION_ID
                    ,PROJECT_CODE
                    ,SCM_SITE_ID
                    ,ITEM_ID
                    ,CURRENCY
                    ,CELL_PER_CAR
                    ,CELL_PER_MODULE
                    ,LIABILITY_PERIOD
                    ,VALID_YN
                    ,BPMS_EXIST
                    ,SALES_COMPANY
                    ,SALES_PLANT
                    ,CREATED_BY
                    ,CREATION_DATE
                    ,LAST_UPDATED_BY
                    ,LAST_UPDATE_DATE
                    ,ATTRIBUTE2
                    ,ATTRIBUTE6
                    ,ATTRIBUTE8)
                VALUES
                    (R.DIVISION_ID
                    ,R.PROJECT_CODE
                    ,R.SCM_SITE_ID
                    ,R.ITEM_ID
                    ,R.CURRENCY
                    ,CASE WHEN R.CELL_PER_CAR IS NULL OR R.CELL_PER_CAR = '0' THEN NULL ELSE R.CELL_PER_CAR END
                    ,CASE WHEN R.CELL_PER_MODULE IS NULL OR R.CELL_PER_MODULE = '0' THEN NULL ELSE R.CELL_PER_MODULE END
                    ,R.LIABILITY_PERIOD
                    ,R.VALID_YN
                    ,R.BPMS_EXIST
                    ,R.SALES_COMPANY
                    ,R.SALES_PLANT
                    ,R.CREATED_BY
                    ,SYSTIMESTAMP
                    ,R.CREATED_BY
                    ,SYSTIMESTAMP
                    ,R.MODULE_VARIANT
                    ,R.INCOTERMS
                    ,R.KWH);
        END;

        V_ROW_CNT := V_ROW_CNT + 1;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN EX_BIZ_EX THEN
            ROLLBACK;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

        WHEN OTHERS THEN
            ROLLBACK;

            V_SQL_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MSG     := SQLERRM;

            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            D_EVENT_DATE  := SYSTIMESTAMP;

            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,NULL
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            RAISE_APPLICATION_ERROR(-20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
                ' / SQLERRM=' || V_ERR_MSG ||
                ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                ' / PARAMS=' || V_IN_PARA_DATA);

    END P_DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR;

   
   
	PROCEDURE P_DMF0008_DNM_EDI_CALLOFF_STATUS
	/*
	 * Program ID   : PR_DM_DNM_EDI_CALLOFF_STATUS
	 * Description  : EDI_CALLOFF DATA의 STATUS 체크
	 *                PR_DM_DNM_EDI_CALLOFF 프로시저에서 호출
	 *                스케줄러에서 호출
	 *                XIF_ERP_EDI_CALLOFF_HEAD_R    -> DM_DNM_EDI_CALLOFF_HEAD
	 *                XIF_ERP_EDI_CALLOFF_PARTNER_R -> DM_DNM_EDI_CALLOFF_PARTNER
	 *                XIF_ERP_EDI_CALLOFF_ITEM_R    -> DM_DNM_EDI_CALLOFF_ITEM
	 * Program History
	 *===================================================================================================
	 *   Date       In Charge      Description
	 *===================================================================================================
	 * 배포시 주의사항 : 개발기 -> LGCE_INFDEV , 운영기 -> LGCE_INF
	 *===================================================================================================
	   2023.01.30				     PR_DM_DNM_EDI_CALLOFF_STATUS 프로시저 생성
	   2023.11.29	kjj0070		 예외처리 적용
	   2024.04.22   HMIN		 예외처리 로직에 SPACE처리 후 비교 하도록 수정
	   2024.06.27	JSSBAE		 [E20240610-000320]_SCM DM EDI(Cust FCST) 관련 문의사항 (예외로직적용: 앞뒤 공백값, NULL값 공백으로 치환해서 비교 처리)
	   2024.07.03	JSSBAE		 [E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
	   2024.12.16	KANG.H.J	 [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
	   2026.03.23	김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
	   2026.04.23 강민재      NextSCM Pilot 수정
	 */
	IS
	  --v_batch_user      VARCHAR2(150 CHAR) := 'scm_batch';
	  $$PLSQL_UNIT    VARCHAR2(150 CHAR) := $$PLSQL_UNIT; --PR_DM_DNM_EDI_CALLOFF_STATUS(AS);
	  V_BATCH_CHK_MSG   VARCHAR2(150 CHAR) := ' ';
	
	  V_LOG_TYPE        VARCHAR2(30 CHAR);
	  N_LOG_COUNT       INTEGER := 0;
	  V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
	  V_DESCRIPTION     VARCHAR2(500 CHAR);
	  D_EVENT_DATE      DATE;
	  --N_HISTORY_SEQ     NUMBER;
	  V_DIVISION_ID     VARCHAR2(30 CHAR);
	  
	  V_FROM_YYYYMMDD   VARCHAR2(4000 CHAR);
	  V_IN_PARA_DATA    VARCHAR2(4000 CHAR) := '';
	BEGIN

	  IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
	      $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
	  END IF;
		--CHECKPOINT
		---- 버퍼 풀 초기화
		--DBCC DROPCLEANBUFFERS
		---- 프로시저 캐시 초기화
		--DBCC FREEPROCCACHE
	  	-- LOG 용 변수 설정
	
		-- 시작 LOG
	  V_LOG_TYPE := 'START';
	  V_LOG_MESSAGE := '########## Start of procedure ##########';
	  V_DESCRIPTION := NULL;
	  D_EVENT_DATE := SYSTIMESTAMP;
	  PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

	  ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	  ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
	
	  -- 기존 MSSQL에서는 DROP 후 CREATE로 테이블 매번 생성
	
	  V_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') + (-52)*7, 'YYYYMMDD');
	
	  -- ITEM_RECORD 입력용 TEMP TABLE 생성
	  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDEC_EDI_INVALID_DATA';
	  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDEC_SCM_MST_ITEM_SN';
	  EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDEC_SCM_MST_SITE_ITEM';
	
	  ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		BEGIN
		    /*
		      0. 점검대상 테이블 추출
		    */
			BEGIN
			-- GT_DDEC_EDI_INVALID_DATA
			INSERT /*+ NO_PARALLEL */ INTO GT_DDEC_EDI_INVALID_DATA
			( 
			    EDI_IF_SEQ
			  , SUB_NO
			  , YYYYMMDD
			  , IFSEQNO
			  , DIVISION_ID
			  , COMPANY_ID
			  , SENDER_CODE
			  , SENDER_NAME
			  , SOLDTO_CODE
			  , SHIPTO_CODE
			  , UNLOADING_POINT
			  , CUSTOMER_PLANT
			  , PROJECT_CODE
			  , CUST_MATERIAL_CODE
			  , ITEM_ID
			  , SCM_SITE_ID
			  , SALES_PLANT_SITE_ID
			  , EDI_INCOTERMS
			  , STATUS_CODE
			  , BOM_STATUS
			  , SALES_SITE_STATUS
			  , PROJECT_STATUS
			  , ITEM_STATUS
			  , SSPM_STATUS
			  , PLANT_SITE_STATUS
			  , INCOTERMS_STATUS
			  , SALES_PLANT_SITE_STATUS
			  , ERP_STATUS
			)
			SELECT 
          		EDI_IF_SEQ
	          , SUB_NO
	          , YYYYMMDD
	          , IFSEQNO
			  , DIVISION_ID
	          , COMPANY_ID
			  , SENDER_CODE
	          , SENDER_NAME
	          , SOLDTO_CODE
	          , SHIPTO_CODE
			  , UNLOADING_POINT
	          , CUSTOMER_PLANT
	          , PROJECT_CODE
	          , CUST_MATERIAL_CODE
	          , ITEM_ID
			  , SCM_SITE_ID 
	          , SALES_PLANT_SITE_ID 
	          , EDI_INCOTERMS
			  , STATUS_CODE
	          , BOM_STATUS
	          , SALES_SITE_STATUS
	          , PROJECT_STATUS
	          , ITEM_STATUS
	          , SSPM_STATUS
	          , PLANT_SITE_STATUS
	          , INCOTERMS_STATUS
	          , SALES_PLANT_SITE_STATUS
	          , ERP_STATUS
			FROM DM_DNM_EDI_CALLOFF_ITEM A
      		WHERE 1=1
	        -- U : CALL_OFF_DATA 기반 신규 생성 / E : 기 점검되었으나 기준정보 부족으로 인해 보류된 건.
	        AND STATUS_CODE IN ('U', 'E')		
	        --오늘 기준 전전월(M-2 월의 1일)부터 현재까지 데이터만 변경
	        AND A.CREATE_DATE >= V_FROM_YYYYMMDD;

			-- GT_DDEC_SCM_MST_ITEM_SN
			INSERT /*+ NO_PARALLEL */ INTO GT_DDEC_SCM_MST_ITEM_SN 
		      (
		        DIVISION_ID
		      , COMPANY_ID
		      , ITEM_ID
		      , SITE_ID
		      , ITEM_TYPE
		      )
			SELECT DISTINCT 
		        DIVISION_ID
		      , COMPANY_ID
		      , ITEM_ID
		      , SITE_ID
		      , ITEM_TYPE
			FROM SCM_MST_ITEM_SN
			WHERE 1=1
        	AND DIVISION_ID IN (SELECT DISTINCT DIVISION_ID FROM GT_DDEC_EDI_INVALID_DATA);

			-- GT_DDEC_SCM_MST_SITE_ITEM
			INSERT /*+ NO_PARALLEL */ INTO GT_DDEC_SCM_MST_SITE_ITEM 
		      (
		        DIVISION_ID
		      , SCM_SITE_ID
		      , ITEM_ID
		      , PROJECT_CODE
		      , SALES_PLANT
		      , EDI_INCOTERMS
		      , VALID_YN
		      )
			SELECT 
		        A.DIVISION_ID
		      , A.SCM_SITE_ID
		      , A.ITEM_ID
		      , A.PROJECT_CODE
		      , A.SALES_PLANT
		      , A.ATTRIBUTE6 EDI_INCOTERMS
		      , A.VALID_YN
			FROM
			(
				SELECT 
		          A.DIVISION_ID
		        , A.SCM_SITE_ID
		        , A.ITEM_ID
		        , A.PROJECT_CODE
		        , A.SALES_PLANT
		        , A.ATTRIBUTE6
		        , A.VALID_YN
				, ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID ORDER BY A.CREATION_DATE DESC, A.PROJECT_CODE DESC) RN	--PROJECT 코드가 중복이므로 가장 최근의 프로젝트로 선정함
				FROM SCM_MST_SITE_ITEM	A
				WHERE 1=1
          		AND DIVISION_ID IN (SELECT DISTINCT DIVISION_ID FROM GT_DDEC_EDI_INVALID_DATA)
          		AND	VALID_YN = 'Y'
			) A
			WHERE RN = 1;
		END;

		/*
      	1. SALES_SITE_STATUS
      	SoldTo, Shipto 정보를 기반으로 SCM_SITE_ID 찾아서 업데이트.
      	. 정보 있을 시,SALES_SITE_STATUS = 'S'로 반영.
      	. 정보 없을 시 SALES_SITE_STATUS = 'E'로 반영, STATUS_CODE = 'E'로 반영
		*/
		BEGIN
			-- SCM_SITE_ID, SALES_SITE_STATUS 업데이트
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING
			(
				SELECT 
		            A1.DIVISION_ID
		          , A1.SCM_SITE_ID
		          , A1.SOLDTO_CODE
		          , A1.SHIPTO_CODE
		          , A2.PLANT_ID
		          , A2.OPERATION_GROUP
		          , A2.SITE_TYPE
				FROM SCM_MST_SITE_CUSTOMER A1
				INNER JOIN SCM_MST_SITE A2
				ON	A1.DIVISION_ID	= A2.DIVISION_ID
				AND	A1.SCM_SITE_ID	= A2.SCM_SITE_ID
				AND A2.SITE_TYPE    = 'SALES'
				AND A2.VALID_YN		  = 'Y'
				AND A1.DIVISION_ID IN (SELECT DISTINCT DIVISION_ID FROM GT_DDEC_EDI_INVALID_DATA)
				WHERE A1.VALID_YN	  = 'Y'
			) B
			ON (
	            1=1
	        AND A.DIVISION_ID	= B.DIVISION_ID
	        AND A.SOLDTO_CODE	= B.SOLDTO_CODE
	        AND A.SHIPTO_CODE	= B.SHIPTO_CODE
      		)
			WHEN MATCHED THEN UPDATE SET
          		A.SCM_SITE_ID	      = B.SCM_SITE_ID
			,	A.SALES_SITE_STATUS = 'S'
			WHEN NOT MATCHED THEN INSERT (EDI_IF_SEQ) VALUES (NULL);

			UPDATE GT_DDEC_EDI_INVALID_DATA A
      		SET		A.SALES_SITE_STATUS = 'E'
				,	A.STATUS_CODE		= 'E'
			WHERE NOT EXISTS (
				SELECT 1 FROM SCM_MST_SITE_CUSTOMER A1
				INNER JOIN SCM_MST_SITE A2
				ON	A1.DIVISION_ID	  = A2.DIVISION_ID
				AND	A1.SCM_SITE_ID	  = A2.SCM_SITE_ID
				AND A2.SITE_TYPE      = 'SALES'
				AND A2.VALID_YN		    = 'Y'
				WHERE 1=1 
        		AND   A1.VALID_YN	    = 'Y'
				AND   A1.DIVISION_ID  = A.DIVISION_ID
				AND   A1.SOLDTO_CODE  = A.SOLDTO_CODE
				AND   A1.SHIPTO_CODE  = A.SHIPTO_CODE
			);
		END;

		/*
      	2. SSPM_STATUS / ITEM_STATUS
      	. DIVISION_ID, SCM_SITE_ID, ITEM_ID 기반으로 SSPM 정보 존재 여부를 확인한다.
      	. 정보가 있다면 MAX 기준으로 프로젝트 코드 데이터 정비
      	. 정보 있을 시, SSPM_STATUS, ITEM_STATUS S로 반영
      	. 정보 없을 시, SSPM_STATUS, ITEM_STATUS E로 반영, STATUS_CODE = 'E'로 반영
		*/
    	BEGIN
			-- SSPM_STATUS / ITEM_ID 업데이트
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING (
        	SELECT 
		            DIVISION_ID
		          , SCM_SITE_ID
		          , ITEM_ID
		          , PROJECT_CODE
		        FROM GT_DDEC_SCM_MST_SITE_ITEM 
		        WHERE VALID_YN = 'Y'
		      ) B
			ON (
            	1=1
		        AND A.DIVISION_ID	= B.DIVISION_ID
		        AND A.SCM_SITE_ID	= B.SCM_SITE_ID
		        AND A.ITEM_ID		  = B.ITEM_ID
	      	)
			WHEN MATCHED THEN UPDATE SET
          			A.SSPM_STATUS	  = 'S'
				,	A.ITEM_STATUS	  = 'S'
				,	A.PROJECT_CODE	= CASE WHEN LENGTH(B.PROJECT_CODE) > 0	THEN B.PROJECT_CODE		ELSE NULL		END		--Project_Code는 Division_id, Scm_Site_ID, Item까지만 비교하여 가장 최근 Project_Code로 생성함.
			;
		
			UPDATE GT_DDEC_EDI_INVALID_DATA A
			SET	A.SSPM_STATUS	  = 'E'
				,	A.ITEM_STATUS	  = 'E'
				,	A.STATUS_CODE	  = 'E'
			WHERE NOT EXISTS (
				SELECT 1 FROM GT_DDEC_SCM_MST_SITE_ITEM B
				WHERE 1=1
        		AND B.VALID_YN    = 'Y'
				AND A.DIVISION_ID = B.DIVISION_ID
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.ITEM_ID     = B.ITEM_ID
			);

		END;

		/*
      	3. PROJECT_CODE
		. DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE 기반으로 PROJECT_CODE 정보 존재 여부를 확인한다.
		. 정보 있을 시, PROJECT_STATUS = S로 반영
		. 정보 없을 시, PROJECT_STATUS = E로 반영, STATUS_CODE = 'E'로 반영
		*/
    	BEGIN
			-- PROJECT_CODE / PROJECT_STATUS 업데이트
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING (
        	SELECT 
	            DIVISION_ID
	          , SCM_SITE_ID
	          , ITEM_ID
	          , PROJECT_CODE 
	        FROM GT_DDEC_SCM_MST_SITE_ITEM
	        WHERE VALID_YN      = 'Y'
      		) B
			ON (
          		1=1
     		AND A.DIVISION_ID	    = B.DIVISION_ID
			AND A.SCM_SITE_ID	    = B.SCM_SITE_ID
			AND A.ITEM_ID		      = B.ITEM_ID
			AND A.PROJECT_CODE	  = B.PROJECT_CODE
      		)
			WHEN MATCHED THEN UPDATE SET
		          	A.PROJECT_STATUS  = CASE WHEN LENGTH(B.PROJECT_CODE) > 0 THEN 'S' ELSE 'E'	END
		        ,	A.STATUS_CODE		  = CASE WHEN LENGTH(B.PROJECT_CODE) = 0 OR B.PROJECT_CODE IS NULL THEN 'E'	END
			;
      
			UPDATE GT_DDEC_EDI_INVALID_DATA A
			SET		A.PROJECT_STATUS	= 'E'
          		,	A.STATUS_CODE		  = 'E'
			WHERE NOT EXISTS (
				SELECT 1 
        		FROM GT_DDEC_SCM_MST_SITE_ITEM B
				WHERE 1=1 
		          AND B.VALID_YN      = 'Y'
		          AND A.DIVISION_ID   = B.DIVISION_ID
		          AND A.SCM_SITE_ID   = B.SCM_SITE_ID
		          AND A.ITEM_ID       = B.ITEM_ID
		          AND A.PROJECT_CODE  = B.PROJECT_CODE
			);

		END;

		/*
      	4. INCOTERMS_STATUS / SALES_PLAN_SITE_STATUS
		. DIVISION_ID, SCM_SITE_ID, ITEM_ID 기반으로 PROJECT_CODE, EDI_INCOTERMS, SALES_PLAN_SITE_ID 를 찾는다.
		. 각각의 정보 있을 시, PROJECT_CODE, EDI_INCOTERMS, SALES_PLANT_SITE_ID 업데이트, PROJECT_STATUS, INCOTERMS_STATUS, SALES_PLAN_SITE_STATUS S로 반영
		. 각각의 정보 없을 시, PROJECT_STATUS, INCOTERMS_STATUS, SALES_PLAN_SITE_STATUS E로 반영, STATUS_CODE = 'E'로 반영
		. incoterms 및 Sales_Plant_Site_ID는 빈칸일 수도 있기 때문에 길이로 판단함.
	    */
		BEGIN
			-- INCOTERMS / SALES_PLANT_SITE_ID 업데이트
			MERGE INTO GT_DDEC_EDI_INVALID_DATA A
			USING (
        	SELECT 
	            DIVISION_ID
	          , SCM_SITE_ID
	          , ITEM_ID
	          , PROJECT_CODE
	          , EDI_INCOTERMS
	          , SALES_PLANT
	        FROM GT_DDEC_SCM_MST_SITE_ITEM
	        WHERE VALID_YN = 'Y'
	      ) B
			ON (
          		1=1
      		AND A.DIVISION_ID	  = B.DIVISION_ID
			AND A.SCM_SITE_ID	  = B.SCM_SITE_ID
			AND A.PROJECT_CODE	= B.PROJECT_CODE
	      AND A.ITEM_ID		= B.ITEM_ID
	      )
			WHEN MATCHED THEN UPDATE SET
          			A.EDI_INCOTERMS				    = CASE WHEN LENGTH(B.EDI_INCOTERMS) > 0   THEN B.EDI_INCOTERMS	ELSE 'E'	END
				,	A.INCOTERMS_STATUS			  = CASE WHEN LENGTH(B.EDI_INCOTERMS) > 0   THEN 'S'				      ELSE 'E'	END
				,	A.SALES_PLANT_SITE_STATUS	= CASE WHEN LENGTH(B.SALES_PLANT) > 0	    THEN 'S'				      ELSE 'E'	END
				, A.SALES_PLANT_SITE_ID		  = CASE WHEN LENGTH(B.SALES_PLANT) > 0		  THEN
        		(B.SALES_PLANT || CASE WHEN SUBSTR(B.ITEM_ID, 2, 1) IN ('M', 'P') THEN '-P' ELSE '-A' END)  ELSE NULL END
        		,	A.STATUS_CODE				      = CASE WHEN (LENGTH(B.EDI_INCOTERMS) IS NULL OR LENGTH(B.SALES_PLANT) IS NULL) THEN 'E' END
			;

			UPDATE GT_DDEC_EDI_INVALID_DATA A
			SET		A.EDI_INCOTERMS				    = 'E'
		          ,	A.INCOTERMS_STATUS			  = 'E'
		          ,	A.SALES_PLANT_SITE_STATUS	= 'E'
		          , A.SALES_PLANT_SITE_ID		  = NULL
		          ,	A.STATUS_CODE				      = 'E'
			WHERE NOT EXISTS (
				SELECT 1 
        	FROM GT_DDEC_SCM_MST_SITE_ITEM B
				WHERE 1=1
		          AND B.VALID_YN      = 'Y'
		          AND A.DIVISION_ID   = B.DIVISION_ID
		          AND A.SCM_SITE_ID   = B.SCM_SITE_ID
		          AND A.PROJECT_CODE  = B.PROJECT_CODE
		          AND A.ITEM_ID       = B.ITEM_ID
			);
		END;

		/*
      	5.  SALES_SITE_STATUS / SSPM_STATUS / PROJECT_STATUS / ITEM_STATUS / INCOTERMS_STATUS / SALES_PLANT_SITE_STATUS 모두 S ==> STATUS_CODE ='S'
	  	* 참고로 BOM_STATUS는 체크로직 제외됨.
    	*/
		BEGIN
			UPDATE GT_DDEC_EDI_INVALID_DATA
			SET STATUS_CODE = 'S'
			WHERE 1=1
			AND (
		            SALES_SITE_STATUS       = 'S'
		        AND SSPM_STATUS             = 'S' 
		        AND PROJECT_STATUS          = 'S' 
		        AND ITEM_STATUS             = 'S' 
		        AND INCOTERMS_STATUS        = 'S' 
		        AND SALES_PLANT_SITE_STATUS = 'S'
      		);
		END;

		/*
      	6.  최종 점검 데이터 원테이블에 UPDATE
    	*/
		BEGIN
			/* TODO: UPDATE...FROM MERGE 변환 실패 */
			MERGE INTO DM_DNM_EDI_CALLOFF_ITEM T
			USING (SELECT * FROM GT_DDEC_EDI_INVALID_DATA) A
			ON (T.EDI_IF_SEQ	= A.EDI_IF_SEQ
			AND T.SUB_NO		  = A.SUB_NO
			AND T.YYYYMMDD		= A.YYYYMMDD
			AND T.CREATE_DATE	>= V_FROM_YYYYMMDD)
			WHEN MATCHED THEN UPDATE SET
          		  T.PROJECT_CODE			    = A.PROJECT_CODE
				, T.SCM_SITE_ID				    = A.SCM_SITE_ID
				, T.SALES_PLANT_SITE_ID		  	= A.SALES_PLANT_SITE_ID
				, T.STATUS_CODE				    = NVL(A.STATUS_CODE, 'E')
				, T.SALES_SITE_STATUS		    = NVL(A.SALES_SITE_STATUS, 'E')
        		, T.BOM_STATUS				    = NVL(A.BOM_STATUS, 'E')
				, T.SSPM_STATUS				    = NVL(A.ITEM_STATUS, 'E')
				, T.PROJECT_STATUS			    = NVL(A.PROJECT_STATUS, 'E')
				, T.ITEM_STATUS				    = NVL(A.ITEM_STATUS, 'E')
				, T.INCOTERMS_STATUS		    = NVL(A.INCOTERMS_STATUS, 'E')
				, T.EDI_INCOTERMS			    = A.EDI_INCOTERMS
				, T.SALES_PLANT_SITE_STATUS		= A.SALES_PLANT_SITE_STATUS
				, T.LAST_UPDATE_DATE		    = SYSDATE
				, T.LAST_UPDATED_BY			    = 'scm_batch';
		END;


		/*
	     7.  예외로직 적용
	     *   예외라 함은 NERP로부터 EDI 접수받더라도 집계에서는 제외한다는 의미로.
	     *   EXCEPTION_FLAG = 'Y' 라 함은 CALL_OFF_STATUS에서 점검 제외 ==> MKT_FCST(CUST_FCST_EDI) 집계도 제외 함.
	     *   EXCEPTION_FLAG 는 'Y'와 NULL 2중 1개로만 존재함.
    	*/
		BEGIN
			UPDATE DM_DNM_EDI_CALLOFF_ITEM A
			SET EXCEPTION_FLAG    = 'Y'
	          , EXCEPTION_DATE    = SYSDATE
	          , LAST_UPDATE_DATE  = SYSDATE
	          , LAST_UPDATED_BY   = 'scm_batch_exception_1'
			WHERE 1=1
			AND A.CREATE_DATE >= V_FROM_YYYYMMDD
			--AND NVL(A.EXCEPTION_FLAG , NULL) <> 'Y'
			AND EXISTS
			(
				SELECT 1
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL Z
				WHERE Z.LOOKUP_TYPE = 'DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE'
				AND Z.SEGMENT1  = A.DIVISION_ID
				AND (LTRIM(RTRIM(Z.SEGMENT2)) = LTRIM(RTRIM(A.SENDER_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT2)) IS NULL AND LTRIM(RTRIM(A.SENDER_CODE)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT3)) = LTRIM(RTRIM(A.UNLOADING_POINT)) OR (LTRIM(RTRIM(Z.SEGMENT3)) IS NULL AND LTRIM(RTRIM(A.UNLOADING_POINT)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT4)) = LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT4)) IS NULL AND LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) IS NULL))
				AND Z.VALID_YN = 'Y'
				AND (A.YYYYMMDD BETWEEN Z.ATTRIBUTE2 AND Z.ATTRIBUTE3)
			);

			UPDATE DM_DNM_EDI_CALLOFF_ITEM A
			SET   EXCEPTION_FLAG = NULL
				, EXCEPTION_DATE = NULL
				, LAST_UPDATE_DATE = SYSDATE
				, LAST_UPDATED_BY = 'scm_batch_exception_2'
			WHERE 1=1
			AND A.CREATE_DATE >= V_FROM_YYYYMMDD
			--AND A.EXCEPTION_FLAG = 'Y'
			AND EXISTS
			(
				SELECT 1
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL Z
				WHERE Z.LOOKUP_TYPE = 'DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE'
				AND Z.SEGMENT1  = A.DIVISION_ID
				AND (LTRIM(RTRIM(Z.SEGMENT2)) = LTRIM(RTRIM(A.SENDER_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT2)) IS NULL AND LTRIM(RTRIM(A.SENDER_CODE)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT3)) = LTRIM(RTRIM(A.UNLOADING_POINT)) OR (LTRIM(RTRIM(Z.SEGMENT3)) IS NULL AND LTRIM(RTRIM(A.UNLOADING_POINT)) IS NULL))
				AND (LTRIM(RTRIM(Z.SEGMENT4)) = LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) OR (LTRIM(RTRIM(Z.SEGMENT4)) IS NULL AND LTRIM(RTRIM(A.CUST_MATERIAL_CODE)) IS NULL))
				AND Z.VALID_YN = ''
				AND (A.YYYYMMDD BETWEEN Z.ATTRIBUTE2 AND Z.ATTRIBUTE3)
			);

		END;

		COMMIT;

	END;

    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
    -- END TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    EXCEPTION
        WHEN OTHERS THEN
      ROLLBACK;
      V_LOG_TYPE := 'ERROR';
      V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
      V_DESCRIPTION := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
      D_EVENT_DATE := SYSTIMESTAMP;

      PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    -- END CATCH

    -- 종료 LOG
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    --V_DESCRIPTION := 'INVALID Count : ' || CAST((v_result_invalid_count) AS VARCHAR2(10)) ||' / '|| 'CUST_FCST INSERT INTO Count : ' || CAST((v_result_insert_count) AS VARCHAR2(10))  ;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

	--ERR_RTN:

	DBMS_OUTPUT.PUT_LINE('end '  ||  TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
            RAISE_APPLICATION_ERROR(-20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
                ' / SQLERRM=' || SQLERRM ||
                ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                ' / PARAMS=' || V_IN_PARA_DATA
            );
  END P_DMF0008_DNM_EDI_CALLOFF_STATUS;

  
END PKG_DMF0008;
/
