/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0002.sql
 * Description  : Standalone Procedures — DMF0002 화면 (3개)
 *              : 향후 PKG_DMF0002로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0002_GET_ITEM_BY_DIVISION_POPUPEX (
   P_DIVISION_ID   IN VARCHAR2
  ,P_DEPT_ID       IN VARCHAR2	--DEPARTMENT
  ,P_END_CUSTOMER  IN VARCHAR2	--ENDCUSTOMER
  ,P_PROJECT_CODE  IN VARCHAR2
  ,P_SCM_SITE_ID   IN VARCHAR2
  ,P_ITEM_ID       IN VARCHAR2
  ,P_MDMACTIVE_SW  IN VARCHAR2  --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선 (개발서버 및 운영배포시 NULL SETTING 제거)
  
	,O_CURSOR		     OUT SYS_REFCURSOR
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



BEGIN

		OPEN O_CURSOR FOR
    WITH TEMP_DM_MST_ITEM_SINGLE_V AS (
        SELECT A.DIVISION_ID, A.ITEM_ID
              ,ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
              ,ACTIVE_FLAG 
          FROM (SELECT T1.DIVISION_ID          AS DIVISION_ID
                      ,T1.ITEM_ID              AS ITEM_ID
                      ,MAX(T1.ITEM_NAME)		   AS ITEM_NAME 				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                      ,MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
                      ,MAX(T1.NICK_NAME)		   AS NICK_NAME			--닉네임이 NULL인 경우가 있으므로 하나로 통일
                      ,CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1		--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
                                     WHEN T1.ITEM_TYPE = 'H' THEN 2		--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                                     WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                     ELSE 4 END )
                            WHEN 1 THEN 'P'
                            WHEN 2 THEN 'H'
                            WHEN 3 THEN 'Q'
                            ELSE 'R' END       AS ITEM_TYPE
                      ,MAX(T1.ACTIVE_FLAG)		AS ACTIVE_FLAG  -- 20180720 ADD 'Y'대상중 1건 추출
                  FROM SCM_MST_ITEM_SN T1 
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
                               FROM SCM_MST_SITE_ITEM S 
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
               FROM SCM_MST_DIVISION I  
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
                                 FROM SCM_MST_SSO_USER_INFO B 
                                      INNER JOIN SCM_MST_SSO_DEPT_INFO C 
                                          ON B.DEPT_ID = C.DEPT_ID ) TEAM
                         ON TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(D.OWNER, ',')) WHERE ROWNUM = 1)
                    LEFT JOIN (
                               SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
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
                            FROM    TABLE(FN_STRING_SPLIT(P_DEPT_ID,',')) P 
                            WHERE   (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                            )
                AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                    ELSE NVL(S.END_CUSTOMER,'')
                     END IN (
                            SELECT  TOKEN
                            FROM    TABLE(FN_STRING_SPLIT(P_END_CUSTOMER,',')) P 
                            WHERE   (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(S.END_CUSTOMER,'') END) = P.TOKEN
                            )				   
                AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                    ELSE S.SCM_SITE_ID			
                     END IN (
                            SELECT  TOKEN
                            FROM    TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID,',')) P 
                            WHERE   (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                            )
                AND (EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE D.PROJECT_CODE LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE A.PROJECT_NAME LIKE P.TOKEN ||'%')
                    )
                AND (EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID,',')) P WHERE D.ITEM_ID LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN ||'%')
                    )	 -- 20181205 NICK NAME 조회요청으로 변경
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
               FROM SCM_MST_DIVISION I  
                    LEFT JOIN   SCM_MST_SITE_ITEM D   
                        ON  I.DIVISION_ID   = D.DIVISION_ID
                        AND D.VALID_YN      = 'Y'
                    LEFT JOIN SCM_MST_PROJECT A 
                        ON  I.DIVISION_ID   = D.DIVISION_ID	   
                        AND D.PROJECT_CODE  = A.PROJECT_CODE
                    LEFT JOIN SCM_MST_SITE S  
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
                                 FROM SCM_MST_SSO_USER_INFO B 
                                      INNER JOIN SCM_MST_SSO_DEPT_INFO C 
                                          ON B.DEPT_ID = C.DEPT_ID
                              ) TEAM
                        ON  TEAM.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(D.OWNER, ',')) WHERE ROWNUM = 1)
                    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
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
                    END IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID,',')) P WHERE 
                            (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                            )
                AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                         ELSE NVL(S.END_CUSTOMER,'')			
                    END IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER,',')) P WHERE 
                            (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL' ELSE NVL(S.END_CUSTOMER,'') END) = P.TOKEN
                            )
                AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                         ELSE S.SCM_SITE_ID			
                    END IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID,',')) P WHERE 
                            (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                            )
                AND (EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE D.PROJECT_CODE LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE A.PROJECT_NAME LIKE P.TOKEN ||'%')
                    )
                AND (EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.ITEM_ID LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN ||'%')
                    )	 -- 20181205 NICK NAME 조회요청으로 변경
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
               FROM SCM_MST_DIVISION I  
                    LEFT JOIN SCM_MST_SITE_ITEM D  
                        ON  I.DIVISION_ID   = D.DIVISION_ID 
                        AND D.VALID_YN      = 'Y'
                    LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO  			       
                        ON  D.OWNER = USER_INFO.USER_ID 
                    LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM  			       
                        ON  USER_INFO.DEPT_ID   = TEAM.DEPT_ID 
                        AND TEAM.VALID_YN       = 'Y' 
                    LEFT JOIN SCM_MST_SITE S  
                        ON  I.DIVISION_ID   = D.DIVISION_ID	   
                        AND D.SCM_SITE_ID   = S.SCM_SITE_ID   
                        AND S.VALID_YN      ='Y' 
                    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V     T 
                        ON  I.DIVISION_ID   = T.DIVISION_ID 
                        AND D.ITEM_ID       = T.ITEM_ID
                    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
                                WHERE LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                                  AND VALID_YN    = 'Y' 
                              )  ITEM_TYPE_CODE
                        ON  T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
                    LEFT OUTER JOIN TMP_81_UC_EXCEPTION EX
                        ON  EX.DIVISION_ID = D.DIVISION_ID
                        AND EX.ITEM_ID = D.ITEM_ID --E20231019-001234 DM시스템의 모델코드 사용중지 정보 제공 개선
              WHERE I.DIVISION_ID       = P_DIVISION_ID		-- 20190123  
                AND I.DIVISION_ID    LIKE '4%'    
                AND I.VALID_YN          = 'Y'   
                AND S.SITE_TYPE         = 'SALES'
                AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL'
                         ELSE TEAM.DEPT_ID			
                    END IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID,',')) P
                             WHERE (CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.TOKEN
                           )
                AND CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                         ELSE NVL(CASE WHEN P_DIVISION_ID <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END,'@#@#@#')
                    END IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER,',')) P
                             WHERE (CASE WHEN P_END_CUSTOMER = 'ALL' THEN 'ALL'
                                         ELSE NVL(CASE WHEN P_DIVISION_ID <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END,'@#@#@#') END) = P.TOKEN
                           )
                AND CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL'
                         ELSE S.SCM_SITE_ID			
                    END IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID,',')) P
                             WHERE (CASE WHEN P_SCM_SITE_ID = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.TOKEN
                           )
                AND (EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID,',')) P WHERE D.ITEM_ID LIKE P.TOKEN ||'%')
                     OR
                     EXISTS (SELECT * FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID,',')) P WHERE T.NICK_NAME LIKE P.TOKEN ||'%')
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
      ORDER BY S.DIVISION_ID
              ,S.PROJECT_CODE
              --, A.PROJECT_NAME
              ,S.SCM_SITE_ID
              ,S.SITE_DESCRIPTION
              ,S.ITEM_ID
	            ,S.ITEM_NAME
       ;

