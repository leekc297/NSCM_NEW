

/*
 * Program ID   : DMF0009_GET_METAL_CURRENCY_PRICE_POPUP
 * Description  : DMF009_MetalCurrencyPricePopUp(Metal & Currency)의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/26	ilovu1			Initial Release 사업계획 프로젝트
 */
--exec dbo.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP '202301', '202405';
CREATE PROCEDURE [dbo].[DMF0009_GET_METAL_CURRENCY_PRICE_POPUP]
      @p_GUBUN				 NVARCHAR(30)	--조회구분(LIST, DATA)
    , @p_DIVISION_ID		 NVARCHAR(30)	--사업부ID
    , @p_METAL_CURRENCY_GBN  NVARCHAR(1)	--메탈통화구분(1 통화, 2 메탈)
    , @p_START_STND_YM       NVARCHAR(6)	--시작 기준연월
    , @p_END_STND_YM         NVARCHAR(6)	--종료 기준연월
	, @p_GroupID			 NVARCHAR(MAX)  
	, @p_UserID              NVARCHAR(MAX)  
AS
begin
    set nocount on;

	declare @v_START_STND_YMD       NVARCHAR(8);
	declare @v_END_STND_YMD         NVARCHAR(8);

	set @v_START_STND_YMD = @p_START_STND_YM + '01';
	set @v_END_STND_YMD   = format(dateadd(day, -1, dateadd(month, 1, @p_END_STND_YM + '01')), 'yyyyMMdd');--종료 기준연월의 마지막일

	create table #CURRENCY
	(
		  SEQ	int
		, CODE	NVARCHAR(100)
		, NAME	NVARCHAR(100)
	);

	create table #METAL
	(
		  SEQ	int
		, CODE	NVARCHAR(100)
		, NAME	NVARCHAR(100)
	);

	create table #DIVISION
	(
		  CODE	NVARCHAR(100)
		, NAME	NVARCHAR(100)
	);

	create table #DIVISION_CURRENCY
	(		  
		  DIVISION_ID	NVARCHAR(100) 
		, SEQ int
		, CURRENCY		NVARCHAR(100)
	);

	create table #YYYYMM
	(
		  COLUMN_NAME	NVARCHAR(10)
		, SPAN_NAME		NVARCHAR(10)
		, COL_HEADER	NVARCHAR(10)
		, SPAN_HEADER	NVARCHAR(10)
		, YYYYMM		NVARCHAR(10)
	);

	create table #DIVISION_CURRENCY_YYYYMM
	(		  
		  DIVISION_ID	NVARCHAR(100) 
		, SEQ           int
		, CURRENCY		NVARCHAR(100)
		, YYYYMM		NVARCHAR(10)
		, COLUMN_NAME   NVARCHAR(10)
	);

	insert 
		into #DIVISION
	exec dbo.UP_FX_GetCommonDataList @Code=N'MyDivision',@Param1=@p_GroupID,@Param2=@p_UserID,@Param3=N'',@Param4=N'',@Param5=N'';
		
	if @p_division_id <> 'ALL'
		delete 
			from #DIVISION
            where CODE not in (select * from dbo.UF_FX_String_SplitForIN (@p_division_id,','));

	if @p_METAL_CURRENCY_GBN = '1'		--통화
	begin
		insert
		  into #CURRENCY
		exec dbo.DMF0009_GET_CODE 'DMF_BIZ_PLAN_METAL_CURRENCY';

		insert
		  into #DIVISION_CURRENCY
		select d.CODE		DIVISION_ID
			 , c.SEQ
			 , c.CODE		CURRENCY		  
		  from #CURRENCY c cross join #DIVISION d;	
		  
		if @p_GUBUN = 'LIST'
		begin
			select c.DIVISION_ID
				 , c.CURRENCY		METAL_CURRENCY
				 , isnull(p.STND_MARKET, 'Business Plan') STND_MARKET
				 , 'Y'				EDIT_FLAG
			  from #DIVISION_CURRENCY c
			       outer apply (select s.STND_MARKET						--기준시장
				                  from dbo.DM_MST_METAL_CURRENCY_PRICE s	--메탈 및 통화 가격
                                 where s.DIVISION_ID = c.DIVISION_ID		--사업부ID
								   and s.METAL_CURRENCY_GBN = '1'			--메탈통화구분(1 통화, 2 메탈)
								   and s.METAL_CURRENCY     = c.CURRENCY	--메탈통화항목
								   and s.STND_YM            between @p_START_STND_YM and @p_END_STND_YM
                                 group by
								       s.STND_MARKET						--기준시장	   
				               ) p
			 order by 
				   DIVISION_ID
				 , SEQ;
		end
		else if @p_GUBUN = 'DATA'
		begin	
			insert
			  into #YYYYMM
            exec dbo.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE @p_START_STND_YM, @p_END_STND_YM;
		    
			insert
			  into #DIVISION_CURRENCY_YYYYMM
			select 
			       a.DIVISION_ID	
			     , a.SEQ           
			     , a.CURRENCY		
			     , b.YYYYMM
				 , b.COLUMN_NAME
			  from #DIVISION_CURRENCY a cross join #YYYYMM b;			       

			select t.DIVISION_ID	
			     , t.YYYYMM									STND_YM
				 , t.CURRENCY								METAL_CURRENCY
				 , isnull(a.STND_MARKET, 'Business Plan')   STND_MARKET
			     , isnull(a.STND_PRICE, b.EXCHANGE_PRICE)	STND_PRICE
				 , case 
						when a.STND_PRICE is not null then 'Y'
						else 'N'
				   end										EXISTED
                 , t.COLUMN_NAME
			  from #DIVISION_CURRENCY_YYYYMM t
			       left  join dbo.DM_MST_METAL_CURRENCY_PRICE a WITH (NOLOCK)	--메탈 및 통화 가격
				           on t.DIVISION_ID			= a.DIVISION_ID				--사업부ID
                          and a.METAL_CURRENCY_GBN	= '1'						--메탈통화구분(1 통화, 2 메탈)
						  and t.YYYYMM				= a.STND_YM					--기준연월
						  and t.CURRENCY			= a.METAL_CURRENCY			--메탈통화항목
				   outer apply (select top 1 
				                       e.EXCHANGE_PRICE
								  from dbo.DM_MST_EXCHANGE_RATE e WITH (NOLOCK)
								 where a.STND_PRICE is null
								   and e.DIVISION_ID = t.DIVISION_ID
								   and (e.YYYYMMDD like t.YYYYMM + '%')
								   AND UNIT_CURRENCY = t.CURRENCY
								   AND CURRENCY = 'KRW'
				               ) b;
		end
	end   
	else if @p_METAL_CURRENCY_GBN = '2'	--메탈
	begin
		insert
		  into #METAL
		exec dbo.DMF0009_GET_CODE 'DMF_BIZ_PLAN_METAL_KIND';

		insert
		  into #DIVISION_CURRENCY
		select d.CODE		DIVISION_ID
			 , c.SEQ
			 , c.CODE		CURRENCY		  
		  from #METAL c cross join #DIVISION d;	
		  
		if @p_GUBUN = 'LIST'
		begin
			select DIVISION_ID
				 , CURRENCY			METAL_CURRENCY
				 , isnull(a.STND_MARKET, '0') STND_MARKET   --0 Business Plan
				 , 'Y'				EDIT_FLAG
			  from #DIVISION_CURRENCY t
			       outer apply (select distinct STND_MARKET								--기준시장
				                  from dbo.DM_MST_METAL_CURRENCY_PRICE m WITH (NOLOCK)	--메탈 및 통화 가격
                                 where m.DIVISION_ID = t.DIVISION_ID					--사업부ID
								   and m.METAL_CURRENCY_GBN = '2'						--메탈통화구분(1 통화, 2 메탈)
								   and m.METAL_CURRENCY     = t.CURRENCY				--메탈통화항목
								   and m.STND_YM            between @p_START_STND_YM and @p_END_STND_YM	--기준연월
                               ) a
			 order by 
				   DIVISION_ID
				 , SEQ;
		end
		else if @p_GUBUN = 'DATA'
		begin
			select a.DIVISION_ID	
			     , a.STND_YM
				 , a.METAL_CURRENCY
				 , a.STND_MARKET
			     , a.STND_PRICE
				 , case 
						when a.STND_PRICE is not null then 'Y'
						else 'N'
				   end										EXISTED
                 , 'C' + a.STND_YM COLUMN_NAME	
			  from dbo.DM_MST_METAL_CURRENCY_PRICE a WITH (NOLOCK)
			 where a.DIVISION_ID in (select CODE from #DIVISION)
			   and a.METAL_CURRENCY_GBN	= '2'
			   and a.STND_YM between @p_START_STND_YM and @p_END_STND_YM
			   ;
		end
	end
end;
