-- SOURCE-FRESH: SCM_MGR.PKG_DMF0072 PACKAGE BODY LAST_DDL=2026-10-15 11:14:12 FETCHED=2026-10-15 11:15 DB=ZIOUI1
-- ROLLBACK 용 원본 (GAP413 적용 전)
CREATE OR REPLACE PACKAGE BODY         "PKG_DMF0072" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0072                                                                        */
/* Description : PKG_DMF0072                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.23  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0072_GET_NNMASTER_MAPPING
(
      P_DATA_TYPE_CODE    IN VARCHAR2--(10 CHAR)
    , P_DIVISION_ID       IN VARCHAR2--(30 CHAR)
    , P_DEPT_ID           IN VARCHAR2--(4000 CHAR)   --Department
    , P_END_CUSTOMER      IN VARCHAR2--(4000 CHAR)   --Endcustomer
    , P_SCM_SITE_ID       IN VARCHAR2--(30 CHAR)
    , P_PROJECT_CODE      IN VARCHAR2--(50 CHAR)
    , P_ITEM_ID           IN VARCHAR2--(50 CHAR)
    , P_USER_ID           IN VARCHAR2
    , P_MENU_ID           IN VARCHAR2
   
    , O_RC1               OUT SYS_REFCURSOR
    , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
* Program ID  : [DMF0072_GET_NNMASTER_MAPPING]                                                           
* Description : Procedure 작성 가이드                                                              
* Usage       : Procedure 작성 시 참조하세요!                                                      
* Parameter   :                                                                                    
*=====================================================================================================================================================
*  Date     In Charge   Description                                                             
*=====================================================================================================================================================
* 2024.04.02  KJJ     Initial Release  
* 2024.08.14  KJJ     [PJ2024-50461] Team Mapping
* 2024.12.10  dsiol   [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 
* 2025.01.21  dsiol   [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포 
* 2025.09.16  JSSBAE    [E20250910-000974]_NN Mapping Master 컬럼 추가 요청

-- EXEC DMF0072_GET_NNMASTER_MAPPING          @p_data_type_code='ALL', @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code='', @p_item_id=''
-- EXEC DMF0072_GET_NNMASTER_MAPPING_20241210 @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code='', @p_item_id=''
*===================================================================================================================================================*/
AS
    -- EXCEPTION 처리 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;


BEGIN
  
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;


    OPEN O_RC1 FOR
    SELECT DATA_TYPE_CODE, DIVISION_ID, COMPANY_ID, END_CUSTOMER, UNLOADING_POINT
         , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, PROJECT_CODE
         , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
         , MAPPING_ITEM_ID, MAPPING_ITEM_ID AS MAPPING_ITEM_ID_ORIGINAL, VALID_START_DATE, VALID_END_DATE, ACTIVE_YN
         , LAST_UPDATE_DATE, LAST_UPDATED_BY
         , DC_LEVEL --[E20250910-000974]_DC_LEVEL 추가
         , EDIT_YN
    FROM (
        SELECT M.DATA_TYPE_CODE, M.DIVISION_ID, M.COMPANY_ID, M.END_CUSTOMER, M.UNLOADING_POINT
             , M.CUSTOMER_PLANT, M.SOLDTO_CODE, M.SHIPTO_CODE, M.SCM_SITE_ID, M.PROJECT_CODE
             , M.FCST_TYPE, M.INCOTERMS, M.DOM_EXP, M.CUSTOMER_ITEM_ID, M.ITEM_ID
             , M.MAPPING_ITEM_ID, M.VALID_START_DATE, M.VALID_END_DATE, M.ACTIVE_YN
             , M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY
             , NVL(M.DC_LEVEL, '') AS DC_LEVEL --[E20250910-000974]_DC_LEVEL 추가
             , EDY.EDIT_YN
        FROM SCM_MGR.DM_CUST_MODEL_MAPPING_M M
             INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
                  ON EDY.USER_ID = P_USER_ID
                 AND EDY.MNU_ID  = P_MENU_ID
                 AND EDY.UNIT_ID = M.DIVISION_ID
             INNER JOIN (
                 SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                 FROM   SCM_MGR.SCM_MST_SITE
                 WHERE  VALID_YN = 'Y'
             ) C
                 ON  M.DIVISION_ID = C.DIVISION_ID
                 AND M.SCM_SITE_ID = C.SCM_SITE_ID
                 AND C.SITE_TYPE   = 'SALES'
             LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM SITE_ITEM
                 ON  M.DIVISION_ID  = SITE_ITEM.DIVISION_ID
                 AND M.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
                 AND M.SCM_SITE_ID  = SITE_ITEM.SCM_SITE_ID
                 AND M.ITEM_ID      = SITE_ITEM.ITEM_ID
--           LEFT JOIN (
--               SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
--               FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
--               INNER JOIN SCM_MST_SSO_DEPT_INFO C
--                   ON B.DEPT_ID = C.DEPT_ID
--           ) TEAM
--               ON TEAM.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(SITE_ITEM.OWNER, ',')) WHERE ROWNUM = 1)
             /* 부서 원천을 아이템 원장(SITE_ITEM.DEPT_ID)으로 변경. 부서 마스터는 주는 값이 없어 조인 제거 */   -- 2026.09.06 AJS
        WHERE M.DIVISION_ID = P_DIVISION_ID
          -- ── DATA_TYPE_CODE 분기 (UNION ALL 대신 인라인 조건; 단일 스캔 유지)
          AND M.DATA_TYPE_CODE = CASE WHEN P_DATA_TYPE_CODE = 'ALL' THEN M.DATA_TYPE_CODE ELSE P_DATA_TYPE_CODE END
          -- ── DEPT_ID 분기
