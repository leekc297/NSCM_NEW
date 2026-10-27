 

CREATE PROCEDURE [dbo].[PR_SCM_RELEASE_PLAN_SEND]

/* ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_RELEASE_PLAN_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : RELEASE 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2017.12.26
-- Update Date		   : 2018.11.18 1.1
--						 2018.11.15 1.2
--						 2018.11.23 PIYONG 2.0
--                       2019.01.02 2.1
--						 2019.01.08 3.0
--						 2019.03.11 PIYONG 3.1 
--						 2020.01.21 PIYONG 4.0
--                       2021.06.04 kimcd  4.1

-- Author              : 
-- Version             : 1.0
--						 1.1 look_up RELEASE_RESULT_MAIL ->  SMS_ADDRESSEE으로 변경 SMS 대상자 관리 하면서 MAIL수신자도 같이 관리
--						 1.2 description 추가
--						 2.0 활성화 계획 전송 로직 추가
--						     Desc. Detail 정보 추가	 
--                       2.1 2019-01-02 kimcd 활성화에 조건 추가
--						 3.0 조회 쿼리 변경
--							 메일 컬럼 변경
--						 3.1 동별로 대상자 송신
--						 4.0 PR_XIF_MES_DAILY_PP_S 프로시저 변경으로 인해 SY_XIF_MES_DAILY_PP_S 데이터가 생성이 안되어 BODY가 안 만들어지는 경우가 있어
--							 SY_XIF_MES_DAILY_PP_S 사용하는 로직 삭제
--                       4.1 2021-06-04 kimcd PI인원 중에 메일 제외 요청이 있어 대상 제외 로직 추가
--                       4.2 2026-03-30 yokejacob E20260121-001037 릴리즈 메일 내용 추가건
-- ================================================================================================
TEST
EXEC [PR_SCM_RELEASE_PLAN_SEND]
@attach_path	='',
@attach_file	='' 
*/
-- PARAMETER
	@instance_id    NVARCHAR(100) = 'ST_E_PRE_A',
	@instance_date  NVARCHAR(100) = '20260316',
	@factory_id     NVARCHAR(100) =  'EQ',
	@plan_group_id  NVARCHAR(100) =  '-',
	@plan_description  NVARCHAR(MAX) =  '-',
	@attach_yn		CHAR(1)			= 'N',
	@attach_path	NVARCHAR(100),
	@attach_file	NVARCHAR(100)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_RELEASE_PLAN_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX)	 = ''
	DECLARE @TABLE_HEAD_CONTENT    NVARCHAR(MAX)
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)
	DECLARE @NOTE                  NVARCHAR(100) = '' -- E20260121-001037 릴리즈 메일 내용 추가

	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(MAX)
	DECLARE @ADDR_LIST			   NVARCHAR(4000)	--2018-11-18 piyong add
	DECLARE @MAIL_ATTACH		   NVARCHAR(200)					

	DECLARE @MAIL_WIDTH			   NUMERIC = 1650;	-- 메일 화면 넓이
	DECLARE @DATEDIFF_CNT		   INT = 0;			-- 최소 와 마지막 날짜의 차
	DECLARE @MAIL_CNT			   INT = 0;	
	DECLARE @DATEMIN			   NVARCHAR(50);	-- 최소 날짜
	DECLARE @DATEMAX			   NVARCHAR(50);	-- 마지막 날짜
	DECLARE @LIMIT_DATEMIN		   NVARCHAR(50);	-- 최소 기준 날짜
	DECLARE @LIMIT_DATEMAX		   NVARCHAR(50);	-- 15일 기준 마지막 날짜
	DECLARE @DATE_ID			   NVARCHAR(10);	-- 날짜 목록
	DECLARE @PIVOT_TD_DATE         NVARCHAR(MAX) = '' -- MAIL 제목 날짜
	DECLARE @PIVOT_CON_DATE        NVARCHAR(MAX) = '' -- MAIL 내용 날짜
	DECLARE @PIVOT_DATE            NVARCHAR(MAX)	  -- PIVOT 조건 날짜
	DECLARE @PIVOT_SEL_DATE        NVARCHAR(MAX)	  -- PIVOT 조회 날짜

	DECLARE @ParmStr			   NVARCHAR(256)		-- 동적 쿼리 변수
	DECLARE @DATA_QUERY            NVARCHAR(MAX) = ''	-- 동적 쿼리
	DECLARE @instance_name		   NVARCHAR(300) = ''	-- INATANCE 이름 2019-01-08 PIYONG ADD
	DECLARE @factory_name		   NVARCHAR(300) = ''	-- 동 이름 2019-01-08 PIYONG ADD

	DECLARE @InstanceName			NVARCHAR(4000)	
	DECLARE @PlanID					NVARCHAR(150)
	DECLARE @Building				NVARCHAR(30)
	DECLARE @Operation				NVARCHAR(30)
	DECLARE @CellCode				NVARCHAR(150)
	DECLARE @ItemID					NVARCHAR(150)
	DECLARE @NickName				NVARCHAR(50)
	DECLARE	@ElecType				NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
	DECLARE	@LineName				NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가
	DECLARE @Version				VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가
	DECLARE @PPM					INT	= 0       -- E20260121-001037 릴리즈 메일 내용 추가	
	DECLARE @UOM					NVARCHAR(10)  -- E20260121-001037 릴리즈 메일 내용 추가	


	DECLARE @BEFOR_InstanceName		NVARCHAR(4000) = ''
	DECLARE @BEFOR_PlanID			NVARCHAR(150) = ''
	DECLARE @BEFOR_Building			NVARCHAR(30) = ''
	DECLARE @BEFOR_Operation		NVARCHAR(30) = ''
	DECLARE @COL1					NVARCHAR(31)
	DECLARE @COL2					NVARCHAR(31)
	DECLARE @COL3					NVARCHAR(31)
	DECLARE @COL4					NVARCHAR(31)
	DECLARE @COL5					NVARCHAR(31)
	DECLARE @COL6					NVARCHAR(31)
	DECLARE @COL7					NVARCHAR(31)
	DECLARE @COL8					NVARCHAR(31)
	DECLARE @COL9					NVARCHAR(31)
	DECLARE @COL10					NVARCHAR(31)
	DECLARE @COL11					NVARCHAR(31)
	DECLARE @COL12					NVARCHAR(31)
	DECLARE @COL13					NVARCHAR(31)
	DECLARE @COL14					NVARCHAR(31)
	DECLARE @COL15					NVARCHAR(31)

	DECLARE @InstanceName_CNT		INT
	DECLARE @PlanID_CNT				INT
	DECLARE @Building_CNT			INT
	DECLARE @Operation_CNT			INT

	DECLARE @TAMP_TABLE7 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE8 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE9 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE10 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE11 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE12 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
		,COL13			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE13 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
		,COL13			NVARCHAR(31)
		,COL14			NVARCHAR(31)
	)

	DECLARE @TAMP_TABLE14 TABLE (
		InstanceName	NVARCHAR(4000)	
		,PlanID			NVARCHAR(150)
		,Building		NVARCHAR(30)
		,Operation		NVARCHAR(150)
		,OPERATION_ID	NVARCHAR(30)
		,CellCode		NVARCHAR(150)
		,ItemID			NVARCHAR(150)
		,NickName		NVARCHAR(50)
		,ElecType		NVARCHAR(30)  -- E20260121-001037 릴리즈 메일 내용 추가
		,LineName		NVARCHAR(150) -- E20260121-001037 릴리즈 메일 내용 추가	
		,Version		VARCHAR(10)   -- E20260121-001037 릴리즈 메일 내용 추가	
		,PPM		    INT           -- E20260121-001037 릴리즈 메일 내용 추가	
		,UOM            NVARCHAR(10)
		,COL1			NVARCHAR(31)
		,COL2			NVARCHAR(31)
		,COL3			NVARCHAR(31)
		,COL4			NVARCHAR(31)
		,COL5			NVARCHAR(31)
		,COL6			NVARCHAR(31)
		,COL7			NVARCHAR(31)
		,COL8			NVARCHAR(31)
		,COL9			NVARCHAR(31)
		,COL10			NVARCHAR(31)
		,COL11			NVARCHAR(31)
		,COL12			NVARCHAR(31)
		,COL13			NVARCHAR(31)
		,COL14			NVARCHAR(31)
		,COL15			NVARCHAR(31)
	)

	SET @ROWCOUNT = @@ROWCOUNT

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

