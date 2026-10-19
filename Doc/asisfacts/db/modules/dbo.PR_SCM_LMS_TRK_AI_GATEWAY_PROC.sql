



CREATE PROCEDURE [dbo].[PR_SCM_LMS_TRK_AI_GATEWAY_PROC]
                 -- 입력파라메터

				 -- 출력파라메터										   	                 
				 
AS


/***********************************************************************************************************
- Program ID         : [PR_SCM_LMS_TRK_AI_GATEWAY_PROC]
- Program Name       : SCM + LMS 트래킹 데이터 조회 FOR AI CHAT
- First Created Date : 2025.11.19
- First Created By   : CHANWOO YANG
- Function           : SCM제품정보를 기반으로 LMS트래킹 데이터를 조회하여 정해진 테이블에 저장
- Input  Parameter   : N/A
- Output Parameter   : N/A
- Step               : 
    STEP 01. 테이블 비우기데이터 생성
    STEP 02. 조회쿼리
    STEP 03. 테이블 저장


- History
  ===================================================================================================
     Date          In Charge     Description
  ===================================================================================================
   2025. 12.26    CHANWOO YANG   최초작성

   
[ Execute Command ]
DECLARE @RESULT      CHAR(1) 

EXEC  [dbo].[PR_SCM_LMS_TRK_AI_GATEWAY_PROC]    


결과저장 타겟테이블 : [LGCE_LOGIDEV].[dbo].TB_SCM_LMS_TRK_AI_GATEWAY

CREATE TABLE TB_SCM_LMS_TRK_AI_GATEWAY (

    DIVISION_ID             NVARCHAR(10)    NOT NULL
    , COMPANY_ID            NVARCHAR(10)    NOT NULL
    , SITE_ID               NVARCHAR(10)    NOT NULL
    , ITEM_ID               NVARCHAR(30)    NOT NULL
    , PARENT_ITEM_ID        NVARCHAR(30)    NOT NULL
    , CHILD_ITEM_ID         NVARCHAR(30)    NOT NULL
    , ITEM_NAME             NVARCHAR(100)   NULL
    , ITEM_CLASS_NAME       NVARCHAR(100)   NULL
    , MATERIAL_CLASS_NAME   NVARCHAR(100)   NULL
    , NICK_NAME             NVARCHAR(100)   NULL
    , PRODUCT_LEVEL1        NVARCHAR(100)   NULL
    , PRODUCT_LEVEL2        NVARCHAR(100)   NULL
    , PRODUCT_LEVEL3        NVARCHAR(100)   NULL
    , DATA_INS_DTM          DATETIME2       DEFAULT GETDATE() NOT NULL
    , DATA_INS_USER_ID      NVARCHAR(50)   DEFAULT 'SYSTEM' NOT NULL
    , CONSTRAINT PK_TB_SCM_LMS_TRK_AI_GATEWAY PRIMARY KEY (DIVISION_ID, COMPANY_ID, SITE_ID, ITEM_ID, PARENT_ITEM_ID, CHILD_ITEM_ID)

);
    
************************************************************************************************************/

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;




    BEGIN TRY
	      
/*
  '수정사항' 조회해서 해당 부분 수정 후 프로시저 반영 필요함
  */

  
/* ============================================================
   0. PJT 결과를 받을 테이블 변수 
   ============================================================ */ 
   
   /*
   CREATE TABLE #PJT_Joined (
   --DECLARE @PJT_Joined TABLE (
      DIVISION_ID   NVARCHAR(30) NOT NULL
    , ITEM_ID       NVARCHAR(50) NOT NULL
    , NICK_NAME     NVARCHAR(150)
	, PRODUCT_LEVEL1  NVARCHAR(150)
	, PRODUCT_LEVEL2  NVARCHAR(150)
	, PRODUCT_LEVEL3  NVARCHAR(150)

	);
	*/
	--ALTER TABLE #PJT_Joined ADD CONSTRAINT PK_PJT PRIMARY KEY (DIVISION_ID, ITEM_ID);
	--CREATE INDEX DIVISION_ID_IDX ON #PJT_Joined (DIVISION_ID);
	--CREATE INDEX ITEM_ID_IDX ON #PJT_Joined (ITEM_ID);


/* ============================================================
   1. PJT 쿼리 자리
   ============================================================ */

   
/*

scm ui 가 uicategory setup 설정에 따라 조회가 되고 있습니다.

 select top 1000 program_id , sheet_name , column_name , column_label_name
FROM	SCM_MST_SHEET_COLUMNS C with(nolock)
where program_id = 'scp0080'
and VALID_YN ='y'
and sheet_name = 'Group Code Management - 81'


위 쿼리 조회시 sheet_name 에 맞는 division으로 컬럼이 매핑되어서 보이고
(sheet_name  ex) 
'Group Code Management - 40'
'Group Code Management - 81' 
'Group Code Management - 81_HD'
설정되지 않는 division은 'Group Code Management' 
로 조회되어 보여진다고 보시면 됩니다.

sheet_name : Group Code Management - 40 
column_name : GROUP_CODE9
column_label_name : product level4 
이면 아래 화면 조회 쿼리에서 group_code9가 ui에서 proeuct level4 에 표시됩니다.


감사합니다.
*/