--        AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END
--             IN ( SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P
--                   WHERE ( CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN )
          AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE SITE_ITEM.DEPT_ID END        -- 2026.09.06 AJS
               IN ( SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P
                     WHERE ( CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE SITE_ITEM.DEPT_ID END) = P.TOKEN )
          -- ── END_CUSTOMER 분기
          AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE M.END_CUSTOMER END
               IN ( SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P
                     WHERE ( CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE M.END_CUSTOMER END) = P.TOKEN )
          -- ── SCM_SITE_ID 분기
          AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE M.SCM_SITE_ID END 
               IN ( SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P
                     WHERE ( CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE M.SCM_SITE_ID END) = P.TOKEN )
          -- ── PROJECT_CODE 분기
          AND (P_PROJECT_CODE IS NULL
               OR
               P_PROJECT_CODE IS NOT NULL AND UPPER(M.PROJECT_CODE) IN ( SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(UPPER(P_PROJECT_CODE),',')) P)
               OR
              (EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(UPPER(P_PROJECT_CODE),',')) P WHERE UPPER(M.PROJECT_CODE) LIKE '%' || UPPER(P.TOKEN) ||'%'))
              )--260820 조회조건 Upper 처리
          -- ── ITEM_ID 분기
          AND (P_ITEM_ID IS NULL
               OR
               P_ITEM_ID IS NOT NULL AND UPPER(M.ITEM_ID) IN ( SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(UPPER(P_ITEM_ID),',')) P)
               OR
              (EXISTS (SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(UPPER(P_ITEM_ID),',')) P WHERE UPPER(M.ITEM_ID) LIKE '%' || UPPER(P.TOKEN) ||'%'))
              )--260820 조회조건 Upper 처리
    ) A
    GROUP BY DIVISION_ID, COMPANY_ID, DATA_TYPE_CODE, END_CUSTOMER, UNLOADING_POINT
           , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, PROJECT_CODE, SCM_SITE_ID
           , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
           , MAPPING_ITEM_ID, ACTIVE_YN, VALID_START_DATE, VALID_END_DATE
           , LAST_UPDATE_DATE, LAST_UPDATED_BY, DC_LEVEL  --[E20250910-000974]_DC_LEVEL 추가
           , EDIT_YN
    ORDER BY DIVISION_ID, DATA_TYPE_CODE, COMPANY_ID, END_CUSTOMER, UNLOADING_POINT
           , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, PROJECT_CODE
           , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID;


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
            'P_DATA_TYPE_CODE' VALUE P_DATA_TYPE_CODE,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_DEPT_ID'        VALUE P_DEPT_ID,
            'P_END_CUSTOMER'   VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'    VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE'   VALUE P_PROJECT_CODE,
            'P_ITEM_ID'        VALUE P_ITEM_ID,            
            'P_USER_ID'        VALUE P_USER_ID,
            'P_MENU_ID'        VALUE P_MENU_ID
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

END P_DMF0072_GET_NNMASTER_MAPPING;

