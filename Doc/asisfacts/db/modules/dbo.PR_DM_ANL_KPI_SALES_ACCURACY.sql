

/*
 * Program ID   : PR_DM_ANL_KPI_SALES_ACCURACY
 * Description  : KPI_SALES_ACCURACY (매출계획 적확도/전월 마지막에 짠 당월 RTF 대비 당월 실적 값의 비율)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 09. 21    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20181213 add SUM(RESULT_QTY) < 0 THEN 0
 * 20181214 RTF 음수값 제외처리 (sp.qty >= 0)
 * 20190121        KHSONG      FCST 상관없이 실적을 구함.
 * 20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022.04.05   HWI1993		GM JV 로직 적용
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_ANL_KPI_SALES_ACCURACY]

	-- Add the parameters for the stored procedure here
	--@p_division_id				NVARCHAR(MAX)		,
	--@p_CREATED_BY               NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_KPI_SALES_ACCURACY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 변수
    DECLARE @v_YYYYMMDD     NVARCHAR(08);
	set @v_YYYYMMDD = convert(varchar,getdate(), 112)

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_DM_ANL_KPI_SALES_ACCURACY;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	


	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                                   매출계획 적확도 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--
	BEGIN
		-- INSERT 수행전 당일중복값 삭제
		DELETE FROM DM_ANL_KPI_SALES_ACCURACY WHERE WORK_YYYYMMDD = @v_YYYYMMDD;

		with salesplan_accuracy as (
		-- 금액은 KRW 기준? Currency를 쓰긴 어려우니...
		select  sp.[DIVISION_ID]
			   ,sp.[SCM_SITE_ID]
			   ,sp.[PROJECT_CODE]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,sp.qty  plan_qty
		       ,0       result_qty
			  ,[MEASURE]
		  from dm_pln_sales_plan_c sp WITH(NOLOCK)
			  ,(
		  select division_id, substring(yyyymmdd, 1,6) months , max(version_no) version_no
			from [dbo].[DM_MST_VERSION] WITH(NOLOCK)
		   where version_type				= 'SP_W'
		   group by division_id, substring(yyyymmdd, 1,6)
			) target_version
		 where sp.division_id				= target_version.division_id
		   and sp.version_no				= target_version.version_no
		   and substring(sp.YYYYMMDD,1,6)	= substring( convert( varchar, dateadd(MM,1, cast(target_version.months + '01' as datetime) ), 112), 1,6)
		   and sp.measure					in ( 'RTF' , 'SalesAmt_KRW' ,'RTF_SYS_RP')  --20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송
		   and sp.qty >= 0  -- 20181214 RTF 음수값 제외처리 (sp.qty >= 0)
		)
		, plan_and_result as (
		select * from salesplan_accuracy
		UNION ALL
		-- FCST 상관없이 실적을 구함. 20190121 추가
		select  sp.[DIVISION_ID]
			   ,ISNULL(sp.[SCM_SITE_ID],'')
			   ,sp.[PROJECT_CODE]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,0       plan_qty
		       ---------------------------------------------------------------------------------------------------------------------------------
			   -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (dm_pln_sales_plan_result에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요)
			   --,sp.qty  result_qty
		       ,SUM(sp.qty)  result_qty
		       ---------------------------------------------------------------------------------------------------------------------------------
			  ,[MEASURE]
		  from dm_pln_sales_plan_result sp WITH(NOLOCK)
			  ,(
					  select DISTINCT  division_id, substring(yyyymmdd, 1,6) months 
						from salesplan_accuracy WITH(NOLOCK)
			) target_version
		 where sp.division_id				= target_version.division_id
		   --and sp.version_no				= target_version.version_no
		   and substring(sp.YYYYMMDD,1,6)	= target_version.months
		   and sp.measure					in ( 'RTF' , 'SalesAmt_KRW' ,'RTF_SYS_RP')  --20191121 KHSONG 'RTF_SYS_RP' MEASURE 추가전송
		   --and sp.qty >= 0  -- 20181214 RTF 음수값 제외처리 (sp.qty >= 0)
		   -- modified by ytchoi 181116 Data 검증이 용이하기 위해서 전주까지의 실적을 가지도록 함.
		   and yyyymmdd                 < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		    ---------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (dm_pln_sales_plan_result에 CELL_PROD_SITE_ID가 추가됨에 따라 SUM 처리 필요)
		    GROUP BY  sp.[DIVISION_ID]
				   ,ISNULL(sp.[SCM_SITE_ID],'')
				   ,sp.[PROJECT_CODE]
				   ,sp.[ITEM_ID]
				   ,sp.[FCST_TYPE]
				   ,sp.YYYYMMDD
				  ,[MEASURE]
		    ---------------------------------------------------------------------------------------------------------------------------------
		)

/*		-- 실적은 FCST가 있는것 기준으로 값을 구함. 20190121 주석처리
		select  sp.[DIVISION_ID]
			   ,sp.[SCM_SITE_ID]
			   ,sp.[PROJECT_CODE]
			   ,sp.[ITEM_ID]
			   ,sp.[FCST_TYPE]
			   ,sp.YYYYMMDD
			   ,0       plan_qty
		       ,sp.qty  result_qty
			  ,[MEASURE]
		  from dm_pln_sales_plan_result sp WITH(NOLOCK)
			  ,(
		   select distinct division_id, scm_site_id, project_code, item_id, fcst_type, SUBSTRING( yyyymmdd, 1,6 ) months
			 from salesplan_accuracy
			) target_key
		 where sp.measure				in ( 'RTF' , 'SalesAmt_KRW' )
		   and sp.DIVISION_ID			= target_key.DIVISION_ID
		   and sp.SCM_SITE_ID			= target_key.scm_site_id
		   and sp.PROJECT_CODE			= target_key.PROJECT_CODE
		   and sp.ITEM_ID				= target_key.ITEM_ID
		   and sp.fcst_type				= target_key.fcst_type
		   and SUBSTRING(YYYYMMDD, 1,6) = target_key.months

		   -- modified by ytchoi 181116 Data 검증이 용이하기 위해서 전주까지의 실적을 가지도록 함.
		   and yyyymmdd                 < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)

		   )
*/
		insert into DM_ANL_KPI_SALES_ACCURACY ( 
			   [WORK_YYYYMMDD]
			  ,[DIVISION_ID]
			  ,[DEPT_ID]
			  ,[END_CUSTOMER]
			  ,[SCM_SITE_ID]
			  ,[PROJECT_CODE]
			  ,[ITEM_ID]
			  ,[FCST_TYPE]
			  ,[YYYYMM]
			  ,[RESULT_QTY]
			  ,[MEASURE]
			  ,[WEIGHT]
			  ,[KPI_RATE]
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
		select @v_YYYYMMDD
			  , x.division_id
		      , case when x.division_id = '40' then ISNULL(su.dept_id,'') else ISNULL(b.dept_id,'') end
		      , case when x.division_id = '40' then ISNULL(si.project_code,'') else ISNULL(b.end_customer,'') end
		      , x.scm_site_id
		      , X.project_code
		      , X.item_id
		      , fcst_type
		      , substring(yyyymmdd, 1,6)
		      , SUM(RESULT_QTY) RESULT_QTY
		      , MEASURE
		      , SUM(PLAN_QTY) WEIGHT
		  --    , CASE WHEN SUM(PLAN_QTY) = 0 THEN 0 WHEN SUM(RESULT_QTY)/SUM(PLAN_QTY) > 1 THEN 1 ELSE SUM(RESULT_QTY)/SUM(PLAN_QTY) END KPI_RATE 
		        -- 20181213 add SUM(RESULT_QTY) < 0 THEN 0
		      , CASE WHEN SUM(PLAN_QTY) = 0 THEN 0 WHEN SUM(RESULT_QTY) < 0 THEN 0  WHEN ABS( SUM(RESULT_QTY) - SUM(PLAN_QTY) ) / SUM(PLAN_QTY) > 1 THEN 1 ELSE 1- ABS( SUM(RESULT_QTY) - SUM(PLAN_QTY) ) / SUM(PLAN_QTY) END KPI_RATE 
			  , 'KPI_SALES_ACCURACY' -- [CREATED_BY]
			  , getdate() [CREATION_DATE]
			  , 'KPI_SALES_ACCURACY' -- [LAST_UPDATED_BY]
			  , getdate() [LAST_UPDATE_DATE]
			  , NULL -- [ATTRIBUTE1]
			  , NULL -- [ATTRIBUTE2]
			  , NULL -- [ATTRIBUTE3]
			  , NULL -- [ATTRIBUTE4]
			  , NULL -- [ATTRIBUTE5]
			  , NULL -- [ATTRIBUTE6]
			  , NULL -- [ATTRIBUTE7]
			  , NULL -- [ATTRIBUTE8]
			  , NULL -- [ATTRIBUTE9]
			  , NULL -- [ATTRIBUTE10]
		  from plan_and_result x

		  inner join scm_mst_site b WITH(NOLOCK)
		    on x.division_id = b.DIVISION_ID
		   and x.scm_site_id = b.scm_site_id
		   and b.VALID_YN	  = 'Y'

		  LEFT join scm_mst_site_item si with(nolock)
		    on x.division_id  = si.DIVISION_ID
		   and x.PROJECT_CODE = si.PROJECT_CODE
		   and x.scm_site_id  = si.scm_site_id
		   and x.item_id	  = si.item_id
		   and si.VALID_YN	  = 'Y'

		  left join SCM_MST_SSO_USER_INFO su WITH(NOLOCK)
		     on substring( si.OWNER, 0, case when charindex(',',si.OWNER) = 0 then len(si.OWNER)+1 else charindex(',',si.OWNER) end ) = su.user_id

		  where x.division_id IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
		 group by x.division_id
		  ,case when x.division_id = '40' then ISNULL(su.dept_id,'') else ISNULL(b.dept_id,'') end
		  ,case when x.division_id = '40' then ISNULL(si.project_code,'') else ISNULL(b.end_customer,'') end
		  ,x.scm_site_id, X.project_code,X.item_id, fcst_type, substring(yyyymmdd, 1,6), MEASURE
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
	ROLLBACK TRANSACTION PR_DM_ANL_KPI_SALES_ACCURACY;

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