--- 화면 조회 쿼리 시작 ---
	

    BEGIN TRAN


	DECLARE @p_division_id			NVARCHAR(1000)			= ''; -- 40 / 81 / 82 
    DECLARE @p_operation_id			NVARCHAR(1000)			= '';
    DECLARE @p_model_id				NVARCHAR(1000)			= '';
    DECLARE @p_nickname				NVARCHAR(1000)			= ''; --- 닉네임.
    --DECLARE @p_check_fcst			NVARCHAR(1000)			= 'N';
    --DECLARE @p_check_production		NVARCHAR(1000)			= 'N';
    --DECLARE @p_check_active			NVARCHAR(1)				= 'N';
    --DECLARE @p_check_bom			NVARCHAR(1)				= 'N';
    --DECLARE @p_user_id				NVARCHAR(1000)			= 'TEST';
    --DECLARE @debug_mode				NVARCHAR(1)				= 'F'
	
	--NERP 매핑코드 [HQ00] = C100
    --DECLARE @v_ESOC NVARCHAR(8);
	--SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('FN_SCP0080_GET_GROUP_CODE_MANAGEMENT','ESOC')

    DECLARE @THIS_MONDAY            NVARCHAR(8)             = '';




    -- 이번주 월요일 날짜 확인
    SELECT @THIS_MONDAY = CONVERT(CHAR(8), DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0), 112);





    --------------------------------------------
    -- 1. 테이블 비우기
    --------------------------------------------
    TRUNCATE TABLE TB_SCM_LMS_TRK_AI_GATEWAY;










	------------------------------------------------------------------------------------------------------------------
	-- print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	-- [PJ20257329] 2025.08.01  Cell 하드 코딩 공정 조건 변경  
	------------------------------------------------------------------------------------------------------------------
	 
    WITH SCP_CELL_FINAL_OPERATION AS (
	 


	    SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	      FROM [LGCE_SCMDEV].[dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LK WITH(NOLOCK)
	     WHERE 1=1
	       AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	       AND LK.SEGMENT3	  = 'A'  -- 공정그룹 (Cell)
	       AND LK.ATTRIBUTE1  = 'Y'	 -- FInal Operation
    )
    ,


    SCP_CELL_PROD_PLAN_OPERATION_ALL AS (

	------------------------------------------------------------------------------------------------------------------
	-- print  convert(varchar(30), getdate(), 121) + N' SCP Cell 생산계획 공정 정보 전체' 
	-- [PJ20257329] 2025.08.01   Cell 하드 코딩 공정 조건 변경
	-- 2025/8/1기준 (A3000, A9000, F6200, F7000, F7100, F7200, F7300)
	------------------------------------------------------------------------------------------------------------------

	    SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	     WHERE 1=1
	       AND LK.LOOKUP_TYPE	= 'SCP_PLAN_OPERATION'
	       AND LK.SEGMENT3	    = 'A'  -- 공정그룹 (Cell)
	       AND LK.VALID_YN		= 'Y'  -- SCP 계획 공정 
	    ------------------------------------------------------------------------------------------------------------------
    )
    ,





    --DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

	--과거 3개월 판매이력
    TblGroupCode_SP0080_MASS AS (


	    SELECT DISTINCT
			      DIVISION_ID
			    , ITEM_ID
			    --, FCST_TYPE
			    --, MEASURE
			    --, YYYYMMDD
			    --, 'Y' AS MOTH
	    FROM	DM_PLN_MKT_FCST_RESULT
	    WHERE	1=1
            AND (
		    @p_division_id IS NULL
		    OR @p_division_id = ''
		    OR DIVISION_ID = @p_division_id )
		    AND MEASURE   = 'RTF_SYS_RP'
		    AND FCST_TYPE = 'MPS' --Mass
		    AND YYYYMMDD  > DATEADD(DAY,-90,GETDATE())


    ),


    TblGroupCode_SP0080_ITEM_ALL AS (


	    SELECT DISTINCT
			      DIVISION_ID
			    , ITEM_ID
			    , 'Y' AS STATUS_NEW
                , ACTIVE_FLAG
                , INSERT_TIME
                , SCP_EXTRA_SPEC -- 40 : Product level2
	    FROM	SCM_MST_ITEM_SN WITH(NOLOCK)
        WHERE   1=1
            AND (
		    @p_division_id IS NULL
		    OR @p_division_id = ''
		    OR DIVISION_ID = @p_division_id )


    ) 
    ,

    --TESTING : NOK
    --select * from @TblGroupCode_SP0080_ITEM_ALL;return;

    --신규 Item ID 발번되어 I/F된지 3주 이내 아이템
    TblGroupCode_SP0080_ITEM AS (



	    SELECT DISTINCT
			      DIVISION_ID
			    , ITEM_ID
			    , STATUS_NEW
	    FROM	TblGroupCode_SP0080_ITEM_ALL
	    WHERE	1=1
            AND INSERT_TIME > DATEADD(DAY,-21,GETDATE())

    )
    ,

    TblGroupCode_SP0080_ITEM_ACTIVE AS (




        SELECT    A.DIVISION_ID
                , A.ITEM_ID
                , A.ACTIVE_FLAG
        FROM    (
                    SELECT    A.DIVISION_ID
                            , A.ITEM_ID
                            , A.ACTIVE_FLAG
                    FROM    (
	                            SELECT    DIVISION_ID
                                        , ITEM_ID
                                        , ACTIVE_FLAG
                                        , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID ORDER BY IIF(ACTIVE_FLAG = 'Y', 1, 2) ASC) RN
	                            FROM    TblGroupCode_SP0080_ITEM_ALL
                            ) A
                    WHERE   1=1
                        AND A.RN = 1
                ) A
        GROUP BY  A.DIVISION_ID
                , A.ITEM_ID
                , A.ACTIVE_FLAG


    )
    ,

    --TESTING : OK
    --select * from @TblGroupCode_SP0080_ITEM_ACTIVE;return;


    TblGroupCode_SP0080_ITEM_EXTRA_SPEC AS (



	    SELECT DISTINCT
			      DIVISION_ID
			    , ITEM_ID
                , SCP_EXTRA_SPEC -- 40 : Product level2
	    FROM    TblGroupCode_SP0080_ITEM_ALL
        WHERE   1=1
            AND SCP_EXTRA_SPEC IS NOT NULL

    )
    ,

--TESTING : NOK
--select  *
--from    @TblGroupCode_SP0080_ITEM_EXTRA_SPEC
--where   1=1
--    AND ITEM_ID IN ('MCMM725075A1')
--ORDER BY ITEM_ID
--return;


    TblGroupCode_SP0080_PLANT AS (


        SELECT  *
        FROM
                (
                    SELECT --DISTINCT
                              P.DIVISION_ID
                            , P.ITEM_ID
                            , S.OPERATION_GROUP
                            , S.PLANT_ID
			                , CASE
                                WHEN S.OPERATION_GROUP = 'W' THEN S.PLANT_ID
				                WHEN N.PLANT_NAME IS NULL    THEN V.VENDOR_NAME
                                ELSE N.PLANT_NAME
                              END AS PLANT_NAME
                            , ROW_NUMBER() OVER(PARTITION BY   P.DIVISION_ID, P.ITEM_ID, S.OPERATION_GROUP ORDER BY (S.PLANT_ID)) AS RN
			                --, CASE
                   --             WHEN S.OSP_YN = 'Y' THEN
                   --                 CASE
                   --                     WHEN V.ATTRIBUTE1 IS NULL THEN
                   --                         CASE
                   --                             WHEN S.OPERATION_GROUP = 'W'    THEN S.PLANT_ID
                   --                             WHEN N.PLANT_NAME IS NULL       THEN V.VENDOR_NAME
                   --                             ELSE N.PLANT_NAME
                   --                         END
                   --                     ELSE V.ATTRIBUTE1
                   --                 END
			                --	WHEN S.OSP_YN = 'N' THEN
                   --                 CASE
                   --                     WHEN SN.DESCRIPTION IS NULL THEN
                   --                         CASE
                   --                             WHEN S.OPERATION_GROUP = 'W'    THEN S.PLANT_ID
                   --                             WHEN N.PLANT_NAME IS NULL       THEN V.VENDOR_NAME
                   --                             ELSE N.PLANT_NAME
                   --                         END
                   --                     ELSE SN.DESCRIPTION
                   --                 END
                   --           END AS PLANT_NAME
                    FROM    SCM_MST_SITE_ITEM_PRIORITY P WITH(NOLOCK)
                            JOIN SCM_MST_SITE S (NOLOCK) ON
                                    P.DIVISION_ID   = S.DIVISION_ID
                                AND P.PLANT_SITE_ID = S.SCM_SITE_ID
			                LEFT OUTER JOIN SCM_MST_PLANT_SN N (NOLOCK) ON
                                    S.COMPANY_ID    = N.COMPANY_ID
                                AND S.DIVISION_ID   = P.DIVISION_ID
                                AND S.PLANT_ID      = N.PLANT_ID
			                LEFT OUTER JOIN SCM_MST_VENDOR V WITH(NOLOCK) ON
                                    V.VENDOR_CODE   = S.PLANT_ID
                                AND S.COMPANY_ID    = V.COMPANY_ID
			                LEFT OUTER JOIN SCM_PLANT_M_SN SN WITH(NOLOCK) ON
                                    S.DIVISION_ID   = SN.DIVISION_ID
                                AND S.PLANT_ID =SN.PLANT_ID
                    WHERE   1=1
                        AND P.PRIORITY    = '1'
                        AND P.VALID_YN    = 'Y'
                        AND S.SITE_TYPE   = 'PLANT'
                        AND S.VALID_YN    = 'Y'
                        AND CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN P.FROM_YYYYMMDD AND P.TO_YYYYMMDD
                ) A
        WHERE   A.RN = 1
    )
    ,