PROCEDURE P_DMF0072_SAVE_NNMASTER_MAPPING
(
      P_DIVISION_ID              IN VARCHAR2
    , P_COMPANY_ID               IN VARCHAR2
    , P_ACT_TYPE                 IN VARCHAR2  -- 신규 / 수정 구분( I / M)
    , P_CUST_FCST_TYPE           IN VARCHAR2  -- DATA_TYPE_CODE
    , P_END_CUSTOMER             IN VARCHAR2
    , P_CUST_UNLOAD              IN VARCHAR2
    , P_CUST_PLANT               IN VARCHAR2
    , P_SOLDTO                   IN VARCHAR2
    , P_SHIPTO                   IN VARCHAR2
    , P_PROJECT_CODE             IN VARCHAR2
    , P_SCM_SITE_ID              IN VARCHAR2
    , P_FCST_TYPE                IN VARCHAR2
    , P_INCOTERMS                IN VARCHAR2
    , P_DOM_EXP                  IN VARCHAR2
    , P_CUST_ITEM_ID             IN VARCHAR2
    , P_MDM_CODE                 IN VARCHAR2
    , P_MAPPING_ITEM_ID          IN VARCHAR2
    , P_MAPPING_ITEM_ID_ORIGINAL IN VARCHAR2  --P_MAPPING_ITEM_ID가 KEY인데 수정 해야 해서 원본 값을 가져온다.
    , P_ACTIVE_FLAG              IN VARCHAR2
    , P_VALID_FROM               IN VARCHAR2
    , P_VALID_TO                 IN VARCHAR2
    , P_USER_ID                  IN VARCHAR2
    , O_RESULT_CURSOR            OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0072_SAVE_NNMASTER_MAPPING]
 * Description  : PR_DETAIL_AUTO 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2024. 04. 08   KJJ     최초 작성
 * 2024. 12. 10  dsiol      [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 *
 * 2025. 01. 21  dsiol          [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포
exec DMF0072_SAVE_NNMASTER_MAPPING 
 @P_DIVISION_ID=N'81'
,@P_COMPANY_ID=N'G380^G450^G450'
,@P_ACT_TYPE=N'M^M^M'
,@P_CUST_FCST_TYPE=N'SCM^SCM^SCM'
,@P_END_CUSTOMER=N'Ford^Volvo^Volvo'
,@P_CUST_UNLOAD=N' ^TCFE4^TCFE4'
,@P_CUST_PLANT=N' ^^'
,@P_SOLDTO=N'US000485^CN002782^CN002782'
,@P_SHIPTO=N'US000485^CNH011174^CNH011174'
,@P_PROJECT_CODE=N'A15FD5001^A17VO4001^A17VO4001'
,@P_SCM_SITE_ID=N'Piston_US_RDF^Zhongjia_CN_TIZ^Zhongjia_CN_TIZ'
,@P_FCST_TYPE=N'MPS^MPS^MPS'
,@P_INCOTERMS=N'DDP^FCA^FCA'
,@P_DOM_EXP=N'E^E^E'
,@P_CUST_ITEM_ID=N' L1M8-10C790-A-PIA-3-AK^32299991^32361087'
,@P_MDM_CODE=N'AMFMCU611-A8^AMVCCCMAE-A1-010^AMVCCCMAE-A1-000'
,@P_MAPPING_ITEM_ID=N'AMFMCU611-A9-000^AMVCCCMAE-A1-010^AMVCCCMAE-A1-000'
,@P_MAPPING_ITEM_ID_ORIGINAL=N'AMFMCU611-A8^AMVCCCMAE-A1-010^AMVCCCMAE-A1-000'
,@P_ACTIVE_FLAG=N'Y^Y^Y'
,@P_VALID_FROM=N'20240101^20240201^20240203'
,@P_VALID_TO=N'20991231^20991231^20991230'
,@P_USER_ID=N'dsiol'

exec DMF0072_SAVE_NNMASTER_MAPPING 
 @P_DIVISION_ID=N'81'
,@P_COMPANY_ID=N'G450^G380^G380^G450'
,@P_ACT_TYPE=N'I^M^M^M'
,@P_CUST_FCST_TYPE=N'SCM^SCM^SCM^SCM'
,@P_END_CUSTOMER=N'ATL^BMW^Ford^Aeonus'
,@P_CUST_UNLOAD=N' xxx^^^66666'
,@P_CUST_PLANT=N' yyy^1^^77777'
,@P_SOLDTO=N'B100^AT000009^US000485^AT000003'
,@P_SHIPTO=N'GBH000114^AT000009^US000485^ATH000019'
,@P_PROJECT_CODE=N'A22AT4002^A15BW7002^A15FD5001^A23US4001'
,@P_SCM_SITE_ID=N'ATL_GB_POO^BMW_DE_DFG^Piston_US_RDF^Aeonus_KR_GUN'
,@P_FCST_TYPE=N'MPS^MPS^MPS^MPS'
,@P_INCOTERMS=N'Z01^A01^DDP^FCA'
,@P_DOM_EXP=N'D^D^E^E'
,@P_CUST_ITEM_ID=N' 333^3^L1M8-10C790-A-PIA-3-AK^88888'
,@P_MDM_CODE=N'AMCOME782-A1-0A0^ACLT1010U-A1-D01^AMFMCU611-A8^ACEN1078I-A1-010'
,@P_MAPPING_ITEM_ID=N'AMVAGBEVN-B2-C07^ACLT1010U-A1-D04^ACPN1039I-A1^ACEN1078I-A1-010'
,@P_MAPPING_ITEM_ID_ORIGINAL=N'AMVAGBEVN-B2-C07^APBMW12V0-A1-000^ACPN1039I-A1^ACEN1078I-A1-010'
,@P_ACTIVE_FLAG=N'Y^Y^Y^Y'
,@P_VALID_FROM=N'20240105^20240104^20240102^20240101'
,@P_VALID_TO=N'99991205^99991231^99991230^99991231'
,@P_USER_ID=N'dsiol'

 */
AS

/*
-중요 로직

1.detail 테이블(DM_CUST_ITEM_MAPPING_DTL_N)은 먼저 지우고 insert한다

2.신규일 경우에,detail  정보를 입력안했으면 기본적인 Valid Range 정보를 detail에 강제로 저장한다
  =>시작일 : 당해년도 01-01
  =>종료일 : 2099-12-31
  =>item :  마스터에 등록된 ITEM_ID(@P_MDM_CODE)

3.수정일 경우에 detail  정보를 입력안했으면(기본으로 등록된 Valid Range 정보를 사용자가 직접 삭제하는경우)
  => 마스터의 ACTIVE_FLAG를 N으로 변경 =>화면에서 처리

*/

    -- LOG 용 변수 설정
    V_CREATION_DATE    DATE := SYSDATE;

    -- LOG 용 변수 설정
    V_LOG_TYPE      VARCHAR2(100   CHAR);
    N_LOG_COUNT     PLS_INTEGER    := 0;
    V_LOG_MESSAGE   VARCHAR2(4000  CHAR);
    V_DESCRIPTION   VARCHAR2(4000  CHAR);
    D_EVENT_DATE    DATE;
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    -- 예외처리 변수 설정
    V_PROC_INPUT    VARCHAR2(32000 CHAR);
    V_BACKTRACE     VARCHAR2(4000  CHAR);
    V_SQL_CODE      VARCHAR2(100   CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000  CHAR);

    ROWCNT          PLS_INTEGER := 0;
    V_EXISTS_CNT    PLS_INTEGER := 0;

    -- 커서 변수 (UF_FX_STRING_SPLIT 대체: ROW_NUMBER 기반 정렬 보장)
    -- MSSQL UF_FX_STRING_SPLIT은 NR(순번) 컬럼을 반환하므로
    -- Oracle에서는 ROWNUM 또는 ROW_NUMBER()로 동일한 순번 매핑
    --
    -- GTT 사용: GT_DM72_T_MAIN (MERGE 소스)
    -- GTT TRUNCATE: 이전에 일반 테이블 DML 없으므로 TRUNCATE 허용
    --
    -- DBMS_STATS / GLOBAL_TEMP_TABLE_STATS 설정:
    --   GT_DM72_T_MAIN 을 DM_CUST_MODEL_MAPPING_M 과 MERGE 하므로 필요
    
    CURSOR CUR_GT_DM72_T_MAIN IS
        SELECT 
               DATA_TYPE_CODE, END_CUSTOMER, UNLOADING_POINT, CUSTOMER_PLANT
             , SOLDTO_CODE, SHIPTO_CODE, PROJECT_CODE, SCM_SITE_ID
             , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
             , ACTIVE_YN, VALID_FROM, VALID_TO, MAPPING_ITEM_ID
             , ACT_TYPE, COMPANY_ID, MAPPING_ITEM_ID_ORIGINAL
        FROM SCM_MGR.GT_DM72_T_MAIN B
        WHERE B.ACT_TYPE IN ('M', 'I');             -- 2026.08.13 AJS
--        WHERE B.ACT_TYPE = 'M';


BEGIN

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ----------------------------------------------------------------
    -- GTT 초기화 (이전 DML 없음 → TRUNCATE 허용)
    -- ----------------------------------------------------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DM72_T_MAIN';

    -- ----------------------------------------------------------------
    -- 파라미터 STRING_SPLIT('^' 구분) → GTT 적재
    -- MSSQL UF_FX_STRING_SPLIT NR 컬럼 기준 순번 일치 보장
    -- APPEND 힌트 미사용: GTT + 이후 일반 테이블 MERGE 혼합
    -- ----------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DM72_T_MAIN
    (
          DATA_TYPE_CODE
        , END_CUSTOMER
        , UNLOADING_POINT
        , CUSTOMER_PLANT
        , SOLDTO_CODE
        , SHIPTO_CODE
        , PROJECT_CODE
        , SCM_SITE_ID
        , FCST_TYPE
        , INCOTERMS
        , DOM_EXP
        , CUSTOMER_ITEM_ID
        , ITEM_ID
        , ACTIVE_YN
        , VALID_FROM
        , VALID_TO
        , MAPPING_ITEM_ID
        , ACT_TYPE
        , COMPANY_ID
        , MAPPING_ITEM_ID_ORIGINAL
    )
    SELECT
          B1.TOKEN  AS DATA_TYPE_CODE
        , B2.TOKEN  AS END_CUSTOMER
        , B3.TOKEN  AS UNLOADING_POINT
        , B4.TOKEN  AS CUSTOMER_PLANT
        , B5.TOKEN  AS SOLDTO_CODE
        , B6.TOKEN  AS SHIPTO_CODE
        , B7.TOKEN  AS PROJECT_CODE
        , B8.TOKEN  AS SCM_SITE_ID
        , B9.TOKEN  AS FCST_TYPE
        , B10.TOKEN AS INCOTERMS
        , B11.TOKEN AS DOM_EXP
        , B12.TOKEN AS CUSTOMER_ITEM_ID
        , B13.TOKEN AS ITEM_ID
        , B14.TOKEN AS ACTIVE_YN
        , B15.TOKEN AS VALID_FROM
        , B16.TOKEN AS VALID_TO
        , B17.TOKEN AS MAPPING_ITEM_ID
        , B18.TOKEN AS ACT_TYPE
        , B19.TOKEN AS COMPANY_ID
        , B20.TOKEN AS MAPPING_ITEM_ID_ORIGINAL
     FROM (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_CUST_FCST_TYPE                            , '^'))) B1 
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_END_CUSTOMER              , '^'))) B2  ON B1.NR = B2.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_CUST_UNLOAD               , '^'))) B3  ON B1.NR = B3.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_CUST_PLANT                , '^'))) B4  ON B1.NR = B4.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_SOLDTO                    , '^'))) B5  ON B1.NR = B5.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_SHIPTO                    , '^'))) B6  ON B1.NR = B6.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_PROJECT_CODE              , '^'))) B7  ON B1.NR = B7.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_SCM_SITE_ID               , '^'))) B8  ON B1.NR = B8.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_FCST_TYPE                 , '^'))) B9  ON B1.NR = B9.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_INCOTERMS                 , '^'))) B10 ON B1.NR = B10.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_DOM_EXP                   , '^'))) B11 ON B1.NR = B11.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_CUST_ITEM_ID              , '^'))) B12 ON B1.NR = B12.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_MDM_CODE                  , '^'))) B13 ON B1.NR = B13.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_ACTIVE_FLAG               , '^'))) B14 ON B1.NR = B14.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_VALID_FROM                , '^'))) B15 ON B1.NR = B15.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_VALID_TO                  , '^'))) B16 ON B1.NR = B16.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_MAPPING_ITEM_ID           , '^'))) B17 ON B1.NR = B17.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_ACT_TYPE                  , '^'))) B18 ON B1.NR = B18.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_COMPANY_ID                , '^'))) B19 ON B1.NR = B19.NR
          LEFT OUTER JOIN (SELECT NR,TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_MAPPING_ITEM_ID_ORIGINAL  , '^'))) B20 ON B1.NR = B20.NR
    ;

    -- ----------------------------------------------------------------
    -- GTT 통계 수집 (MERGE 소스로 사용하므로 필수)
    -- ----------------------------------------------------------------
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM72_T_MAIN', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');

    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_DM72_T_MAIN',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    --SELECT * FROM GT_DM72_T_MAIN

    --SELECT * FROM DM_CUST_MODEL_MAPPING_M WHERE DATA_TYPE_CODE = 'SCM' AND DIVISION_ID = '81'

    --SELECT * FROM DM_CUST_MODEL_MAPPING_M A
    --INNER JOIN GT_DM72_T_MAIN B
    --ON           A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
    --     AND A.DIVISION_ID = P_DIVISION_ID
    --     AND A.COMPANY_ID = B.COMPANY_ID
    --     AND A.SOLDTO_CODE = B.SOLDTO_CODE
    --     AND A.SHIPTO_CODE = B.SHIPTO_CODE
    --     AND NVL(TRIM(A.UNLOADING_POINT),'') = NVL(TRIM(B.UNLOADING_POINT),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
    --     AND NVL(TRIM(A.CUSTOMER_PLANT),'') = NVL(TRIM(B.CUSTOMER_PLANT),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
    --     AND NVL(TRIM(A.CUSTOMER_ITEM_ID),'') = NVL(TRIM(B.CUSTOMER_ITEM_ID),'') -- 원천데이터에 공백이 있으므로 제거하고 처리
    --     --AND A.END_CUSTOMER = B.END_CUSTOMER
    --     AND A.SCM_SITE_ID = B.SCM_SITE_ID
    --     AND A.PROJECT_CODE = B.PROJECT_CODE
    --     AND A.FCST_TYPE = B.FCST_TYPE
    --     AND A.INCOTERMS = B.INCOTERMS
    --     AND A.DOM_EXP = B.DOM_EXP
    --     AND A.ITEM_ID = B.ITEM_ID
    --     AND A.MAPPING_ITEM_ID = B.MAPPING_ITEM_ID_ORIGINAL

    --MASTER 처리
    --ORA-38104: ON 절에서 참조되는 열은 업데이트할 수 없음: "A"."MAPPING_ITEM_ID" 오류로 FOR LOOP로 변경함
/*    MERGE INTO DM_CUST_MODEL_MAPPING_M A
    USING (
        SELECT 
               DATA_TYPE_CODE, END_CUSTOMER, UNLOADING_POINT, CUSTOMER_PLANT
             , SOLDTO_CODE, SHIPTO_CODE, PROJECT_CODE, SCM_SITE_ID
             , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
             , ACTIVE_YN, VALID_FROM, VALID_TO, MAPPING_ITEM_ID
             , ACT_TYPE, COMPANY_ID, MAPPING_ITEM_ID_ORIGINAL
        FROM GT_DM72_T_MAIN B
    ) B
    ON (
           A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
       AND A.DIVISION_ID    = P_DIVISION_ID
       AND A.COMPANY_ID     = B.COMPANY_ID
       AND A.SOLDTO_CODE    = B.SOLDTO_CODE
       AND A.SHIPTO_CODE    = B.SHIPTO_CODE
       AND NVL(TRIM(A.UNLOADING_POINT), '@#@#@#')  = NVL(TRIM(B.UNLOADING_POINT), '@#@#@#')  -- 원천데이터에 공백이 있으므로 제거하고 처리
       AND NVL(TRIM(A.CUSTOMER_PLANT), '@#@#@#')   = NVL(TRIM(B.CUSTOMER_PLANT), '@#@#@#')   -- 원천데이터에 공백이 있으므로 제거하고 처리
       AND NVL(TRIM(A.CUSTOMER_ITEM_ID), '@#@#@#') = NVL(TRIM(B.CUSTOMER_ITEM_ID), '@#@#@#') -- 원천데이터에 공백이 있으므로 제거하고 처리
       --AND A.END_CUSTOMER = B.END_CUSTOMER
       AND A.SCM_SITE_ID   = B.SCM_SITE_ID
       AND A.PROJECT_CODE  = B.PROJECT_CODE
       AND A.FCST_TYPE     = B.FCST_TYPE
       AND A.INCOTERMS     = B.INCOTERMS
       AND A.DOM_EXP       = B.DOM_EXP
       AND A.ITEM_ID       = B.ITEM_ID
       AND A.MAPPING_ITEM_ID = B.MAPPING_ITEM_ID_ORIGINAL
       AND B.ACT_TYPE      = 'M'
       --AND A.UNLOADING_POINT = B.UNLOADING_POINT--PK 추가
       --AND A.CUSTOMER_PLANT = B.CUSTOMER_PLANT--PK 추가
       --AND A.CUSTOMER_ITEM_ID = B.CUSTOMER_ITEM_ID--PK 추가
    )
    WHEN MATCHED THEN
        UPDATE SET
              A.VALID_START_DATE = B.VALID_FROM
            , A.VALID_END_DATE   = B.VALID_TO
            , A.ACTIVE_YN        = B.ACTIVE_YN
            , A.MAPPING_ITEM_ID  = B.MAPPING_ITEM_ID
            , A.LAST_UPDATED_BY  = P_USER_ID
            , A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT
        (
              DATA_TYPE_CODE
            , DIVISION_ID
            , COMPANY_ID
            , SOLDTO_CODE
            , SHIPTO_CODE
            , UNLOADING_POINT
            , CUSTOMER_PLANT
            , CUSTOMER_ITEM_ID
            , END_CUSTOMER
            , SCM_SITE_ID
            , PROJECT_CODE
            , FCST_TYPE
            , INCOTERMS
            , DOM_EXP
            , ITEM_ID
            , MAPPING_ITEM_ID
            , VALID_START_DATE
            , VALID_END_DATE
            , ACTIVE_YN
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
        )
        VALUES
        (
              B.DATA_TYPE_CODE
            , P_DIVISION_ID
            , B.COMPANY_ID
            , B.SOLDTO_CODE
            , B.SHIPTO_CODE
            , NVL(TRIM(B.UNLOADING_POINT), '-')
            , NVL(TRIM(B.CUSTOMER_PLANT), '-')
            , NVL(TRIM(B.CUSTOMER_ITEM_ID), '-')
            , B.END_CUSTOMER
            , B.SCM_SITE_ID
            , B.PROJECT_CODE
            , B.FCST_TYPE
            , B.INCOTERMS
            , B.DOM_EXP
            , B.ITEM_ID
            , B.MAPPING_ITEM_ID
            , B.VALID_FROM
            , B.VALID_TO
            , B.ACTIVE_YN
            , P_USER_ID
            , SYSDATE
            , P_USER_ID
            , SYSDATE
        );

    ROWCNT := SQL%ROWCOUNT;*/
    
    FOR REC IN CUR_GT_DM72_T_MAIN LOOP
      
        N_LOG_COUNT := N_LOG_COUNT + 1;
    
        -- 일치하는 데이터가 있는지 확인
        SELECT COUNT(1)
        INTO   V_EXISTS_CNT
        FROM   SCM_MGR.DM_CUST_MODEL_MAPPING_M A
        WHERE  A.DATA_TYPE_CODE  = REC.DATA_TYPE_CODE
          AND  A.DIVISION_ID     = P_DIVISION_ID
          AND  A.COMPANY_ID      = REC.COMPANY_ID
          AND  A.SOLDTO_CODE     = REC.SOLDTO_CODE
          AND  A.SHIPTO_CODE     = REC.SHIPTO_CODE
          AND  NVL(TRIM(A.UNLOADING_POINT), '@#@#@#') = NVL(TRIM(REC.UNLOADING_POINT), '@#@#@#')
          AND  NVL(TRIM(A.CUSTOMER_PLANT), '@#@#@#')   = NVL(TRIM(REC.CUSTOMER_PLANT), '@#@#@#')
          AND  NVL(TRIM(A.CUSTOMER_ITEM_ID), '@#@#@#') = NVL(TRIM(REC.CUSTOMER_ITEM_ID), '@#@#@#')
          AND  A.END_CUSTOMER    = REC.END_CUSTOMER
          AND  A.SCM_SITE_ID     = REC.SCM_SITE_ID
          AND  A.PROJECT_CODE    = REC.PROJECT_CODE
          AND  A.FCST_TYPE       = REC.FCST_TYPE
          AND  A.INCOTERMS       = REC.INCOTERMS
          AND  A.DOM_EXP         = REC.DOM_EXP
          AND  A.ITEM_ID         = REC.ITEM_ID
          AND  A.MAPPING_ITEM_ID = REC.MAPPING_ITEM_ID_ORIGINAL;

        IF V_EXISTS_CNT > 0 THEN
            -- 일치하는 데이터가 있을 경우 UPDATE
            UPDATE SCM_MGR.DM_CUST_MODEL_MAPPING_M A
            SET 
                A.VALID_START_DATE = REC.VALID_FROM,
                A.VALID_END_DATE   = REC.VALID_TO,
                A.ACTIVE_YN        = REC.ACTIVE_YN,
                A.MAPPING_ITEM_ID  = REC.MAPPING_ITEM_ID,
                A.LAST_UPDATED_BY  = P_USER_ID,
                A.LAST_UPDATE_DATE = SYSDATE
            WHERE A.DATA_TYPE_CODE  = REC.DATA_TYPE_CODE
              AND A.DIVISION_ID     = P_DIVISION_ID
              AND A.COMPANY_ID      = REC.COMPANY_ID
              AND A.SOLDTO_CODE     = REC.SOLDTO_CODE
              AND A.SHIPTO_CODE     = REC.SHIPTO_CODE
              AND NVL(TRIM(A.UNLOADING_POINT), '@#@#@#') = NVL(TRIM(REC.UNLOADING_POINT), '@#@#@#')
              AND NVL(TRIM(A.CUSTOMER_PLANT), '@#@#@#')   = NVL(TRIM(REC.CUSTOMER_PLANT), '@#@#@#')
              AND NVL(TRIM(A.CUSTOMER_ITEM_ID), '@#@#@#') = NVL(TRIM(REC.CUSTOMER_ITEM_ID), '@#@#@#')
              AND A.END_CUSTOMER    = REC.END_CUSTOMER
              AND A.SCM_SITE_ID     = REC.SCM_SITE_ID
              AND A.PROJECT_CODE    = REC.PROJECT_CODE
              AND A.FCST_TYPE       = REC.FCST_TYPE
              AND A.INCOTERMS       = REC.INCOTERMS
              AND A.DOM_EXP         = REC.DOM_EXP
              AND A.ITEM_ID         = REC.ITEM_ID
              AND A.MAPPING_ITEM_ID = REC.MAPPING_ITEM_ID_ORIGINAL;
        ELSE
            -- 일치하는 데이터가 없을 경우 INSERT
            INSERT INTO SCM_MGR.DM_CUST_MODEL_MAPPING_M (
                  DATA_TYPE_CODE
                , DIVISION_ID
                , COMPANY_ID
                , SOLDTO_CODE
                , SHIPTO_CODE
                , UNLOADING_POINT
                , CUSTOMER_PLANT
                , CUSTOMER_ITEM_ID
                , END_CUSTOMER
                , SCM_SITE_ID
                , PROJECT_CODE
                , FCST_TYPE
                , INCOTERMS
                , DOM_EXP
                , ITEM_ID
                , MAPPING_ITEM_ID
                , VALID_START_DATE
                , VALID_END_DATE
                , ACTIVE_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
            )
            VALUES (
                  REC.DATA_TYPE_CODE
                , P_DIVISION_ID
                , REC.COMPANY_ID
                , REC.SOLDTO_CODE
                , REC.SHIPTO_CODE
                , NVL(TRIM(REC.UNLOADING_POINT), '/')
                , NVL(TRIM(REC.CUSTOMER_PLANT), '/')
                , NVL(TRIM(REC.CUSTOMER_ITEM_ID), '/')
                , REC.END_CUSTOMER
                , REC.SCM_SITE_ID
                , REC.PROJECT_CODE
                , REC.FCST_TYPE
                , REC.INCOTERMS
                , REC.DOM_EXP
                , REC.ITEM_ID
                , REC.MAPPING_ITEM_ID
                , REC.VALID_FROM
                , REC.VALID_TO
                , REC.ACTIVE_YN
                , P_USER_ID
                , SYSDATE
                , P_USER_ID
                , SYSDATE
            );
        END IF;
        
    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 결과코드, 결과 카운트 반환
    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS RESULT_CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

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
            'P_DIVISION_ID'              VALUE P_DIVISION_ID,
            'P_COMPANY_ID'               VALUE P_COMPANY_ID,
            'P_ACT_TYPE'                 VALUE P_ACT_TYPE,
            'P_CUST_FCST_TYPE'           VALUE P_CUST_FCST_TYPE,
            'P_END_CUSTOMER'             VALUE P_END_CUSTOMER,
            'P_CUST_UNLOAD'              VALUE P_CUST_UNLOAD,
            'P_CUST_PLANT'               VALUE P_CUST_PLANT,
            'P_SOLDTO'                   VALUE P_SOLDTO,
            'P_SHIPTO'                   VALUE P_SHIPTO,
            'P_PROJECT_CODE'             VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'              VALUE P_SCM_SITE_ID,
            'P_FCST_TYPE'                VALUE P_FCST_TYPE,
            'P_INCOTERMS'                VALUE P_INCOTERMS,
            'P_DOM_EXP'                  VALUE P_DOM_EXP,
            'P_CUST_ITEM_ID'             VALUE P_CUST_ITEM_ID,
            'P_MDM_CODE'                 VALUE P_MDM_CODE,
            'P_MAPPING_ITEM_ID'          VALUE P_MAPPING_ITEM_ID,
            'P_MAPPING_ITEM_ID_ORIGINAL' VALUE P_MAPPING_ITEM_ID_ORIGINAL,
            'P_ACTIVE_FLAG'              VALUE P_ACTIVE_FLAG,
            'P_VALID_FROM'               VALUE P_VALID_FROM,
            'P_VALID_TO'                 VALUE P_VALID_TO,
            'P_USER_ID'                  VALUE P_USER_ID
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

END P_DMF0072_SAVE_NNMASTER_MAPPING;

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_DATA_TYPE_LIST 취합
PROCEDURE P_DMF0072_GET_DATA_TYPE_LIST (
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN O_RC1 FOR
        SELECT 'ALL' AS CODE, 'ALL' AS NAME FROM DUAL
        UNION ALL
        SELECT DISTINCT SEGMENT1, NVL(SEGMENT2, SEGMENT1) AS NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE='DM_EDI_DATA_TYPE_CODE' AND VALID_YN='Y'
         ORDER BY 1;
END P_DMF0072_GET_DATA_TYPE_LIST;

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_END_CUSTOMER_LIST 취합
PROCEDURE P_DMF0072_GET_END_CUSTOMER_LIST (
    P_DIVISION_ID VARCHAR2,
    P_DEPT_ID     VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is .cs L165~178: EndCustomerByDivision[40]
    --   div='40' 분기는 To-Be 에서 통합 SP 로 단일화 (분기 logic 은 wrapper 측에서 처리 가능)
    --   P_DEPT_ID 'ALL' 또는 NULL → 부서 무관 / 그 외 → 콤마 split 후 매칭
    OPEN O_RC1 FOR
      SELECT DISTINCT END_CUSTOMER AS CODE,
             END_CUSTOMER AS NAME
        FROM SCM_MGR.SCM_MST_SITE S
       WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR S.DIVISION_ID = P_DIVISION_ID)
         AND S.END_CUSTOMER IS NOT NULL
         AND S.VALID_YN = 'Y'
         -- cascading: P_DEPT_ID 가 'ALL' 또는 빈 값이면 전체, 그 외 부서별 (현 시점 매핑 부재 — site.OWNER dept 매핑 후속 작업)
         AND (P_DEPT_ID IS NULL OR P_DEPT_ID = 'ALL'
              OR EXISTS (
                SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID, ',')) P
                 WHERE P.TOKEN IS NOT NULL
              )
             )
       ORDER BY 1;
END P_DMF0072_GET_END_CUSTOMER_LIST;

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_NNMASTER_MAPPING_WRAPPER 취합
PROCEDURE P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER (
    P_DATA_TYPE_CODE VARCHAR2,
    P_DIVISION_ID    VARCHAR2,
    P_DEPT_ID        VARCHAR2,
    P_END_CUSTOMER   VARCHAR2,
    P_SCM_SITE_ID    VARCHAR2,
    P_PROJECT_CODE   VARCHAR2,
    P_ITEM_ID        VARCHAR2,
    P_USER_ID        VARCHAR2,
    P_MENU_ID        VARCHAR2,
    O_RC1            OUT SYS_REFCURSOR
) AS
    V_RESULT_CURSOR SYS_REFCURSOR;
BEGIN
    -- As-Is .cs L477~485: FoxDataRequest("DMF0072_GET_NNMASTER_MAPPING")
    --   p_data_type_code/divisionId/deptId/endCustomer/scmSiteId 모두 콤마 join 그대로 전달
    --   ('ALL' 도 그대로 — 메인 SP 가 CASE WHEN P_XXX='ALL' THEN ... 으로 처리)
    SCM_MGR.PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING(
        P_DATA_TYPE_CODE,
        P_DIVISION_ID,
        P_DEPT_ID,
        P_END_CUSTOMER,
        P_SCM_SITE_ID,
        P_PROJECT_CODE,
        P_ITEM_ID,
        P_USER_ID,
        P_MENU_ID,
        O_RC1,
        V_RESULT_CURSOR
    );
END P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER;

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_SALES_SITE_LIST 취합
PROCEDURE P_DMF0072_GET_SALES_SITE_LIST (
    P_DIVISION_ID  VARCHAR2,
    P_END_CUSTOMER VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is .cs L186: UserSiteByEndCustomer — Division + End Customer(다중) 기반 SCM Site list
    OPEN O_RC1 FOR
      SELECT DISTINCT S.SCM_SITE_ID AS CODE,
             NVL(S.SITE_DESCRIPTION, S.SCM_SITE_ID) AS NAME
        FROM SCM_MGR.SCM_MST_SITE S
       WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR S.DIVISION_ID = P_DIVISION_ID)
         AND S.VALID_YN = 'Y'
         -- multi-value cascading: 콤마 split
         AND (P_END_CUSTOMER IS NULL OR P_END_CUSTOMER = 'ALL'
              OR S.END_CUSTOMER IN (
                SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER, ','))
                 WHERE TOKEN IS NOT NULL
              )
             )
       ORDER BY 1
       FETCH FIRST 500 ROWS ONLY;
