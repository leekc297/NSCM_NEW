


/*
 * Program ID   : PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40
 * Description  : 
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2018.10.10   KHSONG                 Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 에서 호출되는 Procedure로 Cufoff 테이블 관련처리를 수행함
 * 20190624 KHSONG [CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용 
 *                 -> @p_division_id 으로 RTF_SCP 수행되므로 특별히 수정할부분은 없음
 * 20190709 KHSONG [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
** 20190709 KHSONG [CSR ID:4034895] 상품 매출에 대한 마케팅의 RTF[R+P] 수정 권한 요청 및 MKT FCST 기본값 삭제 요청 (자동차사업부)
** 20190809 KHSONG [CSR ID:4059971] VMI-In Request 로직 변경
** 20190903 KHSONG [CSR ID:4066366] Sales Plan Waterfall 화면 메져값 수정
** 20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
** 20191028 KHSONG Cutoff Version 'RTF' Measure 삭제 오류로직 수정
** 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가
** 20200213 HWI1993 자동차 사업부의 경우 'RTF_SCP'Measure로 Sales Amt를 계산하도록 수정
** 20200416 KHSONG C20200413-000593 ESS사업부 RTF Measure 추가 (scp plan 수행시 모든사업부가 이 Procedure 로 호출됨)
** 20200507 KHSONG C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
*  20200615 hwi1993 C20200518-000359 GSCM RMA값 표기 로직 수정 요청의 건
* 20240610		KCW3408		이동계획(SCP_PLN_RTF_ALLOCATION_V 테이블 에서 ITEM_ID를 가져오는 기준 변경,FROM_ITEM_ID가 존재시 먼저가져옴)      
** -----------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(02)  -- DIVISION_ID
   ,@p_cut_off_version          NVARCHAR(18)  -- MKT_FCST_C의 Version

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @plan_start_yyyymmdd          NVARCHAR(08);
    DECLARE @c_plan_id                    NVARCHAR(20);
    DECLARE @c_cutoff_yyyymmdd			  NVARCHAR(08);
    DECLARE @c_cutoff_TYPE				  NVARCHAR(04);
    DECLARE @c_SP_TYPE					  NVARCHAR(04);
    DECLARE @c_SP_version				  NVARCHAR(18);

	-------------------------------------------------------------------------------------------------------------------------------------------	
	-- 변수값 셋팅
	-------------------------------------------------------------------------------------------------------------------------------------------	
	SET @c_cutoff_yyyymmdd	 = SUBSTRING(@p_cut_off_version,6,8)
	SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@c_cutoff_yyyymmdd, 'MON')), 112)   -- 월요일
	SET @c_cutoff_TYPE		 = SUBSTRING(@p_cut_off_version,1,4)
	SET @c_SP_TYPE			 = 'SP'+ SUBSTRING(@c_cutoff_TYPE,3,2)        -- SALES PLAN 용
	SET @c_SP_version		 = 'SP'+ SUBSTRING(@p_cut_off_version,3,16)   -- SALES PLAN 용
	SET @c_plan_id			 = ISNULL((SELECT MAX(plan_id) FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  WHERE division_id = @p_division_id and plan_start_yyyymmdd <= @plan_start_yyyymmdd ),'')  -- plan_id 추출
	-------------------------------------------------------------------------------------------------------------------------------------------	

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@p_cut_off_version : ' + RTRIM(LTRIM(@p_cut_off_version))  ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	--BEGIN TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	
	
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                TEMP TABLE SETTING (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
		-------
		--PRINT 'TEMP TABLE SETTING START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

			IF OBJECT_ID (N'tempdb..#T2_CUTOFF_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST ;
			IF OBJECT_ID (N'tempdb..#T2_VMI_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST
			IF OBJECT_ID (N'tempdb..#T2_VMI_MST_MAIN', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST_MAIN
			IF OBJECT_ID (N'tempdb..#T2_VMI_TEMP1', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP1
			IF OBJECT_ID (N'tempdb..#T2_VMI_TEMP2', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP2
			IF OBJECT_ID (N'tempdb..#T2_VMI_TEMP_all', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP_all
			IF OBJECT_ID (N'tempdb..#T2_CUTOFF_MST_ACCUM', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST_ACCUM
			IF OBJECT_ID (N'tempdb..#T2_CUTOFF_TEMPX', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_TEMPX
			IF OBJECT_ID (N'tempdb..#T2_MKT_FCST_INSERT', N'U') IS NOT NULL 
				DROP TABLE #T2_MKT_FCST_INSERT
				
				-- 임시확인테이블 사용시
			IF OBJECT_ID (N'dbo.#T2_CUTOFF_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST ;
			IF OBJECT_ID (N'dbo.#T2_VMI_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST
			IF OBJECT_ID (N'dbo.#T2_VMI_MST_MAIN', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST_MAIN
			IF OBJECT_ID (N'dbo.#T2_VMI_TEMP1', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP1
			IF OBJECT_ID (N'dbo.#T2_VMI_TEMP2', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP2
			IF OBJECT_ID (N'dbo.#T2_VMI_TEMP_all', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP_all
			IF OBJECT_ID (N'dbo.#T2_CUTOFF_MST_ACCUM', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST_ACCUM
			IF OBJECT_ID (N'dbo.#T2_CUTOFF_TEMPX', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_TEMPX


			CREATE TABLE  #T2_CUTOFF_MST
				(DIVISION_ID	NVARCHAR(30) NOT NULL
				,PROJECT_CODE	NVARCHAR(50) NOT NULL
				,SCM_SITE_ID	NVARCHAR(30) NOT NULL
				,ITEM_ID		NVARCHAR(50) NOT NULL
				,DOM_EXP		NVARCHAR(03) NOT NULL
				,FCST_TYPE		NVARCHAR(20) NOT NULL
				,INCOTERMS		NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
				,YYYYMMDD		NVARCHAR(08) NOT NULL
				,MEASURE		NVARCHAR(50) NOT NULL
				,QTY			NUMERIC(30,10) NOT NULL
				)

			CREATE CLUSTERED INDEX [IDX_T_CUTOFF_MST_N1] ON [#T2_CUTOFF_MST]
			(
				 DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,YYYYMMDD ASC
				,MEASURE ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
			;

			CREATE TABLE  #T2_CUTOFF_MST_ACCUM
				(DIVISION_ID	NVARCHAR(30) NOT NULL
				,PROJECT_CODE	NVARCHAR(50) NOT NULL
				,SCM_SITE_ID	NVARCHAR(30) NOT NULL
				,ITEM_ID		NVARCHAR(50) NOT NULL
				,DOM_EXP		NVARCHAR(03) NOT NULL
				,FCST_TYPE		NVARCHAR(20) NOT NULL
				,INCOTERMS		NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
				,YYYYMMDD		NVARCHAR(08) NOT NULL
				,MEASURE		NVARCHAR(50) NOT NULL
				,QTY			NUMERIC(30,10) NOT NULL
				,ACCUM_SUM		NUMERIC(30,10) NOT NULL
				)
			CREATE CLUSTERED INDEX [IDX_T_CUTOFF_MST_ACCUM] ON [#T2_CUTOFF_MST_ACCUM]
			(
				 DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,YYYYMMDD ASC
				,MEASURE ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
			;

			CREATE TABLE  #T2_CUTOFF_TEMPX
			(DIVISION_ID	NVARCHAR(30) NOT NULL
			,PROJECT_CODE	NVARCHAR(50) NOT NULL
			,SCM_SITE_ID	NVARCHAR(30) NOT NULL
			,ITEM_ID		NVARCHAR(50) NOT NULL
			,DOM_EXP		NVARCHAR(03) NOT NULL
			,FCST_TYPE		NVARCHAR(20) NOT NULL
			,INCOTERMS		NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
			,MEASURE		NVARCHAR(50) NOT NULL
			,YYYYMMDD		NVARCHAR(08) NOT NULL
			,ACCUM_X		NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_CUTOFF_TEMPX_N1] ON [#T2_CUTOFF_TEMPX]
			(
			 DIVISION_ID ASC
			,PROJECT_CODE ASC
			,SCM_SITE_ID ASC
			,ITEM_ID ASC
			,DOM_EXP ASC
			,FCST_TYPE ASC
			,INCOTERMS ASC
			,PLANT_SITE_ID ASC
			,MEASURE ASC
			,YYYYMMDD ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			CREATE TABLE  #T2_VMI_MST
			(
			DIVISION_ID	NVARCHAR(30) NOT NULL
			,PROJECT_CODE	NVARCHAR(50) NOT NULL
			,SCM_SITE_ID	NVARCHAR(30) NOT NULL
			,ITEM_ID		NVARCHAR(50) NOT NULL
			,DOM_EXP		NVARCHAR(03) NOT NULL
			,FCST_TYPE		NVARCHAR(20) NOT NULL
			,INCOTERMS		NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID NVARCHAR(30) NOT NULL
			,MEASURE		NVARCHAR(50) NOT NULL
			,YYYYMMDD		NVARCHAR(08) NOT NULL
			,QTY			NUMERIC(30,10) NOT NULL
			);

			CREATE TABLE  #T2_VMI_MST_MAIN
			(DIVISION_ID	NVARCHAR(30) NOT NULL
			,PROJECT_CODE	NVARCHAR(50) NOT NULL
			,SCM_SITE_ID	NVARCHAR(30) NOT NULL
			,ITEM_ID		NVARCHAR(50) NOT NULL
			,DOM_EXP		NVARCHAR(03) NOT NULL
			,FCST_TYPE		NVARCHAR(20) NOT NULL
			,INCOTERMS		NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID NVARCHAR(30) NOT NULL
			,MEASURE		NVARCHAR(50) NOT NULL
			,YYYYMMDD		NVARCHAR(08) NOT NULL
			,QTY			NUMERIC(30,10) NOT NULL
			);

			CREATE TABLE  #T2_VMI_TEMP1
			(DIVISION_ID		NVARCHAR(30) NOT NULL
			,PROJECT_CODE		NVARCHAR(50) NOT NULL
			,SCM_SITE_ID		NVARCHAR(30) NOT NULL
			,ITEM_ID			NVARCHAR(50) NOT NULL
			,DOM_EXP			NVARCHAR(03) NOT NULL
			,FCST_TYPE			NVARCHAR(20) NOT NULL
			,INCOTERMS			NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
			,YYYYMMDD			NVARCHAR(08) NOT NULL
			,MEASURE			NVARCHAR(50) NOT NULL
			,QTY				NUMERIC(30,10) NOT NULL
			,ACCUM_SUM			NUMERIC(30,10) NOT NULL
			,last_accum_sum	NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_40_TEMP1_N1] ON [#T2_VMI_TEMP1]
			(
				DIVISION_ID ASC
			,PROJECT_CODE ASC
			,SCM_SITE_ID ASC
			,ITEM_ID ASC
			,DOM_EXP ASC
			,FCST_TYPE ASC
			,INCOTERMS ASC
			,PLANT_SITE_ID ASC
			,YYYYMMDD ASC
			,MEASURE ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			CREATE TABLE  #T2_VMI_TEMP2
			(DIVISION_ID		NVARCHAR(30) NOT NULL
			,PROJECT_CODE		NVARCHAR(50) NOT NULL
			,SCM_SITE_ID		NVARCHAR(30) NOT NULL
			,ITEM_ID			NVARCHAR(50) NOT NULL
			,DOM_EXP			NVARCHAR(03) NOT NULL
			,FCST_TYPE			NVARCHAR(20) NOT NULL
			,INCOTERMS			NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
			,YYYYMMDD			NVARCHAR(08) NOT NULL
			,MEASURE			NVARCHAR(50) NOT NULL
			,QTY				NUMERIC(30,10) NOT NULL
			,ACCUM_SUM			NUMERIC(30,10) NOT NULL
			,last_accum_sum	NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_40_TEMP2_N1] ON [#T2_VMI_TEMP2]
			(
				DIVISION_ID ASC
			,PROJECT_CODE ASC
			,SCM_SITE_ID ASC
			,ITEM_ID ASC
			,DOM_EXP ASC
			,FCST_TYPE ASC
			,INCOTERMS ASC
			,PLANT_SITE_ID ASC
			,YYYYMMDD ASC
			,MEASURE ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			CREATE TABLE  #T2_VMI_TEMP_all
			(DIVISION_ID		NVARCHAR(30) NOT NULL
			,PROJECT_CODE		NVARCHAR(50) NOT NULL
			,SCM_SITE_ID		NVARCHAR(30) NOT NULL
			,ITEM_ID			NVARCHAR(50) NOT NULL
			,DOM_EXP			NVARCHAR(03) NOT NULL
			,FCST_TYPE			NVARCHAR(20) NOT NULL
			,INCOTERMS			NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
			,YYYYMMDD			NVARCHAR(08) NOT NULL
			,RTF_QTY			NUMERIC(30,10) NOT NULL
			,INV				NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_40_TEMP_all_N1] ON [#T2_VMI_TEMP_all]
			(
				DIVISION_ID ASC
			,PROJECT_CODE ASC
			,SCM_SITE_ID ASC
			,ITEM_ID ASC
			,DOM_EXP ASC
			,FCST_TYPE ASC
			,INCOTERMS ASC
			,PLANT_SITE_ID ASC
			,YYYYMMDD ASC
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;

		END

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                TEMP TABLE SETTING (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                 MKT_FCST, RTF 대상 날짜및 값 추출 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (START)
		BEGIN
			--PRINT N'mkt_fcst  Cutoff RTF insert START               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			DELETE FROM DM_PLN_MKT_FCST_C
				WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_In_Plan')  -- 20190709 KHSONG [CSR ID:4027463] 'RTF_SYS_RP' MEASURE 추가
				and		DIVISION_ID			= @p_division_id
				AND     VERSION_NO			= @p_cut_off_version
				AND     cutoff_type			= @c_cutoff_TYPE
				and     cutoff_yyyymmdd     = @c_cutoff_yyyymmdd

				--SELECT @p_division_id,@c_plan_id,@plan_start_yyyymmdd,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd

			-----------------------------------------------------------------------
			SELECT		 distinct
						 a.DIVISION_ID
						,@p_cut_off_version AS VERSION_NO
						,@c_cutoff_TYPE     AS CUTOFF_TYPE
						,@c_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
						,a.PROJECT_CODE
						,a.SALES_SITE_ID AS SCM_SITE_ID
						,CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = ''   --20240610 KCW3408 
						      THEN A.ITEM_ID
						      ELSE A.FROM_ITEM_ID 
						 END AS ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('81','82','40') THEN 'VMI_In_Plan' ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
						--,PLANT_SITE_ID 
						,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
						,a.YYYYMMDD 
						,SUM(a.ALLOCATION_QTY) QTY
						,'SYSTEM'  CREATED_BY
						,GETDATE() CREATION_DATE
						,'SYSTEM'  LAST_UPDATED_BY
						,GETDATE() LAST_UPDATE_DATE

			INTO #T2_MKT_FCST_INSERT  -- 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임

			FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
   				inner join [DBO].[SCM_MST_SITE] C WITH(NOLOCK)
						on( a.division_id        =   C.division_id      
						AND a.sales_site_id      =   C.scm_site_id )
				WHERE a.DIVISION_ID          = @p_division_id
					and a.plan_id            = @c_plan_id
					and YYYYMMDD			>= @plan_start_yyyymmdd
			GROUP BY a.DIVISION_ID , a.PROJECT_CODE, a.SALES_SITE_ID
			       , CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = '' THEN A.ITEM_ID  ELSE A.FROM_ITEM_ID  END
				   , a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END, a.YYYYMMDD,c.VMI_YN
			-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.

			UNION ALL

			select  
					 a.[DIVISION_ID]
					,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.[PROJECT_CODE]
					,a.[SCM_SITE_ID]
					,a.[ITEM_ID]
					,a.[DOM_EXP]
					,a.[FCST_TYPE]
					,a.[INCOTERMS]
					,CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('81','82','40') THEN 'VMI_In_Plan' ELSE 'RTF_SCP'  END  --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					,a.[PLANT_SITE_ID]
					,a.[YYYYMMDD]
					,SUM( CASE  WHEN  c.VMI_YN = 'Y'        AND A.DIVISION_ID in ('81','82','40') AND MEASURE = 'VMI_In_Req' THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
								WHEN  c.VMI_YN <> 'Y'       AND A.DIVISION_ID in ('81','82','40') AND MEASURE = 'MKT_FCST'   THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
								WHEN  A.DIVISION_ID not in ('81','82','40') AND MEASURE = 'MKT_FCST'   THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
						ELSE 0  END ) QTY
						,'SYSTEM'  CREATED_BY
						,GETDATE() CREATION_DATE
						,'SYSTEM'  LAST_UPDATED_BY
						,GETDATE() LAST_UPDATE_DATE
				from DM_PLN_MKT_FCST_C a WITH(NOLOCK)
				inner join [DBO].[DM_MST_ITEM_SINGLE_V] b WITH(NOLOCK)
					on (a.division_id		= b.division_id
					and a.item_id			= b.item_id)
   				inner join [DBO].[SCM_MST_SITE] C WITH(NOLOCK)
						on( a.division_id        =   C.division_id      
						AND a.SCM_SITE_ID        =   C.scm_site_id )
				where 1=1
					and  A.DIVISION_ID		= @p_division_id
					AND  A.VERSION_NO		= @p_cut_off_version
					AND  A.cutoff_type		= @c_cutoff_TYPE
					and  A.cutoff_yyyymmdd  = @c_cutoff_yyyymmdd
					and  a.measure			= CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('81','82','40') THEN 'VMI_In_Req' ELSE 'MKT_FCST'  END -- VMI = 'Y'인경우에만 VMI_In_Req 'N'이면 MKT_FCST 사용 --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					-- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
					and (b.item_type in ('Q' , 'R' ) OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )
					AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
					)
				group by a.[DIVISION_ID]
				    ,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.[PROJECT_CODE]
					,a.[SCM_SITE_ID]
					,a.[ITEM_ID]
					,a.[DOM_EXP]
					,a.[FCST_TYPE]
					,a.[INCOTERMS]
					,CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('81','82','40') THEN 'VMI_In_Plan' ELSE 'RTF_SCP'  END --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					,a.[PLANT_SITE_ID]
					,a.[YYYYMMDD]

					
				UNION ALL
				-- RMA 처리 C20200518-000359
				select  
					 a.[DIVISION_ID]
					,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.[PROJECT_CODE]
					,a.[SCM_SITE_ID]
					,a.[ITEM_ID]
					,a.[DOM_EXP]
					,a.[FCST_TYPE]
					,a.[INCOTERMS]
					,'RTF_SCP'
					,a.[PLANT_SITE_ID]
					,a.[YYYYMMDD]
					,A.QTY
					,'SYSTEM'  CREATED_BY
					,GETDATE() CREATION_DATE
					,'SYSTEM'  LAST_UPDATED_BY
					,GETDATE() LAST_UPDATE_DATE
				from DM_PLN_MKT_FCST_C a WITH(NOLOCK)
				--JOIN ( SELECT 'RTF_SCP' AS MEASURE
				--		UNION ALL
				--		SELECT 'RTF_SYS_RP' AS MEASURE ) B ON 1=1
				where 1=1
					and  A.DIVISION_ID		= @p_division_id
					AND  A.VERSION_NO		= @p_cut_off_version
					AND  A.cutoff_type		= @c_cutoff_TYPE
					and  A.cutoff_yyyymmdd  = @c_cutoff_yyyymmdd
					and  a.measure			= 'MKT_FCST'
					AND a.division_id ='40'
					AND A.FCST_TYPE = 'RMA'

			-----------------------------------------------------------------------

			insert into DM_PLN_MKT_FCST_C
						(DIVISION_ID
						,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE
						)
			SELECT   DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS
					,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE
				FROM #T2_MKT_FCST_INSERT
				where DIVISION_ID          = @p_division_id

			UNION ALL

			SELECT   DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS
					,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE
				FROM #T2_MKT_FCST_INSERT
					WHERE MEASURE = 'RTF_SCP'  -- 20190709 KHSONG [CSR ID:4027463] MEASURE 추가 INSERT 
					and  DIVISION_ID          = @p_division_id
		END

		
		---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (END)
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
			------------------------------------------------------------------------------------------------
			--PRINT '#T2_VMI_MST_MAIN INSERT START                        =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
					-- 성능이슈로 TEMP테이블로 사용
					SELECT L.DIVISION_ID, l.SCM_SITE_ID, s.item_id, S.QTY
						INTO #FP_STOCK_QTY
						FROM scm_dnm_stock_sn s with(nolock)
							,scm_mst_location l with(nolock)
						where l.division_id = s.division_id
						and l.storage_id = s.storage_id
						and convert( varchar, s.cutoff_date,112)  = @plan_start_yyyymmdd

					-- INSERT
					insert into #T2_VMI_MST_MAIN  -- 
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
					select  distinct
												a.DIVISION_ID 				,
												a.PROJECT_CODE 				,
												a.SCM_SITE_ID 				,
												a.ITEM_ID 					,
												a.DOM_EXP 					,
												a.FCST_TYPE 				,
												a.INCOTERMS 				,
												a.measure					,
												a.PLANT_SITE_ID 			,
												b.BASIS_YYYYMMDD   YYYYMMDD ,
												-- vmi stock qty 를 초재고로 적용 (S)
												CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ('Vmi_In_Plan')  THEN ISNULL(c.qty,0) + ISNULL(( SELECT SUM(s.qty)  
																																FROM #FP_STOCK_QTY S
																																where S.SCM_SITE_ID = A.SCM_SITE_ID
																																AND S.DIVISION_ID   = A.DIVISION_ID
																																and s.item_id like  (case when substring(a.ITEM_ID, 1,2) = 'MP' THEN substring( a.ITEM_ID, 1,11) ELSE a.ITEM_ID END ) +'%' 
																																) ,0)
														ELSE ISNULL(c.qty,0) END QTY
												-- vmi stock qty 를 초재고로 적용 (E)
						from ( SELECT DISTINCT W.DIVISION_ID 				,
												W.PROJECT_CODE 				,
												W.SCM_SITE_ID 				,
												W.ITEM_ID 					,
												W.DOM_EXP 					,
												W.FCST_TYPE 				,
												W.INCOTERMS 				,
												W.measure					,
												W.PLANT_SITE_ID 			
										FROM DM_PLN_MKT_FCST_C W with(nolock) 
										INNER JOIN [DBO].[SCM_MST_SITE] ST WITH(NOLOCK)
											ON  w.division_id        =   st.division_id      
											AND w.scm_site_id        =   st.scm_site_id  
											AND	ST.VMI_YN			 =   'Y'  -- vmi대상만 입력
										and		W.DIVISION_ID			= @p_division_id
										AND     W.VERSION_NO			= @p_cut_off_version
										AND     W.cutoff_type			= @c_cutoff_TYPE
										and     W.cutoff_yyyymmdd       = @c_cutoff_yyyymmdd

									WHERE W.YYYYMMDD between @plan_start_yyyymmdd
								AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
								) A
						inner join SCM_SYS_CALENDAR_M  b with(nolock)
							on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
								AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
						left join DM_PLN_MKT_FCST_C c with(nolock)
							ON		a.division_id		= c.division_id
							AND		a.project_code		= c.project_code
							AND		a.scm_site_id		= c.scm_site_id
							AND		a.item_id			= c.item_id
							AND		a.dom_exp			= c.dom_exp
							AND		a.fcst_type			= c.fcst_type
							AND		a.incoterms			= c.incoterms
							AND		a.plant_site_id		= c.plant_site_id
							and     a.measure			= c.measure
							and     b.BASIS_YYYYMMDD    = c.yyyymmdd
							and		C.DIVISION_ID		= @p_division_id
							AND     C.VERSION_NO		= @p_cut_off_version
							AND     C.cutoff_type		= @c_cutoff_TYPE
							and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
						where 1=1
						and a.measure in ('MKT_FCST', 'Vmi_In_Plan') -- MKT_FCST랑 VMI_IN_PLAN

			--PRINT '#T2_VMI_temp1 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

					INSERT INTO #T2_VMI_MST
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp, a.fcst_type, a.incoterms, a.measure, a.plant_site_id, a.yyyymmdd,a.qty
						FROM #T2_VMI_MST_MAIN A
							WHERE 1=1

					--
					insert into #T2_VMI_temp1
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)

					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY , SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
						,SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
						FROM #T2_VMI_MST A
						where a.measure		= 'MKT_FCST'
						and a.yyyymmdd		>= @plan_start_yyyymmdd

					--PRINT '#T2_VMI_temp2 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|

					insert into #T2_VMI_temp2
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)

					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY , SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
						,SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
						FROM #T2_VMI_MST A
						where a.measure		= 'Vmi_In_Plan'
						and a.yyyymmdd		>= @plan_start_yyyymmdd

			---------------------------------------------------------------------------------------- 

			--PRINT '#T2_VMI_temp_all INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

			insert into #T2_VMI_temp_all
			(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,yyyymmdd,RTF_QTY,INV)
			select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.plant_site_id,a.yyyymmdd
					,SUM( case when isnull(a.accum_sum,0) > isnull(b.accum_sum,0) then isnull(b.accum_sum,0) else isnull(a.accum_sum,0) end ) - SUM( case when isnull(a.last_accum_sum,0) > isnull(b.last_accum_sum,0) then isnull(b.last_accum_sum,0) else isnull(a.last_accum_sum,0) end ) RTF_QTY
					,SUM(isnull(b.accum_sum,0) - isnull(a.accum_sum,0)) INV
				from #T2_VMI_temp1 a  --  'MKT_FCST'
					,#T2_VMI_temp2 b  --  'Vmi_In_Plan'
				where a.division_id	= b.DIVISION_ID
				and a.project_code	= b.project_code
				and a.scm_site_id	= b.scm_site_id
				and a.item_id		= b.ITEM_ID
				and a.fcst_type		= b.FCST_TYPE
				and a.incoterms		= b.incoterms
				and a.plant_site_id	= b.PLANT_SITE_ID
				and a.dom_exp		= b.dom_exp
				and a.yyyymmdd		= b.YYYYMMDD
			group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
			order by a.yyyymmdd
			;

			--PRINT 'DM_PLN_MKT_FCST VMI_Inv DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 초기화 (START)
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST_C
				where MEASURE IN ('VMI_Inv','RTF_SCP')
					and		DIVISION_ID		  = @p_division_id
					and     VERSION_NO		  = @p_cut_off_version
					and     cutoff_type		  = @c_cutoff_TYPE
					and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
					and exists (
							SELECT division_id 
								FROM #T2_VMI_MST
								where 1=1
								and DM_PLN_MKT_FCST_C.division_id        =   division_id      
								AND DM_PLN_MKT_FCST_C.project_code       =   project_code   
								AND DM_PLN_MKT_FCST_C.scm_site_id        =   scm_site_id  
								AND DM_PLN_MKT_FCST_C.item_id            =   item_id      
								AND DM_PLN_MKT_FCST_C.dom_exp            =   dom_exp      
								AND DM_PLN_MKT_FCST_C.fcst_type          =   fcst_type    
								AND DM_PLN_MKT_FCST_C.incoterms          =   incoterms    
								AND DM_PLN_MKT_FCST_C.plant_site_id      =   plant_site_id
								AND DM_PLN_MKT_FCST_C.yyyymmdd           >=   @plan_start_yyyymmdd  -- 월요일
								);

			--PRINT 'DM_PLN_MKT_FCST VMI_Inv INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 계산된 VMI_Inv값 INSERT (START)
			insert into DM_PLN_MKT_FCST_C
						( DIVISION_ID
						,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
			select division_id 
			      ,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
				 , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_SCP' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,rtf_qty as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND rtf_qty > 0 

			-- 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가(START)
			UNION ALL
			select division_id 
			      ,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
				 , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_SYS_RP' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,rtf_qty as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND rtf_qty > 0 
			-- 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가(END)

			union

			select division_id 
			      ,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
				  ,project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'VMI_Inv' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,INV as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND inv > 0 

			---------------------------------- 계산된 VMI_Inv값 INSERT (END)

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                MKT_FCST CUTOFF QTY_BALANCE_CREATE (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
		
		--PRINT N'BALANCE #T2_CUTOFF_MST INSERT                    =>' + CONVERT(VARCHAR(8), GETDATE(), 108)

		INSERT INTO #T2_CUTOFF_MST
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,MEASURE,YYYYMMDD,QTY)
		SELECT ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE, ZZ.YYYYMMDD, max(ISNULL(C.QTY,0))
			FROM 
			 (
			  SELECT * from 
			  (
				SELECT DISTINCT A.division_id, A.project_code, A.scm_site_id, A.item_id, A.dom_exp, A.fcst_type, A.incoterms, A.plant_site_id
					from DM_PLN_MKT_FCST_C A WITH(NOLOCK) WHERE 1=1
						AND     A.MEASURE		   IN ('MKT_FCST','RTF_SCP')
						AND     A.QTY				> 0
						and		DIVISION_ID			= @p_division_id
						AND     A.VERSION_NO		= @p_cut_off_version
						AND     A.cutoff_type		= @c_cutoff_TYPE
						and     A.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
			   ) TARGET_DATA
			   ,(
				SELECT 'MKT_FCST' MEASURE
				UNION ALL
				SELECT 'RTF_SCP' MEASURE
			   ) MEASURE
				,		(
						SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
							FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK)
							WHERE C.BASIS_YYYYMMDD between @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
							AND ((  C.PARTIAL_YN   = 'Y' AND C.END_FLAG ='Y' ) OR  ( C.DAYOFWEEK IN ('SUN') ) )
						UNION
						select	distinct C.YYYYMMDD AS YYYYMMDD
							from DM_PLN_MKT_FCST_C C WITH(NOLOCK) WHERE 1=1
								AND     C.MEASURE		   IN ('MKT_FCST','RTF_SCP')
								AND     C.QTY				> 0
								and		DIVISION_ID			= @p_division_id
								AND     C.VERSION_NO		= @p_cut_off_version
								AND     C.cutoff_type		= @c_cutoff_TYPE
								and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
						) DS
				) ZZ
				LEFT JOIN DM_PLN_MKT_FCST_C C WITH(NOLOCK)
												ON		ZZ.division_id		= C.DIVISION_ID
												AND		ZZ.project_code		= C.PROJECT_CODE
												AND		ZZ.scm_site_id		= C.SCM_SITE_ID
												AND		ZZ.item_id			= C.ITEM_ID
												AND		ZZ.dom_exp			= C.DOM_EXP
												AND		ZZ.fcst_type		= C.FCST_TYPE
												AND		ZZ.incoterms		= C.INCOTERMS
												AND		ZZ.plant_site_id	= C.PLANT_SITE_ID
												AND     ZZ.MEASURE          = C.MEASURE
												AND     ZZ.YYYYMMDD         = C.YYYYMMDD
												and		C.DIVISION_ID		= @p_division_id
												AND     C.VERSION_NO		= @p_cut_off_version
												AND     C.cutoff_type		= @c_cutoff_TYPE
												and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

		group by ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE,ZZ.YYYYMMDD

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		INSERT into #T2_CUTOFF_MST_ACCUM
		select *, SUM(QTY) over ( partition by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, measure order by yyyymmdd) accum_sum
			from #T2_CUTOFF_MST

		INSERT into #T2_CUTOFF_TEMPX
		select division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,  'BALANCE' measure, yyyymmdd,  SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN 0 ELSE accum_sum END)  - SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN accum_sum ELSE 0 END) AS ACCUM_X
			from #T2_CUTOFF_MST_ACCUM
		group by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, yyyymmdd

		--PRINT N'BALANCE DM_PLN_MKT_FCST_C DELETE                =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 초기화 (START)
		WHILE @@ROWCOUNT > 0
			BEGIN
				DELETE TOP (10000)
				FROM dbo.DM_PLN_MKT_FCST_C
					where MEASURE		= 'BALANCE'
					and		DIVISION_ID			= @p_division_id
					AND     VERSION_NO			= @p_cut_off_version
					AND     cutoff_type			= @c_cutoff_TYPE
					and     cutoff_yyyymmdd     = @c_cutoff_yyyymmdd
			END
		---------------------------------- 초기화 (END)
					

		--PRINT N'BALANCE DM_PLN_MKT_FCST_C insert                =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 계산된 BALANCE값 INSERT (START)
		WHILE @@ROWCOUNT > 0
			BEGIN
				insert into DM_PLN_MKT_FCST_C
							( DIVISION_ID,VERSION_NO,cutoff_type,cutoff_yyyymmdd,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
							,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
				select  TOP (10000)
						division_id ,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd, project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE' measure ,plant_site_id, yyyymmdd, ACCUM_X
					,'BALANCE_MAKE',getdate(),'BALANCE_MAKE',getdate(), null,null,null,null,null,null,null,null,null,null
				from  #T2_CUTOFF_TEMPX
					WHERE 1=1
						AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
						AND ACCUM_X <> 0                                -- ZERO 값은 불필요
			END
		---------------------------------- 계산된 BALANCE값 INSERT (END)


		END

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                MKT_FCST CUTOFF QTY_BALANCE_CREATE (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎


		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                  VMI DIO 계산로직 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN

		--PRINT 'DM_PLN_MKT_FCST VMI_DIO DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			-- 수행전 삭제
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST_C
				where MEASURE = 'VMI_DIO'
					and		DIVISION_ID		  = @p_division_id
					and     VERSION_NO		  = @p_cut_off_version
					and     cutoff_type		  = @c_cutoff_TYPE
					and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

			-- VMI_DIO INSERT
			insert into dbo.DM_PLN_MKT_FCST_C
			(	 DIVISION_ID
				,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
				,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
				,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
				,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
				,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
			)
			select   distinct
					 a.DIVISION_ID
			        ,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.PROJECT_CODE
					,a.SCM_SITE_ID
					,a.ITEM_ID
					,a.DOM_EXP
					,a.FCST_TYPE
					,a.INCOTERMS
					,'VMI_DIO' AS MEASURE
					,a.PLANT_SITE_ID
					,a.YYYYMMDD
					--,QTY
					,ISNULL( datediff( day, cast( a.yyyymmdd as datetime) , cast ( (
					select min(yyyymmdd)
						from 
							(
								select yyyymmdd, SUM(QTY) over ( partition by a.division_id order by yyyymmdd) accum_sum
								from DM_PLN_MKT_FCST_C b with(nolock)
								where   a.division_id   = b.division_id
									and a.project_code  = b.project_code
									and a.scm_site_id   = b.scm_site_id
									and a.item_id       = b.item_id
									and a.dom_exp       = b.dom_exp
									and a.fcst_type     = b.FCST_TYPE
									and a.incoterms     = b.incoterms
									and a.PLANT_SITE_ID = b.plant_site_id
									and b.measure       = 'RTF_SCP'
									and b.yyyymmdd      > a.[YYYYMMDD]
									and	b.DIVISION_ID		= @p_division_id
									and b.VERSION_NO		= @p_cut_off_version
									and b.cutoff_type		= @c_cutoff_TYPE
									and b.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
							) zz
						where accum_sum >= a.qty
					) as datetime )  ) , 999 ) QTY
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
				,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				from DM_PLN_MKT_FCST_C a with(nolock)
					inner join #T2_VMI_MST_MAIN s
					on (            A.division_id        =   s.division_id      
								AND A.project_code       =   s.project_code   
								AND A.scm_site_id        =   s.scm_site_id  
								AND A.item_id            =   s.item_id      
								AND A.dom_exp            =   s.dom_exp      
								AND A.fcst_type          =   s.fcst_type    
								AND A.incoterms          =   s.incoterms    
								AND A.plant_site_id      =   s.plant_site_id
								AND A.yyyymmdd           >=   @plan_start_yyyymmdd  -- 월요일
								)
				where 1=1
				and a.measure = 'VMI_Inv'
				and a.qty > 0 
				and	a.DIVISION_ID		= @p_division_id
				and a.VERSION_NO		= @p_cut_off_version
				and a.cutoff_type		= @c_cutoff_TYPE
				and a.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                  VMI DIO 계산로직 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      Sales Plan  Cutoff 정보 변경 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
				--PRINT 'dm_pln_sales_plan_c DELETE START               =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|

				-- 기존 정보 삭제
				delete dbo.dm_pln_sales_plan_c
				-- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
				 where yyyymmdd >= @plan_start_yyyymmdd
				   and division_id = @p_division_id --@v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @plan_start_yyyymmdd
							   and a.division_id    = dm_pln_sales_plan_c.division_id
							   and a.project_code   = dm_pln_sales_plan_c.project_code
							   and a.scm_site_id    = dm_pln_sales_plan_c.scm_site_id
							   and a.item_id        = dm_pln_sales_plan_c.item_id
				       ) = 0
				   and version_no = @c_SP_version
				   and MEASURE in ('SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','RTF_SCP','RTF_SYS_RP')  -- 20181024 KHSONG measure 조건추가 --20190903 KHSONG 'RTF_SYS_RP' MEASURE 추가
				   --and MEASURE in ('SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','RTF') -- 20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함 -- 20191028 KHSONG Cutoff Version 'RTF' Measure 삭제 오류로직 수정
				 ;        
				                  
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF_SCP' 는 다시 계산.
				delete dbo.dm_pln_sales_plan_c
				 where yyyymmdd >= @plan_start_yyyymmdd
				   and division_id = @p_division_id --@v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   and MEASURE in ( 'RTF_SCP' )  -- 20180417 modify skh
				   --and MEASURE in ( 'RTF' )  --20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함  --20191028 KHSONG Cutoff Version 'RTF' Measure 삭제 오류로직 수정
				   and version_no = @c_SP_version
				;

				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
					BEGIN 
						DROP TABLE  #SALES_PLAN_TEMP          
					END 
                 
			  	SELECT TOP 0 	
					  DIVISION_ID
					, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY
					, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 
				INTO #SALES_PLAN_TEMP  
				FROM dbo.dm_pln_sales_plan WITH(NOLOCK);
				
				--PRINT '#SALES_PLAN_TEMP insert                        =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
                INSERT INTO #SALES_PLAN_TEMP
				-- RTF_SCP 값을 update 함.
				select    
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,w.CREATED_BY
						,w.CREATION_DATE
						,'-1' -- @v_created_by					    --[2018-03-15][수정][입력받은 매개변수로 처리]		
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.DM_PLN_MKT_FCST_C w WITH(NOLOCK)
					INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
					ON   basis_yyyymmdd = w.yyyymmdd
					left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @c_SP_version ) si
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
					--	and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
					    and CAL.basis_start_date     = si.yyyymmdd
						AND SI.MEASURE = 'KRW' 
					)
					--where w.measure = 'RTF_SCP'
					where w.measure in ('RTF','RTF_SCP')  --20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함  -- 20191028 KHSONG Cutoff Version 'RTF' Measure 삭제 오류로직 수정
					and w.division_id = @p_division_id --@v_division_id
					and w.yyyymmdd >= @plan_start_yyyymmdd
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
					and w.version_no = @p_cut_off_version
				UNION ALL 
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_KRW' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,fp.CURRENCY
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						,'-1' -- @v_created_by						--[2018-03-15][수정]
						,GETDATE()							--[2018-03-15][수정]
						,'SYSTEM'						--[2018-03-15][수정]
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.DM_PLN_MKT_FCST_C w  WITH(NOLOCK)
					INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL WITH(NOLOCK)
					ON   basis_yyyymmdd = w.yyyymmdd
					left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @c_SP_version ) FP 
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						-- AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						and CAL.basis_start_date     = FP.yyyymmdd
						AND FP.MEASURE = 'KRW' 
					   )
					--where w.measure = 'RTF_SCP'
					-- where w.measure = 'RTF'  --20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
					--where w.measure = CASE WHEN @p_division_id = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
					where w.measure = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
					and w.division_id = @p_division_id --@v_division_id
					and w.yyyymmdd >= @plan_start_yyyymmdd
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @plan_start_yyyymmdd
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
                    and w.version_no = @p_cut_off_version
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_LOC' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,FP.CURRENCY
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						,'-1' -- @v_created_by							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,'SYSTEM'    							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1	
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.DM_PLN_MKT_FCST_C w  WITH(NOLOCK)
					INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL WITH(NOLOCK)
					ON   basis_yyyymmdd = w.yyyymmdd
					left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @c_SP_version ) FP 
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						-- AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )
						and CAL.basis_start_date     = FP.yyyymmdd
						AND FP.MEASURE = 'LOC' 
					   )
						--where w.measure = 'RTF_SCP'
					--where w.measure = 'RTF'  --20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
					--where w.measure = CASE WHEN @p_division_id = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
					where w.measure = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
					and w.division_id = @p_division_id --@v_division_id
				    and w.yyyymmdd >= @plan_start_yyyymmdd   
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				    and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @plan_start_yyyymmdd
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
					and w.version_no = @p_cut_off_version
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_USD' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,FP.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						,'-1' -- @v_created_by								--[2018-03-15][수정]
						,GETDATE()									--[2018-03-15][수정]
						,'SYSTEM'    							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.DM_PLN_MKT_FCST_C w  WITH(NOLOCK)
					INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL WITH(NOLOCK)
					ON   basis_yyyymmdd = w.yyyymmdd
					left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @c_SP_version ) FP 
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						-- AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						and CAL.basis_start_date     = FP.yyyymmdd
						AND FP.MEASURE = 'USD' 
					   )
					--where w.measure = 'RTF_SCP'
					--where w.measure = 'RTF'  --20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
					--where w.measure = CASE WHEN @p_division_id = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
					where w.measure = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
					and w.division_id = @p_division_id --@v_division_id
				   and w.yyyymmdd >= @plan_start_yyyymmdd     
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @plan_start_yyyymmdd
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
					and w.version_no = @p_cut_off_version
					; 


				   BEGIN

						--PRINT 'dm_pln_sales_plan_c DELETE2                    =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
						----------------------------------------------------------|
					   DELETE 
					   FROM dbo.dm_pln_sales_plan_c
					   WHERE exists(
								SELECT B.DIVISION_ID 
								  FROM #SALES_PLAN_TEMP B WITH(NOLOCK)
								 where 1=1
								   and dm_pln_sales_plan_c.DIVISION_ID    =  B.DIVISION_ID  
								   and dm_pln_sales_plan_c.PROJECT_CODE   =  B.PROJECT_CODE                          
								   and dm_pln_sales_plan_c.SCM_SITE_ID    =  B.SCM_SITE_ID                           
								   and dm_pln_sales_plan_c.ITEM_ID        =  B.ITEM_ID                               
								   and dm_pln_sales_plan_c.DOM_EXP        =  B.DOM_EXP                               
								   and dm_pln_sales_plan_c.FCST_TYPE      =  B.FCST_TYPE                             
								   and dm_pln_sales_plan_c.INCOTERMS      =  B.INCOTERMS                             
								   and dm_pln_sales_plan_c.MEASURE        =  B.MEASURE                               
								   and dm_pln_sales_plan_c.PLANT_SITE_ID  =  B.PLANT_SITE_ID                         
								   and dm_pln_sales_plan_c.YYYYMMDD       =  B.YYYYMMDD                              
							  )
                        and version_no = @c_SP_version
						and division_id = @p_division_id
				   END

                -- version 관련 정보 추가해야 함. 
				--PRINT 'dm_pln_sales_plan_c INSERT  INTO               =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
				INSERT  INTO  dbo.dm_pln_sales_plan_c 
				(
					  DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY
					, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				)
				SELECT distinct 
					   DIVISION_ID, @c_SP_version, @c_SP_TYPE,@c_cutoff_yyyymmdd
					  ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE
					  ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_PLAN_TEMP WITH(NOLOCK)
				where division_id = @p_division_id
				-- 20190903 KHSONG [CSR ID:4066366] 추가사항 (BEGIN)
				UNION ALL

				SELECT distinct 
					   DIVISION_ID, @c_SP_version, @c_SP_TYPE,@c_cutoff_yyyymmdd
					   ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					   ,INCOTERMS
					   ,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_PLAN_TEMP WITH(NOLOCK)
					WHERE MEASURE = 'RTF_SCP'
					and division_id = @p_division_id
				-- 20190903 KHSONG [CSR ID:4066366] 추가사항 (END)
		;
		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      Sales Plan  Cutoff 정보 변경 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 트랜잭션 (COMMIT)
    --COMMIT WORK;
	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@p_cut_off_version : ' + RTRIM(LTRIM(@p_cut_off_version)) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			--ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
  END;