--TESTING : OK
--select * from @TblGroupCode_SP0080_PLANT;return;
--select  *
--from    @TblGroupCode_SP0080_PLANT
--WHERE   1=1
--    AND ITEM_ID = 'ACEH1085I-A1-000'
--return;

    TblGroupCode_SP0080_ESS_MODEL_TYPE AS (


        SELECT    B.SEGMENT1 CODE
		        , B.SEGMENT2 NAME
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        WHERE   A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
	        AND A.VALID_YN = 'Y'
	        AND B.VALID_YN = 'Y'
	        AND B.SEGMENT3 = '82'
       -- ORDER BY B.DISPLAY_SEQ;


    ),


    TblGroupCode_SP0080_SMALL_MODEL_TYPE AS (


        SELECT    B.SEGMENT1 CODE
		        , B.SEGMENT2 NAME
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        WHERE   A.LOOKUP_TYPE = 'ITEM_MODEL_TYPE'
	        AND A.VALID_YN = 'Y'
	        AND B.VALID_YN = 'Y'
	        AND B.SEGMENT3 = '40'
        --ORDER BY B.DISPLAY_SEQ;


    )
    ,


    TblGroupCode_SP0080_CATHODE AS (


        SELECT    B.SEGMENT1 CODE
		        , B.SEGMENT2 NAME
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        WHERE   A.LOOKUP_TYPE = 'CATHODE'
	        AND A.VALID_YN = 'Y'
	        AND B.VALID_YN = 'Y'
        --ORDER BY B.DISPLAY_SEQ;

    )
    ,


    TblGroupCode_SP0080_CELL_TYPE_GROUP AS (


        SELECT    A.CODE                    AS CELL_TYPE_CODE
                , SUBSTRING(A.NAME, 1, 1)   AS FLOW_TYPE
                , A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
                , G.NAME                    AS CELL_TYPE_GROUP_NAME
                , A.DISPLAY_SEQ
        FROM    (
                    SELECT    B.SEGMENT1 CODE
                            , B.SEGMENT2 NAME
                            , B.SEGMENT3 GROUP_CODE
                            , B.DISPLAY_SEQ
                    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
        	                    AND B.VALID_YN = 'Y'
                    WHERE   1=1
                        AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_CODE'
	                    AND A.VALID_YN      = 'Y'
                ) A
                JOIN
                    (
                        SELECT    B.SEGMENT1 CODE
                                , B.SEGMENT2 NAME
                        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                                JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON
                                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
        	                        AND B.VALID_YN = 'Y'
                        WHERE   1=1
                            AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
	                        AND A.VALID_YN      = 'Y'
                     ) G ON
                        A.GROUP_CODE = G.CODE
        --ORDER BY A.DISPLAY_SEQ
    )
    ,


    TblGroupCode_SP0080_ENERGE AS (


        SELECT    DIVISION_ID
                , SITE_ID
                , ITEM_ID
                , ENERGE
        FROM    dbo.SCM_MST_ITEM_SN WITH(NOLOCK)
        WHERE   1=1
            AND DIVISION_ID in ('82','40')
            AND COMPANY_ID = dbo.FN_GET_LOOKUP_VALUE('FN_SCP0080_GET_GROUP_CODE_MANAGEMENT','ESOC')
            AND ENERGE IS NOT NULL
            AND ENERGE <> ''

    )
    ,

--TESTING : OK
--select  *
--from    @TblGroupCode_SP0080_ENERGE
--where   1=1
--    AND ITEM_ID = 'ECE0710N7-02'
--return;

