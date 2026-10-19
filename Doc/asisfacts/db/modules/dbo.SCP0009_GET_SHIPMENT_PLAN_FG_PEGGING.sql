
/*
 * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING
 * Description  : Shipment Plan - pegging 조회
 *===================================================================================================
 *   Date			In Charge		Description
 *===================================================================================================
 * 2018/05/17		KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/12		KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2018/08/14		YHW				PROJECT CODE 문제로 안나오는 오류 수정(조인조건)

 EX)
 EXEC SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING @p_division_id='81', @p_plan_start_yyyymmdd='20180514', @p_plan_type='MA', @p_seq=2, 
	@p_item_id='ACPP1015U-B1', @p_origin_from_division_id='' , @p_origin_to_division_id='', @p_electrode_type='', @p_biz_type='A', @p_to_site='BAE_US_ENC', @p_duedate='20180528'

 */
CREATE PROCEDURE [dbo].[SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING]
	  @p_division_id			NVARCHAR(30)
	, @p_plan_start_yyyymmdd	NVARCHAR(8) 
	, @p_plan_type				NVARCHAR(50)
	, @p_seq					bigint 
	, @p_item_id				NVARCHAR(50)
	, @p_origin_from_division_id	NVARCHAR(MAX)
	, @p_origin_to_division_id		NVARCHAR(MAX)
	, @p_electrode_type			NVARCHAR(MAX)
	, @p_biz_type				nvarchar(1)
	, @p_to_site				nvarchar(50)
	, @p_duedate				nvarchar(8)
	, @p_project_code			nvarchar(50)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	select
		a.pegging_operation_code ,
		b.segment2 as PEGGING_OPERATION ,
		a.item_id ,
		isnull(NULLIF(a.ORIGIN_FROM_DIVISION_ID,'') , '-') as ORIGIN_FROM_DIVISION_ID ,
		a.FROM_SITE ,
		isnull(NULLIF(a.ORIGIN_TO_DIVISION_ID, '') , '-') as ORIGIN_TO_DIVISION_ID ,
		a.to_site ,
		a.DUE_DATE ,
		a.PLAN_START_DATE ,
		a.PLAN_END_DATE ,
		dbo.FN_GET_LOOKUP_CODE_DESC('BIZ_TYPE', a.OPERATION_GROUP) as OPERATION_GROUP ,
		ISNULL(NULLIF(a.ELECTRODE_TYPE,'') ,  '-') AS ELECTRODE_TYPE ,
		a.REQUIRED_QTY ,
		a.PLANNED_QTY ,
		a.PROBLEM_TYPE AS PROBLEM_TYPE ,
		a.LPST ,
		a.STOCK_PLAN_LOT_ID
	from SCP_ANL_PROBLEM_REPORT_PEGGING (nolock) a
	left join SCM_ADM_LOOKUP_MASTER_DETAIL (nolock) b on b.lookup_type='PEGGING_OPERATION' 
		and a.pegging_operation_code = b.SEGMENT1
	where a.division_id = @p_division_id
		and a.PLAN_START_YYYYMMDD = @p_Plan_Start_yyyymmdd
		and a.PLAN_TYPE = @p_PLAN_TYPE
		and a.SEQ = @p_SEQ
		--and a.pegging_operation_code in ('ALLOC','PSHIP','CSHIP','ESHIP')
		and a.OPERATION_GROUP = @p_biz_type
		and a.TO_SITE = @p_to_site
		and a.ITEM_ID = @p_item_id
		and a.DUE_DATE = CONVERT(DATETIME , @p_duedate)
		and dbo.fn_scm_split(a.[eng_demand_id],2,'::') = @p_project_code
		--AND A.ORIGIN_FROM_DIVISION_ID = @p_origin_from_division_id
		--AND A.ORIGIN_TO_DIVISION_ID =@p_origin_to_division_id
		--AND A.ELECTRODE_TYPE = @p_electrode_type
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@p_electrode_type,''),'-')
	
	--DECLARE @mEXEC NVARCHAR(MAX) = '';
	--DECLARE @v_SEQ nvarchar(50) = convert(nvarchar(50) , @p_SEQ);

	--SET @mEXEC = @mEXEC+'	SELECT																						'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.pegging_operation_code ,																'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		b.segment2 as PEGGING_OPERATION ,														'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.item_id ,																				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID,'''') , ''-'') as ORIGIN_FROM_DIVISION_ID ,					'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.FROM_SITE ,																			'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID,'''') , ''-'') as ORIGIN_TO_DIVISION_ID ,						'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.to_site ,																				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.DUE_DATE ,																			'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.PLAN_START_DATE ,																		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.PLAN_END_DATE ,																		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		dbo.FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', a.OPERATION_GROUP) as OPERATION_GROUP ,		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		ISNULL(NULLIF(a.ELECTRODE_TYPE,''''), ''-'') AS ELECTRODE_TYPE ,									'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.REQUIRED_QTY ,																		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.PLANNED_QTY ,																			'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.PROBLEM_TYPE AS PROBLEM_TYPE ,														'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.LPST ,																				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		a.STOCK_PLAN_LOT_ID																		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'	FROM SCP_ANL_PROBLEM_REPORT_PEGGING (nolock) a												'+CHAR(10);
	--SET @mEXEC = @mEXEC+'	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (nolock) b on b.lookup_type=''PEGGING_OPERATION''	'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.pegging_operation_code = b.SEGMENT1												'+CHAR(10);
	--SET @mEXEC = @mEXEC+'	WHERE a.DIVISION_ID = ''' + @p_division_id + '''											'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.PLAN_START_YYYYMMDD = ''' + @p_Plan_Start_yyyymmdd + '''										'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.PLAN_TYPE = ''' + @p_PLAN_TYPE + '''															'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.SEQ = ' + @v_SEQ + '																		'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.PEGGING_OPERATION_CODE in (''ALLOC'',''PSHIP'',''CSHIP'',''ESHIP'')				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.OPERATION_GROUP = ''' + @p_biz_type + '''														'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.TO_SITE = ''' + @p_to_site + '''															'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.ITEM_ID = ''' + @p_item_id + '''																'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and a.DUE_DATE = CONVERT(DATETIME , '''+ @p_duedate + ''')											'+CHAR(10);
	--SET @mEXEC = @mEXEC+'		and dbo.fn_scm_split(a.[eng_demand_id],2,''::'') = ''' + @p_project_code + '''						'+CHAR(10);

	--IF @p_division_id = 'EE'
	--BEGIN
	--	--SET @mEXEC = @mEXEC+'		AND A.ORIGIN_TO_DIVISION_ID = ''' + @p_origin_to_division_id + '''								'+CHAR(10);

	--	--IF NOT(@p_electrode_type = '' OR @p_electrode_type IS NULL OR @p_electrode_type = '-')
	--	--	SET @mEXEC = @mEXEC+'		AND A.ORIGIN_FROM_DIVISION_ID = ''' + @p_origin_from_division_id + '''							'+CHAR(10);

	--	IF NOT(@p_electrode_type = '' OR @p_electrode_type IS NULL OR @p_electrode_type = '-')
	--		SET @mEXEC = @mEXEC+'		AND A.ELECTRODE_TYPE = ''' + @p_electrode_type + '''												'+CHAR(10);
	--END;

	--EXEC (@mEXEC);

	--DECLARE @POS INT =1;
	--	DECLARE @LEN INT =LEN(@mEXEC);
	--	WHILE @POS <= @LEN
	--	BEGIN
	--		PRINT SUBSTRING(@mEXEC,@POS,4000);
	--		SET @POS = @POS+4000;
	--	END;

END
