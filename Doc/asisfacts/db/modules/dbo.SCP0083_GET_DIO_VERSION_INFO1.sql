
/*
 * Program ID   : SCP0083_GET_DIO_VERSION_INFO1
 * Description  : SCP0083 DIO Report 화면의 Version Combo매핑
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/06/14   vadabi3				최초생성 
                                    변경전 ( Plan Type Combobox 리스트 조회)
									변경후 ( Version  Combobox 리스트 조회)
* 2022/12/20   anhcv2			create SCP0083_GET_DIO_VERSION_INFO1
 ----------------------------------------------------------------------------------------------------
 -- select * from SCP_ANL_DIO_REPORT_VERSION
 */

CREATE PROCEDURE [dbo].[SCP0083_GET_DIO_VERSION_INFO1]
    @p_division_id				NVARCHAR(30),
	@p_plan_start_yyyymmdd		NVARCHAR(8),
	@p_plan_type				NVARCHAR(5),
	@p_seq						NVARCHAR(2)
AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 


	--------------------------------------------------
	-- @VER_CNT
	--------------------------------------------------
	DECLARE @MAX_VER INT;
	DECLARE @MAX_VER_STATUS NVARCHAR(MAX);

	select  @MAX_VER  = ISNULL(MAX(ver),0)
	from SCP_ANL_DIO_REPORT_VERSION v with(nolock)
	where 1=1
	  and( ( @p_division_id IS NULL OR  @p_division_id='' ) OR v.division_id = @p_division_id)
	  and ( ( @p_plan_start_yyyymmdd IS NULL OR  @p_plan_start_yyyymmdd='' ) OR v.plan_start_yyyymmdd = @p_plan_start_yyyymmdd)
	  and ( ( @p_plan_type IS NULL OR  @p_plan_type='' ) OR v.plan_type = @p_plan_type)
	  and ( ( @p_seq IS NULL OR  @p_seq='' ) OR v.seq = @p_seq )

	select  @MAX_VER_STATUS  = ver_status
	from SCP_ANL_DIO_REPORT_VERSION v with(nolock)
	where 1=1
	  and( ( @p_division_id IS NULL OR  @p_division_id='' ) OR v.division_id = @p_division_id)
	  and ( (@p_plan_start_yyyymmdd IS NULL OR  @p_plan_start_yyyymmdd='' ) OR v.plan_start_yyyymmdd = @p_plan_start_yyyymmdd)
	  and ( (@p_plan_type IS NULL OR  @p_plan_type='' ) OR v.plan_type = @p_plan_type)
	  and ( ( @p_seq IS NULL OR  @p_seq='' ) OR v.seq = @p_seq)
	  and v.ver = @MAX_VER



	IF @MAX_VER = 0
		BEGIN
			select 1 AS CODE 
				  ,CONCAT(1, '-', 'N', '-', N'미생성') AS NAME -- 미생성 -> Version Create 버튼 활성화 
				   ,'' as data_range  -- Range Editable 
				   ,'' as creation_date 
	
		END

	ELSE IF @MAX_VER > 0 AND @MAX_VER_STATUS = 'P'
		BEGIN
			SELECT  VER AS CODE 
				  , CONCAT(VER, '-', ver_status, '-', ver_status_name)  AS NAME    -- C:생성완료, P:생성중
				  , data_range
			from
			(
				select ver 
					, ver_status
					, case when ver_status = 'C' then N'생성완료'
					       when ver_status = 'P' then N'생성중'
						   else ver_status
					       end as ver_status_name
					, v.data_range   
					, convert(nvarchar(10), creation_date, 23) + ' ' +convert(nvarchar(8), creation_date, 24) as creation_date
				 from SCP_ANL_DIO_REPORT_VERSION v with(nolock)
				where 1=1
				  and ( ( @p_division_id IS NULL OR  @p_division_id='' ) OR v.division_id = @p_division_id)
				  and( (@p_plan_start_yyyymmdd IS NULL OR  @p_plan_start_yyyymmdd='' ) OR v.plan_start_yyyymmdd = @p_plan_start_yyyymmdd)
				  and ( (@p_plan_type IS NULL OR  @p_plan_type='' ) OR v.plan_type = @p_plan_type)
				  and ( ( @p_seq IS NULL OR  @p_seq='' ) OR v.seq = @p_seq)
			) DATA
			order by DATA.VER DESC
		END
	ELSE
		BEGIN
		SELECT  VER  AS CODE 
		      , CONCAT(VER, '-', ver_status, '-', ver_status_name)  AS NAME     -- C:생성완료, P:생성중
			  , data_range
			  , DIVISION_ID
			  , PLAN_DATE
			  , PLAN_TYPE
			  , SEP
		from
		(
			select ver
				, ver_status
					, case when ver_status = 'C' then N'생성완료'
					       when ver_status = 'P' then N'생성중'
						   else ver_status
					       end as ver_status_name
				, v.data_range   
				, convert(nvarchar(10), creation_date, 23) + ' ' +convert(nvarchar(8), creation_date, 24) as creation_date
				,v.division_id DIVISION_ID
				,v.plan_start_yyyymmdd PLAN_DATE
				,v.plan_type PLAN_TYPE
				,v.seq SEP
			 from SCP_ANL_DIO_REPORT_VERSION v with(nolock)
			where 1=1
			  and ( ( @p_division_id IS NULL OR  @p_division_id='' ) OR v.division_id = @p_division_id)
				  and( (@p_plan_start_yyyymmdd IS NULL OR  @p_plan_start_yyyymmdd='' ) OR v.plan_start_yyyymmdd = @p_plan_start_yyyymmdd)
				  and ( (@p_plan_type IS NULL OR  @p_plan_type='' ) OR v.plan_type = @p_plan_type)
				  and ( ( @p_seq IS NULL OR  @p_seq='' ) OR v.seq = @p_seq)

			union all
			SELECT @MAX_VER + 1 as ver 
				   , 'N' as ver_status 
				   ,  N'미생성'AS ver_status_name
				   ,'' as data_range  
				   ,'' as creation_date 
				   ,'' as DIVISION_ID
				   ,'' as PLAN_DATE
			       ,'' as PLAN_TYPE
			       ,'' as SEP
				  
	    ) DATA
		order by DATA.VER DESC
		;

	END



/*
		with target_create as (
		select isnull(max(ver)+1, 1) as ver 
			   ,'N' as ver_status  -- 미생성 -> Version Create 버튼 활성화 
			   ,'' as data_range  -- Range Editable 
			   ,'' as creation_date 
		 from SCP_ANL_DIO_REPORT_VERSION v with(nolock)
		where 1=1
		  and v.division_id = @p_division_id
		  and v.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
		  and v.plan_type = @p_plan_type
		  and v.seq = @p_seq
		)
		select VER AS CODE
			  , CONCAT(VER, '-', ver_status)  AS NAME
			  ,data_range
			  ,creation_date
		 from target_create with(nolock)
		where 1=1
		  and not exists (select 1
							from scp_anl_dio_report_version p with(nolock)
						   where p.division_id = @p_division_id
							 and p.plan_start_yyyymmdd= @p_plan_start_yyyymmdd
							 and p.plan_type= @p_plan_type
							 and p.seq= @p_seq
							 and p.ver_status != 'C' 
						 ) -- 생성중 버전이 없을 경우만... 

*/


END