--PRINT CONCAT('ELAPSED_TIME-Temp Codes : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;
    
--평가감 CELL_CF
    TblDynamicPivot_SCP0080_CELL_CF_KD AS (


        SELECT    A.ITEM_ID
                , CONVERT(NVARCHAR(100), CONVERT(NUMERIC(20, 10), ISNULL(B.CELL_CF, '1.0')))     AS CELL_CF
        FROM
                (
                    SELECT    DIVISION_ID
                            , ITEM_ID
                            , CASE 
                                WHEN RIGHT(A.ITEM_ID, 2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  THEN SUBSTRING(ITEM_ID, 1, LEN(ITEM_ID) - 2)
                                WHEN RIGHT(A.ITEM_ID, 3) IN ('-GG','-GK')                                                   THEN SUBSTRING(ITEM_ID, 1, LEN(ITEM_ID) - 3)
                              END AS BASIC_ITEM_ID
                    FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                    WHERE   1=1
                        AND (RIGHT(A.ITEM_ID, 2) IN ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R') OR
                             RIGHT(A.ITEM_ID, 3) IN ('-GG','-GK'))
                ) A
                LEFT JOIN (
                            SELECT  *
                            FROM    SCP_MST_ITEM_CELL_CF WITH(NOLOCK)
                            WHERE   1=1
                            ) B ON
                        A.BASIC_ITEM_ID = B.ITEM_ID

    )
    ,
--TESTING : OK
--select  * from #TblDynamicPivot_SCP0080_CELL_CF_KD;



    TblGroupCode_SP0080_Temp AS ( 

	

--TESTING : OK
--SELECT  A.*
--FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
--		LEFT JOIN @TblGroupCode_SP0080_PLANT D ON
--                A.DIVISION_ID       = D.DIVISION_ID
--            AND A.OPERATION_GROUP   = D.OPERATION_GROUP
--            AND A.ITEM_ID           = D.ITEM_ID
--WHERE   1=1
--	AND A.OPERATION_GROUP IN ('A', 'P')
--	AND A.DIVISION_ID = '82'
--	AND A.ITEM_ID = 'ECE0668N5-01'
--return;



        --INSERT INTO    #TblGroupCode_SP0080_Temp
        SELECT    A.*
                , SUBSTRING(A.BASIC_MODEL_CELL, 8, 2)   AS CATHODE_CODE
        FROM    (
                    SELECT --DISTINCT
                              A.DIVISION_ID
			                , A.FLOW_ID         AS OPERATION_ID
			                , A.ITEM_ID
			                , A.NICK_NAME
			                , CASE
			                    WHEN A.OPERATION_GROUP = 'P' THEN (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)
			                    ELSE ''
			                    END                       AS BASIC_MODEL_PACK
			                , CASE
			                    WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL))
			                    ELSE ''
			                    END                       AS BASIC_NICKNAME_PACK

                            , CASE -- 
                                -- [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN A.ITEM_ID
                                WHEN CA.OPERATION_ID IS NOT NULL THEN A.ITEM_ID	-- [PJ20257329] 2025.08.01 Cell 계획 공정 하드코딩 변경 
                                ELSE
			                      CASE
			                        WHEN A.OPERATION_GROUP = 'P' THEN A.ATTRIBUTE1
			                        ELSE ''
		                          END
                              END AS CELL_MODEL
                            , CASE
                                -- [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000', 'F6200', 'F7000', 'F7100', 'F7200', 'F7300') THEN A.NICK_NAME
                                WHEN CA.OPERATION_ID IS NOT NULL THEN A.NICK_NAME	-- [PJ20257329] 2025.08.01 Cell 계획 공정 하드코딩 변경 
                                ELSE
			                      CASE
			 	                    WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1)
			                        ELSE ''
		                          END
                              END AS CELL_MODEL_NICKNAME
			                , CASE
			                    WHEN A.OPERATION_GROUP = 'P' THEN (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL)
			                    ELSE (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)
			                    END                       AS BASIC_MODEL_CELL
			                , CASE
			                    WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL))
			                    ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL))
			                    END                       AS BASIC_NICKNAME_CELL
			                , A.GROUP_CODE1
			                , A.GROUP_CODE2
			                , A.GROUP_CODE3
			                , A.GROUP_CODE4
			                , A.GROUP_CODE5
			                , A.GROUP_CODE6
			                , A.GROUP_CODE7
			                , A.GROUP_CODE8
			                , A.GROUP_CODE9
			                , A.GROUP_CODE10
			                , ISNULL(A.FCST_YN, 'N')    AS FCST_YN
			                , A.ATTRIBUTE6              AS PIC_ID
                            , UI.USER_NAME              AS PIC_NAME
			                , A.ATTRIBUTE7
			                , A.ATTRIBUTE8
			                , A.ATTRIBUTE9
			                , A.ATTRIBUTE10
			                , A.ATTRIBUTE11
			                , A.ATTRIBUTE12
			                , A.ATTRIBUTE13
			                , A.ATTRIBUTE14
			                , A.ATTRIBUTE15
			                , A.SALES_MODEL
			                , A.SALES_VALID_YN
			                , A.SALES_PRIORITY
			                , A.SALES_FROM_YYYYMMDD
			                , A.SALES_TO_YYYYMMDD
			                , CASE
                                -- [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID = 'A9000' THEN A.GROUP_CODE1
                                WHEN CO.OPERATION_ID IS NOT NULL										THEN A.GROUP_CODE1	-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 
                                WHEN A.FLOW_ID = 'P5000' OR A.FLOW_ID = 'P5500' OR A.FLOW_ID = 'P9500'	THEN A.GROUP_CODE2
                                END                       AS LEVEL1_GROUP
			                , A.LEVEL2_CODE
			                , IIF(C.STATUS_NEW = 'Y' AND ISNULL(A.STATUS_PROTOTYPE, '') <> '', 'Y', A.STATUS_PROTOTYPE) AS STATUS_PROTOTYPE
			                --, CASE
                   --             WHEN ISNULL(A.FCST_YN, '') = '' AND ISNULL(B.MOTH, '') = '' THEN ''
                   --             ELSE 'Y'
                   --           END                        AS STATUS_MASS
			                , C.STATUS_NEW
                            --, ROUND(CONVERT(NUMERIC(20, 10),
                            , ROUND(CONVERT(NUMERIC(20),
                                  CASE
                                    WHEN RIGHT(A.ITEM_ID, 2) IN ('-D', '-K') THEN F.CELL_CF
                                    ELSE
			                            CASE
                                        -- [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN
                                        WHEN CO.OPERATION_ID IS NOT NULL  THEN	-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경 
                                            CASE
                                                WHEN ISNULL(A.CELL_CF, '0') = '0' THEN '1'
                                                ELSE A.CELL_CF
                                            END
                                        ELSE A.CELL_CF
                                        END
                                  END
                              ), 0)                     AS CELL_CF
			                , A.END_CUSTOMER            AS BASIC_END_CUSTOMER
			                , A.FINISHED_PRODUCT        AS BASIC_FINISHED_PRODUCT
                            , A.OPERATION_GROUP
                            , CASE
                                -- [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID = 'A9000'    THEN 'Cell'
                                WHEN CO.OPERATION_ID IS NOT NULL    THEN 'Cell'		-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경
                                WHEN A.FLOW_ID = 'P5500'			THEN 'Module'
                                WHEN A.FLOW_ID = 'P9500'			THEN 'Pack'
                                ELSE                             ''--P5000
                              END AS BIZ_TYPE
                            , SUBSTRING(A.ITEM_ID, 2, 1) AS MODEL_TYPE_CODE
                            , SUBSTRING(A.ITEM_ID, 1, 2) AS LEVEL_EXCEPT -- 예외적용
                            , A.MKT_DEPT
                            , A.REMARK
                            , D.PLANT_ID
                            , D.PLANT_NAME
                            , E.ENERGE
                            , CASE
                                -- [PJ20257329] 2025.08.01  변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C'
                                WHEN CO.OPERATION_ID IS NOT NULL THEN 'C'	-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드 코딩 조건 변경
                                ELSE 'E'
                              END AS FLOW_TYPE
                            , M.ITEM_ID_ASSY
                            , A.REPLACEMENT
                            --, A.SCP_EXTRA_SPEC

						
	                FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
						    -- [PJ20257329] 2025.08.01 Cell 공정 하드 코딩 조건 변경 - Start 
						    LEFT JOIN SCP_CELL_PROD_PLAN_OPERATION_ALL CA 
							       ON CA.OPERATION_ID = A.FLOW_ID
						    LEFT JOIN SCP_CELL_FINAL_OPERATION     CO
							       ON CO.OPERATION_ID = A.FLOW_ID
						    -- [PJ20257329] 2025.08.01 Cell 공정 하드 코딩 조건 변경 - End 
			                --LEFT JOIN @TblGroupCode_SP0080_MASS B ON
                   --                 A.DIVISION_ID       = B.DIVISION_ID
                   --             AND A.ITEM_ID           = B.ITEM_ID
			                LEFT JOIN TblGroupCode_SP0080_ITEM C ON
                                    A.DIVISION_ID       = C.DIVISION_ID
                                AND A.ITEM_ID           = C.ITEM_ID
			                LEFT JOIN TblGroupCode_SP0080_PLANT D ON
                                    A.DIVISION_ID       = D.DIVISION_ID
                                --AND A.OPERATION_GROUP   = D.OPERATION_GROUP
                                AND A.ITEM_ID           = D.ITEM_ID
                            LEFT JOIN TblGroupCode_SP0080_ENERGE E ON
                                    A.DIVISION_ID       = E.DIVISION_ID
                                AND A.ITEM_ID           = E.ITEM_ID
                            LEFT JOIN TblDynamicPivot_SCP0080_CELL_CF_KD F ON
                                    A.ITEM_ID           = F.ITEM_ID
                            LEFT JOIN SCM_MST_SSO_USER_INFO UI WITH(NOLOCK) ON
                                    A.ATTRIBUTE6        = UI.USER_ID
                            LEFT JOIN
                                (
                                    SELECT    DIVISION_ID
                                            , ITEM_ID_PROD
                                            , MIN(ITEM_ID_ASSY) AS ITEM_ID_ASSY
                                    FROM    SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
                                    WHERE   1=1
                                        AND VALID_YN = 'Y'
                                        AND CELL_TYPE = 'CA1'
                                    GROUP BY  DIVISION_ID
                                            , ITEM_ID_PROD
                                ) M ON
                                    A.DIVISION_ID = M.DIVISION_ID
                                AND A.ITEM_ID     = M.ITEM_ID_PROD
	                WHERE   1=1
                        AND (SUBSTRING(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 = '' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
		                AND A.OPERATION_GROUP IN ('A', 'P')
		                AND (
		    @p_division_id IS NULL
		    OR @p_division_id = ''
		    OR (@p_division_id IS NULL OR @p_division_id = '' OR A.DIVISION_ID = @p_division_id ))
		                AND (( @p_operation_id	IS NULL OR @p_operation_id	='') OR A.FLOW_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id	, ',')))
		                AND (( @p_model_id		IS NULL OR @p_model_id		='') OR A.ITEM_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_model_id		, ',')))
		                AND (( @p_nickname		IS NULL OR @p_nickname		='') OR A.NICK_NAME				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_nickname		, ',')))
					    --AND A.group_code7 like '%BEV GEN3%'
					    --AND A.ITEM_ID = 'MCCH125020A1'
            ) A

    )
    ,


	

