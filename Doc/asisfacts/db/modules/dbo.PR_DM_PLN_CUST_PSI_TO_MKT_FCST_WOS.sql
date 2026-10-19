
/*
 * Program ID   : PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS
 * Description  : MKT FCST - PSI Production Result Mapping 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 02. 20    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * '20180411 임시 주석처리' lead time 부분확인후 풀어야함
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
*/

-- DM_MST_CUSTOMER_FCST.CUSTOMER_PSI = 'S' 인 경우만 수행되는 Procedure

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS]

	-- Add the parameters for the stored procedure here
	 @p_division_id        NVARCHAR(MAX)
	,@p_project_code       NVARCHAR(MAX)
	,@p_incoterms          NVARCHAR(MAX)
	,@p_scm_site_id        NVARCHAR(MAX)
	,@p_plant_site_id      NVARCHAR(MAX)
	,@p_dom_exp            NVARCHAR(MAX)
	,@p_fcst_type          NVARCHAR(MAX)
	,@p_item_id            NVARCHAR(MAX)
	,@p_mon_day            NVARCHAR(MAX)  -- 업로드 데이터의 시작일자 받음

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	-- LOG 용 변수 설정

	-- 변수 설정
    DECLARE @v_division_id		        nvarchar(MAX)    ;
    DECLARE @v_scm_site_id		        nvarchar(MAX)    ;
    DECLARE @v_plant_site_id		    nvarchar(MAX)    ;
    DECLARE @v_item_id                  nvarchar(MAX)    ;
    DECLARE @v_project_code             nvarchar(MAX)    ;
    DECLARE @v_incoterms                nvarchar(MAX)    ;
    DECLARE @v_dom_exp                  nvarchar(MAX)    ;
    DECLARE @v_fcst_type                nvarchar(MAX)    ;

    DECLARE @v_measure1                 nvarchar(MAX)    ;
    DECLARE @v_measure2                 nvarchar(MAX)    ;
    DECLARE @v_measure3                 nvarchar(MAX)    ;
    DECLARE @v_measure4                 nvarchar(MAX)    ;
    DECLARE @v_measure5                 nvarchar(MAX)    ;
    DECLARE @v_measure6					nvarchar(MAX)    ;
    DECLARE @v_measure7				    nvarchar(MAX)    ;
	DECLARE @v_measure8				    nvarchar(MAX)    ;
	DECLARE @v_measure9				    nvarchar(MAX)    ;
	DECLARE @v_measure10				nvarchar(MAX)    ;
    DECLARE @n_result_start_date    	AS NVARCHAR(8)   ;  
    DECLARE @n_mkt_fcst_delete_count    INTEGER = 0      ;
    DECLARE @n_inv_count                INTEGER = 0      ;
    DECLARE @n_mkt_count                INTEGER = 0      ;
    DECLARE @v_last_day    				AS NVARCHAR(8)   ;  




	--====================================================== 입력변수 셋팅 start
	set @v_division_id        =  @p_division_id
	set @v_item_id            =  @p_item_id
	set @v_project_code       =  @p_project_code
	set @v_incoterms          =  @p_incoterms
	set @v_scm_site_id        =  @p_scm_site_id
	set @v_plant_site_id      =  @p_plant_site_id

	set @v_dom_exp            =  @p_dom_exp
	set @v_fcst_type          =  @p_fcst_type
	set @n_result_start_date  =  @p_mon_day        -- CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(SYSDATETIME(), 'MON')), 112)

	set @v_measure1           = 'CUST_WHIN_P'    -- 고객제시물동에 고객입고계획 수량을 생성
	set @v_measure2           = 'MKT_WHIN_P'     -- 자사예측물동에 고객입고계획 수량을 생성

	set @v_measure6           = 'MKT_Product_S'  -- sales
	set @v_measure8           = 'CUST_Product_S' -- sales

	set @v_measure4           = 'CUST_INV_I'     -- 고객제시물동에 고객예상재고(I)
	set @v_measure5           = 'MKT_INV_I'      -- 자사예측물동에 고객예상재고(I)

	set @v_measure7           = 'CUST_DIO'        -- 고객제시물동에 WOS(I) 수량을 생성
	set @v_measure9           = 'MKT_DIO'         -- 자사제시물동에 WOS(I) 수량을 생성
	
	set @v_measure3           = 'MKT_FCST'         -- MKT FCST
	set @v_measure10          = 'CUST_FCST'        -- Customer FCST
	-- 
	set @v_last_day           = CONVERT(CHAR(8), DATEADD(DD, +7 * 27, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112)		-- 미래 6개월치로 설정해놓았음
	-- 
	--====================================================== 입력변수 셋팅 end
	


BEGIN
		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)