/*		--2020-01-21 PIYONG DEL
		--	XIF_MES_DAILY_PP_S 테이블에서 PLAN_ID 의 날짜를 조회 한다	
		IF @instance_id NOT LIKE '%FORM%' -- 2019-01-02 kimcd 조건 추가
			BEGIN
				SELECT @DATEDIFF_CNT = DATEDIFF(DD, MIN(PLAN_DATE), MAX(PLAN_DATE) )
					   ,@DATEMIN = SUBSTRING(MIN(PLAN_DATE), 1, 10)
					   ,@DATEMAX = SUBSTRING(MAX(PLAN_DATE), 1, 10)
					   ,@LIMIT_DATEMIN = CAST(DATEADD(DD, 7, MIN(PLAN_DATE)) AS date )
					   ,@LIMIT_DATEMAX = CAST(DATEADD(DD, 14, MIN(PLAN_DATE)) AS date )
				  FROM DBO.SY_XIF_MES_DAILY_PP_S
				 WHERE PLAN_ID IN (
									SELECT RELEASE_PLAN_ID
									  FROM (
											SELECT RELEASE_PLAN_ID
												   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID
																				   , FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC
																	   ) NUMS
											  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
											 WHERE INSTANCE_ID =  @instance_id  
											   AND INSTANCE_DATE = @instance_date
											   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																		FACTORY_ID
																	 ELSE @factory_id
																	  END
											   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																			PLAN_GROUP_ID
																		ELSE @plan_group_id
																		 END
											) A
									WHERE NUMS = 1
								  )
				   AND CAST(OUT_QTY AS NUMERIC) > 0
			END;
*/
		--2019-01-08 PIYONG ADD
		SET @instance_name = (
							  SELECT TOP 1 SLV.SEGMENT2
							    FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
							   WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							     AND SLV.SEGMENT1         = @instance_id
							 )

		--2019-01-08 PIYONG ADD
		SET @factory_name = (
								SELECT FACTORY_NAME
								  FROM SCM_FACTORY_M
								 WHERE FACTORY_ID = @factory_id
							)

		---------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 2018-11-23 PIYONG ADD	 활성화 기간 생성
		-- 2020-01-21 PIYONG DEL IF 조건 삭제
--		IF @instance_id LIKE '%FORM%'
--			BEGIN
				SELECT @DATEDIFF_CNT = DATEDIFF(DD, MIN(PLAN_DATE), MAX(PLAN_DATE) )
					   ,@DATEMIN = CONVERT( NVARCHAR(10), MIN(PLAN_DATE), 120) 
					   ,@DATEMAX = CONVERT( NVARCHAR(10), MAX(PLAN_DATE), 120) 
					   ,@LIMIT_DATEMIN = CAST(DATEADD(DD, 7, MIN(PLAN_DATE)) AS date )
					   ,@LIMIT_DATEMAX = CAST(DATEADD(DD, 14, MIN(PLAN_DATE)) AS date )
				  FROM FP_DAILY_PRODUCTION_PLAN_R
				  WHERE FP_PLAN_ID IN (
										SELECT RELEASE_PLAN_ID
										  FROM (
												SELECT RELEASE_PLAN_ID
													   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID
																					   , FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC
																			   ) NUMS
												  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
												 WHERE INSTANCE_ID = @instance_id
												   AND INSTANCE_DATE = @instance_date
												   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																				FACTORY_ID
																		 ELSE @factory_id
																		 END
												   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																				PLAN_GROUP_ID
																			ELSE @plan_group_id
																			 END
												) A
										   WHERE NUMS = 1
									  )
				   AND CAST(PLAN_QTY AS NUMERIC) > 0
				   AND INSTANCE_ID =  @instance_id -- 2019-01-02 kimcd 조건 추가