--TESTING : OK
--select *  from @TblGroupCode_SP0080_Temp;return;

--select *
--from    @TblGroupCode_SP0080_Temp
--WHERE   1=1
--    AND ITEM_ID = 'ACEH1085I-A1-000'
--return;

--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_Temp : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    TblGroupCode_SP0080_Pre AS (

	


        --INSERT INTO    #TblGroupCode_SP0080_Pre
        SELECT    T.*
                , CASE
                    WHEN T.BASIC_MODEL_CELL IS NOT NULL AND T.BASIC_MODEL_CELL <> '' THEN SUBSTRING(T.BASIC_MODEL_CELL, 3, 1)
                    ELSE T.BASIC_MODEL_CELL
                  END AS BASIC_APPLICATION
                , CASE
                    WHEN T.BASIC_MODEL_CELL IS NOT NULL AND T.BASIC_MODEL_CELL <> '' THEN SUBSTRING(T.BASIC_MODEL_CELL, 4, 2)
                    ELSE T.BASIC_MODEL_CELL
                  END AS BASIC_CELL_TYPE
                --, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) IS NULL, 0, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) LIKE '%[^0-9]%', ROUND(CONVERT(NUMERIC(30), SUBSTRING(T.BASIC_MODEL_CELL, 6, 3)), 0), 0)) AS BASIC_CELL_CAPACITY_81
                --, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) LIKE '%[^0-9]%' AND SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) IS NOT NULL, ROUND(CONVERT(NUMERIC(30), SUBSTRING(T.BASIC_MODEL_CELL, 6, 3)), 0), 0)  AS BASIC_CELL_CAPACITY_81
                --, IIF(SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) LIKE '%[^0-9]%', 'X', 'O') AS BASIC_CELL_CAPACITY_N
                , CASE
                    WHEN SUBSTRING(T.BASIC_MODEL_CELL, 1, 2) = 'EC' THEN SUBSTRING(T.BASIC_MODEL_CELL, 4, 4)
                    ELSE                                                 SUBSTRING(T.BASIC_MODEL_CELL, 6, 3)
                  END AS BASIC_CELL_CAPACITY_CHAR
                --, SUBSTRING(T.BASIC_MODEL_CELL, 6, 3) AS BASIC_MODEL_CELL_ORI
                --, SUBSTRING(T.BASIC_MODEL_CELL, 8, 1) AS BASIC_MODEL_CELL_LAST
                , H.NAME AS CATHODE_NAME
                , SUBSTRING(T.ITEM_ID, 3, 1) AS CELL_TYPE_CODE
                --, CASE
                --    WHEN T.FLOW_TYPE = 'C' THEN BASIC_NICKNAME_CELL
                --    ELSE T.NICK_NAME
                --  END AS NICKNAME_40
                , T.NICK_NAME AS NICKNAME_40
                , E.NAME AS MODEL_TYPE_NAME_82
                , S.NAME AS MODEL_TYPE_NAME_40
                , CASE
                    WHEN LEVEL_EXCEPT = 'EC' THEN 'ESS'
                    WHEN LEVEL_EXCEPT = 'AM' THEN '21700'
                    ELSE X.SCP_EXTRA_SPEC
                  END AS SCP_EXTRA_SPEC
                , CASE
                    WHEN LEVEL_EXCEPT = 'EC' THEN 'ESS'
                    WHEN LEVEL_EXCEPT = 'AM' THEN 'M50L'
                    ELSE T.BASIC_NICKNAME_CELL
                  END AS BASIC_NICKNAME_CELL40

        FROM    TblGroupCode_SP0080_Temp T
                LEFT JOIN TblGroupCode_SP0080_CATHODE H ON
                        T.CATHODE_CODE = H.CODE
                LEFT JOIN TblGroupCode_SP0080_ESS_MODEL_TYPE E ON
                        T.MODEL_TYPE_CODE = E.CODE
                LEFT JOIN TblGroupCode_SP0080_SMALL_MODEL_TYPE S ON
                        T.OPERATION_ID = S.CODE
                LEFT JOIN TblGroupCode_SP0080_ITEM_EXTRA_SPEC X ON
                        T.DIVISION_ID       = X.DIVISION_ID
                    AND T.ITEM_ID           = X.ITEM_ID
    --TESTING : OK
    --select * from @TblGroupCode_SP0080_Temp;
    --select * from @TblGroupCode_SP0080_Pre;return;
    --PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_Pre : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

    )
    ,


    TblGroupCode_SP0080_All AS (


	
    --select *
    --from    @TblGroupCode_SP0080_Pre
    --WHERE   1=1
    --    AND ITEM_ID = 'ACEH1085I-A1-000'
    --return;

        --INSERT INTO    #TblGroupCode_SP0080_All
        SELECT    P.*
                , CASE
                    WHEN P.BASIC_APPLICATION = 'E' THEN 'Battery EV(BEV)'
                    WHEN P.BASIC_APPLICATION = 'H' THEN 'Hybrid(HEV)'
                    WHEN P.BASIC_APPLICATION = 'L' THEN 'Low Voltage(LV)'
                    WHEN P.BASIC_APPLICATION = 'P' THEN 'Plug-in HEV(PHEV)'
                    ELSE            ''
                  END AS APPLICATION_NAME
                , IIF(P.BASIC_CELL_CAPACITY_CHAR IS NULL OR (P.BASIC_CELL_CAPACITY_CHAR LIKE '%[^0-9]%'), NULL, CONVERT(NUMERIC(20, 10), P.BASIC_CELL_CAPACITY_CHAR)) AS BASIC_CELL_CAPACITY_81
                , CASE
                    WHEN P.LEVEL_EXCEPT = 'EC' THEN 'Pouch'
                    WHEN P.LEVEL_EXCEPT = 'AM' THEN 'Cylindrical'
                    WHEN SUBSTRING(P.ITEM_ID, 3, 1) = 'M' AND P.OPERATION_ID = 'P9500' THEN 'Pouch'
                    ELSE G.CELL_TYPE_GROUP_NAME
                  END AS CELL_TYPE_GROUP_NAME
        FROM    TblGroupCode_SP0080_Pre P 
                LEFT JOIN TblGroupCode_SP0080_CELL_TYPE_GROUP G ON
                        P.FLOW_TYPE = G.FLOW_TYPE
                    AND P.CELL_TYPE_CODE = G.CELL_TYPE_CODE


    )
    ,


	--------------------- GPT가 넣으라고 한거 ------------@PJT_Joined에 컬럼값 Insert
	







