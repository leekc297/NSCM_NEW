

/*
 * Program ID   : SCP0083_GET_DIO_REPORT_H
 * Description  : SCP_ANL_DIO_REPORT_H 조회 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/11/04   kmj				Initial Release - [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2022/06/10   vadabi3			VERSION 추가
 */

CREATE PROCEDURE [dbo].[SCP0083_GET_DIO_REPORT_H]
--chaan  @p_division_id            NVARCHAR(5),
    @p_division_id          NVARCHAR(30),--chaan
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type			NVARCHAR(5),
	@p_seq					NVARCHAR(2),
	@p_item_id				NVARCHAR(50),
	@p_nick_name			NVARCHAR(50),
	@p_plant_id				NVARCHAR(50),
	@p_sel_column			NVARCHAR(50),
 	@p_ver					INT,
	@debug_mode				NVARCHAR(1) = 'T'

AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	DECLARE @mEXEC NVARCHAR(MAX) = '';

		SET @mEXEC = '';

		SET @mEXEC = @mEXEC+'SELECT '+CHAR(10);
		SET @mEXEC = @mEXEC+'	DIVISION_ID'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, PLAN_START_YYYYMMDD'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, PLAN_TYPE'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, SEQ'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, NICK_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, FROM_SITE'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, FROM_SITE_DESCRIPTION'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, END_CUSTOMER'+CHAR(10); -- TO_SITE
		SET @mEXEC = @mEXEC+'	, PRODUCTION_TYPE'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, EXTRA_SPEC'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, CELL_ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, BIZ_TYPE'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, INCOTERMS'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, ' +@p_sel_column + ' AS SEL_COLUMN'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, LAST_UPDATED_BY'+CHAR(10);
		SET @mEXEC = @mEXEC+'	, LAST_UPDATE_DATE'+CHAR(10);

		SET @mEXEC = @mEXEC+'FROM SCP_ANL_DIO_REPORT_H A WITH(NOLOCK)'+CHAR(10);
		SET @mEXEC = @mEXEC+'WHERE 1=1'+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.DIVISION_ID			= '''+ @p_division_id +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.PLAN_START_YYYYMMDD	= '''+ @p_plan_start_yyyymmdd +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.PLAN_TYPE			= '''+ @p_plan_type +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.SEQ					= '''+ @p_seq +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.VER					= '''+  CONVERT(NVARCHAR(10), ISNULL(@p_ver, 1)) +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.ITEM_ID				= '''+ @p_item_id +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.NICK_NAME			= N'''+ @p_nick_name +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'AND A.PLANT_ID				= '''+ @p_plant_id +''''+CHAR(10);
		SET @mEXEC = @mEXEC+'ORDER BY PLANT_ID, END_CUSTOMER, NICK_NAME, ITEM_ID, BIZ_TYPE, INCOTERMS, LAST_UPDATE_DATE DESC'+CHAR(10);

		-----------------------------------------------------------7
		-- DEBUG QRY 출력
		-----------------------------------------------------------	
		IF( @debug_mode ='T')
			BEGIN				
				DECLARE @POS INT =1;
				DECLARE @LEN INT =LEN(@mEXEC);
				WHILE @POS <= @LEN
					BEGIN
						PRINT SUBSTRING(@mEXEC,@POS,4000);
						SET @POS = @POS+4000;
					END;
			END;
		-----------------------------------------------------------
		EXEC (@mEXEC);
	


END
