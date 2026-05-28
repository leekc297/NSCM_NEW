/*=============================================================================================
 * File         : 04_Package_PKG_DMF0002.sql
 * Description  : Package — PKG_DMF0002
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0002 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0002                                                                        */
/* Description : PKG_DMF0002                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.16  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0002_GET_ITEM_BY_DIVISION_POPUPEX (
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_MDMACTIVE_SW            IN VARCHAR2  --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선 (개발서버 및 운영배포시 NULL SETTING 제거)
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
);


PROCEDURE P_DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEX
(
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_ITEM_TYPE               IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0002_GET_TITLESET_POPUP (
   P_PROGRAM_ID              IN VARCHAR2
  ,P_SHEET_NAME              IN VARCHAR2
  ,P_COLUMN_TYPE             IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_DIVISION_ID             IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
);

END PKG_DMF0002;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0002 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0002                                                                        */
/* Description : PKG_DMF0002                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.16  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0002_GET_ITEM_BY_DIVISION_POPUPEX (
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_MDMACTIVE_SW            IN VARCHAR2  --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선 (개발서버 및 운영배포시 NULL SETTING 제거)
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
)
AS
/*=====================================================================================================================================================
 * PROGRAM ID  : DMF0002_GET_ITEM_BY_DIVISION_POPUPEX                                          
 * DESCRIPTION : PROCEDURE 작성 가이드                                                          
 * USAGE       : PROCEDURE 작성 시 참조하세요!                                                  
 * PARAMETER   : DMF0002_GET_ITEM_BY_DIVISION_POPUPEX_KCW '81', 'ALL', 'ALL', '', 'ALL', ''  , ''          
 *=====================================================================================================================================================
 * DATE        IN CHARGE    DESCRIPTION                                                        
 *=====================================================================================================================================================
 * 2017.10.24  SONGDH       INITIAL RELEASE [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.06.11  JYE       소형 관련 수정                                                      
 * 2018.12.05         NICK NAME 조회요청으로 변경                                                            
 * 2018.12.18  JYE          82 CURRENCY 수정                                                     
 * 2019.01.23  JYE          42, 44 추가                                                    
 * 2022.04.28  ROSIA27     과제PJ20216891R
 * 2023.11.30  HMIN         [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선 
 * 2024.04.04  KCW3408      DM 프로시저 속도개선 
 * 2024.08.14  KJJ       [PJ2024-50461] TEAM MAPPING
 * 2024.11.18  JSSBAE     [E20241118-000143]_ESS 사업부 SALES PRICE 입력 시 제외조건 일시조치 요청
 * 2025.03.12    PHILSU PARK 속도개선.(불필요 컬럼 제외, WITH 절 처리.)
   EXEC DMF0002_GET_ITEM_BY_DIVISION_POPUPEX @P_DIVISION_ID='81',@P_DEPT_ID='ALL',@P_END_CUSTOMER='ALL',@P_PROJECT_CODE='',@P_SCM_SITE_ID='ALL',@P_ITEM_ID='APBMW12V0-A1-D13',@P_MDMACTIVE_SW='Y'
 * 2026-03-12  SSLEE     [PJ20264226] NEXTSCM PILOT 설계 및 개발
 *===================================================================================================================================================*/


    
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

    OPEN O_CURSOR FOR
    WITH TEMP_DM_MST_ITEM_SINGLE_V AS (
        SELECT A.DIVISION_ID, A.ITEM_ID
              ,ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
              ,ACTIVE_FLAG 
          FROM (SELECT T1.DIVISION_ID          AS DIVISION_ID
                      ,T1.ITEM_ID              AS ITEM_ID
                      ,MAX(T1.ITEM_NAME)       AS ITEM_NAME         --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                      ,MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME   --해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                      ,MAX(T1.NICK_NAME)       AS NICK_NAME     --닉네임이 NULL인 경우가 있으므로 하나로 통일
                      ,CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1   --타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
                                     WHEN T1.ITEM_TYPE = 'H' THEN 2   --또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                                     WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                     ELSE 4 END )
                            WHEN 1 THEN 'P'
                            WHEN 2 THEN 'H'
                            WHEN 3 THEN 'Q'
                            ELSE 'R' END       AS ITEM_TYPE
                      ,MAX(T1.ACTIVE_FLAG)    AS ACTIVE_FLAG  -- 20180720 ADD 'Y'대상중 1건 추출
                  FROM SCM_MGR.SCM_MST_ITEM_SN T1 
                 WHERE T1.DIVISION_ID  = P_DIVISION_ID
                 GROUP BY T1.DIVISION_ID, T1.ITEM_ID
               ) A 
         WHERE A.DIVISION_ID = P_DIVISION_ID
    )
    ,TMP_81_UC_EXCEPTION AS (
         SELECT P_DIVISION_ID AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
           FROM (SELECT P_DIVISION_ID AS DIVISION_ID,  V.ITEM_ID,  V.ACTIVE_FLAG
                   FROM TEMP_DM_MST_ITEM_SINGLE_V V 
                  WHERE V.DIVISION_ID = '81'  --고정값사용 (81_UC의 경우 81번 값으로 대체 처리 , ACTIVE_FLAG 가 NULL인경우에 한함.)
                  GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
                ) V
                 INNER JOIN (SELECT S.DIVISION_ID, S.ITEM_ID
                               FROM SCM_MGR.SCM_MST_SITE_ITEM S 
                              WHERE S.DIVISION_ID = P_DIVISION_ID
                                AND S.ITEM_ID     IS NOT NULL
                              GROUP BY S.DIVISION_ID, S.ITEM_ID
                            ) S
                      ON S.DIVISION_ID   = V.DIVISION_ID 
                     AND S.ITEM_ID       = V.ITEM_ID
          WHERE 1=1
            AND P_DIVISION_ID  = '81_UC'  --PHILSU PARK: HAVING절 대체. 굳이 HAVING으로 할 필요가??
          GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
         -- HAVING CASE WHEN NVL(@P_DIVISION_ID,'')  = '81_UC' THEN @P_DIVISION_ID ELSE 'X' END = CASE WHEN NVL(@P_DIVISION_ID,'')  = '81_UC' THEN @P_DIVISION_ID ELSE 'XX' END
    )
     SELECT S.DIVISION_ID
           ,S.DIVISION_NAME
           ,S.PROJECT_CODE
           ,S.PROJECT_NAME
           ,S.SCM_SITE_ID
           ,S.SITE_DESCRIPTION
           ,S.ITEM_ID  
           ,S.ITEM_NAME
           ,S.ITEM_TYPE
           ,S.ITEM_TYPE_NAME
           ,S.NICK_NAME
           ,S.ITEM_CLASS_NAME
           ,S.DEPT_ID
           ,S.DEPT_NAME_KO
           ,S.END_CUSTOMER
           ,S.CURRENCY
           ,S.END_CUSTOMER40
           ,S.EDIT_YN
       FROM (
             /* 2024.04.04    KCW3408  DM 프로시저 속도개선 */
             SELECT I.DIVISION_ID
                   ,I.DIVISION_ID   AS DIVISION_NAME
                   ,D.PROJECT_CODE 
                   ,A.PROJECT_NAME 
                   ,S.SCM_SITE_ID 
                   ,S.SITE_DESCRIPTION
                   ,D.ITEM_ID   
                   ,T.ITEM_NAME 
                   ,T.ITEM_TYPE 
                   ,ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
                   ,T.NICK_NAME 
                   ,T.ITEM_CLASS_NAME
                   ,TEAM.DEPT_ID 
                   ,TEAM.DEPT_NAME_KO
                   ,S.END_CUSTOMER 
                   ,D.CURRENCY 
                   ,D.PROJECT_CODE  AS END_CUSTOMER40
                   ,EDY.EDIT_YN
               FROM SCM_MGR.SCM_MST_DIVISION I
                    INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                        ON EDY.UNIT_ID = I.DIVISION_ID
                    LEFT JOIN SCM_MST_SITE_ITEM D 
                         ON I.DIVISION_ID   = D.DIVISION_ID
                        AND D.VALID_YN      = 'Y'
                    LEFT JOIN SCM_MST_PROJECT A 
                         ON I.DIVISION_ID   = D.DIVISION_ID    
                        AND D.PROJECT_CODE  = A.PROJECT_CODE
                    LEFT JOIN SCM_MST_SITE S  
                         ON D.SCM_SITE_ID   = S.SCM_SITE_ID
                        AND S.VALID_YN      = 'Y'
                    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V T 
                         ON I.DIVISION_ID   = T.DIVISION_ID 
                        AND D.ITEM_ID       = T.ITEM_ID
                    LEFT JOIN (
                               SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
                                 FROM SCM_MGR.SCM_MST_SSO_USER_INFO B 
                                      INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C 
                                          ON B.DEPT_ID = C.DEPT_ID ) TEAM
                         ON TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(D.OWNER, ',')) WHERE ROWNUM = 1)
                    LEFT JOIN (
                               SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL  
                                WHERE VALID_YN ='Y' 
                                  AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                              ) ITEM_TYPE_CODE
                         ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
                    LEFT OUTER JOIN TMP_81_UC_EXCEPTION EX
                         ON EX.DIVISION_ID = D.DIVISION_ID
                        AND EX.ITEM_ID = D.ITEM_ID  --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선
              WHERE I.DIVISION_ID       = P_DIVISION_ID   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
                AND   I.DIVISION_ID    LIKE '81%'    
                AND   I.VALID_YN          = 'Y'   
                AND   S.SITE_TYPE         = 'SALES'
                AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                    ELSE TEAM.DEPT_ID
                     END IN (
                            SELECT  TOKEN
                            FROM    TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P 
                            WHERE   (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                            )
                AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                    ELSE NVL(S.END_CUSTOMER,'')
                     END IN (
                            SELECT  TOKEN
                            FROM    TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P 
                            WHERE   (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(S.END_CUSTOMER,'') END) = P.TOKEN
                            )          
                AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                    ELSE S.SCM_SITE_ID      
                     END IN (
                            SELECT  TOKEN
                            FROM    TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P 
                            WHERE   (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                            )
                AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE D.PROJECT_CODE LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE A.PROJECT_NAME LIKE P.TOKEN ||'%')
                    )
                AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE D.ITEM_ID LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN ||'%')
                    )  -- 20181205 NICK NAME 조회요청으로 변경
               --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선 
               AND CASE WHEN P_DIVISION_ID = '81_UC' THEN 
                             CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#' ELSE NVL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END
                        ELSE CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'  ELSE T.ACTIVE_FLAG END
                   END = CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'  ELSE 'Y' END
             UNION ALL
             SELECT I.DIVISION_ID
                   ,I.DIVISION_ID  AS DIVISION_NAME
                   ,D.PROJECT_CODE
                   ,A.PROJECT_NAME
                   ,S.SCM_SITE_ID
                   ,S.SITE_DESCRIPTION
                   ,T.ITEM_ID  
                   ,T.ITEM_NAME
                   ,T.ITEM_TYPE
                   ,ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
                   ,T.NICK_NAME
                   ,T.ITEM_CLASS_NAME
                   ,TEAM.DEPT_ID
                   ,TEAM.DEPT_NAME_KO
                   ,S.END_CUSTOMER
                   ,D.CURRENCY
                   ,D.PROJECT_CODE AS END_CUSTOMER40
                   ,EDY.EDIT_YN
               FROM SCM_MGR.SCM_MST_DIVISION I  
                    INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                        ON EDY.UNIT_ID = I.DIVISION_ID
                    LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM D   
                        ON  I.DIVISION_ID   = D.DIVISION_ID
                        AND D.VALID_YN      = 'Y'
                    LEFT JOIN SCM_MGR.SCM_MST_PROJECT A 
                        ON  I.DIVISION_ID   = D.DIVISION_ID    
                        AND D.PROJECT_CODE  = A.PROJECT_CODE
                    LEFT JOIN SCM_MGR.SCM_MST_SITE S  
                        ON  I.DIVISION_ID   = D.DIVISION_ID    
                        AND D.SCM_SITE_ID   = S.SCM_SITE_ID   
                        AND S.VALID_YN      = 'Y' 
                    LEFT OUTER JOIN TEMP_DM_MST_ITEM_SINGLE_V  T 
                        ON  I.DIVISION_ID       = T.DIVISION_ID 
                        AND D.ITEM_ID           = T.ITEM_ID 
                        --E20241118-000143_ESS 사업부 SALES PRICE 입력 시 제외조건 일시조치 요청 START
                        --AND T.ITEM_TYPE NOT IN ( 'H', 'R')  
                        --AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외 
                        --E20241118-000143_ESS 사업부 SALES PRICE 입력 시 제외조건 일시조치 요청 END
                    LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
                                 FROM SCM_MGR.SCM_MST_SSO_USER_INFO B 
                                      INNER JOIN SCM_MST_SSO_DEPT_INFO C 
                                          ON B.DEPT_ID = C.DEPT_ID
                              ) TEAM
                        ON  TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(D.OWNER, ',')) WHERE ROWNUM = 1)
                    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL  
                                WHERE LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                                  AND VALID_YN    = 'Y' 
                                ) ITEM_TYPE_CODE
                        ON T.ITEM_TYPE  = ITEM_TYPE_CODE.CODE
              WHERE I.DIVISION_ID   = P_DIVISION_ID   
                AND I.DIVISION_ID   = '82'
                AND I.VALID_YN      = 'Y'
                AND S.SITE_TYPE     = 'SALES'
                AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                         ELSE TEAM.DEPT_ID      
                    END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P WHERE 
                            (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                            )
                AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                         ELSE NVL(S.END_CUSTOMER,'')      
                    END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P WHERE 
                            (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(S.END_CUSTOMER,'') END) = P.TOKEN
                            )
                AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                         ELSE S.SCM_SITE_ID     
                    END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P WHERE 
                            (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                            )
                AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE D.PROJECT_CODE LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE A.PROJECT_NAME LIKE P.TOKEN ||'%')
                    )
                AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.ITEM_ID LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN ||'%')
                    )  -- 20181205 NICK NAME 조회요청으로 변경
               --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선
                AND CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'
                         ELSE T.ACTIVE_FLAG
                    END = CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'  ELSE 'Y' END --20231127 
             UNION ALL-- 20180611 소형 추가, 42, 44
             SELECT I.DIVISION_ID
                   ,I.DIVISION_ID  AS DIVISION_NAME
                   ,D.PROJECT_CODE
                   ,'' AS PROJECT_NAME
                   ,S.SCM_SITE_ID
                   ,S.SITE_DESCRIPTION
                   ,D.ITEM_ID  
                   ,T.ITEM_NAME
                   ,T.ITEM_TYPE
                   ,ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
                   ,T.NICK_NAME
                   ,T.ITEM_CLASS_NAME
                   ,TEAM.DEPT_ID
                   ,TEAM.DEPT_NAME_KO
                   ,S.END_CUSTOMER
                   ,D.CURRENCY
                   ,D.PROJECT_CODE AS END_CUSTOMER40
                   ,EDY.EDIT_YN
               FROM SCM_MGR.SCM_MST_DIVISION I  
                    INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                        ON EDY.UNIT_ID = I.DIVISION_ID
                    LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM D  
                        ON  I.DIVISION_ID   = D.DIVISION_ID 
                        AND D.VALID_YN      = 'Y'
                    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO USER_INFO              
                        ON  D.OWNER = USER_INFO.USER_ID 
                    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM               
                        ON  USER_INFO.DEPT_ID   = TEAM.DEPT_ID 
                        AND TEAM.VALID_YN       = 'Y' 
                    LEFT JOIN SCM_MGR.SCM_MST_SITE S  
                        ON  I.DIVISION_ID   = D.DIVISION_ID    
                        AND D.SCM_SITE_ID   = S.SCM_SITE_ID   
                        AND S.VALID_YN      ='Y' 
                    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V     T 
                        ON  I.DIVISION_ID   = T.DIVISION_ID 
                        AND D.ITEM_ID       = T.ITEM_ID
                    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL  
                                WHERE LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                                  AND VALID_YN    = 'Y' 
                              )  ITEM_TYPE_CODE
                        ON  T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
                    LEFT OUTER JOIN TMP_81_UC_EXCEPTION EX
                        ON  EX.DIVISION_ID = D.DIVISION_ID
                        AND EX.ITEM_ID = D.ITEM_ID --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선
              WHERE I.DIVISION_ID       = P_DIVISION_ID   -- 20190123  
                AND I.DIVISION_ID    LIKE '4%'    
                AND I.VALID_YN          = 'Y'   
                AND S.SITE_TYPE         = 'SALES'
                AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                         ELSE TEAM.DEPT_ID      
                    END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P
                             WHERE (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                           )
                AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                         ELSE NVL(CASE WHEN P_DIVISION_ID <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END,'@#@#@#')
                    END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P
                             WHERE (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                                         ELSE NVL(CASE WHEN P_DIVISION_ID <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END,'@#@#@#') END) = P.TOKEN
                           )
                AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                         ELSE S.SCM_SITE_ID     
                    END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P
                             WHERE (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                           )
                AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE D.ITEM_ID LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN ||'%')
                    )  -- 20181205 NICK NAME 조회요청으로 변경
                --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선
                --AND CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' THEN ''  ELSE T.ACTIVE_FLAG END = CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' THEN ''  ELSE 'Y' END --20231127 
                AND CASE WHEN P_DIVISION_ID = '81_UC' THEN 
                              CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'  ELSE NVL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END
                         ELSE CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'  ELSE T.ACTIVE_FLAG END     
                    END = CASE WHEN NVL(P_MDMACTIVE_SW, '') = '' OR P_MDMACTIVE_SW IS NULL THEN '@#@#@#'  ELSE 'Y' END
        ) S
      GROUP BY S.DIVISION_ID
              ,S.DIVISION_NAME
              ,S.PROJECT_CODE
              ,S.PROJECT_NAME
              ,S.SCM_SITE_ID
              ,S.SITE_DESCRIPTION
              ,S.ITEM_ID   
              ,S.ITEM_NAME
              ,S.ITEM_TYPE
              ,S.ITEM_TYPE_NAME
              ,S.NICK_NAME
              ,S.ITEM_CLASS_NAME
              ,S.DEPT_ID
              ,S.DEPT_NAME_KO
              ,S.END_CUSTOMER
              ,S.CURRENCY
              ,S.END_CUSTOMER40
              ,S.EDIT_YN
      ORDER BY S.DIVISION_ID
              ,S.PROJECT_CODE
              --, A.PROJECT_NAME
              ,S.SCM_SITE_ID
              ,S.SITE_DESCRIPTION
              ,S.ITEM_ID
              ,S.ITEM_NAME
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
            ,'P_PROJECT_CODE'            VALUE P_PROJECT_CODE
            ,'P_SCM_SITE_ID'             VALUE P_SCM_SITE_ID
            ,'P_ITEM_ID'                 VALUE P_ITEM_ID
            ,'P_MDMACTIVE_SW'            VALUE P_MDMACTIVE_SW
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
        RAISE;