--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_All : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


--TESTING : OK
--select * from @TblGroupCode_SP0080_CELL_TYPE_GROUP;
--select * from @TblGroupCode_SP0080_All;return;
--SELECT  *
--FROM    @TblGroupCode_SP0080_All
--WHERE   1=1
--    AND DIVISION_ID = '82'
--    AND ITEM_ID = 'ECE0710N7-02';
--return;

    TblGroupCode_SP0080_BOM_PACK AS (


	    SELECT DISTINCT
                  MODEL_ID AS ITEM_ID
                , OPERATION_GROUP_ID
	    FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH(NOLOCK)
	    WHERE   (
		    @p_division_id IS NULL
		    OR @p_division_id = ''
		    OR DIVISION_ID = @p_division_id )
            AND OPERATION_GROUP_ID = 'A'


    )
    ,


    TblGroupCode_SP0080_BOM_CELL AS (



	    SELECT DISTINCT
                  MODEL_ID AS ITEM_ID
                , OPERATION_GROUP_ID
	    FROM    SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH(NOLOCK)
	    WHERE   (
		    @p_division_id IS NULL
		    OR @p_division_id = ''
		    OR DIVISION_ID = @p_division_id )
            AND OPERATION_GROUP_ID = 'E'


    )
    ,



--TESTING : OK
--select * from @TblGroupCode_SP0080_BOM;return;

--PRINT CONCAT('ELAPSED_TIME-@TblGroupCode_SP0080_BOM_CELL : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    --DECLARE @v_basis_start_date NVARCHAR(16)    = '';

    --SELECT  @v_basis_start_date = BASIS_START_DATE
    --FROM    SCM_SYS_CALENDAR_M
    --WHERE   BASIS_YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE(), 112)
/*
    SELECT    A.*
            , CASE
                WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = '81'  THEN IIF(A.BASIC_CELL_CAPACITY_81 IS NULL OR A.CELL_CF IS NULL, NULL, CONVERT(NUMERIC(20, 10), A.BASIC_CELL_CAPACITY_81 * A.CELL_CF))
                WHEN A.DIVISION_ID = '82'                   THEN IIF(A.CELL_CF IS NULL, NULL, CONVERT(NUMERIC(20, 10), A.ENERGE))
				WHEN A.DIVISION_ID = '40'                   THEN IIF(A.CELL_CF IS NULL, NULL, CONVERT(NUMERIC(20, 10), A.ENERGE))
                ELSE NULL
              END AS BASIC_TOTAL_CAPACITY
            , CASE
                WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = '81'  THEN A.BASIC_CELL_CAPACITY_81
                WHEN A.DIVISION_ID = '82'                   THEN CONVERT(NUMERIC(20, 10), A.ENERGE) / A.CELL_CF
                ELSE NULL
              END AS BASIC_CELL_CAPACITY
              --ITEM 별 Plant가 n 개이면 Active 가 Plant 별로 Y, N 두개 이상 존재하므로 Y만 필터링(최종 row 가 ITEM 별 1개만 존재하도록)
            , IIF(P.ITEM_ID IS NOT NULL, 'Y', '')                                                               AS PRODUCTION_YN
            , IIF((P.ITEM_ID IS NOT NULL) OR A.FCST_YN = 'Y', 'Y', '')                                          AS STATUS_MASS
            , IIF(IA.ACTIVE_FLAG IS NULL, 'N', IA.ACTIVE_FLAG)                                                  AS STATUS_ACTIVE
    FROM    @TblGroupCode_SP0080_All A
		    LEFT JOIN (
                        SELECT    DISTINCT
                                  N.DIVISION_ID
                                , N.ITEM_ID
                        FROM    SCP_ANL_PRODUCTION_PLAN_N N WITH(NOLOCK)
                        WHERE   1=1
                            AND N.YYYYMMDD >= @v_basis_start_date
                      ) P ON
                    A.DIVISION_ID = P.DIVISION_ID
                AND A.ITEM_ID = P.ITEM_ID
            LEFT JOIN @TblGroupCode_SP0080_ITEM_ACTIVE IA ON
                    A.DIVISION_ID = IA.DIVISION_ID
                AND A.ITEM_ID     = IA.ITEM_ID
		    LEFT JOIN @TblGroupCode_SP0080_BOM_PACK BP ON
                    A.ITEM_ID = BP.ITEM_ID
		    LEFT JOIN @TblGroupCode_SP0080_BOM_CELL BC ON
                    A.ITEM_ID = BC.ITEM_ID
    WHERE   1=1
        AND ((@p_check_fcst ='N')           OR A.FCST_YN = @p_check_fcst)
        AND ((@p_check_production = 'N')    OR (@p_check_production = 'Y'   AND P.ITEM_ID IS NOT NULL))
        AND ((@p_check_bom = 'N')           OR (@p_check_bom = 'Y'          AND A.OPERATION_GROUP = 'P' AND BP.ITEM_ID IS NOT NULL)
                                            OR (@p_check_bom = 'Y'          AND A.OPERATION_GROUP = 'A' AND BC.ITEM_ID IS NOT NULL))
        AND ((@p_check_active = 'N')        OR (@p_check_active = 'Y'       AND IIF(IA.ACTIVE_FLAG IS NULL, 'N', IA.ACTIVE_FLAG) = 'Y'))
    ORDER BY      DIVISION_ID
				, OPERATION_ID
				, ITEM_ID
				, NICK_NAME
				*/

