

/*
 * Program ID   : DMF0009_GET_CODE
 * Description  : DMF0009_BizPlanPrice_Input(메탈 판가 기준등록 화면)의 콤보박스 데이터 목록 가져오기
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/20	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/03 chkim.68          Biz Plan Price MEASURE를 LOOKUP에서 가져
 * 2023/09/14   ilovu1			@p_code_type = 'DMF_BIZ_PLAN_METAL_CURRENCY'에서 "KRW" 가져올 수 있도록 파라미터로 처리
 * 2023/09/18   ilovu1		    @p_code_type = 'DMF_BIZ_PLAN_METAL_LINK_PERIOD'에 M-2 ~ M-6 구간 추가함
 * 2023/09/18   ilovu1		    @p_code_type = 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX'에 M-2 ~ M-6 구간 추가함
 * 2023/09/19   ilovu1		    @p_code_type = 'METAL_LINK_START_MONTH_Q'(분기 드랍박스 목록 데이터) 추가함
 * 2023/09/19   ilovu1		    @p_code_type = 'METAL_LINK_START_MONTH_H'(반기 드랍박스 목록 데이터) 추가함
 * 2023/09/21   ilovu1		    Compile
 * 2023/09/27   ilovu1		    @p_code_type = 'DMF_BIZ_PLAN_METAL_MEASURE82' 추가함
 * 2024/03/11   HMIN            [E20240228-001114] IDR추가 
 * 2025/11/28   JSSBAE          [E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리)
 */
CREATE procedure [dbo].[DMF0009_GET_CODE]
	  @p_code_type		    nvarchar(50)			--코드타입
	, @p_param1				nvarchar(max) = null	--파라미터1	
	, @p_param2				nvarchar(max) = null	--파라미터2
	, @p_param3				nvarchar(max) = null	--파라미터3