END
		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUST_PSI_TO_MKT_FCST_WOS;  -- ssss

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	


		BEGIN	

		  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'psi_wos_cur')
			BEGIN
				CLOSE psi_wos_cur
				DEALLOCATE psi_wos_cur
			END;

			-- 20180411
	   --      begin
			 --    SELECT 'SELECT #TEMP4_DM_PLN_MKT_FCST$ wos procedure'
			 --    SELECT COUNT(*) AS TEMP4_COUNT_wos  FROM #TEMP4_DM_PLN_MKT_FCST$
			 --    SELECT * FROM #TEMP4_DM_PLN_MKT_FCST$ ORDER BY YYYYMMDD
			 --end
			-- 20180411

		
		-- 고객제시물동에 고객입고계획 수량을 생성
		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 WHERE 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure      in ( @v_measure1, @v_measure2 )  -- 'CUST_WHIN_P', 'MKT_WHIN_P'
		   and yyyymmdd     >= @n_result_start_date
		;
		-- DIVISION_ID,,,SCM_SITE_ID,DOM_EXP,FCST_TYPE,,MEASURE,INCOTERMS,PLANT_SITE_ID

		INSERT INTO [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
		SELECT [DIVISION_ID]
			  ,[PROJECT_CODE]
			  ,[SCM_SITE_ID]
			  ,[ITEM_ID]
			  ,[DOM_EXP]
			  ,[FCST_TYPE]
			  ,[INCOTERMS]
			  ,@v_measure6   -- 'MKT_Product_S' 
			  ,[PLANT_SITE_ID]
			  -- Customer L/T이 있으면 그 값만큼 뒤로 밀어주도록 함.
			  ,[YYYYMMDD]
			  ,[QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
		  FROM [dbo].[#TEMP4_DM_PLN_MKT_FCST$] mf 
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure  in (
														SELECT distinct w.MEASURE --+ '_new'
														  FROM [dbo].[DM_MST_CUSTOMER_FCST] w
														      ,(
														          select max(plan_week) plan_week
														            from [dbo].[DM_MST_CUSTOMER_FCST]
														        ) u
														 where w.MEASURE_GROUP = 'PSI'
														   and w.VALID_YN      = 'Y'
														   and w.CUSTOMER_PSI  = 'S'	  -- Sales Measure
														   and w.scm_site_id   = mf.scm_site_id
														   and w.division_id   = mf.division_id
														   and w.plan_week     = u.plan_week	   
		                   )
		   and YYYYMMDD >= @n_result_start_date
		 order by YYYYMMDD 
		;
		
		INSERT INTO [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
		SELECT [DIVISION_ID]
			  ,[PROJECT_CODE]
			  ,[SCM_SITE_ID]
			  ,[ITEM_ID]
			  ,[DOM_EXP]
			  ,[FCST_TYPE]
			  ,[INCOTERMS]
			  ,@v_measure8   -- 'CUST_Product_S'
			  ,[PLANT_SITE_ID]
			  -- Customer L/T이 있으면 그 값만큼 뒤로 밀어주도록 함.
			  ,[YYYYMMDD]
			  ,[QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
		  FROM [dbo].[#TEMP4_DM_PLN_MKT_FCST$] mf 
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure  in (
														SELECT distinct w.MEASURE -- + '_new'
														  FROM [dbo].[DM_MST_CUSTOMER_FCST] w
														      ,(
														          select max(plan_week) plan_week
														            from [dbo].[DM_MST_CUSTOMER_FCST]
														        ) u
														 where w.MEASURE_GROUP = 'PSI'
														   and w.VALID_YN      = 'Y'
														   and w.CUSTOMER_PSI  = 'S'	  -- Sales Measure
														   and w.scm_site_id   = mf.scm_site_id
														   and w.division_id   = mf.division_id
														   and w.plan_week     =  u.plan_week	   
		                   )
		   and YYYYMMDD >= @n_result_start_date
		 order by YYYYMMDD 
		;		

		
		-- 고객제시물동에 고객입고계획 수량을 생성
		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure1  -- 'CUST_WHIN_P'
		   and yyyymmdd     >= @n_result_start_date

/*  20180411 임시 주석처리
		   and yyyymmdd    >= convert( varchar, 
								   cast( @n_result_start_date as datetime )  - ISNULL( (   select max(lt_total)
			     																   from [dbo].SCP_MST_BOD_V bod WITH(NOLOCK)
																				  where bod.from_site = [#TEMP4_DM_PLN_MKT_FCST$].plant_site_id
																					and bod.to_site   = [#TEMP4_DM_PLN_MKT_FCST$].SCM_SITE_ID
																					and bod.incoterms = [#TEMP4_DM_PLN_MKT_FCST$].INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
										 , 112)      -- Upload 시작 시점 또는 당주차 월요일에서 customer_lt이 빠진 기간에서 부터 시작 함.
*/
		;

		INSERT INTO [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
		SELECT [DIVISION_ID]
			  ,[PROJECT_CODE]
			  ,[SCM_SITE_ID]
			  ,[ITEM_ID]
			  ,[DOM_EXP]
			  ,[FCST_TYPE]
			  ,[INCOTERMS]
			  ,@v_measure1 -- 'CUST_WHIN_P' 
			  ,[PLANT_SITE_ID]
			  ,YYYYMMDD
/*  20180411 임시 주석처리
			  -- Customer L/T이 있으면 그 값만큼 뒤로 밀어주도록 함.
			  , convert( varchar, 
				   cast( [YYYYMMDD] as datetime )  + ISNULL( (   select max(lt_total)
			     												   from [dbo].SCP_MST_BOD_V bod WITH(NOLOCK)
																  where bod.from_site = mf.plant_site_id
																	and bod.to_site   = mf.SCM_SITE_ID
																	and bod.incoterms = mf.INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
						 , 112)  yyyymmdd
*/
			  ,[QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
		  FROM [dbo].[DM_PLN_MKT_FCST] mf WITH(NOLOCK)
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure10   -- 'CUST_FCST' 
		   and yyyymmdd     >= @n_result_start_date

/*  20180411 임시 주석처리
		   and YYYYMMDD     >= convert( varchar, 
							   cast( @n_result_start_date as datetime )  - ISNULL( (   select max(lt_total)
			     															   from [dbo].SCP_MST_BOD_V bod WITH(NOLOCK)
																			  where bod.from_site = mf.plant_site_id
																				and bod.to_site   = mf.SCM_SITE_ID
																				and bod.incoterms = mf.INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
									 , 112)      -- Upload 시작 시점 또는 당주차 월요일에서 customer_lt이 빠진 기간에서 부터 시작 함.
*/
		 order by YYYYMMDD 
		;

		-- 자사예측물동에 고객입고계획 수량을 생성


		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure2  -- 'MKT_WHIN_P'
		   and yyyymmdd     >= @n_result_start_date

/*  20180411 임시 주석처리
		   and YYYYMMDD     >= convert( varchar, 
								   cast( @n_result_start_date as datetime )  - ISNULL( (   select max(lt_total)
			     																   from [dbo].SCP_MST_BOD_V bod WITH(NOLOCK)
																				  where bod.from_site = [#TEMP4_DM_PLN_MKT_FCST$].plant_site_id
																					and bod.to_site   = [#TEMP4_DM_PLN_MKT_FCST$].SCM_SITE_ID
																					and bod.incoterms = [#TEMP4_DM_PLN_MKT_FCST$].INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
										 , 112)      -- Upload 시작 시점 또는 당주차 월요일에서 customer_lt이 빠진 기간에서 부터 시작 함.
*/
		;

		--확인 select @n_result_start_date as 'select @n_result_start_date'
		INSERT INTO [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
		SELECT [DIVISION_ID]
			  ,[PROJECT_CODE]
			  ,[SCM_SITE_ID]
			  ,[ITEM_ID]
			  ,[DOM_EXP]
			  ,[FCST_TYPE]
			  ,[INCOTERMS]
			  ,@v_measure2 -- 'MKT_WHIN_P'
			  ,[PLANT_SITE_ID]
		      ,YYYYMMDD

/*  20180411 임시 주석처리
			  -- Customer L/T이 있으면 그 값만큼 뒤로 밀어주도록 함.
			  , convert( varchar, 
				   cast( [YYYYMMDD] as datetime )  + ISNULL( (   select max(lt_total)
			     												   from [dbo].SCP_MST_BOD_V bod WITH(NOLOCK)
																  where bod.from_site = mf.plant_site_id
																	and bod.to_site   = mf.SCM_SITE_ID
																	and bod.incoterms = mf.INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
						 , 112)  yyyymmdd
*/
			  ,[QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
		  FROM [dbo].[DM_PLN_MKT_FCST] mf WITH(NOLOCK)
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure3   -- 'MKT_FCST'
		   and yyyymmdd     >= @n_result_start_date

/*  20180411 임시 주석처리
		   and YYYYMMDD     >= convert( varchar, 
							   cast( @n_result_start_date as datetime )  - ISNULL( (   select max(lt_total)
			     															   from [dbo].SCP_MST_BOD_V bod WITH(NOLOCK)
																			  where bod.from_site = mf.plant_site_id
																				and bod.to_site   = mf.SCM_SITE_ID
																				and bod.incoterms = mf.INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
									 , 112)      -- Upload 시작 시점 또는 당주차 월요일에서 customer_lt이 빠진 기간에서 부터 시작 함.
*/
		 order by YYYYMMDD 
		;

		-- 고객제시물동에 고객예상재고(I) 수량을 생성
		-- 확인  select @n_result_start_date as '@n_result_start_date'
        --------------------------------------------------------------------------------------
		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure4  -- 'CUST_INV_I' 
		   and ( ATTRIBUTE1  <>  'UPLOAD_COMPLETED' or ATTRIBUTE1 IS NULL )  -- 업로드한 데이터는 제외하고 삭제
		   
		   --and YYYYMMDD     >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.  -- 20180315 SKH MODIFY
		;
        --------------------------------------------------------------------------------------

		declare @yyyymmdd nvarchar(8)
		declare @QTY      INT

		declare psi_wos_cur cursor for 
						select c.BASIS_YYYYMMDD
						  from [dbo].[SCM_SYS_CALENDAR_M] c WITH(NOLOCK)
						 where c.BASIS_YYYYMMDD  >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
						   and c.BASIS_YYYYMMDD  <= @v_last_day  -- 미래 6개월치로 설정해놓았음
						  order by c.BASIS_YYYYMMDD

		open psi_wos_cur

		fetch next from psi_wos_cur into @yyyymmdd
		--------------------------------------------------------------------------------------------------------
		while @@FETCH_STATUS = 0 
		--------------------------------------------------------------------------------------------------------
		begin
			--확인 SELECT @yyyymmdd AS 'SELECT KKK  @yyyymmdd'
			select @QTY = ISNULL( (
				 SELECT  SUM(QTY)
				   FROM  [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure4  -- 'CUST_INV_I'
					and  a.yyyymmdd      = convert( varchar,  cast(@yyyymmdd as datetime )  - 1,  112)  
			   ), 0 ) + ISNULL( (
				 SELECT  SUM(QTY)
				   FROM  [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure1  -- 'CUST_WHIN_P' 
					and  a.yyyymmdd      = convert( varchar,  cast(@yyyymmdd as datetime )  - 1,  112)  
			   ), 0 ) - ISNULL( (
				 SELECT  SUM(QTY)
				   FROM  [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure8  -- 'CUST_Product_S'
					and  a.yyyymmdd      = convert( varchar,  cast(@yyyymmdd as datetime )  - 1,  112)  
			   ), 0 )  
	        --select @QTY as '@QTY'

			IF @QTY <0 BEGIN SET @QTY = 0 END
		--------------------------------------------------------------------------------------------------------
			SET @n_inv_count = 0
			SELECT @n_inv_count = count(*) FROM [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure4  -- 'CUST_INV_I'
					AND  a.yyyymmdd      = @yyyymmdd
					and  a.attribute1    = 'UPLOAD_COMPLETED'


		--------------------------------------------------------------------------------------------------------
		    --확인 select '[#TEMP4_DM_PLN_MKT_FCST$] wos'
		    --확인 select * from [#TEMP4_DM_PLN_MKT_FCST$] order by yyyymmdd
		    --확인 select @n_inv_count as '@n_inv_count wos'

			if  @n_inv_count = 0    -- 업로드한 재고량이 존재하는경우 보존해야 하므로 INSERT 하지 않음
			  begin
				insert into dbo.#TEMP4_DM_PLN_MKT_FCST$
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD
				,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
				,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				values
				(
				@v_division_id,@v_project_code,@v_scm_site_id,@v_item_id,@v_dom_exp,@v_fcst_type
				,@v_incoterms,@v_measure4,@v_plant_site_id,@yyyymmdd -- 'CUST_INV_I'
				,CASE WHEN @QTY < 0 THEN 0 ELSE @QTY END
				,'SYSTEM',getdate(),'SYSTEM',getdate(),NULL
				,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
				)
			  end
	

			fetch next from psi_wos_cur into @yyyymmdd
		end 
		--------------------------------------------------------------------------------------------------------
		close psi_wos_cur
		deallocate  psi_wos_cur


		--------------------------------------------------------------------------------------------------------
		-- 자사예측물동에 고객예상재고(I) 수량을 생성
		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure5  -- 'MKT_INV_I'
		   and ATTRIBUTE1   <>  'UPLOAD_COMPLETED'   -- 업로드한 데이터는 제외하고 삭제
		   and YYYYMMDD     >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
		;
		--------------------------------------------------------------------------------------------------------
		-- declare @yyyymmdd nvarchar(8)
		-- declare @QTY      INT

		declare psi_wos_cur cursor for 
						select c.BASIS_YYYYMMDD
						  from [dbo].[SCM_SYS_CALENDAR_M] c WITH(NOLOCK)
						 where c.BASIS_YYYYMMDD  >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
						   and c.BASIS_YYYYMMDD  <= @v_last_day  -- 미래 6개월치로 설정해놓았음
						  order by c.BASIS_YYYYMMDD

		open psi_wos_cur

		fetch next from psi_wos_cur into @yyyymmdd
		while @@FETCH_STATUS = 0 
		begin
			select @QTY = ISNULL( (
				 SELECT  SUM(QTY)
				   FROM  [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure5 -- 'MKT_INV_I' 
					AND  a.yyyymmdd      = convert( varchar,  cast(@yyyymmdd as datetime )  - 1,  112)  
			   ), 0 ) + ISNULL( (
				 SELECT  SUM(QTY)
				   FROM  [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure2  -- 'MKT_WHIN_P'
					AND  a.yyyymmdd      = convert( varchar,  cast(@yyyymmdd as datetime )  - 1,  112)
			   ), 0 ) - ISNULL( (
				 SELECT  SUM(QTY)
				   FROM  [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure6 --'MKT..Product(S)'
					AND  a.yyyymmdd      = convert( varchar,  cast(@yyyymmdd as datetime )  - 1,  112)
			   ), 0 )  
	
			SET @n_mkt_count = 0
			SELECT @n_mkt_count = count(*) FROM [dbo].[#TEMP4_DM_PLN_MKT_FCST$] a 
				 where 1=1
					and  a.division_id   = @v_division_id
					and  a.scm_site_id   = @v_scm_site_id
					and  a.dom_exp       = @v_dom_exp
					and  a.fcst_type     = @v_fcst_type
					and  a.item_id       = @v_item_id
					and  a.project_code  = @v_project_code
					and  a.incoterms     = @v_incoterms
					and  a.plant_site_id = @v_plant_site_id
					and  a.measure       = @v_measure5  -- 'MKT_INV_I'
					AND  a.yyyymmdd      = @yyyymmdd

		--------------------------------------------------------------------------------------------------------
			if  @n_mkt_count = 0    -- 업로드한 재고량이 존재하는경우 보존해야 하므로 INSERT 하지 않음
			  begin
				insert into dbo.#TEMP4_DM_PLN_MKT_FCST$
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD
				,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
				,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				values
				(
				@v_division_id,@v_project_code,@v_scm_site_id,@v_item_id,@v_dom_exp,@v_fcst_type
				,@v_incoterms,@v_measure5,@v_plant_site_id,@yyyymmdd
				,CASE WHEN @QTY < 0 THEN 0 ELSE @QTY END
				,'SYSTEM',getdate(),'SYSTEM',getdate(),NULL
				,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
				)
			  end
	

			fetch next from psi_wos_cur into @yyyymmdd
		end 
		close psi_wos_cur
		deallocate  psi_wos_cur
		--------------------------------------------------------------------------------------------------------






		-- 고객제시물동에 WOS(I) 수량을 생성

		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure7  -- 'CUST_DIO'
		   and YYYYMMDD     >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
		;
		--declare @yyyymmdd nvarchar(8)
		--declare @QTY      INT


		declare psi_wos_cur cursor for 
						select c.BASIS_YYYYMMDD
						  from [dbo].[SCM_SYS_CALENDAR_M] c WITH(NOLOCK)
						 where c.BASIS_YYYYMMDD  >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
						   and c.BASIS_YYYYMMDD  <= @v_last_day  -- 미래 6개월치로 설정해놓았음
						  order by c.BASIS_YYYYMMDD

		open psi_wos_cur

		fetch next from psi_wos_cur into @yyyymmdd
		while @@FETCH_STATUS = 0 
		begin
	
			insert into [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
			(  [DIVISION_ID]
			  ,[PROJECT_CODE]
			  ,[SCM_SITE_ID]
			  ,[ITEM_ID]
			  ,[DOM_EXP]
			  ,[FCST_TYPE]
			  ,[INCOTERMS]
			  ,[MEASURE]
			  ,[PLANT_SITE_ID]
			  ,[YYYYMMDD]
			  ,[QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
			)
			values
			(
			   @v_division_id          -- [DIVISION_ID]
			  ,@v_project_code         -- [PROJECT_CODE]
			  ,@v_scm_site_id          -- [SCM_SITE_ID]
			  ,@v_item_id              -- [ITEM_ID]
			  ,@v_dom_exp              -- [DOM_EXP]
			  ,@v_fcst_type            -- [FCST_TYPE]
			  ,@v_incoterms            -- [INCOTERMS]
			  ,@v_measure7             -- 'CUST_DIO'
			  ,@v_plant_site_id        -- [PLANT_SITE_ID]
			  ,@yyyymmdd               -- [YYYYMMDD]
			  ,CASE WHEN (
										  select SUM(QTY)
											from [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
											where 1=1
												and division_id   = @v_division_id
												and scm_site_id   = @v_scm_site_id
												and dom_exp       = @v_dom_exp
												and fcst_type     = @v_fcst_type
												and item_id       = @v_item_id
												and project_code  = @v_project_code
												and incoterms     = @v_incoterms
												and plant_site_id = @v_plant_site_id
												and measure       = @v_measure4  -- 'CUST..INV(I)'
												and yyyymmdd      = @yyyymmdd
										) = 0 THEN 0 
					ELSE

			   ISNULL( 
			         (
					select min(GAP_DAY) - 1
						from (
						select  CAST( ( cast(yyyymmdd as datetime) - cast ( @yyyymmdd as datetime) ) AS INT ) GAP_DAY,  qty, SUM(QTY) over ( order by yyyymmdd) accum_sum
							from [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
								where 1=1
									and division_id   = @v_division_id
									and scm_site_id   = @v_scm_site_id
									and dom_exp       = @v_dom_exp
									and fcst_type     = @v_fcst_type
									and item_id       = @v_item_id
									and project_code  = @v_project_code
									and incoterms     = @v_incoterms
									and plant_site_id = @v_plant_site_id
									and measure       = @v_measure6  --'MKT_Product_S'
									and yyyymmdd      > @yyyymmdd
							) a
					where accum_sum >=  (
										  select SUM(QTY)
											from [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
											where 1=1
												and division_id   = @v_division_id
												and scm_site_id   = @v_scm_site_id
												and dom_exp       = @v_dom_exp
												and fcst_type     = @v_fcst_type
												and item_id       = @v_item_id
												and project_code  = @v_project_code
												and incoterms     = @v_incoterms
												and plant_site_id = @v_plant_site_id
												and measure       = @v_measure4  -- 'CUST..INV(I)'
												and yyyymmdd      = @yyyymmdd
										)
										), 9999
				   )
				   END  -- [QTY]
			  ,'SYSTEM'            -- [CREATED_BY]
			  ,getdate()           -- [CREATION_DATE]
			  ,'SYSTEM'            -- [LAST_UPDATED_BY]
			  ,getdate()           -- [LAST_UPDATE_DATE]
			  ,NULL                -- [ATTRIBUTE1]
			  ,NULL                -- [ATTRIBUTE2]
			  ,NULL                -- [ATTRIBUTE3]
			  ,NULL                -- [ATTRIBUTE4]
			  ,NULL                -- [ATTRIBUTE5]
			  ,NULL                -- [ATTRIBUTE6]
			  ,NULL -- [ATTRIBUTE7]
			  ,NULL -- [ATTRIBUTE8]
			  ,NULL -- [ATTRIBUTE9]
			  ,NULL -- [ATTRIBUTE10]
			 )

			fetch next from psi_wos_cur into @yyyymmdd
		end 
		close psi_wos_cur
		deallocate  psi_wos_cur
			
		-- 자사예측물동 WOS(I) 수량을 생성

		delete [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 where 1=1
		   and division_id   = @v_division_id
		   and scm_site_id   = @v_scm_site_id
		   and dom_exp       = @v_dom_exp
		   and fcst_type     = @v_fcst_type
		   and item_id       = @v_item_id
		   and project_code  = @v_project_code
		   and incoterms     = @v_incoterms
		   and plant_site_id = @v_plant_site_id
		   and measure       = @v_measure9  --'MKT_DIO'
		   and YYYYMMDD     >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
		;

		--declare @yyyymmdd nvarchar(8)
		--declare @QTY      INT


		declare psi_wos_cur cursor for 
						select c.BASIS_YYYYMMDD
						  from [dbo].[SCM_SYS_CALENDAR_M] c WITH(NOLOCK)
						 where c.BASIS_YYYYMMDD  >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
						   and c.BASIS_YYYYMMDD  <= @v_last_day  -- 미래 6개월치로 설정해놓았음
						  order by c.BASIS_YYYYMMDD

		open psi_wos_cur

		fetch next from psi_wos_cur into @yyyymmdd
		while @@FETCH_STATUS = 0 
		begin
	
			insert into [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
			(  [DIVISION_ID]
			  ,[PROJECT_CODE]
			  ,[SCM_SITE_ID]
			  ,[ITEM_ID]
			  ,[DOM_EXP]
			  ,[FCST_TYPE]
			  ,[INCOTERMS]
			  ,[MEASURE]
			  ,[PLANT_SITE_ID]
			  ,[YYYYMMDD]
			  ,[QTY]
			  ,[CREATED_BY]
			  ,[CREATION_DATE]
			  ,[LAST_UPDATED_BY]
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]
			  ,[ATTRIBUTE2]
			  ,[ATTRIBUTE3]
			  ,[ATTRIBUTE4]
			  ,[ATTRIBUTE5]
			  ,[ATTRIBUTE6]
			  ,[ATTRIBUTE7]
			  ,[ATTRIBUTE8]
			  ,[ATTRIBUTE9]
			  ,[ATTRIBUTE10]
			)
			values
			(
			   @v_division_id          -- [DIVISION_ID]
			  ,@v_project_code         -- [PROJECT_CODE]
			  ,@v_scm_site_id          -- [SCM_SITE_ID]
			  ,@v_item_id              -- [ITEM_ID]
			  ,@v_dom_exp              -- [DOM_EXP]
			  ,@v_fcst_type            -- [FCST_TYPE]
			  ,@v_incoterms            -- [INCOTERMS]
			  ,@v_measure9             -- 'MKT_DIO'
			  ,@v_plant_site_id        -- [PLANT_SITE_ID]
			  ,@yyyymmdd               -- [YYYYMMDD]
			  ,CASE WHEN (
										  select SUM(QTY)
											from [dbo].[#TEMP4_DM_PLN_MKT_FCST$]  
											where 1=1
												and division_id   = @v_division_id
												and scm_site_id   = @v_scm_site_id
												and dom_exp       = @v_dom_exp
												and fcst_type     = @v_fcst_type
												and item_id       = @v_item_id
												and project_code  = @v_project_code
												and incoterms     = @v_incoterms
												and plant_site_id = @v_plant_site_id
												and measure       = @v_measure5    -- 'MKT_INV_I'
												and yyyymmdd      = @yyyymmdd

										) = 0 THEN 0 
					ELSE
			   ISNULL( (
					select min(GAP_DAY) - 1
						from (
						select  CAST( ( cast(yyyymmdd as datetime) - cast ( @yyyymmdd as datetime) ) AS INT ) GAP_DAY,  qty, SUM(QTY) over ( order by yyyymmdd) accum_sum
							from [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
						where 1=1
							and division_id   = @v_division_id
							and scm_site_id   = @v_scm_site_id
							and dom_exp       = @v_dom_exp
							and fcst_type     = @v_fcst_type
							and item_id       = @v_item_id
							and project_code  = @v_project_code
							and incoterms     = @v_incoterms
							and plant_site_id = @v_plant_site_id
							and measure       = @v_measure6 --'MKT_Product_S'
							and yyyymmdd      > @yyyymmdd
							) a
					where accum_sum >=  (
										select SUM(QTY)
										from [dbo].[#TEMP4_DM_PLN_MKT_FCST$] 
										where 1=1
											and division_id   = @v_division_id
											and scm_site_id   = @v_scm_site_id
											and dom_exp       = @v_dom_exp
											and fcst_type     = @v_fcst_type
											and item_id       = @v_item_id
											and project_code  = @v_project_code
											and incoterms     = @v_incoterms
											and plant_site_id = @v_plant_site_id
											and measure       = @v_measure5  -- 'MKT_INV_I'
											and yyyymmdd      = @yyyymmdd
										)
										), 9999
				   )
				   END  -- [QTY]
			  ,'SYSTEM'            -- [CREATED_BY]
			  ,getdate()           -- [CREATION_DATE]
			  ,'SYSTEM'            -- [LAST_UPDATED_BY]
			  ,getdate()           -- [LAST_UPDATE_DATE]
			  ,NULL                -- [ATTRIBUTE1]
			  ,NULL                -- [ATTRIBUTE2]
			  ,NULL                -- [ATTRIBUTE3]
			  ,NULL                -- [ATTRIBUTE4]
			  ,NULL                -- [ATTRIBUTE5]
			  ,NULL                -- [ATTRIBUTE6]
			  ,NULL -- [ATTRIBUTE7]
			  ,NULL -- [ATTRIBUTE8]
			  ,NULL -- [ATTRIBUTE9]
			  ,NULL -- [ATTRIBUTE10]
			 )
	

			fetch next from psi_wos_cur into @yyyymmdd
		end 
		close psi_wos_cur
		deallocate  psi_wos_cur

		/* --확인
		select * -- yyyymmdd, SUM(QTY) over ( order by yyyymmdd) 
		  from [dbo].[#TEMP4_DM_PLN_MKT_FCST$]
		 WHERE item_id      = @v_item_id
		   and PROJECT_CODE = @v_project_code
		   and INCOTERMS    = @v_incoterms
		   and DOM_EXP      = @v_dom_exp
		   and FCST_TYPE    = @v_fcst_type
		   and YYYYMMDD     >= @n_result_start_date  -- 시작일자 기초재고를 제외하고 삭제후 재계산함.
		--   and measure      = @v_measure4
		;
		*/



		END	
        /*---------------------------------------------------------------*/


          COMMIT WORK;    -- ssss

    END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  CUST_PSI_TO_MKT_FCST_WOS

      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
	-- 수행결과 성공여부 DISPLAY
   --  IF @v_log_message IS NULL
	  --SELECT 'success'	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = ' '
	;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