END P_DMF0072_GET_SALES_SITE_LIST;

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_TEAM_LIST 취합
PROCEDURE P_DMF0072_GET_TEAM_LIST (
    P_DIVISION_ID VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환
    --   - SCM_MST_SITE A (SITE_TYPE='SALES') ⋈ SCM_MST_SSO_DEPT_INFO B (DEPT_ID 매칭)
    --   - P_DIVISION_ID 'ALL' 또는 콤마 split IN 매칭
    --   - WITH(NOLOCK) 제거 (Oracle read consistency)
    --   - XML split → UF_FX_STRING_SPLIT (메인 SP P_DMF0072_GET_NNMASTER_MAPPING 과 일관)
    OPEN O_RC1 FOR
--      SELECT DISTINCT
----           B.DEPT_ID      AS CODE,
--             C.DEPT_ID      AS CODE,   /* 부서코드 : 아이템 원장 */                    -- 2026.09.06 AJS
--             B.DEPT_NAME_KO AS NAME
--        FROM SCM_MGR.SCM_MST_SITE          A,
--             SCM_MGR.SCM_MST_SITE_ITEM     C,   /* 아이템 원장 추가 */                 -- 2026.09.06 AJS
--             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
--       WHERE A.SITE_TYPE = 'SALES'
----       AND A.DEPT_ID   = B.DEPT_ID
--         AND A.DIVISION_ID = C.DIVISION_ID                                             -- 2026.09.06 AJS
--         AND A.SCM_SITE_ID = C.SCM_SITE_ID                                             -- 2026.09.06 AJS
--         AND C.DEPT_ID     = B.DEPT_ID                                                 -- 2026.09.06 AJS
--         AND (P_DIVISION_ID IS NULL
--              OR P_DIVISION_ID = 'ALL'
--              OR A.DIVISION_ID IN (
--                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
--                   WHERE TOKEN IS NOT NULL
--              )
--             )
--       ORDER BY 2;
    --*[2026-09-06] SSPM 적용 기준
      SELECT DISTINCT
             C.DEPT_ID      AS CODE,   /* 부서코드 : 아이템 원장 */                    -- 2026.09.06 AJS
             B.DEPT_NAME_KO AS NAME
             
        FROM SCM_MGR.SCM_MST_SITE_ITEM     C,   /* 아이템 원장 추가 */                 -- 2026.09.06 AJS
             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
       WHERE C.DEPT_ID     = B.DEPT_ID                                                 -- 2026.09.06 AJS
         AND C.VALID_YN    = 'Y'
         AND (P_DIVISION_ID IS NULL
              OR P_DIVISION_ID = 'ALL'
              OR C.DIVISION_ID IN (
                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
                   WHERE TOKEN IS NOT NULL
              )
             )
       ORDER BY 2;
END P_DMF0072_GET_TEAM_LIST;

END PKG_DMF0072;
/
