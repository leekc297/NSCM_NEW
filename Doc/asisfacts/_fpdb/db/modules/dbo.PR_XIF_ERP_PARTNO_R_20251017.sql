


CREATE PROCEDURE [dbo].[PR_XIF_ERP_PARTNO_R_1017]

-- ================================================================================================
-- Program ID          : FP00190
-- Program Name        : PR_XIF_ERP_PARTNO_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_PART_NO_R
-- Destination Table   : SCM_ITEM_M, SCM_MODEL_M
--
-- Create(Update) Date : 2016.08.16
-- Update Date		   : 2017.06.21 1.2
--					   : 2017.09.15 1.3	
--						 2018.01.16 1.4
--                       2018.01.28 1.5
--						 2018.04.09 1.6
--						 2018.05.15 1.7
--						 2018.06.25 1.8
--                       2018.10.02 1.9
--						 2018.10.19 1.10
--                       2018.12.24 1.11
--						 2019.03.27 1.12
--						 2019.04.30 2.0
--						 2019.05.24 2.1
--						 2019.10.02 2.2
--						 2020.01.13 2.3
--                       2021.03.03 2.4
--                       2022.03.28 2.6
--                       2022.07.22 2.7

-- Author              : 김 석
-- Version             : 1.1 2017-01-03 kimcd add item toss to RCCP
--						 1.2 2017-06-21 PIYONG ADD CURSOR ORDER BY TERMS
--						 1.3 2017-09-15 PIYONG CUR_ERP_PARTNO CHANGE
--						 1.4 2018-01-16 PIYONG 표준원가, 통화키 추가
--                       1.5 2018-01-28 kimcd 표준원가 금액 조회문장 수정 MAX 값 취함
--						 1.6 2018-04-09 kimjj Energe(kWh) 특성값 추가 (ESS 요청, GSCM Project)
--                       1.7 2018-05-15 kimcd item class의 scp route 정보 갱신 과정 추가
--						 1.8 2018-06-25 kimjj 소형전지 모델 정보 추가 I/F (GSCM Project)
--                       1.9 2018-10-02 kimcd 소형 전지 강제 P 모델 정보 설정
--						 1.10 2018-10-19 PIYONG RCCP 전송 로직 삭제
--                       1.11 2018-12-24 kimcd Item 형성에서 Item Class 기준으로 Flow 자동 형성
--						 1.12 2019-03-27 PIYONG SCP_OPERATION_GROUP_ID, SCP_OPERATION_GROUP 컬럼 자릿수 1 -> 2 변경
--						 2.0 2019-04-30 PIYONG 프로시져 속도 개선
--						 2.1 2019-05-24 PIYONG 같은 자재가 여러 개의 CLASS_CODE로 존재 할수 있는데 변경된 정보가 기초소재인 경우에도 자제 정보가 수신 되어
--											   전지 (CLASS_CODE가 E 시작) 자재만 FP SDB에 적재하기 위해 'ERP_PARTNO_RECEIVE_TYPE' LOOKUP 추가
--											   수신제외 자재 ex) class_code=BMP0605
--						 2.2 PLANT 3050 (청주) 수신 제외
--						 2.3 MDM CELL 수량 수신
--                       2.4 2021-03-03 kimcd  SCM_ITEM_M에 SCP_EXTRA_SPEC 컬럼 추가. SCP LOOKUP 기준으로 값 설정
--						 2.5 2021-12-13 khj79  SCM_ITEM_M에 MAKER 컬럼 추가.
--                       2.6 2022-03-28 kimcd  가상 Division 사용에 따른 로직 수정
--                       2.7 아이템클라스 leeseongmin CODE,CODENAME 추가요청 (주석처리제거)
--                       2.8 2023-06-10 FP Pjt. CELL ASSY(CLASS ES1901) 일 경우 대표모델의 SCP_FLOW_ID 적용
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
--                       2025-01-06 chkim.68 MRP_USE_FLAG (NERP)
--                       2025-06-25 OHIJ	CURSOR를 사용하는 방식에서 TEMP TABLE을 활용한 방식으로 변경
-- ================================================================================================
@IFSEQNO NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_PARTNO_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	-- 2025-06-25 OHIJ	CURSOR를 사용하는 방식에서 TEMP TABLE을 활용한 방식으로 변경 :불필요한 변수 주석처리
	--DECLARE @COMPANY            NVARCHAR(1000)
	--DECLARE @DIVISION           NVARCHAR(1000)
	----DECLARE @PLANT_ID           NVARCHAR(1000)
	--DECLARE @SITE_ID            NVARCHAR(1000)
	--DECLARE @ITEM_ID            NVARCHAR(1000)
	--DECLARE @ITEM_NAME          NVARCHAR(1000)
	--DECLARE @PART_TYPE          NVARCHAR(1000)
	--DECLARE @DISABLE_STATUS     NVARCHAR(1000)
	--DECLARE @DISABLE_DATE       NVARCHAR(1000)
	--DECLARE @VALID              NVARCHAR(1000)
	--DECLARE @MAT_CLASS          NVARCHAR(1000)
	--DECLARE @MAT_CLASS_INFO     NVARCHAR(1000)
	--DECLARE @CLASS_CODE         NVARCHAR(1000)
	--DECLARE @CLASS_NAME         NVARCHAR(1000)
	--DECLARE @EVAL_CLASS         NVARCHAR(1000)
 --   DECLARE @EVAL_CLASS_INFO    NVARCHAR(1000)
	----DECLARE @min_lot_size       NVARCHAR(1000)
	----DECLARE @max_lot_size       NVARCHAR(1000)
	----DECLARE @multiple_lot_size  NVARCHAR(1000)
	--DECLARE @UOM                NVARCHAR(1000)
	--DECLARE @SPEC               NVARCHAR(1000)
	----DECLARE @NICK_NAME          NVARCHAR(1000)
	--DECLARE @REPRESENTIVE_MODEL NVARCHAR(1000)
	--DECLARE @CELL_TYPE NVARCHAR(1000)
	--DECLARE @MAKE_AND_BUY NVARCHAR(10)
	--DECLARE @STANDARD_COST NUMERIC(20, 5)		-- piyong 2018-01-16 add
 --   DECLARE @CURRENCY NVARCHAR(10)				-- piyong 2018-01-16 add
	--DECLARE @ENERGE   NVARCHAR(30)				-- kimjj 2018-04-09 add
	--DECLARE @SCP_FLOW_ID            NVARCHAR(150)	-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
	--DECLARE @SCP_OPERATION_GROUP_ID NVARCHAR(2)	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가	    -- 2019-03-27 PIYONG 자릿수 1->2 변경
	--DECLARE @SCP_OPERATION_GROUP    NVARCHAR(2)	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가    -- 2019-03-27 PIYONG 자릿수 1->2 변경
	--DECLARE @MDM_PROJECT_NAME				NVARCHAR(30)				-- kimjj 2018-06-25 add
	--DECLARE @MIN_CAPACITY 					NVARCHAR(30)				-- kimjj 2018-06-25 add
	--DECLARE @MOBILE_MODEL_ID				NVARCHAR(20)				-- kimjj 2018-06-25 add
	--DECLARE @FORECAST_INFO_BIZ_TYPE			NVARCHAR(10)				-- kimjj 2018-06-25 add
	--DECLARE @FORECAST_INFO_PRODUCT_GROUP	NVARCHAR(10)				-- kimjj 2018-06-25 add
	--DECLARE @FORECAST_INFO_CELL_MODEL		NVARCHAR(30)				-- kimjj 2018-06-25 add
	--DECLARE @FORECAST_INFO_CELL_PACK_COUNT 	NUMERIC(20,10)				-- kimjj 2018-06-25 add
	--DECLARE @FORECAST_INFO_SPEC				NVARCHAR(30)				-- kimjj 2018-06-25 add
	--DECLARE @FORECAST_INFOR_VERSION			NVARCHAR(10)				-- kimjj 2018-06-25 add
	--DECLARE @DOE							NVARCHAR(150)				-- PIYONG 2018-07-05 add	--//CSR ID:3746797
	DECLARE @P_IFSEQNO						NVARCHAR(50) = @IFSEQNO;	-- PIYONG 2019-04-30 add
	--DECLARE @CELL_QUANTITY					NVARCHAR(30)			;	-- PIYONG 2020-01-13 add
	--DECLARE @SCP_EXTRA_SPEC                 NVARCHAR(150)               -- 2021-03-03 kimcd SCP용 부가 속성
	--DECLARE @MAKER							NVARCHAR(30)				-- 2021-12-13 MAKER ADD
	--DECLARE @MRP_ITEM_FLAG                  NVARCHAR(1)                 -- 2025-01-02 chkim.68 ADD NERP
	-- 2025-06-25 OHIJ	CURSOR를 사용하는 방식에서 TEMP TABLE을 활용한 방식으로 변경 :불필요한 변수 주석처리

	--DECLARE CUR_ERP_PARTNO CURSOR FOR


	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================

		SET @P_IFSEQNO = @IFSEQNO;						-- PIYONG 2019-04-30 add
		
		 UPDATE [dbo].[SY_XIF_ERP_PART_NO_R]
			SET TRANSFER_FLAG = 'P'
			    ,TRANSFER_DATE = GETDATE()
		  WHERE TRANSFER_FLAG = 'N'
		    AND IFSEQNO = @P_IFSEQNO					-- PIYONG 2019-04-30 Change @IFSEQNO -> @P_IFSEQNO
		 COMMIT TRAN
 
 	IF OBJECT_ID('tempdb..#TEMP_XIF_ERP_PART_NO_R') IS NOT NULL
		DROP TABLE #TEMP_XIF_ERP_PART_NO_R

		SELECT * 
		INTO #TEMP_XIF_ERP_PART_NO_R
		FROM (
		SELECT X.COMPANY AS COMPANY_ID
			  ,ISNULL(PD.PSEUDO_DIVISION_ID, X.[DIVISION]) AS DIVISION_ID   -- 2022-03-24 kimcd 가상 Division 로직 추가
			  ,X.SITE_ID
		      ,X.ITEM_ID
		      ,X.ITEM_NAME
		      ,CASE WHEN ( SELECT TOP 1 'Y'									-- 2018-10-02 kimcd 소형 전지 강제 P 모델 정보 설정
							 FROM SY_SCM_MST_ALTER_ITEM_TYPE R WITH(NOLOCK)
							WHERE R.MODEL_ID    = X.ITEM_ID
							  AND R.DIVISION_ID = X.DIVISION ) = 'Y' THEN
						'P'
					ELSE
						X.PART_TYPE
					END				AS   PART_TYPE
		      ,X.DISABLE_STATUS
		      ,X.DISABLE_DATE
			  ,CASE WHEN ISNULL ( (SELECT TOP 1 ISNULL(VALID_YN,'Y')  AS C 
							         FROM [dbo].[SY_XIF_ERP_PART_NO_R](NOLOCK) B 
							        WHERE B.IFSEQNO = X.IFSEQNO
									  AND B.ITEM_ID = X.ITEM_ID
									  AND B.TRANSFER_FLAG = 'P'
					                  AND B.COMPANY  = X.COMPANY 
					                  AND B.DIVISION = X.DIVISION
									  AND B.SITE_ID  = X.SITE_ID
					                  AND B.PLANT_ID != X.PLANT_ID
									  AND B.CLASS_CODE = X.CLASS_CODE								-- 2019-05-24 PIYONG ADD END
					                   ), 'X') = 'X' AND VALID_YN = 'X' THEN 'N'
		       ELSE 'Y'
		        END AS VALID_YN
		      ,X.CLASS_CODE
		      ,X.CLASS_NAME -- 2018-05-15 kimcd SCM_ITEM_CLASS_M outer join 추가하여 테이블 이름 추가
		      --,min_lot_size
		      --,max_lot_size
		      --,multiple_lot_size
		      ,X.UOM
		      ,X.SPEC
			  --,NICK_NAME
			  ,X.EVAL_CLASS
			  ,X.EVAL_CLASS_INFO
			  ,X.MAT_CLASS
			  ,X.MAT_CLASS_INFO
			  ,X.REPRESENTIVE_MODEL
			  ,X.CELL_TYPE
			  ,CASE WHEN ISNULL ( X.MAKE_AND_BUY, (SELECT TOP 1 MAKE_AND_BUY  AS C 
												   FROM [dbo].[SY_XIF_ERP_PART_NO_R](NOLOCK) B 
												  WHERE B.IFSEQNO = X.IFSEQNO
													AND B.ITEM_ID = X.ITEM_ID
													AND B.TRANSFER_FLAG = 'P'
													AND B.COMPANY  = X.COMPANY 
													AND B.DIVISION = X.DIVISION
													AND B.SITE_ID  = X.SITE_ID
													AND B.PLANT_ID != X.PLANT_ID													
													AND B.MAKE_AND_BUY  = 'Y'
												    AND B.CLASS_CODE  = X.CLASS_CODE								-- 2019-05-24 PIYONG ADD END
																				) ) = 'Y' THEN 'Y'
					ELSE NULL
				END AS MAKE_AND_BUY
			  ,MAX(X.STANDARD_COST) OVER (PARTITION BY X.IFSEQNO, X.DIVISION, X.SITE_ID, X.ITEM_ID) AS STANDARD_COST	-- piyong 2018-01-16 add  2018-01-28 kimcd max 값 취하도록 조회문 수정
			  ,X.[CURRENCY]						-- piyong 2018-01-16 add
			  ,X.[ENERGE]							-- kimjj 2018-04-09 add
			  --,CASE WHEN X.CLASS_CODE = 'ES1901' THEN ( SELECT SCP_FLOW_ID FROM SCM_ITEM_M WITH(NOLOCK) WHERE COMPANY_ID = X.COMPANY AND DIVISION_ID = ISNULL(PD.PSEUDO_DIVISION_ID, X.[DIVISION]) AND SITE_ID = X.SITE_ID AND ITEM_ID = X.REPRESENTIVE_MODEL)
			  --      ELSE C.SCP_FLOW_ID END AS SCP_FLOW_ID					-- CELL ASSY(CLASS ES1901) 일 경우 대표모델의 SCP_FLOW_ID 적용
			  ,CASE WHEN X.CLASS_CODE = 'ES1901' AND X.CELL_TYPE = 'CYLINDRICAL' THEN 'A3000' ELSE C.SCP_FLOW_ID END AS SCP_FLOW_ID					-- CELL ASSY(CLASS ES1901) 일 경우 대표모델의 SCP_FLOW_ID 적용
			  ,C.SCP_OPERATION_GROUP_ID			-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			  ,C.SCP_OPERATION_GROUP			-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			  ,X.MDM_PROJECT_NAME 				-- kimjj 2018-06-25 add
			  ,X.MIN_CAPACITY 					-- kimjj 2018-06-25 add
			  ,X.MOBILE_MODEL_ID 					-- kimjj 2018-06-25 add
			  ,X.FORECAST_INFO_BIZ_TYPE			-- kimjj 2018-06-25 add
			  ,X.FORECAST_INFO_PRODUCT_GROUP		-- kimjj 2018-06-25 add
			  ,X.FORECAST_INFO_CELL_MODEL			-- kimjj 2018-06-25 add
			  ,X.FORECAST_INFO_CELL_PACK_COUNT	-- kimjj 2018-06-25 add
			  ,X.FORECAST_INFO_SPEC 				-- kimjj 2018-06-25 add
			  ,X.FORECAST_INFOR_VERSION 			-- kimjj 2018-06-25 add
			  ,X.DOE								-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
			  ,X.CELL_QUANTITY					-- PIYONG 2020-01-13 ADD
			  ,(SELECT   TOP 1
						 CASE WHEN SLV.SEGMENT2 = 'ITEM_CLASS' THEN
								  SLV.ATTRIBUTE1
							  WHEN SLV.SEGMENT2 = 'FORECAST_INFO_SPEC' THEN
								  CASE WHEN case when X.CLASS_CODE = 'ES1901' then IM.FORECAST_INFO_SPEC else X.FORECAST_INFO_SPEC end = SLV.SEGMENT3 THEN
									  SLV.ATTRIBUTE1
								  END
						 END
				FROM     SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
				WHERE    SLV.LOOKUP_TYPE_CODE = 'SCP_EXTRA_SPEC'
				AND      SLV.ACTIVE_FLAG = 'Y'
				AND      SLV.SEGMENT1 = case when X.CLASS_CODE = 'ES1901' then IM.ITEM_CLASS else x.class_code end
				ORDER BY 1 DESC )             AS SCP_EXTRA_SPEC   -- 2021-03-03 kimcd SCP용 부가 속성
			  ,X.MAKER												-- 2021-12-13 khj79 ADD
			  ,X.MRP_ITEM_FLAG                                        -- 2025-01-02 chkim.68 add (NERP)
			  ,ROW_NUMBER() OVER ( PARTITION BY X.COMPANY, ISNULL(PD.PSEUDO_DIVISION_ID, X.[DIVISION]), X.SITE_ID, X.ITEM_ID ORDER BY CASE WHEN X.PART_TYPE IS NULL THEN 2 ELSE 1 END, X.PART_TYPE DESC ) AS ROW_NUM
		 FROM [dbo].[SY_XIF_ERP_PART_NO_R] X WITH(NOLOCK)
			  LEFT OUTER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)
						   ON C.CLASS_ID = X.CLASS_CODE		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			---------------------------------------------------------------------------------------------
															-- 2019-05-24 PIYONG ADD
			  INNER JOIN SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
					  ON SLV.LOOKUP_TYPE_CODE = 'ERP_PARTNO_RECEIVE_TYPE' 
					 AND SLV.SEGMENT1 = X.DIVISION
					 AND SLV.SEGMENT2 = SUBSTRING(X.CLASS_CODE, 1, 1)
					 AND SLV.ACTIVE_FLAG = 'Y'
															-- 2019-05-24 PIYONG ADD END
			---------------------------------------------------------------------------------------------
			  LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
						   ON PD.PLANT_ID = X.PLANT_ID
			  LEFT OUTER JOIN SCM_ITEM_M IM WITH(NOLOCK)
						   ON IM.COMPANY_ID = X.COMPANY
						  AND IM.division_id = ISNULL(PD.PSEUDO_DIVISION_ID, X.[DIVISION])
						  AND IM.SITE_ID = X.SITE_ID
						  AND IM.ITEM_ID = X.REPRESENTIVE_MODEL

		WHERE TRANSFER_FLAG = 'P'
		  AND IFSEQNO = @P_IFSEQNO							-- PIYONG 2019-04-30 Change @IFSEQNO -> @P_IFSEQNO
		  -- 하드코딩 전환
		  -- AND X.PLANT_ID != '3050'							-- PIYONG 2019-10-02 ADD
		  AND X.PLANT_ID not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_ERP_PARTNO_R' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y') 	-- PIYONG 2019-10-02 ADD
		)A
		WHERE ROW_NUM = 1
		ORDER BY CASE WHEN A.PART_TYPE IS NULL THEN 2
							   ELSE 1
							   END, A.PART_TYPE DESC
	;
	
	SET @ROWCOUNT = @@ROWCOUNT

		BEGIN TRAN
		  -- PARTNO 정보 추가
		  
		  UPDATE SCM_ITEM_M
		  SET
		  COMPANY_ID							= B.COMPANY_ID
		  , DIVISION_ID							= B.DIVISION_ID
		  , ITEM_NAME							= B.ITEM_NAME
		  , ITEM_TYPE							= B.PART_TYPE							
		  , ITEM_CLASS							= B.CLASS_CODE
		  , ITEM_CLASS_NAME						= B.CLASS_NAME
		  , MATERIAL_CLASS						= B.MAT_CLASS 
		  , MATERIAL_CLASS_NAME					= B.MAT_CLASS_INFO
		  , ERP_EOL								= B.DISABLE_DATE     
		  , ITEM_UOM							= B.UOM 
		  , SPEC								= B.SPEC
		  , EVAL_CLASS							= B.EVAL_CLASS                    
		  , EVAL_CLASS_INFO						= B.EVAL_CLASS_INFO               
		  , ACTIVE_FLAG							= B.VALID_YN
		  , APPLIED_MODEL						= B.REPRESENTIVE_MODEL
		  , UPDATE_ID							= @v_proc_name
		  , UPDATE_TIME							= GETDATE()
		  , CELL_TYPE							= B.CELL_TYPE
		  , MAKE_AND_BUY						= B.MAKE_AND_BUY
		  , STANDARD_COST						= B.STANDARD_COST					-- piyong 2018-01-16 add
		  , CURRENCY							= B.CURRENCY						-- piyong 2018-01-16 add
		  , ENERGE								= B.ENERGE			-- kimjj 2018-04-09 add
		  , SCP_FLOW_ID							= B.SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
		  , SCP_OPERATION_GROUP_ID				= B.SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
		  , SCP_OPERATION_GROUP					= B.SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
		  , MDM_PROJECT_NAME 					= B.MDM_PROJECT_NAME 		 		-- kimjj 2018-06-25 add
		  , MIN_CAPACITY 						= B.MIN_CAPACITY 				-- kimjj 2018-06-25 add
		  , MOBILE_MODEL_ID 					= B.MOBILE_MODEL_ID 				-- kimjj 2018-06-25 add
		  , FORECAST_INFO_BIZ_TYPE 				= B.FORECAST_INFO_BIZ_TYPE 		-- kimjj 2018-06-25 add
		  , FORECAST_INFO_PRODUCT_GROUP 		= B.FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
		  , FORECAST_INFO_CELL_MODEL 			= B.FORECAST_INFO_CELL_MODEL 	-- kimjj 2018-06-25 add
		  , FORECAST_INFO_CELL_PACK_COUNT 		= B.FORECAST_INFO_CELL_PACK_COUNT-- kimjj 2018-06-25 add
		  , FORECAST_INFO_SPEC 					= B.FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
		  , FORECAST_INFOR_VERSION 				= B.FORECAST_INFOR_VERSION 		-- kimjj 2018-06-25 add
		  , DOE 								= B.DOE					-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
		  , FLOW_ID								= ISNULL(A.FLOW_ID, B.SCP_FLOW_ID) -- 2018-12-24 kimcd FLOW ID 없는 경우 ITEM CLASS 기준 기본 값 설정
		  , CELL_QUANTITY						= B.CELL_QUANTITY					-- PIYONG 2020-01-13 ADD
		  , SCP_EXTRA_SPEC						= ISNULL(A.SCP_EXTRA_SPEC, B.SCP_EXTRA_SPEC)         -- 2021-03-03 kimcd SCP용 부가 속성
		  , MAKER								= B.MAKER										-- 2021-12-13 khj79 ADD
		  , MRP_USE_FLAG						= LEFT(B.MRP_ITEM_FLAG,1)
		  FROM SCM_ITEM_M A, #TEMP_XIF_ERP_PART_NO_R B
		  WHERE 1=1
		  AND A.COMPANY_ID = B.COMPANY_ID
		  AND A.DIVISION_ID = B.DIVISION_ID
		  AND A.SITE_ID = B.SITE_ID
		  AND A.ITEM_ID = B.ITEM_ID


		  INSERT INTO SCM_ITEM_M (
			COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,ITEM_ID
			,ITEM_NAME
			,ITEM_TYPE
			,ITEM_CLASS
			,ITEM_CLASS_NAME
			,MATERIAL_CLASS
			,MATERIAL_CLASS_NAME
			,ERP_EOL
			,ITEM_UOM
			,SPEC
			,EVAL_CLASS                 -- leeseongmin 2022-07-22 add
			,EVAL_CLASS_INFO            -- leeseongmin 2022-07-22 add
			,ACTIVE_FLAG
			,APPLIED_MODEL
			,INSERT_ID
			,INSERT_TIME
			,UPDATE_ID
			,UPDATE_TIME
			,CELL_TYPE
			,MAKE_AND_BUY
  			,STANDARD_COST				-- piyong 2018-01-16 add
			,CURRENCY						-- piyong 2018-01-16 add
			,ENERGE						-- kimjj 2018-04-09 add
			,SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			,SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			,SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			,MDM_PROJECT_NAME 			-- kimjj 2018-06-25 add
			,MIN_CAPACITY 				-- kimjj 2018-06-25 add
			,MOBILE_MODEL_ID 				-- kimjj 2018-06-25 add
			,FORECAST_INFO_BIZ_TYPE 		-- kimjj 2018-06-25 add
			,FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
			,FORECAST_INFO_CELL_MODEL 	-- kimjj 2018-06-25 add
			,FORECAST_INFO_CELL_PACK_COUNT-- kimjj 2018-06-25 add
			,FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
			,FORECAST_INFOR_VERSION 		-- kimjj 2018-06-25 add
			,DOE							-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
			,FLOW_ID                      -- 2018-12-24 kimcd FLOW ID 없는 경우 ITEM CLASS 기준 기본 값 설정
			,CELL_QUANTITY				-- PIYONG 2020-01-13 ADD
			,SCP_EXTRA_SPEC               -- 2021-03-03 kimcd SCP용 부가 속성
			,MAKER						-- 2021-12-13 khj79 ADD
			,MRP_USE_FLAG                -- 2025-01-02 chkim.68 ADD       
		  )
		  SELECT 
			A.COMPANY_ID
			,A.DIVISION_ID
			,A.SITE_ID
			,A.ITEM_ID
			,A.ITEM_NAME    
			,A.PART_TYPE     
			,A.CLASS_CODE
			,A.CLASS_NAME
			,A.MAT_CLASS
			,A.MAT_CLASS_INFO   
			,A.DISABLE_DATE      
			,A.UOM               
			,A.SPEC
			,A.EVAL_CLASS                   -- leeseongmin 2022-07-22 add
			,A.EVAL_CLASS_INFO              -- leeseongmin 2022-07-22 add
			,A.VALID_YN
			,A.REPRESENTIVE_MODEL
			,@v_proc_name
			,GETDATE()
			,@v_proc_name
			,GETDATE()
			,A.CELL_TYPE
			,A.MAKE_AND_BUY
			,A.STANDARD_COST					-- piyong 2018-01-16 add
			,A.CURRENCY						-- piyong 2018-01-16 add
			,A.ENERGE						-- kimjj 2018-04-09 add
			,A.SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			,A.SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			,A.SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
			,A.MDM_PROJECT_NAME				-- kimjj 2018-06-25 add
			,A.MIN_CAPACITY 					-- kimjj 2018-06-25 add
			,A.MOBILE_MODEL_ID				-- kimjj 2018-06-25 add
			,A.FORECAST_INFO_BIZ_TYPE		-- kimjj 2018-06-25 add
			,A.FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
			,A.FORECAST_INFO_CELL_MODEL		-- kimjj 2018-06-25 add
			,A.FORECAST_INFO_CELL_PACK_COUNT -- kimjj 2018-06-25 add
			,A.FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
			,A.FORECAST_INFOR_VERSION		-- kimjj 2018-06-25 add
			,A.DOE							-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
			,A.SCP_FLOW_ID                   -- 2018-12-24 kimcd FLOW ID 없는 경우 ITEM CLASS 기준 기본 값 설정
			,A.CELL_QUANTITY					-- PIYONG 2020-01-13 ADD
			,A.SCP_EXTRA_SPEC                -- 2021-03-03 kimcd SCP용 부가 속성
			,A.MAKER							-- 2021-12-13 khj79 ADD
			,LEFT(A.MRP_ITEM_FLAG, 1)   AS MRP_ITEM_FLAG              -- 2025-01-02 chkim.68 ADD NERP
		  FROM #TEMP_XIF_ERP_PART_NO_R A
		  WHERE 1=1
		  AND  NOT EXISTS ( SELECT 1
							FROM SCM_ITEM_M B
							WHERE 1=1
							AND A.COMPANY_ID = B.COMPANY_ID
							AND A.DIVISION_ID = B.DIVISION_ID
							AND A.SITE_ID = B.SITE_ID
							AND A.ITEM_ID = B.ITEM_ID
							)
					
					--MERGE INTO [dbo].[SCM_ITEM_M] SIM
					--USING ( SELECT @COMPANY         AS COMPANY
					--              ,@DIVISION        AS DIVISION
					--              ,@SITE_ID         AS SITE_ID
					--              ,@ITEM_ID         AS ITEM_ID
					--	  ) XXX
					--ON (   SIM.ITEM_ID        = XXX.ITEM_ID
					--   AND SIM.COMPANY_ID     = XXX.COMPANY
					--   AND SIM.DIVISION_ID    = XXX.DIVISION
					--   AND SIM.SITE_ID        = XXX.SITE_ID
					--   )
					--WHEN MATCHED THEN
					--	UPDATE SET   SIM.COMPANY_ID						= @COMPANY
					--				,SIM.DIVISION_ID					= @DIVISION
					--				,SIM.ITEM_NAME						= @ITEM_NAME
					--				,SIM.ITEM_TYPE						= @PART_TYPE							
					--				,SIM.ITEM_CLASS						= @CLASS_CODE
					--				,SIM.ITEM_CLASS_NAME				= @CLASS_NAME
					--				,SIM.MATERIAL_CLASS					= @MAT_CLASS 
					--				,SIM.MATERIAL_CLASS_NAME			= @MAT_CLASS_INFO
					--				,SIM.ERP_EOL						= @DISABLE_DATE     
					--				,SIM.ITEM_UOM						= @UOM 
					--				,SIM.SPEC							= @SPEC
					--				,SIM.EVAL_CLASS						= @EVAL_CLASS                    -- leeseongmin 2022-07-22 add
					--				,SIM.EVAL_CLASS_INFO				= @EVAL_CLASS_INFO               -- leeseongmin 2022-07-22 add
					--				,SIM.ACTIVE_FLAG					= @VALID
					--				,SIM.APPLIED_MODEL					= @REPRESENTIVE_MODEL
					--				,SIM.UPDATE_ID						= @v_proc_name
					--				,SIM.UPDATE_TIME					= GETDATE()
					--				,SIM.CELL_TYPE						= @CELL_TYPE
					--				,SIM.MAKE_AND_BUY					= @MAKE_AND_BUY
					--				,SIM.STANDARD_COST					= @STANDARD_COST					-- piyong 2018-01-16 add
					--				,SIM.CURRENCY						= @CURRENCY						-- piyong 2018-01-16 add
					--				,SIM.ENERGE							= @ENERGE			-- kimjj 2018-04-09 add
					--				,SIM.SCP_FLOW_ID					= @SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--				,SIM.SCP_OPERATION_GROUP_ID			= @SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--				,SIM.SCP_OPERATION_GROUP			= @SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--				,SIM.MDM_PROJECT_NAME 				= @MDM_PROJECT_NAME 		 		-- kimjj 2018-06-25 add
					--				,SIM.MIN_CAPACITY 					= @MIN_CAPACITY 				-- kimjj 2018-06-25 add
					--				,SIM.MOBILE_MODEL_ID 				= @MOBILE_MODEL_ID 				-- kimjj 2018-06-25 add
					--				,SIM.FORECAST_INFO_BIZ_TYPE 		= @FORECAST_INFO_BIZ_TYPE 		-- kimjj 2018-06-25 add
					--				,SIM.FORECAST_INFO_PRODUCT_GROUP 	= @FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
					--				,SIM.FORECAST_INFO_CELL_MODEL 		= @FORECAST_INFO_CELL_MODEL 	-- kimjj 2018-06-25 add
					--				,SIM.FORECAST_INFO_CELL_PACK_COUNT 	= @FORECAST_INFO_CELL_PACK_COUNT-- kimjj 2018-06-25 add
					--				,SIM.FORECAST_INFO_SPEC 			= @FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
					--				,SIM.FORECAST_INFOR_VERSION 		= @FORECAST_INFOR_VERSION 		-- kimjj 2018-06-25 add
					--				,SIM.DOE 							= @DOE					-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
					--				,SIM.FLOW_ID                        = ISNULL(SIM.FLOW_ID, @SCP_FLOW_ID) -- 2018-12-24 kimcd FLOW ID 없는 경우 ITEM CLASS 기준 기본 값 설정
					--				,SIM.CELL_QUANTITY					= @CELL_QUANTITY					-- PIYONG 2020-01-13 ADD
					--				,SIM.SCP_EXTRA_SPEC                 = ISNULL(SIM.SCP_EXTRA_SPEC, @SCP_EXTRA_SPEC)         -- 2021-03-03 kimcd SCP용 부가 속성
					--				,SIM.MAKER							= @MAKER										-- 2021-12-13 khj79 ADD
					--				,SIM.MRP_USE_FLAG                 = @MRP_ITEM_FLAG
					                
					--WHEN NOT MATCHED THEN
					--	INSERT (   COMPANY_ID
					--		      ,DIVISION_ID
					--		      ,SITE_ID
					--		      ,ITEM_ID
					--		      ,ITEM_NAME
					--			  ,ITEM_TYPE
					--		 --     ,ITEM_CLASS_LEVEL_1
					--		 --     ,ITEM_CLASS_LEVEL_2
					--		 --     ,ITEM_CLASS_LEVEL_3
					--		 --     ,ITEM_CLASS_LEVEL_4
					--			  ,ITEM_CLASS
					--			  ,ITEM_CLASS_NAME
					--			  ,MATERIAL_CLASS
					--			  ,MATERIAL_CLASS_NAME
					--		      ,ERP_EOL
					--		      ,ITEM_UOM
					--		      ,SPEC
					--			  --,NICK_NAME
					--	            ,EVAL_CLASS                 -- leeseongmin 2022-07-22 add
					--				,EVAL_CLASS_INFO            -- leeseongmin 2022-07-22 add
					--		      --,MIN_LOT_SIZE
					--		      --,INCREMENT_LOT_SIZE
					--			  ,ACTIVE_FLAG
					--			  ,APPLIED_MODEL
					--		      ,INSERT_ID
					--		      ,INSERT_TIME
					--		      ,UPDATE_ID
					--		      ,UPDATE_TIME
					--			  ,CELL_TYPE
					--			  ,MAKE_AND_BUY
  			--					  ,STANDARD_COST				-- piyong 2018-01-16 add
					--			  ,CURRENCY						-- piyong 2018-01-16 add
					--			  ,ENERGE						-- kimjj 2018-04-09 add
					--			  ,SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--			  ,SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--			  ,SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--			  ,MDM_PROJECT_NAME 			-- kimjj 2018-06-25 add
					--			  ,MIN_CAPACITY 				-- kimjj 2018-06-25 add
					--			  ,MOBILE_MODEL_ID 				-- kimjj 2018-06-25 add
					--			  ,FORECAST_INFO_BIZ_TYPE 		-- kimjj 2018-06-25 add
					--			  ,FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
					--			  ,FORECAST_INFO_CELL_MODEL 	-- kimjj 2018-06-25 add
					--			  ,FORECAST_INFO_CELL_PACK_COUNT-- kimjj 2018-06-25 add
					--			  ,FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
					--			  ,FORECAST_INFOR_VERSION 		-- kimjj 2018-06-25 add
					--			  ,DOE							-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
					--			  ,FLOW_ID                      -- 2018-12-24 kimcd FLOW ID 없는 경우 ITEM CLASS 기준 기본 값 설정
					--			  ,CELL_QUANTITY				-- PIYONG 2020-01-13 ADD
					--			  ,SCP_EXTRA_SPEC               -- 2021-03-03 kimcd SCP용 부가 속성
					--			  ,MAKER						-- 2021-12-13 khj79 ADD
					--			  ,MRP_USE_FLAG                -- 2025-01-02 chkim.68 ADD
					--		   )
					--	VALUES (     @COMPANY
					--				,@DIVISION
					--				,@SITE_ID
					--				,@ITEM_ID
					--				,@ITEM_NAME    
					--				,@PART_TYPE    
					--		--		,dbo.[fn_get_class_cd](@CLASS_NAME,1)             
					--		--		,dbo.[fn_get_class_cd](@CLASS_NAME,2)      
					--		--		,dbo.[fn_get_class_cd](@CLASS_NAME,3)        
					--		--		,dbo.[fn_get_class_cd](@CLASS_NAME,4)   
					--				,@CLASS_CODE
					--				,@CLASS_NAME
					--				,@MAT_CLASS
					--				,@MAT_CLASS_INFO   
					--				,@DISABLE_DATE      
					--				,@UOM               
					--				,@SPEC
					--				--,@NICK_NAME
					--	            ,@EVAL_CLASS                   -- leeseongmin 2022-07-22 add
					--				,@EVAL_CLASS_INFO              -- leeseongmin 2022-07-22 add
					--				--,@min_lot_size      
					--				--,@multiple_lot_size 
					--				,@VALID
					--				,@REPRESENTIVE_MODEL
					--				,@v_proc_name
					--				,GETDATE()
					--				,@v_proc_name
					--				,GETDATE()
					--				,@CELL_TYPE
					--				,@MAKE_AND_BUY
					--				,@STANDARD_COST					-- piyong 2018-01-16 add
					--			    ,@CURRENCY						-- piyong 2018-01-16 add
					--				,@ENERGE						-- kimjj 2018-04-09 add
					--				,@SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--				,@SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--				,@SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--				,@MDM_PROJECT_NAME				-- kimjj 2018-06-25 add
					--				,@MIN_CAPACITY 					-- kimjj 2018-06-25 add
					--				,@MOBILE_MODEL_ID				-- kimjj 2018-06-25 add
					--				,@FORECAST_INFO_BIZ_TYPE		-- kimjj 2018-06-25 add
					--				,@FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
					--				,@FORECAST_INFO_CELL_MODEL		-- kimjj 2018-06-25 add
					--				,@FORECAST_INFO_CELL_PACK_COUNT -- kimjj 2018-06-25 add
					--				,@FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
					--				,@FORECAST_INFOR_VERSION		-- kimjj 2018-06-25 add
					--				,@DOE							-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
					--				,@SCP_FLOW_ID                   -- 2018-12-24 kimcd FLOW ID 없는 경우 ITEM CLASS 기준 기본 값 설정
					--				,@CELL_QUANTITY					-- PIYONG 2020-01-13 ADD
					--				,@SCP_EXTRA_SPEC                -- 2021-03-03 kimcd SCP용 부가 속성
					--				,@MAKER							-- 2021-12-13 khj79 ADD
					--				,@MRP_ITEM_FLAG                 -- 2025-01-02 chkim.68 ADD NERP
					--		   );  	

 
 		  UPDATE SCM_MODEL_M
		  SET
		  COMPANY_ID							= B.COMPANY_ID
		  , DIVISION_ID							= B.DIVISION_ID
		  , ITEM_NAME							= B.ITEM_NAME
		  , ITEM_CLASS							= DBO.[FN_GET_CLASS_CD](B.CLASS_NAME,0)  
		  , DESCRIPTION							= B.CLASS_NAME         
		  , ACTIVE_FLAG							= B.VALID_YN
		  , MAKE_AND_BUY						= B.MAKE_AND_BUY
		  , UPDATE_ID							= @v_proc_name
		  , UPDATE_TIME							= GETDATE()
		  FROM SCM_MODEL_M A, #TEMP_XIF_ERP_PART_NO_R B
		  WHERE 1=1
		  AND A.COMPANY_ID = B.COMPANY_ID
		  AND A.DIVISION_ID = B.DIVISION_ID
		  AND A.SITE_ID = B.SITE_ID
		  AND A.ITEM_ID = B.ITEM_ID
		  AND B.PART_TYPE = 'P'

		  INSERT INTO SCM_MODEL_M (
			COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,ITEM_ID
			,ITEM_NAME
			,ITEM_CLASS
			,DESCRIPTION
			,ACTIVE_FLAG
			,MAKE_AND_BUY    
			,INSERT_ID
			,INSERT_TIME
			,UPDATE_ID
			,UPDATE_TIME
		  )
		  SELECT 
			A.COMPANY_ID
			,A.DIVISION_ID
			,A.SITE_ID
			,A.ITEM_ID
			,A.ITEM_NAME  
			, DBO.[FN_GET_CLASS_CD](A.CLASS_NAME,0)   AS ITEM_CLASS
			,A.CLASS_NAME	AS DESCRIPTION   
			,A.VALID_YN AS ACTIVE_FLAG
			,A.MAKE_AND_BUY
			,@v_proc_name
			,GETDATE()
			,@v_proc_name
			,GETDATE()
		  FROM #TEMP_XIF_ERP_PART_NO_R A
		  WHERE 1=1
		  AND  A.PART_TYPE = 'P'
		  AND  NOT EXISTS ( SELECT 1
							FROM SCM_MODEL_M B
							WHERE 1=1
							AND A.COMPANY_ID = B.COMPANY_ID
							AND A.DIVISION_ID = B.DIVISION_ID
							AND A.SITE_ID = B.SITE_ID
							AND A.ITEM_ID = B.ITEM_ID
							)

				 --IF @PART_TYPE = 'P'
					--MERGE INTO DBO.SCM_MODEL_M SMM
					--USING ( SELECT @COMPANY         AS COMPANY
					--				,@DIVISION        AS DIVISION
					--				,@SITE_ID         AS SITE_ID
					--				,@ITEM_ID         AS ITEM_ID
					--				) XXX
					--ON (   SMM.ITEM_ID        = XXX.ITEM_ID
					--	AND SMM.DIVISION_ID    = XXX.DIVISION
					--	AND SMM.SITE_ID        = XXX.SITE_ID
					--	AND SMM.COMPANY_ID     = XXX.COMPANY
					--	)	
					--WHEN MATCHED THEN
					--	UPDATE SET   SMM.COMPANY_ID                        = @COMPANY
					--							,SMM.DIVISION_ID           = @DIVISION
					--							,SMM.ITEM_NAME             = @ITEM_NAME
					--							,SMM.ITEM_CLASS            = DBO.[FN_GET_CLASS_CD](@CLASS_NAME,0)  
					--							,SMM.DESCRIPTION           = @CLASS_NAME
					--							,SMM.ACTIVE_FLAG           = @VALID
					--							,SMM.MAKE_AND_BUY          = @MAKE_AND_BUY
					--							,SMM.UPDATE_ID             = @V_PROC_NAME
					--							,SMM.UPDATE_TIME           = GETDATE()
              
					--WHEN NOT MATCHED THEN
					--	INSERT (   COMPANY_ID
					--				,DIVISION_ID
					--				,SITE_ID
					--				,ITEM_ID
					--				,ITEM_NAME
					--				,ITEM_CLASS
					--				,DESCRIPTION
					--				,ACTIVE_FLAG
					--				,MAKE_AND_BUY
					--				,INSERT_ID
					--				,INSERT_TIME
					--				,UPDATE_ID
					--				,UPDATE_TIME
					--			)
					--	VALUES (     @COMPANY
					--				,@DIVISION
					--				,@SITE_ID
					--				,@ITEM_ID
					--				,@ITEM_NAME    
					--				,DBO.[FN_GET_CLASS_CD](@CLASS_NAME,0)  
					--				,@CLASS_NAME
					--				,@VALID
					--				,@MAKE_AND_BUY
					--				,@V_PROC_NAME
					--				,GETDATE()
					--				,@V_PROC_NAME
					--				,GETDATE()
					--			);  	 

					--  FETCH NEXT FROM CUR_ERP_PARTNO INTO    @COMPANY          
					--							            ,@DIVISION   
					--					              		,@SITE_ID           
					--					             		--,@PLANT_ID         
					--						             	,@ITEM_ID          
					--					            		,@ITEM_NAME        
					--						            	,@PART_TYPE            
					--						            	,@DISABLE_STATUS   
					--					            		,@DISABLE_DATE     
					--					             		,@VALID           
					--					             		,@CLASS_CODE       
					--						            	,@CLASS_NAME       
					--						             	--,@min_lot_size     
					--										--,@max_lot_size     
					--										--,@multiple_lot_size
					--										,@UOM              
					--										,@SPEC 
					--										--,@NICK_NAME
					--										,@EVAL_CLASS                   -- leeseongmin 2022-07-22 add
					--										,@EVAL_CLASS_INFO              -- leeseongmin 2022-07-22 add
					--										,@MAT_CLASS
					--										,@MAT_CLASS_INFO
					--										,@REPRESENTIVE_MODEL
					--							            ,@CELL_TYPE
					--										,@MAKE_AND_BUY
					--										,@STANDARD_COST				-- piyong 2018-01-16 add
					--										,@CURRENCY					-- piyong 2018-01-16 add
					--										,@ENERGE					-- kimjj 2018-04-09 add
					--										,@SCP_FLOW_ID					-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--										,@SCP_OPERATION_GROUP_ID 	    -- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--										,@SCP_OPERATION_GROUP    		-- 2018-05-15 kimcd SCP 기본 Route 정보 추가
					--										,@MDM_PROJECT_NAME 				-- kimjj 2018-06-25 add
					--										,@MIN_CAPACITY 					-- kimjj 2018-06-25 add
					--										,@MOBILE_MODEL_ID				-- kimjj 2018-06-25 add
					--										,@FORECAST_INFO_BIZ_TYPE		-- kimjj 2018-06-25 add
					--										,@FORECAST_INFO_PRODUCT_GROUP 	-- kimjj 2018-06-25 add
					--										,@FORECAST_INFO_CELL_MODEL		-- kimjj 2018-06-25 add
					--										,@FORECAST_INFO_CELL_PACK_COUNT -- kimjj 2018-06-25 add
					--										,@FORECAST_INFO_SPEC 			-- kimjj 2018-06-25 add
					--										,@FORECAST_INFOR_VERSION		-- kimjj 2018-06-25 add
					--										,@DOE							-- PIYONG 2018-07-05 ADD		--//CSR ID:3746797
					--										,@CELL_QUANTITY					-- PIYONG 2020-01-13 ADD
					--										,@SCP_EXTRA_SPEC                -- 2021-03-03 kimcd SCP용 부가 속성
					--										,@MAKER							-- khj79 2021-12-13 khj79 ADD
					--										,@MRP_ITEM_FLAG                 -- chkim.68 2025-01-02 chkim.68 NERP
					--							;   
												
												          

		  --END;
		  --CLOSE CUR_ERP_PARTNO;
		  --DEALLOCATE CUR_ERP_PARTNO;
		COMMIT TRAN
      	  
		BEGIN TRAN
		 UPDATE [dbo].[SY_XIF_ERP_PART_NO_R]
			SET TRANSFER_FLAG = 'Y'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE TRANSFER_FLAG = 'P'
		    AND IFSEQNO = @P_IFSEQNO;							-- PIYONG 2019-04-30 Change @IFSEQNO -> @P_IFSEQNO  
		COMMIT TRAN

		BEGIN TRAN           
			-- 남경 생산 모델이지만, MDM에 R로 되어 있어서 P로 변경 함. 임시..
			UPDATE DBO.SCM_ITEM_M
			   SET ITEM_TYPE = 'P'
			 WHERE ITEM_ID = 'ACEN1053I-A1'
			   AND SITE_ID = 'A002'


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		IF OBJECT_ID('tempdb..#TEMP_XIF_ERP_PART_NO_R') IS NOT NULL
			DROP TABLE #TEMP_XIF_ERP_PART_NO_R

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