END P_DMF0002_GET_ITEM_BY_DIVISION_POPUPEX;

PROCEDURE P_DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEX
(
   P_DIVISION_ID             IN VARCHAR2
  ,P_DEPT_ID                 IN VARCHAR2  --DEPARTMENT
  ,P_END_CUSTOMER            IN VARCHAR2  --ENDCUSTOMER
  ,P_PROJECT_CODE            IN VARCHAR2
  ,P_SCM_SITE_ID             IN VARCHAR2
  ,P_ITEM_ID                 IN VARCHAR2
  ,P_ITEM_TYPE               IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_ITEM_BY_DIVISION_POP                                                    */
/* Description : Procedure 작성 가이드                                                                */
/* Usage       : Procedure 작성 시 참조하세요!                                                         */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      */
/* 2018/12/05  nick name    조회요청으로 수정                                                          */
/* 2024/08/29	 KJJ		    	[PJ2024-50461] Team Mapping                                             */
/*                                                                                                  */
/****************************************************************************************************/

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

    /*
  SELECT I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID
   , T.ITEM_NAME
   , T.ITEM_TYPE
   , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
   , T.NICK_NAME
   , T.ITEM_CLASS_NAME
   , TEAM.DEPT_ID
   , TEAM.DEPT_NAME_KO
   , C.END_CUSTOMER
   , D.CURRENCY

  FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
       LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
     ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
     ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
     ON D.SCM_SITE_ID  = S.SCM_SITE_ID
     --LEFT JOIN SCM_MST_ITEM_SN     T
     LEFT JOIN DM_MST_ITEM_SINGLE_V     T
     ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
     LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
     ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
     LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
     ON C.DEPT_ID = TEAM.DEPT_ID
     LEFT JOIN (
          SELECT  LOOKUP_CODE AS CODE, DESCRIPTION AS NAME
          FROM SCM_ADM_LOOKUP_VALUES
          WHERE;
          VALID_YN ='Y'
          AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
     )  AS ITEM_TYPE_CODE
     ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE


WHERE;
        CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL'
           ELSE I.DIVISION_ID
      END IN (
          SELECT * FROM UF_FX_STRING_SPLITFORIN (P_DIVISION_ID,',') AS P WHERE
          (CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.DATA
                 )
    AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
           ELSE TEAM.DEPT_ID
      END IN (
          SELECT * FROM UF_FX_STRING_SPLITFORIN (P_DEPT_ID,',') AS P WHERE
          (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.DATA
                 )
    AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
           ELSE NVL(C.END_CUSTOMER, NULL)
      END IN (
          SELECT * FROM UF_FX_STRING_SPLITFORIN (P_END_CUSTOMER,',') AS P WHERE
          (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.DATA
                 )

    AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
           ELSE S.SCM_SITE_ID
      END IN (
          SELECT * FROM UF_FX_STRING_SPLITFORIN (P_SCM_SITE_ID,',') AS P WHERE
          (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.DATA
                 )
    --AND CASE WHEN P_PROJECT_CODE IS NULL THEN ''
    --       ELSE A.PROJECT_CODE
    --  END IN (
    --      SELECT * FROM UF_FX_STRING_SPLITFORIN (P_PROJECT_CODE,',') AS P WHERE
    --      (CASE WHEN P_PROJECT_CODE IS NULL THEN '' ELSE A.PROJECT_CODE END) = P.DATA
   --              )
    --AND CASE WHEN P_PROJECT_CODE IS NULL THEN ''
    --       ELSE A.PROJECT_NAME
    --  END IN (
    --      SELECT * FROM UF_FX_STRING_SPLITFORIN (P_PROJECT_CODE,',') AS P WHERE
    --      (CASE WHEN P_PROJECT_CODE IS NULL THEN '' ELSE A.PROJECT_NAME END) = P.DATA
   --              )

    --AND CASE WHEN P_ITEM_ID IS NULL THEN ''
    --       ELSE D.ITEM_ID
    --  END IN (
    --      SELECT * FROM UF_FX_STRING_SPLITFORIN (P_ITEM_ID,',') AS P WHERE
    --      (CASE WHEN P_ITEM_ID IS NULL THEN '' ELSE D.ITEM_ID END) = P.DATA
   --              )
    --AND CASE WHEN P_ITEM_ID IS NULL THEN ''
    --       ELSE T.ITEM_NAME
    --  END IN (
    --      SELECT * FROM UF_FX_STRING_SPLITFORIN (P_ITEM_ID,',') AS P WHERE
    --      (CASE WHEN P_ITEM_ID IS NULL THEN '' ELSE T.ITEM_NAME END) = P.DATA
   --              )
   AND (;
     EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) AS P WHERE A.PROJECT_CODE LIKE P.TOKEN +'%')
       OR
     EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) AS P WHERE A.PROJECT_NAME LIKE P.TOKEN +'%')
     )
   AND (;
     EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE D.ITEM_ID LIKE P.TOKEN +'%')
       OR
     EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE T.ITEM_NAME LIKE P.TOKEN +'%')
     )
   --AND    (   A.PROJECT_CODE LIKE '%'+ P_PROJECT_CODE + '%'
    --  OR A.PROJECT_NAME LIKE '%'+ P_PROJECT_CODE + '%'
    -- )

  --   AND    (   D.ITEM_ID   LIKE '%' + P_ITEM_ID + '%'
  --        OR T.ITEM_NAME LIKE '%' + P_ITEM_ID + '%' )


  GROUP BY;
    I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID
   , T.ITEM_NAME
   , T.ITEM_TYPE
   , ITEM_TYPE_CODE.NAME
   , T.NICK_NAME
   , T.ITEM_CLASS_NAME
   , TEAM.DEPT_ID
   , TEAM.DEPT_NAME_KO
   , C.END_CUSTOMER
   , D.CURRENCY

  ORDER BY I.DIVISION_ID
         , D.PROJECT_CODE
         , A.PROJECT_NAME
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , D.ITEM_ID
       , T.ITEM_NAME
*/

    IF NVL(P_DIVISION_ID,'@#@#@#') <> '40' THEN
        OPEN O_CURSOR FOR
        SELECT DIVISION_ID
              ,DIVISION_NAME
              ,PROJECT_CODE
              ,PROJECT_NAME
              ,SCM_SITE_ID
              ,SITE_DESCRIPTION
              ,ITEM_ID
              ,ITEM_NAME
              ,ITEM_TYPE
              ,ITEM_TYPE_NAME
              ,NICK_NAME
              ,ITEM_CLASS_NAME
              ,DEPT_ID
              ,DEPT_NAME_KO
              ,END_CUSTOMER
              ,CURRENCY
              ,EDIT_YN
          FROM (SELECT I.DIVISION_ID
                      ,I.DIVISION_ID  AS DIVISION_NAME
                      ,D.PROJECT_CODE
                      ,A.PROJECT_NAME
                      ,S.SCM_SITE_ID
                      ,S.SITE_DESCRIPTION
                      ,D.ITEM_ID
                      ,T.ITEM_NAME
                      ,T.ITEM_TYPE
                      ,ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
                      ,T.NICK_NAME
                      ,T.ITEM_CLASS_NAME
                      ,TEAM.DEPT_ID
                      ,TEAM.DEPT_NAME_KO
                      ,C.END_CUSTOMER
                      ,D.CURRENCY
                      ,EDY.EDIT_YN
                  FROM (SELECT * 
                          FROM SCM_MGR.SCM_MST_DIVISION
                         WHERE VALID_YN = 'Y') I
                       INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                           ON EDY.UNIT_ID = I.DIVISION_ID
                       LEFT JOIN (SELECT (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(DD.OWNER, ',')) WHERE ROWNUM = 1) AS USER_ID
                                        ,DD.*
                                    FROM SCM_MGR.SCM_MST_SITE_ITEM DD
                                   WHERE VALID_YN = 'Y') D
                           ON I.DIVISION_ID  = D.DIVISION_ID
                       LEFT JOIN (SELECT * 
                                    FROM SCM_MGR.SCM_MST_PROJECT ) A
                           ON D.PROJECT_CODE = A.PROJECT_CODE
                       LEFT JOIN (SELECT * 
                                    FROM SCM_MGR.SCM_MST_SITE
                                   WHERE VALID_YN = 'Y') S
                           ON D.SCM_SITE_ID  = S.SCM_SITE_ID
                       --LEFT JOIN SCM_MST_ITEM_SN     T
                       LEFT JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V T
                            ON I.DIVISION_ID  = T.DIVISION_ID
                           AND D.ITEM_ID      = T.ITEM_ID
                       LEFT JOIN (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID, A.END_CUSTOMER, B.PROJECT_CODE, B.ITEM_ID
                                    FROM SCM_MGR.SCM_MST_SITE A
                                         LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                                              ON A.DIVISION_ID = B.DIVISION_ID 
                                             AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                                   WHERE A.VALID_YN = 'Y'
                                   GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID, A.END_CUSTOMER, B.PROJECT_CODE, B.ITEM_ID
                                  ) C
                            ON I.DIVISION_ID  = C.DIVISION_ID
                           AND D.SCM_SITE_ID  = C.SCM_SITE_ID
                           AND D.PROJECT_CODE = C.PROJECT_CODE
                           AND D.ITEM_ID      = C.ITEM_ID
                       --[PJ2024-50461] TEAM MAPPING------------------------------------
                       --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
                       --ON C.DEPT_ID = TEAM.DEPT_ID
                       LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                                    FROM SCM_MGR.SCM_MST_SSO_USER_INFO B
                                         INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                                             ON B.DEPT_ID = C.DEPT_ID
                                 ) TEAM
                            --ON TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(D.OWNER, ',')) WHERE ROWNUM = 1) --TUNNIN
                            ON TEAM.USER_ID = D.USER_ID
                   --[PJ2024-50461] TEAM MAPPING------------------------------------
                   LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE VALID_YN = 'Y'
                                 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                             ) ITEM_TYPE_CODE
                       ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
                 WHERE I.DIVISION_ID = '81'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
                   AND SITE_TYPE = 'SALES'
                   AND CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL'
                            ELSE I.DIVISION_ID
                       END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID,',')) P
                                WHERE (CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.TOKEN
                              )
                   AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                            ELSE TEAM.DEPT_ID
                       END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P
                                WHERE (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                              )
                   AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                            ELSE NVL(C.END_CUSTOMER, '@#@#@#')
                       END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P
                                WHERE (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, '@#@#@#') END) = P.TOKEN
                              )
                   AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                            ELSE S.SCM_SITE_ID
                       END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P
                                WHERE (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                               )
                   AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE D.PROJECT_CODE LIKE P.TOKEN  || '%')
                        OR
                        EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE A.PROJECT_NAME LIKE P.TOKEN  || '%')
                       )
                   AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE D.ITEM_ID LIKE P.TOKEN  || '%')
                        --OR
                        --EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE T.ITEM_NAME LIKE P.TOKEN +'%')
                        OR
                        EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN  || '%')
                       )   --20181205 NICK NAME 조회요청으로 수정
                 GROUP BY I.DIVISION_ID
                         ,D.PROJECT_CODE
                         ,A.PROJECT_NAME
                         ,S.SCM_SITE_ID
                         ,S.SITE_DESCRIPTION
                         ,D.ITEM_ID
                         ,T.ITEM_NAME
                         ,T.ITEM_TYPE
                         ,ITEM_TYPE_CODE.NAME
                         ,T.NICK_NAME
                         ,T.ITEM_CLASS_NAME
                         ,TEAM.DEPT_ID
                         ,TEAM.DEPT_NAME_KO
                         ,C.END_CUSTOMER
                         ,D.CURRENCY
                         ,EDY.EDIT_YN
                 UNION ALL
                 SELECT I.DIVISION_ID
                       ,I.DIVISION_ID  AS DIVISION_NAME
                       ,D.PROJECT_CODE
                       ,A.PROJECT_NAME
                       ,S.SCM_SITE_ID
                       ,S.SITE_DESCRIPTION
                       ,T.ITEM_ID
                       ,T.ITEM_NAME
                       ,T.ITEM_TYPE
                       ,ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
                       ,T.NICK_NAME
                       ,T.ITEM_CLASS_NAME
                       ,TEAM.DEPT_ID
                       ,TEAM.DEPT_NAME_KO
                       ,C.END_CUSTOMER
                       ,A.CURRENCY
                       ,EDY.EDIT_YN
                   FROM (SELECT * 
                           FROM SCM_MGR.SCM_MST_DIVISION
                          WHERE VALID_YN = 'Y') I
                       INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                           ON EDY.UNIT_ID = I.DIVISION_ID
                        --[PJ2024-50461] TEAM MAPPING------------------------------------
                        --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
                        LEFT JOIN (SELECT (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(OWNER, ',')) WHERE ROWNUM = 1) AS USER_ID
                                         ,DIVISION_ID, SCM_SITE_ID, PROJECT_CODE,OWNER
                                     FROM (SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE,OWNER
                                             FROM SCM_MGR.SCM_MST_SITE_ITEM
                                            WHERE VALID_YN = 'Y'
                                            GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE,OWNER) DD
                                  ) D
                        --[PJ2024-50461] TEAM MAPPING------------------------------------
                            ON I.DIVISION_ID  = D.DIVISION_ID
                        LEFT OUTER JOIN (SELECT * 
                                           FROM SCM_MGR.SCM_MST_PROJECT ) A
                             ON D.PROJECT_CODE = A.PROJECT_CODE
                        LEFT JOIN (SELECT * 
                                     FROM SCM_MGR.SCM_MST_SITE
                                    WHERE VALID_YN = 'Y') S
                             ON D.SCM_SITE_ID  = S.SCM_SITE_ID
                        LEFT OUTER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V T
                             ON I.DIVISION_ID  = T.DIVISION_ID
                            AND T.ITEM_TYPE NOT IN ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
                        LEFT JOIN (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID, A.END_CUSTOMER, B.PROJECT_CODE, B.ITEM_ID
                                    FROM SCM_MGR.SCM_MST_SITE A
                                         LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                                              ON A.DIVISION_ID = B.DIVISION_ID 
                                             AND A.SCM_SITE_ID = B.SCM_SITE_ID 
                                   WHERE A.VALID_YN = 'Y'
                                   GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, B.DEPT_ID, A.END_CUSTOMER, B.PROJECT_CODE, B.ITEM_ID) C
                             ON I.DIVISION_ID  = C.DIVISION_ID
                            AND D.SCM_SITE_ID  = C.SCM_SITE_ID
                            AND D.PROJECT_CODE = C.PROJECT_CODE
                            AND T.ITEM_ID      = C.ITEM_ID
                        --[PJ2024-50461] TEAM MAPPING------------------------------------
                        --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
                        --ON C.DEPT_ID = TEAM.DEPT_ID
                        LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                                     FROM SCM_MGR.SCM_MST_SSO_USER_INFO B
                                          INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                                              ON B.DEPT_ID = C.DEPT_ID
                                  ) TEAM
                            --ON TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(D.OWNER, ',')) WHERE ROWNUM = 1) --TUNNING
                            ON TEAM.USER_ID = D.USER_ID
                        --[PJ2024-50461] TEAM MAPPING------------------------------------
                        LEFT JOIN (SELECT SEGMENT1 AS CODE
                                         ,SEGMENT2 AS NAME
                                     FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE VALID_YN    = 'Y'
                                      AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                                  ) ITEM_TYPE_CODE
                            ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
                  WHERE I.DIVISION_ID = '82'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
                    AND SITE_TYPE = 'SALES'
                    --AND D.PROJECT_CODE = 'DC-17-001'
                    AND CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL'
                             ELSE I.DIVISION_ID
                        END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID,',')) P
                                 WHERE (CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.TOKEN
                               )
                    AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                             ELSE TEAM.DEPT_ID
                        END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID,',')) P
                                 WHERE (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                               )
                    AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                             ELSE NVL(C.END_CUSTOMER, '@#@#@#')
                        END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,',')) P
                                 WHERE (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, '@#@#@#') END) = P.TOKEN
                                )
                    AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                             ELSE S.SCM_SITE_ID
                        END IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,',')) P
                                 WHERE (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                               )
                    AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE D.PROJECT_CODE LIKE P.TOKEN  || '%')
                         OR
                         EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE A.PROJECT_NAME LIKE P.TOKEN  || '%')
                        )
                    AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.ITEM_ID LIKE P.TOKEN  || '%')
                         --OR
                         --EXISTS (SELECT * FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE T.ITEM_NAME LIKE P.TOKEN +'%')
                         OR
                         EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN  || '%')
                        )   --20181205 NICK NAME 조회요청으로 수정
                 GROUP BY I.DIVISION_ID
                         ,D.PROJECT_CODE
                         ,A.PROJECT_NAME
                         ,S.SCM_SITE_ID
                         ,S.SITE_DESCRIPTION
                         ,T.ITEM_ID
                         ,T.ITEM_NAME
                         ,T.ITEM_TYPE
                         ,ITEM_TYPE_CODE.NAME
                         ,T.NICK_NAME
                         ,T.ITEM_CLASS_NAME
                         ,TEAM.DEPT_ID
                         ,TEAM.DEPT_NAME_KO
                         ,C.END_CUSTOMER
                         ,A.CURRENCY
                         ,EDY.EDIT_YN
               )
         GROUP BY DIVISION_ID
                 ,DIVISION_NAME
                 ,PROJECT_CODE
                 ,PROJECT_NAME
                 ,SCM_SITE_ID
                 ,SITE_DESCRIPTION
                 ,ITEM_ID
                 ,ITEM_NAME
                 ,ITEM_TYPE
                 ,ITEM_TYPE_NAME
                 ,NICK_NAME
                 ,ITEM_CLASS_NAME
                 ,DEPT_ID
                 ,DEPT_NAME_KO
                 ,END_CUSTOMER
                 ,CURRENCY
                 ,EDIT_YN
         ORDER BY DIVISION_ID
                 ,PROJECT_CODE
                 ,PROJECT_NAME
                 ,SCM_SITE_ID
                 ,SITE_DESCRIPTION
                 ,ITEM_ID
                 ,ITEM_NAME
        ;

    ELSE  --40

        --DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
        OPEN O_CURSOR FOR
        SELECT T.DIVISION_ID
              ,T.DIVISION_ID  AS DIVISION_NAME
              ,''             AS PROJECT_CODE
              ,''             AS PROJECT_NAME
              ,''             AS SCM_SITE_ID
              ,''             AS SITE_DESCRIPTION
              ,T.ITEM_ID
              ,T.ITEM_NAME
              ,T.ITEM_TYPE
              ,ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
              ,T.NICK_NAME
              ,T.ITEM_CLASS_NAME  --MODEL TYPE
              ,''             AS DEPT_ID
              ,''             AS DEPT_NAME_KO
              ,''             AS END_CUSTOMER
              ,''             AS CURRENCY
              ,EDY.EDIT_YN
        FROM SCM_MGR.DM_MST_ITEM_SINGLE_V T
             INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                 ON EDY.UNIT_ID = T.DIVISION_ID
             LEFT JOIN (SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                         WHERE VALID_YN    = 'Y'
                           AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                       ) ITEM_TYPE_CODE
                 ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
       WHERE T.DIVISION_ID = '40'
         AND (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.ITEM_ID LIKE P.TOKEN  || '%')
              --OR
              --EXISTS (SELECT * FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE T.ITEM_NAME LIKE P.TOKEN +'%')
              OR
              EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN  || '%')
             )   --20181205 NICK NAME 조회요청으로 수정
        AND T.ITEM_TYPE IN (SELECT TOKEN 
                              FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_TYPE,',')) P
                             WHERE (CASE WHEN P_ITEM_TYPE IS NULL THEN '' ELSE T.ITEM_TYPE END) = P.TOKEN)
        ORDER BY T.ITEM_ID
        ;
              
    END IF;


    /*
    SELECT DISTINCT TOP 1000 I.DIVISION_ID
     , I.DIVISION_ID  AS DIVISION_NAME
     , '' AS PROJECT_CODE
     , '' AS PROJECT_NAME
     , '' AS SCM_SITE_ID
     , '' AS SITE_DESCRIPTION
     , T.ITEM_ID
     , T.ITEM_NAME
     , T.ITEM_TYPE
     , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
     , T.NICK_NAME
     , T.ITEM_CLASS_NAME  --MODEL TYPE
     , '' AS DEPT_ID
     , '' AS DEPT_NAME_KO
     , '' AS END_CUSTOMER
     , '' AS CURRENCY

    FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
       LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
    ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT OUTER JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
    ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
    ON D.SCM_SITE_ID  = S.SCM_SITE_ID

    LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V     T

    ON I.DIVISION_ID  = T.DIVISION_ID ------AND T.ITEM_TYPE NOT IN ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
    LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
    ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
    LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
    ON C.DEPT_ID = TEAM.DEPT_ID
    LEFT JOIN (
     SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE;
     VALID_YN ='Y'
     AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
    )  AS ITEM_TYPE_CODE
    ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

  WHERE I.DIVISION_ID = '40'  -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
   AND   SITE_TYPE = 'SALES'
    AND   CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL'
             ELSE I.DIVISION_ID
        END IN (
            SELECT * FROM UF_FX_STRING_SPLITFORIN (P_DIVISION_ID,',') AS P WHERE
            (CASE WHEN P_DIVISION_ID = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.DATA
             )
      AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
             ELSE TEAM.DEPT_ID
        END IN (
            SELECT * FROM UF_FX_STRING_SPLITFORIN (P_DEPT_ID,',') AS P WHERE
            (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.DATA
             )
      --AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
      --       ELSE NVL(C.END_CUSTOMER, NULL)
      --  END IN (
      --      SELECT * FROM UF_FX_STRING_SPLITFORIN (P_END_CUSTOMER,',') AS P WHERE
      --      (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.DATA
     --              )
        AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
             ELSE NVL(
            CASE WHEN P_DIVISION_ID <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
           , NULL)
        END IN (
            SELECT * FROM UF_FX_STRING_SPLITFORIN (P_END_CUSTOMER,',') AS P WHERE
            (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(
              CASE WHEN P_DIVISION_ID <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
            , NULL) END) = P.DATA
      )
      AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
             ELSE S.SCM_SITE_ID
        END IN (
            SELECT * FROM UF_FX_STRING_SPLITFORIN (P_SCM_SITE_ID,',') AS P WHERE
            (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.DATA
             )
  --***
     ----AND (
      ---- EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) AS P WHERE D.PROJECT_CODE LIKE P.TOKEN +'%')
     ----    OR
      ---- EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) AS P WHERE A.PROJECT_NAME LIKE P.TOKEN +'%')
      ---- )
  --***
     ------AND (
      ------ EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE T.ITEM_ID LIKE P.TOKEN +'%')
     ------    OR
      ------ EXISTS (SELECT * FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID,',')) AS P WHERE T.ITEM_NAME LIKE P.TOKEN +'%')
      ------ )

        AND CASE WHEN P_ITEM_ID IS NULL THEN ''
             ELSE T.ITEM_ID
        END IN (
            SELECT * FROM UF_FX_STRING_SPLITFORIN (P_ITEM_ID,',') AS P WHERE
            (CASE WHEN P_ITEM_ID IS NULL THEN '' ELSE T.ITEM_ID END) = P.DATA
             )
        AND CASE WHEN P_ITEM_TYPE IS NULL THEN ''
             ELSE T.ITEM_TYPE
        END IN (
            SELECT * FROM UF_FX_STRING_SPLITFORIN (P_ITEM_TYPE,',') AS P WHERE
            (CASE WHEN P_ITEM_TYPE IS NULL THEN '' ELSE T.ITEM_TYPE END) = P.DATA
             )

    ----AND (T.ITEM_TYPE  = 'H' OR T.ITEM_TYPE  = 'P' OR T.ITEM_TYPE  = 'R' OR T.ITEM_TYPE  = 'Q')  --*****
    ORDER BY I.DIVISION_ID
       --, D.PROJECT_CODE
       --, A.PROJECT_NAME
       --, S.SCM_SITE_ID
       --, S.SITE_DESCRIPTION
       , T.ITEM_ID
       , T.ITEM_NAME
   --DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
   */


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
            ,'P_PROJECT_CODE'            VALUE P_PROJECT_CODE
            ,'P_SCM_SITE_ID'             VALUE P_SCM_SITE_ID
            ,'P_ITEM_ID'                 VALUE P_ITEM_ID
            ,'P_ITEM_TYPE'               VALUE P_ITEM_TYPE
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
        RAISE;