END DMF0002_GET_ITEM_BY_DIVISION_POPUPEX;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx
(
  p_division_id   VARCHAR2,
  p_dept_id        VARCHAR2,	--Department
  p_end_customer   VARCHAR2,	--Endcustomer
  p_project_code  VARCHAR2,
  p_scm_site_id   VARCHAR2,
  p_item_id       VARCHAR2,
  p_item_type     VARCHAR2
)
AS
BEGIN

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
        CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID
			END IN (
					Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
					(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
		AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID
			END IN (
					Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
					(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE NVL(C.END_CUSTOMER, NULL)
			END IN (
					Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
					(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
	               )

		AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID
			END IN (
					Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
					(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
		--AND CASE WHEN p_project_code IS NULL THEN ''
		--   		 ELSE A.PROJECT_CODE
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_project_code,',') as P Where
		--			(CASE WHEN p_project_code IS NULL THEN '' ELSE A.PROJECT_CODE END) = P.data
	 --              )
		--AND CASE WHEN p_project_code IS NULL THEN ''
		--   		 ELSE A.PROJECT_NAME
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_project_code,',') as P Where
		--			(CASE WHEN p_project_code IS NULL THEN '' ELSE A.PROJECT_NAME END) = P.data
	 --              )

		--AND CASE WHEN p_item_id IS NULL THEN ''
		--   		 ELSE D.ITEM_ID
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_item_id,',') as P Where
		--			(CASE WHEN p_item_id IS NULL THEN '' ELSE D.ITEM_ID END) = P.data
	 --              )
		--AND CASE WHEN p_item_id IS NULL THEN ''
		--   		 ELSE T.ITEM_NAME
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_item_id,',') as P Where
		--			(CASE WHEN p_item_id IS NULL THEN '' ELSE T.ITEM_NAME END) = P.data
	 --              )
	 AND (;
		 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (;
		 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where D.ITEM_ID LIKE P.token +'%')
	     OR
		 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
		 )
	 --AND    (   A.PROJECT_CODE LIKE '%'+ p_project_code + '%'
		--  OR A.PROJECT_NAME LIKE '%'+ p_project_code + '%'
		-- )

  --   AND    (   D.ITEM_ID   LIKE '%' + p_item_id + '%'
  --        OR T.ITEM_NAME LIKE '%' + p_item_id + '%' )


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

  if p_division_id <> '40' THEN
	  SELECT DISTINCT I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
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

		   --[PJ2024-50461] Team Mapping------------------------------------
		   --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
		   --ON C.DEPT_ID = TEAM.DEPT_ID
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
				FROM SCM_MST_SSO_USER_INFO B
				INNER JOIN SCM_MST_SSO_DEPT_INFO C
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(D.owner, ',')))
		   --[PJ2024-50461] Team Mapping------------------------------------
		   LEFT JOIN (
FETCH FIRST 1 ROWS ONLY
						 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
						 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
						WHERE;
						VALID_YN ='Y'
						AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		   )  AS ITEM_TYPE_CODE
		   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

	WHERE   I.DIVISION_ID = '81'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
	  AND   SITE_TYPE = 'SALES'
	  AND   CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE NVL(C.END_CUSTOMER, NULL)
				END IN (
						Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
						(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
					   )

			AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
						(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where D.PROJECT_CODE LIKE P.token  || '%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token  || '%')
			 )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where D.ITEM_ID LIKE P.token  || '%')
			 --OR
			 --Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.NICK_NAME LIKE P.token  || '%')
			 )	 --20181205 nick name 조회요청으로 수정

	UNION

	  SELECT DISTINCT I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , D.PROJECT_CODE
		 , A.PROJECT_NAME
		 , S.SCM_SITE_ID
		 , S.SITE_DESCRIPTION
		 , T.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME
		 , TEAM.DEPT_ID
		 , TEAM.DEPT_NAME_KO
		 , C.END_CUSTOMER
		 , A.CURRENCY

	  FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
	  --[PJ2024-50461] Team Mapping------------------------------------
		   --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE,owner FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
		--[PJ2024-50461] Team Mapping------------------------------------
		ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT OUTER JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
		ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
		ON D.SCM_SITE_ID  = S.SCM_SITE_ID

		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V     T

		ON I.DIVISION_ID  = T.DIVISION_ID AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
		LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
		ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID

		--[PJ2024-50461] Team Mapping------------------------------------
		--LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
		--ON C.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
			FROM SCM_MST_SSO_USER_INFO B
			INNER JOIN SCM_MST_SSO_DEPT_INFO C
			ON B.DEPT_ID = C.DEPT_ID
		) AS TEAM
		ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(D.owner, ',')))
		--[PJ2024-50461] Team Mapping------------------------------------


		LEFT JOIN (
FETCH FIRST 1 ROWS ONLY
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		 WHERE;
		 VALID_YN ='Y'
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

	WHERE   I.DIVISION_ID = '82'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
	  AND   SITE_TYPE = 'SALES'
	--  AND   D.PROJECT_CODE = 'DC-17-001'


	  AND   CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE NVL(C.END_CUSTOMER, NULL)
				END IN (
						Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
						(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
					   )

			AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
						(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where D.PROJECT_CODE LIKE P.token  || '%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token  || '%')
			 )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_ID LIKE P.token  || '%')
			 --OR
			 --Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.NICK_NAME LIKE P.token  || '%')
			 )	 --20181205 nick name 조회요청으로 수정
		ORDER BY I.DIVISION_ID
		, D.PROJECT_CODE
		, A.PROJECT_NAME
		, S.SCM_SITE_ID
		, S.SITE_DESCRIPTION
		, D.ITEM_ID
		, T.ITEM_NAME
	ELSE  --40
		--DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
 	  SELECT  T.DIVISION_ID
		 , T.DIVISION_ID  AS DIVISION_NAME
		 , '' AS PROJECT_CODE
		 , '' AS PROJECT_NAME
		 , '' AS SCM_SITE_ID
		 , '' AS SITE_DESCRIPTION
		 , T.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME	--model type
		 , '' AS DEPT_ID
		 , '' AS DEPT_NAME_KO
		 , '' AS END_CUSTOMER
		 , '' AS CURRENCY
	  FROM DM_MST_ITEM_SINGLE_V	T
		LEFT JOIN (
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		 WHERE;
		 VALID_YN ='Y'
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	WHERE  T.division_id = '40'
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_ID LIKE P.token  || '%')
			 --OR
			 --Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.NICK_NAME LIKE P.token  || '%')
			 )	 --20181205 nick name 조회요청으로 수정
		AND T.ITEM_TYPE  IN (
						 Select * from UF_FX_String_SplitForIN (p_item_type,',') as P Where (CASE WHEN p_item_type IS NULL THEN '' ELSE T.ITEM_TYPE END) = P.data
						)
	  ORDER BY T.ITEM_ID

	  /*
	  SELECT DISTINCT top 1000 I.DIVISION_ID
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
		 , T.ITEM_CLASS_NAME	--model type
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

		ON I.DIVISION_ID  = T.DIVISION_ID ------AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
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
	  AND   CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			--AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
			--   		 ELSE NVL(C.END_CUSTOMER, NULL)
			--	END IN (
			--			Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
			--			(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
		 --              )
			  AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE NVL(
						CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
					 , NULL)
				END IN (
						Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
						(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
							CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
						, NULL) END) = P.data
			)
			AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
						(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
	--***
		 ----AND (
			---- Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where D.PROJECT_CODE LIKE P.token +'%')
		 ----    OR
			---- Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token +'%')
			---- )
	--***
		 ------AND (
			------ Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_ID LIKE P.token +'%')
		 ------    OR
			------ Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			------ )

				AND CASE WHEN p_item_id IS NULL THEN ''
		   			 ELSE T.ITEM_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_item_id,',') as P Where
						(CASE WHEN p_item_id IS NULL THEN '' ELSE T.ITEM_ID END) = P.data
					   )
				AND CASE WHEN p_item_type IS NULL THEN ''
		   			 ELSE T.ITEM_TYPE
				END IN (
						Select * from UF_FX_String_SplitForIN (p_item_type,',') as P Where
						(CASE WHEN p_item_type IS NULL THEN '' ELSE T.ITEM_TYPE END) = P.data
					   )

		----AND (T.ITEM_TYPE  = 'H' OR T.ITEM_TYPE  = 'P' OR T.ITEM_TYPE  = 'R' OR T.ITEM_TYPE  = 'Q')	--*****
	  ORDER BY I.DIVISION_ID
			 --, D.PROJECT_CODE
			 --, A.PROJECT_NAME
			 --, S.SCM_SITE_ID
			 --, S.SITE_DESCRIPTION
			 , T.ITEM_ID
			 , T.ITEM_NAME
	 --DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
	 */
	END IF;

