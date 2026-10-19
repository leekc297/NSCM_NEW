
/*
 * Program ID   : DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT
 * Description  : DMF0009_BizPlanPrice_Input(메탈 판가 기준등록 화면)의 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/08/10	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/18   ilovu1		    METAL_LINK_START_MONTH 컬럼 추가
 * 2023/09/18   ilovu1		    METAL_LINK_START_MONTH 컬럼 Default Value 설정; 분기별: Default(1월), 반기별: Default(자동차: 2월, 소형/ESS: 1월)
 * 2023/09/21   ilovu1		    Compile
 */
CREATE procedure [dbo].[DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT]
	  @p_SAVE_FLAG						nvarchar(max) --저장구분(I:Insert, M: Modify)
	, @p_DIVISION_ID					nvarchar(max) --사업부ID
	, @p_PROJECT_CODE					nvarchar(max) --프로젝트코드
	, @p_SCM_SITE_ID					nvarchar(max) --SCM사이트ID
	, @p_ITEM_ID						nvarchar(max) --품목ID

    , @p_BASE_PRICE_PER_EA              nvarchar(max) --기준단가(/EA)
    , @p_METAL_LINK_YN                  nvarchar(max) --메탈링크여부
    , @p_CURRENCY                       nvarchar(max) --통화코드
    , @p_METAL_LINK_PERIOD              nvarchar(max) --메탈링크범위
	, @p_METAL_LINK_START_MONTH			nvarchar(max) --동일값(Metal Index(Cur)) 기간 시작연월
    , @p_METAL_LINK_MTD                 nvarchar(max) --메탈링크방법
    , @p_CELL_NICK                      nvarchar(max) --Cell Nick
    , @p_CELL_QTY                       nvarchar(max) --Cell Qty(/Biz Type)
    , @p_CAP_PCT                        nvarchar(max) --Cap Percentage                          
    , @p_START_YM                       nvarchar(max) --시작연월
    , @p_END_YM                         nvarchar(max) --종료연월

	, @p_AL_USD_PER_KG					nvarchar(max) --메탈인덱스Al(USD/KG)
	, @p_CU_USD_PER_KG					nvarchar(max) --메탈인덱스Cu(USD/KG)
	, @p_MN_USD_PER_KG					nvarchar(max) --메탈인덱스Mn(USD/KG)
	, @p_NI_USD_PER_KG					nvarchar(max) --메탈인덱스Ni(USD/KG)
	, @p_CO_USD_PER_KG					nvarchar(max) --메탈인덱스Co(USD/KG)
	, @p_LI2CO3_USD_PER_KG				nvarchar(max) --메탈인덱스Li2Co3(USD/KG)
	, @p_LIOH_USD_PER_KG				nvarchar(max) --메탈인덱스LiOH(USD/KG)
	, @p_CNTRC_EXCHANGE_PRICE			nvarchar(max) --계약시 환율
	, @p_CREATED_BY						nvarchar(max) --생성자
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;	

	---------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	---------------------------------------------------------------------------------------------------------
    declare @v_program_name		nvarchar(150) = 'DMF0009_SAVE_ESS_BIZ_PLAN_PRICE_INPUT';
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
    select nr as SEQ, token into #BASE_PRICE_PER_EA                from dbo.String_Split(@p_BASE_PRICE_PER_EA              , @v_delimiter);--기준단가(/EA)
    select nr as SEQ, token into #METAL_LINK_YN                    from dbo.String_Split(@p_METAL_LINK_YN                  , @v_delimiter);--메탈링크여부
    select nr as SEQ, token into #CURRENCY                         from dbo.String_Split(@p_CURRENCY                       , @v_delimiter);--통화코드
    select nr as SEQ, token into #METAL_LINK_PERIOD                from dbo.String_Split(@p_METAL_LINK_PERIOD              , @v_delimiter);--메탈링크범위
	select nr as SEQ, token into #METAL_LINK_START_MONTH           from dbo.String_Split(@p_METAL_LINK_START_MONTH         , @v_delimiter);--동일값(Metal Index(Cur)) 기간 시작연월
    select nr as SEQ, token into #METAL_LINK_MTD                   from dbo.String_Split(@p_METAL_LINK_MTD                 , @v_delimiter);--메탈링크방법

	select nr as SEQ, token into #CELL_NICK						   from dbo.String_Split(@p_CELL_NICK                      , @v_delimiter);--메탈링크방법
	select nr as SEQ, token into #CELL_QTY						   from dbo.String_Split(@p_CELL_QTY                       , @v_delimiter);--메탈링크방법
	select nr as SEQ, token into #CAP_PCT						   from dbo.String_Split(@p_CAP_PCT                        , @v_delimiter);--메탈링크방법

	select nr as SEQ, token into #START_YM						   from dbo.String_Split(@p_START_YM                       , @v_delimiter);--시작연월
	select nr as SEQ, token into #END_YM                           from dbo.String_Split(@p_END_YM                         , @v_delimiter);--종료연월
    
    select nr as SEQ, token into #AL_USD_PER_KG                    from dbo.String_Split(@p_AL_USD_PER_KG                  , @v_delimiter);--메탈인덱스Al(USD/KG)
    select nr as SEQ, token into #CU_USD_PER_KG                    from dbo.String_Split(@p_CU_USD_PER_KG                  , @v_delimiter);--메탈인덱스Cu(USD/KG)
    select nr as SEQ, token into #MN_USD_PER_KG                    from dbo.String_Split(@p_MN_USD_PER_KG                  , @v_delimiter);--메탈인덱스Mn(USD/KG)
    select nr as SEQ, token into #NI_USD_PER_KG                    from dbo.String_Split(@p_NI_USD_PER_KG                  , @v_delimiter);--메탈인덱스Ni(USD/KG)
    select nr as SEQ, token into #CO_USD_PER_KG                    from dbo.String_Split(@p_CO_USD_PER_KG                  , @v_delimiter);--메탈인덱스Co(USD/KG)
    select nr as SEQ, token into #LI2CO3_USD_PER_KG                from dbo.String_Split(@p_LI2CO3_USD_PER_KG              , @v_delimiter);--메탈인덱스Li2Co3(USD/KG)
    select nr as SEQ, token into #LIOH_USD_PER_KG                  from dbo.String_Split(@p_LIOH_USD_PER_KG                , @v_delimiter);--메탈인덱스LiOH(USD/KG)
    select nr as SEQ, token into #CNTRC_EXCHANGE_PRICE             from dbo.String_Split(@p_CNTRC_EXCHANGE_PRICE           , @v_delimiter);--계약시 환율
	---------------------------------------------------------------------------------------------------------

	begin try
		---------------------------------------------------------------------------------------------------------
		-- 파라미터 값을 행 데이터로 변환하여 임시테이블에 저장
		---------------------------------------------------------------------------------------------------------
        select SAVE_FLAG.SEQ                            						 --순번
             , case when SAVE_FLAG.token                    <> '' then SAVE_FLAG.token                    else null end as SAVE_FLAG                   --저장구분(I:Insert, M: Modify, D: Delete)
             , case when DIVISION_ID.token                  <> '' then DIVISION_ID.token                  else null end as DIVISION_ID                 --사업부ID
             , case when PROJECT_CODE.token                 <> '' then PROJECT_CODE.token                 else null end as PROJECT_CODE                --프로젝트코드                       
             , case when SCM_SITE_ID.token                  <> '' then SCM_SITE_ID.token                  else null end as SCM_SITE_ID                 --SCM사이트ID                      
             , case when ITEM_ID.token                      <> '' then ITEM_ID.token                      else null end as ITEM_ID                     --품목ID                          
             , case when BASE_PRICE_PER_EA.token            <> '' then BASE_PRICE_PER_EA.token            else null end as BASE_PRICE_PER_EA           --기준단가(/EA)                          
             , case when METAL_LINK_YN.token                <> '' then METAL_LINK_YN.token                else null end as METAL_LINK_YN               --메탈링크여부                       
             , case when CURRENCY.token                     <> '' then CURRENCY.token                     else null end as CURRENCY                    --통화코드                          
             , case when METAL_LINK_PERIOD.token            <> '' then METAL_LINK_PERIOD.token            else null end as METAL_LINK_PERIOD           --메탈링크범위
			 , case when METAL_LINK_START_MONTH.token       <> '' then METAL_LINK_START_MONTH.token       else null end as METAL_LINK_START_MONTH      --동일값(Metal Index(Cur)) 기간 시작연월
             , case when METAL_LINK_MTD.token               <> '' then METAL_LINK_MTD.token               else null end as METAL_LINK_MTD              --메탈링크방법   
			 
			 , case when CELL_NICK.token					<> '' then CELL_NICK.token					  else null end as CELL_NICK				   --Cell Nick
			 , case when CELL_QTY.token						<> '' then CELL_QTY.token	                  else null end as CELL_QTY					   --Cell Qty(/Biz Type)
			 , case when CAP_PCT.token						<> '' then CAP_PCT.token	                  else null end as CAP_PCT					   --Cap Percentage      

			 , case when START_YM.token                     <> '' then START_YM.token                     else null end as START_YM                    --시작연월
			 , case when END_YM.token                       <> '' then END_YM.token                       else null end as END_YM                      --종료연월
                  
             , case when AL_USD_PER_KG.token                <> '' then AL_USD_PER_KG.token                else null end as AL_USD_PER_KG               --메탈인덱스Al(USD/KG)               
             , case when CU_USD_PER_KG.token                <> '' then CU_USD_PER_KG.token                else null end as CU_USD_PER_KG               --메탈인덱스Cu(USD/KG)               
             , case when MN_USD_PER_KG.token                <> '' then MN_USD_PER_KG.token                else null end as MN_USD_PER_KG               --메탈인덱스Mn(USD/KG)               
             , case when NI_USD_PER_KG.token                <> '' then NI_USD_PER_KG.token                else null end as NI_USD_PER_KG               --메탈인덱스Ni(USD/KG)               
             , case when CO_USD_PER_KG.token                <> '' then CO_USD_PER_KG.token                else null end as CO_USD_PER_KG               --메탈인덱스Co(USD/KG)               
             , case when LI2CO3_USD_PER_KG.token            <> '' then LI2CO3_USD_PER_KG.token            else null end as LI2CO3_USD_PER_KG           --메탈인덱스Li2Co3(USD/KG)           
             , case when LIOH_USD_PER_KG.token              <> '' then LIOH_USD_PER_KG.token              else null end as LIOH_USD_PER_KG             --메탈인덱스LiOH(USD/KG)             
             , case when CNTRC_EXCHANGE_PRICE.token         <> '' then CNTRC_EXCHANGE_PRICE.token         else null end as CNTRC_EXCHANGE_PRICE        --계약시 환율
          into #SOURCE
          from              #SAVE_FLAG                      SAVE_FLAG                                                                           --저장구분(I:Insert, M: Modify)
               inner join   #DIVISION_ID                    DIVISION_ID                      on SAVE_FLAG.SEQ = DIVISION_ID.SEQ                 --사업부ID                       
               inner join   #PROJECT_CODE                   PROJECT_CODE                     on SAVE_FLAG.SEQ = PROJECT_CODE.SEQ                --프로젝트코드                       
               inner join   #SCM_SITE_ID                    SCM_SITE_ID                      on SAVE_FLAG.SEQ = SCM_SITE_ID.SEQ                 --SCM사이트ID                       
               inner join   #ITEM_ID                        ITEM_ID                          on SAVE_FLAG.SEQ = ITEM_ID.SEQ                     --품목ID                                              
               inner join   #BASE_PRICE_PER_EA              BASE_PRICE_PER_EA                on SAVE_FLAG.SEQ = BASE_PRICE_PER_EA.SEQ           --기준단가(/EA)                                              
               inner join   #METAL_LINK_YN                  METAL_LINK_YN                    on SAVE_FLAG.SEQ = METAL_LINK_YN.SEQ               --메탈링크여부                       
               inner join   #CURRENCY                       CURRENCY                         on SAVE_FLAG.SEQ = CURRENCY.SEQ                    --통화코드                                             
               inner join   #METAL_LINK_PERIOD              METAL_LINK_PERIOD                on SAVE_FLAG.SEQ = METAL_LINK_PERIOD.SEQ           --메탈링크범위
			   inner join   #METAL_LINK_START_MONTH         METAL_LINK_START_MONTH           on SAVE_FLAG.SEQ = METAL_LINK_START_MONTH.SEQ      --동일값(Metal Index(Cur)) 기간 시작연월
               inner join   #METAL_LINK_MTD                 METAL_LINK_MTD                   on SAVE_FLAG.SEQ = METAL_LINK_MTD.SEQ              --메탈링크방법  
			   
			   inner join   #CELL_NICK                      CELL_NICK                        on SAVE_FLAG.SEQ = CELL_NICK.SEQ                   --Cell Nick 
			   inner join   #CELL_QTY	                    CELL_QTY	                     on SAVE_FLAG.SEQ = CELL_QTY.SEQ                    --Cell Qty(/Biz Type) 
			   inner join   #CAP_PCT	                    CAP_PCT	                         on SAVE_FLAG.SEQ = CAP_PCT.SEQ                     --Cap Percentage      

			   inner join   #START_YM                       START_YM                         on SAVE_FLAG.SEQ = START_YM.SEQ                    --시작연월
			   inner join   #END_YM	                        END_YM	                         on SAVE_FLAG.SEQ = END_YM.SEQ                      --종료연월
                                    
               inner join   #AL_USD_PER_KG                  AL_USD_PER_KG                    on SAVE_FLAG.SEQ = AL_USD_PER_KG.SEQ               --메탈인덱스Al(USD/KG)                       
               inner join   #CU_USD_PER_KG                  CU_USD_PER_KG                    on SAVE_FLAG.SEQ = CU_USD_PER_KG.SEQ               --메탈인덱스Cu(USD/KG)                       
               inner join   #MN_USD_PER_KG                  MN_USD_PER_KG                    on SAVE_FLAG.SEQ = MN_USD_PER_KG.SEQ               --메탈인덱스Mn(USD/KG)                       
               inner join   #NI_USD_PER_KG                  NI_USD_PER_KG                    on SAVE_FLAG.SEQ = NI_USD_PER_KG.SEQ               --메탈인덱스Ni(USD/KG)                       
               inner join   #CO_USD_PER_KG                  CO_USD_PER_KG                    on SAVE_FLAG.SEQ = CO_USD_PER_KG.SEQ               --메탈인덱스Co(USD/KG)                       
               inner join   #LI2CO3_USD_PER_KG              LI2CO3_USD_PER_KG                on SAVE_FLAG.SEQ = LI2CO3_USD_PER_KG.SEQ           --메탈인덱스Li2Co3(USD/KG)                       
               inner join   #LIOH_USD_PER_KG                LIOH_USD_PER_KG                  on SAVE_FLAG.SEQ = LIOH_USD_PER_KG.SEQ             --메탈인덱스LiOH(USD/KG)                       
               inner join   #CNTRC_EXCHANGE_PRICE           CNTRC_EXCHANGE_PRICE             on SAVE_FLAG.SEQ = CNTRC_EXCHANGE_PRICE.SEQ        --계약시 환율  
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

		--not null 제약 확인(BASE_PRICE_PER_EA)
		if exists (select 1 from #BASE_PRICE_PER_EA where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Base Price(/EA) 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Base Price(/EA))을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(METAL_LINK_YN)
		if exists (select 1 from #METAL_LINK_YN where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Metal Link 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Metal Link)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(CURRENCY)
		if exists (select 1 from #CURRENCY where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Currency 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Currency)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(CELL_NICK)
		if exists (select 1 from #CELL_NICK where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')	and METAL_LINK_YN <> 'N') and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Cell Nick 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Cell Nick)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(CELL_QTY)
		if exists (select 1 from #CELL_QTY where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M') and METAL_LINK_YN <> 'N') and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Cell QTY(/Biz Type) 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Cell QTY(/Biz Type))을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(START_YM)
		if exists (select 1 from #START_YM where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Start 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Start)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(END_YM)
		if exists (select 1 from #END_YM where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'End 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(End)을 확인하세요.';
			goto err_rtn;
		end

		--데이터 상호의존성 확인(각각의 광물에 대해 입력된 값 확인)
		if exists (
					select 1
					  from #SOURCE s
					       left  join dbo.DM_MST_ESS_METAL_SENSITIVITY e
						           on s.DIVISION_ID = e.DIVISION_ID
                                  and s.CELL_NICK   = e.CELL_NICK
					 where SAVE_FLAG in ('I', 'M')
					   and (
							   (case 
									when e.AL is     null and (s.AL_USD_PER_KG     <>'') then 1 
									when e.AL is not null and (s.AL_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						    or (case 
									when e.CU is     null and (s.CU_USD_PER_KG     <>'') then 1 
									when e.CU is not null and (s.CU_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						    or (case 
									when e.MN is     null and (s.MN_USD_PER_KG     <>'') then 1 
									when e.MN is not null and (s.MN_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						    or (case 
									when e.NI is     null and (s.NI_USD_PER_KG     <>'') then 1 
									when e.NI is not null and (s.NI_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						    or (case 
									when e.CO is     null and (s.CO_USD_PER_KG     <>'') then 1 
									when e.CO is not null and (s.CO_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						    or (case 
									when e.LI2CO3 is     null and (s.LI2CO3_USD_PER_KG     <>'') then 1 
									when e.LI2CO3 is not null and (s.LI2CO3_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						    or (case 
									when e.LIOH is     null and (s.LIOH_USD_PER_KG     <>'') then 1 
									when e.LIOH is not null and (s.LIOH_USD_PER_KG  is null) then 1 
								end					
							   ) = 1
						  )
                  )
        begin
			set @v_log_type = 'INVALID';
			select N'메탈 민감도와 일치하지 않는 메탈 입력값이 있습니다.';
			set @v_description = N'메탈 민감도와 일치하지 않는 메탈 입력값이 있습니다.';
			goto err_rtn;
		end
		
		--데이터 상호의존성 확인(METAL_LINK_YN --> METAL_LINK_PERIOD)
		if exists (
					select 1 
					  from #SOURCE 
					 where SAVE_FLAG in ('I', 'M') 
					   and (
							(case
								--when isnull(CURRENCY, '') = 'USD' and (isnull(METAL_LINK_MTD, '') <> '' or isnull(CNTRC_EXCHANGE_PRICE, '') <> '') then 1
								--when isnull(CURRENCY, '') = ''    and (isnull(METAL_LINK_MTD, '') <> '' or isnull(CNTRC_EXCHANGE_PRICE, '') <> '') then 1
								when METAL_LINK_YN = 'Y' and isnull(CURRENCY, '') <>'USD' and (isnull(METAL_LINK_MTD, '') =  '' or isnull(CNTRC_EXCHANGE_PRICE, '') =  '') then 1
								when (METAL_LINK_YN = 'N' or isnull(CURRENCY, '') ='USD' ) and (isnull(METAL_LINK_MTD, '') <> '' or isnull(CNTRC_EXCHANGE_PRICE, '') <> '') then 1
					         end
							) = 1
						   )
				  )						
		begin 
			set @v_log_type = 'INVALID';
			select N'Currency 또는 Cur Metal Link 또는 Contract Ex. Rate(Cur/USD) 입력값을 확인하세요.';
			set @v_description = N'Currency 또는 Cur Metal Link 또는 Contract Ex. Rate(Cur/USD) 입력값을 확인하세요.';
			goto err_rtn;
		end

		--데이터 상호의존성 확인(METAL_LINK_YN --> METAL_LINK_PERIOD)
		--if exists (select 1 from #SOURCE where SAVE_FLAG in ('I', 'M') and METAL_LINK_YN = 'N' and isnull(METAL_LINK_PERIOD, '') <> '')
		--begin 
		--	set @v_log_type = 'INVALID';
		--	select N'값(METAL_LINK_PERIOD)을 입력할 수 없습니다.';
		--	set @v_description = N'값(METAL_LINK_PERIOD)을 입력할 수 없습니다.';
		--	goto err_rtn;
		--end

		--데이터 상호의존성 확인(METAL_LINK_YN --> METAL_LINK_MTD)
		--if exists (select 1 from #SOURCE where SAVE_FLAG in ('I', 'M') and METAL_LINK_YN = 'Y' and isnull(METAL_LINK_MTD, '') = '')
		--begin 
		--	set @v_log_type = 'INVALID';
		--	select N'METAL_LINK_MTD 입력값을 확인하세요.';
		--	set @v_description = N'필수 입력값(METAL_LINK_MTD)을 확인하세요.';
		--	goto err_rtn;
		--end

		--데이터 상호의존성 확인(METAL_LINK_YN --> METAL_LINK_MTD)
		--if exists (select 1 from #SOURCE where SAVE_FLAG in ('I', 'M') and METAL_LINK_YN = 'N' and isnull(METAL_LINK_MTD, '') <> '')
		--begin 
		--	set @v_log_type = 'INVALID';
		--	select N'값(METAL_LINK_MTD)을 입력할 수 없습니다.';
		--	set @v_description = N'값(METAL_LINK_MTD)을 입력할 수 없습니다.';
		--	goto err_rtn;
		--end

		---------------------------------------------------------------------------------------------------------
		-- METAL_LINK_START_MONTH 값이 널인 경우 디폴트로 대체
		---------------------------------------------------------------------------------------------------------
		create table #PERIOD
		(
              CODE				nvarchar(100)   not null
			, NAME				nvarchar(100)   not null
			, PERIOD_GUBUN      nvarchar(1)	    not null
			, PERIOD_GUBUN2     nvarchar(1)	    not null
			, DISPLAY_SEQ       int			    not null			
		);

		insert
		  into #PERIOD
		exec dbo.DMF0009_GET_CODE 'DMF_BIZ_PLAN_METAL_LINK_PERIOD';

		 merge
		  into #SOURCE t
		 using #PERIOD s
		    on (t.METAL_LINK_PERIOD = s.CODE)
		  when matched and t.METAL_LINK_START_MONTH is null and t.METAL_LINK_YN = 'Y' then
		       update 
			      set t.METAL_LINK_START_MONTH = case 
													when s.PERIOD_GUBUN = 'Q' then 'JAN'	--분기별: Default(1월)
													when s.PERIOD_GUBUN = 'H' then 'JAN'	--반기별: Default(자동차: 2월, 소형/ESS: 1월)
												 end;

		--METAL_LINK_START_MONTH 널 체크
		if exists (select 1 from #SOURCE where SAVE_FLAG in ('I', 'M') and METAL_LINK_YN = 'Y' and isnull(METAL_LINK_START_MONTH, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'값(Metal Link Start Month)을 확정할 수 없습니다. Metal Link Period의 값을 확인하세요.';
			set @v_description = N'값(Metal Link Start Month)을 확정할 수 없습니다. Metal Link Period의 값을 확인하세요.';
			goto err_rtn;
		end
		---------------------------------------------------------------------------------------------------------

		begin tran;
		merge 
		 into dbo.DM_MST_ESS_METAL_PRICE_RULE t
		using #SOURCE s
		   on (	   t.DIVISION_ID	= s.DIVISION_ID
		       and t.PROJECT_CODE   = s.PROJECT_CODE
			   and t.SCM_SITE_ID	= s.SCM_SITE_ID
			   and t.ITEM_ID		= s.ITEM_ID
		      )
		 when matched and s.SAVE_FLAG = 'D' then
			  delete
         when matched and s.SAVE_FLAG in ('I', 'M') then
		      update
			      set 
				  	t.BASE_PRICE_PER_EA              = s.BASE_PRICE_PER_EA            --기준단가(/EA)
				    , t.METAL_LINK_YN                = s.METAL_LINK_YN                --메탈링크여부
				    , t.CURRENCY                     = s.CURRENCY                     --통화코드
				    , t.METAL_LINK_PERIOD            = s.METAL_LINK_PERIOD            --메탈링크범위
					, t.METAL_LINK_START_MONTH		 = s.METAL_LINK_START_MONTH		  --동일값(Metal Index(Cur)) 기간 시작연월
				    , t.METAL_LINK_MTD               = s.METAL_LINK_MTD               --메탈링크방법
				    , t.CELL_NICK                    = s.CELL_NICK                    --Cell Nick
				    , t.CELL_QTY                     = s.CELL_QTY                     --Cell Qty(/Biz Type)
				    , t.CAP_PCT                      = s.CAP_PCT                      --Cap Percentage                          
				    , t.START_YM                     = s.START_YM                     --시작연월
				    , t.END_YM                       = s.END_YM                       --종료연월

                    , t.AL_USD_PER_KG                = s.AL_USD_PER_KG                --메탈인덱스Al(USD/KG)        
                    , t.CU_USD_PER_KG                = s.CU_USD_PER_KG                --메탈인덱스Cu(USD/KG)        
                    , t.MN_USD_PER_KG                = s.MN_USD_PER_KG                --메탈인덱스Mn(USD/KG)        
                    , t.NI_USD_PER_KG                = s.NI_USD_PER_KG                --메탈인덱스Ni(USD/KG)        
                    , t.CO_USD_PER_KG                = s.CO_USD_PER_KG                --메탈인덱스Co(USD/KG)        
                    , t.LI2CO3_USD_PER_KG            = s.LI2CO3_USD_PER_KG            --메탈인덱스Li2Co3(USD/KG)    
                    , t.LIOH_USD_PER_KG              = s.LIOH_USD_PER_KG              --메탈인덱스LiOH(USD/KG)      
                    , t.CNTRC_EXCHANGE_PRICE         = s.CNTRC_EXCHANGE_PRICE         --계약시 환율                 
					, t.LAST_UPDATED_BY				 = @p_CREATED_BY				  --최종수정자
					, t.LAST_UPDATE_DATE			 = getdate()					  --최종수정일자
         when not matched by target and s.SAVE_FLAG in ('I', 'M') then
			  insert ( DIVISION_ID						--사업부ID                    
                     , PROJECT_CODE                		--프로젝트코드                
                     , SCM_SITE_ID                 		--SCM사이트ID                 
                     , ITEM_ID                     		--품목ID                      
                     
					 , BASE_PRICE_PER_EA                --기준단가(/EA)
					 , METAL_LINK_YN                    --메탈링크여부
					 , CURRENCY                         --통화코드
					 , METAL_LINK_PERIOD                --메탈링크범위
					 , METAL_LINK_START_MONTH			--동일값(Metal Index(Cur)) 기간 시작연월
					 , METAL_LINK_MTD                   --메탈링크방법
					 , CELL_NICK                        --Cell Nick
					 , CELL_QTY                         --Cell Qty(/Biz Type)
					 , CAP_PCT                          --Cap Percentage      
					 , START_YM                         --시작연월
					 , END_YM                           --종료연월
					 
                     , AL_USD_PER_KG               		--메탈인덱스Al(USD/KG)        
                     , CU_USD_PER_KG               		--메탈인덱스Cu(USD/KG)        
                     , MN_USD_PER_KG               		--메탈인덱스Mn(USD/KG)        
                     , NI_USD_PER_KG               		--메탈인덱스Ni(USD/KG)        
                     , CO_USD_PER_KG               		--메탈인덱스Co(USD/KG)        
                     , LI2CO3_USD_PER_KG           		--메탈인덱스Li2Co3(USD/KG)    
                     , LIOH_USD_PER_KG             		--메탈인덱스LiOH(USD/KG)      
                     , CNTRC_EXCHANGE_PRICE        		--계약시 환율
					               
					 , CREATED_BY						--생성자 
					 , CREATION_DATE					--생성일자
					 , LAST_UPDATED_BY					--최종수정자
					 , LAST_UPDATE_DATE					--최종수정일자
			         )
              values ( s.DIVISION_ID					--사업부ID                    
                     , s.PROJECT_CODE                	--프로젝트코드                
                     , s.SCM_SITE_ID                 	--SCM사이트ID                 
                     , s.ITEM_ID                     	--품목ID  
					 
                     , s.BASE_PRICE_PER_EA              --기준단가(/EA)
					 , s.METAL_LINK_YN                  --메탈링크여부
					 , s.CURRENCY                       --통화코드
					 , s.METAL_LINK_PERIOD              --메탈링크범위
					 , s.METAL_LINK_START_MONTH			--동일값(Metal Index(Cur)) 기간 시작연월
					 , s.METAL_LINK_MTD                 --메탈링크방법
					 , s.CELL_NICK                      --Cell Nick
					 , s.CELL_QTY                       --Cell Qty(/Biz Type)
					 , s.CAP_PCT                        --Cap Percentage      
					 , s.START_YM                       --시작연월
					 , s.END_YM                         --종료연월
                       
                     , s.AL_USD_PER_KG               	--메탈인덱스Al(USD/KG)        
                     , s.CU_USD_PER_KG               	--메탈인덱스Cu(USD/KG)        
                     , s.MN_USD_PER_KG               	--메탈인덱스Mn(USD/KG)        
                     , s.NI_USD_PER_KG               	--메탈인덱스Ni(USD/KG)        
                     , s.CO_USD_PER_KG               	--메탈인덱스Co(USD/KG)        
                     , s.LI2CO3_USD_PER_KG           	--메탈인덱스Li2Co3(USD/KG)    
                     , s.LIOH_USD_PER_KG             	--메탈인덱스LiOH(USD/KG)      
                     , s.CNTRC_EXCHANGE_PRICE        	--계약시 환율
					 
					 , @p_CREATED_BY					--생성자 
					 , getdate()						--생성일자
					 , @p_CREATED_BY					--최종수정자
					 , getdate()						--최종수정일자			  
			         );
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
	set @v_log_message	= '########## END of procedure ##########';
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