--			END

		IF @DATEDIFF_CNT > 21
			SET @DATEDIFF_CNT = 21

		-- 2018-11-23 PIYONG ADD  END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------


		SET @MAIL_WIDTH = @MAIL_WIDTH + (  (@DATEDIFF_CNT - 7) * 125 )+ ( SELECT CASE WHEN LEN(SEGMENT2) > 30 THEN
																						  400
																					  WHEN LEN(SEGMENT2) > 20 THEN
																					      200
																					  ELSE
																						0
																				   END
																				 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																			    WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
																				  AND SEGMENT1 = @instance_id
																		) 

		IF @DATEDIFF_CNT > 14							--배포일자와 계획 마지막 날짜의 차이가 14일 이상이면 15일 까지만 적용
			BEGIN
				SET @DATEMAX = @LIMIT_DATEMAX
				SET @DATEDIFF_CNT = 14
			END
		ELSE IF @DATEDIFF_CNT < 7						--배포일자와 계획 마지막 날짜의 차이가 7일 이하이면 7일 까지 적용
			BEGIN
				SET @DATEMAX = @LIMIT_DATEMIN
				SET @DATEDIFF_CNT = 7
			END

		DECLARE CUR_DATE_LIST CURSOR FOR				--배포기간 날짜 조회
			SELECT DATE_ID
			  FROM SCM_SYS_CALENDAR_M
			 WHERE DATE_ID >= @DATEMIN
			   AND DATE_ID <= @DATEMAX

		OPEN CUR_DATE_LIST;
		
		FETCH NEXT FROM CUR_DATE_LIST INTO @DATE_ID
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF @PIVOT_DATE = '' OR @PIVOT_DATE IS NULL	--첫 번째 일 경우
					BEGIN
						SET @PIVOT_SEL_DATE = 'ISNULL(FORMAT(['+@DATE_ID+'], ''N0''),'''') AS ['+@DATE_ID+']'		--NULL를 하지 않으면  값이 원하는 날짜에 값이 들어 가지 않는다.
						SET @PIVOT_DATE = '['+@DATE_ID+']'
					END
				ELSE										-- 첫 번째가 아닐 경우
					BEGIN
						SET @PIVOT_SEL_DATE = @PIVOT_SEL_DATE + ', ISNULL(FORMAT(['+@DATE_ID+'], ''N0''),'''') AS ['+@DATE_ID+']'
						SET @PIVOT_DATE = @PIVOT_DATE + ', ['+@DATE_ID+']'
					END

				SET @PIVOT_TD_DATE = @PIVOT_TD_DATE +', td = ['+@DATE_ID+']'

				SET @PIVOT_CON_DATE = @PIVOT_CON_DATE +', '''+@DATE_ID+''' as td'

				FETCH NEXT FROM CUR_DATE_LIST INTO @DATE_ID
				;
			END;
			
		CLOSE CUR_DATE_LIST;
		DEALLOCATE CUR_DATE_LIST;

		-- LOOP 끝나고 생성 되는 변수의 값 모양
		--	@PIVOT_SEL_DATE		=	ISNULL( CONVERT(NVARCHAR(50),['2017-12-21']), '''') AS [2017-12-21'],ISNULL( CONVERT(NVARCHAR(50),['2017-12-22']), '''') AS [2017-12-22]
		--	@PIVOT_DATE			=	['2017-12-21'],['2017-12-22'],['2017-12-23']
		--	@PIVOT_TD_DATE		=	, td = ['2017-12-21'], td = ['2017-12-22'], td = ['2017-12-23']
		--	@PIVOT_CON_DATE		=	, '2017-12-21' as td, '2017-12-22' as td, '2017-12-23' as td


--		SET @DATA_QUERY = 'SET @TABLE_CONTENTS = (SELECT td = Instance_Name, td = PlanID, td = Plant_Name, td = Building, td = LineID, td = Line_Name, td = Operation, td = ItemID'+@PIVOT_TD_DATE
		SET @DATA_QUERY =						'			SELECT Instance_Name, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName, '+'ElecType, LINE_NAME ,VERSION ,CAST(DAILY_CAPA_PPM AS INT) PPM , ITEM_UOM AS UOM,' + @PIVOT_SEL_DATE      --E20260121-001037 릴리즈 메일 내용 추가
						+						'			  FROM ( '
						+						'					SELECT '''+@instance_name		+'''			AS Instance_Name	'


		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 2018-11-23 PIYONG ADD		기준 테이블 변경
		-- 2020-01-21 PIYONG DEL IF 조건 삭제
--		IF @instance_id LIKE '%FORM%'
--			BEGIN

		SET @DATA_QUERY = @DATA_QUERY +						'			   , RTRIM(SUBSTRING(A.FP_PLAN_ID, CHARINDEX(''-'', A.FP_PLAN_ID, 1)+1, LEN(A.FP_PLAN_ID))) AS PlanID 		'
						+									'			   , A.TOP_ITEM_ID                           AS CellCode 	'  --2019-01-08 PIYONG ADD
						+									'			   , F.FACTORY_NAME                          AS Building 	'  --2019-01-08 PIYONG ADD
						+									'			   , A.OPERATION_ID										 	'
						+									'			   , (SELECT TOP 1 OPERATION_NAME  FROM SCM_OPERATION_M WHERE OPERATION_ID = A.OPERATION_ID	) AS Operation 	'
						+									'			   , A.ITEM_ID                               AS ItemID 		'
						+									'			   , I.NICK_NAME							 AS NickName	'  --2019-01-08 PIYONG ADD
						+									'			   , CONVERT(NVARCHAR(10), A.PLAN_DATE,120)	 AS Plan_Date 	'
						+									'			   , SUM(CONVERT(NUMERIC(13),A.PLAN_QTY))	 AS Plan_Qty 	'
						+									'			   ,L.LINE_NAME ,A.VERSION , Z.DAILY_CAPA_PPM , A.ITEM_UOM , A.ELECTRODE_TYPE AS ElecType'                --E20260121-001037 릴리즈 메일 내용 추가
						+									'		  FROM DBO.FP_DAILY_PRODUCTION_PLAN_R A WITH(NOLOCK)  			'
						+									'			   INNER JOIN DBO.SCM_FACTORY_M F ON A.FACTORY_ID = F.FACTORY_ID' --E20260121-001037 릴리즈 메일 내용  inner join 으로 변경
						+									'			   INNER JOIN DBO.SCM_ITEM_M I	ON F.COMPANY_ID = I.COMPANY_ID AND F.DIVISION_ID = I.DIVISION_ID AND F.SITE_ID = I.SITE_ID AND A.TOP_ITEM_ID = I.ITEM_ID '  --E20260121-001037 릴리즈 메일 내용  inner join 으로 변경 
						+									'			   INNER JOIN DBO.SCM_LINE_M L	ON F.COMPANY_ID = L.COMPANY_ID AND A.FACTORY_ID = L.FACTORY_ID AND A.LINE_ID = L.LINE_ID AND A.OPERATION_ID = L.OPERATION_ID  AND A.ELECTRODE_TYPE = L.ELECTRODE_TYPE AND L.ACTIVE_FLAG = ''Y'' '  --E20260121-001037 릴리즈 메일 내용 추가
						+									'              LEFT OUTER JOIN (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM '--E20260121-001037 릴리즈 메일 내용 추가
						--+									'			   ,DBO.SCM_FACTORY_M F				  						'
						--+									'			   ,DBO.SCM_ITEM_M I						  				'  --2019-01-08 PIYONG ADD
                        +									'                                 FROM SCM_TACT_TIME_M A WITH(NOLOCK)'
                        +									'                                WHERE A.MONTH = SUBSTRING('''+ @instance_date +''',1,6)'
                        +									'                                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID) Z'
                        +									'                                ON  A.COMPANY_ID = Z.COMPANY_ID AND A.DIVISION_ID = Z.DIVISION_ID AND A.SITE_ID = Z.SITE_ID AND A.PLANT_ID = Z.PLANT_ID AND A.FACTORY_ID = Z.FACTORY_ID AND A.OPERATION_ID = Z.OPERATION_ID AND A.LINE_ID = Z.LINE_ID AND A.ELECTRODE_TYPE  = Z.ELECTRODE_TYPE AND A.ITEM_ID = Z.ITEM_ID'
						+									'		 WHERE A.INSTANCE_ID   = '''+@instance_id		+'''			'  -- 2019-01-02 kimcd 조건 추가
						--+									'		   AND A.FACTORY_ID	   = F.FACTORY_ID							'  --2019-01-08 PIYONG ADD
						--+									'		   AND F.COMPANY_ID    = I.COMPANY_ID		  					'  --2019-01-08 PIYONG ADD
						--+									'		   AND F.DIVISION_ID   = I.DIVISION_ID		  					'  --2019-01-08 PIYONG ADD
						--+									'		   AND F.SITE_ID       = I.SITE_ID		  						'  --2019-01-08 PIYONG ADD
						--+									'		   AND A.TOP_ITEM_ID   = I.ITEM_ID								'  --2019-01-08 PIYONG ADD
						+									'		   AND A.PLAN_DATE	  >= '''+@DATEMIN+'''						'
						+									'		   AND A.PLAN_DATE	  <= '''+@DATEMAX+'''						'
				IF @instance_id LIKE '%FORM%'
					BEGIN
						SET @DATA_QUERY = @DATA_QUERY +		''
						END
				ELSE IF @instance_id LIKE '%E_PRE%'
					BEGIN
						SET @DATA_QUERY = @DATA_QUERY +		'		   AND A.OPERATION_ID = ''E2000''  						'		--2019-01-08 PIYONG ADD
					END
				ELSE
					BEGIN
						SET @DATA_QUERY = @DATA_QUERY +		'		   AND A.OPERATION_ID != ''A6000''  						'		--2019-01-08 PIYONG ADD
					END
		SET @DATA_QUERY = @DATA_QUERY +						'		   AND A.FP_PLAN_ID   IN (										'
--			END
		-- 2018-11-23 PIYONG ADD END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------
/*		--2020-01-21 PIYONG DEL
		ELSE
			BEGIN

		SET @DATA_QUERY = @DATA_QUERY +						'			   , RTRIM(SUBSTRING(A.PLAN_ID, CHARINDEX(''-'', A.PLAN_ID, 1)+1, LEN(A.PLAN_ID))) AS PlanID		 		'
						+									'			   , P.TOP_ITEM_ID                           AS CellCode 	'  --2019-01-08 PIYONG ADD
						+									'			   , F.FACTORY_NAME                          AS Building 	'  --2019-01-08 PIYONG ADD
						+									'			   , A.OPERATION_ID										 	'
						+									'			   , (SELECT TOP 1 OPERATION_NAME  FROM SCM_OPERATION_M WHERE OPERATION_ID = A.OPERATION_ID	) AS Operation 	'
						+									'			   , A.ITEM_ID                               AS ItemID 		'
						+									'			   , I.NICK_NAME							 AS NickName	'  --2019-01-08 PIYONG ADD
						+									'			   , CONVERT(NVARCHAR(10), A.PLAN_DATE, 120) AS Plan_Date 	'
						+									'			   , SUM(CONVERT(NUMERIC(13),A.OUT_QTY))   AS Plan_Qty 	'
						+									'		  FROM DBO.SY_XIF_MES_DAILY_PP_S A WITH(NOLOCK)					'
						+									'			   ,DBO.SCM_FACTORY_M F						  				'  --2019-01-08 PIYONG ADD
						+									'			   ,DBO.FP_DAILY_PRODUCTION_PLAN_R P WITH(NOLOCK) 			'  --2019-01-08 PIYONG ADD
						+									'			   ,DBO.SCM_ITEM_M I						  				'
						+									'		  WHERE A.BUILNO	   = F.FACTORY_ID			 				'
						+									'		    AND P.INSTANCE_ID  = '''+@instance_id		+'''			'
						+									'		    AND A.PLAN_ID      = P.FP_PLAN_ID						'		--2019-01-08 PIYONG ADD
						+									'		    AND F.COMPANY_ID   = P.COMPANY_ID		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND F.DIVISION_ID  = P.DIVISION_ID		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND F.SITE_ID      = P.SITE_ID		  					'		--2019-01-08 PIYONG ADD
						+									'		    AND A.PLANT_ID	   = P.PLANT_ID		  					'		--2019-01-08 PIYONG ADD
						+									'		    AND A.BUILNO	   = P.FACTORY_ID		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND A.WO		   = P.WORK_ORDER_SPL_ID		  		'		--2019-01-08 PIYONG ADD
						+									'		    AND A.ITEM_ID	   = P.ITEM_ID		  					'		--2019-01-08 PIYONG ADD
						+									'		    AND A.PLAN_DATE	   = P.PLAN_DATE		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND A.OPERATION_ID = P.OPERATION_ID		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND F.COMPANY_ID   = I.COMPANY_ID		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND F.DIVISION_ID  = I.DIVISION_ID		  				'		--2019-01-08 PIYONG ADD
						+									'		    AND F.SITE_ID      = I.SITE_ID		  					'		--2019-01-08 PIYONG ADD
						+									'		    AND P.TOP_ITEM_ID  = I.ITEM_ID							'		--2019-01-08 PIYONG ADD
				SET @DATA_QUERY = @DATA_QUERY +				'		    AND A.PLAN_ID      = (									'
			END
*/

		SET @DATA_QUERY = @DATA_QUERY +						'									SELECT RELEASE_PLAN_ID				'
						+									'									  FROM (							'
						+									'											SELECT RELEASE_PLAN_ID		'
						+																		'			   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID	'
						+																		'											   , INSTANCE_DATE	'
						+																		'											   , DIVISION_ID	'
						+																		'											   , FACTORY_ID		'
						+																		'											   , PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS	'
						+																		'		  FROM [DBO].FP_RELEASE_PLAN_INFO_H H											'
						+																		'		 WHERE INSTANCE_ID =  		'''+@instance_id		+'''						'
						+																		'		   AND INSTANCE_DATE = 		'''+@instance_date	+'''							'
						+																		'		   AND FACTORY_ID = CASE WHEN	'''+ ISNULL(@factory_id,'')+ ''' =	'''' THEN	'
						+																		'										FACTORY_ID										'
						+																		'								 ELSE	'''+ ISNULL(@factory_id,'')	+'''				'
						+																		'									  END												'
						+																		'		   AND PLAN_GROUP_ID = CASE WHEN '''+ISNULL(@plan_group_id,'')+ ''' = '''' THEN	'
						+																		'										PLAN_GROUP_ID									'
						+																		'									ELSE '''+ISNULL(@plan_group_id,'')+'''				'
						+																		'									 END												'
						+																		'	   ) A			'
						+															'			 WHERE NUMS = 1		'
						+															'		 )						'
		---------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 2018-11-23 PIYONG ADD 조건 컬럼 변경
		-- 2020-01-21 PIYONG DEL IF 조건 삭제
--		IF @instance_id LIKE '%FORM%'
--			BEGIN
		SET @DATA_QUERY = @DATA_QUERY +						'		   AND CONVERT(NUMERIC(20,5), PLAN_QTY) > 0		'
						+									'		 GROUP BY A.FP_PLAN_ID  						'
						+									'			   , A.TOP_ITEM_ID  						'		--2019-01-08 PIYONG ADD

--			END
		-- 2018-11-23 PIYONG ADD END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------
/*		-- 2020-01-21 PIYONG DEL IF 조건 삭제
		ELSE
			BEGIN
		SET @DATA_QUERY = @DATA_QUERY +						'		   AND CONVERT(NUMERIC(20,5), OUT_QTY) > 0		'
						+									'		 GROUP BY A.PLAN_ID  							'
						+									'			   ,P.TOP_ITEM_ID  							'		--2019-01-08 PIYONG ADD

			END
*/


		SET @DATA_QUERY = @DATA_QUERY +						'			   , A.OPERATION_ID							'
						+									'			   , A.ITEM_ID								'
						+									'			   , F.FACTORY_NAME							'		--2019-01-08 PIYONG ADD
						+									'			   , I.NICK_NAME								'	--2019-01-08 PIYONG ADD
						+									'			   , CONVERT(NVARCHAR(10), A.PLAN_DATE, 120)	'
						+									'			   , A.LINE_ID, L.LINE_NAME ,A.VERSION , Z.DAILY_CAPA_PPM, A.ITEM_UOM, A.ELECTRODE_TYPE'--E20260121-001037 릴리즈 메일 내용 추가
						+									'	   ) A	PIVOT ( SUM(Plan_Qty) FOR Plan_Date IN ('+@PIVOT_DATE+')		'
						+									'	 ) PV	'
						
						

			IF @DATEDIFF_CNT = 7 
				BEGIN
					INSERT INTO @TAMP_TABLE7
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM --E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8
					)
					SELECT *
					 FROM @TAMP_TABLE7

				END
			ELSE IF @DATEDIFF_CNT = 8
				BEGIN
					INSERT INTO @TAMP_TABLE8
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM --E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9
					)
					SELECT *
					 FROM @TAMP_TABLE8
				END
			ELSE IF @DATEDIFF_CNT = 9 
				BEGIN
					INSERT INTO @TAMP_TABLE9
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM --E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10
					)
					SELECT *
					 FROM @TAMP_TABLE9
				END
			ELSE IF @DATEDIFF_CNT = 10 
				BEGIN
					INSERT INTO @TAMP_TABLE10
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM --E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11
					)
					SELECT *
					 FROM @TAMP_TABLE10
				END
			ELSE IF @DATEDIFF_CNT = 11 
				BEGIN
					INSERT INTO @TAMP_TABLE11
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM --E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11, COL12
					)
					SELECT *
					 FROM @TAMP_TABLE11
				END
			ELSE IF @DATEDIFF_CNT = 12
				BEGIN
					INSERT INTO @TAMP_TABLE12
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM--E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11, COL12, COL13
					)
					SELECT *
					 FROM @TAMP_TABLE12
				END
			ELSE IF @DATEDIFF_CNT = 13
				BEGIN
					INSERT INTO @TAMP_TABLE13
					EXEC sp_executesql @DATA_QUERY

					INSERT INTO @TAMP_TABLE14 (
						InstanceName, PlanID, Building, Operation, OPERATION_ID, CellCode, ItemID, NickName , ElecType, LineName, Version, PPM, UOM --E20260121-001037 릴리즈 메일 내용 추가
						,COL1,COL2, COL3, COL4, COL5, COL6, COL7, COL8, COL9, COL10,COL11, COL12, COL13, COL14
					)
					SELECT *
					 FROM @TAMP_TABLE13
				END
			ELSE IF @DATEDIFF_CNT = 14
				BEGIN

					INSERT INTO @TAMP_TABLE14
					EXEC sp_executesql @DATA_QUERY
				END





			DECLARE CUR_DATA_LIST CURSOR FOR
				SELECT InstanceName
						,PlanID
						,Building
						,Operation
						,CellCode
						,ItemID
						,ISNULL(NickName,'') AS NickName
						,ISNULL(ElecType,'') AS ElecType  --E20260121-001037 릴리즈 메일 내용 추가
						,ISNULL(LineName,'') AS LineName  --E20260121-001037 릴리즈 메일 내용 추가
						,ISNULL(Version,'') AS Version    --E20260121-001037 릴리즈 메일 내용 추가
						,PPM                              --E20260121-001037 릴리즈 메일 내용 추가
						,UOM
						,COL1
						,COL2
						,COL3
						,COL4
						,COL5
						,COL6
						,COL7
						,COL8
						,COL9
						,COL10
						,COL11
						,COL12
						,COL13
						,COL14
						,COL15
						,COUNT ( InstanceName ) OVER ( PARTITION BY InstanceName ) AS InstanceName_CNT
						,COUNT ( PlanID ) OVER ( PARTITION BY PlanID ) AS PlanID_CNT
						,COUNT ( Building ) OVER ( PARTITION BY Building ) AS Building_CNT
						,COUNT ( Operation ) OVER ( PARTITION BY Building, Operation ) AS Operation_CNT
				 FROM @TAMP_TABLE14
				ORDER BY Building, OPERATION_ID, CellCode, ItemID

			OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO @InstanceName
													,@PlanID
													,@Building
													,@Operation
													,@CellCode
													,@ItemID
													,@NickName
													,@ElecType	  --E20260121-001037 릴리즈 메일 내용 추가
													,@LineName	  --E20260121-001037 릴리즈 메일 내용 추가
													,@Version	  --E20260121-001037 릴리즈 메일 내용 추가
													,@PPM		  --E20260121-001037 릴리즈 메일 내용 추가
													,@UOM
													,@COL1
													,@COL2
													,@COL3
													,@COL4
													,@COL5
													,@COL6
													,@COL7
													,@COL8
													,@COL9
													,@COL10
													,@COL11
													,@COL12
													,@COL13
													,@COL14
													,@COL15
													,@InstanceName_CNT
													,@PlanID_CNT
													,@Building_CNT
													,@Operation_CNT

				WHILE (@@FETCH_STATUS = 0)
					BEGIN
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'

						IF @BEFOR_InstanceName != @InstanceName
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@InstanceName_CNT AS nvarchar)+'''>'+@InstanceName+'</td>'
								SET @BEFOR_InstanceName = @InstanceName
							END

						IF @BEFOR_PlanID != @PlanID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@PlanID_CNT AS nvarchar)+'''>'+@PlanID+'</td>'
								SET @BEFOR_PlanID = @PlanID
							END

						IF @BEFOR_Building != @Building
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@Building_CNT AS nvarchar)+'''>'+@Building+'</td>'
								SET @BEFOR_Building = @Building
							END

						IF @BEFOR_Operation != @Operation
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@Operation_CNT AS nvarchar)+'''>'+@Operation+'</td>'
								SET @BEFOR_Operation = @Operation
							END

						SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@CellCode+'</td>'
																+'<td>'+@ItemID+'</td>'
																+'<td>'+@NickName+'</td>'
																+'<td>'+@ElecType+'</td>'  --E20260121-001037 릴리즈 메일 내용 추가
																+'<td>'+@LineName+'</td>'  --E20260121-001037 릴리즈 메일 내용 추가
																+'<td>'+@Version+'</td>'   --E20260121-001037 릴리즈 메일 내용 추가
																+'<td>'+ISNULL(CAST(@PPM AS VARCHAR(20)), '')+'</td>'  --E20260121-001037 릴리즈 메일 내용 추가	
																+'<td>'+@UOM+'</td>'   --E20260121-001037 릴리즈 메일 내용 추가
															    +'<td>'+@COL1+'</td>'
																+'<td>'+@COL2+'</td>'
																+'<td>'+@COL3+'</td>'
																+'<td>'+@COL4+'</td>'
																+'<td>'+@COL5+'</td>'
																+'<td>'+@COL6+'</td>'
																+'<td>'+@COL7+'</td>'
																+'<td>'+@COL8+'</td>'


						IF @DATEDIFF_CNT IN ( 8, 9, 10, 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL9+'</td>'
						IF @DATEDIFF_CNT IN ( 9, 10, 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL10+'</td>'
						IF @DATEDIFF_CNT IN ( 10, 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL11+'</td>'
						IF @DATEDIFF_CNT IN ( 11, 12, 13, 14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL12+'</td>'
						IF @DATEDIFF_CNT IN ( 12,13,14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL13+'</td>'
						IF @DATEDIFF_CNT IN ( 13,14 )
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL14+'</td>'
						IF @DATEDIFF_CNT = 14 
							SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@COL15+'</td>'

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'										


						FETCH NEXT FROM CUR_DATA_LIST INTO @InstanceName
														,@PlanID
														,@Building
														,@Operation
														,@CellCode
														,@ItemID
														,@NickName
														,@ElecType  --E20260121-001037 릴리즈 메일 내용 추가
														,@LineName	--E20260121-001037 릴리즈 메일 내용 추가
														,@Version	--E20260121-001037 릴리즈 메일 내용 추가
														,@PPM	    --E20260121-001037 릴리즈 메일 내용 추가
														,@UOM	    --E20260121-001037 릴리즈 메일 내용 추가
														,@COL1
														,@COL2
														,@COL3
														,@COL4
														,@COL5
														,@COL6
														,@COL7
														,@COL8
														,@COL9
														,@COL10
														,@COL11
														,@COL12
														,@COL13
														,@COL14
														,@COL15
														,@InstanceName_CNT
														,@PlanID_CNT
														,@Building_CNT
														,@Operation_CNT
													
					;
					END;
			
				CLOSE CUR_DATA_LIST;
				DEALLOCATE CUR_DATA_LIST;


			SET @DATA_QUERY ='SET @TABLE_HEAD_CONTENT = (	'
													+'	 SELECT ''Instance_Name'' as td '
													+'		    ,''PlanID'' as td		'
													+'		    ,''Building'' as td		'
													+'		    ,''Operation'' as td	'
													+'		    ,''ItemID'' as td		'					--2019-01-08 PIYONG ADD
													+'		    ,''Material'' as td		'
													+'		    ,''NickName'' as td '
													+'		    ,''Elec.Type'' as td ' --E20260121-001037 릴리즈 메일 내용 추가
													+'		    ,''LineName'' as td ' --E20260121-001037 릴리즈 메일 내용 추가
													+'		    ,''Version'' as td '  --E20260121-001037 릴리즈 메일 내용 추가
													+'		    ,''PPM'' as td '      --E20260121-001037 릴리즈 메일 내용 추가
													+'		    ,''UOM'' as td '      --E20260121-001037 릴리즈 메일 내용 추가
													+@PIVOT_CON_DATE		--2019-01-08 PIYONG NickName ADD
													+'		FOR XML RAW(''tr''), ELEMENTS	'
													+'	)	'

			SET @ParmStr =  N'@TABLE_HEAD_CONTENT NVARCHAR(MAX) output'										--리턴 변수 선언 

			EXEC sp_executesql @DATA_QUERY, @ParmStr, @TABLE_HEAD_CONTENT=@TABLE_HEAD_CONTENT OUTPUT		--사용되는QUERY, 리턴값, OUTPUT 값 셋팅


			SET @MAIL_TITLE = '['+@instance_date+'] ['+@instance_name+'__'+ISNULL(@factory_name, @plan_group_id)+']  FP System Release Plan'

			SET @MAIL_CONTENT = N'Plan Release Date : '+@instance_date
								+'<br>Plan Release Plan ID : '+ (
																	SELECT RELEASE_PLAN_ID
																	  FROM (
																			SELECT RELEASE_PLAN_ID
																				   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID
																												   , FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC
																									   ) NUMS
																			  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
																			 WHERE INSTANCE_ID =  @instance_id  
																			   AND INSTANCE_DATE = @instance_date
																			   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																										FACTORY_ID
																									 ELSE @factory_id
																									  END
																			   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																											PLAN_GROUP_ID
																										ELSE @plan_group_id
																										 END
																			) A
																	WHERE NUMS = 1
																)
			IF @plan_group_id IS NULL
				SET @MAIL_CONTENT = @MAIL_CONTENT+'<br>Plan Release Building : '+ @factory_name
			ELSE IF @factory_id IS NULL
				SET @MAIL_CONTENT = @MAIL_CONTENT+'<br>Plan Release Group : '+@plan_group_id

			SET @MAIL_CONTENT = @MAIL_CONTENT+'<br>'+ISNULL( (
															  SELECT TOP 1 'Desc. : '+ISNULL([DESCRIPTION], '') 
																FROM [SCM_FP_PLAN_H]
															   WHERE [CONFIRM_FLAG] = 'Y'
																 AND [INSTANCE_ID] = @instance_id
																 AND [PLAN_ID] = (SELECT RELEASE_PLAN_ID
																					FROM (
																							SELECT RELEASE_PLAN_ID
																									, ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID
																																, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC
																														) NUMS
																							  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
																							 WHERE INSTANCE_ID =  @instance_id  
																							   AND INSTANCE_DATE = @instance_date
																							   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																														FACTORY_ID
																													 ELSE @factory_id
																													  END
																							   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																															PLAN_GROUP_ID
																														ELSE @plan_group_id
																														END
																						 ) A
																				   WHERE NUMS = 1
																				  )
															), 'Desc. : ')
			SET @MAIL_CONTENT = @MAIL_CONTENT+'<br>'+ISNULL( (
															  SELECT TOP 1 'Desc. Detail : '+ISNULL([REL_DESC], '') 
																FROM [SCM_FP_PLAN_H]
															   WHERE [CONFIRM_FLAG] = 'Y'
																 AND [INSTANCE_ID] = @instance_id
																 AND [PLAN_ID] = (SELECT RELEASE_PLAN_ID
																					FROM (
																							SELECT RELEASE_PLAN_ID
																									, ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID
																																, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC
																														) NUMS
																							  FROM [DBO].FP_RELEASE_PLAN_INFO_H H
																							 WHERE INSTANCE_ID =  @instance_id  
																							   AND INSTANCE_DATE = @instance_date
																							   AND FACTORY_ID = CASE WHEN @factory_id IS NULL THEN
																														FACTORY_ID
																													 ELSE @factory_id
																													  END
																							   AND PLAN_GROUP_ID = CASE WHEN @plan_group_id IS NULL THEN
																															PLAN_GROUP_ID
																														ELSE @plan_group_id
																														END
																						 ) A
																				   WHERE NUMS = 1
																				  )
															), 'Desc. Detail : ')

			IF EXISTS (SELECT 1 FROM @TAMP_TABLE14 where OPERATION_ID ='E2000')
			BEGIN 
				SET @NOTE = 'The unit for the Electrode Coater Operation E2000 is M(P/C).'
			END 
 
			SET @TABLE_BODY = '	<html>
									<head>
										<title>Untitled Document</title>
										<style>
   											* {margin:0;padding:0;}
   											body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   											table {border-collapse:collapse;width:100%;}
   											table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   											table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   											table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;}
   											table tbody td {text-align:left;padding:6px 8px;}
   											table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
											.hori-table table thead td {text-align:center;padding:3px;}  
   											.hori-table table tbody td {text-align:center;padding:3px;}
   											.vertical-table, .hori-table {margin-bottom:20px;}
										</style>
									</head>
									<body>' +
										REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + '
   										<br>
   										<div class=''wrap''>
       										<div class=''hori-table''>
           										<table style=''border-top:2px solid #c8294b; width:'+CAST(@MAIL_WIDTH AS nvarchar)+'px''>
               										<thead>' +
                   										@TABLE_HEAD_CONTENT + 
               										'</thead>
               										<tbody>' +
               										ISNULL(@TABLE_CONTENTS, '') + '
               										</tbody>
												</table>' + ISNULL(@NOTE, '') + '
       										</div>
   										</div>										
									</body>
								</html>'

			DECLARE CUR_PI_MAIL_ADDR_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
				SELECT ATTRIBUTE3	
				FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					AND SEGMENT1 = 'ELECTRODE_PI'
					AND ATTRIBUTE4 = 'Y'
					AND ATTRIBUTE3 IS NOT NULL
					AND ISNULL(ATTRIBUTE5,'Y') != 'N' -- 2021-06-04 kimcd 메일 제외 요청자 제거


			OPEN CUR_PI_MAIL_ADDR_LIST;
		
			SET @MAIL_RECEIVER_LIST = '';
			FETCH NEXT FROM CUR_PI_MAIL_ADDR_LIST INTO @ADDR_LIST
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_RECEIVER_LIST =  @MAIL_RECEIVER_LIST+';'+ @ADDR_LIST

					FETCH NEXT FROM CUR_PI_MAIL_ADDR_LIST INTO @ADDR_LIST
					
					END;
			
			CLOSE CUR_PI_MAIL_ADDR_LIST;
			DEALLOCATE CUR_PI_MAIL_ADDR_LIST;

			IF @MAIL_RECEIVER_LIST != '' 
			BEGIN
				EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL_TEST'
										, @recipients             = @MAIL_RECEIVER_LIST  										
										, @query_result_separator = ';'
										, @subject                = @MAIL_TITLE
										, @body                   = @TABLE_BODY
										, @body_format            = 'html'
				--EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL_TEST'
			END
			-----------------------------------------------------------------------------------------------
			--2018-10-18 PIYONG ADD
			IF @attach_yn = 'Y'
			BEGIN
				-- 미첨부 발송 -----------------------------------------------------------------------------------
				DECLARE CUR_MAIL_ADDR_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
					SELECT ATTRIBUTE3	
					  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
					 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					   AND SEGMENT1 = 'PLAN_CONFIRM'
					   AND ISNULL(ATTRIBUTE4, ACTIVE_FLAG) = 'Y'
					   AND ATTRIBUTE3 IS NOT NULL
					   AND ATTRIBUTE2 = @instance_id
					   AND ISNULL(ATTRIBUTE7, 'N') = 'N'	-- 미첨부
					   AND (SEGMENT3 = '-' OR SEGMENT3 = @factory_id)
					 ORDER BY CAST(SEGMENT2 AS INT)

				OPEN CUR_MAIL_ADDR_LIST;

				SET @MAIL_RECEIVER_LIST = '';
				FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_CNT = @MAIL_CNT +1;
					SET @MAIL_RECEIVER_LIST =  @MAIL_RECEIVER_LIST+';'+ @ADDR_LIST

					IF @MAIL_CNT % 30 = 0
					BEGIN
						EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL'
												, @recipients             = @MAIL_RECEIVER_LIST
												, @query_result_separator = ';'
												, @subject                = @MAIL_TITLE
												, @body                   = @TABLE_BODY
												, @body_format            = 'html'
						;

						SET @MAIL_CNT = 0;
						SET @MAIL_RECEIVER_LIST = '';
					END

					FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
					;
				END;
			
				CLOSE CUR_MAIL_ADDR_LIST;
				DEALLOCATE CUR_MAIL_ADDR_LIST;
		
				IF @MAIL_CNT > 0 AND @MAIL_RECEIVER_LIST != ''
				BEGIN
					EXEC  msdb.dbo.sp_send_dbmail @profile_name	  = 'FP_MAIL'
										, @recipients             = @MAIL_RECEIVER_LIST
										, @query_result_separator = ';'
										, @subject                = @MAIL_TITLE
										, @body                   = @TABLE_BODY
										, @body_format            = 'html'
				END

				-- 첨부 발송 -----------------------------------------------------------------------------------
				SET @MAIL_ATTACH = CONCAT(@attach_path, @attach_file)

				DECLARE CUR_MAIL_ADDR_ATTACH_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
					SELECT ATTRIBUTE3	
					  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
					 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					   AND SEGMENT1 = 'PLAN_CONFIRM'
					   AND ISNULL(ATTRIBUTE4, ACTIVE_FLAG) = 'Y'
					   AND ATTRIBUTE3 IS NOT NULL
					   AND ATTRIBUTE2 = @instance_id
					   AND ISNULL(ATTRIBUTE7, 'N') = 'Y'	-- 첨부
					   AND (SEGMENT3 = '-' OR SEGMENT3 = @factory_id)
					 ORDER BY CAST(SEGMENT2 AS INT)

				OPEN CUR_MAIL_ADDR_ATTACH_LIST;

				SET @MAIL_CNT = 0
				SET @MAIL_RECEIVER_LIST = '';

				FETCH NEXT FROM CUR_MAIL_ADDR_ATTACH_LIST INTO @ADDR_LIST
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_CNT = @MAIL_CNT +1;
					SET @MAIL_RECEIVER_LIST =  @MAIL_RECEIVER_LIST+';'+ @ADDR_LIST

					IF @MAIL_CNT % 30 = 0
					BEGIN
						EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL'
												, @recipients             = @MAIL_RECEIVER_LIST
												, @query_result_separator = ';'
												, @subject                = @MAIL_TITLE
												, @body                   = @TABLE_BODY
												, @body_format            = 'html'
												, @file_attachments		  = @MAIL_ATTACH
						SET @MAIL_CNT = 0;
						SET @MAIL_RECEIVER_LIST = '';
					END

					FETCH NEXT FROM CUR_MAIL_ADDR_ATTACH_LIST INTO @ADDR_LIST
				END
			
				CLOSE CUR_MAIL_ADDR_ATTACH_LIST;
				DEALLOCATE CUR_MAIL_ADDR_ATTACH_LIST;
		
				IF @MAIL_CNT > 0 AND @MAIL_RECEIVER_LIST != ''
				BEGIN
					EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL'
											, @recipients             = @MAIL_RECEIVER_LIST
											, @query_result_separator = ';'
											, @subject                = @MAIL_TITLE
											, @body                   = @TABLE_BODY
											, @body_format            = 'html'
											, @file_attachments		  = @MAIL_ATTACH
				END
			END
			ELSE -- 파일 첨부가 안된 경우 -----------------------------------------------------------------------------------------
			BEGIN
				DECLARE CUR_MAIL_ADDR_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
					SELECT ATTRIBUTE3	
					  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
					 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					   AND SEGMENT1 = 'PLAN_CONFIRM'
					   AND ISNULL(ATTRIBUTE4, ACTIVE_FLAG) = 'Y'
					   AND ATTRIBUTE3 IS NOT NULL
					   AND ATTRIBUTE2 = @instance_id
					   AND (SEGMENT3 = '-' OR SEGMENT3 = @factory_id)
					 ORDER BY CAST(SEGMENT2 AS INT)

				OPEN CUR_MAIL_ADDR_LIST;

				SET @MAIL_RECEIVER_LIST = '';
				FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_CNT = @MAIL_CNT +1;
					SET @MAIL_RECEIVER_LIST =  @MAIL_RECEIVER_LIST+';'+ @ADDR_LIST

					IF @MAIL_CNT % 30 = 0
					BEGIN
						EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL'
												, @recipients             = @MAIL_RECEIVER_LIST
												, @query_result_separator = ';'
												, @subject                = @MAIL_TITLE
												, @body                   = @TABLE_BODY
												, @body_format            = 'html'
						;
						SET @MAIL_CNT = 0;
						SET @MAIL_RECEIVER_LIST = ''
					END

					FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
				END;
		
				CLOSE CUR_MAIL_ADDR_LIST
				DEALLOCATE CUR_MAIL_ADDR_LIST
	
				IF @MAIL_CNT > 0 AND @MAIL_RECEIVER_LIST != ''
				BEGIN
					EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL'
										, @recipients             = @MAIL_RECEIVER_LIST
										, @query_result_separator = ';'
										, @subject                = @MAIL_TITLE
										, @body                   = @TABLE_BODY
										, @body_format            = 'html'
				END
			END

			--2018-10-18 PIYONG ADD END
			-----------------------------------------------------------------------------------------------
		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