END;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0002_GET_TITLESET_POPUP(
    p_program_id   IN VARCHAR2,
    p_sheet_name   IN VARCHAR2,
    p_column_type  IN VARCHAR2,
    p_user_id      IN VARCHAR2,
    p_division_id  IN VARCHAR2
)
AS
    v_err_msg   VARCHAR2(4000 CHAR);
    v_backtrace VARCHAR2(4000 CHAR);
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    -- EXEC dbo.SCM0002_SET_DEFAULT_TITLESET_POPUP @p_program_id , @p_sheet_name, @p_column_type, @p_user_id
    SCM0002_SET_DEFAULT_TITLESET_POPUP(p_program_id, p_sheet_name, p_column_type, p_user_id);

    IF (p_division_id = '') -- 20180604 소형. 분기 추가
    THEN
        IF p_column_type = 'C' -- Column
        THEN
            SELECT b.program_id
                 , b.sheet_name
                 , b.column_name
                 , b.column_label_name
                 , b.small_class_label_name
                 , b.large_class_label_name
                 , b.data_sort_method_code
                 , b.column_width
                 , b.sort_order_no
                 , u.sub_total_flag
                 , FN_SCM_SYS_NVL(FN_SCM_SYS_NVL(u.data_sort_method_code, b.data_sort_method_code), 'ASC') AS user_sort_method_code
                 , u.sort_order_no AS user_sort_order_no
                 , (CASE NVL(u.column_name,'@@')
                    WHEN '@@' THEN ''
                    ELSE 'Y'
                    END) AS user_flag
                 , FN_SCM_SYS_NVL(b.default_flag, '') AS default_flag
                 , FN_SCM_SYS_NVL(b.user_selectable_flag, 'Y') AS user_selectable_flag
                 , '' AS total_use_flag  
              FROM scm_mst_sheet_columns b  
              LEFT OUTER JOIN scm_mst_titleset_user u ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = p_user_id
             WHERE b.program_id = p_program_id
               AND b.sheet_name = p_sheet_name
               AND b.valid_yn = 'Y'
               AND b.visible_flag = 'Y'
             ORDER BY b.sort_order_no;
        ELSE -- Measure
            SELECT b.program_id
                 , b.sheet_name
                 , b.column_name
                 , b.column_label_name
                 , b.small_class_label_name
                 , b.large_class_label_name
                 , u.data_sort_method_code
                 , b.sort_order_no
                 , NULL AS sub_total_flag
                 , NULL AS user_sort_method_code
                 , u.sort_order_no AS user_sort_order_no
                 , b.USER_SELECTABLE_FLAG
                 , (CASE NVL(u.column_name,'@@')
                    WHEN '@@' THEN ''
                    ELSE 'Y'
                    END) AS user_flag
                 , FN_SCM_SYS_NVL(b.default_flag, '') AS default_flag
                 , '' AS total_use_flag
              FROM scm_mst_sheet_measure b  
              LEFT OUTER JOIN scm_mst_titleset_user u ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = p_user_id
             WHERE b.program_id = p_program_id
               AND b.sheet_name = p_sheet_name
               AND b.valid_yn = 'Y'
               AND p_division_id IN (SELECT token FROM String_Split(b.DIVISION_ID ,',') ) -- 20180604 division 추가
             ORDER BY b.sort_order_no;
        END IF;
    ELSE -- 20180604 소형. ESLE 내용 추가
        IF p_column_type = 'C' -- Column
        THEN
            SELECT b.program_id
                 , b.sheet_name
                 , b.column_name
                 , b.column_label_name
                 , b.small_class_label_name
                 , b.large_class_label_name
                 , b.data_sort_method_code
                 , b.column_width
                 , b.sort_order_no
                 , u.sub_total_flag
                 , FN_SCM_SYS_NVL(FN_SCM_SYS_NVL(u.data_sort_method_code, b.data_sort_method_code), 'ASC') AS user_sort_method_code
                 , u.sort_order_no AS user_sort_order_no
                 , (CASE NVL(u.column_name,'@@')
                    WHEN '@@' THEN ''
                    ELSE 'Y'
                    END) AS user_flag
                 , FN_SCM_SYS_NVL(b.default_flag, '') AS default_flag
                 , FN_SCM_SYS_NVL(b.user_selectable_flag, 'Y') AS user_selectable_flag
                 , '' AS total_use_flag  
              FROM scm_mst_sheet_columns b  
              LEFT OUTER JOIN scm_mst_titleset_user u ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = p_user_id
             WHERE b.program_id = p_program_id
               AND b.sheet_name = p_sheet_name
               AND b.valid_yn = 'Y'
               AND b.visible_flag = 'Y'
               AND p_division_id IN (SELECT token FROM String_Split(b.DIVISION_ID ,',') ) -- 20180604 division 추가
             ORDER BY b.sort_order_no;
        ELSE -- Measure
            SELECT b.program_id
                 , b.sheet_name
                 , b.column_name
                 , b.column_label_name
                 , b.small_class_label_name
                 , b.large_class_label_name
                 , u.data_sort_method_code
                 , b.sort_order_no
                 , NULL AS sub_total_flag
                 , NULL AS user_sort_method_code
                 , u.sort_order_no AS user_sort_order_no
                 , b.USER_SELECTABLE_FLAG
                 , (CASE NVL(u.column_name,'@@')
                    WHEN '@@' THEN ''
                    ELSE 'Y'
                    END) AS user_flag
                 , FN_SCM_SYS_NVL(b.default_flag, '') AS default_flag
                 , '' AS total_use_flag
              FROM scm_mst_sheet_measure b  
              LEFT OUTER JOIN scm_mst_titleset_user u ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = p_user_id
             WHERE b.program_id = p_program_id
               AND b.sheet_name = p_sheet_name
               AND b.valid_yn = 'Y'
               AND p_division_id IN (SELECT token FROM String_Split(b.DIVISION_ID ,',') ) -- 20180604 division 추가
             ORDER BY b.sort_order_no;
        END IF;
    END IF;

    COMMIT;
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION
    WHEN OTHERS THEN
        v_err_msg   := SQLERRM;
        v_backtrace := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'DMF0002_GET_TITLESET_POPUP failed: ' || v_err_msg);
END DMF0002_GET_TITLESET_POPUP;
/
