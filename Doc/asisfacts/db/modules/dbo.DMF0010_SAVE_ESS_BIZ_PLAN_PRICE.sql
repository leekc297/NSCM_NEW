


/*
 * Program ID   : DMF0010_SAVE_ESS_BIZ_PLAN_PRICE
 * Description  : DMF0010_BizPlanPrice(메탈 판가 등록 화면)의 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/08/10	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/01   ilovu1          PRICE 컬럼 데이터타입 변경(NUMERIC(20,10)  --> NUMERIC(30,10))
 * 2023/09/07   ilovu1          CURRENCY 컬럼 값 할당
 * 2023/09/19   ilovu1		    METAL_LINK_START_MONTH 컬럼 추가
 * 2023/09/21   ilovu1		    Compile
 * 2023/09/27   ilovu1		    Total Price(Cur) 메저 합산 항목 변경
 */
CREATE procedure [dbo].[DMF0010_SAVE_ESS_BIZ_PLAN_PRICE]
	  @p_SAVE_FLAG						nvarchar(max) --저장구분(I:Insert, M: Modify)
	, @p_DIVISION_ID					nvarchar(max) --사업부ID
	, @p_PROJECT_CODE					nvarchar(max) --프로젝트코드
	, @p_SCM_SITE_ID					nvarchar(max) --SCM사이트ID
	, @p_ITEM_ID						nvarchar(max) --품목ID	
	, @p_MEASURE                        nvarchar(max) --계산기준
	, @p_STND_YM                        nvarchar(max) --기준연월
	, @p_PRICE                          nvarchar(max) --단가
	
	, @p_START_STND_YM                  nvarchar(max) --시작 기준연월
	, @p_END_STND_YM                    nvarchar(max) --종료 기준연월
	, @p_CREATED_BY						nvarchar(max) --생성자
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;	

	---------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	---------------------------------------------------------------------------------------------------------
    declare @v_program_name		nvarchar(150) = 'DMF0010_SAVE_ESS_BIZ_PLAN_PRICE';
    declare @v_log_type			nvarchar(30); -- START/END/ERROR/...
    declare @n_log_count		integer = 0;
    declare @v_log_message		nvarchar(1000);
    declare @v_description		nvarchar(500);
    declare @v_event_date		datetime;
	---------------------------------------------------------------------------------------------------------	

	---------------------------------------------------------------------------------------------------------
	-- 시작 LOG
	---------------------------------------------------------------------------------------------------------
	set @v_log_type		= 'START';
	set @n_log_count	= 0;
	set @v_log_message	= '########## Start of procedure ##########';
	set @v_description	= '';
	set @v_event_date	= sysdatetime();
	exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;
	---------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------
	-- 파라미터 값을 파싱하여 임시테이블에 저장
	---------------------------------------------------------------------------------------------------------
	declare @v_delimiter nvarchar(1) = '^';		--파람미터 값 구분자
	select nr as SEQ, token into #SAVE_FLAG						   from dbo.String_Split(@p_SAVE_FLAG					   , @v_delimiter);--저장구분(I:Insert, M: Modify, D: Delete)
    select nr as SEQ, token into #DIVISION_ID                      from dbo.String_Split(@p_DIVISION_ID                    , @v_delimiter);--사업부ID
    select nr as SEQ, token into #PROJECT_CODE                     from dbo.String_Split(@p_PROJECT_CODE                   , @v_delimiter);--프로젝트코드
    select nr as SEQ, token into #SCM_SITE_ID                      from dbo.String_Split(@p_SCM_SITE_ID                    , @v_delimiter);--SCM사이트ID
    select nr as SEQ, token into #ITEM_ID                          from dbo.String_Split(@p_ITEM_ID                        , @v_delimiter);--품목ID
    select nr as SEQ, token into #MEASURE                          from dbo.String_Split(@p_MEASURE                        , @v_delimiter);--계산기준
	select nr as SEQ, token into #STND_YM                          from dbo.String_Split(@p_STND_YM                        , @v_delimiter);--기준연월
	select nr as SEQ, token into #PRICE	                           from dbo.String_Split(@p_PRICE                          , @v_delimiter);--단가
	---------------------------------------------------------------------------------------------------------

	begin try
        select SAVE_FLAG.SEQ                            						 --순번
             , case when SAVE_FLAG.token                    <> '' then SAVE_FLAG.token                    else null end as SAVE_FLAG                   --저장구분(I:Insert, M: Modify, D: Delete)
             , case when DIVISION_ID.token                  <> '' then DIVISION_ID.token                  else null end as DIVISION_ID                 --사업부ID
             , case when PROJECT_CODE.token                 <> '' then PROJECT_CODE.token                 else null end as PROJECT_CODE                --프로젝트코드                       
             , case when SCM_SITE_ID.token                  <> '' then SCM_SITE_ID.token                  else null end as SCM_SITE_ID                 --SCM사이트ID                      
             , case when ITEM_ID.token                      <> '' then ITEM_ID.token                      else null end as ITEM_ID                     --품목ID   
			 , case when MEASURE.token                      <> '' then MEASURE.token                      else null end as MEASURE                     --계산기준
			 , case when STND_YM.token                      <> '' then STND_YM.token                      else null end as STND_YM                     --기준연월
			 , case when PRICE.token                        <> '' then PRICE.token                        else null end as PRICE                       --단가 
          into #SOURCE
          from              #SAVE_FLAG                      SAVE_FLAG                                                                                  --저장구분(I:Insert, M: Modify)
               inner join   #DIVISION_ID                    DIVISION_ID                                   on SAVE_FLAG.SEQ = DIVISION_ID.SEQ           --사업부ID                       
               inner join   #PROJECT_CODE                   PROJECT_CODE                                  on SAVE_FLAG.SEQ = PROJECT_CODE.SEQ          --프로젝트코드                       
               inner join   #SCM_SITE_ID                    SCM_SITE_ID                                   on SAVE_FLAG.SEQ = SCM_SITE_ID.SEQ           --SCM사이트ID                       
               inner join   #ITEM_ID                        ITEM_ID                                       on SAVE_FLAG.SEQ = ITEM_ID.SEQ               --품목ID  
			   inner join   #MEASURE                        MEASURE                                       on SAVE_FLAG.SEQ = MEASURE.SEQ               --계산기준
			   inner join   #STND_YM                        STND_YM                                       on SAVE_FLAG.SEQ = STND_YM.SEQ               --기준연월
			   inner join   #PRICE	                        PRICE                                         on SAVE_FLAG.SEQ = PRICE.SEQ                 --단가  
			   ;
		---------------------------------------------------------------------------------------------------------
		-- 데이터 유효성 체크
		---------------------------------------------------------------------------------------------------------
		--구분자에 의해 파싱한 파라미터 값의 개수 일치 여부 확인
		if exists (select 1 from #SAVE_FLAG a left join #SOURCE b on a.SEQ = b.SEQ where b.SEQ is null)
		begin 
			set @v_log_type = 'INVALID';
			select N'UI 프로그램 오류입니다. 파라미터의 값의 수가 일치하지 않습니다.';
			set @v_description = N'UI 화면 개발자에게 문의하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(DIVISION_ID)
		if exists (select 1 from #DIVISION_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Div 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Div)을 확인하세요.';
			goto err_rtn;
		end
			
		--not null 제약 확인(PROJECT_CODE)
		if exists (select 1 from #PROJECT_CODE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Project Code 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Project Code)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(SCM_SITE_ID)
		if exists (select 1 from #SCM_SITE_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Sales Site 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Sales Site)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(ITEM_ID)
		if exists (select 1 from #ITEM_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Model 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Model)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(MEASURE)
		if exists (select 1 from #MEASURE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Measure 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Measure)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(STND_YM)
		if exists (select 1 from #STND_YM where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'기준연월 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(기준연월)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(PRICE)
		if exists (select 1 from #PRICE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'금액 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(금액)을 확인하세요.';
			goto err_rtn;
		end
		---------------------------------------------------------------------------------------------------------

		select 
                    r.DIVISION_ID				--사업부ID
                  , r.PROJECT_CODE				--프로젝트코드
                  , r.SCM_SITE_ID				--SCM사이트ID
                  , r.ITEM_ID					--품목ID

                  , r.BASE_PRICE_PER_EA			--기준단가(/EA)
                  , r.METAL_LINK_YN				--메탈링크여부
                  , r.CURRENCY					--통화코드
                  , r.METAL_LINK_START_MONTH	--동일값(Metal Index(Cur)) 기간 시작연월
                  , r.METAL_LINK_MTD			--메탈링크방법
				  , r.CELL_NICK					--Cell Nick
				  , r.CELL_QTY					--Cell Qty(/Biz Type)
				  , r.CAP_PCT					--Cap Percentage

				  , case
						when r.END_YM   < @p_START_STND_YM then cast(null as nvarchar(6))
						when r.START_YM > @p_END_STND_YM   then cast(null as nvarchar(6))
						when r.START_YM < @p_START_STND_YM then @p_START_STND_YM
						else r.START_YM
                    end START_YM				--시작연월
                  , case
						when r.END_YM   < @p_START_STND_YM then cast(null as nvarchar(6))
						when r.START_YM > @p_END_STND_YM   then cast(null as nvarchar(6))
						when r.END_YM   < @p_END_STND_YM   then r.END_YM
						else @p_END_STND_YM
                    end END_YM					--종료연월 

                  , e.AL     AL_KG_PER_BIZ_TYPE     --AL     민감도   
                  , e.CU     CU_KG_PER_BIZ_TYPE     --CU     민감도   
                  , e.MN     MN_KG_PER_BIZ_TYPE     --MN     민감도   
                  , e.NI     NI_KG_PER_BIZ_TYPE     --NI     민감도   
                  , e.CO     CO_KG_PER_BIZ_TYPE     --CO     민감도   
                  , e.LI2CO3 LI2CO3_KG_PER_BIZ_TYPE --LI2CO3 민감도   
                  , e.LIOH   LIOH_KG_PER_BIZ_TYPE   --LIOH   민감도   
                  , r.AL_USD_PER_KG                 --메탈인덱스Al(USD/KG)           
                  , r.CU_USD_PER_KG                 --메탈인덱스Cu(USD/KG)           
                  , r.MN_USD_PER_KG                 --메탈인덱스Mn(USD/KG)           
                  , r.NI_USD_PER_KG                 --메탈인덱스Ni(USD/KG)           
                  , r.CO_USD_PER_KG                 --메탈인덱스Co(USD/KG)           
                  , r.LI2CO3_USD_PER_KG             --메탈인덱스Li2Co3(USD/KG)           
                  , r.LIOH_USD_PER_KG               --메탈인덱스LiOH(USD/KG)           
                  , r.CNTRC_EXCHANGE_PRICE          --계약시 환율          
                  , r.METAL_LINK_PERIOD AL_MIX_METAL_LINK_PERIOD     ----메탈링크범위
                  , r.METAL_LINK_PERIOD CU_MIX_METAL_LINK_PERIOD     ----메탈링크범위   
                  , r.METAL_LINK_PERIOD MN_MIX_METAL_LINK_PERIOD     ----메탈링크범위                
                  , r.METAL_LINK_PERIOD NI_MIX_METAL_LINK_PERIOD     ----메탈링크범위                
                  , r.METAL_LINK_PERIOD CO_MIX_METAL_LINK_PERIOD     ----메탈링크범위                
                  , r.METAL_LINK_PERIOD LI2CO3_MIX_METAL_LINK_PERIOD ----메탈링크범위          
                  , r.METAL_LINK_PERIOD LIOH_MIX_METAL_LINK_PERIOD	 ----메탈링크범위
            into #RULE
		    from (select distinct
                         DIVISION_ID                 --사업부ID
                       , PROJECT_CODE                --프로젝트코드 
                       , SCM_SITE_ID                 --SCM사이트ID  
                       , ITEM_ID                     --품목ID
					from #SOURCE
                   where MEASURE = 'BasePriceCur'
				) s
				inner join dbo.DM_MST_ESS_METAL_PRICE_RULE r with (nolock)--PK: (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)
						on s.DIVISION_ID  = r.DIVISION_ID
					   and s.PROJECT_CODE = r.PROJECT_CODE
					   and s.SCM_SITE_ID  = r.SCM_SITE_ID
					   and s.ITEM_ID      = r.ITEM_ID
				left  join dbo.DM_MST_ESS_METAL_SENSITIVITY e with (nolock)
				        on r.DIVISION_ID = e.DIVISION_ID
                       and r.CELL_NICK   = e.CELL_NICK
						;

		create table #DATA
		(
		      SAVE_FLAG                               NVARCHAR(1)         NOT NULL --저장구분(I:Insert, M: Modify, D: Delete)
			, DIVISION_ID                             NVARCHAR(30)        NOT NULL --사업부ID	
			, PROJECT_CODE                            NVARCHAR(50)        NOT NULL --프로젝트코드	
			, SCM_SITE_ID                             NVARCHAR(30)        NOT NULL --SCM사이트ID	
			, ITEM_ID                                 NVARCHAR(50)        NOT NULL --품목ID	
			, MEASURE                                 NVARCHAR(20)        NOT NULL --계산기준	
			, STND_YM                                 NVARCHAR(6)         NOT NULL --기준연월	
			, PRICE                                   NUMERIC(30,10)      NOT NULL --단가
			, CURRENCY								  NVARCHAR(10)        NOT NULL --통화코드
			, PERIOD_GUBUN							  NVARCHAR(1)             NULL --기간구분
		);
		
		--1.Base Price(Cur)
		insert 
		  into #DATA
		     ( SAVE_FLAG             --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , MEASURE               --계산기준	
			 , STND_YM               --기준연월	
			 , PRICE                 --단가
			 , CURRENCY				 --통화코드
			 )
		select 'I'                   --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , 'BasePriceCur'		   MEASURE	 --계산기준(Base Price(Cur): 1)	
			 , p.YM         STND_YM  --기준연월	
			 , r.BASE_PRICE_PER_EA PRICE --단가		
			 , r.CURRENCY			 --통화코드
		  from #RULE r
		       cross apply (select YM from dbo.DMF0009_GET_YM_IN_BETWEEN_TWO_YM(r.START_YM, r.END_YM)) p
		 where p.YM is not null;

		--2.Base Price- Change(Cur), 4.Base Price- Others (Cur), 6.Other Price(Cur)
		insert 
		  into #DATA
		     ( SAVE_FLAG             --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , MEASURE               --계산기준	
			 , STND_YM               --기준연월	
			 , PRICE                 --단가
			 , CURRENCY				 --통화코드
			 )
		select s.SAVE_FLAG
			 , s.DIVISION_ID         --사업부ID	
			 , s.PROJECT_CODE        --프로젝트코드	
			 , s.SCM_SITE_ID         --SCM사이트ID	
			 , s.ITEM_ID             --품목ID	
			 , s.MEASURE			 --계산기준(Base Price(Cur): 1)	
			 , s.STND_YM			 --기준연월	
			 , s.PRICE			     --단가	
			 , e.CURRENCY			 --통화코드
		  from #SOURCE s
		       outer apply (select r.CURRENCY 
			                  from #RULE r 
                             where r.DIVISION_ID    = s.DIVISION_ID 
                               and r.PROJECT_CODE   = s.PROJECT_CODE
                               and r.SCM_SITE_ID    = s.SCM_SITE_ID 
                               and r.ITEM_ID	    = s.ITEM_ID
						   ) e
         where MEASURE in ('BasePriceChangeCur', 'BasePriceOthersCur', 'OtherPriceCur')
		   and SAVE_FLAG <> 'D';

		--3.Base Price- Metal A/P(Cur)
		insert 
		  into #DATA
		     ( SAVE_FLAG             --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , MEASURE               --계산기준	
			 , STND_YM               --기준연월	
			 , PRICE                 --단가
			 , CURRENCY				 --통화코드
			 )
		select 'I'
             , r.DIVISION_ID 
             , r.PROJECT_CODE
             , r.SCM_SITE_ID 
             , r.ITEM_ID	  
             , 'BasePriceMetalAPCur'  MEASURE 
			 , p.YM STND_YM
			 , (
			   isnull(r.AL_KG_PER_BIZ_TYPE    , 0) * isnull(r.AL_USD_PER_KG, 0) +    
               isnull(r.CU_KG_PER_BIZ_TYPE    , 0) * isnull(r.CU_USD_PER_KG, 0) +     
               isnull(r.MN_KG_PER_BIZ_TYPE    , 0) * isnull(r.MN_USD_PER_KG, 0) +     
               isnull(r.NI_KG_PER_BIZ_TYPE    , 0) * isnull(r.NI_USD_PER_KG, 0) +     
               isnull(r.CO_KG_PER_BIZ_TYPE    , 0) * isnull(r.CO_USD_PER_KG, 0) +     
               isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) * isnull(r.LI2CO3_USD_PER_KG, 0) +  
               isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0) * isnull(r.LIOH_USD_PER_KG, 0)  
			   ) * r.CELL_QTY * 
			   case 
					when r.CURRENCY = 'USD' 
					then 1
					else r.CNTRC_EXCHANGE_PRICE
               end PRICE
             , r.CURRENCY
		  from #RULE r
		       cross apply (select YM from dbo.DMF0009_GET_YM_IN_BETWEEN_TWO_YM(r.START_YM, r.END_YM)) p
         where r.METAL_LINK_YN = 'Y'
		   and p.YM is not null;		   

		--5.Metal Index(Cur)
		create table #PERIOD
		(
              CODE				nvarchar(100)   not null
			, NAME				nvarchar(100)   not null
			, START_OFFSET      int			    not null
			, END_OFFSET        int			    not null
			, PERIOD_GUBUN      nvarchar(1)	    not null
		);

		insert
		  into #PERIOD
		exec dbo.DMF0009_GET_CODE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD_MIX';

		
		insert 
		  into #DATA
		     ( SAVE_FLAG             --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , MEASURE               --계산기준	
			 , STND_YM               --기준연월	
			 , PRICE                 --단가
			 , CURRENCY				 --통화코드
			 , PERIOD_GUBUN			 --기간구분			 
			 )
		select 'I'
			 , r.DIVISION_ID         --사업부ID	
			 , r.PROJECT_CODE        --프로젝트코드	
			 , r.SCM_SITE_ID         --SCM사이트ID	
			 , r.ITEM_ID             --품목ID	
			 , 'MetalIndexCur'		   MEASURE	 --계산기준(Metal Index(Cur): 5)	
			 , p.YM         STND_YM  --기준연월
			 , isnull(
			   case isnull(r.METAL_LINK_MTD, '1')
					when '1' then		--Monthly
						case r.CURRENCY 
							when 'USD' then
								(select ( --(해당 기간 each month 광물 단가 합계) * (KG_PER_BIZ_TYPE) / (해당 기간 개월수)
											isnull(sum(case when m.METAL_CURRENCY = 'Al'     then m.STND_PRICE end), 0) * isnull(r.AL_KG_PER_BIZ_TYPE    , 0) / isnull((e_AL.END_OFFSET     - e_AL.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Cu'     then m.STND_PRICE end), 0) * isnull(r.CU_KG_PER_BIZ_TYPE    , 0) / isnull((e_CU.END_OFFSET     - e_CU.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Mn'     then m.STND_PRICE end), 0) * isnull(r.MN_KG_PER_BIZ_TYPE    , 0) / isnull((e_MN.END_OFFSET     - e_MN.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Ni'     then m.STND_PRICE end), 0) * isnull(r.NI_KG_PER_BIZ_TYPE    , 0) / isnull((e_NI.END_OFFSET     - e_NI.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Co'     then m.STND_PRICE end), 0) * isnull(r.CO_KG_PER_BIZ_TYPE    , 0) / isnull((e_CO.END_OFFSET     - e_CO.START_OFFSET + 1), 1) +  
											isnull(sum(case when m.METAL_CURRENCY = 'Li2CO3' then m.STND_PRICE end), 0) * isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) / isnull((e_LI2CO3.END_OFFSET - e_LI2CO3.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'LiOH'   then m.STND_PRICE end), 0) * isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0) / isnull((e_LIOH.END_OFFSET   - e_LIOH.START_OFFSET + 1), 1) 
										)
								   from dbo.DM_MST_METAL_CURRENCY_PRICE m		--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
								  where m.DIVISION_ID         = r.DIVISION_ID	--사업부ID
									and m.METAL_CURRENCY_GBN  = '2'				--메탈통화구분(1 통화, 2 메탈)
									and (--    METAL_CURRENCY(메탈통화항목)    STND_MARKET(기준시장)                    STND_YM(기준연월)
									        (m.METAL_CURRENCY = 'Al'     and m.STND_YM between format(dateadd(month, e_AL.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_AL.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Cu'     and m.STND_YM between format(dateadd(month, e_CU.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CU.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Mn'     and m.STND_YM between format(dateadd(month, e_MN.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_MN.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Ni'     and m.STND_YM between format(dateadd(month, e_NI.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_NI.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Co'     and m.STND_YM between format(dateadd(month, e_CO.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CO.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Li2CO3' and m.STND_YM between format(dateadd(month, e_LI2CO3.START_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LI2CO3.END_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'LiOH'   and m.STND_YM between format(dateadd(month, e_LIOH.START_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LIOH.END_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										)
								)
							when 'KRW' then
								(select ( --(해당 기간 each month (광물 단가) * (USD환율) * (해당통화환율) 합계) * (KG_PER_BIZ_TYPE) / (해당 기간 개월수)
											isnull(sum(case when m.METAL_CURRENCY = 'Al'     then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.AL_KG_PER_BIZ_TYPE    , 0) / isnull((e_AL.END_OFFSET     - e_AL.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Cu'     then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.CU_KG_PER_BIZ_TYPE    , 0) / isnull((e_CU.END_OFFSET     - e_CU.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Mn'     then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.MN_KG_PER_BIZ_TYPE    , 0) / isnull((e_MN.END_OFFSET     - e_MN.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Ni'     then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.NI_KG_PER_BIZ_TYPE    , 0) / isnull((e_NI.END_OFFSET     - e_NI.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Co'     then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.CO_KG_PER_BIZ_TYPE    , 0) / isnull((e_CO.END_OFFSET     - e_CO.START_OFFSET + 1), 1) +   
											isnull(sum(case when m.METAL_CURRENCY = 'Li2CO3' then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) / isnull((e_LI2CO3.END_OFFSET - e_LI2CO3.START_OFFSET + 1) , 1)+
											isnull(sum(case when m.METAL_CURRENCY = 'LiOH'   then m.STND_PRICE * c1.STND_PRICE end), 0) * isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0) / isnull((e_LIOH.END_OFFSET   - e_LIOH.START_OFFSET + 1), 1)
										)
								   from dbo.DM_MST_METAL_CURRENCY_PRICE m		--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
								        inner join dbo.DM_MST_METAL_CURRENCY_PRICE c1
										        on m.DIVISION_ID         = c1.DIVISION_ID
                                               and c1.METAL_CURRENCY_GBN = '1'
											   and m.STND_YM             = c1.STND_YM
											   and c1.METAL_CURRENCY     = 'USD'
											   and c1.STND_MARKET         = 'Business Plan'
								  where m.DIVISION_ID		  = r.DIVISION_ID	--사업부ID
									and m.METAL_CURRENCY_GBN  = '2'				--메탈통화구분(1 통화, 2 메탈)
									and (--    METAL_CURRENCY(메탈통화항목)    STND_MARKET(기준시장)                    STND_YM(기준연월)
									        (m.METAL_CURRENCY = 'Al'     and m.STND_YM between format(dateadd(month, e_AL.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_AL.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Cu'     and m.STND_YM between format(dateadd(month, e_CU.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CU.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Mn'     and m.STND_YM between format(dateadd(month, e_MN.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_MN.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Ni'     and m.STND_YM between format(dateadd(month, e_NI.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_NI.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Co'     and m.STND_YM between format(dateadd(month, e_CO.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CO.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Li2CO3' and m.STND_YM between format(dateadd(month, e_LI2CO3.START_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LI2CO3.END_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'LiOH'   and m.STND_YM between format(dateadd(month, e_LIOH.START_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LIOH.END_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										)									
								)
                            else
								(select ( --(해당 기간 each month (광물 단가) * (USD환율) * (해당통화환율) 합계) * (KG_PER_BIZ_TYPE) / (해당 기간 개월수)
											isnull(sum(case when m.METAL_CURRENCY = 'Al'     then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.AL_KG_PER_BIZ_TYPE    , 0) / isnull((e_AL.END_OFFSET     - e_AL.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Cu'     then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.CU_KG_PER_BIZ_TYPE    , 0) / isnull((e_CU.END_OFFSET     - e_CU.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Mn'     then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.MN_KG_PER_BIZ_TYPE    , 0) / isnull((e_MN.END_OFFSET     - e_MN.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Ni'     then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.NI_KG_PER_BIZ_TYPE    , 0) / isnull((e_NI.END_OFFSET     - e_NI.START_OFFSET + 1), 1) + 
											isnull(sum(case when m.METAL_CURRENCY = 'Co'     then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.CO_KG_PER_BIZ_TYPE    , 0) / isnull((e_CO.END_OFFSET     - e_CO.START_OFFSET + 1), 1) +   
											isnull(sum(case when m.METAL_CURRENCY = 'Li2CO3' then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) / isnull((e_LI2CO3.END_OFFSET - e_LI2CO3.START_OFFSET + 1) , 1)+
											isnull(sum(case when m.METAL_CURRENCY = 'LiOH'   then m.STND_PRICE * c1.STND_PRICE / c2.STND_PRICE end), 0) * isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0) / isnull((e_LIOH.END_OFFSET   - e_LIOH.START_OFFSET + 1), 1)
										)
								   from dbo.DM_MST_METAL_CURRENCY_PRICE m		--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
								        inner join dbo.DM_MST_METAL_CURRENCY_PRICE c1
										        on m.DIVISION_ID         = c1.DIVISION_ID
                                               and c1.METAL_CURRENCY_GBN = '1'
											   and m.STND_YM             = c1.STND_YM
											   and c1.METAL_CURRENCY     = 'USD'
											   and c1.STND_MARKET         = 'Business Plan'
								        inner join dbo.DM_MST_METAL_CURRENCY_PRICE c2
										        on m.DIVISION_ID         = c2.DIVISION_ID
                                               and c2.METAL_CURRENCY_GBN = '1'
											   and m.STND_YM             = c2.STND_YM
											   and c2.METAL_CURRENCY     = r.CURRENCY
											   and c2.STND_MARKET         = 'Business Plan'
								  where m.DIVISION_ID		  = r.DIVISION_ID	--사업부ID
									and m.METAL_CURRENCY_GBN  = '2'				--메탈통화구분(1 통화, 2 메탈)
									and (--    METAL_CURRENCY(메탈통화항목)    STND_MARKET(기준시장)                    STND_YM(기준연월)
									        (m.METAL_CURRENCY = 'Al'     and m.STND_YM between format(dateadd(month, e_AL.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_AL.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Cu'     and m.STND_YM between format(dateadd(month, e_CU.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CU.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Mn'     and m.STND_YM between format(dateadd(month, e_MN.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_MN.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Ni'     and m.STND_YM between format(dateadd(month, e_NI.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_NI.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Co'     and m.STND_YM between format(dateadd(month, e_CO.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CO.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Li2CO3' and m.STND_YM between format(dateadd(month, e_LI2CO3.START_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LI2CO3.END_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'LiOH'   and m.STND_YM between format(dateadd(month, e_LIOH.START_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LIOH.END_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										)									
								)
						end 
					when '2' then		--Period Average
						case r.CURRENCY 
							when 'USD' then
								(select ( --(해당 기간 (광물 단가 평균)) * (KG_PER_BIZ_TYPE)
											isnull(avg(case when m.METAL_CURRENCY = 'Al'     then m.STND_PRICE end), 0) * isnull(r.AL_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Cu'     then m.STND_PRICE end), 0) * isnull(r.CU_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Mn'     then m.STND_PRICE end), 0) * isnull(r.MN_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Ni'     then m.STND_PRICE end), 0) * isnull(r.NI_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Co'     then m.STND_PRICE end), 0) * isnull(r.CO_KG_PER_BIZ_TYPE    , 0) +  
											isnull(avg(case when m.METAL_CURRENCY = 'Li2CO3' then m.STND_PRICE end), 0) * isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'LiOH'   then m.STND_PRICE end), 0) * isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0)
										)
								   from dbo.DM_MST_METAL_CURRENCY_PRICE m		--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
								  where m.DIVISION_ID         = r.DIVISION_ID	--사업부ID
									and m.METAL_CURRENCY_GBN  = '2'				--메탈통화구분(1 통화, 2 메탈)
									and (--    METAL_CURRENCY(메탈통화항목)    STND_MARKET(기준시장)                    STND_YM(기준연월)
									        (m.METAL_CURRENCY = 'Al'     and m.STND_YM between format(dateadd(month, e_AL.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_AL.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Cu'     and m.STND_YM between format(dateadd(month, e_CU.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CU.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Mn'     and m.STND_YM between format(dateadd(month, e_MN.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_MN.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Ni'     and m.STND_YM between format(dateadd(month, e_NI.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_NI.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Co'     and m.STND_YM between format(dateadd(month, e_CO.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CO.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Li2CO3' and m.STND_YM between format(dateadd(month, e_LI2CO3.START_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LI2CO3.END_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'LiOH'   and m.STND_YM between format(dateadd(month, e_LIOH.START_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LIOH.END_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										)
								)
							when 'KRW' then
								(select ( --(해당 기간 (광물 단가 평균) * (USD환율 평균) / (해당통화환율 평균)) * (KG_PER_BIZ_TYPE)
											isnull(avg(case when m.METAL_CURRENCY = 'Al'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Al'     then c1.STND_PRICE end), 0) * isnull(r.AL_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Cu'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Cu'     then c1.STND_PRICE end), 0) * isnull(r.CU_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Mn'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Mn'     then c1.STND_PRICE end), 0) * isnull(r.MN_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Ni'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Ni'     then c1.STND_PRICE end), 0) * isnull(r.NI_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Co'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Co'     then c1.STND_PRICE end), 0) * isnull(r.CO_KG_PER_BIZ_TYPE    , 0) +  
											isnull(avg(case when m.METAL_CURRENCY = 'Li2CO3' then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Li2CO3' then c1.STND_PRICE end), 0) * isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'LiOH'   then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'LiOH'   then c1.STND_PRICE end), 0) * isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0) 
										)
								   from dbo.DM_MST_METAL_CURRENCY_PRICE m		--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
								        inner join dbo.DM_MST_METAL_CURRENCY_PRICE c1
										        on m.DIVISION_ID         = c1.DIVISION_ID
                                               and c1.METAL_CURRENCY_GBN = '1'
											   and m.STND_YM             = c1.STND_YM
											   and c1.METAL_CURRENCY     = 'USD'
											   and c1.STND_MARKET         = 'Business Plan'
								  where m.DIVISION_ID		  = r.DIVISION_ID	--사업부ID
									and m.METAL_CURRENCY_GBN  = '2'				--메탈통화구분(1 통화, 2 메탈)
									and (--    METAL_CURRENCY(메탈통화항목)    STND_MARKET(기준시장)                    STND_YM(기준연월)
									        (m.METAL_CURRENCY = 'Al'     and m.STND_YM between format(dateadd(month, e_AL.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_AL.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Cu'     and m.STND_YM between format(dateadd(month, e_CU.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CU.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Mn'     and m.STND_YM between format(dateadd(month, e_MN.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_MN.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Ni'     and m.STND_YM between format(dateadd(month, e_NI.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_NI.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Co'     and m.STND_YM between format(dateadd(month, e_CO.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CO.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Li2CO3' and m.STND_YM between format(dateadd(month, e_LI2CO3.START_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LI2CO3.END_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'LiOH'   and m.STND_YM between format(dateadd(month, e_LIOH.START_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LIOH.END_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										)									
								)
                            else
								(select ( --(해당 기간 (광물 단가 평균) * (USD환율 평균) / (해당통화환율 평균)) * (KG_PER_BIZ_TYPE)
											isnull(avg(case when m.METAL_CURRENCY = 'Al'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Al'     then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'Al'     then c2.STND_PRICE end), 1) * isnull(r.AL_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Cu'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Cu'     then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'Cu'     then c2.STND_PRICE end), 1) * isnull(r.CU_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Mn'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Mn'     then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'Mn'     then c2.STND_PRICE end), 1) * isnull(r.MN_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Ni'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Ni'     then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'Ni'     then c2.STND_PRICE end), 1) * isnull(r.NI_KG_PER_BIZ_TYPE    , 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'Co'     then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Co'     then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'Co'     then c2.STND_PRICE end), 1) * isnull(r.CO_KG_PER_BIZ_TYPE    , 0) +  
											isnull(avg(case when m.METAL_CURRENCY = 'Li2CO3' then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'Li2CO3' then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'Li2CO3' then c2.STND_PRICE end), 1) * isnull(r.LI2CO3_KG_PER_BIZ_TYPE, 0) + 
											isnull(avg(case when m.METAL_CURRENCY = 'LiOH'   then m.STND_PRICE end), 0) * isnull(avg(case when m.METAL_CURRENCY = 'LiOH'   then c1.STND_PRICE end), 0) / isnull(avg(case when m.METAL_CURRENCY = 'LiOH'   then c2.STND_PRICE end), 1) * isnull(r.LIOH_KG_PER_BIZ_TYPE  , 0) 
										)
								   from dbo.DM_MST_METAL_CURRENCY_PRICE m		--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
								        inner join dbo.DM_MST_METAL_CURRENCY_PRICE c1
										        on m.DIVISION_ID         = c1.DIVISION_ID
                                               and c1.METAL_CURRENCY_GBN = '1'
											   and m.STND_YM             = c1.STND_YM
											   and c1.METAL_CURRENCY     = 'USD'
											   and c1.STND_MARKET         = 'Business Plan'
								        inner join dbo.DM_MST_METAL_CURRENCY_PRICE c2
										        on m.DIVISION_ID         = c2.DIVISION_ID
                                               and c2.METAL_CURRENCY_GBN = '1'
											   and m.STND_YM             = c2.STND_YM
											   and c2.METAL_CURRENCY     = r.CURRENCY
											   and c2.STND_MARKET         = 'Business Plan'
								  where m.DIVISION_ID		  = r.DIVISION_ID	--사업부ID
									and m.METAL_CURRENCY_GBN  = '2'				--메탈통화구분(1 통화, 2 메탈)
									and (--    METAL_CURRENCY(메탈통화항목)    STND_MARKET(기준시장)                    STND_YM(기준연월)
									        (m.METAL_CURRENCY = 'Al'     and m.STND_YM between format(dateadd(month, e_AL.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_AL.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_AL.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Cu'     and m.STND_YM between format(dateadd(month, e_CU.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CU.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CU.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Mn'     and m.STND_YM between format(dateadd(month, e_MN.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_MN.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_MN.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Ni'     and m.STND_YM between format(dateadd(month, e_NI.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_NI.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_NI.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Co'     and m.STND_YM between format(dateadd(month, e_CO.START_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_CO.END_OFFSET,     dbo.DMF0009_GET_START_YM(e_CO.PERIOD_GUBUN,     r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'Li2CO3' and m.STND_YM between format(dateadd(month, e_LI2CO3.START_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LI2CO3.END_OFFSET, dbo.DMF0009_GET_START_YM(e_LI2CO3.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										 or (m.METAL_CURRENCY = 'LiOH'   and m.STND_YM between format(dateadd(month, e_LIOH.START_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM') and format(dateadd(month, e_LIOH.END_OFFSET,   dbo.DMF0009_GET_START_YM(e_LIOH.PERIOD_GUBUN,   r.METAL_LINK_START_MONTH, p.YM) + '01'), 'yyyyMM'))
										)									
								)
						end 
			   end * r.CELL_QTY - 
			   (select PRICE 
			      from #DATA
                 where DIVISION_ID  = r.DIVISION_ID		--사업부ID
				   and PROJECT_CODE = r.PROJECT_CODE	--프로젝트코드
				   and SCM_SITE_ID  = r.SCM_SITE_ID		--SCM사이트ID
				   and ITEM_ID	    = r.ITEM_ID			--품목ID
				   and MEASURE      = 'BasePriceMetalAPCur'				--Base Price- Metal A/P(Cur)
				   and STND_YM      = p.YM				--기준연월
			   ), 0) PRICE				--단가
             , r.CURRENCY
             , COALESCE(e_AL.PERIOD_GUBUN, e_CU.PERIOD_GUBUN, e_MN.PERIOD_GUBUN, e_NI.PERIOD_GUBUN, e_CO.PERIOD_GUBUN, e_LI2CO3.PERIOD_GUBUN, e_LIOH.PERIOD_GUBUN) --기간구분
		  from #RULE r
			   left  join #PERIOD e_AL		on r.AL_MIX_METAL_LINK_PERIOD    = e_AL.CODE
			   left  join #PERIOD e_CU		on r.CU_MIX_METAL_LINK_PERIOD    = e_CU.CODE
			   left  join #PERIOD e_MN		on r.MN_MIX_METAL_LINK_PERIOD    = e_MN.CODE
			   left  join #PERIOD e_NI		on r.NI_MIX_METAL_LINK_PERIOD    = e_NI.CODE
			   left  join #PERIOD e_CO		on r.CO_MIX_METAL_LINK_PERIOD    = e_CO.CODE
			   left  join #PERIOD e_LI2CO3	on r.LI2CO3_MIX_METAL_LINK_PERIOD= e_LI2CO3.CODE
			   left  join #PERIOD e_LIOH	on r.LIOH_MIX_METAL_LINK_PERIOD  = e_LIOH.CODE		
		       cross apply (select YM from dbo.DMF0009_GET_YM_IN_BETWEEN_TWO_YM(r.START_YM, r.END_YM)) p	           
         where r.METAL_LINK_YN = 'Y'
		   and p.YM is not null;

 --/* 
--        select
--			   DIVISION_ID        --사업부ID	
--			 , PROJECT_CODE       --프로젝트코드	
--			 , SCM_SITE_ID        --SCM사이트ID	
--			 , ITEM_ID            --품목ID	
--			 , dbo.DMF0009_GET_START_YM(PERIOD_GUBUN, STND_YM) STND_YM --기준연월	
--			 , MIN(PRICE) PRICE   --단가
--			 , MIN(PERIOD_GUBUN) PERIOD_GUBUN					       --기간구분
--		  into #TEMP
--		  from #DATA
--         where MEASURE = '5'
--		 group by
--			   DIVISION_ID        --사업부ID	
--			 , PROJECT_CODE       --프로젝트코드	
--			 , SCM_SITE_ID        --SCM사이트ID	
--			 , ITEM_ID            --품목ID
--			 , dbo.DMF0009_GET_START_YM(PERIOD_GUBUN, STND_YM) --기준연월
--		 ;
		declare @v_DIVISION_ID  NVARCHAR(30)   = null;--사업부ID	
		declare @v_PROJECT_CODE NVARCHAR(50)   = null;--프로젝트코드	
		declare @v_SCM_SITE_ID  NVARCHAR(30)   = null;--SCM사이트ID	
		declare @v_ITEM_ID      NVARCHAR(50)   = null;--품목ID		
		declare @v_STND_YM      NVARCHAR(6)    = null;--기준연월	
		declare @v_PRICE5       NUMERIC(30,10) = null;--단가(Metal Index(Cur))
		declare @v_PRICE3       NUMERIC(30,10) = null;--단가(Base Price- Metal A/P(Cur))
		declare @v_CAP_PCT      NUMERIC(5,2)   = null;--Cap Percentage
		declare @v_PERIOD_GUBUN NVARCHAR(1)    = null;--기간구분
		declare @v_METAL_LINK_START_MONTH NVARCHAR(3) = null;--동일값(Metal Index(Cur)) 기간 시작연월
		declare @v_PREV_PRICE5  NUMERIC(30,10) = null;--직전단가(Metal Index(Cur))

		declare @v_value1       NUMERIC(30,10);
		declare @v_value2       NUMERIC(30,10);

		declare c1 cursor for
			select d.DIVISION_ID           --사업부ID
			     , d.PROJECT_CODE          --프로젝트코드	
			     , d.SCM_SITE_ID           --SCM사이트ID	
			     , d.ITEM_ID               --품목ID	
			     , dbo.DMF0009_GET_START_YM(d.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, d.STND_YM)  STND_YM --기준연월				 
			     , d.PRICE				   --단가(Metal Index(Cur))
				 , e.PRICE 				   --단가(Base Price- Metal A/P(Cur))
				 , r.CAP_PCT			   --Cap Percentage
				 , d.PERIOD_GUBUN          --기간구분
				 , r.METAL_LINK_START_MONTH--동일값(Metal Index(Cur)) 기간 시작연월
			  from #DATA d with (nolock)
			       inner join  #RULE r with (nolock)
				           on  d.DIVISION_ID	 = r.DIVISION_ID			--사업부ID
                          and  d.PROJECT_CODE	 = r.PROJECT_CODE			--프로젝트코드
						  and  d.SCM_SITE_ID	 = r.SCM_SITE_ID			--SCM사이트ID
						  and  d.ITEM_ID		 = r.ITEM_ID				--품목ID
			       cross apply (select top 1 PRICE 
				                  from #DATA s with (nolock)
                                 where s.DIVISION_ID = d.DIVISION_ID
								   and s.PROJECT_CODE= d.PROJECT_CODE
								   and s.SCM_SITE_ID = d.SCM_SITE_ID
								   and s.ITEM_ID     = d.ITEM_ID
								   and s.MEASURE     = 'BasePriceMetalAPCur'					--3.Base Price- Metal A/P(Cur)
							   ) e
             where MEASURE = 'MetalIndexCur'		   --5.Metal Index(Cur)
			 group by
			       d.DIVISION_ID           --사업부ID
				 , d.PROJECT_CODE          --프로젝트코드	
				 , d.SCM_SITE_ID           --SCM사이트ID	
				 , d.ITEM_ID               --품목ID
			     , dbo.DMF0009_GET_START_YM(d.PERIOD_GUBUN, r.METAL_LINK_START_MONTH, d.STND_YM) --기준연월				 
			     , d.PRICE				   --단가(Metal Index(Cur))
				 , e.PRICE 				   --단가(Base Price- Metal A/P(Cur))
				 , r.CAP_PCT			   --Cap Percentage
				 , d.PERIOD_GUBUN          --기간구분
				 , r.METAL_LINK_START_MONTH--동일값(Metal Index(Cur)) 기간 시작연월
			 order by
			       d.DIVISION_ID           --사업부ID
			     , d.PROJECT_CODE          --프로젝트코드	
			     , d.SCM_SITE_ID           --SCM사이트ID	
			     , d.ITEM_ID               --품목ID
			     , STND_YM                 --기준연월	
			 ;
		open c1;
		fetch next from c1 into @v_DIVISION_ID   --사업부ID
                              , @v_PROJECT_CODE  --프로젝트코드	
                              , @v_SCM_SITE_ID   --SCM사이트ID	
                              , @v_ITEM_ID       --품목ID	
                              , @v_STND_YM       --기준연월	
                              , @v_PRICE5        --단가(Metal Index(Cur))
                              , @v_PRICE3        --단가(Base Price- Metal A/P(Cur))
							  , @v_CAP_PCT       --Cap Percentage
							  , @v_PERIOD_GUBUN	 --기간구분
							  , @v_METAL_LINK_START_MONTH--동일값(Metal Index(Cur)) 기간 시작연월
							  ;     

		while (@@FETCH_STATUS=0)
		begin
			begin try	
				if @v_CAP_PCT is not null
				begin
					set @v_PREV_PRICE5 = null;
					select @v_PREV_PRICE5 = PRICE
					  from #DATA d with (nolock)
					 where d.DIVISION_ID  = @v_DIVISION_ID   --사업부ID                   
					   and d.PROJECT_CODE = @v_PROJECT_CODE  --프로젝트코드
					   and d.SCM_SITE_ID  = @v_SCM_SITE_ID   --SCM사이트ID
					   and d.ITEM_ID      = @v_ITEM_ID       --품목ID
					   and d.MEASURE      = 'MetalIndexCur'              --단가(Metal Index(Cur))
					   and d.STND_YM      = format(dateadd(month, -1, dbo.DMF0009_GET_START_YM(@v_PERIOD_GUBUN, @v_METAL_LINK_START_MONTH, @v_STND_YM) + '01'), 'yyyyMM')  --기준연월 
					   ;
				end
				else
					set @v_PREV_PRICE5 = null;

				if @v_PREV_PRICE5 is not null
				begin					
					set @v_value1 = ((@v_PRICE5 + @v_PRICE3) - (@v_PREV_PRICE5 + @v_PRICE3));--직전기간 대비 증감 금액
					set @v_value2 = ABS( (@v_PREV_PRICE5 + @v_PRICE3) *(@v_CAP_PCT * 0.01) );--최대 증감 금액
					if ABS(@v_value1) > @v_value2
					begin
						set @v_PRICE5 = case when @v_value1 >= 0 then @v_PREV_PRICE5 + @v_value2 else @v_PREV_PRICE5 - @v_value2 end;

						update #DATA
						   set PRICE = @v_PRICE5
						 where DIVISION_ID  = @v_DIVISION_ID   --사업부ID                   
						   and PROJECT_CODE = @v_PROJECT_CODE  --프로젝트코드
						   and SCM_SITE_ID  = @v_SCM_SITE_ID   --SCM사이트ID
						   and ITEM_ID      = @v_ITEM_ID       --품목ID
						   and MEASURE      = 'MetalIndexCur'              --단가(Metal Index(Cur))
						   and dbo.DMF0009_GET_START_YM(@v_PERIOD_GUBUN, @v_METAL_LINK_START_MONTH, STND_YM) = @v_STND_YM --기준연월
						   ;
					end
				end
				fetch next from c1 into @v_DIVISION_ID   --사업부ID
									  , @v_PROJECT_CODE  --프로젝트코드	
									  , @v_SCM_SITE_ID   --SCM사이트ID	
									  , @v_ITEM_ID       --품목ID	
									  , @v_STND_YM       --기준연월	
									  , @v_PRICE5        --단가(Metal Index(Cur))
									  , @v_PRICE3        --단가(Base Price- Metal A/P(Cur))
									  , @v_CAP_PCT       --Cap Percentage
									  , @v_PERIOD_GUBUN	 --기간구분
									  , @v_METAL_LINK_START_MONTH--동일값(Metal Index(Cur)) 기간 시작연월
									  ;
			end try
			begin catch
				if CURSOR_STATUS('global','c1') > -1 
				begin
					close c1;
					deallocate c1;
				end
				if @@trancount > 0
					rollback tran;

				---------------------------------------------------------------------------------------------------------
				-- ERROR LOG
				---------------------------------------------------------------------------------------------------------
				set @v_log_type		= 'ERROR';
				set @n_log_count	= @n_log_count + 1;
				set @v_log_message	= cast(error_message() AS nvarchar(1000));
				set @v_description	= 'ERROR_LINE : ' + str(error_line());
				set @v_event_date	= sysdatetime();
				exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

				select '[' + convert(nvarchar(10), error_number()) + ']' + error_message();
				return;
			end catch
		end
		if CURSOR_STATUS('global','c1') > -1 
		begin
			close c1;
			deallocate c1;
		end
--*/
		--7.Total Price(Cur)
		insert 
		  into #DATA
		     ( SAVE_FLAG             --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , MEASURE               --계산기준	
			 , STND_YM               --기준연월	
			 , PRICE                 --단가
			 , CURRENCY				 --통화코드
			 )
		select 'I'
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , 'TotalPriceCur'        MEASURE    --계산기준: Total Price(Cur)
			 , STND_YM               --기준연월	
			 , sum(PRICE) PRICE		 --단가
			 , d.CURRENCY			 --통화코드
		  from #DATA d
		 where MEASURE in (
						    'BasePriceCur'
						  , 'BasePriceChangeCur'
						  --, 'BasePriceMetalAPCur'
						  , 'BasePriceOthersCur'
						  , 'MetalIndexCur'
						  , 'OtherPriceCur'
						  )
		 group by
			   DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID
			 , STND_YM               --기준연월
			 , d.CURRENCY			 --통화코드
		      ;

		--8.Total Price(KRW)
		insert 
		  into #DATA
		     ( SAVE_FLAG             --저장구분(I:Insert, M: Modify, D: Delete)
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , MEASURE               --계산기준	
			 , STND_YM               --기준연월	
			 , PRICE                 --단가
			 , CURRENCY				 --통화코드
			 )
		select 'I'
			 , DIVISION_ID           --사업부ID	
			 , PROJECT_CODE          --프로젝트코드	
			 , SCM_SITE_ID           --SCM사이트ID	
			 , ITEM_ID               --품목ID	
			 , 'TotalPriceKRW'        MEASURE    --계산기준: Total Price(KRW)
			 , STND_YM               --기준연월	
			 , isnull(
			   case d.CURRENCY
					when 'KRW' then 
						d.PRICE
					else
						(select d.PRICE * c.STND_PRICE
						   from dbo.DM_MST_METAL_CURRENCY_PRICE c	--PK: DIVISION_ID, METAL_CURRENCY_GBN, STND_YM, METAL_CURRENCY, STND_MARKET
                          where c.DIVISION_ID         = d.DIVISION_ID   --사업부ID
                            and c.METAL_CURRENCY_GBN  = '1'				--메탈통화구분(1 통화, 2 메탈)
                            and c.STND_YM             = d.STND_YM		--기준연월
                            and c.METAL_CURRENCY      = d.CURRENCY		--메탈통화항목	
                            and c.STND_MARKET         = 'Business Plan' --기준시장
						)
			   end, 0)        PRICE  --단가
             , 'KRW' CURRENCY		 --통화코드
		  from #DATA d   
		 where MEASURE in ('TotalPriceCur');

		begin tran;
		delete t
		  from dbo.DM_MST_METAL_PRICE t
		       inner join (select a.DIVISION_ID, a.PROJECT_CODE, a.SCM_SITE_ID, a.ITEM_ID, b.YM STND_YM 
			                 from #SOURCE a 
							      cross join dbo.DMF0009_GET_YM_IN_BETWEEN_TWO_YM(@p_START_STND_YM, @p_END_STND_YM) b 
						    where MEASURE = 'BasePriceCur'
						  ) s
					   on s.DIVISION_ID     = t.DIVISION_ID
					  and s.PROJECT_CODE    = t.PROJECT_CODE
					  and s.SCM_SITE_ID     = t.SCM_SITE_ID
					  and s.ITEM_ID         = t.ITEM_ID
					  and s.STND_YM         = t.STND_YM;
		
		insert 
		  into dbo.DM_MST_METAL_PRICE
		     (
			   DIVISION_ID						--사업부ID                    
             , PROJECT_CODE                		--프로젝트코드                
             , SCM_SITE_ID                 		--SCM사이트ID                 
             , ITEM_ID                     		--품목ID                      
	         , MEASURE                          --계산기준	
	         , STND_YM                          --기준연월	
	         , PRICE                            --단가	           
			 , CURRENCY                         --통화코드             
			 , CREATED_BY						--생성자 
			 , CREATION_DATE					--생성일자
			 , LAST_UPDATED_BY					--최종수정자
			 , LAST_UPDATE_DATE					--최종수정일자
			 )
		select
			   DIVISION_ID                      --사업부ID	
			 , PROJECT_CODE                     --프로젝트코드	
			 , SCM_SITE_ID                      --SCM사이트ID	
			 , ITEM_ID                          --품목ID	
			 , MEASURE                          --계산기준	
			 , STND_YM                          --기준연월	
			 , PRICE                            --단가			  
			 , d.CURRENCY                       --통화코드    
			 , @p_CREATED_BY					--생성자 
			 , getdate()						--생성일자
			 , @p_CREATED_BY					--최종수정자
			 , getdate()						--최종수정일자	
		  from #DATA d;
		commit tran;
  	end try
	
	begin catch
		if @@trancount > 0
			rollback tran;

		---------------------------------------------------------------------------------------------------------
		-- ERROR LOG
		---------------------------------------------------------------------------------------------------------
		set @v_log_type		= 'ERROR';
		set @n_log_count	= @n_log_count + 1;
		set @v_log_message	= cast(error_message() AS nvarchar(1000));
		set @v_description	= 'ERROR_LINE : ' + str(error_line());
		set @v_event_date	= sysdatetime();
		exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

		select '[' + convert(nvarchar(10), error_number()) + ']' + error_message();
	end catch
	
	---------------------------------------------------------------------------------------------------------
	-- 종료 LOG
	---------------------------------------------------------------------------------------------------------
	set @v_log_type		= 'END';
	set @n_log_count	= @n_log_count + 1;
	set @v_log_message	= '########## END of procedure ##########';;
	set @v_description	= '';
	set @v_event_date	= sysdatetime();
	exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;
end;

err_rtn:
	if @v_log_type = 'INVALID'
		begin		
			if @@trancount > 0
				rollback tran;

			set @n_log_count	= @n_log_count + 1;
			set @v_log_message	= '########## END of procedure ##########';
			set @v_event_date	= sysdatetime();
			exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

			select @v_description;
		end	