/* ============================================================
   2. ProdItem CTE (출하/생산 아이템 리스트)
   ============================================================ */
   
---------- 1. 법인향 출하계획 + 고객향 출하계획 + 생산계획에 존재하는 Item ID 리스트  --------------------------------------------------





    ProdItem AS (

	    SELECT DISTINCT
			    --CASE WHEN LEFT(SF.FROM_SITE,2) not in ('HQ', 'NJ', 'NB', 'WA', 'MI') THEN 'HQ00' ELSE LEFT(SF.FROM_SITE,2) + '00' END AS COMPANY_ID,
		       COALESCE(m.COMPANY_CODE, 'HQ00') AS COMPANY_ID, ------------------------------------------- 법인코드 ***
	           LTRIM(RTRIM(SF.DIVISION_ID)) AS DIVISION_ID,
               LTRIM(RTRIM(SF.ITEM_ID)) AS ITEM_ID
        FROM [LGCE_SCMDEV].[dbo].[SCP_ANL_SHIPMENT_PLAN_FG] SF WITH(NOLOCK) --고객향 출하계획
	    LEFT JOIN [LGCE_LOGIPROD].[dbo].[LOGI_MST_COMPANY] m  WITH(NOLOCK)
				    ON LEFT(SF.FROM_SITE,2) = LEFT(m.COMPANY_CODE,2)
	    WHERE SF.MEASURE          = 'SHIP_PLAN_AMEND' -- 수정한 최종 계획
          AND SF.PLAN_START_YYYYMMDD = @THIS_MONDAY   --------------------------------------------------------------------- 수정사항 : 최신 계획일 (월요일 날짜 입력 필요) 수정 필요
          AND SF.QTY               > 0
          AND SF.PLAN_TYPE         = 'FN' -- Final
	      AND SF.SEQ = (
		    SELECT MAX(SEQ)----------------SEQ 가 가장 높은것
		    FROM [LGCE_SCMDEV].[dbo].[SCP_ANL_SHIPMENT_PLAN_FG]  WITH(NOLOCK)
		    WHERE MEASURE          = 'SHIP_PLAN_AMEND' -- 수정한 최종 계획
          AND PLAN_START_YYYYMMDD = @THIS_MONDAY   --------------------------------------------------------------------- 수정사항 : 최신 계획일 (월요일 날짜 입력 필요) 수정 필요
          AND QTY               > 0
          AND PLAN_TYPE         = 'FN' -- Final
	      )

	    UNION

	    SELECT DISTINCT
		       --CASE WHEN LEFT(SS.FROM_SITE,2) not in ('HQ', 'NJ', 'NB', 'WA', 'MI') THEN 'HQ00' ELSE LEFT(SS.FROM_SITE,2) + '00' END AS COMPANY_ID,
		       COALESCE(m.COMPANY_CODE, 'HQ00') AS COMPANY_ID, ------------------------------------------- 법인코드 ***
	           LTRIM(RTRIM(SS.DIVISION_ID)) AS DIVISION_ID,
               LTRIM(RTRIM(SS.ITEM_ID)) AS ITEM_ID
	    FROM [LGCE_SCMDEV].[dbo].[SCP_ANL_SHIPMENT_PLAN_SEMI] SS  WITH(NOLOCK) --법인간 출하계획
		    LEFT JOIN [LGCE_LOGIPROD].[dbo].[LOGI_MST_COMPANY] m  WITH(NOLOCK)
				    ON LEFT(SS.FROM_SITE,2) = LEFT(m.COMPANY_CODE,2)
	    WHERE SS.MEASURE          = 'SHIP_PLAN_AMEND' -- 수정한 최종 계획
          AND SS.PLAN_START_YYYYMMDD = @THIS_MONDAY   --------------------------------------------------------------------- 수정사항 : 최신 계획일 (월요일 날짜 입력 필요) 수정 필요
          AND SS.QTY               > 0
          AND SS.PLAN_TYPE         = 'FN' -- Final
	      AND SS.SEQ   = (
		    SELECT MAX(SEQ)----------------SEQ 가 가장 높은것
		    FROM [LGCE_SCMDEV].[dbo].[SCP_ANL_SHIPMENT_PLAN_SEMI]  WITH(NOLOCK)
		    WHERE MEASURE          = 'SHIP_PLAN_AMEND' -- 수정한 최종 계획
          AND PLAN_START_YYYYMMDD = @THIS_MONDAY   --------------------------------------------------------------------- 수정사항 : 최신 계획일 (월요일 날짜 입력 필요) 수정 필요
          AND QTY               > 0
          AND PLAN_TYPE         = 'FN' -- Final
	      )

	    UNION


	    SELECT DISTINCT
	        --CASE WHEN LEFT(PP.SCM_SITE_ID,2) not in ('HQ', 'NJ', 'NB', 'WA', 'MI') THEN 'HQ00' ELSE LEFT(PP.SCM_SITE_ID,2) + '00' END AS COMPANY_ID,
            COALESCE(m.COMPANY_CODE, 'HQ00') AS COMPANY_ID, ------------------------------------------- 법인코드 ***
		    LTRIM(RTRIM(PP.DIVISION_ID)) AS DIVISION_ID,
            LTRIM(RTRIM(PP.ITEM_ID)) AS ITEM_ID
        FROM [LGCE_SCMDEV].[dbo].[SCP_ANL_PRODUCTION_PLAN] PP  WITH(NOLOCK)
	    LEFT JOIN [LGCE_LOGIPROD].[dbo].[LOGI_MST_COMPANY] m  WITH(NOLOCK)
				    ON LEFT(PP.SCM_SITE_ID,2) = LEFT(m.COMPANY_CODE,2)
        WHERE PP.MEASURE          = 'PROD_PLAN_ENGINE'
          AND PP.PLAN_START_YYYYMMDD = @THIS_MONDAY   ------------------------------------------------------------------------------ 수정사항 : 최신 계획일 (월요일 날짜 입력 필요) 수정 필요
          AND PP.QTY               > 0
          AND PP.PLAN_TYPE         = 'FN'
	      AND PP.SEQ   = (
		    SELECT MAX(SEQ)----------------SEQ 가 가장 높은것
		    FROM [LGCE_SCMDEV].[dbo].[SCP_ANL_PRODUCTION_PLAN]  WITH(NOLOCK)
		    WHERE MEASURE          = 'PROD_PLAN_ENGINE' -- 수정한 최종 계획
          AND PLAN_START_YYYYMMDD = @THIS_MONDAY   --------------------------------------------------------------------- 수정사항 : 최신 계획일 (월요일 날짜 입력 필요) 수정 필요
          AND QTY               > 0
          AND PLAN_TYPE         = 'FN' -- Final
	      )

    ),

	  /*
	  SELECT *
	  FROM ProdItem */



    ---------- 2️.  BOM & ITEM 테이블과 조인 (중복 제거) --------------------------------------------------
    FINAL AS(

	    SELECT 
		    --TOP 1000                                                                      ------- 수정사항 : Top 1000 삭제 필요 ---------
            PI.DIVISION_ID AS DIVISION_ID,
            PI.COMPANY_ID AS COMPANY_ID,
            BOM.SITE_ID AS SITE_ID,
            PI.ITEM_ID AS ITEM_ID,
		    BOM.PARENT_ITEM_ID AS PARENT_ITEM_ID,
            BOM.CHILD_ITEM_ID AS CHILD_ITEM_ID,
		    ITEM.ITEM_NAME AS ITEM_NAME ,
		    ITEM.ITEM_CLASS_NAME AS ITEM_CLASS_NAME,
		    ITEM.MATERIAL_CLASS_NAME AS MATERIAL_CLASS_NAME
	
	    FROM ProdItem PI
	    LEFT JOIN [LGCE_SCMDEV].[dbo].[SCM_MST_MODEL_BOM] BOM  WITH(NOLOCK) --- 생산계획이 존재하는 Item 리스트 테이블과 BOM 조인
		    ON BOM.COMPANY_ID = PI.COMPANY_ID
	       AND BOM.DIVISION_ID = PI.DIVISION_ID
           AND BOM.MODEL_ID    = PI.ITEM_ID          -- ITEM_ID와 매핑되는 컬럼
        OUTER APPLY (
            SELECT TOP (1)
                   I.ITEM_NAME,
                   I.ITEM_CLASS_NAME,
                   I.MATERIAL_CLASS_NAME
            FROM [LGCE_FP_TR].[dbo].[SCM_ITEM_M] I  WITH(NOLOCK)
            WHERE I.ITEM_ID     = BOM.CHILD_ITEM_ID
            ORDER BY 
                CASE 
                    WHEN I.COMPANY_ID = BOM.COMPANY_ID 
				    AND I.DIVISION_ID = BOM.DIVISION_ID THEN 1  -- 1순위: COMPANY + DIVISION + ITEM 일치
				    WHEN I.DIVISION_ID = BOM.DIVISION_ID THEN 2 -- 2순위: DIVISION + ITEM 일치
				    ELSE 3                                      -- 3순위: ITEM 일치
                END
        ) ITEM


       /*LEFT JOIN [LGCE_FP_TR].[dbo].[SCM_ITEM_M] ITEM
	        ON BOM.COMPANY_ID = ITEM.COMPANY_ID
	       AND BOM.DIVISION_ID = ITEM.DIVISION_ID
	       AND BOM.CHILD_ITEM_ID = ITEM.ITEM_ID */

		    --AND ITEM.ITEM_TYPE = 'R'
		    WHERE 1=1
		    --and PI.COMPANY_ID = 'HQ00'
		    --and PI.ITEM_ID  = 'MACH114030D3'

    )




    ----------------------------------------------
    -- 3. 결과를 테이블에 저장함
    ----------------------------------------------

    INSERT INTO [LGCE_LOGIDEV].[dbo].TB_SCM_LMS_TRK_AI_GATEWAY
	(
        DIVISION_ID          
        , COMPANY_ID         
        , SITE_ID            
        , ITEM_ID            
        , PARENT_ITEM_ID     
        , CHILD_ITEM_ID      
        , ITEM_NAME          
        , ITEM_CLASS_NAME    
        , MATERIAL_CLASS_NAME
        , NICK_NAME          
        , PRODUCT_LEVEL1     
        , PRODUCT_LEVEL2     
        , PRODUCT_LEVEL3         
    )

    SELECT 

	    --TOP (10)

	    f.DIVISION_ID,
	    f.COMPANY_ID,
        f.SITE_ID,
        f.ITEM_ID,
	    f.PARENT_ITEM_ID,
        f.CHILD_ITEM_ID,
	    f.ITEM_NAME ,
	    f.ITEM_CLASS_NAME,
	    f.MATERIAL_CLASS_NAME,
	    pjt.NICK_NAME,
	    pjt.PRODUCT_LEVEL1,
	    pjt.PRODUCT_LEVEL2,
	    pjt.PRODUCT_LEVEL3
    FROM FINAL f
    LEFT JOIN (

	    SELECT A.DIVISION_ID,
		    A.ITEM_ID,
		    CASE
			    WHEN A.DIVISION_ID = '40' THEN NICKNAME_40 ------------Division 코드 변경 시 수정 필요
			    ELSE NICK_NAME
			    END AS NICK_NAME,
		    CASE 
			    WHEN A.DIVISION_ID = '40' THEN A.BASIC_NICKNAME_CELL40
			    WHEN A.DIVISION_ID like '81%' THEN A.GROUP_CODE6
			    WHEN A.DIVISION_ID like '82%' THEN A.GROUP_CODE6
		    END AS PRODUCT_LEVEL1,
		    CASE 
			    WHEN A.DIVISION_ID = '40' THEN A.NICKNAME_40
			    WHEN A.DIVISION_ID like '81%' THEN A.GROUP_CODE7
			    WHEN A.DIVISION_ID like '82%' THEN A.GROUP_CODE7
		    END AS PRODUCT_LEVEL2,
		    CASE 
			    WHEN A.DIVISION_ID = '40' THEN A.GROUP_CODE9
			    WHEN A.DIVISION_ID like '81%' THEN A.GROUP_CODE5
			    WHEN A.DIVISION_ID like '82%' THEN A.GROUP_CODE4
		    END AS PRODUCT_LEVEL3
	    FROM TblGroupCode_SP0080_All A

    ) pjt
	    ON f.DIVISION_ID = pjt.DIVISION_ID
	    AND f.ITEM_ID = pjt.ITEM_ID
	    ORDER BY 
	    DIVISION_ID desc

    ;



    COMMIT TRAN;

    END TRY


    	
   BEGIN CATCH

         IF  @@ERROR != 0
	     BEGIN
                 ROLLBACK TRAN ;
	     END;

   END CATCH


END

