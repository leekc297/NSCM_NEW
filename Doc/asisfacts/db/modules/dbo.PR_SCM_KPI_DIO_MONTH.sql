
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_SCM_KPI_DIO_MONTH
 * Description  : KPI_RTF_DIO (월별 재고일주 산출)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021. 08. 12    JSHEO      Initial Release 
 * 2022. 03. 25    sclee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023. 03. 23	   hrkim	  [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2025. 08. 01    hrkim	  PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경 
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_KPI_DIO_MONTH]

	-- Add the parameters for the stored procedure here
	@p_START_DATE				NVARCHAR(8)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_KPI_DIO_MONTH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 변수
    DECLARE @v_start_week         NVARCHAR(8);
    DECLARE @v_dio_yyyymm         NVARCHAR(6);
    DECLARE @v_rtf_yyyymm         NVARCHAR(6);
	DECLARE @v_plan_delete_yyyymm NVARCHAR(6);
	
    -- PJ20216891
    DECLARE @v_tb_target_division TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division
    -- SELECT '40' DIVISION_ID UNION ALL
    -- SELECT '81' DIVISION_ID UNION ALL
    -- SELECT '81_UC' DIVISION_ID UNION ALL
    -- SELECT '82' DIVISION_ID
	-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	SELECT DIVISION_ID
	  FROM SCM_MST_DIVISION WITH(NOLOCK)
	 WHERE 1=1
	   AND ATTRIBUTE3 != 'EE' 
	   AND VALID_YN	   = 'Y'

    DECLARE @v_tb_target_division1 TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division1
    -- SELECT 'EE_UC' DIVISION_ID UNION ALL
    -- SELECT 'EE' DIVISION_ID
	-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	SELECT DIVISION_ID
	  FROM SCM_MST_DIVISION WITH(NOLOCK)
	 WHERE 1=1
	   AND ATTRIBUTE3 = 'EE' 
	   AND VALID_YN	   = 'Y'

	-- 계획 시작, 종료 구간
    DECLARE @v_period_start_date NVARCHAR(8);


	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'  -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------


	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_SCM_KPI_DIO_MONTH;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	


	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                   매출계획 적확도 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--
	BEGIN
	    -- 1.1 매출 실적 I/F 기준 일자
	    SET @v_start_week      = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                              THEN CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 당주 월요일
		                              ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CONVERT(DATETIME, @p_START_DATE), 'MON')), 112)
								 END  -- 해당 일자 월요일

        -- 1.2 매출 삭제 시작 월
	    SET @v_dio_yyyymm   = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                              THEN CONVERT(CHAR(6), DATEADD(MM, -1, GETDATE()), 112)
		                              ELSE CONVERT(CHAR(6), DATEADD(MM, -1, CONVERT(DATETIME, @p_START_DATE)), 112)
								 END  -- 당월 기준 2달 전 지난 정보 삭제

        -- 1.2 매출 삭제 시작 월
	    SET @v_rtf_yyyymm   = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                              THEN CONVERT(CHAR(6), DATEADD(MM, 0, GETDATE()), 112)
		                              ELSE CONVERT(CHAR(6), DATEADD(MM, 0, CONVERT(DATETIME, @p_START_DATE)), 112)
								 END  -- 당월 기준 2달 전 지난 정보 삭제

		-- 1.4 RTF 버전 및 계획 삭제, 시작 일자
		SET @v_period_start_date    = CASE WHEN ISNULL(@p_START_DATE,'') = '' 
		                                   THEN CONVERT(NVARCHAR(6), GETDATE(), 112) + '01'
		                                   ELSE CONVERT(NVARCHAR(6), CONVERT(DATETIME, @p_START_DATE), 112) + '01'
								      END  --계획 시작 구간.


		-- 2.2 RTF, BP  삭제
		DELETE FROM SCM_KPI_DIO WHERE YYYYMM >= @v_dio_yyyymm ;


		-- 기말 마감 재고 INSERT (Detail)
		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		
		SELECT ST.DIVISION_ID
		     , ST.DOE             AS ITEM_ID
		     , ST.BASE_YYYYMM     AS YYYYMM
			 , '-'                AS MEASURE
			 , SUM(ST.QTY)        AS QTY
			 , 0                  AS DIO_QTY
			 , ST.DOE
			 , '-'                AS BASIC_NICK_NAME
			 , '-'                AS GROUP_TYPE
			 , '-'                AS ITEM_CLASS_NAME
			 , '-'                AS SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   (
				SELECT ST.BASE_YYYYMM, ST.DIVISION_ID, ST.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, ISNULL(IT.DOE, ST.ITEM_ID) AS DOE,  SUM(ST.TOTAL_QTY) AS QTY
				FROM   SCM_DNM_MONTH_CLOSE_INVENTORY ST WITH(NOLOCK)
						, (
						SELECT IT.DIVISION_ID, IT.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE, MAX(IT.NICK_NAME) AS NICK_NAME
						FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
						
                        -- PJ20216891
						-- WHERE  DIVISION_ID IN ('40', '81', '82')
						WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
						AND    IT.SCP_OPERATION_GROUP = 'A'
						AND    IT.SCP_FLOW_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
						-- PJ20257329 변경전 AND    IT.SCP_FLOW_ID IN ('A3000', 'A9000')
						GROUP  BY IT.DIVISION_ID, IT.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
						) IT
				WHERE  ST.BASE_YYYYMM = @v_dio_yyyymm
				AND    ST.DIVISION_ID = IT.DIVISION_ID
				AND    ST.ITEM_ID     = IT.ITEM_ID
				GROUP  BY ST.BASE_YYYYMM, ST.DIVISION_ID, ST.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, ISNULL(IT.DOE, ST.ITEM_ID) 

				UNION  ALL
		
				SELECT ST.BASE_YYYYMM, ST.DIVISION_ID, BM.CHILD_ITEM_ID, BM.SCP_OPERATION_GROUP, BM.SCP_FLOW_ID, ISNULL(BM.DOE, BM.CHILD_ITEM_ID) AS DOE,  SUM(ST.QTY*BM.ACCUMULATED_CHILD_QTY) AS QTY
				FROM   (
						SELECT ST.BASE_YYYYMM, ST.DIVISION_ID, ST.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE,  SUM(ST.TOTAL_QTY) AS QTY
						FROM   SCM_DNM_MONTH_CLOSE_INVENTORY ST WITH(NOLOCK)
							 , (
								SELECT IT.DIVISION_ID, IT.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE, MAX(IT.NICK_NAME) AS NICK_NAME
								FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
								
                                -- PJ20216891
								-- WHERE  DIVISION_ID IN ('40', '81', '82')
								WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
								AND    IT.SCP_OPERATION_GROUP IN ('A','P')
								AND    IT.SCP_FLOW_ID IN ('P5000', 'P5500', 'P9500', 'R5500', 'F7000', 'F7100', 'F7300')
								GROUP  BY IT.DIVISION_ID, IT.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
							   ) IT
						WHERE  ST.BASE_YYYYMM = @v_dio_yyyymm
						AND    ST.DIVISION_ID = IT.DIVISION_ID
						AND    ST.ITEM_ID     = IT.ITEM_ID
						GROUP  BY ST.BASE_YYYYMM, ST.DIVISION_ID, ST.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
					   ) ST
					   LEFT OUTER JOIN 
					   ( SELECT BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE,  MAX(BM.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
						 FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V BM WITH(NOLOCK)
							 ,  (
								SELECT IT.DIVISION_ID, IT.ITEM_ID,  IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE, MAX(IT.NICK_NAME) AS NICK_NAME
								FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
								
                                -- PJ20216891
								-- WHERE  DIVISION_ID IN ('40', '81', '82')
								WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
								AND    IT.SCP_OPERATION_GROUP = 'A'
								AND    IT.SCP_FLOW_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
								-- PJ20257329 변경전 AND    IT.SCP_FLOW_ID IN ('A3000', 'A9000')
								GROUP  BY IT.DIVISION_ID, IT.ITEM_ID,  IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
								) IT
						 WHERE  BM.OPERATION_GROUP_ID = 'A'
						 AND    BM.TCO_CELL_YN        = 'N'
						 AND    BM.DIVISION_ID        = IT.DIVISION_ID
						 AND    BM.CHILD_ITEM_ID      = IT.ITEM_ID
						 GROUP  BY BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
					   ) BM
					   ON  ST.DIVISION_ID        = BM.DIVISION_ID
					   AND ST.ITEM_ID            = BM.MODEL_ID
				WHERE  BM.CHILD_ITEM_ID IS NOT NULL
				GROUP  BY ST.BASE_YYYYMM, ST.DIVISION_ID, BM.CHILD_ITEM_ID, BM.SCP_OPERATION_GROUP, BM.SCP_FLOW_ID, ISNULL(BM.DOE, BM.CHILD_ITEM_ID)
			   ) ST
		WHERE  1 = 1
		GROUP  BY ST.DIVISION_ID, ST.DOE , ST.BASE_YYYYMM ;


		-- 생산 계획 INSERT (Detail)
		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		
		SELECT ST.DIVISION_ID
		     , ST.DOE             AS ITEM_ID
		     , ST.YYYYMM          AS YYYYMM
			 , 'PROD'             AS MEASURE
			 , ST.QTY             AS QTY
			 , 0                  AS DIO_QTY
			 , ST.DOE
			 , '-'                AS BASIC_NICK_NAME
			 , '-'                AS GROUP_TYPE
			 , '-'                AS ITEM_CLASS_NAME
			 , '-'                AS SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   (
				SELECT P.DIVISION_ID
					 , ISNULL(IT.DOE, P.ITEM_ID) AS DOE
					 , SUBSTRING(P.YYYYMMDD,1,6) AS YYYYMM
					 , SUM(ROUND(P.QTY * ISNULL(Y.YIELD,1),0)) AS QTY
				FROM   SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK)
					   LEFT  OUTER JOIN (
						SELECT DIVISION_ID, PLANT_SITE_ID, ITEM_ID, ISNULL(SSP_MODIFY_YIELD, FORMATION_TOTAL_YIELD) AS YIELD
						FROM   SCP_MST_FORMATION WITH(NOLOCK)
					   ) Y
					   ON  P.DIVISION_ID = Y.DIVISION_ID
					   AND P.SCM_SITE_ID = Y.PLANT_SITE_ID
					   AND P.ITEM_ID     = Y.ITEM_ID
					   , (
						SELECT IT.DIVISION_ID, IT.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE, MAX(IT.NICK_NAME) AS NICK_NAME
						FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
						
                        -- PJ20216891
						-- WHERE  DIVISION_ID IN ('40', '81', '82')
						WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
						AND    IT.SCP_OPERATION_GROUP = 'A'
						AND    IT.SCP_FLOW_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
						-- PJ20257329 변경전 AND    IT.SCP_FLOW_ID IN ('A3000', 'A9000')  
						GROUP  BY IT.DIVISION_ID, IT.ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
						) IT
					,   (
							 SELECT X.DIVISION_ID,
									X.PLAN_NAME,
									X.PLAN_TYPE,
									X.PLAN_SEQ
							 FROM (
									 SELECT D.DIVISION_ID,
											P.PLAN_NAME,
											D.PLAN_TYPE,
											D.PLAN_SEQ,
											(ROW_NUMBER() OVER ( PARTITION BY D.DIVISION_ID ORDER BY P.PLAN_NAME DESC )) AS SEQ_NO
									   FROM SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
										   ,SCM_MST_PLAN P WITH(NOLOCK)
									  WHERE 1=1
									  
                                        -- PJ20216891
										-- AND P.DIVISION_ID <> 'EE'
										AND P.DIVISION_ID NOT IN (SELECT DIVISION_ID FROM @v_tb_target_division1)
										AND P.PLAN_CYCLE  = 'WEEKLY'
										AND P.PLAN_NAME   <= @v_period_start_date
										AND P.DIVISION_ID = D.DIVISION_ID
										AND P.PLAN_ID     = D.PLAN_ID
										AND D.PLAN_TYPE   = 'FN'
										AND D.CONFIRM_FLAG ='Y'
								   ) X
							  WHERE X.SEQ_NO = 1
					   ) VR
				WHERE  P.DIVISION_ID = VR.DIVISION_ID
				AND    P.PLAN_START_YYYYMMDD = VR.PLAN_NAME
				AND    P.PLAN_TYPE = VR.PLAN_TYPE
				AND    P.SEQ  = VR.PLAN_SEQ
				AND    P.OPERATION_GROUP = 'A'
				AND    P.MEASURE         = 'PROD_PLAN_AMEND'
				AND    P.QTY             > 0 
				AND    P.DIVISION_ID     = IT.DIVISION_ID
				AND    P.ITEM_ID         = IT.ITEM_ID
				AND    SUBSTRING(P.YYYYMMDD,1,6) BETWEEN SUBSTRING(@v_period_start_date,1,6) AND CONVERT(CHAR(6), DATEADD(MM, 3, CONVERT(DATETIME, @v_period_start_date)), 112)
				GROUP  BY P.DIVISION_ID, ISNULL(IT.DOE, P.ITEM_ID), SUBSTRING(P.YYYYMMDD,1,6)
		       ) ST
		WHERE  1 = 1
		;

		-- RTF 계획 INSERT (Detail)
		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		
		SELECT ST.DIVISION_ID
		     , ST.DOE             AS ITEM_ID
		     , ST.YYYYMM          AS YYYYMM
			 , 'RTF'              AS MEASURE
			 , ST.QTY             AS QTY
			 , 0                  AS DIO_QTY
			 , ST.DOE
			 , '-'                AS BASIC_NICK_NAME
			 , '-'                AS GROUP_TYPE
			 , '-'                AS ITEM_CLASS_NAME
			 , '-'                AS SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   (
				SELECT RF.DIVISION_ID, ISNULL(BM.DOE, BM.CHILD_ITEM_ID) AS DOE, RF.YYYYMM, SUM(RF.QTY * BM.ACCUMULATED_CHILD_QTY) AS QTY
				FROM   (
						select  sp.[DIVISION_ID]
							   ,sp.[ITEM_ID]
							   ,SUBSTRING(sp.YYYYMMDD,1,6) AS YYYYMM
							   ,SUM(sp.qty) AS  qty
						  from dm_pln_sales_plan_c sp WITH(NOLOCK)
							  ,(
								SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
								FROM (
										SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
												ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
										WHERE  VERSION_TYPE = 'SP_W'
										AND    YYYYMMDD < @v_rtf_yyyymm+'01'

										) VER
								WHERE VER.SEQ = 1
							) target_version
						 where sp.division_id				= target_version.division_id
						   and sp.version_no				= target_version.version_no
						   and sp.YYYYMMDD               	>= @v_rtf_yyyymm+'01'
						   AND sp.YYYYMMDD               	< CONVERT(NVARCHAR(6), DATEADD(MONTH, 4, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
						   and sp.measure					= 'RTF_SYS_RP'
						   and sp.qty                       >= 0 
						 GROUP BY sp.[DIVISION_ID], sp.[ITEM_ID], SUBSTRING(sp.YYYYMMDD,1,6) 
						) RF
						LEFT OUTER JOIN 
						( SELECT BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE,  MAX(BM.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
							FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V BM WITH(NOLOCK)
								,  (
								SELECT IT.DIVISION_ID, IT.ITEM_ID,  IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE, MAX(IT.NICK_NAME) AS NICK_NAME
								FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
								
                                -- PJ20216891
								-- WHERE  DIVISION_ID IN ('40', '81', '82')
								WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
								AND    IT.SCP_OPERATION_GROUP = 'A'
								AND    IT.SCP_FLOW_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
								-- PJ20257329 변경전 AND    IT.SCP_FLOW_ID IN ('A3000', 'A9000')
								GROUP  BY IT.DIVISION_ID, IT.ITEM_ID,  IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
								) IT
							WHERE  BM.OPERATION_GROUP_ID = 'A'
							AND    BM.TCO_CELL_YN        = 'N'
							AND    BM.DIVISION_ID        = IT.DIVISION_ID
							AND    BM.CHILD_ITEM_ID      = IT.ITEM_ID
							GROUP  BY BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
						) BM
						ON  RF.DIVISION_ID        = BM.DIVISION_ID
						AND RF.ITEM_ID            = BM.MODEL_ID
						LEFT OUTER JOIN
						(
						   SELECT DIVISION_ID, ISNULL(DOE,ITEM_ID) AS ITEM_ID, MAX(BASIC_NICK_NAME) AS BASIC_NICK_NAME, MAX(GROUP_TYPE) AS GROUP_TYPE, MAX(ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
						   FROM   (
								    SELECT IT.DIVISION_ID, IT.ITEM_ID, ISNULL(IT.DOE, IT.ITEM_ID) AS DOE, IT.SCP_EXTRA_SPEC, IT.SCM_PIC
									
                                         -- PJ20216891
										 -- , CASE WHEN IT.DIVISION_ID IN ('81', '82')       THEN '-'
										 , CASE WHEN IT.DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division WHERE DIVISION_ID <> '40')       THEN '-'
										   WHEN IT.DIVISION_ID = '40'                THEN 
												CASE WHEN FI.CELL_TYPE_GROUP_CODE = 'C' THEN 'Cyl'
													 WHEN FI.CELL_TYPE_GROUP_CODE = 'P' THEN 'Pouch'
													 WHEN FI.CELL_TYPE_GROUP_CODE = 'R' THEN 'Pris'
													 ELSE '-'
												END
									  END  AS ITEM_CLASS_NAME
										, (
										   SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') 
										   FROM   DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) 
										   WHERE  1=1 AND X.DIVISION_ID = IT.DIVISION_ID 
										   AND X.ITEM_ID = ISNULL(IT.DOE, IT.ITEM_ID)
										  ) AS BASIC_NICK_NAME
										, (SELECT SEGMENT2
										   FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
										   WHERE A.LOOKUP_TYPE = 'OPERATION_GROUP'
										   AND A.SEGMENT1 = (SELECT DBO.FN_GET_ITEM_OPERATION_GROUP(IT.DIVISION_ID, ISNULL(IT.DOE, IT.ITEM_ID)))) AS GROUP_TYPE
								   FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
										, SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
										
                                   -- PJ20216891
								   -- WHERE  IT.DIVISION_ID IN ('40','81','82')
								   WHERE  IT.DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
								   AND    IT.DIVISION_ID = FI.DIVISION_ID
								   AND    ISNULL(IT.DOE, IT.ITEM_ID)    = FI.ITEM_ID
								  ) A
						   GROUP  BY DIVISION_ID, ISNULL(DOE,ITEM_ID)
						) INFO
						ON  RF.[DIVISION_ID]                  = INFO.DIVISION_ID
						AND ISNULL(BM.DOE, BM.CHILD_ITEM_ID)  = INFO.ITEM_ID
				WHERE   BM.CHILD_ITEM_ID IS NOT NULL
				GROUP   BY RF.DIVISION_ID, ISNULL(BM.DOE, BM.CHILD_ITEM_ID), RF.YYYYMM
		        ) ST
		WHERE   1 = 1
		;

		
		-- RTF 준수율 KPI 재생성을 위한 추가 필드 
		-- 대표코드/대표Nick_Name/Biz Type/Class Name/SCM User. (2021.07.22 hjs)
		MERGE INTO SCM_KPI_DIO AS KPI
		USING (
			   SELECT DIVISION_ID, ISNULL(DOE,ITEM_ID) AS ITEM_ID, MAX(BASIC_NICK_NAME) AS BASIC_NICK_NAME, MAX(GROUP_TYPE) AS GROUP_TYPE, MAX(ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
			   FROM   (
					   SELECT IT.DIVISION_ID, IT.ITEM_ID, ISNULL(IT.DOE, IT.ITEM_ID) AS DOE, IT.SCP_EXTRA_SPEC, IT.SCM_PIC

                            -- PJ20216891
					        -- , CASE WHEN IT.DIVISION_ID IN ('81', '82')       THEN '-'
					        , CASE WHEN IT.DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division WHERE DIVISION_ID <> '40')       THEN '-'
							       WHEN IT.DIVISION_ID = '40'                THEN 
										CASE WHEN CELL_TYPE_GROUP_CODE = 'C' THEN 'Cyl'
										     WHEN CELL_TYPE_GROUP_CODE = 'P' THEN 'Pouch'
										     WHEN CELL_TYPE_GROUP_CODE = 'R' THEN 'Pris'
											 ELSE '-'
										END
							  END  AS ITEM_CLASS_NAME
					        , IT.SCP_OPERATION_GROUP
							, (
							   SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') 
							   FROM   DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) 
							   WHERE  1=1 AND X.DIVISION_ID = IT.DIVISION_ID 
							   AND X.ITEM_ID = ISNULL(IT.DOE, IT.ITEM_ID)
							  ) AS BASIC_NICK_NAME
							, CASE WHEN IT.SCP_OPERATION_GROUP = 'A'         THEN 'Cell' 
							       WHEN IT.SCP_FLOW_ID IN ('P5000', 'P5500') THEN 'Module'
								   WHEN IT.SCP_FLOW_ID IN ('P9000', 'P9500', 'R5500') THEN 'Pack'
								   WHEN IT.SCP_OPERATION_GROUP = 'E' THEN 'Electrode'
								   ELSE IT.SCP_OPERATION_GROUP
							  END  AS GROUP_TYPE
					   FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
					        , SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
							
                       -- PJ20216891
					   -- WHERE  IT.DIVISION_ID IN ('40','81','82')
					   WHERE  IT.DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
					   AND    IT.SCP_OPERATION_GROUP IN ('P', 'A', 'E')
					   AND    IT.DIVISION_ID = FI.DIVISION_ID
					   AND    ISNULL(IT.DOE, IT.ITEM_ID)    = FI.ITEM_ID
					  ) A
			   GROUP  BY DIVISION_ID, ISNULL(DOE,ITEM_ID)
			  ) AS IT
		   ON (
						KPI.YYYYMM        >= @v_dio_yyyymm
					AND KPI.DIVISION_ID   = IT.DIVISION_ID
					AND KPI.ITEM_ID       = IT.ITEM_ID
				  )
		WHEN MATCHED THEN
		UPDATE SET KPI.BASIC_NICK_NAME = IT.BASIC_NICK_NAME
				 , KPI.GROUP_TYPE      = IT.GROUP_TYPE
				 , KPI.ITEM_CLASS_NAME = IT.ITEM_CLASS_NAME
				 , KPI.SCM_PIC         = IT.SCM_PIC 

		;


		-- 상세 정보 삭제 건. 2021-10-28
		DELETE SCM_KPI_DIO_DETAIL WHERE DIO_YYYYMM = @v_dio_yyyymm;

		-- 상세 정보 추가 건. 2021-10-28
		INSERT INTO SCM_KPI_DIO_DETAIL (
		       DIO_YYYYMM
             , DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		SELECT @v_dio_yyyymm as  DIO_YYYYMM
		     , DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		FROM    SCM_KPI_DIO KPI WITH(NOLOCK)
		WHERE   KPI.YYYYMM >= @v_rtf_yyyymm
		AND     KPI.MEASURE IN ('PROD', 'RTF')

		;
		

		-- 예상 재고 산출 INSERT (Detail)
		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		
		SELECT ST.DIVISION_ID
		     , ST.DOE             AS ITEM_ID
		     , ST.YYYYMM          AS YYYYMM
			 , '-'                AS MEASURE
			 , ST.QTY             AS QTY
			 , 0                  AS DIO_QTY
			 , ST.DOE
			 , ST.BASIC_NICK_NAME
			 , ST.GROUP_TYPE
			 , ST.ITEM_CLASS_NAME
			 , ST.SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   (
				SELECT T.DIVISION_ID, T.ITEM_ID AS DOE, T.YYYYMM
					 , SUM(CASE WHEN T.MEASURE = 'RTF' THEN ACC_QTY*-1 ELSE ACC_QTY END) AS QTY
					 , BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, SCM_PIC
				FROM   (
						SELECT DIVISION_ID, ITEM_ID, YYYYMM 
							 , MEASURE
							 , QTY
							 , SUM(QTY) OVER (PARTITION BY DIVISION_ID, ITEM_ID ORDER BY YYYYMM) AS ACC_QTY
							 , DOE, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, SCM_PIC
						FROM   SCM_KPI_DIO WITH(NOLOCK)
						WHERE  YYYYMM  > @v_dio_yyyymm
						AND    MEASURE IN ('RTF', 'PROD')
						UNION  ALL
						SELECT K.DIVISION_ID, K.ITEM_ID, C.BASIS_YYYYMM AS YYYYMM 
							 , K.MEASURE
							 , K.QTY
							 , K.QTY AS ACC_QTY
							 , K.DOE, K.BASIC_NICK_NAME, K.GROUP_TYPE, K.ITEM_CLASS_NAME, K.SCM_PIC
						FROM   SCM_KPI_DIO K WITH(NOLOCK)
							 , (
								SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
								FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
								WHERE  BASIS_YYYYMMDD >= @v_period_start_date
								AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 4, CONVERT(DATETIME,@v_period_start_date)), 112) + '01' 
								GROUP  BY BASIS_YYYYMM
							   ) C
						WHERE  K.YYYYMM  = @v_dio_yyyymm
						AND    K.MEASURE = '-'

					   ) T
				WHERE  1 = 1
				GROUP  BY T.DIVISION_ID, T.ITEM_ID, T.YYYYMM
					 , BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, SCM_PIC
			   ) ST
		WHERE  1 = 1 ;


		-- 예상재고 산출 - 생산, RTF 삭제.
		DELETE FROM SCM_KPI_DIO WHERE YYYYMM >= @v_dio_yyyymm AND MEASURE IN ('RTF', 'PROD');


		-- 기말 마감 재고 INSERT (ITEM_CLASS_NAME)

		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		SELECT DIVISION_ID, '-' AS ITEM_ID, YYYYMM, 'BASIC_NICK_NAME' AS MEASURE, SUM(QTY) AS QTY, 0 AS DIO_QTY
		     , '-' AS DOE, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   SCM_KPI_DIO
		WHERE  YYYYMM >= @v_dio_yyyymm
		AND    MEASURE = '-'
		GROUP  BY DIVISION_ID, YYYYMM, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME
		;

		-- 기말 마감 재고 INSERT (ITEM_CLASS_NAME)

		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		SELECT DIVISION_ID, '-' AS ITEM_ID, YYYYMM, 'ITEM_CLASS_SUB_TOTAL' AS MEASURE, SUM(QTY) AS QTY, 0 AS DIO_QTY
		     , '-' AS DOE, '-' BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, '-' AS SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   SCM_KPI_DIO
		WHERE  YYYYMM >= @v_dio_yyyymm
		AND    MEASURE = '-'
		GROUP  BY DIVISION_ID, YYYYMM, GROUP_TYPE, ITEM_CLASS_NAME
		;

		
		-- 기말 마감 재고 INSERT (DIVISION)

		INSERT INTO SCM_KPI_DIO (
               DIVISION_ID
			 , ITEM_ID
			 , YYYYMM
			 , MEASURE
			 , QTY
			 , DIO_QTY
			 , DOE
			 , BASIC_NICK_NAME
			 , GROUP_TYPE
			 , ITEM_CLASS_NAME
			 , SCM_PIC
			 , CREATED_BY
			 , CREATION_DATE
			 , LAST_UPDATED_BY
			 , LAST_UPDATE_DATE
		       )
		SELECT DIVISION_ID, '-' AS ITEM_ID, YYYYMM, 'DIVISION_SUB_TOTAL' AS MEASURE, SUM(QTY) AS QTY, 0 AS DIO_QTY
		     , '-' AS DOE, '-' BASIC_NICK_NAME, '-' GROUP_TYPE, '-' ITEM_CLASS_NAME, '-' AS SCM_PIC
			 , 'SYSTEM'           AS CREATED_BY
			 , GETDATE()          AS CREATION_DATE
			 , 'SYSTEM'           AS LAST_UPDATED_BY
			 , GETDATE()          AS LAST_UPDATE_DATE
		FROM   SCM_KPI_DIO
		WHERE  YYYYMM >= @v_dio_yyyymm
		AND    MEASURE = '-'
		GROUP  BY DIVISION_ID, YYYYMM
		;


		DELETE FROM SCM_KPI_DIO WHERE YYYYMM >= @v_dio_yyyymm AND MEASURE = '-' ;

		
        IF OBJECT_ID('tempdb..#TMP_RTF_PLAN') IS NOT NULL                
            DROP TABLE #TMP_RTF_PLAN ; 
		
		-- 2. RTF CUTOFF 정보
		SELECT RF.DIVISION_ID, '-' AS ITEM_ID, RF.YYYYMM, SUM(RF.QTY * BM.ACCUMULATED_CHILD_QTY) AS QTY
			 , INFO.BASIC_NICK_NAME
			 , INFO.GROUP_TYPE
			 , INFO.ITEM_CLASS_NAME
			 , INFO.SCM_PIC
		 INTO #TMP_RTF_PLAN
		FROM   (
				select  sp.[DIVISION_ID]
					   ,sp.[ITEM_ID]
					   ,SUBSTRING(sp.YYYYMMDD,1,6) AS YYYYMM
					   ,SUM(sp.qty) AS  qty
				  from dm_pln_sales_plan_c sp WITH(NOLOCK)
					  ,(
						SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
						FROM (
								SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
										ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
								WHERE  VERSION_TYPE = 'SP_W'
								AND    YYYYMMDD < @v_rtf_yyyymm+'01'

								) VER
						WHERE VER.SEQ = 1
					) target_version
				 where sp.division_id				= target_version.division_id
				   and sp.version_no				= target_version.version_no
				   and sp.YYYYMMDD               	>= @v_rtf_yyyymm+'01'
				   AND sp.YYYYMMDD               	< CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
				   and sp.measure					= 'RTF_SYS_RP'
				   and sp.qty                       >= 0 
				 GROUP BY sp.[DIVISION_ID], sp.[ITEM_ID], SUBSTRING(sp.YYYYMMDD,1,6) 
				) RF
				LEFT OUTER JOIN 
				( SELECT BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE,  MAX(BM.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
					FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V BM WITH(NOLOCK)
						,  (
						SELECT IT.DIVISION_ID, IT.ITEM_ID,  IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE, MAX(IT.NICK_NAME) AS NICK_NAME
						FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
						
                        -- PJ20216891
						-- WHERE  DIVISION_ID IN ('40', '81', '82')
						WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
						AND    IT.SCP_OPERATION_GROUP = 'A'
						AND    IT.SCP_FLOW_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
						-- PJ20257329 변경전 AND    IT.SCP_FLOW_ID IN ('A3000', 'A9000')
						GROUP  BY IT.DIVISION_ID, IT.ITEM_ID,  IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
						) IT
					WHERE  BM.OPERATION_GROUP_ID = 'A'
					AND    BM.TCO_CELL_YN        = 'N'
					AND    BM.DIVISION_ID        = IT.DIVISION_ID
					AND    BM.CHILD_ITEM_ID      = IT.ITEM_ID
					GROUP  BY BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, IT.SCP_OPERATION_GROUP, IT.SCP_FLOW_ID, IT.DOE
				) BM
				ON  RF.DIVISION_ID        = BM.DIVISION_ID
				AND RF.ITEM_ID            = BM.MODEL_ID
				LEFT OUTER JOIN
				(
				   SELECT DIVISION_ID, ISNULL(DOE,ITEM_ID) AS ITEM_ID, MAX(BASIC_NICK_NAME) AS BASIC_NICK_NAME, MAX(GROUP_TYPE) AS GROUP_TYPE, MAX(ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
				   FROM   (
						    SELECT IT.DIVISION_ID, IT.ITEM_ID, ISNULL(IT.DOE, IT.ITEM_ID) AS DOE, IT.SCP_EXTRA_SPEC, IT.SCM_PIC
						        
                                -- PJ20216891
								-- , CASE WHEN IT.DIVISION_ID IN ('81', '82')       THEN '-'
								, CASE WHEN IT.DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division WHERE DIVISION_ID <> '40')       THEN '-'
							       WHEN IT.DIVISION_ID = '40'                THEN 
										CASE WHEN FI.CELL_TYPE_GROUP_CODE = 'C' THEN 'Cyl'
										     WHEN FI.CELL_TYPE_GROUP_CODE = 'P' THEN 'Pouch'
										     WHEN FI.CELL_TYPE_GROUP_CODE = 'R' THEN 'Pris'
											 ELSE '-'
										END
							  END  AS ITEM_CLASS_NAME
								, (
								   SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') 
								   FROM   DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) 
								   WHERE  1=1 AND X.DIVISION_ID = IT.DIVISION_ID 
								   AND X.ITEM_ID = ISNULL(IT.DOE, IT.ITEM_ID)
								  ) AS BASIC_NICK_NAME
								, (SELECT SEGMENT2
								   FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
								   WHERE A.LOOKUP_TYPE = 'OPERATION_GROUP'
								   AND A.SEGMENT1 = (SELECT DBO.FN_GET_ITEM_OPERATION_GROUP(IT.DIVISION_ID, ISNULL(IT.DOE, IT.ITEM_ID)))) AS GROUP_TYPE
						   FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
					            , SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
								
                           -- PJ20216891
					       -- WHERE  IT.DIVISION_ID IN ('40','81','82')
					       WHERE  IT.DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
					       AND    IT.DIVISION_ID = FI.DIVISION_ID
					       AND    ISNULL(IT.DOE, IT.ITEM_ID)    = FI.ITEM_ID
						  ) A
				   GROUP  BY DIVISION_ID, ISNULL(DOE,ITEM_ID)
				) INFO
				ON  RF.[DIVISION_ID]                  = INFO.DIVISION_ID
				AND ISNULL(BM.DOE, BM.CHILD_ITEM_ID)  = INFO.ITEM_ID
		WHERE   BM.CHILD_ITEM_ID IS NOT NULL
		GROUP   BY RF.DIVISION_ID, RF.YYYYMM
			 , INFO.BASIC_NICK_NAME
			 , INFO.GROUP_TYPE
			 , INFO.ITEM_CLASS_NAME
			 , INFO.SCM_PIC
		;

		
        IF OBJECT_ID('tempdb..#TMP_DIO_01') IS NOT NULL                
            DROP TABLE #TMP_DIO_01 ; 

		
        IF OBJECT_ID('tempdb..#TMP_DIO_02') IS NOT NULL                
            DROP TABLE #TMP_DIO_02 ; 

		
        IF OBJECT_ID('tempdb..#TMP_DIO_03') IS NOT NULL                
            DROP TABLE #TMP_DIO_03 ; 

		SELECT DIO.DIVISION_ID,  DIO.YYYYMM, DIO.BASIC_NICK_NAME, DIO.STOCK_QTY
			 , CASE WHEN SUM(DIO.MONTH_DIO) > 180 THEN 180 ELSE SUM(DIO.MONTH_DIO) END  AS MONTH_DIO
		INTO   #TMP_DIO_01
		FROM   (
				SELECT ST.DIVISION_ID, ST.YYYYMM, ST.BASIC_NICK_NAME, ST.QTY AS STOCK_QTY
					 , RF.YYYYMM AS RTF_YYYYMM, RF.MONTH_CNT, RF.QTY, RF.ACC_QTY
					 , CASE WHEN RF.QTY IS NULL
							THEN 180
							WHEN ST.QTY > RF.ACC_QTY
							THEN RF.MONTH_CNT
							WHEN RF.QTY <> 0 AND RF.QTY = RF.ACC_QTY
							THEN RF.MONTH_CNT * (ST.QTY / RF.ACC_QTY)
							WHEN RF.QTY = 0
							THEN 0
							WHEN ST.QTY < RF.ACC_QTY AND (ST.QTY - (RF.ACC_QTY - RF.QTY)) > 0 
							THEN RF.MONTH_CNT * (ST.QTY - (RF.ACC_QTY - RF.QTY)) / RF.QTY
							WHEN (ST.QTY - (RF.ACC_QTY - RF.QTY)) < 0
							THEN 0
							ELSE RF.MONTH_CNT 
					   END  AS MONTH_DIO
				FROM   SCM_KPI_DIO ST 
					   LEFT OUTER JOIN
					   (
						SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.BASIC_NICK_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= @v_rtf_yyyymm+'01' 
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								GROUP  BY RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 0, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.BASIC_NICK_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'  
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.BASIC_NICK_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'  
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.BASIC_NICK_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 3, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'  
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 3, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, RF.BASIC_NICK_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
					   ) RF
					   ON  ST.DIVISION_ID     = RF.DIVISION_ID
					   AND ST.BASIC_NICK_NAME = RF.BASIC_NICK_NAME
					   AND ST.YYYYMM          = RF.RTF_YYYYMM
				WHERE  ST.YYYYMM >= @v_dio_yyyymm
				AND    ST.MEASURE = 'BASIC_NICK_NAME'
			   ) DIO
		WHERE  1 = 1
		GROUP  BY DIO.DIVISION_ID,  DIO.YYYYMM, DIO.BASIC_NICK_NAME, DIO.STOCK_QTY

		;


		SELECT DIO.DIVISION_ID,  DIO.YYYYMM, DIO.ITEM_CLASS_NAME, DIO.STOCK_QTY
			 , CASE WHEN SUM(DIO.MONTH_DIO) > 180 THEN 180 ELSE SUM(DIO.MONTH_DIO) END  AS MONTH_DIO
		INTO   #TMP_DIO_02
		FROM   (
				SELECT ST.DIVISION_ID, ST.YYYYMM, ST.ITEM_CLASS_NAME, ST.QTY AS STOCK_QTY
					 , RF.YYYYMM AS RTF_YYYYMM, RF.MONTH_CNT, RF.QTY, RF.ACC_QTY
					 , CASE WHEN RF.QTY IS NULL
							THEN 180
							WHEN ST.QTY > RF.ACC_QTY
							THEN RF.MONTH_CNT
							WHEN RF.QTY <> 0 AND RF.QTY = RF.ACC_QTY
							THEN RF.MONTH_CNT * (ST.QTY / RF.ACC_QTY)
							WHEN RF.QTY = 0
							THEN 0
							WHEN ST.QTY < RF.ACC_QTY AND (ST.QTY - (RF.ACC_QTY - RF.QTY)) > 0 
							THEN RF.MONTH_CNT * (ST.QTY - (RF.ACC_QTY - RF.QTY)) / RF.QTY
							WHEN (ST.QTY - (RF.ACC_QTY - RF.QTY)) < 0
							THEN 0
							ELSE RF.MONTH_CNT 
					   END  AS MONTH_DIO
				FROM   (SELECT ST.DIVISION_ID, ST.YYYYMM, ST.ITEM_CLASS_NAME, SUM(ST.QTY) AS QTY
				        FROM   SCM_KPI_DIO ST
						WHERE  ST.YYYYMM  >= @v_dio_yyyymm
				        AND    ST.MEASURE = 'ITEM_CLASS_SUB_TOTAL' 
						GROUP  BY ST.DIVISION_ID, ST.YYYYMM, ST.ITEM_CLASS_NAME) ST 
					   LEFT OUTER JOIN
					   (
						SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= @v_rtf_yyyymm+'01' 
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								GROUP  BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 0, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 3, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 3, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, RF.ITEM_CLASS_NAME, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
					   ) RF
					   ON  ST.DIVISION_ID         = RF.DIVISION_ID
					   AND ST.ITEM_CLASS_NAME     = RF.ITEM_CLASS_NAME
					   AND ST.YYYYMM              = RF.RTF_YYYYMM
				WHERE  1 = 1
			   ) DIO
		WHERE  1 = 1
		GROUP  BY DIO.DIVISION_ID,  DIO.YYYYMM, DIO.ITEM_CLASS_NAME, DIO.STOCK_QTY

		;


		
		SELECT DIO.DIVISION_ID,  DIO.YYYYMM, DIO.STOCK_QTY
			 , CASE WHEN SUM(DIO.MONTH_DIO) > 180 THEN 180 ELSE SUM(DIO.MONTH_DIO) END  AS MONTH_DIO
		INTO   #TMP_DIO_03
		FROM   (
				SELECT ST.DIVISION_ID, ST.YYYYMM, ST.QTY AS STOCK_QTY
					 , RF.YYYYMM AS RTF_YYYYMM, RF.MONTH_CNT, RF.QTY, RF.ACC_QTY
					 , CASE WHEN RF.QTY IS NULL
							THEN 180
							WHEN ST.QTY > RF.ACC_QTY
							THEN RF.MONTH_CNT
							WHEN RF.QTY <> 0 AND RF.QTY = RF.ACC_QTY
							THEN RF.MONTH_CNT * (ST.QTY / RF.ACC_QTY)
							WHEN RF.QTY = 0
							THEN 0
							WHEN ST.QTY < RF.ACC_QTY AND (ST.QTY - (RF.ACC_QTY - RF.QTY)) > 0 
							THEN RF.MONTH_CNT * (ST.QTY - (RF.ACC_QTY - RF.QTY)) / RF.QTY
							WHEN (ST.QTY - (RF.ACC_QTY - RF.QTY)) < 0
							THEN 0
							ELSE RF.MONTH_CNT 
					   END  AS MONTH_DIO
				FROM   (SELECT ST.DIVISION_ID, ST.YYYYMM, SUM(ST.QTY) AS QTY
				        FROM   SCM_KPI_DIO ST
						WHERE  ST.YYYYMM  >= @v_dio_yyyymm
				        AND    ST.MEASURE = 'DIVISION_SUB_TOTAL' 
						GROUP  BY ST.DIVISION_ID, ST.YYYYMM) ST 
					   LEFT OUTER JOIN
					   (
						SELECT RF.DIVISION_ID, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= @v_rtf_yyyymm+'01' 
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								GROUP  BY RF.DIVISION_ID, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 0, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)  AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
						 UNION ALL
						 
						SELECT RF.DIVISION_ID, RF.YYYYMM, RF.MONTH_CNT
							 , RF.QTY, CONVERT(NVARCHAR(6), DATEADD(MONTH, 2, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) AS RTF_YYYYMM
							 , SUM(RF.QTY) OVER (PARTITION BY RF.DIVISION_ID ORDER BY RF.YYYYMM ASC) AS ACC_QTY
						FROM   (
								SELECT RF.DIVISION_ID, CL.BASIS_YYYYMM AS YYYYMM, CL.MONTH_CNT
									 , SUM(CASE WHEN RF.YYYYMM = CL.BASIS_YYYYMM THEN RF.QTY ELSE 0 END) AS QTY 
								FROM   #TMP_RTF_PLAN RF
									 , (
										SELECT BASIS_YYYYMM, COUNT(*) AS MONTH_CNT
										FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE  BASIS_YYYYMMDD >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 3, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01'
										AND    BASIS_YYYYMMDD < CONVERT(NVARCHAR(6), DATEADD(MONTH, 12, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112) + '01' 
										GROUP  BY BASIS_YYYYMM
									   ) CL
								WHERE  1 = 1
								AND    RF.YYYYMM >= CONVERT(NVARCHAR(6), DATEADD(MONTH, 3, CONVERT(DATETIME,@v_rtf_yyyymm+'01')), 112)
								GROUP  BY RF.DIVISION_ID, CL.BASIS_YYYYMM, CL.MONTH_CNT
							   ) RF
						 WHERE 1 = 1
					   ) RF
					   ON  ST.DIVISION_ID   = RF.DIVISION_ID
					   AND ST.YYYYMM        = RF.RTF_YYYYMM
				WHERE  1 = 1
			   ) DIO
		WHERE  1 = 1
		GROUP  BY DIO.DIVISION_ID,  DIO.YYYYMM, DIO.STOCK_QTY

		;


		
        UPDATE X
           SET X.DIO_QTY           = Y.MONTH_DIO
              ,X.ATTRIBUTE1        = 'Y' 
         FROM SCM_KPI_DIO  X WITH (NOLOCK)
              INNER JOIN #TMP_DIO_01 Y WITH (NOLOCK)
          ON  1 = 1
          AND X.DIVISION_ID         = Y.DIVISION_ID
          AND X.BASIC_NICK_NAME     = Y.BASIC_NICK_NAME
          AND X.YYYYMM              = Y.YYYYMM  
		  AND X.MEASURE             = 'BASIC_NICK_NAME'
		
		;
		
        UPDATE X
           SET X.DIO_QTY           = Y.MONTH_DIO
              ,X.ATTRIBUTE1        = 'Y' 
         FROM SCM_KPI_DIO  X WITH (NOLOCK)
              INNER JOIN #TMP_DIO_02 Y WITH (NOLOCK)
          ON  1 = 1
          AND X.DIVISION_ID         = Y.DIVISION_ID
          AND X.ITEM_CLASS_NAME     = Y.ITEM_CLASS_NAME
          AND X.YYYYMM              = Y.YYYYMM  
		  AND X.MEASURE             = 'ITEM_CLASS_SUB_TOTAL'
		
		;

		
        UPDATE X
           SET X.DIO_QTY           = Y.MONTH_DIO
              ,X.ATTRIBUTE1        = 'Y' 
         FROM SCM_KPI_DIO  X WITH (NOLOCK)
              INNER JOIN #TMP_DIO_03 Y WITH (NOLOCK)
          ON  1 = 1
          AND X.DIVISION_ID         = Y.DIVISION_ID
          AND X.YYYYMM              = Y.YYYYMM  
		  AND X.MEASURE             = 'DIVISION_SUB_TOTAL'
		
		;


		/*

		with plan_and_result as (

		
		
		-- BP CUTOFF 정보
		select  sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,sp.qty  qty
		       ,CASE WHEN sp.YYYYMMDD >= @v_start_week THEN sp.qty ELSE 0 END  acc_qty
			   ,'BP'   MEASURE
		  from dm_pln_sales_plan_c sp WITH(NOLOCK)
			  ,(
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
				FROM (
						SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
								ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
						WHERE  VERSION_TYPE = 'SP_W'
						AND    YYYYMMDD < @v_period_start_date

						) VER
				WHERE VER.SEQ = 1
			) target_version
		 where sp.division_id				= target_version.division_id
		   and sp.version_no				= target_version.version_no
		   and sp.YYYYMMDD               	>= @v_period_start_date
		   and sp.measure					= 'RTF_SYS_RP'
		   and sp.qty                       >= 0 

		UNION ALL

		-- RTF CUTOFF 정보
		select  sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,sp.qty  qty
		       ,CASE WHEN sp.YYYYMMDD >= @v_start_week THEN sp.qty ELSE 0 END  acc_qty
			   ,'RTF'   MEASURE
		  from dm_pln_sales_plan_c sp WITH(NOLOCK)
			  ,(
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
				FROM (
						SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
								ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
						WHERE  VERSION_TYPE = 'SP_W'
						AND    YYYYMMDD < @v_period_start_date

						) VER
				WHERE VER.SEQ = 1
			) target_version
		 where sp.division_id				= target_version.division_id
		   and sp.version_no				= target_version.version_no
		   and sp.YYYYMMDD               	>= @v_period_start_date
		   and sp.measure					= 'RTF_SYS_RP'
		   and sp.qty                       >= 0 
		
		UNION ALL

		-- 매출 실적
		select  sp.[DIVISION_ID]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
		       ,sp.qty   qty
		       ,CASE WHEN sp.YYYYMMDD < @v_start_week THEN sp.qty ELSE 0 END  acc_qty
			   ,'SALES'  MEASURE
		  from dm_pln_sales_plan_result sp WITH(NOLOCK)
		 where sp.division_id				IN ('40', '81', '82')
		   and sp.measure					= 'RTF_SYS_RP'  --20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송
		   and yyyymmdd                     >= @v_delete_yyyymm + '01'
		   and yyyymmdd                     < @v_start_week
		)

		insert into DM_ANL_KPI_RTF_SALES ( 
			   [DIVISION_ID]
			  ,[ITEM_ID]
			  ,[FCST_TYPE]
			  ,[YYYYMM]
			  ,[MEASURE]
			  ,[QTY]
			  ,[ACC_QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
		   )
		select  x.division_id
		      , X.item_id
		      , X.fcst_type
		      , substring(X.yyyymmdd, 1,6) AS YYYYMM
		      , X.MEASURE
		      , SUM(QTY)           AS QTY
		      , SUM(ACC_QTY)       AS ACC_QTY
			  , 'KPI_RTF_SALES'    AS [CREATED_BY]
			  , getdate()          AS [CREATION_DATE]
			  , 'KPI_RTF_SALES'    AS [LAST_UPDATED_BY]
			  , getdate()          AS [LAST_UPDATE_DATE]
		  from plan_and_result x
		 where x.division_id in ( '81','82' ,'40')
		 group 
		    by  x.division_id
		      , X.item_id
		      , X.fcst_type
		      , substring(X.yyyymmdd, 1,6)
		      , X.MEASURE
		;

		*/



		-- RTF 준수율 KPI 재생성을 위한 추가 필드 
		-- 대표코드/대표Nick_Name/Biz Type/Class Name/SCM User. (2021.07.22 hjs)
		MERGE INTO SCM_KPI_DIO AS KPI
		USING (
			   SELECT DIVISION_ID, ISNULL(DOE,ITEM_ID) AS ITEM_ID, BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME, MAX(SCM_PIC) AS SCM_PIC
			   FROM   (
					   SELECT DIVISION_ID, ITEM_ID, ISNULL(DOE, ITEM_ID) AS DOE, SCP_EXTRA_SPEC, SCM_PIC, ITEM_CLASS_NAME
							, (
							   SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') 
							   FROM   DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) 
							   WHERE  1=1 AND X.DIVISION_ID = IT.DIVISION_ID 
							   AND X.ITEM_ID = ISNULL(IT.DOE, IT.ITEM_ID)
							  ) AS BASIC_NICK_NAME
							, (SELECT SEGMENT2
							   FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
							   WHERE A.LOOKUP_TYPE = 'OPERATION_GROUP'
							   AND A.SEGMENT1 = (SELECT DBO.FN_GET_ITEM_OPERATION_GROUP(IT.DIVISION_ID, ISNULL(IT.DOE, IT.ITEM_ID)))) AS GROUP_TYPE
					   FROM   SCM_MST_ITEM_SN IT WITH(NOLOCK)
					   
                       -- PJ20216891
					   -- WHERE  DIVISION_ID IN ('40','81','82')
					   WHERE  DIVISION_ID IN (SELECT DIVISION_ID FROM @v_tb_target_division)
					  ) A
			   GROUP  BY DIVISION_ID, ISNULL(DOE,ITEM_ID), BASIC_NICK_NAME, GROUP_TYPE, ITEM_CLASS_NAME
			  ) AS IT
		   ON (
						KPI.YYYYMM        >= @v_dio_yyyymm
					AND KPI.DIVISION_ID   = IT.DIVISION_ID
					AND KPI.ITEM_ID       = IT.ITEM_ID
				  )
		WHEN MATCHED THEN
		UPDATE SET KPI.BASIC_NICK_NAME = IT.BASIC_NICK_NAME
				 , KPI.GROUP_TYPE      = IT.GROUP_TYPE
				 , KPI.ITEM_CLASS_NAME = IT.ITEM_CLASS_NAME
				 , KPI.SCM_PIC         = IT.SCM_PIC 

													 ;


	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                   매출계획 적확도 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION PR_SCM_KPI_DIO_MONTH;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