as
begin
	set nocount on;

	if @p_code_type = 'DMF_METAL_BUCKET' 
	    select t.CODE, t.NAME
		  from (
				select cast(2 as int) as SEQ, cast('1'		as nvarchar(100)) as CODE, cast('Monthly'		 as nvarchar(100)) as NAME 
				 union all
				select cast(3 as int) as SEQ, cast('2'		as nvarchar(100)) as CODE, cast('Period Average' as nvarchar(100)) as NAME
			   ) t 
		 order by
		       t.SEQ;
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_LINK_PERIOD' 
		SELECT SEGMENT1 AS CODE
			 , SEGMENT2 AS NAME  
			 , SEGMENT3 AS PERIOD_GUBUN
			 , SEGMENT3 AS ATTR1
			 , DISPLAY_SEQ
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
		 WHERE LOOKUP_TYPE = 'DMF_BIZ_PLAN_METAL_LINK_PERIOD'
		   AND SEGMENT1    <> 'MIX'
		 UNION ALL
		SELECT SEGMENT1 AS CODE
			 , SEGMENT2 AS NAME  
			 , SEGMENT3 AS PERIOD_GUBUN
			 , SEGMENT3 AS ATTR1
			 , DISPLAY_SEQ
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
		 WHERE LOOKUP_TYPE = 'DMF_BIZ_PLAN_METAL_LINK_PERIOD'
		   AND @p_param1   = 'MIX'
		   AND SEGMENT1    = 'MIX'  
		 ORDER BY DISPLAY_SEQ;
		/*
		select t.CODE, t.NAME,t.PERIOD_GUBUN as attr1
		  from (
				select cast(1 as int)  as SEQ, cast('M-1M-3'	as nvarchar(100)) as CODE, cast('M-1 ~ M-3'		as nvarchar(100)) as NAME, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(2 as int)  as SEQ, cast('M-2M-4'	as nvarchar(100)) as CODE, cast('M-2 ~ M-4'		as nvarchar(100)) as NAME, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(3 as int)  as SEQ, cast('M-3M-5'	as nvarchar(100)) as CODE, cast('M-3 ~ M-5'		as nvarchar(100)) as NAME, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(4 as int)  as SEQ, cast('M-4M-6'	as nvarchar(100)) as CODE, cast('M-4 ~ M-6'		as nvarchar(100)) as NAME, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(5 as int)  as SEQ, cast('M-5M-7'	as nvarchar(100)) as CODE, cast('M-5 ~ M-7'		as nvarchar(100)) as NAME, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(6 as int)  as SEQ, cast('M-6M-8'	as nvarchar(100)) as CODE, cast('M-6 ~ M-8'		as nvarchar(100)) as NAME, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all

                select cast(7 as int)  as SEQ, cast('M-2M-6'	as nvarchar(100)) as CODE, cast('M-2 ~ M-6'		as nvarchar(100)) as NAME, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				
				select cast(8 as int)  as SEQ, cast('M-2M-7'	as nvarchar(100)) as CODE, cast('M-2 ~ M-7'		as nvarchar(100)) as NAME, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(9 as int)  as SEQ, cast('M-3M-8'	as nvarchar(100)) as CODE, cast('M-3 ~ M-8'		as nvarchar(100)) as NAME, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(10 as int) as SEQ, cast('M-4M-9'	as nvarchar(100)) as CODE, cast('M-4 ~ M-9'		as nvarchar(100)) as NAME, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all				
				select cast(13 as int) as SEQ, cast('MIX'		as nvarchar(100)) as CODE, cast('MIX'			as nvarchar(100)) as NAME, cast('H' as nvarchar(1)) PERIOD_GUBUN--??? PERIOD_GUBUN 확인 필요
				 where @p_param1 = 'MIX'
			   ) t 
		 order by
		       t.SEQ;
			   */
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX' 
		select t.CODE, t.NAME, t.START_OFFSET, t.END_OFFSET, t.PERIOD_GUBUN
		  from (
				select cast(1 as int)  as SEQ, cast('M-1M-3'	as nvarchar(100)) as CODE, cast('M-1 ~ M-3'		as nvarchar(100)) as NAME, cast( -3 as integer) START_OFFSET, cast(-1 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN 
				 union all
				select cast(2 as int)  as SEQ, cast('M-2M-4'	as nvarchar(100)) as CODE, cast('M-2 ~ M-4'		as nvarchar(100)) as NAME, cast( -4 as integer) START_OFFSET, cast(-2 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN 
				 union all
				select cast(3 as int)  as SEQ, cast('M-3M-5'	as nvarchar(100)) as CODE, cast('M-3 ~ M-5'		as nvarchar(100)) as NAME, cast( -5 as integer) START_OFFSET, cast(-3 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(4 as int)  as SEQ, cast('M-4M-6'	as nvarchar(100)) as CODE, cast('M-4 ~ M-6'		as nvarchar(100)) as NAME, cast( -6 as integer) START_OFFSET, cast(-4 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(5 as int)  as SEQ, cast('M-5M-7'	as nvarchar(100)) as CODE, cast('M-5 ~ M-7'		as nvarchar(100)) as NAME, cast( -7 as integer) START_OFFSET, cast(-5 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(6 as int)  as SEQ, cast('M-6M-8'	as nvarchar(100)) as CODE, cast('M-6 ~ M-8'		as nvarchar(100)) as NAME, cast( -8 as integer) START_OFFSET, cast(-6 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(7 as int)  as SEQ, cast('M-7M-9'	as nvarchar(100)) as CODE, cast('M-7 ~ M-9'		as nvarchar(100)) as NAME, cast( -9 as integer) START_OFFSET, cast(-7 as integer) END_OFFSET, cast('Q' as nvarchar(1)) PERIOD_GUBUN
				 union all

				select cast(8 as int)  as SEQ, cast('M-2M-6'	as nvarchar(100)) as CODE, cast('M-2 ~ M-6'		as nvarchar(100)) as NAME, cast( -6 as integer) START_OFFSET, cast(-2 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all

				select cast(9 as int)  as SEQ, cast('M-2M-7'	as nvarchar(100)) as CODE, cast('M-2 ~ M-7'		as nvarchar(100)) as NAME, cast( -7 as integer) START_OFFSET, cast(-2 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(10 as int)  as SEQ, cast('M-3M-8'	as nvarchar(100)) as CODE, cast('M-3 ~ M-8'		as nvarchar(100)) as NAME, cast( -8 as integer) START_OFFSET, cast(-3 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(11 as int) as SEQ, cast('M-4M-9'	as nvarchar(100)) as CODE, cast('M-4 ~ M-9'		as nvarchar(100)) as NAME, cast( -9 as integer) START_OFFSET, cast(-4 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(12 as int) as SEQ, cast('M-5M-10'	as nvarchar(100)) as CODE, cast('M-5 ~ M-10'	as nvarchar(100)) as NAME, cast(-10 as integer) START_OFFSET, cast(-5 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(13 as int) as SEQ, cast('M-6M-11'	as nvarchar(100)) as CODE, cast('M-6 ~ M-11'	as nvarchar(100)) as NAME, cast(-11 as integer) START_OFFSET, cast(-6 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
				 union all
				select cast(14 as int) as SEQ, cast('M-7M-12'	as nvarchar(100)) as CODE, cast('M-7 ~ M-12'	as nvarchar(100)) as NAME, cast(-12 as integer) START_OFFSET, cast(-7 as integer) END_OFFSET, cast('H' as nvarchar(1)) PERIOD_GUBUN
			   ) t 
		 order by
		       t.SEQ;
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_STANDARD' 
		select t.CODE, t.NAME
		  from (
		        select cast(0 as int) as SEQ, cast('0'		as nvarchar(100)) as CODE, cast('Business Plan'	as nvarchar(100)) as NAME
				 union all
				select cast(1 as int) as SEQ, cast('1'		as nvarchar(100)) as CODE, cast('LME'		as nvarchar(100)) as NAME where @p_param1 = 'Al'
				 union all
				select cast(2 as int) as SEQ, cast('1'		as nvarchar(100)) as CODE, cast('LME'		as nvarchar(100)) as NAME where @p_param1 = 'Cu'
				 union all
				select cast(3 as int) as SEQ, cast('2'		as nvarchar(100)) as CODE, cast('LMB'		as nvarchar(100)) as NAME where @p_param1 = 'Mn'
				 union all
				select cast(4 as int) as SEQ, cast('1'		as nvarchar(100)) as CODE, cast('LME'		as nvarchar(100)) as NAME where @p_param1 = 'Ni'
				 union all
				select cast(5 as int) as SEQ, cast('2'		as nvarchar(100)) as CODE, cast('LMB'		as nvarchar(100)) as NAME where @p_param1 = 'Ni'
				 union all
				select cast(6 as int) as SEQ, cast('1'		as nvarchar(100)) as CODE, cast('LME'		as nvarchar(100)) as NAME where @p_param1 = 'Co'
				 union all
				select cast(7 as int) as SEQ, cast('2'		as nvarchar(100)) as CODE, cast('LMB'		as nvarchar(100)) as NAME where @p_param1 = 'Co'
				 union all
				select cast(8 as int) as SEQ, cast('3'		as nvarchar(100)) as CODE, cast(N'Fastmarket(CIF 한중일)'	as nvarchar(100)) as NAME where @p_param1 = 'Li2CO3'
				 union all																											 
				select cast(9 as int) as SEQ, cast('4'		as nvarchar(100)) as CODE, cast('FastMarket(EXW China)'		as nvarchar(100)) as NAME where @p_param1 = 'Li2CO3'
				 union all																											 
				select cast(10 as int) as SEQ,cast('5'		as nvarchar(100)) as CODE, cast('Datamyne'					as nvarchar(100)) as NAME where @p_param1 = 'Li2CO3'
				 union all																											 
				select cast(11 as int) as SEQ,cast('6'		as nvarchar(100)) as CODE, cast('Asian Metal'				as nvarchar(100)) as NAME where @p_param1 = 'Li2CO3'
				 union all
				select cast(12 as int) as SEQ,cast('3'		as nvarchar(100)) as CODE, cast(N'Fastmarket(CIF 한중일)'	as nvarchar(100)) as NAME where @p_param1 = 'LiOH'
				 union all																											 
				select cast(13 as int) as SEQ,cast('4'		as nvarchar(100)) as CODE, cast('FastMarket(EXW China)'		as nvarchar(100)) as NAME where @p_param1 = 'LiOH'
				 union all																											 
				select cast(14 as int) as SEQ,cast('5'		as nvarchar(100)) as CODE, cast('Datamyne'					as nvarchar(100)) as NAME where @p_param1 = 'LiOH'
				 union all																											 
				select cast(15 as int) as SEQ,cast('6'		as nvarchar(100)) as CODE, cast('Asian Metal'				as nvarchar(100)) as NAME where @p_param1 = 'LiOH'
			   ) t 
		 order by
		       t.SEQ;
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_CURRENCY' 
		--[E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리) (START)
		--주석처리 후 룩업을 이용하여 데이터를 가지고 오도록 수정
		/*
		select t.SEQ, t.CODE, t.NAME
		  from (
				select cast(1 as int) as SEQ, cast('USD' as nvarchar(100)) as CODE, cast('USD' as nvarchar(100)) as NAME 
				 union all
				select cast(2 as int) as SEQ, cast('JPY' as nvarchar(100)) as CODE, cast('JPY' as nvarchar(100)) as NAME 
				 union all
				select cast(3 as int) as SEQ, cast('CNY' as nvarchar(100)) as CODE, cast('CNY' as nvarchar(100)) as NAME
				 union all
				select cast(4 as int) as SEQ, cast('EUR' as nvarchar(100)) as CODE, cast('EUR' as nvarchar(100)) as NAME
				 union all
				select cast(5 as int) as SEQ, cast('PLN' as nvarchar(100)) as CODE, cast('PLN' as nvarchar(100)) as NAME
				 union all
				select cast(6 as int) as SEQ, cast('AUD' as nvarchar(100)) as CODE, cast('AUD' as nvarchar(100)) as NAME
				 union all
				select cast(7 as int) as SEQ, cast('INR' as nvarchar(100)) as CODE, cast('INR' as nvarchar(100)) as NAME
				union all
				select cast(8 as int) as SEQ, cast('IDR' as nvarchar(100)) as CODE, cast('IDR' as nvarchar(100)) as NAME  /* E20240228-001114 HMIN IDR추가 */
				 union all
				select cast(0 as int) as SEQ, cast('KRW' as nvarchar(100)) as CODE, cast('KRW' as nvarchar(100)) as NAME where @p_param1 = 'KRW'
			   ) t 
		 order by
		       t.SEQ;*/
		SELECT T.SEQ, T.CODE, T.NAME
		FROM ( SELECT DISPLAY_SEQ AS SEQ, SEGMENT1 AS CODE, SEGMENT2 AS NAME  
				 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'CURRENCY_LIST'
				  AND VALID_YN = 'Y') T
		ORDER BY T.SEQ;
		--[E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리) (END)			   
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_CURRENCY_STANDARD'
		select t.SEQ, t.CODE, t.NAME
		  from (
				select cast(1 as int) as SEQ, cast('Business Plan' as nvarchar(100)) as CODE, cast('Business Plan' as nvarchar(100)) as NAME 				
			   ) t 
		 order by
		       t.SEQ;
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_KIND'
		select t.SEQ, t.CODE, t.NAME
		  from (
				select cast(1 as int) as SEQ, cast('Ni'		as nvarchar(100)) as CODE, cast('Ni'		as nvarchar(100)) as NAME 	
				 union all
				select cast(2 as int) as SEQ, cast('Co'		as nvarchar(100)) as CODE, cast('Co'		as nvarchar(100)) as NAME
				 union all
				select cast(3 as int) as SEQ, cast('Li2CO3' as nvarchar(100)) as CODE, cast('Li2CO3'	as nvarchar(100)) as NAME
				 union all
				select cast(4 as int) as SEQ, cast('LiOH'	as nvarchar(100)) as CODE, cast('LiOH'		as nvarchar(100)) as NAME
				 union all
				select cast(5 as int) as SEQ, cast('Al'		as nvarchar(100)) as CODE, cast('Al'		as nvarchar(100)) as NAME
				 union all
				select cast(6 as int) as SEQ, cast('Mn'		as nvarchar(100)) as CODE, cast('Mn'		as nvarchar(100)) as NAME
				 union all
				select cast(7 as int) as SEQ, cast('Cu'		as nvarchar(100)) as CODE, cast('Cu'		as nvarchar(100)) as NAME
			   ) t 
		 order by
		       t.SEQ;
	else if @p_code_type in ('DMF_BIZ_PLAN_METAL_MEASURE', 'DMF_BIZ_PLAN_METAL_MEASURE82', 'DMF_BIZ_PLAN_METAL_MEASURE40')
		SELECT 
			   SEGMENT3 AS SEQ
			 , SEGMENT1 AS CODE
			 , SEGMENT2 AS NAME  
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
		 WHERE LOOKUP_TYPE = @p_code_type
		   AND SEGMENT4    = 'Y'
		 ORDER BY SEQ;

	  --  select t.SEQ, t.CODE, t.NAME
		 -- from (
			--	select cast(1 as int) as SEQ, cast('BasePriceCur'			as nvarchar(100)) as CODE, cast('Initial Base Price(Cur)'				as nvarchar(100)) as NAME 
			--	 union all
			--	select cast(3 as int) as SEQ, cast('BasePriceChangeCur'		as nvarchar(100)) as CODE, cast('Base Price Change- CR(Cur)'		as nvarchar(100)) as NAME
			--	 union all
			--	select cast(2 as int) as SEQ, cast('BasePriceMetalAPCur'	as nvarchar(100)) as CODE, cast('Base Price - Inital Metal A/P(Cur)'	as nvarchar(100)) as NAME
			--	 union all
			--	select cast(4 as int) as SEQ, cast('BasePriceOthersCur'		as nvarchar(100)) as CODE, cast('Base Price Change- Others (Cur)'		as nvarchar(100)) as NAME
			--	 union all
			--	select cast(5 as int) as SEQ, cast('MetalIndexCur'			as nvarchar(100)) as CODE, cast('Metal Index Gap(Cur)'				as nvarchar(100)) as NAME
			--	 union all
			--	select cast(6 as int) as SEQ, cast('OtherPriceCur'			as nvarchar(100)) as CODE, cast('Others(Cur)'				as nvarchar(100)) as NAME
			--	 union all
			--	select cast(7 as int) as SEQ, cast('TotalPriceCur'			as nvarchar(100)) as CODE, cast('Total Price(Cur)'				as nvarchar(100)) as NAME
			--	 union all
			--	select cast(8 as int) as SEQ, cast('TotalPriceKRW'			as nvarchar(100)) as CODE, cast('Total Price(KRW)'				as nvarchar(100)) as NAME
			--   ) t 
		 --order by
		 --      t.SEQ;
	--else if @p_code_type = 'DMF_BIZ_PLAN_METAL_MEASURE40'
	--	SELECT 
	--		   SEGMENT3 AS SEQ
	--		 , SEGMENT1 AS CODE
	--		 , SEGMENT2 AS NAME  
	--	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
	--	 WHERE LOOKUP_TYPE = 'DMF_BIZ_PLAN_METAL_MEASURE40'
	--	 ORDER BY SEQ;
	else if @p_code_type = 'DMF_BIZ_PLAN_METAL_CELL_NICK'
		select t.SEQ, t.CODE, t.NAME
		  from (
				select cast(1 as int) as SEQ, cast('JH4'	as nvarchar(100)) as CODE, cast('JH4'							as nvarchar(100)) as NAME 
				 union all
				select cast(2 as int) as SEQ, cast('JP3'	as nvarchar(100)) as CODE, cast('JP3'							as nvarchar(100)) as NAME
				 union all
				select cast(3 as int) as SEQ, cast('JH5'	as nvarchar(100)) as CODE, cast('JH5'							as nvarchar(100)) as NAME
				 union all
				select cast(4 as int) as SEQ, cast('JH3'	as nvarchar(100)) as CODE, cast('JH3'							as nvarchar(100)) as NAME
				 union all
				select cast(5 as int) as SEQ, cast('JH6'	as nvarchar(100)) as CODE, cast('JH6'							as nvarchar(100)) as NAME
				 union all
				select cast(6 as int) as SEQ, cast('JP5'	as nvarchar(100)) as CODE, cast('JP5'							as nvarchar(100)) as NAME
				 union all
				select cast(7 as int) as SEQ, cast('JF1'	as nvarchar(100)) as CODE, cast('JF1'							as nvarchar(100)) as NAME
				 union all
				select cast(8 as int) as SEQ, cast('JF1A'	as nvarchar(100)) as CODE, cast('JF1A'							as nvarchar(100)) as NAME
				 union all
				select cast(8 as int) as SEQ, cast('JF2'	as nvarchar(100)) as CODE, cast('JF2'							as nvarchar(100)) as NAME
			   ) t 
		 order by
		       t.SEQ;
	else if @p_code_type = 'DMF0042_3_BP_Measure'
		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
		  FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		 WHERE PROGRAM_ID = 'DMF0042_3' 
		   AND SHEET_NAME = 'Biz Plan'
		 ORDER BY SORT_ORDER_NO;
	else if @p_code_type = 'DMF0051_1_BP_Measure'
		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
		  FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		 WHERE PROGRAM_ID = 'DMF0051_1' 
		   AND SHEET_NAME = 'Biz Plan Waterfall'
		 ORDER BY SORT_ORDER_NO;
	else if @p_code_type = 'CELL_PROD_SITE'
		SELECT SEGMENT1 CODE, ATTRIBUTE1 NAME
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
         WHERE LOOKUP_TYPE =   'DM_CELL_PROD_SITE'
		   AND SEGMENT1    in ('A01', 'A02', 'Z01')
		 ORDER BY DISPLAY_SEQ;
	else if @p_code_type = 'DMF_BIZ_PLAN_MONTH_START' 
		if @p_param1 = 'Q' begin
		select t.CODE, t.NAME
		  from (
				select cast(1 as int)  as SEQ, cast('JAN'	as nvarchar(100)) as CODE, cast('JAN'		as nvarchar(100)) as NAME 
				 union all
				select cast(2 as int)  as SEQ, cast('FEB'	as nvarchar(100)) as CODE, cast('FEB'		as nvarchar(100)) as NAME
				 union all
				select cast(3 as int)  as SEQ, cast('MAR'	as nvarchar(100)) as CODE, cast('MAR'		as nvarchar(100)) as NAME
			   ) t 
		 order by
		       t.SEQ;
		end
		else begin
		select t.CODE, t.NAME
		  from (
				select cast(1 as int)  as SEQ, cast('JAN'	as nvarchar(100)) as CODE, cast('JAN'		as nvarchar(100)) as NAME 
				 union all
				select cast(2 as int)  as SEQ, cast('FEB'	as nvarchar(100)) as CODE, cast('FEB'		as nvarchar(100)) as NAME
				 union all
				select cast(3 as int)  as SEQ, cast('MAR'	as nvarchar(100)) as CODE, cast('MAR'		as nvarchar(100)) as NAME
				 union all
				select cast(4 as int)  as SEQ, cast('APR'	as nvarchar(100)) as CODE, cast('APR'		as nvarchar(100)) as NAME
				 union all
				select cast(5 as int)  as SEQ, cast('MAY'	as nvarchar(100)) as CODE, cast('MAY'		as nvarchar(100)) as NAME
				 union all
				select cast(6 as int)  as SEQ, cast('JUN'	as nvarchar(100)) as CODE, cast('JUN'		as nvarchar(100)) as NAME
			   ) t 
		 order by
		       t.SEQ;
		end
end;