END P_DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEX;

PROCEDURE P_DMF0002_GET_TITLESET_POPUP(
   P_PROGRAM_ID              IN VARCHAR2
  ,P_SHEET_NAME              IN VARCHAR2
  ,P_COLUMN_TYPE             IN VARCHAR2
  ,P_USER_ID                 IN VARCHAR2
  ,P_DIVISION_ID             IN VARCHAR2
  ,P_MENU_ID                 IN VARCHAR2
  
  ,O_CURSOR                  OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR           OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : SCM0002_GET_TITLESET_POPUP                                                         */
/* Description : Column Setting, Measure Setting                                                    */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017.11.21  정병훈        Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      */
/* 2018.05.31	 JYE	        DIVISION_ID 별로 칼럼 해더 리턴                                            */
/*                                                                                                  */
/****************************************************************************************************/
    
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
    -- EXEC DBO.SCM0002_SET_DEFAULT_TITLESET_POPUP @P_PROGRAM_ID , @P_SHEET_NAME, @P_COLUMN_TYPE, @P_USER_ID
    SCM_MGR.SCM0002_SET_DEFAULT_TITLESET_POPUP(P_PROGRAM_ID, P_SHEET_NAME, P_COLUMN_TYPE, P_USER_ID);

    IF (P_DIVISION_ID = '' OR P_DIVISION_ID IS NULL) -- 20180604 소형. 분기 추가
    THEN
        IF P_COLUMN_TYPE = 'C' -- COLUMN
        THEN
            OPEN O_CURSOR FOR
            SELECT B.PROGRAM_ID
                  ,B.SHEET_NAME
                  ,B.COLUMN_NAME
                  ,B.COLUMN_LABEL_NAME
                  ,B.SMALL_CLASS_LABEL_NAME
                  ,B.LARGE_CLASS_LABEL_NAME
                  ,B.DATA_SORT_METHOD_CODE
                  ,B.COLUMN_WIDTH
                  ,B.SORT_ORDER_NO
                  ,U.SUB_TOTAL_FLAG
                  ,FN_SCM_SYS_NVL(FN_SCM_SYS_NVL(U.DATA_SORT_METHOD_CODE, B.DATA_SORT_METHOD_CODE), 'ASC') AS USER_SORT_METHOD_CODE
                  ,U.SORT_ORDER_NO AS USER_SORT_ORDER_NO
                  ,(CASE WHEN NVL(U.COLUMN_NAME,'@@') = '@@' THEN ''
                         ELSE 'Y'
                    END) AS USER_FLAG
                  ,FN_SCM_SYS_NVL(B.DEFAULT_FLAG, '') AS DEFAULT_FLAG
                  ,FN_SCM_SYS_NVL(B.USER_SELECTABLE_FLAG, 'Y') AS USER_SELECTABLE_FLAG
                  ,'' AS TOTAL_USE_FLAG
                  ,EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS B  
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = B.DIVISION_ID
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                        ON U.PROGRAM_ID  = B.PROGRAM_ID
                       AND U.SHEET_NAME  = B.SHEET_NAME
                       AND U.COLUMN_NAME = B.COLUMN_NAME
                       AND U.USER_ID     = P_USER_ID
             WHERE B.PROGRAM_ID   = P_PROGRAM_ID
               AND B.SHEET_NAME   = P_SHEET_NAME
               AND B.VALID_YN     = 'Y'
               AND B.VISIBLE_FLAG = 'Y'
             ORDER BY B.SORT_ORDER_NO;
        ELSE -- MEASURE
            OPEN O_CURSOR FOR
            SELECT B.PROGRAM_ID
                  ,B.SHEET_NAME
                  ,B.COLUMN_NAME
                  ,B.COLUMN_LABEL_NAME
                  ,B.SMALL_CLASS_LABEL_NAME
                  ,B.LARGE_CLASS_LABEL_NAME
                  ,U.DATA_SORT_METHOD_CODE
                  ,B.SORT_ORDER_NO
                  ,NULL AS SUB_TOTAL_FLAG
                  ,NULL AS USER_SORT_METHOD_CODE
                  ,U.SORT_ORDER_NO AS USER_SORT_ORDER_NO
                  ,B.USER_SELECTABLE_FLAG
                  ,(CASE WHEN NVL(U.COLUMN_NAME,'@@') = '@@' THEN ''
                         ELSE 'Y'
                    END) AS USER_FLAG
                  ,FN_SCM_SYS_NVL(B.DEFAULT_FLAG, '') AS DEFAULT_FLAG
                  ,''                                 AS TOTAL_USE_FLAG
              FROM SCM_MGR.SCM_MST_SHEET_MEASURE B  
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = B.DIVISION_ID
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                        ON U.PROGRAM_ID  = B.PROGRAM_ID
                       AND U.SHEET_NAME  = B.SHEET_NAME
                       AND U.COLUMN_NAME = B.COLUMN_NAME
                       AND U.USER_ID     = P_USER_ID
             WHERE B.PROGRAM_ID = P_PROGRAM_ID
               AND B.SHEET_NAME = P_SHEET_NAME
               AND B.VALID_YN = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(B.DIVISION_ID ,',')) ) -- 20180604 DIVISION 추가
             ORDER BY B.SORT_ORDER_NO;
        END IF;
    ELSE -- 20180604 소형. ESLE 내용 추가
        IF P_COLUMN_TYPE = 'C' -- COLUMN
        THEN
            OPEN O_CURSOR FOR
            SELECT B.PROGRAM_ID
                  ,B.SHEET_NAME
                  ,B.COLUMN_NAME
                  ,B.COLUMN_LABEL_NAME
                  ,B.SMALL_CLASS_LABEL_NAME
                  ,B.LARGE_CLASS_LABEL_NAME
                  ,B.DATA_SORT_METHOD_CODE
                  ,B.COLUMN_WIDTH
                  ,B.SORT_ORDER_NO
                  ,U.SUB_TOTAL_FLAG
                  ,FN_SCM_SYS_NVL(FN_SCM_SYS_NVL(U.DATA_SORT_METHOD_CODE, B.DATA_SORT_METHOD_CODE), 'ASC') AS USER_SORT_METHOD_CODE
                  ,U.SORT_ORDER_NO AS USER_SORT_ORDER_NO
                  ,(CASE WHEN NVL(U.COLUMN_NAME,'@@') = '@@' THEN ''
                         ELSE 'Y'
                    END)                                       AS USER_FLAG
                  ,FN_SCM_SYS_NVL(B.DEFAULT_FLAG, '')         AS DEFAULT_FLAG
                  ,FN_SCM_SYS_NVL(B.USER_SELECTABLE_FLAG, 'Y') AS USER_SELECTABLE_FLAG
                  ,''                                         AS TOTAL_USE_FLAG 
                  ,EDY.EDIT_YN 
              FROM SCM_MGR.SCM_MST_SHEET_COLUMNS B
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = B.DIVISION_ID
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                        ON U.PROGRAM_ID  = B.PROGRAM_ID
                       AND U.SHEET_NAME  = B.SHEET_NAME
                       AND U.COLUMN_NAME = B.COLUMN_NAME
                       AND U.USER_ID     = P_USER_ID
             WHERE B.PROGRAM_ID   = P_PROGRAM_ID
               AND B.SHEET_NAME   = P_SHEET_NAME
               AND B.VALID_YN     = 'Y'
               AND B.VISIBLE_FLAG = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(B.DIVISION_ID ,',')) ) -- 20180604 DIVISION 추가
             ORDER BY B.SORT_ORDER_NO;
        ELSE -- MEASURE
            OPEN O_CURSOR FOR
            SELECT B.PROGRAM_ID
                  ,B.SHEET_NAME
                  ,B.COLUMN_NAME
                  ,B.COLUMN_LABEL_NAME
                  ,B.SMALL_CLASS_LABEL_NAME
                  ,B.LARGE_CLASS_LABEL_NAME
                  ,U.DATA_SORT_METHOD_CODE
                  ,B.SORT_ORDER_NO
                  ,NULL AS SUB_TOTAL_FLAG
                  ,NULL AS USER_SORT_METHOD_CODE
                  ,U.SORT_ORDER_NO AS USER_SORT_ORDER_NO
                  ,B.USER_SELECTABLE_FLAG
                  ,(CASE WHEN NVL(U.COLUMN_NAME,'@@') = '@@' THEN ''
                         ELSE 'Y'
                    END) AS USER_FLAG
                  ,FN_SCM_SYS_NVL(B.DEFAULT_FLAG, '') AS DEFAULT_FLAG
                  ,''                                 AS TOTAL_USE_FLAG
                  ,EDY.EDIT_YN
              FROM SCM_MGR.SCM_MST_SHEET_MEASURE B  
                   INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) EDY
                       ON EDY.UNIT_ID = B.DIVISION_ID
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
                        ON U.PROGRAM_ID  = B.PROGRAM_ID
                       AND U.SHEET_NAME  = B.SHEET_NAME
                       AND U.COLUMN_NAME = B.COLUMN_NAME
                       AND U.USER_ID     = P_USER_ID
             WHERE B.PROGRAM_ID = P_PROGRAM_ID
               AND B.SHEET_NAME = P_SHEET_NAME
               AND B.VALID_YN   = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(B.DIVISION_ID ,',')) ) -- 20180604 DIVISION 추가
             ORDER BY B.SORT_ORDER_NO;
        END IF;
    END IF;


    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
             'P_PROGRAM_ID'          VALUE P_PROGRAM_ID
            ,'P_SHEET_NAME'          VALUE P_SHEET_NAME
            ,'P_COLUMN_TYPE'         VALUE P_COLUMN_TYPE
            ,'P_USER_ID'             VALUE P_USER_ID
            ,'P_DIVISION_ID'         VALUE P_DIVISION_ID
            ,'P_MENU_ID'             VALUE P_MENU_ID
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

END P_DMF0002_GET_TITLESET_POPUP;

END PKG_DMF0002;
/
